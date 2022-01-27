Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6A97DC433EF
	for <linux-scsi@archiver.kernel.org>; Thu, 27 Jan 2022 15:38:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239770AbiA0PiY (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 27 Jan 2022 10:38:24 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:24934 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236698AbiA0PiX (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 27 Jan 2022 10:38:23 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1643297902;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=fhlPBjAhjuVfHSxUMpdZzKcPbotcrpiIRvsIraa5OBI=;
        b=cwq5Iz0vJHhdYfrOm/KQFb1GoOgwipMKvzRkpNS40n6z52ZzpbxquvSZQfODFCEmrNaokr
        HwO5mlL+EbcO+H6Pj5+OfRnXQWmG5C67d3gvAc5GCPXjM77Ih3wVZRWZWco3V0z45yVqYV
        D/V70qgu7TjICCOnqrtUAFkPB4SS+oQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-668-vbN8RlLqOyagcXAzztRpXw-1; Thu, 27 Jan 2022 10:38:19 -0500
X-MC-Unique: vbN8RlLqOyagcXAzztRpXw-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 72F5B84DA41;
        Thu, 27 Jan 2022 15:38:18 +0000 (UTC)
Received: from localhost (ovpn-8-22.pek2.redhat.com [10.72.8.22])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 1C6FA1F473;
        Thu, 27 Jan 2022 15:37:39 +0000 (UTC)
From:   Ming Lei <ming.lei@redhat.com>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org
Cc:     Ming Lei <ming.lei@redhat.com>,
        Bart Van Assche <bvanassche@acm.org>,
        Martin Wilck <martin.wilck@suse.com>,
        Martin Wilck <mwilck@suse.com>
Subject: [PATCH V2] scsi: core: reallocate scsi device's budget map if default queue depth is changed
Date:   Thu, 27 Jan 2022 23:37:33 +0800
Message-Id: <20220127153733.409132-1-ming.lei@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Martin reported that sdev->queue_depth can often be changed in
->slave_configure(), and now we uses ->cmd_per_lun as initial queue
depth for setting up sdev->budget_map. And some extreme ->cmd_per_lun
or ->can_queue won't be used at default actually, if they are used to
allocate sdev->budget_map, huge memory may be consumed just because
of bad ->cmd_per_lun.

Fix the issue by reallocating sdev->budget_map after ->slave_configure()
returns, at that time, queue_depth should be much more reasonable.

Cc: Bart Van Assche <bvanassche@acm.org>
Reported-by: Martin Wilck <martin.wilck@suse.com>
Suggested-by: Martin Wilck <martin.wilck@suse.com>
Tested-by: Martin Wilck <mwilck@suse.com>
Reviewed-by: Martin Wilck <mwilck@suse.com>
Signed-off-by: Ming Lei <ming.lei@redhat.com>
---
V2:
	- rename one local variable, and fix a comment grammar issue, as
	reported by Bart

 drivers/scsi/scsi_scan.c | 56 ++++++++++++++++++++++++++++++++++++----
 1 file changed, 51 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
index 3520b9384428..4c7fb5a5ea4a 100644
--- a/drivers/scsi/scsi_scan.c
+++ b/drivers/scsi/scsi_scan.c
@@ -214,6 +214,48 @@ static void scsi_unlock_floptical(struct scsi_device *sdev,
 			 SCSI_TIMEOUT, 3, NULL);
 }
 
+static int scsi_realloc_sdev_budget_map(struct scsi_device *sdev,
+					unsigned int depth)
+{
+	int new_shift = sbitmap_calculate_shift(depth);
+	bool need_alloc = !sdev->budget_map.map;
+	bool need_free = false;
+	int ret;
+	struct sbitmap sb_backup;
+
+	/*
+	 * realloc if new shift is calculated, which is caused by setting
+	 * up one new default queue depth after calling ->slave_configure
+	 */
+	if (!need_alloc && new_shift != sdev->budget_map.shift)
+		need_alloc = need_free = true;
+
+	if (!need_alloc)
+		return 0;
+
+	/*
+	 * Request queue has to be frozen for reallocating budget map,
+	 * and here disk isn't added yet, so freezing is pretty fast
+	 */
+	if (need_free) {
+		blk_mq_freeze_queue(sdev->request_queue);
+		sb_backup = sdev->budget_map;
+	}
+	ret = sbitmap_init_node(&sdev->budget_map,
+				scsi_device_max_queue_depth(sdev),
+				new_shift, GFP_KERNEL,
+				sdev->request_queue->node, false, true);
+	if (need_free) {
+		if (ret)
+			sdev->budget_map = sb_backup;
+		else
+			sbitmap_free(&sb_backup);
+		ret = 0;
+		blk_mq_unfreeze_queue(sdev->request_queue);
+	}
+	return ret;
+}
+
 /**
  * scsi_alloc_sdev - allocate and setup a scsi_Device
  * @starget: which target to allocate a &scsi_device for
@@ -306,11 +348,7 @@ static struct scsi_device *scsi_alloc_sdev(struct scsi_target *starget,
 	 * default device queue depth to figure out sbitmap shift
 	 * since we use this queue depth most of times.
 	 */
-	if (sbitmap_init_node(&sdev->budget_map,
-				scsi_device_max_queue_depth(sdev),
-				sbitmap_calculate_shift(depth),
-				GFP_KERNEL, sdev->request_queue->node,
-				false, true)) {
+	if (scsi_realloc_sdev_budget_map(sdev, depth)) {
 		put_device(&starget->dev);
 		kfree(sdev);
 		goto out;
@@ -1017,6 +1055,14 @@ static int scsi_add_lun(struct scsi_device *sdev, unsigned char *inq_result,
 			}
 			return SCSI_SCAN_NO_RESPONSE;
 		}
+
+		/*
+		 * queue_depth is often changed in ->slave_configure, so
+		 * setup budget map again for getting better memory uses
+		 * since memory consumption of the map depends on queue
+		 * depth heavily
+		 */
+		scsi_realloc_sdev_budget_map(sdev, sdev->queue_depth);
 	}
 
 	if (sdev->scsi_level >= SCSI_3)
-- 
2.31.1

