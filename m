From: Himanshu Madhani <himanshu.madhani@qlogic.com>
Subject: [PATCH  13/14] qla2xxx: Add pci device id 0x2261.
Date: Tue, 4 Aug 2015 13:38:03 -0400
Message-ID: <1438709884-623-14-git-send-email-himanshu.madhani@qlogic.com>
References: <1438709884-623-1-git-send-email-himanshu.madhani@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0b-0016ce01.pphosted.com ([67.231.156.153]:54775 "EHLO
	mx0b-0016ce01.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752569AbbHDSXr (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 4 Aug 2015 14:23:47 -0400
In-Reply-To: <1438709884-623-1-git-send-email-himanshu.madhani@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com
Cc: hch@lst.de, giridhar.malavali@qlogic.com, himanshu.madhani@qlogic.com, andrew.vasquez@qlogic.com, linux-scsi@vger.kernel.org

From: Sawan Chandak <sawan.chandak@qlogic.com>

Signed-off-by: Sawan Chandak <sawan.chandak@qlogic.com>
Signed-off-by: Himanshu Madhani <himanshu.madhani@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_def.h |    7 +++++--
 drivers/scsi/qla2xxx/qla_os.c  |   11 ++++++++++-
 2 files changed, 15 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_def.h b/drivers/scsi/qla2xxx/qla_def.h
index 8becec9..5e4389a 100644
--- a/drivers/scsi/qla2xxx/qla_def.h
+++ b/drivers/scsi/qla2xxx/qla_def.h
@@ -3061,6 +3061,7 @@ struct qla_hw_data {
 #define PCI_DEVICE_ID_QLOGIC_ISP2031	0x2031
 #define PCI_DEVICE_ID_QLOGIC_ISP2071	0x2071
 #define PCI_DEVICE_ID_QLOGIC_ISP2271	0x2271
+#define PCI_DEVICE_ID_QLOGIC_ISP2261	0x2261
 
 	uint32_t	device_type;
 #define DT_ISP2100                      BIT_0
@@ -3084,7 +3085,8 @@ struct qla_hw_data {
 #define DT_ISP8044			BIT_18
 #define DT_ISP2071			BIT_19
 #define DT_ISP2271			BIT_20
-#define DT_ISP_LAST			(DT_ISP2271 << 1)
+#define DT_ISP2261			BIT_21
+#define DT_ISP_LAST			(DT_ISP2261 << 1)
 
 #define DT_T10_PI                       BIT_25
 #define DT_IIDMA                        BIT_26
@@ -3116,6 +3118,7 @@ struct qla_hw_data {
 #define IS_QLAFX00(ha)	(DT_MASK(ha) & DT_ISPFX00)
 #define IS_QLA2071(ha)	(DT_MASK(ha) & DT_ISP2071)
 #define IS_QLA2271(ha)	(DT_MASK(ha) & DT_ISP2271)
+#define IS_QLA2261(ha)	(DT_MASK(ha) & DT_ISP2261)
 
 #define IS_QLA23XX(ha)  (IS_QLA2300(ha) || IS_QLA2312(ha) || IS_QLA2322(ha) || \
 			IS_QLA6312(ha) || IS_QLA6322(ha))
@@ -3124,7 +3127,7 @@ struct qla_hw_data {
 #define IS_QLA25XX(ha)  (IS_QLA2532(ha))
 #define IS_QLA83XX(ha)	(IS_QLA2031(ha) || IS_QLA8031(ha))
 #define IS_QLA84XX(ha)  (IS_QLA8432(ha))
-#define IS_QLA27XX(ha)  (IS_QLA2071(ha) || IS_QLA2271(ha))
+#define IS_QLA27XX(ha)  (IS_QLA2071(ha) || IS_QLA2271(ha) || IS_QLA2261(ha))
 #define IS_QLA24XX_TYPE(ha)     (IS_QLA24XX(ha) || IS_QLA54XX(ha) || \
 				IS_QLA84XX(ha))
 #define IS_CNA_CAPABLE(ha)	(IS_QLA81XX(ha) || IS_QLA82XX(ha) || \
diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index aca6577..2f6b004 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -2208,6 +2208,13 @@ qla2x00_set_isp_flags(struct qla_hw_data *ha)
 		ha->device_type |= DT_IIDMA;
 		ha->fw_srisc_address = RISC_START_ADDRESS_2400;
 		break;
+	case PCI_DEVICE_ID_QLOGIC_ISP2261:
+		ha->device_type |= DT_ISP2261;
+		ha->device_type |= DT_ZIO_SUPPORTED;
+		ha->device_type |= DT_FWI2;
+		ha->device_type |= DT_IIDMA;
+		ha->fw_srisc_address = RISC_START_ADDRESS_2400;
+		break;
 	}
 
 	if (IS_QLA82XX(ha))
@@ -2285,7 +2292,8 @@ qla2x00_probe_one(struct pci_dev *pdev, const struct pci_device_id *id)
 	    pdev->device == PCI_DEVICE_ID_QLOGIC_ISPF001 ||
 	    pdev->device == PCI_DEVICE_ID_QLOGIC_ISP8044 ||
 	    pdev->device == PCI_DEVICE_ID_QLOGIC_ISP2071 ||
-	    pdev->device == PCI_DEVICE_ID_QLOGIC_ISP2271) {
+	    pdev->device == PCI_DEVICE_ID_QLOGIC_ISP2271 ||
+	    pdev->device == PCI_DEVICE_ID_QLOGIC_ISP2261) {
 		bars = pci_select_bars(pdev, IORESOURCE_MEM);
 		mem_only = 1;
 		ql_dbg_pci(ql_dbg_init, pdev, 0x0007,
@@ -5707,6 +5715,7 @@ static struct pci_device_id qla2xxx_pci_tbl[] = {
 	{ PCI_DEVICE(PCI_VENDOR_ID_QLOGIC, PCI_DEVICE_ID_QLOGIC_ISP8044) },
 	{ PCI_DEVICE(PCI_VENDOR_ID_QLOGIC, PCI_DEVICE_ID_QLOGIC_ISP2071) },
 	{ PCI_DEVICE(PCI_VENDOR_ID_QLOGIC, PCI_DEVICE_ID_QLOGIC_ISP2271) },
+	{ PCI_DEVICE(PCI_VENDOR_ID_QLOGIC, PCI_DEVICE_ID_QLOGIC_ISP2261) },
 	{ 0 },
 };
 MODULE_DEVICE_TABLE(pci, qla2xxx_pci_tbl);
-- 
1.7.7

