From: James Smart <james.smart@emulex.com>
Subject: [PATCH 5/7] lpfc 8.3.13: BSG management fixes
Date: Wed, 12 May 2010 09:32:14 -0400
Message-ID: <1273671164.24670.21.camel@wookie>
Reply-To: james.smart@emulex.com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from exht1.emulex.com ([138.239.113.183]:16392 "EHLO
	exht1.ad.emulex.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751846Ab0ELNdq (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 12 May 2010 09:33:46 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


- Add reference counting to prevent module removal when
  there are outstanding BSG requests.
- Clean up some duplicate code.

 Signed-off-by: Alex Iannicelli <alex.iannicelli@emulex.com>
 Signed-off-by: James Smart <james.smart@emulex.com>

 ---

 lpfc_bsg.c |  103 +++++++++++++++++++++++++++++++++++++++++++++++++++++--------
 1 file changed, 91 insertions(+), 12 deletions(-)


diff -upNr a/drivers/scsi/lpfc/lpfc_bsg.c b/drivers/scsi/lpfc/lpfc_bsg.c
--- a/drivers/scsi/lpfc/lpfc_bsg.c	2010-05-05 08:52:38.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_bsg.c	2010-05-12 09:04:43.000000000 -0400
@@ -141,6 +141,47 @@ struct lpfc_dmabufext {
 };
 
 /**
+ * lpfc_bsg_get_kboject - gets a reference on the drivers module kobject
+ * @phba: Pointer to HBA context object
+ *
+ * This function bumps the reference on the drivers module kobject preventing
+ * the driver from being removed. Prevents the sysfs tree from being
+ * corrupted because the driver was removed while bsg jobs are unfinished,
+ * this would be the case for registered events or any command sent to hardware
+ * and the driver needs to wait for the command to complete.
+ **/
+static void
+lpfc_bsg_get_kboject(struct lpfc_hba *phba)
+{
+	struct lpfc_vport *vport = phba->pport;
+	struct Scsi_Host  *shost = lpfc_shost_from_vport(vport);
+	unsigned long flags;
+
+	spin_lock_irqsave(shost->host_lock, flags);
+	__module_get(shost->dma_dev->driver->owner);
+	spin_unlock_irqrestore(shost->host_lock, flags);
+}
+
+/**
+ * lpfc_bsg_put_kboject - puts back a reference the drivers module kobject
+ * @phba: Pointer to HBA context object
+ *
+ * This function decrements the reference on the drivers module kobject
+ * allowing the module to be removed if no other references are outstanding.
+ **/
+static void
+lpfc_bsg_put_kboject(struct lpfc_hba *phba)
+{
+	struct lpfc_vport *vport = phba->pport;
+	struct Scsi_Host  *shost = lpfc_shost_from_vport(vport);
+	unsigned long flags;
+
+	spin_lock_irqsave(shost->host_lock, flags);
+	module_put(shost->dma_dev->driver->owner);
+	spin_unlock_irqrestore(shost->host_lock, flags);
+}
+
+/**
  * lpfc_bsg_send_mgmt_cmd_cmp - lpfc_bsg_send_mgmt_cmd's completion handler
  * @phba: Pointer to HBA context object.
  * @cmdiocbq: Pointer to command iocb.
@@ -230,6 +271,7 @@ lpfc_bsg_send_mgmt_cmd_cmp(struct lpfc_h
 	/* complete the job back to userspace */
 	job->job_done(job);
 	spin_unlock_irqrestore(&phba->ct_ev_lock, flags);
+	lpfc_bsg_put_kboject(phba);
 	return;
 }
 
@@ -400,6 +442,7 @@ no_dd_data:
 	/* make error code available to userspace */
 	job->reply->result = rc;
 	job->dd_data = NULL;
+	lpfc_bsg_put_kboject(phba);
 	return rc;
 }
 
@@ -490,6 +533,7 @@ lpfc_bsg_rport_els_cmp(struct lpfc_hba *
 	/* complete the job back to userspace */
 	job->job_done(job);
 	spin_unlock_irqrestore(&phba->ct_ev_lock, flags);
+	lpfc_bsg_put_kboject(phba);
 	return;
 }
 
@@ -645,6 +689,7 @@ no_dd_data:
 	/* make error code available to userspace */
 	job->reply->result = rc;
 	job->dd_data = NULL;
+	lpfc_bsg_put_kboject(phba);
 	return rc;
 }
 
@@ -981,6 +1026,7 @@ lpfc_bsg_ct_unsol_event(struct lpfc_hba 
 			/* complete the job back to userspace */
 			spin_unlock_irqrestore(&phba->ct_ev_lock, flags);
 			job->job_done(job);
+			lpfc_bsg_put_kboject(phba);
 			spin_lock_irqsave(&phba->ct_ev_lock, flags);
 		}
 	}
@@ -997,6 +1043,11 @@ error_ct_unsol_exit:
 /**
  * lpfc_bsg_hba_set_event - process a SET_EVENT bsg vendor command
  * @job: SET_EVENT fc_bsg_job
+ *
+ * On error decrement the kobject count, otherwise we are holding
+ * the job in the event structure to complete later.
+ * The unsolicited event handler will decrement the count when it finds
+ * this job on the ct_ev_waiters queue.
  **/
 static int
 lpfc_bsg_hba_set_event(struct fc_bsg_job *job)
@@ -1074,12 +1125,15 @@ job_error:
 		kfree(dd_data);
 
 	job->dd_data = NULL;
+	lpfc_bsg_put_kboject(phba);
 	return rc;
 }
 
 /**
  * lpfc_bsg_hba_get_event - process a GET_EVENT bsg vendor command
  * @job: GET_EVENT fc_bsg_job
+ *
+ * This job is finished with or without an error so decrement the kobject.
  **/
 static int
 lpfc_bsg_hba_get_event(struct fc_bsg_job *job)
@@ -1160,11 +1214,13 @@ lpfc_bsg_hba_get_event(struct fc_bsg_job
 	job->dd_data = NULL;
 	job->reply->result = 0;
 	job->job_done(job);
+	lpfc_bsg_put_kboject(phba);
 	return 0;
 
 job_error:
 	job->dd_data = NULL;
 	job->reply->result = rc;
+	lpfc_bsg_put_kboject(phba);
 	return rc;
 }
 
@@ -1244,6 +1300,7 @@ lpfc_issue_ct_rsp_cmp(struct lpfc_hba *p
 	/* complete the job back to userspace */
 	job->job_done(job);
 	spin_unlock_irqrestore(&phba->ct_ev_lock, flags);
+	lpfc_bsg_put_kboject(phba);
 	return;
 }
 
@@ -1365,6 +1422,9 @@ no_dd_data:
 /**
  * lpfc_bsg_send_mgmt_rsp - process a SEND_MGMT_RESP bsg vendor command
  * @job: SEND_MGMT_RESP fc_bsg_job
+ *
+ * This job is completed with or without an error so decrement the kobject
+ * count.
  **/
 static int
 lpfc_bsg_send_mgmt_rsp(struct fc_bsg_job *job)
@@ -1435,6 +1495,7 @@ send_mgmt_rsp_exit:
 	/* make error code available to userspace */
 	job->reply->result = rc;
 	job->dd_data = NULL;
+	lpfc_bsg_put_kboject(phba);
 	return rc;
 }
 
@@ -1594,6 +1655,7 @@ job_error:
 	/* complete the job back to userspace if no error */
 	if (rc == 0)
 		job->job_done(job);
+	lpfc_bsg_put_kboject(phba);
 	return rc;
 }
 
@@ -2328,6 +2390,7 @@ loopback_test_exit:
 	/* complete the job back to userspace if no error */
 	if (rc == 0)
 		job->job_done(job);
+	lpfc_bsg_put_kboject(phba);
 	return rc;
 }
 
@@ -2374,6 +2437,7 @@ job_error:
 	job->reply->result = rc;
 	if (rc == 0)
 		job->job_done(job);
+	lpfc_bsg_put_kboject(phba);
 	return rc;
 }
 
@@ -2477,6 +2541,7 @@ lpfc_bsg_wake_mbox_wait(struct lpfc_hba 
 		kfree(dd_data->context_un.mbox.rxbmp);
 	}
 	kfree(dd_data);
+	lpfc_bsg_put_kboject(phba);
 	return;
 }
 
@@ -2688,15 +2753,6 @@ lpfc_bsg_issue_mbox(struct lpfc_hba *phb
 
 		pmboxq->context2 = ext;
 		pmboxq->in_ext_byte_len =
-			mbox_req->inExtWLen *
-			sizeof(uint32_t);
-		pmboxq->out_ext_byte_len =
-			mbox_req->outExtWLen *
-			sizeof(uint32_t);
-		pmboxq->mbox_offset_word =
-			mbox_req->mbOffset;
-		pmboxq->context2 = ext;
-		pmboxq->in_ext_byte_len =
 			mbox_req->inExtWLen * sizeof(uint32_t);
 		pmboxq->out_ext_byte_len =
 			mbox_req->outExtWLen * sizeof(uint32_t);
@@ -2945,7 +3001,7 @@ job_done:
 		kfree(rxbmp);
 	}
 	kfree(dd_data);
-
+	lpfc_bsg_put_kboject(phba);
 	return rc;
 }
 
@@ -2994,13 +3050,15 @@ job_error:
 		job->reply->result = 0;
 		job->dd_data = NULL;
 		job->job_done(job);
+		lpfc_bsg_put_kboject(phba);
 	} else if (rc == 1)
-		/* job submitted, will complete later*/
+		/* will complete the job later so hold onto the kobject */
 		rc = 0; /* return zero, no error */
 	else {
 		/* some error occurred */
 		job->reply->result = rc;
 		job->dd_data = NULL;
+		lpfc_bsg_put_kboject(phba);
 	}
 
 	return rc;
@@ -3100,6 +3158,7 @@ lpfc_bsg_menlo_cmd_cmp(struct lpfc_hba *
 	/* complete the job back to userspace */
 	job->job_done(job);
 	spin_unlock_irqrestore(&phba->ct_ev_lock, flags);
+	lpfc_bsg_put_kboject(phba);
 	return;
 }
 
@@ -3295,6 +3354,7 @@ no_dd_data:
 	/* make error code available to userspace */
 	job->reply->result = rc;
 	job->dd_data = NULL;
+	lpfc_bsg_put_kboject(phba);
 	return rc;
 }
 /**
@@ -3304,6 +3364,8 @@ no_dd_data:
 static int
 lpfc_bsg_hst_vendor(struct fc_bsg_job *job)
 {
+	struct lpfc_vport *vport = (struct lpfc_vport *)job->shost->hostdata;
+	struct lpfc_hba *phba = vport->phba;
 	int command = job->request->rqst_data.h_vendor.vendor_cmd[0];
 	int rc;
 
@@ -3338,6 +3400,7 @@ lpfc_bsg_hst_vendor(struct fc_bsg_job *j
 		job->reply->reply_payload_rcv_len = 0;
 		/* make error code available to userspace */
 		job->reply->result = rc;
+		lpfc_bsg_put_kboject(phba);
 		break;
 	}
 
@@ -3347,12 +3410,21 @@ lpfc_bsg_hst_vendor(struct fc_bsg_job *j
 /**
  * lpfc_bsg_request - handle a bsg request from the FC transport
  * @job: fc_bsg_job to handle
+ *
+ * We increment the scsi host drivers kobject until we are completely
+ * finished with the job with or without error. By doing so the module
+ * cannot be removed preventing the scsi transport sysfs entries from
+ * becoming corrupt. This mimics the older ioctl device file.
  **/
 int
 lpfc_bsg_request(struct fc_bsg_job *job)
 {
 	uint32_t msgcode;
 	int rc;
+	struct lpfc_vport *vport = (struct lpfc_vport *)job->shost->hostdata;
+	struct lpfc_hba *phba = vport->phba;
+
+	lpfc_bsg_get_kboject(phba);
 
 	msgcode = job->request->msgcode;
 	switch (msgcode) {
@@ -3370,6 +3442,7 @@ lpfc_bsg_request(struct fc_bsg_job *job)
 		job->reply->reply_payload_rcv_len = 0;
 		/* make error code available to userspace */
 		job->reply->result = rc;
+		lpfc_bsg_put_kboject(phba);
 		break;
 	}
 
@@ -3429,6 +3502,7 @@ lpfc_bsg_timeout(struct fc_bsg_job *job)
 		job->reply->result = -EAGAIN;
 		spin_unlock_irqrestore(&phba->ct_ev_lock, flags);
 		job->job_done(job);
+		lpfc_bsg_put_kboject(phba);
 		break;
 	case TYPE_MBOX:
 		mbox = &dd_data->context_un.mbox;
@@ -3437,9 +3511,14 @@ lpfc_bsg_timeout(struct fc_bsg_job *job)
 		job->dd_data = NULL;
 		job->reply->reply_payload_rcv_len = 0;
 		job->reply->result = -EAGAIN;
-		/* the mbox completion handler can now be run */
+		/* the mbox completion handler can now run but it wont
+		 * find a job so it will just cleanup, we have a ref count
+		 * on the module while the command is outstanding.
+		 */
 		spin_unlock_irqrestore(&phba->ct_ev_lock, flags);
 		job->job_done(job);
+		/* decrement count as we are done with this job */
+		lpfc_bsg_put_kboject(phba);
 		break;
 	case TYPE_MENLO:
 		menlo = &dd_data->context_un.menlo;


