From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 11/12] advansys: cleanup function return codes
Date: Wed,  3 Dec 2014 12:45:04 +0100
Message-ID: <1417607105-85455-12-git-send-email-hare@suse.de>
References: <1417607105-85455-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:55203 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753641AbaLCLpO (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 3 Dec 2014 06:45:14 -0500
In-Reply-To: <1417607105-85455-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <jbottomley@parallels.com>
Cc: Christoph Hellwig <hch@lst.de>, Matthew Wilcox <matthew@wil.cx>, Doug Gilbert <dgilbert@interlog.com>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/scsi/advansys.c | 34 +++++++++++++---------------------
 1 file changed, 13 insertions(+), 21 deletions(-)

diff --git a/drivers/scsi/advansys.c b/drivers/scsi/advansys.c
index 14a4571..bd44d1b 100644
--- a/drivers/scsi/advansys.c
+++ b/drivers/scsi/advansys.c
@@ -3998,15 +3998,13 @@ static u32 AscMemSumLramWord(PortAddr iop_base, ushort s_addr, int words)
 	return (sum);
 }
 
-static ushort AscInitLram(ASC_DVC_VAR *asc_dvc)
+static void AscInitLram(ASC_DVC_VAR *asc_dvc)
 {
 	uchar i;
 	ushort s_addr;
 	PortAddr iop_base;
-	ushort warn_code;
 
 	iop_base = asc_dvc->iop_base;
-	warn_code = 0;
 	AscMemWordSetLram(iop_base, ASC_QADR_BEG, 0,
 			  (ushort)(((int)(asc_dvc->max_total_qng + 2 + 1) *
 				    64) >> 1));
@@ -4045,7 +4043,6 @@ static ushort AscInitLram(ASC_DVC_VAR *asc_dvc)
 		AscWriteLramByte(iop_base,
 				 (ushort)(s_addr + (ushort)ASC_SCSIQ_B_QNO), i);
 	}
-	return warn_code;
 }
 
 static u32
@@ -4104,10 +4101,10 @@ static void AscInitQLinkVar(ASC_DVC_VAR *asc_dvc)
 	}
 }
 
-static ushort AscInitMicroCodeVar(ASC_DVC_VAR *asc_dvc)
+static int AscInitMicroCodeVar(ASC_DVC_VAR *asc_dvc)
 {
 	int i;
-	ushort warn_code;
+	int warn_code;
 	PortAddr iop_base;
 	__le32 phy_addr;
 	__le32 phy_size;
@@ -4149,12 +4146,12 @@ static ushort AscInitMicroCodeVar(ASC_DVC_VAR *asc_dvc)
 	AscSetPCAddr(iop_base, ASC_MCODE_START_ADDR);
 	if (AscGetPCAddr(iop_base) != ASC_MCODE_START_ADDR) {
 		asc_dvc->err_code |= ASC_IERR_SET_PC_ADDR;
-		warn_code = UW_ERR;
+		warn_code = -EINVAL;
 		goto err_mcode_start;
 	}
 	if (AscStartChip(iop_base) != 1) {
 		asc_dvc->err_code |= ASC_IERR_START_STOP_CHIP;
-		warn_code = UW_ERR;
+		warn_code = -EIO;
 		goto err_mcode_start;
 	}
 
@@ -4168,13 +4165,13 @@ err_dma_map:
 	return warn_code;
 }
 
-static ushort AscInitAsc1000Driver(ASC_DVC_VAR *asc_dvc)
+static int AscInitAsc1000Driver(ASC_DVC_VAR *asc_dvc)
 {
 	const struct firmware *fw;
 	const char fwname[] = "advansys/mcode.bin";
 	int err;
 	unsigned long chksum;
-	ushort warn_code;
+	int warn_code;
 	PortAddr iop_base;
 
 	iop_base = asc_dvc->iop_base;
@@ -4186,15 +4183,13 @@ static ushort AscInitAsc1000Driver(ASC_DVC_VAR *asc_dvc)
 	}
 	asc_dvc->init_state |= ASC_INIT_STATE_BEG_LOAD_MC;
 	if (asc_dvc->err_code != 0)
-		return UW_ERR;
+		return ASC_ERROR;
 	if (!AscFindSignature(asc_dvc->iop_base)) {
 		asc_dvc->err_code = ASC_IERR_BAD_SIGNATURE;
 		return warn_code;
 	}
 	AscDisableInterrupt(iop_base);
-	warn_code |= AscInitLram(asc_dvc);
-	if (asc_dvc->err_code != 0)
-		return UW_ERR;
+	AscInitLram(asc_dvc);
 
 	err = request_firmware(&fw, fwname, asc_dvc->drv_ptr->dev);
 	if (err) {
@@ -9065,15 +9060,13 @@ static uchar AscSetIsaDmaSpeed(PortAddr iop_base, uchar speed_value)
 }
 #endif /* CONFIG_ISA */
 
-static ushort AscInitAscDvcVar(ASC_DVC_VAR *asc_dvc)
+static void AscInitAscDvcVar(ASC_DVC_VAR *asc_dvc)
 {
 	int i;
 	PortAddr iop_base;
-	ushort warn_code;
 	uchar chip_version;
 
 	iop_base = asc_dvc->iop_base;
-	warn_code = 0;
 	asc_dvc->err_code = 0;
 	if ((asc_dvc->bus_type &
 	     (ASC_IS_ISA | ASC_IS_PCI | ASC_IS_EISA | ASC_IS_VL)) == 0) {
@@ -9149,7 +9142,6 @@ static ushort AscInitAscDvcVar(ASC_DVC_VAR *asc_dvc)
 		asc_dvc->scsiq_busy_tail[i] = (ASC_SCSI_Q *)0L;
 		asc_dvc->cfg->max_tag_qng[i] = ASC_MAX_INRAM_TAG_QNG;
 	}
-	return warn_code;
 }
 
 static int AscWriteEEPCmdReg(PortAddr iop_base, uchar cmd_reg)
@@ -9415,7 +9407,7 @@ static int AscSetEEPConfig(PortAddr iop_base, ASCEEP_CONFIG *cfg_buf,
 	return n_error;
 }
 
-static ushort AscInitFromEEP(ASC_DVC_VAR *asc_dvc)
+static int AscInitFromEEP(ASC_DVC_VAR *asc_dvc)
 {
 	ASCEEP_CONFIG eep_config_buf;
 	ASCEEP_CONFIG *eep_config;
@@ -9591,8 +9583,8 @@ static int AscInitGetConfig(struct Scsi_Host *shost)
 		return asc_dvc->err_code;
 
 	if (AscFindSignature(asc_dvc->iop_base)) {
-		warn_code |= AscInitAscDvcVar(asc_dvc);
-		warn_code |= AscInitFromEEP(asc_dvc);
+		AscInitAscDvcVar(asc_dvc);
+		warn_code = AscInitFromEEP(asc_dvc);
 		asc_dvc->init_state |= ASC_INIT_STATE_END_GET_CFG;
 		if (asc_dvc->scsi_reset_wait > ASC_MAX_SCSI_RESET_WAIT)
 			asc_dvc->scsi_reset_wait = ASC_MAX_SCSI_RESET_WAIT;
-- 
1.8.5.2

