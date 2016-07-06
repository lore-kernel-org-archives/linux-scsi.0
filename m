From: Himanshu Madhani <himanshu.madhani@qlogic.com>
Subject: [PATCH 15/19] qla2xxx: Separate ISP type bits out from device type.
Date: Wed, 6 Jul 2016 11:14:31 -0400
Message-ID: <1467818075-15246-16-git-send-email-himanshu.madhani@qlogic.com>
References: <1467818075-15246-1-git-send-email-himanshu.madhani@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0b-0016ce01.pphosted.com ([67.231.156.153]:62998 "EHLO
	mx0b-0016ce01.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754145AbcGFQAL (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 6 Jul 2016 12:00:11 -0400
In-Reply-To: <1467818075-15246-1-git-send-email-himanshu.madhani@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com, martin.petersen@oracle.com
Cc: giridhar.malavali@qlogic.com, himanshu.madhani@qlogic.com, linux-scsi@vger.kernel.org

From: Joe Carnuccio <joe.carnuccio@qlogic.com>

Signed-off-by: Joe Carnuccio <joe.carnuccio@qlogic.com>
Signed-off-by: Himanshu Madhani <himanshu.madhani@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_def.h |  6 ++++--
 drivers/scsi/qla2xxx/qla_os.c  | 44 +++++++++++++++++++++---------------------
 2 files changed, 26 insertions(+), 24 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_def.h b/drivers/scsi/qla2xxx/qla_def.h
index c04d83e..ae4a747 100644
--- a/drivers/scsi/qla2xxx/qla_def.h
+++ b/drivers/scsi/qla2xxx/qla_def.h
@@ -3130,7 +3130,7 @@ struct qla_hw_data {
 #define PCI_DEVICE_ID_QLOGIC_ISP2271	0x2271
 #define PCI_DEVICE_ID_QLOGIC_ISP2261	0x2261
 
-	uint32_t	device_type;
+	uint32_t	isp_type;
 #define DT_ISP2100                      BIT_0
 #define DT_ISP2200                      BIT_1
 #define DT_ISP2300                      BIT_2
@@ -3155,6 +3155,7 @@ struct qla_hw_data {
 #define DT_ISP2261			BIT_21
 #define DT_ISP_LAST			(DT_ISP2261 << 1)
 
+	uint32_t	device_type;
 #define DT_T10_PI                       BIT_25
 #define DT_IIDMA                        BIT_26
 #define DT_FWI2                         BIT_27
@@ -3162,7 +3163,8 @@ struct qla_hw_data {
 #define DT_OEM_001                      BIT_29
 #define DT_ISP2200A                     BIT_30
 #define DT_EXTENDED_IDS                 BIT_31
-#define DT_MASK(ha)     ((ha)->device_type & (DT_ISP_LAST - 1))
+
+#define DT_MASK(ha)     ((ha)->isp_type & (DT_ISP_LAST - 1))
 #define IS_QLA2100(ha)  (DT_MASK(ha) & DT_ISP2100)
 #define IS_QLA2200(ha)  (DT_MASK(ha) & DT_ISP2200)
 #define IS_QLA2300(ha)  (DT_MASK(ha) & DT_ISP2300)
diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index fde7ee1..dc7e583 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -2110,27 +2110,27 @@ qla2x00_set_isp_flags(struct qla_hw_data *ha)
 	ha->device_type = DT_EXTENDED_IDS;
 	switch (ha->pdev->device) {
 	case PCI_DEVICE_ID_QLOGIC_ISP2100:
-		ha->device_type |= DT_ISP2100;
+		ha->isp_type |= DT_ISP2100;
 		ha->device_type &= ~DT_EXTENDED_IDS;
 		ha->fw_srisc_address = RISC_START_ADDRESS_2100;
 		break;
 	case PCI_DEVICE_ID_QLOGIC_ISP2200:
-		ha->device_type |= DT_ISP2200;
+		ha->isp_type |= DT_ISP2200;
 		ha->device_type &= ~DT_EXTENDED_IDS;
 		ha->fw_srisc_address = RISC_START_ADDRESS_2100;
 		break;
 	case PCI_DEVICE_ID_QLOGIC_ISP2300:
-		ha->device_type |= DT_ISP2300;
+		ha->isp_type |= DT_ISP2300;
 		ha->device_type |= DT_ZIO_SUPPORTED;
 		ha->fw_srisc_address = RISC_START_ADDRESS_2300;
 		break;
 	case PCI_DEVICE_ID_QLOGIC_ISP2312:
-		ha->device_type |= DT_ISP2312;
+		ha->isp_type |= DT_ISP2312;
 		ha->device_type |= DT_ZIO_SUPPORTED;
 		ha->fw_srisc_address = RISC_START_ADDRESS_2300;
 		break;
 	case PCI_DEVICE_ID_QLOGIC_ISP2322:
-		ha->device_type |= DT_ISP2322;
+		ha->isp_type |= DT_ISP2322;
 		ha->device_type |= DT_ZIO_SUPPORTED;
 		if (ha->pdev->subsystem_vendor == 0x1028 &&
 		    ha->pdev->subsystem_device == 0x0170)
@@ -2138,60 +2138,60 @@ qla2x00_set_isp_flags(struct qla_hw_data *ha)
 		ha->fw_srisc_address = RISC_START_ADDRESS_2300;
 		break;
 	case PCI_DEVICE_ID_QLOGIC_ISP6312:
-		ha->device_type |= DT_ISP6312;
+		ha->isp_type |= DT_ISP6312;
 		ha->fw_srisc_address = RISC_START_ADDRESS_2300;
 		break;
 	case PCI_DEVICE_ID_QLOGIC_ISP6322:
-		ha->device_type |= DT_ISP6322;
+		ha->isp_type |= DT_ISP6322;
 		ha->fw_srisc_address = RISC_START_ADDRESS_2300;
 		break;
 	case PCI_DEVICE_ID_QLOGIC_ISP2422:
-		ha->device_type |= DT_ISP2422;
+		ha->isp_type |= DT_ISP2422;
 		ha->device_type |= DT_ZIO_SUPPORTED;
 		ha->device_type |= DT_FWI2;
 		ha->device_type |= DT_IIDMA;
 		ha->fw_srisc_address = RISC_START_ADDRESS_2400;
 		break;
 	case PCI_DEVICE_ID_QLOGIC_ISP2432:
-		ha->device_type |= DT_ISP2432;
+		ha->isp_type |= DT_ISP2432;
 		ha->device_type |= DT_ZIO_SUPPORTED;
 		ha->device_type |= DT_FWI2;
 		ha->device_type |= DT_IIDMA;
 		ha->fw_srisc_address = RISC_START_ADDRESS_2400;
 		break;
 	case PCI_DEVICE_ID_QLOGIC_ISP8432:
-		ha->device_type |= DT_ISP8432;
+		ha->isp_type |= DT_ISP8432;
 		ha->device_type |= DT_ZIO_SUPPORTED;
 		ha->device_type |= DT_FWI2;
 		ha->device_type |= DT_IIDMA;
 		ha->fw_srisc_address = RISC_START_ADDRESS_2400;
 		break;
 	case PCI_DEVICE_ID_QLOGIC_ISP5422:
-		ha->device_type |= DT_ISP5422;
+		ha->isp_type |= DT_ISP5422;
 		ha->device_type |= DT_FWI2;
 		ha->fw_srisc_address = RISC_START_ADDRESS_2400;
 		break;
 	case PCI_DEVICE_ID_QLOGIC_ISP5432:
-		ha->device_type |= DT_ISP5432;
+		ha->isp_type |= DT_ISP5432;
 		ha->device_type |= DT_FWI2;
 		ha->fw_srisc_address = RISC_START_ADDRESS_2400;
 		break;
 	case PCI_DEVICE_ID_QLOGIC_ISP2532:
-		ha->device_type |= DT_ISP2532;
+		ha->isp_type |= DT_ISP2532;
 		ha->device_type |= DT_ZIO_SUPPORTED;
 		ha->device_type |= DT_FWI2;
 		ha->device_type |= DT_IIDMA;
 		ha->fw_srisc_address = RISC_START_ADDRESS_2400;
 		break;
 	case PCI_DEVICE_ID_QLOGIC_ISP8001:
-		ha->device_type |= DT_ISP8001;
+		ha->isp_type |= DT_ISP8001;
 		ha->device_type |= DT_ZIO_SUPPORTED;
 		ha->device_type |= DT_FWI2;
 		ha->device_type |= DT_IIDMA;
 		ha->fw_srisc_address = RISC_START_ADDRESS_2400;
 		break;
 	case PCI_DEVICE_ID_QLOGIC_ISP8021:
-		ha->device_type |= DT_ISP8021;
+		ha->isp_type |= DT_ISP8021;
 		ha->device_type |= DT_ZIO_SUPPORTED;
 		ha->device_type |= DT_FWI2;
 		ha->fw_srisc_address = RISC_START_ADDRESS_2400;
@@ -2199,7 +2199,7 @@ qla2x00_set_isp_flags(struct qla_hw_data *ha)
 		qla82xx_init_flags(ha);
 		break;
 	 case PCI_DEVICE_ID_QLOGIC_ISP8044:
-		ha->device_type |= DT_ISP8044;
+		ha->isp_type |= DT_ISP8044;
 		ha->device_type |= DT_ZIO_SUPPORTED;
 		ha->device_type |= DT_FWI2;
 		ha->fw_srisc_address = RISC_START_ADDRESS_2400;
@@ -2207,7 +2207,7 @@ qla2x00_set_isp_flags(struct qla_hw_data *ha)
 		qla82xx_init_flags(ha);
 		break;
 	case PCI_DEVICE_ID_QLOGIC_ISP2031:
-		ha->device_type |= DT_ISP2031;
+		ha->isp_type |= DT_ISP2031;
 		ha->device_type |= DT_ZIO_SUPPORTED;
 		ha->device_type |= DT_FWI2;
 		ha->device_type |= DT_IIDMA;
@@ -2215,7 +2215,7 @@ qla2x00_set_isp_flags(struct qla_hw_data *ha)
 		ha->fw_srisc_address = RISC_START_ADDRESS_2400;
 		break;
 	case PCI_DEVICE_ID_QLOGIC_ISP8031:
-		ha->device_type |= DT_ISP8031;
+		ha->isp_type |= DT_ISP8031;
 		ha->device_type |= DT_ZIO_SUPPORTED;
 		ha->device_type |= DT_FWI2;
 		ha->device_type |= DT_IIDMA;
@@ -2223,10 +2223,10 @@ qla2x00_set_isp_flags(struct qla_hw_data *ha)
 		ha->fw_srisc_address = RISC_START_ADDRESS_2400;
 		break;
 	case PCI_DEVICE_ID_QLOGIC_ISPF001:
-		ha->device_type |= DT_ISPFX00;
+		ha->isp_type |= DT_ISPFX00;
 		break;
 	case PCI_DEVICE_ID_QLOGIC_ISP2071:
-		ha->device_type |= DT_ISP2071;
+		ha->isp_type |= DT_ISP2071;
 		ha->device_type |= DT_ZIO_SUPPORTED;
 		ha->device_type |= DT_FWI2;
 		ha->device_type |= DT_IIDMA;
@@ -2234,7 +2234,7 @@ qla2x00_set_isp_flags(struct qla_hw_data *ha)
 		ha->fw_srisc_address = RISC_START_ADDRESS_2400;
 		break;
 	case PCI_DEVICE_ID_QLOGIC_ISP2271:
-		ha->device_type |= DT_ISP2271;
+		ha->isp_type |= DT_ISP2271;
 		ha->device_type |= DT_ZIO_SUPPORTED;
 		ha->device_type |= DT_FWI2;
 		ha->device_type |= DT_IIDMA;
@@ -2242,7 +2242,7 @@ qla2x00_set_isp_flags(struct qla_hw_data *ha)
 		ha->fw_srisc_address = RISC_START_ADDRESS_2400;
 		break;
 	case PCI_DEVICE_ID_QLOGIC_ISP2261:
-		ha->device_type |= DT_ISP2261;
+		ha->isp_type |= DT_ISP2261;
 		ha->device_type |= DT_ZIO_SUPPORTED;
 		ha->device_type |= DT_FWI2;
 		ha->device_type |= DT_IIDMA;
-- 
2.7.2

