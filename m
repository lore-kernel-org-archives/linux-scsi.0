From: John Soni Jose <sony.john-n@emulex.com>
Subject: [PATCH 09/17] be2iscsi: Fix support for Skyhawk Adapters
Date: Sat, 29 Sep 2012 07:03:21 +0530
Message-ID: <8eb311d1-baf3-4fc5-bb82-eee00d74385f@CMEXHTCAS1.ad.emulex.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cmexedge2.ext.emulex.com ([138.239.224.100]:52567 "EHLO
	CMEXEDGE2.ext.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030298Ab2I2Be2 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 28 Sep 2012 21:34:28 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: michaelc@cs.wisc.edu, linux-scsi@vger.kernel.org
Cc: John Soni Jose <sony.john-n@emulex.com>, Jayamohan Kallickal <jayamohan.kallickal@emulex.com>

 Fix support for Skyhawk adapter by populating the pci_id_table

Signed-off-by: John Soni Jose <sony.john-n@emulex.com>
Signed-off-by: Jayamohan Kallickal <jayamohan.kallickal@emulex.com>
---
 drivers/scsi/be2iscsi/be.h      |    2 +-
 drivers/scsi/be2iscsi/be_main.c |    3 +++
 drivers/scsi/be2iscsi/be_main.h |    4 ++++
 3 files changed, 8 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/be2iscsi/be.h b/drivers/scsi/be2iscsi/be.h
index be67c90..7d9267b 100644
--- a/drivers/scsi/be2iscsi/be.h
+++ b/drivers/scsi/be2iscsi/be.h
@@ -28,7 +28,7 @@
 /* BladeEngine Generation numbers */
 #define BE_GEN2 2
 #define BE_GEN3 3
-
+#define BE_GEN4	4
 struct be_dma_mem {
 	void *va;
 	dma_addr_t dma;
diff --git a/drivers/scsi/be2iscsi/be_main.c b/drivers/scsi/be2iscsi/be_main.c
index c7f9929..c97f010 100644
--- a/drivers/scsi/be2iscsi/be_main.c
+++ b/drivers/scsi/be2iscsi/be_main.c
@@ -521,6 +521,7 @@ static DEFINE_PCI_DEVICE_TABLE(beiscsi_pci_id_table) = {
 	{ PCI_DEVICE(BE_VENDOR_ID, OC_DEVICE_ID1) },
 	{ PCI_DEVICE(BE_VENDOR_ID, OC_DEVICE_ID2) },
 	{ PCI_DEVICE(BE_VENDOR_ID, OC_DEVICE_ID3) },
+	{ PCI_DEVICE(ELX_VENDOR_ID, OC_SKH_ID1) },
 	{ 0 }
 };
 MODULE_DEVICE_TABLE(pci, beiscsi_pci_id_table);
@@ -4591,6 +4592,8 @@ static int __devinit beiscsi_dev_probe(struct pci_dev *pcidev,
 	case OC_DEVICE_ID3:
 		phba->generation = BE_GEN3;
 		break;
+	case OC_SKH_ID1:
+		phba->generation = BE_GEN4;
 	default:
 		phba->generation = 0;
 	}
diff --git a/drivers/scsi/be2iscsi/be_main.h b/drivers/scsi/be2iscsi/be_main.h
index 687ac28..71443fd 100644
--- a/drivers/scsi/be2iscsi/be_main.h
+++ b/drivers/scsi/be2iscsi/be_main.h
@@ -42,6 +42,7 @@
 #define DRV_DESC		BE_NAME " " "Driver"
 
 #define BE_VENDOR_ID		0x19A2
+#define ELX_VENDOR_ID		0x10DF
 /* DEVICE ID's for BE2 */
 #define BE_DEVICE_ID1		0x212
 #define OC_DEVICE_ID1		0x702
@@ -51,6 +52,9 @@
 #define BE_DEVICE_ID2		0x222
 #define OC_DEVICE_ID3		0x712
 
+/* DEVICE ID for SKH */
+#define OC_SKH_ID1			0x722
+
 #define BE2_IO_DEPTH		1024
 #define BE2_MAX_SESSIONS	256
 #define BE2_CMDS_PER_CXN	128
-- 
1.7.2

