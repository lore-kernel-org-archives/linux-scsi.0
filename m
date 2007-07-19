From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: [PATCH 2/9] qla2xxx: Generalize iIDMA support.
Date: Thu, 19 Jul 2007 15:05:57 -0700
Message-ID: <11848827641583-git-send-email-andrew.vasquez@qlogic.com>
References: <20070719220456.GK4015@plap.qlogic.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexch1.qlogic.com ([198.70.193.115]:27113 "EHLO
	avexch1.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762206AbXGSWHC (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 19 Jul 2007 18:07:02 -0400
In-Reply-To: <20070719220456.GK4015@plap.qlogic.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Linux SCSI Mailing List <linux-scsi@vger.kernel.org>, James Bottomley <james.bottomley@steeleye.com>
Cc: Andrew Vasquez <andrew.vasquez@qlogic.com>, Seokmann Ju <seokmann.ju@qlogic.com>

In preparation for new ISP types.

Signed-off-by: Andrew Vasquez <andrew.vasquez@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_def.h  |    2 ++
 drivers/scsi/qla2xxx/qla_gs.c   |    4 ++--
 drivers/scsi/qla2xxx/qla_init.c |    2 +-
 drivers/scsi/qla2xxx/qla_mbx.c  |    4 ++--
 drivers/scsi/qla2xxx/qla_os.c   |    2 ++
 5 files changed, 9 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_def.h b/drivers/scsi/qla2xxx/qla_def.h
index b818c43..d505c04 100644
--- a/drivers/scsi/qla2xxx/qla_def.h
+++ b/drivers/scsi/qla2xxx/qla_def.h
@@ -2215,6 +2215,7 @@ typedef struct scsi_qla_host {
 #define DT_ISP5432			BIT_10
 #define DT_ISP_LAST			(DT_ISP5432 << 1)
 
+#define DT_IIDMA			BIT_26
 #define DT_FWI2				BIT_27
 #define DT_ZIO_SUPPORTED		BIT_28
 #define DT_OEM_001			BIT_29
@@ -2239,6 +2240,7 @@ typedef struct scsi_qla_host {
 #define IS_QLA24XX(ha)	(IS_QLA2422(ha) || IS_QLA2432(ha))
 #define IS_QLA54XX(ha)	(IS_QLA5422(ha) || IS_QLA5432(ha))
 
+#define IS_IIDMA_CAPABLE(ha)	((ha)->device_type & DT_IIDMA)
 #define IS_FWI2_CAPABLE(ha)	((ha)->device_type & DT_FWI2)
 #define IS_ZIO_SUPPORTED(ha)	((ha)->device_type & DT_ZIO_SUPPORTED)
 #define IS_OEM_001(ha)		((ha)->device_type & DT_OEM_001)
diff --git a/drivers/scsi/qla2xxx/qla_gs.c b/drivers/scsi/qla2xxx/qla_gs.c
index 16de917..9be3123 100644
--- a/drivers/scsi/qla2xxx/qla_gs.c
+++ b/drivers/scsi/qla2xxx/qla_gs.c
@@ -1678,7 +1678,7 @@ qla2x00_gfpn_id(scsi_qla_host_t *ha, sw_info_t *list)
 	struct ct_sns_req	*ct_req;
 	struct ct_sns_rsp	*ct_rsp;
 
-	if (!IS_FWI2_CAPABLE(ha))
+	if (!IS_IIDMA_CAPABLE(ha))
 		return QLA_FUNCTION_FAILED;
 
 	for (i = 0; i < MAX_FIBRE_DEVICES; i++) {
@@ -1786,7 +1786,7 @@ qla2x00_gpsc(scsi_qla_host_t *ha, sw_info_t *list)
 	struct ct_sns_req	*ct_req;
 	struct ct_sns_rsp	*ct_rsp;
 
-	if (!IS_FWI2_CAPABLE(ha))
+	if (!IS_IIDMA_CAPABLE(ha))
 		return QLA_FUNCTION_FAILED;
 	if (!ha->flags.gpsc_supported)
 		return QLA_FUNCTION_FAILED;
diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index 7e53814..dbf64bb 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -2119,7 +2119,7 @@ qla2x00_iidma_fcport(scsi_qla_host_t *ha, fc_port_t *fcport)
 	int rval;
 	uint16_t port_speed, mb[6];
 
-	if (!IS_QLA24XX(ha))
+	if (!IS_IIDMA_CAPABLE(ha))
 		return;
 
 	switch (be16_to_cpu(fcport->fp_speed)) {
diff --git a/drivers/scsi/qla2xxx/qla_mbx.c b/drivers/scsi/qla2xxx/qla_mbx.c
index 321acc2..d3746ec 100644
--- a/drivers/scsi/qla2xxx/qla_mbx.c
+++ b/drivers/scsi/qla2xxx/qla_mbx.c
@@ -2552,7 +2552,7 @@ qla2x00_get_idma_speed(scsi_qla_host_t *ha, uint16_t loop_id,
 	mbx_cmd_t mc;
 	mbx_cmd_t *mcp = &mc;
 
-	if (!IS_QLA24XX(ha))
+	if (!IS_IIDMA_CAPABLE(ha))
 		return QLA_FUNCTION_FAILED;
 
 	DEBUG11(printk("%s(%ld): entered.\n", __func__, ha->host_no));
@@ -2595,7 +2595,7 @@ qla2x00_set_idma_speed(scsi_qla_host_t *ha, uint16_t loop_id,
 	mbx_cmd_t mc;
 	mbx_cmd_t *mcp = &mc;
 
-	if (!IS_QLA24XX(ha))
+	if (!IS_IIDMA_CAPABLE(ha))
 		return QLA_FUNCTION_FAILED;
 
 	DEBUG11(printk("%s(%ld): entered.\n", __func__, ha->host_no));
diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index e246f94..d19fd79 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -1239,12 +1239,14 @@ qla2x00_set_isp_flags(scsi_qla_host_t *ha)
 		ha->device_type |= DT_ISP2422;
 		ha->device_type |= DT_ZIO_SUPPORTED;
 		ha->device_type |= DT_FWI2;
+		ha->device_type |= DT_IIDMA;
 		ha->fw_srisc_address = RISC_START_ADDRESS_2400;
 		break;
 	case PCI_DEVICE_ID_QLOGIC_ISP2432:
 		ha->device_type |= DT_ISP2432;
 		ha->device_type |= DT_ZIO_SUPPORTED;
 		ha->device_type |= DT_FWI2;
+		ha->device_type |= DT_IIDMA;
 		ha->fw_srisc_address = RISC_START_ADDRESS_2400;
 		break;
 	case PCI_DEVICE_ID_QLOGIC_ISP5422:
-- 
1.5.3.rc2.4.g726f9

