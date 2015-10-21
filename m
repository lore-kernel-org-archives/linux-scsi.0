From: "Matthew R. Ochs" <mrochs@linux.vnet.ibm.com>
Subject: [PATCH v6 03/37] cxlflash: Fix read capacity timeout
Date: Wed, 21 Oct 2015 15:11:10 -0500
Message-ID: <1445458270-20899-1-git-send-email-mrochs@linux.vnet.ibm.com>
References: <1445458134-63197-1-git-send-email-mrochs@linux.vnet.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e18.ny.us.ibm.com ([129.33.205.208]:35162 "EHLO
	e18.ny.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932341AbbJUUMc (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 21 Oct 2015 16:12:32 -0400
Received: from localhost
	by e18.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-scsi@vger.kernel.org> from <mrochs@linux.vnet.ibm.com>;
	Wed, 21 Oct 2015 16:12:32 -0400
Received: from b01cxnp22033.gho.pok.ibm.com (b01cxnp22033.gho.pok.ibm.com [9.57.198.23])
	by d01dlp01.pok.ibm.com (Postfix) with ESMTP id C37BD38C8026
	for <linux-scsi@vger.kernel.org>; Wed, 21 Oct 2015 16:12:30 -0400 (EDT)
Received: from d01av03.pok.ibm.com (d01av03.pok.ibm.com [9.56.224.217])
	by b01cxnp22033.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id t9LKCUxT58261562
	for <linux-scsi@vger.kernel.org>; Wed, 21 Oct 2015 20:12:30 GMT
Received: from d01av03.pok.ibm.com (localhost [127.0.0.1])
	by d01av03.pok.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id t9LKCR2G016256
	for <linux-scsi@vger.kernel.org>; Wed, 21 Oct 2015 16:12:30 -0400
In-Reply-To: <1445458134-63197-1-git-send-email-mrochs@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, James Bottomley <James.Bottomley@HansenPartnership.com>, "Nicholas A. Bellinger" <nab@linux-iscsi.org>, Brian King <brking@linux.vnet.ibm.com>, Ian Munsie <imunsie@au1.ibm.com>, Daniel Axtens <dja@ozlabs.au.ibm.com>, Andrew Donnellan <andrew.donnellan@au1.ibm.com>, Tomas Henzl <thenzl@redhat.com>, David Laight <David.Laight@ACULAB.COM>
Cc: Michael Neuling <mikey@neuling.org>, "Manoj N. Kumar" <manoj@linux.vnet.ibm.com>, linuxppc-dev@lists.ozlabs.org, Manoj Kumar <kumarmn@us.ibm.com>

From: Manoj Kumar <kumarmn@us.ibm.com>

The timeout value for read capacity is too small. Certain devices
may take longer to respond and thus the command may prematurely
timeout. Additionally the literal used for the timeout is stale.

Update the timeout to 30 seconds (matches the value used in sd.c)
and rework the timeout literal to a more appropriate description.

Signed-off-by: Matthew R. Ochs <mrochs@linux.vnet.ibm.com>
Signed-off-by: Manoj N. Kumar <manoj@linux.vnet.ibm.com>
Reviewed-by: Brian King <brking@linux.vnet.ibm.com>
Reviewed-by: Tomas Henzl <thenzl@redhat.com>
---
 drivers/scsi/cxlflash/superpipe.c | 9 ++++-----
 drivers/scsi/cxlflash/superpipe.h | 2 +-
 drivers/scsi/cxlflash/vlun.c      | 4 ++--
 3 files changed, 7 insertions(+), 8 deletions(-)

diff --git a/drivers/scsi/cxlflash/superpipe.c b/drivers/scsi/cxlflash/superpipe.c
index 4db15a4..4e44a48 100644
--- a/drivers/scsi/cxlflash/superpipe.c
+++ b/drivers/scsi/cxlflash/superpipe.c
@@ -296,7 +296,7 @@ static int read_cap16(struct scsi_device *sdev, struct llun_info *lli)
 	int rc = 0;
 	int result = 0;
 	int retry_cnt = 0;
-	u32 tout = (MC_DISCOVERY_TIMEOUT * HZ);
+	u32 to = CMD_TIMEOUT * HZ;
 
 retry:
 	cmd_buf = kzalloc(CMD_BUFSIZE, GFP_KERNEL);
@@ -315,8 +315,7 @@ retry:
 		retry_cnt ? "re" : "", scsi_cmd[0]);
 
 	result = scsi_execute(sdev, scsi_cmd, DMA_FROM_DEVICE, cmd_buf,
-			      CMD_BUFSIZE, sense_buf, tout, CMD_RETRIES,
-			      0, NULL);
+			      CMD_BUFSIZE, sense_buf, to, CMD_RETRIES, 0, NULL);
 
 	if (driver_byte(result) == DRIVER_SENSE) {
 		result &= ~(0xFF<<24); /* DRIVER_SENSE is not an error */
@@ -1376,8 +1375,8 @@ out_attach:
 	attach->block_size = gli->blk_len;
 	attach->mmio_size = sizeof(afu->afu_map->hosts[0].harea);
 	attach->last_lba = gli->max_lba;
-	attach->max_xfer = (sdev->host->max_sectors * MAX_SECTOR_UNIT) /
-		gli->blk_len;
+	attach->max_xfer = sdev->host->max_sectors * MAX_SECTOR_UNIT;
+	attach->max_xfer /= gli->blk_len;
 
 out:
 	attach->adap_fd = fd;
diff --git a/drivers/scsi/cxlflash/superpipe.h b/drivers/scsi/cxlflash/superpipe.h
index 3f7856b..fffb179 100644
--- a/drivers/scsi/cxlflash/superpipe.h
+++ b/drivers/scsi/cxlflash/superpipe.h
@@ -28,7 +28,7 @@ extern struct cxlflash_global global;
 */
 #define MC_CHUNK_SIZE     (1 << MC_RHT_NMASK)	/* in LBAs */
 
-#define MC_DISCOVERY_TIMEOUT 5  /* 5 secs */
+#define CMD_TIMEOUT 30  /* 30 secs */
 #define CMD_RETRIES 5   /* 5 retries for scsi_execute */
 
 #define MAX_SECTOR_UNIT  512 /* max_sector is in 512 byte multiples */
diff --git a/drivers/scsi/cxlflash/vlun.c b/drivers/scsi/cxlflash/vlun.c
index 6d6608b..68994c4 100644
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
 
@@ -434,7 +434,7 @@ static int write_same16(struct scsi_device *sdev,
 				   &scsi_cmd[10]);
 
 		result = scsi_execute(sdev, scsi_cmd, DMA_TO_DEVICE, cmd_buf,
-				      CMD_BUFSIZE, sense_buf, tout, CMD_RETRIES,
+				      CMD_BUFSIZE, sense_buf, to, CMD_RETRIES,
 				      0, NULL);
 		if (result) {
 			dev_err_ratelimited(dev, "%s: command failed for "
-- 
2.1.0

