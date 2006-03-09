From: andrew.vasquez@qlogic.com
Subject: [PATCH 01/10] qla2xxx: Convert IS_QLA*() defines to bit-operations.
Date: Thu, 9 Mar 2006 14:27:08 -0800
Message-ID: <11419432283911-git-send-email-andrew.vasquez@qlogic.com>
References: <20060309222436.GC10181@andrew-vasquezs-powerbook-g4-15.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pat.qlogic.com ([198.70.193.2]:12612 "EHLO avexch02.qlogic.com")
	by vger.kernel.org with ESMTP id S1751949AbWCIW1N (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 9 Mar 2006 17:27:13 -0500
In-Reply-To: <20060309222436.GC10181@andrew-vasquezs-powerbook-g4-15.local>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, James.Bottomley@SteelEye.com
Cc: andrew.vasquez@qlogic.com

Signed-off-by: Andrew Vasquez <andrew.vasquez@qlogic.com>

---

 drivers/scsi/qla2xxx/qla_def.h  |  115 +++++++++++++--------------------------
 drivers/scsi/qla2xxx/qla_init.c |    1 
 drivers/scsi/qla2xxx/qla_os.c   |   49 +++++++++++++++++
 drivers/scsi/qla2xxx/qla_sup.c  |    5 --
 4 files changed, 89 insertions(+), 81 deletions(-)

8e6ea4d1c2e6da691c39c30f44c3c68758cd54c9
diff --git a/drivers/scsi/qla2xxx/qla_def.h b/drivers/scsi/qla2xxx/qla_def.h
index 2e16f32..00b7e82 100644
--- a/drivers/scsi/qla2xxx/qla_def.h
+++ b/drivers/scsi/qla2xxx/qla_def.h
@@ -31,82 +31,6 @@
 #include <scsi/scsi_cmnd.h>
 #include <scsi/scsi_transport_fc.h>
 
-#if defined(CONFIG_SCSI_QLA2XXX_EMBEDDED_FIRMWARE)
-#if defined(CONFIG_SCSI_QLA21XX) || defined(CONFIG_SCSI_QLA21XX_MODULE)
-#define IS_QLA2100(ha)	((ha)->pdev->device == PCI_DEVICE_ID_QLOGIC_ISP2100)
-#else
-#define IS_QLA2100(ha)	0
-#endif
-
-#if defined(CONFIG_SCSI_QLA22XX) || defined(CONFIG_SCSI_QLA22XX_MODULE)
-#define IS_QLA2200(ha)	((ha)->pdev->device == PCI_DEVICE_ID_QLOGIC_ISP2200)
-#else
-#define IS_QLA2200(ha)	0
-#endif
-
-#if defined(CONFIG_SCSI_QLA2300) || defined(CONFIG_SCSI_QLA2300_MODULE)
-#define IS_QLA2300(ha)	((ha)->pdev->device == PCI_DEVICE_ID_QLOGIC_ISP2300)
-#define IS_QLA2312(ha)	((ha)->pdev->device == PCI_DEVICE_ID_QLOGIC_ISP2312)
-#else
-#define IS_QLA2300(ha)	0
-#define IS_QLA2312(ha)	0
-#endif
-
-#if defined(CONFIG_SCSI_QLA2322) || defined(CONFIG_SCSI_QLA2322_MODULE)
-#define IS_QLA2322(ha)	((ha)->pdev->device == PCI_DEVICE_ID_QLOGIC_ISP2322)
-#else
-#define IS_QLA2322(ha)	0
-#endif
-
-#if defined(CONFIG_SCSI_QLA6312) || defined(CONFIG_SCSI_QLA6312_MODULE)
-#define IS_QLA6312(ha)	((ha)->pdev->device == PCI_DEVICE_ID_QLOGIC_ISP6312)
-#define IS_QLA6322(ha)	((ha)->pdev->device == PCI_DEVICE_ID_QLOGIC_ISP6322)
-#else
-#define IS_QLA6312(ha)	0
-#define IS_QLA6322(ha)	0
-#endif
-
-#if defined(CONFIG_SCSI_QLA24XX) || defined(CONFIG_SCSI_QLA24XX_MODULE)
-#define IS_QLA2422(ha)	((ha)->pdev->device == PCI_DEVICE_ID_QLOGIC_ISP2422)
-#define IS_QLA2432(ha)	((ha)->pdev->device == PCI_DEVICE_ID_QLOGIC_ISP2432)
-#else
-#define IS_QLA2422(ha)	0
-#define IS_QLA2432(ha)	0
-#endif
-
-#if defined(CONFIG_SCSI_QLA25XX) || defined(CONFIG_SCSI_QLA25XX_MODULE)
-#define IS_QLA2512(ha)	((ha)->pdev->device == PCI_DEVICE_ID_QLOGIC_ISP2512)
-#define IS_QLA2522(ha)	((ha)->pdev->device == PCI_DEVICE_ID_QLOGIC_ISP2522)
-#else
-#define IS_QLA2512(ha)	0
-#define IS_QLA2522(ha)	0
-#endif
-
-#else	/* !defined(CONFIG_SCSI_QLA2XXX_EMBEDDED_FIRMWARE) */
-
-#define IS_QLA2100(ha)	((ha)->pdev->device == PCI_DEVICE_ID_QLOGIC_ISP2100)
-#define IS_QLA2200(ha)	((ha)->pdev->device == PCI_DEVICE_ID_QLOGIC_ISP2200)
-#define IS_QLA2300(ha)	((ha)->pdev->device == PCI_DEVICE_ID_QLOGIC_ISP2300)
-#define IS_QLA2312(ha)	((ha)->pdev->device == PCI_DEVICE_ID_QLOGIC_ISP2312)
-#define IS_QLA2322(ha)	((ha)->pdev->device == PCI_DEVICE_ID_QLOGIC_ISP2322)
-#define IS_QLA6312(ha)	((ha)->pdev->device == PCI_DEVICE_ID_QLOGIC_ISP6312)
-#define IS_QLA6322(ha)	((ha)->pdev->device == PCI_DEVICE_ID_QLOGIC_ISP6322)
-#define IS_QLA2422(ha)	((ha)->pdev->device == PCI_DEVICE_ID_QLOGIC_ISP2422)
-#define IS_QLA2432(ha)	((ha)->pdev->device == PCI_DEVICE_ID_QLOGIC_ISP2432)
-#define IS_QLA2512(ha)	((ha)->pdev->device == PCI_DEVICE_ID_QLOGIC_ISP2512)
-#define IS_QLA2522(ha)	((ha)->pdev->device == PCI_DEVICE_ID_QLOGIC_ISP2522)
-#endif
-
-#define IS_QLA23XX(ha)	(IS_QLA2300(ha) || IS_QLA2312(ha) || IS_QLA2322(ha) || \
-    			 IS_QLA6312(ha) || IS_QLA6322(ha))
-#define IS_QLA24XX(ha)	(IS_QLA2422(ha) || IS_QLA2432(ha))
-#define IS_QLA25XX(ha)	(IS_QLA2512(ha) || IS_QLA2522(ha))
-
-/*
- * Only non-ISP2[12]00 have extended addressing support in the firmware.
- */
-#define HAS_EXTENDED_IDS(ha)	(!IS_QLA2100(ha) && !IS_QLA2200(ha))
-
 /*
  * We have MAILBOX_REGISTER_COUNT sized arrays in a few places,
  * but that's fine as we don't look at the last 24 ones for
@@ -2300,6 +2224,45 @@ typedef struct scsi_qla_host {
 #define	SWITCH_FOUND			BIT_3
 #define	DFLG_NO_CABLE			BIT_4
 
+	uint32_t	device_type;
+#define DT_ISP2100			BIT_0
+#define DT_ISP2200			BIT_1
+#define DT_ISP2300			BIT_2
+#define DT_ISP2312			BIT_3
+#define DT_ISP2322			BIT_4
+#define DT_ISP6312			BIT_5
+#define DT_ISP6322			BIT_6
+#define DT_ISP2422			BIT_7
+#define DT_ISP2432			BIT_8
+#define DT_ISP2512			BIT_9
+#define DT_ISP2522			BIT_10
+#define DT_ISP_LAST			(DT_ISP2522 << 1)
+
+#define DT_OEM_001			BIT_29
+#define DT_ISP2200A			BIT_30
+#define DT_EXTENDED_IDS			BIT_31
+
+#define DT_MASK(ha)	((ha)->device_type & (DT_ISP_LAST - 1))
+#define IS_QLA2100(ha)	(DT_MASK(ha) & DT_ISP2100)
+#define IS_QLA2200(ha)	(DT_MASK(ha) & DT_ISP2200)
+#define IS_QLA2300(ha)	(DT_MASK(ha) & DT_ISP2300)
+#define IS_QLA2312(ha)	(DT_MASK(ha) & DT_ISP2312)
+#define IS_QLA2322(ha)	(DT_MASK(ha) & DT_ISP2322)
+#define IS_QLA6312(ha)	(DT_MASK(ha) & DT_ISP6312)
+#define IS_QLA6322(ha)	(DT_MASK(ha) & DT_ISP6322)
+#define IS_QLA2422(ha)	(DT_MASK(ha) & DT_ISP2422)
+#define IS_QLA2432(ha)	(DT_MASK(ha) & DT_ISP2432)
+#define IS_QLA2512(ha)	(DT_MASK(ha) & DT_ISP2512)
+#define IS_QLA2522(ha)	(DT_MASK(ha) & DT_ISP2522)
+
+#define IS_QLA23XX(ha)	(IS_QLA2300(ha) || IS_QLA2312(ha) || IS_QLA2322(ha) || \
+    			 IS_QLA6312(ha) || IS_QLA6322(ha))
+#define IS_QLA24XX(ha)	(IS_QLA2422(ha) || IS_QLA2432(ha))
+#define IS_QLA25XX(ha)	(IS_QLA2512(ha) || IS_QLA2522(ha))
+
+#define IS_OEM_001(ha)		((ha)->device_type & DT_OEM_001)
+#define HAS_EXTENDED_IDS(ha)	((ha)->device_type & DT_EXTENDED_IDS)
+
 	/* SRB cache. */
 #define SRB_MIN_REQ	128
 	mempool_t	*srb_mempool;
diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index 634ee17..f49eb06 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -727,6 +727,7 @@ qla2x00_chip_diag(scsi_qla_host_t *ha)
 		DEBUG3(printk("scsi(%ld): Found QLA2200A chip.\n",
 		    ha->host_no));
 
+		ha->device_type |= DT_ISP2200A;
 		ha->fw_transfer_size = 128;
 	}
 
diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index 43ca0d8..757c4c4 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -1146,6 +1146,52 @@ qla2x00_config_dma_addressing(scsi_qla_h
 	pci_set_consistent_dma_mask(ha->pdev, DMA_32BIT_MASK);
 }
 
+static inline void
+qla2x00_set_isp_flags(scsi_qla_host_t *ha)
+{
+	ha->device_type = DT_EXTENDED_IDS;
+	switch (ha->pdev->device) {
+	case PCI_DEVICE_ID_QLOGIC_ISP2100:
+		ha->device_type |= DT_ISP2100;
+		ha->device_type &= ~DT_EXTENDED_IDS;
+		break;
+	case PCI_DEVICE_ID_QLOGIC_ISP2200:
+		ha->device_type |= DT_ISP2200;
+		ha->device_type &= ~DT_EXTENDED_IDS;
+		break;
+	case PCI_DEVICE_ID_QLOGIC_ISP2300:
+		ha->device_type |= DT_ISP2300;
+		break;
+	case PCI_DEVICE_ID_QLOGIC_ISP2312:
+		ha->device_type |= DT_ISP2312;
+		break;
+	case PCI_DEVICE_ID_QLOGIC_ISP2322:
+		ha->device_type |= DT_ISP2322;
+		if (ha->pdev->subsystem_vendor == 0x1028 &&
+		    ha->pdev->subsystem_device == 0x0170)
+			ha->device_type |= DT_OEM_001;
+		break;
+	case PCI_DEVICE_ID_QLOGIC_ISP6312:
+		ha->device_type |= DT_ISP6312;
+		break;
+	case PCI_DEVICE_ID_QLOGIC_ISP6322:
+		ha->device_type |= DT_ISP6322;
+		break;
+	case PCI_DEVICE_ID_QLOGIC_ISP2422:
+		ha->device_type |= DT_ISP2422;
+		break;
+	case PCI_DEVICE_ID_QLOGIC_ISP2432:
+		ha->device_type |= DT_ISP2432;
+		break;
+	case PCI_DEVICE_ID_QLOGIC_ISP2512:
+		ha->device_type |= DT_ISP2512;
+		break;
+	case PCI_DEVICE_ID_QLOGIC_ISP2522:
+		ha->device_type |= DT_ISP2522;
+		break;
+	}
+}
+
 static int
 qla2x00_iospace_config(scsi_qla_host_t *ha)
 {
@@ -1307,6 +1353,9 @@ int qla2x00_probe_one(struct pci_dev *pd
 	ha->brd_info = brd_info;
 	sprintf(ha->host_str, "%s_%ld", ha->brd_info->drv_name, ha->host_no);
 
+	/* Set ISP-type information. */
+	qla2x00_set_isp_flags(ha);
+
 	/* Configure PCI I/O space */
 	ret = qla2x00_iospace_config(ha);
 	if (ret)
diff --git a/drivers/scsi/qla2xxx/qla_sup.c b/drivers/scsi/qla2xxx/qla_sup.c
index 8d68c46..8b0121d 100644
--- a/drivers/scsi/qla2xxx/qla_sup.c
+++ b/drivers/scsi/qla2xxx/qla_sup.c
@@ -1191,11 +1191,6 @@ qla2x00_poll_flash(scsi_qla_host_t *ha, 
 	return status;
 }
 
-#define IS_OEM_001(ha) \
-	((ha)->pdev->device == PCI_DEVICE_ID_QLOGIC_ISP2322 && \
-	 (ha)->pdev->subsystem_vendor == 0x1028 && \
-	 (ha)->pdev->subsystem_device == 0x0170)
-
 /**
  * qla2x00_program_flash_address() - Programs a flash address
  * @ha: HA context
-- 
1.2.4.gf067


