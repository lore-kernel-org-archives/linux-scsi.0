From: Himanshu Madhani <himanshu.madhani@qlogic.com>
Subject: [PATCH 10/19] qla2xxx: Add bsg interface to support D_Port Diagnostics.
Date: Wed, 6 Jul 2016 11:14:26 -0400
Message-ID: <1467818075-15246-11-git-send-email-himanshu.madhani@qlogic.com>
References: <1467818075-15246-1-git-send-email-himanshu.madhani@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0b-0016ce01.pphosted.com ([67.231.156.153]:18523 "EHLO
	mx0b-0016ce01.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754786AbcGFQAG (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 6 Jul 2016 12:00:06 -0400
In-Reply-To: <1467818075-15246-1-git-send-email-himanshu.madhani@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com, martin.petersen@oracle.com
Cc: giridhar.malavali@qlogic.com, himanshu.madhani@qlogic.com, linux-scsi@vger.kernel.org

From: Joe Carnuccio <joe.carnuccio@qlogic.com>

Signed-off-by: Joe Carnuccio <joe.carnuccio@qlogic.com>
Signed-off-by: Himanshu Madhani <himanshu.madhani@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_bsg.c | 44 ++++++++++++++++++++++++++++++++
 drivers/scsi/qla2xxx/qla_bsg.h | 12 +++++++++
 drivers/scsi/qla2xxx/qla_dbg.c |  3 +--
 drivers/scsi/qla2xxx/qla_gbl.h |  3 +++
 drivers/scsi/qla2xxx/qla_isr.c |  7 +++--
 drivers/scsi/qla2xxx/qla_mbx.c | 58 +++++++++++++++++++++++++++++++++++++++++-
 6 files changed, 122 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_bsg.c b/drivers/scsi/qla2xxx/qla_bsg.c
index 8cadc4d..592e924 100644
--- a/drivers/scsi/qla2xxx/qla_bsg.c
+++ b/drivers/scsi/qla2xxx/qla_bsg.c
@@ -2296,6 +2296,47 @@ done:
 }
 
 static int
+qla2x00_do_dport_diagnostics(struct fc_bsg_job *bsg_job)
+{
+	struct Scsi_Host *host = bsg_job->shost;
+	scsi_qla_host_t *vha = shost_priv(host);
+	int rval;
+	struct qla_dport_diag *dd;
+
+	if (!IS_QLA83XX(vha->hw) && !IS_QLA27XX(vha->hw))
+		return -EPERM;
+
+	dd = kmalloc(sizeof(*dd), GFP_KERNEL);
+	if (!dd) {
+		ql_log(ql_log_warn, vha, 0x70db,
+		    "Failed to allocate memory for dport.\n");
+		return -ENOMEM;
+	}
+
+	sg_copy_to_buffer(bsg_job->request_payload.sg_list,
+	    bsg_job->request_payload.sg_cnt, dd, sizeof(*dd));
+
+	rval = qla26xx_dport_diagnostics(
+	    vha, dd->buf, sizeof(dd->buf), dd->options);
+	if (rval == QLA_SUCCESS) {
+		sg_copy_from_buffer(bsg_job->reply_payload.sg_list,
+		    bsg_job->reply_payload.sg_cnt, dd, sizeof(*dd));
+	}
+
+	bsg_job->reply->reply_payload_rcv_len = sizeof(*dd);
+	bsg_job->reply->reply_data.vendor_reply.vendor_rsp[0] =
+	    rval ? EXT_STATUS_MAILBOX : EXT_STATUS_OK;
+
+	bsg_job->reply_len = sizeof(*bsg_job->reply);
+	bsg_job->reply->result = DID_OK << 16;
+	bsg_job->job_done(bsg_job);
+
+	kfree(dd);
+
+	return 0;
+}
+
+static int
 qla2x00_process_vendor_specific(struct fc_bsg_job *bsg_job)
 {
 	switch (bsg_job->request->rqst_data.h_vendor.vendor_cmd[0]) {
@@ -2362,6 +2403,9 @@ qla2x00_process_vendor_specific(struct fc_bsg_job *bsg_job)
 	case QL_VND_GET_PRIV_STATS:
 		return qla2x00_get_priv_stats(bsg_job);
 
+	case QL_VND_DPORT_DIAGNOSTICS:
+		return qla2x00_do_dport_diagnostics(bsg_job);
+
 	default:
 		return -ENOSYS;
 	}
diff --git a/drivers/scsi/qla2xxx/qla_bsg.h b/drivers/scsi/qla2xxx/qla_bsg.h
index c80192d..3b1045f 100644
--- a/drivers/scsi/qla2xxx/qla_bsg.h
+++ b/drivers/scsi/qla2xxx/qla_bsg.h
@@ -29,6 +29,7 @@
 #define QL_VND_SET_FLASH_UPDATE_CAPS    0x16
 #define QL_VND_GET_BBCR_DATA    0x17
 #define QL_VND_GET_PRIV_STATS	0x18
+#define QL_VND_DPORT_DIAGNOSTICS	0x19
 
 /* BSG Vendor specific subcode returns */
 #define EXT_STATUS_OK			0
@@ -266,4 +267,15 @@ struct  qla_bbcr_data {
 	uint16_t  mbx1;			/* Port state */
 	uint8_t   reserved[9];
 } __packed;
+
+struct qla_dport_diag {
+	uint16_t options;
+	uint32_t buf[16];
+	uint8_t  unused[62];
+} __packed;
+
+/* D_Port options */
+#define QLA_DPORT_RESULT	0x0
+#define QLA_DPORT_START		0x2
+
 #endif
diff --git a/drivers/scsi/qla2xxx/qla_dbg.c b/drivers/scsi/qla2xxx/qla_dbg.c
index 2790e5f..2a1eb02 100644
--- a/drivers/scsi/qla2xxx/qla_dbg.c
+++ b/drivers/scsi/qla2xxx/qla_dbg.c
@@ -14,7 +14,7 @@
  * | Module Init and Probe        |       0x018f       | 0x0146         |
  * |                              |                    | 0x015b-0x0160	|
  * |                              |                    | 0x016e		|
- * | Mailbox commands             |       0x1191       | 		|
+ * | Mailbox commands             |       0x1196       |		|
  * |                              |                    |		|
  * | Device Discovery             |       0x2003       | 0x2016		|
  * |                              |                    | 0x2011-0x2012, |
@@ -41,7 +41,6 @@
  * |                              |                    | 0x70ad-0x70ae  |
  * |                              |                    | 0x70d0-0x70d6	|
  * |                              |                    | 0x70d7-0x70db  |
- * |                              |                    | 0x70db		|
  * | Task Management              |       0x803d       | 0x8000,0x800b  |
  * |                              |                    | 0x8019         |
  * |                              |                    | 0x8025,0x8026  |
diff --git a/drivers/scsi/qla2xxx/qla_gbl.h b/drivers/scsi/qla2xxx/qla_gbl.h
index be24e62..6ca0081 100644
--- a/drivers/scsi/qla2xxx/qla_gbl.h
+++ b/drivers/scsi/qla2xxx/qla_gbl.h
@@ -445,6 +445,9 @@ qla2x00_port_logout(scsi_qla_host_t *, struct fc_port *);
 extern int
 qla2x00_dump_mctp_data(scsi_qla_host_t *, dma_addr_t, uint32_t, uint32_t);
 
+extern int
+qla26xx_dport_diagnostics(scsi_qla_host_t *, void *, uint, uint);
+
 /*
  * Global Function Prototypes in qla_isr.c source file.
  */
diff --git a/drivers/scsi/qla2xxx/qla_isr.c b/drivers/scsi/qla2xxx/qla_isr.c
index f1bfb42..b8d0b78a 100644
--- a/drivers/scsi/qla2xxx/qla_isr.c
+++ b/drivers/scsi/qla2xxx/qla_isr.c
@@ -1152,10 +1152,13 @@ global_port_update:
 
 	case MBA_DPORT_DIAGNOSTICS:
 		ql_dbg(ql_dbg_async, vha, 0x5052,
-		    "D-Port Diagnostics: %04x %04x=%s\n", mb[0], mb[1],
+		    "D-Port Diagnostics: %04x result=%s index=%u size=%u\n",
+		    mb[0],
 		    mb[1] == 0 ? "start" :
 		    mb[1] == 1 ? "done (ok)" :
-		    mb[1] == 2 ? "done (error)" : "other");
+		    mb[1] == 2 ? "done (error)" : "other",
+		    LSB(mb[2]),
+		    mb[3]);
 		break;
 
 	case MBA_TEMPERATURE_ALERT:
diff --git a/drivers/scsi/qla2xxx/qla_mbx.c b/drivers/scsi/qla2xxx/qla_mbx.c
index 97099ce..0f7b83a 100644
--- a/drivers/scsi/qla2xxx/qla_mbx.c
+++ b/drivers/scsi/qla2xxx/qla_mbx.c
@@ -1872,7 +1872,7 @@ qla2x00_get_firmware_state(scsi_qla_host_t *vha, uint16_t *states)
 	states[0] = mcp->mb[1];
 	if (IS_FWI2_CAPABLE(vha->hw)) {
 		states[1] = mcp->mb[2];
-		states[2] = mcp->mb[3];
+		states[2] = mcp->mb[3];  /* SFP info */
 		states[3] = mcp->mb[4];
 		states[4] = mcp->mb[5];
 		states[5] = mcp->mb[6];  /* DPORT status */
@@ -5748,3 +5748,59 @@ qla2x00_dump_mctp_data(scsi_qla_host_t *vha, dma_addr_t req_dma, uint32_t addr,
 
 	return rval;
 }
+
+int
+qla26xx_dport_diagnostics(scsi_qla_host_t *vha,
+	void *dd_buf, uint size, uint options)
+{
+	int rval;
+	mbx_cmd_t mc;
+	mbx_cmd_t *mcp = &mc;
+	dma_addr_t dd_dma;
+
+	if (!IS_QLA83XX(vha->hw) && !IS_QLA27XX(vha->hw))
+		return QLA_FUNCTION_FAILED;
+
+	ql_dbg(ql_dbg_mbx + ql_dbg_verbose, vha, 0x1192,
+	    "Entered %s.\n", __func__);
+
+	if (size < 1024) {
+		ql_log(ql_log_warn, vha, 0x1193, "Failed insufficient size.\n");
+		return QLA_FUNCTION_PARAMETER_ERROR;
+	}
+
+	dd_dma = dma_map_single(&vha->hw->pdev->dev,
+	    dd_buf, size, DMA_FROM_DEVICE);
+	if (!dd_dma) {
+		ql_log(ql_log_warn, vha, 0x1194, "Failed to map dma buffer.\n");
+		return QLA_MEMORY_ALLOC_FAILED;
+	}
+
+	memset(dd_buf, 0, size);
+
+	mcp->mb[0] = MBC_DPORT_DIAGNOSTICS;
+	mcp->mb[1] = options;
+	mcp->mb[2] = MSW(LSD(dd_dma));
+	mcp->mb[3] = LSW(LSD(dd_dma));
+	mcp->mb[6] = MSW(MSD(dd_dma));
+	mcp->mb[7] = LSW(MSD(dd_dma));
+	mcp->mb[8] = size;
+	mcp->out_mb = MBX_8|MBX_7|MBX_6|MBX_3|MBX_2|MBX_1|MBX_0;
+	mcp->in_mb = MBX_3|MBX_2|MBX_1|MBX_0;
+	mcp->buf_size = size;
+	mcp->flags = MBX_DMA_IN;
+	mcp->tov = MBX_TOV_SECONDS * 4;
+	rval = qla2x00_mailbox_command(vha, mcp);
+
+	if (rval != QLA_SUCCESS) {
+		ql_dbg(ql_dbg_mbx, vha, 0x1195, "Failed=%x.\n", rval);
+	} else {
+		ql_dbg(ql_dbg_mbx + ql_dbg_verbose, vha, 0x1196,
+		    "Done %s.\n", __func__);
+	}
+
+	dma_unmap_single(&vha->hw->pdev->dev, dd_dma,
+	    size, DMA_FROM_DEVICE);
+
+	return rval;
+}
-- 
2.7.2

