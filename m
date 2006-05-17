From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: [PATCH 02/15] qla2xxx: Add support for new flash part.
Date: Wed, 17 May 2006 15:08:49 -0700
Message-ID: <11479037243129-git-send-email-andrew.vasquez@qlogic.com>
References: <20060517220642.GF4126@andrew-vasquezs-powerbook-g4-15.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pat.qlogic.com ([198.70.193.2]:24247 "EHLO avexch1.qlogic.com")
	by vger.kernel.org with ESMTP id S1751213AbWEQWIu (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 17 May 2006 18:08:50 -0400
In-Reply-To: <20060517220642.GF4126@andrew-vasquezs-powerbook-g4-15.local>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, James.Bottomley@SteelEye.com
Cc: Andrew Vasquez <andrew.vasquez@qlogic.com>, Ravi Anand <ravi.anand@qlogic.com>

From: Ravi Anand <ravi.anand@qlogic.com>

Signed-off-by: Andrew Vasquez <andrew.vasquez@qlogic.com>

---

c87569110989aafda73e6de80ef019a3d36a4c28
 drivers/scsi/qla2xxx/qla_def.h |    2 +
 drivers/scsi/qla2xxx/qla_sup.c |   93 +++++++++++++++++++++++++++++++++++-----
 2 files changed, 83 insertions(+), 12 deletions(-)

c87569110989aafda73e6de80ef019a3d36a4c28
diff --git a/drivers/scsi/qla2xxx/qla_def.h b/drivers/scsi/qla2xxx/qla_def.h
index 53508f3..4881242 100644
--- a/drivers/scsi/qla2xxx/qla_def.h
+++ b/drivers/scsi/qla2xxx/qla_def.h
@@ -270,6 +270,8 @@ #define NVR_DATA_OUT		BIT_2
 #define NVR_SELECT		BIT_1
 #define NVR_CLOCK		BIT_0
 
+#define NVR_WAIT_CNT		20000
+
 	union {
 		struct {
 			uint16_t mailbox0;
diff --git a/drivers/scsi/qla2xxx/qla_sup.c b/drivers/scsi/qla2xxx/qla_sup.c
index 8b0121d..c71dbd5 100644
--- a/drivers/scsi/qla2xxx/qla_sup.c
+++ b/drivers/scsi/qla2xxx/qla_sup.c
@@ -97,7 +97,7 @@ qla2x00_write_nvram_word(scsi_qla_host_t
 {
 	int count;
 	uint16_t word;
-	uint32_t nv_cmd;
+	uint32_t nv_cmd, wait_cnt;
 	struct device_reg_2xxx __iomem *reg = &ha->iobase->isp;
 
 	qla2x00_nv_write(ha, NVR_DATA_OUT);
@@ -127,7 +127,13 @@ qla2x00_write_nvram_word(scsi_qla_host_t
 	/* Wait for NVRAM to become ready */
 	WRT_REG_WORD(&reg->nvram, NVR_SELECT);
 	RD_REG_WORD(&reg->nvram);		/* PCI Posting. */
+	wait_cnt = NVR_WAIT_CNT;
 	do {
+		if (!--wait_cnt) {
+			DEBUG9_10(printk("%s(%ld): NVRAM didn't go ready...\n",
+			    __func__, ha->host_no));
+			break;
+		}
 		NVRAM_DELAY();
 		word = RD_REG_WORD(&reg->nvram);
 	} while ((word & NVR_DATA_IN) == 0);
@@ -301,16 +307,17 @@ qla2x00_clear_nvram_protection(scsi_qla_
 {
 	int ret, stat;
 	struct device_reg_2xxx __iomem *reg = &ha->iobase->isp;
-	uint32_t word;
+	uint32_t word, wait_cnt;
 	uint16_t wprot, wprot_old;
 
 	/* Clear NVRAM write protection. */
 	ret = QLA_FUNCTION_FAILED;
-	wprot_old = cpu_to_le16(qla2x00_get_nvram_word(ha, 0));
-	stat = qla2x00_write_nvram_word_tmo(ha, 0,
+
+	wprot_old = cpu_to_le16(qla2x00_get_nvram_word(ha, ha->nvram_base));
+	stat = qla2x00_write_nvram_word_tmo(ha, ha->nvram_base,
 	    __constant_cpu_to_le16(0x1234), 100000);
-	wprot = cpu_to_le16(qla2x00_get_nvram_word(ha, 0));
-	if (stat != QLA_SUCCESS || wprot != __constant_cpu_to_le16(0x1234)) {
+	wprot = cpu_to_le16(qla2x00_get_nvram_word(ha, ha->nvram_base));
+	if (stat != QLA_SUCCESS || wprot != 0x1234) {
 		/* Write enable. */
 		qla2x00_nv_write(ha, NVR_DATA_OUT);
 		qla2x00_nv_write(ha, 0);
@@ -341,14 +348,22 @@ qla2x00_clear_nvram_protection(scsi_qla_
 		/* Wait for NVRAM to become ready. */
 		WRT_REG_WORD(&reg->nvram, NVR_SELECT);
 		RD_REG_WORD(&reg->nvram);	/* PCI Posting. */
+		wait_cnt = NVR_WAIT_CNT;
 		do {
+			if (!--wait_cnt) {
+				DEBUG9_10(printk("%s(%ld): NVRAM didn't go "
+				    "ready...\n", __func__,
+				    ha->host_no));
+				break;
+			}
 			NVRAM_DELAY();
 			word = RD_REG_WORD(&reg->nvram);
 		} while ((word & NVR_DATA_IN) == 0);
 
-		ret = QLA_SUCCESS;
+		if (wait_cnt)
+			ret = QLA_SUCCESS;
 	} else
-		qla2x00_write_nvram_word(ha, 0, wprot_old);
+		qla2x00_write_nvram_word(ha, ha->nvram_base, wprot_old);
 
 	return ret;
 }
@@ -357,7 +372,7 @@ static void
 qla2x00_set_nvram_protection(scsi_qla_host_t *ha, int stat)
 {
 	struct device_reg_2xxx __iomem *reg = &ha->iobase->isp;
-	uint32_t word;
+	uint32_t word, wait_cnt;
 
 	if (stat != QLA_SUCCESS)
 		return;
@@ -393,7 +408,13 @@ qla2x00_set_nvram_protection(scsi_qla_ho
 	/* Wait for NVRAM to become ready. */
 	WRT_REG_WORD(&reg->nvram, NVR_SELECT);
 	RD_REG_WORD(&reg->nvram);		/* PCI Posting. */
+	wait_cnt = NVR_WAIT_CNT;
 	do {
+		if (!--wait_cnt) {
+			DEBUG9_10(printk("%s(%ld): NVRAM didn't go ready...\n",
+			    __func__, ha->host_no));
+			break;
+		}
 		NVRAM_DELAY();
 		word = RD_REG_WORD(&reg->nvram);
 	} while ((word & NVR_DATA_IN) == 0);
@@ -500,6 +521,20 @@ qla24xx_get_flash_manufacturer(scsi_qla_
 	ids = qla24xx_read_flash_dword(ha, flash_data_to_access_addr(0xd03ab));
 	*man_id = LSB(ids);
 	*flash_id = MSB(ids);
+
+	/* Check if man_id and flash_id are valid. */
+	if (ids != 0xDEADDEAD && (*man_id == 0 || *flash_id == 0)) {
+		/* Read information using 0x9f opcode
+		 * Device ID, Mfg ID would be read in the format:
+		 *   <Ext Dev Info><Device ID Part2><Device ID Part 1><Mfg ID>
+		 * Example: ATMEL 0x00 01 45 1F
+		 * Extract MFG and Dev ID from last two bytes.
+		 */
+		ids = qla24xx_read_flash_dword(ha,
+		    flash_data_to_access_addr(0xd009f));
+		*man_id = LSB(ids);
+		*flash_id = MSB(ids);
+	}
 }
 
 int
@@ -508,8 +543,8 @@ qla24xx_write_flash_data(scsi_qla_host_t
 {
 	int ret;
 	uint32_t liter;
-	uint32_t sec_mask, rest_addr, conf_addr;
-	uint32_t fdata;
+	uint32_t sec_mask, rest_addr, conf_addr, sec_end_mask;
+	uint32_t fdata, findex ;
 	uint8_t	man_id, flash_id;
 	struct device_reg_24xx __iomem *reg = &ha->iobase->isp24;
 
@@ -519,6 +554,7 @@ qla24xx_write_flash_data(scsi_qla_host_t
 	DEBUG9(printk("%s(%ld): Flash man_id=%d flash_id=%d\n", __func__,
 	    ha->host_no, man_id, flash_id));
 
+	sec_end_mask = 0;
 	conf_addr = flash_conf_to_access_addr(0x03d8);
 	switch (man_id) {
 	case 0xbf: /* STT flash. */
@@ -531,6 +567,12 @@ qla24xx_write_flash_data(scsi_qla_host_t
 		rest_addr = 0x3fff;
 		sec_mask = 0x3c000;
 		break;
+	case 0x1f: // Atmel 26DF081A
+		rest_addr = 0x0fff;
+		sec_mask = 0xff000;
+		sec_end_mask = 0x003ff;
+		conf_addr = flash_conf_to_access_addr(0x0320);
+		break;
 	default:
 		/* Default to 64 kb sector size. */
 		rest_addr = 0x3fff;
@@ -545,11 +587,30 @@ qla24xx_write_flash_data(scsi_qla_host_t
 
 	/* Disable flash write-protection. */
 	qla24xx_write_flash_dword(ha, flash_conf_to_access_addr(0x101), 0);
+	/* Some flash parts need an additional zero-write to clear bits.*/
+	qla24xx_write_flash_dword(ha, flash_conf_to_access_addr(0x101), 0);
 
 	do {    /* Loop once to provide quick error exit. */
 		for (liter = 0; liter < dwords; liter++, faddr++, dwptr++) {
+			if (man_id == 0x1f) {
+				findex = faddr << 2;
+				fdata = findex & sec_mask;
+			} else {
+				findex = faddr;
+				fdata = (findex & sec_mask) << 2;
+			}
+
 			/* Are we at the beginning of a sector? */
-			if ((faddr & rest_addr) == 0) {
+			if ((findex & rest_addr) == 0) {
+				/*
+				 * Do sector unprotect at 4K boundry for Atmel
+				 * part.
+				 */
+				if (man_id == 0x1f)
+					qla24xx_write_flash_dword(ha,
+					    flash_conf_to_access_addr(0x0339),
+					    (fdata & 0xff00) | ((fdata << 16) &
+					    0xff0000) | ((fdata >> 16) & 0xff));
 				fdata = (faddr & sec_mask) << 2;
 				ret = qla24xx_write_flash_dword(ha, conf_addr,
 				    (fdata & 0xff00) |((fdata << 16) &
@@ -570,6 +631,14 @@ qla24xx_write_flash_data(scsi_qla_host_t
 				    ha->host_no, faddr, *dwptr));
 				break;
 			}
+
+			/* Do sector protect at 4K boundry for Atmel part. */
+			if (man_id == 0x1f &&
+			    ((faddr & sec_end_mask) == 0x3ff))
+				qla24xx_write_flash_dword(ha,
+				    flash_conf_to_access_addr(0x0336),
+				    (fdata & 0xff00) | ((fdata << 16) &
+				    0xff0000) | ((fdata >> 16) & 0xff));
 		}
 	} while (0);
 
-- 
1.3.3.g63df


