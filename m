From: Himanshu Madhani <himanshu.madhani@cavium.com>
Subject: [PATCH 4/6] qla2xxx: Send FC4 type NVMe to the management server
Date: Fri, 16 Jun 2017 15:47:42 -0700
Message-ID: <20170616224744.3681-5-himanshu.madhani@cavium.com>
References: <20170616224744.3681-1-himanshu.madhani@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bn3nam01on0052.outbound.protection.outlook.com ([104.47.33.52]:60000
        "EHLO NAM01-BN3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751144AbdFPWsE (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 16 Jun 2017 18:48:04 -0400
In-Reply-To: <20170616224744.3681-1-himanshu.madhani@cavium.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: martin.petersen@oracle.com
Cc: himanshu.madhani@cavium.com, linux-scsi@vger.kernel.org, giridhar.malaval@cavium.com, darren.trapp@cavium.com

From: Duane Grigsby <duane.grigsby@cavium.com>

This patch adds switch command support for FC-4 type of FC-NVMe (0x28)
for resgistering HBA port to the management server. RFT_ID command is
used to register FC-4 type of 0x28 and RFF_ID is used to register
FC-4 features bits for FC-NVMe port.

Signed-off-by: Darren Trapp <darren.trapp@cavium.com>
Signed-off-by: Duane Grigsby <duane.grigsby@cavium.com>
Signed-off-by: Anil Gurumurthy <anil.gurumurhty@cavium.com>
Signed-off-by: Giridhar Malavali <giridhar.malavali@cavium.com>
Signed-off-by: Himanshu Madhani <himanshu.madhani@cavium.com>
---
 drivers/scsi/qla2xxx/qla_def.h  |   1 +
 drivers/scsi/qla2xxx/qla_gbl.h  |   6 +-
 drivers/scsi/qla2xxx/qla_gs.c   | 118 +++++++++++++++++++++++++++++++++++++++-
 drivers/scsi/qla2xxx/qla_init.c |  11 +++-
 4 files changed, 131 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_def.h b/drivers/scsi/qla2xxx/qla_def.h
index c1edfa55b071..c68c1cb1aadf 100644
--- a/drivers/scsi/qla2xxx/qla_def.h
+++ b/drivers/scsi/qla2xxx/qla_def.h
@@ -2866,6 +2866,7 @@ struct ct_sns_rsp {
 		} gpsc;
 
 #define GFF_FCP_SCSI_OFFSET	7
+#define GFF_NVME_OFFSET		23 /* type = 28h */
 		struct {
 			uint8_t fc4_features[128];
 		} gff_id;
diff --git a/drivers/scsi/qla2xxx/qla_gbl.h b/drivers/scsi/qla2xxx/qla_gbl.h
index fc2c03bda731..1a2b5b791e22 100644
--- a/drivers/scsi/qla2xxx/qla_gbl.h
+++ b/drivers/scsi/qla2xxx/qla_gbl.h
@@ -34,6 +34,7 @@ extern void qla_nvme_fcp_abort(struct nvme_fc_local_port *,
     struct nvme_fc_remote_port *, void *, struct nvmefc_fcp_req *);
 extern void qla24xx_nvme_ls4_iocb(scsi_qla_host_t *, struct pt_ls4_request *,
     struct req_que *);
+extern void qla24xx_async_gffid_sp_done(void *, int);
 
 /*
  * Global Function Prototypes in qla_init.c source file.
@@ -634,7 +635,7 @@ extern int qla2x00_gpn_id(scsi_qla_host_t *, sw_info_t *);
 extern int qla2x00_gnn_id(scsi_qla_host_t *, sw_info_t *);
 extern void qla2x00_gff_id(scsi_qla_host_t *, sw_info_t *);
 extern int qla2x00_rft_id(scsi_qla_host_t *);
-extern int qla2x00_rff_id(scsi_qla_host_t *);
+extern int qla2x00_rff_id(scsi_qla_host_t *, u8);
 extern int qla2x00_rnn_id(scsi_qla_host_t *);
 extern int qla2x00_rsnn_nn(scsi_qla_host_t *);
 extern void *qla2x00_prep_ms_fdmi_iocb(scsi_qla_host_t *, uint32_t, uint32_t);
@@ -660,7 +661,8 @@ void qla24xx_handle_gpnid_event(scsi_qla_host_t *, struct event_arg *);
 int qla24xx_post_gpsc_work(struct scsi_qla_host *, fc_port_t *);
 int qla24xx_async_gpsc(scsi_qla_host_t *, fc_port_t *);
 int qla2x00_mgmt_svr_login(scsi_qla_host_t *);
-
+void qla24xx_handle_gffid_event(scsi_qla_host_t *vha, struct event_arg *ea);
+int qla24xx_async_gffid(scsi_qla_host_t *vha, fc_port_t *fcport);
 /*
  * Global Function Prototypes in qla_attr.c source file.
  */
diff --git a/drivers/scsi/qla2xxx/qla_gs.c b/drivers/scsi/qla2xxx/qla_gs.c
index 540fec524ccb..c91478529b51 100644
--- a/drivers/scsi/qla2xxx/qla_gs.c
+++ b/drivers/scsi/qla2xxx/qla_gs.c
@@ -550,6 +550,8 @@ qla2x00_rft_id(scsi_qla_host_t *vha)
 
 	ct_req->req.rft_id.fc4_types[2] = 0x01;		/* FCP-3 */
 
+	if (vha->flags.nvme_enabled)
+		ct_req->req.rft_id.fc4_types[6] = 1;    /* NVMe type 28h */
 	/* Execute MS IOCB */
 	rval = qla2x00_issue_iocb(vha, ha->ms_iocb, ha->ms_iocb_dma,
 	    sizeof(ms_iocb_entry_t));
@@ -575,7 +577,7 @@ qla2x00_rft_id(scsi_qla_host_t *vha)
  * Returns 0 on success.
  */
 int
-qla2x00_rff_id(scsi_qla_host_t *vha)
+qla2x00_rff_id(scsi_qla_host_t *vha, u8 type)
 {
 	int		rval;
 	struct qla_hw_data *ha = vha->hw;
@@ -613,7 +615,7 @@ qla2x00_rff_id(scsi_qla_host_t *vha)
 
 	qlt_rff_id(vha, ct_req);
 
-	ct_req->req.rff_id.fc4_type = 0x08;		/* SCSI - FCP */
+	ct_req->req.rff_id.fc4_type = type;		/* SCSI - FCP */
 
 	/* Execute MS IOCB */
 	rval = qla2x00_issue_iocb(vha, ha->ms_iocb, ha->ms_iocb_dma,
@@ -2754,6 +2756,10 @@ qla2x00_gff_id(scsi_qla_host_t *vha, sw_info_t *list)
 				list[i].fc4_type = FC4_TYPE_FCP_SCSI;
 			else
 				list[i].fc4_type = FC4_TYPE_OTHER;
+
+			list[i].fc4f_nvme =
+			    ct_rsp->rsp.gff_id.fc4_features[GFF_NVME_OFFSET];
+			list[i].fc4f_nvme &= 0xf;
 		}
 
 		/* Last device exit. */
@@ -3305,3 +3311,111 @@ int qla24xx_async_gpnid(scsi_qla_host_t *vha, port_id_t *id)
 done:
 	return rval;
 }
+
+void qla24xx_handle_gffid_event(scsi_qla_host_t *vha, struct event_arg *ea)
+{
+       fc_port_t *fcport = ea->fcport;
+
+       qla24xx_post_gnl_work(vha, fcport);
+}
+
+void qla24xx_async_gffid_sp_done(void *s, int res)
+{
+       struct srb *sp = s;
+       struct scsi_qla_host *vha = sp->vha;
+       fc_port_t *fcport = sp->fcport;
+       struct ct_sns_rsp *ct_rsp;
+       struct event_arg ea;
+
+       ql_dbg(ql_dbg_disc, vha, 0x2133,
+	   "Async done-%s res %x ID %x. %8phC\n",
+	   sp->name, res, fcport->d_id.b24, fcport->port_name);
+
+       fcport->flags &= ~FCF_ASYNC_SENT;
+       ct_rsp = &fcport->ct_desc.ct_sns->p.rsp;
+       /*
+	* FC-GS-7, 5.2.3.12 FC-4 Features - format
+	* The format of the FC-4 Features object, as defined by the FC-4,
+	* Shall be an array of 4-bit values, one for each type code value
+	*/
+       if (!res) {
+	       if (ct_rsp->rsp.gff_id.fc4_features[GFF_FCP_SCSI_OFFSET] & 0xf) {
+		       /* w1 b00:03 */
+		       fcport->fc4_type =
+			   ct_rsp->rsp.gff_id.fc4_features[GFF_FCP_SCSI_OFFSET];
+		       fcport->fc4_type &= 0xf;
+	       }
+
+	       if (ct_rsp->rsp.gff_id.fc4_features[GFF_NVME_OFFSET] & 0xf) {
+		       /* w5 [00:03]/28h */
+		       fcport->fc4f_nvme =
+			   ct_rsp->rsp.gff_id.fc4_features[GFF_NVME_OFFSET];
+		       fcport->fc4f_nvme &= 0xf;
+	       }
+       }
+
+       memset(&ea, 0, sizeof(ea));
+       ea.sp = sp;
+       ea.fcport = sp->fcport;
+       ea.rc = res;
+       ea.event = FCME_GFFID_DONE;
+
+       qla2x00_fcport_event_handler(vha, &ea);
+       sp->free(sp);
+}
+
+/* Get FC4 Feature with Nport ID. */
+int qla24xx_async_gffid(scsi_qla_host_t *vha, fc_port_t *fcport)
+{
+	int rval = QLA_FUNCTION_FAILED;
+	struct ct_sns_req       *ct_req;
+	srb_t *sp;
+
+	if (!vha->flags.online)
+		return rval;
+
+	sp = qla2x00_get_sp(vha, fcport, GFP_KERNEL);
+	if (!sp)
+		return rval;
+
+	fcport->flags |= FCF_ASYNC_SENT;
+	sp->type = SRB_CT_PTHRU_CMD;
+	sp->name = "gffid";
+	sp->gen1 = fcport->rscn_gen;
+	sp->gen2 = fcport->login_gen;
+
+	qla2x00_init_timer(sp, qla2x00_get_async_timeout(vha) + 2);
+
+	/* CT_IU preamble  */
+	ct_req = qla2x00_prep_ct_req(fcport->ct_desc.ct_sns, GFF_ID_CMD,
+	    GFF_ID_RSP_SIZE);
+
+	ct_req->req.gff_id.port_id[0] = fcport->d_id.b.domain;
+	ct_req->req.gff_id.port_id[1] = fcport->d_id.b.area;
+	ct_req->req.gff_id.port_id[2] = fcport->d_id.b.al_pa;
+
+	sp->u.iocb_cmd.u.ctarg.req = fcport->ct_desc.ct_sns;
+	sp->u.iocb_cmd.u.ctarg.req_dma = fcport->ct_desc.ct_sns_dma;
+	sp->u.iocb_cmd.u.ctarg.rsp = fcport->ct_desc.ct_sns;
+	sp->u.iocb_cmd.u.ctarg.rsp_dma = fcport->ct_desc.ct_sns_dma;
+	sp->u.iocb_cmd.u.ctarg.req_size = GFF_ID_REQ_SIZE;
+	sp->u.iocb_cmd.u.ctarg.rsp_size = GFF_ID_RSP_SIZE;
+	sp->u.iocb_cmd.u.ctarg.nport_handle = NPH_SNS;
+
+	sp->u.iocb_cmd.timeout = qla2x00_async_iocb_timeout;
+	sp->done = qla24xx_async_gffid_sp_done;
+
+	rval = qla2x00_start_sp(sp);
+	if (rval != QLA_SUCCESS)
+		goto done_free_sp;
+
+	ql_dbg(ql_dbg_disc, vha, 0x2132,
+	    "Async-%s hdl=%x  %8phC.\n", sp->name,
+	    sp->handle, fcport->port_name);
+
+	return rval;
+done_free_sp:
+	sp->free(sp);
+	fcport->flags &= ~FCF_ASYNC_SENT;
+	return rval;
+}
diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index 73125837267b..5dbb3d582e22 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -1244,6 +1244,9 @@ void qla2x00_fcport_event_handler(scsi_qla_host_t *vha, struct event_arg *ea)
 	case FCME_GPNID_DONE:
 		qla24xx_handle_gpnid_event(vha, ea);
 		break;
+	case FCME_GFFID_DONE:
+		qla24xx_handle_gffid_event(vha, ea);
+		break;
 	case FCME_DELETE_DONE:
 		qla24xx_handle_delete_done_event(vha, ea);
 		break;
@@ -4626,7 +4629,7 @@ qla2x00_configure_fabric(scsi_qla_host_t *vha)
 				    &vha->dpc_flags))
 					break;
 			}
-			if (qla2x00_rff_id(vha)) {
+			if (qla2x00_rff_id(vha, FC4_TYPE_FCP_SCSI)) {
 				/* EMPTY */
 				ql_dbg(ql_dbg_disc, vha, 0x209a,
 				    "Register FC-4 Features failed.\n");
@@ -4634,6 +4637,12 @@ qla2x00_configure_fabric(scsi_qla_host_t *vha)
 				    &vha->dpc_flags))
 					break;
 			}
+			if (vha->flags.nvme_enabled) {
+				if (qla2x00_rff_id(vha, FC4_TYPE_NVME)) {
+					ql_dbg(ql_dbg_disc, vha, 0x2049,
+					    "Register NVME FC Type Features failed.\n");
+				}
+			}
 			if (qla2x00_rnn_id(vha)) {
 				/* EMPTY */
 				ql_dbg(ql_dbg_disc, vha, 0x2104,
-- 
2.12.0
