From: andrew.vasquez@qlogic.com
Subject: [PATCH 07/10] qla2xxx: Further restrict ZIO mode support.
Date: Thu, 9 Mar 2006 14:27:39 -0800
Message-ID: <11419432541611-git-send-email-andrew.vasquez@qlogic.com>
References: <20060309222436.GC10181@andrew-vasquezs-powerbook-g4-15.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pat.qlogic.com ([198.70.193.2]:32070 "EHLO avexch02.qlogic.com")
	by vger.kernel.org with ESMTP id S1751965AbWCIW1j (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 9 Mar 2006 17:27:39 -0500
In-Reply-To: <20060309222436.GC10181@andrew-vasquezs-powerbook-g4-15.local>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, James.Bottomley@SteelEye.com
Cc: andrew.vasquez@qlogic.com

Only support ZIO mode 6 on specific ISP types.

Signed-off-by: Andrew Vasquez <andrew.vasquez@qlogic.com>

---

 drivers/scsi/qla2xxx/qla_attr.c |   17 +++++------------
 drivers/scsi/qla2xxx/qla_def.h  |    3 ++-
 drivers/scsi/qla2xxx/qla_init.c |    4 ++++
 drivers/scsi/qla2xxx/qla_os.c   |    5 +++++
 4 files changed, 16 insertions(+), 13 deletions(-)

412e0492b4a0c3855e2a822427f009e22a7aaa58
diff --git a/drivers/scsi/qla2xxx/qla_attr.c b/drivers/scsi/qla2xxx/qla_attr.c
index 488b3d1..fee0c49 100644
--- a/drivers/scsi/qla2xxx/qla_attr.c
+++ b/drivers/scsi/qla2xxx/qla_attr.c
@@ -507,9 +507,6 @@ qla2x00_zio_show(struct class_device *cd
 	int len = 0;
 
 	switch (ha->zio_mode) {
-	case QLA_ZIO_MODE_5:
-		len += snprintf(buf + len, PAGE_SIZE-len, "Mode 5\n");
-		break;
 	case QLA_ZIO_MODE_6:
 		len += snprintf(buf + len, PAGE_SIZE-len, "Mode 6\n");
 		break;
@@ -527,20 +524,16 @@ qla2x00_zio_store(struct class_device *c
 	int val = 0;
 	uint16_t zio_mode;
 
+	if (!IS_ZIO_SUPPORTED(ha))
+		return -ENOTSUPP;
+
 	if (sscanf(buf, "%d", &val) != 1)
 		return -EINVAL;
 
-	switch (val) {
-	case 1:
-		zio_mode = QLA_ZIO_MODE_5;
-		break;
-	case 2:
+	if (val)
 		zio_mode = QLA_ZIO_MODE_6;
-		break;
-	default:
+	else
 		zio_mode = QLA_ZIO_DISABLED;
-		break;
-	}
 
 	/* Update per-hba values and queue a reset. */
 	if (zio_mode != QLA_ZIO_DISABLED || ha->zio_mode != QLA_ZIO_DISABLED) {
diff --git a/drivers/scsi/qla2xxx/qla_def.h b/drivers/scsi/qla2xxx/qla_def.h
index 20798f9..53508f3 100644
--- a/drivers/scsi/qla2xxx/qla_def.h
+++ b/drivers/scsi/qla2xxx/qla_def.h
@@ -762,7 +762,6 @@ typedef struct {
 #define PD_STATE_WAIT_PORT_LOGOUT_ACK		11
 
 
-#define QLA_ZIO_MODE_5		(BIT_2 | BIT_0)
 #define QLA_ZIO_MODE_6		(BIT_2 | BIT_1)
 #define QLA_ZIO_DISABLED	0
 #define QLA_ZIO_DEFAULT_TIMER	2
@@ -2238,6 +2237,7 @@ typedef struct scsi_qla_host {
 #define DT_ISP5432			BIT_10
 #define DT_ISP_LAST			(DT_ISP5432 << 1)
 
+#define DT_ZIO_SUPPORTED		BIT_28
 #define DT_OEM_001			BIT_29
 #define DT_ISP2200A			BIT_30
 #define DT_EXTENDED_IDS			BIT_31
@@ -2260,6 +2260,7 @@ typedef struct scsi_qla_host {
 #define IS_QLA24XX(ha)	(IS_QLA2422(ha) || IS_QLA2432(ha))
 #define IS_QLA54XX(ha)	(IS_QLA5422(ha) || IS_QLA5432(ha))
 
+#define IS_ZIO_SUPPORTED(ha)	((ha)->device_type & DT_ZIO_SUPPORTED)
 #define IS_OEM_001(ha)		((ha)->device_type & DT_OEM_001)
 #define HAS_EXTENDED_IDS(ha)	((ha)->device_type & DT_EXTENDED_IDS)
 
diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index 71b6bcc..ebc7c24 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -1659,6 +1659,8 @@ qla2x00_nvram_config(scsi_qla_host_t *ha
 		    ~(BIT_3 | BIT_2 | BIT_1 | BIT_0);
 		ha->flags.process_response_queue = 0;
 		if (ha->zio_mode != QLA_ZIO_DISABLED) {
+			ha->zio_mode = QLA_ZIO_MODE_6;
+
 			DEBUG2(printk("scsi(%ld): ZIO mode %d enabled; timer "
 			    "delay (%d us).\n", ha->host_no, ha->zio_mode,
 			    ha->zio_timer * 100));
@@ -3474,6 +3476,8 @@ qla24xx_nvram_config(scsi_qla_host_t *ha
 	    ~(BIT_3 | BIT_2 | BIT_1 | BIT_0));
 	ha->flags.process_response_queue = 0;
 	if (ha->zio_mode != QLA_ZIO_DISABLED) {
+		ha->zio_mode = QLA_ZIO_MODE_6;
+
 		DEBUG2(printk("scsi(%ld): ZIO mode %d enabled; timer delay "
 		    "(%d us).\n", ha->host_no, ha->zio_mode,
 		    ha->zio_timer * 100));
diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index 4dc08d9..0fc89ac 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -1161,12 +1161,15 @@ qla2x00_set_isp_flags(scsi_qla_host_t *h
 		break;
 	case PCI_DEVICE_ID_QLOGIC_ISP2300:
 		ha->device_type |= DT_ISP2300;
+		ha->device_type |= DT_ZIO_SUPPORTED;
 		break;
 	case PCI_DEVICE_ID_QLOGIC_ISP2312:
 		ha->device_type |= DT_ISP2312;
+		ha->device_type |= DT_ZIO_SUPPORTED;
 		break;
 	case PCI_DEVICE_ID_QLOGIC_ISP2322:
 		ha->device_type |= DT_ISP2322;
+		ha->device_type |= DT_ZIO_SUPPORTED;
 		if (ha->pdev->subsystem_vendor == 0x1028 &&
 		    ha->pdev->subsystem_device == 0x0170)
 			ha->device_type |= DT_OEM_001;
@@ -1179,9 +1182,11 @@ qla2x00_set_isp_flags(scsi_qla_host_t *h
 		break;
 	case PCI_DEVICE_ID_QLOGIC_ISP2422:
 		ha->device_type |= DT_ISP2422;
+		ha->device_type |= DT_ZIO_SUPPORTED;
 		break;
 	case PCI_DEVICE_ID_QLOGIC_ISP2432:
 		ha->device_type |= DT_ISP2432;
+		ha->device_type |= DT_ZIO_SUPPORTED;
 		break;
 	case PCI_DEVICE_ID_QLOGIC_ISP5422:
 		ha->device_type |= DT_ISP5422;
-- 
1.2.4.gf067


