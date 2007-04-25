From: James Smart <James.Smart@Emulex.Com>
Subject: [PATCH 14/16] lpfc 8.1.12 : Added support for 8G speed and new HBAs
Date: Wed, 25 Apr 2007 09:53:28 -0400
Message-ID: <1177509208.23155.21.camel@localhost.localdomain>
Reply-To: James.Smart@Emulex.Com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:51778 "EHLO
	emulex.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031052AbXDYNxU (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 25 Apr 2007 09:53:20 -0400
Received: from xbl3.ad.emulex.com (xbl3.ma.emulex.com [138.239.73.12])
	by emulex.emulex.com (8.13.6/8.13.6) with ESMTP id l3PDrJfS006718
	for <linux-scsi@vger.kernel.org>; Wed, 25 Apr 2007 06:53:19 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Added support for 8G speed and new HBAs.

Signed-off-by: James Smart <James.Smart@emulex.com>


diff -upNr a/drivers/scsi/lpfc/lpfc_attr.c b/drivers/scsi/lpfc/lpfc_attr.c
--- a/drivers/scsi/lpfc/lpfc_attr.c	2007-04-24 11:12:42.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_attr.c	2007-04-24 11:12:43.000000000 -0400
@@ -985,9 +985,10 @@ LPFC_ATTR_RW(topology, 0, 0, 6, "Select 
 #       1  = 1 Gigabaud
 #       2  = 2 Gigabaud
 #       4  = 4 Gigabaud
-# Value range is [0,4]. Default value is 0.
+#       8  = 8 Gigabaud
+# Value range is [0,8]. Default value is 0.
 */
-LPFC_ATTR_R(link_speed, 0, 0, 4, "Select link speed");
+LPFC_ATTR_R(link_speed, 0, 0, 8, "Select link speed");
 
 /*
 # lpfc_fcp_class:  Determines FC class to use for the FCP protocol.
@@ -1559,6 +1560,9 @@ lpfc_get_host_speed(struct Scsi_Host *sh
 			case LA_4GHZ_LINK:
 				fc_host_speed(shost) = FC_PORTSPEED_4GBIT;
 			break;
+			case LA_8GHZ_LINK:
+				fc_host_speed(shost) = FC_PORTSPEED_8GBIT;
+			break;
 			default:
 				fc_host_speed(shost) = FC_PORTSPEED_UNKNOWN;
 			break;
diff -upNr a/drivers/scsi/lpfc/lpfc_ct.c b/drivers/scsi/lpfc/lpfc_ct.c
--- a/drivers/scsi/lpfc/lpfc_ct.c	2007-04-24 11:12:42.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_ct.c	2007-04-24 11:12:43.000000000 -0400
@@ -1038,6 +1038,9 @@ lpfc_fdmi_cmd(struct lpfc_hba * phba, st
 				case LA_4GHZ_LINK:
 					ae->un.PortSpeed = HBA_PORTSPEED_4GBIT;
 				break;
+				case LA_8GHZ_LINK:
+					ae->un.PortSpeed = HBA_PORTSPEED_8GBIT;
+				break;
 				default:
 					ae->un.PortSpeed =
 						HBA_PORTSPEED_UNKNOWN;
diff -upNr a/drivers/scsi/lpfc/lpfc_hbadisc.c b/drivers/scsi/lpfc/lpfc_hbadisc.c
--- a/drivers/scsi/lpfc/lpfc_hbadisc.c	2007-04-24 11:12:42.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_hbadisc.c	2007-04-24 11:12:43.000000000 -0400
@@ -723,6 +723,9 @@ lpfc_mbx_process_link_up(struct lpfc_hba
 		case LA_4GHZ_LINK:
 			phba->fc_linkspeed = LA_4GHZ_LINK;
 			break;
+		case LA_8GHZ_LINK:
+			phba->fc_linkspeed = LA_8GHZ_LINK;
+			break;
 		default:
 			phba->fc_linkspeed = LA_UNKNW_LINK;
 			break;
diff -upNr a/drivers/scsi/lpfc/lpfc_hw.h b/drivers/scsi/lpfc/lpfc_hw.h
--- a/drivers/scsi/lpfc/lpfc_hw.h	2007-03-12 13:56:16.000000000 -0500
+++ b/drivers/scsi/lpfc/lpfc_hw.h	2007-04-24 11:12:43.000000000 -0400
@@ -1078,6 +1078,8 @@ typedef struct {
 /* Start FireFly Register definitions */
 #define PCI_VENDOR_ID_EMULEX        0x10df
 #define PCI_DEVICE_ID_FIREFLY       0x1ae5
+#define PCI_DEVICE_ID_SAT_SMB       0xf011
+#define PCI_DEVICE_ID_SAT_MID       0xf015
 #define PCI_DEVICE_ID_RFLY          0xf095
 #define PCI_DEVICE_ID_PFLY          0xf098
 #define PCI_DEVICE_ID_LP101         0xf0a1
@@ -1089,6 +1091,9 @@ typedef struct {
 #define PCI_DEVICE_ID_NEPTUNE       0xf0f5
 #define PCI_DEVICE_ID_NEPTUNE_SCSP  0xf0f6
 #define PCI_DEVICE_ID_NEPTUNE_DCSP  0xf0f7
+#define PCI_DEVICE_ID_SAT           0xf100
+#define PCI_DEVICE_ID_SAT_SCSP      0xf111
+#define PCI_DEVICE_ID_SAT_DCSP      0xf112
 #define PCI_DEVICE_ID_SUPERFLY      0xf700
 #define PCI_DEVICE_ID_DRAGONFLY     0xf800
 #define PCI_DEVICE_ID_CENTAUR       0xf900
@@ -1098,6 +1103,7 @@ typedef struct {
 #define PCI_DEVICE_ID_LP10000S      0xfc00
 #define PCI_DEVICE_ID_LP11000S      0xfc10
 #define PCI_DEVICE_ID_LPE11000S     0xfc20
+#define PCI_DEVICE_ID_SAT_S         0xfc40
 #define PCI_DEVICE_ID_HELIOS        0xfd00
 #define PCI_DEVICE_ID_HELIOS_SCSP   0xfd11
 #define PCI_DEVICE_ID_HELIOS_DCSP   0xfd12
@@ -1118,6 +1124,7 @@ typedef struct {
 #define HELIOS_JEDEC_ID             0x0364
 #define ZEPHYR_JEDEC_ID             0x0577
 #define VIPER_JEDEC_ID              0x4838
+#define SATURN_JEDEC_ID             0x1004
 
 #define JEDEC_ID_MASK               0x0FFFF000
 #define JEDEC_ID_SHIFT              12
@@ -1565,7 +1572,7 @@ typedef struct {
 #define LINK_SPEED_1G   1       /* 1 Gigabaud */
 #define LINK_SPEED_2G   2       /* 2 Gigabaud */
 #define LINK_SPEED_4G   4       /* 4 Gigabaud */
-#define LINK_SPEED_8G   8       /* 4 Gigabaud */
+#define LINK_SPEED_8G   8       /* 8 Gigabaud */
 #define LINK_SPEED_10G   16      /* 10 Gigabaud */
 
 } INIT_LINK_VAR;
diff -upNr a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
--- a/drivers/scsi/lpfc/lpfc_init.c	2007-04-24 11:12:43.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_init.c	2007-04-24 11:12:43.000000000 -0400
@@ -903,6 +903,24 @@ lpfc_get_hba_model_desc(struct lpfc_hba 
 		m = (typeof(m)){"LPe11000-S", max_speed,
 			"PCIe"};
 		break;
+	case PCI_DEVICE_ID_SAT:
+		m = (typeof(m)){"LPe12000", max_speed, "PCIe"};
+		break;
+	case PCI_DEVICE_ID_SAT_MID:
+		m = (typeof(m)){"LPe1250", max_speed, "PCIe"};
+		break;
+	case PCI_DEVICE_ID_SAT_SMB:
+		m = (typeof(m)){"LPe121", max_speed, "PCIe"};
+		break;
+	case PCI_DEVICE_ID_SAT_DCSP:
+		m = (typeof(m)){"LPe12002-SP", max_speed, "PCIe"};
+		break;
+	case PCI_DEVICE_ID_SAT_SCSP:
+		m = (typeof(m)){"LPe12000-SP", max_speed, "PCIe"};
+		break;
+	case PCI_DEVICE_ID_SAT_S:
+		m = (typeof(m)){"LPe12000-S", max_speed, "PCIe"};
+		break;
 	default:
 		m = (typeof(m)){ NULL };
 		break;
@@ -1890,6 +1908,18 @@ static struct pci_device_id lpfc_id_tabl
 		PCI_ANY_ID, PCI_ANY_ID, },
 	{PCI_VENDOR_ID_EMULEX, PCI_DEVICE_ID_LPE11000S,
 		PCI_ANY_ID, PCI_ANY_ID, },
+	{PCI_VENDOR_ID_EMULEX, PCI_DEVICE_ID_SAT,
+		PCI_ANY_ID, PCI_ANY_ID, },
+	{PCI_VENDOR_ID_EMULEX, PCI_DEVICE_ID_SAT_MID,
+		PCI_ANY_ID, PCI_ANY_ID, },
+	{PCI_VENDOR_ID_EMULEX, PCI_DEVICE_ID_SAT_SMB,
+		PCI_ANY_ID, PCI_ANY_ID, },
+	{PCI_VENDOR_ID_EMULEX, PCI_DEVICE_ID_SAT_DCSP,
+		PCI_ANY_ID, PCI_ANY_ID, },
+	{PCI_VENDOR_ID_EMULEX, PCI_DEVICE_ID_SAT_SCSP,
+		PCI_ANY_ID, PCI_ANY_ID, },
+	{PCI_VENDOR_ID_EMULEX, PCI_DEVICE_ID_SAT_S,
+		PCI_ANY_ID, PCI_ANY_ID, },
 	{ 0 }
 };
 
diff -upNr a/drivers/scsi/lpfc/lpfc_mbox.c b/drivers/scsi/lpfc/lpfc_mbox.c
--- a/drivers/scsi/lpfc/lpfc_mbox.c	2007-03-12 13:56:16.000000000 -0500
+++ b/drivers/scsi/lpfc/lpfc_mbox.c	2007-04-24 11:12:43.000000000 -0400
@@ -212,6 +212,7 @@ lpfc_init_link(struct lpfc_hba * phba,
 			case LINK_SPEED_1G:
 			case LINK_SPEED_2G:
 			case LINK_SPEED_4G:
+			case LINK_SPEED_8G:
 				mb->un.varInitLnk.link_flags |=
 							FLAGS_LINK_SPEED;
 				mb->un.varInitLnk.link_speed = linkspeed;


