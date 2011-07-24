From: michaelc@cs.wisc.edu
Subject: [PATCH RFC/RFT 07/10] lpfc: convert lpfc to blk bsg lib
Date: Sun, 24 Jul 2011 03:59:21 -0500
Message-ID: <1311497964-26842-8-git-send-email-michaelc@cs.wisc.edu>
References: <1311497964-26842-1-git-send-email-michaelc@cs.wisc.edu>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:56749 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752235Ab1GXI4t (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 24 Jul 2011 04:56:49 -0400
In-Reply-To: <1311497964-26842-1-git-send-email-michaelc@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Mike Christie <michaelc@cs.wisc.edu>, James Smart <james.smart@emulex.com>

From: Mike Christie <michaelc@cs.wisc.edu>

This patch converts lpfc to the blk bsg lib. The differences
visible to the driver are:
- fc_bsg_job is now named bsg_job.
- no rport pointer. Can access it through the device pointer.
- the request and reply pointers on the scsi_bsg_job struct
  are now void pointers, so you cannot do bsg_job->request->some_field.

Patch is only compile tested and made over scsi-misc.

Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
Cc: James Smart <james.smart@emulex.com>
---
 drivers/scsi/lpfc/lpfc_bsg.c  |  428 ++++++++++++++++++++++++-----------------
 drivers/scsi/lpfc/lpfc_crtn.h |    4 +-
 2 files changed, 252 insertions(+), 180 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_bsg.c b/drivers/scsi/lpfc/lpfc_bsg.c
index 7fb0ba4..2a5ee63 100644
--- a/drivers/scsi/lpfc/lpfc_bsg.c
+++ b/drivers/scsi/lpfc/lpfc_bsg.c
@@ -64,7 +64,7 @@ struct lpfc_bsg_event {
 	struct list_head events_to_see;
 
 	/* job waiting for this event to finish */
-	struct fc_bsg_job *set_job;
+	struct bsg_job *set_job;
 };
 
 struct lpfc_bsg_iocb {
@@ -74,7 +74,7 @@ struct lpfc_bsg_iocb {
 	struct lpfc_nodelist *ndlp;
 
 	/* job waiting for this iocb to finish */
-	struct fc_bsg_job *set_job;
+	struct bsg_job *set_job;
 };
 
 struct lpfc_bsg_mbox {
@@ -87,7 +87,7 @@ struct lpfc_bsg_mbox {
 	uint32_t outExtWLen; /* from app */
 
 	/* job waiting for this mbox command to finish */
-	struct fc_bsg_job *set_job;
+	struct bsg_job *set_job;
 };
 
 #define MENLO_DID 0x0000FC0E
@@ -98,7 +98,7 @@ struct lpfc_bsg_menlo {
 	struct lpfc_dmabuf *bmp;
 
 	/* job waiting for this iocb to finish */
-	struct fc_bsg_job *set_job;
+	struct bsg_job *set_job;
 };
 
 #define TYPE_EVT 	1
@@ -163,7 +163,8 @@ lpfc_bsg_send_mgmt_cmd_cmp(struct lpfc_hba *phba,
 			struct lpfc_iocbq *rspiocbq)
 {
 	struct bsg_job_data *dd_data;
-	struct fc_bsg_job *job;
+	struct bsg_job *job;
+	struct fc_bsg_reply *reply;
 	IOCB_t *rsp;
 	struct lpfc_dmabuf *bmp;
 	struct lpfc_nodelist *ndlp;
@@ -182,6 +183,7 @@ lpfc_bsg_send_mgmt_cmd_cmp(struct lpfc_hba *phba,
 	iocb = &dd_data->context_un.iocb;
 	job = iocb->set_job;
 	job->dd_data = NULL; /* so timeout handler does not reply */
+	reply = job->reply;
 
 	bmp = iocb->bmp;
 	rsp = &rspiocbq->iocb;
@@ -208,7 +210,7 @@ lpfc_bsg_send_mgmt_cmd_cmp(struct lpfc_hba *phba,
 		} else
 			rc = -EACCES;
 	} else
-		job->reply->reply_payload_rcv_len =
+		reply->reply_payload_rcv_len =
 			rsp->un.genreq64.bdl.bdeSize;
 
 	lpfc_mbuf_free(phba, bmp->virt, bmp->phys);
@@ -217,23 +219,26 @@ lpfc_bsg_send_mgmt_cmd_cmp(struct lpfc_hba *phba,
 	kfree(bmp);
 	kfree(dd_data);
 	/* make error code available to userspace */
-	job->reply->result = rc;
+	reply->result = rc;
 	/* complete the job back to userspace */
-	job->job_done(job);
+	bsg_job_done(job, rc, reply->reply_payload_rcv_len);
 	spin_unlock_irqrestore(&phba->ct_ev_lock, flags);
 	return;
 }
 
 /**
  * lpfc_bsg_send_mgmt_cmd - send a CT command from a bsg request
- * @job: fc_bsg_job to handle
+ * @job: bsg_job to handle
  **/
 static int
-lpfc_bsg_send_mgmt_cmd(struct fc_bsg_job *job)
+lpfc_bsg_send_mgmt_cmd(struct bsg_job *job)
 {
-	struct lpfc_vport *vport = (struct lpfc_vport *)job->shost->hostdata;
+	struct Scsi_Host *shost = fc_bsg_to_shost(job);
+	struct lpfc_vport *vport = (struct lpfc_vport *)shost->hostdata;
 	struct lpfc_hba *phba = vport->phba;
-	struct lpfc_rport_data *rdata = job->rport->dd_data;
+	struct fc_rport *rport = fc_bsg_to_rport(job);
+	struct lpfc_rport_data *rdata = rport->dd_data;
+	struct fc_bsg_reply *reply = job->reply;
 	struct lpfc_nodelist *ndlp = rdata->pnode;
 	struct ulp_bde64 *bpl = NULL;
 	uint32_t timeout;
@@ -251,7 +256,7 @@ lpfc_bsg_send_mgmt_cmd(struct fc_bsg_job *job)
 	int iocb_stat;
 
 	/* in case no data is transferred */
-	job->reply->reply_payload_rcv_len = 0;
+	reply->reply_payload_rcv_len = 0;
 
 	/* allocate our bsg tracking structure */
 	dd_data = kmalloc(sizeof(struct bsg_job_data), GFP_KERNEL);
@@ -386,7 +391,7 @@ no_ndlp:
 	kfree(dd_data);
 no_dd_data:
 	/* make error code available to userspace */
-	job->reply->result = rc;
+	reply->result = rc;
 	job->dd_data = NULL;
 	return rc;
 }
@@ -414,7 +419,8 @@ lpfc_bsg_rport_els_cmp(struct lpfc_hba *phba,
 			struct lpfc_iocbq *rspiocbq)
 {
 	struct bsg_job_data *dd_data;
-	struct fc_bsg_job *job;
+	struct bsg_job *job;
+	struct fc_bsg_reply *reply;
 	IOCB_t *rsp;
 	struct lpfc_nodelist *ndlp;
 	struct lpfc_dmabuf *pbuflist = NULL;
@@ -437,6 +443,7 @@ lpfc_bsg_rport_els_cmp(struct lpfc_hba *phba,
 		       &rspiocbq->iocb, sizeof(IOCB_t));
 
 	job = dd_data->context_un.iocb.set_job;
+	reply = job->reply;
 	cmdiocbq = dd_data->context_un.iocb.cmdiocbq;
 	rspiocbq = dd_data->context_un.iocb.rspiocbq;
 	rsp = &rspiocbq->iocb;
@@ -447,17 +454,17 @@ lpfc_bsg_rport_els_cmp(struct lpfc_hba *phba,
 	pci_unmap_sg(phba->pcidev, job->reply_payload.sg_list,
 		     job->reply_payload.sg_cnt, DMA_FROM_DEVICE);
 
-	if (job->reply->result == -EAGAIN)
+	if (reply->result == -EAGAIN)
 		rc = -EAGAIN;
 	else if (rsp->ulpStatus == IOSTAT_SUCCESS)
-		job->reply->reply_payload_rcv_len =
+		reply->reply_payload_rcv_len =
 			rsp->un.elsreq64.bdl.bdeSize;
 	else if (rsp->ulpStatus == IOSTAT_LS_RJT) {
-		job->reply->reply_payload_rcv_len =
+		reply->reply_payload_rcv_len =
 			sizeof(struct fc_bsg_ctels_reply);
 		/* LS_RJT data returned in word 4 */
 		rjt_data = (uint8_t *)&rsp->un.ulpWord[4];
-		els_reply = &job->reply->reply_data.ctels_reply;
+		els_reply = &reply->reply_data.ctels_reply;
 		els_reply->status = FC_CTELS_STATUS_REJECT;
 		els_reply->rjt_data.action = rjt_data[3];
 		els_reply->rjt_data.reason_code = rjt_data[2];
@@ -473,24 +480,26 @@ lpfc_bsg_rport_els_cmp(struct lpfc_hba *phba,
 	lpfc_nlp_put(ndlp);
 	kfree(dd_data);
 	/* make error code available to userspace */
-	job->reply->result = rc;
+	reply->result = rc;
 	job->dd_data = NULL;
 	/* complete the job back to userspace */
-	job->job_done(job);
+	bsg_job_done(job, rc, reply->reply_payload_rcv_len);
 	spin_unlock_irqrestore(&phba->ct_ev_lock, flags);
 	return;
 }
 
 /**
  * lpfc_bsg_rport_els - send an ELS command from a bsg request
- * @job: fc_bsg_job to handle
+ * @job: bsg_job to handle
  **/
 static int
-lpfc_bsg_rport_els(struct fc_bsg_job *job)
+lpfc_bsg_rport_els(struct bsg_job *job)
 {
-	struct lpfc_vport *vport = (struct lpfc_vport *)job->shost->hostdata;
+	struct Scsi_Host *shost = fc_bsg_to_shost(job);
+	struct lpfc_vport *vport = (struct lpfc_vport *)shost->hostdata;
 	struct lpfc_hba *phba = vport->phba;
-	struct lpfc_rport_data *rdata = job->rport->dd_data;
+	struct fc_rport *rport = fc_bsg_to_rport(job);
+	struct lpfc_rport_data *rdata = rport->dd_data;
 	struct lpfc_nodelist *ndlp = rdata->pnode;
 	uint32_t elscmd;
 	uint32_t cmdsize;
@@ -509,11 +518,13 @@ lpfc_bsg_rport_els(struct fc_bsg_job *job)
 	int numbde;
 	dma_addr_t busaddr;
 	struct bsg_job_data *dd_data;
+	struct fc_bsg_request *req = job->request;
+	struct fc_bsg_reply *reply = job->reply;
 	uint32_t creg_val;
 	int rc = 0;
 
 	/* in case no data is transferred */
-	job->reply->reply_payload_rcv_len = 0;
+	reply->reply_payload_rcv_len = 0;
 
 	/* allocate our bsg tracking structure */
 	dd_data = kmalloc(sizeof(struct bsg_job_data), GFP_KERNEL);
@@ -529,7 +540,7 @@ lpfc_bsg_rport_els(struct fc_bsg_job *job)
 		goto free_dd_data;
 	}
 
-	elscmd = job->request->rqst_data.r_els.els_code;
+	elscmd = req->rqst_data.r_els.els_code;
 	cmdsize = job->request_payload.payload_len;
 	rspsize = job->reply_payload.payload_len;
 	rspiocbq = lpfc_sli_get_iocbq(phba);
@@ -639,7 +650,7 @@ free_dd_data:
 
 no_dd_data:
 	/* make error code available to userspace */
-	job->reply->result = rc;
+	reply->result = rc;
 	job->dd_data = NULL;
 	return rc;
 }
@@ -784,7 +795,8 @@ lpfc_bsg_ct_unsol_event(struct lpfc_hba *phba, struct lpfc_sli_ring *pring,
 	struct lpfc_dmabuf *bdeBuf2 = piocbq->context3;
 	struct lpfc_hbq_entry *hbqe;
 	struct lpfc_sli_ct_request *ct_req;
-	struct fc_bsg_job *job = NULL;
+	struct bsg_job *job = NULL;
+	struct fc_bsg_reply *reply;
 	unsigned long flags;
 	int size = 0;
 
@@ -982,13 +994,15 @@ lpfc_bsg_ct_unsol_event(struct lpfc_hba *phba, struct lpfc_sli_ring *pring,
 		job = evt->set_job;
 		evt->set_job = NULL;
 		if (job) {
-			job->reply->reply_payload_rcv_len = size;
+			reply = job->reply;
+			reply->reply_payload_rcv_len = size;
+
 			/* make error code available to userspace */
-			job->reply->result = 0;
+			reply->result = 0;
 			job->dd_data = NULL;
 			/* complete the job back to userspace */
 			spin_unlock_irqrestore(&phba->ct_ev_lock, flags);
-			job->job_done(job);
+			bsg_job_done(job, 0, size);
 			spin_lock_irqsave(&phba->ct_ev_lock, flags);
 		}
 	}
@@ -1004,16 +1018,18 @@ error_ct_unsol_exit:
 
 /**
  * lpfc_bsg_hba_set_event - process a SET_EVENT bsg vendor command
- * @job: SET_EVENT fc_bsg_job
+ * @job: SET_EVENT bsg_job
  **/
 static int
-lpfc_bsg_hba_set_event(struct fc_bsg_job *job)
+lpfc_bsg_hba_set_event(struct bsg_job *job)
 {
-	struct lpfc_vport *vport = (struct lpfc_vport *)job->shost->hostdata;
+	struct Scsi_Host *shost = fc_bsg_to_shost(job);
+	struct lpfc_vport *vport = (struct lpfc_vport *)shost->hostdata;
 	struct lpfc_hba *phba = vport->phba;
 	struct set_ct_event *event_req;
 	struct lpfc_bsg_event *evt;
 	int rc = 0;
+	struct fc_bsg_request *req = job->request;
 	struct bsg_job_data *dd_data = NULL;
 	uint32_t ev_mask;
 	unsigned long flags;
@@ -1036,7 +1052,7 @@ lpfc_bsg_hba_set_event(struct fc_bsg_job *job)
 	}
 
 	event_req = (struct set_ct_event *)
-		job->request->rqst_data.h_vendor.vendor_cmd;
+		req->rqst_data.h_vendor.vendor_cmd;
 	ev_mask = ((uint32_t)(unsigned long)event_req->type_mask &
 				FC_REG_EVENT_MASK);
 	spin_lock_irqsave(&phba->ct_ev_lock, flags);
@@ -1087,12 +1103,15 @@ job_error:
 
 /**
  * lpfc_bsg_hba_get_event - process a GET_EVENT bsg vendor command
- * @job: GET_EVENT fc_bsg_job
+ * @job: GET_EVENT bsg_job
  **/
 static int
-lpfc_bsg_hba_get_event(struct fc_bsg_job *job)
+lpfc_bsg_hba_get_event(struct bsg_job *job)
 {
-	struct lpfc_vport *vport = (struct lpfc_vport *)job->shost->hostdata;
+	struct fc_bsg_reply *reply = job->reply;
+	struct fc_bsg_request *req = job->request;
+	struct Scsi_Host *shost = fc_bsg_to_shost(job);
+	struct lpfc_vport *vport = (struct lpfc_vport *)shost->hostdata;
 	struct lpfc_hba *phba = vport->phba;
 	struct get_ct_event *event_req;
 	struct get_ct_event_reply *event_reply;
@@ -1111,10 +1130,10 @@ lpfc_bsg_hba_get_event(struct fc_bsg_job *job)
 	}
 
 	event_req = (struct get_ct_event *)
-		job->request->rqst_data.h_vendor.vendor_cmd;
+		req->rqst_data.h_vendor.vendor_cmd;
 
 	event_reply = (struct get_ct_event_reply *)
-		job->reply->reply_data.vendor_reply.vendor_rsp;
+		reply->reply_data.vendor_reply.vendor_rsp;
 	spin_lock_irqsave(&phba->ct_ev_lock, flags);
 	list_for_each_entry(evt, &phba->ct_ev_waiters, node) {
 		if (evt->reg_id == event_req->ev_reg_id) {
@@ -1134,7 +1153,7 @@ lpfc_bsg_hba_get_event(struct fc_bsg_job *job)
 	 * an error indicating that there isn't anymore
 	 */
 	if (evt_dat == NULL) {
-		job->reply->reply_payload_rcv_len = 0;
+		reply->reply_payload_rcv_len = 0;
 		rc = -ENOENT;
 		goto job_error;
 	}
@@ -1150,12 +1169,12 @@ lpfc_bsg_hba_get_event(struct fc_bsg_job *job)
 	event_reply->type = evt_dat->type;
 	event_reply->immed_data = evt_dat->immed_dat;
 	if (evt_dat->len > 0)
-		job->reply->reply_payload_rcv_len =
+		reply->reply_payload_rcv_len =
 			sg_copy_from_buffer(job->request_payload.sg_list,
 					    job->request_payload.sg_cnt,
 					    evt_dat->data, evt_dat->len);
 	else
-		job->reply->reply_payload_rcv_len = 0;
+		reply->reply_payload_rcv_len = 0;
 
 	if (evt_dat) {
 		kfree(evt_dat->data);
@@ -1166,13 +1185,13 @@ lpfc_bsg_hba_get_event(struct fc_bsg_job *job)
 	lpfc_bsg_event_unref(evt);
 	spin_unlock_irqrestore(&phba->ct_ev_lock, flags);
 	job->dd_data = NULL;
-	job->reply->result = 0;
-	job->job_done(job);
+	reply->result = 0;
+	bsg_job_done(job, 0, reply->reply_payload_rcv_len);
 	return 0;
 
 job_error:
 	job->dd_data = NULL;
-	job->reply->result = rc;
+	reply->result = rc;
 	return rc;
 }
 
@@ -1199,7 +1218,8 @@ lpfc_issue_ct_rsp_cmp(struct lpfc_hba *phba,
 			struct lpfc_iocbq *rspiocbq)
 {
 	struct bsg_job_data *dd_data;
-	struct fc_bsg_job *job;
+	struct bsg_job *job;
+	struct fc_bsg_reply *reply;
 	IOCB_t *rsp;
 	struct lpfc_dmabuf *bmp;
 	struct lpfc_nodelist *ndlp;
@@ -1218,6 +1238,7 @@ lpfc_issue_ct_rsp_cmp(struct lpfc_hba *phba,
 	bmp = dd_data->context_un.iocb.bmp;
 	rsp = &rspiocbq->iocb;
 	ndlp = dd_data->context_un.iocb.ndlp;
+	reply = job->reply;
 
 	pci_unmap_sg(phba->pcidev, job->request_payload.sg_list,
 		     job->request_payload.sg_cnt, DMA_TO_DEVICE);
@@ -1238,7 +1259,7 @@ lpfc_issue_ct_rsp_cmp(struct lpfc_hba *phba,
 		} else
 			rc = -EACCES;
 	} else
-		job->reply->reply_payload_rcv_len =
+		reply->reply_payload_rcv_len =
 			rsp->un.genreq64.bdl.bdeSize;
 
 	lpfc_mbuf_free(phba, bmp->virt, bmp->phys);
@@ -1247,10 +1268,10 @@ lpfc_issue_ct_rsp_cmp(struct lpfc_hba *phba,
 	kfree(bmp);
 	kfree(dd_data);
 	/* make error code available to userspace */
-	job->reply->result = rc;
+	reply->result = rc;
 	job->dd_data = NULL;
 	/* complete the job back to userspace */
-	job->job_done(job);
+	bsg_job_done(job, rc, reply->reply_payload_rcv_len);
 	spin_unlock_irqrestore(&phba->ct_ev_lock, flags);
 	return;
 }
@@ -1264,8 +1285,8 @@ lpfc_issue_ct_rsp_cmp(struct lpfc_hba *phba,
  * @num_entry: Number of enties in the bde.
  **/
 static int
-lpfc_issue_ct_rsp(struct lpfc_hba *phba, struct fc_bsg_job *job, uint32_t tag,
-		  struct lpfc_dmabuf *bmp, int num_entry)
+lpfc_issue_ct_rsp(struct lpfc_hba *phba, struct bsg_job *job,
+		  uint32_t tag, struct lpfc_dmabuf *bmp, int num_entry)
 {
 	IOCB_t *icmd;
 	struct lpfc_iocbq *ctiocb = NULL;
@@ -1394,15 +1415,18 @@ no_dd_data:
 
 /**
  * lpfc_bsg_send_mgmt_rsp - process a SEND_MGMT_RESP bsg vendor command
- * @job: SEND_MGMT_RESP fc_bsg_job
+ * @job: SEND_MGMT_RESP bsg_job
  **/
 static int
-lpfc_bsg_send_mgmt_rsp(struct fc_bsg_job *job)
+lpfc_bsg_send_mgmt_rsp(struct bsg_job *job)
 {
-	struct lpfc_vport *vport = (struct lpfc_vport *)job->shost->hostdata;
+	struct Scsi_Host *shost = fc_bsg_to_shost(job);
+	struct lpfc_vport *vport = (struct lpfc_vport *)shost->hostdata;
 	struct lpfc_hba *phba = vport->phba;
+	struct fc_bsg_reply *reply = job->reply;
+	struct fc_bsg_request *req = job->request;
 	struct send_mgmt_resp *mgmt_resp = (struct send_mgmt_resp *)
-		job->request->rqst_data.h_vendor.vendor_cmd;
+		req->rqst_data.h_vendor.vendor_cmd;
 	struct ulp_bde64 *bpl;
 	struct lpfc_dmabuf *bmp = NULL;
 	struct scatterlist *sgel = NULL;
@@ -1415,7 +1439,7 @@ lpfc_bsg_send_mgmt_rsp(struct fc_bsg_job *job)
 	int rc = 0;
 
 	/* in case no data is transferred */
-	job->reply->reply_payload_rcv_len = 0;
+	reply->reply_payload_rcv_len = 0;
 
 	if (!reqbfrcnt || (reqbfrcnt > (80 * BUF_SZ_4K))) {
 		rc = -ERANGE;
@@ -1463,7 +1487,7 @@ send_mgmt_rsp_free_bmp:
 	kfree(bmp);
 send_mgmt_rsp_exit:
 	/* make error code available to userspace */
-	job->reply->result = rc;
+	reply->result = rc;
 	job->dd_data = NULL;
 	return rc;
 }
@@ -1477,7 +1501,7 @@ send_mgmt_rsp_exit:
  * on device.
  */
 static int
-lpfc_bsg_diag_mode_enter(struct lpfc_hba *phba, struct fc_bsg_job *job)
+lpfc_bsg_diag_mode_enter(struct lpfc_hba *phba, struct bsg_job *job)
 {
 	struct lpfc_vport **vports;
 	struct Scsi_Host *shost;
@@ -1561,8 +1585,11 @@ lpfc_bsg_diag_mode_exit(struct lpfc_hba *phba)
  * All of this is done in-line.
  */
 static int
-lpfc_sli3_bsg_diag_loopback_mode(struct lpfc_hba *phba, struct fc_bsg_job *job)
+lpfc_sli3_bsg_diag_loopback_mode(struct lpfc_hba *phba,
+				 struct bsg_job *job)
 {
+	struct fc_bsg_request *req = job->request;
+	struct fc_bsg_reply *reply = job->reply;
 	struct diag_mode_set *loopback_mode;
 	uint32_t link_flags;
 	uint32_t timeout;
@@ -1572,7 +1599,7 @@ lpfc_sli3_bsg_diag_loopback_mode(struct lpfc_hba *phba, struct fc_bsg_job *job)
 	int rc = 0;
 
 	/* no data to return just the return code */
-	job->reply->reply_payload_rcv_len = 0;
+	reply->reply_payload_rcv_len = 0;
 
 	if (job->request_len < sizeof(struct fc_bsg_request) +
 	    sizeof(struct diag_mode_set)) {
@@ -1592,7 +1619,7 @@ lpfc_sli3_bsg_diag_loopback_mode(struct lpfc_hba *phba, struct fc_bsg_job *job)
 
 	/* bring the link to diagnostic mode */
 	loopback_mode = (struct diag_mode_set *)
-		job->request->rqst_data.h_vendor.vendor_cmd;
+		req->rqst_data.h_vendor.vendor_cmd;
 	link_flags = loopback_mode->type;
 	timeout = loopback_mode->timeout * 100;
 
@@ -1664,10 +1691,11 @@ loopback_mode_exit:
 
 job_error:
 	/* make error code available to userspace */
-	job->reply->result = rc;
+	reply->result = rc;
 	/* complete the job back to userspace if no error */
 	if (rc == 0)
-		job->job_done(job);
+		bsg_job_done(job, reply->result,
+			     reply->reply_payload_rcv_len);
 	return rc;
 }
 
@@ -1735,8 +1763,11 @@ link_diag_state_set_out:
  * loopback mode in order to perform a diagnostic loopback test.
  */
 static int
-lpfc_sli4_bsg_diag_loopback_mode(struct lpfc_hba *phba, struct fc_bsg_job *job)
+lpfc_sli4_bsg_diag_loopback_mode(struct lpfc_hba *phba,
+				 struct bsg_job *job)
 {
+	struct fc_bsg_request *req = job->request;
+	struct fc_bsg_reply *reply = job->reply;
 	struct diag_mode_set *loopback_mode;
 	uint32_t link_flags, timeout, req_len, alloc_len;
 	struct lpfc_mbx_set_link_diag_loopback *link_diag_loopback;
@@ -1744,7 +1775,7 @@ lpfc_sli4_bsg_diag_loopback_mode(struct lpfc_hba *phba, struct fc_bsg_job *job)
 	int mbxstatus, i, rc = 0;
 
 	/* no data to return just the return code */
-	job->reply->reply_payload_rcv_len = 0;
+	reply->reply_payload_rcv_len = 0;
 
 	if (job->request_len < sizeof(struct fc_bsg_request) +
 	    sizeof(struct diag_mode_set)) {
@@ -1764,7 +1795,7 @@ lpfc_sli4_bsg_diag_loopback_mode(struct lpfc_hba *phba, struct fc_bsg_job *job)
 
 	/* bring the link to diagnostic mode */
 	loopback_mode = (struct diag_mode_set *)
-		job->request->rqst_data.h_vendor.vendor_cmd;
+		req->rqst_data.h_vendor.vendor_cmd;
 	link_flags = loopback_mode->type;
 	timeout = loopback_mode->timeout * 100;
 
@@ -1838,10 +1869,11 @@ loopback_mode_exit:
 
 job_error:
 	/* make error code available to userspace */
-	job->reply->result = rc;
+	reply->result = rc;
 	/* complete the job back to userspace if no error */
 	if (rc == 0)
-		job->job_done(job);
+		bsg_job_done(job, reply->result,
+			     reply->reply_payload_rcv_len);
 	return rc;
 }
 
@@ -1853,17 +1885,16 @@ job_error:
  * command from the user to proper driver action routines.
  */
 static int
-lpfc_bsg_diag_loopback_mode(struct fc_bsg_job *job)
+lpfc_bsg_diag_loopback_mode(struct bsg_job *job)
 {
-	struct Scsi_Host *shost;
+	struct Scsi_Host *shost = fc_bsg_to_shost(job);
 	struct lpfc_vport *vport;
 	struct lpfc_hba *phba;
 	int rc;
 
-	shost = job->shost;
 	if (!shost)
 		return -ENODEV;
-	vport = (struct lpfc_vport *)job->shost->hostdata;
+	vport = (struct lpfc_vport *)shost->hostdata;
 	if (!vport)
 		return -ENODEV;
 	phba = vport->phba;
@@ -1890,17 +1921,16 @@ lpfc_bsg_diag_loopback_mode(struct fc_bsg_job *job)
  * command from the user to proper driver action routines.
  */
 static int
-lpfc_sli4_bsg_diag_mode_end(struct fc_bsg_job *job)
+lpfc_sli4_bsg_diag_mode_end(struct bsg_job *job)
 {
-	struct Scsi_Host *shost;
+	struct Scsi_Host *shost = fc_bsg_to_shost(job);
 	struct lpfc_vport *vport;
 	struct lpfc_hba *phba;
 	int rc;
 
-	shost = job->shost;
 	if (!shost)
 		return -ENODEV;
-	vport = (struct lpfc_vport *)job->shost->hostdata;
+	vport = (struct lpfc_vport *)shost->hostdata;
 	if (!vport)
 		return -ENODEV;
 	phba = vport->phba;
@@ -1929,9 +1959,11 @@ lpfc_sli4_bsg_diag_mode_end(struct fc_bsg_job *job)
  * applicaiton.
  */
 static int
-lpfc_sli4_bsg_link_diag_test(struct fc_bsg_job *job)
+lpfc_sli4_bsg_link_diag_test(struct bsg_job *job)
 {
-	struct Scsi_Host *shost;
+	struct fc_bsg_request *req = job->request;
+	struct fc_bsg_reply *reply = job->reply;
+	struct Scsi_Host *shost = fc_bsg_to_shost(job);
 	struct lpfc_vport *vport;
 	struct lpfc_hba *phba;
 	LPFC_MBOXQ_t *pmboxq;
@@ -1944,12 +1976,11 @@ lpfc_sli4_bsg_link_diag_test(struct fc_bsg_job *job)
 	struct diag_status *diag_status_reply;
 	int mbxstatus, rc = 0;
 
-	shost = job->shost;
 	if (!shost) {
 		rc = -ENODEV;
 		goto job_error;
 	}
-	vport = (struct lpfc_vport *)job->shost->hostdata;
+	vport = (struct lpfc_vport *)shost->hostdata;
 	if (!vport) {
 		rc = -ENODEV;
 		goto job_error;
@@ -1987,7 +2018,7 @@ lpfc_sli4_bsg_link_diag_test(struct fc_bsg_job *job)
 		goto job_error;
 
 	link_diag_test_cmd = (struct sli4_link_diag *)
-			 job->request->rqst_data.h_vendor.vendor_cmd;
+			     req->rqst_data.h_vendor.vendor_cmd;
 	timeout = link_diag_test_cmd->timeout * 100;
 
 	rc = lpfc_sli4_bsg_set_link_diag_state(phba, 1);
@@ -2038,7 +2069,7 @@ lpfc_sli4_bsg_link_diag_test(struct fc_bsg_job *job)
 	}
 
 	diag_status_reply = (struct diag_status *)
-			    job->reply->reply_data.vendor_reply.vendor_rsp;
+			    reply->reply_data.vendor_reply.vendor_rsp;
 
 	if (job->reply_len <
 	    sizeof(struct fc_bsg_request) + sizeof(struct diag_status)) {
@@ -2066,10 +2097,11 @@ link_diag_test_exit:
 
 job_error:
 	/* make error code available to userspace */
-	job->reply->result = rc;
+	reply->result = rc;
 	/* complete the job back to userspace if no error */
 	if (rc == 0)
-		job->job_done(job);
+		bsg_job_done(job, reply->result,
+			     reply->reply_payload_rcv_len);
 	return rc;
 }
 
@@ -2618,9 +2650,12 @@ err_post_rxbufs_exit:
  * of loopback mode.
  **/
 static int
-lpfc_bsg_diag_loopback_run(struct fc_bsg_job *job)
+lpfc_bsg_diag_loopback_run(struct bsg_job *job)
 {
-	struct lpfc_vport *vport = (struct lpfc_vport *)job->shost->hostdata;
+	struct fc_bsg_request *req = job->request;
+	struct fc_bsg_reply *reply = job->reply;
+	struct Scsi_Host *shost = fc_bsg_to_shost(job);
+	struct lpfc_vport *vport = (struct lpfc_vport *)shost->hostdata;
 	struct lpfc_hba *phba = vport->phba;
 	struct diag_mode_test *diag_mode;
 	struct lpfc_bsg_event *evt;
@@ -2649,7 +2684,7 @@ lpfc_bsg_diag_loopback_run(struct fc_bsg_job *job)
 	uint32_t total_mem;
 
 	/* in case no data is returned return just the return code */
-	job->reply->reply_payload_rcv_len = 0;
+	reply->reply_payload_rcv_len = 0;
 
 	if (job->request_len <
 	    sizeof(struct fc_bsg_request) + sizeof(struct diag_mode_test)) {
@@ -2667,7 +2702,7 @@ lpfc_bsg_diag_loopback_run(struct fc_bsg_job *job)
 	}
 
 	diag_mode = (struct diag_mode_test *)
-		job->request->rqst_data.h_vendor.vendor_cmd;
+		req->rqst_data.h_vendor.vendor_cmd;
 
 	if ((phba->link_state == LPFC_HBA_ERROR) ||
 	    (psli->sli_flag & LPFC_BLOCK_MGMT_IO) ||
@@ -2854,11 +2889,11 @@ lpfc_bsg_diag_loopback_run(struct fc_bsg_job *job)
 			rc = IOCB_SUCCESS;
 			/* skip over elx loopback header */
 			rx_databuf += ELX_LOOPBACK_HEADER_SZ;
-			job->reply->reply_payload_rcv_len =
+			reply->reply_payload_rcv_len =
 				sg_copy_from_buffer(job->reply_payload.sg_list,
 						    job->reply_payload.sg_cnt,
 						    rx_databuf, size);
-			job->reply->reply_payload_rcv_len = size;
+			reply->reply_payload_rcv_len = size;
 		}
 	}
 
@@ -2888,22 +2923,26 @@ err_loopback_test_exit:
 loopback_test_exit:
 	kfree(dataout);
 	/* make error code available to userspace */
-	job->reply->result = rc;
+	reply->result = rc;
 	job->dd_data = NULL;
 	/* complete the job back to userspace if no error */
 	if (rc == 0)
-		job->job_done(job);
+		bsg_job_done(job, reply->result,
+			     reply->reply_payload_rcv_len);
 	return rc;
 }
 
 /**
  * lpfc_bsg_get_dfc_rev - process a GET_DFC_REV bsg vendor command
- * @job: GET_DFC_REV fc_bsg_job
+ * @job: GET_DFC_REV bsg_job
  **/
 static int
-lpfc_bsg_get_dfc_rev(struct fc_bsg_job *job)
+lpfc_bsg_get_dfc_rev(struct bsg_job *job)
 {
-	struct lpfc_vport *vport = (struct lpfc_vport *)job->shost->hostdata;
+	struct fc_bsg_request *req = job->request;
+	struct fc_bsg_reply *reply = job->reply;
+	struct Scsi_Host *shost = fc_bsg_to_shost(job);
+	struct lpfc_vport *vport = (struct lpfc_vport *)shost->hostdata;
 	struct lpfc_hba *phba = vport->phba;
 	struct get_mgmt_rev *event_req;
 	struct get_mgmt_rev_reply *event_reply;
@@ -2919,10 +2958,10 @@ lpfc_bsg_get_dfc_rev(struct fc_bsg_job *job)
 	}
 
 	event_req = (struct get_mgmt_rev *)
-		job->request->rqst_data.h_vendor.vendor_cmd;
+		req->rqst_data.h_vendor.vendor_cmd;
 
 	event_reply = (struct get_mgmt_rev_reply *)
-		job->reply->reply_data.vendor_reply.vendor_rsp;
+		reply->reply_data.vendor_reply.vendor_rsp;
 
 	if (job->reply_len <
 	    sizeof(struct fc_bsg_request) + sizeof(struct get_mgmt_rev_reply)) {
@@ -2936,9 +2975,10 @@ lpfc_bsg_get_dfc_rev(struct fc_bsg_job *job)
 	event_reply->info.a_Major = MANAGEMENT_MAJOR_REV;
 	event_reply->info.a_Minor = MANAGEMENT_MINOR_REV;
 job_error:
-	job->reply->result = rc;
+	reply->result = rc;
 	if (rc == 0)
-		job->job_done(job);
+		bsg_job_done(job, reply->result,
+			     reply->reply_payload_rcv_len);
 	return rc;
 }
 
@@ -2957,7 +2997,8 @@ void
 lpfc_bsg_issue_mbox_cmpl(struct lpfc_hba *phba, LPFC_MBOXQ_t *pmboxq)
 {
 	struct bsg_job_data *dd_data;
-	struct fc_bsg_job *job;
+	struct bsg_job *job;
+	struct fc_bsg_reply *reply;
 	uint32_t size;
 	unsigned long flags;
 	uint8_t *pmb, *pmb_buf;
@@ -2980,8 +3021,9 @@ lpfc_bsg_issue_mbox_cmpl(struct lpfc_hba *phba, LPFC_MBOXQ_t *pmboxq)
 
 	job = dd_data->context_un.mbox.set_job;
 	if (job) {
+		reply = job->reply;
 		size = job->reply_payload.payload_len;
-		job->reply->reply_payload_rcv_len =
+		reply->reply_payload_rcv_len =
 			sg_copy_from_buffer(job->reply_payload.sg_list,
 					    job->reply_payload.sg_cnt,
 					    pmb_buf, size);
@@ -3002,8 +3044,9 @@ lpfc_bsg_issue_mbox_cmpl(struct lpfc_hba *phba, LPFC_MBOXQ_t *pmboxq)
 	kfree(dd_data);
 
 	if (job) {
-		job->reply->result = 0;
-		job->job_done(job);
+		reply->result = 0;
+		bsg_job_done(job, reply->result,
+			     reply->reply_payload_rcv_len);
 	}
 	return;
 }
@@ -3131,11 +3174,12 @@ lpfc_bsg_mbox_ext_session_reset(struct lpfc_hba *phba)
  * This is routine handles BSG job for mailbox commands completions with
  * multiple external buffers.
  **/
-static struct fc_bsg_job *
+static struct bsg_job *
 lpfc_bsg_issue_mbox_ext_handle_job(struct lpfc_hba *phba, LPFC_MBOXQ_t *pmboxq)
 {
 	struct bsg_job_data *dd_data;
-	struct fc_bsg_job *job;
+	struct bsg_job *job;
+	struct fc_bsg_reply *reply;
 	uint8_t *pmb, *pmb_buf;
 	unsigned long flags;
 	uint32_t size;
@@ -3160,13 +3204,14 @@ lpfc_bsg_issue_mbox_ext_handle_job(struct lpfc_hba *phba, LPFC_MBOXQ_t *pmboxq)
 
 	job = dd_data->context_un.mbox.set_job;
 	if (job) {
+		reply = job->reply;
 		size = job->reply_payload.payload_len;
-		job->reply->reply_payload_rcv_len =
+		reply->reply_payload_rcv_len =
 			sg_copy_from_buffer(job->reply_payload.sg_list,
 					    job->reply_payload.sg_cnt,
 					    pmb_buf, size);
 		/* result for successful */
-		job->reply->result = 0;
+		reply->result = 0;
 		job->dd_data = NULL;
 		/* need to hold the lock util we set job->dd_data to NULL
 		 * to hold off the timeout handler from midlayer to take
@@ -3206,7 +3251,8 @@ job_done_out:
 static void
 lpfc_bsg_issue_read_mbox_ext_cmpl(struct lpfc_hba *phba, LPFC_MBOXQ_t *pmboxq)
 {
-	struct fc_bsg_job *job;
+	struct bsg_job *job;
+	struct fc_bsg_reply *reply;
 
 	/* handle the BSG job with mailbox command */
 	if (phba->mbox_ext_buf_ctx.state == LPFC_BSG_MBOX_ABTS)
@@ -3226,9 +3272,11 @@ lpfc_bsg_issue_read_mbox_ext_cmpl(struct lpfc_hba *phba, LPFC_MBOXQ_t *pmboxq)
 	mempool_free(pmboxq, phba->mbox_mem_pool);
 
 	/* complete the bsg job if we have it */
-	if (job)
-		job->job_done(job);
-
+	if (job) {
+		reply = job->reply;
+		bsg_job_done(job, reply->result,
+			     reply->reply_payload_rcv_len);
+	}
 	return;
 }
 
@@ -3243,7 +3291,8 @@ lpfc_bsg_issue_read_mbox_ext_cmpl(struct lpfc_hba *phba, LPFC_MBOXQ_t *pmboxq)
 static void
 lpfc_bsg_issue_write_mbox_ext_cmpl(struct lpfc_hba *phba, LPFC_MBOXQ_t *pmboxq)
 {
-	struct fc_bsg_job *job;
+	struct bsg_job *job;
+	struct fc_bsg_reply *reply;
 
 	/* handle the BSG job with the mailbox command */
 	if (phba->mbox_ext_buf_ctx.state == LPFC_BSG_MBOX_ABTS)
@@ -3261,9 +3310,11 @@ lpfc_bsg_issue_write_mbox_ext_cmpl(struct lpfc_hba *phba, LPFC_MBOXQ_t *pmboxq)
 	lpfc_bsg_mbox_ext_session_reset(phba);
 
 	/* complete the bsg job if we have it */
-	if (job)
-		job->job_done(job);
-
+	if (job) {
+		reply = job->reply;
+		bsg_job_done(job, reply->result,
+			     reply->reply_payload_rcv_len);
+	}
 	return;
 }
 
@@ -3371,10 +3422,11 @@ lpfc_bsg_sli_cfg_dma_desc_setup(struct lpfc_hba *phba, enum nemb_type nemb_tp,
  * non-embedded external bufffers.
  **/
 static int
-lpfc_bsg_sli_cfg_read_cmd_ext(struct lpfc_hba *phba, struct fc_bsg_job *job,
+lpfc_bsg_sli_cfg_read_cmd_ext(struct lpfc_hba *phba, struct bsg_job *job,
 			      enum nemb_type nemb_tp,
 			      struct lpfc_dmabuf *dmabuf)
 {
+	struct fc_bsg_request *req = job->request;
 	struct lpfc_sli_config_mbox *sli_cfg_mbx;
 	struct dfc_mbox_req *mbox_req;
 	struct lpfc_dmabuf *curr_dmabuf, *next_dmabuf;
@@ -3387,7 +3439,7 @@ lpfc_bsg_sli_cfg_read_cmd_ext(struct lpfc_hba *phba, struct fc_bsg_job *job,
 	int rc, i;
 
 	mbox_req =
-	   (struct dfc_mbox_req *)job->request->rqst_data.h_vendor.vendor_cmd;
+	   (struct dfc_mbox_req *)req->rqst_data.h_vendor.vendor_cmd;
 
 	/* pointer to the start of mailbox command */
 	sli_cfg_mbx = (struct lpfc_sli_config_mbox *)dmabuf->virt;
@@ -3538,10 +3590,11 @@ job_error:
  * non-embedded external bufffers.
  **/
 static int
-lpfc_bsg_sli_cfg_write_cmd_ext(struct lpfc_hba *phba, struct fc_bsg_job *job,
+lpfc_bsg_sli_cfg_write_cmd_ext(struct lpfc_hba *phba, struct bsg_job *job,
 			       enum nemb_type nemb_tp,
 			       struct lpfc_dmabuf *dmabuf)
 {
+	struct fc_bsg_request *req = job->request;
 	struct dfc_mbox_req *mbox_req;
 	struct lpfc_sli_config_mbox *sli_cfg_mbx;
 	uint32_t ext_buf_cnt;
@@ -3552,7 +3605,7 @@ lpfc_bsg_sli_cfg_write_cmd_ext(struct lpfc_hba *phba, struct fc_bsg_job *job,
 	int rc = 0, i;
 
 	mbox_req =
-	   (struct dfc_mbox_req *)job->request->rqst_data.h_vendor.vendor_cmd;
+	   (struct dfc_mbox_req *)req->rqst_data.h_vendor.vendor_cmd;
 
 	/* pointer to the start of mailbox command */
 	sli_cfg_mbx = (struct lpfc_sli_config_mbox *)dmabuf->virt;
@@ -3687,7 +3740,7 @@ job_error:
  * with embedded sussystem 0x1 and opcodes with external HBDs.
  **/
 static int
-lpfc_bsg_handle_sli_cfg_mbox(struct lpfc_hba *phba, struct fc_bsg_job *job,
+lpfc_bsg_handle_sli_cfg_mbox(struct lpfc_hba *phba, struct bsg_job *job,
 			     struct lpfc_dmabuf *dmabuf)
 {
 	struct lpfc_sli_config_mbox *sli_cfg_mbx;
@@ -3808,8 +3861,9 @@ lpfc_bsg_mbox_ext_abort(struct lpfc_hba *phba)
  * user space through BSG.
  **/
 static int
-lpfc_bsg_read_ebuf_get(struct lpfc_hba *phba, struct fc_bsg_job *job)
+lpfc_bsg_read_ebuf_get(struct lpfc_hba *phba, struct bsg_job *job)
 {
+	struct fc_bsg_reply *reply = job->reply;
 	struct lpfc_sli_config_mbox *sli_cfg_mbx;
 	struct lpfc_dmabuf *dmabuf;
 	uint8_t *pbuf;
@@ -3841,7 +3895,7 @@ lpfc_bsg_read_ebuf_get(struct lpfc_hba *phba, struct fc_bsg_job *job)
 				  struct lpfc_dmabuf, list);
 	list_del_init(&dmabuf->list);
 	pbuf = (uint8_t *)dmabuf->virt;
-	job->reply->reply_payload_rcv_len =
+	reply->reply_payload_rcv_len =
 		sg_copy_from_buffer(job->reply_payload.sg_list,
 				    job->reply_payload.sg_cnt,
 				    pbuf, size);
@@ -3855,8 +3909,8 @@ lpfc_bsg_read_ebuf_get(struct lpfc_hba *phba, struct fc_bsg_job *job)
 		lpfc_bsg_mbox_ext_session_reset(phba);
 	}
 
-	job->reply->result = 0;
-	job->job_done(job);
+	reply->result = 0;
+	bsg_job_done(job, 0, reply->reply_payload_rcv_len);
 
 	return SLI_CONFIG_HANDLED;
 }
@@ -3870,9 +3924,10 @@ lpfc_bsg_read_ebuf_get(struct lpfc_hba *phba, struct fc_bsg_job *job)
  * from user space through BSG.
  **/
 static int
-lpfc_bsg_write_ebuf_set(struct lpfc_hba *phba, struct fc_bsg_job *job,
+lpfc_bsg_write_ebuf_set(struct lpfc_hba *phba, struct bsg_job *job,
 			struct lpfc_dmabuf *dmabuf)
 {
+	struct fc_bsg_reply *reply = job->reply;
 	struct lpfc_sli_config_mbox *sli_cfg_mbx;
 	struct bsg_job_data *dd_data = NULL;
 	LPFC_MBOXQ_t *pmboxq = NULL;
@@ -3969,8 +4024,8 @@ lpfc_bsg_write_ebuf_set(struct lpfc_hba *phba, struct fc_bsg_job *job,
 	}
 
 	/* wait for additoinal external buffers */
-	job->reply->result = 0;
-	job->job_done(job);
+	reply->result = 0;
+	bsg_job_done(job, 0, 0);
 	return SLI_CONFIG_HANDLED;
 
 job_error:
@@ -3990,7 +4045,7 @@ job_error:
  * command with multiple non-embedded external buffers.
  **/
 static int
-lpfc_bsg_handle_sli_cfg_ebuf(struct lpfc_hba *phba, struct fc_bsg_job *job,
+lpfc_bsg_handle_sli_cfg_ebuf(struct lpfc_hba *phba, struct bsg_job *job,
 			     struct lpfc_dmabuf *dmabuf)
 {
 	int rc;
@@ -4035,14 +4090,14 @@ lpfc_bsg_handle_sli_cfg_ebuf(struct lpfc_hba *phba, struct fc_bsg_job *job,
  * (0x9B) mailbox commands and external buffers.
  **/
 static int
-lpfc_bsg_handle_sli_cfg_ext(struct lpfc_hba *phba, struct fc_bsg_job *job,
+lpfc_bsg_handle_sli_cfg_ext(struct lpfc_hba *phba, struct bsg_job *job,
 			    struct lpfc_dmabuf *dmabuf)
 {
+	struct fc_bsg_request *req = job->request;
 	struct dfc_mbox_req *mbox_req;
 	int rc;
 
-	mbox_req =
-	   (struct dfc_mbox_req *)job->request->rqst_data.h_vendor.vendor_cmd;
+	mbox_req = (struct dfc_mbox_req *)req->rqst_data.h_vendor.vendor_cmd;
 
 	/* mbox command with/without single external buffer */
 	if (mbox_req->extMboxTag == 0 && mbox_req->extSeqNum == 0)
@@ -4112,9 +4167,11 @@ sli_cfg_ext_error:
  * let our completion handler finish the command.
  **/
 static uint32_t
-lpfc_bsg_issue_mbox(struct lpfc_hba *phba, struct fc_bsg_job *job,
+lpfc_bsg_issue_mbox(struct lpfc_hba *phba, struct bsg_job *job,
 	struct lpfc_vport *vport)
 {
+	struct fc_bsg_reply *reply = job->reply;
+	struct fc_bsg_request *req = job->request;
 	LPFC_MBOXQ_t *pmboxq = NULL; /* internal mailbox queue */
 	MAILBOX_t *pmb; /* shortcut to the pmboxq mailbox */
 	/* a 4k buffer to hold the mb and extended data from/to the bsg */
@@ -4135,7 +4192,7 @@ lpfc_bsg_issue_mbox(struct lpfc_hba *phba, struct fc_bsg_job *job,
 
 
 	/* in case no data is transferred */
-	job->reply->reply_payload_rcv_len = 0;
+	reply->reply_payload_rcv_len = 0;
 
 	/* sanity check to protect driver */
 	if (job->reply_payload.payload_len > BSG_MBOX_SIZE ||
@@ -4153,8 +4210,7 @@ lpfc_bsg_issue_mbox(struct lpfc_hba *phba, struct fc_bsg_job *job,
 		goto job_done;
 	}
 
-	mbox_req =
-	    (struct dfc_mbox_req *)job->request->rqst_data.h_vendor.vendor_cmd;
+	mbox_req = (struct dfc_mbox_req *)req->rqst_data.h_vendor.vendor_cmd;
 
 	/* check if requested extended data lengths are valid */
 	if ((mbox_req->inExtWLen > BSG_MBOX_SIZE/sizeof(uint32_t)) ||
@@ -4374,7 +4430,7 @@ lpfc_bsg_issue_mbox(struct lpfc_hba *phba, struct fc_bsg_job *job,
 
 		/* job finished, copy the data */
 		memcpy(pmbx, pmb, sizeof(*pmb));
-		job->reply->reply_payload_rcv_len =
+		reply->reply_payload_rcv_len =
 			sg_copy_from_buffer(job->reply_payload.sg_list,
 					    job->reply_payload.sg_cnt,
 					    pmbx, size);
@@ -4403,15 +4459,18 @@ job_cont:
  * @job: MBOX fc_bsg_job for LPFC_BSG_VENDOR_MBOX.
  **/
 static int
-lpfc_bsg_mbox_cmd(struct fc_bsg_job *job)
+lpfc_bsg_mbox_cmd(struct bsg_job *job)
 {
-	struct lpfc_vport *vport = (struct lpfc_vport *)job->shost->hostdata;
+	struct fc_bsg_reply *reply = job->reply;
+	struct fc_bsg_request *req = job->request;
+	struct Scsi_Host *shost = fc_bsg_to_shost(job);
+	struct lpfc_vport *vport = (struct lpfc_vport *)shost->hostdata;
 	struct lpfc_hba *phba = vport->phba;
 	struct dfc_mbox_req *mbox_req;
 	int rc = 0;
 
 	/* mix-and-match backward compatibility */
-	job->reply->reply_payload_rcv_len = 0;
+	reply->reply_payload_rcv_len = 0;
 	if (job->request_len <
 	    sizeof(struct fc_bsg_request) + sizeof(struct dfc_mbox_req)) {
 		lpfc_printf_log(phba, KERN_INFO, LOG_LIBDFC,
@@ -4422,7 +4481,7 @@ lpfc_bsg_mbox_cmd(struct fc_bsg_job *job)
 				      sizeof(struct fc_bsg_request)),
 				(int)sizeof(struct dfc_mbox_req));
 		mbox_req = (struct dfc_mbox_req *)
-				job->request->rqst_data.h_vendor.vendor_cmd;
+				req->rqst_data.h_vendor.vendor_cmd;
 		mbox_req->extMboxTag = 0;
 		mbox_req->extSeqNum = 0;
 	}
@@ -4431,15 +4490,15 @@ lpfc_bsg_mbox_cmd(struct fc_bsg_job *job)
 
 	if (rc == 0) {
 		/* job done */
-		job->reply->result = 0;
+		reply->result = 0;
 		job->dd_data = NULL;
-		job->job_done(job);
+		bsg_job_done(job, 0, reply->reply_payload_rcv_len);
 	} else if (rc == 1)
 		/* job submitted, will complete later*/
 		rc = 0; /* return zero, no error */
 	else {
 		/* some error occurred */
-		job->reply->result = rc;
+		reply->result = rc;
 		job->dd_data = NULL;
 	}
 
@@ -4469,7 +4528,8 @@ lpfc_bsg_menlo_cmd_cmp(struct lpfc_hba *phba,
 			struct lpfc_iocbq *rspiocbq)
 {
 	struct bsg_job_data *dd_data;
-	struct fc_bsg_job *job;
+	struct bsg_job *job;
+	struct fc_bsg_reply *reply;
 	IOCB_t *rsp;
 	struct lpfc_dmabuf *bmp;
 	struct lpfc_bsg_menlo *menlo;
@@ -4486,6 +4546,7 @@ lpfc_bsg_menlo_cmd_cmp(struct lpfc_hba *phba,
 
 	menlo = &dd_data->context_un.menlo;
 	job = menlo->set_job;
+	reply = job->reply;
 	job->dd_data = NULL; /* so timeout handler does not reply */
 
 	spin_lock(&phba->hbalock);
@@ -4509,7 +4570,7 @@ lpfc_bsg_menlo_cmd_cmp(struct lpfc_hba *phba,
 	 * of the exchange.
 	 */
 	menlo_resp = (struct menlo_response *)
-		job->reply->reply_data.vendor_reply.vendor_rsp;
+		reply->reply_data.vendor_reply.vendor_rsp;
 	menlo_resp->xri = rsp->ulpContext;
 	if (rsp->ulpStatus) {
 		if (rsp->ulpStatus == IOSTAT_LOCAL_REJECT) {
@@ -4527,7 +4588,7 @@ lpfc_bsg_menlo_cmd_cmp(struct lpfc_hba *phba,
 		} else
 			rc = -EACCES;
 	} else
-		job->reply->reply_payload_rcv_len =
+		reply->reply_payload_rcv_len =
 			rsp->un.genreq64.bdl.bdeSize;
 
 	lpfc_mbuf_free(phba, bmp->virt, bmp->phys);
@@ -4536,16 +4597,16 @@ lpfc_bsg_menlo_cmd_cmp(struct lpfc_hba *phba,
 	kfree(bmp);
 	kfree(dd_data);
 	/* make error code available to userspace */
-	job->reply->result = rc;
+	reply->result = rc;
 	/* complete the job back to userspace */
-	job->job_done(job);
+	bsg_job_done(job, reply->result, reply->reply_payload_rcv_len);
 	spin_unlock_irqrestore(&phba->ct_ev_lock, flags);
 	return;
 }
 
 /**
  * lpfc_menlo_cmd - send an ioctl for menlo hardware
- * @job: fc_bsg_job to handle
+ * @job: bsg_job to handle
  *
  * This function issues a gen request 64 CR ioctl for all menlo cmd requests,
  * all the command completions will return the xri for the command.
@@ -4553,9 +4614,12 @@ lpfc_bsg_menlo_cmd_cmp(struct lpfc_hba *phba,
  * supplied in the menlo request header xri field.
  **/
 static int
-lpfc_menlo_cmd(struct fc_bsg_job *job)
+lpfc_menlo_cmd(struct bsg_job *job)
 {
-	struct lpfc_vport *vport = (struct lpfc_vport *)job->shost->hostdata;
+	struct fc_bsg_reply *reply = job->reply;
+	struct fc_bsg_request *req = job->request;
+	struct Scsi_Host *shost = fc_bsg_to_shost(job);
+	struct lpfc_vport *vport = (struct lpfc_vport *)shost->hostdata;
 	struct lpfc_hba *phba = vport->phba;
 	struct lpfc_iocbq *cmdiocbq, *rspiocbq;
 	IOCB_t *cmd, *rsp;
@@ -4572,7 +4636,7 @@ lpfc_menlo_cmd(struct fc_bsg_job *job)
 	struct ulp_bde64 *bpl = NULL;
 
 	/* in case no data is returned return just the return code */
-	job->reply->reply_payload_rcv_len = 0;
+	reply->reply_payload_rcv_len = 0;
 
 	if (job->request_len <
 	    sizeof(struct fc_bsg_request) +
@@ -4602,10 +4666,10 @@ lpfc_menlo_cmd(struct fc_bsg_job *job)
 	}
 
 	menlo_cmd = (struct menlo_command *)
-		job->request->rqst_data.h_vendor.vendor_cmd;
+		req->rqst_data.h_vendor.vendor_cmd;
 
 	menlo_resp = (struct menlo_response *)
-		job->reply->reply_data.vendor_reply.vendor_rsp;
+		reply->reply_data.vendor_reply.vendor_rsp;
 
 	/* allocate our bsg tracking structure */
 	dd_data = kmalloc(sizeof(struct bsg_job_data), GFP_KERNEL);
@@ -4733,19 +4797,21 @@ free_dd:
 	kfree(dd_data);
 no_dd_data:
 	/* make error code available to userspace */
-	job->reply->result = rc;
+	reply->result = rc;
 	job->dd_data = NULL;
 	return rc;
 }
 
 /**
  * lpfc_bsg_hst_vendor - process a vendor-specific fc_bsg_job
- * @job: fc_bsg_job to handle
+ * @job: bsg_job to handle
  **/
 static int
-lpfc_bsg_hst_vendor(struct fc_bsg_job *job)
+lpfc_bsg_hst_vendor(struct bsg_job *job)
 {
-	int command = job->request->rqst_data.h_vendor.vendor_cmd[0];
+	struct fc_bsg_reply *reply = job->reply;
+	struct fc_bsg_request *req = job->request;
+	int command = req->rqst_data.h_vendor.vendor_cmd[0];
 	int rc;
 
 	switch (command) {
@@ -4782,9 +4848,9 @@ lpfc_bsg_hst_vendor(struct fc_bsg_job *job)
 		break;
 	default:
 		rc = -EINVAL;
-		job->reply->reply_payload_rcv_len = 0;
+		reply->reply_payload_rcv_len = 0;
 		/* make error code available to userspace */
-		job->reply->result = rc;
+		reply->result = rc;
 		break;
 	}
 
@@ -4793,15 +4859,17 @@ lpfc_bsg_hst_vendor(struct fc_bsg_job *job)
 
 /**
  * lpfc_bsg_request - handle a bsg request from the FC transport
- * @job: fc_bsg_job to handle
+ * @job: bsg_job to handle
  **/
 int
-lpfc_bsg_request(struct fc_bsg_job *job)
+lpfc_bsg_request(struct bsg_job *job)
 {
+	struct fc_bsg_reply *reply = job->reply;
+	struct fc_bsg_request *req = job->request;
 	uint32_t msgcode;
 	int rc;
 
-	msgcode = job->request->msgcode;
+	msgcode = req->msgcode;
 	switch (msgcode) {
 	case FC_BSG_HST_VENDOR:
 		rc = lpfc_bsg_hst_vendor(job);
@@ -4814,9 +4882,9 @@ lpfc_bsg_request(struct fc_bsg_job *job)
 		break;
 	default:
 		rc = -EINVAL;
-		job->reply->reply_payload_rcv_len = 0;
+		reply->reply_payload_rcv_len = 0;
 		/* make error code available to userspace */
-		job->reply->result = rc;
+		reply->result = rc;
 		break;
 	}
 
@@ -4825,15 +4893,17 @@ lpfc_bsg_request(struct fc_bsg_job *job)
 
 /**
  * lpfc_bsg_timeout - handle timeout of a bsg request from the FC transport
- * @job: fc_bsg_job that has timed out
+ * @job: bsg_job that has timed out
  *
  * This function just aborts the job's IOCB.  The aborted IOCB will return to
  * the waiting function which will handle passing the error back to userspace
  **/
 int
-lpfc_bsg_timeout(struct fc_bsg_job *job)
+lpfc_bsg_timeout(struct bsg_job *job)
 {
-	struct lpfc_vport *vport = (struct lpfc_vport *)job->shost->hostdata;
+	struct fc_bsg_reply *reply = job->reply;
+	struct Scsi_Host *shost = fc_bsg_to_shost(job);
+	struct lpfc_vport *vport = (struct lpfc_vport *)shost->hostdata;
 	struct lpfc_hba *phba = vport->phba;
 	struct lpfc_iocbq *cmdiocb;
 	struct lpfc_bsg_event *evt;
@@ -4857,7 +4927,7 @@ lpfc_bsg_timeout(struct fc_bsg_job *job)
 		iocb = &dd_data->context_un.iocb;
 		cmdiocb = iocb->cmdiocbq;
 		/* hint to completion handler that the job timed out */
-		job->reply->result = -EAGAIN;
+		reply->result = -EAGAIN;
 		spin_unlock_irqrestore(&phba->ct_ev_lock, flags);
 		/* this will call our completion handler */
 		spin_lock_irq(&phba->hbalock);
@@ -4869,24 +4939,26 @@ lpfc_bsg_timeout(struct fc_bsg_job *job)
 		/* this event has no job anymore */
 		evt->set_job = NULL;
 		job->dd_data = NULL;
-		job->reply->reply_payload_rcv_len = 0;
+		reply->reply_payload_rcv_len = 0;
 		/* Return -EAGAIN which is our way of signallying the
 		 * app to retry.
 		 */
-		job->reply->result = -EAGAIN;
+		reply->result = -EAGAIN;
 		spin_unlock_irqrestore(&phba->ct_ev_lock, flags);
-		job->job_done(job);
+		bsg_job_done(job, reply->result,
+			      reply->reply_payload_rcv_len);
 		break;
 	case TYPE_MBOX:
 		mbox = &dd_data->context_un.mbox;
 		/* this mbox has no job anymore */
 		mbox->set_job = NULL;
 		job->dd_data = NULL;
-		job->reply->reply_payload_rcv_len = 0;
-		job->reply->result = -EAGAIN;
+		reply->reply_payload_rcv_len = 0;
+		reply->result = -EAGAIN;
 		/* the mbox completion handler can now be run */
 		spin_unlock_irqrestore(&phba->ct_ev_lock, flags);
-		job->job_done(job);
+		bsg_job_done(job, reply->result,
+			     reply->reply_payload_rcv_len);
 		if (phba->mbox_ext_buf_ctx.state == LPFC_BSG_MBOX_PORT)
 			phba->mbox_ext_buf_ctx.state = LPFC_BSG_MBOX_ABTS;
 		break;
@@ -4894,7 +4966,7 @@ lpfc_bsg_timeout(struct fc_bsg_job *job)
 		menlo = &dd_data->context_un.menlo;
 		cmdiocb = menlo->cmdiocbq;
 		/* hint to completion handler that the job timed out */
-		job->reply->result = -EAGAIN;
+		reply->result = -EAGAIN;
 		spin_unlock_irqrestore(&phba->ct_ev_lock, flags);
 		/* this will call our completion handler */
 		spin_lock_irq(&phba->hbalock);
diff --git a/drivers/scsi/lpfc/lpfc_crtn.h b/drivers/scsi/lpfc/lpfc_crtn.h
index fc20c24..202bbcd 100644
--- a/drivers/scsi/lpfc/lpfc_crtn.h
+++ b/drivers/scsi/lpfc/lpfc_crtn.h
@@ -415,8 +415,8 @@ struct lpfc_sglq *__lpfc_get_active_sglq(struct lpfc_hba *, uint16_t);
 #define HBA_EVENT_LINK_DOWN              3
 
 /* functions to support SGIOv4/bsg interface */
-int lpfc_bsg_request(struct fc_bsg_job *);
-int lpfc_bsg_timeout(struct fc_bsg_job *);
+int lpfc_bsg_request(struct bsg_job *);
+int lpfc_bsg_timeout(struct bsg_job *);
 int lpfc_bsg_ct_unsol_event(struct lpfc_hba *, struct lpfc_sli_ring *,
 			     struct lpfc_iocbq *);
 void __lpfc_sli_ringtx_put(struct lpfc_hba *, struct lpfc_sli_ring *,
-- 
1.7.2.3

