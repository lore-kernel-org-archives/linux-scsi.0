From: Saurav Kashyap <saurav.kashyap@qlogic.com>
Subject: [PATCH 11/22] qla2xxx: Add BSG interface for read/write serdes register.
Date: Wed, 30 Oct 2013 03:38:18 -0400
Message-ID: <1383118709-5569-12-git-send-email-saurav.kashyap@qlogic.com>
References: <1383118709-5569-1-git-send-email-saurav.kashyap@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from [67.231.148.157] ([67.231.148.157]:15186 "EHLO
	mx0a-0016ce01.pphosted.com" rhost-flags-FAIL-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752684Ab3J3ILW (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 30 Oct 2013 04:11:22 -0400
In-Reply-To: <1383118709-5569-1-git-send-email-saurav.kashyap@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com
Cc: giridhar.malavali@qlogic.com, saurav.kashyap@qlogic.com, andrew.vasquez@qlogic.com, linux-scsi@vger.kernel.org

From: Joe Carnuccio <joe.carnuccio@qlogic.com>

Signed-off-by: Joe Carnuccio <joe.carnuccio@qlogic.com>
Signed-off-by: Saurav Kashyap <saurav.kashyap@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_bsg.c |   44 +++++++++++++++++++++++++
 drivers/scsi/qla2xxx/qla_bsg.h |   13 +++++++
 drivers/scsi/qla2xxx/qla_dbg.c |    2 +-
 drivers/scsi/qla2xxx/qla_def.h |    3 +-
 drivers/scsi/qla2xxx/qla_gbl.h |    5 +++
 drivers/scsi/qla2xxx/qla_mbx.c |   69 ++++++++++++++++++++++++++++++++++++++++
 6 files changed, 134 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_bsg.c b/drivers/scsi/qla2xxx/qla_bsg.c
index aa57bf0..f15d03e 100644
--- a/drivers/scsi/qla2xxx/qla_bsg.c
+++ b/drivers/scsi/qla2xxx/qla_bsg.c
@@ -2022,6 +2022,46 @@ done:
 }
 
 static int
+qla26xx_serdes_op(struct fc_bsg_job *bsg_job)
+{
+	struct Scsi_Host *host = bsg_job->shost;
+	scsi_qla_host_t *vha = shost_priv(host);
+	int rval = 0;
+	struct qla_serdes_reg sr;
+
+	memset(&sr, 0, sizeof(sr));
+
+	sg_copy_to_buffer(bsg_job->request_payload.sg_list,
+	    bsg_job->request_payload.sg_cnt, &sr, sizeof(sr));
+
+	switch (sr.cmd) {
+	case INT_SC_SERDES_WRITE_REG:
+		rval = qla2x00_write_serdes_word(vha, sr.addr, sr.val);
+		bsg_job->reply->reply_payload_rcv_len = 0;
+		break;
+	case INT_SC_SERDES_READ_REG:
+		rval = qla2x00_read_serdes_word(vha, sr.addr, &sr.val);
+		sg_copy_from_buffer(bsg_job->reply_payload.sg_list,
+		    bsg_job->reply_payload.sg_cnt, &sr, sizeof(sr));
+		bsg_job->reply->reply_payload_rcv_len = sizeof(sr);
+		break;
+	default:
+		ql_log(ql_log_warn, vha, 0x708c,
+		    "Unknown serdes cmd %x.\n", sr.cmd);
+		rval = -EDOM;
+		break;
+	}
+
+	bsg_job->reply->reply_data.vendor_reply.vendor_rsp[0] =
+	    rval ? EXT_STATUS_MAILBOX : 0;
+
+	bsg_job->reply_len = sizeof(struct fc_bsg_reply);
+	bsg_job->reply->result = DID_OK << 16;
+	bsg_job->job_done(bsg_job);
+	return 0;
+}
+
+static int
 qla2x00_process_vendor_specific(struct fc_bsg_job *bsg_job)
 {
 	switch (bsg_job->request->rqst_data.h_vendor.vendor_cmd[0]) {
@@ -2069,6 +2109,10 @@ qla2x00_process_vendor_specific(struct fc_bsg_job *bsg_job)
 
 	case QL_VND_FX00_MGMT_CMD:
 		return qlafx00_mgmt_cmd(bsg_job);
+
+	case QL_VND_SERDES_OP:
+		return qla26xx_serdes_op(bsg_job);
+
 	default:
 		return -ENOSYS;
 	}
diff --git a/drivers/scsi/qla2xxx/qla_bsg.h b/drivers/scsi/qla2xxx/qla_bsg.h
index 04f7703..e5c2126 100644
--- a/drivers/scsi/qla2xxx/qla_bsg.h
+++ b/drivers/scsi/qla2xxx/qla_bsg.h
@@ -23,6 +23,7 @@
 #define QL_VND_WRITE_I2C	0x10
 #define QL_VND_READ_I2C		0x11
 #define QL_VND_FX00_MGMT_CMD	0x12
+#define QL_VND_SERDES_OP	0x13
 
 /* BSG Vendor specific subcode returns */
 #define EXT_STATUS_OK			0
@@ -212,4 +213,16 @@ struct qla_i2c_access {
 	uint8_t  buffer[0x40];
 } __packed;
 
+/* 26xx serdes register interface */
+
+/* serdes reg commands */
+#define INT_SC_SERDES_READ_REG		1
+#define INT_SC_SERDES_WRITE_REG		2
+
+struct qla_serdes_reg {
+	uint16_t cmd;
+	uint16_t addr;
+	uint16_t val;
+} __packed;
+
 #endif
diff --git a/drivers/scsi/qla2xxx/qla_dbg.c b/drivers/scsi/qla2xxx/qla_dbg.c
index 66f6597..9cd767c 100644
--- a/drivers/scsi/qla2xxx/qla_dbg.c
+++ b/drivers/scsi/qla2xxx/qla_dbg.c
@@ -12,7 +12,7 @@
  * |             Level            |   Last Value Used  |     Holes	|
  * ----------------------------------------------------------------------
  * | Module Init and Probe        |       0x015b       | 0x4b,0xba,0xfa |
- * | Mailbox commands             |       0x1181       | 0x111a-0x111b  |
+ * | Mailbox commands             |       0x1187       | 0x111a-0x111b  |
  * |                              |                    | 0x1155-0x1158  |
  * |                              |                    | 0x1018-0x1019  |
  * |                              |                    | 0x1115-0x1116  |
diff --git a/drivers/scsi/qla2xxx/qla_def.h b/drivers/scsi/qla2xxx/qla_def.h
index ac62bca..41d6491 100644
--- a/drivers/scsi/qla2xxx/qla_def.h
+++ b/drivers/scsi/qla2xxx/qla_def.h
@@ -862,7 +862,6 @@ struct mbx_cmd_32 {
  */
 #define MBC_LOAD_RAM			1	/* Load RAM. */
 #define MBC_EXECUTE_FIRMWARE		2	/* Execute firmware. */
-#define MBC_WRITE_RAM_WORD		4	/* Write RAM word. */
 #define MBC_READ_RAM_WORD		5	/* Read RAM word. */
 #define MBC_MAILBOX_REGISTER_TEST	6	/* Wrap incoming mailboxes */
 #define MBC_VERIFY_CHECKSUM		7	/* Verify checksum. */
@@ -937,6 +936,8 @@ struct mbx_cmd_32 {
 /*
  * ISP24xx mailbox commands
  */
+#define MBC_WRITE_SERDES		0x3	/* Write serdes word. */
+#define MBC_READ_SERDES			0x4	/* Read serdes word. */
 #define MBC_SERDES_PARAMS		0x10	/* Serdes Tx Parameters. */
 #define MBC_GET_IOCB_STATUS		0x12	/* Get IOCB status command. */
 #define MBC_PORT_PARAMS			0x1A	/* Port iDMA Parameters. */
diff --git a/drivers/scsi/qla2xxx/qla_gbl.h b/drivers/scsi/qla2xxx/qla_gbl.h
index 359d0d9..00427e0 100644
--- a/drivers/scsi/qla2xxx/qla_gbl.h
+++ b/drivers/scsi/qla2xxx/qla_gbl.h
@@ -341,6 +341,11 @@ extern int
 qla2x00_system_error(scsi_qla_host_t *);
 
 extern int
+qla2x00_write_serdes_word(scsi_qla_host_t *, uint16_t, uint16_t);
+extern int
+qla2x00_read_serdes_word(scsi_qla_host_t *, uint16_t, uint16_t *);
+
+extern int
 qla2x00_set_serdes_params(scsi_qla_host_t *, uint16_t, uint16_t, uint16_t);
 
 extern int
diff --git a/drivers/scsi/qla2xxx/qla_mbx.c b/drivers/scsi/qla2xxx/qla_mbx.c
index 5957fee..b94511a 100644
--- a/drivers/scsi/qla2xxx/qla_mbx.c
+++ b/drivers/scsi/qla2xxx/qla_mbx.c
@@ -2800,6 +2800,75 @@ qla2x00_system_error(scsi_qla_host_t *vha)
 	return rval;
 }
 
+int
+qla2x00_write_serdes_word(scsi_qla_host_t *vha, uint16_t addr, uint16_t data)
+{
+	int rval;
+	mbx_cmd_t mc;
+	mbx_cmd_t *mcp = &mc;
+
+	if (!IS_QLA2031(vha->hw))
+		return QLA_FUNCTION_FAILED;
+
+	ql_dbg(ql_dbg_mbx + ql_dbg_verbose, vha, 0x1182,
+	    "Entered %s.\n", __func__);
+
+	mcp->mb[0] = MBC_WRITE_SERDES;
+	mcp->mb[1] = addr;
+	mcp->mb[2] = data & 0xff;
+	mcp->mb[3] = 0;
+	mcp->out_mb = MBX_3|MBX_2|MBX_1|MBX_0;
+	mcp->in_mb = MBX_0;
+	mcp->tov = MBX_TOV_SECONDS;
+	mcp->flags = 0;
+	rval = qla2x00_mailbox_command(vha, mcp);
+
+	if (rval != QLA_SUCCESS) {
+		ql_dbg(ql_dbg_mbx, vha, 0x1183,
+		    "Failed=%x mb[0]=%x.\n", rval, mcp->mb[0]);
+	} else {
+		ql_dbg(ql_dbg_mbx + ql_dbg_verbose, vha, 0x1184,
+		    "Done %s.\n", __func__);
+	}
+
+	return rval;
+}
+
+int
+qla2x00_read_serdes_word(scsi_qla_host_t *vha, uint16_t addr, uint16_t *data)
+{
+	int rval;
+	mbx_cmd_t mc;
+	mbx_cmd_t *mcp = &mc;
+
+	if (!IS_QLA2031(vha->hw))
+		return QLA_FUNCTION_FAILED;
+
+	ql_dbg(ql_dbg_mbx + ql_dbg_verbose, vha, 0x1185,
+	    "Entered %s.\n", __func__);
+
+	mcp->mb[0] = MBC_READ_SERDES;
+	mcp->mb[1] = addr;
+	mcp->mb[3] = 0;
+	mcp->out_mb = MBX_3|MBX_1|MBX_0;
+	mcp->in_mb = MBX_1|MBX_0;
+	mcp->tov = MBX_TOV_SECONDS;
+	mcp->flags = 0;
+	rval = qla2x00_mailbox_command(vha, mcp);
+
+	*data = mcp->mb[1] & 0xff;
+
+	if (rval != QLA_SUCCESS) {
+		ql_dbg(ql_dbg_mbx, vha, 0x1186,
+		    "Failed=%x mb[0]=%x.\n", rval, mcp->mb[0]);
+	} else {
+		ql_dbg(ql_dbg_mbx + ql_dbg_verbose, vha, 0x1187,
+		    "Done %s.\n", __func__);
+	}
+
+	return rval;
+}
+
 /**
  * qla2x00_set_serdes_params() -
  * @ha: HA context
-- 
1.7.7

