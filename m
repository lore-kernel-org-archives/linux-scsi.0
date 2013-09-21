From: Akinobu Mita <mita@fixstars.com>
Subject: [PATCH] ufs: adjust queue settings to PRDT limitations
Date: Sat, 21 Sep 2013 15:36:59 +0900
Message-ID: <1379745419-7099-1-git-send-email-mita@fixstars.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mo.fixstars.hdemail.jp ([176.34.54.138]:36802 "EHLO
	mo.fixstars.hdemail.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752071Ab3IUGmE (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 21 Sep 2013 02:42:04 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Akinobu Mita <mita@fixstars.com>, Vinayak Holikatti <vinholikatti@gmail.com>, Santosh Y <santoshsy@gmail.com>, "James E.J. Bottomley" <JBottomley@parallels.com>

The data byte count field of PRDT indicates the length of data block
which is a segment of data transfer for SCSI commands.  The value of
this field shall have Dword granularity and the the maximum of length
is 256KB.

This adjusts dma pad mask and max segment size to the above-mentioned
PRDT limitations.

Signed-off-by: Akinobu Mita <mita@fixstars.com>
Cc: Vinayak Holikatti <vinholikatti@gmail.com>
Cc: Santosh Y <santoshsy@gmail.com>
Cc: "James E.J. Bottomley" <JBottomley@parallels.com>
Cc: linux-scsi@vger.kernel.org
---
 drivers/scsi/ufs/ufshcd.c | 15 +++++++++++++++
 drivers/scsi/ufs/ufshci.h |  3 +++
 2 files changed, 18 insertions(+)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 7ef9c17..c60537f 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -1919,6 +1919,20 @@ static int ufshcd_slave_alloc(struct scsi_device *sdev)
 }
 
 /**
+ * ufshcd_slave_configure - adjust SCSI device configurations
+ * @sdev: pointer to SCSI device
+ */
+static int ufshcd_slave_configure(struct scsi_device *sdev)
+{
+	struct request_queue *q = sdev->request_queue;
+
+	blk_queue_update_dma_pad(q, PRDT_DATA_BYTE_COUNT_PAD - 1);
+	blk_queue_max_segment_size(q, PRDT_DATA_BYTE_COUNT_MAX);
+
+	return 0;
+}
+
+/**
  * ufshcd_slave_destroy - remove SCSI device configurations
  * @sdev: pointer to SCSI device
  */
@@ -2749,6 +2763,7 @@ static struct scsi_host_template ufshcd_driver_template = {
 	.proc_name		= UFSHCD,
 	.queuecommand		= ufshcd_queuecommand,
 	.slave_alloc		= ufshcd_slave_alloc,
+	.slave_configure	= ufshcd_slave_configure,
 	.slave_destroy		= ufshcd_slave_destroy,
 	.eh_abort_handler	= ufshcd_abort,
 	.eh_device_reset_handler = ufshcd_device_reset,
diff --git a/drivers/scsi/ufs/ufshci.h b/drivers/scsi/ufs/ufshci.h
index 0475c66..c8de354 100644
--- a/drivers/scsi/ufs/ufshci.h
+++ b/drivers/scsi/ufs/ufshci.h
@@ -296,6 +296,9 @@ enum {
 	MASK_OCS			= 0x0F,
 };
 
+#define PRDT_DATA_BYTE_COUNT_MAX	(256 * 1024)
+#define PRDT_DATA_BYTE_COUNT_PAD	4
+
 /**
  * struct ufshcd_sg_entry - UFSHCI PRD Entry
  * @base_addr: Lower 32bit physical address DW-0
-- 
1.8.3.1

