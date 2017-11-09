From: Himanshu Madhani <himanshu.madhani@cavium.com>
Subject: [PATCH v2 3/4] qla2xxx_nvmet: Add FC-NVMe Target LS request handling
Date: Wed, 8 Nov 2017 19:17:53 -0800
Message-ID: <20171109031754.10270-4-himanshu.madhani@cavium.com>
References: <20171109031754.10270-1-himanshu.madhani@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-sn1nam02on0087.outbound.protection.outlook.com ([104.47.36.87]:9967
        "EHLO NAM02-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751660AbdKIDSF (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 8 Nov 2017 22:18:05 -0500
In-Reply-To: <20171109031754.10270-1-himanshu.madhani@cavium.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-nvme@lists.infradead.org, hch@lst.de, sagi@grimberg.me, james.smart@broadcom.com, James.Bottomley@HansenPartnership.com, martin.petersen@oracle.com
Cc: himanshu.madhani@cavium.com, linux-scsi@vger.kernel.org

From: Anil Gurumurthy <anil.gurumurthy@cavium.com>

Signed-off-by: Anil Gurumurthy <anil.gurumurthy@cavium.com>
Signed-off-by: Giridhar Malavali <giridhar.malavali@cavium.com>
Signed-off-by: Darren Trapp <darren.trapp@cavium.com>
Signed-off-by: Himanshu Madhani <himanshu.madhani@cavium.com>
---
 drivers/scsi/qla2xxx/qla_dbg.c  |  1 +
 drivers/scsi/qla2xxx/qla_dbg.h  |  2 ++
 drivers/scsi/qla2xxx/qla_iocb.c | 42 ++++++++++++++++++++++++++++++++++++++++-
 3 files changed, 44 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/qla2xxx/qla_dbg.c b/drivers/scsi/qla2xxx/qla_dbg.c
index 3e9dc54b89a3..974cae74072f 100644
--- a/drivers/scsi/qla2xxx/qla_dbg.c
+++ b/drivers/scsi/qla2xxx/qla_dbg.c
@@ -67,6 +67,7 @@
  * | Target Mode Management	  |	  0xf09b       | 0xf002		|
  * |                              |                    | 0xf046-0xf049  |
  * | Target Mode Task Management  |	  0x1000d      |		|
+ * | NVME			  |	  0x11000      |		|
  * ----------------------------------------------------------------------
  */
 
diff --git a/drivers/scsi/qla2xxx/qla_dbg.h b/drivers/scsi/qla2xxx/qla_dbg.h
index 8877aa97d829..4ad97923e40b 100644
--- a/drivers/scsi/qla2xxx/qla_dbg.h
+++ b/drivers/scsi/qla2xxx/qla_dbg.h
@@ -367,6 +367,8 @@ ql_log_qp(uint32_t, struct qla_qpair *, int32_t, const char *fmt, ...);
 #define ql_dbg_tgt_tmr	0x00001000 /* Target mode task management */
 #define ql_dbg_tgt_dif  0x00000800 /* Target mode dif */
 
+#define ql_dbg_nvme 0x00000400 /* NVME Target */
+
 extern int qla27xx_dump_mpi_ram(struct qla_hw_data *, uint32_t, uint32_t *,
 	uint32_t, void **);
 extern int qla24xx_dump_ram(struct qla_hw_data *, uint32_t, uint32_t *,
diff --git a/drivers/scsi/qla2xxx/qla_iocb.c b/drivers/scsi/qla2xxx/qla_iocb.c
index d810a447cb4a..4ac2817e5f8d 100644
--- a/drivers/scsi/qla2xxx/qla_iocb.c
+++ b/drivers/scsi/qla2xxx/qla_iocb.c
@@ -2152,7 +2152,7 @@ __qla2x00_alloc_iocbs(struct qla_qpair *qpair, srb_t *sp)
 	sp->handle = handle;
 
 	/* Adjust entry-counts as needed. */
-	if (sp->type != SRB_SCSI_CMD)
+	if ((sp->type != SRB_SCSI_CMD) && (sp->type != SRB_NVMET_FCP))
 		req_cnt = sp->iocbs;
 
 skip_cmd_array:
@@ -3381,6 +3381,40 @@ qla_nvme_ls(srb_t *sp, struct pt_ls4_request *cmd_pkt)
 	return rval;
 }
 
+/*
+ * Build NVMET LS response
+ */
+static int
+qla_nvmet_ls(srb_t *sp, struct pt_ls4_request *rsp_pkt)
+{
+	struct srb_iocb *nvme;
+	int     rval = QLA_SUCCESS;
+
+	nvme = &sp->u.iocb_cmd;
+
+	rsp_pkt->entry_type = PT_LS4_REQUEST;
+	rsp_pkt->entry_count = 1;
+	rsp_pkt->control_flags = cpu_to_le16(CF_LS4_RESPONDER << CF_LS4_SHIFT);
+	rsp_pkt->handle = sp->handle;
+
+	rsp_pkt->nport_handle = sp->fcport->loop_id;
+	rsp_pkt->vp_index = nvme->u.nvme.vp_index;
+	rsp_pkt->exchange_address = cpu_to_le32(nvme->u.nvme.exchange_address);
+
+	rsp_pkt->tx_dseg_count = 1;
+	rsp_pkt->tx_byte_count = cpu_to_le16(nvme->u.nvme.rsp_len);
+	rsp_pkt->dseg0_len = cpu_to_le16(nvme->u.nvme.rsp_len);
+	rsp_pkt->dseg0_address[0] = cpu_to_le32(LSD(nvme->u.nvme.rsp_dma));
+	rsp_pkt->dseg0_address[1] = cpu_to_le32(MSD(nvme->u.nvme.rsp_dma));
+
+	ql_log(ql_log_info, sp->vha, 0xffff,
+		"Dumping the NVME-LS response IOCB\n");
+	ql_dump_buffer(ql_dbg_disc + ql_dbg_buffer, sp->vha, 0x2075,
+		(uint8_t *)rsp_pkt, sizeof(*rsp_pkt));
+
+	return rval;
+}
+
 int
 qla2x00_start_sp(srb_t *sp)
 {
@@ -3440,6 +3474,9 @@ qla2x00_start_sp(srb_t *sp)
 	case SRB_NVME_LS:
 		qla_nvme_ls(sp, pkt);
 		break;
+	case SRB_NVMET_LS:
+		qla_nvmet_ls(sp, pkt);
+		break;
 	case SRB_ABT_CMD:
 		IS_QLAFX00(ha) ?
 			qlafx00_abort_iocb(sp, pkt) :
@@ -3459,6 +3496,9 @@ qla2x00_start_sp(srb_t *sp)
 	case SRB_NACK_LOGO:
 		qla2x00_send_notify_ack_iocb(sp, pkt);
 		break;
+	case SRB_NVME_ELS_RSP:
+		qlt_send_els_resp(sp, pkt);
+		break;
 	default:
 		break;
 	}
-- 
2.12.0
