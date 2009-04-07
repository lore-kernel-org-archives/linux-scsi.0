From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: [PATCH 03/15] qla2xxx: Correct compilation failures when DEBUG'n' options are enabled.
Date: Mon,  6 Apr 2009 22:33:39 -0700
Message-ID: <1239082431-19496-4-git-send-email-andrew.vasquez@qlogic.com>
References: <1239082431-19496-1-git-send-email-andrew.vasquez@qlogic.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexch1.qlogic.com ([198.70.193.115]:29400 "EHLO
	avexch1.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750977AbZDGFdy (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 7 Apr 2009 01:33:54 -0400
In-Reply-To: <1239082431-19496-1-git-send-email-andrew.vasquez@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Andrew Vasquez <andrew.vasquez@qlogic.com>, Giridhar Malavali <giridhar.malavali@qlogic.com>, Linux SCSI Mailing List <linux-scsi@vger.kernel.org>

Signed-off-by: Andrew Vasquez <andrew.vasquez@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_init.c |   10 +++++-----
 drivers/scsi/qla2xxx/qla_mbx.c  |    2 +-
 drivers/scsi/qla2xxx/qla_sup.c  |   19 +++++++++++--------
 3 files changed, 17 insertions(+), 14 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index bd7dd84..9a343ec 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -634,7 +634,7 @@ qla2x00_chip_diag(scsi_qla_host_t *vha)
 		goto chip_diag_failed;
 
 	DEBUG3(printk("scsi(%ld): Reset register cleared by chip reset\n",
-	    ha->host_no));
+	    vha->host_no));
 
 	/* Reset RISC processor. */
 	WRT_REG_WORD(&reg->hccr, HCCR_RESET_RISC);
@@ -655,7 +655,7 @@ qla2x00_chip_diag(scsi_qla_host_t *vha)
 		goto chip_diag_failed;
 
 	/* Check product ID of chip */
-	DEBUG3(printk("scsi(%ld): Checking product ID of chip\n", ha->host_no));
+	DEBUG3(printk("scsi(%ld): Checking product ID of chip\n", vha->host_no));
 
 	mb[1] = RD_MAILBOX_REG(ha, reg, 1);
 	mb[2] = RD_MAILBOX_REG(ha, reg, 2);
@@ -2110,7 +2110,7 @@ qla2x00_configure_local_loop(scsi_qla_host_t *vha)
 		goto cleanup_allocation;
 
 	DEBUG3(printk("scsi(%ld): Entries in ID list (%d)\n",
-	    ha->host_no, entries));
+	    vha->host_no, entries));
 	DEBUG3(qla2x00_dump_buffer((uint8_t *)ha->gid_list,
 	    entries * sizeof(struct gid_list_info)));
 
@@ -3587,7 +3587,7 @@ qla24xx_nvram_config(scsi_qla_host_t *vha)
 	for (cnt = 0, chksum = 0; cnt < ha->nvram_size >> 2; cnt++)
 		chksum += le32_to_cpu(*dptr++);
 
-	DEBUG5(printk("scsi(%ld): Contents of NVRAM\n", ha->host_no));
+	DEBUG5(printk("scsi(%ld): Contents of NVRAM\n", vha->host_no));
 	DEBUG5(qla2x00_dump_buffer((uint8_t *)nv, ha->nvram_size));
 
 	/* Bad NVRAM data, set defaults parameters. */
@@ -4305,7 +4305,7 @@ qla81xx_nvram_config(scsi_qla_host_t *vha)
 	for (cnt = 0, chksum = 0; cnt < ha->nvram_size >> 2; cnt++)
 		chksum += le32_to_cpu(*dptr++);
 
-	DEBUG5(printk("scsi(%ld): Contents of NVRAM\n", ha->host_no));
+	DEBUG5(printk("scsi(%ld): Contents of NVRAM\n", vha->host_no));
 	DEBUG5(qla2x00_dump_buffer((uint8_t *)nv, ha->nvram_size));
 
 	/* Bad NVRAM data, set defaults parameters. */
diff --git a/drivers/scsi/qla2xxx/qla_mbx.c b/drivers/scsi/qla2xxx/qla_mbx.c
index dc5a1fe..4f7e94c 100644
--- a/drivers/scsi/qla2xxx/qla_mbx.c
+++ b/drivers/scsi/qla2xxx/qla_mbx.c
@@ -3393,7 +3393,7 @@ qla2x00_read_edc(scsi_qla_host_t *vha, uint16_t dev, uint16_t adr,
 		DEBUG2_3_11(printk("%s(%ld): failed=%x (%x).\n", __func__,
 		    vha->host_no, rval, mcp->mb[0]));
 	} else {
-		DEBUG11(printk("%s(%ld): done.\n", __func__, ha->host_no));
+		DEBUG11(printk("%s(%ld): done.\n", __func__, vha->host_no));
 	}
 
 	return rval;
diff --git a/drivers/scsi/qla2xxx/qla_sup.c b/drivers/scsi/qla2xxx/qla_sup.c
index 152ecfc..81187a0 100644
--- a/drivers/scsi/qla2xxx/qla_sup.c
+++ b/drivers/scsi/qla2xxx/qla_sup.c
@@ -219,8 +219,8 @@ qla2x00_write_nvram_word(struct qla_hw_data *ha, uint32_t addr, uint16_t data)
 	wait_cnt = NVR_WAIT_CNT;
 	do {
 		if (!--wait_cnt) {
-			DEBUG9_10(printk("%s(%ld): NVRAM didn't go ready...\n",
-			    __func__, vha->host_no));
+			DEBUG9_10(qla_printk(KERN_WARNING, ha,
+			    "NVRAM didn't go ready...\n"));
 			break;
 		}
 		NVRAM_DELAY();
@@ -349,7 +349,7 @@ qla2x00_clear_nvram_protection(struct qla_hw_data *ha)
 		wait_cnt = NVR_WAIT_CNT;
 		do {
 			if (!--wait_cnt) {
-				DEBUG9_10(qla_printk(
+				DEBUG9_10(qla_printk(KERN_WARNING, ha,
 				    "NVRAM didn't go ready...\n"));
 				break;
 			}
@@ -408,7 +408,8 @@ qla2x00_set_nvram_protection(struct qla_hw_data *ha, int stat)
 	wait_cnt = NVR_WAIT_CNT;
 	do {
 		if (!--wait_cnt) {
-			DEBUG9_10(qla_printk("NVRAM didn't go ready...\n"));
+			DEBUG9_10(qla_printk(KERN_WARNING, ha,
+			    "NVRAM didn't go ready...\n"));
 			break;
 		}
 		NVRAM_DELAY();
@@ -1079,8 +1080,9 @@ qla24xx_write_flash_data(scsi_qla_host_t *vha, uint32_t *dwptr, uint32_t faddr,
 				    0xff0000) | ((fdata >> 16) & 0xff));
 			ret = qla24xx_erase_sector(vha, fdata);
 			if (ret != QLA_SUCCESS) {
-				DEBUG9(qla_printk("Unable to erase sector: "
-				    "address=%x.\n", faddr));
+				DEBUG9(qla_printk(KERN_WARNING, ha,
+				    "Unable to erase sector: address=%x.\n",
+				    faddr));
 				break;
 			}
 		}
@@ -1240,8 +1242,9 @@ qla24xx_write_nvram_data(scsi_qla_host_t *vha, uint8_t *buf, uint32_t naddr,
 		ret = qla24xx_write_flash_dword(ha,
 		    nvram_data_addr(ha, naddr), cpu_to_le32(*dwptr));
 		if (ret != QLA_SUCCESS) {
-			DEBUG9(qla_printk("Unable to program nvram address=%x "
-			    "data=%x.\n", naddr, *dwptr));
+			DEBUG9(qla_printk(KERN_WARNING, ha,
+			    "Unable to program nvram address=%x data=%x.\n",
+			    naddr, *dwptr));
 			break;
 		}
 	}
-- 
1.6.2.2.404.ge96f3

