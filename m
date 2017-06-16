From: Himanshu Madhani <himanshu.madhani@cavium.com>
Subject: [PATCH 2/6] qla2xxx: Add FC-NVMe command handling
Date: Fri, 16 Jun 2017 15:47:40 -0700
Message-ID: <20170616224744.3681-3-himanshu.madhani@cavium.com>
References: <20170616224744.3681-1-himanshu.madhani@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bn3nam01on0044.outbound.protection.outlook.com ([104.47.33.44]:58842
        "EHLO NAM01-BN3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751901AbdFPWr6 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 16 Jun 2017 18:47:58 -0400
In-Reply-To: <20170616224744.3681-1-himanshu.madhani@cavium.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: martin.petersen@oracle.com
Cc: himanshu.madhani@cavium.com, linux-scsi@vger.kernel.org, giridhar.malaval@cavium.com, darren.trapp@cavium.com

From: Duane Grigsby <duane.grigsby@cavium.com>

Signed-off-by: Darren Trapp <darren.trapp@cavium.com>
Signed-off-by: Duane Grigsby <duane.grigsby@cavium.com>
Signed-off-by: Anil Gurumurthy <anil.gurumurhty@cavium.com>
Signed-off-by: Giridhar Malavali <giridhar.malavali@cavium.com>
Signed-off-by: Himanshu Madhani <himanshu.madhani@cavium.com>
---
 drivers/scsi/qla2xxx/qla_def.h | 17 +++++++++
 drivers/scsi/qla2xxx/qla_fw.h  | 28 ++++++++++++--
 drivers/scsi/qla2xxx/qla_isr.c | 86 ++++++++++++++++++++++++++++++++++++++++++
 drivers/scsi/qla2xxx/qla_os.c  | 18 ++++++++-
 4 files changed, 144 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_def.h b/drivers/scsi/qla2xxx/qla_def.h
index bd1b3fef95a4..693c42392886 100644
--- a/drivers/scsi/qla2xxx/qla_def.h
+++ b/drivers/scsi/qla2xxx/qla_def.h
@@ -412,6 +412,20 @@ struct srb_iocb {
 		struct {
 			struct imm_ntfy_from_isp *ntfy;
 		} nack;
+		struct {
+			__le16 comp_status;
+			uint16_t rsp_pyld_len;
+			uint8_t	aen_op;
+			void *desc;
+
+			/* These are only used with ls4 requests */
+			int cmd_len;
+			int rsp_len;
+			dma_addr_t cmd_dma;
+			dma_addr_t rsp_dma;
+			uint32_t dl;
+			uint32_t timeout_sec;
+		} nvme;
 	} u;
 
 	struct timer_list timer;
@@ -437,6 +451,7 @@ struct srb_iocb {
 #define SRB_NACK_PLOGI	16
 #define SRB_NACK_PRLI	17
 #define SRB_NACK_LOGO	18
+#define SRB_NVME_CMD	19
 #define SRB_PRLI_CMD	21
 
 enum {
@@ -4111,6 +4126,8 @@ typedef struct scsi_qla_host {
 	struct		nvme_fc_local_port *nvme_local_port;
 	atomic_t	nvme_ref_count;
 	struct list_head nvme_rport_list;
+	atomic_t 	nvme_active_aen_cnt;
+	uint16_t	nvme_last_rptd_aen;
 
 	uint16_t	fcoe_vlan_id;
 	uint16_t	fcoe_fcf_idx;
diff --git a/drivers/scsi/qla2xxx/qla_fw.h b/drivers/scsi/qla2xxx/qla_fw.h
index dcae62d4cbeb..7d9a076c4667 100644
--- a/drivers/scsi/qla2xxx/qla_fw.h
+++ b/drivers/scsi/qla2xxx/qla_fw.h
@@ -603,9 +603,14 @@ struct sts_entry_24xx {
 
 	uint32_t residual_len;		/* FW calc residual transfer length. */
 
-	uint16_t reserved_1;
+	union {
+		uint16_t reserved_1;
+		uint16_t nvme_rsp_pyld_len;
+	};
+
 	uint16_t state_flags;		/* State flags. */
 #define SF_TRANSFERRED_DATA	BIT_11
+#define SF_NVME_ERSP            BIT_6
 #define SF_FCP_RSP_DMA		BIT_0
 
 	uint16_t retry_delay;
@@ -615,8 +620,25 @@ struct sts_entry_24xx {
 	uint32_t rsp_residual_count;	/* FCP RSP residual count. */
 
 	uint32_t sense_len;		/* FCP SENSE length. */
-	uint32_t rsp_data_len;		/* FCP response data length. */
-	uint8_t data[28];		/* FCP response/sense information. */
+
+	union {
+		struct {
+			uint32_t rsp_data_len;	/* FCP response data length  */
+			uint8_t data[28];	/* FCP rsp/sense information */
+		};
+		struct {
+			/* nvme ersp hdr */
+			__u8	status_code;
+			__u8	rsvd0;
+			__be16	iu_len;
+			__be32	rsn;
+			__be32	xfrd_len;
+			__be32	rsvd12;
+			uint8_t	cqe[16];
+		};
+		uint8_t nvme_ersp_data[32];
+	};
+
 	/*
 	 * If DIF Error is set in comp_status, these additional fields are
 	 * defined:
diff --git a/drivers/scsi/qla2xxx/qla_isr.c b/drivers/scsi/qla2xxx/qla_isr.c
index 40385bc1d1fa..0d60fd0da604 100644
--- a/drivers/scsi/qla2xxx/qla_isr.c
+++ b/drivers/scsi/qla2xxx/qla_isr.c
@@ -1799,6 +1799,86 @@ qla24xx_tm_iocb_entry(scsi_qla_host_t *vha, struct req_que *req, void *tsk)
 	sp->done(sp, 0);
 }
 
+static void
+qla24xx_nvme_iocb_entry(scsi_qla_host_t *vha, struct req_que *req, void *tsk)
+{
+	const char func[] = "NVME-IOCB";
+	fc_port_t *fcport;
+	srb_t *sp;
+	struct srb_iocb *iocb;
+	struct sts_entry_24xx *sts = (struct sts_entry_24xx *)tsk;
+	uint16_t        state_flags;
+	struct nvmefc_fcp_req *fd;
+	struct srb_iocb *nvme;
+
+	sp = qla2x00_get_sp_from_handle(vha, func, req, tsk);
+	if (!sp)
+		return;
+
+	iocb = &sp->u.iocb_cmd;
+	fcport = sp->fcport;
+	iocb->u.nvme.comp_status = le16_to_cpu(sts->comp_status);
+	state_flags  = le16_to_cpu(sts->state_flags);
+	fd = iocb->u.nvme.desc;
+	nvme = &sp->u.iocb_cmd;
+
+	if (unlikely(nvme->u.nvme.aen_op)) {
+		atomic_dec(&sp->vha->nvme_active_aen_cnt);
+		/*
+		 * Needed right now since the transport doesn't cleanup
+		 * up AEN's IO's on remote port delete.
+		 * they could have gone away while we still have the *fd.
+		 */
+		if (!atomic_read(&sp->fcport->nvme_ref_count)) {
+			sp->done(sp, QLA_FUNCTION_FAILED);
+			return;
+		}
+	}
+
+	/*
+	 * State flags: Bit 6 and 0.
+	 * If 0 is set, we don't care about 6.
+	 * both cases resp was dma'd to host buffer
+	 * if both are 0, that is good path case.
+	 * if six is set and 0 is clear, we need to
+	 * copy resp data from status iocb to resp buffer.
+	 */
+	if (!(state_flags & (SF_FCP_RSP_DMA | SF_NVME_ERSP))) {
+		iocb->u.nvme.rsp_pyld_len = 0;
+	} else if ((state_flags & SF_FCP_RSP_DMA)) {
+		iocb->u.nvme.rsp_pyld_len = le16_to_cpu(sts->nvme_rsp_pyld_len);
+	} else if (state_flags & SF_NVME_ERSP) {
+		uint32_t *inbuf, *outbuf;
+		uint16_t iter;
+
+		inbuf = (uint32_t *)&sts->nvme_ersp_data;
+		outbuf = (uint32_t *)fd->rspaddr;
+		iocb->u.nvme.rsp_pyld_len = le16_to_cpu(sts->nvme_rsp_pyld_len);
+		iter = iocb->u.nvme.rsp_pyld_len >> 2;
+		for (; iter; iter--)
+			*outbuf++ = swab32(*inbuf++);
+	} else { /* unhandled case */
+	    ql_log(ql_log_warn, fcport->vha, 0x503a,
+		"NVME-%s error. Unhandled state_flags of %x\n",
+		sp->name, state_flags);
+	}
+
+	fd->transferred_length = fd->payload_length -
+	    le32_to_cpu(sts->residual_len);
+
+	if (sts->entry_status) {
+		ql_log(ql_log_warn, fcport->vha, 0x5038,
+		    "NVME-%s error - hdl=%x entry-status(%x).\n",
+		    sp->name, sp->handle, sts->entry_status);
+	} else if (sts->comp_status != cpu_to_le16(CS_COMPLETE)) {
+		ql_log(ql_log_warn, fcport->vha, 0x5039,
+		    "NVME-%s error - hdl=%x completion status(%x) resid=%x  ox_id=%x\n",
+		    sp->name, sp->handle, sts->comp_status,
+		    le32_to_cpu(sts->residual_len), sts->ox_id);
+	}
+	sp->done(sp, QLA_FUNCTION_FAILED);
+}
+
 /**
  * qla2x00_process_response_queue() - Process response queue entries.
  * @ha: SCSI driver HA context
@@ -2289,6 +2369,12 @@ qla2x00_status_entry(scsi_qla_host_t *vha, struct rsp_que *rsp, void *pkt)
 		return;
 	}
 
+	/* NVME completion. */
+	if (sp->type == SRB_NVME_CMD) {
+		qla24xx_nvme_iocb_entry(vha, req, pkt);
+		return;
+	}
+
 	if (unlikely((state_flags & BIT_1) && (sp->type == SRB_BIDI_CMD))) {
 		qla25xx_process_bidir_status_iocb(vha, pkt, req, handle);
 		return;
diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index b2474952f858..59f2d5d8009f 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -695,8 +695,10 @@ qla2x00_sp_free_dma(void *ptr)
 	}
 
 end:
-	CMD_SP(cmd) = NULL;
-	qla2x00_rel_sp(sp);
+	if (sp->type != SRB_NVME_CMD) {
+		CMD_SP(cmd) = NULL;
+		qla2x00_rel_sp(sp);
+	}
 }
 
 void
@@ -5996,6 +5998,18 @@ qla2x00_timer(scsi_qla_host_t *vha)
 	if (!list_empty(&vha->work_list))
 		start_dpc++;
 
+	/*
+	 * FC-NVME
+	 * see if the active AEN count has changed from what was last reported.
+	 */
+	if (atomic_read(&vha->nvme_active_aen_cnt) != vha->nvme_last_rptd_aen) {
+		vha->nvme_last_rptd_aen =
+		    atomic_read(&vha->nvme_active_aen_cnt);
+		ql_log(ql_log_info, vha, 0x3002,
+		    "reporting new aen count of %d to the fw TBD\n",
+		    vha->nvme_last_rptd_aen);
+	}
+
 	/* Schedule the DPC routine if needed */
 	if ((test_bit(ISP_ABORT_NEEDED, &vha->dpc_flags) ||
 	    test_bit(LOOP_RESYNC_NEEDED, &vha->dpc_flags) ||
-- 
2.12.0
