From: "Matthew R. Ochs" <mrochs@linux.vnet.ibm.com>
Subject: [PATCH v6 02/37] cxlflash: Replace magic numbers with literals
Date: Wed, 21 Oct 2015 15:11:00 -0500
Message-ID: <1445458260-11396-1-git-send-email-mrochs@linux.vnet.ibm.com>
References: <1445458134-63197-1-git-send-email-mrochs@linux.vnet.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e17.ny.us.ibm.com ([129.33.205.207]:50211 "EHLO
	e17.ny.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932454AbbJUUMY (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 21 Oct 2015 16:12:24 -0400
Received: from localhost
	by e17.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-scsi@vger.kernel.org> from <mrochs@linux.vnet.ibm.com>;
	Wed, 21 Oct 2015 16:12:23 -0400
Received: from b01cxnp23034.gho.pok.ibm.com (b01cxnp23034.gho.pok.ibm.com [9.57.198.29])
	by d01dlp01.pok.ibm.com (Postfix) with ESMTP id 8C0EC38C8054
	for <linux-scsi@vger.kernel.org>; Wed, 21 Oct 2015 16:12:21 -0400 (EDT)
Received: from d01av02.pok.ibm.com (d01av02.pok.ibm.com [9.56.224.216])
	by b01cxnp23034.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id t9LKCL1k65732622
	for <linux-scsi@vger.kernel.org>; Wed, 21 Oct 2015 20:12:21 GMT
Received: from d01av02.pok.ibm.com (localhost [127.0.0.1])
	by d01av02.pok.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id t9LKCJxh007844
	for <linux-scsi@vger.kernel.org>; Wed, 21 Oct 2015 16:12:21 -0400
In-Reply-To: <1445458134-63197-1-git-send-email-mrochs@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, James Bottomley <James.Bottomley@HansenPartnership.com>, "Nicholas A. Bellinger" <nab@linux-iscsi.org>, Brian King <brking@linux.vnet.ibm.com>, Ian Munsie <imunsie@au1.ibm.com>, Daniel Axtens <dja@ozlabs.au.ibm.com>, Andrew Donnellan <andrew.donnellan@au1.ibm.com>, Tomas Henzl <thenzl@redhat.com>, David Laight <David.Laight@ACULAB.COM>
Cc: Michael Neuling <mikey@neuling.org>, "Manoj N. Kumar" <manoj@linux.vnet.ibm.com>, linuxppc-dev@lists.ozlabs.org, Manoj Kumar <kumarmn@us.ibm.com>

From: Manoj Kumar <kumarmn@us.ibm.com>

Magic numbers are not meaningful and can create confusion. As a
remedy, replace them with descriptive literals.

Replace 512 with literal MAX_SECTOR_UNIT.
Replace 5 with literal CMD_RETRIES.

Signed-off-by: Matthew R. Ochs <mrochs@linux.vnet.ibm.com>
Signed-off-by: Manoj N. Kumar <manoj@linux.vnet.ibm.com>
Reviewed-by: Brian King <brking@linux.vnet.ibm.com>
Reviewed-by: Andrew Donnellan <andrew.donnellan@au1.ibm.com>
Reviewed-by: Tomas Henzl <thenzl@redhat.com>
---
 drivers/scsi/cxlflash/superpipe.c | 6 ++++--
 drivers/scsi/cxlflash/superpipe.h | 3 +++
 drivers/scsi/cxlflash/vlun.c      | 3 ++-
 3 files changed, 9 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/cxlflash/superpipe.c b/drivers/scsi/cxlflash/superpipe.c
index 05e0ecf..4db15a4 100644
--- a/drivers/scsi/cxlflash/superpipe.c
+++ b/drivers/scsi/cxlflash/superpipe.c
@@ -315,7 +315,8 @@ retry:
 		retry_cnt ? "re" : "", scsi_cmd[0]);
 
 	result = scsi_execute(sdev, scsi_cmd, DMA_FROM_DEVICE, cmd_buf,
-			      CMD_BUFSIZE, sense_buf, tout, 5, 0, NULL);
+			      CMD_BUFSIZE, sense_buf, tout, CMD_RETRIES,
+			      0, NULL);
 
 	if (driver_byte(result) == DRIVER_SENSE) {
 		result &= ~(0xFF<<24); /* DRIVER_SENSE is not an error */
@@ -1375,7 +1376,8 @@ out_attach:
 	attach->block_size = gli->blk_len;
 	attach->mmio_size = sizeof(afu->afu_map->hosts[0].harea);
 	attach->last_lba = gli->max_lba;
-	attach->max_xfer = (sdev->host->max_sectors * 512) / gli->blk_len;
+	attach->max_xfer = (sdev->host->max_sectors * MAX_SECTOR_UNIT) /
+		gli->blk_len;
 
 out:
 	attach->adap_fd = fd;
diff --git a/drivers/scsi/cxlflash/superpipe.h b/drivers/scsi/cxlflash/superpipe.h
index d7dc88b..3f7856b 100644
--- a/drivers/scsi/cxlflash/superpipe.h
+++ b/drivers/scsi/cxlflash/superpipe.h
@@ -29,6 +29,9 @@ extern struct cxlflash_global global;
 #define MC_CHUNK_SIZE     (1 << MC_RHT_NMASK)	/* in LBAs */
 
 #define MC_DISCOVERY_TIMEOUT 5  /* 5 secs */
+#define CMD_RETRIES 5   /* 5 retries for scsi_execute */
+
+#define MAX_SECTOR_UNIT  512 /* max_sector is in 512 byte multiples */
 
 #define CHAN2PORT(_x)	((_x) + 1)
 #define PORT2CHAN(_x)	((_x) - 1)
diff --git a/drivers/scsi/cxlflash/vlun.c b/drivers/scsi/cxlflash/vlun.c
index 6155cb1..6d6608b 100644
--- a/drivers/scsi/cxlflash/vlun.c
+++ b/drivers/scsi/cxlflash/vlun.c
@@ -434,7 +434,8 @@ static int write_same16(struct scsi_device *sdev,
 				   &scsi_cmd[10]);
 
 		result = scsi_execute(sdev, scsi_cmd, DMA_TO_DEVICE, cmd_buf,
-				      CMD_BUFSIZE, sense_buf, tout, 5, 0, NULL);
+				      CMD_BUFSIZE, sense_buf, tout, CMD_RETRIES,
+				      0, NULL);
 		if (result) {
 			dev_err_ratelimited(dev, "%s: command failed for "
 					    "offset %lld result=0x%x\n",
-- 
2.1.0

