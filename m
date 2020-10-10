Return-Path: <SRS0=yR1C=DR=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BAF78C433E7
	for <linux-scsi@archiver.kernel.org>; Sat, 10 Oct 2020 03:42:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7506C21D46
	for <linux-scsi@archiver.kernel.org>; Sat, 10 Oct 2020 03:42:52 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="hdtlDfbW"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730972AbgJJDlk (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 9 Oct 2020 23:41:40 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:41950 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730764AbgJJDeG (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 9 Oct 2020 23:34:06 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1602300844;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=mquaAJYhQGvRjI4YiIIywOVHyGl4nbZ/nLSs0H46bfg=;
        b=hdtlDfbWcGSI8pDikb41+gMZ/OrFkKwHzXAHcl7pOA7OnRDdh4a/OdwgT5IdtdzfiaBHdl
        elp+2Wy6W6sCwsxDthdfyiscNCqeFQznVhq9btde7HsTj6ZgG7Arxq2xgfYZwyk3jCNx0W
        m0Erdx5NZ7vogifBDNV0QgT7orDjz+M=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-250-TKRnvnTUM8OqtC_oWDY0Gw-1; Fri, 09 Oct 2020 23:25:52 -0400
X-MC-Unique: TKRnvnTUM8OqtC_oWDY0Gw-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 362A2108E1A0;
        Sat, 10 Oct 2020 03:25:51 +0000 (UTC)
Received: from localhost (ovpn-13-88.pek2.redhat.com [10.72.13.88])
        by smtp.corp.redhat.com (Postfix) with ESMTP id B543760DA0;
        Sat, 10 Oct 2020 03:25:47 +0000 (UTC)
From:   Ming Lei <ming.lei@redhat.com>
To:     linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Ming Lei <ming.lei@redhat.com>, Christoph Hellwig <hch@lst.de>,
        "Ewan D . Milne" <emilne@redhat.com>,
        Hannes Reinecke <hare@suse.de>,
        Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH] scsi: core: don't start concurrent async scan on same host
Date:   Sat, 10 Oct 2020 11:25:39 +0800
Message-Id: <20201010032539.426615-1-ming.lei@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Current scsi host scan mechanism supposes to fallback into sync host
scan if async scan is in-progress. However, this rule isn't strictly
respected, because scsi_prep_async_scan() doesn't hold scan_mutex when
checking shost->async_scan. When scsi_scan_host() is called
concurrently, two async scan on same host may be started, and hang in
do_scan_async() is observed.

Fixes this issue by checking & setting shost->async_scan atomically
with shost->scan_mutex.

Cc: Christoph Hellwig <hch@lst.de>
Cc: Ewan D. Milne <emilne@redhat.com>
Cc: Hannes Reinecke <hare@suse.de>
Cc: Bart Van Assche <bvanassche@acm.org>
Signed-off-by: Ming Lei <ming.lei@redhat.com>
---
 drivers/scsi/scsi_scan.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
index f2437a7570ce..9af50e6f94c4 100644
--- a/drivers/scsi/scsi_scan.c
+++ b/drivers/scsi/scsi_scan.c
@@ -1714,15 +1714,16 @@ static void scsi_sysfs_add_devices(struct Scsi_Host *shost)
  */
 static struct async_scan_data *scsi_prep_async_scan(struct Scsi_Host *shost)
 {
-	struct async_scan_data *data;
+	struct async_scan_data *data = NULL;
 	unsigned long flags;
 
 	if (strncmp(scsi_scan_type, "sync", 4) == 0)
 		return NULL;
 
+	mutex_lock(&shost->scan_mutex);
 	if (shost->async_scan) {
 		shost_printk(KERN_DEBUG, shost, "%s called twice\n", __func__);
-		return NULL;
+		goto err;
 	}
 
 	data = kmalloc(sizeof(*data), GFP_KERNEL);
@@ -1733,7 +1734,6 @@ static struct async_scan_data *scsi_prep_async_scan(struct Scsi_Host *shost)
 		goto err;
 	init_completion(&data->prev_finished);
 
-	mutex_lock(&shost->scan_mutex);
 	spin_lock_irqsave(shost->host_lock, flags);
 	shost->async_scan = 1;
 	spin_unlock_irqrestore(shost->host_lock, flags);
@@ -1748,6 +1748,7 @@ static struct async_scan_data *scsi_prep_async_scan(struct Scsi_Host *shost)
 	return data;
 
  err:
+	mutex_unlock(&shost->scan_mutex);
 	kfree(data);
 	return NULL;
 }
-- 
2.25.2

