From: Johannes Thumshirn <jthumshirn-l3A5Bk7waGM@public.gmane.org>
Subject: [PATCH v3 04/16] scsi: Unify interfaces of
	fc_bsg_jobdone and bsg_job_done
Date: Thu, 13 Oct 2016 17:00:20 +0200
Message-ID: <2b02bb8460fa27db4fe971a2161e0cb7c2fca4df.1476369687.git.jthumshirn@suse.de>
References: <cover.1476369687.git.jthumshirn@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <fcoe-devel-bounces-s9riP+hp16TNLxjTenLetw@public.gmane.org>
In-Reply-To: <cover.1476369687.git.jthumshirn-l3A5Bk7waGM@public.gmane.org>
In-Reply-To: <cover.1476369687.git.jthumshirn-l3A5Bk7waGM@public.gmane.org>
References: <cover.1476369687.git.jthumshirn-l3A5Bk7waGM@public.gmane.org>
List-Unsubscribe: <http://lists.open-fcoe.org/mailman/options/fcoe-devel>,
 <mailto:fcoe-devel-request-s9riP+hp16TNLxjTenLetw@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.open-fcoe.org/pipermail/fcoe-devel/>
List-Post: <mailto:fcoe-devel-s9riP+hp16TNLxjTenLetw@public.gmane.org>
List-Help: <mailto:fcoe-devel-request-s9riP+hp16TNLxjTenLetw@public.gmane.org?subject=help>
List-Subscribe: <http://lists.open-fcoe.org/mailman/listinfo/fcoe-devel>,
 <mailto:fcoe-devel-request-s9riP+hp16TNLxjTenLetw@public.gmane.org?subject=subscribe>
Errors-To: fcoe-devel-bounces-s9riP+hp16TNLxjTenLetw@public.gmane.org
Sender: "fcoe-devel" <fcoe-devel-bounces-s9riP+hp16TNLxjTenLetw@public.gmane.org>
To: "Martin K . Petersen" <martin.petersen-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: Benjamin Herrenschmidt <benh-XVmvHMARGAS8U2dJNN8I7kB+6BGkLq7r@public.gmane.org>, Heiko Carstens <heiko.carstens-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org>, Paul Mackerras <paulus-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>, "open list:S390 ZFCP DRIVER" <linux-s390-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Dick Kennedy <dick.kennedy-1wcpHE2jlwO1Z/+hSey0Gg@public.gmane.org>, "James E.J. Bottomley" <jejb-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, Sudarsana Kalluru <sudarsana.kalluru-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>, Michael Ellerman <mpe-Gsx/Oe8HsFggBc27wqDAHg@public.gmane.org>, Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, "open list:FCOE SUBSYSTEM libfc, libfcoe, fcoe" <fcoe-devel-s9riP+hp16TNLxjTenLetw@public.gmane.org>, Steffen Maier <maier-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, "supporter:QLOGIC QLA2XXX FC-SCSI DRIVER" <qla2xxx-upstream-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>, Linux SCSI Mailinglist <linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Anil Gurumurthy <anil.gurumurthy-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>, Linux Kernel Mailinglist <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, James Smart <james.smart-1wcpHE2jlwO1Z/+hSey0Gg@public.gmane.org>, Martin Schwidefsky <schwidefsky-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org>, Johannes Thumshirn <jth-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

Unify the interfaces of fc_bsg_jobdone and bsg_job_done. This will reduce the
diff when moving from 'struct fc_bsg_job' to a plain 'struct bsg_job' later
on.

Signed-off-by: Johannes Thumshirn <jthumshirn-l3A5Bk7waGM@public.gmane.org>
Reviewed-by: Hannes Reinecke <hare-IBi9RG/b67k@public.gmane.org>
---
 drivers/s390/scsi/zfcp_fc.c      |  2 +-
 drivers/scsi/bfa/bfad_bsg.c      |  6 ++--
 drivers/scsi/ibmvscsi/ibmvfc.c   |  3 +-
 drivers/scsi/libfc/fc_lport.c    |  6 ++--
 drivers/scsi/lpfc/lpfc_bsg.c     | 68 +++++++++++++++++++++++++++-------------
 drivers/scsi/qla2xxx/qla_bsg.c   | 66 +++++++++++++++++++++++++-------------
 drivers/scsi/scsi_transport_fc.c | 22 +++++++------
 include/scsi/scsi_transport_fc.h |  3 +-
 8 files changed, 116 insertions(+), 60 deletions(-)

diff --git a/drivers/s390/scsi/zfcp_fc.c b/drivers/s390/scsi/zfcp_fc.c
index 40d8f06..87f6330 100644
--- a/drivers/s390/scsi/zfcp_fc.c
+++ b/drivers/s390/scsi/zfcp_fc.c
@@ -892,7 +892,7 @@ static void zfcp_fc_ct_els_job_handler(void *data)
 	jr->reply_payload_rcv_len = job->reply_payload.payload_len;
 	jr->reply_data.ctels_reply.status = FC_CTELS_STATUS_OK;
 	jr->result = zfcp_ct_els->status ? -EIO : 0;
-	fc_bsg_jobdone(job);
+	fc_bsg_jobdone(job, jr->result, jr->reply_payload_rcv_len);
 }
 
 static struct zfcp_fc_wka_port *zfcp_fc_job_wka_port(struct fc_bsg_job *job)
diff --git a/drivers/scsi/bfa/bfad_bsg.c b/drivers/scsi/bfa/bfad_bsg.c
index 25889b9..e49a6c8 100644
--- a/drivers/scsi/bfa/bfad_bsg.c
+++ b/drivers/scsi/bfa/bfad_bsg.c
@@ -3180,7 +3180,8 @@
 	bsg_reply->reply_payload_rcv_len = job->reply_payload.payload_len;
 	bsg_reply->result = rc;
 
-	fc_bsg_jobdone(job);
+	fc_bsg_jobdone(job, bsg_reply->result,
+		       bsg_reply->reply_payload_rcv_len);
 	return rc;
 error:
 	/* free the command buffer */
@@ -3556,7 +3557,8 @@ struct bfad_buf_info *
 	bsg_reply->result = rc;
 
 	if (rc == BFA_STATUS_OK)
-		fc_bsg_jobdone(job);
+		fc_bsg_jobdone(job, bsg_reply->result,
+			       bsg_reply->reply_payload_rcv_len);
 
 	return rc;
 }
diff --git a/drivers/scsi/ibmvscsi/ibmvfc.c b/drivers/scsi/ibmvscsi/ibmvfc.c
index f14e9c1..6070361 100644
--- a/drivers/scsi/ibmvscsi/ibmvfc.c
+++ b/drivers/scsi/ibmvscsi/ibmvfc.c
@@ -1945,7 +1945,8 @@ static int ibmvfc_bsg_request(struct fc_bsg_job *job)
 	ibmvfc_free_event(evt);
 	spin_unlock_irqrestore(vhost->host->host_lock, flags);
 	bsg_reply->result = rc;
-	fc_bsg_jobdone(job);
+	fc_bsg_jobdone(job, bsg_reply->result,
+		       bsg_reply->reply_payload_rcv_len);
 	rc = 0;
 out:
 	dma_unmap_sg(vhost->dev, job->request_payload.sg_list,
diff --git a/drivers/scsi/libfc/fc_lport.c b/drivers/scsi/libfc/fc_lport.c
index 33e2881..000188f 100644
--- a/drivers/scsi/libfc/fc_lport.c
+++ b/drivers/scsi/libfc/fc_lport.c
@@ -1917,7 +1917,8 @@ static void fc_lport_bsg_resp(struct fc_seq *sp, struct fc_frame *fp,
 			-ECONNABORTED : -ETIMEDOUT;
 		job->reply_len = sizeof(uint32_t);
 		job->state_flags |= FC_RQST_STATE_DONE;
-		fc_bsg_jobdone(job);
+		fc_bsg_jobdone(job, bsg_reply->result,
+			       bsg_reply->reply_payload_rcv_len);
 		kfree(info);
 		return;
 	}
@@ -1952,7 +1953,8 @@ static void fc_lport_bsg_resp(struct fc_seq *sp, struct fc_frame *fp,
 				job->reply_payload.payload_len;
 		bsg_reply->result = 0;
 		job->state_flags |= FC_RQST_STATE_DONE;
-		fc_bsg_jobdone(job);
+		fc_bsg_jobdone(job, bsg_reply->result,
+			       bsg_reply->reply_payload_rcv_len);
 		kfree(info);
 	}
 	fc_frame_free(fp);
diff --git a/drivers/scsi/lpfc/lpfc_bsg.c b/drivers/scsi/lpfc/lpfc_bsg.c
index 1db9cca..447a7af 100644
--- a/drivers/scsi/lpfc/lpfc_bsg.c
+++ b/drivers/scsi/lpfc/lpfc_bsg.c
@@ -371,7 +371,8 @@ struct lpfc_dmabufext {
 
 	if (job) {
 		bsg_reply->result = rc;
-		fc_bsg_jobdone(job);
+		fc_bsg_jobdone(job, bsg_reply->result,
+			       bsg_reply->reply_payload_rcv_len);
 	}
 	return;
 }
@@ -644,7 +645,8 @@ struct lpfc_dmabufext {
 
 	if (job) {
 		bsg_reply->result = rc;
-		fc_bsg_jobdone(job);
+		fc_bsg_jobdone(job, bsg_reply->result,
+			       bsg_reply->reply_payload_rcv_len);
 	}
 	return;
 }
@@ -1136,7 +1138,8 @@ struct lpfc_dmabufext {
 			job->dd_data = NULL;
 			/* complete the job back to userspace */
 			spin_unlock_irqrestore(&phba->ct_ev_lock, flags);
-			fc_bsg_jobdone(job);
+			fc_bsg_jobdone(job, bsg_reply->result,
+				       bsg_reply->reply_payload_rcv_len);
 			spin_lock_irqsave(&phba->ct_ev_lock, flags);
 		}
 	}
@@ -1361,7 +1364,8 @@ struct lpfc_dmabufext {
 	spin_unlock_irqrestore(&phba->ct_ev_lock, flags);
 	job->dd_data = NULL;
 	bsg_reply->result = 0;
-	fc_bsg_jobdone(job);
+	fc_bsg_jobdone(job, bsg_reply->result,
+		       bsg_reply->reply_payload_rcv_len);
 	return 0;
 
 job_error:
@@ -1458,7 +1462,8 @@ struct lpfc_dmabufext {
 
 	if (job) {
 		bsg_reply->result = rc;
-		fc_bsg_jobdone(job);
+		fc_bsg_jobdone(job, bsg_reply->result,
+			       bsg_reply->reply_payload_rcv_len);
 	}
 	return;
 }
@@ -1886,7 +1891,8 @@ struct lpfc_dmabufext {
 	bsg_reply->result = rc;
 	/* complete the job back to userspace if no error */
 	if (rc == 0)
-		fc_bsg_jobdone(job);
+		fc_bsg_jobdone(job, bsg_reply->result,
+			       bsg_reply->reply_payload_rcv_len);
 	return rc;
 }
 
@@ -2175,7 +2181,8 @@ struct lpfc_dmabufext {
 	bsg_reply->result = rc;
 	/* complete the job back to userspace if no error */
 	if (rc == 0)
-		fc_bsg_jobdone(job);
+		fc_bsg_jobdone(job, bsg_reply->result,
+			       bsg_reply->reply_payload_rcv_len);
 	return rc;
 }
 
@@ -2289,7 +2296,8 @@ struct lpfc_dmabufext {
 	bsg_reply->result = rc;
 	/* complete the job back to userspace if no error */
 	if (rc == 0)
-		fc_bsg_jobdone(job);
+		fc_bsg_jobdone(job, bsg_reply->result,
+			       bsg_reply->reply_payload_rcv_len);
 	return rc;
 }
 
@@ -2441,7 +2449,8 @@ struct lpfc_dmabufext {
 	bsg_reply->result = rc;
 	/* complete the job back to userspace if no error */
 	if (rc == 0)
-		fc_bsg_jobdone(job);
+		fc_bsg_jobdone(job, bsg_reply->result,
+			       bsg_reply->reply_payload_rcv_len);
 	return rc;
 }
 
@@ -3301,7 +3310,8 @@ static int lpfcdiag_loop_post_rxbufs(struct lpfc_hba *phba, uint16_t rxxri,
 	job->dd_data = NULL;
 	/* complete the job back to userspace if no error */
 	if (rc == IOCB_SUCCESS)
-		fc_bsg_jobdone(job);
+		fc_bsg_jobdone(job, bsg_reply->result,
+			       bsg_reply->reply_payload_rcv_len);
 	return rc;
 }
 
@@ -3344,7 +3354,8 @@ static int lpfcdiag_loop_post_rxbufs(struct lpfc_hba *phba, uint16_t rxxri,
 job_error:
 	bsg_reply->result = rc;
 	if (rc == 0)
-		fc_bsg_jobdone(job);
+		fc_bsg_jobdone(job, bsg_reply->result,
+			       bsg_reply->reply_payload_rcv_len);
 	return rc;
 }
 
@@ -3409,7 +3420,8 @@ static int lpfcdiag_loop_post_rxbufs(struct lpfc_hba *phba, uint16_t rxxri,
 
 	if (job) {
 		bsg_reply->result = 0;
-		fc_bsg_jobdone(job);
+		fc_bsg_jobdone(job, bsg_reply->result,
+			       bsg_reply->reply_payload_rcv_len);
 	}
 	return;
 }
@@ -3635,6 +3647,7 @@ static int lpfc_bsg_check_cmd_access(struct lpfc_hba *phba,
 lpfc_bsg_issue_read_mbox_ext_cmpl(struct lpfc_hba *phba, LPFC_MBOXQ_t *pmboxq)
 {
 	struct fc_bsg_job *job;
+	struct fc_bsg_reply *bsg_reply;
 
 	job = lpfc_bsg_issue_mbox_ext_handle_job(phba, pmboxq);
 
@@ -3654,9 +3667,11 @@ static int lpfc_bsg_check_cmd_access(struct lpfc_hba *phba,
 	mempool_free(pmboxq, phba->mbox_mem_pool);
 
 	/* if the job is still active, call job done */
-	if (job)
-		fc_bsg_jobdone(job);
-
+	if (job) {
+		bsg_reply = job->reply;
+		fc_bsg_jobdone(job, bsg_reply->result,
+			       bsg_reply->reply_payload_rcv_len);
+	}
 	return;
 }
 
@@ -3672,6 +3687,7 @@ static int lpfc_bsg_check_cmd_access(struct lpfc_hba *phba,
 lpfc_bsg_issue_write_mbox_ext_cmpl(struct lpfc_hba *phba, LPFC_MBOXQ_t *pmboxq)
 {
 	struct fc_bsg_job *job;
+	struct fc_bsg_reply *bsg_reply;
 
 	job = lpfc_bsg_issue_mbox_ext_handle_job(phba, pmboxq);
 
@@ -3689,8 +3705,11 @@ static int lpfc_bsg_check_cmd_access(struct lpfc_hba *phba,
 	lpfc_bsg_mbox_ext_session_reset(phba);
 
 	/* if the job is still active, call job done */
-	if (job)
-		fc_bsg_jobdone(job);
+	if (job) {
+		bsg_reply = job->reply;
+		fc_bsg_jobdone(job, bsg_reply->result,
+			       bsg_reply->reply_payload_rcv_len);
+	}
 
 	return;
 }
@@ -4131,7 +4150,8 @@ static int lpfc_bsg_check_cmd_access(struct lpfc_hba *phba,
 	/* wait for additoinal external buffers */
 
 	bsg_reply->result = 0;
-	fc_bsg_jobdone(job);
+	fc_bsg_jobdone(job, bsg_reply->result,
+		       bsg_reply->reply_payload_rcv_len);
 	return SLI_CONFIG_HANDLED;
 
 job_error:
@@ -4357,7 +4377,8 @@ static int lpfc_bsg_check_cmd_access(struct lpfc_hba *phba,
 	}
 
 	bsg_reply->result = 0;
-	fc_bsg_jobdone(job);
+	fc_bsg_jobdone(job, bsg_reply->result,
+		       bsg_reply->reply_payload_rcv_len);
 
 	return SLI_CONFIG_HANDLED;
 }
@@ -4473,7 +4494,8 @@ static int lpfc_bsg_check_cmd_access(struct lpfc_hba *phba,
 
 	/* wait for additoinal external buffers */
 	bsg_reply->result = 0;
-	fc_bsg_jobdone(job);
+	fc_bsg_jobdone(job, bsg_reply->result,
+		       bsg_reply->reply_payload_rcv_len);
 	return SLI_CONFIG_HANDLED;
 
 job_error:
@@ -4941,7 +4963,8 @@ static int lpfc_bsg_check_cmd_access(struct lpfc_hba *phba,
 		/* job done */
 		bsg_reply->result = 0;
 		job->dd_data = NULL;
-		fc_bsg_jobdone(job);
+		fc_bsg_jobdone(job, bsg_reply->result,
+			       bsg_reply->reply_payload_rcv_len);
 	} else if (rc == 1)
 		/* job submitted, will complete later*/
 		rc = 0; /* return zero, no error */
@@ -5051,7 +5074,8 @@ static int lpfc_bsg_check_cmd_access(struct lpfc_hba *phba,
 
 	if (job) {
 		bsg_reply->result = rc;
-		fc_bsg_jobdone(job);
+		fc_bsg_jobdone(job, bsg_reply->result,
+			       bsg_reply->reply_payload_rcv_len);
 	}
 
 	return;
diff --git a/drivers/scsi/qla2xxx/qla_bsg.c b/drivers/scsi/qla2xxx/qla_bsg.c
index 1bca77b..9293d5a 100644
--- a/drivers/scsi/qla2xxx/qla_bsg.c
+++ b/drivers/scsi/qla2xxx/qla_bsg.c
@@ -20,7 +20,8 @@
 	struct fc_bsg_reply *bsg_reply = bsg_job->reply;
 
 	bsg_reply->result = res;
-	fc_bsg_jobdone(bsg_job);
+	fc_bsg_jobdone(bsg_job, bsg_reply->result,
+		       bsg_reply->reply_payload_rcv_len);
 	sp->free(vha, sp);
 }
 
@@ -242,7 +243,8 @@
 	}
 exit_fcp_prio_cfg:
 	if (!ret)
-		fc_bsg_jobdone(bsg_job);
+		fc_bsg_jobdone(bsg_job, bsg_reply->result,
+			       bsg_reply->reply_payload_rcv_len);
 	return ret;
 }
 
@@ -939,7 +941,8 @@
 	    bsg_job->request_payload.sg_list,
 	    bsg_job->request_payload.sg_cnt, DMA_TO_DEVICE);
 	if (!rval)
-		fc_bsg_jobdone(bsg_job);
+		fc_bsg_jobdone(bsg_job, bsg_reply->result,
+			       bsg_reply->reply_payload_rcv_len);
 	return rval;
 }
 
@@ -972,7 +975,8 @@
 		ql_dbg(ql_dbg_user, vha, 0x7031,
 		    "Vendor request 84xx reset completed.\n");
 		bsg_reply->result = DID_OK;
-		fc_bsg_jobdone(bsg_job);
+		fc_bsg_jobdone(bsg_job, bsg_reply->result,
+			       bsg_reply->reply_payload_rcv_len);
 	}
 
 	return rval;
@@ -1085,7 +1089,8 @@
 		bsg_job->request_payload.sg_cnt, DMA_TO_DEVICE);
 
 	if (!rval)
-		fc_bsg_jobdone(bsg_job);
+		fc_bsg_jobdone(bsg_job, bsg_reply->result,
+			       bsg_reply->reply_payload_rcv_len);
 	return rval;
 }
 
@@ -1282,7 +1287,8 @@
 	dma_pool_free(ha->s_dma_pool, mn, mn_dma);
 
 	if (!rval)
-		fc_bsg_jobdone(bsg_job);
+		fc_bsg_jobdone(bsg_job, bsg_reply->result,
+			       bsg_reply->reply_payload_rcv_len);
 	return rval;
 }
 
@@ -1368,7 +1374,8 @@
 		}
 
 		bsg_reply->result = DID_OK;
-		fc_bsg_jobdone(bsg_job);
+		fc_bsg_jobdone(bsg_job, bsg_reply->result,
+			       bsg_reply->reply_payload_rcv_len);
 	}
 
 	return rval;
@@ -1476,7 +1483,8 @@
 	ha->optrom_buffer = NULL;
 	ha->optrom_state = QLA_SWAITING;
 	mutex_unlock(&ha->optrom_mutex);
-	fc_bsg_jobdone(bsg_job);
+	fc_bsg_jobdone(bsg_job, bsg_reply->result,
+		       bsg_reply->reply_payload_rcv_len);
 	return rval;
 }
 
@@ -1511,7 +1519,8 @@
 	ha->optrom_buffer = NULL;
 	ha->optrom_state = QLA_SWAITING;
 	mutex_unlock(&ha->optrom_mutex);
-	fc_bsg_jobdone(bsg_job);
+	fc_bsg_jobdone(bsg_job, bsg_reply->result,
+		       bsg_reply->reply_payload_rcv_len);
 	return rval;
 }
 
@@ -1561,7 +1570,8 @@
 done:
 	bsg_job->reply_len = sizeof(struct fc_bsg_reply);
 	bsg_reply->result = DID_OK << 16;
-	fc_bsg_jobdone(bsg_job);
+	fc_bsg_jobdone(bsg_job, bsg_reply->result,
+		       bsg_reply->reply_payload_rcv_len);
 
 	return 0;
 }
@@ -1610,7 +1620,8 @@
 	bsg_job->reply_len = sizeof(struct fc_bsg_reply);
 	bsg_reply->reply_payload_rcv_len = sizeof(*sr);
 	bsg_reply->result = DID_OK << 16;
-	fc_bsg_jobdone(bsg_job);
+	fc_bsg_jobdone(bsg_job, bsg_reply->result,
+		       bsg_reply->reply_payload_rcv_len);
 
 	return 0;
 }
@@ -1655,7 +1666,8 @@
 done:
 	bsg_job->reply_len = sizeof(struct fc_bsg_reply);
 	bsg_reply->result = DID_OK << 16;
-	fc_bsg_jobdone(bsg_job);
+	fc_bsg_jobdone(bsg_job, bsg_reply->result,
+		       bsg_reply->reply_payload_rcv_len);
 
 	return 0;
 }
@@ -1699,7 +1711,8 @@
 done:
 	bsg_job->reply_len = sizeof(struct fc_bsg_reply);
 	bsg_reply->result = DID_OK << 16;
-	fc_bsg_jobdone(bsg_job);
+	fc_bsg_jobdone(bsg_job, bsg_reply->result,
+		       bsg_reply->reply_payload_rcv_len);
 
 	return 0;
 }
@@ -1747,7 +1760,8 @@
 	bsg_job->reply_len = sizeof(struct fc_bsg_reply);
 	bsg_reply->reply_payload_rcv_len = sizeof(*i2c);
 	bsg_reply->result = DID_OK << 16;
-	fc_bsg_jobdone(bsg_job);
+	fc_bsg_jobdone(bsg_job, bsg_reply->result,
+		       bsg_reply->reply_payload_rcv_len);
 
 	return 0;
 }
@@ -1925,7 +1939,8 @@
 	bsg_job->reply_len = sizeof(struct fc_bsg_reply);
 	bsg_reply->reply_payload_rcv_len = 0;
 	bsg_reply->result = (DID_OK) << 16;
-	fc_bsg_jobdone(bsg_job);
+	fc_bsg_jobdone(bsg_job, bsg_reply->result,
+		       bsg_reply->reply_payload_rcv_len);
 	/* Always return success, vendor rsp carries correct status */
 	return 0;
 }
@@ -2090,7 +2105,8 @@
 
 	bsg_job->reply_len = sizeof(struct fc_bsg_reply);
 	bsg_reply->result = DID_OK << 16;
-	fc_bsg_jobdone(bsg_job);
+	fc_bsg_jobdone(bsg_job, bsg_reply->result,
+		       bsg_reply->reply_payload_rcv_len);
 	return 0;
 }
 
@@ -2131,7 +2147,8 @@
 
 	bsg_job->reply_len = sizeof(struct fc_bsg_reply);
 	bsg_reply->result = DID_OK << 16;
-	fc_bsg_jobdone(bsg_job);
+	fc_bsg_jobdone(bsg_job, bsg_reply->result,
+		       bsg_reply->reply_payload_rcv_len);
 	return 0;
 }
 
@@ -2162,7 +2179,8 @@
 
 	bsg_job->reply_len = sizeof(struct fc_bsg_reply);
 	bsg_reply->result = DID_OK << 16;
-	fc_bsg_jobdone(bsg_job);
+	fc_bsg_jobdone(bsg_job, bsg_reply->result,
+		       bsg_reply->reply_payload_rcv_len);
 	return 0;
 }
 
@@ -2207,7 +2225,8 @@
 
 	bsg_job->reply_len = sizeof(struct fc_bsg_reply);
 	bsg_reply->result = DID_OK << 16;
-	fc_bsg_jobdone(bsg_job);
+	fc_bsg_jobdone(bsg_job, bsg_reply->result,
+		       bsg_reply->reply_payload_rcv_len);
 	return 0;
 }
 
@@ -2265,7 +2284,8 @@
 
 	bsg_job->reply_len = sizeof(struct fc_bsg_reply);
 	bsg_reply->result = DID_OK << 16;
-	fc_bsg_jobdone(bsg_job);
+	fc_bsg_jobdone(bsg_job, bsg_reply->result,
+		       bsg_reply->reply_payload_rcv_len);
 	return 0;
 }
 
@@ -2321,7 +2341,8 @@
 
 	bsg_job->reply_len = sizeof(*bsg_reply);
 	bsg_reply->result = DID_OK << 16;
-	fc_bsg_jobdone(bsg_job);
+	fc_bsg_jobdone(bsg_job, bsg_reply->result,
+		       bsg_reply->reply_payload_rcv_len);
 
 	dma_free_coherent(&ha->pdev->dev, sizeof(*stats),
 		stats, stats_dma);
@@ -2364,7 +2385,8 @@
 
 	bsg_job->reply_len = sizeof(*bsg_reply);
 	bsg_reply->result = DID_OK << 16;
-	fc_bsg_jobdone(bsg_job);
+	fc_bsg_jobdone(bsg_job, bsg_reply->result,
+		       bsg_reply->reply_payload_rcv_len);
 
 	kfree(dd);
 
diff --git a/drivers/scsi/scsi_transport_fc.c b/drivers/scsi/scsi_transport_fc.c
index 4149dac..9744476 100644
--- a/drivers/scsi/scsi_transport_fc.c
+++ b/drivers/scsi/scsi_transport_fc.c
@@ -3582,15 +3582,17 @@ struct fc_vport *
  * fc_bsg_jobdone - completion routine for bsg requests that the LLD has
  *                  completed
  * @job:	fc_bsg_job that is complete
+ * @result:	job reply result
+ * @reply_payload_rcv_len: length of payload received
  */
-void fc_bsg_jobdone(struct fc_bsg_job *job)
+void fc_bsg_jobdone(struct fc_bsg_job *job, int result,
+		    unsigned int reply_payload_rcv_len)
 {
 	struct request *req = job->req;
 	struct request *rsp = req->next_rq;
-	struct fc_bsg_reply *bsg_reply = job->reply;
 	int err;
 
-	err = job->req->errors = bsg_reply->result;
+	err = job->req->errors = result;
 
 	if (err < 0)
 		/* we're only returning the result field in the reply */
@@ -3602,11 +3604,10 @@ void fc_bsg_jobdone(struct fc_bsg_job *job)
 	req->resid_len = 0;
 
 	if (rsp) {
-		WARN_ON(bsg_reply->reply_payload_rcv_len > rsp->resid_len);
+		WARN_ON(reply_payload_rcv_len > rsp->resid_len);
 
 		/* set reply (bidi) residual */
-		rsp->resid_len -= min(bsg_reply->reply_payload_rcv_len,
-				      rsp->resid_len);
+		rsp->resid_len -= min(reply_payload_rcv_len, rsp->resid_len);
 	}
 	blk_complete_request(req);
 }
@@ -3847,7 +3848,8 @@ enum fc_dispatch_result {
 	bsg_reply->reply_payload_rcv_len = 0;
 	bsg_reply->result = ret;
 	job->reply_len = sizeof(uint32_t);
-	fc_bsg_jobdone(job);
+	fc_bsg_jobdone(job, bsg_reply->result,
+		       bsg_reply->reply_payload_rcv_len);
 	return FC_DISPATCH_UNLOCKED;
 }
 
@@ -3924,7 +3926,8 @@ enum fc_dispatch_result {
 	bsg_reply->reply_payload_rcv_len = 0;
 	bsg_reply->result = ret;
 	job->reply_len = sizeof(uint32_t);
-	fc_bsg_jobdone(job);
+	fc_bsg_jobdone(job, bsg_reply->result,
+		       bsg_reply->reply_payload_rcv_len);
 	return FC_DISPATCH_UNLOCKED;
 }
 
@@ -3984,7 +3987,8 @@ enum fc_dispatch_result {
 			bsg_reply->reply_payload_rcv_len = 0;
 			bsg_reply->result = -ENOMSG;
 			job->reply_len = sizeof(uint32_t);
-			fc_bsg_jobdone(job);
+			fc_bsg_jobdone(job, bsg_reply->result,
+				       bsg_reply->reply_payload_rcv_len);
 			spin_lock_irq(q->queue_lock);
 			continue;
 		}
diff --git a/include/scsi/scsi_transport_fc.h b/include/scsi/scsi_transport_fc.h
index 9ef583f..eca8ed7 100644
--- a/include/scsi/scsi_transport_fc.h
+++ b/include/scsi/scsi_transport_fc.h
@@ -841,6 +841,7 @@ struct fc_vport *fc_vport_create(struct Scsi_Host *shost, int channel,
 		struct fc_vport_identifiers *);
 int fc_vport_terminate(struct fc_vport *vport);
 int fc_block_scsi_eh(struct scsi_cmnd *cmnd);
-void fc_bsg_jobdone(struct fc_bsg_job *job);
+void fc_bsg_jobdone(struct fc_bsg_job *job, int result,
+		    unsigned int reply_payload_rcv_len);
 
 #endif /* SCSI_TRANSPORT_FC_H */
-- 
1.8.5.6
