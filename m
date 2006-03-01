From: Jamie Wellnitz <Jamie.Wellnitz@emulex.com>
Subject: [PATCH 1/9] lpfc 8.1.3: Derive supported speeds from LMT field in the READ_CONFIG
Date: Tue, 28 Feb 2006 22:33:04 -0500
Message-ID: <20060301033304.GA21457@shrimp.ma.emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from shrimp.ma.emulex.com ([138.239.78.42]:36304 "EHLO
	shrimp.ma.emulex.com") by vger.kernel.org with ESMTP
	id S1750777AbWCADdG (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 28 Feb 2006 22:33:06 -0500
Received: from shrimp.ma.emulex.com (localhost.localdomain [127.0.0.1])
	by shrimp.ma.emulex.com (8.13.4/8.13.4) with ESMTP id k213X4VE021466
	for <linux-scsi@vger.kernel.org>; Tue, 28 Feb 2006 22:33:04 -0500
Received: (from jamesw@localhost)
	by shrimp.ma.emulex.com (8.13.4/8.13.4/Submit) id k213X4TD021462
	for linux-scsi@vger.kernel.org; Tue, 28 Feb 2006 22:33:04 -0500
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Derive supported speeds from LMT field in the READ_CONFIG

Driver was keying off internal cores. Use what the firmware reports instead.

Signed-off-by: Jamie Wellnitz <Jamie.Wellnitz@emulex.com>

--- a/drivers/scsi/lpfc/lpfc_init.c
+++ b/drivers/scsi/lpfc/lpfc_init.c
@@ -42,7 +42,7 @@
 #include "lpfc_crtn.h"
 #include "lpfc_version.h"
 
-static int lpfc_parse_vpd(struct lpfc_hba *, uint8_t *);
+static int lpfc_parse_vpd(struct lpfc_hba *, uint8_t *, int);
 static void lpfc_get_hba_model_desc(struct lpfc_hba *, uint8_t *, uint8_t *);
 static int lpfc_post_rcv_buf(struct lpfc_hba *);
 
@@ -161,9 +161,6 @@ lpfc_config_port_prep(struct lpfc_hba * 
 		memcpy(phba->RandomData, (char *)&mb->un.varWords[24],
 						sizeof (phba->RandomData));
 
-	/* Get the default values for Model Name and Description */
-	lpfc_get_hba_model_desc(phba, phba->ModelName, phba->ModelDesc);
-
 	/* Get adapter VPD information */
 	pmb->context2 = kmalloc(DMP_RSP_SIZE, GFP_KERNEL);
 	if (!pmb->context2)
@@ -182,16 +179,15 @@ lpfc_config_port_prep(struct lpfc_hba * 
 					"mbxCmd x%x DUMP VPD, mbxStatus x%x\n",
 					phba->brd_no,
 					mb->mbxCommand, mb->mbxStatus);
-			kfree(lpfc_vpd_data);
-			lpfc_vpd_data = NULL;
-			break;
+			mb->un.varDmp.word_cnt = 0;
 		}
-
+		if (mb->un.varDmp.word_cnt > DMP_VPD_SIZE - offset)
+			mb->un.varDmp.word_cnt = DMP_VPD_SIZE - offset;
 		lpfc_sli_pcimem_bcopy(pmb->context2, lpfc_vpd_data + offset,
 							mb->un.varDmp.word_cnt);
 		offset += mb->un.varDmp.word_cnt;
-	} while (mb->un.varDmp.word_cnt);
-	lpfc_parse_vpd(phba, lpfc_vpd_data);
+	} while (mb->un.varDmp.word_cnt && offset < DMP_VPD_SIZE);
+	lpfc_parse_vpd(phba, lpfc_vpd_data, offset);
 
 	kfree(lpfc_vpd_data);
 out_free_context2:
@@ -327,13 +323,22 @@ lpfc_config_port_post(struct lpfc_hba * 
 			mb->un.varRdConfig.max_xri + 1;
 
 	phba->lmt = mb->un.varRdConfig.lmt;
-	/* HBA is not 4GB capable, or HBA is not 2GB capable,
-	don't let link speed ask for it */
-	if ((((phba->lmt & LMT_4250_10bit) != LMT_4250_10bit) &&
-		(phba->cfg_link_speed > LINK_SPEED_2G)) ||
-		(((phba->lmt & LMT_2125_10bit) != LMT_2125_10bit) &&
-		(phba->cfg_link_speed > LINK_SPEED_1G))) {
-		/* Reset link speed to auto. 1G/2GB HBA cfg'd for 4G */
+
+	/* Get the default values for Model Name and Description */
+	lpfc_get_hba_model_desc(phba, phba->ModelName, phba->ModelDesc);
+
+	if ((phba->cfg_link_speed > LINK_SPEED_10G)
+	    || ((phba->cfg_link_speed == LINK_SPEED_1G)
+		&& !(phba->lmt & LMT_1Gb))
+	    || ((phba->cfg_link_speed == LINK_SPEED_2G)
+		&& !(phba->lmt & LMT_2Gb))
+	    || ((phba->cfg_link_speed == LINK_SPEED_4G)
+		&& !(phba->lmt & LMT_4Gb))
+	    || ((phba->cfg_link_speed == LINK_SPEED_8G)
+		&& !(phba->lmt & LMT_8Gb))
+	    || ((phba->cfg_link_speed == LINK_SPEED_10G)
+		&& !(phba->lmt & LMT_10Gb))) {
+		/* Reset link speed to auto */
 		lpfc_printf_log(phba,
 			KERN_WARNING,
 			LOG_LINK_EVENT,
@@ -647,7 +652,7 @@ lpfc_handle_latt_err_exit:
 /*                                                                      */
 /************************************************************************/
 static int
-lpfc_parse_vpd(struct lpfc_hba * phba, uint8_t * vpd)
+lpfc_parse_vpd(struct lpfc_hba * phba, uint8_t * vpd, int len)
 {
 	uint8_t lenlo, lenhi;
 	uint32_t Length;
@@ -666,9 +671,10 @@ lpfc_parse_vpd(struct lpfc_hba * phba, u
 			phba->brd_no,
 			(uint32_t) vpd[0], (uint32_t) vpd[1], (uint32_t) vpd[2],
 			(uint32_t) vpd[3]);
-	do {
+	while (!finished && (index < (len - 4))) {
 		switch (vpd[index]) {
 		case 0x82:
+		case 0x91:
 			index += 1;
 			lenlo = vpd[index];
 			index += 1;
@@ -684,7 +690,8 @@ lpfc_parse_vpd(struct lpfc_hba * phba, u
 			lenhi = vpd[index];
 			index += 1;
 			Length = ((((unsigned short)lenhi) << 8) + lenlo);
-
+			if (Length > len - index)
+				Length = len - index;
 			while (Length > 0) {
 			/* Look for Serial Number */
 			if ((vpd[index] == 'S') && (vpd[index+1] == 'N')) {
@@ -778,7 +785,7 @@ lpfc_parse_vpd(struct lpfc_hba * phba, u
 			index ++;
 			break;
 		}
-	} while (!finished && (index < 108));
+	}
 
 	return(1);
 }
@@ -790,124 +797,153 @@ lpfc_get_hba_model_desc(struct lpfc_hba 
 	uint16_t dev_id = phba->pcidev->device;
 	uint16_t dev_subid = phba->pcidev->subsystem_device;
 	uint8_t hdrtype = phba->pcidev->hdr_type;
-	char *model_str = "";
+	int max_speed;
+	char * ports = (hdrtype == 0x80) ? "2-port " : "";
+	struct {
+		char * name;
+		int    max_speed;
+		char * ports;
+		char * bus;
+	} m;
+
+	if (mdp && mdp[0] != '\0'
+		&& descp && descp[0] != '\0')
+		return;
+
+	if (phba->lmt & LMT_10Gb)
+		max_speed = 10;
+	else if (phba->lmt & LMT_8Gb)
+		max_speed = 8;
+	else if (phba->lmt & LMT_4Gb)
+		max_speed = 4;
+	else if (phba->lmt & LMT_2Gb)
+		max_speed = 2;
+	else
+		max_speed = 1;
 
 	vp = &phba->vpd;
 
 	switch (dev_id) {
 	case PCI_DEVICE_ID_FIREFLY:
-		model_str = "LP6000 1Gb PCI";
+		m = (typeof(m)){"LP6000", max_speed, "", "PCI"};
 		break;
 	case PCI_DEVICE_ID_SUPERFLY:
 		if (vp->rev.biuRev >= 1 && vp->rev.biuRev <= 3)
-			model_str = "LP7000 1Gb PCI";
+			m = (typeof(m)){"LP7000", max_speed, "", "PCI"};
 		else
-			model_str = "LP7000E 1Gb PCI";
+			m = (typeof(m)){"LP7000E", max_speed, "", "PCI"};
 		break;
 	case PCI_DEVICE_ID_DRAGONFLY:
-		model_str = "LP8000 1Gb PCI";
+		m = (typeof(m)){"LP8000", max_speed, "", "PCI"};
 		break;
 	case PCI_DEVICE_ID_CENTAUR:
 		if (FC_JEDEC_ID(vp->rev.biuRev) == CENTAUR_2G_JEDEC_ID)
-			model_str = "LP9002 2Gb PCI";
+			m = (typeof(m)){"LP9002", max_speed, "", "PCI"};
 		else
-			model_str = "LP9000 1Gb PCI";
+			m = (typeof(m)){"LP9000", max_speed, "", "PCI"};
 		break;
 	case PCI_DEVICE_ID_RFLY:
-		model_str = "LP952 2Gb PCI";
+		m = (typeof(m)){"LP952", max_speed, "", "PCI"};
 		break;
 	case PCI_DEVICE_ID_PEGASUS:
-		model_str = "LP9802 2Gb PCI-X";
+		m = (typeof(m)){"LP9802", max_speed, "", "PCI-X"};
 		break;
 	case PCI_DEVICE_ID_THOR:
 		if (hdrtype == 0x80)
-			model_str = "LP10000DC 2Gb 2-port PCI-X";
+			m = (typeof(m)){"LP10000DC",
+					max_speed, ports, "PCI-X"};
 		else
-			model_str = "LP10000 2Gb PCI-X";
+			m = (typeof(m)){"LP10000",
+					max_speed, ports, "PCI-X"};
 		break;
 	case PCI_DEVICE_ID_VIPER:
-		model_str = "LPX1000 10Gb PCI-X";
+		m = (typeof(m)){"LPX1000", max_speed, "", "PCI-X"};
 		break;
 	case PCI_DEVICE_ID_PFLY:
-		model_str = "LP982 2Gb PCI-X";
+		m = (typeof(m)){"LP982", max_speed, "", "PCI-X"};
 		break;
 	case PCI_DEVICE_ID_TFLY:
 		if (hdrtype == 0x80)
-			model_str = "LP1050DC 2Gb 2-port PCI-X";
+			m = (typeof(m)){"LP1050DC", max_speed, ports, "PCI-X"};
 		else
-			model_str = "LP1050 2Gb PCI-X";
+			m = (typeof(m)){"LP1050", max_speed, ports, "PCI-X"};
 		break;
 	case PCI_DEVICE_ID_HELIOS:
 		if (hdrtype == 0x80)
-			model_str = "LP11002 4Gb 2-port PCI-X2";
+			m = (typeof(m)){"LP11002", max_speed, ports, "PCI-X2"};
 		else
-			model_str = "LP11000 4Gb PCI-X2";
+			m = (typeof(m)){"LP11000", max_speed, ports, "PCI-X2"};
 		break;
 	case PCI_DEVICE_ID_HELIOS_SCSP:
-		model_str = "LP11000-SP 4Gb PCI-X2";
+		m = (typeof(m)){"LP11000-SP", max_speed, ports, "PCI-X2"};
 		break;
 	case PCI_DEVICE_ID_HELIOS_DCSP:
-		model_str = "LP11002-SP 4Gb 2-port PCI-X2";
+		m = (typeof(m)){"LP11002-SP", max_speed, ports, "PCI-X2"};
 		break;
 	case PCI_DEVICE_ID_NEPTUNE:
 		if (hdrtype == 0x80)
-			model_str = "LPe1002 4Gb 2-port";
+			m = (typeof(m)){"LPe1002", max_speed, ports, "PCIe"};
 		else
-			model_str = "LPe1000 4Gb PCIe";
+			m = (typeof(m)){"LPe1000", max_speed, ports, "PCIe"};
 		break;
 	case PCI_DEVICE_ID_NEPTUNE_SCSP:
-		model_str = "LPe1000-SP 4Gb PCIe";
+		m = (typeof(m)){"LPe1000-SP", max_speed, ports, "PCIe"};
 		break;
 	case PCI_DEVICE_ID_NEPTUNE_DCSP:
-		model_str = "LPe1002-SP 4Gb 2-port PCIe";
+		m = (typeof(m)){"LPe1002-SP", max_speed, ports, "PCIe"};
 		break;
 	case PCI_DEVICE_ID_BMID:
-		model_str = "LP1150 4Gb PCI-X2";
+		m = (typeof(m)){"LP1150", max_speed, ports, "PCI-X2"};
 		break;
 	case PCI_DEVICE_ID_BSMB:
-		model_str = "LP111 4Gb PCI-X2";
+		m = (typeof(m)){"LP111", max_speed, ports, "PCI-X2"};
 		break;
 	case PCI_DEVICE_ID_ZEPHYR:
 		if (hdrtype == 0x80)
-			model_str = "LPe11002 4Gb 2-port PCIe";
+			m = (typeof(m)){"LPe11002", max_speed, ports, "PCIe"};
 		else
-			model_str = "LPe11000 4Gb PCIe";
+			m = (typeof(m)){"LPe11000", max_speed, ports, "PCIe"};
 		break;
 	case PCI_DEVICE_ID_ZEPHYR_SCSP:
-		model_str = "LPe11000-SP 4Gb PCIe";
+		m = (typeof(m)){"LPe11000", max_speed, ports, "PCIe"};
 		break;
 	case PCI_DEVICE_ID_ZEPHYR_DCSP:
-		model_str = "LPe11002-SP 4Gb 2-port PCIe";
+		m = (typeof(m)){"LPe11002-SP", max_speed, ports, "PCIe"};
 		break;
 	case PCI_DEVICE_ID_ZMID:
-		model_str = "LPe1150 4Gb PCIe";
+		m = (typeof(m)){"LPe1150", max_speed, ports, "PCIe"};
 		break;
 	case PCI_DEVICE_ID_ZSMB:
-		model_str = "LPe111 4Gb PCIe";
+		m = (typeof(m)){"LPe111", max_speed, ports, "PCIe"};
 		break;
 	case PCI_DEVICE_ID_LP101:
-		model_str = "LP101 2Gb PCI-X";
+		m = (typeof(m)){"LP101", max_speed, ports, "PCI-X"};
 		break;
 	case PCI_DEVICE_ID_LP10000S:
-		model_str = "LP10000-S 2Gb PCI";
+		m = (typeof(m)){"LP10000-S", max_speed, ports, "PCI"};
 		break;
 	case PCI_DEVICE_ID_LP11000S:
 	case PCI_DEVICE_ID_LPE11000S:
 		switch (dev_subid) {
 		case PCI_SUBSYSTEM_ID_LP11000S:
-			model_str = "LP11002-S 4Gb PCI-X2";
+			m = (typeof(m)){"LP11000-S", max_speed,
+					ports, "PCI-X2"};
 			break;
 		case PCI_SUBSYSTEM_ID_LP11002S:
-			model_str = "LP11000-S 4Gb 2-port PCI-X2";
+			m = (typeof(m)){"LP11002-S", max_speed,
+					ports, "PCI-X2"};
 			break;
 		case PCI_SUBSYSTEM_ID_LPE11000S:
-			model_str = "LPe11002-S 4Gb PCIe";
+			m = (typeof(m)){"LPe11000-S", max_speed,
+					ports, "PCIe"};
 			break;
 		case PCI_SUBSYSTEM_ID_LPE11002S:
-			model_str = "LPe11002-S 4Gb 2-port PCIe";
+			m = (typeof(m)){"LPe11002-S", max_speed,
+					ports, "PCIe"};
 			break;
 		case PCI_SUBSYSTEM_ID_LPE11010S:
-			model_str = "LPe11010-S 4Gb 10-port PCIe";
+			m = (typeof(m)){"LPe11010-S", max_speed,
+					"10-port ", "PCIe"};
 			break;
 		default:
 			break;
@@ -916,10 +952,13 @@ lpfc_get_hba_model_desc(struct lpfc_hba 
 	default:
 		break;
 	}
-	if (mdp)
-		sscanf(model_str, "%s", mdp);
-	if (descp)
-		sprintf(descp, "Emulex %s Fibre Channel Adapter", model_str);
+
+	if (mdp && mdp[0] == '\0')
+		snprintf(mdp, 79,"%s", m.name);
+	if (descp && descp[0] == '\0')
+		snprintf(descp, 255,
+			 "Emulex %s %dGb %s%s Fibre Channel Adapter",
+			 m.name, m.max_speed, m.ports, m.bus);
 }
 
 /**************************************************/
@@ -1627,21 +1666,14 @@ lpfc_pci_probe_one(struct pci_dev *pdev,
 	lpfc_get_hba_sym_node_name(phba, fc_host_symbolic_name(host));
 
 	fc_host_supported_speeds(host) = 0;
-	switch (FC_JEDEC_ID(phba->vpd.rev.biuRev)) {
-	case VIPER_JEDEC_ID:
+	if (phba->lmt & LMT_10Gb)
 		fc_host_supported_speeds(host) |= FC_PORTSPEED_10GBIT;
-		break;
-	case HELIOS_JEDEC_ID:
+	if (phba->lmt & LMT_4Gb)
 		fc_host_supported_speeds(host) |= FC_PORTSPEED_4GBIT;
-		/* Fall through */
-	case CENTAUR_2G_JEDEC_ID:
-	case PEGASUS_JEDEC_ID:
-	case THOR_JEDEC_ID:
+	if (phba->lmt & LMT_2Gb)
 		fc_host_supported_speeds(host) |= FC_PORTSPEED_2GBIT;
-		/* Fall through */
-	default:
-		fc_host_supported_speeds(host) = FC_PORTSPEED_1GBIT;
-	}
+	if (phba->lmt & LMT_1Gb)
+		fc_host_supported_speeds(host) |= FC_PORTSPEED_1GBIT;
 
 	fc_host_maxframe_size(host) =
 		((((uint32_t) phba->fc_sparam.cmn.bbRcvSizeMsb & 0x0F) << 8) |
--- a/drivers/scsi/lpfc/lpfc_ct.c
+++ b/drivers/scsi/lpfc/lpfc_ct.c
@@ -1014,19 +1014,19 @@ lpfc_fdmi_cmd(struct lpfc_hba * phba, st
 			ae = (ATTRIBUTE_ENTRY *) ((uint8_t *) pab + size);
 			ae->ad.bits.AttrType = be16_to_cpu(SUPPORTED_SPEED);
 			ae->ad.bits.AttrLen = be16_to_cpu(FOURBYTES + 4);
-			if (FC_JEDEC_ID(vp->rev.biuRev) == VIPER_JEDEC_ID)
+
+			ae->un.SupportSpeed = 0;
+			if (phba->lmt & LMT_10Gb)
 				ae->un.SupportSpeed = HBA_PORTSPEED_10GBIT;
-			else if (FC_JEDEC_ID(vp->rev.biuRev) == HELIOS_JEDEC_ID)
-				ae->un.SupportSpeed = HBA_PORTSPEED_4GBIT;
-			else if ((FC_JEDEC_ID(vp->rev.biuRev) ==
-				  CENTAUR_2G_JEDEC_ID)
-				 || (FC_JEDEC_ID(vp->rev.biuRev) ==
-				     PEGASUS_JEDEC_ID)
-				 || (FC_JEDEC_ID(vp->rev.biuRev) ==
-				     THOR_JEDEC_ID))
-				ae->un.SupportSpeed = HBA_PORTSPEED_2GBIT;
-			else
-				ae->un.SupportSpeed = HBA_PORTSPEED_1GBIT;
+			if (phba->lmt & LMT_8Gb)
+				ae->un.SupportSpeed |= HBA_PORTSPEED_8GBIT;
+			if (phba->lmt & LMT_4Gb)
+				ae->un.SupportSpeed |= HBA_PORTSPEED_4GBIT;
+			if (phba->lmt & LMT_2Gb)
+				ae->un.SupportSpeed |= HBA_PORTSPEED_2GBIT;
+			if (phba->lmt & LMT_1Gb)
+				ae->un.SupportSpeed |= HBA_PORTSPEED_1GBIT;
+
 			pab->ab.EntryCnt++;
 			size += FOURBYTES + 4;
 
--- a/drivers/scsi/lpfc/lpfc_hw.h
+++ b/drivers/scsi/lpfc/lpfc_hw.h
@@ -1711,13 +1711,13 @@ typedef struct {
 	uint32_t rttov;
 	uint32_t altov;
 	uint32_t lmt;
-#define LMT_RESERVED    0x0    /* Not used */
-#define LMT_266_10bit   0x1    /* 265.625 Mbaud 10 bit iface  */
-#define LMT_532_10bit   0x2    /* 531.25  Mbaud 10 bit iface  */
-#define LMT_1063_20bit  0x3    /* 1062.5   Mbaud 20 bit iface */
-#define LMT_1063_10bit  0x4    /* 1062.5   Mbaud 10 bit iface */
-#define LMT_2125_10bit  0x8    /* 2125     Mbaud 10 bit iface */
-#define LMT_4250_10bit  0x40   /* 4250     Mbaud 10 bit iface */
+#define LMT_RESERVED  0x000    /* Not used */
+#define LMT_1Gb       0x004
+#define LMT_2Gb       0x008
+#define LMT_4Gb       0x040
+#define LMT_8Gb       0x080
+#define LMT_10Gb      0x100
+
 
 	uint32_t rsvd2;
 	uint32_t rsvd3;
