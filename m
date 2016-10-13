From: Johannes Thumshirn <jthumshirn-l3A5Bk7waGM@public.gmane.org>
Subject: [PATCH v3 13/16] scsi: fc: use bsg_job_done
Date: Thu, 13 Oct 2016 17:00:29 +0200
Message-ID: <5a9084734166d6386270f582a382d6d06cff8b10.1476369687.git.jthumshirn@suse.de>
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

fc_bsg_jobdone() and bsg_job_done() are 1:1 copies now so use the bsg-lib one
instead of the FC private implementation.

Signed-off-by: Johannes Thumshirn <jthumshirn-l3A5Bk7waGM@public.gmane.org>
Reviewed-by: Hannes Reinecke <hare-IBi9RG/b67k@public.gmane.org>
---
 drivers/s390/scsi/zfcp_fc.c      |  2 +-
 drivers/scsi/bfa/bfad_bsg.c      |  4 ++--
 drivers/scsi/ibmvscsi/ibmvfc.c   |  2 +-
 drivers/scsi/libfc/fc_lport.c    |  4 ++--
 drivers/scsi/lpfc/lpfc_bsg.c     | 38 +++++++++++++++++-----------------
 drivers/scsi/qla2xxx/qla_bsg.c   | 44 ++++++++++++++++++++--------------------
 drivers/scsi/scsi_transport_fc.c | 41 +++----------------------------------
 include/scsi/scsi_transport_fc.h |  2 --
 8 files changed, 50 insertions(+), 87 deletions(-)

diff --git a/drivers/s390/scsi/zfcp_fc.c b/drivers/s390/scsi/zfcp_fc.c
index b1b4129..a0f9c82 100644
--- a/drivers/s390/scsi/zfcp_fc.c
+++ b/drivers/s390/scsi/zfcp_fc.c
@@ -893,7 +893,7 @@ static void zfcp_fc_ct_els_job_handler(void *data)
 	jr->reply_payload_rcv_len = job->reply_payload.payload_len;
 	jr->reply_data.ctels_reply.status = FC_CTELS_STATUS_OK;
 	jr->result = zfcp_ct_els->status ? -EIO : 0;
-	fc_bsg_jobdone(job, jr->result, jr->reply_payload_rcv_len);
+	bsg_job_done(job, jr->result, jr->reply_payload_rcv_len);
 }
 
 static struct zfcp_fc_wka_port *zfcp_fc_job_wka_port(struct bsg_job *job)
diff --git a/drivers/scsi/bfa/bfad_bsg.c b/drivers/scsi/bfa/bfad_bsg.c
index cdc25e6..a9a0016 100644
--- a/drivers/scsi/bfa/bfad_bsg.c
+++ b/drivers/scsi/bfa/bfad_bsg.c
@@ -3179,7 +3179,7 @@
 	bsg_reply->reply_payload_rcv_len = job->reply_payload.payload_len;
 	bsg_reply->result = rc;
 
-	fc_bsg_jobdone(job, bsg_reply->result,
+	bsg_job_done(job, bsg_reply->result,
 		       bsg_reply->reply_payload_rcv_len);
 	return rc;
 error:
@@ -3555,7 +3555,7 @@ struct bfad_buf_info *
 	bsg_reply->result = rc;
 
 	if (rc == BFA_STATUS_OK)
-		fc_bsg_jobdone(job, bsg_reply->result,
+		bsg_job_done(job, bsg_reply->result,
 			       bsg_reply->reply_payload_rcv_len);
 
 	return rc;
diff --git a/drivers/scsi/ibmvscsi/ibmvfc.c b/drivers/scsi/ibmvscsi/ibmvfc.c
index f59b0a1..78b72c2 100644
--- a/drivers/scsi/ibmvscsi/ibmvfc.c
+++ b/drivers/scsi/ibmvscsi/ibmvfc.c
@@ -1946,7 +1946,7 @@ static int ibmvfc_bsg_request(struct bsg_job *job)
 	ibmvfc_free_event(evt);
 	spin_unlock_irqrestore(vhost->host->host_lock, flags);
 	bsg_reply->result = rc;
-	fc_bsg_jobdone(job, bsg_reply->result,
+	bsg_job_done(job, bsg_reply->result,
 		       bsg_reply->reply_payload_rcv_len);
 	rc = 0;
 out:
diff --git a/drivers/scsi/libfc/fc_lport.c b/drivers/scsi/libfc/fc_lport.c
index 9845667..518e3b0 100644
--- a/drivers/scsi/libfc/fc_lport.c
+++ b/drivers/scsi/libfc/fc_lport.c
@@ -1916,7 +1916,7 @@ static void fc_lport_bsg_resp(struct fc_seq *sp, struct fc_frame *fp,
 		bsg_reply->result = (PTR_ERR(fp) == -FC_EX_CLOSED) ?
 			-ECONNABORTED : -ETIMEDOUT;
 		job->reply_len = sizeof(uint32_t);
-		fc_bsg_jobdone(job, bsg_reply->result,
+		bsg_job_done(job, bsg_reply->result,
 			       bsg_reply->reply_payload_rcv_len);
 		kfree(info);
 		return;
@@ -1951,7 +1951,7 @@ static void fc_lport_bsg_resp(struct fc_seq *sp, struct fc_frame *fp,
 			bsg_reply->reply_payload_rcv_len =
 				job->reply_payload.payload_len;
 		bsg_reply->result = 0;
-		fc_bsg_jobdone(job, bsg_reply->result,
+		bsg_job_done(job, bsg_reply->result,
 			       bsg_reply->reply_payload_rcv_len);
 		kfree(info);
 	}
diff --git a/drivers/scsi/lpfc/lpfc_bsg.c b/drivers/scsi/lpfc/lpfc_bsg.c
index ca21f25..a862437 100644
--- a/drivers/scsi/lpfc/lpfc_bsg.c
+++ b/drivers/scsi/lpfc/lpfc_bsg.c
@@ -371,7 +371,7 @@ struct lpfc_dmabufext {
 
 	if (job) {
 		bsg_reply->result = rc;
-		fc_bsg_jobdone(job, bsg_reply->result,
+		bsg_job_done(job, bsg_reply->result,
 			       bsg_reply->reply_payload_rcv_len);
 	}
 	return;
@@ -645,7 +645,7 @@ struct lpfc_dmabufext {
 
 	if (job) {
 		bsg_reply->result = rc;
-		fc_bsg_jobdone(job, bsg_reply->result,
+		bsg_job_done(job, bsg_reply->result,
 			       bsg_reply->reply_payload_rcv_len);
 	}
 	return;
@@ -1138,7 +1138,7 @@ struct lpfc_dmabufext {
 			job->dd_data = NULL;
 			/* complete the job back to userspace */
 			spin_unlock_irqrestore(&phba->ct_ev_lock, flags);
-			fc_bsg_jobdone(job, bsg_reply->result,
+			bsg_job_done(job, bsg_reply->result,
 				       bsg_reply->reply_payload_rcv_len);
 			spin_lock_irqsave(&phba->ct_ev_lock, flags);
 		}
@@ -1364,7 +1364,7 @@ struct lpfc_dmabufext {
 	spin_unlock_irqrestore(&phba->ct_ev_lock, flags);
 	job->dd_data = NULL;
 	bsg_reply->result = 0;
-	fc_bsg_jobdone(job, bsg_reply->result,
+	bsg_job_done(job, bsg_reply->result,
 		       bsg_reply->reply_payload_rcv_len);
 	return 0;
 
@@ -1462,7 +1462,7 @@ struct lpfc_dmabufext {
 
 	if (job) {
 		bsg_reply->result = rc;
-		fc_bsg_jobdone(job, bsg_reply->result,
+		bsg_job_done(job, bsg_reply->result,
 			       bsg_reply->reply_payload_rcv_len);
 	}
 	return;
@@ -1891,7 +1891,7 @@ struct lpfc_dmabufext {
 	bsg_reply->result = rc;
 	/* complete the job back to userspace if no error */
 	if (rc == 0)
-		fc_bsg_jobdone(job, bsg_reply->result,
+		bsg_job_done(job, bsg_reply->result,
 			       bsg_reply->reply_payload_rcv_len);
 	return rc;
 }
@@ -2181,7 +2181,7 @@ struct lpfc_dmabufext {
 	bsg_reply->result = rc;
 	/* complete the job back to userspace if no error */
 	if (rc == 0)
-		fc_bsg_jobdone(job, bsg_reply->result,
+		bsg_job_done(job, bsg_reply->result,
 			       bsg_reply->reply_payload_rcv_len);
 	return rc;
 }
@@ -2296,7 +2296,7 @@ struct lpfc_dmabufext {
 	bsg_reply->result = rc;
 	/* complete the job back to userspace if no error */
 	if (rc == 0)
-		fc_bsg_jobdone(job, bsg_reply->result,
+		bsg_job_done(job, bsg_reply->result,
 			       bsg_reply->reply_payload_rcv_len);
 	return rc;
 }
@@ -2449,7 +2449,7 @@ struct lpfc_dmabufext {
 	bsg_reply->result = rc;
 	/* complete the job back to userspace if no error */
 	if (rc == 0)
-		fc_bsg_jobdone(job, bsg_reply->result,
+		bsg_job_done(job, bsg_reply->result,
 			       bsg_reply->reply_payload_rcv_len);
 	return rc;
 }
@@ -3310,7 +3310,7 @@ static int lpfcdiag_loop_post_rxbufs(struct lpfc_hba *phba, uint16_t rxxri,
 	job->dd_data = NULL;
 	/* complete the job back to userspace if no error */
 	if (rc == IOCB_SUCCESS)
-		fc_bsg_jobdone(job, bsg_reply->result,
+		bsg_job_done(job, bsg_reply->result,
 			       bsg_reply->reply_payload_rcv_len);
 	return rc;
 }
@@ -3354,7 +3354,7 @@ static int lpfcdiag_loop_post_rxbufs(struct lpfc_hba *phba, uint16_t rxxri,
 job_error:
 	bsg_reply->result = rc;
 	if (rc == 0)
-		fc_bsg_jobdone(job, bsg_reply->result,
+		bsg_job_done(job, bsg_reply->result,
 			       bsg_reply->reply_payload_rcv_len);
 	return rc;
 }
@@ -3420,7 +3420,7 @@ static int lpfcdiag_loop_post_rxbufs(struct lpfc_hba *phba, uint16_t rxxri,
 
 	if (job) {
 		bsg_reply->result = 0;
-		fc_bsg_jobdone(job, bsg_reply->result,
+		bsg_job_done(job, bsg_reply->result,
 			       bsg_reply->reply_payload_rcv_len);
 	}
 	return;
@@ -3669,7 +3669,7 @@ static int lpfc_bsg_check_cmd_access(struct lpfc_hba *phba,
 	/* if the job is still active, call job done */
 	if (job) {
 		bsg_reply = job->reply;
-		fc_bsg_jobdone(job, bsg_reply->result,
+		bsg_job_done(job, bsg_reply->result,
 			       bsg_reply->reply_payload_rcv_len);
 	}
 	return;
@@ -3707,7 +3707,7 @@ static int lpfc_bsg_check_cmd_access(struct lpfc_hba *phba,
 	/* if the job is still active, call job done */
 	if (job) {
 		bsg_reply = job->reply;
-		fc_bsg_jobdone(job, bsg_reply->result,
+		bsg_job_done(job, bsg_reply->result,
 			       bsg_reply->reply_payload_rcv_len);
 	}
 
@@ -4150,7 +4150,7 @@ static int lpfc_bsg_check_cmd_access(struct lpfc_hba *phba,
 	/* wait for additoinal external buffers */
 
 	bsg_reply->result = 0;
-	fc_bsg_jobdone(job, bsg_reply->result,
+	bsg_job_done(job, bsg_reply->result,
 		       bsg_reply->reply_payload_rcv_len);
 	return SLI_CONFIG_HANDLED;
 
@@ -4377,7 +4377,7 @@ static int lpfc_bsg_check_cmd_access(struct lpfc_hba *phba,
 	}
 
 	bsg_reply->result = 0;
-	fc_bsg_jobdone(job, bsg_reply->result,
+	bsg_job_done(job, bsg_reply->result,
 		       bsg_reply->reply_payload_rcv_len);
 
 	return SLI_CONFIG_HANDLED;
@@ -4494,7 +4494,7 @@ static int lpfc_bsg_check_cmd_access(struct lpfc_hba *phba,
 
 	/* wait for additoinal external buffers */
 	bsg_reply->result = 0;
-	fc_bsg_jobdone(job, bsg_reply->result,
+	bsg_job_done(job, bsg_reply->result,
 		       bsg_reply->reply_payload_rcv_len);
 	return SLI_CONFIG_HANDLED;
 
@@ -4963,7 +4963,7 @@ static int lpfc_bsg_check_cmd_access(struct lpfc_hba *phba,
 		/* job done */
 		bsg_reply->result = 0;
 		job->dd_data = NULL;
-		fc_bsg_jobdone(job, bsg_reply->result,
+		bsg_job_done(job, bsg_reply->result,
 			       bsg_reply->reply_payload_rcv_len);
 	} else if (rc == 1)
 		/* job submitted, will complete later*/
@@ -5074,7 +5074,7 @@ static int lpfc_bsg_check_cmd_access(struct lpfc_hba *phba,
 
 	if (job) {
 		bsg_reply->result = rc;
-		fc_bsg_jobdone(job, bsg_reply->result,
+		bsg_job_done(job, bsg_reply->result,
 			       bsg_reply->reply_payload_rcv_len);
 	}
 
diff --git a/drivers/scsi/qla2xxx/qla_bsg.c b/drivers/scsi/qla2xxx/qla_bsg.c
index 342e8a3..1bf8061 100644
--- a/drivers/scsi/qla2xxx/qla_bsg.c
+++ b/drivers/scsi/qla2xxx/qla_bsg.c
@@ -21,7 +21,7 @@
 	struct fc_bsg_reply *bsg_reply = bsg_job->reply;
 
 	bsg_reply->result = res;
-	fc_bsg_jobdone(bsg_job, bsg_reply->result,
+	bsg_job_done(bsg_job, bsg_reply->result,
 		       bsg_reply->reply_payload_rcv_len);
 	sp->free(vha, sp);
 }
@@ -244,7 +244,7 @@
 	}
 exit_fcp_prio_cfg:
 	if (!ret)
-		fc_bsg_jobdone(bsg_job, bsg_reply->result,
+		bsg_job_done(bsg_job, bsg_reply->result,
 			       bsg_reply->reply_payload_rcv_len);
 	return ret;
 }
@@ -942,7 +942,7 @@
 	    bsg_job->request_payload.sg_list,
 	    bsg_job->request_payload.sg_cnt, DMA_TO_DEVICE);
 	if (!rval)
-		fc_bsg_jobdone(bsg_job, bsg_reply->result,
+		bsg_job_done(bsg_job, bsg_reply->result,
 			       bsg_reply->reply_payload_rcv_len);
 	return rval;
 }
@@ -976,7 +976,7 @@
 		ql_dbg(ql_dbg_user, vha, 0x7031,
 		    "Vendor request 84xx reset completed.\n");
 		bsg_reply->result = DID_OK;
-		fc_bsg_jobdone(bsg_job, bsg_reply->result,
+		bsg_job_done(bsg_job, bsg_reply->result,
 			       bsg_reply->reply_payload_rcv_len);
 	}
 
@@ -1090,7 +1090,7 @@
 		bsg_job->request_payload.sg_cnt, DMA_TO_DEVICE);
 
 	if (!rval)
-		fc_bsg_jobdone(bsg_job, bsg_reply->result,
+		bsg_job_done(bsg_job, bsg_reply->result,
 			       bsg_reply->reply_payload_rcv_len);
 	return rval;
 }
@@ -1288,7 +1288,7 @@
 	dma_pool_free(ha->s_dma_pool, mn, mn_dma);
 
 	if (!rval)
-		fc_bsg_jobdone(bsg_job, bsg_reply->result,
+		bsg_job_done(bsg_job, bsg_reply->result,
 			       bsg_reply->reply_payload_rcv_len);
 	return rval;
 }
@@ -1375,7 +1375,7 @@
 		}
 
 		bsg_reply->result = DID_OK;
-		fc_bsg_jobdone(bsg_job, bsg_reply->result,
+		bsg_job_done(bsg_job, bsg_reply->result,
 			       bsg_reply->reply_payload_rcv_len);
 	}
 
@@ -1484,7 +1484,7 @@
 	ha->optrom_buffer = NULL;
 	ha->optrom_state = QLA_SWAITING;
 	mutex_unlock(&ha->optrom_mutex);
-	fc_bsg_jobdone(bsg_job, bsg_reply->result,
+	bsg_job_done(bsg_job, bsg_reply->result,
 		       bsg_reply->reply_payload_rcv_len);
 	return rval;
 }
@@ -1520,7 +1520,7 @@
 	ha->optrom_buffer = NULL;
 	ha->optrom_state = QLA_SWAITING;
 	mutex_unlock(&ha->optrom_mutex);
-	fc_bsg_jobdone(bsg_job, bsg_reply->result,
+	bsg_job_done(bsg_job, bsg_reply->result,
 		       bsg_reply->reply_payload_rcv_len);
 	return rval;
 }
@@ -1571,7 +1571,7 @@
 done:
 	bsg_job->reply_len = sizeof(struct fc_bsg_reply);
 	bsg_reply->result = DID_OK << 16;
-	fc_bsg_jobdone(bsg_job, bsg_reply->result,
+	bsg_job_done(bsg_job, bsg_reply->result,
 		       bsg_reply->reply_payload_rcv_len);
 
 	return 0;
@@ -1621,7 +1621,7 @@
 	bsg_job->reply_len = sizeof(struct fc_bsg_reply);
 	bsg_reply->reply_payload_rcv_len = sizeof(*sr);
 	bsg_reply->result = DID_OK << 16;
-	fc_bsg_jobdone(bsg_job, bsg_reply->result,
+	bsg_job_done(bsg_job, bsg_reply->result,
 		       bsg_reply->reply_payload_rcv_len);
 
 	return 0;
@@ -1667,7 +1667,7 @@
 done:
 	bsg_job->reply_len = sizeof(struct fc_bsg_reply);
 	bsg_reply->result = DID_OK << 16;
-	fc_bsg_jobdone(bsg_job, bsg_reply->result,
+	bsg_job_done(bsg_job, bsg_reply->result,
 		       bsg_reply->reply_payload_rcv_len);
 
 	return 0;
@@ -1712,7 +1712,7 @@
 done:
 	bsg_job->reply_len = sizeof(struct fc_bsg_reply);
 	bsg_reply->result = DID_OK << 16;
-	fc_bsg_jobdone(bsg_job, bsg_reply->result,
+	bsg_job_done(bsg_job, bsg_reply->result,
 		       bsg_reply->reply_payload_rcv_len);
 
 	return 0;
@@ -1761,7 +1761,7 @@
 	bsg_job->reply_len = sizeof(struct fc_bsg_reply);
 	bsg_reply->reply_payload_rcv_len = sizeof(*i2c);
 	bsg_reply->result = DID_OK << 16;
-	fc_bsg_jobdone(bsg_job, bsg_reply->result,
+	bsg_job_done(bsg_job, bsg_reply->result,
 		       bsg_reply->reply_payload_rcv_len);
 
 	return 0;
@@ -1940,7 +1940,7 @@
 	bsg_job->reply_len = sizeof(struct fc_bsg_reply);
 	bsg_reply->reply_payload_rcv_len = 0;
 	bsg_reply->result = (DID_OK) << 16;
-	fc_bsg_jobdone(bsg_job, bsg_reply->result,
+	bsg_job_done(bsg_job, bsg_reply->result,
 		       bsg_reply->reply_payload_rcv_len);
 	/* Always return success, vendor rsp carries correct status */
 	return 0;
@@ -2106,7 +2106,7 @@
 
 	bsg_job->reply_len = sizeof(struct fc_bsg_reply);
 	bsg_reply->result = DID_OK << 16;
-	fc_bsg_jobdone(bsg_job, bsg_reply->result,
+	bsg_job_done(bsg_job, bsg_reply->result,
 		       bsg_reply->reply_payload_rcv_len);
 	return 0;
 }
@@ -2148,7 +2148,7 @@
 
 	bsg_job->reply_len = sizeof(struct fc_bsg_reply);
 	bsg_reply->result = DID_OK << 16;
-	fc_bsg_jobdone(bsg_job, bsg_reply->result,
+	bsg_job_done(bsg_job, bsg_reply->result,
 		       bsg_reply->reply_payload_rcv_len);
 	return 0;
 }
@@ -2180,7 +2180,7 @@
 
 	bsg_job->reply_len = sizeof(struct fc_bsg_reply);
 	bsg_reply->result = DID_OK << 16;
-	fc_bsg_jobdone(bsg_job, bsg_reply->result,
+	bsg_job_done(bsg_job, bsg_reply->result,
 		       bsg_reply->reply_payload_rcv_len);
 	return 0;
 }
@@ -2226,7 +2226,7 @@
 
 	bsg_job->reply_len = sizeof(struct fc_bsg_reply);
 	bsg_reply->result = DID_OK << 16;
-	fc_bsg_jobdone(bsg_job, bsg_reply->result,
+	bsg_job_done(bsg_job, bsg_reply->result,
 		       bsg_reply->reply_payload_rcv_len);
 	return 0;
 }
@@ -2285,7 +2285,7 @@
 
 	bsg_job->reply_len = sizeof(struct fc_bsg_reply);
 	bsg_reply->result = DID_OK << 16;
-	fc_bsg_jobdone(bsg_job, bsg_reply->result,
+	bsg_job_done(bsg_job, bsg_reply->result,
 		       bsg_reply->reply_payload_rcv_len);
 	return 0;
 }
@@ -2342,7 +2342,7 @@
 
 	bsg_job->reply_len = sizeof(*bsg_reply);
 	bsg_reply->result = DID_OK << 16;
-	fc_bsg_jobdone(bsg_job, bsg_reply->result,
+	bsg_job_done(bsg_job, bsg_reply->result,
 		       bsg_reply->reply_payload_rcv_len);
 
 	dma_free_coherent(&ha->pdev->dev, sizeof(*stats),
@@ -2386,7 +2386,7 @@
 
 	bsg_job->reply_len = sizeof(*bsg_reply);
 	bsg_reply->result = DID_OK << 16;
-	fc_bsg_jobdone(bsg_job, bsg_reply->result,
+	bsg_job_done(bsg_job, bsg_reply->result,
 		       bsg_reply->reply_payload_rcv_len);
 
 	kfree(dd);
diff --git a/drivers/scsi/scsi_transport_fc.c b/drivers/scsi/scsi_transport_fc.c
index 1ae6d86..720ddc9 100644
--- a/drivers/scsi/scsi_transport_fc.c
+++ b/drivers/scsi/scsi_transport_fc.c
@@ -3556,41 +3556,6 @@ struct fc_vport *
  */
 
 /**
- * fc_bsg_jobdone - completion routine for bsg requests that the LLD has
- *                  completed
- * @job:	fc_bsg_job that is complete
- * @result:	job reply result
- * @reply_payload_rcv_len: length of payload received
- */
-void fc_bsg_jobdone(struct bsg_job *job, int result,
-		    unsigned int reply_payload_rcv_len)
-{
-	struct request *req = job->req;
-	struct request *rsp = req->next_rq;
-	int err;
-
-	err = job->req->errors = result;
-
-	if (err < 0)
-		/* we're only returning the result field in the reply */
-		job->req->sense_len = sizeof(uint32_t);
-	else
-		job->req->sense_len = job->reply_len;
-
-	/* we assume all request payload was transferred, residual == 0 */
-	req->resid_len = 0;
-
-	if (rsp) {
-		WARN_ON(reply_payload_rcv_len > rsp->resid_len);
-
-		/* set reply (bidi) residual */
-		rsp->resid_len -= min(reply_payload_rcv_len, rsp->resid_len);
-	}
-	blk_complete_request(req);
-}
-EXPORT_SYMBOL_GPL(fc_bsg_jobdone);
-
-/**
  * fc_bsg_job_timeout - handler for when a bsg request timesout
  * @req:	request that timed out
  */
@@ -3799,7 +3764,7 @@ enum fc_dispatch_result {
 	bsg_reply->reply_payload_rcv_len = 0;
 	bsg_reply->result = ret;
 	job->reply_len = sizeof(uint32_t);
-	fc_bsg_jobdone(job, bsg_reply->result,
+	bsg_job_done(job, bsg_reply->result,
 		       bsg_reply->reply_payload_rcv_len);
 	return FC_DISPATCH_UNLOCKED;
 }
@@ -3877,7 +3842,7 @@ enum fc_dispatch_result {
 	bsg_reply->reply_payload_rcv_len = 0;
 	bsg_reply->result = ret;
 	job->reply_len = sizeof(uint32_t);
-	fc_bsg_jobdone(job, bsg_reply->result,
+	bsg_job_done(job, bsg_reply->result,
 		       bsg_reply->reply_payload_rcv_len);
 	return FC_DISPATCH_UNLOCKED;
 }
@@ -3938,7 +3903,7 @@ enum fc_dispatch_result {
 			bsg_reply->reply_payload_rcv_len = 0;
 			bsg_reply->result = -ENOMSG;
 			job->reply_len = sizeof(uint32_t);
-			fc_bsg_jobdone(job, bsg_reply->result,
+			bsg_job_done(job, bsg_reply->result,
 				       bsg_reply->reply_payload_rcv_len);
 			spin_lock_irq(q->queue_lock);
 			continue;
diff --git a/include/scsi/scsi_transport_fc.h b/include/scsi/scsi_transport_fc.h
index 1da8b71..924c8e6 100644
--- a/include/scsi/scsi_transport_fc.h
+++ b/include/scsi/scsi_transport_fc.h
@@ -808,8 +808,6 @@ struct fc_vport *fc_vport_create(struct Scsi_Host *shost, int channel,
 		struct fc_vport_identifiers *);
 int fc_vport_terminate(struct fc_vport *vport);
 int fc_block_scsi_eh(struct scsi_cmnd *cmnd);
-void fc_bsg_jobdone(struct bsg_job *job, int result,
-		    unsigned int reply_payload_rcv_len);
 
 static inline struct Scsi_Host *fc_bsg_to_shost(struct bsg_job *job)
 {
-- 
1.8.5.6
