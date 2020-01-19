Return-Path: <SRS0=1Um0=3I=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CF756C33CB1
	for <linux-scsi@archiver.kernel.org>; Sun, 19 Jan 2020 07:15:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9B9002081E
	for <linux-scsi@archiver.kernel.org>; Sun, 19 Jan 2020 07:15:25 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="LTP0pVAK"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726761AbgASHPZ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 19 Jan 2020 02:15:25 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:30946 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726421AbgASHPZ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 19 Jan 2020 02:15:25 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1579418123;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=DlR31H0UiDgmum6L83kqDXST3JGsU/beKwaxBIY8doc=;
        b=LTP0pVAK3/Ad/MvSfnegHl1HbdT9hfRo7UyF7I+X3BzB7dn81A731iEO9HozpUWAypNyEx
        BRKEAjCEIq1RE624TNv+Yk58r61G+b6VWAIjPc744fdxZJ5uFsnx0D7b2Wb3xLO8lQ3F7y
        0rMQKJ+aZyt2DmhhuHDFvNRJEcH3yDI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-42-bDrRvOxUOdC462uwmRLR4A-1; Sun, 19 Jan 2020 02:15:20 -0500
X-MC-Unique: bDrRvOxUOdC462uwmRLR4A-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 438C0800EBF;
        Sun, 19 Jan 2020 07:15:18 +0000 (UTC)
Received: from localhost (ovpn-8-23.pek2.redhat.com [10.72.8.23])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 0823886C48;
        Sun, 19 Jan 2020 07:15:14 +0000 (UTC)
From:   Ming Lei <ming.lei@redhat.com>
To:     James Bottomley <James.Bottomley@HansenPartnership.com>,
        linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-block@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        Ming Lei <ming.lei@redhat.com>,
        Sathya Prakash <sathya.prakash@broadcom.com>,
        Chaitra P B <chaitra.basappa@broadcom.com>,
        Suganath Prabu Subramani 
        <suganath-prabu.subramani@broadcom.com>,
        Kashyap Desai <kashyap.desai@broadcom.com>,
        Sumit Saxena <sumit.saxena@broadcom.com>,
        Shivasharan S <shivasharan.srikanteshwara@broadcom.com>,
        "Ewan D . Milne" <emilne@redhat.com>,
        Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>,
        Bart Van Assche <bart.vanassche@wdc.com>
Subject: [PATCH 5/6] scsi: core: don't limit per-LUN queue depth for SSD when HBA needs
Date:   Sun, 19 Jan 2020 15:14:31 +0800
Message-Id: <20200119071432.18558-6-ming.lei@redhat.com>
In-Reply-To: <20200119071432.18558-1-ming.lei@redhat.com>
References: <20200119071432.18558-1-ming.lei@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Content-Transfer-Encoding: quoted-printable
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

SCSI core uses the atomic variable of sdev->device_busy to track
in-flight IO requests dispatched to this scsi device. IO request may be
submitted from any CPU, so the cost for maintaining the shared atomic
counter can be very big on big NUMA machine with lots of CPU cores.

sdev->queue_depth is usually used for two purposes: 1) improve IO merge;
2) fair IO request scattered among all LUNs.

blk-mq already provides fair request allocation among all active shared
request queues(LUNs), see hctx_may_queue().

NVMe doesn't have such per-request-queue(namespace) queue depth, so it
is reasonable to ignore the limit for SCSI SSD too. Also IO merge won't
play big role for reaching top SSD performance.

With this patch, big cost for tracking in-flight per-LUN requests via
atomic variable can be saved for some high end controller with SSD.

Cc: Sathya Prakash <sathya.prakash@broadcom.com>
Cc: Chaitra P B <chaitra.basappa@broadcom.com>
Cc: Suganath Prabu Subramani <suganath-prabu.subramani@broadcom.com>
Cc: Kashyap Desai <kashyap.desai@broadcom.com>
Cc: Sumit Saxena <sumit.saxena@broadcom.com>
Cc: Shivasharan S <shivasharan.srikanteshwara@broadcom.com>
Cc: Ewan D. Milne <emilne@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>,
Cc: Hannes Reinecke <hare@suse.de>
Cc: Bart Van Assche <bart.vanassche@wdc.com>
Signed-off-by: Ming Lei <ming.lei@redhat.com>
---
 drivers/scsi/scsi_lib.c  | 34 ++++++++++++++++++++++++++++------
 include/scsi/scsi_host.h |  3 +++
 2 files changed, 31 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 610ee41fa54c..0903697dd843 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -344,6 +344,16 @@ static void scsi_dec_host_busy(struct Scsi_Host *sho=
st, struct scsi_cmnd *cmd)
 	rcu_read_unlock();
 }
=20
+static inline bool scsi_bypass_device_busy(struct scsi_device *sdev)
+{
+	struct Scsi_Host *shost =3D sdev->host;
+
+	if (!shost->hostt->no_device_queue_for_ssd)
+		return false;
+
+	return blk_queue_nonrot(sdev->request_queue);
+}
+
 void scsi_device_unbusy(struct scsi_device *sdev, struct scsi_cmnd *cmd)
 {
 	struct Scsi_Host *shost =3D sdev->host;
@@ -354,7 +364,8 @@ void scsi_device_unbusy(struct scsi_device *sdev, str=
uct scsi_cmnd *cmd)
 	if (starget->can_queue > 0)
 		atomic_dec(&starget->target_busy);
=20
-	atomic_dec(&sdev->device_busy);
+	if (!scsi_bypass_device_busy(sdev))
+		atomic_dec(&sdev->device_busy);
 }
=20
 static void scsi_kick_queue(struct request_queue *q)
@@ -410,7 +421,8 @@ static void scsi_single_lun_run(struct scsi_device *c=
urrent_sdev)
=20
 static inline bool scsi_device_is_busy(struct scsi_device *sdev)
 {
-	if (atomic_read(&sdev->device_busy) >=3D sdev->queue_depth)
+	if (!scsi_bypass_device_busy(sdev) &&
+			atomic_read(&sdev->device_busy) >=3D sdev->queue_depth)
 		return true;
 	if (atomic_read(&sdev->device_blocked) > 0)
 		return true;
@@ -1283,8 +1295,12 @@ static inline int scsi_dev_queue_ready(struct requ=
est_queue *q,
 				  struct scsi_device *sdev)
 {
 	unsigned int busy;
+	bool bypass =3D scsi_bypass_device_busy(sdev);
=20
-	busy =3D atomic_inc_return(&sdev->device_busy) - 1;
+	if (!bypass)
+		busy =3D atomic_inc_return(&sdev->device_busy) - 1;
+	else
+		busy =3D 0;
 	if (atomic_read(&sdev->device_blocked)) {
 		if (busy)
 			goto out_dec;
@@ -1298,12 +1314,16 @@ static inline int scsi_dev_queue_ready(struct req=
uest_queue *q,
 				   "unblocking device at zero depth\n"));
 	}
=20
+	if (bypass)
+		return 1;
+
 	if (busy >=3D sdev->queue_depth)
 		goto out_dec;
=20
 	return 1;
 out_dec:
-	atomic_dec(&sdev->device_busy);
+	if (!bypass)
+		atomic_dec(&sdev->device_busy);
 	return 0;
 }
=20
@@ -1624,7 +1644,8 @@ static void scsi_mq_put_budget(struct blk_mq_hw_ctx=
 *hctx)
 	struct request_queue *q =3D hctx->queue;
 	struct scsi_device *sdev =3D q->queuedata;
=20
-	atomic_dec(&sdev->device_busy);
+	if (!scsi_bypass_device_busy(sdev))
+		atomic_dec(&sdev->device_busy);
 }
=20
 static bool scsi_mq_get_budget(struct blk_mq_hw_ctx *hctx)
@@ -1706,7 +1727,8 @@ static blk_status_t scsi_queue_rq(struct blk_mq_hw_=
ctx *hctx,
 	case BLK_STS_OK:
 		break;
 	case BLK_STS_RESOURCE:
-		if (atomic_read(&sdev->device_busy) ||
+		if ((!scsi_bypass_device_busy(sdev) &&
+		     atomic_read(&sdev->device_busy)) ||
 		    scsi_device_blocked(sdev))
 			ret =3D BLK_STS_DEV_RESOURCE;
 		break;
diff --git a/include/scsi/scsi_host.h b/include/scsi/scsi_host.h
index 7a97fb8104cf..8e80edfd5a6d 100644
--- a/include/scsi/scsi_host.h
+++ b/include/scsi/scsi_host.h
@@ -426,6 +426,9 @@ struct scsi_host_template {
 	/* True if the controller does not support WRITE SAME */
 	unsigned no_write_same:1;
=20
+	/* True if the controller needn't to maintain device queue for SSD */
+	unsigned no_device_queue_for_ssd:1;
+
 	/*
 	 * Countdown for host blocking with no commands outstanding.
 	 */
--=20
2.20.1

