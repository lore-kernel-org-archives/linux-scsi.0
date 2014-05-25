From: Akinobu Mita <akinobu.mita@gmail.com>
Subject: [PATCH 4/4] scsi_debug: allow huge transfer length for read/write commands
Date: Sun, 25 May 2014 21:43:36 +0900
Message-ID: <1401021816-10423-5-git-send-email-akinobu.mita@gmail.com>
References: <1401021816-10423-1-git-send-email-akinobu.mita@gmail.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pa0-f43.google.com ([209.85.220.43]:35967 "EHLO
	mail-pa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751455AbaEYMoJ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 25 May 2014 08:44:09 -0400
Received: by mail-pa0-f43.google.com with SMTP id hz1so6283993pad.30
        for <linux-scsi@vger.kernel.org>; Sun, 25 May 2014 05:44:09 -0700 (PDT)
In-Reply-To: <1401021816-10423-1-git-send-email-akinobu.mita@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Akinobu Mita <akinobu.mita@gmail.com>, Jens Axboe <axboe@kernel.dk>, "James E.J. Bottomley" <JBottomley@parallels.com>, Douglas Gilbert <dgilbert@interlog.com>

This change enables to test read/write commands with huge transfer
length such as 1GB.  For example:

	# modprobe scsi_debug dev_size_mb=1024 clustering=1 opts=1
	# cat /sys/block/$DEV/queue/max_hw_sectors_kb > \
		/sys/block/$DEV/queue/max_sectors_kb
	# fio --name=test --rw=write --bs=1g --size=1g --filename=/dev/$DEV \
		--mem=mmaphuge  --direct=1

The data type of max_sectors in scsi_host_template has been extended
to unsigned int by the previous change.  So we can increase it from
0xffff to 0xffffffff to allow such huge transfer length.

Also, this increases sg_tablesize and max_segment_size, otherwise the
maximum transfer length is limited to 64MB.
(sg_tablesize * max_segment_size = 256 * 256KB)

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: "James E.J. Bottomley" <JBottomley@parallels.com>
Cc: Douglas Gilbert <dgilbert@interlog.com>
Cc: linux-scsi@vger.kernel.org
---
 drivers/scsi/scsi_debug.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
index f3e9cc0..35ce1fa 100644
--- a/drivers/scsi/scsi_debug.c
+++ b/drivers/scsi/scsi_debug.c
@@ -2483,7 +2483,7 @@ static int scsi_debug_slave_configure(struct scsi_device *sdp)
 	if (sdp->host->cmd_per_lun)
 		scsi_adjust_queue_depth(sdp, SDEBUG_TAGGED_QUEUING,
 					sdp->host->cmd_per_lun);
-	blk_queue_max_segment_size(sdp->request_queue, 256 * 1024);
+	blk_queue_max_segment_size(sdp->request_queue, -1U);
 	if (scsi_debug_no_uld)
 		sdp->no_uld_attach = 1;
 	return 0;
@@ -3938,9 +3938,9 @@ static struct scsi_host_template sdebug_driver_template = {
 	.bios_param =		scsi_debug_biosparam,
 	.can_queue =		SCSI_DEBUG_CANQUEUE,
 	.this_id =		7,
-	.sg_tablesize =		256,
+	.sg_tablesize =		SCSI_MAX_SG_CHAIN_SEGMENTS,
 	.cmd_per_lun =		16,
-	.max_sectors =		0xffff,
+	.max_sectors =		-1U,
 	.use_clustering = 	DISABLE_CLUSTERING,
 	.module =		THIS_MODULE,
 };
-- 
1.9.1

