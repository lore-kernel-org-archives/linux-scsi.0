From: Saurav Kashyap <saurav.kashyap@qlogic.com>
Subject: [PATCH 12/42] qla2xxx: Add ISP8044 serdes bsg interface.
Date: Fri, 11 Apr 2014 16:54:17 -0400
Message-ID: <1397249687-32666-13-git-send-email-saurav.kashyap@qlogic.com>
References: <1397249687-32666-1-git-send-email-saurav.kashyap@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0b-0016ce01.pphosted.com ([67.231.156.153]:13427 "EHLO
	mx0b-0016ce01.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755132AbaDKVcH (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 11 Apr 2014 17:32:07 -0400
In-Reply-To: <1397249687-32666-1-git-send-email-saurav.kashyap@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com
Cc: giridhar.malavali@qlogic.com, saurav.kashyap@qlogic.com, andrew.vasquez@qlogic.com, linux-scsi@vger.kernel.org

From: Joe Carnuccio <joe.carnuccio@qlogic.com>

Signed-off-by: Joe Carnuccio <joe.carnuccio@qlogic.com>
Signed-off-by: Saurav Kashyap <saurav.kashyap@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_bsg.c |   47 +++++++++++++++++++++++++-
 drivers/scsi/qla2xxx/qla_bsg.h |    7 ++++
 drivers/scsi/qla2xxx/qla_dbg.c |    2 +-
 drivers/scsi/qla2xxx/qla_def.h |    7 ++++
 drivers/scsi/qla2xxx/qla_gbl.h |    5 +++
 drivers/scsi/qla2xxx/qla_mbx.c |   72 ++++++++++++++++++++++++++++++++++++++++
 6 files changed, 137 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_bsg.c b/drivers/scsi/qla2xxx/qla_bsg.c
index 71ff340..467c694 100644
--- a/drivers/scsi/qla2xxx/qla_bsg.c
+++ b/drivers/scsi/qla2xxx/qla_bsg.c
@@ -2054,9 +2054,49 @@ qla26xx_serdes_op(struct fc_bsg_job *bsg_job)
 		bsg_job->reply->reply_payload_rcv_len = sizeof(sr);
 		break;
 	default:
-		ql_log(ql_log_warn, vha, 0x708c,
+		ql_dbg(ql_dbg_user, vha, 0x708c,
 		    "Unknown serdes cmd %x.\n", sr.cmd);
-		rval = -EDOM;
+		rval = -EINVAL;
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
+qla8044_serdes_op(struct fc_bsg_job *bsg_job)
+{
+	struct Scsi_Host *host = bsg_job->shost;
+	scsi_qla_host_t *vha = shost_priv(host);
+	int rval = 0;
+	struct qla_serdes_reg_ex sr;
+
+	memset(&sr, 0, sizeof(sr));
+
+	sg_copy_to_buffer(bsg_job->request_payload.sg_list,
+	    bsg_job->request_payload.sg_cnt, &sr, sizeof(sr));
+
+	switch (sr.cmd) {
+	case INT_SC_SERDES_WRITE_REG:
+		rval = qla8044_write_serdes_word(vha, sr.addr, sr.val);
+		bsg_job->reply->reply_payload_rcv_len = 0;
+		break;
+	case INT_SC_SERDES_READ_REG:
+		rval = qla8044_read_serdes_word(vha, sr.addr, &sr.val);
+		sg_copy_from_buffer(bsg_job->reply_payload.sg_list,
+		    bsg_job->reply_payload.sg_cnt, &sr, sizeof(sr));
+		bsg_job->reply->reply_payload_rcv_len = sizeof(sr);
+		break;
+	default:
+		ql_dbg(ql_dbg_user, vha, 0x70cf,
+		    "Unknown serdes cmd %x.\n", sr.cmd);
+		rval = -EINVAL;
 		break;
 	}
 
@@ -2121,6 +2161,9 @@ qla2x00_process_vendor_specific(struct fc_bsg_job *bsg_job)
 	case QL_VND_SERDES_OP:
 		return qla26xx_serdes_op(bsg_job);
 
+	case QL_VND_SERDES_OP_EX:
+		return qla8044_serdes_op(bsg_job);
+
 	default:
 		return -ENOSYS;
 	}
diff --git a/drivers/scsi/qla2xxx/qla_bsg.h b/drivers/scsi/qla2xxx/qla_bsg.h
index e5c2126..4e49d0a 100644
--- a/drivers/scsi/qla2xxx/qla_bsg.h
+++ b/drivers/scsi/qla2xxx/qla_bsg.h
@@ -24,6 +24,7 @@
 #define QL_VND_READ_I2C		0x11
 #define QL_VND_FX00_MGMT_CMD	0x12
 #define QL_VND_SERDES_OP	0x13
+#define	QL_VND_SERDES_OP_EX	0x14
 
 /* BSG Vendor specific subcode returns */
 #define EXT_STATUS_OK			0
@@ -225,4 +226,10 @@ struct qla_serdes_reg {
 	uint16_t val;
 } __packed;
 
+struct qla_serdes_reg_ex {
+	uint16_t cmd;
+	uint32_t addr;
+	uint32_t val;
+} __packed;
+
 #endif
diff --git a/drivers/scsi/qla2xxx/qla_dbg.c b/drivers/scsi/qla2xxx/qla_dbg.c
index 7cf1044..ba72e16 100644
--- a/drivers/scsi/qla2xxx/qla_dbg.c
+++ b/drivers/scsi/qla2xxx/qla_dbg.c
@@ -15,7 +15,7 @@
  * |                              |                    | 0x0144,0x0146	|
  * |                              |                    | 0x015b-0x0160	|
  * |                              |                    | 0x016e-0x0170	|
- * | Mailbox commands             |       0x1187       | 0x1018-0x1019	|
+ * | Mailbox commands             |       0x118d       | 0x1018-0x1019	|
  * |                              |                    | 0x10ca         |
  * |                              |                    | 0x1115-0x1116  |
  * |                              |                    | 0x111a-0x111b	|
diff --git a/drivers/scsi/qla2xxx/qla_def.h b/drivers/scsi/qla2xxx/qla_def.h
index bab1cf1..2326827 100644
--- a/drivers/scsi/qla2xxx/qla_def.h
+++ b/drivers/scsi/qla2xxx/qla_def.h
@@ -965,6 +965,13 @@ struct mbx_cmd_32 {
  */
 #define MBC_WRITE_MPI_REGISTER		0x01    /* Write MPI Register. */
 
+/*
+ * ISP8044 mailbox commands
+ */
+#define MBC_SET_GET_ETH_SERDES_REG	0x150
+#define HCS_WRITE_SERDES		0x3
+#define HCS_READ_SERDES			0x4
+
 /* Firmware return data sizes */
 #define FCAL_MAP_SIZE	128
 
diff --git a/drivers/scsi/qla2xxx/qla_gbl.h b/drivers/scsi/qla2xxx/qla_gbl.h
index e665e81..b66710b 100644
--- a/drivers/scsi/qla2xxx/qla_gbl.h
+++ b/drivers/scsi/qla2xxx/qla_gbl.h
@@ -347,6 +347,11 @@ extern int
 qla2x00_read_serdes_word(scsi_qla_host_t *, uint16_t, uint16_t *);
 
 extern int
+qla8044_write_serdes_word(scsi_qla_host_t *, uint32_t, uint32_t);
+extern int
+qla8044_read_serdes_word(scsi_qla_host_t *, uint32_t, uint32_t *);
+
+extern int
 qla2x00_set_serdes_params(scsi_qla_host_t *, uint16_t, uint16_t, uint16_t);
 
 extern int
diff --git a/drivers/scsi/qla2xxx/qla_mbx.c b/drivers/scsi/qla2xxx/qla_mbx.c
index 601562f..0f7887d 100644
--- a/drivers/scsi/qla2xxx/qla_mbx.c
+++ b/drivers/scsi/qla2xxx/qla_mbx.c
@@ -2879,6 +2879,78 @@ qla2x00_read_serdes_word(scsi_qla_host_t *vha, uint16_t addr, uint16_t *data)
 	return rval;
 }
 
+int
+qla8044_write_serdes_word(scsi_qla_host_t *vha, uint32_t addr, uint32_t data)
+{
+	int rval;
+	mbx_cmd_t mc;
+	mbx_cmd_t *mcp = &mc;
+
+	if (!IS_QLA8044(vha->hw))
+		return QLA_FUNCTION_FAILED;
+
+	ql_dbg(ql_dbg_mbx + ql_dbg_verbose, vha, 0x1186,
+	    "Entered %s.\n", __func__);
+
+	mcp->mb[0] = MBC_SET_GET_ETH_SERDES_REG;
+	mcp->mb[1] = HCS_WRITE_SERDES;
+	mcp->mb[3] = LSW(addr);
+	mcp->mb[4] = MSW(addr);
+	mcp->mb[5] = LSW(data);
+	mcp->mb[6] = MSW(data);
+	mcp->out_mb = MBX_6|MBX_5|MBX_4|MBX_3|MBX_1|MBX_0;
+	mcp->in_mb = MBX_0;
+	mcp->tov = MBX_TOV_SECONDS;
+	mcp->flags = 0;
+	rval = qla2x00_mailbox_command(vha, mcp);
+
+	if (rval != QLA_SUCCESS) {
+		ql_dbg(ql_dbg_mbx, vha, 0x1187,
+		    "Failed=%x mb[0]=%x.\n", rval, mcp->mb[0]);
+	} else {
+		ql_dbg(ql_dbg_mbx + ql_dbg_verbose, vha, 0x1188,
+		    "Done %s.\n", __func__);
+	}
+
+	return rval;
+}
+
+int
+qla8044_read_serdes_word(scsi_qla_host_t *vha, uint32_t addr, uint32_t *data)
+{
+	int rval;
+	mbx_cmd_t mc;
+	mbx_cmd_t *mcp = &mc;
+
+	if (!IS_QLA8044(vha->hw))
+		return QLA_FUNCTION_FAILED;
+
+	ql_dbg(ql_dbg_mbx + ql_dbg_verbose, vha, 0x1189,
+	    "Entered %s.\n", __func__);
+
+	mcp->mb[0] = MBC_SET_GET_ETH_SERDES_REG;
+	mcp->mb[1] = HCS_READ_SERDES;
+	mcp->mb[3] = LSW(addr);
+	mcp->mb[4] = MSW(addr);
+	mcp->out_mb = MBX_4|MBX_3|MBX_1|MBX_0;
+	mcp->in_mb = MBX_2|MBX_1|MBX_0;
+	mcp->tov = MBX_TOV_SECONDS;
+	mcp->flags = 0;
+	rval = qla2x00_mailbox_command(vha, mcp);
+
+	*data = mcp->mb[2] << 16 | mcp->mb[1];
+
+	if (rval != QLA_SUCCESS) {
+		ql_dbg(ql_dbg_mbx, vha, 0x118a,
+		    "Failed=%x mb[0]=%x.\n", rval, mcp->mb[0]);
+	} else {
+		ql_dbg(ql_dbg_mbx + ql_dbg_verbose, vha, 0x118b,
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

