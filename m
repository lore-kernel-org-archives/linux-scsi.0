From: James Smart <james.smart@emulex.com>
Subject: [PATCH 2/4] lpfc 8.3.14: FCoE Discovery Fixes
Date: Tue, 8 Jun 2010 18:31:37 -0400
Message-ID: <1276036332.3169.2.camel@wookie>
Reply-To: james.smart@emulex.com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from exht1.emulex.com ([138.239.113.183]:14393 "EHLO
	exht1.ad.emulex.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752365Ab0FHWc4 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 8 Jun 2010 18:32:56 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


- Prevent unregistring of unused FCF when FLOGI is pending.
- Prevent point to point discovery on a FCoE HBA.
- Fixed FCF discovery failure after swapping FCoE port by
  switching over to fast failover method when no FCF matches in-use FCF.

 Signed-off-by: Alex Iannicelli <alex.iannicelli@emulex.com>
 Signed-off-by: James Smart <james.smart@emulex.com>

 ---

 lpfc_els.c     |   38 +++++++++++++-
 lpfc_hbadisc.c |  151 ++++++++++++++++++++++++++++++++++++++++++++++++++-------
 lpfc_sli.c     |    3 -
 lpfc_sli4.h    |    3 +
 4 files changed, 175 insertions(+), 20 deletions(-)


diff -upNr a/drivers/scsi/lpfc/lpfc_els.c b/drivers/scsi/lpfc/lpfc_els.c
--- a/drivers/scsi/lpfc/lpfc_els.c	2010-06-07 19:15:18.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_els.c	2010-06-08 12:01:54.000000000 -0400
@@ -796,7 +796,9 @@ lpfc_cmpl_els_flogi(struct lpfc_hba *phb
 		 * due to new FCF discovery
 		 */
 		if ((phba->hba_flag & HBA_FIP_SUPPORT) &&
-		    (phba->fcf.fcf_flag & FCF_DISCOVERY)) {
+		    (phba->fcf.fcf_flag & FCF_DISCOVERY) &&
+		    (irsp->ulpStatus != IOSTAT_LOCAL_REJECT) &&
+		    (irsp->un.ulpWord[4] != IOERR_SLI_ABORTED)) {
 			lpfc_printf_log(phba, KERN_WARNING, LOG_FIP | LOG_ELS,
 					"2611 FLOGI failed on registered "
 					"FCF record fcf_index:%d, trying "
@@ -890,9 +892,39 @@ lpfc_cmpl_els_flogi(struct lpfc_hba *phb
 		 */
 		if (sp->cmn.fPort)
 			rc = lpfc_cmpl_els_flogi_fabric(vport, ndlp, sp, irsp);
-		else
+		else if (!(phba->hba_flag & HBA_FCOE_SUPPORT))
 			rc = lpfc_cmpl_els_flogi_nport(vport, ndlp, sp);
-
+		else {
+			lpfc_printf_vlog(vport, KERN_ERR,
+				LOG_FIP | LOG_ELS,
+				"2831 FLOGI response with cleared Fabric "
+				"bit fcf_index 0x%x "
+				"Switch Name %02x%02x%02x%02x%02x%02x%02x%02x "
+				"Fabric Name "
+				"%02x%02x%02x%02x%02x%02x%02x%02x\n",
+				phba->fcf.current_rec.fcf_indx,
+				phba->fcf.current_rec.switch_name[0],
+				phba->fcf.current_rec.switch_name[1],
+				phba->fcf.current_rec.switch_name[2],
+				phba->fcf.current_rec.switch_name[3],
+				phba->fcf.current_rec.switch_name[4],
+				phba->fcf.current_rec.switch_name[5],
+				phba->fcf.current_rec.switch_name[6],
+				phba->fcf.current_rec.switch_name[7],
+				phba->fcf.current_rec.fabric_name[0],
+				phba->fcf.current_rec.fabric_name[1],
+				phba->fcf.current_rec.fabric_name[2],
+				phba->fcf.current_rec.fabric_name[3],
+				phba->fcf.current_rec.fabric_name[4],
+				phba->fcf.current_rec.fabric_name[5],
+				phba->fcf.current_rec.fabric_name[6],
+				phba->fcf.current_rec.fabric_name[7]);
+			lpfc_nlp_put(ndlp);
+			spin_lock_irq(&phba->hbalock);
+			phba->fcf.fcf_flag &= ~FCF_DISCOVERY;
+			spin_unlock_irq(&phba->hbalock);
+			goto out;
+		}
 		if (!rc) {
 			/* Mark the FCF discovery process done */
 			if (phba->hba_flag & HBA_FIP_SUPPORT)
diff -upNr a/drivers/scsi/lpfc/lpfc_hbadisc.c b/drivers/scsi/lpfc/lpfc_hbadisc.c
--- a/drivers/scsi/lpfc/lpfc_hbadisc.c	2010-06-07 19:15:18.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_hbadisc.c	2010-06-08 12:01:54.000000000 -0400
@@ -1300,7 +1300,7 @@ lpfc_register_fcf(struct lpfc_hba *phba)
  * used for this FCF when the function returns.
  * If the FCF record need to be used with a particular vlan id, the vlan is
  * set in the vlan_id on return of the function. If not VLAN tagging need to
- * be used with the FCF vlan_id will be set to 0xFFFF;
+ * be used with the FCF vlan_id will be set to LPFC_FCOE_NULL_VID;
  **/
 static int
 lpfc_match_fcf_conn_list(struct lpfc_hba *phba,
@@ -1336,7 +1336,7 @@ lpfc_match_fcf_conn_list(struct lpfc_hba
 		if (phba->valid_vlan)
 			*vlan_id = phba->vlan_id;
 		else
-			*vlan_id = 0xFFFF;
+			*vlan_id = LPFC_FCOE_NULL_VID;
 		return 1;
 	}
 
@@ -1360,7 +1360,7 @@ lpfc_match_fcf_conn_list(struct lpfc_hba
 		if (fcf_vlan_id)
 			*vlan_id = fcf_vlan_id;
 		else
-			*vlan_id = 0xFFFF;
+			*vlan_id = LPFC_FCOE_NULL_VID;
 		return 1;
 	}
 
@@ -1469,7 +1469,7 @@ lpfc_match_fcf_conn_list(struct lpfc_hba
 		else if (fcf_vlan_id)
 			*vlan_id = fcf_vlan_id;
 		else
-			*vlan_id = 0xFFFF;
+			*vlan_id = LPFC_FCOE_NULL_VID;
 
 		return 1;
 	}
@@ -1521,6 +1521,9 @@ lpfc_check_pending_fcoe_event(struct lpf
 		 * Do not continue FCF discovery and clear FCF_DISC_INPROGRESS
 		 * flag
 		 */
+		lpfc_printf_log(phba, KERN_INFO, LOG_FIP | LOG_DISCOVERY,
+				"2833 Stop FCF discovery process due to link "
+				"state change (x%x)\n", phba->link_state);
 		spin_lock_irq(&phba->hbalock);
 		phba->hba_flag &= ~FCF_DISC_INPROGRESS;
 		phba->fcf.fcf_flag &= ~(FCF_REDISC_FOV | FCF_DISCOVERY);
@@ -1696,6 +1699,37 @@ lpfc_sli4_log_fcf_record_info(struct lpf
 }
 
 /**
+ lpfc_sli4_fcf_record_match - testing new FCF record for matching existing FCF
+ * @phba: pointer to lpfc hba data structure.
+ * @fcf_rec: pointer to an existing FCF record.
+ * @new_fcf_record: pointer to a new FCF record.
+ * @new_vlan_id: vlan id from the new FCF record.
+ *
+ * This function performs matching test of a new FCF record against an existing
+ * FCF record. If the new_vlan_id passed in is LPFC_FCOE_IGNORE_VID, vlan id
+ * will not be used as part of the FCF record matching criteria.
+ *
+ * Returns true if all the fields matching, otherwise returns false.
+ */
+static bool
+lpfc_sli4_fcf_record_match(struct lpfc_hba *phba,
+			   struct lpfc_fcf_rec *fcf_rec,
+			   struct fcf_record *new_fcf_record,
+			   uint16_t new_vlan_id)
+{
+	if (new_vlan_id != LPFC_FCOE_IGNORE_VID)
+		if (!lpfc_vlan_id_match(fcf_rec->vlan_id, new_vlan_id))
+			return false;
+	if (!lpfc_mac_addr_match(fcf_rec->mac_addr, new_fcf_record))
+		return false;
+	if (!lpfc_sw_name_match(fcf_rec->switch_name, new_fcf_record))
+		return false;
+	if (!lpfc_fab_name_match(fcf_rec->fabric_name, new_fcf_record))
+		return false;
+	return true;
+}
+
+/**
  * lpfc_mbx_cmpl_fcf_scan_read_fcf_rec - fcf scan read_fcf mbox cmpl handler.
  * @phba: pointer to lpfc hba data structure.
  * @mboxq: pointer to mailbox object.
@@ -1758,7 +1792,7 @@ lpfc_mbx_cmpl_fcf_scan_read_fcf_rec(stru
 	 */
 	if (!rc) {
 		lpfc_printf_log(phba, KERN_WARNING, LOG_FIP,
-				"2781 FCF record fcf_index:x%x failed FCF "
+				"2781 FCF record (x%x) failed FCF "
 				"connection list check, fcf_avail:x%x, "
 				"fcf_valid:x%x\n",
 				bf_get(lpfc_fcf_record_fcf_index,
@@ -1767,6 +1801,32 @@ lpfc_mbx_cmpl_fcf_scan_read_fcf_rec(stru
 				       new_fcf_record),
 				bf_get(lpfc_fcf_record_fcf_valid,
 				       new_fcf_record));
+		if ((phba->fcf.fcf_flag & FCF_IN_USE) &&
+		    lpfc_sli4_fcf_record_match(phba, &phba->fcf.current_rec,
+		    new_fcf_record, LPFC_FCOE_IGNORE_VID)) {
+			/*
+			 * In case the current in-use FCF record becomes
+			 * invalid/unavailable during FCF discovery that
+			 * was not triggered by fast FCF failover process,
+			 * treat it as fast FCF failover.
+			 */
+			if (!(phba->fcf.fcf_flag & FCF_REDISC_PEND) &&
+			    !(phba->fcf.fcf_flag & FCF_REDISC_FOV)) {
+				lpfc_printf_log(phba, KERN_WARNING, LOG_FIP,
+						"2835 Invalid in-use FCF "
+						"record (x%x) reported, "
+						"entering fast FCF failover "
+						"mode scanning.\n",
+						phba->fcf.current_rec.fcf_indx);
+				spin_lock_irq(&phba->hbalock);
+				phba->fcf.fcf_flag |= FCF_REDISC_FOV;
+				spin_unlock_irq(&phba->hbalock);
+				lpfc_sli4_mbox_cmd_free(phba, mboxq);
+				lpfc_sli4_fcf_scan_read_fcf_rec(phba,
+						LPFC_FCOE_FCF_GET_FIRST);
+				return;
+			}
+		}
 		goto read_next_fcf;
 	} else {
 		fcf_index = bf_get(lpfc_fcf_record_fcf_index, new_fcf_record);
@@ -1783,14 +1843,8 @@ lpfc_mbx_cmpl_fcf_scan_read_fcf_rec(stru
 	 */
 	spin_lock_irq(&phba->hbalock);
 	if (phba->fcf.fcf_flag & FCF_IN_USE) {
-		if (lpfc_fab_name_match(phba->fcf.current_rec.fabric_name,
-					new_fcf_record) &&
-		    lpfc_sw_name_match(phba->fcf.current_rec.switch_name,
-					new_fcf_record) &&
-		    lpfc_mac_addr_match(phba->fcf.current_rec.mac_addr,
-					new_fcf_record) &&
-		    lpfc_vlan_id_match(phba->fcf.current_rec.vlan_id,
-					vlan_id)) {
+		if (lpfc_sli4_fcf_record_match(phba, &phba->fcf.current_rec,
+		    new_fcf_record, vlan_id)) {
 			phba->fcf.fcf_flag |= FCF_AVAILABLE;
 			if (phba->fcf.fcf_flag & FCF_REDISC_PEND)
 				/* Stop FCF redisc wait timer if pending */
@@ -1800,6 +1854,13 @@ lpfc_mbx_cmpl_fcf_scan_read_fcf_rec(stru
 				phba->fcf.fcf_flag &= ~(FCF_REDISC_FOV |
 							FCF_DISCOVERY);
 			spin_unlock_irq(&phba->hbalock);
+			lpfc_printf_log(phba, KERN_INFO, LOG_FIP,
+					"2836 The new FCF record (x%x) "
+					"matches the in-use FCF record "
+					"(x%x)\n",
+					phba->fcf.current_rec.fcf_indx,
+					bf_get(lpfc_fcf_record_fcf_index,
+					       new_fcf_record));
 			goto out;
 		}
 		/*
@@ -1831,6 +1892,12 @@ lpfc_mbx_cmpl_fcf_scan_read_fcf_rec(stru
 		 */
 		if (boot_flag && !(fcf_rec->flag & BOOT_ENABLE)) {
 			/* Choose this FCF record */
+			lpfc_printf_log(phba, KERN_INFO, LOG_FIP,
+					"2837 Update current FCF record "
+					"(x%x) with new FCF record (x%x)\n",
+					fcf_rec->fcf_indx,
+					bf_get(lpfc_fcf_record_fcf_index,
+					new_fcf_record));
 			__lpfc_update_fcf_record(phba, fcf_rec, new_fcf_record,
 					addr_mode, vlan_id, BOOT_ENABLE);
 			spin_unlock_irq(&phba->hbalock);
@@ -1851,6 +1918,12 @@ lpfc_mbx_cmpl_fcf_scan_read_fcf_rec(stru
 		 */
 		if (new_fcf_record->fip_priority < fcf_rec->priority) {
 			/* Choose the new FCF record with lower priority */
+			lpfc_printf_log(phba, KERN_INFO, LOG_FIP,
+					"2838 Update current FCF record "
+					"(x%x) with new FCF record (x%x)\n",
+					fcf_rec->fcf_indx,
+					bf_get(lpfc_fcf_record_fcf_index,
+					       new_fcf_record));
 			__lpfc_update_fcf_record(phba, fcf_rec, new_fcf_record,
 					addr_mode, vlan_id, 0);
 			/* Reset running random FCF selection count */
@@ -1860,11 +1933,18 @@ lpfc_mbx_cmpl_fcf_scan_read_fcf_rec(stru
 			phba->fcf.eligible_fcf_cnt++;
 			select_new_fcf = lpfc_sli4_new_fcf_random_select(phba,
 						phba->fcf.eligible_fcf_cnt);
-			if (select_new_fcf)
+			if (select_new_fcf) {
+				lpfc_printf_log(phba, KERN_INFO, LOG_FIP,
+					"2839 Update current FCF record "
+					"(x%x) with new FCF record (x%x)\n",
+					fcf_rec->fcf_indx,
+					bf_get(lpfc_fcf_record_fcf_index,
+					       new_fcf_record));
 				/* Choose the new FCF by random selection */
 				__lpfc_update_fcf_record(phba, fcf_rec,
 							 new_fcf_record,
 							 addr_mode, vlan_id, 0);
+			}
 		}
 		spin_unlock_irq(&phba->hbalock);
 		goto read_next_fcf;
@@ -1874,6 +1954,11 @@ lpfc_mbx_cmpl_fcf_scan_read_fcf_rec(stru
 	 * initial best-fit FCF.
 	 */
 	if (fcf_rec) {
+		lpfc_printf_log(phba, KERN_INFO, LOG_FIP,
+				"2840 Update current FCF record "
+				"with initial FCF record (x%x)\n",
+				bf_get(lpfc_fcf_record_fcf_index,
+				       new_fcf_record));
 		__lpfc_update_fcf_record(phba, fcf_rec, new_fcf_record,
 					 addr_mode, vlan_id, (boot_flag ?
 					 BOOT_ENABLE : 0));
@@ -1931,6 +2016,12 @@ read_next_fcf:
 			lpfc_unregister_fcf(phba);
 
 			/* Replace in-use record with the new record */
+			lpfc_printf_log(phba, KERN_INFO, LOG_FIP,
+					"2842 Replace the current in-use "
+					"FCF record (x%x) with failover FCF "
+					"record (x%x)\n",
+					phba->fcf.current_rec.fcf_indx,
+					phba->fcf.failover_rec.fcf_indx);
 			memcpy(&phba->fcf.current_rec,
 			       &phba->fcf.failover_rec,
 			       sizeof(struct lpfc_fcf_rec));
@@ -1954,6 +2045,28 @@ read_next_fcf:
 			if ((phba->fcf.fcf_flag & FCF_REDISC_EVT) ||
 			    (phba->fcf.fcf_flag & FCF_REDISC_PEND))
 				return;
+
+			if (phba->fcf.fcf_flag & FCF_IN_USE) {
+				/*
+				 * In case the current in-use FCF record no
+				 * longer existed during FCF discovery that
+				 * was not triggered by fast FCF failover
+				 * process, treat it as fast FCF failover.
+				 */
+				lpfc_printf_log(phba, KERN_INFO, LOG_FIP,
+						"2841 In-use FCF record (x%x) "
+						"not reported, entering fast "
+						"FCF failover mode scanning.\n",
+						phba->fcf.current_rec.fcf_indx);
+				spin_lock_irq(&phba->hbalock);
+				phba->fcf.fcf_flag |= FCF_REDISC_FOV;
+				spin_unlock_irq(&phba->hbalock);
+				lpfc_sli4_mbox_cmd_free(phba, mboxq);
+				lpfc_sli4_fcf_scan_read_fcf_rec(phba,
+						LPFC_FCOE_FCF_GET_FIRST);
+				return;
+			}
+
 			/*
 			 * Otherwise, initial scan or post linkdown rescan,
 			 * register with the best FCF record found so far
@@ -2036,6 +2149,11 @@ lpfc_mbx_cmpl_fcf_rr_read_fcf_rec(struct
 				      next_fcf_index);
 
 	/* Upload new FCF record to the failover FCF record */
+	lpfc_printf_log(phba, KERN_INFO, LOG_FIP,
+			"2834 Update the current FCF record (x%x) "
+			"with the next FCF record (x%x)\n",
+			phba->fcf.failover_rec.fcf_indx,
+			bf_get(lpfc_fcf_record_fcf_index, new_fcf_record));
 	spin_lock_irq(&phba->hbalock);
 	__lpfc_update_fcf_record(phba, &phba->fcf.failover_rec,
 				 new_fcf_record, addr_mode, vlan_id,
@@ -2053,7 +2171,7 @@ lpfc_mbx_cmpl_fcf_rr_read_fcf_rec(struct
 
 	lpfc_printf_log(phba, KERN_INFO, LOG_FIP,
 			"2783 FLOGI round robin FCF failover from FCF "
-			"(index:x%x) to FCF (index:x%x).\n",
+			"(x%x) to FCF (x%x).\n",
 			current_fcf_index,
 			bf_get(lpfc_fcf_record_fcf_index, new_fcf_record));
 
@@ -5217,7 +5335,8 @@ lpfc_unregister_unused_fcf(struct lpfc_h
 	spin_lock_irq(&phba->hbalock);
 	if (!(phba->hba_flag & HBA_FCOE_SUPPORT) ||
 	    !(phba->fcf.fcf_flag & FCF_REGISTERED) ||
-	    !(phba->hba_flag & HBA_FIP_SUPPORT)) {
+	    !(phba->hba_flag & HBA_FIP_SUPPORT) ||
+	    (phba->pport->port_state == LPFC_FLOGI)) {
 		spin_unlock_irq(&phba->hbalock);
 		return;
 	}
diff -upNr a/drivers/scsi/lpfc/lpfc_sli4.h b/drivers/scsi/lpfc/lpfc_sli4.h
--- a/drivers/scsi/lpfc/lpfc_sli4.h	2010-06-08 12:01:16.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_sli4.h	2010-06-08 12:01:54.000000000 -0400
@@ -51,6 +51,9 @@
 #define LPFC_FCOE_FCF_GET_FIRST	0xFFFF
 #define LPFC_FCOE_FCF_NEXT_NONE	0xFFFF
 
+#define LPFC_FCOE_NULL_VID	0xFFF
+#define LPFC_FCOE_IGNORE_VID	0xFFFF
+
 /* First 3 bytes of default FCF MAC is specified by FC_MAP */
 #define LPFC_FCOE_FCF_MAC3	0xFF
 #define LPFC_FCOE_FCF_MAC4	0xFF
diff -upNr a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
--- a/drivers/scsi/lpfc/lpfc_sli.c	2010-06-08 12:01:16.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_sli.c	2010-06-08 12:01:54.000000000 -0400
@@ -12404,7 +12404,8 @@ lpfc_sli4_fcf_rr_next_index_get(struct l
 		next_fcf_index = find_next_bit(phba->fcf.fcf_rr_bmask,
 					       LPFC_SLI4_FCF_TBL_INDX_MAX, 0);
 	/* Round robin failover stop condition */
-	if (next_fcf_index == phba->fcf.fcf_rr_init_indx)
+	if ((next_fcf_index == phba->fcf.fcf_rr_init_indx) ||
+		(next_fcf_index >= LPFC_SLI4_FCF_TBL_INDX_MAX))
 		return LPFC_FCOE_FCF_NEXT_NONE;
 
 	return next_fcf_index;


