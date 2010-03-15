From: James Smart <james.smart@emulex.com>
Subject: [PATCH 5/6] lpfc 8.3.11: NPIV changes
Date: Mon, 15 Mar 2010 11:25:44 -0400
Message-ID: <1268666744.31367.17.camel@wookie>
Reply-To: james.smart@emulex.com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from exht1.emulex.com ([138.239.113.183]:57397 "EHLO
	exht1.ad.emulex.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S965193Ab0COPZz (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 15 Mar 2010 11:25:55 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

NPIV changes

- Enable NPIV by default.
- Added code to handle unsolicited LOGO on physical port.


 Signed-off-by: Alex Iannicelli <alex.iannicelli@emulex.com>
 Signed-off-by: James Smart <james.smart@emulex.com>

 ---

 lpfc.h           |    2 ++
 lpfc_attr.c      |    2 +-
 lpfc_els.c       |    7 ++++++-
 lpfc_hbadisc.c   |    7 ++++++-
 lpfc_nportdisc.c |   43 ++++++++++++++++++++++++++++++++++++++-----
 5 files changed, 53 insertions(+), 8 deletions(-)


diff -upNr a/drivers/scsi/lpfc/lpfc_attr.c b/drivers/scsi/lpfc/lpfc_attr.c
--- a/drivers/scsi/lpfc/lpfc_attr.c	2010-03-05 10:42:37.000000000 -0500
+++ b/drivers/scsi/lpfc/lpfc_attr.c	2010-03-15 10:32:46.000000000 -0400
@@ -1928,7 +1928,7 @@ int lpfc_enable_npiv = 0;
 module_param(lpfc_enable_npiv, int, 0);
 MODULE_PARM_DESC(lpfc_enable_npiv, "Enable NPIV functionality");
 lpfc_param_show(enable_npiv);
-lpfc_param_init(enable_npiv, 0, 0, 1);
+lpfc_param_init(enable_npiv, 1, 0, 1);
 static DEVICE_ATTR(lpfc_enable_npiv, S_IRUGO,
 			 lpfc_enable_npiv_show, NULL);
 
diff -upNr a/drivers/scsi/lpfc/lpfc_els.c b/drivers/scsi/lpfc/lpfc_els.c
--- a/drivers/scsi/lpfc/lpfc_els.c	2010-03-15 10:30:47.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_els.c	2010-03-15 10:32:46.000000000 -0400
@@ -863,6 +863,7 @@ lpfc_cmpl_els_flogi(struct lpfc_hba *phb
 	}
 	spin_lock_irq(shost->host_lock);
 	vport->fc_flag &= ~FC_VPORT_CVL_RCVD;
+	vport->fc_flag &= ~FC_VPORT_LOGO_RCVD;
 	spin_unlock_irq(shost->host_lock);
 
 	/*
@@ -6052,7 +6053,8 @@ lpfc_cmpl_reg_new_vport(struct lpfc_hba 
 			spin_lock_irq(shost->host_lock);
 			vport->fc_flag |= FC_VPORT_NEEDS_REG_VPI;
 			spin_unlock_irq(shost->host_lock);
-			if (vport->port_type == LPFC_PHYSICAL_PORT)
+			if (vport->port_type == LPFC_PHYSICAL_PORT
+				&& !(vport->fc_flag & FC_LOGO_RCVD_DID_CHNG))
 				lpfc_initial_flogi(vport);
 			else
 				lpfc_initial_fdisc(vport);
@@ -6288,6 +6290,7 @@ lpfc_cmpl_els_fdisc(struct lpfc_hba *phb
 	}
 	spin_lock_irq(shost->host_lock);
 	vport->fc_flag &= ~FC_VPORT_CVL_RCVD;
+	vport->fc_flag &= ~FC_VPORT_LOGO_RCVD;
 	vport->fc_flag |= FC_FABRIC;
 	if (vport->phba->fc_topology == TOPOLOGY_LOOP)
 		vport->fc_flag |=  FC_PUBLIC_LOOP;
@@ -6317,6 +6320,8 @@ lpfc_cmpl_els_fdisc(struct lpfc_hba *phb
 		vport->fc_flag |= FC_VPORT_NEEDS_REG_VPI;
 		if (phba->sli_rev == LPFC_SLI_REV4)
 			vport->fc_flag |= FC_VPORT_NEEDS_INIT_VPI;
+		else
+			vport->fc_flag |= FC_LOGO_RCVD_DID_CHNG;
 		spin_unlock_irq(shost->host_lock);
 	}
 
diff -upNr a/drivers/scsi/lpfc/lpfc.h b/drivers/scsi/lpfc/lpfc.h
--- a/drivers/scsi/lpfc/lpfc.h	2010-03-15 10:32:12.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc.h	2010-03-15 10:32:46.000000000 -0400
@@ -310,7 +310,9 @@ struct lpfc_vport {
 #define FC_NLP_MORE             0x40	 /* More node to process in node tbl */
 #define FC_OFFLINE_MODE         0x80	 /* Interface is offline for diag */
 #define FC_FABRIC               0x100	 /* We are fabric attached */
+#define FC_VPORT_LOGO_RCVD      0x200    /* LOGO received on vport */
 #define FC_RSCN_DISCOVERY       0x400	 /* Auth all devices after RSCN */
+#define FC_LOGO_RCVD_DID_CHNG   0x800    /* FDISC on phys port detect DID chng*/
 #define FC_SCSI_SCAN_TMO        0x4000	 /* scsi scan timer running */
 #define FC_ABORT_DISCOVERY      0x8000	 /* we want to abort discovery */
 #define FC_NDISC_ACTIVE         0x10000	 /* NPort discovery active */
diff -upNr a/drivers/scsi/lpfc/lpfc_hbadisc.c b/drivers/scsi/lpfc/lpfc_hbadisc.c
--- a/drivers/scsi/lpfc/lpfc_hbadisc.c	2010-03-15 10:31:09.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_hbadisc.c	2010-03-15 10:32:46.000000000 -0400
@@ -3015,7 +3015,12 @@ lpfc_mbx_cmpl_fabric_reg_login(struct lp
 	lpfc_nlp_set_state(vport, ndlp, NLP_STE_UNMAPPED_NODE);
 
 	if (vport->port_state == LPFC_FABRIC_CFG_LINK) {
-		lpfc_start_fdiscs(phba);
+		/* when physical port receive logo donot start
+		 * vport discovery */
+		if (!(vport->fc_flag & FC_LOGO_RCVD_DID_CHNG))
+			lpfc_start_fdiscs(phba);
+		else
+			vport->fc_flag &= ~FC_LOGO_RCVD_DID_CHNG ;
 		lpfc_do_scr_ns_plogi(phba, vport);
 	}
 
diff -upNr a/drivers/scsi/lpfc/lpfc_nportdisc.c b/drivers/scsi/lpfc/lpfc_nportdisc.c
--- a/drivers/scsi/lpfc/lpfc_nportdisc.c	2010-02-11 17:26:54.000000000 -0500
+++ b/drivers/scsi/lpfc/lpfc_nportdisc.c	2010-03-15 10:32:46.000000000 -0400
@@ -492,6 +492,9 @@ lpfc_rcv_logo(struct lpfc_vport *vport, 
 	      struct lpfc_iocbq *cmdiocb, uint32_t els_cmd)
 {
 	struct Scsi_Host *shost = lpfc_shost_from_vport(vport);
+	struct lpfc_hba    *phba = vport->phba;
+	struct lpfc_vport **vports;
+	int i, active_vlink_present = 0 ;
 
 	/* Put ndlp in NPR state with 1 sec timeout for plogi, ACC logo */
 	/* Only call LOGO ACC for first LOGO, this avoids sending unnecessary
@@ -504,15 +507,44 @@ lpfc_rcv_logo(struct lpfc_vport *vport, 
 		lpfc_els_rsp_acc(vport, ELS_CMD_PRLO, cmdiocb, ndlp, NULL);
 	else
 		lpfc_els_rsp_acc(vport, ELS_CMD_ACC, cmdiocb, ndlp, NULL);
-	if ((ndlp->nlp_DID == Fabric_DID) &&
-		vport->port_type == LPFC_NPIV_PORT) {
+	if (ndlp->nlp_DID == Fabric_DID) {
+		if (vport->port_state <= LPFC_FDISC)
+			goto out;
 		lpfc_linkdown_port(vport);
-		mod_timer(&ndlp->nlp_delayfunc, jiffies + HZ * 1);
 		spin_lock_irq(shost->host_lock);
-		ndlp->nlp_flag |= NLP_DELAY_TMO;
+		vport->fc_flag |= FC_VPORT_LOGO_RCVD;
 		spin_unlock_irq(shost->host_lock);
+		vports = lpfc_create_vport_work_array(phba);
+		if (vports) {
+			for (i = 0; i <= phba->max_vports && vports[i] != NULL;
+					i++) {
+				if ((!(vports[i]->fc_flag &
+					FC_VPORT_LOGO_RCVD)) &&
+					(vports[i]->port_state > LPFC_FDISC)) {
+					active_vlink_present = 1;
+					break;
+				}
+			}
+			lpfc_destroy_vport_work_array(phba, vports);
+		}
 
-		ndlp->nlp_last_elscmd = ELS_CMD_FDISC;
+		if (active_vlink_present) {
+			/*
+			 * If there are other active VLinks present,
+			 * re-instantiate the Vlink using FDISC.
+			 */
+			mod_timer(&ndlp->nlp_delayfunc, jiffies + HZ);
+			spin_lock_irq(shost->host_lock);
+			ndlp->nlp_flag |= NLP_DELAY_TMO;
+			spin_unlock_irq(shost->host_lock);
+			ndlp->nlp_last_elscmd = ELS_CMD_FDISC;
+			vport->port_state = LPFC_FDISC;
+		} else {
+			spin_lock_irq(shost->host_lock);
+			phba->pport->fc_flag &= ~FC_LOGO_RCVD_DID_CHNG;
+			spin_unlock_irq(shost->host_lock);
+			lpfc_retry_pport_discovery(phba);
+		}
 	} else if ((!(ndlp->nlp_type & NLP_FABRIC) &&
 		((ndlp->nlp_type & NLP_FCP_TARGET) ||
 		!(ndlp->nlp_type & NLP_FCP_INITIATOR))) ||
@@ -525,6 +557,7 @@ lpfc_rcv_logo(struct lpfc_vport *vport, 
 
 		ndlp->nlp_last_elscmd = ELS_CMD_PLOGI;
 	}
+out:
 	ndlp->nlp_prev_state = ndlp->nlp_state;
 	lpfc_nlp_set_state(vport, ndlp, NLP_STE_NPR_NODE);
 


