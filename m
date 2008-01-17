From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: [PATCH] qla2xxx: Trace-Control naming cleanups.
Date: Thu, 17 Jan 2008 09:02:16 -0800
Message-ID: <1200589340-19499-10-git-send-email-andrew.vasquez@qlogic.com>
References: <20080117165940.GA19033@plap3.qlogic.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexch1.qlogic.com ([198.70.193.115]:20849 "EHLO
	avexch1.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751080AbYAQRCi (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 17 Jan 2008 12:02:38 -0500
In-Reply-To: <20080117165940.GA19033@plap3.qlogic.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Linux SCSI Mailing List <linux-scsi@vger.kernel.org>, James Bottomley <james.bottomley@steeleye.com>
Cc: Andrew Vasquez <andrew.vasquez@qlogic.com>, Seokmann Ju <seokmann.ju@qlogic.com>

In preparation for FCE (Fibre Channel Event) tracing support.

Signed-off-by: Andrew Vasquez <andrew.vasquez@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_def.h  |    3 --
 drivers/scsi/qla2xxx/qla_fw.h   |    7 +++++
 drivers/scsi/qla2xxx/qla_gbl.h  |    4 ++-
 drivers/scsi/qla2xxx/qla_init.c |    5 +--
 drivers/scsi/qla2xxx/qla_mbx.c  |   49 +++++++++++++++++++++++++++++---------
 drivers/scsi/qla2xxx/qla_os.c   |    2 +-
 6 files changed, 50 insertions(+), 20 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_def.h b/drivers/scsi/qla2xxx/qla_def.h
index 144f6d0..3f934bd 100644
--- a/drivers/scsi/qla2xxx/qla_def.h
+++ b/drivers/scsi/qla2xxx/qla_def.h
@@ -623,9 +623,6 @@ typedef struct {
 #define MBC_GET_LINK_PRIV_STATS		0x6d	/* Get link & private data. */
 #define MBC_SET_VENDOR_ID		0x76	/* Set Vendor ID. */
 
-#define TC_ENABLE			4
-#define TC_DISABLE			5
-
 /* Firmware return data sizes */
 #define FCAL_MAP_SIZE	128
 
diff --git a/drivers/scsi/qla2xxx/qla_fw.h b/drivers/scsi/qla2xxx/qla_fw.h
index 69a5e31..ef14bcd 100644
--- a/drivers/scsi/qla2xxx/qla_fw.h
+++ b/drivers/scsi/qla2xxx/qla_fw.h
@@ -952,6 +952,13 @@ struct device_reg_24xx {
 	uint32_t iobase_sdata;
 };
 
+/* Trace Control *************************************************************/
+
+#define TC_AEN_DISABLE		0
+
+#define TC_EFT_ENABLE		4
+#define TC_EFT_DISABLE		5
+
 /* MID Support ***************************************************************/
 
 #define MIN_MULTI_ID_FABRIC	64	/* Must be power-of-2. */
diff --git a/drivers/scsi/qla2xxx/qla_gbl.h b/drivers/scsi/qla2xxx/qla_gbl.h
index fd75539..2fd31fd 100644
--- a/drivers/scsi/qla2xxx/qla_gbl.h
+++ b/drivers/scsi/qla2xxx/qla_gbl.h
@@ -228,7 +228,9 @@ extern int
 qla2x00_stop_firmware(scsi_qla_host_t *);
 
 extern int
-qla2x00_trace_control(scsi_qla_host_t *, uint16_t, dma_addr_t, uint16_t);
+qla2x00_enable_eft_trace(scsi_qla_host_t *, dma_addr_t, uint16_t);
+extern int
+qla2x00_disable_eft_trace(scsi_qla_host_t *);
 
 extern int
 qla2x00_read_sfp(scsi_qla_host_t *, dma_addr_t, uint16_t, uint16_t, uint16_t);
diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index 03444d6..da2cce0 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -766,8 +766,7 @@ qla2x00_alloc_fw_dump(scsi_qla_host_t *ha)
 			goto cont_alloc;
 		}
 
-		rval = qla2x00_trace_control(ha, TC_ENABLE, eft_dma,
-		    EFT_NUM_BUFFERS);
+		rval = qla2x00_enable_eft_trace(ha, eft_dma, EFT_NUM_BUFFERS);
 		if (rval) {
 			qla_printk(KERN_WARNING, ha, "Unable to initialize "
 			    "EFT (%d).\n", rval);
@@ -3240,7 +3239,7 @@ qla2x00_abort_isp(scsi_qla_host_t *ha)
 			clear_bit(ISP_ABORT_RETRY, &ha->dpc_flags);
 
 			if (ha->eft) {
-				rval = qla2x00_trace_control(ha, TC_ENABLE,
+				rval = qla2x00_enable_eft_trace(ha,
 				    ha->eft_dma, EFT_NUM_BUFFERS);
 				if (rval) {
 					qla_printk(KERN_WARNING, ha,
diff --git a/drivers/scsi/qla2xxx/qla_mbx.c b/drivers/scsi/qla2xxx/qla_mbx.c
index ee7899d..7c6aa4e 100644
--- a/drivers/scsi/qla2xxx/qla_mbx.c
+++ b/drivers/scsi/qla2xxx/qla_mbx.c
@@ -2350,7 +2350,7 @@ qla2x00_stop_firmware(scsi_qla_host_t *ha)
 }
 
 int
-qla2x00_trace_control(scsi_qla_host_t *ha, uint16_t ctrl, dma_addr_t eft_dma,
+qla2x00_enable_eft_trace(scsi_qla_host_t *ha, dma_addr_t eft_dma,
     uint16_t buffers)
 {
 	int rval;
@@ -2363,22 +2363,47 @@ qla2x00_trace_control(scsi_qla_host_t *ha, uint16_t ctrl, dma_addr_t eft_dma,
 	DEBUG11(printk("%s(%ld): entered.\n", __func__, ha->host_no));
 
 	mcp->mb[0] = MBC_TRACE_CONTROL;
-	mcp->mb[1] = ctrl;
-	mcp->out_mb = MBX_1|MBX_0;
+	mcp->mb[1] = TC_EFT_ENABLE;
+	mcp->mb[2] = LSW(eft_dma);
+	mcp->mb[3] = MSW(eft_dma);
+	mcp->mb[4] = LSW(MSD(eft_dma));
+	mcp->mb[5] = MSW(MSD(eft_dma));
+	mcp->mb[6] = buffers;
+	mcp->mb[7] = TC_AEN_DISABLE;
+	mcp->out_mb = MBX_7|MBX_6|MBX_5|MBX_4|MBX_3|MBX_2|MBX_1|MBX_0;
 	mcp->in_mb = MBX_1|MBX_0;
-	if (ctrl == TC_ENABLE) {
-		mcp->mb[2] = LSW(eft_dma);
-		mcp->mb[3] = MSW(eft_dma);
-		mcp->mb[4] = LSW(MSD(eft_dma));
-		mcp->mb[5] = MSW(MSD(eft_dma));
-		mcp->mb[6] = buffers;
-		mcp->mb[7] = 0;
-		mcp->out_mb |= MBX_7|MBX_6|MBX_5|MBX_4|MBX_3|MBX_2;
-	}
 	mcp->tov = 30;
 	mcp->flags = 0;
 	rval = qla2x00_mailbox_command(ha, mcp);
+	if (rval != QLA_SUCCESS) {
+		DEBUG2_3_11(printk("%s(%ld): failed=%x mb[0]=%x mb[1]=%x.\n",
+		    __func__, ha->host_no, rval, mcp->mb[0], mcp->mb[1]));
+	} else {
+		DEBUG11(printk("%s(%ld): done.\n", __func__, ha->host_no));
+	}
+
+	return rval;
+}
 
+int
+qla2x00_disable_eft_trace(scsi_qla_host_t *ha)
+{
+	int rval;
+	mbx_cmd_t mc;
+	mbx_cmd_t *mcp = &mc;
+
+	if (!IS_FWI2_CAPABLE(ha))
+		return QLA_FUNCTION_FAILED;
+
+	DEBUG11(printk("%s(%ld): entered.\n", __func__, ha->host_no));
+
+	mcp->mb[0] = MBC_TRACE_CONTROL;
+	mcp->mb[1] = TC_EFT_DISABLE;
+	mcp->out_mb = MBX_1|MBX_0;
+	mcp->in_mb = MBX_1|MBX_0;
+	mcp->tov = 30;
+	mcp->flags = 0;
+	rval = qla2x00_mailbox_command(ha, mcp);
 	if (rval != QLA_SUCCESS) {
 		DEBUG2_3_11(printk("%s(%ld): failed=%x mb[0]=%x mb[1]=%x.\n",
 		    __func__, ha->host_no, rval, mcp->mb[0], mcp->mb[1]));
diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index 2dd4371..37b02c0 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -1856,7 +1856,7 @@ qla2x00_free_device(scsi_qla_host_t *ha)
 	}
 
 	if (ha->eft)
-		qla2x00_trace_control(ha, TC_DISABLE, 0, 0);
+		qla2x00_disable_eft_trace(ha);
 
 	ha->flags.online = 0;
 
-- 
1.5.4.rc3.14.g44397

