From: "Matthew R. Ochs" <mrochs@linux.vnet.ibm.com>
Subject: [PATCH 03/29] cxlflash: Increase timeout value for read capacity to 30 seconds
Date: Fri, 11 Sep 2015 16:10:09 -0500
Message-ID: <1442005809-46422-1-git-send-email-mrochs@linux.vnet.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e35.co.us.ibm.com ([32.97.110.153]:43612 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752561AbbIKVK0 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 11 Sep 2015 17:10:26 -0400
Received: from /spool/local
	by e35.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-scsi@vger.kernel.org> from <mrochs@linux.vnet.ibm.com>;
	Fri, 11 Sep 2015 15:10:26 -0600
Received: from b03cxnp08026.gho.boulder.ibm.com (b03cxnp08026.gho.boulder.ibm.com [9.17.130.18])
	by d03dlp01.boulder.ibm.com (Postfix) with ESMTP id 2EB061FF0049
	for <linux-scsi@vger.kernel.org>; Fri, 11 Sep 2015 15:01:34 -0600 (MDT)
Received: from d03av04.boulder.ibm.com (d03av04.boulder.ibm.com [9.17.195.170])
	by b03cxnp08026.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id t8BL9Zr737421064
	for <linux-scsi@vger.kernel.org>; Fri, 11 Sep 2015 14:09:35 -0700
Received: from d03av04.boulder.ibm.com (loopback [127.0.0.1])
	by d03av04.boulder.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id t8BLANFN007587
	for <linux-scsi@vger.kernel.org>; Fri, 11 Sep 2015 15:10:24 -0600
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, James.Bottomley@HansenPartnership.com, nab@linux-iscsi.org, brking@linux.vnet.ibm.com, imunsie@au1.ibm.com, dja@ozlabs.au.ibm.com, andrew.donnellan@au1.ibm.com
Cc: mikey@neuling.org, Manoj Kumar <kumarmn@us.ibm.com>, "Manoj N. Kumar" <manoj@linux.vnet.ibm.com>

From: Manoj Kumar <kumarmn@us.ibm.com>

Make literals for number of retries as well.

Signed-off-by: Matthew R. Ochs <mrochs@linux.vnet.ibm.com>
Signed-off-by: Manoj N. Kumar <manoj@linux.vnet.ibm.com>
---
 drivers/scsi/cxlflash/superpipe.c | 8 ++++----
 drivers/scsi/cxlflash/superpipe.h | 3 ++-
 drivers/scsi/cxlflash/vlun.c      | 5 +++--
 3 files changed, 9 insertions(+), 7 deletions(-)

diff --git a/drivers/scsi/cxlflash/superpipe.c b/drivers/scsi/cxlflash/superpipe.c
index affec2d..fa513ba 100644
--- a/drivers/scsi/cxlflash/superpipe.c
+++ b/drivers/scsi/cxlflash/superpipe.c
@@ -296,7 +296,7 @@ static int read_cap16(struct scsi_device *sdev, struct llun_info *lli)
 	int rc = 0;
 	int result = 0;
 	int retry_cnt = 0;
-	u32 tout = (MC_DISCOVERY_TIMEOUT * HZ);
+	u32 to = (CMD_TIMEOUT * HZ);
 
 retry:
 	cmd_buf = kzalloc(CMD_BUFSIZE, GFP_KERNEL);
@@ -315,7 +315,7 @@ retry:
 		retry_cnt ? "re" : "", scsi_cmd[0]);
 
 	result = scsi_execute(sdev, scsi_cmd, DMA_FROM_DEVICE, cmd_buf,
-			      CMD_BUFSIZE, sense_buf, tout, 5, 0, NULL);
+			      CMD_BUFSIZE, sense_buf, to, CMD_RETRIES, 0, NULL);
 
 	if (driver_byte(result) == DRIVER_SENSE) {
 		result &= ~(0xFF<<24); /* DRIVER_SENSE is not an error */
@@ -1375,8 +1375,8 @@ out_attach:
 	attach->block_size = gli->blk_len;
 	attach->mmio_size = sizeof(afu->afu_map->hosts[0].harea);
 	attach->last_lba = gli->max_lba;
-	attach->max_xfer = (sdev->host->max_sectors * MAX_SECTOR_UNIT) /
-		gli->blk_len;
+	attach->max_xfer = (sdev->host->max_sectors * MAX_SECTOR_UNIT);
+	attach->max_xfer /= gli->blk_len;
 
 out:
 	attach->adap_fd = fd;
diff --git a/drivers/scsi/cxlflash/superpipe.h b/drivers/scsi/cxlflash/superpipe.h
index 5c39f2c..fffb179 100644
--- a/drivers/scsi/cxlflash/superpipe.h
+++ b/drivers/scsi/cxlflash/superpipe.h
@@ -28,7 +28,8 @@ extern struct cxlflash_global global;
 */
 #define MC_CHUNK_SIZE     (1 << MC_RHT_NMASK)	/* in LBAs */
 
-#define MC_DISCOVERY_TIMEOUT 5  /* 5 secs */
+#define CMD_TIMEOUT 30  /* 30 secs */
+#define CMD_RETRIES 5   /* 5 retries for scsi_execute */
 
 #define MAX_SECTOR_UNIT  512 /* max_sector is in 512 byte multiples */
 
diff --git a/drivers/scsi/cxlflash/vlun.c b/drivers/scsi/cxlflash/vlun.c
index 6155cb1..68994c4 100644
--- a/drivers/scsi/cxlflash/vlun.c
+++ b/drivers/scsi/cxlflash/vlun.c
@@ -414,7 +414,7 @@ static int write_same16(struct scsi_device *sdev,
 	int ws_limit = SISLITE_MAX_WS_BLOCKS;
 	u64 offset = lba;
 	int left = nblks;
-	u32 tout = sdev->request_queue->rq_timeout;
+	u32 to = sdev->request_queue->rq_timeout;
 	struct cxlflash_cfg *cfg = (struct cxlflash_cfg *)sdev->host->hostdata;
 	struct device *dev = &cfg->dev->dev;
 
@@ -434,7 +434,8 @@ static int write_same16(struct scsi_device *sdev,
 				   &scsi_cmd[10]);
 
 		result = scsi_execute(sdev, scsi_cmd, DMA_TO_DEVICE, cmd_buf,
-				      CMD_BUFSIZE, sense_buf, tout, 5, 0, NULL);
+				      CMD_BUFSIZE, sense_buf, to, CMD_RETRIES,
+				      0, NULL);
 		if (result) {
 			dev_err_ratelimited(dev, "%s: command failed for "
 					    "offset %lld result=0x%x\n",
-- 
2.1.0

