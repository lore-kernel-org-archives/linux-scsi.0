From: Johannes Thumshirn <jthumshirn-l3A5Bk7waGM@public.gmane.org>
Subject: [PATCH v4 03/15] scsi: fc: Export fc_bsg_jobdone and
	use it in FC drivers
Date: Thu, 17 Nov 2016 10:31:13 +0100
Message-ID: <ff27b6d9ce9b6841eddec10fde59657e1c5cd3c8.1479374719.git.jthumshirn@suse.de>
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

Export fc_bsg_jobdone so drivers can use it directly instead of doing
the round-trip via struct fc_bsg_job::job_done() and use it in the LLDDs.
That way we can also unify the interfaces of fc_bsg_jobdone and bsg_job_done.

As we've converted all LLDDs over to use fc_bsg_jobdone() directly,
we can remove the function pointer from struct fc_bsg_job as well.

Signed-off-by: Johannes Thumshirn <jthumshirn-l3A5Bk7waGM@public.gmane.org>
Reviewed-by: Hannes Reinecke <hare-IBi9RG/b67k@public.gmane.org>
Reviewed-by: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Acked-by: Tyrel Datwyler <tyreld-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
---
 drivers/s390/scsi/zfcp_fc.c      |  2 +-
 drivers/scsi/bfa/bfad_bsg.c      |  6 ++--
 drivers/scsi/ibmvscsi/ibmvfc.c   |  3 +-
 drivers/scsi/libfc/fc_lport.c    |  6 ++--
 drivers/scsi/lpfc/lpfc_bsg.c     | 71 +++++++++++++++++++++++++++-------------
 drivers/scsi/qla2xxx/qla_bsg.c   | 66 ++++++++++++++++++++++++-------------
 drivers/scsi/scsi_transport_fc.c | 25 +++++++-------
 include/scsi/scsi_transport_fc.h |  3 +-
 8 files changed, 119 insertions(+), 63 deletions(-)

diff --git a/drivers/s390/scsi/zfcp_fc.c b/drivers/s390/scsi/zfcp_fc.c
index 4c4023f..87f6330 100644
--- a/drivers/s390/scsi/zfcp_fc.c
+++ b/drivers/s390/scsi/zfcp_fc.c
@@ -892,7 +892,7 @@ static void zfcp_fc_ct_els_job_handler(void *data)
 	jr->reply_payload_rcv_len = job->reply_payload.payload_len;
 	jr->reply_data.ctels_reply.status = FC_CTELS_STATUS_OK;
 	jr->result = zfcp_ct_els->status ? -EIO : 0;
-	job->job_done(job);
+	fc_bsg_jobdone(job, jr->result, jr->reply_payload_rcv_len);
 }
 
 static struct zfcp_fc_wka_port *zfcp_fc_job_wka_port(struct fc_bsg_job *job)
diff --git a/drivers/scsi/bfa/bfad_bsg.c b/drivers/scsi/bfa/bfad_bsg.c
index 48366d8..e49a6c8 100644
--- a/drivers/scsi/bfa/bfad_bsg.c
+++ b/drivers/scsi/bfa/bfad_bsg.c
@@ -3180,7 +3180,8 @@
 	bsg_reply->reply_payload_rcv_len = job->reply_payload.payload_len;
 	bsg_reply->result = rc;
 
-	job->job_done(job);
+	fc_bsg_jobdone(job, bsg_reply->result,
+		       bsg_reply->reply_payload_rcv_len);
 	return rc;
 error:
 	/* free the command buffer */
@@ -3556,7 +3557,8 @@ struct bfad_buf_info *
 	bsg_reply->result = rc;
 
 	if (rc == BFA_STATUS_OK)
-		job->job_done(job);
+		fc_bsg_jobdone(job, bsg_reply->result,
+			       bsg_reply->reply_payload_rcv_len);
 
 	return rc;
 }
diff --git a/drivers/scsi/ibmvscsi/ibmvfc.c b/drivers/scsi/ibmvscsi/ibmvfc.c
index 7c17a7e..6070361 100644
--- a/drivers/scsi/ibmvscsi/ibmvfc.c
+++ b/drivers/scsi/ibmvscsi/ibmvfc.c
@@ -1945,7 +1945,8 @@ static int ibmvfc_bsg_request(struct fc_bsg_job *job)
 	ibmvfc_free_event(evt);
 	spin_unlock_irqrestore(vhost->host->host_lock, flags);
 	bsg_reply->result = rc;
-	job->job_done(job);
+	fc_bsg_jobdone(job, bsg_reply->result,
+		       bsg_reply->reply_payload_rcv_len);
 	rc = 0;
 out:
 	dma_unmap_sg(vhost->dev, job->request_payload.sg_list,
diff --git a/drivers/scsi/libfc/fc_lport.c b/drivers/scsi/libfc/fc_lport.c
index 2de6093..8ea6e93 100644
--- a/drivers/scsi/libfc/fc_lport.c
+++ b/drivers/scsi/libfc/fc_lport.c
@@ -1913,7 +1913,8 @@ static void fc_lport_bsg_resp(struct fc_seq *sp, struct fc_frame *fp,
 			-ECONNABORTED : -ETIMEDOUT;
 		job->reply_len = sizeof(uint32_t);
 		job->state_flags |= FC_RQST_STATE_DONE;
-		job->job_done(job);
+		fc_bsg_jobdone(job, bsg_reply->result,
+			       bsg_reply->reply_payload_rcv_len);
 		kfree(info);
 		return;
 	}
@@ -1948,7 +1949,8 @@ static void fc_lport_bsg_resp(struct fc_seq *sp, struct fc_frame *fp,
 				job->reply_payload.payload_len;
 		bsg_reply->result = 0;
 		job->state_flags |= FC_RQST_STATE_DONE;
-		job->job_done(job);
+		fc_bsg_jobdone(job, bsg_reply->result,
+			       bsg_reply->reply_payload_rcv_len);
 		kfree(info);
 	}
 	fc_frame_free(fp);
diff --git a/drivers/scsi/lpfc/lpfc_bsg.c b/drivers/scsi/lpfc/lpfc_bsg.c
index f09a325..46f0b8f 100644
--- a/drivers/scsi/lpfc/lpfc_bsg.c
+++ b/drivers/scsi/lpfc/lpfc_bsg.c
@@ -371,7 +371,8 @@ struct lpfc_dmabufext {
 
 	if (job) {
 		bsg_reply->result = rc;
-		job->job_done(job);
+		fc_bsg_jobdone(job, bsg_reply->result,
+			       bsg_reply->reply_payload_rcv_len);
 	}
 	return;
 }
@@ -644,7 +645,8 @@ struct lpfc_dmabufext {
 
 	if (job) {
 		bsg_reply->result = rc;
-		job->job_done(job);
+		fc_bsg_jobdone(job, bsg_reply->result,
+			       bsg_reply->reply_payload_rcv_len);
 	}
 	return;
 }
@@ -1136,7 +1138,8 @@ struct lpfc_dmabufext {
 			job->dd_data = NULL;
 			/* complete the job back to userspace */
 			spin_unlock_irqrestore(&phba->ct_ev_lock, flags);
-			job->job_done(job);
+			fc_bsg_jobdone(job, bsg_reply->result,
+				       bsg_reply->reply_payload_rcv_len);
 			spin_lock_irqsave(&phba->ct_ev_lock, flags);
 		}
 	}
@@ -1361,7 +1364,8 @@ struct lpfc_dmabufext {
 	spin_unlock_irqrestore(&phba->ct_ev_lock, flags);
 	job->dd_data = NULL;
 	bsg_reply->result = 0;
-	job->job_done(job);
+	fc_bsg_jobdone(job, bsg_reply->result,
+		       bsg_reply->reply_payload_rcv_len);
 	return 0;
 
 job_error:
@@ -1458,7 +1462,8 @@ struct lpfc_dmabufext {
 
 	if (job) {
 		bsg_reply->result = rc;
-		job->job_done(job);
+		fc_bsg_jobdone(job, bsg_reply->result,
+			       bsg_reply->reply_payload_rcv_len);
 	}
 	return;
 }
@@ -1886,7 +1891,8 @@ struct lpfc_dmabufext {
 	bsg_reply->result = rc;
 	/* complete the job back to userspace if no error */
 	if (rc == 0)
-		job->job_done(job);
+		fc_bsg_jobdone(job, bsg_reply->result,
+			       bsg_reply->reply_payload_rcv_len);
 	return rc;
 }
 
@@ -2175,7 +2181,8 @@ struct lpfc_dmabufext {
 	bsg_reply->result = rc;
 	/* complete the job back to userspace if no error */
 	if (rc == 0)
-		job->job_done(job);
+		fc_bsg_jobdone(job, bsg_reply->result,
+			       bsg_reply->reply_payload_rcv_len);
 	return rc;
 }
 
@@ -2289,7 +2296,8 @@ struct lpfc_dmabufext {
 	bsg_reply->result = rc;
 	/* complete the job back to userspace if no error */
 	if (rc == 0)
-		job->job_done(job);
+		fc_bsg_jobdone(job, bsg_reply->result,
+			       bsg_reply->reply_payload_rcv_len);
 	return rc;
 }
 
@@ -2441,7 +2449,8 @@ struct lpfc_dmabufext {
 	bsg_reply->result = rc;
 	/* complete the job back to userspace if no error */
 	if (rc == 0)
-		job->job_done(job);
+		fc_bsg_jobdone(job, bsg_reply->result,
+			       bsg_reply->reply_payload_rcv_len);
 	return rc;
 }
 
@@ -3301,7 +3310,8 @@ static int lpfcdiag_loop_post_rxbufs(struct lpfc_hba *phba, uint16_t rxxri,
 	job->dd_data = NULL;
 	/* complete the job back to userspace if no error */
 	if (rc == IOCB_SUCCESS)
-		job->job_done(job);
+		fc_bsg_jobdone(job, bsg_reply->result,
+			       bsg_reply->reply_payload_rcv_len);
 	return rc;
 }
 
@@ -3344,7 +3354,8 @@ static int lpfcdiag_loop_post_rxbufs(struct lpfc_hba *phba, uint16_t rxxri,
 job_error:
 	bsg_reply->result = rc;
 	if (rc == 0)
-		job->job_done(job);
+		fc_bsg_jobdone(job, bsg_reply->result,
+			       bsg_reply->reply_payload_rcv_len);
 	return rc;
 }
 
@@ -3409,7 +3420,8 @@ static int lpfcdiag_loop_post_rxbufs(struct lpfc_hba *phba, uint16_t rxxri,
 
 	if (job) {
 		bsg_reply->result = 0;
-		job->job_done(job);
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
-		job->job_done(job);
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
-		job->job_done(job);
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
-	job->job_done(job);
+	fc_bsg_jobdone(job, bsg_reply->result,
+		       bsg_reply->reply_payload_rcv_len);
 	return SLI_CONFIG_HANDLED;
 
 job_error:
@@ -4357,7 +4377,8 @@ static int lpfc_bsg_check_cmd_access(struct lpfc_hba *phba,
 	}
 
 	bsg_reply->result = 0;
-	job->job_done(job);
+	fc_bsg_jobdone(job, bsg_reply->result,
+		       bsg_reply->reply_payload_rcv_len);
 
 	return SLI_CONFIG_HANDLED;
 }
@@ -4473,7 +4494,8 @@ static int lpfc_bsg_check_cmd_access(struct lpfc_hba *phba,
 
 	/* wait for additoinal external buffers */
 	bsg_reply->result = 0;
-	job->job_done(job);
+	fc_bsg_jobdone(job, bsg_reply->result,
+		       bsg_reply->reply_payload_rcv_len);
 	return SLI_CONFIG_HANDLED;
 
 job_error:
@@ -4941,7 +4963,8 @@ static int lpfc_bsg_check_cmd_access(struct lpfc_hba *phba,
 		/* job done */
 		bsg_reply->result = 0;
 		job->dd_data = NULL;
-		job->job_done(job);
+		fc_bsg_jobdone(job, bsg_reply->result,
+			       bsg_reply->reply_payload_rcv_len);
 	} else if (rc == 1)
 		/* job submitted, will complete later*/
 		rc = 0; /* return zero, no error */
@@ -5051,7 +5074,8 @@ static int lpfc_bsg_check_cmd_access(struct lpfc_hba *phba,
 
 	if (job) {
 		bsg_reply->result = rc;
-		job->job_done(job);
+		fc_bsg_jobdone(job, bsg_reply->result,
+			       bsg_reply->reply_payload_rcv_len);
 	}
 
 	return;
@@ -5269,7 +5293,8 @@ static int lpfc_bsg_check_cmd_access(struct lpfc_hba *phba,
 job_error:
 	bsg_reply->result = rc;
 	if (rc == 0)
-		job->job_done(job);
+		fc_bsg_jobdone(job, bsg_reply->result,
+			       bsg_reply->reply_payload_rcv_len);
 	return rc;
 }
 
diff --git a/drivers/scsi/qla2xxx/qla_bsg.c b/drivers/scsi/qla2xxx/qla_bsg.c
index 40f7c10..9293d5a 100644
--- a/drivers/scsi/qla2xxx/qla_bsg.c
+++ b/drivers/scsi/qla2xxx/qla_bsg.c
@@ -20,7 +20,8 @@
 	struct fc_bsg_reply *bsg_reply = bsg_job->reply;
 
 	bsg_reply->result = res;
-	bsg_job->job_done(bsg_job);
+	fc_bsg_jobdone(bsg_job, bsg_reply->result,
+		       bsg_reply->reply_payload_rcv_len);
 	sp->free(vha, sp);
 }
 
@@ -242,7 +243,8 @@
 	}
 exit_fcp_prio_cfg:
 	if (!ret)
-		bsg_job->job_done(bsg_job);
+		fc_bsg_jobdone(bsg_job, bsg_reply->result,
+			       bsg_reply->reply_payload_rcv_len);
 	return ret;
 }
 
@@ -939,7 +941,8 @@
 	    bsg_job->request_payload.sg_list,
 	    bsg_job->request_payload.sg_cnt, DMA_TO_DEVICE);
 	if (!rval)
-		bsg_job->job_done(bsg_job);
+		fc_bsg_jobdone(bsg_job, bsg_reply->result,
+			       bsg_reply->reply_payload_rcv_len);
 	return rval;
 }
 
@@ -972,7 +975,8 @@
 		ql_dbg(ql_dbg_user, vha, 0x7031,
 		    "Vendor request 84xx reset completed.\n");
 		bsg_reply->result = DID_OK;
-		bsg_job->job_done(bsg_job);
+		fc_bsg_jobdone(bsg_job, bsg_reply->result,
+			       bsg_reply->reply_payload_rcv_len);
 	}
 
 	return rval;
@@ -1085,7 +1089,8 @@
 		bsg_job->request_payload.sg_cnt, DMA_TO_DEVICE);
 
 	if (!rval)
-		bsg_job->job_done(bsg_job);
+		fc_bsg_jobdone(bsg_job, bsg_reply->result,
+			       bsg_reply->reply_payload_rcv_len);
 	return rval;
 }
 
@@ -1282,7 +1287,8 @@
 	dma_pool_free(ha->s_dma_pool, mn, mn_dma);
 
 	if (!rval)
-		bsg_job->job_done(bsg_job);
+		fc_bsg_jobdone(bsg_job, bsg_reply->result,
+			       bsg_reply->reply_payload_rcv_len);
 	return rval;
 }
 
@@ -1368,7 +1374,8 @@
 		}
 
 		bsg_reply->result = DID_OK;
-		bsg_job->job_done(bsg_job);
+		fc_bsg_jobdone(bsg_job, bsg_reply->result,
+			       bsg_reply->reply_payload_rcv_len);
 	}
 
 	return rval;
@@ -1476,7 +1483,8 @@
 	ha->optrom_buffer = NULL;
 	ha->optrom_state = QLA_SWAITING;
 	mutex_unlock(&ha->optrom_mutex);
-	bsg_job->job_done(bsg_job);
+	fc_bsg_jobdone(bsg_job, bsg_reply->result,
+		       bsg_reply->reply_payload_rcv_len);
 	return rval;
 }
 
@@ -1511,7 +1519,8 @@
 	ha->optrom_buffer = NULL;
 	ha->optrom_state = QLA_SWAITING;
 	mutex_unlock(&ha->optrom_mutex);
-	bsg_job->job_done(bsg_job);
+	fc_bsg_jobdone(bsg_job, bsg_reply->result,
+		       bsg_reply->reply_payload_rcv_len);
 	return rval;
 }
 
@@ -1561,7 +1570,8 @@
 done:
 	bsg_job->reply_len = sizeof(struct fc_bsg_reply);
 	bsg_reply->result = DID_OK << 16;
-	bsg_job->job_done(bsg_job);
+	fc_bsg_jobdone(bsg_job, bsg_reply->result,
+		       bsg_reply->reply_payload_rcv_len);
 
 	return 0;
 }
@@ -1610,7 +1620,8 @@
 	bsg_job->reply_len = sizeof(struct fc_bsg_reply);
 	bsg_reply->reply_payload_rcv_len = sizeof(*sr);
 	bsg_reply->result = DID_OK << 16;
-	bsg_job->job_done(bsg_job);
+	fc_bsg_jobdone(bsg_job, bsg_reply->result,
+		       bsg_reply->reply_payload_rcv_len);
 
 	return 0;
 }
@@ -1655,7 +1666,8 @@
 done:
 	bsg_job->reply_len = sizeof(struct fc_bsg_reply);
 	bsg_reply->result = DID_OK << 16;
-	bsg_job->job_done(bsg_job);
+	fc_bsg_jobdone(bsg_job, bsg_reply->result,
+		       bsg_reply->reply_payload_rcv_len);
 
 	return 0;
 }
@@ -1699,7 +1711,8 @@
 done:
 	bsg_job->reply_len = sizeof(struct fc_bsg_reply);
 	bsg_reply->result = DID_OK << 16;
-	bsg_job->job_done(bsg_job);
+	fc_bsg_jobdone(bsg_job, bsg_reply->result,
+		       bsg_reply->reply_payload_rcv_len);
 
 	return 0;
 }
@@ -1747,7 +1760,8 @@
 	bsg_job->reply_len = sizeof(struct fc_bsg_reply);
 	bsg_reply->reply_payload_rcv_len = sizeof(*i2c);
 	bsg_reply->result = DID_OK << 16;
-	bsg_job->job_done(bsg_job);
+	fc_bsg_jobdone(bsg_job, bsg_reply->result,
+		       bsg_reply->reply_payload_rcv_len);
 
 	return 0;
 }
@@ -1925,7 +1939,8 @@
 	bsg_job->reply_len = sizeof(struct fc_bsg_reply);
 	bsg_reply->reply_payload_rcv_len = 0;
 	bsg_reply->result = (DID_OK) << 16;
-	bsg_job->job_done(bsg_job);
+	fc_bsg_jobdone(bsg_job, bsg_reply->result,
+		       bsg_reply->reply_payload_rcv_len);
 	/* Always return success, vendor rsp carries correct status */
 	return 0;
 }
@@ -2090,7 +2105,8 @@
 
 	bsg_job->reply_len = sizeof(struct fc_bsg_reply);
 	bsg_reply->result = DID_OK << 16;
-	bsg_job->job_done(bsg_job);
+	fc_bsg_jobdone(bsg_job, bsg_reply->result,
+		       bsg_reply->reply_payload_rcv_len);
 	return 0;
 }
 
@@ -2131,7 +2147,8 @@
 
 	bsg_job->reply_len = sizeof(struct fc_bsg_reply);
 	bsg_reply->result = DID_OK << 16;
-	bsg_job->job_done(bsg_job);
+	fc_bsg_jobdone(bsg_job, bsg_reply->result,
+		       bsg_reply->reply_payload_rcv_len);
 	return 0;
 }
 
@@ -2162,7 +2179,8 @@
 
 	bsg_job->reply_len = sizeof(struct fc_bsg_reply);
 	bsg_reply->result = DID_OK << 16;
-	bsg_job->job_done(bsg_job);
+	fc_bsg_jobdone(bsg_job, bsg_reply->result,
+		       bsg_reply->reply_payload_rcv_len);
 	return 0;
 }
 
@@ -2207,7 +2225,8 @@
 
 	bsg_job->reply_len = sizeof(struct fc_bsg_reply);
 	bsg_reply->result = DID_OK << 16;
-	bsg_job->job_done(bsg_job);
+	fc_bsg_jobdone(bsg_job, bsg_reply->result,
+		       bsg_reply->reply_payload_rcv_len);
 	return 0;
 }
 
@@ -2265,7 +2284,8 @@
 
 	bsg_job->reply_len = sizeof(struct fc_bsg_reply);
 	bsg_reply->result = DID_OK << 16;
-	bsg_job->job_done(bsg_job);
+	fc_bsg_jobdone(bsg_job, bsg_reply->result,
+		       bsg_reply->reply_payload_rcv_len);
 	return 0;
 }
 
@@ -2321,7 +2341,8 @@
 
 	bsg_job->reply_len = sizeof(*bsg_reply);
 	bsg_reply->result = DID_OK << 16;
-	bsg_job->job_done(bsg_job);
+	fc_bsg_jobdone(bsg_job, bsg_reply->result,
+		       bsg_reply->reply_payload_rcv_len);
 
 	dma_free_coherent(&ha->pdev->dev, sizeof(*stats),
 		stats, stats_dma);
@@ -2364,7 +2385,8 @@
 
 	bsg_job->reply_len = sizeof(*bsg_reply);
 	bsg_reply->result = DID_OK << 16;
-	bsg_job->job_done(bsg_job);
+	fc_bsg_jobdone(bsg_job, bsg_reply->result,
+		       bsg_reply->reply_payload_rcv_len);
 
 	kfree(dd);
 
diff --git a/drivers/scsi/scsi_transport_fc.c b/drivers/scsi/scsi_transport_fc.c
index 02a83e5..66871c8 100644
--- a/drivers/scsi/scsi_transport_fc.c
+++ b/drivers/scsi/scsi_transport_fc.c
@@ -3582,16 +3582,17 @@ struct fc_vport *
  * fc_bsg_jobdone - completion routine for bsg requests that the LLD has
  *                  completed
  * @job:	fc_bsg_job that is complete
+ * @result:	job reply result
+ * @reply_payload_rcv_len: length of payload received
  */
-static void
-fc_bsg_jobdone(struct fc_bsg_job *job)
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
@@ -3603,14 +3604,14 @@ struct fc_vport *
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
+EXPORT_SYMBOL_GPL(fc_bsg_jobdone);
 
 /**
  * fc_bsg_softirq_done - softirq done routine for destroying the bsg requests
@@ -3742,7 +3743,6 @@ static void fc_bsg_softirq_done(struct request *rq)
 		if (ret)
 			goto failjob_rls_rqst_payload;
 	}
-	job->job_done = fc_bsg_jobdone;
 	if (rport)
 		job->dev = &rport->dev;
 	else
@@ -3846,7 +3846,8 @@ enum fc_dispatch_result {
 	bsg_reply->reply_payload_rcv_len = 0;
 	bsg_reply->result = ret;
 	job->reply_len = sizeof(uint32_t);
-	fc_bsg_jobdone(job);
+	fc_bsg_jobdone(job, bsg_reply->result,
+		       bsg_reply->reply_payload_rcv_len);
 	return FC_DISPATCH_UNLOCKED;
 }
 
@@ -3923,7 +3924,8 @@ enum fc_dispatch_result {
 	bsg_reply->reply_payload_rcv_len = 0;
 	bsg_reply->result = ret;
 	job->reply_len = sizeof(uint32_t);
-	fc_bsg_jobdone(job);
+	fc_bsg_jobdone(job, bsg_reply->result,
+		       bsg_reply->reply_payload_rcv_len);
 	return FC_DISPATCH_UNLOCKED;
 }
 
@@ -3983,7 +3985,8 @@ enum fc_dispatch_result {
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
index 921b097..eca8ed7 100644
--- a/include/scsi/scsi_transport_fc.h
+++ b/include/scsi/scsi_transport_fc.h
@@ -637,7 +637,6 @@ struct fc_bsg_job {
 	spinlock_t job_lock;
 	unsigned int state_flags;
 	unsigned int ref_cnt;
-	void (*job_done)(struct fc_bsg_job *);
 
 	struct fc_bsg_request *request;
 	struct fc_bsg_reply *reply;
@@ -842,5 +841,7 @@ struct fc_vport *fc_vport_create(struct Scsi_Host *shost, int channel,
 		struct fc_vport_identifiers *);
 int fc_vport_terminate(struct fc_vport *vport);
 int fc_block_scsi_eh(struct scsi_cmnd *cmnd);
+void fc_bsg_jobdone(struct fc_bsg_job *job, int result,
+		    unsigned int reply_payload_rcv_len);
 
 #endif /* SCSI_TRANSPORT_FC_H */
-- 
1.8.5.6
