From: Sebastian Herbszt <herbszt@gmx.de>
Subject: [PATCH] lpfc: remove set but not used variables
Date: Sun, 26 Jul 2015 18:45:27 +0200
Message-ID: <20150726184527.000033fa@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.18]:54257 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755199AbbGZQpi (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 26 Jul 2015 12:45:38 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: James Smart <james.smart@avagotech.com>, Sebastian Herbszt <herbszt@gmx.de>

Remove set but not used variables.

Signed-off-by: Sebastian Herbszt <herbszt@gmx.de>
---

diff -urp a/drivers/scsi/lpfc/lpfc_attr.c b/drivers/scsi/lpfc/lpfc_attr.c
--- a/drivers/scsi/lpfc/lpfc_attr.c	2015-04-15 06:18:24.669045137 +0200
+++ b/drivers/scsi/lpfc/lpfc_attr.c	2015-07-25 01:22:42.072765205 +0200
@@ -1642,8 +1642,6 @@ lpfc_##attr##_show(struct device *dev, s
 	struct Scsi_Host  *shost = class_to_shost(dev);\
 	struct lpfc_vport *vport = (struct lpfc_vport *) shost->hostdata;\
 	struct lpfc_hba   *phba = vport->phba;\
-	uint val = 0;\
-	val = phba->cfg_##attr;\
 	return snprintf(buf, PAGE_SIZE, "%d\n",\
 			phba->cfg_##attr);\
 }
@@ -1808,8 +1806,6 @@ lpfc_##attr##_show(struct device *dev, s
 { \
 	struct Scsi_Host  *shost = class_to_shost(dev);\
 	struct lpfc_vport *vport = (struct lpfc_vport *) shost->hostdata;\
-	uint val = 0;\
-	val = vport->cfg_##attr;\
 	return snprintf(buf, PAGE_SIZE, "%d\n", vport->cfg_##attr);\
 }
 
@@ -1835,8 +1831,6 @@ lpfc_##attr##_show(struct device *dev, s
 { \
 	struct Scsi_Host  *shost = class_to_shost(dev);\
 	struct lpfc_vport *vport = (struct lpfc_vport *) shost->hostdata;\
-	uint val = 0;\
-	val = vport->cfg_##attr;\
 	return snprintf(buf, PAGE_SIZE, "%#x\n", vport->cfg_##attr);\
 }
 
diff -urp a/drivers/scsi/lpfc/lpfc_bsg.c b/drivers/scsi/lpfc/lpfc_bsg.c
--- a/drivers/scsi/lpfc/lpfc_bsg.c	2015-04-15 06:18:24.669045137 +0200
+++ b/drivers/scsi/lpfc/lpfc_bsg.c	2015-07-25 01:15:43.796746130 +0200
@@ -904,7 +904,6 @@ lpfc_bsg_ct_unsol_event(struct lpfc_hba
 {
 	uint32_t evt_req_id = 0;
 	uint32_t cmd;
-	uint32_t len;
 	struct lpfc_dmabuf *dmabuf = NULL;
 	struct lpfc_bsg_event *evt;
 	struct event_data *evt_dat = NULL;
@@ -946,7 +945,6 @@ lpfc_bsg_ct_unsol_event(struct lpfc_hba
 	ct_req = (struct lpfc_sli_ct_request *)dmabuf->virt;
 	evt_req_id = ct_req->FsType;
 	cmd = ct_req->CommandResponse.bits.CmdRsp;
-	len = ct_req->CommandResponse.bits.Size;
 	if (!(phba->sli3_options & LPFC_SLI3_HBQ_ENABLED))
 		lpfc_sli_ringpostbuf_put(phba, pring, dmabuf);
 
@@ -2988,7 +2986,6 @@ lpfc_bsg_diag_loopback_run(struct fc_bsg
 {
 	struct lpfc_vport *vport = (struct lpfc_vport *)job->shost->hostdata;
 	struct lpfc_hba *phba = vport->phba;
-	struct diag_mode_test *diag_mode;
 	struct lpfc_bsg_event *evt;
 	struct event_data *evdat;
 	struct lpfc_sli *psli = &phba->sli;
@@ -3031,8 +3028,6 @@ lpfc_bsg_diag_loopback_run(struct fc_bsg
 		rc = -EINVAL;
 		goto loopback_test_exit;
 	}
-	diag_mode = (struct diag_mode_test *)
-		job->request->rqst_data.h_vendor.vendor_cmd;
 
 	if ((phba->link_state == LPFC_HBA_ERROR) ||
 	    (psli->sli_flag & LPFC_BLOCK_MGMT_IO) ||
@@ -3293,7 +3288,6 @@ lpfc_bsg_get_dfc_rev(struct fc_bsg_job *
 {
 	struct lpfc_vport *vport = (struct lpfc_vport *)job->shost->hostdata;
 	struct lpfc_hba *phba = vport->phba;
-	struct get_mgmt_rev *event_req;
 	struct get_mgmt_rev_reply *event_reply;
 	int rc = 0;
 
@@ -3306,9 +3300,6 @@ lpfc_bsg_get_dfc_rev(struct fc_bsg_job *
 		goto job_error;
 	}
 
-	event_req = (struct get_mgmt_rev *)
-		job->request->rqst_data.h_vendor.vendor_cmd;
-
 	event_reply = (struct get_mgmt_rev_reply *)
 		job->reply->reply_data.vendor_reply.vendor_rsp;
 
@@ -4348,7 +4339,6 @@ static int
 lpfc_bsg_write_ebuf_set(struct lpfc_hba *phba, struct fc_bsg_job *job,
 			struct lpfc_dmabuf *dmabuf)
 {
-	struct lpfc_sli_config_mbox *sli_cfg_mbx;
 	struct bsg_job_data *dd_data = NULL;
 	LPFC_MBOXQ_t *pmboxq = NULL;
 	MAILBOX_t *pmb;
@@ -4362,9 +4352,6 @@ lpfc_bsg_write_ebuf_set(struct lpfc_hba
 	phba->mbox_ext_buf_ctx.seqNum++;
 	nemb_tp = phba->mbox_ext_buf_ctx.nembType;
 
-	sli_cfg_mbx = (struct lpfc_sli_config_mbox *)
-			phba->mbox_ext_buf_ctx.mbx_dmabuf->virt;
-
 	dd_data = kmalloc(sizeof(struct bsg_job_data), GFP_KERNEL);
 	if (!dd_data) {
 		rc = -ENOMEM;
@@ -4606,7 +4593,6 @@ lpfc_bsg_issue_mbox(struct lpfc_hba *phb
 	uint32_t transmit_length, receive_length, mode;
 	struct lpfc_mbx_sli4_config *sli4_config;
 	struct lpfc_mbx_nembed_cmd *nembed_sge;
-	struct mbox_header *header;
 	struct ulp_bde64 *bde;
 	uint8_t *ext = NULL;
 	int rc = 0;
@@ -4804,8 +4790,6 @@ lpfc_bsg_issue_mbox(struct lpfc_hba *phb
 				/* rebuild the command for sli4 using our
 				 * own buffers like we do for biu diags
 				 */
-				header = (struct mbox_header *)
-						&pmb->un.varWords[0];
 				nembed_sge = (struct lpfc_mbx_nembed_cmd *)
 						&pmb->un.varWords[0];
 				receive_length = nembed_sge->sge[0].length;
@@ -5048,7 +5032,6 @@ lpfc_menlo_cmd(struct fc_bsg_job *job)
 	IOCB_t *cmd;
 	int rc = 0;
 	struct menlo_command *menlo_cmd;
-	struct menlo_response *menlo_resp;
 	struct lpfc_dmabuf *bmp = NULL, *cmp = NULL, *rmp = NULL;
 	int request_nseg;
 	int reply_nseg;
@@ -5088,9 +5071,6 @@ lpfc_menlo_cmd(struct fc_bsg_job *job)
 	menlo_cmd = (struct menlo_command *)
 		job->request->rqst_data.h_vendor.vendor_cmd;
 
-	menlo_resp = (struct menlo_response *)
-		job->reply->reply_data.vendor_reply.vendor_rsp;
-
 	/* allocate our bsg tracking structure */
 	dd_data = kmalloc(sizeof(struct bsg_job_data), GFP_KERNEL);
 	if (!dd_data) {
diff -urp a/drivers/scsi/lpfc/lpfc_ct.c b/drivers/scsi/lpfc/lpfc_ct.c
--- a/drivers/scsi/lpfc/lpfc_ct.c	2015-04-15 06:18:24.669045137 +0200
+++ b/drivers/scsi/lpfc/lpfc_ct.c	2015-07-25 01:59:56.892867120 +0200
@@ -575,7 +575,6 @@ lpfc_cmpl_ct_cmd_gid_ft(struct lpfc_hba
 	struct lpfc_vport *vport = cmdiocb->vport;
 	struct Scsi_Host *shost = lpfc_shost_from_vport(vport);
 	IOCB_t *irsp;
-	struct lpfc_dmabuf *bmp;
 	struct lpfc_dmabuf *outp;
 	struct lpfc_sli_ct_request *CTrsp;
 	struct lpfc_nodelist *ndlp;
@@ -588,7 +587,6 @@ lpfc_cmpl_ct_cmd_gid_ft(struct lpfc_hba
 	cmdiocb->context_un.rsp_iocb = rspiocb;
 
 	outp = (struct lpfc_dmabuf *) cmdiocb->context2;
-	bmp = (struct lpfc_dmabuf *) cmdiocb->context3;
 	irsp = &rspiocb->iocb;
 
 	lpfc_debugfs_disc_trc(vport, LPFC_DISC_TRC_CT,
@@ -1733,12 +1731,9 @@ hba_out:
 	case SLI_MGMT_RPRT:
 	case SLI_MGMT_RPA:
 		{
-			lpfc_vpd_t *vp;
 			struct serv_parm *hsp;
 			int len = 0;
 
-			vp = &phba->vpd;
-
 			if (cmdcode == SLI_MGMT_RPRT) {
 				rh = (struct lpfc_fdmi_reg_hba *)
 					&CtReq->un.PortID;
diff -urp a/drivers/scsi/lpfc/lpfc_els.c b/drivers/scsi/lpfc/lpfc_els.c
--- a/drivers/scsi/lpfc/lpfc_els.c	2015-07-05 22:18:43.929739150 +0200
+++ b/drivers/scsi/lpfc/lpfc_els.c	2015-07-25 01:55:11.896854124 +0200
@@ -457,11 +457,9 @@ lpfc_issue_reg_vfi(struct lpfc_vport *vp
 	struct lpfc_hba  *phba = vport->phba;
 	LPFC_MBOXQ_t *mboxq;
 	struct lpfc_nodelist *ndlp;
-	struct serv_parm *sp;
 	struct lpfc_dmabuf *dmabuf;
 	int rc = 0;
 
-	sp = &phba->fc_fabparam;
 	/* move forward in case of SLI4 FC port loopback test and pt2pt mode */
 	if ((phba->sli_rev == LPFC_SLI_REV4) &&
 	    !(phba->link_flag & LS_LOOPBACK_MODE) &&
@@ -1205,14 +1203,11 @@ lpfc_issue_els_flogi(struct lpfc_vport *
 	struct serv_parm *sp;
 	IOCB_t *icmd;
 	struct lpfc_iocbq *elsiocb;
-	struct lpfc_sli_ring *pring;
 	uint8_t *pcmd;
 	uint16_t cmdsize;
 	uint32_t tmo;
 	int rc;
 
-	pring = &phba->sli.ring[LPFC_ELS_RING];
-
 	cmdsize = (sizeof(uint32_t) + sizeof(struct serv_parm));
 	elsiocb = lpfc_prep_els_iocb(vport, 1, cmdsize, retry, ndlp,
 				     ndlp->nlp_DID, ELS_CMD_FLOGI);
@@ -1454,8 +1449,6 @@ lpfc_initial_fdisc(struct lpfc_vport *vp
 void
 lpfc_more_plogi(struct lpfc_vport *vport)
 {
-	int sentplogi;
-
 	if (vport->num_disc_nodes)
 		vport->num_disc_nodes--;
 
@@ -1468,7 +1461,7 @@ lpfc_more_plogi(struct lpfc_vport *vport
 	/* Check to see if there are more PLOGIs to be sent */
 	if (vport->fc_flag & FC_NLP_MORE)
 		/* go thru NPR nodes and issue any remaining ELS PLOGIs */
-		sentplogi = lpfc_els_disc_plogi(vport);
+		lpfc_els_disc_plogi(vport);
 
 	return;
 }
@@ -1956,16 +1949,12 @@ lpfc_issue_els_plogi(struct lpfc_vport *
 {
 	struct lpfc_hba  *phba = vport->phba;
 	struct serv_parm *sp;
-	IOCB_t *icmd;
 	struct lpfc_nodelist *ndlp;
 	struct lpfc_iocbq *elsiocb;
-	struct lpfc_sli *psli;
 	uint8_t *pcmd;
 	uint16_t cmdsize;
 	int ret;
 
-	psli = &phba->sli;
-
 	ndlp = lpfc_findnode_did(vport, did);
 	if (ndlp && !NLP_CHK_NODE_ACT(ndlp))
 		ndlp = NULL;
@@ -1977,7 +1966,6 @@ lpfc_issue_els_plogi(struct lpfc_vport *
 	if (!elsiocb)
 		return 1;
 
-	icmd = &elsiocb->iocb;
 	pcmd = (uint8_t *) (((struct lpfc_dmabuf *) elsiocb->context2)->virt);
 
 	/* For PLOGI request, remainder of payload is service parameters */
@@ -2034,10 +2022,8 @@ lpfc_cmpl_els_prli(struct lpfc_hba *phba
 	struct lpfc_vport *vport = cmdiocb->vport;
 	struct Scsi_Host  *shost = lpfc_shost_from_vport(vport);
 	IOCB_t *irsp;
-	struct lpfc_sli *psli;
 	struct lpfc_nodelist *ndlp;
 
-	psli = &phba->sli;
 	/* we pass cmdiocb to state machine which needs rspiocb as well */
 	cmdiocb->context_un.rsp_iocb = rspiocb;
 
@@ -2117,7 +2103,6 @@ lpfc_issue_els_prli(struct lpfc_vport *v
 	struct Scsi_Host *shost = lpfc_shost_from_vport(vport);
 	struct lpfc_hba *phba = vport->phba;
 	PRLI *npr;
-	IOCB_t *icmd;
 	struct lpfc_iocbq *elsiocb;
 	uint8_t *pcmd;
 	uint16_t cmdsize;
@@ -2128,7 +2113,6 @@ lpfc_issue_els_prli(struct lpfc_vport *v
 	if (!elsiocb)
 		return 1;
 
-	icmd = &elsiocb->iocb;
 	pcmd = (uint8_t *) (((struct lpfc_dmabuf *) elsiocb->context2)->virt);
 
 	/* For PRLI request, remainder of payload is service parameters */
@@ -2413,7 +2397,6 @@ lpfc_issue_els_adisc(struct lpfc_vport *
 	struct Scsi_Host *shost = lpfc_shost_from_vport(vport);
 	struct lpfc_hba  *phba = vport->phba;
 	ADISC *ap;
-	IOCB_t *icmd;
 	struct lpfc_iocbq *elsiocb;
 	uint8_t *pcmd;
 	uint16_t cmdsize;
@@ -2424,7 +2407,6 @@ lpfc_issue_els_adisc(struct lpfc_vport *
 	if (!elsiocb)
 		return 1;
 
-	icmd = &elsiocb->iocb;
 	pcmd = (uint8_t *) (((struct lpfc_dmabuf *) elsiocb->context2)->virt);
 
 	/* For ADISC request, remainder of payload is service parameters */
@@ -2478,12 +2460,10 @@ lpfc_cmpl_els_logo(struct lpfc_hba *phba
 	struct lpfc_vport *vport = ndlp->vport;
 	struct Scsi_Host  *shost = lpfc_shost_from_vport(vport);
 	IOCB_t *irsp;
-	struct lpfc_sli *psli;
 	struct lpfcMboxq *mbox;
 	unsigned long flags;
 	uint32_t skip_recovery = 0;
 
-	psli = &phba->sli;
 	/* we pass cmdiocb to state machine which needs rspiocb as well */
 	cmdiocb->context_un.rsp_iocb = rspiocb;
 
@@ -2609,7 +2589,6 @@ lpfc_issue_els_logo(struct lpfc_vport *v
 {
 	struct Scsi_Host *shost = lpfc_shost_from_vport(vport);
 	struct lpfc_hba  *phba = vport->phba;
-	IOCB_t *icmd;
 	struct lpfc_iocbq *elsiocb;
 	uint8_t *pcmd;
 	uint16_t cmdsize;
@@ -2628,7 +2607,6 @@ lpfc_issue_els_logo(struct lpfc_vport *v
 	if (!elsiocb)
 		return 1;
 
-	icmd = &elsiocb->iocb;
 	pcmd = (uint8_t *) (((struct lpfc_dmabuf *) elsiocb->context2)->virt);
 	*((uint32_t *) (pcmd)) = ELS_CMD_LOGO;
 	pcmd += sizeof(uint32_t);
@@ -2742,14 +2720,11 @@ int
 lpfc_issue_els_scr(struct lpfc_vport *vport, uint32_t nportid, uint8_t retry)
 {
 	struct lpfc_hba  *phba = vport->phba;
-	IOCB_t *icmd;
 	struct lpfc_iocbq *elsiocb;
-	struct lpfc_sli *psli;
 	uint8_t *pcmd;
 	uint16_t cmdsize;
 	struct lpfc_nodelist *ndlp;
 
-	psli = &phba->sli;
 	cmdsize = (sizeof(uint32_t) + sizeof(SCR));
 
 	ndlp = lpfc_findnode_did(vport, nportid);
@@ -2776,7 +2751,6 @@ lpfc_issue_els_scr(struct lpfc_vport *vp
 		return 1;
 	}
 
-	icmd = &elsiocb->iocb;
 	pcmd = (uint8_t *) (((struct lpfc_dmabuf *) elsiocb->context2)->virt);
 
 	*((uint32_t *) (pcmd)) = ELS_CMD_SCR;
@@ -2836,9 +2810,7 @@ static int
 lpfc_issue_els_farpr(struct lpfc_vport *vport, uint32_t nportid, uint8_t retry)
 {
 	struct lpfc_hba  *phba = vport->phba;
-	IOCB_t *icmd;
 	struct lpfc_iocbq *elsiocb;
-	struct lpfc_sli *psli;
 	FARP *fp;
 	uint8_t *pcmd;
 	uint32_t *lp;
@@ -2846,7 +2818,6 @@ lpfc_issue_els_farpr(struct lpfc_vport *
 	struct lpfc_nodelist *ondlp;
 	struct lpfc_nodelist *ndlp;
 
-	psli = &phba->sli;
 	cmdsize = (sizeof(uint32_t) + sizeof(FARP));
 
 	ndlp = lpfc_findnode_did(vport, nportid);
@@ -2872,7 +2843,6 @@ lpfc_issue_els_farpr(struct lpfc_vport *
 		return 1;
 	}
 
-	icmd = &elsiocb->iocb;
 	pcmd = (uint8_t *) (((struct lpfc_dmabuf *) elsiocb->context2)->virt);
 
 	*((uint32_t *) (pcmd)) = ELS_CMD_FARPR;
@@ -3922,13 +3892,11 @@ lpfc_els_rsp_acc(struct lpfc_vport *vpor
 	IOCB_t *icmd;
 	IOCB_t *oldcmd;
 	struct lpfc_iocbq *elsiocb;
-	struct lpfc_sli *psli;
 	uint8_t *pcmd;
 	uint16_t cmdsize;
 	int rc;
 	ELS_PKT *els_pkt_ptr;
 
-	psli = &phba->sli;
 	oldcmd = &oldiocb->iocb;
 
 	switch (flag) {
@@ -4061,12 +4029,10 @@ lpfc_els_rsp_reject(struct lpfc_vport *v
 	IOCB_t *icmd;
 	IOCB_t *oldcmd;
 	struct lpfc_iocbq *elsiocb;
-	struct lpfc_sli *psli;
 	uint8_t *pcmd;
 	uint16_t cmdsize;
 	int rc;
 
-	psli = &phba->sli;
 	cmdsize = 2 * sizeof(uint32_t);
 	elsiocb = lpfc_prep_els_iocb(vport, 0, cmdsize, oldiocb->retry, ndlp,
 				     ndlp->nlp_DID, ELS_CMD_LS_RJT);
@@ -4212,13 +4178,10 @@ lpfc_els_rsp_prli_acc(struct lpfc_vport
 	IOCB_t *icmd;
 	IOCB_t *oldcmd;
 	struct lpfc_iocbq *elsiocb;
-	struct lpfc_sli *psli;
 	uint8_t *pcmd;
 	uint16_t cmdsize;
 	int rc;
 
-	psli = &phba->sli;
-
 	cmdsize = sizeof(uint32_t) + sizeof(PRLI);
 	elsiocb = lpfc_prep_els_iocb(vport, 0, cmdsize, oldiocb->retry, ndlp,
 		ndlp->nlp_DID, (ELS_CMD_ACC | (ELS_CMD_PRLI & ~ELS_RSP_MASK)));
@@ -4315,12 +4278,10 @@ lpfc_els_rsp_rnid_acc(struct lpfc_vport
 	RNID *rn;
 	IOCB_t *icmd, *oldcmd;
 	struct lpfc_iocbq *elsiocb;
-	struct lpfc_sli *psli;
 	uint8_t *pcmd;
 	uint16_t cmdsize;
 	int rc;
 
-	psli = &phba->sli;
 	cmdsize = sizeof(uint32_t) + sizeof(uint32_t)
 					+ (2 * sizeof(struct lpfc_name));
 	if (format)
@@ -4447,12 +4408,10 @@ lpfc_els_rsp_echo_acc(struct lpfc_vport
 {
 	struct lpfc_hba  *phba = vport->phba;
 	struct lpfc_iocbq *elsiocb;
-	struct lpfc_sli *psli;
 	uint8_t *pcmd;
 	uint16_t cmdsize;
 	int rc;
 
-	psli = &phba->sli;
 	cmdsize = oldiocb->iocb.unsli3.rcvsli3.acc_len;
 
 	/* The accumulated length can exceed the BPL_SIZE.  For
@@ -5181,14 +5140,12 @@ lpfc_els_rcv_lcb(struct lpfc_vport *vpor
 {
 	struct lpfc_hba *phba = vport->phba;
 	struct lpfc_dmabuf *pcmd;
-	IOCB_t *icmd;
 	uint8_t *lp;
 	struct fc_lcb_request_frame *beacon;
 	struct lpfc_lcb_context *lcb_context;
 	uint8_t state, rjt_err;
 	struct ls_rjt stat;
 
-	icmd = &cmdiocb->iocb;
 	pcmd = (struct lpfc_dmabuf *)cmdiocb->context2;
 	lp = (uint8_t *)pcmd->virt;
 	beacon = (struct fc_lcb_request_frame *)pcmd->virt;
@@ -5481,13 +5438,11 @@ lpfc_els_rcv_rscn(struct lpfc_vport *vpo
 	struct lpfc_hba  *phba = vport->phba;
 	struct lpfc_dmabuf *pcmd;
 	uint32_t *lp, *datap;
-	IOCB_t *icmd;
 	uint32_t payload_len, length, nportid, *cmd;
 	int rscn_cnt;
 	int rscn_id = 0, hba_id = 0;
 	int i;
 
-	icmd = &cmdiocb->iocb;
 	pcmd = (struct lpfc_dmabuf *) cmdiocb->context2;
 	lp = (uint32_t *) pcmd->virt;
 
@@ -5943,12 +5898,10 @@ lpfc_els_rcv_rnid(struct lpfc_vport *vpo
 {
 	struct lpfc_dmabuf *pcmd;
 	uint32_t *lp;
-	IOCB_t *icmd;
 	RNID *rn;
 	struct ls_rjt stat;
 	uint32_t cmd;
 
-	icmd = &cmdiocb->iocb;
 	pcmd = (struct lpfc_dmabuf *) cmdiocb->context2;
 	lp = (uint32_t *) pcmd->virt;
 
@@ -6259,7 +6212,6 @@ lpfc_els_rcv_rls(struct lpfc_vport *vpor
 {
 	struct lpfc_hba *phba = vport->phba;
 	LPFC_MBOXQ_t *mbox;
-	struct lpfc_dmabuf *pcmd;
 	struct ls_rjt stat;
 
 	if ((ndlp->nlp_state != NLP_STE_UNMAPPED_NODE) &&
@@ -6267,8 +6219,6 @@ lpfc_els_rcv_rls(struct lpfc_vport *vpor
 		/* reject the unsolicited RPS request and done with it */
 		goto reject_out;
 
-	pcmd = (struct lpfc_dmabuf *) cmdiocb->context2;
-
 	mbox = mempool_alloc(phba->mbox_mem_pool, GFP_ATOMIC);
 	if (mbox) {
 		lpfc_read_lnk_stat(phba, mbox);
@@ -6482,7 +6432,6 @@ lpfc_issue_els_rrq(struct lpfc_vport *vp
 {
 	struct lpfc_hba  *phba = vport->phba;
 	struct RRQ *els_rrq;
-	IOCB_t *icmd;
 	struct lpfc_iocbq *elsiocb;
 	uint8_t *pcmd;
 	uint16_t cmdsize;
@@ -6501,7 +6450,6 @@ lpfc_issue_els_rrq(struct lpfc_vport *vp
 	if (!elsiocb)
 		return 1;
 
-	icmd = &elsiocb->iocb;
 	pcmd = (uint8_t *) (((struct lpfc_dmabuf *) elsiocb->context2)->virt);
 
 	/* For RRQ request, remainder of payload is Exchange IDs */
@@ -8428,7 +8376,6 @@ lpfc_issue_els_npiv_logo(struct lpfc_vpo
 {
 	struct Scsi_Host *shost = lpfc_shost_from_vport(vport);
 	struct lpfc_hba  *phba = vport->phba;
-	IOCB_t *icmd;
 	struct lpfc_iocbq *elsiocb;
 	uint8_t *pcmd;
 	uint16_t cmdsize;
@@ -8439,7 +8386,6 @@ lpfc_issue_els_npiv_logo(struct lpfc_vpo
 	if (!elsiocb)
 		return 1;
 
-	icmd = &elsiocb->iocb;
 	pcmd = (uint8_t *) (((struct lpfc_dmabuf *) elsiocb->context2)->virt);
 	*((uint32_t *) (pcmd)) = ELS_CMD_LOGO;
 	pcmd += sizeof(uint32_t);
diff -urp a/drivers/scsi/lpfc/lpfc_hbadisc.c b/drivers/scsi/lpfc/lpfc_hbadisc.c
--- a/drivers/scsi/lpfc/lpfc_hbadisc.c	2015-07-05 22:18:43.933739150 +0200
+++ b/drivers/scsi/lpfc/lpfc_hbadisc.c	2015-07-25 01:39:57.620812429 +0200
@@ -800,7 +800,6 @@ lpfc_cleanup_rpis(struct lpfc_vport *vpo
 	struct Scsi_Host *shost = lpfc_shost_from_vport(vport);
 	struct lpfc_hba  *phba = vport->phba;
 	struct lpfc_nodelist *ndlp, *next_ndlp;
-	int  rc;
 
 	list_for_each_entry_safe(ndlp, next_ndlp, &vport->fc_nodes, nlp_listp) {
 		if (!NLP_CHK_NODE_ACT(ndlp))
@@ -816,10 +815,10 @@ lpfc_cleanup_rpis(struct lpfc_vport *vpo
 		if ((phba->sli_rev < LPFC_SLI_REV4) &&
 		    (!remove && ndlp->nlp_type & NLP_FABRIC))
 			continue;
-		rc = lpfc_disc_state_machine(vport, ndlp, NULL,
-					     remove
-					     ? NLP_EVT_DEVICE_RM
-					     : NLP_EVT_DEVICE_RECOVERY);
+		lpfc_disc_state_machine(vport, ndlp, NULL,
+					remove
+					? NLP_EVT_DEVICE_RM
+					: NLP_EVT_DEVICE_RECOVERY);
 	}
 	if (phba->sli3_options & LPFC_SLI3_VPORT_TEARDOWN) {
 		if (phba->sli_rev == LPFC_SLI_REV4)
@@ -1774,7 +1773,6 @@ lpfc_sli4_fcf_rec_mbox_parse(struct lpfc
 			     uint16_t *next_fcf_index)
 {
 	void *virt_addr;
-	dma_addr_t phys_addr;
 	struct lpfc_mbx_sge sge;
 	struct lpfc_mbx_read_fcf_tbl *read_fcf;
 	uint32_t shdr_status, shdr_add_status, if_type;
@@ -1785,7 +1783,6 @@ lpfc_sli4_fcf_rec_mbox_parse(struct lpfc
 	 * routine only uses a single SGE.
 	 */
 	lpfc_sli4_mbx_sge_get(mboxq, 0, &sge);
-	phys_addr = getPaddr(sge.pa_hi, sge.pa_lo);
 	if (unlikely(!mboxq->sge_array)) {
 		lpfc_printf_log(phba, KERN_ERR, LOG_MBOX,
 				"2524 Failed to get the non-embedded SGE "
diff -urp a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
--- a/drivers/scsi/lpfc/lpfc_init.c	2015-07-05 22:18:43.941739151 +0200
+++ b/drivers/scsi/lpfc/lpfc_init.c	2015-07-25 01:37:39.056806110 +0200
@@ -10287,7 +10287,7 @@ lpfc_pci_probe_one_s4(struct pci_dev *pd
 	struct lpfc_hba   *phba;
 	struct lpfc_vport *vport = NULL;
 	struct Scsi_Host  *shost = NULL;
-	int error, ret;
+	int error;
 	uint32_t cfg_mode, intr_mode;
 	int adjusted_fcp_io_channel;
 
@@ -10411,7 +10411,7 @@ lpfc_pci_probe_one_s4(struct pci_dev *pd
 
 	/* check for firmware upgrade or downgrade */
 	if (phba->cfg_request_firmware_upgrade)
-		ret = lpfc_sli4_request_firmware_update(phba, INT_FW_UPGRADE);
+		lpfc_sli4_request_firmware_update(phba, INT_FW_UPGRADE);
 
 	/* Check if there are static vports to be created. */
 	lpfc_create_static_vport(phba);
diff -urp a/drivers/scsi/lpfc/lpfc_mbox.c b/drivers/scsi/lpfc/lpfc_mbox.c
--- a/drivers/scsi/lpfc/lpfc_mbox.c	2015-07-05 22:18:43.945739151 +0200
+++ b/drivers/scsi/lpfc/lpfc_mbox.c	2015-07-25 01:33:46.384795500 +0200
@@ -289,9 +289,7 @@ lpfc_read_topology(struct lpfc_hba *phba
 		   struct lpfc_dmabuf *mp)
 {
 	MAILBOX_t *mb;
-	struct lpfc_sli *psli;
 
-	psli = &phba->sli;
 	mb = &pmb->u.mb;
 	memset(pmb, 0, sizeof (LPFC_MBOXQ_t));
 
@@ -483,13 +481,11 @@ lpfc_init_link(struct lpfc_hba * phba,
 	       LPFC_MBOXQ_t * pmb, uint32_t topology, uint32_t linkspeed)
 {
 	lpfc_vpd_t *vpd;
-	struct lpfc_sli *psli;
 	MAILBOX_t *mb;
 
 	mb = &pmb->u.mb;
 	memset(pmb, 0, sizeof (LPFC_MBOXQ_t));
 
-	psli = &phba->sli;
 	switch (topology) {
 	case FLAGS_TOPOLOGY_MODE_LOOP_PT:
 		mb->un.varInitLnk.link_flags = FLAGS_TOPOLOGY_MODE_LOOP;
@@ -585,9 +581,7 @@ lpfc_read_sparam(struct lpfc_hba *phba,
 {
 	struct lpfc_dmabuf *mp;
 	MAILBOX_t *mb;
-	struct lpfc_sli *psli;
 
-	psli = &phba->sli;
 	mb = &pmb->u.mb;
 	memset(pmb, 0, sizeof (LPFC_MBOXQ_t));
 
@@ -2010,7 +2004,6 @@ lpfc_sli4_mbx_read_fcf_rec(struct lpfc_h
 			   uint16_t fcf_index)
 {
 	void *virt_addr;
-	dma_addr_t phys_addr;
 	uint8_t *bytep;
 	struct lpfc_mbx_sge sge;
 	uint32_t alloc_len, req_len;
@@ -2039,7 +2032,6 @@ lpfc_sli4_mbx_read_fcf_rec(struct lpfc_h
 	 * routine only uses a single SGE.
 	 */
 	lpfc_sli4_mbx_sge_get(mboxq, 0, &sge);
-	phys_addr = getPaddr(sge.pa_hi, sge.pa_lo);
 	virt_addr = mboxq->sge_array->addr[0];
 	read_fcf = (struct lpfc_mbx_read_fcf_tbl *)virt_addr;
 
diff -urp a/drivers/scsi/lpfc/lpfc_nportdisc.c b/drivers/scsi/lpfc/lpfc_nportdisc.c
--- a/drivers/scsi/lpfc/lpfc_nportdisc.c	2015-07-05 22:18:43.945739151 +0200
+++ b/drivers/scsi/lpfc/lpfc_nportdisc.c	2015-07-25 01:32:06.948790965 +0200
@@ -820,7 +820,6 @@ lpfc_disc_illegal(struct lpfc_vport *vpo
 {
 	struct lpfc_hba *phba;
 	LPFC_MBOXQ_t *pmb = (LPFC_MBOXQ_t *) arg;
-	MAILBOX_t *mb;
 	uint16_t rpi;
 
 	phba = vport->phba;
@@ -828,7 +827,6 @@ lpfc_disc_illegal(struct lpfc_vport *vpo
 	if (!(phba->pport->load_flag & FC_UNLOADING) &&
 		(evt == NLP_EVT_CMPL_REG_LOGIN) &&
 		(!pmb->u.mb.mbxStatus)) {
-		mb = &pmb->u.mb;
 		rpi = pmb->u.mb.un.varWords[0];
 		lpfc_release_rpi(phba, vport, rpi);
 	}
diff -urp a/drivers/scsi/lpfc/lpfc_scsi.c b/drivers/scsi/lpfc/lpfc_scsi.c
--- a/drivers/scsi/lpfc/lpfc_scsi.c	2015-07-05 22:18:43.949739151 +0200
+++ b/drivers/scsi/lpfc/lpfc_scsi.c	2015-07-25 01:30:39.668786985 +0200
@@ -1293,7 +1293,6 @@ lpfc_bg_err_inject(struct lpfc_hba *phba
 		uint32_t *reftag, uint16_t *apptag, uint32_t new_guard)
 {
 	struct scatterlist *sgpe; /* s/g prot entry */
-	struct scatterlist *sgde; /* s/g data entry */
 	struct lpfc_scsi_buf *lpfc_cmd = NULL;
 	struct scsi_dif_tuple *src = NULL;
 	struct lpfc_nodelist *ndlp;
@@ -1309,7 +1308,6 @@ lpfc_bg_err_inject(struct lpfc_hba *phba
 		return 0;
 
 	sgpe = scsi_prot_sglist(sc);
-	sgde = scsi_sglist(sc);
 	lba = scsi_get_lba(sc);
 
 	/* First check if we need to match the LBA */
@@ -1882,7 +1880,6 @@ lpfc_bg_setup_bpl(struct lpfc_hba *phba,
 #endif
 	uint32_t checking = 1;
 	uint32_t reftag;
-	unsigned blksize;
 	uint8_t txop, rxop;
 
 	status  = lpfc_sc_to_bg_opcodes(phba, sc, &txop, &rxop);
@@ -1890,7 +1887,6 @@ lpfc_bg_setup_bpl(struct lpfc_hba *phba,
 		goto out;
 
 	/* extract some info from the scsi command for pde*/
-	blksize = lpfc_cmd_blksize(sc);
 	reftag = (uint32_t)scsi_get_lba(sc); /* Truncate LBA */
 
 #ifdef CONFIG_SCSI_LPFC_DEBUG_FS
@@ -2263,7 +2259,6 @@ lpfc_bg_setup_sgl(struct lpfc_hba *phba,
 	dma_addr_t physaddr;
 	int i = 0, num_sge = 0, status;
 	uint32_t reftag;
-	unsigned blksize;
 	uint8_t txop, rxop;
 #ifdef CONFIG_SCSI_LPFC_DEBUG_FS
 	uint32_t rc;
@@ -2277,7 +2272,6 @@ lpfc_bg_setup_sgl(struct lpfc_hba *phba,
 		goto out;
 
 	/* extract some info from the scsi command for pde*/
-	blksize = lpfc_cmd_blksize(sc);
 	reftag = (uint32_t)scsi_get_lba(sc); /* Truncate LBA */
 
 #ifdef CONFIG_SCSI_LPFC_DEBUG_FS
@@ -2881,7 +2875,7 @@ lpfc_calc_bg_err(struct lpfc_hba *phba,
 	struct scsi_cmnd *cmd = lpfc_cmd->pCmd;
 	struct scsi_dif_tuple *src = NULL;
 	uint8_t *data_src = NULL;
-	uint16_t guard_tag, guard_type;
+	uint16_t guard_tag;
 	uint16_t start_app_tag, app_tag;
 	uint32_t start_ref_tag, ref_tag;
 	int prot, protsegcnt;
@@ -2922,7 +2916,6 @@ lpfc_calc_bg_err(struct lpfc_hba *phba,
 		data_len = sgde->length;
 		if ((data_len & (blksize - 1)) == 0)
 			chk_guard = 1;
-		guard_type = scsi_host_get_guard(cmd->device->host);
 
 		src = (struct scsi_dif_tuple *)sg_virt(sgpe);
 		start_ref_tag = (uint32_t)scsi_get_lba(cmd); /* Truncate LBA */
@@ -3908,12 +3901,10 @@ lpfc_scsi_cmd_iocb_cmpl(struct lpfc_hba
 	struct lpfc_rport_data *rdata = lpfc_cmd->rdata;
 	struct lpfc_nodelist *pnode = rdata->pnode;
 	struct scsi_cmnd *cmd;
-	int result;
 	int depth;
 	unsigned long flags;
 	struct lpfc_fast_path_event *fast_path_evt;
 	struct Scsi_Host *shost;
-	uint32_t queue_depth, scsi_id;
 	uint32_t logit = LOG_FCP;
 
 	/* Sanity check on return of outstanding command */
@@ -4095,7 +4086,6 @@ lpfc_scsi_cmd_iocb_cmpl(struct lpfc_hba
 	}
 
 	lpfc_update_stats(phba, lpfc_cmd);
-	result = cmd->result;
 	if (vport->cfg_max_scsicmpl_time &&
 	   time_after(jiffies, lpfc_cmd->start_time +
 		msecs_to_jiffies(vport->cfg_max_scsicmpl_time))) {
@@ -4132,8 +4122,6 @@ lpfc_scsi_cmd_iocb_cmpl(struct lpfc_hba
 	lpfc_scsi_unprep_dma_buf(phba, lpfc_cmd);
 
 	/* The sdev is not guaranteed to be valid post scsi_done upcall. */
-	queue_depth = cmd->device->queue_depth;
-	scsi_id = cmd->device->id;
 	cmd->scsi_done(cmd);
 
 	if (phba->cfg_poll & ENABLE_FCP_RING_POLLING) {
diff -urp a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
--- a/drivers/scsi/lpfc/lpfc_sli.c	2015-07-05 22:18:43.953739151 +0200
+++ b/drivers/scsi/lpfc/lpfc_sli.c	2015-07-25 01:58:34.944863383 +0200
@@ -12491,12 +12491,10 @@ lpfc_sli4_fof_intr_handler(int irq, void
 	struct lpfc_eqe *eqe;
 	unsigned long iflag;
 	int ecount = 0;
-	uint32_t eqidx;
 
 	/* Get the driver's phba structure from the dev_id */
 	fcp_eq_hdl = (struct lpfc_fcp_eq_hdl *)dev_id;
 	phba = fcp_eq_hdl->phba;
-	eqidx = fcp_eq_hdl->idx;
 
 	if (unlikely(!phba))
 		return IRQ_NONE;
@@ -12831,12 +12829,8 @@ out_fail:
 static void __iomem *
 lpfc_dual_chute_pci_bar_map(struct lpfc_hba *phba, uint16_t pci_barset)
 {
-	struct pci_dev *pdev;
-
 	if (!phba->pcidev)
 		return NULL;
-	else
-		pdev = phba->pcidev;
 
 	switch (pci_barset) {
 	case WQ_PCI_BAR_0_AND_1:
@@ -15920,7 +15914,6 @@ lpfc_sli4_add_fcf_record(struct lpfc_hba
 	LPFC_MBOXQ_t *mboxq;
 	uint8_t *bytep;
 	void *virt_addr;
-	dma_addr_t phys_addr;
 	struct lpfc_mbx_sge sge;
 	uint32_t alloc_len, req_len;
 	uint32_t fcfindex;
@@ -15953,7 +15946,6 @@ lpfc_sli4_add_fcf_record(struct lpfc_hba
 	 * routine only uses a single SGE.
 	 */
 	lpfc_sli4_mbx_sge_get(mboxq, 0, &sge);
-	phys_addr = getPaddr(sge.pa_hi, sge.pa_lo);
 	virt_addr = mboxq->sge_array->addr[0];
 	/*
 	 * Configure the FCF record for FCFI 0.  This is the driver's
