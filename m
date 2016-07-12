From: wenxiong@linux.vnet.ibm.com
Subject: [PATCH 1/3] ipr: Add new CCIN for new adapters support
Date: Tue, 12 Jul 2016 16:02:07 -0500
Message-ID: <1468357329-3790-1-git-send-email-wenxiong@linux.vnet.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:52029 "EHLO
	mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750926AbcGLVHn (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 12 Jul 2016 17:07:43 -0400
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.16.0.11/8.16.0.11) with SMTP id u6CL3mcf024165
	for <linux-scsi@vger.kernel.org>; Tue, 12 Jul 2016 17:07:32 -0400
Received: from e24smtp02.br.ibm.com (e24smtp02.br.ibm.com [32.104.18.86])
	by mx0a-001b2d01.pphosted.com with ESMTP id 243es69dv4-1
	(version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Tue, 12 Jul 2016 17:07:32 -0400
Received: from localhost
	by e24smtp02.br.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-scsi@vger.kernel.org> from <wenxiong@us.ibm.com>;
	Tue, 12 Jul 2016 18:07:30 -0300
Received: from d24relay01.br.ibm.com (d24relay01.br.ibm.com [9.8.31.16])
	by d24dlp01.br.ibm.com (Postfix) with ESMTP id 0D06C3520068
	for <linux-scsi@vger.kernel.org>; Tue, 12 Jul 2016 17:07:10 -0400 (EDT)
Received: from d24av02.br.ibm.com (d24av02.br.ibm.com [9.8.31.93])
	by d24relay01.br.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id u6CL7Sj74944120
	for <linux-scsi@vger.kernel.org>; Tue, 12 Jul 2016 18:07:28 -0300
Received: from d24av02.br.ibm.com (localhost [127.0.0.1])
	by d24av02.br.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id u6CL7Rw9028384
	for <linux-scsi@vger.kernel.org>; Tue, 12 Jul 2016 18:07:28 -0300
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: JBottomley@Odin.com, martin.petersen@oracle.com, brking@linux.vnet.ibm.com, krisman@linux.vnet.ibm.com, Wen Xiong <wenxiong@linux.vnet.ibm.com>

From: Wen Xiong <wenxiong@linux.vnet.ibm.com>

Add the appropriate definitions and table entries for new
adapters support.

Signed-off-by: Wen Xiong <wenxiong@linux.vnet.ibm.com>
---
 drivers/scsi/ipr.c |    7 ++++++-
 drivers/scsi/ipr.h |    3 +++
 2 files changed, 9 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/ipr.c b/drivers/scsi/ipr.c
index d6803a9..01dc065 100644
--- a/drivers/scsi/ipr.c
+++ b/drivers/scsi/ipr.c
@@ -194,7 +194,8 @@ static const struct ipr_chip_t ipr_chip[] = {
 	{ PCI_VENDOR_ID_IBM, PCI_DEVICE_ID_IBM_SNIPE, IPR_USE_LSI, IPR_SIS32, IPR_PCI_CFG, &ipr_chip_cfg[1] },
 	{ PCI_VENDOR_ID_ADAPTEC2, PCI_DEVICE_ID_ADAPTEC2_SCAMP, IPR_USE_LSI, IPR_SIS32, IPR_PCI_CFG, &ipr_chip_cfg[1] },
 	{ PCI_VENDOR_ID_IBM, PCI_DEVICE_ID_IBM_CROC_FPGA_E2, IPR_USE_MSI, IPR_SIS64, IPR_MMIO, &ipr_chip_cfg[2] },
-	{ PCI_VENDOR_ID_IBM, PCI_DEVICE_ID_IBM_CROCODILE, IPR_USE_MSI, IPR_SIS64, IPR_MMIO, &ipr_chip_cfg[2] }
+	{ PCI_VENDOR_ID_IBM, PCI_DEVICE_ID_IBM_CROCODILE, IPR_USE_MSI, IPR_SIS64, IPR_MMIO, &ipr_chip_cfg[2] },
+	{ PCI_VENDOR_ID_IBM, PCI_DEVICE_ID_IBM_RATTLESNAKE, IPR_USE_MSI, IPR_SIS64, IPR_MMIO, &ipr_chip_cfg[2] }
 };
 
 static int ipr_max_bus_speeds[] = {
@@ -10565,6 +10566,10 @@ static struct pci_device_id ipr_pci_table[] = {
 		PCI_VENDOR_ID_IBM, IPR_SUBS_DEV_ID_2CD2, 0, 0, 0 },
 	{ PCI_VENDOR_ID_IBM, PCI_DEVICE_ID_IBM_CROCODILE,
 		PCI_VENDOR_ID_IBM, IPR_SUBS_DEV_ID_2CCD, 0, 0, 0 },
+	{ PCI_VENDOR_ID_IBM, PCI_DEVICE_ID_IBM_RATTLESNAKE,
+		PCI_VENDOR_ID_IBM, IPR_SUBS_DEV_ID_580A, 0, 0, 0 },
+	{ PCI_VENDOR_ID_IBM, PCI_DEVICE_ID_IBM_RATTLESNAKE,
+		PCI_VENDOR_ID_IBM, IPR_SUBS_DEV_ID_580B, 0, 0, 0 },
 	{ }
 };
 MODULE_DEVICE_TABLE(pci, ipr_pci_table);
diff --git a/drivers/scsi/ipr.h b/drivers/scsi/ipr.h
index 56c5706..1d42c74 100644
--- a/drivers/scsi/ipr.h
+++ b/drivers/scsi/ipr.h
@@ -60,6 +60,7 @@
 
 #define PCI_DEVICE_ID_IBM_CROC_FPGA_E2          0x033D
 #define PCI_DEVICE_ID_IBM_CROCODILE             0x034A
+#define PCI_DEVICE_ID_IBM_RATTLESNAKE		0x04DA
 
 #define IPR_SUBS_DEV_ID_2780	0x0264
 #define IPR_SUBS_DEV_ID_5702	0x0266
@@ -111,6 +112,8 @@
 #define IPR_SUBS_DEV_ID_2CCA	0x04C7
 #define IPR_SUBS_DEV_ID_2CD2	0x04C8
 #define IPR_SUBS_DEV_ID_2CCD	0x04C9
+#define IPR_SUBS_DEV_ID_580A	0x04FC
+#define IPR_SUBS_DEV_ID_580B	0x04FB
 #define IPR_NAME				"ipr"
 
 /*
-- 
1.7.1

