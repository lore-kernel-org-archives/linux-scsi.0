From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: [PATCH 15/16] qla2xxx: Stop firmware execution at unintialization time.
Date: Fri, 26 Aug 2005 19:10:20 -0700 (PDT)
Message-ID: <20050827021020.27275.86517.sendpatchset@plap.qlogic.com>
References: <20050827020750.27275.19733.sendpatchset@plap.qlogic.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pat.qlogic.com ([198.70.193.2]:53352 "EHLO avexch01.qlogic.com")
	by vger.kernel.org with ESMTP id S1751624AbVH0CKV (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 26 Aug 2005 22:10:21 -0400
In-Reply-To: <20050827020750.27275.19733.sendpatchset@plap.qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>, Linux-SCSI Mailing List <linux-scsi@vger.kernel.org>
Cc: Andrew Vasquez <andrew.vasquez@qlogic.com>

Stop firmware execution at unintialization time.

On ISP24xx parts, stop execution of firmware during ISP
tear-down.

Signed-off-by: Andrew Vasquez <andrew.vasquez@qlogic.com>
---

 drivers/scsi/qla2xxx/qla_def.h |    1 +
 drivers/scsi/qla2xxx/qla_gbl.h |    3 +++
 drivers/scsi/qla2xxx/qla_mbx.c |   30 ++++++++++++++++++++++++++++++
 drivers/scsi/qla2xxx/qla_os.c  |   14 ++++++++------
 4 files changed, 42 insertions(+), 6 deletions(-)

928d73db7de14683cc79e1672027ab0e75ccb9cc
diff --git a/drivers/scsi/qla2xxx/qla_def.h b/drivers/scsi/qla2xxx/qla_def.h
--- a/drivers/scsi/qla2xxx/qla_def.h
+++ b/drivers/scsi/qla2xxx/qla_def.h
@@ -631,6 +631,7 @@ typedef struct {
 #define MBC_WRITE_RAM_WORD_EXTENDED	0xd	/* Write RAM word extended */
 #define MBC_READ_RAM_EXTENDED		0xf	/* Read RAM extended. */
 #define MBC_IOCB_COMMAND		0x12	/* Execute IOCB command. */
+#define MBC_STOP_FIRMWARE		0x14	/* Stop firmware. */
 #define MBC_ABORT_COMMAND		0x15	/* Abort IOCB command. */
 #define MBC_ABORT_DEVICE		0x16	/* Abort device (ID/LUN). */
 #define MBC_ABORT_TARGET		0x17	/* Abort target (ID). */
diff --git a/drivers/scsi/qla2xxx/qla_gbl.h b/drivers/scsi/qla2xxx/qla_gbl.h
--- a/drivers/scsi/qla2xxx/qla_gbl.h
+++ b/drivers/scsi/qla2xxx/qla_gbl.h
@@ -213,6 +213,9 @@ qla2x00_get_serdes_params(scsi_qla_host_
 extern int
 qla2x00_set_serdes_params(scsi_qla_host_t *, uint16_t, uint16_t, uint16_t);
 
+extern int
+qla2x00_stop_firmware(scsi_qla_host_t *);
+
 /*
  * Global Function Prototypes in qla_isr.c source file.
  */
diff --git a/drivers/scsi/qla2xxx/qla_mbx.c b/drivers/scsi/qla2xxx/qla_mbx.c
--- a/drivers/scsi/qla2xxx/qla_mbx.c
+++ b/drivers/scsi/qla2xxx/qla_mbx.c
@@ -2427,3 +2427,32 @@ qla2x00_set_serdes_params(scsi_qla_host_
 
 	return rval;
 }
+
+int
+qla2x00_stop_firmware(scsi_qla_host_t *ha)
+{
+	int rval;
+	mbx_cmd_t mc;
+	mbx_cmd_t *mcp = &mc;
+
+	if (!IS_QLA24XX(ha) && !IS_QLA25XX(ha))
+		return QLA_FUNCTION_FAILED;
+
+	DEBUG11(printk("%s(%ld): entered.\n", __func__, ha->host_no));
+
+	mcp->mb[0] = MBC_STOP_FIRMWARE;
+	mcp->out_mb = MBX_0;
+	mcp->in_mb = MBX_0;
+	mcp->tov = 5;
+	mcp->flags = 0;
+	rval = qla2x00_mailbox_command(ha, mcp);
+
+	if (rval != QLA_SUCCESS) {
+		DEBUG2_3_11(printk("%s(%ld): failed=%x.\n", __func__,
+		    ha->host_no, rval));
+	} else {
+		DEBUG11(printk("%s(%ld): done.\n", __func__, ha->host_no));
+	}
+
+	return rval;
+}
diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -79,7 +79,7 @@ module_param(ql2xloginretrycount, int, S
 MODULE_PARM_DESC(ql2xloginretrycount,
 		"Specify an alternate value for the NVRAM login retry count.");
 
-int ql2xfwloadbin;
+int ql2xfwloadbin=1;
 module_param(ql2xfwloadbin, int, S_IRUGO|S_IRUSR);
 MODULE_PARM_DESC(ql2xfwloadbin,
 		"Load ISP2xxx firmware image via hotplug.");
@@ -1626,10 +1626,6 @@ qla2x00_free_device(scsi_qla_host_t *ha)
 	if (!IS_QLA2100(ha) && !IS_QLA2200(ha))
 		qla2x00_cancel_io_descriptors(ha);
 
-	/* turn-off interrupts on the card */
-	if (ha->interrupts_on)
-		ha->isp_ops.disable_intrs(ha);
-
 	/* Disable timer */
 	if (ha->timer_active)
 		qla2x00_stop_timer(ha);
@@ -1649,8 +1645,14 @@ qla2x00_free_device(scsi_qla_host_t *ha)
 		}
 	}
 
-	qla2x00_mem_free(ha);
+	/* Stop currently executing firmware. */
+	qla2x00_stop_firmware(ha);
 
+	/* turn-off interrupts on the card */
+	if (ha->interrupts_on)
+		ha->isp_ops.disable_intrs(ha);
+
+	qla2x00_mem_free(ha);
 
 	ha->flags.online = 0;
 

-- 
Andrew Vasquez
