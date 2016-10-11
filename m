From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: [PATCH 05/44] lpfc: don't use fc_bsg_job::request and fc_bsg_job::reply directly
Date: Tue, 11 Oct 2016 13:28:36 +0200
Message-ID: <d59fc60dbbf5991fcd06d5f306cca354a9d7b444.1476180827.git.jthumshirn@suse.de>
References: <cover.1476180827.git.jthumshirn@suse.de>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <cover.1476180827.git.jthumshirn@suse.de>
In-Reply-To: <cover.1476180827.git.jthumshirn@suse.de>
References: <cover.1476180827.git.jthumshirn@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@infradead.org>, Hannes Reinecke <hare@suse.de>, Linux Kernel Mailinglist <linux-kernel@vger.kernel.org>, Linux SCSI Mailinglist <linux-scsi@vger.kernel.org>, Johannes Thumshirn <jthumshirn@suse.de>, James Smart <james.smart@avagotech.com>, Dick Kennedy <dick.kennedy@avagotech.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>
List-Id: linux-scsi@vger.kernel.org

Don't use fc_bsg_job::request and fc_bsg_job::reply directly, but use
helper variables bsg_request and bsg_reply. This will be helpfull when
transitioning to bsg-lib.

Signed-off-by: Johannes Thumshirn <jthumshirn@suse.de>
---
 drivers/scsi/lpfc/lpfc_bsg.c | 194 +++++++++++++++++++++++++++----------------
 1 file changed, 121 insertions(+), 73 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_bsg.c b/drivers/scsi/lpfc/lpfc_bsg.c
index 1002627..27b5930 100644
--- a/drivers/scsi/lpfc/lpfc_bsg.c
+++ b/drivers/scsi/lpfc/lpfc_bsg.c
@@ -299,6 +299,7 @@ lpfc_bsg_send_mgmt_cmd_cmp(struct lpfc_hba *phba,
 {
 	struct bsg_job_data *dd_data;
 	struct fc_bsg_job *job;
+	struct fc_bsg_reply *bsg_reply;
 	IOCB_t *rsp;
 	struct lpfc_dmabuf *bmp, *cmp, *rmp;
 	struct lpfc_nodelist *ndlp;
@@ -313,6 +314,7 @@ lpfc_bsg_send_mgmt_cmd_cmp(struct lpfc_hba *phba,
 	spin_lock_irqsave(&phba->ct_ev_lock, flags);
 	job = dd_data->set_job;
 	if (job) {
+		bsg_reply = job->reply;
 		/* Prevent timeout handling from trying to abort job */
 		job->dd_data = NULL;
 	}
@@ -351,7 +353,7 @@ lpfc_bsg_send_mgmt_cmd_cmp(struct lpfc_hba *phba,
 			}
 		} else {
 			rsp_size = rsp->un.genreq64.bdl.bdeSize;
-			job->reply->reply_payload_rcv_len =
+			bsg_reply->reply_payload_rcv_len =
 				lpfc_bsg_copy_data(rmp, &job->reply_payload,
 						   rsp_size, 0);
 		}
@@ -368,7 +370,7 @@ lpfc_bsg_send_mgmt_cmd_cmp(struct lpfc_hba *phba,
 	/* Complete the job if the job is still active */
 
 	if (job) {
-		job->reply->result = rc;
+		bsg_reply->result = rc;
 		job->job_done(job);
 	}
 	return;
@@ -385,6 +387,7 @@ lpfc_bsg_send_mgmt_cmd(struct fc_bsg_job *job)
 	struct lpfc_hba *phba = vport->phba;
 	struct lpfc_rport_data *rdata = job->rport->dd_data;
 	struct lpfc_nodelist *ndlp = rdata->pnode;
+	struct fc_bsg_reply *bsg_reply = job->reply;
 	struct ulp_bde64 *bpl = NULL;
 	uint32_t timeout;
 	struct lpfc_iocbq *cmdiocbq = NULL;
@@ -399,7 +402,7 @@ lpfc_bsg_send_mgmt_cmd(struct fc_bsg_job *job)
 	int iocb_stat;
 
 	/* in case no data is transferred */
-	job->reply->reply_payload_rcv_len = 0;
+	bsg_reply->reply_payload_rcv_len = 0;
 
 	/* allocate our bsg tracking structure */
 	dd_data = kmalloc(sizeof(struct bsg_job_data), GFP_KERNEL);
@@ -543,7 +546,7 @@ no_ndlp:
 	kfree(dd_data);
 no_dd_data:
 	/* make error code available to userspace */
-	job->reply->result = rc;
+	bsg_reply->result = rc;
 	job->dd_data = NULL;
 	return rc;
 }
@@ -572,6 +575,7 @@ lpfc_bsg_rport_els_cmp(struct lpfc_hba *phba,
 {
 	struct bsg_job_data *dd_data;
 	struct fc_bsg_job *job;
+	struct fc_bsg_reply *bsg_reply;
 	IOCB_t *rsp;
 	struct lpfc_nodelist *ndlp;
 	struct lpfc_dmabuf *pcmd = NULL, *prsp = NULL;
@@ -589,6 +593,7 @@ lpfc_bsg_rport_els_cmp(struct lpfc_hba *phba,
 	spin_lock_irqsave(&phba->ct_ev_lock, flags);
 	job = dd_data->set_job;
 	if (job) {
+		bsg_reply = job->reply;
 		/* Prevent timeout handling from trying to abort job  */
 		job->dd_data = NULL;
 	}
@@ -610,17 +615,17 @@ lpfc_bsg_rport_els_cmp(struct lpfc_hba *phba,
 	if (job) {
 		if (rsp->ulpStatus == IOSTAT_SUCCESS) {
 			rsp_size = rsp->un.elsreq64.bdl.bdeSize;
-			job->reply->reply_payload_rcv_len =
+			bsg_reply->reply_payload_rcv_len =
 				sg_copy_from_buffer(job->reply_payload.sg_list,
 						    job->reply_payload.sg_cnt,
 						    prsp->virt,
 						    rsp_size);
 		} else if (rsp->ulpStatus == IOSTAT_LS_RJT) {
-			job->reply->reply_payload_rcv_len =
+			bsg_reply->reply_payload_rcv_len =
 				sizeof(struct fc_bsg_ctels_reply);
 			/* LS_RJT data returned in word 4 */
 			rjt_data = (uint8_t *)&rsp->un.ulpWord[4];
-			els_reply = &job->reply->reply_data.ctels_reply;
+			els_reply = &bsg_reply->reply_data.ctels_reply;
 			els_reply->status = FC_CTELS_STATUS_REJECT;
 			els_reply->rjt_data.action = rjt_data[3];
 			els_reply->rjt_data.reason_code = rjt_data[2];
@@ -638,7 +643,7 @@ lpfc_bsg_rport_els_cmp(struct lpfc_hba *phba,
 	/* Complete the job if the job is still active */
 
 	if (job) {
-		job->reply->result = rc;
+		bsg_reply->result = rc;
 		job->job_done(job);
 	}
 	return;
@@ -655,6 +660,8 @@ lpfc_bsg_rport_els(struct fc_bsg_job *job)
 	struct lpfc_hba *phba = vport->phba;
 	struct lpfc_rport_data *rdata = job->rport->dd_data;
 	struct lpfc_nodelist *ndlp = rdata->pnode;
+	struct fc_bsg_request *bsg_request = job->request;
+	struct fc_bsg_reply *bsg_reply = job->reply;
 	uint32_t elscmd;
 	uint32_t cmdsize;
 	struct lpfc_iocbq *cmdiocbq;
@@ -665,7 +672,7 @@ lpfc_bsg_rport_els(struct fc_bsg_job *job)
 	int rc = 0;
 
 	/* in case no data is transferred */
-	job->reply->reply_payload_rcv_len = 0;
+	bsg_reply->reply_payload_rcv_len = 0;
 
 	/* verify the els command is not greater than the
 	 * maximum ELS transfer size.
@@ -685,7 +692,7 @@ lpfc_bsg_rport_els(struct fc_bsg_job *job)
 		goto no_dd_data;
 	}
 
-	elscmd = job->request->rqst_data.r_els.els_code;
+	elscmd = bsg_request->rqst_data.r_els.els_code;
 	cmdsize = job->request_payload.payload_len;
 
 	if (!lpfc_nlp_get(ndlp)) {
@@ -772,7 +779,7 @@ free_dd_data:
 
 no_dd_data:
 	/* make error code available to userspace */
-	job->reply->result = rc;
+	bsg_reply->result = rc;
 	job->dd_data = NULL;
 	return rc;
 }
@@ -919,6 +926,7 @@ lpfc_bsg_ct_unsol_event(struct lpfc_hba *phba, struct lpfc_sli_ring *pring,
 	struct lpfc_hbq_entry *hbqe;
 	struct lpfc_sli_ct_request *ct_req;
 	struct fc_bsg_job *job = NULL;
+	struct fc_bsg_reply *bsg_reply;
 	struct bsg_job_data *dd_data = NULL;
 	unsigned long flags;
 	int size = 0;
@@ -1121,9 +1129,10 @@ lpfc_bsg_ct_unsol_event(struct lpfc_hba *phba, struct lpfc_sli_ring *pring,
 		dd_data->set_job = NULL;
 		lpfc_bsg_event_unref(evt);
 		if (job) {
-			job->reply->reply_payload_rcv_len = size;
+			bsg_reply = job->reply;
+			bsg_reply->reply_payload_rcv_len = size;
 			/* make error code available to userspace */
-			job->reply->result = 0;
+			bsg_reply->result = 0;
 			job->dd_data = NULL;
 			/* complete the job back to userspace */
 			spin_unlock_irqrestore(&phba->ct_ev_lock, flags);
@@ -1192,6 +1201,7 @@ lpfc_bsg_hba_set_event(struct fc_bsg_job *job)
 {
 	struct lpfc_vport *vport = (struct lpfc_vport *)job->shost->hostdata;
 	struct lpfc_hba *phba = vport->phba;
+	struct fc_bsg_request *bsg_request = job->request;
 	struct set_ct_event *event_req;
 	struct lpfc_bsg_event *evt;
 	int rc = 0;
@@ -1209,7 +1219,7 @@ lpfc_bsg_hba_set_event(struct fc_bsg_job *job)
 	}
 
 	event_req = (struct set_ct_event *)
-		job->request->rqst_data.h_vendor.vendor_cmd;
+		bsg_request->rqst_data.h_vendor.vendor_cmd;
 	ev_mask = ((uint32_t)(unsigned long)event_req->type_mask &
 				FC_REG_EVENT_MASK);
 	spin_lock_irqsave(&phba->ct_ev_lock, flags);
@@ -1276,6 +1286,8 @@ lpfc_bsg_hba_get_event(struct fc_bsg_job *job)
 {
 	struct lpfc_vport *vport = (struct lpfc_vport *)job->shost->hostdata;
 	struct lpfc_hba *phba = vport->phba;
+	struct fc_bsg_request *bsg_request = job->request;
+	struct fc_bsg_reply *bsg_reply = job->reply;
 	struct get_ct_event *event_req;
 	struct get_ct_event_reply *event_reply;
 	struct lpfc_bsg_event *evt, *evt_next;
@@ -1293,10 +1305,10 @@ lpfc_bsg_hba_get_event(struct fc_bsg_job *job)
 	}
 
 	event_req = (struct get_ct_event *)
-		job->request->rqst_data.h_vendor.vendor_cmd;
+		bsg_request->rqst_data.h_vendor.vendor_cmd;
 
 	event_reply = (struct get_ct_event_reply *)
-		job->reply->reply_data.vendor_reply.vendor_rsp;
+		bsg_reply->reply_data.vendor_reply.vendor_rsp;
 	spin_lock_irqsave(&phba->ct_ev_lock, flags);
 	list_for_each_entry_safe(evt, evt_next, &phba->ct_ev_waiters, node) {
 		if (evt->reg_id == event_req->ev_reg_id) {
@@ -1316,7 +1328,7 @@ lpfc_bsg_hba_get_event(struct fc_bsg_job *job)
 	 * an error indicating that there isn't anymore
 	 */
 	if (evt_dat == NULL) {
-		job->reply->reply_payload_rcv_len = 0;
+		bsg_reply->reply_payload_rcv_len = 0;
 		rc = -ENOENT;
 		goto job_error;
 	}
@@ -1332,12 +1344,12 @@ lpfc_bsg_hba_get_event(struct fc_bsg_job *job)
 	event_reply->type = evt_dat->type;
 	event_reply->immed_data = evt_dat->immed_dat;
 	if (evt_dat->len > 0)
-		job->reply->reply_payload_rcv_len =
+		bsg_reply->reply_payload_rcv_len =
 			sg_copy_from_buffer(job->request_payload.sg_list,
 					    job->request_payload.sg_cnt,
 					    evt_dat->data, evt_dat->len);
 	else
-		job->reply->reply_payload_rcv_len = 0;
+		bsg_reply->reply_payload_rcv_len = 0;
 
 	if (evt_dat) {
 		kfree(evt_dat->data);
@@ -1348,13 +1360,13 @@ lpfc_bsg_hba_get_event(struct fc_bsg_job *job)
 	lpfc_bsg_event_unref(evt);
 	spin_unlock_irqrestore(&phba->ct_ev_lock, flags);
 	job->dd_data = NULL;
-	job->reply->result = 0;
+	bsg_reply->result = 0;
 	job->job_done(job);
 	return 0;
 
 job_error:
 	job->dd_data = NULL;
-	job->reply->result = rc;
+	bsg_reply->result = rc;
 	return rc;
 }
 
@@ -1382,6 +1394,7 @@ lpfc_issue_ct_rsp_cmp(struct lpfc_hba *phba,
 {
 	struct bsg_job_data *dd_data;
 	struct fc_bsg_job *job;
+	struct fc_bsg_reply *bsg_reply;
 	IOCB_t *rsp;
 	struct lpfc_dmabuf *bmp, *cmp;
 	struct lpfc_nodelist *ndlp;
@@ -1412,6 +1425,7 @@ lpfc_issue_ct_rsp_cmp(struct lpfc_hba *phba,
 	/* Copy the completed job data or set the error status */
 
 	if (job) {
+		bsg_reply = job->reply;
 		if (rsp->ulpStatus) {
 			if (rsp->ulpStatus == IOSTAT_LOCAL_REJECT) {
 				switch (rsp->un.ulpWord[4] & IOERR_PARAM_MASK) {
@@ -1429,7 +1443,7 @@ lpfc_issue_ct_rsp_cmp(struct lpfc_hba *phba,
 				rc = -EACCES;
 			}
 		} else {
-			job->reply->reply_payload_rcv_len = 0;
+			bsg_reply->reply_payload_rcv_len = 0;
 		}
 	}
 
@@ -1443,7 +1457,7 @@ lpfc_issue_ct_rsp_cmp(struct lpfc_hba *phba,
 	/* Complete the job if the job is still active */
 
 	if (job) {
-		job->reply->result = rc;
+		bsg_reply->result = rc;
 		job->job_done(job);
 	}
 	return;
@@ -1608,8 +1622,10 @@ lpfc_bsg_send_mgmt_rsp(struct fc_bsg_job *job)
 {
 	struct lpfc_vport *vport = (struct lpfc_vport *)job->shost->hostdata;
 	struct lpfc_hba *phba = vport->phba;
+	struct fc_bsg_request *bsg_request = job->request;
+	struct fc_bsg_reply *bsg_reply = job->reply;
 	struct send_mgmt_resp *mgmt_resp = (struct send_mgmt_resp *)
-		job->request->rqst_data.h_vendor.vendor_cmd;
+		bsg_request->rqst_data.h_vendor.vendor_cmd;
 	struct ulp_bde64 *bpl;
 	struct lpfc_dmabuf *bmp = NULL, *cmp = NULL;
 	int bpl_entries;
@@ -1619,7 +1635,7 @@ lpfc_bsg_send_mgmt_rsp(struct fc_bsg_job *job)
 	int rc = 0;
 
 	/* in case no data is transferred */
-	job->reply->reply_payload_rcv_len = 0;
+	bsg_reply->reply_payload_rcv_len = 0;
 
 	if (!reqbfrcnt || (reqbfrcnt > (80 * BUF_SZ_4K))) {
 		rc = -ERANGE;
@@ -1665,7 +1681,7 @@ send_mgmt_rsp_free_bmp:
 	kfree(bmp);
 send_mgmt_rsp_exit:
 	/* make error code available to userspace */
-	job->reply->result = rc;
+	bsg_reply->result = rc;
 	job->dd_data = NULL;
 	return rc;
 }
@@ -1763,6 +1779,8 @@ lpfc_bsg_diag_mode_exit(struct lpfc_hba *phba)
 static int
 lpfc_sli3_bsg_diag_loopback_mode(struct lpfc_hba *phba, struct fc_bsg_job *job)
 {
+	struct fc_bsg_request *bsg_request = job->request;
+	struct fc_bsg_reply *bsg_reply = job->reply;
 	struct diag_mode_set *loopback_mode;
 	uint32_t link_flags;
 	uint32_t timeout;
@@ -1772,7 +1790,7 @@ lpfc_sli3_bsg_diag_loopback_mode(struct lpfc_hba *phba, struct fc_bsg_job *job)
 	int rc = 0;
 
 	/* no data to return just the return code */
-	job->reply->reply_payload_rcv_len = 0;
+	bsg_reply->reply_payload_rcv_len = 0;
 
 	if (job->request_len < sizeof(struct fc_bsg_request) +
 	    sizeof(struct diag_mode_set)) {
@@ -1792,7 +1810,7 @@ lpfc_sli3_bsg_diag_loopback_mode(struct lpfc_hba *phba, struct fc_bsg_job *job)
 
 	/* bring the link to diagnostic mode */
 	loopback_mode = (struct diag_mode_set *)
-		job->request->rqst_data.h_vendor.vendor_cmd;
+		bsg_request->rqst_data.h_vendor.vendor_cmd;
 	link_flags = loopback_mode->type;
 	timeout = loopback_mode->timeout * 100;
 
@@ -1865,7 +1883,7 @@ loopback_mode_exit:
 
 job_error:
 	/* make error code available to userspace */
-	job->reply->result = rc;
+	bsg_reply->result = rc;
 	/* complete the job back to userspace if no error */
 	if (rc == 0)
 		job->job_done(job);
@@ -2018,12 +2036,14 @@ lpfc_sli4_diag_fcport_reg_setup(struct lpfc_hba *phba)
 static int
 lpfc_sli4_bsg_diag_loopback_mode(struct lpfc_hba *phba, struct fc_bsg_job *job)
 {
+	struct fc_bsg_request *bsg_request = job->request;
+	struct fc_bsg_reply *bsg_reply = job->reply;
 	struct diag_mode_set *loopback_mode;
 	uint32_t link_flags, timeout;
 	int i, rc = 0;
 
 	/* no data to return just the return code */
-	job->reply->reply_payload_rcv_len = 0;
+	bsg_reply->reply_payload_rcv_len = 0;
 
 	if (job->request_len < sizeof(struct fc_bsg_request) +
 	    sizeof(struct diag_mode_set)) {
@@ -2055,7 +2075,7 @@ lpfc_sli4_bsg_diag_loopback_mode(struct lpfc_hba *phba, struct fc_bsg_job *job)
 	lpfc_printf_log(phba, KERN_INFO, LOG_LIBDFC,
 			"3129 Bring link to diagnostic state.\n");
 	loopback_mode = (struct diag_mode_set *)
-		job->request->rqst_data.h_vendor.vendor_cmd;
+		bsg_request->rqst_data.h_vendor.vendor_cmd;
 	link_flags = loopback_mode->type;
 	timeout = loopback_mode->timeout * 100;
 
@@ -2152,7 +2172,7 @@ loopback_mode_exit:
 
 job_error:
 	/* make error code available to userspace */
-	job->reply->result = rc;
+	bsg_reply->result = rc;
 	/* complete the job back to userspace if no error */
 	if (rc == 0)
 		job->job_done(job);
@@ -2205,6 +2225,8 @@ lpfc_bsg_diag_loopback_mode(struct fc_bsg_job *job)
 static int
 lpfc_sli4_bsg_diag_mode_end(struct fc_bsg_job *job)
 {
+	struct fc_bsg_request *bsg_request = job->request;
+	struct fc_bsg_reply *bsg_reply = job->reply;
 	struct Scsi_Host *shost;
 	struct lpfc_vport *vport;
 	struct lpfc_hba *phba;
@@ -2233,7 +2255,7 @@ lpfc_sli4_bsg_diag_mode_end(struct fc_bsg_job *job)
 	phba->link_flag &= ~LS_LOOPBACK_MODE;
 	spin_unlock_irq(&phba->hbalock);
 	loopback_mode_end_cmd = (struct diag_mode_set *)
-			job->request->rqst_data.h_vendor.vendor_cmd;
+			bsg_request->rqst_data.h_vendor.vendor_cmd;
 	timeout = loopback_mode_end_cmd->timeout * 100;
 
 	rc = lpfc_sli4_bsg_set_link_diag_state(phba, 0);
@@ -2264,7 +2286,7 @@ lpfc_sli4_bsg_diag_mode_end(struct fc_bsg_job *job)
 
 loopback_mode_end_exit:
 	/* make return code available to userspace */
-	job->reply->result = rc;
+	bsg_reply->result = rc;
 	/* complete the job back to userspace if no error */
 	if (rc == 0)
 		job->job_done(job);
@@ -2281,6 +2303,8 @@ loopback_mode_end_exit:
 static int
 lpfc_sli4_bsg_link_diag_test(struct fc_bsg_job *job)
 {
+	struct fc_bsg_request *bsg_request = job->request;
+	struct fc_bsg_reply *bsg_reply = job->reply;
 	struct Scsi_Host *shost;
 	struct lpfc_vport *vport;
 	struct lpfc_hba *phba;
@@ -2336,7 +2360,7 @@ lpfc_sli4_bsg_link_diag_test(struct fc_bsg_job *job)
 		goto job_error;
 
 	link_diag_test_cmd = (struct sli4_link_diag *)
-			 job->request->rqst_data.h_vendor.vendor_cmd;
+			 bsg_request->rqst_data.h_vendor.vendor_cmd;
 
 	rc = lpfc_sli4_bsg_set_link_diag_state(phba, 1);
 
@@ -2386,7 +2410,7 @@ lpfc_sli4_bsg_link_diag_test(struct fc_bsg_job *job)
 	}
 
 	diag_status_reply = (struct diag_status *)
-			    job->reply->reply_data.vendor_reply.vendor_rsp;
+			    bsg_reply->reply_data.vendor_reply.vendor_rsp;
 
 	if (job->reply_len <
 	    sizeof(struct fc_bsg_request) + sizeof(struct diag_status)) {
@@ -2414,7 +2438,7 @@ link_diag_test_exit:
 
 job_error:
 	/* make error code available to userspace */
-	job->reply->result = rc;
+	bsg_reply->result = rc;
 	/* complete the job back to userspace if no error */
 	if (rc == 0)
 		job->job_done(job);
@@ -2986,6 +3010,7 @@ static int
 lpfc_bsg_diag_loopback_run(struct fc_bsg_job *job)
 {
 	struct lpfc_vport *vport = (struct lpfc_vport *)job->shost->hostdata;
+	struct fc_bsg_reply *bsg_reply = job->reply;
 	struct lpfc_hba *phba = vport->phba;
 	struct lpfc_bsg_event *evt;
 	struct event_data *evdat;
@@ -3013,7 +3038,7 @@ lpfc_bsg_diag_loopback_run(struct fc_bsg_job *job)
 	uint32_t total_mem;
 
 	/* in case no data is returned return just the return code */
-	job->reply->reply_payload_rcv_len = 0;
+	bsg_reply->reply_payload_rcv_len = 0;
 
 	if (job->request_len <
 	    sizeof(struct fc_bsg_request) + sizeof(struct diag_mode_test)) {
@@ -3238,11 +3263,11 @@ lpfc_bsg_diag_loopback_run(struct fc_bsg_job *job)
 			rc = IOCB_SUCCESS;
 			/* skip over elx loopback header */
 			rx_databuf += ELX_LOOPBACK_HEADER_SZ;
-			job->reply->reply_payload_rcv_len =
+			bsg_reply->reply_payload_rcv_len =
 				sg_copy_from_buffer(job->reply_payload.sg_list,
 						    job->reply_payload.sg_cnt,
 						    rx_databuf, size);
-			job->reply->reply_payload_rcv_len = size;
+			bsg_reply->reply_payload_rcv_len = size;
 		}
 	}
 
@@ -3272,7 +3297,7 @@ err_loopback_test_exit:
 loopback_test_exit:
 	kfree(dataout);
 	/* make error code available to userspace */
-	job->reply->result = rc;
+	bsg_reply->result = rc;
 	job->dd_data = NULL;
 	/* complete the job back to userspace if no error */
 	if (rc == IOCB_SUCCESS)
@@ -3288,6 +3313,7 @@ static int
 lpfc_bsg_get_dfc_rev(struct fc_bsg_job *job)
 {
 	struct lpfc_vport *vport = (struct lpfc_vport *)job->shost->hostdata;
+	struct fc_bsg_reply *bsg_reply = job->reply;
 	struct lpfc_hba *phba = vport->phba;
 	struct get_mgmt_rev_reply *event_reply;
 	int rc = 0;
@@ -3302,7 +3328,7 @@ lpfc_bsg_get_dfc_rev(struct fc_bsg_job *job)
 	}
 
 	event_reply = (struct get_mgmt_rev_reply *)
-		job->reply->reply_data.vendor_reply.vendor_rsp;
+		bsg_reply->reply_data.vendor_reply.vendor_rsp;
 
 	if (job->reply_len <
 	    sizeof(struct fc_bsg_request) + sizeof(struct get_mgmt_rev_reply)) {
@@ -3316,7 +3342,7 @@ lpfc_bsg_get_dfc_rev(struct fc_bsg_job *job)
 	event_reply->info.a_Major = MANAGEMENT_MAJOR_REV;
 	event_reply->info.a_Minor = MANAGEMENT_MINOR_REV;
 job_error:
-	job->reply->result = rc;
+	bsg_reply->result = rc;
 	if (rc == 0)
 		job->job_done(job);
 	return rc;
@@ -3337,6 +3363,7 @@ static void
 lpfc_bsg_issue_mbox_cmpl(struct lpfc_hba *phba, LPFC_MBOXQ_t *pmboxq)
 {
 	struct bsg_job_data *dd_data;
+	struct fc_bsg_reply *bsg_reply;
 	struct fc_bsg_job *job;
 	uint32_t size;
 	unsigned long flags;
@@ -3365,8 +3392,9 @@ lpfc_bsg_issue_mbox_cmpl(struct lpfc_hba *phba, LPFC_MBOXQ_t *pmboxq)
 	/* Copy the mailbox data to the job if it is still active */
 
 	if (job) {
+		bsg_reply = job->reply;
 		size = job->reply_payload.payload_len;
-		job->reply->reply_payload_rcv_len =
+		bsg_reply->reply_payload_rcv_len =
 			sg_copy_from_buffer(job->reply_payload.sg_list,
 					    job->reply_payload.sg_cnt,
 					    pmb_buf, size);
@@ -3380,7 +3408,7 @@ lpfc_bsg_issue_mbox_cmpl(struct lpfc_hba *phba, LPFC_MBOXQ_t *pmboxq)
 	/* Complete the job if the job is still active */
 
 	if (job) {
-		job->reply->result = 0;
+		bsg_reply->result = 0;
 		job->job_done(job);
 	}
 	return;
@@ -3516,6 +3544,7 @@ lpfc_bsg_issue_mbox_ext_handle_job(struct lpfc_hba *phba, LPFC_MBOXQ_t *pmboxq)
 {
 	struct bsg_job_data *dd_data;
 	struct fc_bsg_job *job;
+	struct fc_bsg_reply *bsg_reply;
 	uint8_t *pmb, *pmb_buf;
 	unsigned long flags;
 	uint32_t size;
@@ -3530,6 +3559,7 @@ lpfc_bsg_issue_mbox_ext_handle_job(struct lpfc_hba *phba, LPFC_MBOXQ_t *pmboxq)
 	spin_lock_irqsave(&phba->ct_ev_lock, flags);
 	job = dd_data->set_job;
 	if (job) {
+		bsg_reply = job->reply;
 		/* Prevent timeout handling from trying to abort job  */
 		job->dd_data = NULL;
 	}
@@ -3560,13 +3590,13 @@ lpfc_bsg_issue_mbox_ext_handle_job(struct lpfc_hba *phba, LPFC_MBOXQ_t *pmboxq)
 
 	if (job) {
 		size = job->reply_payload.payload_len;
-		job->reply->reply_payload_rcv_len =
+		bsg_reply->reply_payload_rcv_len =
 			sg_copy_from_buffer(job->reply_payload.sg_list,
 					    job->reply_payload.sg_cnt,
 					    pmb_buf, size);
 
 		/* result for successful */
-		job->reply->result = 0;
+		bsg_reply->result = 0;
 
 		lpfc_printf_log(phba, KERN_INFO, LOG_LIBDFC,
 				"2937 SLI_CONFIG ext-buffer maibox command "
@@ -3773,6 +3803,7 @@ lpfc_bsg_sli_cfg_read_cmd_ext(struct lpfc_hba *phba, struct fc_bsg_job *job,
 			      enum nemb_type nemb_tp,
 			      struct lpfc_dmabuf *dmabuf)
 {
+	struct fc_bsg_request *bsg_request = job->request;
 	struct lpfc_sli_config_mbox *sli_cfg_mbx;
 	struct dfc_mbox_req *mbox_req;
 	struct lpfc_dmabuf *curr_dmabuf, *next_dmabuf;
@@ -3785,7 +3816,7 @@ lpfc_bsg_sli_cfg_read_cmd_ext(struct lpfc_hba *phba, struct fc_bsg_job *job,
 	int rc, i;
 
 	mbox_req =
-	   (struct dfc_mbox_req *)job->request->rqst_data.h_vendor.vendor_cmd;
+	   (struct dfc_mbox_req *)bsg_request->rqst_data.h_vendor.vendor_cmd;
 
 	/* pointer to the start of mailbox command */
 	sli_cfg_mbx = (struct lpfc_sli_config_mbox *)dmabuf->virt;
@@ -3960,6 +3991,8 @@ lpfc_bsg_sli_cfg_write_cmd_ext(struct lpfc_hba *phba, struct fc_bsg_job *job,
 			       enum nemb_type nemb_tp,
 			       struct lpfc_dmabuf *dmabuf)
 {
+	struct fc_bsg_request *bsg_request = job->request;
+	struct fc_bsg_reply *bsg_reply = job->reply;
 	struct dfc_mbox_req *mbox_req;
 	struct lpfc_sli_config_mbox *sli_cfg_mbx;
 	uint32_t ext_buf_cnt;
@@ -3970,7 +4003,7 @@ lpfc_bsg_sli_cfg_write_cmd_ext(struct lpfc_hba *phba, struct fc_bsg_job *job,
 	int rc = SLI_CONFIG_NOT_HANDLED, i;
 
 	mbox_req =
-	   (struct dfc_mbox_req *)job->request->rqst_data.h_vendor.vendor_cmd;
+	   (struct dfc_mbox_req *)bsg_request->rqst_data.h_vendor.vendor_cmd;
 
 	/* pointer to the start of mailbox command */
 	sli_cfg_mbx = (struct lpfc_sli_config_mbox *)dmabuf->virt;
@@ -4097,7 +4130,7 @@ lpfc_bsg_sli_cfg_write_cmd_ext(struct lpfc_hba *phba, struct fc_bsg_job *job,
 
 	/* wait for additoinal external buffers */
 
-	job->reply->result = 0;
+	bsg_reply->result = 0;
 	job->job_done(job);
 	return SLI_CONFIG_HANDLED;
 
@@ -4271,6 +4304,7 @@ lpfc_bsg_mbox_ext_abort(struct lpfc_hba *phba)
 static int
 lpfc_bsg_read_ebuf_get(struct lpfc_hba *phba, struct fc_bsg_job *job)
 {
+	struct fc_bsg_reply *bsg_reply = job->reply;
 	struct lpfc_sli_config_mbox *sli_cfg_mbx;
 	struct lpfc_dmabuf *dmabuf;
 	uint8_t *pbuf;
@@ -4308,7 +4342,7 @@ lpfc_bsg_read_ebuf_get(struct lpfc_hba *phba, struct fc_bsg_job *job)
 					dmabuf, index);
 
 	pbuf = (uint8_t *)dmabuf->virt;
-	job->reply->reply_payload_rcv_len =
+	bsg_reply->reply_payload_rcv_len =
 		sg_copy_from_buffer(job->reply_payload.sg_list,
 				    job->reply_payload.sg_cnt,
 				    pbuf, size);
@@ -4322,7 +4356,7 @@ lpfc_bsg_read_ebuf_get(struct lpfc_hba *phba, struct fc_bsg_job *job)
 		lpfc_bsg_mbox_ext_session_reset(phba);
 	}
 
-	job->reply->result = 0;
+	bsg_reply->result = 0;
 	job->job_done(job);
 
 	return SLI_CONFIG_HANDLED;
@@ -4340,6 +4374,7 @@ static int
 lpfc_bsg_write_ebuf_set(struct lpfc_hba *phba, struct fc_bsg_job *job,
 			struct lpfc_dmabuf *dmabuf)
 {
+	struct fc_bsg_reply *bsg_reply = job->reply;
 	struct bsg_job_data *dd_data = NULL;
 	LPFC_MBOXQ_t *pmboxq = NULL;
 	MAILBOX_t *pmb;
@@ -4437,7 +4472,7 @@ lpfc_bsg_write_ebuf_set(struct lpfc_hba *phba, struct fc_bsg_job *job,
 	}
 
 	/* wait for additoinal external buffers */
-	job->reply->result = 0;
+	bsg_reply->result = 0;
 	job->job_done(job);
 	return SLI_CONFIG_HANDLED;
 
@@ -4506,11 +4541,12 @@ static int
 lpfc_bsg_handle_sli_cfg_ext(struct lpfc_hba *phba, struct fc_bsg_job *job,
 			    struct lpfc_dmabuf *dmabuf)
 {
+	struct fc_bsg_request *bsg_request = job->request;
 	struct dfc_mbox_req *mbox_req;
 	int rc = SLI_CONFIG_NOT_HANDLED;
 
 	mbox_req =
-	   (struct dfc_mbox_req *)job->request->rqst_data.h_vendor.vendor_cmd;
+	   (struct dfc_mbox_req *)bsg_request->rqst_data.h_vendor.vendor_cmd;
 
 	/* mbox command with/without single external buffer */
 	if (mbox_req->extMboxTag == 0 && mbox_req->extSeqNum == 0)
@@ -4583,6 +4619,8 @@ static int
 lpfc_bsg_issue_mbox(struct lpfc_hba *phba, struct fc_bsg_job *job,
 	struct lpfc_vport *vport)
 {
+	struct fc_bsg_request *bsg_request = job->request;
+	struct fc_bsg_reply *bsg_reply = job->reply;
 	LPFC_MBOXQ_t *pmboxq = NULL; /* internal mailbox queue */
 	MAILBOX_t *pmb; /* shortcut to the pmboxq mailbox */
 	/* a 4k buffer to hold the mb and extended data from/to the bsg */
@@ -4601,7 +4639,7 @@ lpfc_bsg_issue_mbox(struct lpfc_hba *phba, struct fc_bsg_job *job,
 	uint32_t size;
 
 	/* in case no data is transferred */
-	job->reply->reply_payload_rcv_len = 0;
+	bsg_reply->reply_payload_rcv_len = 0;
 
 	/* sanity check to protect driver */
 	if (job->reply_payload.payload_len > BSG_MBOX_SIZE ||
@@ -4620,7 +4658,7 @@ lpfc_bsg_issue_mbox(struct lpfc_hba *phba, struct fc_bsg_job *job,
 	}
 
 	mbox_req =
-	    (struct dfc_mbox_req *)job->request->rqst_data.h_vendor.vendor_cmd;
+	    (struct dfc_mbox_req *)bsg_request->rqst_data.h_vendor.vendor_cmd;
 
 	/* check if requested extended data lengths are valid */
 	if ((mbox_req->inExtWLen > BSG_MBOX_SIZE/sizeof(uint32_t)) ||
@@ -4842,7 +4880,7 @@ lpfc_bsg_issue_mbox(struct lpfc_hba *phba, struct fc_bsg_job *job,
 
 		/* job finished, copy the data */
 		memcpy(pmbx, pmb, sizeof(*pmb));
-		job->reply->reply_payload_rcv_len =
+		bsg_reply->reply_payload_rcv_len =
 			sg_copy_from_buffer(job->reply_payload.sg_list,
 					    job->reply_payload.sg_cnt,
 					    pmbx, size);
@@ -4874,12 +4912,14 @@ static int
 lpfc_bsg_mbox_cmd(struct fc_bsg_job *job)
 {
 	struct lpfc_vport *vport = (struct lpfc_vport *)job->shost->hostdata;
+	struct fc_bsg_request *bsg_request = job->request;
+	struct fc_bsg_reply *bsg_reply = job->reply;
 	struct lpfc_hba *phba = vport->phba;
 	struct dfc_mbox_req *mbox_req;
 	int rc = 0;
 
 	/* mix-and-match backward compatibility */
-	job->reply->reply_payload_rcv_len = 0;
+	bsg_reply->reply_payload_rcv_len = 0;
 	if (job->request_len <
 	    sizeof(struct fc_bsg_request) + sizeof(struct dfc_mbox_req)) {
 		lpfc_printf_log(phba, KERN_INFO, LOG_LIBDFC,
@@ -4890,7 +4930,7 @@ lpfc_bsg_mbox_cmd(struct fc_bsg_job *job)
 				      sizeof(struct fc_bsg_request)),
 				(int)sizeof(struct dfc_mbox_req));
 		mbox_req = (struct dfc_mbox_req *)
-				job->request->rqst_data.h_vendor.vendor_cmd;
+				bsg_request->rqst_data.h_vendor.vendor_cmd;
 		mbox_req->extMboxTag = 0;
 		mbox_req->extSeqNum = 0;
 	}
@@ -4899,7 +4939,7 @@ lpfc_bsg_mbox_cmd(struct fc_bsg_job *job)
 
 	if (rc == 0) {
 		/* job done */
-		job->reply->result = 0;
+		bsg_reply->result = 0;
 		job->dd_data = NULL;
 		job->job_done(job);
 	} else if (rc == 1)
@@ -4907,7 +4947,7 @@ lpfc_bsg_mbox_cmd(struct fc_bsg_job *job)
 		rc = 0; /* return zero, no error */
 	else {
 		/* some error occurred */
-		job->reply->result = rc;
+		bsg_reply->result = rc;
 		job->dd_data = NULL;
 	}
 
@@ -4938,6 +4978,7 @@ lpfc_bsg_menlo_cmd_cmp(struct lpfc_hba *phba,
 {
 	struct bsg_job_data *dd_data;
 	struct fc_bsg_job *job;
+	struct fc_bsg_reply *bsg_reply;
 	IOCB_t *rsp;
 	struct lpfc_dmabuf *bmp, *cmp, *rmp;
 	struct lpfc_bsg_menlo *menlo;
@@ -4957,6 +4998,7 @@ lpfc_bsg_menlo_cmd_cmp(struct lpfc_hba *phba,
 	spin_lock_irqsave(&phba->ct_ev_lock, flags);
 	job = dd_data->set_job;
 	if (job) {
+		bsg_reply = job->reply;
 		/* Prevent timeout handling from trying to abort job  */
 		job->dd_data = NULL;
 	}
@@ -4971,7 +5013,7 @@ lpfc_bsg_menlo_cmd_cmp(struct lpfc_hba *phba,
 		 */
 
 		menlo_resp = (struct menlo_response *)
-			job->reply->reply_data.vendor_reply.vendor_rsp;
+			bsg_reply->reply_data.vendor_reply.vendor_rsp;
 		menlo_resp->xri = rsp->ulpContext;
 		if (rsp->ulpStatus) {
 			if (rsp->ulpStatus == IOSTAT_LOCAL_REJECT) {
@@ -4991,7 +5033,7 @@ lpfc_bsg_menlo_cmd_cmp(struct lpfc_hba *phba,
 			}
 		} else {
 			rsp_size = rsp->un.genreq64.bdl.bdeSize;
-			job->reply->reply_payload_rcv_len =
+			bsg_reply->reply_payload_rcv_len =
 				lpfc_bsg_copy_data(rmp, &job->reply_payload,
 						   rsp_size, 0);
 		}
@@ -5008,7 +5050,7 @@ lpfc_bsg_menlo_cmd_cmp(struct lpfc_hba *phba,
 	/* Complete the job if active */
 
 	if (job) {
-		job->reply->result = rc;
+		bsg_reply->result = rc;
 		job->job_done(job);
 	}
 
@@ -5028,6 +5070,8 @@ static int
 lpfc_menlo_cmd(struct fc_bsg_job *job)
 {
 	struct lpfc_vport *vport = (struct lpfc_vport *)job->shost->hostdata;
+	struct fc_bsg_request *bsg_request = job->request;
+	struct fc_bsg_reply *bsg_reply = job->reply;
 	struct lpfc_hba *phba = vport->phba;
 	struct lpfc_iocbq *cmdiocbq;
 	IOCB_t *cmd;
@@ -5040,7 +5084,7 @@ lpfc_menlo_cmd(struct fc_bsg_job *job)
 	struct ulp_bde64 *bpl = NULL;
 
 	/* in case no data is returned return just the return code */
-	job->reply->reply_payload_rcv_len = 0;
+	bsg_reply->reply_payload_rcv_len = 0;
 
 	if (job->request_len <
 	    sizeof(struct fc_bsg_request) +
@@ -5070,7 +5114,7 @@ lpfc_menlo_cmd(struct fc_bsg_job *job)
 	}
 
 	menlo_cmd = (struct menlo_command *)
-		job->request->rqst_data.h_vendor.vendor_cmd;
+		bsg_request->rqst_data.h_vendor.vendor_cmd;
 
 	/* allocate our bsg tracking structure */
 	dd_data = kmalloc(sizeof(struct bsg_job_data), GFP_KERNEL);
@@ -5181,7 +5225,7 @@ free_dd:
 	kfree(dd_data);
 no_dd_data:
 	/* make error code available to userspace */
-	job->reply->result = rc;
+	bsg_reply->result = rc;
 	job->dd_data = NULL;
 	return rc;
 }
@@ -5193,7 +5237,9 @@ no_dd_data:
 static int
 lpfc_bsg_hst_vendor(struct fc_bsg_job *job)
 {
-	int command = job->request->rqst_data.h_vendor.vendor_cmd[0];
+	struct fc_bsg_request *bsg_request = job->request;
+	struct fc_bsg_reply *bsg_reply = job->reply;
+	int command = bsg_request->rqst_data.h_vendor.vendor_cmd[0];
 	int rc;
 
 	switch (command) {
@@ -5230,9 +5276,9 @@ lpfc_bsg_hst_vendor(struct fc_bsg_job *job)
 		break;
 	default:
 		rc = -EINVAL;
-		job->reply->reply_payload_rcv_len = 0;
+		bsg_reply->reply_payload_rcv_len = 0;
 		/* make error code available to userspace */
-		job->reply->result = rc;
+		bsg_reply->result = rc;
 		break;
 	}
 
@@ -5246,10 +5292,12 @@ lpfc_bsg_hst_vendor(struct fc_bsg_job *job)
 int
 lpfc_bsg_request(struct fc_bsg_job *job)
 {
+	struct fc_bsg_request *bsg_request = job->request;
+	struct fc_bsg_reply *bsg_reply = job->reply;
 	uint32_t msgcode;
 	int rc;
 
-	msgcode = job->request->msgcode;
+	msgcode = bsg_request->msgcode;
 	switch (msgcode) {
 	case FC_BSG_HST_VENDOR:
 		rc = lpfc_bsg_hst_vendor(job);
@@ -5262,9 +5310,9 @@ lpfc_bsg_request(struct fc_bsg_job *job)
 		break;
 	default:
 		rc = -EINVAL;
-		job->reply->reply_payload_rcv_len = 0;
+		bsg_reply->reply_payload_rcv_len = 0;
 		/* make error code available to userspace */
-		job->reply->result = rc;
+		bsg_reply->result = rc;
 		break;
 	}
 
-- 
1.8.5.6
