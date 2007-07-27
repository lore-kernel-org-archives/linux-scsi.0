From: Matthew Wilcox <matthew@wil.cx>
Subject: [PATCH 20/24] advansys: use memcpy instead of open-coded loop
Date: Fri, 27 Jul 2007 07:42:29 -0600
Message-ID: <11855437533847-git-send-email-matthew@wil.cx>
References: <20070727134038.GC21219@parisc-linux.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.tor.primus.ca ([216.254.136.21]:50075 "EHLO
	smtp-06.primus.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933653AbXG0Nmi (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 27 Jul 2007 09:42:38 -0400
In-Reply-To: <20070727134038.GC21219@parisc-linux.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Matthew Wilcox <matthew@wil.cx>

Use memcpy to initialise eep_config instead of a loop.  For
AdvInitFrom38C1600EEP where we need to modify the default EEPROM
configuration, do it after the loop, and do it using the structure
definition, not by finding the right byte.  I think it was wrong for
big-endian machines.

Also delete some non-useful comments and prototypes.

Signed-off-by: Matthew Wilcox <matthew@wil.cx>
---
 drivers/scsi/advansys.c |  119 ++++++++++++++++-------------------------------
 1 files changed, 40 insertions(+), 79 deletions(-)

diff --git a/drivers/scsi/advansys.c b/drivers/scsi/advansys.c
index e13287b..12e714a 100644
--- a/drivers/scsi/advansys.c
+++ b/drivers/scsi/advansys.c
@@ -3181,13 +3181,6 @@ do { \
 #define QHSTA_M_SGBACKUP_ERROR      0x47	/* Scatter-Gather backup error */
 
 /*
- * Default EEPROM Configuration structure defined in a_init.c.
- */
-static ADVEEP_3550_CONFIG Default_3550_EEPROM_Config;
-static ADVEEP_38C0800_CONFIG Default_38C0800_EEPROM_Config;
-static ADVEEP_38C1600_CONFIG Default_38C1600_EEPROM_Config;
-
-/*
  * DvcGetPhyAddr() flag arguments
  */
 #define ADV_IS_SCSIQ_FLAG       0x01	/* 'addr' is ASC_SCSI_REQ_Q pointer */
@@ -13341,7 +13334,6 @@ static unsigned char _adv_asc38C1600_buf[] = {
 static unsigned short _adv_asc38C1600_size = sizeof(_adv_asc38C1600_buf);	/* 0x1673 */
 static ADV_DCNT _adv_asc38C1600_chksum = 0x0604EF77UL;	/* Expanded little-endian checksum. */
 
-/* a_init.c */
 /*
  * EEPROM Configuration.
  *
@@ -15601,7 +15593,6 @@ static int __devinit AdvInitFrom3550EEP(ADV_DVC_VAR *asc_dvc)
 	AdvPortAddr iop_base;
 	ushort warn_code;
 	ADVEEP_3550_CONFIG eep_config;
-	int i;
 
 	iop_base = asc_dvc->iop_base;
 
@@ -15618,15 +15609,12 @@ static int __devinit AdvInitFrom3550EEP(ADV_DVC_VAR *asc_dvc)
 		/*
 		 * Set EEPROM default values.
 		 */
-		for (i = 0; i < sizeof(ADVEEP_3550_CONFIG); i++) {
-			*((uchar *)&eep_config + i) =
-			    *((uchar *)&Default_3550_EEPROM_Config + i);
-		}
+		memcpy(&eep_config, &Default_3550_EEPROM_Config,
+			sizeof(ADVEEP_3550_CONFIG));
 
 		/*
-		 * Assume the 6 byte board serial number that was read
-		 * from EEPROM is correct even if the EEPROM checksum
-		 * failed.
+		 * Assume the 6 byte board serial number that was read from
+		 * EEPROM is correct even if the EEPROM checksum failed.
 		 */
 		eep_config.serial_number_word3 =
 		    AdvReadEEPWord(iop_base, ADV_EEP_DVC_CFG_END - 1);
@@ -15755,7 +15743,6 @@ static int __devinit AdvInitFrom38C0800EEP(ADV_DVC_VAR *asc_dvc)
 	AdvPortAddr iop_base;
 	ushort warn_code;
 	ADVEEP_38C0800_CONFIG eep_config;
-	int i;
 	uchar tid, termination;
 	ushort sdtr_speed = 0;
 
@@ -15775,15 +15762,12 @@ static int __devinit AdvInitFrom38C0800EEP(ADV_DVC_VAR *asc_dvc)
 		/*
 		 * Set EEPROM default values.
 		 */
-		for (i = 0; i < sizeof(ADVEEP_38C0800_CONFIG); i++) {
-			*((uchar *)&eep_config + i) =
-			    *((uchar *)&Default_38C0800_EEPROM_Config + i);
-		}
+		memcpy(&eep_config, &Default_38C0800_EEPROM_Config,
+			sizeof(ADVEEP_38C0800_CONFIG));
 
 		/*
-		 * Assume the 6 byte board serial number that was read
-		 * from EEPROM is correct even if the EEPROM checksum
-		 * failed.
+		 * Assume the 6 byte board serial number that was read from
+		 * EEPROM is correct even if the EEPROM checksum failed.
 		 */
 		eep_config.serial_number_word3 =
 		    AdvReadEEPWord(iop_base, ADV_EEP_DVC_CFG_END - 1);
@@ -15958,7 +15942,6 @@ static int __devinit AdvInitFrom38C1600EEP(ADV_DVC_VAR *asc_dvc)
 	AdvPortAddr iop_base;
 	ushort warn_code;
 	ADVEEP_38C1600_CONFIG eep_config;
-	int i;
 	uchar tid, termination;
 	ushort sdtr_speed = 0;
 
@@ -15979,68 +15962,46 @@ static int __devinit AdvInitFrom38C1600EEP(ADV_DVC_VAR *asc_dvc)
 		/*
 		 * Set EEPROM default values.
 		 */
-		for (i = 0; i < sizeof(ADVEEP_38C1600_CONFIG); i++) {
-			if (i == 1 && PCI_FUNC(pdev->devfn) != 0) {
-				/*
-				 * Set Function 1 EEPROM Word 0 MSB
-				 *
-				 * Clear the BIOS_ENABLE (bit 14) and INTAB (bit 11)
-				 * EEPROM bits.
-				 *
-				 * Disable Bit 14 (BIOS_ENABLE) to fix SPARC Ultra 60 and
-				 * old Mac system booting problem. The Expansion ROM must
-				 * be disabled in Function 1 for these systems.
-				 *
-				 */
-				*((uchar *)&eep_config + i) =
-				    ((*
-				      ((uchar *)&Default_38C1600_EEPROM_Config
-				       +
-				       i)) &
-				     (~
-				      (((ADV_EEPROM_BIOS_ENABLE |
-					 ADV_EEPROM_INTAB) >> 8) & 0xFF)));
+		memcpy(&eep_config, &Default_38C1600_EEPROM_Config,
+			sizeof(ADVEEP_38C1600_CONFIG));
 
-				/*
-				 * Set the INTAB (bit 11) if the GPIO 0 input indicates
-				 * the Function 1 interrupt line is wired to INTA.
-				 *
-				 * Set/Clear Bit 11 (INTAB) from the GPIO bit 0 input:
-				 *   1 - Function 1 interrupt line wired to INT A.
-				 *   0 - Function 1 interrupt line wired to INT B.
-				 *
-				 * Note: Adapter boards always have Function 0 wired to INTA.
-				 * Put all 5 GPIO bits in input mode and then read
-				 * their input values.
-				 */
-				AdvWriteByteRegister(iop_base, IOPB_GPIO_CNTL,
-						     0);
-				if (AdvReadByteRegister
-				    (iop_base, IOPB_GPIO_DATA) & 0x01) {
-					/* Function 1 interrupt wired to INTA; Set EEPROM bit. */
-					*((uchar *)&eep_config + i) |=
-					    ((ADV_EEPROM_INTAB >> 8) & 0xFF);
-				}
-			} else {
-				*((uchar *)&eep_config + i) =
-				    *((uchar *)&Default_38C1600_EEPROM_Config
-				      + i);
-			}
+		if (PCI_FUNC(pdev->devfn) != 0) {
+			u8 ints;
+			/*
+			 * Disable Bit 14 (BIOS_ENABLE) to fix SPARC Ultra 60
+			 * and old Mac system booting problem. The Expansion
+			 * ROM must be disabled in Function 1 for these systems
+			 */
+			eep_config.cfg_lsw &= ~ADV_EEPROM_BIOS_ENABLE;
+			/*
+			 * Clear the INTAB (bit 11) if the GPIO 0 input
+			 * indicates the Function 1 interrupt line is wired
+			 * to INTB.
+			 *
+			 * Set/Clear Bit 11 (INTAB) from the GPIO bit 0 input:
+			 *   1 - Function 1 interrupt line wired to INT A.
+			 *   0 - Function 1 interrupt line wired to INT B.
+			 *
+			 * Note: Function 0 is always wired to INTA.
+			 * Put all 5 GPIO bits in input mode and then read
+			 * their input values.
+			 */
+			AdvWriteByteRegister(iop_base, IOPB_GPIO_CNTL, 0);
+			ints = AdvReadByteRegister(iop_base, IOPB_GPIO_DATA);
+			if ((ints & 0x01) == 0)
+				eep_config.cfg_lsw &= ~ADV_EEPROM_INTAB;
 		}
 
 		/*
-		 * Assume the 6 byte board serial number that was read
-		 * from EEPROM is correct even if the EEPROM checksum
-		 * failed.
+		 * Assume the 6 byte board serial number that was read from
+		 * EEPROM is correct even if the EEPROM checksum failed.
 		 */
 		eep_config.serial_number_word3 =
-		    AdvReadEEPWord(iop_base, ADV_EEP_DVC_CFG_END - 1);
-
+			AdvReadEEPWord(iop_base, ADV_EEP_DVC_CFG_END - 1);
 		eep_config.serial_number_word2 =
-		    AdvReadEEPWord(iop_base, ADV_EEP_DVC_CFG_END - 2);
-
+			AdvReadEEPWord(iop_base, ADV_EEP_DVC_CFG_END - 2);
 		eep_config.serial_number_word1 =
-		    AdvReadEEPWord(iop_base, ADV_EEP_DVC_CFG_END - 3);
+			AdvReadEEPWord(iop_base, ADV_EEP_DVC_CFG_END - 3);
 
 		AdvSet38C1600EEPConfig(iop_base, &eep_config);
 	}
-- 
1.4.4.4

