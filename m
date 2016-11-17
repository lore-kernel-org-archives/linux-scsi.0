From: Johannes Thumshirn <jthumshirn-l3A5Bk7waGM@public.gmane.org>
Subject: [PATCH v4 02/15] scsi: don't use fc_bsg_job::request
	and fc_bsg_job::reply directly
Date: Thu, 17 Nov 2016 10:31:12 +0100
Message-ID: <70cda0c20ecedf82323ff96e62ed6250a4cb575d.1479374719.git.jthumshirn@suse.de>
References: <cover.1479374719.git.jthumshirn@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <fcoe-devel-bounces-s9riP+hp16TNLxjTenLetw@public.gmane.org>
In-Reply-To: <cover.1479374719.git.jthumshirn-l3A5Bk7waGM@public.gmane.org>
In-Reply-To: <cover.1479374719.git.jthumshirn-l3A5Bk7waGM@public.gmane.org>
References: <cover.1479374719.git.jthumshirn-l3A5Bk7waGM@public.gmane.org>
List-Unsubscribe: <http://lists.open-fcoe.org/mailman/options/fcoe-devel>,
 <mailto:fcoe-devel-request-s9riP+hp16TNLxjTenLetw@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.open-fcoe.org/pipermail/fcoe-devel/>
List-Post: <mailto:fcoe-devel-s9riP+hp16TNLxjTenLetw@public.gmane.org>
List-Help: <mailto:fcoe-devel-request-s9riP+hp16TNLxjTenLetw@public.gmane.org?subject=help>
List-Subscribe: <http://lists.open-fcoe.org/mailman/listinfo/fcoe-devel>,
 <mailto:fcoe-devel-request-s9riP+hp16TNLxjTenLetw@public.gmane.org?subject=subscribe>
Errors-To: fcoe-devel-bounces-s9riP+hp16TNLxjTenLetw@public.gmane.org
Sender: "fcoe-devel" <fcoe-devel-bounces-s9riP+hp16TNLxjTenLetw@public.gmane.org>
To: James Bottomley <jejb-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, "Martin K . Petersen" <martin.petersen-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: "open list:S390 ZFCP DRIVER" <linux-s390-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Benjamin Herrenschmidt <benh-XVmvHMARGAS8U2dJNN8I7kB+6BGkLq7r@public.gmane.org>, "open list:BROCADE BFA FC SCSI DRIVER" <linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Sudarsana Kalluru <sudarsana.kalluru-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>, "open list:FCOE SUBSYSTEM libfc, libfcoe, fcoe" <fcoe-devel-s9riP+hp16TNLxjTenLetw@public.gmane.org>, Michael Ellerman <mpe-Gsx/Oe8HsFggBc27wqDAHg@public.gmane.org>, Anil Gurumurthy <anil.gurumurthy-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>, "supporter:QLOGIC QLA2XXX FC-SCSI DRIVER" <qla2xxx-upstream-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>, Heiko Carstens <heiko.carstens-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org>, James Smart <james.smart-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>, open list <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Martin Schwidefsky <schwidefsky-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org>, Paul Mackerras <paulus-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>, Steffen Maier <maier-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, Dick Kennedy <dick.kennedy-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>, Johannes Thumshirn <jth-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>"open list:LINUX FOR POWERPC 32-BIT AND 64-BIT" <li>
List-Id: linux-scsi@vger.kernel.org

Don't use fc_bsg_job::request and fc_bsg_job::reply directly, but use
helper variables bsg_request and bsg_reply. This will be helpfull  when
transitioning to bsg-lib.

Signed-off-by: Johannes Thumshirn <jthumshirn-l3A5Bk7waGM@public.gmane.org>
Reviewed-by: Hannes Reinecke <hare-IBi9RG/b67k@public.gmane.org>
---
 drivers/s390/scsi/zfcp_fc.c      |   9 +-
 drivers/scsi/bfa/bfad_bsg.c      |  40 +++---
 drivers/scsi/ibmvscsi/ibmvfc.c   |  22 ++--
 drivers/scsi/libfc/fc_lport.c    |  23 ++--
 drivers/scsi/lpfc/lpfc_bsg.c     | 199 ++++++++++++++++++-----------
 drivers/scsi/qla2xxx/qla_bsg.c   | 264 ++++++++++++++++++++++-----------------
 drivers/scsi/qla2xxx/qla_iocb.c  |   5 +-
 drivers/scsi/qla2xxx/qla_isr.c   |  46 ++++---
 drivers/scsi/qla2xxx/qla_mr.c    |  10 +-
 drivers/scsi/scsi_transport_fc.c |  55 ++++----
 10 files changed, 398 insertions(+), 275 deletions(-)

diff --git a/drivers/s390/scsi/zfcp_fc.c b/drivers/s390/scsi/zfcp_fc.c
index 237688a..4c4023f 100644
--- a/drivers/s390/scsi/zfcp_fc.c
+++ b/drivers/s390/scsi/zfcp_fc.c
@@ -900,8 +900,9 @@ static struct zfcp_fc_wka_port *zfcp_fc_job_wka_port(struct fc_bsg_job *job)
 	u32 preamble_word1;
 	u8 gs_type;
 	struct zfcp_adapter *adapter;
+	struct fc_bsg_request *bsg_request = job->request;
 
-	preamble_word1 = job->request->rqst_data.r_ct.preamble_word1;
+	preamble_word1 = bsg_request->rqst_data.r_ct.preamble_word1;
 	gs_type = (preamble_word1 & 0xff000000) >> 24;
 
 	adapter = (struct zfcp_adapter *) job->shost->hostdata[0];
@@ -938,6 +939,7 @@ static int zfcp_fc_exec_els_job(struct fc_bsg_job *job,
 {
 	struct zfcp_fsf_ct_els *els = job->dd_data;
 	struct fc_rport *rport = job->rport;
+	struct fc_bsg_request *bsg_request = job->request;
 	struct zfcp_port *port;
 	u32 d_id;
 
@@ -949,7 +951,7 @@ static int zfcp_fc_exec_els_job(struct fc_bsg_job *job,
 		d_id = port->d_id;
 		put_device(&port->dev);
 	} else
-		d_id = ntoh24(job->request->rqst_data.h_els.port_id);
+		d_id = ntoh24(bsg_request->rqst_data.h_els.port_id);
 
 	els->handler = zfcp_fc_ct_els_job_handler;
 	return zfcp_fsf_send_els(adapter, d_id, els, job->req->timeout / HZ);
@@ -983,6 +985,7 @@ int zfcp_fc_exec_bsg_job(struct fc_bsg_job *job)
 	struct Scsi_Host *shost;
 	struct zfcp_adapter *adapter;
 	struct zfcp_fsf_ct_els *ct_els = job->dd_data;
+	struct fc_bsg_request *bsg_request = job->request;
 
 	shost = job->rport ? rport_to_shost(job->rport) : job->shost;
 	adapter = (struct zfcp_adapter *)shost->hostdata[0];
@@ -994,7 +997,7 @@ int zfcp_fc_exec_bsg_job(struct fc_bsg_job *job)
 	ct_els->resp = job->reply_payload.sg_list;
 	ct_els->handler_data = job;
 
-	switch (job->request->msgcode) {
+	switch (bsg_request->msgcode) {
 	case FC_BSG_RPT_ELS:
 	case FC_BSG_HST_ELS_NOLOGIN:
 		return zfcp_fc_exec_els_job(job, adapter);
diff --git a/drivers/scsi/bfa/bfad_bsg.c b/drivers/scsi/bfa/bfad_bsg.c
index d1ad020..48366d8 100644
--- a/drivers/scsi/bfa/bfad_bsg.c
+++ b/drivers/scsi/bfa/bfad_bsg.c
@@ -3132,7 +3132,9 @@
 static int
 bfad_im_bsg_vendor_request(struct fc_bsg_job *job)
 {
-	uint32_t vendor_cmd = job->request->rqst_data.h_vendor.vendor_cmd[0];
+	struct fc_bsg_request *bsg_request = job->request;
+	struct fc_bsg_reply *bsg_reply = job->reply;
+	uint32_t vendor_cmd = bsg_request->rqst_data.h_vendor.vendor_cmd[0];
 	struct bfad_im_port_s *im_port =
 			(struct bfad_im_port_s *) job->shost->hostdata[0];
 	struct bfad_s *bfad = im_port->bfad;
@@ -3175,8 +3177,8 @@
 
 	/* Fill the BSG job reply data */
 	job->reply_len = job->reply_payload.payload_len;
-	job->reply->reply_payload_rcv_len = job->reply_payload.payload_len;
-	job->reply->result = rc;
+	bsg_reply->reply_payload_rcv_len = job->reply_payload.payload_len;
+	bsg_reply->result = rc;
 
 	job->job_done(job);
 	return rc;
@@ -3184,9 +3186,9 @@
 	/* free the command buffer */
 	kfree(payload_kbuf);
 out:
-	job->reply->result = rc;
+	bsg_reply->result = rc;
 	job->reply_len = sizeof(uint32_t);
-	job->reply->reply_payload_rcv_len = 0;
+	bsg_reply->reply_payload_rcv_len = 0;
 	return rc;
 }
 
@@ -3362,18 +3364,20 @@ struct bfad_buf_info *
 	struct bfad_fcxp    *drv_fcxp;
 	struct bfa_fcs_lport_s *fcs_port;
 	struct bfa_fcs_rport_s *fcs_rport;
-	uint32_t command_type = job->request->msgcode;
+	struct fc_bsg_request *bsg_request = bsg_request;
+	struct fc_bsg_reply *bsg_reply = job->reply;
+	uint32_t command_type = bsg_request->msgcode;
 	unsigned long flags;
 	struct bfad_buf_info *rsp_buf_info;
 	void *req_kbuf = NULL, *rsp_kbuf = NULL;
 	int rc = -EINVAL;
 
 	job->reply_len  = sizeof(uint32_t);	/* Atleast uint32_t reply_len */
-	job->reply->reply_payload_rcv_len = 0;
+	bsg_reply->reply_payload_rcv_len = 0;
 
 	/* Get the payload passed in from userspace */
-	bsg_data = (struct bfa_bsg_data *) (((char *)job->request) +
-					sizeof(struct fc_bsg_request));
+	bsg_data = (struct bfa_bsg_data *) (((char *)bsg_request) +
+					    sizeof(struct fc_bsg_request));
 	if (bsg_data == NULL)
 		goto out;
 
@@ -3517,13 +3521,13 @@ struct bfad_buf_info *
 	/* fill the job->reply data */
 	if (drv_fcxp->req_status == BFA_STATUS_OK) {
 		job->reply_len = drv_fcxp->rsp_len;
-		job->reply->reply_payload_rcv_len = drv_fcxp->rsp_len;
-		job->reply->reply_data.ctels_reply.status = FC_CTELS_STATUS_OK;
+		bsg_reply->reply_payload_rcv_len = drv_fcxp->rsp_len;
+		bsg_reply->reply_data.ctels_reply.status = FC_CTELS_STATUS_OK;
 	} else {
-		job->reply->reply_payload_rcv_len =
+		bsg_reply->reply_payload_rcv_len =
 					sizeof(struct fc_bsg_ctels_reply);
 		job->reply_len = sizeof(uint32_t);
-		job->reply->reply_data.ctels_reply.status =
+		bsg_reply->reply_data.ctels_reply.status =
 						FC_CTELS_STATUS_REJECT;
 	}
 
@@ -3549,7 +3553,7 @@ struct bfad_buf_info *
 	kfree(bsg_fcpt);
 	kfree(drv_fcxp);
 out:
-	job->reply->result = rc;
+	bsg_reply->result = rc;
 
 	if (rc == BFA_STATUS_OK)
 		job->job_done(job);
@@ -3560,9 +3564,11 @@ struct bfad_buf_info *
 int
 bfad_im_bsg_request(struct fc_bsg_job *job)
 {
+	struct fc_bsg_request *bsg_request = job->request;
+	struct fc_bsg_reply *bsg_reply = job->reply;
 	uint32_t rc = BFA_STATUS_OK;
 
-	switch (job->request->msgcode) {
+	switch (bsg_request->msgcode) {
 	case FC_BSG_HST_VENDOR:
 		/* Process BSG HST Vendor requests */
 		rc = bfad_im_bsg_vendor_request(job);
@@ -3575,8 +3581,8 @@ struct bfad_buf_info *
 		rc = bfad_im_bsg_els_ct_request(job);
 		break;
 	default:
-		job->reply->result = rc = -EINVAL;
-		job->reply->reply_payload_rcv_len = 0;
+		bsg_reply->result = rc = -EINVAL;
+		bsg_reply->reply_payload_rcv_len = 0;
 		break;
 	}
 
diff --git a/drivers/scsi/ibmvscsi/ibmvfc.c b/drivers/scsi/ibmvscsi/ibmvfc.c
index 7e487c7..7c17a7e 100644
--- a/drivers/scsi/ibmvscsi/ibmvfc.c
+++ b/drivers/scsi/ibmvscsi/ibmvfc.c
@@ -1827,28 +1827,30 @@ static int ibmvfc_bsg_request(struct fc_bsg_job *job)
 	struct ibmvfc_event *evt;
 	union ibmvfc_iu rsp_iu;
 	unsigned long flags, port_id = -1;
-	unsigned int code = job->request->msgcode;
+	struct fc_bsg_request *bsg_request = job->request;
+	struct fc_bsg_reply *bsg_reply = job->reply;
+	unsigned int code = bsg_request->msgcode;
 	int rc = 0, req_seg, rsp_seg, issue_login = 0;
 	u32 fc_flags, rsp_len;
 
 	ENTER;
-	job->reply->reply_payload_rcv_len = 0;
+	bsg_reply->reply_payload_rcv_len = 0;
 	if (rport)
 		port_id = rport->port_id;
 
 	switch (code) {
 	case FC_BSG_HST_ELS_NOLOGIN:
-		port_id = (job->request->rqst_data.h_els.port_id[0] << 16) |
-			(job->request->rqst_data.h_els.port_id[1] << 8) |
-			job->request->rqst_data.h_els.port_id[2];
+		port_id = (bsg_request->rqst_data.h_els.port_id[0] << 16) |
+			(bsg_request->rqst_data.h_els.port_id[1] << 8) |
+			bsg_request->rqst_data.h_els.port_id[2];
 	case FC_BSG_RPT_ELS:
 		fc_flags = IBMVFC_FC_ELS;
 		break;
 	case FC_BSG_HST_CT:
 		issue_login = 1;
-		port_id = (job->request->rqst_data.h_ct.port_id[0] << 16) |
-			(job->request->rqst_data.h_ct.port_id[1] << 8) |
-			job->request->rqst_data.h_ct.port_id[2];
+		port_id = (bsg_request->rqst_data.h_ct.port_id[0] << 16) |
+			(bsg_request->rqst_data.h_ct.port_id[1] << 8) |
+			bsg_request->rqst_data.h_ct.port_id[2];
 	case FC_BSG_RPT_CT:
 		fc_flags = IBMVFC_FC_CT_IU;
 		break;
@@ -1937,12 +1939,12 @@ static int ibmvfc_bsg_request(struct fc_bsg_job *job)
 	if (rsp_iu.passthru.common.status)
 		rc = -EIO;
 	else
-		job->reply->reply_payload_rcv_len = rsp_len;
+		bsg_reply->reply_payload_rcv_len = rsp_len;
 
 	spin_lock_irqsave(vhost->host->host_lock, flags);
 	ibmvfc_free_event(evt);
 	spin_unlock_irqrestore(vhost->host->host_lock, flags);
-	job->reply->result = rc;
+	bsg_reply->result = rc;
 	job->job_done(job);
 	rc = 0;
 out:
diff --git a/drivers/scsi/libfc/fc_lport.c b/drivers/scsi/libfc/fc_lport.c
index 2d3133f..2de6093 100644
--- a/drivers/scsi/libfc/fc_lport.c
+++ b/drivers/scsi/libfc/fc_lport.c
@@ -1902,13 +1902,14 @@ static void fc_lport_bsg_resp(struct fc_seq *sp, struct fc_frame *fp,
 {
 	struct fc_bsg_info *info = info_arg;
 	struct fc_bsg_job *job = info->job;
+	struct fc_bsg_reply *bsg_reply = job->reply;
 	struct fc_lport *lport = info->lport;
 	struct fc_frame_header *fh;
 	size_t len;
 	void *buf;
 
 	if (IS_ERR(fp)) {
-		job->reply->result = (PTR_ERR(fp) == -FC_EX_CLOSED) ?
+		bsg_reply->result = (PTR_ERR(fp) == -FC_EX_CLOSED) ?
 			-ECONNABORTED : -ETIMEDOUT;
 		job->reply_len = sizeof(uint32_t);
 		job->state_flags |= FC_RQST_STATE_DONE;
@@ -1929,23 +1930,23 @@ static void fc_lport_bsg_resp(struct fc_seq *sp, struct fc_frame *fp,
 			(unsigned short)fc_frame_payload_op(fp);
 
 		/* Save the reply status of the job */
-		job->reply->reply_data.ctels_reply.status =
+		bsg_reply->reply_data.ctels_reply.status =
 			(cmd == info->rsp_code) ?
 			FC_CTELS_STATUS_OK : FC_CTELS_STATUS_REJECT;
 	}
 
-	job->reply->reply_payload_rcv_len +=
+	bsg_reply->reply_payload_rcv_len +=
 		fc_copy_buffer_to_sglist(buf, len, info->sg, &info->nents,
 					 &info->offset, NULL);
 
 	if (fr_eof(fp) == FC_EOF_T &&
 	    (ntoh24(fh->fh_f_ctl) & (FC_FC_LAST_SEQ | FC_FC_END_SEQ)) ==
 	    (FC_FC_LAST_SEQ | FC_FC_END_SEQ)) {
-		if (job->reply->reply_payload_rcv_len >
+		if (bsg_reply->reply_payload_rcv_len >
 		    job->reply_payload.payload_len)
-			job->reply->reply_payload_rcv_len =
+			bsg_reply->reply_payload_rcv_len =
 				job->reply_payload.payload_len;
-		job->reply->result = 0;
+		bsg_reply->result = 0;
 		job->state_flags |= FC_RQST_STATE_DONE;
 		job->job_done(job);
 		kfree(info);
@@ -2082,6 +2083,8 @@ static int fc_lport_ct_request(struct fc_bsg_job *job,
  */
 int fc_lport_bsg_request(struct fc_bsg_job *job)
 {
+	struct fc_bsg_request *bsg_request = job->request;
+	struct fc_bsg_reply *bsg_reply = job->reply;
 	struct request *rsp = job->req->next_rq;
 	struct Scsi_Host *shost = job->shost;
 	struct fc_lport *lport = shost_priv(shost);
@@ -2090,13 +2093,13 @@ int fc_lport_bsg_request(struct fc_bsg_job *job)
 	int rc = -EINVAL;
 	u32 did, tov;
 
-	job->reply->reply_payload_rcv_len = 0;
+	bsg_reply->reply_payload_rcv_len = 0;
 	if (rsp)
 		rsp->resid_len = job->reply_payload.payload_len;
 
 	mutex_lock(&lport->lp_mutex);
 
-	switch (job->request->msgcode) {
+	switch (bsg_request->msgcode) {
 	case FC_BSG_RPT_ELS:
 		rport = job->rport;
 		if (!rport)
@@ -2118,7 +2121,7 @@ int fc_lport_bsg_request(struct fc_bsg_job *job)
 		break;
 
 	case FC_BSG_HST_CT:
-		did = ntoh24(job->request->rqst_data.h_ct.port_id);
+		did = ntoh24(bsg_request->rqst_data.h_ct.port_id);
 		if (did == FC_FID_DIR_SERV) {
 			rdata = lport->dns_rdata;
 			if (!rdata)
@@ -2136,7 +2139,7 @@ int fc_lport_bsg_request(struct fc_bsg_job *job)
 		break;
 
 	case FC_BSG_HST_ELS_NOLOGIN:
-		did = ntoh24(job->request->rqst_data.h_els.port_id);
+		did = ntoh24(bsg_request->rqst_data.h_els.port_id);
 		rc = fc_lport_els_request(job, lport, did, lport->e_d_tov);
 		break;
 	}
diff --git a/drivers/scsi/lpfc/lpfc_bsg.c b/drivers/scsi/lpfc/lpfc_bsg.c
index 0148ee3e..f09a325 100644
--- a/drivers/scsi/lpfc/lpfc_bsg.c
+++ b/drivers/scsi/lpfc/lpfc_bsg.c
@@ -299,6 +299,7 @@ struct lpfc_dmabufext {
 {
 	struct bsg_job_data *dd_data;
 	struct fc_bsg_job *job;
+	struct fc_bsg_reply *bsg_reply;
 	IOCB_t *rsp;
 	struct lpfc_dmabuf *bmp, *cmp, *rmp;
 	struct lpfc_nodelist *ndlp;
@@ -313,6 +314,7 @@ struct lpfc_dmabufext {
 	spin_lock_irqsave(&phba->ct_ev_lock, flags);
 	job = dd_data->set_job;
 	if (job) {
+		bsg_reply = job->reply;
 		/* Prevent timeout handling from trying to abort job */
 		job->dd_data = NULL;
 	}
@@ -351,7 +353,7 @@ struct lpfc_dmabufext {
 			}
 		} else {
 			rsp_size = rsp->un.genreq64.bdl.bdeSize;
-			job->reply->reply_payload_rcv_len =
+			bsg_reply->reply_payload_rcv_len =
 				lpfc_bsg_copy_data(rmp, &job->reply_payload,
 						   rsp_size, 0);
 		}
@@ -368,7 +370,7 @@ struct lpfc_dmabufext {
 	/* Complete the job if the job is still active */
 
 	if (job) {
-		job->reply->result = rc;
+		bsg_reply->result = rc;
 		job->job_done(job);
 	}
 	return;
@@ -385,6 +387,7 @@ struct lpfc_dmabufext {
 	struct lpfc_hba *phba = vport->phba;
 	struct lpfc_rport_data *rdata = job->rport->dd_data;
 	struct lpfc_nodelist *ndlp = rdata->pnode;
+	struct fc_bsg_reply *bsg_reply = job->reply;
 	struct ulp_bde64 *bpl = NULL;
 	uint32_t timeout;
 	struct lpfc_iocbq *cmdiocbq = NULL;
@@ -399,7 +402,7 @@ struct lpfc_dmabufext {
 	int iocb_stat;
 
 	/* in case no data is transferred */
-	job->reply->reply_payload_rcv_len = 0;
+	bsg_reply->reply_payload_rcv_len = 0;
 
 	/* allocate our bsg tracking structure */
 	dd_data = kmalloc(sizeof(struct bsg_job_data), GFP_KERNEL);
@@ -543,7 +546,7 @@ struct lpfc_dmabufext {
 	kfree(dd_data);
 no_dd_data:
 	/* make error code available to userspace */
-	job->reply->result = rc;
+	bsg_reply->result = rc;
 	job->dd_data = NULL;
 	return rc;
 }
@@ -572,6 +575,7 @@ struct lpfc_dmabufext {
 {
 	struct bsg_job_data *dd_data;
 	struct fc_bsg_job *job;
+	struct fc_bsg_reply *bsg_reply;
 	IOCB_t *rsp;
 	struct lpfc_nodelist *ndlp;
 	struct lpfc_dmabuf *pcmd = NULL, *prsp = NULL;
@@ -589,6 +593,7 @@ struct lpfc_dmabufext {
 	spin_lock_irqsave(&phba->ct_ev_lock, flags);
 	job = dd_data->set_job;
 	if (job) {
+		bsg_reply = job->reply;
 		/* Prevent timeout handling from trying to abort job  */
 		job->dd_data = NULL;
 	}
@@ -610,17 +615,17 @@ struct lpfc_dmabufext {
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
@@ -638,7 +643,7 @@ struct lpfc_dmabufext {
 	/* Complete the job if the job is still active */
 
 	if (job) {
-		job->reply->result = rc;
+		bsg_reply->result = rc;
 		job->job_done(job);
 	}
 	return;
@@ -655,6 +660,8 @@ struct lpfc_dmabufext {
 	struct lpfc_hba *phba = vport->phba;
 	struct lpfc_rport_data *rdata = job->rport->dd_data;
 	struct lpfc_nodelist *ndlp = rdata->pnode;
+	struct fc_bsg_request *bsg_request = job->request;
+	struct fc_bsg_reply *bsg_reply = job->reply;
 	uint32_t elscmd;
 	uint32_t cmdsize;
 	struct lpfc_iocbq *cmdiocbq;
@@ -665,7 +672,7 @@ struct lpfc_dmabufext {
 	int rc = 0;
 
 	/* in case no data is transferred */
-	job->reply->reply_payload_rcv_len = 0;
+	bsg_reply->reply_payload_rcv_len = 0;
 
 	/* verify the els command is not greater than the
 	 * maximum ELS transfer size.
@@ -685,7 +692,7 @@ struct lpfc_dmabufext {
 		goto no_dd_data;
 	}
 
-	elscmd = job->request->rqst_data.r_els.els_code;
+	elscmd = bsg_request->rqst_data.r_els.els_code;
 	cmdsize = job->request_payload.payload_len;
 
 	if (!lpfc_nlp_get(ndlp)) {
@@ -772,7 +779,7 @@ struct lpfc_dmabufext {
 
 no_dd_data:
 	/* make error code available to userspace */
-	job->reply->result = rc;
+	bsg_reply->result = rc;
 	job->dd_data = NULL;
 	return rc;
 }
@@ -919,6 +926,7 @@ struct lpfc_dmabufext {
 	struct lpfc_hbq_entry *hbqe;
 	struct lpfc_sli_ct_request *ct_req;
 	struct fc_bsg_job *job = NULL;
+	struct fc_bsg_reply *bsg_reply;
 	struct bsg_job_data *dd_data = NULL;
 	unsigned long flags;
 	int size = 0;
@@ -1121,9 +1129,10 @@ struct lpfc_dmabufext {
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
@@ -1192,6 +1201,7 @@ struct lpfc_dmabufext {
 {
 	struct lpfc_vport *vport = (struct lpfc_vport *)job->shost->hostdata;
 	struct lpfc_hba *phba = vport->phba;
+	struct fc_bsg_request *bsg_request = job->request;
 	struct set_ct_event *event_req;
 	struct lpfc_bsg_event *evt;
 	int rc = 0;
@@ -1209,7 +1219,7 @@ struct lpfc_dmabufext {
 	}
 
 	event_req = (struct set_ct_event *)
-		job->request->rqst_data.h_vendor.vendor_cmd;
+		bsg_request->rqst_data.h_vendor.vendor_cmd;
 	ev_mask = ((uint32_t)(unsigned long)event_req->type_mask &
 				FC_REG_EVENT_MASK);
 	spin_lock_irqsave(&phba->ct_ev_lock, flags);
@@ -1276,6 +1286,8 @@ struct lpfc_dmabufext {
 {
 	struct lpfc_vport *vport = (struct lpfc_vport *)job->shost->hostdata;
 	struct lpfc_hba *phba = vport->phba;
+	struct fc_bsg_request *bsg_request = job->request;
+	struct fc_bsg_reply *bsg_reply = job->reply;
 	struct get_ct_event *event_req;
 	struct get_ct_event_reply *event_reply;
 	struct lpfc_bsg_event *evt, *evt_next;
@@ -1293,10 +1305,10 @@ struct lpfc_dmabufext {
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
@@ -1316,7 +1328,7 @@ struct lpfc_dmabufext {
 	 * an error indicating that there isn't anymore
 	 */
 	if (evt_dat == NULL) {
-		job->reply->reply_payload_rcv_len = 0;
+		bsg_reply->reply_payload_rcv_len = 0;
 		rc = -ENOENT;
 		goto job_error;
 	}
@@ -1332,12 +1344,12 @@ struct lpfc_dmabufext {
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
@@ -1348,13 +1360,13 @@ struct lpfc_dmabufext {
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
 
@@ -1382,6 +1394,7 @@ struct lpfc_dmabufext {
 {
 	struct bsg_job_data *dd_data;
 	struct fc_bsg_job *job;
+	struct fc_bsg_reply *bsg_reply;
 	IOCB_t *rsp;
 	struct lpfc_dmabuf *bmp, *cmp;
 	struct lpfc_nodelist *ndlp;
@@ -1412,6 +1425,7 @@ struct lpfc_dmabufext {
 	/* Copy the completed job data or set the error status */
 
 	if (job) {
+		bsg_reply = job->reply;
 		if (rsp->ulpStatus) {
 			if (rsp->ulpStatus == IOSTAT_LOCAL_REJECT) {
 				switch (rsp->un.ulpWord[4] & IOERR_PARAM_MASK) {
@@ -1429,7 +1443,7 @@ struct lpfc_dmabufext {
 				rc = -EACCES;
 			}
 		} else {
-			job->reply->reply_payload_rcv_len = 0;
+			bsg_reply->reply_payload_rcv_len = 0;
 		}
 	}
 
@@ -1443,7 +1457,7 @@ struct lpfc_dmabufext {
 	/* Complete the job if the job is still active */
 
 	if (job) {
-		job->reply->result = rc;
+		bsg_reply->result = rc;
 		job->job_done(job);
 	}
 	return;
@@ -1608,8 +1622,10 @@ struct lpfc_dmabufext {
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
@@ -1619,7 +1635,7 @@ struct lpfc_dmabufext {
 	int rc = 0;
 
 	/* in case no data is transferred */
-	job->reply->reply_payload_rcv_len = 0;
+	bsg_reply->reply_payload_rcv_len = 0;
 
 	if (!reqbfrcnt || (reqbfrcnt > (80 * BUF_SZ_4K))) {
 		rc = -ERANGE;
@@ -1665,7 +1681,7 @@ struct lpfc_dmabufext {
 	kfree(bmp);
 send_mgmt_rsp_exit:
 	/* make error code available to userspace */
-	job->reply->result = rc;
+	bsg_reply->result = rc;
 	job->dd_data = NULL;
 	return rc;
 }
@@ -1763,6 +1779,8 @@ struct lpfc_dmabufext {
 static int
 lpfc_sli3_bsg_diag_loopback_mode(struct lpfc_hba *phba, struct fc_bsg_job *job)
 {
+	struct fc_bsg_request *bsg_request = job->request;
+	struct fc_bsg_reply *bsg_reply = job->reply;
 	struct diag_mode_set *loopback_mode;
 	uint32_t link_flags;
 	uint32_t timeout;
@@ -1772,7 +1790,7 @@ struct lpfc_dmabufext {
 	int rc = 0;
 
 	/* no data to return just the return code */
-	job->reply->reply_payload_rcv_len = 0;
+	bsg_reply->reply_payload_rcv_len = 0;
 
 	if (job->request_len < sizeof(struct fc_bsg_request) +
 	    sizeof(struct diag_mode_set)) {
@@ -1792,7 +1810,7 @@ struct lpfc_dmabufext {
 
 	/* bring the link to diagnostic mode */
 	loopback_mode = (struct diag_mode_set *)
-		job->request->rqst_data.h_vendor.vendor_cmd;
+		bsg_request->rqst_data.h_vendor.vendor_cmd;
 	link_flags = loopback_mode->type;
 	timeout = loopback_mode->timeout * 100;
 
@@ -1865,7 +1883,7 @@ struct lpfc_dmabufext {
 
 job_error:
 	/* make error code available to userspace */
-	job->reply->result = rc;
+	bsg_reply->result = rc;
 	/* complete the job back to userspace if no error */
 	if (rc == 0)
 		job->job_done(job);
@@ -2018,12 +2036,14 @@ struct lpfc_dmabufext {
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
@@ -2055,7 +2075,7 @@ struct lpfc_dmabufext {
 	lpfc_printf_log(phba, KERN_INFO, LOG_LIBDFC,
 			"3129 Bring link to diagnostic state.\n");
 	loopback_mode = (struct diag_mode_set *)
-		job->request->rqst_data.h_vendor.vendor_cmd;
+		bsg_request->rqst_data.h_vendor.vendor_cmd;
 	link_flags = loopback_mode->type;
 	timeout = loopback_mode->timeout * 100;
 
@@ -2152,7 +2172,7 @@ struct lpfc_dmabufext {
 
 job_error:
 	/* make error code available to userspace */
-	job->reply->result = rc;
+	bsg_reply->result = rc;
 	/* complete the job back to userspace if no error */
 	if (rc == 0)
 		job->job_done(job);
@@ -2205,6 +2225,8 @@ struct lpfc_dmabufext {
 static int
 lpfc_sli4_bsg_diag_mode_end(struct fc_bsg_job *job)
 {
+	struct fc_bsg_request *bsg_request = job->request;
+	struct fc_bsg_reply *bsg_reply = job->reply;
 	struct Scsi_Host *shost;
 	struct lpfc_vport *vport;
 	struct lpfc_hba *phba;
@@ -2233,7 +2255,7 @@ struct lpfc_dmabufext {
 	phba->link_flag &= ~LS_LOOPBACK_MODE;
 	spin_unlock_irq(&phba->hbalock);
 	loopback_mode_end_cmd = (struct diag_mode_set *)
-			job->request->rqst_data.h_vendor.vendor_cmd;
+			bsg_request->rqst_data.h_vendor.vendor_cmd;
 	timeout = loopback_mode_end_cmd->timeout * 100;
 
 	rc = lpfc_sli4_bsg_set_link_diag_state(phba, 0);
@@ -2264,7 +2286,7 @@ struct lpfc_dmabufext {
 
 loopback_mode_end_exit:
 	/* make return code available to userspace */
-	job->reply->result = rc;
+	bsg_reply->result = rc;
 	/* complete the job back to userspace if no error */
 	if (rc == 0)
 		job->job_done(job);
@@ -2281,6 +2303,8 @@ struct lpfc_dmabufext {
 static int
 lpfc_sli4_bsg_link_diag_test(struct fc_bsg_job *job)
 {
+	struct fc_bsg_request *bsg_request = job->request;
+	struct fc_bsg_reply *bsg_reply = job->reply;
 	struct Scsi_Host *shost;
 	struct lpfc_vport *vport;
 	struct lpfc_hba *phba;
@@ -2336,7 +2360,7 @@ struct lpfc_dmabufext {
 		goto job_error;
 
 	link_diag_test_cmd = (struct sli4_link_diag *)
-			 job->request->rqst_data.h_vendor.vendor_cmd;
+			 bsg_request->rqst_data.h_vendor.vendor_cmd;
 
 	rc = lpfc_sli4_bsg_set_link_diag_state(phba, 1);
 
@@ -2386,7 +2410,7 @@ struct lpfc_dmabufext {
 	}
 
 	diag_status_reply = (struct diag_status *)
-			    job->reply->reply_data.vendor_reply.vendor_rsp;
+			    bsg_reply->reply_data.vendor_reply.vendor_rsp;
 
 	if (job->reply_len <
 	    sizeof(struct fc_bsg_request) + sizeof(struct diag_status)) {
@@ -2414,7 +2438,7 @@ struct lpfc_dmabufext {
 
 job_error:
 	/* make error code available to userspace */
-	job->reply->result = rc;
+	bsg_reply->result = rc;
 	/* complete the job back to userspace if no error */
 	if (rc == 0)
 		job->job_done(job);
@@ -2986,6 +3010,7 @@ static int lpfcdiag_loop_post_rxbufs(struct lpfc_hba *phba, uint16_t rxxri,
 lpfc_bsg_diag_loopback_run(struct fc_bsg_job *job)
 {
 	struct lpfc_vport *vport = (struct lpfc_vport *)job->shost->hostdata;
+	struct fc_bsg_reply *bsg_reply = job->reply;
 	struct lpfc_hba *phba = vport->phba;
 	struct lpfc_bsg_event *evt;
 	struct event_data *evdat;
@@ -3013,7 +3038,7 @@ static int lpfcdiag_loop_post_rxbufs(struct lpfc_hba *phba, uint16_t rxxri,
 	uint32_t total_mem;
 
 	/* in case no data is returned return just the return code */
-	job->reply->reply_payload_rcv_len = 0;
+	bsg_reply->reply_payload_rcv_len = 0;
 
 	if (job->request_len <
 	    sizeof(struct fc_bsg_request) + sizeof(struct diag_mode_test)) {
@@ -3238,11 +3263,11 @@ static int lpfcdiag_loop_post_rxbufs(struct lpfc_hba *phba, uint16_t rxxri,
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
 
@@ -3272,7 +3297,7 @@ static int lpfcdiag_loop_post_rxbufs(struct lpfc_hba *phba, uint16_t rxxri,
 loopback_test_exit:
 	kfree(dataout);
 	/* make error code available to userspace */
-	job->reply->result = rc;
+	bsg_reply->result = rc;
 	job->dd_data = NULL;
 	/* complete the job back to userspace if no error */
 	if (rc == IOCB_SUCCESS)
@@ -3288,6 +3313,7 @@ static int lpfcdiag_loop_post_rxbufs(struct lpfc_hba *phba, uint16_t rxxri,
 lpfc_bsg_get_dfc_rev(struct fc_bsg_job *job)
 {
 	struct lpfc_vport *vport = (struct lpfc_vport *)job->shost->hostdata;
+	struct fc_bsg_reply *bsg_reply = job->reply;
 	struct lpfc_hba *phba = vport->phba;
 	struct get_mgmt_rev_reply *event_reply;
 	int rc = 0;
@@ -3302,7 +3328,7 @@ static int lpfcdiag_loop_post_rxbufs(struct lpfc_hba *phba, uint16_t rxxri,
 	}
 
 	event_reply = (struct get_mgmt_rev_reply *)
-		job->reply->reply_data.vendor_reply.vendor_rsp;
+		bsg_reply->reply_data.vendor_reply.vendor_rsp;
 
 	if (job->reply_len <
 	    sizeof(struct fc_bsg_request) + sizeof(struct get_mgmt_rev_reply)) {
@@ -3316,7 +3342,7 @@ static int lpfcdiag_loop_post_rxbufs(struct lpfc_hba *phba, uint16_t rxxri,
 	event_reply->info.a_Major = MANAGEMENT_MAJOR_REV;
 	event_reply->info.a_Minor = MANAGEMENT_MINOR_REV;
 job_error:
-	job->reply->result = rc;
+	bsg_reply->result = rc;
 	if (rc == 0)
 		job->job_done(job);
 	return rc;
@@ -3337,6 +3363,7 @@ static int lpfcdiag_loop_post_rxbufs(struct lpfc_hba *phba, uint16_t rxxri,
 lpfc_bsg_issue_mbox_cmpl(struct lpfc_hba *phba, LPFC_MBOXQ_t *pmboxq)
 {
 	struct bsg_job_data *dd_data;
+	struct fc_bsg_reply *bsg_reply;
 	struct fc_bsg_job *job;
 	uint32_t size;
 	unsigned long flags;
@@ -3365,8 +3392,9 @@ static int lpfcdiag_loop_post_rxbufs(struct lpfc_hba *phba, uint16_t rxxri,
 	/* Copy the mailbox data to the job if it is still active */
 
 	if (job) {
+		bsg_reply = job->reply;
 		size = job->reply_payload.payload_len;
-		job->reply->reply_payload_rcv_len =
+		bsg_reply->reply_payload_rcv_len =
 			sg_copy_from_buffer(job->reply_payload.sg_list,
 					    job->reply_payload.sg_cnt,
 					    pmb_buf, size);
@@ -3380,7 +3408,7 @@ static int lpfcdiag_loop_post_rxbufs(struct lpfc_hba *phba, uint16_t rxxri,
 	/* Complete the job if the job is still active */
 
 	if (job) {
-		job->reply->result = 0;
+		bsg_reply->result = 0;
 		job->job_done(job);
 	}
 	return;
@@ -3516,6 +3544,7 @@ static int lpfc_bsg_check_cmd_access(struct lpfc_hba *phba,
 {
 	struct bsg_job_data *dd_data;
 	struct fc_bsg_job *job;
+	struct fc_bsg_reply *bsg_reply;
 	uint8_t *pmb, *pmb_buf;
 	unsigned long flags;
 	uint32_t size;
@@ -3530,6 +3559,7 @@ static int lpfc_bsg_check_cmd_access(struct lpfc_hba *phba,
 	spin_lock_irqsave(&phba->ct_ev_lock, flags);
 	job = dd_data->set_job;
 	if (job) {
+		bsg_reply = job->reply;
 		/* Prevent timeout handling from trying to abort job  */
 		job->dd_data = NULL;
 	}
@@ -3560,13 +3590,13 @@ static int lpfc_bsg_check_cmd_access(struct lpfc_hba *phba,
 
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
@@ -3773,6 +3803,7 @@ static int lpfc_bsg_check_cmd_access(struct lpfc_hba *phba,
 			      enum nemb_type nemb_tp,
 			      struct lpfc_dmabuf *dmabuf)
 {
+	struct fc_bsg_request *bsg_request = job->request;
 	struct lpfc_sli_config_mbox *sli_cfg_mbx;
 	struct dfc_mbox_req *mbox_req;
 	struct lpfc_dmabuf *curr_dmabuf, *next_dmabuf;
@@ -3785,7 +3816,7 @@ static int lpfc_bsg_check_cmd_access(struct lpfc_hba *phba,
 	int rc, i;
 
 	mbox_req =
-	   (struct dfc_mbox_req *)job->request->rqst_data.h_vendor.vendor_cmd;
+	   (struct dfc_mbox_req *)bsg_request->rqst_data.h_vendor.vendor_cmd;
 
 	/* pointer to the start of mailbox command */
 	sli_cfg_mbx = (struct lpfc_sli_config_mbox *)dmabuf->virt;
@@ -3960,6 +3991,8 @@ static int lpfc_bsg_check_cmd_access(struct lpfc_hba *phba,
 			       enum nemb_type nemb_tp,
 			       struct lpfc_dmabuf *dmabuf)
 {
+	struct fc_bsg_request *bsg_request = job->request;
+	struct fc_bsg_reply *bsg_reply = job->reply;
 	struct dfc_mbox_req *mbox_req;
 	struct lpfc_sli_config_mbox *sli_cfg_mbx;
 	uint32_t ext_buf_cnt;
@@ -3970,7 +4003,7 @@ static int lpfc_bsg_check_cmd_access(struct lpfc_hba *phba,
 	int rc = SLI_CONFIG_NOT_HANDLED, i;
 
 	mbox_req =
-	   (struct dfc_mbox_req *)job->request->rqst_data.h_vendor.vendor_cmd;
+	   (struct dfc_mbox_req *)bsg_request->rqst_data.h_vendor.vendor_cmd;
 
 	/* pointer to the start of mailbox command */
 	sli_cfg_mbx = (struct lpfc_sli_config_mbox *)dmabuf->virt;
@@ -4097,7 +4130,7 @@ static int lpfc_bsg_check_cmd_access(struct lpfc_hba *phba,
 
 	/* wait for additoinal external buffers */
 
-	job->reply->result = 0;
+	bsg_reply->result = 0;
 	job->job_done(job);
 	return SLI_CONFIG_HANDLED;
 
@@ -4271,6 +4304,7 @@ static int lpfc_bsg_check_cmd_access(struct lpfc_hba *phba,
 static int
 lpfc_bsg_read_ebuf_get(struct lpfc_hba *phba, struct fc_bsg_job *job)
 {
+	struct fc_bsg_reply *bsg_reply = job->reply;
 	struct lpfc_sli_config_mbox *sli_cfg_mbx;
 	struct lpfc_dmabuf *dmabuf;
 	uint8_t *pbuf;
@@ -4308,7 +4342,7 @@ static int lpfc_bsg_check_cmd_access(struct lpfc_hba *phba,
 					dmabuf, index);
 
 	pbuf = (uint8_t *)dmabuf->virt;
-	job->reply->reply_payload_rcv_len =
+	bsg_reply->reply_payload_rcv_len =
 		sg_copy_from_buffer(job->reply_payload.sg_list,
 				    job->reply_payload.sg_cnt,
 				    pbuf, size);
@@ -4322,7 +4356,7 @@ static int lpfc_bsg_check_cmd_access(struct lpfc_hba *phba,
 		lpfc_bsg_mbox_ext_session_reset(phba);
 	}
 
-	job->reply->result = 0;
+	bsg_reply->result = 0;
 	job->job_done(job);
 
 	return SLI_CONFIG_HANDLED;
@@ -4340,6 +4374,7 @@ static int lpfc_bsg_check_cmd_access(struct lpfc_hba *phba,
 lpfc_bsg_write_ebuf_set(struct lpfc_hba *phba, struct fc_bsg_job *job,
 			struct lpfc_dmabuf *dmabuf)
 {
+	struct fc_bsg_reply *bsg_reply = job->reply;
 	struct bsg_job_data *dd_data = NULL;
 	LPFC_MBOXQ_t *pmboxq = NULL;
 	MAILBOX_t *pmb;
@@ -4437,7 +4472,7 @@ static int lpfc_bsg_check_cmd_access(struct lpfc_hba *phba,
 	}
 
 	/* wait for additoinal external buffers */
-	job->reply->result = 0;
+	bsg_reply->result = 0;
 	job->job_done(job);
 	return SLI_CONFIG_HANDLED;
 
@@ -4506,11 +4541,12 @@ static int lpfc_bsg_check_cmd_access(struct lpfc_hba *phba,
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
@@ -4583,6 +4619,8 @@ static int lpfc_bsg_check_cmd_access(struct lpfc_hba *phba,
 lpfc_bsg_issue_mbox(struct lpfc_hba *phba, struct fc_bsg_job *job,
 	struct lpfc_vport *vport)
 {
+	struct fc_bsg_request *bsg_request = job->request;
+	struct fc_bsg_reply *bsg_reply = job->reply;
 	LPFC_MBOXQ_t *pmboxq = NULL; /* internal mailbox queue */
 	MAILBOX_t *pmb; /* shortcut to the pmboxq mailbox */
 	/* a 4k buffer to hold the mb and extended data from/to the bsg */
@@ -4601,7 +4639,7 @@ static int lpfc_bsg_check_cmd_access(struct lpfc_hba *phba,
 	uint32_t size;
 
 	/* in case no data is transferred */
-	job->reply->reply_payload_rcv_len = 0;
+	bsg_reply->reply_payload_rcv_len = 0;
 
 	/* sanity check to protect driver */
 	if (job->reply_payload.payload_len > BSG_MBOX_SIZE ||
@@ -4620,7 +4658,7 @@ static int lpfc_bsg_check_cmd_access(struct lpfc_hba *phba,
 	}
 
 	mbox_req =
-	    (struct dfc_mbox_req *)job->request->rqst_data.h_vendor.vendor_cmd;
+	    (struct dfc_mbox_req *)bsg_request->rqst_data.h_vendor.vendor_cmd;
 
 	/* check if requested extended data lengths are valid */
 	if ((mbox_req->inExtWLen > BSG_MBOX_SIZE/sizeof(uint32_t)) ||
@@ -4842,7 +4880,7 @@ static int lpfc_bsg_check_cmd_access(struct lpfc_hba *phba,
 
 		/* job finished, copy the data */
 		memcpy(pmbx, pmb, sizeof(*pmb));
-		job->reply->reply_payload_rcv_len =
+		bsg_reply->reply_payload_rcv_len =
 			sg_copy_from_buffer(job->reply_payload.sg_list,
 					    job->reply_payload.sg_cnt,
 					    pmbx, size);
@@ -4874,12 +4912,14 @@ static int lpfc_bsg_check_cmd_access(struct lpfc_hba *phba,
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
@@ -4890,7 +4930,7 @@ static int lpfc_bsg_check_cmd_access(struct lpfc_hba *phba,
 				      sizeof(struct fc_bsg_request)),
 				(int)sizeof(struct dfc_mbox_req));
 		mbox_req = (struct dfc_mbox_req *)
-				job->request->rqst_data.h_vendor.vendor_cmd;
+				bsg_request->rqst_data.h_vendor.vendor_cmd;
 		mbox_req->extMboxTag = 0;
 		mbox_req->extSeqNum = 0;
 	}
@@ -4899,7 +4939,7 @@ static int lpfc_bsg_check_cmd_access(struct lpfc_hba *phba,
 
 	if (rc == 0) {
 		/* job done */
-		job->reply->result = 0;
+		bsg_reply->result = 0;
 		job->dd_data = NULL;
 		job->job_done(job);
 	} else if (rc == 1)
@@ -4907,7 +4947,7 @@ static int lpfc_bsg_check_cmd_access(struct lpfc_hba *phba,
 		rc = 0; /* return zero, no error */
 	else {
 		/* some error occurred */
-		job->reply->result = rc;
+		bsg_reply->result = rc;
 		job->dd_data = NULL;
 	}
 
@@ -4938,6 +4978,7 @@ static int lpfc_bsg_check_cmd_access(struct lpfc_hba *phba,
 {
 	struct bsg_job_data *dd_data;
 	struct fc_bsg_job *job;
+	struct fc_bsg_reply *bsg_reply;
 	IOCB_t *rsp;
 	struct lpfc_dmabuf *bmp, *cmp, *rmp;
 	struct lpfc_bsg_menlo *menlo;
@@ -4957,6 +4998,7 @@ static int lpfc_bsg_check_cmd_access(struct lpfc_hba *phba,
 	spin_lock_irqsave(&phba->ct_ev_lock, flags);
 	job = dd_data->set_job;
 	if (job) {
+		bsg_reply = job->reply;
 		/* Prevent timeout handling from trying to abort job  */
 		job->dd_data = NULL;
 	}
@@ -4971,7 +5013,7 @@ static int lpfc_bsg_check_cmd_access(struct lpfc_hba *phba,
 		 */
 
 		menlo_resp = (struct menlo_response *)
-			job->reply->reply_data.vendor_reply.vendor_rsp;
+			bsg_reply->reply_data.vendor_reply.vendor_rsp;
 		menlo_resp->xri = rsp->ulpContext;
 		if (rsp->ulpStatus) {
 			if (rsp->ulpStatus == IOSTAT_LOCAL_REJECT) {
@@ -4991,7 +5033,7 @@ static int lpfc_bsg_check_cmd_access(struct lpfc_hba *phba,
 			}
 		} else {
 			rsp_size = rsp->un.genreq64.bdl.bdeSize;
-			job->reply->reply_payload_rcv_len =
+			bsg_reply->reply_payload_rcv_len =
 				lpfc_bsg_copy_data(rmp, &job->reply_payload,
 						   rsp_size, 0);
 		}
@@ -5008,7 +5050,7 @@ static int lpfc_bsg_check_cmd_access(struct lpfc_hba *phba,
 	/* Complete the job if active */
 
 	if (job) {
-		job->reply->result = rc;
+		bsg_reply->result = rc;
 		job->job_done(job);
 	}
 
@@ -5028,6 +5070,8 @@ static int lpfc_bsg_check_cmd_access(struct lpfc_hba *phba,
 lpfc_menlo_cmd(struct fc_bsg_job *job)
 {
 	struct lpfc_vport *vport = (struct lpfc_vport *)job->shost->hostdata;
+	struct fc_bsg_request *bsg_request = job->request;
+	struct fc_bsg_reply *bsg_reply = job->reply;
 	struct lpfc_hba *phba = vport->phba;
 	struct lpfc_iocbq *cmdiocbq;
 	IOCB_t *cmd;
@@ -5040,7 +5084,7 @@ static int lpfc_bsg_check_cmd_access(struct lpfc_hba *phba,
 	struct ulp_bde64 *bpl = NULL;
 
 	/* in case no data is returned return just the return code */
-	job->reply->reply_payload_rcv_len = 0;
+	bsg_reply->reply_payload_rcv_len = 0;
 
 	if (job->request_len <
 	    sizeof(struct fc_bsg_request) +
@@ -5070,7 +5114,7 @@ static int lpfc_bsg_check_cmd_access(struct lpfc_hba *phba,
 	}
 
 	menlo_cmd = (struct menlo_command *)
-		job->request->rqst_data.h_vendor.vendor_cmd;
+		bsg_request->rqst_data.h_vendor.vendor_cmd;
 
 	/* allocate our bsg tracking structure */
 	dd_data = kmalloc(sizeof(struct bsg_job_data), GFP_KERNEL);
@@ -5181,7 +5225,7 @@ static int lpfc_bsg_check_cmd_access(struct lpfc_hba *phba,
 	kfree(dd_data);
 no_dd_data:
 	/* make error code available to userspace */
-	job->reply->result = rc;
+	bsg_reply->result = rc;
 	job->dd_data = NULL;
 	return rc;
 }
@@ -5192,6 +5236,7 @@ static int lpfc_bsg_check_cmd_access(struct lpfc_hba *phba,
 	struct Scsi_Host *shost = job->shost;
 	struct lpfc_vport *vport = shost_priv(shost);
 	struct lpfc_hba *phba = vport->phba;
+	struct fc_bsg_reply *bsg_reply = job->reply;
 	struct forced_link_speed_support_reply *forced_reply;
 	int rc = 0;
 
@@ -5206,7 +5251,7 @@ static int lpfc_bsg_check_cmd_access(struct lpfc_hba *phba,
 	}
 
 	forced_reply = (struct forced_link_speed_support_reply *)
-		job->reply->reply_data.vendor_reply.vendor_rsp;
+		bsg_reply->reply_data.vendor_reply.vendor_rsp;
 
 	if (job->reply_len <
 	    sizeof(struct fc_bsg_request) +
@@ -5222,7 +5267,7 @@ static int lpfc_bsg_check_cmd_access(struct lpfc_hba *phba,
 				   ? LPFC_FORCED_LINK_SPEED_SUPPORTED
 				   : LPFC_FORCED_LINK_SPEED_NOT_SUPPORTED;
 job_error:
-	job->reply->result = rc;
+	bsg_reply->result = rc;
 	if (rc == 0)
 		job->job_done(job);
 	return rc;
@@ -5235,7 +5280,9 @@ static int lpfc_bsg_check_cmd_access(struct lpfc_hba *phba,
 static int
 lpfc_bsg_hst_vendor(struct fc_bsg_job *job)
 {
-	int command = job->request->rqst_data.h_vendor.vendor_cmd[0];
+	struct fc_bsg_request *bsg_request = job->request;
+	struct fc_bsg_reply *bsg_reply = job->reply;
+	int command = bsg_request->rqst_data.h_vendor.vendor_cmd[0];
 	int rc;
 
 	switch (command) {
@@ -5275,9 +5322,9 @@ static int lpfc_bsg_check_cmd_access(struct lpfc_hba *phba,
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
 
@@ -5291,10 +5338,12 @@ static int lpfc_bsg_check_cmd_access(struct lpfc_hba *phba,
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
@@ -5307,9 +5356,9 @@ static int lpfc_bsg_check_cmd_access(struct lpfc_hba *phba,
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
 
diff --git a/drivers/scsi/qla2xxx/qla_bsg.c b/drivers/scsi/qla2xxx/qla_bsg.c
index 643014f..40f7c10 100644
--- a/drivers/scsi/qla2xxx/qla_bsg.c
+++ b/drivers/scsi/qla2xxx/qla_bsg.c
@@ -17,8 +17,9 @@
 	srb_t *sp = (srb_t *)ptr;
 	struct scsi_qla_host *vha = (scsi_qla_host_t *)data;
 	struct fc_bsg_job *bsg_job = sp->u.bsg_job;
+	struct fc_bsg_reply *bsg_reply = bsg_job->reply;
 
-	bsg_job->reply->result = res;
+	bsg_reply->result = res;
 	bsg_job->job_done(bsg_job);
 	sp->free(vha, sp);
 }
@@ -29,12 +30,14 @@
 	srb_t *sp = (srb_t *)ptr;
 	struct scsi_qla_host *vha = sp->fcport->vha;
 	struct fc_bsg_job *bsg_job = sp->u.bsg_job;
+	struct fc_bsg_request *bsg_request = bsg_job->request;
+
 	struct qla_hw_data *ha = vha->hw;
 	struct qla_mt_iocb_rqst_fx00 *piocb_rqst;
 
 	if (sp->type == SRB_FXIOCB_BCMD) {
 		piocb_rqst = (struct qla_mt_iocb_rqst_fx00 *)
-		    &bsg_job->request->rqst_data.h_vendor.vendor_cmd[1];
+		    &bsg_request->rqst_data.h_vendor.vendor_cmd[1];
 
 		if (piocb_rqst->flags & SRB_FXDISC_REQ_DMA_VALID)
 			dma_unmap_sg(&ha->pdev->dev,
@@ -119,6 +122,8 @@
 qla24xx_proc_fcp_prio_cfg_cmd(struct fc_bsg_job *bsg_job)
 {
 	struct Scsi_Host *host = bsg_job->shost;
+	struct fc_bsg_request *bsg_request = bsg_job->request;
+	struct fc_bsg_reply *bsg_reply = bsg_job->reply;
 	scsi_qla_host_t *vha = shost_priv(host);
 	struct qla_hw_data *ha = vha->hw;
 	int ret = 0;
@@ -131,7 +136,7 @@
 	}
 
 	/* Get the sub command */
-	oper = bsg_job->request->rqst_data.h_vendor.vendor_cmd[1];
+	oper = bsg_request->rqst_data.h_vendor.vendor_cmd[1];
 
 	/* Only set config is allowed if config memory is not allocated */
 	if (!ha->fcp_prio_cfg && (oper != QLFC_FCP_PRIO_SET_CONFIG)) {
@@ -145,10 +150,10 @@
 			ha->fcp_prio_cfg->attributes &=
 				~FCP_PRIO_ATTR_ENABLE;
 			qla24xx_update_all_fcp_prio(vha);
-			bsg_job->reply->result = DID_OK;
+			bsg_reply->result = DID_OK;
 		} else {
 			ret = -EINVAL;
-			bsg_job->reply->result = (DID_ERROR << 16);
+			bsg_reply->result = (DID_ERROR << 16);
 			goto exit_fcp_prio_cfg;
 		}
 		break;
@@ -160,10 +165,10 @@
 				ha->fcp_prio_cfg->attributes |=
 				    FCP_PRIO_ATTR_ENABLE;
 				qla24xx_update_all_fcp_prio(vha);
-				bsg_job->reply->result = DID_OK;
+				bsg_reply->result = DID_OK;
 			} else {
 				ret = -EINVAL;
-				bsg_job->reply->result = (DID_ERROR << 16);
+				bsg_reply->result = (DID_ERROR << 16);
 				goto exit_fcp_prio_cfg;
 			}
 		}
@@ -173,12 +178,12 @@
 		len = bsg_job->reply_payload.payload_len;
 		if (!len || len > FCP_PRIO_CFG_SIZE) {
 			ret = -EINVAL;
-			bsg_job->reply->result = (DID_ERROR << 16);
+			bsg_reply->result = (DID_ERROR << 16);
 			goto exit_fcp_prio_cfg;
 		}
 
-		bsg_job->reply->result = DID_OK;
-		bsg_job->reply->reply_payload_rcv_len =
+		bsg_reply->result = DID_OK;
+		bsg_reply->reply_payload_rcv_len =
 			sg_copy_from_buffer(
 			bsg_job->reply_payload.sg_list,
 			bsg_job->reply_payload.sg_cnt, ha->fcp_prio_cfg,
@@ -189,7 +194,7 @@
 	case QLFC_FCP_PRIO_SET_CONFIG:
 		len = bsg_job->request_payload.payload_len;
 		if (!len || len > FCP_PRIO_CFG_SIZE) {
-			bsg_job->reply->result = (DID_ERROR << 16);
+			bsg_reply->result = (DID_ERROR << 16);
 			ret = -EINVAL;
 			goto exit_fcp_prio_cfg;
 		}
@@ -200,7 +205,7 @@
 				ql_log(ql_log_warn, vha, 0x7050,
 				    "Unable to allocate memory for fcp prio "
 				    "config data (%x).\n", FCP_PRIO_CFG_SIZE);
-				bsg_job->reply->result = (DID_ERROR << 16);
+				bsg_reply->result = (DID_ERROR << 16);
 				ret = -ENOMEM;
 				goto exit_fcp_prio_cfg;
 			}
@@ -215,7 +220,7 @@
 
 		if (!qla24xx_fcp_prio_cfg_valid(vha,
 		    (struct qla_fcp_prio_cfg *) ha->fcp_prio_cfg, 1)) {
-			bsg_job->reply->result = (DID_ERROR << 16);
+			bsg_reply->result = (DID_ERROR << 16);
 			ret = -EINVAL;
 			/* If buffer was invalidatic int
 			 * fcp_prio_cfg is of no use
@@ -229,7 +234,7 @@
 		if (ha->fcp_prio_cfg->attributes & FCP_PRIO_ATTR_ENABLE)
 			ha->flags.fcp_prio_enabled = 1;
 		qla24xx_update_all_fcp_prio(vha);
-		bsg_job->reply->result = DID_OK;
+		bsg_reply->result = DID_OK;
 		break;
 	default:
 		ret = -EINVAL;
@@ -244,6 +249,7 @@
 static int
 qla2x00_process_els(struct fc_bsg_job *bsg_job)
 {
+	struct fc_bsg_request *bsg_request = bsg_job->request;
 	struct fc_rport *rport;
 	fc_port_t *fcport = NULL;
 	struct Scsi_Host *host;
@@ -255,7 +261,7 @@
 	int rval =  (DRIVER_ERROR << 16);
 	uint16_t nextlid = 0;
 
-	if (bsg_job->request->msgcode == FC_BSG_RPT_ELS) {
+	if (bsg_request->msgcode == FC_BSG_RPT_ELS) {
 		rport = bsg_job->rport;
 		fcport = *(fc_port_t **) rport->dd_data;
 		host = rport_to_shost(rport);
@@ -296,7 +302,7 @@
 	}
 
 	/* ELS request for rport */
-	if (bsg_job->request->msgcode == FC_BSG_RPT_ELS) {
+	if (bsg_request->msgcode == FC_BSG_RPT_ELS) {
 		/* make sure the rport is logged in,
 		 * if not perform fabric login
 		 */
@@ -322,11 +328,11 @@
 		/* Initialize all required  fields of fcport */
 		fcport->vha = vha;
 		fcport->d_id.b.al_pa =
-			bsg_job->request->rqst_data.h_els.port_id[0];
+			bsg_request->rqst_data.h_els.port_id[0];
 		fcport->d_id.b.area =
-			bsg_job->request->rqst_data.h_els.port_id[1];
+			bsg_request->rqst_data.h_els.port_id[1];
 		fcport->d_id.b.domain =
-			bsg_job->request->rqst_data.h_els.port_id[2];
+			bsg_request->rqst_data.h_els.port_id[2];
 		fcport->loop_id =
 			(fcport->d_id.b.al_pa == 0xFD) ?
 			NPH_FABRIC_CONTROLLER : NPH_F_PORT;
@@ -366,11 +372,11 @@
 	}
 
 	sp->type =
-		(bsg_job->request->msgcode == FC_BSG_RPT_ELS ?
-		SRB_ELS_CMD_RPT : SRB_ELS_CMD_HST);
+		(bsg_request->msgcode == FC_BSG_RPT_ELS ?
+		 SRB_ELS_CMD_RPT : SRB_ELS_CMD_HST);
 	sp->name =
-		(bsg_job->request->msgcode == FC_BSG_RPT_ELS ?
-		"bsg_els_rpt" : "bsg_els_hst");
+		(bsg_request->msgcode == FC_BSG_RPT_ELS ?
+		 "bsg_els_rpt" : "bsg_els_hst");
 	sp->u.bsg_job = bsg_job;
 	sp->free = qla2x00_bsg_sp_free;
 	sp->done = qla2x00_bsg_job_done;
@@ -378,7 +384,7 @@
 	ql_dbg(ql_dbg_user, vha, 0x700a,
 	    "bsg rqst type: %s els type: %x - loop-id=%x "
 	    "portid=%-2x%02x%02x.\n", type,
-	    bsg_job->request->rqst_data.h_els.command_code, fcport->loop_id,
+	    bsg_request->rqst_data.h_els.command_code, fcport->loop_id,
 	    fcport->d_id.b.domain, fcport->d_id.b.area, fcport->d_id.b.al_pa);
 
 	rval = qla2x00_start_sp(sp);
@@ -399,7 +405,7 @@
 	goto done_free_fcport;
 
 done_free_fcport:
-	if (bsg_job->request->msgcode == FC_BSG_RPT_ELS)
+	if (bsg_request->msgcode == FC_BSG_RPT_ELS)
 		kfree(fcport);
 done:
 	return rval;
@@ -423,6 +429,7 @@
 qla2x00_process_ct(struct fc_bsg_job *bsg_job)
 {
 	srb_t *sp;
+	struct fc_bsg_request *bsg_request = bsg_job->request;
 	struct Scsi_Host *host = bsg_job->shost;
 	scsi_qla_host_t *vha = shost_priv(host);
 	struct qla_hw_data *ha = vha->hw;
@@ -469,7 +476,7 @@
 	}
 
 	loop_id =
-		(bsg_job->request->rqst_data.h_ct.preamble_word1 & 0xFF000000)
+		(bsg_request->rqst_data.h_ct.preamble_word1 & 0xFF000000)
 			>> 24;
 	switch (loop_id) {
 	case 0xFC:
@@ -500,9 +507,9 @@
 
 	/* Initialize all required  fields of fcport */
 	fcport->vha = vha;
-	fcport->d_id.b.al_pa = bsg_job->request->rqst_data.h_ct.port_id[0];
-	fcport->d_id.b.area = bsg_job->request->rqst_data.h_ct.port_id[1];
-	fcport->d_id.b.domain = bsg_job->request->rqst_data.h_ct.port_id[2];
+	fcport->d_id.b.al_pa = bsg_request->rqst_data.h_ct.port_id[0];
+	fcport->d_id.b.area = bsg_request->rqst_data.h_ct.port_id[1];
+	fcport->d_id.b.domain = bsg_request->rqst_data.h_ct.port_id[2];
 	fcport->loop_id = loop_id;
 
 	/* Alloc SRB structure */
@@ -524,7 +531,7 @@
 	ql_dbg(ql_dbg_user, vha, 0x7016,
 	    "bsg rqst type: %s else type: %x - "
 	    "loop-id=%x portid=%02x%02x%02x.\n", type,
-	    (bsg_job->request->rqst_data.h_ct.preamble_word2 >> 16),
+	    (bsg_request->rqst_data.h_ct.preamble_word2 >> 16),
 	    fcport->loop_id, fcport->d_id.b.domain, fcport->d_id.b.area,
 	    fcport->d_id.b.al_pa);
 
@@ -699,6 +706,8 @@
 static int
 qla2x00_process_loopback(struct fc_bsg_job *bsg_job)
 {
+	struct fc_bsg_request *bsg_request = bsg_job->request;
+	struct fc_bsg_reply *bsg_reply = bsg_job->reply;
 	struct Scsi_Host *host = bsg_job->shost;
 	scsi_qla_host_t *vha = shost_priv(host);
 	struct qla_hw_data *ha = vha->hw;
@@ -780,9 +789,9 @@
 	elreq.rcv_dma = rsp_data_dma;
 	elreq.transfer_size = req_data_len;
 
-	elreq.options = bsg_job->request->rqst_data.h_vendor.vendor_cmd[1];
+	elreq.options = bsg_request->rqst_data.h_vendor.vendor_cmd[1];
 	elreq.iteration_count =
-	    bsg_job->request->rqst_data.h_vendor.vendor_cmd[2];
+	    bsg_request->rqst_data.h_vendor.vendor_cmd[2];
 
 	if (atomic_read(&vha->loop_state) == LOOP_READY &&
 	    (ha->current_topology == ISP_CFG_F ||
@@ -896,12 +905,12 @@
 		    "Vendor request %s failed.\n", type);
 
 		rval = 0;
-		bsg_job->reply->result = (DID_ERROR << 16);
-		bsg_job->reply->reply_payload_rcv_len = 0;
+		bsg_reply->result = (DID_ERROR << 16);
+		bsg_reply->reply_payload_rcv_len = 0;
 	} else {
 		ql_dbg(ql_dbg_user, vha, 0x702d,
 		    "Vendor request %s completed.\n", type);
-		bsg_job->reply->result = (DID_OK << 16);
+		bsg_reply->result = (DID_OK << 16);
 		sg_copy_from_buffer(bsg_job->reply_payload.sg_list,
 			bsg_job->reply_payload.sg_cnt, rsp_data,
 			rsp_data_len);
@@ -937,7 +946,9 @@
 static int
 qla84xx_reset(struct fc_bsg_job *bsg_job)
 {
+	struct fc_bsg_request *bsg_request = bsg_job->request;
 	struct Scsi_Host *host = bsg_job->shost;
+	struct fc_bsg_reply *bsg_reply = bsg_job->reply;
 	scsi_qla_host_t *vha = shost_priv(host);
 	struct qla_hw_data *ha = vha->hw;
 	int rval = 0;
@@ -948,7 +959,7 @@
 		return -EINVAL;
 	}
 
-	flag = bsg_job->request->rqst_data.h_vendor.vendor_cmd[1];
+	flag = bsg_request->rqst_data.h_vendor.vendor_cmd[1];
 
 	rval = qla84xx_reset_chip(vha, flag == A84_ISSUE_RESET_DIAG_FW);
 
@@ -960,7 +971,7 @@
 	} else {
 		ql_dbg(ql_dbg_user, vha, 0x7031,
 		    "Vendor request 84xx reset completed.\n");
-		bsg_job->reply->result = DID_OK;
+		bsg_reply->result = DID_OK;
 		bsg_job->job_done(bsg_job);
 	}
 
@@ -970,6 +981,8 @@
 static int
 qla84xx_updatefw(struct fc_bsg_job *bsg_job)
 {
+	struct fc_bsg_request *bsg_request = bsg_job->request;
+	struct fc_bsg_reply *bsg_reply = bsg_job->reply;
 	struct Scsi_Host *host = bsg_job->shost;
 	scsi_qla_host_t *vha = shost_priv(host);
 	struct qla_hw_data *ha = vha->hw;
@@ -1027,7 +1040,7 @@
 		goto done_free_fw_buf;
 	}
 
-	flag = bsg_job->request->rqst_data.h_vendor.vendor_cmd[1];
+	flag = bsg_request->rqst_data.h_vendor.vendor_cmd[1];
 	fw_ver = le32_to_cpu(*((uint32_t *)((uint32_t *)fw_buf + 2)));
 
 	memset(mn, 0, sizeof(struct access_chip_84xx));
@@ -1059,7 +1072,7 @@
 		    "Vendor request 84xx updatefw completed.\n");
 
 		bsg_job->reply_len = sizeof(struct fc_bsg_reply);
-		bsg_job->reply->result = DID_OK;
+		bsg_reply->result = DID_OK;
 	}
 
 	dma_pool_free(ha->s_dma_pool, mn, mn_dma);
@@ -1079,6 +1092,8 @@
 static int
 qla84xx_mgmt_cmd(struct fc_bsg_job *bsg_job)
 {
+	struct fc_bsg_request *bsg_request = bsg_job->request;
+	struct fc_bsg_reply *bsg_reply = bsg_job->reply;
 	struct Scsi_Host *host = bsg_job->shost;
 	scsi_qla_host_t *vha = shost_priv(host);
 	struct qla_hw_data *ha = vha->hw;
@@ -1107,7 +1122,7 @@
 	memset(mn, 0, sizeof(struct access_chip_84xx));
 	mn->entry_type = ACCESS_CHIP_IOCB_TYPE;
 	mn->entry_count = 1;
-	ql84_mgmt = (void *)bsg_job->request + sizeof(struct fc_bsg_request);
+	ql84_mgmt = (void *)bsg_request + sizeof(struct fc_bsg_request);
 	switch (ql84_mgmt->mgmt.cmd) {
 	case QLA84_MGMT_READ_MEM:
 	case QLA84_MGMT_GET_INFO:
@@ -1239,11 +1254,11 @@
 		    "Vendor request 84xx mgmt completed.\n");
 
 		bsg_job->reply_len = sizeof(struct fc_bsg_reply);
-		bsg_job->reply->result = DID_OK;
+		bsg_reply->result = DID_OK;
 
 		if ((ql84_mgmt->mgmt.cmd == QLA84_MGMT_READ_MEM) ||
 			(ql84_mgmt->mgmt.cmd == QLA84_MGMT_GET_INFO)) {
-			bsg_job->reply->reply_payload_rcv_len =
+			bsg_reply->reply_payload_rcv_len =
 				bsg_job->reply_payload.payload_len;
 
 			sg_copy_from_buffer(bsg_job->reply_payload.sg_list,
@@ -1274,6 +1289,8 @@
 static int
 qla24xx_iidma(struct fc_bsg_job *bsg_job)
 {
+	struct fc_bsg_request *bsg_request = bsg_job->request;
+	struct fc_bsg_reply *bsg_reply = bsg_job->reply;
 	struct Scsi_Host *host = bsg_job->shost;
 	scsi_qla_host_t *vha = shost_priv(host);
 	int rval = 0;
@@ -1288,7 +1305,7 @@
 		return -EINVAL;
 	}
 
-	port_param = (void *)bsg_job->request + sizeof(struct fc_bsg_request);
+	port_param = (void *)bsg_request + sizeof(struct fc_bsg_request);
 	if (port_param->fc_scsi_addr.dest_type != EXT_DEF_TYPE_WWPN) {
 		ql_log(ql_log_warn, vha, 0x7048,
 		    "Invalid destination type.\n");
@@ -1343,14 +1360,14 @@
 			bsg_job->reply_len = sizeof(struct fc_bsg_reply) +
 				sizeof(struct qla_port_param);
 
-			rsp_ptr = ((uint8_t *)bsg_job->reply) +
+			rsp_ptr = ((uint8_t *)bsg_reply) +
 				sizeof(struct fc_bsg_reply);
 
 			memcpy(rsp_ptr, port_param,
 				sizeof(struct qla_port_param));
 		}
 
-		bsg_job->reply->result = DID_OK;
+		bsg_reply->result = DID_OK;
 		bsg_job->job_done(bsg_job);
 	}
 
@@ -1361,6 +1378,7 @@
 qla2x00_optrom_setup(struct fc_bsg_job *bsg_job, scsi_qla_host_t *vha,
 	uint8_t is_update)
 {
+	struct fc_bsg_request *bsg_request = bsg_job->request;
 	uint32_t start = 0;
 	int valid = 0;
 	struct qla_hw_data *ha = vha->hw;
@@ -1368,7 +1386,7 @@
 	if (unlikely(pci_channel_offline(ha->pdev)))
 		return -EINVAL;
 
-	start = bsg_job->request->rqst_data.h_vendor.vendor_cmd[1];
+	start = bsg_request->rqst_data.h_vendor.vendor_cmd[1];
 	if (start > ha->optrom_size) {
 		ql_log(ql_log_warn, vha, 0x7055,
 		    "start %d > optrom_size %d.\n", start, ha->optrom_size);
@@ -1429,6 +1447,7 @@
 static int
 qla2x00_read_optrom(struct fc_bsg_job *bsg_job)
 {
+	struct fc_bsg_reply *bsg_reply = bsg_job->reply;
 	struct Scsi_Host *host = bsg_job->shost;
 	scsi_qla_host_t *vha = shost_priv(host);
 	struct qla_hw_data *ha = vha->hw;
@@ -1451,8 +1470,8 @@
 	    bsg_job->reply_payload.sg_cnt, ha->optrom_buffer,
 	    ha->optrom_region_size);
 
-	bsg_job->reply->reply_payload_rcv_len = ha->optrom_region_size;
-	bsg_job->reply->result = DID_OK;
+	bsg_reply->reply_payload_rcv_len = ha->optrom_region_size;
+	bsg_reply->result = DID_OK;
 	vfree(ha->optrom_buffer);
 	ha->optrom_buffer = NULL;
 	ha->optrom_state = QLA_SWAITING;
@@ -1464,6 +1483,7 @@
 static int
 qla2x00_update_optrom(struct fc_bsg_job *bsg_job)
 {
+	struct fc_bsg_reply *bsg_reply = bsg_job->reply;
 	struct Scsi_Host *host = bsg_job->shost;
 	scsi_qla_host_t *vha = shost_priv(host);
 	struct qla_hw_data *ha = vha->hw;
@@ -1486,7 +1506,7 @@
 	ha->isp_ops->write_optrom(vha, ha->optrom_buffer,
 	    ha->optrom_region_start, ha->optrom_region_size);
 
-	bsg_job->reply->result = DID_OK;
+	bsg_reply->result = DID_OK;
 	vfree(ha->optrom_buffer);
 	ha->optrom_buffer = NULL;
 	ha->optrom_state = QLA_SWAITING;
@@ -1498,6 +1518,7 @@
 static int
 qla2x00_update_fru_versions(struct fc_bsg_job *bsg_job)
 {
+	struct fc_bsg_reply *bsg_reply = bsg_job->reply;
 	struct Scsi_Host *host = bsg_job->shost;
 	scsi_qla_host_t *vha = shost_priv(host);
 	struct qla_hw_data *ha = vha->hw;
@@ -1509,7 +1530,7 @@
 	dma_addr_t sfp_dma;
 	void *sfp = dma_pool_alloc(ha->s_dma_pool, GFP_KERNEL, &sfp_dma);
 	if (!sfp) {
-		bsg_job->reply->reply_data.vendor_reply.vendor_rsp[0] =
+		bsg_reply->reply_data.vendor_reply.vendor_rsp[0] =
 		    EXT_STATUS_NO_MEMORY;
 		goto done;
 	}
@@ -1525,21 +1546,21 @@
 		    image->field_address.device, image->field_address.offset,
 		    sizeof(image->field_info), image->field_address.option);
 		if (rval) {
-			bsg_job->reply->reply_data.vendor_reply.vendor_rsp[0] =
+			bsg_reply->reply_data.vendor_reply.vendor_rsp[0] =
 			    EXT_STATUS_MAILBOX;
 			goto dealloc;
 		}
 		image++;
 	}
 
-	bsg_job->reply->reply_data.vendor_reply.vendor_rsp[0] = 0;
+	bsg_reply->reply_data.vendor_reply.vendor_rsp[0] = 0;
 
 dealloc:
 	dma_pool_free(ha->s_dma_pool, sfp, sfp_dma);
 
 done:
 	bsg_job->reply_len = sizeof(struct fc_bsg_reply);
-	bsg_job->reply->result = DID_OK << 16;
+	bsg_reply->result = DID_OK << 16;
 	bsg_job->job_done(bsg_job);
 
 	return 0;
@@ -1548,6 +1569,7 @@
 static int
 qla2x00_read_fru_status(struct fc_bsg_job *bsg_job)
 {
+	struct fc_bsg_reply *bsg_reply = bsg_job->reply;
 	struct Scsi_Host *host = bsg_job->shost;
 	scsi_qla_host_t *vha = shost_priv(host);
 	struct qla_hw_data *ha = vha->hw;
@@ -1557,7 +1579,7 @@
 	dma_addr_t sfp_dma;
 	uint8_t *sfp = dma_pool_alloc(ha->s_dma_pool, GFP_KERNEL, &sfp_dma);
 	if (!sfp) {
-		bsg_job->reply->reply_data.vendor_reply.vendor_rsp[0] =
+		bsg_reply->reply_data.vendor_reply.vendor_rsp[0] =
 		    EXT_STATUS_NO_MEMORY;
 		goto done;
 	}
@@ -1571,7 +1593,7 @@
 	sr->status_reg = *sfp;
 
 	if (rval) {
-		bsg_job->reply->reply_data.vendor_reply.vendor_rsp[0] =
+		bsg_reply->reply_data.vendor_reply.vendor_rsp[0] =
 		    EXT_STATUS_MAILBOX;
 		goto dealloc;
 	}
@@ -1579,15 +1601,15 @@
 	sg_copy_from_buffer(bsg_job->reply_payload.sg_list,
 	    bsg_job->reply_payload.sg_cnt, sr, sizeof(*sr));
 
-	bsg_job->reply->reply_data.vendor_reply.vendor_rsp[0] = 0;
+	bsg_reply->reply_data.vendor_reply.vendor_rsp[0] = 0;
 
 dealloc:
 	dma_pool_free(ha->s_dma_pool, sfp, sfp_dma);
 
 done:
 	bsg_job->reply_len = sizeof(struct fc_bsg_reply);
-	bsg_job->reply->reply_payload_rcv_len = sizeof(*sr);
-	bsg_job->reply->result = DID_OK << 16;
+	bsg_reply->reply_payload_rcv_len = sizeof(*sr);
+	bsg_reply->result = DID_OK << 16;
 	bsg_job->job_done(bsg_job);
 
 	return 0;
@@ -1596,6 +1618,7 @@
 static int
 qla2x00_write_fru_status(struct fc_bsg_job *bsg_job)
 {
+	struct fc_bsg_reply *bsg_reply = bsg_job->reply;
 	struct Scsi_Host *host = bsg_job->shost;
 	scsi_qla_host_t *vha = shost_priv(host);
 	struct qla_hw_data *ha = vha->hw;
@@ -1605,7 +1628,7 @@
 	dma_addr_t sfp_dma;
 	uint8_t *sfp = dma_pool_alloc(ha->s_dma_pool, GFP_KERNEL, &sfp_dma);
 	if (!sfp) {
-		bsg_job->reply->reply_data.vendor_reply.vendor_rsp[0] =
+		bsg_reply->reply_data.vendor_reply.vendor_rsp[0] =
 		    EXT_STATUS_NO_MEMORY;
 		goto done;
 	}
@@ -1619,19 +1642,19 @@
 	    sizeof(sr->status_reg), sr->field_address.option);
 
 	if (rval) {
-		bsg_job->reply->reply_data.vendor_reply.vendor_rsp[0] =
+		bsg_reply->reply_data.vendor_reply.vendor_rsp[0] =
 		    EXT_STATUS_MAILBOX;
 		goto dealloc;
 	}
 
-	bsg_job->reply->reply_data.vendor_reply.vendor_rsp[0] = 0;
+	bsg_reply->reply_data.vendor_reply.vendor_rsp[0] = 0;
 
 dealloc:
 	dma_pool_free(ha->s_dma_pool, sfp, sfp_dma);
 
 done:
 	bsg_job->reply_len = sizeof(struct fc_bsg_reply);
-	bsg_job->reply->result = DID_OK << 16;
+	bsg_reply->result = DID_OK << 16;
 	bsg_job->job_done(bsg_job);
 
 	return 0;
@@ -1640,6 +1663,7 @@
 static int
 qla2x00_write_i2c(struct fc_bsg_job *bsg_job)
 {
+	struct fc_bsg_reply *bsg_reply = bsg_job->reply;
 	struct Scsi_Host *host = bsg_job->shost;
 	scsi_qla_host_t *vha = shost_priv(host);
 	struct qla_hw_data *ha = vha->hw;
@@ -1649,7 +1673,7 @@
 	dma_addr_t sfp_dma;
 	uint8_t *sfp = dma_pool_alloc(ha->s_dma_pool, GFP_KERNEL, &sfp_dma);
 	if (!sfp) {
-		bsg_job->reply->reply_data.vendor_reply.vendor_rsp[0] =
+		bsg_reply->reply_data.vendor_reply.vendor_rsp[0] =
 		    EXT_STATUS_NO_MEMORY;
 		goto done;
 	}
@@ -1662,19 +1686,19 @@
 	    i2c->device, i2c->offset, i2c->length, i2c->option);
 
 	if (rval) {
-		bsg_job->reply->reply_data.vendor_reply.vendor_rsp[0] =
+		bsg_reply->reply_data.vendor_reply.vendor_rsp[0] =
 		    EXT_STATUS_MAILBOX;
 		goto dealloc;
 	}
 
-	bsg_job->reply->reply_data.vendor_reply.vendor_rsp[0] = 0;
+	bsg_reply->reply_data.vendor_reply.vendor_rsp[0] = 0;
 
 dealloc:
 	dma_pool_free(ha->s_dma_pool, sfp, sfp_dma);
 
 done:
 	bsg_job->reply_len = sizeof(struct fc_bsg_reply);
-	bsg_job->reply->result = DID_OK << 16;
+	bsg_reply->result = DID_OK << 16;
 	bsg_job->job_done(bsg_job);
 
 	return 0;
@@ -1683,6 +1707,7 @@
 static int
 qla2x00_read_i2c(struct fc_bsg_job *bsg_job)
 {
+	struct fc_bsg_reply *bsg_reply = bsg_job->reply;
 	struct Scsi_Host *host = bsg_job->shost;
 	scsi_qla_host_t *vha = shost_priv(host);
 	struct qla_hw_data *ha = vha->hw;
@@ -1692,7 +1717,7 @@
 	dma_addr_t sfp_dma;
 	uint8_t *sfp = dma_pool_alloc(ha->s_dma_pool, GFP_KERNEL, &sfp_dma);
 	if (!sfp) {
-		bsg_job->reply->reply_data.vendor_reply.vendor_rsp[0] =
+		bsg_reply->reply_data.vendor_reply.vendor_rsp[0] =
 		    EXT_STATUS_NO_MEMORY;
 		goto done;
 	}
@@ -1704,7 +1729,7 @@
 		i2c->device, i2c->offset, i2c->length, i2c->option);
 
 	if (rval) {
-		bsg_job->reply->reply_data.vendor_reply.vendor_rsp[0] =
+		bsg_reply->reply_data.vendor_reply.vendor_rsp[0] =
 		    EXT_STATUS_MAILBOX;
 		goto dealloc;
 	}
@@ -1713,15 +1738,15 @@
 	sg_copy_from_buffer(bsg_job->reply_payload.sg_list,
 	    bsg_job->reply_payload.sg_cnt, i2c, sizeof(*i2c));
 
-	bsg_job->reply->reply_data.vendor_reply.vendor_rsp[0] = 0;
+	bsg_reply->reply_data.vendor_reply.vendor_rsp[0] = 0;
 
 dealloc:
 	dma_pool_free(ha->s_dma_pool, sfp, sfp_dma);
 
 done:
 	bsg_job->reply_len = sizeof(struct fc_bsg_reply);
-	bsg_job->reply->reply_payload_rcv_len = sizeof(*i2c);
-	bsg_job->reply->result = DID_OK << 16;
+	bsg_reply->reply_payload_rcv_len = sizeof(*i2c);
+	bsg_reply->result = DID_OK << 16;
 	bsg_job->job_done(bsg_job);
 
 	return 0;
@@ -1730,6 +1755,7 @@
 static int
 qla24xx_process_bidir_cmd(struct fc_bsg_job *bsg_job)
 {
+	struct fc_bsg_reply *bsg_reply = bsg_job->reply;
 	struct Scsi_Host *host = bsg_job->shost;
 	scsi_qla_host_t *vha = shost_priv(host);
 	struct qla_hw_data *ha = vha->hw;
@@ -1895,10 +1921,10 @@
 	/* Return an error vendor specific response
 	 * and complete the bsg request
 	 */
-	bsg_job->reply->reply_data.vendor_reply.vendor_rsp[0] = rval;
+	bsg_reply->reply_data.vendor_reply.vendor_rsp[0] = rval;
 	bsg_job->reply_len = sizeof(struct fc_bsg_reply);
-	bsg_job->reply->reply_payload_rcv_len = 0;
-	bsg_job->reply->result = (DID_OK) << 16;
+	bsg_reply->reply_payload_rcv_len = 0;
+	bsg_reply->result = (DID_OK) << 16;
 	bsg_job->job_done(bsg_job);
 	/* Always return success, vendor rsp carries correct status */
 	return 0;
@@ -1907,6 +1933,7 @@
 static int
 qlafx00_mgmt_cmd(struct fc_bsg_job *bsg_job)
 {
+	struct fc_bsg_request *bsg_request = bsg_job->request;
 	struct Scsi_Host *host = bsg_job->shost;
 	scsi_qla_host_t *vha = shost_priv(host);
 	struct qla_hw_data *ha = vha->hw;
@@ -1919,7 +1946,7 @@
 
 	/* Copy the IOCB specific information */
 	piocb_rqst = (struct qla_mt_iocb_rqst_fx00 *)
-	    &bsg_job->request->rqst_data.h_vendor.vendor_cmd[1];
+	    &bsg_request->rqst_data.h_vendor.vendor_cmd[1];
 
 	/* Dump the vendor information */
 	ql_dump_buffer(ql_dbg_user + ql_dbg_verbose , vha, 0x70cf,
@@ -2029,6 +2056,7 @@
 static int
 qla26xx_serdes_op(struct fc_bsg_job *bsg_job)
 {
+	struct fc_bsg_reply *bsg_reply = bsg_job->reply;
 	struct Scsi_Host *host = bsg_job->shost;
 	scsi_qla_host_t *vha = shost_priv(host);
 	int rval = 0;
@@ -2042,13 +2070,13 @@
 	switch (sr.cmd) {
 	case INT_SC_SERDES_WRITE_REG:
 		rval = qla2x00_write_serdes_word(vha, sr.addr, sr.val);
-		bsg_job->reply->reply_payload_rcv_len = 0;
+		bsg_reply->reply_payload_rcv_len = 0;
 		break;
 	case INT_SC_SERDES_READ_REG:
 		rval = qla2x00_read_serdes_word(vha, sr.addr, &sr.val);
 		sg_copy_from_buffer(bsg_job->reply_payload.sg_list,
 		    bsg_job->reply_payload.sg_cnt, &sr, sizeof(sr));
-		bsg_job->reply->reply_payload_rcv_len = sizeof(sr);
+		bsg_reply->reply_payload_rcv_len = sizeof(sr);
 		break;
 	default:
 		ql_dbg(ql_dbg_user, vha, 0x708c,
@@ -2057,11 +2085,11 @@
 		break;
 	}
 
-	bsg_job->reply->reply_data.vendor_reply.vendor_rsp[0] =
+	bsg_reply->reply_data.vendor_reply.vendor_rsp[0] =
 	    rval ? EXT_STATUS_MAILBOX : 0;
 
 	bsg_job->reply_len = sizeof(struct fc_bsg_reply);
-	bsg_job->reply->result = DID_OK << 16;
+	bsg_reply->result = DID_OK << 16;
 	bsg_job->job_done(bsg_job);
 	return 0;
 }
@@ -2069,6 +2097,7 @@
 static int
 qla8044_serdes_op(struct fc_bsg_job *bsg_job)
 {
+	struct fc_bsg_reply *bsg_reply = bsg_job->reply;
 	struct Scsi_Host *host = bsg_job->shost;
 	scsi_qla_host_t *vha = shost_priv(host);
 	int rval = 0;
@@ -2082,13 +2111,13 @@
 	switch (sr.cmd) {
 	case INT_SC_SERDES_WRITE_REG:
 		rval = qla8044_write_serdes_word(vha, sr.addr, sr.val);
-		bsg_job->reply->reply_payload_rcv_len = 0;
+		bsg_reply->reply_payload_rcv_len = 0;
 		break;
 	case INT_SC_SERDES_READ_REG:
 		rval = qla8044_read_serdes_word(vha, sr.addr, &sr.val);
 		sg_copy_from_buffer(bsg_job->reply_payload.sg_list,
 		    bsg_job->reply_payload.sg_cnt, &sr, sizeof(sr));
-		bsg_job->reply->reply_payload_rcv_len = sizeof(sr);
+		bsg_reply->reply_payload_rcv_len = sizeof(sr);
 		break;
 	default:
 		ql_dbg(ql_dbg_user, vha, 0x70cf,
@@ -2097,11 +2126,11 @@
 		break;
 	}
 
-	bsg_job->reply->reply_data.vendor_reply.vendor_rsp[0] =
+	bsg_reply->reply_data.vendor_reply.vendor_rsp[0] =
 	    rval ? EXT_STATUS_MAILBOX : 0;
 
 	bsg_job->reply_len = sizeof(struct fc_bsg_reply);
-	bsg_job->reply->result = DID_OK << 16;
+	bsg_reply->result = DID_OK << 16;
 	bsg_job->job_done(bsg_job);
 	return 0;
 }
@@ -2109,6 +2138,7 @@
 static int
 qla27xx_get_flash_upd_cap(struct fc_bsg_job *bsg_job)
 {
+	struct fc_bsg_reply *bsg_reply = bsg_job->reply;
 	struct Scsi_Host *host = bsg_job->shost;
 	scsi_qla_host_t *vha = shost_priv(host);
 	struct qla_hw_data *ha = vha->hw;
@@ -2125,13 +2155,13 @@
 
 	sg_copy_from_buffer(bsg_job->reply_payload.sg_list,
 	    bsg_job->reply_payload.sg_cnt, &cap, sizeof(cap));
-	bsg_job->reply->reply_payload_rcv_len = sizeof(cap);
+	bsg_reply->reply_payload_rcv_len = sizeof(cap);
 
-	bsg_job->reply->reply_data.vendor_reply.vendor_rsp[0] =
+	bsg_reply->reply_data.vendor_reply.vendor_rsp[0] =
 	    EXT_STATUS_OK;
 
 	bsg_job->reply_len = sizeof(struct fc_bsg_reply);
-	bsg_job->reply->result = DID_OK << 16;
+	bsg_reply->result = DID_OK << 16;
 	bsg_job->job_done(bsg_job);
 	return 0;
 }
@@ -2139,6 +2169,7 @@
 static int
 qla27xx_set_flash_upd_cap(struct fc_bsg_job *bsg_job)
 {
+	struct fc_bsg_reply *bsg_reply = bsg_job->reply;
 	struct Scsi_Host *host = bsg_job->shost;
 	scsi_qla_host_t *vha = shost_priv(host);
 	struct qla_hw_data *ha = vha->hw;
@@ -2158,24 +2189,24 @@
 			 (uint64_t)ha->fw_attributes;
 
 	if (online_fw_attr != cap.capabilities) {
-		bsg_job->reply->reply_data.vendor_reply.vendor_rsp[0] =
+		bsg_reply->reply_data.vendor_reply.vendor_rsp[0] =
 		    EXT_STATUS_INVALID_PARAM;
 		return -EINVAL;
 	}
 
 	if (cap.outage_duration < MAX_LOOP_TIMEOUT)  {
-		bsg_job->reply->reply_data.vendor_reply.vendor_rsp[0] =
+		bsg_reply->reply_data.vendor_reply.vendor_rsp[0] =
 		    EXT_STATUS_INVALID_PARAM;
 		return -EINVAL;
 	}
 
-	bsg_job->reply->reply_payload_rcv_len = 0;
+	bsg_reply->reply_payload_rcv_len = 0;
 
-	bsg_job->reply->reply_data.vendor_reply.vendor_rsp[0] =
+	bsg_reply->reply_data.vendor_reply.vendor_rsp[0] =
 	    EXT_STATUS_OK;
 
 	bsg_job->reply_len = sizeof(struct fc_bsg_reply);
-	bsg_job->reply->result = DID_OK << 16;
+	bsg_reply->result = DID_OK << 16;
 	bsg_job->job_done(bsg_job);
 	return 0;
 }
@@ -2183,6 +2214,7 @@
 static int
 qla27xx_get_bbcr_data(struct fc_bsg_job *bsg_job)
 {
+	struct fc_bsg_reply *bsg_reply = bsg_job->reply;
 	struct Scsi_Host *host = bsg_job->shost;
 	scsi_qla_host_t *vha = shost_priv(host);
 	struct qla_hw_data *ha = vha->hw;
@@ -2227,12 +2259,12 @@
 done:
 	sg_copy_from_buffer(bsg_job->reply_payload.sg_list,
 		bsg_job->reply_payload.sg_cnt, &bbcr, sizeof(bbcr));
-	bsg_job->reply->reply_payload_rcv_len = sizeof(bbcr);
+	bsg_reply->reply_payload_rcv_len = sizeof(bbcr);
 
-	bsg_job->reply->reply_data.vendor_reply.vendor_rsp[0] = EXT_STATUS_OK;
+	bsg_reply->reply_data.vendor_reply.vendor_rsp[0] = EXT_STATUS_OK;
 
 	bsg_job->reply_len = sizeof(struct fc_bsg_reply);
-	bsg_job->reply->result = DID_OK << 16;
+	bsg_reply->result = DID_OK << 16;
 	bsg_job->job_done(bsg_job);
 	return 0;
 }
@@ -2240,6 +2272,8 @@
 static int
 qla2x00_get_priv_stats(struct fc_bsg_job *bsg_job)
 {
+	struct fc_bsg_request *bsg_request = bsg_job->request;
+	struct fc_bsg_reply *bsg_reply = bsg_job->reply;
 	struct Scsi_Host *host = bsg_job->shost;
 	scsi_qla_host_t *vha = shost_priv(host);
 	struct qla_hw_data *ha = vha->hw;
@@ -2247,7 +2281,7 @@
 	struct link_statistics *stats = NULL;
 	dma_addr_t stats_dma;
 	int rval;
-	uint32_t *cmd = bsg_job->request->rqst_data.h_vendor.vendor_cmd;
+	uint32_t *cmd = bsg_request->rqst_data.h_vendor.vendor_cmd;
 	uint options = cmd[0] == QL_VND_GET_PRIV_STATS_EX ? cmd[1] : 0;
 
 	if (test_bit(UNLOADING, &vha->dpc_flags))
@@ -2281,12 +2315,12 @@
 			bsg_job->reply_payload.sg_cnt, stats, sizeof(*stats));
 	}
 
-	bsg_job->reply->reply_payload_rcv_len = sizeof(*stats);
-	bsg_job->reply->reply_data.vendor_reply.vendor_rsp[0] =
+	bsg_reply->reply_payload_rcv_len = sizeof(*stats);
+	bsg_reply->reply_data.vendor_reply.vendor_rsp[0] =
 	    rval ? EXT_STATUS_MAILBOX : EXT_STATUS_OK;
 
-	bsg_job->reply_len = sizeof(*bsg_job->reply);
-	bsg_job->reply->result = DID_OK << 16;
+	bsg_job->reply_len = sizeof(*bsg_reply);
+	bsg_reply->result = DID_OK << 16;
 	bsg_job->job_done(bsg_job);
 
 	dma_free_coherent(&ha->pdev->dev, sizeof(*stats),
@@ -2298,6 +2332,7 @@
 static int
 qla2x00_do_dport_diagnostics(struct fc_bsg_job *bsg_job)
 {
+	struct fc_bsg_reply *bsg_reply = bsg_job->reply;
 	struct Scsi_Host *host = bsg_job->shost;
 	scsi_qla_host_t *vha = shost_priv(host);
 	int rval;
@@ -2323,12 +2358,12 @@
 		    bsg_job->reply_payload.sg_cnt, dd, sizeof(*dd));
 	}
 
-	bsg_job->reply->reply_payload_rcv_len = sizeof(*dd);
-	bsg_job->reply->reply_data.vendor_reply.vendor_rsp[0] =
+	bsg_reply->reply_payload_rcv_len = sizeof(*dd);
+	bsg_reply->reply_data.vendor_reply.vendor_rsp[0] =
 	    rval ? EXT_STATUS_MAILBOX : EXT_STATUS_OK;
 
-	bsg_job->reply_len = sizeof(*bsg_job->reply);
-	bsg_job->reply->result = DID_OK << 16;
+	bsg_job->reply_len = sizeof(*bsg_reply);
+	bsg_reply->result = DID_OK << 16;
 	bsg_job->job_done(bsg_job);
 
 	kfree(dd);
@@ -2339,7 +2374,9 @@
 static int
 qla2x00_process_vendor_specific(struct fc_bsg_job *bsg_job)
 {
-	switch (bsg_job->request->rqst_data.h_vendor.vendor_cmd[0]) {
+	struct fc_bsg_request *bsg_request = bsg_job->request;
+
+	switch (bsg_request->rqst_data.h_vendor.vendor_cmd[0]) {
 	case QL_VND_LOOPBACK:
 		return qla2x00_process_loopback(bsg_job);
 
@@ -2415,15 +2452,17 @@
 int
 qla24xx_bsg_request(struct fc_bsg_job *bsg_job)
 {
+	struct fc_bsg_request *bsg_request = bsg_job->request;
+	struct fc_bsg_reply *bsg_reply = bsg_job->reply;
 	int ret = -EINVAL;
 	struct fc_rport *rport;
 	struct Scsi_Host *host;
 	scsi_qla_host_t *vha;
 
 	/* In case no data transferred. */
-	bsg_job->reply->reply_payload_rcv_len = 0;
+	bsg_reply->reply_payload_rcv_len = 0;
 
-	if (bsg_job->request->msgcode == FC_BSG_RPT_ELS) {
+	if (bsg_request->msgcode == FC_BSG_RPT_ELS) {
 		rport = bsg_job->rport;
 		host = rport_to_shost(rport);
 		vha = shost_priv(host);
@@ -2435,14 +2474,14 @@
 	if (qla2x00_reset_active(vha)) {
 		ql_dbg(ql_dbg_user, vha, 0x709f,
 		    "BSG: ISP abort active/needed -- cmd=%d.\n",
-		    bsg_job->request->msgcode);
+		    bsg_request->msgcode);
 		return -EBUSY;
 	}
 
 	ql_dbg(ql_dbg_user, vha, 0x7000,
-	    "Entered %s msgcode=0x%x.\n", __func__, bsg_job->request->msgcode);
+	    "Entered %s msgcode=0x%x.\n", __func__, bsg_request->msgcode);
 
-	switch (bsg_job->request->msgcode) {
+	switch (bsg_request->msgcode) {
 	case FC_BSG_RPT_ELS:
 	case FC_BSG_HST_ELS_NOLOGIN:
 		ret = qla2x00_process_els(bsg_job);
@@ -2466,6 +2505,7 @@
 int
 qla24xx_bsg_timeout(struct fc_bsg_job *bsg_job)
 {
+	struct fc_bsg_reply *bsg_reply = bsg_job->reply;
 	scsi_qla_host_t *vha = shost_priv(bsg_job->shost);
 	struct qla_hw_data *ha = vha->hw;
 	srb_t *sp;
@@ -2494,13 +2534,13 @@
 						    "mbx abort_command "
 						    "failed.\n");
 						bsg_job->req->errors =
-						bsg_job->reply->result = -EIO;
+						bsg_reply->result = -EIO;
 					} else {
 						ql_dbg(ql_dbg_user, vha, 0x708a,
 						    "mbx abort_command "
 						    "success.\n");
 						bsg_job->req->errors =
-						bsg_job->reply->result = 0;
+						bsg_reply->result = 0;
 					}
 					spin_lock_irqsave(&ha->hardware_lock, flags);
 					goto done;
@@ -2510,7 +2550,7 @@
 	}
 	spin_unlock_irqrestore(&ha->hardware_lock, flags);
 	ql_log(ql_log_info, vha, 0x708b, "SRB not found to abort.\n");
-	bsg_job->req->errors = bsg_job->reply->result = -ENXIO;
+	bsg_job->req->errors = bsg_reply->result = -ENXIO;
 	return 0;
 
 done:
diff --git a/drivers/scsi/qla2xxx/qla_iocb.c b/drivers/scsi/qla2xxx/qla_iocb.c
index b41265a..6929fda 100644
--- a/drivers/scsi/qla2xxx/qla_iocb.c
+++ b/drivers/scsi/qla2xxx/qla_iocb.c
@@ -2198,6 +2198,7 @@ static void qla25xx_set_que(srb_t *sp, struct rsp_que **rsp)
 qla24xx_els_iocb(srb_t *sp, struct els_entry_24xx *els_iocb)
 {
 	struct fc_bsg_job *bsg_job = sp->u.bsg_job;
+	struct fc_bsg_request *bsg_request = bsg_job->request;
 
         els_iocb->entry_type = ELS_IOCB_TYPE;
         els_iocb->entry_count = 1;
@@ -2212,8 +2213,8 @@ static void qla25xx_set_que(srb_t *sp, struct rsp_que **rsp)
 
 	els_iocb->opcode =
 	    sp->type == SRB_ELS_CMD_RPT ?
-	    bsg_job->request->rqst_data.r_els.els_code :
-	    bsg_job->request->rqst_data.h_els.command_code;
+	    bsg_request->rqst_data.r_els.els_code :
+	    bsg_request->rqst_data.h_els.command_code;
         els_iocb->port_id[0] = sp->fcport->d_id.b.al_pa;
         els_iocb->port_id[1] = sp->fcport->d_id.b.area;
         els_iocb->port_id[2] = sp->fcport->d_id.b.domain;
diff --git a/drivers/scsi/qla2xxx/qla_isr.c b/drivers/scsi/qla2xxx/qla_isr.c
index 068c4e4..d83e083 100644
--- a/drivers/scsi/qla2xxx/qla_isr.c
+++ b/drivers/scsi/qla2xxx/qla_isr.c
@@ -1357,6 +1357,7 @@ static void qla_irq_affinity_notify(struct irq_affinity_notify *,
 	const char *type;
 	srb_t *sp;
 	struct fc_bsg_job *bsg_job;
+	struct fc_bsg_reply *bsg_reply;
 	uint16_t comp_status;
 	int res;
 
@@ -1365,6 +1366,7 @@ static void qla_irq_affinity_notify(struct irq_affinity_notify *,
 		return;
 
 	bsg_job = sp->u.bsg_job;
+	bsg_reply = bsg_job->reply;
 
 	type = "ct pass-through";
 
@@ -1373,32 +1375,32 @@ static void qla_irq_affinity_notify(struct irq_affinity_notify *,
 	/* return FC_CTELS_STATUS_OK and leave the decoding of the ELS/CT
 	 * fc payload  to the caller
 	 */
-	bsg_job->reply->reply_data.ctels_reply.status = FC_CTELS_STATUS_OK;
+	bsg_reply->reply_data.ctels_reply.status = FC_CTELS_STATUS_OK;
 	bsg_job->reply_len = sizeof(struct fc_bsg_reply);
 
 	if (comp_status != CS_COMPLETE) {
 		if (comp_status == CS_DATA_UNDERRUN) {
 			res = DID_OK << 16;
-			bsg_job->reply->reply_payload_rcv_len =
+			bsg_reply->reply_payload_rcv_len =
 			    le16_to_cpu(((sts_entry_t *)pkt)->rsp_info_len);
 
 			ql_log(ql_log_warn, vha, 0x5048,
 			    "CT pass-through-%s error "
 			    "comp_status-status=0x%x total_byte = 0x%x.\n",
 			    type, comp_status,
-			    bsg_job->reply->reply_payload_rcv_len);
+			    bsg_reply->reply_payload_rcv_len);
 		} else {
 			ql_log(ql_log_warn, vha, 0x5049,
 			    "CT pass-through-%s error "
 			    "comp_status-status=0x%x.\n", type, comp_status);
 			res = DID_ERROR << 16;
-			bsg_job->reply->reply_payload_rcv_len = 0;
+			bsg_reply->reply_payload_rcv_len = 0;
 		}
 		ql_dump_buffer(ql_dbg_async + ql_dbg_buffer, vha, 0x5035,
 		    (uint8_t *)pkt, sizeof(*pkt));
 	} else {
 		res = DID_OK << 16;
-		bsg_job->reply->reply_payload_rcv_len =
+		bsg_reply->reply_payload_rcv_len =
 		    bsg_job->reply_payload.payload_len;
 		bsg_job->reply_len = 0;
 	}
@@ -1414,6 +1416,7 @@ static void qla_irq_affinity_notify(struct irq_affinity_notify *,
 	const char *type;
 	srb_t *sp;
 	struct fc_bsg_job *bsg_job;
+	struct fc_bsg_reply *bsg_reply;
 	uint16_t comp_status;
 	uint32_t fw_status[3];
 	uint8_t* fw_sts_ptr;
@@ -1423,6 +1426,7 @@ static void qla_irq_affinity_notify(struct irq_affinity_notify *,
 	if (!sp)
 		return;
 	bsg_job = sp->u.bsg_job;
+	bsg_reply = bsg_job->reply;
 
 	type = NULL;
 	switch (sp->type) {
@@ -1452,13 +1456,13 @@ static void qla_irq_affinity_notify(struct irq_affinity_notify *,
 	/* return FC_CTELS_STATUS_OK and leave the decoding of the ELS/CT
 	 * fc payload  to the caller
 	 */
-	bsg_job->reply->reply_data.ctels_reply.status = FC_CTELS_STATUS_OK;
+	bsg_reply->reply_data.ctels_reply.status = FC_CTELS_STATUS_OK;
 	bsg_job->reply_len = sizeof(struct fc_bsg_reply) + sizeof(fw_status);
 
 	if (comp_status != CS_COMPLETE) {
 		if (comp_status == CS_DATA_UNDERRUN) {
 			res = DID_OK << 16;
-			bsg_job->reply->reply_payload_rcv_len =
+			bsg_reply->reply_payload_rcv_len =
 			    le16_to_cpu(((struct els_sts_entry_24xx *)pkt)->total_byte_count);
 
 			ql_dbg(ql_dbg_user, vha, 0x503f,
@@ -1480,7 +1484,7 @@ static void qla_irq_affinity_notify(struct irq_affinity_notify *,
 			    le16_to_cpu(((struct els_sts_entry_24xx *)
 				    pkt)->error_subcode_2));
 			res = DID_ERROR << 16;
-			bsg_job->reply->reply_payload_rcv_len = 0;
+			bsg_reply->reply_payload_rcv_len = 0;
 			fw_sts_ptr = ((uint8_t*)bsg_job->req->sense) + sizeof(struct fc_bsg_reply);
 			memcpy( fw_sts_ptr, fw_status, sizeof(fw_status));
 		}
@@ -1489,7 +1493,7 @@ static void qla_irq_affinity_notify(struct irq_affinity_notify *,
 	}
 	else {
 		res =  DID_OK << 16;
-		bsg_job->reply->reply_payload_rcv_len = bsg_job->reply_payload.payload_len;
+		bsg_reply->reply_payload_rcv_len = bsg_job->reply_payload.payload_len;
 		bsg_job->reply_len = 0;
 	}
 
@@ -1905,6 +1909,8 @@ struct scsi_dif_tuple {
 	uint16_t thread_id;
 	uint32_t rval = EXT_STATUS_OK;
 	struct fc_bsg_job *bsg_job = NULL;
+	struct fc_bsg_request *bsg_request;
+	struct fc_bsg_reply *bsg_reply;
 	sts_entry_t *sts;
 	struct sts_entry_24xx *sts24;
 	sts = (sts_entry_t *) pkt;
@@ -1919,11 +1925,7 @@ struct scsi_dif_tuple {
 	}
 
 	sp = req->outstanding_cmds[index];
-	if (sp) {
-		/* Free outstanding command slot. */
-		req->outstanding_cmds[index] = NULL;
-		bsg_job = sp->u.bsg_job;
-	} else {
+	if (!sp) {
 		ql_log(ql_log_warn, vha, 0x70b0,
 		    "Req:%d: Invalid ISP SCSI completion handle(0x%x)\n",
 		    req->id, index);
@@ -1932,6 +1934,12 @@ struct scsi_dif_tuple {
 		return;
 	}
 
+	/* Free outstanding command slot. */
+	req->outstanding_cmds[index] = NULL;
+	bsg_job = sp->u.bsg_job;
+	bsg_request = bsg_job->request;
+	bsg_reply = bsg_job->reply;
+
 	if (IS_FWI2_CAPABLE(ha)) {
 		comp_status = le16_to_cpu(sts24->comp_status);
 		scsi_status = le16_to_cpu(sts24->scsi_status) & SS_MASK;
@@ -1940,14 +1948,14 @@ struct scsi_dif_tuple {
 		scsi_status = le16_to_cpu(sts->scsi_status) & SS_MASK;
 	}
 
-	thread_id = bsg_job->request->rqst_data.h_vendor.vendor_cmd[1];
+	thread_id = bsg_request->rqst_data.h_vendor.vendor_cmd[1];
 	switch (comp_status) {
 	case CS_COMPLETE:
 		if (scsi_status == 0) {
-			bsg_job->reply->reply_payload_rcv_len =
+			bsg_reply->reply_payload_rcv_len =
 					bsg_job->reply_payload.payload_len;
 			vha->qla_stats.input_bytes +=
-				bsg_job->reply->reply_payload_rcv_len;
+				bsg_reply->reply_payload_rcv_len;
 			vha->qla_stats.input_requests++;
 			rval = EXT_STATUS_OK;
 		}
@@ -2028,11 +2036,11 @@ struct scsi_dif_tuple {
 		rval = EXT_STATUS_ERR;
 		break;
 	}
-	bsg_job->reply->reply_payload_rcv_len = 0;
+	bsg_reply->reply_payload_rcv_len = 0;
 
 done:
 	/* Return the vendor specific reply to API */
-	bsg_job->reply->reply_data.vendor_reply.vendor_rsp[0] = rval;
+	bsg_reply->reply_data.vendor_reply.vendor_rsp[0] = rval;
 	bsg_job->reply_len = sizeof(struct fc_bsg_reply);
 	/* Always return DID_OK, bsg will send the vendor specific response
 	 * in this case only */
diff --git a/drivers/scsi/qla2xxx/qla_mr.c b/drivers/scsi/qla2xxx/qla_mr.c
index 15dff70..b597d04 100644
--- a/drivers/scsi/qla2xxx/qla_mr.c
+++ b/drivers/scsi/qla2xxx/qla_mr.c
@@ -2207,6 +2207,7 @@
 	const char func[] = "IOSB_IOCB";
 	srb_t *sp;
 	struct fc_bsg_job *bsg_job;
+	struct fc_bsg_reply *bsg_reply;
 	struct srb_iocb *iocb_job;
 	int res;
 	struct qla_mt_iocb_rsp_fx00 fstatus;
@@ -2226,6 +2227,7 @@
 			    pkt->dataword_r;
 	} else {
 		bsg_job = sp->u.bsg_job;
+		bsg_reply = bsg_job->reply;
 
 		memset(&fstatus, 0, sizeof(struct qla_mt_iocb_rsp_fx00));
 
@@ -2257,8 +2259,8 @@
 		    sp->fcport->vha, 0x5074,
 		    (uint8_t *)fw_sts_ptr, sizeof(struct qla_mt_iocb_rsp_fx00));
 
-		res = bsg_job->reply->result = DID_OK << 16;
-		bsg_job->reply->reply_payload_rcv_len =
+		res = bsg_reply->result = DID_OK << 16;
+		bsg_reply->reply_payload_rcv_len =
 		    bsg_job->reply_payload.payload_len;
 	}
 	sp->done(vha, sp, res);
@@ -3253,6 +3255,7 @@
 	struct srb_iocb *fxio = &sp->u.iocb_cmd;
 	struct qla_mt_iocb_rqst_fx00 *piocb_rqst;
 	struct fc_bsg_job *bsg_job;
+	struct fc_bsg_request *bsg_request;
 	struct fxdisc_entry_fx00 fx_iocb;
 	uint8_t entry_cnt = 1;
 
@@ -3301,8 +3304,9 @@
 	} else {
 		struct scatterlist *sg;
 		bsg_job = sp->u.bsg_job;
+		bsg_request = bsg_job->request;
 		piocb_rqst = (struct qla_mt_iocb_rqst_fx00 *)
-			&bsg_job->request->rqst_data.h_vendor.vendor_cmd[1];
+			&bsg_request->rqst_data.h_vendor.vendor_cmd[1];
 
 		fx_iocb.func_num = piocb_rqst->func_type;
 		fx_iocb.adapid = piocb_rqst->adapid;
diff --git a/drivers/scsi/scsi_transport_fc.c b/drivers/scsi/scsi_transport_fc.c
index bc831bd..02a83e5 100644
--- a/drivers/scsi/scsi_transport_fc.c
+++ b/drivers/scsi/scsi_transport_fc.c
@@ -3588,9 +3588,10 @@ struct fc_vport *
 {
 	struct request *req = job->req;
 	struct request *rsp = req->next_rq;
+	struct fc_bsg_reply *bsg_reply = job->reply;
 	int err;
 
-	err = job->req->errors = job->reply->result;
+	err = job->req->errors = bsg_reply->result;
 
 	if (err < 0)
 		/* we're only returning the result field in the reply */
@@ -3602,10 +3603,10 @@ struct fc_vport *
 	req->resid_len = 0;
 
 	if (rsp) {
-		WARN_ON(job->reply->reply_payload_rcv_len > rsp->resid_len);
+		WARN_ON(bsg_reply->reply_payload_rcv_len > rsp->resid_len);
 
 		/* set reply (bidi) residual */
-		rsp->resid_len -= min(job->reply->reply_payload_rcv_len,
+		rsp->resid_len -= min(bsg_reply->reply_payload_rcv_len,
 				      rsp->resid_len);
 	}
 	blk_complete_request(req);
@@ -3779,11 +3780,19 @@ enum fc_dispatch_result {
 			 struct fc_bsg_job *job)
 {
 	struct fc_internal *i = to_fc_internal(shost->transportt);
+	struct fc_bsg_request *bsg_request = job->request;
+	struct fc_bsg_reply *bsg_reply = job->reply;
 	int cmdlen = sizeof(uint32_t);	/* start with length of msgcode */
 	int ret;
 
+	/* check if we really have all the request data needed */
+	if (job->request_len < cmdlen) {
+		ret = -ENOMSG;
+		goto fail_host_msg;
+	}
+
 	/* Validate the host command */
-	switch (job->request->msgcode) {
+	switch (bsg_request->msgcode) {
 	case FC_BSG_HST_ADD_RPORT:
 		cmdlen += sizeof(struct fc_bsg_host_add_rport);
 		break;
@@ -3815,7 +3824,7 @@ enum fc_dispatch_result {
 	case FC_BSG_HST_VENDOR:
 		cmdlen += sizeof(struct fc_bsg_host_vendor);
 		if ((shost->hostt->vendor_id == 0L) ||
-		    (job->request->rqst_data.h_vendor.vendor_id !=
+		    (bsg_request->rqst_data.h_vendor.vendor_id !=
 			shost->hostt->vendor_id)) {
 			ret = -ESRCH;
 			goto fail_host_msg;
@@ -3827,12 +3836,6 @@ enum fc_dispatch_result {
 		goto fail_host_msg;
 	}
 
-	/* check if we really have all the request data needed */
-	if (job->request_len < cmdlen) {
-		ret = -ENOMSG;
-		goto fail_host_msg;
-	}
-
 	ret = i->f->bsg_request(job);
 	if (!ret)
 		return FC_DISPATCH_UNLOCKED;
@@ -3840,8 +3843,8 @@ enum fc_dispatch_result {
 fail_host_msg:
 	/* return the errno failure code as the only status */
 	BUG_ON(job->reply_len < sizeof(uint32_t));
-	job->reply->reply_payload_rcv_len = 0;
-	job->reply->result = ret;
+	bsg_reply->reply_payload_rcv_len = 0;
+	bsg_reply->result = ret;
 	job->reply_len = sizeof(uint32_t);
 	fc_bsg_jobdone(job);
 	return FC_DISPATCH_UNLOCKED;
@@ -3878,11 +3881,19 @@ enum fc_dispatch_result {
 			 struct fc_rport *rport, struct fc_bsg_job *job)
 {
 	struct fc_internal *i = to_fc_internal(shost->transportt);
+	struct fc_bsg_request *bsg_request = job->request;
+	struct fc_bsg_reply *bsg_reply = job->reply;
 	int cmdlen = sizeof(uint32_t);	/* start with length of msgcode */
 	int ret;
 
+	/* check if we really have all the request data needed */
+	if (job->request_len < cmdlen) {
+		ret = -ENOMSG;
+		goto fail_rport_msg;
+	}
+
 	/* Validate the rport command */
-	switch (job->request->msgcode) {
+	switch (bsg_request->msgcode) {
 	case FC_BSG_RPT_ELS:
 		cmdlen += sizeof(struct fc_bsg_rport_els);
 		goto check_bidi;
@@ -3902,12 +3913,6 @@ enum fc_dispatch_result {
 		goto fail_rport_msg;
 	}
 
-	/* check if we really have all the request data needed */
-	if (job->request_len < cmdlen) {
-		ret = -ENOMSG;
-		goto fail_rport_msg;
-	}
-
 	ret = i->f->bsg_request(job);
 	if (!ret)
 		return FC_DISPATCH_UNLOCKED;
@@ -3915,8 +3920,8 @@ enum fc_dispatch_result {
 fail_rport_msg:
 	/* return the errno failure code as the only status */
 	BUG_ON(job->reply_len < sizeof(uint32_t));
-	job->reply->reply_payload_rcv_len = 0;
-	job->reply->result = ret;
+	bsg_reply->reply_payload_rcv_len = 0;
+	bsg_reply->result = ret;
 	job->reply_len = sizeof(uint32_t);
 	fc_bsg_jobdone(job);
 	return FC_DISPATCH_UNLOCKED;
@@ -3937,6 +3942,7 @@ enum fc_dispatch_result {
 	struct request *req;
 	struct fc_bsg_job *job;
 	enum fc_dispatch_result ret;
+	struct fc_bsg_reply *bsg_reply;
 
 	if (!get_device(dev))
 		return;
@@ -3973,8 +3979,9 @@ enum fc_dispatch_result {
 		/* check if we have the msgcode value at least */
 		if (job->request_len < sizeof(uint32_t)) {
 			BUG_ON(job->reply_len < sizeof(uint32_t));
-			job->reply->reply_payload_rcv_len = 0;
-			job->reply->result = -ENOMSG;
+			bsg_reply = job->reply;
+			bsg_reply->reply_payload_rcv_len = 0;
+			bsg_reply->result = -ENOMSG;
 			job->reply_len = sizeof(uint32_t);
 			fc_bsg_jobdone(job);
 			spin_lock_irq(q->queue_lock);
-- 
1.8.5.6
