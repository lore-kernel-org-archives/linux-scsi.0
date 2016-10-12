From: Johannes Thumshirn <jthumshirn-l3A5Bk7waGM@public.gmane.org>
Subject: [PATCH v2 03/16] scsi: fc: Export fc_bsg_jobdone and
	use it in FC drivers
Date: Wed, 12 Oct 2016 15:06:29 +0200
Message-ID: <be630735292b05efbefe3835b79f22a8f95f34da.1476276823.git.jthumshirn@suse.de>
References: <cover.1476276823.git.jthumshirn@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <fcoe-devel-bounces-s9riP+hp16TNLxjTenLetw@public.gmane.org>
In-Reply-To: <cover.1476276823.git.jthumshirn-l3A5Bk7waGM@public.gmane.org>
In-Reply-To: <cover.1476276823.git.jthumshirn-l3A5Bk7waGM@public.gmane.org>
References: <cover.1476276823.git.jthumshirn-l3A5Bk7waGM@public.gmane.org>
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

Export fc_bsg_jobdone so drivers can use it directly instead of doing
the round-trip via struct fc_bsg_job::job_done() and use it in the LLDDs.

As we've converted all LLDDs over to use fc_bsg_jobdone() directly,
we can remove the function pointer from struct fc_bsg_job as well.

Signed-off-by: Johannes Thumshirn <jthumshirn-l3A5Bk7waGM@public.gmane.org>
---
 drivers/s390/scsi/zfcp_fc.c      |  2 +-
 drivers/scsi/bfa/bfad_bsg.c      |  4 ++--
 drivers/scsi/ibmvscsi/ibmvfc.c   |  2 +-
 drivers/scsi/libfc/fc_lport.c    |  4 ++--
 drivers/scsi/lpfc/lpfc_bsg.c     | 38 +++++++++++++++++-----------------
 drivers/scsi/qla2xxx/qla_bsg.c   | 44 ++++++++++++++++++++--------------------
 drivers/scsi/scsi_transport_fc.c |  5 ++---
 include/scsi/scsi_transport_fc.h |  2 +-
 8 files changed, 50 insertions(+), 51 deletions(-)

diff --git a/drivers/s390/scsi/zfcp_fc.c b/drivers/s390/scsi/zfcp_fc.c
index 4c4023f..40d8f06 100644
--- a/drivers/s390/scsi/zfcp_fc.c
+++ b/drivers/s390/scsi/zfcp_fc.c
@@ -892,7 +892,7 @@ static void zfcp_fc_ct_els_job_handler(void *data)
 	jr->reply_payload_rcv_len = job->reply_payload.payload_len;
 	jr->reply_data.ctels_reply.status = FC_CTELS_STATUS_OK;
 	jr->result = zfcp_ct_els->status ? -EIO : 0;
-	job->job_done(job);
+	fc_bsg_jobdone(job);
 }
 
 static struct zfcp_fc_wka_port *zfcp_fc_job_wka_port(struct fc_bsg_job *job)
diff --git a/drivers/scsi/bfa/bfad_bsg.c b/drivers/scsi/bfa/bfad_bsg.c
index 48366d8..25889b9 100644
--- a/drivers/scsi/bfa/bfad_bsg.c
+++ b/drivers/scsi/bfa/bfad_bsg.c
@@ -3180,7 +3180,7 @@ bfad_im_bsg_vendor_request(struct fc_bsg_job *job)
 	bsg_reply->reply_payload_rcv_len = job->reply_payload.payload_len;
 	bsg_reply->result = rc;
 
-	job->job_done(job);
+	fc_bsg_jobdone(job);
 	return rc;
 error:
 	/* free the command buffer */
@@ -3556,7 +3556,7 @@ out:
 	bsg_reply->result = rc;
 
 	if (rc == BFA_STATUS_OK)
-		job->job_done(job);
+		fc_bsg_jobdone(job);
 
 	return rc;
 }
diff --git a/drivers/scsi/ibmvscsi/ibmvfc.c b/drivers/scsi/ibmvscsi/ibmvfc.c
index 8b55279..21c9d28 100644
--- a/drivers/scsi/ibmvscsi/ibmvfc.c
+++ b/drivers/scsi/ibmvscsi/ibmvfc.c
@@ -1939,7 +1939,7 @@ static int ibmvfc_bsg_request(struct fc_bsg_job *job)
 	ibmvfc_free_event(evt);
 	spin_unlock_irqrestore(vhost->host->host_lock, flags);
 	bsg_reply->result = rc;
-	job->job_done(job);
+	fc_bsg_jobdone(job);
 	rc = 0;
 out:
 	dma_unmap_sg(vhost->dev, job->request_payload.sg_list,
diff --git a/drivers/scsi/libfc/fc_lport.c b/drivers/scsi/libfc/fc_lport.c
index a1c12e7..8811fe0 100644
--- a/drivers/scsi/libfc/fc_lport.c
+++ b/drivers/scsi/libfc/fc_lport.c
@@ -1912,7 +1912,7 @@ static void fc_lport_bsg_resp(struct fc_seq *sp, struct fc_frame *fp,
 			-ECONNABORTED : -ETIMEDOUT;
 		job->reply_len = sizeof(uint32_t);
 		job->state_flags |= FC_RQST_STATE_DONE;
-		job->job_done(job);
+		fc_bsg_jobdone(job);
 		kfree(info);
 		return;
 	}
@@ -1947,7 +1947,7 @@ static void fc_lport_bsg_resp(struct fc_seq *sp, struct fc_frame *fp,
 				job->reply_payload.payload_len;
 		bsg_reply->result = 0;
 		job->state_flags |= FC_RQST_STATE_DONE;
-		job->job_done(job);
+		fc_bsg_jobdone(job);
 		kfree(info);
 	}
 	fc_frame_free(fp);
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
diff --git a/drivers/scsi/qla2xxx/qla_bsg.c b/drivers/scsi/qla2xxx/qla_bsg.c
index 40f7c10..1bca77b 100644
--- a/drivers/scsi/qla2xxx/qla_bsg.c
+++ b/drivers/scsi/qla2xxx/qla_bsg.c
@@ -20,7 +20,7 @@ qla2x00_bsg_job_done(void *data, void *ptr, int res)
 	struct fc_bsg_reply *bsg_reply = bsg_job->reply;
 
 	bsg_reply->result = res;
-	bsg_job->job_done(bsg_job);
+	fc_bsg_jobdone(bsg_job);
 	sp->free(vha, sp);
 }
 
@@ -242,7 +242,7 @@ qla24xx_proc_fcp_prio_cfg_cmd(struct fc_bsg_job *bsg_job)
 	}
 exit_fcp_prio_cfg:
 	if (!ret)
-		bsg_job->job_done(bsg_job);
+		fc_bsg_jobdone(bsg_job);
 	return ret;
 }
 
@@ -939,7 +939,7 @@ done_unmap_req_sg:
 	    bsg_job->request_payload.sg_list,
 	    bsg_job->request_payload.sg_cnt, DMA_TO_DEVICE);
 	if (!rval)
-		bsg_job->job_done(bsg_job);
+		fc_bsg_jobdone(bsg_job);
 	return rval;
 }
 
@@ -972,7 +972,7 @@ qla84xx_reset(struct fc_bsg_job *bsg_job)
 		ql_dbg(ql_dbg_user, vha, 0x7031,
 		    "Vendor request 84xx reset completed.\n");
 		bsg_reply->result = DID_OK;
-		bsg_job->job_done(bsg_job);
+		fc_bsg_jobdone(bsg_job);
 	}
 
 	return rval;
@@ -1085,7 +1085,7 @@ done_unmap_sg:
 		bsg_job->request_payload.sg_cnt, DMA_TO_DEVICE);
 
 	if (!rval)
-		bsg_job->job_done(bsg_job);
+		fc_bsg_jobdone(bsg_job);
 	return rval;
 }
 
@@ -1282,7 +1282,7 @@ exit_mgmt:
 	dma_pool_free(ha->s_dma_pool, mn, mn_dma);
 
 	if (!rval)
-		bsg_job->job_done(bsg_job);
+		fc_bsg_jobdone(bsg_job);
 	return rval;
 }
 
@@ -1368,7 +1368,7 @@ qla24xx_iidma(struct fc_bsg_job *bsg_job)
 		}
 
 		bsg_reply->result = DID_OK;
-		bsg_job->job_done(bsg_job);
+		fc_bsg_jobdone(bsg_job);
 	}
 
 	return rval;
@@ -1476,7 +1476,7 @@ qla2x00_read_optrom(struct fc_bsg_job *bsg_job)
 	ha->optrom_buffer = NULL;
 	ha->optrom_state = QLA_SWAITING;
 	mutex_unlock(&ha->optrom_mutex);
-	bsg_job->job_done(bsg_job);
+	fc_bsg_jobdone(bsg_job);
 	return rval;
 }
 
@@ -1511,7 +1511,7 @@ qla2x00_update_optrom(struct fc_bsg_job *bsg_job)
 	ha->optrom_buffer = NULL;
 	ha->optrom_state = QLA_SWAITING;
 	mutex_unlock(&ha->optrom_mutex);
-	bsg_job->job_done(bsg_job);
+	fc_bsg_jobdone(bsg_job);
 	return rval;
 }
 
@@ -1561,7 +1561,7 @@ dealloc:
 done:
 	bsg_job->reply_len = sizeof(struct fc_bsg_reply);
 	bsg_reply->result = DID_OK << 16;
-	bsg_job->job_done(bsg_job);
+	fc_bsg_jobdone(bsg_job);
 
 	return 0;
 }
@@ -1610,7 +1610,7 @@ done:
 	bsg_job->reply_len = sizeof(struct fc_bsg_reply);
 	bsg_reply->reply_payload_rcv_len = sizeof(*sr);
 	bsg_reply->result = DID_OK << 16;
-	bsg_job->job_done(bsg_job);
+	fc_bsg_jobdone(bsg_job);
 
 	return 0;
 }
@@ -1655,7 +1655,7 @@ dealloc:
 done:
 	bsg_job->reply_len = sizeof(struct fc_bsg_reply);
 	bsg_reply->result = DID_OK << 16;
-	bsg_job->job_done(bsg_job);
+	fc_bsg_jobdone(bsg_job);
 
 	return 0;
 }
@@ -1699,7 +1699,7 @@ dealloc:
 done:
 	bsg_job->reply_len = sizeof(struct fc_bsg_reply);
 	bsg_reply->result = DID_OK << 16;
-	bsg_job->job_done(bsg_job);
+	fc_bsg_jobdone(bsg_job);
 
 	return 0;
 }
@@ -1747,7 +1747,7 @@ done:
 	bsg_job->reply_len = sizeof(struct fc_bsg_reply);
 	bsg_reply->reply_payload_rcv_len = sizeof(*i2c);
 	bsg_reply->result = DID_OK << 16;
-	bsg_job->job_done(bsg_job);
+	fc_bsg_jobdone(bsg_job);
 
 	return 0;
 }
@@ -1925,7 +1925,7 @@ done:
 	bsg_job->reply_len = sizeof(struct fc_bsg_reply);
 	bsg_reply->reply_payload_rcv_len = 0;
 	bsg_reply->result = (DID_OK) << 16;
-	bsg_job->job_done(bsg_job);
+	fc_bsg_jobdone(bsg_job);
 	/* Always return success, vendor rsp carries correct status */
 	return 0;
 }
@@ -2090,7 +2090,7 @@ qla26xx_serdes_op(struct fc_bsg_job *bsg_job)
 
 	bsg_job->reply_len = sizeof(struct fc_bsg_reply);
 	bsg_reply->result = DID_OK << 16;
-	bsg_job->job_done(bsg_job);
+	fc_bsg_jobdone(bsg_job);
 	return 0;
 }
 
@@ -2131,7 +2131,7 @@ qla8044_serdes_op(struct fc_bsg_job *bsg_job)
 
 	bsg_job->reply_len = sizeof(struct fc_bsg_reply);
 	bsg_reply->result = DID_OK << 16;
-	bsg_job->job_done(bsg_job);
+	fc_bsg_jobdone(bsg_job);
 	return 0;
 }
 
@@ -2162,7 +2162,7 @@ qla27xx_get_flash_upd_cap(struct fc_bsg_job *bsg_job)
 
 	bsg_job->reply_len = sizeof(struct fc_bsg_reply);
 	bsg_reply->result = DID_OK << 16;
-	bsg_job->job_done(bsg_job);
+	fc_bsg_jobdone(bsg_job);
 	return 0;
 }
 
@@ -2207,7 +2207,7 @@ qla27xx_set_flash_upd_cap(struct fc_bsg_job *bsg_job)
 
 	bsg_job->reply_len = sizeof(struct fc_bsg_reply);
 	bsg_reply->result = DID_OK << 16;
-	bsg_job->job_done(bsg_job);
+	fc_bsg_jobdone(bsg_job);
 	return 0;
 }
 
@@ -2265,7 +2265,7 @@ done:
 
 	bsg_job->reply_len = sizeof(struct fc_bsg_reply);
 	bsg_reply->result = DID_OK << 16;
-	bsg_job->job_done(bsg_job);
+	fc_bsg_jobdone(bsg_job);
 	return 0;
 }
 
@@ -2321,7 +2321,7 @@ qla2x00_get_priv_stats(struct fc_bsg_job *bsg_job)
 
 	bsg_job->reply_len = sizeof(*bsg_reply);
 	bsg_reply->result = DID_OK << 16;
-	bsg_job->job_done(bsg_job);
+	fc_bsg_jobdone(bsg_job);
 
 	dma_free_coherent(&ha->pdev->dev, sizeof(*stats),
 		stats, stats_dma);
@@ -2364,7 +2364,7 @@ qla2x00_do_dport_diagnostics(struct fc_bsg_job *bsg_job)
 
 	bsg_job->reply_len = sizeof(*bsg_reply);
 	bsg_reply->result = DID_OK << 16;
-	bsg_job->job_done(bsg_job);
+	fc_bsg_jobdone(bsg_job);
 
 	kfree(dd);
 
diff --git a/drivers/scsi/scsi_transport_fc.c b/drivers/scsi/scsi_transport_fc.c
index eafc7555..4149dac 100644
--- a/drivers/scsi/scsi_transport_fc.c
+++ b/drivers/scsi/scsi_transport_fc.c
@@ -3583,8 +3583,7 @@ fc_destroy_bsgjob(struct fc_bsg_job *job)
  *                  completed
  * @job:	fc_bsg_job that is complete
  */
-static void
-fc_bsg_jobdone(struct fc_bsg_job *job)
+void fc_bsg_jobdone(struct fc_bsg_job *job)
 {
 	struct request *req = job->req;
 	struct request *rsp = req->next_rq;
@@ -3611,6 +3610,7 @@ fc_bsg_jobdone(struct fc_bsg_job *job)
 	}
 	blk_complete_request(req);
 }
+EXPORT_SYMBOL_GPL(fc_bsg_jobdone);
 
 /**
  * fc_bsg_softirq_done - softirq done routine for destroying the bsg requests
@@ -3744,7 +3744,6 @@ fc_req_to_bsgjob(struct Scsi_Host *shost, struct fc_rport *rport,
 		if (ret)
 			goto failjob_rls_rqst_payload;
 	}
-	job->job_done = fc_bsg_jobdone;
 	if (rport)
 		job->dev = &rport->dev;
 	else
diff --git a/include/scsi/scsi_transport_fc.h b/include/scsi/scsi_transport_fc.h
index 921b097..9ef583f 100644
--- a/include/scsi/scsi_transport_fc.h
+++ b/include/scsi/scsi_transport_fc.h
@@ -637,7 +637,6 @@ struct fc_bsg_job {
 	spinlock_t job_lock;
 	unsigned int state_flags;
 	unsigned int ref_cnt;
-	void (*job_done)(struct fc_bsg_job *);
 
 	struct fc_bsg_request *request;
 	struct fc_bsg_reply *reply;
@@ -842,5 +841,6 @@ struct fc_vport *fc_vport_create(struct Scsi_Host *shost, int channel,
 		struct fc_vport_identifiers *);
 int fc_vport_terminate(struct fc_vport *vport);
 int fc_block_scsi_eh(struct scsi_cmnd *cmnd);
+void fc_bsg_jobdone(struct fc_bsg_job *job);
 
 #endif /* SCSI_TRANSPORT_FC_H */
-- 
1.8.5.6
