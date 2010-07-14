From: James Smart <james.smart@emulex.com>
Subject: [PATCH 2/4] lpfc 8.3.15: FCoE Related Fixes
Date: Wed, 14 Jul 2010 15:31:37 -0400
Message-ID: <1279135917.32010.3.camel@wookie>
Reply-To: james.smart@emulex.com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from exht1.emulex.com ([138.239.113.183]:37766 "EHLO
	exht1.ad.emulex.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753236Ab0GNTgT (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 14 Jul 2010 15:36:19 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


FCoE Related Fixes
- Correct find-next-FCF routine so that it searches at next FCF rather
  than current one.
- Enhanced round-robin FCF failover algorithm to re-start on "New FCF"
  async event
- Update the manner in which we look at FCFs while they may be in 
  their discovery state.
- Use LPFC_FCOE_NULL_VID macro when checkinf for valid vlan_id for FCF


 Signed-off-by: Alex Iannicelli <alex.iannicelli@emulex.com>
 Signed-off-by: James Smart <james.smart@emulex.com>

 ---

 lpfc_els.c     |   24 ++++++++++++------------
 lpfc_hbadisc.c |   28 ++++++++++++++++++++--------
 lpfc_init.c    |   22 ++++++++++------------
 lpfc_mbox.c    |    2 +-
 lpfc_sli.c     |   55 ++++++++++++++++++++++++++++++++++++++++++++++++-------
 lpfc_sli4.h    |    1 +
 6 files changed, 92 insertions(+), 40 deletions(-)


diff -upNr a/drivers/scsi/lpfc/lpfc_els.c b/drivers/scsi/lpfc/lpfc_els.c
--- a/drivers/scsi/lpfc/lpfc_els.c	2010-07-14 13:46:49.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_els.c	2010-07-14 13:47:16.000000000 -0400
@@ -813,18 +813,21 @@ lpfc_cmpl_els_flogi(struct lpfc_hba *phb
 				 */
 				lpfc_printf_log(phba, KERN_WARNING,
 						LOG_FIP | LOG_ELS,
-						"2760 FLOGI exhausted FCF "
-						"round robin failover list, "
-						"retry FLOGI on the current "
-						"registered FCF index:%d\n",
+						"2760 Completed one round "
+						"of FLOGI FCF round robin "
+						"failover list, retry FLOGI "
+						"on currently registered "
+						"FCF index:%d\n",
 						phba->fcf.current_rec.fcf_indx);
-				spin_lock_irq(&phba->hbalock);
-				phba->fcf.fcf_flag &= ~FCF_DISCOVERY;
-				spin_unlock_irq(&phba->hbalock);
 			} else {
+				lpfc_printf_log(phba, KERN_INFO,
+						LOG_FIP | LOG_ELS,
+						"2794 FLOGI FCF round robin "
+						"failover to FCF index x%x\n",
+						fcf_index);
 				rc = lpfc_sli4_fcf_rr_read_fcf_rec(phba,
 								   fcf_index);
-				if (rc) {
+				if (rc)
 					lpfc_printf_log(phba, KERN_WARNING,
 							LOG_FIP | LOG_ELS,
 							"2761 FLOGI round "
@@ -833,10 +836,7 @@ lpfc_cmpl_els_flogi(struct lpfc_hba *phb
 							"rc:x%x, fcf_index:"
 							"%d\n", rc,
 						phba->fcf.current_rec.fcf_indx);
-					spin_lock_irq(&phba->hbalock);
-					phba->fcf.fcf_flag &= ~FCF_DISCOVERY;
-					spin_unlock_irq(&phba->hbalock);
-				} else
+				else
 					goto out;
 			}
 		}
diff -upNr a/drivers/scsi/lpfc/lpfc_hbadisc.c b/drivers/scsi/lpfc/lpfc_hbadisc.c
--- a/drivers/scsi/lpfc/lpfc_hbadisc.c	2010-07-14 13:46:49.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_hbadisc.c	2010-07-14 13:47:16.000000000 -0400
@@ -1572,7 +1572,7 @@ lpfc_sli4_new_fcf_random_select(struct l
 }
 
 /**
- * lpfc_mbx_cmpl_read_fcf_record - Completion handler for read_fcf mbox.
+ * lpfc_sli4_fcf_rec_mbox_parse - Parse read_fcf mbox command.
  * @phba: pointer to lpfc hba data structure.
  * @mboxq: pointer to mailbox object.
  * @next_fcf_index: pointer to holder of next fcf index.
@@ -2026,9 +2026,14 @@ read_next_fcf:
 			memcpy(&phba->fcf.current_rec,
 			       &phba->fcf.failover_rec,
 			       sizeof(struct lpfc_fcf_rec));
-			/* mark the FCF fast failover completed */
+			/*
+			 * Mark the fast FCF failover rediscovery completed
+			 * and the start of the first round of the roundrobin
+			 * FCF failover.
+			 */
 			spin_lock_irq(&phba->hbalock);
-			phba->fcf.fcf_flag &= ~FCF_REDISC_FOV;
+			phba->fcf.fcf_flag &=
+					~(FCF_REDISC_FOV | FCF_REDISC_RRU);
 			spin_unlock_irq(&phba->hbalock);
 			/*
 			 * Set up the initial registered FCF index for FLOGI
@@ -2074,9 +2079,14 @@ read_next_fcf:
 			 * through the FCF scanning process.
 			 */
 
-			/* mark the initial FCF discovery completed */
+			/*
+			 * Mark the initial FCF discovery completed and
+			 * the start of the first round of the roundrobin
+			 * FCF failover.
+			 */
 			spin_lock_irq(&phba->hbalock);
-			phba->fcf.fcf_flag &= ~FCF_INIT_DISC;
+			phba->fcf.fcf_flag &=
+					~(FCF_INIT_DISC | FCF_REDISC_RRU);
 			spin_unlock_irq(&phba->hbalock);
 			/*
 			 * Set up the initial registered FCF index for FLOGI
@@ -2206,7 +2216,7 @@ lpfc_mbx_cmpl_read_fcf_rec(struct lpfc_h
 		goto out;
 
 	/* If FCF discovery period is over, no need to proceed */
-	if (phba->fcf.fcf_flag & FCF_DISCOVERY)
+	if (!(phba->fcf.fcf_flag & FCF_DISCOVERY))
 		goto out;
 
 	/* Parse the FCF record from the non-embedded mailbox command */
@@ -5331,13 +5341,15 @@ void
 lpfc_unregister_unused_fcf(struct lpfc_hba *phba)
 {
 	/*
-	 * If HBA is not running in FIP mode or if HBA does not support
-	 * FCoE or if FCF is not registered, do nothing.
+	 * If HBA is not running in FIP mode, if HBA does not support
+	 * FCoE, if FCF discovery is ongoing, or if FCF has not been
+	 * registered, do nothing.
 	 */
 	spin_lock_irq(&phba->hbalock);
 	if (!(phba->hba_flag & HBA_FCOE_SUPPORT) ||
 	    !(phba->fcf.fcf_flag & FCF_REGISTERED) ||
 	    !(phba->hba_flag & HBA_FIP_SUPPORT) ||
+	    (phba->fcf.fcf_flag & FCF_DISCOVERY) ||
 	    (phba->pport->port_state == LPFC_FLOGI)) {
 		spin_unlock_irq(&phba->hbalock);
 		return;
diff -upNr a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
--- a/drivers/scsi/lpfc/lpfc_init.c	2010-07-09 00:49:14.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_init.c	2010-07-14 13:47:16.000000000 -0400
@@ -3357,22 +3357,14 @@ lpfc_sli4_async_fcoe_evt(struct lpfc_hba
 					"evt_tag:x%x, fcf_index:x%x\n",
 					acqe_fcoe->event_tag,
 					acqe_fcoe->index);
+		/* If the FCF discovery is in progress, do nothing. */
 		spin_lock_irq(&phba->hbalock);
-		if ((phba->fcf.fcf_flag & FCF_SCAN_DONE) ||
-		    (phba->hba_flag & FCF_DISC_INPROGRESS)) {
-			/*
-			 * If the current FCF is in discovered state or
-			 * FCF discovery is in progress, do nothing.
-			 */
+		if (phba->hba_flag & FCF_DISC_INPROGRESS) {
 			spin_unlock_irq(&phba->hbalock);
 			break;
 		}
-
+		/* If fast FCF failover rescan event is pending, do nothing */
 		if (phba->fcf.fcf_flag & FCF_REDISC_EVT) {
-			/*
-			 * If fast FCF failover rescan event is pending,
-			 * do nothing.
-			 */
 			spin_unlock_irq(&phba->hbalock);
 			break;
 		}
@@ -3393,7 +3385,13 @@ lpfc_sli4_async_fcoe_evt(struct lpfc_hba
 					acqe_fcoe->index);
 			rc = lpfc_sli4_read_fcf_rec(phba, acqe_fcoe->index);
 		}
-
+		/* If the FCF has been in discovered state, do nothing. */
+		spin_lock_irq(&phba->hbalock);
+		if (phba->fcf.fcf_flag & FCF_SCAN_DONE) {
+			spin_unlock_irq(&phba->hbalock);
+			break;
+		}
+		spin_unlock_irq(&phba->hbalock);
 		/* Otherwise, scan the entire FCF table and re-discover SAN */
 		lpfc_printf_log(phba, KERN_INFO, LOG_FIP | LOG_DISCOVERY,
 				"2770 Start FCF table scan due to new FCF "
diff -upNr a/drivers/scsi/lpfc/lpfc_mbox.c b/drivers/scsi/lpfc/lpfc_mbox.c
--- a/drivers/scsi/lpfc/lpfc_mbox.c	2010-07-09 00:49:14.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_mbox.c	2010-07-14 13:47:16.000000000 -0400
@@ -2045,7 +2045,7 @@ lpfc_reg_fcfi(struct lpfc_hba *phba, str
 	       phba->fcf.current_rec.fcf_indx);
 	/* reg_fcf addr mode is bit wise inverted value of fcf addr_mode */
 	bf_set(lpfc_reg_fcfi_mam, reg_fcfi, (~phba->fcf.addr_mode) & 0x3);
-	if (phba->fcf.current_rec.vlan_id != 0xFFFF) {
+	if (phba->fcf.current_rec.vlan_id != LPFC_FCOE_NULL_VID) {
 		bf_set(lpfc_reg_fcfi_vv, reg_fcfi, 1);
 		bf_set(lpfc_reg_fcfi_vlan_tag, reg_fcfi,
 		       phba->fcf.current_rec.vlan_id);
diff -upNr a/drivers/scsi/lpfc/lpfc_sli4.h b/drivers/scsi/lpfc/lpfc_sli4.h
--- a/drivers/scsi/lpfc/lpfc_sli4.h	2010-07-09 00:49:14.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_sli4.h	2010-07-14 13:47:16.000000000 -0400
@@ -163,6 +163,7 @@ struct lpfc_fcf {
 #define FCF_REDISC_PEND	0x80 /* FCF rediscovery pending */
 #define FCF_REDISC_EVT	0x100 /* FCF rediscovery event to worker thread */
 #define FCF_REDISC_FOV	0x200 /* Post FCF rediscovery fast failover */
+#define FCF_REDISC_RRU	0x400 /* Roundrobin bitmap updated */
 	uint32_t addr_mode;
 	uint16_t fcf_rr_init_indx;
 	uint32_t eligible_fcf_cnt;
diff -upNr a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
--- a/drivers/scsi/lpfc/lpfc_sli.c	2010-07-14 13:46:49.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_sli.c	2010-07-14 13:47:16.000000000 -0400
@@ -12405,19 +12405,47 @@ lpfc_sli4_fcf_rr_next_index_get(struct l
 {
 	uint16_t next_fcf_index;
 
-	/* Search from the currently registered FCF index */
+	/* Search start from next bit of currently registered FCF index */
+	next_fcf_index = (phba->fcf.current_rec.fcf_indx + 1) %
+					LPFC_SLI4_FCF_TBL_INDX_MAX;
 	next_fcf_index = find_next_bit(phba->fcf.fcf_rr_bmask,
 				       LPFC_SLI4_FCF_TBL_INDX_MAX,
-				       phba->fcf.current_rec.fcf_indx);
+				       next_fcf_index);
+
 	/* Wrap around condition on phba->fcf.fcf_rr_bmask */
 	if (next_fcf_index >= LPFC_SLI4_FCF_TBL_INDX_MAX)
 		next_fcf_index = find_next_bit(phba->fcf.fcf_rr_bmask,
 					       LPFC_SLI4_FCF_TBL_INDX_MAX, 0);
-	/* Round robin failover stop condition */
-	if ((next_fcf_index == phba->fcf.fcf_rr_init_indx) ||
-		(next_fcf_index >= LPFC_SLI4_FCF_TBL_INDX_MAX))
+
+	/* Check roundrobin failover list empty condition */
+	if (next_fcf_index >= LPFC_SLI4_FCF_TBL_INDX_MAX) {
+		lpfc_printf_log(phba, KERN_WARNING, LOG_FIP,
+				"2844 No roundrobin failover FCF available\n");
 		return LPFC_FCOE_FCF_NEXT_NONE;
+	}
+
+	/* Check roundrobin failover index bmask stop condition */
+	if (next_fcf_index == phba->fcf.fcf_rr_init_indx) {
+		if (!(phba->fcf.fcf_flag & FCF_REDISC_RRU)) {
+			lpfc_printf_log(phba, KERN_WARNING, LOG_FIP,
+					"2847 Round robin failover FCF index "
+					"search hit stop condition:x%x\n",
+					next_fcf_index);
+			return LPFC_FCOE_FCF_NEXT_NONE;
+		}
+		/* The roundrobin failover index bmask updated, start over */
+		lpfc_printf_log(phba, KERN_INFO, LOG_FIP,
+				"2848 Round robin failover FCF index bmask "
+				"updated, start over\n");
+		spin_lock_irq(&phba->hbalock);
+		phba->fcf.fcf_flag &= ~FCF_REDISC_RRU;
+		spin_unlock_irq(&phba->hbalock);
+		return phba->fcf.fcf_rr_init_indx;
+	}
 
+	lpfc_printf_log(phba, KERN_INFO, LOG_FIP,
+			"2845 Get next round robin failover "
+			"FCF index x%x\n", next_fcf_index);
 	return next_fcf_index;
 }
 
@@ -12447,11 +12475,20 @@ lpfc_sli4_fcf_rr_index_set(struct lpfc_h
 	/* Set the eligible FCF record index bmask */
 	set_bit(fcf_index, phba->fcf.fcf_rr_bmask);
 
+	/* Set the roundrobin index bmask updated */
+	spin_lock_irq(&phba->hbalock);
+	phba->fcf.fcf_flag |= FCF_REDISC_RRU;
+	spin_unlock_irq(&phba->hbalock);
+
+	lpfc_printf_log(phba, KERN_INFO, LOG_FIP,
+			"2790 Set FCF index x%x to round robin failover "
+			"bmask\n", fcf_index);
+
 	return 0;
 }
 
 /**
- * lpfc_sli4_fcf_rr_index_set - Clear bmask from eligible fcf record index
+ * lpfc_sli4_fcf_rr_index_clear - Clear bmask from eligible fcf record index
  * @phba: pointer to lpfc hba data structure.
  *
  * This routine clears the FCF record index from the eligible bmask for
@@ -12472,6 +12509,10 @@ lpfc_sli4_fcf_rr_index_clear(struct lpfc
 	}
 	/* Clear the eligible FCF record index bmask */
 	clear_bit(fcf_index, phba->fcf.fcf_rr_bmask);
+
+	lpfc_printf_log(phba, KERN_INFO, LOG_FIP,
+			"2791 Clear FCF index x%x from round robin failover "
+			"bmask\n", fcf_index);
 }
 
 /**
@@ -12534,7 +12575,7 @@ lpfc_mbx_cmpl_redisc_fcf_table(struct lp
 }
 
 /**
- * lpfc_sli4_redisc_all_fcf - Request to rediscover entire FCF table by port.
+ * lpfc_sli4_redisc_fcf_table - Request to rediscover entire FCF table by port.
  * @phba: pointer to lpfc hba data structure.
  *
  * This routine is invoked to request for rediscovery of the entire FCF table


