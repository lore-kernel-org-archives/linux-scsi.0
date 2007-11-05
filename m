From: Adrian Bunk <bunk@kernel.org>
Subject: [2.6 patch] scsi/lpfc/: possible cleanups
Date: Mon, 5 Nov 2007 18:07:33 +0100
Message-ID: <20071105170733.GQ12045@stusta.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:59524 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757654AbXKERH5 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 5 Nov 2007 12:07:57 -0500
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: james.smart@emulex.com, James.Bottomley@SteelEye.com
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

This patch contains the following possible cleanups:
- make the following needlessly global functions static:
  - lpfc_els.c: lpfc_register_new_vport()
  - lpfc_els.c: lpfc_issue_els_fdisc()
  - lpfc_els.c: lpfc_issue_fabric_iocb()
  - lpfc_els.c: lpfc_fabric_abort_vport()
  - lpfc_hbadisc.c: lpfc_dev_loss_tmo_handler()
  - lpfc_hbadisc.c: lpfc_mbx_cmpl_clear_la()
  - lpfc_hbadisc.c: lpfc_disc_flush_list()
  - lpfc_hbadisc.c: __lpfc_find_node()
  - lpfc_init.c: lpfc_hb_timeout()
  - lpfc_init.c: lpfc_block_mgmt_io()
  - lpfc_sli.c: __lpfc_sli_release_iocbq()
  - lpfc_sli.c: lpfc_sli_next_hbq_slot()
  - lpfc_sli.c: lpfc_sli_hbqbuf_init_hbqs()
  - lpfc_sli.c: lpfc_sli_hbqbuf_find()
  - lpfc_sli.c: __lpfc_sli_issue_iocb()
- #if 0 the following unused global functions:
  - lpfc_els.c: lpfc_fabric_abort_flogi()
  - lpfc_hbadisc.c: lpfc_find_node()
  - lpfc_hbadisc.c: lpfc_findnode_rpi()
- remove the unused exports

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---

 drivers/scsi/lpfc/lpfc_crtn.h    |   19 -------------------
 drivers/scsi/lpfc/lpfc_els.c     |   18 ++++++++++++++----
 drivers/scsi/lpfc/lpfc_hbadisc.c |   13 +++++++++----
 drivers/scsi/lpfc/lpfc_init.c    |   22 +++++++++++-----------
 drivers/scsi/lpfc/lpfc_sli.c     |   10 +++++-----
 drivers/scsi/lpfc/lpfc_vport.c   |    3 ---
 6 files changed, 39 insertions(+), 46 deletions(-)

c94edacd40dd5e59cd20072974594e3d2160540c 
diff --git a/drivers/scsi/lpfc/lpfc_crtn.h b/drivers/scsi/lpfc/lpfc_crtn.h
index a599e15..53dd68d 100644
--- a/drivers/scsi/lpfc/lpfc_crtn.h
+++ b/drivers/scsi/lpfc/lpfc_crtn.h
@@ -45,7 +45,6 @@ void lpfc_cleanup_rpis(struct lpfc_vport *vport, int remove);
 int lpfc_linkdown(struct lpfc_hba *);
 void lpfc_mbx_cmpl_read_la(struct lpfc_hba *, LPFC_MBOXQ_t *);
 
-void lpfc_mbx_cmpl_clear_la(struct lpfc_hba *, LPFC_MBOXQ_t *);
 void lpfc_mbx_cmpl_reg_login(struct lpfc_hba *, LPFC_MBOXQ_t *);
 void lpfc_mbx_cmpl_dflt_rpi(struct lpfc_hba *, LPFC_MBOXQ_t *);
 void lpfc_mbx_cmpl_fabric_reg_login(struct lpfc_hba *, LPFC_MBOXQ_t *);
@@ -69,12 +68,10 @@ int  lpfc_nlp_put(struct lpfc_nodelist *);
 struct lpfc_nodelist *lpfc_setup_disc_node(struct lpfc_vport *, uint32_t);
 void lpfc_disc_list_loopmap(struct lpfc_vport *);
 void lpfc_disc_start(struct lpfc_vport *);
-void lpfc_disc_flush_list(struct lpfc_vport *);
 void lpfc_cleanup_discovery_resources(struct lpfc_vport *);
 void lpfc_disc_timeout(unsigned long);
 
 struct lpfc_nodelist *__lpfc_findnode_rpi(struct lpfc_vport *, uint16_t);
-struct lpfc_nodelist *lpfc_findnode_rpi(struct lpfc_vport *, uint16_t);
 
 void lpfc_worker_wake_up(struct lpfc_hba *);
 int lpfc_workq_post_event(struct lpfc_hba *, void *, void *, uint32_t);
@@ -82,8 +79,6 @@ int lpfc_do_work(void *);
 int lpfc_disc_state_machine(struct lpfc_vport *, struct lpfc_nodelist *, void *,
 			    uint32_t);
 
-void lpfc_register_new_vport(struct lpfc_hba *, struct lpfc_vport *,
-			struct lpfc_nodelist *);
 void lpfc_do_scr_ns_plogi(struct lpfc_hba *, struct lpfc_vport *);
 int lpfc_check_sparm(struct lpfc_vport *, struct lpfc_nodelist *,
 		     struct serv_parm *, uint32_t);
@@ -92,7 +87,6 @@ int lpfc_els_chk_latt(struct lpfc_vport *);
 int lpfc_els_abort_flogi(struct lpfc_hba *);
 int lpfc_initial_flogi(struct lpfc_vport *);
 int lpfc_initial_fdisc(struct lpfc_vport *);
-int lpfc_issue_els_fdisc(struct lpfc_vport *, struct lpfc_nodelist *, uint8_t);
 int lpfc_issue_els_plogi(struct lpfc_vport *, uint32_t, uint8_t);
 int lpfc_issue_els_prli(struct lpfc_vport *, struct lpfc_nodelist *, uint8_t);
 int lpfc_issue_els_adisc(struct lpfc_vport *, struct lpfc_nodelist *, uint8_t);
@@ -112,7 +106,6 @@ int lpfc_els_rsp_prli_acc(struct lpfc_vport *, struct lpfc_iocbq *,
 void lpfc_cancel_retry_delay_tmo(struct lpfc_vport *, struct lpfc_nodelist *);
 void lpfc_els_retry_delay(unsigned long);
 void lpfc_els_retry_delay_handler(struct lpfc_nodelist *);
-void lpfc_dev_loss_tmo_handler(struct lpfc_nodelist *);
 void lpfc_els_unsol_event(struct lpfc_hba *, struct lpfc_sli_ring *,
 			  struct lpfc_iocbq *);
 int lpfc_els_handle_rscn(struct lpfc_vport *);
@@ -124,7 +117,6 @@ int lpfc_els_disc_adisc(struct lpfc_vport *);
 int lpfc_els_disc_plogi(struct lpfc_vport *);
 void lpfc_els_timeout(unsigned long);
 void lpfc_els_timeout_handler(struct lpfc_vport *);
-void lpfc_hb_timeout(unsigned long);
 void lpfc_hb_timeout_handler(struct lpfc_hba *);
 
 void lpfc_ct_unsol_event(struct lpfc_hba *, struct lpfc_sli_ring *,
@@ -142,7 +134,6 @@ void lpfc_hba_init(struct lpfc_hba *, uint32_t *);
 int lpfc_post_buffer(struct lpfc_hba *, struct lpfc_sli_ring *, int, int);
 void lpfc_decode_firmware_rev(struct lpfc_hba *, char *, int);
 int lpfc_online(struct lpfc_hba *);
-void lpfc_block_mgmt_io(struct lpfc_hba *);
 void lpfc_unblock_mgmt_io(struct lpfc_hba *);
 void lpfc_offline_prep(struct lpfc_hba *);
 void lpfc_offline(struct lpfc_hba *);
@@ -165,7 +156,6 @@ int lpfc_mbox_tmo_val(struct lpfc_hba *, int);
 
 void lpfc_config_hbq(struct lpfc_hba *, uint32_t, struct lpfc_hbq_init *,
 	uint32_t , LPFC_MBOXQ_t *);
-struct lpfc_hbq_entry * lpfc_sli_next_hbq_slot(struct lpfc_hba *, uint32_t);
 struct hbq_dmabuf *lpfc_els_hbq_alloc(struct lpfc_hba *);
 void lpfc_els_hbq_free(struct lpfc_hba *, struct hbq_dmabuf *);
 
@@ -178,7 +168,6 @@ void lpfc_poll_start_timer(struct lpfc_hba * phba);
 void lpfc_sli_poll_fcp_ring(struct lpfc_hba * hba);
 struct lpfc_iocbq * lpfc_sli_get_iocbq(struct lpfc_hba *);
 void lpfc_sli_release_iocbq(struct lpfc_hba * phba, struct lpfc_iocbq * iocb);
-void __lpfc_sli_release_iocbq(struct lpfc_hba * phba, struct lpfc_iocbq * iocb);
 uint16_t lpfc_sli_next_iotag(struct lpfc_hba * phba, struct lpfc_iocbq * iocb);
 
 void lpfc_reset_barrier(struct lpfc_hba * phba);
@@ -205,10 +194,8 @@ struct lpfc_dmabuf *lpfc_sli_ringpostbuf_get(struct lpfc_hba *,
 					     struct lpfc_sli_ring *,
 					     dma_addr_t);
 int lpfc_sli_hbq_count(void);
-int lpfc_sli_hbqbuf_init_hbqs(struct lpfc_hba *, uint32_t);
 int lpfc_sli_hbqbuf_add_hbqs(struct lpfc_hba *, uint32_t);
 void lpfc_sli_hbqbuf_free_all(struct lpfc_hba *);
-struct hbq_dmabuf *lpfc_sli_hbqbuf_find(struct lpfc_hba *, uint32_t);
 int lpfc_sli_hbq_size(void);
 int lpfc_sli_issue_abort_iotag(struct lpfc_hba *, struct lpfc_sli_ring *,
 			       struct lpfc_iocbq *);
@@ -219,9 +206,6 @@ int lpfc_sli_abort_iocb(struct lpfc_vport *, struct lpfc_sli_ring *, uint16_t,
 void lpfc_mbox_timeout(unsigned long);
 void lpfc_mbox_timeout_handler(struct lpfc_hba *);
 
-struct lpfc_nodelist *__lpfc_find_node(struct lpfc_vport *, node_filter,
-				       void *);
-struct lpfc_nodelist *lpfc_find_node(struct lpfc_vport *, node_filter, void *);
 struct lpfc_nodelist *lpfc_findnode_did(struct lpfc_vport *, uint32_t);
 struct lpfc_nodelist *lpfc_findnode_wwpn(struct lpfc_vport *,
 					 struct lpfc_name *);
@@ -281,11 +265,8 @@ extern void lpfc_debugfs_slow_ring_trc(struct lpfc_hba *, char *, uint32_t,
 extern struct lpfc_hbq_init *lpfc_hbq_defs[];
 
 /* Interface exported by fabric iocb scheduler */
-int lpfc_issue_fabric_iocb(struct lpfc_hba *, struct lpfc_iocbq *);
-void lpfc_fabric_abort_vport(struct lpfc_vport *);
 void lpfc_fabric_abort_nport(struct lpfc_nodelist *);
 void lpfc_fabric_abort_hba(struct lpfc_hba *);
-void lpfc_fabric_abort_flogi(struct lpfc_hba *);
 void lpfc_fabric_block_timeout(unsigned long);
 void lpfc_unblock_fabric_iocbs(struct lpfc_hba *);
 void lpfc_adjust_queue_depth(struct lpfc_hba *);
diff --git a/drivers/scsi/lpfc/lpfc_els.c b/drivers/scsi/lpfc/lpfc_els.c
index 8085900..7e1a559 100644
--- a/drivers/scsi/lpfc/lpfc_els.c
+++ b/drivers/scsi/lpfc/lpfc_els.c
@@ -42,6 +42,14 @@ static int lpfc_els_retry(struct lpfc_hba *, struct lpfc_iocbq *,
 			  struct lpfc_iocbq *);
 static void lpfc_cmpl_fabric_iocb(struct lpfc_hba *, struct lpfc_iocbq *,
 			struct lpfc_iocbq *);
+static void lpfc_fabric_abort_vport(struct lpfc_vport *vport);
+static int lpfc_issue_els_fdisc(struct lpfc_vport *vport,
+				struct lpfc_nodelist *ndlp, uint8_t retry);
+static int lpfc_issue_fabric_iocb(struct lpfc_hba *phba,
+				  struct lpfc_iocbq *iocb);
+static void lpfc_register_new_vport(struct lpfc_hba *phba,
+				    struct lpfc_vport *vport,
+				    struct lpfc_nodelist *ndlp);
 
 static int lpfc_max_els_tries = 3;
 
@@ -4150,7 +4158,7 @@ lpfc_cmpl_reg_new_vport(struct lpfc_hba *phba, LPFC_MBOXQ_t *pmb)
 	return;
 }
 
-void
+static void
 lpfc_register_new_vport(struct lpfc_hba *phba, struct lpfc_vport *vport,
 			struct lpfc_nodelist *ndlp)
 {
@@ -4266,7 +4274,7 @@ out:
 	lpfc_els_free_iocb(phba, cmdiocb);
 }
 
-int
+static int
 lpfc_issue_els_fdisc(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp,
 		     uint8_t retry)
 {
@@ -4539,7 +4547,7 @@ lpfc_cmpl_fabric_iocb(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 	}
 }
 
-int
+static int
 lpfc_issue_fabric_iocb(struct lpfc_hba *phba, struct lpfc_iocbq *iocb)
 {
 	unsigned long iflags;
@@ -4583,7 +4591,7 @@ lpfc_issue_fabric_iocb(struct lpfc_hba *phba, struct lpfc_iocbq *iocb)
 }
 
 
-void lpfc_fabric_abort_vport(struct lpfc_vport *vport)
+static void lpfc_fabric_abort_vport(struct lpfc_vport *vport)
 {
 	LIST_HEAD(completions);
 	struct lpfc_hba  *phba = vport->phba;
@@ -4663,6 +4671,7 @@ void lpfc_fabric_abort_hba(struct lpfc_hba *phba)
 }
 
 
+#if 0
 void lpfc_fabric_abort_flogi(struct lpfc_hba *phba)
 {
 	LIST_HEAD(completions);
@@ -4693,5 +4702,6 @@ void lpfc_fabric_abort_flogi(struct lpfc_hba *phba)
 		(piocb->iocb_cmpl) (phba, piocb, piocb);
 	}
 }
+#endif  /*  0  */
 
 
diff --git a/drivers/scsi/lpfc/lpfc_hbadisc.c b/drivers/scsi/lpfc/lpfc_hbadisc.c
index c81c2b3..c3f7af5 100644
--- a/drivers/scsi/lpfc/lpfc_hbadisc.c
+++ b/drivers/scsi/lpfc/lpfc_hbadisc.c
@@ -57,6 +57,7 @@ static uint8_t lpfcAlpaArray[] = {
 };
 
 static void lpfc_disc_timeout_handler(struct lpfc_vport *);
+static void lpfc_disc_flush_list(struct lpfc_vport *vport);
 
 void
 lpfc_terminate_rport_io(struct fc_rport *rport)
@@ -154,7 +155,7 @@ lpfc_dev_loss_tmo_callbk(struct fc_rport *rport)
  * This function is called from the worker thread when dev_loss_tmo
  * expire.
  */
-void
+static void
 lpfc_dev_loss_tmo_handler(struct lpfc_nodelist *ndlp)
 {
 	struct lpfc_rport_data *rdata;
@@ -749,7 +750,7 @@ lpfc_linkup(struct lpfc_hba *phba)
  * as the completion routine when the command is
  * handed off to the SLI layer.
  */
-void
+static void
 lpfc_mbx_cmpl_clear_la(struct lpfc_hba *phba, LPFC_MBOXQ_t *pmb)
 {
 	struct lpfc_vport *vport = pmb->vport;
@@ -2414,7 +2415,7 @@ lpfc_free_tx(struct lpfc_hba *phba, struct lpfc_nodelist *ndlp)
 	}
 }
 
-void
+static void
 lpfc_disc_flush_list(struct lpfc_vport *vport)
 {
 	struct lpfc_nodelist *ndlp, *next_ndlp;
@@ -2747,7 +2748,7 @@ lpfc_filter_by_wwpn(struct lpfc_nodelist *ndlp, void *param)
 		      sizeof(ndlp->nlp_portname)) == 0;
 }
 
-struct lpfc_nodelist *
+static struct lpfc_nodelist *
 __lpfc_find_node(struct lpfc_vport *vport, node_filter filter, void *param)
 {
 	struct lpfc_nodelist *ndlp;
@@ -2760,6 +2761,7 @@ __lpfc_find_node(struct lpfc_vport *vport, node_filter filter, void *param)
 	return NULL;
 }
 
+#if 0
 /*
  * Search node lists for a remote port matching filter criteria
  * Caller needs to hold host_lock before calling this routine.
@@ -2775,6 +2777,7 @@ lpfc_find_node(struct lpfc_vport *vport, node_filter filter, void *param)
 	spin_unlock_irq(shost->host_lock);
 	return ndlp;
 }
+#endif  /*  0  */
 
 /*
  * This routine looks up the ndlp lists for the given RPI. If rpi found it
@@ -2786,6 +2789,7 @@ __lpfc_findnode_rpi(struct lpfc_vport *vport, uint16_t rpi)
 	return __lpfc_find_node(vport, lpfc_filter_by_rpi, &rpi);
 }
 
+#if 0
 struct lpfc_nodelist *
 lpfc_findnode_rpi(struct lpfc_vport *vport, uint16_t rpi)
 {
@@ -2797,6 +2801,7 @@ lpfc_findnode_rpi(struct lpfc_vport *vport, uint16_t rpi)
 	spin_unlock_irq(shost->host_lock);
 	return ndlp;
 }
+#endif  /*  0  */
 
 /*
  * This routine looks up the ndlp lists for the given WWPN. If WWPN found it
diff --git a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
index ecebdfa..131f81e 100644
--- a/drivers/scsi/lpfc/lpfc_init.c
+++ b/drivers/scsi/lpfc/lpfc_init.c
@@ -473,7 +473,7 @@ lpfc_hba_down_post(struct lpfc_hba *phba)
 }
 
 /* HBA heart beat timeout handler */
-void
+static void
 lpfc_hb_timeout(unsigned long ptr)
 {
 	struct lpfc_hba *phba;
@@ -1339,6 +1339,16 @@ lpfc_stop_phba_timers(struct lpfc_hba *phba)
 	return;
 }
 
+static void
+lpfc_block_mgmt_io(struct lpfc_hba * phba)
+{
+	unsigned long iflag;
+
+	spin_lock_irqsave(&phba->hbalock, iflag);
+	phba->sli.sli_flag |= LPFC_BLOCK_MGMT_IO;
+	spin_unlock_irqrestore(&phba->hbalock, iflag);
+}
+
 int
 lpfc_online(struct lpfc_hba *phba)
 {
@@ -1385,16 +1395,6 @@ lpfc_online(struct lpfc_hba *phba)
 }
 
 void
-lpfc_block_mgmt_io(struct lpfc_hba * phba)
-{
-	unsigned long iflag;
-
-	spin_lock_irqsave(&phba->hbalock, iflag);
-	phba->sli.sli_flag |= LPFC_BLOCK_MGMT_IO;
-	spin_unlock_irqrestore(&phba->hbalock, iflag);
-}
-
-void
 lpfc_unblock_mgmt_io(struct lpfc_hba * phba)
 {
 	unsigned long iflag;
diff --git a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
index ce348c5..de79d72 100644
--- a/drivers/scsi/lpfc/lpfc_sli.c
+++ b/drivers/scsi/lpfc/lpfc_sli.c
@@ -106,7 +106,7 @@ lpfc_sli_get_iocbq(struct lpfc_hba *phba)
 	return iocbq;
 }
 
-void
+static void
 __lpfc_sli_release_iocbq(struct lpfc_hba *phba, struct lpfc_iocbq *iocbq)
 {
 	size_t start_clean = offsetof(struct lpfc_iocbq, iocb);
@@ -514,7 +514,7 @@ lpfc_sli_turn_on_ring(struct lpfc_hba *phba, int ringno)
 	spin_unlock_irqrestore(&phba->hbalock, iflags);
 }
 
-struct lpfc_hbq_entry *
+static struct lpfc_hbq_entry *
 lpfc_sli_next_hbq_slot(struct lpfc_hba *phba, uint32_t hbqno)
 {
 	struct hbq_s *hbqp = &phba->hbqs[hbqno];
@@ -660,14 +660,14 @@ lpfc_sli_hbqbuf_add_hbqs(struct lpfc_hba *phba, uint32_t qno)
 					 lpfc_hbq_defs[qno]->add_count));
 }
 
-int
+static int
 lpfc_sli_hbqbuf_init_hbqs(struct lpfc_hba *phba, uint32_t qno)
 {
 	return(lpfc_sli_hbqbuf_fill_hbqs(phba, qno,
 					 lpfc_hbq_defs[qno]->init_count));
 }
 
-struct hbq_dmabuf *
+static struct hbq_dmabuf *
 lpfc_sli_hbqbuf_find(struct lpfc_hba *phba, uint32_t tag)
 {
 	struct lpfc_dmabuf *d_buf;
@@ -2848,7 +2848,7 @@ lpfc_sli_next_iocb(struct lpfc_hba *phba, struct lpfc_sli_ring *pring,
 /*
  * Lockless version of lpfc_sli_issue_iocb.
  */
-int
+static int
 __lpfc_sli_issue_iocb(struct lpfc_hba *phba, struct lpfc_sli_ring *pring,
 		    struct lpfc_iocbq *piocb, uint32_t flag)
 {
diff --git a/drivers/scsi/lpfc/lpfc_vport.c b/drivers/scsi/lpfc/lpfc_vport.c
index dcb415e..cff3828 100644
--- a/drivers/scsi/lpfc/lpfc_vport.c
+++ b/drivers/scsi/lpfc/lpfc_vport.c
@@ -532,9 +532,6 @@ skip_logo:
 	return VPORT_OK;
 }
 
-EXPORT_SYMBOL(lpfc_vport_create);
-EXPORT_SYMBOL(lpfc_vport_delete);
-
 struct lpfc_vport **
 lpfc_create_vport_work_array(struct lpfc_hba *phba)
 {

