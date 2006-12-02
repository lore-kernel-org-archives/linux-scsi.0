From: James Smart <James.Smart@Emulex.Com>
Subject: [PATCH 6/9] lpfc 8.1.11 :  Removed decoding of PCI Subsystem Id
Date: Sat, 02 Dec 2006 13:35:08 -0500
Message-ID: <1165084508.27443.27.camel@localhost.localdomain>
Reply-To: James.Smart@Emulex.Com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:57047 "EHLO
	emulex.emulex.com") by vger.kernel.org with ESMTP id S1759468AbWLBQHH
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 2 Dec 2006 11:07:07 -0500
Received: from xbl3.ad.emulex.com (xbl3.ma.emulex.com [138.239.73.12])
	by emulex.emulex.com (8.13.6/8.13.6) with ESMTP id kB2G71an009324
	for <linux-scsi@vger.kernel.org>; Sat, 2 Dec 2006 08:07:06 -0800 (PST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Removed decoding of PCI Subsystem Id.
  To avoid continually updating the driver for new subsystem ids
  (as adapter modules are proliferating), remove this 2nd level decode.
  Genericize the reported Adapter names to be consistent across
  Emulex product line.
 

Signed-off-by: James Smart <James.Smart@emulex.com>


diff -upNr a/drivers/scsi/lpfc/lpfc_hw.h b/drivers/scsi/lpfc/lpfc_hw.h
--- a/drivers/scsi/lpfc/lpfc_hw.h	2006-12-02 11:57:07.000000000 -0500
+++ b/drivers/scsi/lpfc/lpfc_hw.h	2006-12-02 12:23:02.000000000 -0500
@@ -1105,12 +1105,6 @@ typedef struct {
 #define PCI_DEVICE_ID_ZEPHYR_SCSP   0xfe11
 #define PCI_DEVICE_ID_ZEPHYR_DCSP   0xfe12
 
-#define PCI_SUBSYSTEM_ID_LP11000S      0xfc11
-#define PCI_SUBSYSTEM_ID_LP11002S      0xfc12
-#define PCI_SUBSYSTEM_ID_LPE11000S     0xfc21
-#define PCI_SUBSYSTEM_ID_LPE11002S     0xfc22
-#define PCI_SUBSYSTEM_ID_LPE11010S     0xfc2A
-
 #define JEDEC_ID_ADDRESS            0x0080001c
 #define FIREFLY_JEDEC_ID            0x1ACC
 #define SUPERFLY_JEDEC_ID           0x0020
diff -upNr a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
--- a/drivers/scsi/lpfc/lpfc_init.c	2006-12-02 12:13:17.000000000 -0500
+++ b/drivers/scsi/lpfc/lpfc_init.c	2006-12-02 12:23:02.000000000 -0500
@@ -804,19 +804,13 @@ lpfc_get_hba_model_desc(struct lpfc_hba 
 {
 	lpfc_vpd_t *vp;
 	uint16_t dev_id = phba->pcidev->device;
-	uint16_t dev_subid = phba->pcidev->subsystem_device;
-	uint8_t hdrtype;
 	int max_speed;
-	char * ports;
 	struct {
 		char * name;
 		int    max_speed;
-		char * ports;
 		char * bus;
-	} m = {"<Unknown>", 0, "", ""};
+	} m = {"<Unknown>", 0, ""};
 
-	pci_read_config_byte(phba->pcidev, PCI_HEADER_TYPE, &hdrtype);
-	ports = (hdrtype == 0x80) ? "2-port " : "";
 	if (mdp && mdp[0] != '\0'
 		&& descp && descp[0] != '\0')
 		return;
@@ -836,130 +830,93 @@ lpfc_get_hba_model_desc(struct lpfc_hba 
 
 	switch (dev_id) {
 	case PCI_DEVICE_ID_FIREFLY:
-		m = (typeof(m)){"LP6000", max_speed, "", "PCI"};
+		m = (typeof(m)){"LP6000", max_speed, "PCI"};
 		break;
 	case PCI_DEVICE_ID_SUPERFLY:
 		if (vp->rev.biuRev >= 1 && vp->rev.biuRev <= 3)
-			m = (typeof(m)){"LP7000", max_speed, "", "PCI"};
+			m = (typeof(m)){"LP7000", max_speed,  "PCI"};
 		else
-			m = (typeof(m)){"LP7000E", max_speed, "", "PCI"};
+			m = (typeof(m)){"LP7000E", max_speed, "PCI"};
 		break;
 	case PCI_DEVICE_ID_DRAGONFLY:
-		m = (typeof(m)){"LP8000", max_speed, "", "PCI"};
+		m = (typeof(m)){"LP8000", max_speed, "PCI"};
 		break;
 	case PCI_DEVICE_ID_CENTAUR:
 		if (FC_JEDEC_ID(vp->rev.biuRev) == CENTAUR_2G_JEDEC_ID)
-			m = (typeof(m)){"LP9002", max_speed, "", "PCI"};
+			m = (typeof(m)){"LP9002", max_speed, "PCI"};
 		else
-			m = (typeof(m)){"LP9000", max_speed, "", "PCI"};
+			m = (typeof(m)){"LP9000", max_speed, "PCI"};
 		break;
 	case PCI_DEVICE_ID_RFLY:
-		m = (typeof(m)){"LP952", max_speed, "", "PCI"};
+		m = (typeof(m)){"LP952", max_speed, "PCI"};
 		break;
 	case PCI_DEVICE_ID_PEGASUS:
-		m = (typeof(m)){"LP9802", max_speed, "", "PCI-X"};
+		m = (typeof(m)){"LP9802", max_speed, "PCI-X"};
 		break;
 	case PCI_DEVICE_ID_THOR:
-		if (hdrtype == 0x80)
-			m = (typeof(m)){"LP10000DC",
-					max_speed, ports, "PCI-X"};
-		else
-			m = (typeof(m)){"LP10000",
-					max_speed, ports, "PCI-X"};
+		m = (typeof(m)){"LP10000", max_speed, "PCI-X"};
 		break;
 	case PCI_DEVICE_ID_VIPER:
-		m = (typeof(m)){"LPX1000", max_speed, "", "PCI-X"};
+		m = (typeof(m)){"LPX1000", max_speed,  "PCI-X"};
 		break;
 	case PCI_DEVICE_ID_PFLY:
-		m = (typeof(m)){"LP982", max_speed, "", "PCI-X"};
+		m = (typeof(m)){"LP982", max_speed, "PCI-X"};
 		break;
 	case PCI_DEVICE_ID_TFLY:
-		if (hdrtype == 0x80)
-			m = (typeof(m)){"LP1050DC", max_speed, ports, "PCI-X"};
-		else
-			m = (typeof(m)){"LP1050", max_speed, ports, "PCI-X"};
+		m = (typeof(m)){"LP1050", max_speed, "PCI-X"};
 		break;
 	case PCI_DEVICE_ID_HELIOS:
-		if (hdrtype == 0x80)
-			m = (typeof(m)){"LP11002", max_speed, ports, "PCI-X2"};
-		else
-			m = (typeof(m)){"LP11000", max_speed, ports, "PCI-X2"};
+		m = (typeof(m)){"LP11000", max_speed, "PCI-X2"};
 		break;
 	case PCI_DEVICE_ID_HELIOS_SCSP:
-		m = (typeof(m)){"LP11000-SP", max_speed, ports, "PCI-X2"};
+		m = (typeof(m)){"LP11000-SP", max_speed, "PCI-X2"};
 		break;
 	case PCI_DEVICE_ID_HELIOS_DCSP:
-		m = (typeof(m)){"LP11002-SP", max_speed, ports, "PCI-X2"};
+		m = (typeof(m)){"LP11002-SP", max_speed, "PCI-X2"};
 		break;
 	case PCI_DEVICE_ID_NEPTUNE:
-		if (hdrtype == 0x80)
-			m = (typeof(m)){"LPe1002", max_speed, ports, "PCIe"};
-		else
-			m = (typeof(m)){"LPe1000", max_speed, ports, "PCIe"};
+		m = (typeof(m)){"LPe1000", max_speed, "PCIe"};
 		break;
 	case PCI_DEVICE_ID_NEPTUNE_SCSP:
-		m = (typeof(m)){"LPe1000-SP", max_speed, ports, "PCIe"};
+		m = (typeof(m)){"LPe1000-SP", max_speed, "PCIe"};
 		break;
 	case PCI_DEVICE_ID_NEPTUNE_DCSP:
-		m = (typeof(m)){"LPe1002-SP", max_speed, ports, "PCIe"};
+		m = (typeof(m)){"LPe1002-SP", max_speed, "PCIe"};
 		break;
 	case PCI_DEVICE_ID_BMID:
-		m = (typeof(m)){"LP1150", max_speed, ports, "PCI-X2"};
+		m = (typeof(m)){"LP1150", max_speed, "PCI-X2"};
 		break;
 	case PCI_DEVICE_ID_BSMB:
-		m = (typeof(m)){"LP111", max_speed, ports, "PCI-X2"};
+		m = (typeof(m)){"LP111", max_speed, "PCI-X2"};
 		break;
 	case PCI_DEVICE_ID_ZEPHYR:
-		if (hdrtype == 0x80)
-			m = (typeof(m)){"LPe11002", max_speed, ports, "PCIe"};
-		else
-			m = (typeof(m)){"LPe11000", max_speed, ports, "PCIe"};
+		m = (typeof(m)){"LPe11000", max_speed, "PCIe"};
 		break;
 	case PCI_DEVICE_ID_ZEPHYR_SCSP:
-		m = (typeof(m)){"LPe11000", max_speed, ports, "PCIe"};
+		m = (typeof(m)){"LPe11000", max_speed, "PCIe"};
 		break;
 	case PCI_DEVICE_ID_ZEPHYR_DCSP:
-		m = (typeof(m)){"LPe11002-SP", max_speed, ports, "PCIe"};
+		m = (typeof(m)){"LPe11002-SP", max_speed, "PCIe"};
 		break;
 	case PCI_DEVICE_ID_ZMID:
-		m = (typeof(m)){"LPe1150", max_speed, ports, "PCIe"};
+		m = (typeof(m)){"LPe1150", max_speed, "PCIe"};
 		break;
 	case PCI_DEVICE_ID_ZSMB:
-		m = (typeof(m)){"LPe111", max_speed, ports, "PCIe"};
+		m = (typeof(m)){"LPe111", max_speed, "PCIe"};
 		break;
 	case PCI_DEVICE_ID_LP101:
-		m = (typeof(m)){"LP101", max_speed, ports, "PCI-X"};
+		m = (typeof(m)){"LP101", max_speed, "PCI-X"};
 		break;
 	case PCI_DEVICE_ID_LP10000S:
-		m = (typeof(m)){"LP10000-S", max_speed, ports, "PCI"};
+		m = (typeof(m)){"LP10000-S", max_speed, "PCI"};
 		break;
 	case PCI_DEVICE_ID_LP11000S:
+		m = (typeof(m)){"LP11000-S", max_speed,
+			"PCI-X2"};
+		break;
 	case PCI_DEVICE_ID_LPE11000S:
-		switch (dev_subid) {
-		case PCI_SUBSYSTEM_ID_LP11000S:
-			m = (typeof(m)){"LP11000-S", max_speed,
-					ports, "PCI-X2"};
-			break;
-		case PCI_SUBSYSTEM_ID_LP11002S:
-			m = (typeof(m)){"LP11002-S", max_speed,
-					ports, "PCI-X2"};
-			break;
-		case PCI_SUBSYSTEM_ID_LPE11000S:
-			m = (typeof(m)){"LPe11000-S", max_speed,
-					ports, "PCIe"};
-			break;
-		case PCI_SUBSYSTEM_ID_LPE11002S:
-			m = (typeof(m)){"LPe11002-S", max_speed,
-					ports, "PCIe"};
-			break;
-		case PCI_SUBSYSTEM_ID_LPE11010S:
-			m = (typeof(m)){"LPe11010-S", max_speed,
-					"10-port ", "PCIe"};
-			break;
-		default:
-			m = (typeof(m)){ NULL };
-			break;
-		}
+		m = (typeof(m)){"LPe11000-S", max_speed,
+			"PCIe"};
 		break;
 	default:
 		m = (typeof(m)){ NULL };
@@ -970,8 +927,8 @@ lpfc_get_hba_model_desc(struct lpfc_hba 
 		snprintf(mdp, 79,"%s", m.name);
 	if (descp && descp[0] == '\0')
 		snprintf(descp, 255,
-			 "Emulex %s %dGb %s%s Fibre Channel Adapter",
-			 m.name, m.max_speed, m.ports, m.bus);
+			 "Emulex %s %dGb %s Fibre Channel Adapter",
+			 m.name, m.max_speed, m.bus);
 }
 
 /**************************************************/


