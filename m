From: Matthew Wilcox <matthew@wil.cx>
Subject: [PATCH 03/22] advansys: Create AdvLoadMicrocode
Date: Sun,  9 Sep 2007 08:56:28 -0600
Message-ID: <11893498071397-git-send-email-matthew@wil.cx>
References: <20070909145358.GG6809@parisc-linux.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.tor.primus.ca ([216.254.136.21]:50172 "EHLO
	mail-01.primus.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757287AbXIIO4s (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 9 Sep 2007 10:56:48 -0400
In-Reply-To: <20070909145358.GG6809@parisc-linux.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Matthew Wilcox <matthew@wil.cx>

Split AdvLoadMicrocode out of AdvInitAsc3550Driver, AdvInitAsc38C0800Driver
and AdvInitAsc38C1600Driver.

Signed-off-by: Matthew Wilcox <matthew@wil.cx>
---
 drivers/scsi/advansys.c |  382 +++++++++++++----------------------------------
 1 files changed, 107 insertions(+), 275 deletions(-)

diff --git a/drivers/scsi/advansys.c b/drivers/scsi/advansys.c
index c216d6a..0f02f3f 100644
--- a/drivers/scsi/advansys.c
+++ b/drivers/scsi/advansys.c
@@ -12932,6 +12932,78 @@ static void AdvBuildCarrierFreelist(struct adv_dvc_var *asc_dvc)
 }
 
 /*
+ * Load the Microcode
+ *
+ * Write the microcode image to RISC memory starting at address 0.
+ *
+ * The microcode is stored compressed in the following format:
+ *
+ *  254 word (508 byte) table indexed by byte code followed
+ *  by the following byte codes:
+ *
+ *    1-Byte Code:
+ *      00: Emit word 0 in table.
+ *      01: Emit word 1 in table.
+ *      .
+ *      FD: Emit word 253 in table.
+ *
+ *    Multi-Byte Code:
+ *      FE WW WW: (3 byte code) Word to emit is the next word WW WW.
+ *      FF BB WW WW: (4 byte code) Emit BB count times next word WW WW.
+ *
+ * Returns 0 or an error if the checksum doesn't match
+ */
+static int AdvLoadMicrocode(AdvPortAddr iop_base, unsigned char *buf, int size,
+			    int memsize, int chksum)
+{
+	int i, j, end, len = 0;
+	ADV_DCNT sum;
+
+	AdvWriteWordRegister(iop_base, IOPW_RAM_ADDR, 0);
+
+	for (i = 253 * 2; i < size; i++) {
+		if (buf[i] == 0xff) {
+			unsigned short word = (buf[i + 3] << 8) | buf[i + 2];
+			for (j = 0; j < buf[i + 1]; j++) {
+				AdvWriteWordAutoIncLram(iop_base, word);
+				len += 2;
+			}
+			i += 3;
+		} else if (buf[i] == 0xfe) {
+			unsigned short word = (buf[i + 2] << 8) | buf[i + 1];
+			AdvWriteWordAutoIncLram(iop_base, word);
+			i += 2;
+			len += 2;
+		} else {
+			unsigned char off = buf[i] * 2;
+			unsigned short word = (buf[off + 1] << 8) | buf[off];
+			AdvWriteWordAutoIncLram(iop_base, word);
+			len += 2;
+		}
+	}
+
+	end = len;
+
+	while (len < memsize) {
+		AdvWriteWordAutoIncLram(iop_base, 0);
+		len += 2;
+	}
+
+	/* Verify the microcode checksum. */
+	sum = 0;
+	AdvWriteWordRegister(iop_base, IOPW_RAM_ADDR, 0);
+
+	for (len = 0; len < end; len += 2) {
+		sum += AdvReadWordAutoIncLram(iop_base);
+	}
+
+	if (sum != chksum)
+		return ASC_IERR_MCODE_CHKSUM;
+
+	return 0;
+}
+
+/*
  * Initialize the ASC-3550.
  *
  * On failure set the ADV_DVC_VAR field 'err_code' and return ADV_ERROR.
@@ -12945,13 +13017,10 @@ static int AdvInitAsc3550Driver(ADV_DVC_VAR *asc_dvc)
 {
 	AdvPortAddr iop_base;
 	ushort warn_code;
-	ADV_DCNT sum;
 	int begin_addr;
 	int end_addr;
 	ushort code_sum;
 	int word;
-	int j;
-	int adv_asc3550_expanded_size;
 	int i;
 	ushort scsi_cfg1;
 	uchar tid;
@@ -12960,15 +13029,14 @@ static int AdvInitAsc3550Driver(ADV_DVC_VAR *asc_dvc)
 	uchar max_cmd[ADV_MAX_TID + 1];
 
 	/* If there is already an error, don't continue. */
-	if (asc_dvc->err_code != 0) {
+	if (asc_dvc->err_code != 0)
 		return ADV_ERROR;
-	}
 
 	/*
 	 * The caller must set 'chip_type' to ADV_CHIP_ASC3550.
 	 */
 	if (asc_dvc->chip_type != ADV_CHIP_ASC3550) {
-		asc_dvc->err_code |= ASC_IERR_BAD_CHIPTYPE;
+		asc_dvc->err_code = ASC_IERR_BAD_CHIPTYPE;
 		return ADV_ERROR;
 	}
 
@@ -13012,84 +13080,11 @@ static int AdvInitAsc3550Driver(ADV_DVC_VAR *asc_dvc)
 				max_cmd[tid]);
 	}
 
-	/*
-	 * Load the Microcode
-	 *
-	 * Write the microcode image to RISC memory starting at address 0.
-	 */
-	AdvWriteWordRegister(iop_base, IOPW_RAM_ADDR, 0);
-	/* Assume the following compressed format of the microcode buffer:
-	 *
-	 *  254 word (508 byte) table indexed by byte code followed
-	 *  by the following byte codes:
-	 *
-	 *    1-Byte Code:
-	 *      00: Emit word 0 in table.
-	 *      01: Emit word 1 in table.
-	 *      .
-	 *      FD: Emit word 253 in table.
-	 *
-	 *    Multi-Byte Code:
-	 *      FE WW WW: (3 byte code) Word to emit is the next word WW WW.
-	 *      FF BB WW WW: (4 byte code) Emit BB count times next word WW WW.
-	 */
-	word = 0;
-	for (i = 253 * 2; i < _adv_asc3550_size; i++) {
-		if (_adv_asc3550_buf[i] == 0xff) {
-			for (j = 0; j < _adv_asc3550_buf[i + 1]; j++) {
-				AdvWriteWordAutoIncLram(iop_base, (((ushort)
-								    _adv_asc3550_buf
-								    [i +
-								     3] << 8) |
-								   _adv_asc3550_buf
-								   [i + 2]));
-				word++;
-			}
-			i += 3;
-		} else if (_adv_asc3550_buf[i] == 0xfe) {
-			AdvWriteWordAutoIncLram(iop_base, (((ushort)
-							    _adv_asc3550_buf[i +
-									     2]
-							    << 8) |
-							   _adv_asc3550_buf[i +
-									    1]));
-			i += 2;
-			word++;
-		} else {
-			AdvWriteWordAutoIncLram(iop_base, (((ushort)
-							    _adv_asc3550_buf[(_adv_asc3550_buf[i] * 2) + 1] << 8) | _adv_asc3550_buf[_adv_asc3550_buf[i] * 2]));
-			word++;
-		}
-	}
-
-	/*
-	 * Set 'word' for later use to clear the rest of memory and save
-	 * the expanded mcode size.
-	 */
-	word *= 2;
-	adv_asc3550_expanded_size = word;
-
-	/*
-	 * Clear the rest of ASC-3550 Internal RAM (8KB).
-	 */
-	for (; word < ADV_3550_MEMSIZE; word += 2) {
-		AdvWriteWordAutoIncLram(iop_base, 0);
-	}
-
-	/*
-	 * Verify the microcode checksum.
-	 */
-	sum = 0;
-	AdvWriteWordRegister(iop_base, IOPW_RAM_ADDR, 0);
-
-	for (word = 0; word < adv_asc3550_expanded_size; word += 2) {
-		sum += AdvReadWordAutoIncLram(iop_base);
-	}
-
-	if (sum != _adv_asc3550_chksum) {
-		asc_dvc->err_code |= ASC_IERR_MCODE_CHKSUM;
+	asc_dvc->err_code = AdvLoadMicrocode(iop_base, _adv_asc3550_buf,
+					_adv_asc3550_size, ADV_3550_MEMSIZE,
+					_adv_asc3550_chksum);
+	if (asc_dvc->err_code)
 		return ADV_ERROR;
-	}
 
 	/*
 	 * Restore the RISC memory BIOS region.
@@ -13460,13 +13455,10 @@ static int AdvInitAsc38C0800Driver(ADV_DVC_VAR *asc_dvc)
 {
 	AdvPortAddr iop_base;
 	ushort warn_code;
-	ADV_DCNT sum;
 	int begin_addr;
 	int end_addr;
 	ushort code_sum;
 	int word;
-	int j;
-	int adv_asc38C0800_expanded_size;
 	int i;
 	ushort scsi_cfg1;
 	uchar byte;
@@ -13476,9 +13468,8 @@ static int AdvInitAsc38C0800Driver(ADV_DVC_VAR *asc_dvc)
 	uchar max_cmd[ADV_MAX_TID + 1];
 
 	/* If there is already an error, don't continue. */
-	if (asc_dvc->err_code != 0) {
+	if (asc_dvc->err_code != 0)
 		return ADV_ERROR;
-	}
 
 	/*
 	 * The caller must set 'chip_type' to ADV_CHIP_ASC38C0800.
@@ -13550,7 +13541,7 @@ static int AdvInitAsc38C0800Driver(ADV_DVC_VAR *asc_dvc)
 		byte = AdvReadByteRegister(iop_base, IOPB_RAM_BIST);
 		if ((byte & RAM_TEST_DONE) == 0
 		    || (byte & 0x0F) != PRE_TEST_VALUE) {
-			asc_dvc->err_code |= ASC_IERR_BIST_PRE_TEST;
+			asc_dvc->err_code = ASC_IERR_BIST_PRE_TEST;
 			return ADV_ERROR;
 		}
 
@@ -13558,7 +13549,7 @@ static int AdvInitAsc38C0800Driver(ADV_DVC_VAR *asc_dvc)
 		DvcSleepMilliSecond(10);	/* Wait for 10ms before reading back. */
 		if (AdvReadByteRegister(iop_base, IOPB_RAM_BIST)
 		    != NORMAL_VALUE) {
-			asc_dvc->err_code |= ASC_IERR_BIST_PRE_TEST;
+			asc_dvc->err_code = ASC_IERR_BIST_PRE_TEST;
 			return ADV_ERROR;
 		}
 	}
@@ -13577,99 +13568,18 @@ static int AdvInitAsc38C0800Driver(ADV_DVC_VAR *asc_dvc)
 	if ((byte & RAM_TEST_DONE) == 0 || (byte & RAM_TEST_STATUS) != 0) {
 		/* Get here if Done bit not set or Status not 0. */
 		asc_dvc->bist_err_code = byte;	/* for BIOS display message */
-		asc_dvc->err_code |= ASC_IERR_BIST_RAM_TEST;
+		asc_dvc->err_code = ASC_IERR_BIST_RAM_TEST;
 		return ADV_ERROR;
 	}
 
 	/* We need to reset back to normal mode after LRAM test passes. */
 	AdvWriteByteRegister(iop_base, IOPB_RAM_BIST, NORMAL_MODE);
 
-	/*
-	 * Load the Microcode
-	 *
-	 * Write the microcode image to RISC memory starting at address 0.
-	 *
-	 */
-	AdvWriteWordRegister(iop_base, IOPW_RAM_ADDR, 0);
-
-	/* Assume the following compressed format of the microcode buffer:
-	 *
-	 *  254 word (508 byte) table indexed by byte code followed
-	 *  by the following byte codes:
-	 *
-	 *    1-Byte Code:
-	 *      00: Emit word 0 in table.
-	 *      01: Emit word 1 in table.
-	 *      .
-	 *      FD: Emit word 253 in table.
-	 *
-	 *    Multi-Byte Code:
-	 *      FE WW WW: (3 byte code) Word to emit is the next word WW WW.
-	 *      FF BB WW WW: (4 byte code) Emit BB count times next word WW WW.
-	 */
-	word = 0;
-	for (i = 253 * 2; i < _adv_asc38C0800_size; i++) {
-		if (_adv_asc38C0800_buf[i] == 0xff) {
-			for (j = 0; j < _adv_asc38C0800_buf[i + 1]; j++) {
-				AdvWriteWordAutoIncLram(iop_base, (((ushort)
-								    _adv_asc38C0800_buf
-								    [i +
-								     3] << 8) |
-								   _adv_asc38C0800_buf
-								   [i + 2]));
-				word++;
-			}
-			i += 3;
-		} else if (_adv_asc38C0800_buf[i] == 0xfe) {
-			AdvWriteWordAutoIncLram(iop_base, (((ushort)
-							    _adv_asc38C0800_buf
-							    [i +
-							     2] << 8) |
-							   _adv_asc38C0800_buf[i
-									       +
-									       1]));
-			i += 2;
-			word++;
-		} else {
-			AdvWriteWordAutoIncLram(iop_base, (((ushort)
-							    _adv_asc38C0800_buf[(_adv_asc38C0800_buf[i] * 2) + 1] << 8) | _adv_asc38C0800_buf[_adv_asc38C0800_buf[i] * 2]));
-			word++;
-		}
-	}
-
-	/*
-	 * Set 'word' for later use to clear the rest of memory and save
-	 * the expanded mcode size.
-	 */
-	word *= 2;
-	adv_asc38C0800_expanded_size = word;
-
-	/*
-	 * Clear the rest of ASC-38C0800 Internal RAM (16KB).
-	 */
-	for (; word < ADV_38C0800_MEMSIZE; word += 2) {
-		AdvWriteWordAutoIncLram(iop_base, 0);
-	}
-
-	/*
-	 * Verify the microcode checksum.
-	 */
-	sum = 0;
-	AdvWriteWordRegister(iop_base, IOPW_RAM_ADDR, 0);
-
-	for (word = 0; word < adv_asc38C0800_expanded_size; word += 2) {
-		sum += AdvReadWordAutoIncLram(iop_base);
-	}
-	ASC_DBG2(1, "AdvInitAsc38C0800Driver: word %d, i %d\n", word, i);
-
-	ASC_DBG2(1,
-		 "AdvInitAsc38C0800Driver: sum 0x%lx, _adv_asc38C0800_chksum 0x%lx\n",
-		 (ulong)sum, (ulong)_adv_asc38C0800_chksum);
-
-	if (sum != _adv_asc38C0800_chksum) {
-		asc_dvc->err_code |= ASC_IERR_MCODE_CHKSUM;
+	asc_dvc->err_code = AdvLoadMicrocode(iop_base, _adv_asc38C0800_buf,
+				 _adv_asc38C0800_size, ADV_38C0800_MEMSIZE,
+				 _adv_asc38C0800_chksum);
+	if (asc_dvc->err_code)
 		return ADV_ERROR;
-	}
 
 	/*
 	 * Restore the RISC memory BIOS region.
@@ -13807,16 +13717,18 @@ static int AdvInitAsc38C0800Driver(ADV_DVC_VAR *asc_dvc)
 	}
 
 	/*
-	 * All kind of combinations of devices attached to one of four connectors
-	 * are acceptable except HVD device attached. For example, LVD device can
-	 * be attached to SE connector while SE device attached to LVD connector.
-	 * If LVD device attached to SE connector, it only runs up to Ultra speed.
+	 * All kind of combinations of devices attached to one of four
+	 * connectors are acceptable except HVD device attached. For example,
+	 * LVD device can be attached to SE connector while SE device attached
+	 * to LVD connector.  If LVD device attached to SE connector, it only
+	 * runs up to Ultra speed.
 	 *
-	 * If an HVD device is attached to one of LVD connectors, return an error.
-	 * However, there is no way to detect HVD device attached to SE connectors.
+	 * If an HVD device is attached to one of LVD connectors, return an
+	 * error.  However, there is no way to detect HVD device attached to
+	 * SE connectors.
 	 */
 	if (scsi_cfg1 & HVD) {
-		asc_dvc->err_code |= ASC_IERR_HVD_DEVICE;
+		asc_dvc->err_code = ASC_IERR_HVD_DEVICE;
 		return ADV_ERROR;
 	}
 
@@ -13825,8 +13737,8 @@ static int AdvInitAsc38C0800Driver(ADV_DVC_VAR *asc_dvc)
 	 * set the termination value based on a table listed in a_condor.h.
 	 *
 	 * If manual termination was specified with an EEPROM setting then
-	 * 'termination' was set-up in AdvInitFrom38C0800EEPROM() and is ready to
-	 * be 'ored' into SCSI_CFG1.
+	 * 'termination' was set-up in AdvInitFrom38C0800EEPROM() and is ready
+	 * to be 'ored' into SCSI_CFG1.
 	 */
 	if ((asc_dvc->cfg->termination & TERM_SE) == 0) {
 		/* SE automatic termination control is enabled. */
@@ -13872,9 +13784,9 @@ static int AdvInitAsc38C0800Driver(ADV_DVC_VAR *asc_dvc)
 	scsi_cfg1 |= (~asc_dvc->cfg->termination & 0xF0);
 
 	/*
-	 * Clear BIG_ENDIAN, DIS_TERM_DRV, Terminator Polarity and HVD/LVD/SE bits
-	 * and set possibly modified termination control bits in the Microcode
-	 * SCSI_CFG1 Register Value.
+	 * Clear BIG_ENDIAN, DIS_TERM_DRV, Terminator Polarity and HVD/LVD/SE
+	 * bits and set possibly modified termination control bits in the
+	 * Microcode SCSI_CFG1 Register Value.
 	 */
 	scsi_cfg1 &= (~BIG_ENDIAN & ~DIS_TERM_DRV & ~TERM_POL & ~HVD_LVD_SE);
 
@@ -14022,13 +13934,10 @@ static int AdvInitAsc38C1600Driver(ADV_DVC_VAR *asc_dvc)
 {
 	AdvPortAddr iop_base;
 	ushort warn_code;
-	ADV_DCNT sum;
 	int begin_addr;
 	int end_addr;
 	ushort code_sum;
 	long word;
-	int j;
-	int adv_asc38C1600_expanded_size;
 	int i;
 	ushort scsi_cfg1;
 	uchar byte;
@@ -14113,7 +14022,7 @@ static int AdvInitAsc38C1600Driver(ADV_DVC_VAR *asc_dvc)
 		byte = AdvReadByteRegister(iop_base, IOPB_RAM_BIST);
 		if ((byte & RAM_TEST_DONE) == 0
 		    || (byte & 0x0F) != PRE_TEST_VALUE) {
-			asc_dvc->err_code |= ASC_IERR_BIST_PRE_TEST;
+			asc_dvc->err_code = ASC_IERR_BIST_PRE_TEST;
 			return ADV_ERROR;
 		}
 
@@ -14121,7 +14030,7 @@ static int AdvInitAsc38C1600Driver(ADV_DVC_VAR *asc_dvc)
 		DvcSleepMilliSecond(10);	/* Wait for 10ms before reading back. */
 		if (AdvReadByteRegister(iop_base, IOPB_RAM_BIST)
 		    != NORMAL_VALUE) {
-			asc_dvc->err_code |= ASC_IERR_BIST_PRE_TEST;
+			asc_dvc->err_code = ASC_IERR_BIST_PRE_TEST;
 			return ADV_ERROR;
 		}
 	}
@@ -14140,95 +14049,18 @@ static int AdvInitAsc38C1600Driver(ADV_DVC_VAR *asc_dvc)
 	if ((byte & RAM_TEST_DONE) == 0 || (byte & RAM_TEST_STATUS) != 0) {
 		/* Get here if Done bit not set or Status not 0. */
 		asc_dvc->bist_err_code = byte;	/* for BIOS display message */
-		asc_dvc->err_code |= ASC_IERR_BIST_RAM_TEST;
+		asc_dvc->err_code = ASC_IERR_BIST_RAM_TEST;
 		return ADV_ERROR;
 	}
 
 	/* We need to reset back to normal mode after LRAM test passes. */
 	AdvWriteByteRegister(iop_base, IOPB_RAM_BIST, NORMAL_MODE);
 
-	/*
-	 * Load the Microcode
-	 *
-	 * Write the microcode image to RISC memory starting at address 0.
-	 *
-	 */
-	AdvWriteWordRegister(iop_base, IOPW_RAM_ADDR, 0);
-
-	/*
-	 * Assume the following compressed format of the microcode buffer:
-	 *
-	 *  254 word (508 byte) table indexed by byte code followed
-	 *  by the following byte codes:
-	 *
-	 *    1-Byte Code:
-	 *      00: Emit word 0 in table.
-	 *      01: Emit word 1 in table.
-	 *      .
-	 *      FD: Emit word 253 in table.
-	 *
-	 *    Multi-Byte Code:
-	 *      FE WW WW: (3 byte code) Word to emit is the next word WW WW.
-	 *      FF BB WW WW: (4 byte code) Emit BB count times next word WW WW.
-	 */
-	word = 0;
-	for (i = 253 * 2; i < _adv_asc38C1600_size; i++) {
-		if (_adv_asc38C1600_buf[i] == 0xff) {
-			for (j = 0; j < _adv_asc38C1600_buf[i + 1]; j++) {
-				AdvWriteWordAutoIncLram(iop_base, (((ushort)
-								    _adv_asc38C1600_buf
-								    [i +
-								     3] << 8) |
-								   _adv_asc38C1600_buf
-								   [i + 2]));
-				word++;
-			}
-			i += 3;
-		} else if (_adv_asc38C1600_buf[i] == 0xfe) {
-			AdvWriteWordAutoIncLram(iop_base, (((ushort)
-							    _adv_asc38C1600_buf
-							    [i +
-							     2] << 8) |
-							   _adv_asc38C1600_buf[i
-									       +
-									       1]));
-			i += 2;
-			word++;
-		} else {
-			AdvWriteWordAutoIncLram(iop_base, (((ushort)
-							    _adv_asc38C1600_buf[(_adv_asc38C1600_buf[i] * 2) + 1] << 8) | _adv_asc38C1600_buf[_adv_asc38C1600_buf[i] * 2]));
-			word++;
-		}
-	}
-
-	/*
-	 * Set 'word' for later use to clear the rest of memory and save
-	 * the expanded mcode size.
-	 */
-	word *= 2;
-	adv_asc38C1600_expanded_size = word;
-
-	/*
-	 * Clear the rest of ASC-38C1600 Internal RAM (32KB).
-	 */
-	for (; word < ADV_38C1600_MEMSIZE; word += 2) {
-		AdvWriteWordAutoIncLram(iop_base, 0);
-	}
-
-	/*
-	 * Verify the microcode checksum.
-	 */
-	sum = 0;
-	AdvWriteWordRegister(iop_base, IOPW_RAM_ADDR, 0);
-
-	for (word = 0; word < adv_asc38C1600_expanded_size; word += 2) {
-		sum += AdvReadWordAutoIncLram(iop_base);
-	}
-
-	if (sum != _adv_asc38C1600_chksum) {
-		asc_dvc->err_code |= ASC_IERR_MCODE_CHKSUM;
+	asc_dvc->err_code = AdvLoadMicrocode(iop_base, _adv_asc38C1600_buf,
+				 _adv_asc38C1600_size, ADV_38C1600_MEMSIZE,
+				 _adv_asc38C1600_chksum);
+	if (asc_dvc->err_code)
 		return ADV_ERROR;
-	}
 
 	/*
 	 * Restore the RISC memory BIOS region.
-- 
1.5.2.4

