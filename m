From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: [PATCH 1/5] qla2xxx: Correct Atmel flash-part handling.
Date: Fri, 24 Oct 2008 15:13:44 -0700
Message-ID: <1224886428-31799-2-git-send-email-andrew.vasquez@qlogic.com>
References: <1224886428-31799-1-git-send-email-andrew.vasquez@qlogic.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexch1.qlogic.com ([198.70.193.115]:14169 "EHLO
	avexch1.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755451AbYJXWNv (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 24 Oct 2008 18:13:51 -0400
In-Reply-To: <1224886428-31799-1-git-send-email-andrew.vasquez@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Linux SCSI Mailing List <linux-scsi@vger.kernel.org>, James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Andrew Vasquez <andrew.vasquez@qlogic.com>, Seokmann Ju <seokmann.ju@qlogic.com>, Lalit Chandivade <lalit.chandivade@qlogic.com>

From: Lalit Chandivade <lalit.chandivade@qlogic.com>

Use correct block size (4K) for erase command 0x20 for Atmel
Flash. Use dword addresses for determining sector boundary.

Cc: Stable Tree <stable@kernel.org>
Signed-off-by: Lalit Chandivade <lalit.chandivade@qlogic.com>
Signed-off-by: Andrew Vasquez <andrew.vasquez@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_def.h |    1 -
 drivers/scsi/qla2xxx/qla_sup.c |   19 +++++++------------
 2 files changed, 7 insertions(+), 13 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_def.h b/drivers/scsi/qla2xxx/qla_def.h
index f25f41a..b971940 100644
--- a/drivers/scsi/qla2xxx/qla_def.h
+++ b/drivers/scsi/qla2xxx/qla_def.h
@@ -2547,7 +2547,6 @@ typedef struct scsi_qla_host {
 	uint8_t		fcode_revision[16];
 	uint32_t	fw_revision[4];
 
-	uint16_t	fdt_odd_index;
 	uint32_t	fdt_wrt_disable;
 	uint32_t	fdt_erase_cmd;
 	uint32_t	fdt_block_size;
diff --git a/drivers/scsi/qla2xxx/qla_sup.c b/drivers/scsi/qla2xxx/qla_sup.c
index 90a1321..e4af678 100644
--- a/drivers/scsi/qla2xxx/qla_sup.c
+++ b/drivers/scsi/qla2xxx/qla_sup.c
@@ -722,6 +722,7 @@ done:
 static void
 qla2xxx_get_fdt_info(scsi_qla_host_t *ha)
 {
+#define FLASH_BLK_SIZE_4K	0x1000
 #define FLASH_BLK_SIZE_32K	0x8000
 #define FLASH_BLK_SIZE_64K	0x10000
 	const char *loc, *locations[] = { "MID", "FDT" };
@@ -755,7 +756,6 @@ qla2xxx_get_fdt_info(scsi_qla_host_t *ha)
 	loc = locations[1];
 	mid = le16_to_cpu(fdt->man_id);
 	fid = le16_to_cpu(fdt->id);
-	ha->fdt_odd_index = mid == 0x1f;
 	ha->fdt_wrt_disable = fdt->wrt_disable_bits;
 	ha->fdt_erase_cmd = flash_conf_to_access_addr(0x0300 | fdt->erase_cmd);
 	ha->fdt_block_size = le32_to_cpu(fdt->block_size);
@@ -788,8 +788,7 @@ no_flash_data:
 		ha->fdt_block_size = FLASH_BLK_SIZE_64K;
 		break;
 	case 0x1f: /* Atmel 26DF081A. */
-		ha->fdt_odd_index = 1;
-		ha->fdt_block_size = FLASH_BLK_SIZE_64K;
+		ha->fdt_block_size = FLASH_BLK_SIZE_4K;
 		ha->fdt_erase_cmd = flash_conf_to_access_addr(0x0320);
 		ha->fdt_unprotect_sec_cmd = flash_conf_to_access_addr(0x0339);
 		ha->fdt_protect_sec_cmd = flash_conf_to_access_addr(0x0336);
@@ -801,9 +800,9 @@ no_flash_data:
 	}
 done:
 	DEBUG2(qla_printk(KERN_DEBUG, ha, "FDT[%s]: (0x%x/0x%x) erase=0x%x "
-	    "pro=%x upro=%x idx=%d wrtd=0x%x blk=0x%x.\n", loc, mid, fid,
+	    "pro=%x upro=%x wrtd=0x%x blk=0x%x.\n", loc, mid, fid,
 	    ha->fdt_erase_cmd, ha->fdt_protect_sec_cmd,
-	    ha->fdt_unprotect_sec_cmd, ha->fdt_odd_index, ha->fdt_wrt_disable,
+	    ha->fdt_unprotect_sec_cmd, ha->fdt_wrt_disable,
 	    ha->fdt_block_size));
 }
 
@@ -987,13 +986,9 @@ qla24xx_write_flash_data(scsi_qla_host_t *ha, uint32_t *dwptr, uint32_t faddr,
 	qla24xx_unprotect_flash(ha);
 
 	for (liter = 0; liter < dwords; liter++, faddr++, dwptr++) {
-		if (ha->fdt_odd_index) {
-			findex = faddr << 2;
-			fdata = findex & sec_mask;
-		} else {
-			findex = faddr;
-			fdata = (findex & sec_mask) << 2;
-		}
+
+		findex = faddr;
+		fdata = (findex & sec_mask) << 2;
 
 		/* Are we at the beginning of a sector? */
 		if ((findex & rest_addr) == 0) {
-- 
1.6.0.2.526.g5c283

