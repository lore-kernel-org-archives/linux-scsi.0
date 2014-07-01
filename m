From: Akinobu Mita <akinobu.mita@gmail.com>
Subject: [PATCH v3] ufs: adjust queue settings to PRDT limitations
Date: Tue,  1 Jul 2014 23:00:32 +0900
Message-ID: <1404223232-4097-1-git-send-email-akinobu.mita@gmail.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pd0-f181.google.com ([209.85.192.181]:62873 "EHLO
	mail-pd0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755301AbaGAOBm (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 1 Jul 2014 10:01:42 -0400
Received: by mail-pd0-f181.google.com with SMTP id v10so10053241pde.26
        for <linux-scsi@vger.kernel.org>; Tue, 01 Jul 2014 07:01:42 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Akinobu Mita <akinobu.mita@gmail.com>, Akinobu Mita <mita@fixstars.com>, Subhash Jadavani <subhashj@codeaurora.org>, Dolev Raviv <draviv@codeaurora.org>, Vinayak Holikatti <vinholikatti@gmail.com>, Santosh Y <santoshsy@gmail.com>, "James E.J. Bottomley" <JBottomley@parallels.com>

The data byte count field of PRDT indicates the length of data block
which is a segment of data transfer for SCSI commands.  The value of
this field shall have Dword granularity and the the maximum of length
is 256KB.

This adjusts dma pad mask and max segment size to the above-mentioned
PRDT limitations.

Signed-off-by: Akinobu Mita <mita@fixstars.com>
Reviewed-by: Subhash Jadavani <subhashj@codeaurora.org>
Tested-by: Dolev Raviv <draviv@codeaurora.org>
Acked-by: Vinayak Holikatti <vinholikatti@gmail.com>
Cc: Subhash Jadavani <subhashj@codeaurora.org>
Cc: Dolev Raviv <draviv@codeaurora.org>
Cc: Vinayak Holikatti <vinholikatti@gmail.com>
Cc: Santosh Y <santoshsy@gmail.com>
Cc: "James E.J. Bottomley" <JBottomley@parallels.com>
Cc: linux-scsi@vger.kernel.org
---
* Change from v2
- Add Tested-by and Acked-by lines

 drivers/scsi/ufs/ufshcd.c | 15 +++++++++++++++
 drivers/scsi/ufs/ufshci.h |  5 +++++
 2 files changed, 20 insertions(+)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 6fd427b..c0da473 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -1900,6 +1900,20 @@ static int ufshcd_slave_alloc(struct scsi_device *sdev)
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
@@ -3011,6 +3025,7 @@ static struct scsi_host_template ufshcd_driver_template = {
 	.proc_name		= UFSHCD,
 	.queuecommand		= ufshcd_queuecommand,
 	.slave_alloc		= ufshcd_slave_alloc,
+	.slave_configure	= ufshcd_slave_configure,
 	.slave_destroy		= ufshcd_slave_destroy,
 	.eh_abort_handler	= ufshcd_abort,
 	.eh_device_reset_handler = ufshcd_eh_device_reset_handler,
diff --git a/drivers/scsi/ufs/ufshci.h b/drivers/scsi/ufs/ufshci.h
index 9abc7e3..e1b844b 100644
--- a/drivers/scsi/ufs/ufshci.h
+++ b/drivers/scsi/ufs/ufshci.h
@@ -296,6 +296,11 @@ enum {
 	MASK_OCS			= 0x0F,
 };
 
+/* The maximum length of the data byte count field in the PRDT is 256KB */
+#define PRDT_DATA_BYTE_COUNT_MAX	(256 * 1024)
+/* The granularity of the data byte count field in the PRDT is 32-bit */
+#define PRDT_DATA_BYTE_COUNT_PAD	4
+
 /**
  * struct ufshcd_sg_entry - UFSHCI PRD Entry
  * @base_addr: Lower 32bit physical address DW-0
-- 
1.9.1

