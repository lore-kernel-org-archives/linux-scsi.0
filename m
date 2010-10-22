From: James Smart <james.smart@emulex.com>
Subject: [PATCH 1/7] lpfc 8.3.18: FC/FCoE Discovery fixes
Date: Fri, 22 Oct 2010 11:05:36 -0400
Message-ID: <1287759951.11844.18.camel@wookie>
Reply-To: james.smart@emulex.com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from exht1.emulex.com ([138.239.113.183]:56052 "EHLO
	exht1.ad.emulex.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755898Ab0JVPGF (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 22 Oct 2010 11:06:05 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

FC/FCoE Discovery fixes:

- Call the lpfc_drain_txq only for SLI4 hba
- In lpfc_cmpl_els_fdisc, fix code path that does not free IOCB.
- Treated firmware matching FCF property with different index as error
- Propagate error returns from lpfc_issue_els_flogi()
- Refactored lpfc_unregister_unused_fcf() to create a post
  lpfc_dev_loss_tmo handler call for SLI-4 devices. Allows checking of 
  fcf after last ndlp released so that fcf can be released if no longer
  in use.
- Replaced individual FCF_XXXX_DISC flag clearing in lieu of aggregate
  FCF_DISCOVERY flag upon succesful completion of flogi.
- Correct setting of altBbCredit value in sparams to correct issue with
  logins with remote loop-based devices.


 Signed-off-by: Alex Iannicelli <alex.iannicelli@emulex.com>
 Signed-off-by: James Smart <james.smart@emulex.com>

 ---

 lpfc_els.c     |   20 +++++++-------
 lpfc_hbadisc.c |   79 ++++++++++++++++++++++++++++++---------------------------
 lpfc_init.c    |    9 +++---
 3 files changed, 58 insertions(+), 50 deletions(-)


diff -upNr a/drivers/scsi/lpfc/lpfc_els.c b/drivers/scsi/lpfc/lpfc_els.c
--- a/drivers/scsi/lpfc/lpfc_els.c	2010-10-11 12:32:22.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_els.c	2010-10-21 22:37:34.000000000 -0400
@@ -523,12 +523,6 @@ lpfc_cmpl_els_flogi_fabric(struct lpfc_v
 		spin_lock_irq(shost->host_lock);
 		vport->fc_flag |= FC_PUBLIC_LOOP;
 		spin_unlock_irq(shost->host_lock);
-	} else {
-		/*
-		 * If we are a N-port connected to a Fabric, fixup sparam's so
-		 * logins to devices on remote loops work.
-		 */
-		vport->fc_sparam.cmn.altBbCredit = 1;
 	}
 
 	vport->fc_myDID = irsp->un.ulpWord[4] & Mask_DID;
@@ -1175,12 +1169,13 @@ lpfc_initial_flogi(struct lpfc_vport *vp
 			return 0;
 	}
 
-	if (lpfc_issue_els_flogi(vport, ndlp, 0))
+	if (lpfc_issue_els_flogi(vport, ndlp, 0)) {
 		/* This decrement of reference count to node shall kick off
 		 * the release of the node.
 		 */
 		lpfc_nlp_put(ndlp);
-
+		return 0;
+	}
 	return 1;
 }
 
@@ -1645,6 +1640,13 @@ lpfc_issue_els_plogi(struct lpfc_vport *
 	memcpy(pcmd, &vport->fc_sparam, sizeof(struct serv_parm));
 	sp = (struct serv_parm *) pcmd;
 
+	/*
+	 * If we are a N-port connected to a Fabric, fix-up paramm's so logins
+	 * to device on remote loops work.
+	 */
+	if ((vport->fc_flag & FC_FABRIC) && !(vport->fc_flag & FC_PUBLIC_LOOP))
+		sp->cmn.altBbCredit = 1;
+
 	if (sp->cmn.fcphLow < FC_PH_4_3)
 		sp->cmn.fcphLow = FC_PH_4_3;
 
@@ -6452,7 +6454,7 @@ lpfc_cmpl_els_fdisc(struct lpfc_hba *phb
 		 * to update the MAC address.
 		 */
 		lpfc_register_new_vport(phba, vport, ndlp);
-		return ;
+		goto out;
 	}
 
 	if (vport->fc_flag & FC_VPORT_NEEDS_INIT_VPI)
diff -upNr a/drivers/scsi/lpfc/lpfc_hbadisc.c b/drivers/scsi/lpfc/lpfc_hbadisc.c
--- a/drivers/scsi/lpfc/lpfc_hbadisc.c	2010-10-11 12:32:22.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_hbadisc.c	2010-10-21 22:37:34.000000000 -0400
@@ -1803,6 +1803,16 @@ lpfc_mbx_cmpl_fcf_scan_read_fcf_rec(stru
 		if ((phba->fcf.fcf_flag & FCF_IN_USE) &&
 		    lpfc_sli4_fcf_record_match(phba, &phba->fcf.current_rec,
 		    new_fcf_record, LPFC_FCOE_IGNORE_VID)) {
+			if (bf_get(lpfc_fcf_record_fcf_index, new_fcf_record) !=
+			    phba->fcf.current_rec.fcf_indx) {
+				lpfc_printf_log(phba, KERN_ERR, LOG_FIP,
+					"2862 FCF (x%x) matches property "
+					"of in-use FCF (x%x)\n",
+					bf_get(lpfc_fcf_record_fcf_index,
+					       new_fcf_record),
+					phba->fcf.current_rec.fcf_indx);
+				goto read_next_fcf;
+			}
 			/*
 			 * In case the current in-use FCF record becomes
 			 * invalid/unavailable during FCF discovery that
@@ -1844,22 +1854,29 @@ lpfc_mbx_cmpl_fcf_scan_read_fcf_rec(stru
 	if (phba->fcf.fcf_flag & FCF_IN_USE) {
 		if (lpfc_sli4_fcf_record_match(phba, &phba->fcf.current_rec,
 		    new_fcf_record, vlan_id)) {
-			phba->fcf.fcf_flag |= FCF_AVAILABLE;
-			if (phba->fcf.fcf_flag & FCF_REDISC_PEND)
-				/* Stop FCF redisc wait timer if pending */
-				__lpfc_sli4_stop_fcf_redisc_wait_timer(phba);
-			else if (phba->fcf.fcf_flag & FCF_REDISC_FOV)
-				/* If in fast failover, mark it's completed */
-				phba->fcf.fcf_flag &= ~FCF_REDISC_FOV;
-			spin_unlock_irq(&phba->hbalock);
-			lpfc_printf_log(phba, KERN_INFO, LOG_FIP,
-					"2836 The new FCF record (x%x) "
-					"matches the in-use FCF record "
-					"(x%x)\n",
-					phba->fcf.current_rec.fcf_indx,
+			if (bf_get(lpfc_fcf_record_fcf_index, new_fcf_record) ==
+			    phba->fcf.current_rec.fcf_indx) {
+				phba->fcf.fcf_flag |= FCF_AVAILABLE;
+				if (phba->fcf.fcf_flag & FCF_REDISC_PEND)
+					/* Stop FCF redisc wait timer */
+					__lpfc_sli4_stop_fcf_redisc_wait_timer(
+									phba);
+				else if (phba->fcf.fcf_flag & FCF_REDISC_FOV)
+					/* Fast failover, mark completed */
+					phba->fcf.fcf_flag &= ~FCF_REDISC_FOV;
+				spin_unlock_irq(&phba->hbalock);
+				lpfc_printf_log(phba, KERN_INFO, LOG_FIP,
+						"2836 New FCF matches in-use "
+						"FCF (x%x)\n",
+						phba->fcf.current_rec.fcf_indx);
+				goto out;
+			} else
+				lpfc_printf_log(phba, KERN_ERR, LOG_FIP,
+					"2863 New FCF (x%x) matches "
+					"property of in-use FCF (x%x)\n",
 					bf_get(lpfc_fcf_record_fcf_index,
-					       new_fcf_record));
-			goto out;
+					       new_fcf_record),
+					phba->fcf.current_rec.fcf_indx);
 		}
 		/*
 		 * Read next FCF record from HBA searching for the matching
@@ -2069,28 +2086,6 @@ read_next_fcf:
 						LPFC_FCOE_FCF_GET_FIRST);
 				return;
 			}
-
-			/*
-			 * Otherwise, initial scan or post linkdown rescan,
-			 * register with the best FCF record found so far
-			 * through the FCF scanning process.
-			 */
-
-			/*
-			 * Mark the initial FCF discovery completed and
-			 * the start of the first round of the roundrobin
-			 * FCF failover.
-			 */
-			spin_lock_irq(&phba->hbalock);
-			phba->fcf.fcf_flag &=
-					~(FCF_INIT_DISC | FCF_REDISC_RRU);
-			spin_unlock_irq(&phba->hbalock);
-			/*
-			 * Set up the initial registered FCF index for FLOGI
-			 * round robin FCF failover
-			 */
-			phba->fcf.fcf_rr_init_indx =
-					phba->fcf.current_rec.fcf_indx;
 			/* Register to the new FCF record */
 			lpfc_register_fcf(phba);
 		}
@@ -3992,6 +3987,16 @@ lpfc_cleanup_node(struct lpfc_vport *vpo
 	}
 
 	spin_lock_irq(&phba->hbalock);
+	/* Cleanup REG_LOGIN completions which are not yet processed */
+	list_for_each_entry(mb, &phba->sli.mboxq_cmpl, list) {
+		if ((mb->u.mb.mbxCommand != MBX_REG_LOGIN64) ||
+			(ndlp != (struct lpfc_nodelist *) mb->context2))
+			continue;
+
+		mb->context2 = NULL;
+		mb->mbox_cmpl = lpfc_sli_def_mbox_cmpl;
+	}
+
 	list_for_each_entry_safe(mb, nextmb, &phba->sli.mboxq, list) {
 		if ((mb->u.mb.mbxCommand == MBX_REG_LOGIN64) &&
 		    (ndlp == (struct lpfc_nodelist *) mb->context2)) {
diff -upNr a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
--- a/drivers/scsi/lpfc/lpfc_init.c	2010-10-11 12:32:22.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_init.c	2010-10-21 22:37:34.000000000 -0400
@@ -2234,10 +2234,9 @@ lpfc_stop_vport_timers(struct lpfc_vport
 void
 __lpfc_sli4_stop_fcf_redisc_wait_timer(struct lpfc_hba *phba)
 {
-	/* Clear pending FCF rediscovery wait and failover in progress flags */
-	phba->fcf.fcf_flag &= ~(FCF_REDISC_PEND |
-				FCF_DEAD_DISC |
-				FCF_ACVL_DISC);
+	/* Clear pending FCF rediscovery wait flag */
+	phba->fcf.fcf_flag &= ~FCF_REDISC_PEND;
+
 	/* Now, try to stop the timer */
 	del_timer(&phba->fcf.redisc_wait);
 }
@@ -2261,6 +2260,8 @@ lpfc_sli4_stop_fcf_redisc_wait_timer(str
 		return;
 	}
 	__lpfc_sli4_stop_fcf_redisc_wait_timer(phba);
+	/* Clear failover in progress flags */
+	phba->fcf.fcf_flag &= ~(FCF_DEAD_DISC | FCF_ACVL_DISC);
 	spin_unlock_irq(&phba->hbalock);
 }
 


