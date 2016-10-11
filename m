From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: [PATCH 14/44] lpfc: Use fc_bsg_jobdone()
Date: Tue, 11 Oct 2016 13:28:45 +0200
Message-ID: <78e8d4738e8d6287d9c98c2b7f671a34e480ef55.1476180827.git.jthumshirn@suse.de>
References: <cover.1476180827.git.jthumshirn@suse.de>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <cover.1476180827.git.jthumshirn@suse.de>
In-Reply-To: <cover.1476180827.git.jthumshirn@suse.de>
References: <cover.1476180827.git.jthumshirn@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@infradead.org>, Hannes Reinecke <hare@suse.de>, Linux Kernel Mailinglist <linux-kernel@vger.kernel.org>, Linux SCSI Mailinglist <linux-scsi@vger.kernel.org>, Johannes Thumshirn <jthumshirn@suse.de>, James Smart <james.smart@avagotech.com>, Dick Kennedy <dick.kennedy@avagotech.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>
List-Id: linux-scsi@vger.kernel.org

Use fc_bsg_jobdone() directly instead of the struct bsg_job::job_done()
callback.

Signed-off-by: Johannes Thumshirn <jthumshirn@suse.de>
---
 drivers/scsi/lpfc/lpfc_bsg.c | 38 +++++++++++++++++++-------------------
 1 file changed, 19 insertions(+), 19 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_bsg.c b/drivers/scsi/lpfc/lpfc_bsg.c
index 27b5930..1db9cca 100644
--- a/drivers/scsi/lpfc/lpfc_bsg.c
+++ b/drivers/scsi/lpfc/lpfc_bsg.c
@@ -371,7 +371,7 @@ lpfc_bsg_send_mgmt_cmd_cmp(struct lpfc_hba *phba,
 
 	if (job) {
 		bsg_reply->result = rc;
-		job->job_done(job);
+		fc_bsg_jobdone(job);
 	}
 	return;
 }
@@ -644,7 +644,7 @@ lpfc_bsg_rport_els_cmp(struct lpfc_hba *phba,
 
 	if (job) {
 		bsg_reply->result = rc;
-		job->job_done(job);
+		fc_bsg_jobdone(job);
 	}
 	return;
 }
@@ -1136,7 +1136,7 @@ lpfc_bsg_ct_unsol_event(struct lpfc_hba *phba, struct lpfc_sli_ring *pring,
 			job->dd_data = NULL;
 			/* complete the job back to userspace */
 			spin_unlock_irqrestore(&phba->ct_ev_lock, flags);
-			job->job_done(job);
+			fc_bsg_jobdone(job);
 			spin_lock_irqsave(&phba->ct_ev_lock, flags);
 		}
 	}
@@ -1361,7 +1361,7 @@ lpfc_bsg_hba_get_event(struct fc_bsg_job *job)
 	spin_unlock_irqrestore(&phba->ct_ev_lock, flags);
 	job->dd_data = NULL;
 	bsg_reply->result = 0;
-	job->job_done(job);
+	fc_bsg_jobdone(job);
 	return 0;
 
 job_error:
@@ -1458,7 +1458,7 @@ lpfc_issue_ct_rsp_cmp(struct lpfc_hba *phba,
 
 	if (job) {
 		bsg_reply->result = rc;
-		job->job_done(job);
+		fc_bsg_jobdone(job);
 	}
 	return;
 }
@@ -1886,7 +1886,7 @@ job_error:
 	bsg_reply->result = rc;
 	/* complete the job back to userspace if no error */
 	if (rc == 0)
-		job->job_done(job);
+		fc_bsg_jobdone(job);
 	return rc;
 }
 
@@ -2175,7 +2175,7 @@ job_error:
 	bsg_reply->result = rc;
 	/* complete the job back to userspace if no error */
 	if (rc == 0)
-		job->job_done(job);
+		fc_bsg_jobdone(job);
 	return rc;
 }
 
@@ -2289,7 +2289,7 @@ loopback_mode_end_exit:
 	bsg_reply->result = rc;
 	/* complete the job back to userspace if no error */
 	if (rc == 0)
-		job->job_done(job);
+		fc_bsg_jobdone(job);
 	return rc;
 }
 
@@ -2441,7 +2441,7 @@ job_error:
 	bsg_reply->result = rc;
 	/* complete the job back to userspace if no error */
 	if (rc == 0)
-		job->job_done(job);
+		fc_bsg_jobdone(job);
 	return rc;
 }
 
@@ -3301,7 +3301,7 @@ loopback_test_exit:
 	job->dd_data = NULL;
 	/* complete the job back to userspace if no error */
 	if (rc == IOCB_SUCCESS)
-		job->job_done(job);
+		fc_bsg_jobdone(job);
 	return rc;
 }
 
@@ -3344,7 +3344,7 @@ lpfc_bsg_get_dfc_rev(struct fc_bsg_job *job)
 job_error:
 	bsg_reply->result = rc;
 	if (rc == 0)
-		job->job_done(job);
+		fc_bsg_jobdone(job);
 	return rc;
 }
 
@@ -3409,7 +3409,7 @@ lpfc_bsg_issue_mbox_cmpl(struct lpfc_hba *phba, LPFC_MBOXQ_t *pmboxq)
 
 	if (job) {
 		bsg_reply->result = 0;
-		job->job_done(job);
+		fc_bsg_jobdone(job);
 	}
 	return;
 }
@@ -3655,7 +3655,7 @@ lpfc_bsg_issue_read_mbox_ext_cmpl(struct lpfc_hba *phba, LPFC_MBOXQ_t *pmboxq)
 
 	/* if the job is still active, call job done */
 	if (job)
-		job->job_done(job);
+		fc_bsg_jobdone(job);
 
 	return;
 }
@@ -3690,7 +3690,7 @@ lpfc_bsg_issue_write_mbox_ext_cmpl(struct lpfc_hba *phba, LPFC_MBOXQ_t *pmboxq)
 
 	/* if the job is still active, call job done */
 	if (job)
-		job->job_done(job);
+		fc_bsg_jobdone(job);
 
 	return;
 }
@@ -4131,7 +4131,7 @@ lpfc_bsg_sli_cfg_write_cmd_ext(struct lpfc_hba *phba, struct fc_bsg_job *job,
 	/* wait for additoinal external buffers */
 
 	bsg_reply->result = 0;
-	job->job_done(job);
+	fc_bsg_jobdone(job);
 	return SLI_CONFIG_HANDLED;
 
 job_error:
@@ -4357,7 +4357,7 @@ lpfc_bsg_read_ebuf_get(struct lpfc_hba *phba, struct fc_bsg_job *job)
 	}
 
 	bsg_reply->result = 0;
-	job->job_done(job);
+	fc_bsg_jobdone(job);
 
 	return SLI_CONFIG_HANDLED;
 }
@@ -4473,7 +4473,7 @@ lpfc_bsg_write_ebuf_set(struct lpfc_hba *phba, struct fc_bsg_job *job,
 
 	/* wait for additoinal external buffers */
 	bsg_reply->result = 0;
-	job->job_done(job);
+	fc_bsg_jobdone(job);
 	return SLI_CONFIG_HANDLED;
 
 job_error:
@@ -4941,7 +4941,7 @@ lpfc_bsg_mbox_cmd(struct fc_bsg_job *job)
 		/* job done */
 		bsg_reply->result = 0;
 		job->dd_data = NULL;
-		job->job_done(job);
+		fc_bsg_jobdone(job);
 	} else if (rc == 1)
 		/* job submitted, will complete later*/
 		rc = 0; /* return zero, no error */
@@ -5051,7 +5051,7 @@ lpfc_bsg_menlo_cmd_cmp(struct lpfc_hba *phba,
 
 	if (job) {
 		bsg_reply->result = rc;
-		job->job_done(job);
+		fc_bsg_jobdone(job);
 	}
 
 	return;
-- 
1.8.5.6
