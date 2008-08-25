From: James Smart <James.Smart@Emulex.Com>
Subject: [PATCH 6/15] lpfc 8.2.8 : Miscellaneous Discovery Fixes
Date: Sun, 24 Aug 2008 21:49:45 -0400
Message-ID: <1219628985.7890.31.camel@localhost.localdomain>
Reply-To: James.Smart@Emulex.Com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:52463 "EHLO
	emulex.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753212AbYHYBtn (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 24 Aug 2008 21:49:43 -0400
Received: from xbl3.ad.emulex.com (xbl3.ma.emulex.com [138.239.73.12])
	by emulex.emulex.com (8.13.6/8.13.6) with ESMTP id m7P1ngRQ019949
	for <linux-scsi@vger.kernel.org>; Sun, 24 Aug 2008 18:49:42 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


Miscellaneous Discovery fixes:
- Fix rejection followed by acceptance in handling RPL and RPS
  unsolicited events
- Fix for vport delete crash
- Fix PLOGI vs ADISC race condition


 Signed-off-by: James Smart <james.smart@emulex.com>

 ---

 lpfc_els.c       |  186 ++++++++++++++++++++++++++++---------------------------
 lpfc_init.c      |    8 --
 lpfc_nportdisc.c |   14 ----
 lpfc_vport.c     |   74 +++++++++++++++++++++
 4 files changed, 172 insertions(+), 110 deletions(-)


diff -upNr a/drivers/scsi/lpfc/lpfc_els.c b/drivers/scsi/lpfc/lpfc_els.c
--- a/drivers/scsi/lpfc/lpfc_els.c	2008-08-24 18:58:43.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_els.c	2008-08-24 20:36:39.000000000 -0400
@@ -1556,6 +1556,83 @@ lpfc_issue_els_prli(struct lpfc_vport *v
 }
 
 /**
+ * lpfc_rscn_disc: Perform rscn discovery for a vport.
+ * @vport: pointer to a host virtual N_Port data structure.
+ *
+ * This routine performs Registration State Change Notification (RSCN)
+ * discovery for a @vport. If the @vport's node port recovery count is not
+ * zero, it will invoke the lpfc_els_disc_plogi() to perform PLOGI for all
+ * the nodes that need recovery. If none of the PLOGI were needed through
+ * the lpfc_els_disc_plogi() routine, the lpfc_end_rscn() routine shall be
+ * invoked to check and handle possible more RSCN came in during the period
+ * of processing the current ones.
+ **/
+static void
+lpfc_rscn_disc(struct lpfc_vport *vport)
+{
+	lpfc_can_disctmo(vport);
+
+	/* RSCN discovery */
+	/* go thru NPR nodes and issue ELS PLOGIs */
+	if (vport->fc_npr_cnt)
+		if (lpfc_els_disc_plogi(vport))
+			return;
+
+	lpfc_end_rscn(vport);
+}
+
+/**
+ * lpfc_adisc_done: Complete the adisc phase of discovery.
+ * @vport: pointer to lpfc_vport hba data structure that finished all ADISCs.
+ *
+ * This function is called when the final ADISC is completed during discovery.
+ * This function handles clearing link attention or issuing reg_vpi depending
+ * on whether npiv is enabled. This function also kicks off the PLOGI phase of
+ * discovery.
+ * This function is called with no locks held.
+ **/
+static void
+lpfc_adisc_done(struct lpfc_vport *vport)
+{
+	struct Scsi_Host   *shost = lpfc_shost_from_vport(vport);
+	struct lpfc_hba   *phba = vport->phba;
+
+	/*
+	 * For NPIV, cmpl_reg_vpi will set port_state to READY,
+	 * and continue discovery.
+	 */
+	if ((phba->sli3_options & LPFC_SLI3_NPIV_ENABLED) &&
+	    !(vport->fc_flag & FC_RSCN_MODE)) {
+		lpfc_issue_reg_vpi(phba, vport);
+		return;
+	}
+	/*
+	* For SLI2, we need to set port_state to READY
+	* and continue discovery.
+	*/
+	if (vport->port_state < LPFC_VPORT_READY) {
+		/* If we get here, there is nothing to ADISC */
+		if (vport->port_type == LPFC_PHYSICAL_PORT)
+			lpfc_issue_clear_la(phba, vport);
+		if (!(vport->fc_flag & FC_ABORT_DISCOVERY)) {
+			vport->num_disc_nodes = 0;
+			/* go thru NPR list, issue ELS PLOGIs */
+			if (vport->fc_npr_cnt)
+				lpfc_els_disc_plogi(vport);
+			if (!vport->num_disc_nodes) {
+				spin_lock_irq(shost->host_lock);
+				vport->fc_flag &= ~FC_NDISC_ACTIVE;
+				spin_unlock_irq(shost->host_lock);
+				lpfc_can_disctmo(vport);
+				lpfc_end_rscn(vport);
+			}
+		}
+		vport->port_state = LPFC_VPORT_READY;
+	} else
+		lpfc_rscn_disc(vport);
+}
+
+/**
  * lpfc_more_adisc: Issue more adisc as needed.
  * @vport: pointer to a host virtual N_Port data structure.
  *
@@ -1583,36 +1660,12 @@ lpfc_more_adisc(struct lpfc_vport *vport
 		/* go thru NPR nodes and issue any remaining ELS ADISCs */
 		sentadisc = lpfc_els_disc_adisc(vport);
 	}
+	if (!vport->num_disc_nodes)
+		lpfc_adisc_done(vport);
 	return;
 }
 
 /**
- * lpfc_rscn_disc: Perform rscn discovery for a vport.
- * @vport: pointer to a host virtual N_Port data structure.
- *
- * This routine performs Registration State Change Notification (RSCN)
- * discovery for a @vport. If the @vport's node port recovery count is not
- * zero, it will invoke the lpfc_els_disc_plogi() to perform PLOGI for all
- * the nodes that need recovery. If none of the PLOGI were needed through
- * the lpfc_els_disc_plogi() routine, the lpfc_end_rscn() routine shall be
- * invoked to check and handle possible more RSCN came in during the period
- * of processing the current ones.
- **/
-static void
-lpfc_rscn_disc(struct lpfc_vport *vport)
-{
-	lpfc_can_disctmo(vport);
-
-	/* RSCN discovery */
-	/* go thru NPR nodes and issue ELS PLOGIs */
-	if (vport->fc_npr_cnt)
-		if (lpfc_els_disc_plogi(vport))
-			return;
-
-	lpfc_end_rscn(vport);
-}
-
-/**
  * lpfc_cmpl_els_adisc: Completion callback function for adisc.
  * @phba: pointer to lpfc hba data structure.
  * @cmdiocb: pointer to lpfc command iocb data structure.
@@ -1692,52 +1745,9 @@ lpfc_cmpl_els_adisc(struct lpfc_hba *phb
 		lpfc_disc_state_machine(vport, ndlp, cmdiocb,
 					NLP_EVT_CMPL_ADISC);
 
-	if (disc && vport->num_disc_nodes) {
-		/* Check to see if there are more ADISCs to be sent */
+	/* Check to see if there are more ADISCs to be sent */
+	if (disc && vport->num_disc_nodes)
 		lpfc_more_adisc(vport);
-
-		/* Check to see if we are done with ADISC authentication */
-		if (vport->num_disc_nodes == 0) {
-			/* If we get here, there is nothing left to ADISC */
-			/*
-			 * For NPIV, cmpl_reg_vpi will set port_state to READY,
-			 * and continue discovery.
-			 */
-			if ((phba->sli3_options & LPFC_SLI3_NPIV_ENABLED) &&
-			   !(vport->fc_flag & FC_RSCN_MODE)) {
-				lpfc_issue_reg_vpi(phba, vport);
-				goto out;
-			}
-			/*
-			 * For SLI2, we need to set port_state to READY
-			 * and continue discovery.
-			 */
-			if (vport->port_state < LPFC_VPORT_READY) {
-				/* If we get here, there is nothing to ADISC */
-				if (vport->port_type == LPFC_PHYSICAL_PORT)
-					lpfc_issue_clear_la(phba, vport);
-
-				if (!(vport->fc_flag & FC_ABORT_DISCOVERY)) {
-					vport->num_disc_nodes = 0;
-					/* go thru NPR list, issue ELS PLOGIs */
-					if (vport->fc_npr_cnt)
-						lpfc_els_disc_plogi(vport);
-
-					if (!vport->num_disc_nodes) {
-						spin_lock_irq(shost->host_lock);
-						vport->fc_flag &=
-							~FC_NDISC_ACTIVE;
-						spin_unlock_irq(
-							shost->host_lock);
-						lpfc_can_disctmo(vport);
-					}
-				}
-				vport->port_state = LPFC_VPORT_READY;
-			} else {
-				lpfc_rscn_disc(vport);
-			}
-		}
-	}
 out:
 	lpfc_els_free_iocb(phba, cmdiocb);
 	return;
@@ -2258,19 +2268,16 @@ lpfc_cancel_retry_delay_tmo(struct lpfc_
 			if (vport->port_state < LPFC_VPORT_READY) {
 				/* Check if there are more ADISCs to be sent */
 				lpfc_more_adisc(vport);
-				if ((vport->num_disc_nodes == 0) &&
-				    (vport->fc_npr_cnt))
-					lpfc_els_disc_plogi(vport);
 			} else {
 				/* Check if there are more PLOGIs to be sent */
 				lpfc_more_plogi(vport);
-			}
-			if (vport->num_disc_nodes == 0) {
-				spin_lock_irq(shost->host_lock);
-				vport->fc_flag &= ~FC_NDISC_ACTIVE;
-				spin_unlock_irq(shost->host_lock);
-				lpfc_can_disctmo(vport);
-				lpfc_end_rscn(vport);
+				if (vport->num_disc_nodes == 0) {
+					spin_lock_irq(shost->host_lock);
+					vport->fc_flag &= ~FC_NDISC_ACTIVE;
+					spin_unlock_irq(shost->host_lock);
+					lpfc_can_disctmo(vport);
+					lpfc_end_rscn(vport);
+				}
 			}
 		}
 	}
@@ -4480,14 +4487,9 @@ lpfc_els_rcv_rps(struct lpfc_vport *vpor
 	struct ls_rjt stat;
 
 	if ((ndlp->nlp_state != NLP_STE_UNMAPPED_NODE) &&
-	    (ndlp->nlp_state != NLP_STE_MAPPED_NODE)) {
-		stat.un.b.lsRjtRsvd0 = 0;
-		stat.un.b.lsRjtRsnCode = LSRJT_UNABLE_TPC;
-		stat.un.b.lsRjtRsnCodeExp = LSEXP_CANT_GIVE_DATA;
-		stat.un.b.vendorUnique = 0;
-		lpfc_els_rsp_reject(vport, stat.un.lsRjtError, cmdiocb, ndlp,
-			NULL);
-	}
+	    (ndlp->nlp_state != NLP_STE_MAPPED_NODE))
+		/* reject the unsolicited RPS request and done with it */
+		goto reject_out;
 
 	pcmd = (struct lpfc_dmabuf *) cmdiocb->context2;
 	lp = (uint32_t *) pcmd->virt;
@@ -4520,6 +4522,9 @@ lpfc_els_rcv_rps(struct lpfc_vport *vpor
 			mempool_free(mbox, phba->mbox_mem_pool);
 		}
 	}
+
+reject_out:
+	/* issue rejection response */
 	stat.un.b.lsRjtRsvd0 = 0;
 	stat.un.b.lsRjtRsnCode = LSRJT_UNABLE_TPC;
 	stat.un.b.lsRjtRsnCodeExp = LSEXP_CANT_GIVE_DATA;
@@ -4629,12 +4634,15 @@ lpfc_els_rcv_rpl(struct lpfc_vport *vpor
 
 	if ((ndlp->nlp_state != NLP_STE_UNMAPPED_NODE) &&
 	    (ndlp->nlp_state != NLP_STE_MAPPED_NODE)) {
+		/* issue rejection response */
 		stat.un.b.lsRjtRsvd0 = 0;
 		stat.un.b.lsRjtRsnCode = LSRJT_UNABLE_TPC;
 		stat.un.b.lsRjtRsnCodeExp = LSEXP_CANT_GIVE_DATA;
 		stat.un.b.vendorUnique = 0;
 		lpfc_els_rsp_reject(vport, stat.un.lsRjtError, cmdiocb, ndlp,
 			NULL);
+		/* rejected the unsolicited RPL request and done with it */
+		return 0;
 	}
 
 	pcmd = (struct lpfc_dmabuf *) cmdiocb->context2;
diff -upNr a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
--- a/drivers/scsi/lpfc/lpfc_init.c	2008-08-24 18:58:43.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_init.c	2008-08-24 20:36:13.000000000 -0400
@@ -1580,14 +1580,6 @@ lpfc_cleanup(struct lpfc_vport *vport)
 		lpfc_disc_state_machine(vport, ndlp, NULL,
 					     NLP_EVT_DEVICE_RM);
 
-		/* nlp_type zero is not defined, nlp_flag zero also not defined,
-		 * nlp_state is unused, this happens when
-		 * an initiator has logged
-		 * into us so cleanup this ndlp.
-		 */
-		if ((ndlp->nlp_type == 0) && (ndlp->nlp_flag == 0) &&
-			(ndlp->nlp_state == 0))
-			lpfc_nlp_put(ndlp);
 	}
 
 	/* At this point, ALL ndlp's should be gone
diff -upNr a/drivers/scsi/lpfc/lpfc_nportdisc.c b/drivers/scsi/lpfc/lpfc_nportdisc.c
--- a/drivers/scsi/lpfc/lpfc_nportdisc.c	2008-06-30 09:31:58.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_nportdisc.c	2008-08-24 20:36:39.000000000 -0400
@@ -1003,20 +1003,8 @@ lpfc_rcv_plogi_adisc_issue(struct lpfc_v
 			spin_lock_irq(shost->host_lock);
 			ndlp->nlp_flag &= ~NLP_NPR_2B_DISC;
 			spin_unlock_irq(shost->host_lock);
-
-			if (vport->num_disc_nodes) {
+			if (vport->num_disc_nodes)
 				lpfc_more_adisc(vport);
-				if ((vport->num_disc_nodes == 0) &&
-				    (vport->fc_npr_cnt))
-					lpfc_els_disc_plogi(vport);
-				if (vport->num_disc_nodes == 0) {
-					spin_lock_irq(shost->host_lock);
-					vport->fc_flag &= ~FC_NDISC_ACTIVE;
-					spin_unlock_irq(shost->host_lock);
-					lpfc_can_disctmo(vport);
-					lpfc_end_rscn(vport);
-				}
-			}
 		}
 		return ndlp->nlp_state;
 	}
diff -upNr a/drivers/scsi/lpfc/lpfc_vport.c b/drivers/scsi/lpfc/lpfc_vport.c
--- a/drivers/scsi/lpfc/lpfc_vport.c	2008-06-30 09:31:58.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_vport.c	2008-08-24 20:36:13.000000000 -0400
@@ -204,6 +204,77 @@ lpfc_unique_wwpn(struct lpfc_hba *phba, 
 	return 1;
 }
 
+/**
+ * lpfc_discovery_wait: Wait for driver discovery to quiesce.
+ * @vport: The virtual port for which this call is being executed.
+ *
+ * This driver calls this routine specifically from lpfc_vport_delete
+ * to enforce a synchronous execution of vport
+ * delete relative to discovery activities.  The
+ * lpfc_vport_delete routine should not return until it
+ * can reasonably guarantee that discovery has quiesced.
+ * Post FDISC LOGO, the driver must wait until its SAN teardown is
+ * complete and all resources recovered before allowing
+ * cleanup.
+ *
+ * This routine does not require any locks held.
+ **/
+static void lpfc_discovery_wait(struct lpfc_vport *vport)
+{
+	struct lpfc_hba *phba = vport->phba;
+	uint32_t wait_flags = 0;
+	unsigned long wait_time_max;
+	unsigned long start_time;
+
+	wait_flags = FC_RSCN_MODE | FC_RSCN_DISCOVERY | FC_NLP_MORE |
+		     FC_RSCN_DEFERRED | FC_NDISC_ACTIVE | FC_DISC_TMO;
+
+	/*
+	 * The time constraint on this loop is a balance between the
+	 * fabric RA_TOV value and dev_loss tmo.  The driver's
+	 * devloss_tmo is 10 giving this loop a 3x multiplier minimally.
+	 */
+	wait_time_max = msecs_to_jiffies(((phba->fc_ratov * 3) + 3) * 1000);
+	wait_time_max += jiffies;
+	start_time = jiffies;
+	while (time_before(jiffies, wait_time_max)) {
+		if ((vport->num_disc_nodes > 0)    ||
+		    (vport->fc_flag & wait_flags)  ||
+		    ((vport->port_state > LPFC_VPORT_FAILED) &&
+		     (vport->port_state < LPFC_VPORT_READY))) {
+			lpfc_printf_log(phba, KERN_INFO, LOG_VPORT,
+					"1833 Vport discovery quiesce Wait:"
+					" vpi x%x state x%x fc_flags x%x"
+					" num_nodes x%x, waiting 1000 msecs"
+					" total wait msecs x%x\n",
+					vport->vpi, vport->port_state,
+					vport->fc_flag, vport->num_disc_nodes,
+					jiffies_to_msecs(jiffies - start_time));
+			msleep(1000);
+		} else {
+			/* Base case.  Wait variants satisfied.  Break out */
+			lpfc_printf_log(phba, KERN_INFO, LOG_VPORT,
+					 "1834 Vport discovery quiesced:"
+					 " vpi x%x state x%x fc_flags x%x"
+					 " wait msecs x%x\n",
+					 vport->vpi, vport->port_state,
+					 vport->fc_flag,
+					 jiffies_to_msecs(jiffies
+						- start_time));
+			break;
+		}
+	}
+
+	if (time_after(jiffies, wait_time_max))
+		lpfc_printf_log(phba, KERN_ERR, LOG_VPORT,
+				"1835 Vport discovery quiesce failed:"
+				" vpi x%x state x%x fc_flags x%x"
+				" wait msecs x%x\n",
+				vport->vpi, vport->port_state,
+				vport->fc_flag,
+				jiffies_to_msecs(jiffies - start_time));
+}
+
 int
 lpfc_vport_create(struct fc_vport *fc_vport, bool disable)
 {
@@ -602,6 +673,9 @@ lpfc_vport_delete(struct fc_vport *fc_vp
 				timeout = schedule_timeout(timeout);
 	}
 
+	if (!(phba->pport->load_flag & FC_UNLOADING))
+		lpfc_discovery_wait(vport);
+
 skip_logo:
 	lpfc_cleanup(vport);
 	lpfc_sli_host_down(vport);


