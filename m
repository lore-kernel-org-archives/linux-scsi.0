From: James Smart <james.smart@emulex.com>
Subject: [PATCH 2/6] lpfc 8.3.9: Discovery changes to the lpfc driver.
Date: Fri, 12 Feb 2010 14:41:27 -0500
Message-ID: <1266003707.2939.15.camel@wookie>
Reply-To: james.smart@emulex.com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from exht1.emulex.com ([138.239.113.183]:49966 "EHLO
	exht1.ad.emulex.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756948Ab0BLTmM (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 12 Feb 2010 14:42:12 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


- Add init_vpi mailbox command before re-registering VPI.
- Add Fast FCF failover support.


 Signed-off-by: James Smart <james.smart@emulex.com>

 ---

 lpfc_crtn.h    |    8 
 lpfc_els.c     |   16 +
 lpfc_hbadisc.c |  672 +++++++++++++++++++++++++++++++++++++--------------------
 lpfc_hw4.h     |   16 +
 lpfc_init.c    |  164 +++++++++++++
 lpfc_mbox.c    |   70 +++++
 lpfc_sli.c     |  128 +++++++---
 lpfc_sli4.h    |   36 ++-
 8 files changed, 821 insertions(+), 289 deletions(-)


diff -upNr a/drivers/scsi/lpfc/lpfc_crtn.h b/drivers/scsi/lpfc/lpfc_crtn.h
--- a/drivers/scsi/lpfc/lpfc_crtn.h	2010-02-11 17:26:54.000000000 -0500
+++ b/drivers/scsi/lpfc/lpfc_crtn.h	2010-02-12 10:52:43.000000000 -0500
@@ -78,6 +78,7 @@ void lpfc_set_disctmo(struct lpfc_vport 
 int  lpfc_can_disctmo(struct lpfc_vport *);
 int  lpfc_unreg_rpi(struct lpfc_vport *, struct lpfc_nodelist *);
 void lpfc_unreg_all_rpis(struct lpfc_vport *);
+void lpfc_unreg_hba_rpis(struct lpfc_hba *);
 void lpfc_unreg_default_rpis(struct lpfc_vport *);
 void lpfc_issue_reg_vpi(struct lpfc_hba *, struct lpfc_vport *);
 
@@ -202,6 +203,7 @@ void lpfc_reg_fcfi(struct lpfc_hba *, st
 void lpfc_unreg_fcfi(struct lpfcMboxq *, uint16_t);
 void lpfc_resume_rpi(struct lpfcMboxq *, struct lpfc_nodelist *);
 int lpfc_check_pending_fcoe_event(struct lpfc_hba *, uint8_t);
+void lpfc_issue_init_vpi(struct lpfc_vport *);
 
 void lpfc_config_hbq(struct lpfc_hba *, uint32_t, struct lpfc_hbq_init *,
 	uint32_t , LPFC_MBOXQ_t *);
@@ -211,7 +213,11 @@ struct hbq_dmabuf *lpfc_sli4_rb_alloc(st
 void lpfc_sli4_rb_free(struct lpfc_hba *, struct hbq_dmabuf *);
 void lpfc_sli4_build_dflt_fcf_record(struct lpfc_hba *, struct fcf_record *,
 			uint16_t);
+void lpfc_unregister_fcf(struct lpfc_hba *);
+void lpfc_unregister_fcf_rescan(struct lpfc_hba *);
 void lpfc_unregister_unused_fcf(struct lpfc_hba *);
+int lpfc_sli4_redisc_fcf_table(struct lpfc_hba *);
+void lpfc_fcf_redisc_wait_start_timer(struct lpfc_hba *);
 
 int lpfc_mem_alloc(struct lpfc_hba *, int align);
 void lpfc_mem_free(struct lpfc_hba *);
@@ -370,6 +376,8 @@ void lpfc_free_fast_evt(struct lpfc_hba 
 void lpfc_create_static_vport(struct lpfc_hba *);
 void lpfc_stop_hba_timers(struct lpfc_hba *);
 void lpfc_stop_port(struct lpfc_hba *);
+void __lpfc_sli4_stop_fcf_redisc_wait_timer(struct lpfc_hba *);
+void lpfc_sli4_stop_fcf_redisc_wait_timer(struct lpfc_hba *);
 void lpfc_parse_fcoe_conf(struct lpfc_hba *, uint8_t *, uint32_t);
 int lpfc_parse_vpd(struct lpfc_hba *, uint8_t *, int);
 void lpfc_start_fdiscs(struct lpfc_hba *phba);
diff -upNr a/drivers/scsi/lpfc/lpfc_els.c b/drivers/scsi/lpfc/lpfc_els.c
--- a/drivers/scsi/lpfc/lpfc_els.c	2010-02-11 17:26:54.000000000 -0500
+++ b/drivers/scsi/lpfc/lpfc_els.c	2010-02-12 10:52:43.000000000 -0500
@@ -589,6 +589,15 @@ lpfc_cmpl_els_flogi_fabric(struct lpfc_v
 			vport->fc_flag |= FC_VPORT_NEEDS_REG_VPI;
 			spin_unlock_irq(shost->host_lock);
 		}
+		/*
+		 * If VPI is unreged, driver need to do INIT_VPI
+		 * before re-registering
+		 */
+		if (phba->sli_rev == LPFC_SLI_REV4) {
+			spin_lock_irq(shost->host_lock);
+			vport->fc_flag |= FC_VPORT_NEEDS_INIT_VPI;
+			spin_unlock_irq(shost->host_lock);
+		}
 	}
 
 	if (phba->sli_rev < LPFC_SLI_REV4) {
@@ -606,7 +615,7 @@ lpfc_cmpl_els_flogi_fabric(struct lpfc_v
 			lpfc_start_fdiscs(phba);
 			lpfc_do_scr_ns_plogi(phba, vport);
 		} else if (vport->fc_flag & FC_VFI_REGISTERED)
-			lpfc_register_new_vport(phba, vport, ndlp);
+			lpfc_issue_init_vpi(vport);
 		else
 			lpfc_issue_reg_vfi(vport);
 	}
@@ -6210,10 +6219,13 @@ lpfc_cmpl_els_fdisc(struct lpfc_hba *phb
 		lpfc_mbx_unreg_vpi(vport);
 		spin_lock_irq(shost->host_lock);
 		vport->fc_flag |= FC_VPORT_NEEDS_REG_VPI;
+		vport->fc_flag |= FC_VPORT_NEEDS_INIT_VPI;
 		spin_unlock_irq(shost->host_lock);
 	}
 
-	if (vport->fc_flag & FC_VPORT_NEEDS_REG_VPI)
+	if (vport->fc_flag & FC_VPORT_NEEDS_INIT_VPI)
+		lpfc_issue_init_vpi(vport);
+	else if (vport->fc_flag & FC_VPORT_NEEDS_REG_VPI)
 		lpfc_register_new_vport(phba, vport, ndlp);
 	else
 		lpfc_do_scr_ns_plogi(phba, vport);
diff -upNr a/drivers/scsi/lpfc/lpfc_hbadisc.c b/drivers/scsi/lpfc/lpfc_hbadisc.c
--- a/drivers/scsi/lpfc/lpfc_hbadisc.c	2010-02-11 17:26:54.000000000 -0500
+++ b/drivers/scsi/lpfc/lpfc_hbadisc.c	2010-02-12 10:52:43.000000000 -0500
@@ -525,6 +525,8 @@ lpfc_work_done(struct lpfc_hba *phba)
 			spin_unlock_irq(&phba->hbalock);
 			lpfc_sli_hbqbuf_add_hbqs(phba, LPFC_ELS_HBQ);
 		}
+		if (phba->fcf.fcf_flag & FCF_REDISC_EVT)
+			lpfc_sli4_fcf_redisc_event_proc(phba);
 	}
 
 	vports = lpfc_create_vport_work_array(phba);
@@ -754,7 +756,7 @@ lpfc_linkdown(struct lpfc_hba *phba)
 	lpfc_scsi_dev_block(phba);
 
 	spin_lock_irq(&phba->hbalock);
-	phba->fcf.fcf_flag &= ~(FCF_AVAILABLE | FCF_DISCOVERED);
+	phba->fcf.fcf_flag &= ~(FCF_AVAILABLE | FCF_SCAN_DONE);
 	if (phba->link_state > LPFC_LINK_DOWN) {
 		phba->link_state = LPFC_LINK_DOWN;
 		phba->pport->fc_flag &= ~FC_LBIT;
@@ -1025,7 +1027,7 @@ lpfc_mbx_cmpl_reg_fcfi(struct lpfc_hba *
 		return;
 	}
 	spin_lock_irqsave(&phba->hbalock, flags);
-	phba->fcf.fcf_flag |= (FCF_DISCOVERED | FCF_IN_USE);
+	phba->fcf.fcf_flag |= (FCF_SCAN_DONE | FCF_IN_USE);
 	phba->hba_flag &= ~FCF_DISC_INPROGRESS;
 	spin_unlock_irqrestore(&phba->hbalock, flags);
 	if (vport->port_state != LPFC_FLOGI)
@@ -1047,25 +1049,23 @@ lpfc_mbx_cmpl_reg_fcfi(struct lpfc_hba *
 static uint32_t
 lpfc_fab_name_match(uint8_t *fab_name, struct fcf_record *new_fcf_record)
 {
-	if ((fab_name[0] ==
-		bf_get(lpfc_fcf_record_fab_name_0, new_fcf_record)) &&
-	    (fab_name[1] ==
-		bf_get(lpfc_fcf_record_fab_name_1, new_fcf_record)) &&
-	    (fab_name[2] ==
-		bf_get(lpfc_fcf_record_fab_name_2, new_fcf_record)) &&
-	    (fab_name[3] ==
-		bf_get(lpfc_fcf_record_fab_name_3, new_fcf_record)) &&
-	    (fab_name[4] ==
-		bf_get(lpfc_fcf_record_fab_name_4, new_fcf_record)) &&
-	    (fab_name[5] ==
-		bf_get(lpfc_fcf_record_fab_name_5, new_fcf_record)) &&
-	    (fab_name[6] ==
-		bf_get(lpfc_fcf_record_fab_name_6, new_fcf_record)) &&
-	    (fab_name[7] ==
-		bf_get(lpfc_fcf_record_fab_name_7, new_fcf_record)))
-		return 1;
-	else
+	if (fab_name[0] != bf_get(lpfc_fcf_record_fab_name_0, new_fcf_record))
+		return 0;
+	if (fab_name[1] != bf_get(lpfc_fcf_record_fab_name_1, new_fcf_record))
+		return 0;
+	if (fab_name[2] != bf_get(lpfc_fcf_record_fab_name_2, new_fcf_record))
+		return 0;
+	if (fab_name[3] != bf_get(lpfc_fcf_record_fab_name_3, new_fcf_record))
+		return 0;
+	if (fab_name[4] != bf_get(lpfc_fcf_record_fab_name_4, new_fcf_record))
+		return 0;
+	if (fab_name[5] != bf_get(lpfc_fcf_record_fab_name_5, new_fcf_record))
 		return 0;
+	if (fab_name[6] != bf_get(lpfc_fcf_record_fab_name_6, new_fcf_record))
+		return 0;
+	if (fab_name[7] != bf_get(lpfc_fcf_record_fab_name_7, new_fcf_record))
+		return 0;
+	return 1;
 }
 
 /**
@@ -1080,30 +1080,28 @@ lpfc_fab_name_match(uint8_t *fab_name, s
 static uint32_t
 lpfc_sw_name_match(uint8_t *sw_name, struct fcf_record *new_fcf_record)
 {
-	if ((sw_name[0] ==
-		bf_get(lpfc_fcf_record_switch_name_0, new_fcf_record)) &&
-	    (sw_name[1] ==
-		bf_get(lpfc_fcf_record_switch_name_1, new_fcf_record)) &&
-	    (sw_name[2] ==
-		bf_get(lpfc_fcf_record_switch_name_2, new_fcf_record)) &&
-	    (sw_name[3] ==
-		bf_get(lpfc_fcf_record_switch_name_3, new_fcf_record)) &&
-	    (sw_name[4] ==
-		bf_get(lpfc_fcf_record_switch_name_4, new_fcf_record)) &&
-	    (sw_name[5] ==
-		bf_get(lpfc_fcf_record_switch_name_5, new_fcf_record)) &&
-	    (sw_name[6] ==
-		bf_get(lpfc_fcf_record_switch_name_6, new_fcf_record)) &&
-	    (sw_name[7] ==
-		bf_get(lpfc_fcf_record_switch_name_7, new_fcf_record)))
-		return 1;
-	else
+	if (sw_name[0] != bf_get(lpfc_fcf_record_switch_name_0, new_fcf_record))
+		return 0;
+	if (sw_name[1] != bf_get(lpfc_fcf_record_switch_name_1, new_fcf_record))
+		return 0;
+	if (sw_name[2] != bf_get(lpfc_fcf_record_switch_name_2, new_fcf_record))
 		return 0;
+	if (sw_name[3] != bf_get(lpfc_fcf_record_switch_name_3, new_fcf_record))
+		return 0;
+	if (sw_name[4] != bf_get(lpfc_fcf_record_switch_name_4, new_fcf_record))
+		return 0;
+	if (sw_name[5] != bf_get(lpfc_fcf_record_switch_name_5, new_fcf_record))
+		return 0;
+	if (sw_name[6] != bf_get(lpfc_fcf_record_switch_name_6, new_fcf_record))
+		return 0;
+	if (sw_name[7] != bf_get(lpfc_fcf_record_switch_name_7, new_fcf_record))
+		return 0;
+	return 1;
 }
 
 /**
  * lpfc_mac_addr_match - Check if the fcf mac address match.
- * @phba: pointer to lpfc hba data structure.
+ * @mac_addr: pointer to mac address.
  * @new_fcf_record: pointer to fcf record.
  *
  * This routine compare the fcf record's mac address with HBA's
@@ -1111,85 +1109,115 @@ lpfc_sw_name_match(uint8_t *sw_name, str
  * returns 1 else return 0.
  **/
 static uint32_t
-lpfc_mac_addr_match(struct lpfc_hba *phba, struct fcf_record *new_fcf_record)
+lpfc_mac_addr_match(uint8_t *mac_addr, struct fcf_record *new_fcf_record)
 {
-	if ((phba->fcf.mac_addr[0] ==
-		bf_get(lpfc_fcf_record_mac_0, new_fcf_record)) &&
-	    (phba->fcf.mac_addr[1] ==
-		bf_get(lpfc_fcf_record_mac_1, new_fcf_record)) &&
-	    (phba->fcf.mac_addr[2] ==
-		bf_get(lpfc_fcf_record_mac_2, new_fcf_record)) &&
-	    (phba->fcf.mac_addr[3] ==
-		bf_get(lpfc_fcf_record_mac_3, new_fcf_record)) &&
-	    (phba->fcf.mac_addr[4] ==
-		bf_get(lpfc_fcf_record_mac_4, new_fcf_record)) &&
-	    (phba->fcf.mac_addr[5] ==
-		bf_get(lpfc_fcf_record_mac_5, new_fcf_record)))
-		return 1;
-	else
+	if (mac_addr[0] != bf_get(lpfc_fcf_record_mac_0, new_fcf_record))
+		return 0;
+	if (mac_addr[1] != bf_get(lpfc_fcf_record_mac_1, new_fcf_record))
+		return 0;
+	if (mac_addr[2] != bf_get(lpfc_fcf_record_mac_2, new_fcf_record))
+		return 0;
+	if (mac_addr[3] != bf_get(lpfc_fcf_record_mac_3, new_fcf_record))
+		return 0;
+	if (mac_addr[4] != bf_get(lpfc_fcf_record_mac_4, new_fcf_record))
+		return 0;
+	if (mac_addr[5] != bf_get(lpfc_fcf_record_mac_5, new_fcf_record))
 		return 0;
+	return 1;
+}
+
+static bool
+lpfc_vlan_id_match(uint16_t curr_vlan_id, uint16_t new_vlan_id)
+{
+	return (curr_vlan_id == new_vlan_id);
 }
 
 /**
  * lpfc_copy_fcf_record - Copy fcf information to lpfc_hba.
- * @phba: pointer to lpfc hba data structure.
+ * @fcf: pointer to driver fcf record.
  * @new_fcf_record: pointer to fcf record.
  *
  * This routine copies the FCF information from the FCF
  * record to lpfc_hba data structure.
  **/
 static void
-lpfc_copy_fcf_record(struct lpfc_hba *phba, struct fcf_record *new_fcf_record)
+lpfc_copy_fcf_record(struct lpfc_fcf_rec *fcf_rec,
+		     struct fcf_record *new_fcf_record)
 {
-	phba->fcf.fabric_name[0] =
+	/* Fabric name */
+	fcf_rec->fabric_name[0] =
 		bf_get(lpfc_fcf_record_fab_name_0, new_fcf_record);
-	phba->fcf.fabric_name[1] =
+	fcf_rec->fabric_name[1] =
 		bf_get(lpfc_fcf_record_fab_name_1, new_fcf_record);
-	phba->fcf.fabric_name[2] =
+	fcf_rec->fabric_name[2] =
 		bf_get(lpfc_fcf_record_fab_name_2, new_fcf_record);
-	phba->fcf.fabric_name[3] =
+	fcf_rec->fabric_name[3] =
 		bf_get(lpfc_fcf_record_fab_name_3, new_fcf_record);
-	phba->fcf.fabric_name[4] =
+	fcf_rec->fabric_name[4] =
 		bf_get(lpfc_fcf_record_fab_name_4, new_fcf_record);
-	phba->fcf.fabric_name[5] =
+	fcf_rec->fabric_name[5] =
 		bf_get(lpfc_fcf_record_fab_name_5, new_fcf_record);
-	phba->fcf.fabric_name[6] =
+	fcf_rec->fabric_name[6] =
 		bf_get(lpfc_fcf_record_fab_name_6, new_fcf_record);
-	phba->fcf.fabric_name[7] =
+	fcf_rec->fabric_name[7] =
 		bf_get(lpfc_fcf_record_fab_name_7, new_fcf_record);
-	phba->fcf.mac_addr[0] =
-		bf_get(lpfc_fcf_record_mac_0, new_fcf_record);
-	phba->fcf.mac_addr[1] =
-		bf_get(lpfc_fcf_record_mac_1, new_fcf_record);
-	phba->fcf.mac_addr[2] =
-		bf_get(lpfc_fcf_record_mac_2, new_fcf_record);
-	phba->fcf.mac_addr[3] =
-		bf_get(lpfc_fcf_record_mac_3, new_fcf_record);
-	phba->fcf.mac_addr[4] =
-		bf_get(lpfc_fcf_record_mac_4, new_fcf_record);
-	phba->fcf.mac_addr[5] =
-		bf_get(lpfc_fcf_record_mac_5, new_fcf_record);
-	phba->fcf.fcf_indx = bf_get(lpfc_fcf_record_fcf_index, new_fcf_record);
-	phba->fcf.priority = new_fcf_record->fip_priority;
-	phba->fcf.switch_name[0] =
+	/* Mac address */
+	fcf_rec->mac_addr[0] = bf_get(lpfc_fcf_record_mac_0, new_fcf_record);
+	fcf_rec->mac_addr[1] = bf_get(lpfc_fcf_record_mac_1, new_fcf_record);
+	fcf_rec->mac_addr[2] = bf_get(lpfc_fcf_record_mac_2, new_fcf_record);
+	fcf_rec->mac_addr[3] = bf_get(lpfc_fcf_record_mac_3, new_fcf_record);
+	fcf_rec->mac_addr[4] = bf_get(lpfc_fcf_record_mac_4, new_fcf_record);
+	fcf_rec->mac_addr[5] = bf_get(lpfc_fcf_record_mac_5, new_fcf_record);
+	/* FCF record index */
+	fcf_rec->fcf_indx = bf_get(lpfc_fcf_record_fcf_index, new_fcf_record);
+	/* FCF record priority */
+	fcf_rec->priority = new_fcf_record->fip_priority;
+	/* Switch name */
+	fcf_rec->switch_name[0] =
 		bf_get(lpfc_fcf_record_switch_name_0, new_fcf_record);
-	phba->fcf.switch_name[1] =
+	fcf_rec->switch_name[1] =
 		bf_get(lpfc_fcf_record_switch_name_1, new_fcf_record);
-	phba->fcf.switch_name[2] =
+	fcf_rec->switch_name[2] =
 		bf_get(lpfc_fcf_record_switch_name_2, new_fcf_record);
-	phba->fcf.switch_name[3] =
+	fcf_rec->switch_name[3] =
 		bf_get(lpfc_fcf_record_switch_name_3, new_fcf_record);
-	phba->fcf.switch_name[4] =
+	fcf_rec->switch_name[4] =
 		bf_get(lpfc_fcf_record_switch_name_4, new_fcf_record);
-	phba->fcf.switch_name[5] =
+	fcf_rec->switch_name[5] =
 		bf_get(lpfc_fcf_record_switch_name_5, new_fcf_record);
-	phba->fcf.switch_name[6] =
+	fcf_rec->switch_name[6] =
 		bf_get(lpfc_fcf_record_switch_name_6, new_fcf_record);
-	phba->fcf.switch_name[7] =
+	fcf_rec->switch_name[7] =
 		bf_get(lpfc_fcf_record_switch_name_7, new_fcf_record);
 }
 
 /**
+ * lpfc_update_fcf_record - Update driver fcf record
+ * @phba: pointer to lpfc hba data structure.
+ * @fcf_rec: pointer to driver fcf record.
+ * @new_fcf_record: pointer to hba fcf record.
+ * @addr_mode: address mode to be set to the driver fcf record.
+ * @vlan_id: vlan tag to be set to the driver fcf record.
+ * @flag: flag bits to be set to the driver fcf record.
+ *
+ * This routine updates the driver FCF record from the new HBA FCF record
+ * together with the address mode, vlan_id, and other informations. This
+ * routine is called with the host lock held.
+ **/
+static void
+__lpfc_update_fcf_record(struct lpfc_hba *phba, struct lpfc_fcf_rec *fcf_rec,
+		       struct fcf_record *new_fcf_record, uint32_t addr_mode,
+		       uint16_t vlan_id, uint32_t flag)
+{
+	/* Copy the fields from the HBA's FCF record */
+	lpfc_copy_fcf_record(fcf_rec, new_fcf_record);
+	/* Update other fields of driver FCF record */
+	fcf_rec->addr_mode = addr_mode;
+	fcf_rec->vlan_id = vlan_id;
+	fcf_rec->flag |= (flag | RECORD_VALID);
+}
+
+/**
  * lpfc_register_fcf - Register the FCF with hba.
  * @phba: pointer to lpfc hba data structure.
  *
@@ -1214,7 +1242,7 @@ lpfc_register_fcf(struct lpfc_hba *phba)
 
 	/* The FCF is already registered, start discovery */
 	if (phba->fcf.fcf_flag & FCF_REGISTERED) {
-		phba->fcf.fcf_flag |= (FCF_DISCOVERED | FCF_IN_USE);
+		phba->fcf.fcf_flag |= (FCF_SCAN_DONE | FCF_IN_USE);
 		phba->hba_flag &= ~FCF_DISC_INPROGRESS;
 		spin_unlock_irqrestore(&phba->hbalock, flags);
 		if (phba->pport->port_state != LPFC_FLOGI)
@@ -1252,6 +1280,7 @@ lpfc_register_fcf(struct lpfc_hba *phba)
  * @new_fcf_record: pointer to fcf record.
  * @boot_flag: Indicates if this record used by boot bios.
  * @addr_mode: The address mode to be used by this FCF
+ * @vlan_id: The vlan id to be used as vlan tagging by this FCF.
  *
  * This routine compare the fcf record with connect list obtained from the
  * config region to decide if this FCF can be used for SAN discovery. It returns
@@ -1325,7 +1354,8 @@ lpfc_match_fcf_conn_list(struct lpfc_hba
 		return 1;
 	}
 
-	list_for_each_entry(conn_entry, &phba->fcf_conn_rec_list, list) {
+	list_for_each_entry(conn_entry,
+			    &phba->fcf_conn_rec_list, list) {
 		if (!(conn_entry->conn_rec.flags & FCFCNCT_VALID))
 			continue;
 
@@ -1472,6 +1502,7 @@ lpfc_check_pending_fcoe_event(struct lpf
 		 */
 		spin_lock_irq(&phba->hbalock);
 		phba->hba_flag &= ~FCF_DISC_INPROGRESS;
+		phba->fcf.fcf_flag &= ~FCF_REDISC_FOV;
 		spin_unlock_irq(&phba->hbalock);
 	}
 
@@ -1526,11 +1557,12 @@ lpfc_mbx_cmpl_read_fcf_record(struct lpf
 	uint32_t shdr_status, shdr_add_status;
 	union lpfc_sli4_cfg_shdr *shdr;
 	struct fcf_record *new_fcf_record;
-	int rc;
 	uint32_t boot_flag, addr_mode;
 	uint32_t next_fcf_index;
-	unsigned long flags;
+	struct lpfc_fcf_rec *fcf_rec = NULL;
+	unsigned long iflags;
 	uint16_t vlan_id;
+	int rc;
 
 	/* If there is pending FCoE event restart FCF table scan */
 	if (lpfc_check_pending_fcoe_event(phba, 0)) {
@@ -1585,9 +1617,8 @@ lpfc_mbx_cmpl_read_fcf_record(struct lpf
 			      sizeof(struct fcf_record));
 	bytep = virt_addr + sizeof(union lpfc_sli4_cfg_shdr);
 
-	rc = lpfc_match_fcf_conn_list(phba, new_fcf_record,
-				      &boot_flag, &addr_mode,
-					&vlan_id);
+	rc = lpfc_match_fcf_conn_list(phba, new_fcf_record, &boot_flag,
+				      &addr_mode, &vlan_id);
 	/*
 	 * If the fcf record does not match with connect list entries
 	 * read the next entry.
@@ -1596,90 +1627,159 @@ lpfc_mbx_cmpl_read_fcf_record(struct lpf
 		goto read_next_fcf;
 	/*
 	 * If this is not the first FCF discovery of the HBA, use last
-	 * FCF record for the discovery.
+	 * FCF record for the discovery. The condition that a rescan
+	 * matches the in-use FCF record: fabric name, switch name, mac
+	 * address, and vlan_id.
 	 */
-	spin_lock_irqsave(&phba->hbalock, flags);
+	spin_lock_irqsave(&phba->hbalock, iflags);
 	if (phba->fcf.fcf_flag & FCF_IN_USE) {
-		if (lpfc_fab_name_match(phba->fcf.fabric_name,
+		if (lpfc_fab_name_match(phba->fcf.current_rec.fabric_name,
+					new_fcf_record) &&
+		    lpfc_sw_name_match(phba->fcf.current_rec.switch_name,
 					new_fcf_record) &&
-		    lpfc_sw_name_match(phba->fcf.switch_name,
+		    lpfc_mac_addr_match(phba->fcf.current_rec.mac_addr,
 					new_fcf_record) &&
-		    lpfc_mac_addr_match(phba, new_fcf_record)) {
+		    lpfc_vlan_id_match(phba->fcf.current_rec.vlan_id,
+					vlan_id)) {
 			phba->fcf.fcf_flag |= FCF_AVAILABLE;
-			spin_unlock_irqrestore(&phba->hbalock, flags);
+			if (phba->fcf.fcf_flag & FCF_REDISC_PEND)
+				/* Stop FCF redisc wait timer if pending */
+				__lpfc_sli4_stop_fcf_redisc_wait_timer(phba);
+			else if (phba->fcf.fcf_flag & FCF_REDISC_FOV)
+				/* If in fast failover, mark it's completed */
+				phba->fcf.fcf_flag &= ~FCF_REDISC_FOV;
+			spin_unlock_irqrestore(&phba->hbalock, iflags);
 			goto out;
 		}
-		spin_unlock_irqrestore(&phba->hbalock, flags);
-		goto read_next_fcf;
+		/*
+		 * Read next FCF record from HBA searching for the matching
+		 * with in-use record only if not during the fast failover
+		 * period. In case of fast failover period, it shall try to
+		 * determine whether the FCF record just read should be the
+		 * next candidate.
+		 */
+		if (!(phba->fcf.fcf_flag & FCF_REDISC_FOV)) {
+			spin_unlock_irqrestore(&phba->hbalock, iflags);
+			goto read_next_fcf;
+		}
 	}
+	/*
+	 * Update on failover FCF record only if it's in FCF fast-failover
+	 * period; otherwise, update on current FCF record.
+	 */
+	if (phba->fcf.fcf_flag & FCF_REDISC_FOV) {
+		/* Fast FCF failover only to the same fabric name */
+		if (lpfc_fab_name_match(phba->fcf.current_rec.fabric_name,
+					new_fcf_record))
+			fcf_rec = &phba->fcf.failover_rec;
+		else
+			goto read_next_fcf;
+	} else
+		fcf_rec = &phba->fcf.current_rec;
+
 	if (phba->fcf.fcf_flag & FCF_AVAILABLE) {
 		/*
-		 * If the current FCF record does not have boot flag
-		 * set and new fcf record has boot flag set, use the
-		 * new fcf record.
+		 * If the driver FCF record does not have boot flag
+		 * set and new hba fcf record has boot flag set, use
+		 * the new hba fcf record.
 		 */
-		if (boot_flag && !(phba->fcf.fcf_flag & FCF_BOOT_ENABLE)) {
-			/* Use this FCF record */
-			lpfc_copy_fcf_record(phba, new_fcf_record);
-			phba->fcf.addr_mode = addr_mode;
-			phba->fcf.fcf_flag |= FCF_BOOT_ENABLE;
-			if (vlan_id != 0xFFFF) {
-				phba->fcf.fcf_flag |= FCF_VALID_VLAN;
-				phba->fcf.vlan_id = vlan_id;
-			}
-			spin_unlock_irqrestore(&phba->hbalock, flags);
+		if (boot_flag && !(fcf_rec->flag & BOOT_ENABLE)) {
+			/* Choose this FCF record */
+			__lpfc_update_fcf_record(phba, fcf_rec, new_fcf_record,
+					addr_mode, vlan_id, BOOT_ENABLE);
+			spin_unlock_irqrestore(&phba->hbalock, iflags);
 			goto read_next_fcf;
 		}
 		/*
-		 * If the current FCF record has boot flag set and the
-		 * new FCF record does not have boot flag, read the next
-		 * FCF record.
+		 * If the driver FCF record has boot flag set and the
+		 * new hba FCF record does not have boot flag, read
+		 * the next FCF record.
 		 */
-		if (!boot_flag && (phba->fcf.fcf_flag & FCF_BOOT_ENABLE)) {
-			spin_unlock_irqrestore(&phba->hbalock, flags);
+		if (!boot_flag && (fcf_rec->flag & BOOT_ENABLE)) {
+			spin_unlock_irqrestore(&phba->hbalock, iflags);
 			goto read_next_fcf;
 		}
 		/*
-		 * If there is a record with lower priority value for
-		 * the current FCF, use that record.
+		 * If the new hba FCF record has lower priority value
+		 * than the driver FCF record, use the new record.
 		 */
-		if (lpfc_fab_name_match(phba->fcf.fabric_name,
-					new_fcf_record) &&
-		    (new_fcf_record->fip_priority < phba->fcf.priority)) {
-			/* Use this FCF record */
-			lpfc_copy_fcf_record(phba, new_fcf_record);
-			phba->fcf.addr_mode = addr_mode;
-			if (vlan_id != 0xFFFF) {
-				phba->fcf.fcf_flag |= FCF_VALID_VLAN;
-				phba->fcf.vlan_id = vlan_id;
-			}
-			spin_unlock_irqrestore(&phba->hbalock, flags);
-			goto read_next_fcf;
+		if (lpfc_fab_name_match(fcf_rec->fabric_name, new_fcf_record) &&
+		    (new_fcf_record->fip_priority < fcf_rec->priority)) {
+			/* Choose this FCF record */
+			__lpfc_update_fcf_record(phba, fcf_rec, new_fcf_record,
+					addr_mode, vlan_id, 0);
 		}
-		spin_unlock_irqrestore(&phba->hbalock, flags);
+		spin_unlock_irqrestore(&phba->hbalock, iflags);
 		goto read_next_fcf;
 	}
 	/*
-	 * This is the first available FCF record, use this
-	 * record.
+	 * This is the first suitable FCF record, choose this record for
+	 * initial best-fit FCF.
 	 */
-	lpfc_copy_fcf_record(phba, new_fcf_record);
-	phba->fcf.addr_mode = addr_mode;
-	if (boot_flag)
-		phba->fcf.fcf_flag |= FCF_BOOT_ENABLE;
-	phba->fcf.fcf_flag |= FCF_AVAILABLE;
-	if (vlan_id != 0xFFFF) {
-		phba->fcf.fcf_flag |= FCF_VALID_VLAN;
-		phba->fcf.vlan_id = vlan_id;
+	if (fcf_rec) {
+		__lpfc_update_fcf_record(phba, fcf_rec, new_fcf_record,
+					 addr_mode, vlan_id, (boot_flag ?
+					 BOOT_ENABLE : 0));
+		phba->fcf.fcf_flag |= FCF_AVAILABLE;
 	}
-	spin_unlock_irqrestore(&phba->hbalock, flags);
+	spin_unlock_irqrestore(&phba->hbalock, iflags);
 	goto read_next_fcf;
 
 read_next_fcf:
 	lpfc_sli4_mbox_cmd_free(phba, mboxq);
-	if (next_fcf_index == LPFC_FCOE_FCF_NEXT_NONE || next_fcf_index == 0)
-		lpfc_register_fcf(phba);
-	else
+	if (next_fcf_index == LPFC_FCOE_FCF_NEXT_NONE || next_fcf_index == 0) {
+		if (phba->fcf.fcf_flag & FCF_REDISC_FOV) {
+			/*
+			 * Case of FCF fast failover scan
+			 */
+
+			/*
+			 * It has not found any suitable FCF record, cancel
+			 * FCF scan inprogress, and do nothing
+			 */
+			if (!(phba->fcf.failover_rec.flag & RECORD_VALID)) {
+				spin_lock_irqsave(&phba->hbalock, iflags);
+				phba->hba_flag &= ~FCF_DISC_INPROGRESS;
+				spin_unlock_irqrestore(&phba->hbalock, iflags);
+				return;
+			}
+			/*
+			 * It has found a suitable FCF record that is not
+			 * the same as in-use FCF record, unregister the
+			 * in-use FCF record, replace the in-use FCF record
+			 * with the new FCF record, mark FCF fast failover
+			 * completed, and then start register the new FCF
+			 * record.
+			 */
+
+			/* unregister the current in-use FCF record */
+			lpfc_unregister_fcf(phba);
+			/* replace in-use record with the new record */
+			memcpy(&phba->fcf.current_rec,
+			       &phba->fcf.failover_rec,
+			       sizeof(struct lpfc_fcf_rec));
+			/* mark the FCF fast failover completed */
+			spin_lock_irqsave(&phba->hbalock, iflags);
+			phba->fcf.fcf_flag &= ~FCF_REDISC_FOV;
+			spin_unlock_irqrestore(&phba->hbalock, iflags);
+			/* Register to the new FCF record */
+			lpfc_register_fcf(phba);
+		} else {
+			/*
+			 * In case of transaction period to fast FCF failover,
+			 * do nothing when search to the end of the FCF table.
+			 */
+			if ((phba->fcf.fcf_flag & FCF_REDISC_EVT) ||
+			    (phba->fcf.fcf_flag & FCF_REDISC_PEND))
+				return;
+			/*
+			 * Otherwise, initial scan or post linkdown rescan,
+			 * register with the best fit FCF record found so
+			 * far through the scanning process.
+			 */
+			lpfc_register_fcf(phba);
+		}
+	} else
 		lpfc_sli4_read_fcf_record(phba, next_fcf_index);
 	return;
 
@@ -1741,6 +1841,37 @@ lpfc_init_vpi_cmpl(struct lpfc_hba *phba
 }
 
 /**
+ * lpfc_issue_init_vpi - Issue init_vpi mailbox command.
+ * @vport: pointer to lpfc_vport data structure.
+ *
+ * This function issue a init_vpi mailbox command to initialize
+ * VPI for the vport.
+ */
+void
+lpfc_issue_init_vpi(struct lpfc_vport *vport)
+{
+	LPFC_MBOXQ_t *mboxq;
+	int rc;
+
+	mboxq = mempool_alloc(vport->phba->mbox_mem_pool, GFP_KERNEL);
+	if (!mboxq) {
+		lpfc_printf_vlog(vport, KERN_ERR,
+			LOG_MBOX, "2607 Failed to allocate "
+			"init_vpi mailbox\n");
+		return;
+	}
+	lpfc_init_vpi(vport->phba, mboxq, vport->vpi);
+	mboxq->vport = vport;
+	mboxq->mbox_cmpl = lpfc_init_vpi_cmpl;
+	rc = lpfc_sli_issue_mbox(vport->phba, mboxq, MBX_NOWAIT);
+	if (rc == MBX_NOT_FINISHED) {
+		lpfc_printf_vlog(vport, KERN_ERR,
+			LOG_MBOX, "2608 Failed to issue init_vpi mailbox\n");
+		mempool_free(mboxq, vport->phba->mbox_mem_pool);
+	}
+}
+
+/**
  * lpfc_start_fdiscs - send fdiscs for each vports on this port.
  * @phba: pointer to lpfc hba data structure.
  *
@@ -1752,8 +1883,6 @@ lpfc_start_fdiscs(struct lpfc_hba *phba)
 {
 	struct lpfc_vport **vports;
 	int i;
-	LPFC_MBOXQ_t *mboxq;
-	int rc;
 
 	vports = lpfc_create_vport_work_array(phba);
 	if (vports != NULL) {
@@ -1772,26 +1901,7 @@ lpfc_start_fdiscs(struct lpfc_hba *phba)
 				continue;
 			}
 			if (vports[i]->fc_flag & FC_VPORT_NEEDS_INIT_VPI) {
-				mboxq = mempool_alloc(phba->mbox_mem_pool,
-					GFP_KERNEL);
-				if (!mboxq) {
-					lpfc_printf_vlog(vports[i], KERN_ERR,
-					LOG_MBOX, "2607 Failed to allocate "
-					"init_vpi mailbox\n");
-					continue;
-				}
-				lpfc_init_vpi(phba, mboxq, vports[i]->vpi);
-				mboxq->vport = vports[i];
-				mboxq->mbox_cmpl = lpfc_init_vpi_cmpl;
-				rc = lpfc_sli_issue_mbox(phba, mboxq,
-					MBX_NOWAIT);
-				if (rc == MBX_NOT_FINISHED) {
-					lpfc_printf_vlog(vports[i], KERN_ERR,
-					LOG_MBOX, "2608 Failed to issue "
-					"init_vpi mailbox\n");
-					mempool_free(mboxq,
-						phba->mbox_mem_pool);
-				}
+				lpfc_issue_init_vpi(vports[i]);
 				continue;
 			}
 			if (phba->link_flag & LS_NPIV_FAB_SUPPORTED)
@@ -2071,8 +2181,7 @@ lpfc_mbx_process_link_up(struct lpfc_hba
 			return;
 		}
 		spin_unlock_irq(&phba->hbalock);
-		rc = lpfc_sli4_read_fcf_record(phba,
-					LPFC_FCOE_FCF_GET_FIRST);
+		rc = lpfc_sli4_read_fcf_record(phba, LPFC_FCOE_FCF_GET_FIRST);
 		if (rc)
 			goto out;
 	}
@@ -3240,6 +3349,34 @@ lpfc_unreg_rpi(struct lpfc_vport *vport,
 	return 0;
 }
 
+/**
+ * lpfc_unreg_hba_rpis - Unregister rpis registered to the hba.
+ * @phba: pointer to lpfc hba data structure.
+ *
+ * This routine is invoked to unregister all the currently registered RPIs
+ * to the HBA.
+ **/
+void
+lpfc_unreg_hba_rpis(struct lpfc_hba *phba)
+{
+	struct lpfc_vport **vports;
+	struct lpfc_nodelist *ndlp;
+	struct Scsi_Host *shost;
+	int i;
+
+	vports = lpfc_create_vport_work_array(phba);
+	for (i = 0; i <= phba->max_vports && vports[i] != NULL; i++) {
+		shost = lpfc_shost_from_vport(vports[i]);
+		spin_lock_irq(shost->host_lock);
+		list_for_each_entry(ndlp, &vports[i]->fc_nodes, nlp_listp) {
+			if (ndlp->nlp_flag & NLP_RPI_VALID)
+				lpfc_unreg_rpi(vports[i], ndlp);
+		}
+		spin_unlock_irq(shost->host_lock);
+	}
+	lpfc_destroy_vport_work_array(phba, vports);
+}
+
 void
 lpfc_unreg_all_rpis(struct lpfc_vport *vport)
 {
@@ -4470,47 +4607,31 @@ lpfc_unregister_fcfi_cmpl(struct lpfc_hb
 }
 
 /**
- * lpfc_unregister_unused_fcf - Unregister FCF if all devices are disconnected.
+ * lpfc_unregister_fcf_prep - Unregister fcf record preparation
  * @phba: Pointer to hba context object.
  *
- * This function check if there are any connected remote port for the FCF and
- * if all the devices are disconnected, this function unregister FCFI.
- * This function also tries to use another FCF for discovery.
+ * This function prepare the HBA for unregistering the currently registered
+ * FCF from the HBA. It performs unregistering, in order, RPIs, VPIs, and
+ * VFIs.
  */
-void
-lpfc_unregister_unused_fcf(struct lpfc_hba *phba)
+int
+lpfc_unregister_fcf_prep(struct lpfc_hba *phba)
 {
 	LPFC_MBOXQ_t *mbox;
-	int rc;
 	struct lpfc_vport **vports;
-	int i;
 	struct lpfc_nodelist *ndlp;
+	int i, rc;
 
-	spin_lock_irq(&phba->hbalock);
-	/*
-	 * If HBA is not running in FIP mode or
-	 * If HBA does not support FCoE or
-	 * If FCF is not registered.
-	 * do nothing.
-	 */
-	if (!(phba->hba_flag & HBA_FCOE_SUPPORT) ||
-		!(phba->fcf.fcf_flag & FCF_REGISTERED) ||
-		(!(phba->hba_flag & HBA_FIP_SUPPORT))) {
-		spin_unlock_irq(&phba->hbalock);
-		return;
-	}
-	spin_unlock_irq(&phba->hbalock);
-
+	/* Unregister RPIs */
 	if (lpfc_fcf_inuse(phba))
-		return;
+		lpfc_unreg_hba_rpis(phba);
 
 	/* At this point, all discovery is aborted */
 	phba->pport->port_state = LPFC_VPORT_UNKNOWN;
 
 	/* Unregister VPIs */
 	vports = lpfc_create_vport_work_array(phba);
-	if (vports &&
-		(phba->sli3_options & LPFC_SLI3_NPIV_ENABLED))
+	if (vports && (phba->sli3_options & LPFC_SLI3_NPIV_ENABLED))
 		for (i = 0; i <= phba->max_vports && vports[i] != NULL; i++) {
 			/* Stop FLOGI/FDISC retries */
 			ndlp = lpfc_findnode_did(vports[i], Fabric_DID);
@@ -4531,10 +4652,9 @@ lpfc_unregister_unused_fcf(struct lpfc_h
 	mbox = mempool_alloc(phba->mbox_mem_pool, GFP_KERNEL);
 	if (!mbox) {
 		lpfc_printf_log(phba, KERN_ERR, LOG_DISCOVERY|LOG_MBOX,
-			"2556 UNREG_VFI mbox allocation failed"
-			"HBA state x%x\n",
-			phba->pport->port_state);
-		return;
+				"2556 UNREG_VFI mbox allocation failed"
+				"HBA state x%x\n", phba->pport->port_state);
+		return -ENOMEM;
 	}
 
 	lpfc_unreg_vfi(mbox, phba->pport);
@@ -4544,62 +4664,162 @@ lpfc_unregister_unused_fcf(struct lpfc_h
 	rc = lpfc_sli_issue_mbox(phba, mbox, MBX_NOWAIT);
 	if (rc == MBX_NOT_FINISHED) {
 		lpfc_printf_log(phba, KERN_ERR, LOG_DISCOVERY|LOG_MBOX,
-			"2557 UNREG_VFI issue mbox failed rc x%x "
-			"HBA state x%x\n",
-			rc, phba->pport->port_state);
+				"2557 UNREG_VFI issue mbox failed rc x%x "
+				"HBA state x%x\n",
+				rc, phba->pport->port_state);
 		mempool_free(mbox, phba->mbox_mem_pool);
-		return;
+		return -EIO;
 	}
 
 	spin_lock_irq(&phba->hbalock);
 	phba->pport->fc_flag &= ~FC_VFI_REGISTERED;
 	spin_unlock_irq(&phba->hbalock);
 
-	/* Unregister FCF */
+	return 0;
+}
+
+/**
+ * lpfc_sli4_unregister_fcf - Unregister currently registered FCF record
+ * @phba: Pointer to hba context object.
+ *
+ * This function issues synchronous unregister FCF mailbox command to HBA to
+ * unregister the currently registered FCF record. The driver does not reset
+ * the driver FCF usage state flags.
+ *
+ * Return 0 if successfully issued, none-zero otherwise.
+ */
+int
+lpfc_sli4_unregister_fcf(struct lpfc_hba *phba)
+{
+	LPFC_MBOXQ_t *mbox;
+	int rc;
+
 	mbox = mempool_alloc(phba->mbox_mem_pool, GFP_KERNEL);
 	if (!mbox) {
 		lpfc_printf_log(phba, KERN_ERR, LOG_DISCOVERY|LOG_MBOX,
-			"2551 UNREG_FCFI mbox allocation failed"
-			"HBA state x%x\n",
-			phba->pport->port_state);
-		return;
+				"2551 UNREG_FCFI mbox allocation failed"
+				"HBA state x%x\n", phba->pport->port_state);
+		return -ENOMEM;
 	}
-
 	lpfc_unreg_fcfi(mbox, phba->fcf.fcfi);
 	mbox->vport = phba->pport;
 	mbox->mbox_cmpl = lpfc_unregister_fcfi_cmpl;
 	rc = lpfc_sli_issue_mbox(phba, mbox, MBX_NOWAIT);
 
 	if (rc == MBX_NOT_FINISHED) {
-		lpfc_printf_log(phba, KERN_ERR, LOG_DISCOVERY|LOG_MBOX,
-			"2552 UNREG_FCFI issue mbox failed rc x%x "
-			"HBA state x%x\n",
-			rc, phba->pport->port_state);
-		mempool_free(mbox, phba->mbox_mem_pool);
+		lpfc_printf_log(phba, KERN_ERR, LOG_SLI,
+				"2552 Unregister FCFI command failed rc x%x "
+				"HBA state x%x\n",
+				rc, phba->pport->port_state);
+		return -EINVAL;
+	}
+	return 0;
+}
+
+/**
+ * lpfc_unregister_fcf_rescan - Unregister currently registered fcf and rescan
+ * @phba: Pointer to hba context object.
+ *
+ * This function unregisters the currently reigstered FCF. This function
+ * also tries to find another FCF for discovery by rescan the HBA FCF table.
+ */
+void
+lpfc_unregister_fcf_rescan(struct lpfc_hba *phba)
+{
+	int rc;
+
+	/* Preparation for unregistering fcf */
+	rc = lpfc_unregister_fcf_prep(phba);
+	if (rc) {
+		lpfc_printf_log(phba, KERN_ERR, LOG_DISCOVERY,
+				"2748 Failed to prepare for unregistering "
+				"HBA's FCF record: rc=%d\n", rc);
 		return;
 	}
 
-	spin_lock_irq(&phba->hbalock);
-	phba->fcf.fcf_flag &= ~(FCF_AVAILABLE | FCF_REGISTERED |
-		FCF_DISCOVERED | FCF_BOOT_ENABLE | FCF_IN_USE |
-		FCF_VALID_VLAN);
-	spin_unlock_irq(&phba->hbalock);
+	/* Now, unregister FCF record and reset HBA FCF state */
+	rc = lpfc_sli4_unregister_fcf(phba);
+	if (rc)
+		return;
+	/* Reset HBA FCF states after successful unregister FCF */
+	phba->fcf.fcf_flag = 0;
 
 	/*
 	 * If driver is not unloading, check if there is any other
 	 * FCF record that can be used for discovery.
 	 */
 	if ((phba->pport->load_flag & FC_UNLOADING) ||
-		(phba->link_state < LPFC_LINK_UP))
+	    (phba->link_state < LPFC_LINK_UP))
 		return;
 
 	rc = lpfc_sli4_read_fcf_record(phba, LPFC_FCOE_FCF_GET_FIRST);
 
 	if (rc)
 		lpfc_printf_log(phba, KERN_ERR, LOG_DISCOVERY|LOG_MBOX,
-			"2553 lpfc_unregister_unused_fcf failed to read FCF"
-			" record HBA state x%x\n",
-			phba->pport->port_state);
+				"2553 lpfc_unregister_unused_fcf failed "
+				"to read FCF record HBA state x%x\n",
+				phba->pport->port_state);
+}
+
+/**
+ * lpfc_unregister_fcf - Unregister the currently registered fcf record
+ * @phba: Pointer to hba context object.
+ *
+ * This function just unregisters the currently reigstered FCF. It does not
+ * try to find another FCF for discovery.
+ */
+void
+lpfc_unregister_fcf(struct lpfc_hba *phba)
+{
+	int rc;
+
+	/* Preparation for unregistering fcf */
+	rc = lpfc_unregister_fcf_prep(phba);
+	if (rc) {
+		lpfc_printf_log(phba, KERN_ERR, LOG_DISCOVERY,
+				"2749 Failed to prepare for unregistering "
+				"HBA's FCF record: rc=%d\n", rc);
+		return;
+	}
+
+	/* Now, unregister FCF record and reset HBA FCF state */
+	rc = lpfc_sli4_unregister_fcf(phba);
+	if (rc)
+		return;
+	/* Set proper HBA FCF states after successful unregister FCF */
+	spin_lock_irq(&phba->hbalock);
+	phba->fcf.fcf_flag &= ~FCF_REGISTERED;
+	spin_unlock_irq(&phba->hbalock);
+}
+
+/**
+ * lpfc_unregister_unused_fcf - Unregister FCF if all devices are disconnected.
+ * @phba: Pointer to hba context object.
+ *
+ * This function check if there are any connected remote port for the FCF and
+ * if all the devices are disconnected, this function unregister FCFI.
+ * This function also tries to use another FCF for discovery.
+ */
+void
+lpfc_unregister_unused_fcf(struct lpfc_hba *phba)
+{
+	/*
+	 * If HBA is not running in FIP mode or if HBA does not support
+	 * FCoE or if FCF is not registered, do nothing.
+	 */
+	spin_lock_irq(&phba->hbalock);
+	if (!(phba->hba_flag & HBA_FCOE_SUPPORT) ||
+	    !(phba->fcf.fcf_flag & FCF_REGISTERED) ||
+	    !(phba->hba_flag & HBA_FIP_SUPPORT)) {
+		spin_unlock_irq(&phba->hbalock);
+		return;
+	}
+	spin_unlock_irq(&phba->hbalock);
+
+	if (lpfc_fcf_inuse(phba))
+		return;
+
+	lpfc_unregister_fcf_rescan(phba);
 }
 
 /**
diff -upNr a/drivers/scsi/lpfc/lpfc_hw4.h b/drivers/scsi/lpfc/lpfc_hw4.h
--- a/drivers/scsi/lpfc/lpfc_hw4.h	2010-02-12 10:52:11.000000000 -0500
+++ b/drivers/scsi/lpfc/lpfc_hw4.h	2010-02-12 10:52:43.000000000 -0500
@@ -797,6 +797,7 @@ struct mbox_header {
 #define LPFC_MBOX_OPCODE_FCOE_ADD_FCF			0x09
 #define LPFC_MBOX_OPCODE_FCOE_DELETE_FCF		0x0A
 #define LPFC_MBOX_OPCODE_FCOE_POST_HDR_TEMPLATE		0x0B
+#define LPFC_MBOX_OPCODE_FCOE_REDISCOVER_FCF		0x10
 
 /* Mailbox command structures */
 struct eq_context {
@@ -1297,6 +1298,19 @@ struct lpfc_mbx_del_fcf_tbl_entry {
 #define lpfc_mbx_del_fcf_tbl_index_WORD		word10
 };
 
+struct lpfc_mbx_redisc_fcf_tbl {
+	struct mbox_header header;
+	uint32_t word10;
+#define lpfc_mbx_redisc_fcf_count_SHIFT		0
+#define lpfc_mbx_redisc_fcf_count_MASK		0x0000FFFF
+#define lpfc_mbx_redisc_fcf_count_WORD		word10
+	uint32_t resvd;
+	uint32_t word12;
+#define lpfc_mbx_redisc_fcf_index_SHIFT		0
+#define lpfc_mbx_redisc_fcf_index_MASK		0x0000FFFF
+#define lpfc_mbx_redisc_fcf_index_WORD		word12
+};
+
 struct lpfc_mbx_query_fw_cfg {
 	struct mbox_header header;
 	uint32_t config_number;
@@ -1859,6 +1873,7 @@ struct lpfc_mqe {
 		struct lpfc_mbx_read_fcf_tbl read_fcf_tbl;
 		struct lpfc_mbx_add_fcf_tbl_entry add_fcf_entry;
 		struct lpfc_mbx_del_fcf_tbl_entry del_fcf_entry;
+		struct lpfc_mbx_redisc_fcf_tbl redisc_fcf_tbl;
 		struct lpfc_mbx_reg_fcfi reg_fcfi;
 		struct lpfc_mbx_unreg_fcfi unreg_fcfi;
 		struct lpfc_mbx_mq_create mq_create;
@@ -1975,6 +1990,7 @@ struct lpfc_acqe_fcoe {
 #define LPFC_FCOE_EVENT_TYPE_FCF_TABLE_FULL	0x2
 #define LPFC_FCOE_EVENT_TYPE_FCF_DEAD		0x3
 #define LPFC_FCOE_EVENT_TYPE_CVL		0x4
+#define LPFC_FCOE_EVENT_TYPE_FCF_PARAM_MOD	0x5
 	uint32_t event_tag;
 	uint32_t trailer;
 };
diff -upNr a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
--- a/drivers/scsi/lpfc/lpfc_init.c	2010-02-12 10:52:11.000000000 -0500
+++ b/drivers/scsi/lpfc/lpfc_init.c	2010-02-12 10:52:43.000000000 -0500
@@ -2073,6 +2073,44 @@ lpfc_stop_vport_timers(struct lpfc_vport
 }
 
 /**
+ * __lpfc_sli4_stop_fcf_redisc_wait_timer - Stop FCF rediscovery wait timer
+ * @phba: pointer to lpfc hba data structure.
+ *
+ * This routine stops the SLI4 FCF rediscover wait timer if it's on. The
+ * caller of this routine should already hold the host lock.
+ **/
+void
+__lpfc_sli4_stop_fcf_redisc_wait_timer(struct lpfc_hba *phba)
+{
+	/* Clear pending FCF rediscovery wait timer */
+	phba->fcf.fcf_flag &= ~FCF_REDISC_PEND;
+	/* Now, try to stop the timer */
+	del_timer(&phba->fcf.redisc_wait);
+}
+
+/**
+ * lpfc_sli4_stop_fcf_redisc_wait_timer - Stop FCF rediscovery wait timer
+ * @phba: pointer to lpfc hba data structure.
+ *
+ * This routine stops the SLI4 FCF rediscover wait timer if it's on. It
+ * checks whether the FCF rediscovery wait timer is pending with the host
+ * lock held before proceeding with disabling the timer and clearing the
+ * wait timer pendig flag.
+ **/
+void
+lpfc_sli4_stop_fcf_redisc_wait_timer(struct lpfc_hba *phba)
+{
+	spin_lock_irq(&phba->hbalock);
+	if (!(phba->fcf.fcf_flag & FCF_REDISC_PEND)) {
+		/* FCF rediscovery timer already fired or stopped */
+		spin_unlock_irq(&phba->hbalock);
+		return;
+	}
+	__lpfc_sli4_stop_fcf_redisc_wait_timer(phba);
+	spin_unlock_irq(&phba->hbalock);
+}
+
+/**
  * lpfc_stop_hba_timers - Stop all the timers associated with an HBA
  * @phba: pointer to lpfc hba data structure.
  *
@@ -2096,6 +2134,7 @@ lpfc_stop_hba_timers(struct lpfc_hba *ph
 		break;
 	case LPFC_PCI_DEV_OC:
 		/* Stop any OneConnect device sepcific driver timers */
+		lpfc_sli4_stop_fcf_redisc_wait_timer(phba);
 		break;
 	default:
 		lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
@@ -2706,7 +2745,7 @@ lpfc_sli_remove_dflt_fcf(struct lpfc_hba
 	del_fcf_record = &mboxq->u.mqe.un.del_fcf_entry;
 	bf_set(lpfc_mbx_del_fcf_tbl_count, del_fcf_record, 1);
 	bf_set(lpfc_mbx_del_fcf_tbl_index, del_fcf_record,
-	       phba->fcf.fcf_indx);
+	       phba->fcf.current_rec.fcf_indx);
 
 	if (!phba->sli4_hba.intr_enable)
 		rc = lpfc_sli_issue_mbox(phba, mboxq, MBX_POLL);
@@ -2730,6 +2769,57 @@ lpfc_sli_remove_dflt_fcf(struct lpfc_hba
 }
 
 /**
+ * lpfc_fcf_redisc_wait_start_timer - Start fcf rediscover wait timer
+ * @phba: Pointer to hba for which this call is being executed.
+ *
+ * This routine starts the timer waiting for the FCF rediscovery to complete.
+ **/
+void
+lpfc_fcf_redisc_wait_start_timer(struct lpfc_hba *phba)
+{
+	unsigned long fcf_redisc_wait_tmo =
+		(jiffies + msecs_to_jiffies(LPFC_FCF_REDISCOVER_WAIT_TMO));
+	/* Start fcf rediscovery wait period timer */
+	mod_timer(&phba->fcf.redisc_wait, fcf_redisc_wait_tmo);
+	spin_lock_irq(&phba->hbalock);
+	/* Allow action to new fcf asynchronous event */
+	phba->fcf.fcf_flag &= ~(FCF_AVAILABLE | FCF_SCAN_DONE);
+	/* Mark the FCF rediscovery pending state */
+	phba->fcf.fcf_flag |= FCF_REDISC_PEND;
+	spin_unlock_irq(&phba->hbalock);
+}
+
+/**
+ * lpfc_sli4_fcf_redisc_wait_tmo - FCF table rediscover wait timeout
+ * @ptr: Map to lpfc_hba data structure pointer.
+ *
+ * This routine is invoked when waiting for FCF table rediscover has been
+ * timed out. If new FCF record(s) has (have) been discovered during the
+ * wait period, a new FCF event shall be added to the FCOE async event
+ * list, and then worker thread shall be waked up for processing from the
+ * worker thread context.
+ **/
+void
+lpfc_sli4_fcf_redisc_wait_tmo(unsigned long ptr)
+{
+	struct lpfc_hba *phba = (struct lpfc_hba *)ptr;
+
+	/* Don't send FCF rediscovery event if timer cancelled */
+	spin_lock_irq(&phba->hbalock);
+	if (!(phba->fcf.fcf_flag & FCF_REDISC_PEND)) {
+		spin_unlock_irq(&phba->hbalock);
+		return;
+	}
+	/* Clear FCF rediscovery timer pending flag */
+	phba->fcf.fcf_flag &= ~FCF_REDISC_PEND;
+	/* FCF rediscovery event to worker thread */
+	phba->fcf.fcf_flag |= FCF_REDISC_EVT;
+	spin_unlock_irq(&phba->hbalock);
+	/* wake up worker thread */
+	lpfc_worker_wake_up(phba);
+}
+
+/**
  * lpfc_sli4_fw_cfg_check - Read the firmware config and verify FCoE support
  * @phba: pointer to lpfc hba data structure.
  *
@@ -3020,17 +3110,26 @@ lpfc_sli4_async_fcoe_evt(struct lpfc_hba
 	phba->fcoe_eventtag = acqe_fcoe->event_tag;
 	switch (event_type) {
 	case LPFC_FCOE_EVENT_TYPE_NEW_FCF:
+	case LPFC_FCOE_EVENT_TYPE_FCF_PARAM_MOD:
 		lpfc_printf_log(phba, KERN_ERR, LOG_DISCOVERY,
 			"2546 New FCF found index 0x%x tag 0x%x\n",
 			acqe_fcoe->index,
 			acqe_fcoe->event_tag);
-		/*
-		 * If the current FCF is in discovered state, or
-		 * FCF discovery is in progress do nothing.
-		 */
 		spin_lock_irq(&phba->hbalock);
-		if ((phba->fcf.fcf_flag & FCF_DISCOVERED) ||
-		   (phba->hba_flag & FCF_DISC_INPROGRESS)) {
+		if ((phba->fcf.fcf_flag & FCF_SCAN_DONE) ||
+		    (phba->hba_flag & FCF_DISC_INPROGRESS)) {
+			/*
+			 * If the current FCF is in discovered state or
+			 * FCF discovery is in progress, do nothing.
+			 */
+			spin_unlock_irq(&phba->hbalock);
+			break;
+		}
+		if (phba->fcf.fcf_flag & FCF_REDISC_EVT) {
+			/*
+			 * If fast FCF failover rescan event is pending,
+			 * do nothing.
+			 */
 			spin_unlock_irq(&phba->hbalock);
 			break;
 		}
@@ -3057,7 +3156,7 @@ lpfc_sli4_async_fcoe_evt(struct lpfc_hba
 			" tag 0x%x\n", acqe_fcoe->index,
 			acqe_fcoe->event_tag);
 		/* If the event is not for currently used fcf do nothing */
-		if (phba->fcf.fcf_indx != acqe_fcoe->index)
+		if (phba->fcf.current_rec.fcf_indx != acqe_fcoe->index)
 			break;
 		/*
 		 * Currently, driver support only one FCF - so treat this as
@@ -3121,7 +3220,19 @@ lpfc_sli4_async_fcoe_evt(struct lpfc_hba
 			ndlp->nlp_last_elscmd = ELS_CMD_FDISC;
 			vport->port_state = LPFC_FDISC;
 		} else {
-			lpfc_retry_pport_discovery(phba);
+			/*
+			 * Otherwise, we request port to rediscover
+			 * the entire FCF table for a fast recovery
+			 * from possible case that the current FCF
+			 * is no longer valid.
+			 */
+			rc = lpfc_sli4_redisc_fcf_table(phba);
+			if (rc)
+				/*
+				 * Last resort will be re-try on the
+				 * the current registered FCF entry.
+				 */
+				lpfc_retry_pport_discovery(phba);
 		}
 		break;
 	default:
@@ -3198,6 +3309,34 @@ void lpfc_sli4_async_event_proc(struct l
 }
 
 /**
+ * lpfc_sli4_fcf_redisc_event_proc - Process fcf table rediscovery event
+ * @phba: pointer to lpfc hba data structure.
+ *
+ * This routine is invoked by the worker thread to process FCF table
+ * rediscovery pending completion event.
+ **/
+void lpfc_sli4_fcf_redisc_event_proc(struct lpfc_hba *phba)
+{
+	int rc;
+
+	spin_lock_irq(&phba->hbalock);
+	/* Clear FCF rediscovery timeout event */
+	phba->fcf.fcf_flag &= ~FCF_REDISC_EVT;
+	/* Clear driver fast failover FCF record flag */
+	phba->fcf.failover_rec.flag = 0;
+	/* Set state for FCF fast failover */
+	phba->fcf.fcf_flag |= FCF_REDISC_FOV;
+	spin_unlock_irq(&phba->hbalock);
+
+	/* Scan FCF table from the first entry to re-discover SAN */
+	rc = lpfc_sli4_read_fcf_record(phba, LPFC_FCOE_FCF_GET_FIRST);
+	if (rc)
+		lpfc_printf_log(phba, KERN_ERR, LOG_DISCOVERY,
+				"2747 Post FCF rediscovery read FCF record "
+				"failed 0x%x\n", rc);
+}
+
+/**
  * lpfc_api_table_setup - Set up per hba pci-device group func api jump table
  * @phba: pointer to lpfc hba data structure.
  * @dev_grp: The HBA PCI-Device group number.
@@ -3512,6 +3651,11 @@ lpfc_sli4_driver_resource_setup(struct l
 	init_timer(&phba->eratt_poll);
 	phba->eratt_poll.function = lpfc_poll_eratt;
 	phba->eratt_poll.data = (unsigned long) phba;
+	/* FCF rediscover timer */
+	init_timer(&phba->fcf.redisc_wait);
+	phba->fcf.redisc_wait.function = lpfc_sli4_fcf_redisc_wait_tmo;
+	phba->fcf.redisc_wait.data = (unsigned long)phba;
+
 	/*
 	 * We need to do a READ_CONFIG mailbox command here before
 	 * calling lpfc_get_cfgparam. For VFs this will report the
@@ -6039,7 +6183,7 @@ lpfc_sli4_fcfi_unreg(struct lpfc_hba *ph
 		spin_lock_irqsave(&phba->hbalock, flags);
 		/* Mark the FCFI is no longer registered */
 		phba->fcf.fcf_flag &=
-			~(FCF_AVAILABLE | FCF_REGISTERED | FCF_DISCOVERED);
+			~(FCF_AVAILABLE | FCF_REGISTERED | FCF_SCAN_DONE);
 		spin_unlock_irqrestore(&phba->hbalock, flags);
 	}
 }
diff -upNr a/drivers/scsi/lpfc/lpfc_mbox.c b/drivers/scsi/lpfc/lpfc_mbox.c
--- a/drivers/scsi/lpfc/lpfc_mbox.c	2009-12-08 09:43:11.000000000 -0500
+++ b/drivers/scsi/lpfc/lpfc_mbox.c	2010-02-12 10:52:43.000000000 -0500
@@ -1747,6 +1747,65 @@ lpfc_sli4_mbox_opcode_get(struct lpfc_hb
 }
 
 /**
+ * lpfc_sli4_mbx_read_fcf_record - Allocate and construct read fcf mbox cmd
+ * @phba: pointer to lpfc hba data structure.
+ * @fcf_index: index to fcf table.
+ *
+ * This routine routine allocates and constructs non-embedded mailbox command
+ * for reading a FCF table entry refered by @fcf_index.
+ *
+ * Return: pointer to the mailbox command constructed if successful, otherwise
+ * NULL.
+ **/
+int
+lpfc_sli4_mbx_read_fcf_record(struct lpfc_hba *phba,
+			      struct lpfcMboxq *mboxq,
+			      uint16_t fcf_index)
+{
+	void *virt_addr;
+	dma_addr_t phys_addr;
+	uint8_t *bytep;
+	struct lpfc_mbx_sge sge;
+	uint32_t alloc_len, req_len;
+	struct lpfc_mbx_read_fcf_tbl *read_fcf;
+
+	if (!mboxq)
+		return -ENOMEM;
+
+	req_len = sizeof(struct fcf_record) +
+		  sizeof(union lpfc_sli4_cfg_shdr) + 2 * sizeof(uint32_t);
+
+	/* Set up READ_FCF SLI4_CONFIG mailbox-ioctl command */
+	alloc_len = lpfc_sli4_config(phba, mboxq, LPFC_MBOX_SUBSYSTEM_FCOE,
+			LPFC_MBOX_OPCODE_FCOE_READ_FCF_TABLE, req_len,
+			LPFC_SLI4_MBX_NEMBED);
+
+	if (alloc_len < req_len) {
+		lpfc_printf_log(phba, KERN_ERR, LOG_MBOX,
+				"0291 Allocated DMA memory size (x%x) is "
+				"less than the requested DMA memory "
+				"size (x%x)\n", alloc_len, req_len);
+		return -ENOMEM;
+	}
+
+	/* Get the first SGE entry from the non-embedded DMA memory. This
+	 * routine only uses a single SGE.
+	 */
+	lpfc_sli4_mbx_sge_get(mboxq, 0, &sge);
+	phys_addr = getPaddr(sge.pa_hi, sge.pa_lo);
+	virt_addr = mboxq->sge_array->addr[0];
+	read_fcf = (struct lpfc_mbx_read_fcf_tbl *)virt_addr;
+
+	/* Set up command fields */
+	bf_set(lpfc_mbx_read_fcf_tbl_indx, &read_fcf->u.request, fcf_index);
+	/* Perform necessary endian conversion */
+	bytep = virt_addr + sizeof(union lpfc_sli4_cfg_shdr);
+	lpfc_sli_pcimem_bcopy(bytep, bytep, sizeof(uint32_t));
+
+	return 0;
+}
+
+/**
  * lpfc_request_features: Configure SLI4 REQUEST_FEATURES mailbox
  * @mboxq: pointer to lpfc mbox command.
  *
@@ -1946,13 +2005,14 @@ lpfc_reg_fcfi(struct lpfc_hba *phba, str
 	bf_set(lpfc_reg_fcfi_rq_id1, reg_fcfi, REG_FCF_INVALID_QID);
 	bf_set(lpfc_reg_fcfi_rq_id2, reg_fcfi, REG_FCF_INVALID_QID);
 	bf_set(lpfc_reg_fcfi_rq_id3, reg_fcfi, REG_FCF_INVALID_QID);
-	bf_set(lpfc_reg_fcfi_info_index, reg_fcfi, phba->fcf.fcf_indx);
+	bf_set(lpfc_reg_fcfi_info_index, reg_fcfi,
+	       phba->fcf.current_rec.fcf_indx);
 	/* reg_fcf addr mode is bit wise inverted value of fcf addr_mode */
-	bf_set(lpfc_reg_fcfi_mam, reg_fcfi,
-		(~phba->fcf.addr_mode) & 0x3);
-	if (phba->fcf.fcf_flag & FCF_VALID_VLAN) {
+	bf_set(lpfc_reg_fcfi_mam, reg_fcfi, (~phba->fcf.addr_mode) & 0x3);
+	if (phba->fcf.current_rec.vlan_id != 0xFFFF) {
 		bf_set(lpfc_reg_fcfi_vv, reg_fcfi, 1);
-		bf_set(lpfc_reg_fcfi_vlan_tag, reg_fcfi, phba->fcf.vlan_id);
+		bf_set(lpfc_reg_fcfi_vlan_tag, reg_fcfi,
+		       phba->fcf.current_rec.vlan_id);
 	}
 }
 
diff -upNr a/drivers/scsi/lpfc/lpfc_sli4.h b/drivers/scsi/lpfc/lpfc_sli4.h
--- a/drivers/scsi/lpfc/lpfc_sli4.h	2010-02-11 17:26:55.000000000 -0500
+++ b/drivers/scsi/lpfc/lpfc_sli4.h	2010-02-12 10:52:43.000000000 -0500
@@ -22,6 +22,10 @@
 #define LPFC_RELEASE_NOTIFICATION_INTERVAL	32
 #define LPFC_GET_QE_REL_INT			32
 #define LPFC_RPI_LOW_WATER_MARK			10
+
+/* Amount of time in seconds for waiting FCF rediscovery to complete */
+#define LPFC_FCF_REDISCOVER_WAIT_TMO		2000 /* msec */
+
 /* Number of SGL entries can be posted in a 4KB nonembedded mbox command */
 #define LPFC_NEMBED_MBOX_SGL_CNT		254
 
@@ -129,22 +133,33 @@ struct lpfc_sli4_link {
 	uint16_t logical_speed;
 };
 
-struct lpfc_fcf {
-	uint8_t	 fabric_name[8];
-	uint8_t	 switch_name[8];
+struct lpfc_fcf_rec {
+	uint8_t  fabric_name[8];
+	uint8_t  switch_name[8];
 	uint8_t  mac_addr[6];
 	uint16_t fcf_indx;
+	uint32_t priority;
+	uint16_t vlan_id;
+	uint32_t addr_mode;
+	uint32_t flag;
+#define BOOT_ENABLE	0x01
+#define RECORD_VALID	0x02
+};
+
+struct lpfc_fcf {
 	uint16_t fcfi;
 	uint32_t fcf_flag;
 #define FCF_AVAILABLE	0x01 /* FCF available for discovery */
 #define FCF_REGISTERED	0x02 /* FCF registered with FW */
-#define FCF_DISCOVERED	0x04 /* FCF discovery started  */
-#define FCF_BOOT_ENABLE 0x08 /* Boot bios use this FCF */
-#define FCF_IN_USE	0x10 /* Atleast one discovery completed */
-#define FCF_VALID_VLAN	0x20 /* Use the vlan id specified */
-	uint32_t priority;
+#define FCF_SCAN_DONE	0x04 /* FCF table scan done */
+#define FCF_IN_USE	0x08 /* Atleast one discovery completed */
+#define FCF_REDISC_PEND	0x10 /* FCF rediscovery pending */
+#define FCF_REDISC_EVT	0x20 /* FCF rediscovery event to worker thread */
+#define FCF_REDISC_FOV	0x40 /* Post FCF rediscovery fast failover */
 	uint32_t addr_mode;
-	uint16_t vlan_id;
+	struct lpfc_fcf_rec current_rec;
+	struct lpfc_fcf_rec failover_rec;
+	struct timer_list redisc_wait;
 };
 
 #define LPFC_REGION23_SIGNATURE "RG23"
@@ -407,6 +422,8 @@ void lpfc_sli4_mbox_cmd_free(struct lpfc
 void lpfc_sli4_mbx_sge_set(struct lpfcMboxq *, uint32_t, dma_addr_t, uint32_t);
 void lpfc_sli4_mbx_sge_get(struct lpfcMboxq *, uint32_t,
 			   struct lpfc_mbx_sge *);
+int lpfc_sli4_mbx_read_fcf_record(struct lpfc_hba *, struct lpfcMboxq *,
+				  uint16_t);
 
 void lpfc_sli4_hba_reset(struct lpfc_hba *);
 struct lpfc_queue *lpfc_sli4_queue_alloc(struct lpfc_hba *, uint32_t,
@@ -449,6 +466,7 @@ int lpfc_sli4_alloc_rpi(struct lpfc_hba 
 void lpfc_sli4_free_rpi(struct lpfc_hba *, int);
 void lpfc_sli4_remove_rpis(struct lpfc_hba *);
 void lpfc_sli4_async_event_proc(struct lpfc_hba *);
+void lpfc_sli4_fcf_redisc_event_proc(struct lpfc_hba *);
 int lpfc_sli4_resume_rpi(struct lpfc_nodelist *);
 void lpfc_sli4_fcp_xri_abort_event_proc(struct lpfc_hba *);
 void lpfc_sli4_els_xri_abort_event_proc(struct lpfc_hba *);
diff -upNr a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
--- a/drivers/scsi/lpfc/lpfc_sli.c	2010-02-11 17:26:55.000000000 -0500
+++ b/drivers/scsi/lpfc/lpfc_sli.c	2010-02-12 10:52:43.000000000 -0500
@@ -11956,12 +11956,6 @@ lpfc_sli4_read_fcf_record(struct lpfc_hb
 {
 	int rc = 0, error;
 	LPFC_MBOXQ_t *mboxq;
-	void *virt_addr;
-	dma_addr_t phys_addr;
-	uint8_t *bytep;
-	struct lpfc_mbx_sge sge;
-	uint32_t alloc_len, req_len;
-	struct lpfc_mbx_read_fcf_tbl *read_fcf;
 
 	phba->fcoe_eventtag_at_fcf_scan = phba->fcoe_eventtag;
 	mboxq = mempool_alloc(phba->mbox_mem_pool, GFP_KERNEL);
@@ -11972,43 +11966,19 @@ lpfc_sli4_read_fcf_record(struct lpfc_hb
 		error = -ENOMEM;
 		goto fail_fcfscan;
 	}
-
-	req_len = sizeof(struct fcf_record) +
-		  sizeof(union lpfc_sli4_cfg_shdr) + 2 * sizeof(uint32_t);
-
-	/* Set up READ_FCF SLI4_CONFIG mailbox-ioctl command */
-	alloc_len = lpfc_sli4_config(phba, mboxq, LPFC_MBOX_SUBSYSTEM_FCOE,
-			 LPFC_MBOX_OPCODE_FCOE_READ_FCF_TABLE, req_len,
-			 LPFC_SLI4_MBX_NEMBED);
-
-	if (alloc_len < req_len) {
-		lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
-				"0291 Allocated DMA memory size (x%x) is "
-				"less than the requested DMA memory "
-				"size (x%x)\n", alloc_len, req_len);
-		error = -ENOMEM;
+	/* Construct the read FCF record mailbox command */
+	rc = lpfc_sli4_mbx_read_fcf_record(phba, mboxq, fcf_index);
+	if (rc) {
+		error = -EINVAL;
 		goto fail_fcfscan;
 	}
-
-	/* Get the first SGE entry from the non-embedded DMA memory. This
-	 * routine only uses a single SGE.
-	 */
-	lpfc_sli4_mbx_sge_get(mboxq, 0, &sge);
-	phys_addr = getPaddr(sge.pa_hi, sge.pa_lo);
-	virt_addr = mboxq->sge_array->addr[0];
-	read_fcf = (struct lpfc_mbx_read_fcf_tbl *)virt_addr;
-
-	/* Set up command fields */
-	bf_set(lpfc_mbx_read_fcf_tbl_indx, &read_fcf->u.request, fcf_index);
-	/* Perform necessary endian conversion */
-	bytep = virt_addr + sizeof(union lpfc_sli4_cfg_shdr);
-	lpfc_sli_pcimem_bcopy(bytep, bytep, sizeof(uint32_t));
+	/* Issue the mailbox command asynchronously */
 	mboxq->vport = phba->pport;
 	mboxq->mbox_cmpl = lpfc_mbx_cmpl_read_fcf_record;
 	rc = lpfc_sli_issue_mbox(phba, mboxq, MBX_NOWAIT);
-	if (rc == MBX_NOT_FINISHED) {
+	if (rc == MBX_NOT_FINISHED)
 		error = -EIO;
-	} else {
+	else {
 		spin_lock_irq(&phba->hbalock);
 		phba->hba_flag |= FCF_DISC_INPROGRESS;
 		spin_unlock_irq(&phba->hbalock);
@@ -12027,6 +11997,90 @@ fail_fcfscan:
 }
 
 /**
+ * lpfc_mbx_cmpl_redisc_fcf_table - completion routine for rediscover FCF table
+ * @phba: pointer to lpfc hba data structure.
+ *
+ * This routine is the completion routine for the rediscover FCF table mailbox
+ * command. If the mailbox command returned failure, it will try to stop the
+ * FCF rediscover wait timer.
+ **/
+void
+lpfc_mbx_cmpl_redisc_fcf_table(struct lpfc_hba *phba, LPFC_MBOXQ_t *mbox)
+{
+	struct lpfc_mbx_redisc_fcf_tbl *redisc_fcf;
+	uint32_t shdr_status, shdr_add_status;
+
+	redisc_fcf = &mbox->u.mqe.un.redisc_fcf_tbl;
+
+	shdr_status = bf_get(lpfc_mbox_hdr_status,
+			     &redisc_fcf->header.cfg_shdr.response);
+	shdr_add_status = bf_get(lpfc_mbox_hdr_add_status,
+			     &redisc_fcf->header.cfg_shdr.response);
+	if (shdr_status || shdr_add_status) {
+		lpfc_printf_log(phba, KERN_ERR, LOG_SLI,
+				"2746 Requesting for FCF rediscovery failed "
+				"status x%x add_status x%x\n",
+				shdr_status, shdr_add_status);
+		/*
+		 * Request failed, last resort to re-try current
+		 * registered FCF entry
+		 */
+		lpfc_retry_pport_discovery(phba);
+	} else
+		/*
+		 * Start FCF rediscovery wait timer for pending FCF
+		 * before rescan FCF record table.
+		 */
+		lpfc_fcf_redisc_wait_start_timer(phba);
+
+	mempool_free(mbox, phba->mbox_mem_pool);
+}
+
+/**
+ * lpfc_sli4_redisc_all_fcf - Request to rediscover entire FCF table by port.
+ * @phba: pointer to lpfc hba data structure.
+ *
+ * This routine is invoked to request for rediscovery of the entire FCF table
+ * by the port.
+ **/
+int
+lpfc_sli4_redisc_fcf_table(struct lpfc_hba *phba)
+{
+	LPFC_MBOXQ_t *mbox;
+	struct lpfc_mbx_redisc_fcf_tbl *redisc_fcf;
+	int rc, length;
+
+	mbox = mempool_alloc(phba->mbox_mem_pool, GFP_KERNEL);
+	if (!mbox) {
+		lpfc_printf_log(phba, KERN_ERR, LOG_SLI,
+				"2745 Failed to allocate mbox for "
+				"requesting FCF rediscover.\n");
+		return -ENOMEM;
+	}
+
+	length = (sizeof(struct lpfc_mbx_redisc_fcf_tbl) -
+		  sizeof(struct lpfc_sli4_cfg_mhdr));
+	lpfc_sli4_config(phba, mbox, LPFC_MBOX_SUBSYSTEM_FCOE,
+			 LPFC_MBOX_OPCODE_FCOE_REDISCOVER_FCF,
+			 length, LPFC_SLI4_MBX_EMBED);
+
+	redisc_fcf = &mbox->u.mqe.un.redisc_fcf_tbl;
+	/* Set count to 0 for invalidating the entire FCF database */
+	bf_set(lpfc_mbx_redisc_fcf_count, redisc_fcf, 0);
+
+	/* Issue the mailbox command asynchronously */
+	mbox->vport = phba->pport;
+	mbox->mbox_cmpl = lpfc_mbx_cmpl_redisc_fcf_table;
+	rc = lpfc_sli_issue_mbox(phba, mbox, MBX_NOWAIT);
+
+	if (rc == MBX_NOT_FINISHED) {
+		mempool_free(mbox, phba->mbox_mem_pool);
+		return -EIO;
+	}
+	return 0;
+}
+
+/**
  * lpfc_sli_read_link_ste - Read region 23 to decide if link is disabled.
  * @phba: pointer to lpfc hba data structure.
  *


