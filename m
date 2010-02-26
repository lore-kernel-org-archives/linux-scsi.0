From: James Smart <james.smart@emulex.com>
Subject: [PATCH 5/7] lpfc 8.3.10: Fix Discovery issues
Date: Fri, 26 Feb 2010 14:15:29 -0500
Message-ID: <1267211749.3372.7.camel@wookie>
Reply-To: james.smart@emulex.com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from exht1.emulex.com ([138.239.113.183]:4949 "EHLO
	exht1.ad.emulex.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S965813Ab0BZTQK (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 26 Feb 2010 14:16:10 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


- Prevent Vport discovery after reg_new_vport completes when physical
  logged in using FDISC.
- Remove fast FCF failover fabric name matching. Allow failover to FCFs
  connected to different fabrics.
- Added fast FCF failover in response to FCF DEAD event on current
  FCF record.


 Signed-off-by: James Smart <james.smart@emulex.com>

 ---

 lpfc_crtn.h    |    1 
 lpfc_els.c     |    7 ++
 lpfc_hbadisc.c |   27 +++++-----
 lpfc_init.c    |  140 +++++++++++++++++++++++++++++++++++++++++++++------------
 lpfc_sli.c     |   54 +++++++++++++++++++--
 lpfc_sli4.h    |    8 ++-
 6 files changed, 186 insertions(+), 51 deletions(-)


diff -upNr a/drivers/scsi/lpfc/lpfc_crtn.h b/drivers/scsi/lpfc/lpfc_crtn.h
--- a/drivers/scsi/lpfc/lpfc_crtn.h	2010-02-25 16:33:47.000000000 -0500
+++ b/drivers/scsi/lpfc/lpfc_crtn.h	2010-02-25 16:34:30.000000000 -0500
@@ -221,6 +221,7 @@ void lpfc_unregister_fcf_rescan(struct l
 void lpfc_unregister_unused_fcf(struct lpfc_hba *);
 int lpfc_sli4_redisc_fcf_table(struct lpfc_hba *);
 void lpfc_fcf_redisc_wait_start_timer(struct lpfc_hba *);
+void lpfc_sli4_fcf_dead_failthrough(struct lpfc_hba *);
 
 int lpfc_mem_alloc(struct lpfc_hba *, int align);
 void lpfc_mem_free(struct lpfc_hba *);
diff -upNr a/drivers/scsi/lpfc/lpfc_els.c b/drivers/scsi/lpfc/lpfc_els.c
--- a/drivers/scsi/lpfc/lpfc_els.c	2010-02-25 16:33:47.000000000 -0500
+++ b/drivers/scsi/lpfc/lpfc_els.c	2010-02-25 16:34:30.000000000 -0500
@@ -6004,7 +6004,12 @@ lpfc_cmpl_reg_new_vport(struct lpfc_hba 
 			if (phba->sli_rev < LPFC_SLI_REV4)
 				lpfc_issue_fabric_reglogin(vport);
 			else {
-				lpfc_start_fdiscs(phba);
+				/*
+				 * If the physical port is instantiated using
+				 * FDISC, do not start vport discovery.
+				 */
+				if (vport->port_state != LPFC_FDISC)
+					lpfc_start_fdiscs(phba);
 				lpfc_do_scr_ns_plogi(phba, vport);
 			}
 		} else
diff -upNr a/drivers/scsi/lpfc/lpfc_hbadisc.c b/drivers/scsi/lpfc/lpfc_hbadisc.c
--- a/drivers/scsi/lpfc/lpfc_hbadisc.c	2010-02-25 16:33:09.000000000 -0500
+++ b/drivers/scsi/lpfc/lpfc_hbadisc.c	2010-02-25 16:34:30.000000000 -0500
@@ -1504,7 +1504,9 @@ lpfc_check_pending_fcoe_event(struct lpf
 		 */
 		spin_lock_irq(&phba->hbalock);
 		phba->hba_flag &= ~FCF_DISC_INPROGRESS;
-		phba->fcf.fcf_flag &= ~FCF_REDISC_FOV;
+		phba->fcf.fcf_flag &= ~(FCF_REDISC_FOV |
+					FCF_DEAD_FOVER |
+					FCF_CVL_FOVER);
 		spin_unlock_irq(&phba->hbalock);
 	}
 
@@ -1649,7 +1651,9 @@ lpfc_mbx_cmpl_read_fcf_record(struct lpf
 				__lpfc_sli4_stop_fcf_redisc_wait_timer(phba);
 			else if (phba->fcf.fcf_flag & FCF_REDISC_FOV)
 				/* If in fast failover, mark it's completed */
-				phba->fcf.fcf_flag &= ~FCF_REDISC_FOV;
+				phba->fcf.fcf_flag &= ~(FCF_REDISC_FOV |
+							FCF_DEAD_FOVER |
+							FCF_CVL_FOVER);
 			spin_unlock_irqrestore(&phba->hbalock, iflags);
 			goto out;
 		}
@@ -1669,14 +1673,9 @@ lpfc_mbx_cmpl_read_fcf_record(struct lpf
 	 * Update on failover FCF record only if it's in FCF fast-failover
 	 * period; otherwise, update on current FCF record.
 	 */
-	if (phba->fcf.fcf_flag & FCF_REDISC_FOV) {
-		/* Fast FCF failover only to the same fabric name */
-		if (lpfc_fab_name_match(phba->fcf.current_rec.fabric_name,
-					new_fcf_record))
-			fcf_rec = &phba->fcf.failover_rec;
-		else
-			goto read_next_fcf;
-	} else
+	if (phba->fcf.fcf_flag & FCF_REDISC_FOV)
+		fcf_rec = &phba->fcf.failover_rec;
+	else
 		fcf_rec = &phba->fcf.current_rec;
 
 	if (phba->fcf.fcf_flag & FCF_AVAILABLE) {
@@ -1705,8 +1704,7 @@ lpfc_mbx_cmpl_read_fcf_record(struct lpf
 		 * If the new hba FCF record has lower priority value
 		 * than the driver FCF record, use the new record.
 		 */
-		if (lpfc_fab_name_match(fcf_rec->fabric_name, new_fcf_record) &&
-		    (new_fcf_record->fip_priority < fcf_rec->priority)) {
+		if (new_fcf_record->fip_priority < fcf_rec->priority) {
 			/* Choose this FCF record */
 			__lpfc_update_fcf_record(phba, fcf_rec, new_fcf_record,
 					addr_mode, vlan_id, 0);
@@ -1762,7 +1760,9 @@ read_next_fcf:
 			       sizeof(struct lpfc_fcf_rec));
 			/* mark the FCF fast failover completed */
 			spin_lock_irqsave(&phba->hbalock, iflags);
-			phba->fcf.fcf_flag &= ~FCF_REDISC_FOV;
+			phba->fcf.fcf_flag &= ~(FCF_REDISC_FOV |
+						FCF_DEAD_FOVER |
+						FCF_CVL_FOVER);
 			spin_unlock_irqrestore(&phba->hbalock, iflags);
 			/* Register to the new FCF record */
 			lpfc_register_fcf(phba);
@@ -4760,6 +4760,7 @@ lpfc_unregister_fcf_rescan(struct lpfc_h
 		return;
 	/* Reset HBA FCF states after successful unregister FCF */
 	phba->fcf.fcf_flag = 0;
+	phba->fcf.current_rec.flag = 0;
 
 	/*
 	 * If driver is not unloading, check if there is any other
diff -upNr a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
--- a/drivers/scsi/lpfc/lpfc_init.c	2010-02-25 16:34:10.000000000 -0500
+++ b/drivers/scsi/lpfc/lpfc_init.c	2010-02-25 16:34:30.000000000 -0500
@@ -2199,8 +2199,10 @@ lpfc_stop_vport_timers(struct lpfc_vport
 void
 __lpfc_sli4_stop_fcf_redisc_wait_timer(struct lpfc_hba *phba)
 {
-	/* Clear pending FCF rediscovery wait timer */
-	phba->fcf.fcf_flag &= ~FCF_REDISC_PEND;
+	/* Clear pending FCF rediscovery wait and failover in progress flags */
+	phba->fcf.fcf_flag &= ~(FCF_REDISC_PEND |
+				FCF_DEAD_FOVER  |
+				FCF_CVL_FOVER);
 	/* Now, try to stop the timer */
 	del_timer(&phba->fcf.redisc_wait);
 }
@@ -3212,6 +3214,68 @@ out_free_pmb:
 }
 
 /**
+ * lpfc_sli4_perform_vport_cvl - Perform clear virtual link on a vport
+ * @vport: pointer to vport data structure.
+ *
+ * This routine is to perform Clear Virtual Link (CVL) on a vport in
+ * response to a CVL event.
+ *
+ * Return the pointer to the ndlp with the vport if successful, otherwise
+ * return NULL.
+ **/
+static struct lpfc_nodelist *
+lpfc_sli4_perform_vport_cvl(struct lpfc_vport *vport)
+{
+	struct lpfc_nodelist *ndlp;
+	struct Scsi_Host *shost;
+	struct lpfc_hba *phba;
+
+	if (!vport)
+		return NULL;
+	ndlp = lpfc_findnode_did(vport, Fabric_DID);
+	if (!ndlp)
+		return NULL;
+	phba = vport->phba;
+	if (!phba)
+		return NULL;
+	if (phba->pport->port_state <= LPFC_FLOGI)
+		return NULL;
+	/* If virtual link is not yet instantiated ignore CVL */
+	if (vport->port_state <= LPFC_FDISC)
+		return NULL;
+	shost = lpfc_shost_from_vport(vport);
+	if (!shost)
+		return NULL;
+	lpfc_linkdown_port(vport);
+	lpfc_cleanup_pending_mbox(vport);
+	spin_lock_irq(shost->host_lock);
+	vport->fc_flag |= FC_VPORT_CVL_RCVD;
+	spin_unlock_irq(shost->host_lock);
+
+	return ndlp;
+}
+
+/**
+ * lpfc_sli4_perform_all_vport_cvl - Perform clear virtual link on all vports
+ * @vport: pointer to lpfc hba data structure.
+ *
+ * This routine is to perform Clear Virtual Link (CVL) on all vports in
+ * response to a FCF dead event.
+ **/
+static void
+lpfc_sli4_perform_all_vport_cvl(struct lpfc_hba *phba)
+{
+	struct lpfc_vport **vports;
+	int i;
+
+	vports = lpfc_create_vport_work_array(phba);
+	if (vports)
+		for (i = 0; i <= phba->max_vports && vports[i] != NULL; i++)
+			lpfc_sli4_perform_vport_cvl(vports[i]);
+	lpfc_destroy_vport_work_array(phba, vports);
+}
+
+/**
  * lpfc_sli4_async_fcoe_evt - Process the asynchronous fcoe event
  * @phba: pointer to lpfc hba data structure.
  * @acqe_link: pointer to the async fcoe completion queue entry.
@@ -3227,7 +3291,6 @@ lpfc_sli4_async_fcoe_evt(struct lpfc_hba
 	struct lpfc_vport *vport;
 	struct lpfc_nodelist *ndlp;
 	struct Scsi_Host  *shost;
-	uint32_t link_state;
 	int active_vlink_present;
 	struct lpfc_vport **vports;
 	int i;
@@ -3284,16 +3347,35 @@ lpfc_sli4_async_fcoe_evt(struct lpfc_hba
 		/* If the event is not for currently used fcf do nothing */
 		if (phba->fcf.current_rec.fcf_indx != acqe_fcoe->index)
 			break;
-		/*
-		 * Currently, driver support only one FCF - so treat this as
-		 * a link down, but save the link state because we don't want
-		 * it to be changed to Link Down unless it is already down.
+		/* We request port to rediscover the entire FCF table for
+		 * a fast recovery from case that the current FCF record
+		 * is no longer valid if the last CVL event hasn't already
+		 * triggered process.
 		 */
-		link_state = phba->link_state;
-		lpfc_linkdown(phba);
-		phba->link_state = link_state;
-		/* Unregister FCF if no devices connected to it */
-		lpfc_unregister_unused_fcf(phba);
+		spin_lock_irq(&phba->hbalock);
+		if (phba->fcf.fcf_flag & FCF_CVL_FOVER) {
+			spin_unlock_irq(&phba->hbalock);
+			break;
+		}
+		/* Mark the fast failover process in progress */
+		phba->fcf.fcf_flag |= FCF_DEAD_FOVER;
+		spin_unlock_irq(&phba->hbalock);
+		rc = lpfc_sli4_redisc_fcf_table(phba);
+		if (rc) {
+			spin_lock_irq(&phba->hbalock);
+			phba->fcf.fcf_flag &= ~FCF_DEAD_FOVER;
+			spin_unlock_irq(&phba->hbalock);
+			/*
+			 * Last resort will fail over by treating this
+			 * as a link down to FCF registration.
+			 */
+			lpfc_sli4_fcf_dead_failthrough(phba);
+		} else
+			/* Handling fast FCF failover to a DEAD FCF event
+			 * is considered equalivant to receiving CVL to all
+			 * vports.
+			 */
+			lpfc_sli4_perform_all_vport_cvl(phba);
 		break;
 	case LPFC_FCOE_EVENT_TYPE_CVL:
 		lpfc_printf_log(phba, KERN_ERR, LOG_DISCOVERY,
@@ -3301,23 +3383,9 @@ lpfc_sli4_async_fcoe_evt(struct lpfc_hba
 			" tag 0x%x\n", acqe_fcoe->index, acqe_fcoe->event_tag);
 		vport = lpfc_find_vport_by_vpid(phba,
 				acqe_fcoe->index - phba->vpi_base);
-		if (!vport)
-			break;
-		ndlp = lpfc_findnode_did(vport, Fabric_DID);
+		ndlp = lpfc_sli4_perform_vport_cvl(vport);
 		if (!ndlp)
 			break;
-		shost = lpfc_shost_from_vport(vport);
-		if (phba->pport->port_state <= LPFC_FLOGI)
-			break;
-		/* If virtual link is not yet instantiated ignore CVL */
-		if (vport->port_state <= LPFC_FDISC)
-			break;
-
-		lpfc_linkdown_port(vport);
-		lpfc_cleanup_pending_mbox(vport);
-		spin_lock_irq(shost->host_lock);
-		vport->fc_flag |= FC_VPORT_CVL_RCVD;
-		spin_unlock_irq(shost->host_lock);
 		active_vlink_present = 0;
 
 		vports = lpfc_create_vport_work_array(phba);
@@ -3340,6 +3408,7 @@ lpfc_sli4_async_fcoe_evt(struct lpfc_hba
 			 * re-instantiate the Vlink using FDISC.
 			 */
 			mod_timer(&ndlp->nlp_delayfunc, jiffies + HZ);
+			shost = lpfc_shost_from_vport(vport);
 			spin_lock_irq(shost->host_lock);
 			ndlp->nlp_flag |= NLP_DELAY_TMO;
 			spin_unlock_irq(shost->host_lock);
@@ -3350,15 +3419,28 @@ lpfc_sli4_async_fcoe_evt(struct lpfc_hba
 			 * Otherwise, we request port to rediscover
 			 * the entire FCF table for a fast recovery
 			 * from possible case that the current FCF
-			 * is no longer valid.
+			 * is no longer valid if the FCF_DEAD event
+			 * hasn't already triggered process.
 			 */
+			spin_lock_irq(&phba->hbalock);
+			if (phba->fcf.fcf_flag & FCF_DEAD_FOVER) {
+				spin_unlock_irq(&phba->hbalock);
+				break;
+			}
+			/* Mark the fast failover process in progress */
+			phba->fcf.fcf_flag |= FCF_CVL_FOVER;
+			spin_unlock_irq(&phba->hbalock);
 			rc = lpfc_sli4_redisc_fcf_table(phba);
-			if (rc)
+			if (rc) {
+				spin_lock_irq(&phba->hbalock);
+				phba->fcf.fcf_flag &= ~FCF_CVL_FOVER;
+				spin_unlock_irq(&phba->hbalock);
 				/*
 				 * Last resort will be re-try on the
 				 * the current registered FCF entry.
 				 */
 				lpfc_retry_pport_discovery(phba);
+			}
 		}
 		break;
 	default:
diff -upNr a/drivers/scsi/lpfc/lpfc_sli4.h b/drivers/scsi/lpfc/lpfc_sli4.h
--- a/drivers/scsi/lpfc/lpfc_sli4.h	2010-02-25 16:33:47.000000000 -0500
+++ b/drivers/scsi/lpfc/lpfc_sli4.h	2010-02-25 16:34:30.000000000 -0500
@@ -153,9 +153,11 @@ struct lpfc_fcf {
 #define FCF_REGISTERED	0x02 /* FCF registered with FW */
 #define FCF_SCAN_DONE	0x04 /* FCF table scan done */
 #define FCF_IN_USE	0x08 /* Atleast one discovery completed */
-#define FCF_REDISC_PEND	0x10 /* FCF rediscovery pending */
-#define FCF_REDISC_EVT	0x20 /* FCF rediscovery event to worker thread */
-#define FCF_REDISC_FOV	0x40 /* Post FCF rediscovery fast failover */
+#define FCF_DEAD_FOVER  0x10 /* FCF DEAD triggered fast FCF failover */
+#define FCF_CVL_FOVER	0x20 /* CVL triggered fast FCF failover */
+#define FCF_REDISC_PEND	0x40 /* FCF rediscovery pending */
+#define FCF_REDISC_EVT	0x80 /* FCF rediscovery event to worker thread */
+#define FCF_REDISC_FOV	0x100 /* Post FCF rediscovery fast failover */
 	uint32_t addr_mode;
 	struct lpfc_fcf_rec current_rec;
 	struct lpfc_fcf_rec failover_rec;
diff -upNr a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
--- a/drivers/scsi/lpfc/lpfc_sli.c	2010-02-25 16:33:47.000000000 -0500
+++ b/drivers/scsi/lpfc/lpfc_sli.c	2010-02-25 16:34:30.000000000 -0500
@@ -4519,6 +4519,10 @@ lpfc_sli4_hba_setup(struct lpfc_hba *phb
 	/* Post receive buffers to the device */
 	lpfc_sli4_rb_setup(phba);
 
+	/* Reset HBA FCF states after HBA reset */
+	phba->fcf.fcf_flag = 0;
+	phba->fcf.current_rec.flag = 0;
+
 	/* Start the ELS watchdog timer */
 	mod_timer(&vport->els_tmofunc,
 		  jiffies + HZ * (phba->fc_ratov * 2));
@@ -12069,11 +12073,26 @@ lpfc_mbx_cmpl_redisc_fcf_table(struct lp
 				"2746 Requesting for FCF rediscovery failed "
 				"status x%x add_status x%x\n",
 				shdr_status, shdr_add_status);
-		/*
-		 * Request failed, last resort to re-try current
-		 * registered FCF entry
-		 */
-		lpfc_retry_pport_discovery(phba);
+		if (phba->fcf.fcf_flag & FCF_CVL_FOVER) {
+			spin_lock_irq(&phba->hbalock);
+			phba->fcf.fcf_flag &= ~FCF_CVL_FOVER;
+			spin_unlock_irq(&phba->hbalock);
+			/*
+			 * CVL event triggered FCF rediscover request failed,
+			 * last resort to re-try current registered FCF entry.
+			 */
+			lpfc_retry_pport_discovery(phba);
+		} else {
+			spin_lock_irq(&phba->hbalock);
+			phba->fcf.fcf_flag &= ~FCF_DEAD_FOVER;
+			spin_unlock_irq(&phba->hbalock);
+			/*
+			 * DEAD FCF event triggered FCF rediscover request
+			 * failed, last resort to fail over as a link down
+			 * to FCF registration.
+			 */
+			lpfc_sli4_fcf_dead_failthrough(phba);
+		}
 	} else
 		/*
 		 * Start FCF rediscovery wait timer for pending FCF
@@ -12129,6 +12148,31 @@ lpfc_sli4_redisc_fcf_table(struct lpfc_h
 }
 
 /**
+ * lpfc_sli4_fcf_dead_failthrough - Failthrough routine to fcf dead event
+ * @phba: pointer to lpfc hba data structure.
+ *
+ * This function is the failover routine as a last resort to the FCF DEAD
+ * event when driver failed to perform fast FCF failover.
+ **/
+void
+lpfc_sli4_fcf_dead_failthrough(struct lpfc_hba *phba)
+{
+	uint32_t link_state;
+
+	/*
+	 * Last resort as FCF DEAD event failover will treat this as
+	 * a link down, but save the link state because we don't want
+	 * it to be changed to Link Down unless it is already down.
+	 */
+	link_state = phba->link_state;
+	lpfc_linkdown(phba);
+	phba->link_state = link_state;
+
+	/* Unregister FCF if no devices connected to it */
+	lpfc_unregister_unused_fcf(phba);
+}
+
+/**
  * lpfc_sli_read_link_ste - Read region 23 to decide if link is disabled.
  * @phba: pointer to lpfc hba data structure.
  *


