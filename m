From: James Smart <James.Smart@Emulex.Com>
Subject: [PATCH 2/6] lpfc 8.2.5 : Miscellaneous Fixes
Date: Fri, 08 Feb 2008 18:49:39 -0500
Message-ID: <1202514579.20924.13.camel@localhost.localdomain>
Reply-To: James.Smart@Emulex.Com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:44667 "EHLO
	emulex.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756817AbYBHXtd (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 8 Feb 2008 18:49:33 -0500
Received: from xbl3.ad.emulex.com (xbl3.ma.emulex.com [138.239.73.12])
	by emulex.emulex.com (8.13.6/8.13.6) with ESMTP id m18NnEIv018509
	for <linux-scsi@vger.kernel.org>; Fri, 8 Feb 2008 15:49:32 -0800 (PST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


Miscellaneous fixes:
- Fix ERRATT flag which was overlapping
- Allow RESTART mbx commands through when stopped.
- Accept incoming PLOGI when connected to an N_Port.
- Fix NPort to NPort pt2pt problems: ADISC and reg_vpi issues
- Fix vport unloading error that erroneously cleaned up RSCN buffers
- Fix memory leak during repeated unloads - in mbox handling
- Fix link bounce vs FLOGI race conditions


 Signed-off-by: James Smart <james.smart@emulex.com>

 ---

 lpfc.h           |    4 ++--
 lpfc_attr.c      |    8 +++++---
 lpfc_els.c       |   14 +++++++++++---
 lpfc_hbadisc.c   |   15 ++-------------
 lpfc_init.c      |   13 +++++++++++--
 lpfc_nportdisc.c |   16 +++++++++-------
 lpfc_sli.c       |    4 +---
 7 files changed, 41 insertions(+), 33 deletions(-)


diff -upNr a/drivers/scsi/lpfc/lpfc_attr.c b/drivers/scsi/lpfc/lpfc_attr.c
--- a/drivers/scsi/lpfc/lpfc_attr.c	2008-02-08 18:10:08.000000000 -0500
+++ b/drivers/scsi/lpfc/lpfc_attr.c	2008-02-08 18:10:59.000000000 -0500
@@ -1946,11 +1946,13 @@ sysfs_mbox_read(struct kobject *kobj, st
 		}
 
 		/* If HBA encountered an error attention, allow only DUMP
-		 * mailbox command until the HBA is restarted.
+		 * or RESTART mailbox commands until the HBA is restarted.
 		 */
 		if ((phba->pport->stopped) &&
-			(phba->sysfs_mbox.mbox->mb.mbxCommand
-				!= MBX_DUMP_MEMORY)) {
+			(phba->sysfs_mbox.mbox->mb.mbxCommand !=
+				MBX_DUMP_MEMORY &&
+			 phba->sysfs_mbox.mbox->mb.mbxCommand !=
+				MBX_RESTART)) {
 			sysfs_mbox_idle(phba);
 			spin_unlock_irq(&phba->hbalock);
 			return -EPERM;
diff -upNr a/drivers/scsi/lpfc/lpfc_els.c b/drivers/scsi/lpfc/lpfc_els.c
--- a/drivers/scsi/lpfc/lpfc_els.c	2008-02-08 18:10:20.000000000 -0500
+++ b/drivers/scsi/lpfc/lpfc_els.c	2008-02-08 18:11:36.000000000 -0500
@@ -2046,7 +2046,8 @@ lpfc_els_retry(struct lpfc_hba *phba, st
 		retry = 1;
 
 	if ((cmd == ELS_CMD_FLOGI) &&
-	    (phba->fc_topology != TOPOLOGY_LOOP)) {
+	    (phba->fc_topology != TOPOLOGY_LOOP) &&
+	    !lpfc_error_lost_link(irsp)) {
 		/* FLOGI retry policy */
 		retry = 1;
 		maxretry = 48;
@@ -4091,8 +4092,15 @@ lpfc_els_unsol_buffer(struct lpfc_hba *p
 		ndlp = lpfc_plogi_confirm_nport(phba, payload, ndlp);
 
 		if (vport->port_state < LPFC_DISC_AUTH) {
-			rjt_err = LSRJT_UNABLE_TPC;
-			break;
+			if (!(phba->pport->fc_flag & FC_PT2PT) ||
+				(phba->pport->fc_flag & FC_PT2PT_PLOGI)) {
+				rjt_err = LSRJT_UNABLE_TPC;
+				break;
+			}
+			/* We get here, and drop thru, if we are PT2PT with
+			 * another NPort and the other side has initiated
+			 * the PLOGI before responding to our FLOGI.
+			 */
 		}
 
 		shost = lpfc_shost_from_vport(vport);
diff -upNr a/drivers/scsi/lpfc/lpfc.h b/drivers/scsi/lpfc/lpfc.h
--- a/drivers/scsi/lpfc/lpfc.h	2008-02-08 18:10:08.000000000 -0500
+++ b/drivers/scsi/lpfc/lpfc.h	2008-02-08 18:10:53.000000000 -0500
@@ -1,7 +1,7 @@
 /*******************************************************************
  * This file is part of the Emulex Linux Device Driver for         *
  * Fibre Channel Host Bus Adapters.                                *
- * Copyright (C) 2004-2007 Emulex.  All rights reserved.           *
+ * Copyright (C) 2004-2008 Emulex.  All rights reserved.           *
  * EMULEX and SLI are trademarks of Emulex.                        *
  * www.emulex.com                                                  *
  * Portions Copyright (C) 2004-2005 Christoph Hellwig              *
@@ -409,7 +409,7 @@ struct lpfc_hba {
 					/* This flag is set while issuing */
 					/* INIT_LINK mailbox command */
 #define LS_NPIV_FAB_SUPPORTED 0x2	/* Fabric supports NPIV */
-#define LS_IGNORE_ERATT       0x3	/* intr handler should ignore ERATT */
+#define LS_IGNORE_ERATT       0x4	/* intr handler should ignore ERATT */
 
 	struct lpfc_sli2_slim *slim2p;
 	struct lpfc_dmabuf hbqslimp;
diff -upNr a/drivers/scsi/lpfc/lpfc_hbadisc.c b/drivers/scsi/lpfc/lpfc_hbadisc.c
--- a/drivers/scsi/lpfc/lpfc_hbadisc.c	2008-02-08 18:10:08.000000000 -0500
+++ b/drivers/scsi/lpfc/lpfc_hbadisc.c	2008-02-08 18:11:26.000000000 -0500
@@ -800,21 +800,9 @@ lpfc_mbx_cmpl_clear_la(struct lpfc_hba *
 	writel(control, phba->HCregaddr);
 	readl(phba->HCregaddr); /* flush */
 	spin_unlock_irq(&phba->hbalock);
+	mempool_free(pmb, phba->mbox_mem_pool);
 	return;
 
-	vport->num_disc_nodes = 0;
-	/* go thru NPR nodes and issue ELS PLOGIs */
-	if (vport->fc_npr_cnt)
-		lpfc_els_disc_plogi(vport);
-
-	if (!vport->num_disc_nodes) {
-		spin_lock_irq(shost->host_lock);
-		vport->fc_flag &= ~FC_NDISC_ACTIVE;
-		spin_unlock_irq(shost->host_lock);
-	}
-
-	vport->port_state = LPFC_VPORT_READY;
-
 out:
 	/* Device Discovery completes */
 	lpfc_printf_vlog(vport, KERN_INFO, LOG_DISCOVERY,
@@ -2484,6 +2472,7 @@ lpfc_disc_start(struct lpfc_vport *vport
 	 * continue discovery.
 	 */
 	if ((phba->sli3_options & LPFC_SLI3_NPIV_ENABLED) &&
+	    !(vport->fc_flag & FC_PT2PT) &&
 	    !(vport->fc_flag & FC_RSCN_MODE)) {
 		lpfc_issue_reg_vpi(phba, vport);
 		return;
diff -upNr a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
--- a/drivers/scsi/lpfc/lpfc_init.c	2008-02-08 18:10:20.000000000 -0500
+++ b/drivers/scsi/lpfc/lpfc_init.c	2008-02-08 18:11:20.000000000 -0500
@@ -461,12 +461,21 @@ lpfc_config_port_post(struct lpfc_hba *p
 int
 lpfc_hba_down_prep(struct lpfc_hba *phba)
 {
+	struct lpfc_vport **vports;
+	int i;
 	/* Disable interrupts */
 	writel(0, phba->HCregaddr);
 	readl(phba->HCregaddr); /* flush */
 
-	lpfc_cleanup_discovery_resources(phba->pport);
-	return 0;
+	if (phba->pport->load_flag & FC_UNLOADING)
+		lpfc_cleanup_discovery_resources(phba->pport);
+	else {
+		vports = lpfc_create_vport_work_array(phba);
+		if (vports != NULL)
+			for(i = 0; i <= phba->max_vpi && vports[i] != NULL; i++)
+				lpfc_cleanup_discovery_resources(vports[i]);
+		lpfc_destroy_vport_work_array(phba, vports);
+	}	return 0;
 }
 
 /************************************************************************/
diff -upNr a/drivers/scsi/lpfc/lpfc_nportdisc.c b/drivers/scsi/lpfc/lpfc_nportdisc.c
--- a/drivers/scsi/lpfc/lpfc_nportdisc.c	2008-02-08 18:10:20.000000000 -0500
+++ b/drivers/scsi/lpfc/lpfc_nportdisc.c	2008-02-08 18:11:12.000000000 -0500
@@ -645,13 +645,15 @@ lpfc_disc_set_adisc(struct lpfc_vport *v
 		return 0;
 	}
 
-	/* Check config parameter use-adisc or FCP-2 */
-	if ((vport->cfg_use_adisc && (vport->fc_flag & FC_RSCN_MODE)) ||
-	    ndlp->nlp_fcp_info & NLP_FCP_2_DEVICE) {
-		spin_lock_irq(shost->host_lock);
-		ndlp->nlp_flag |= NLP_NPR_ADISC;
-		spin_unlock_irq(shost->host_lock);
-		return 1;
+	if (!(vport->fc_flag & FC_PT2PT)) {
+		/* Check config parameter use-adisc or FCP-2 */
+		if ((vport->cfg_use_adisc && (vport->fc_flag & FC_RSCN_MODE)) ||
+		    ndlp->nlp_fcp_info & NLP_FCP_2_DEVICE) {
+			spin_lock_irq(shost->host_lock);
+			ndlp->nlp_flag |= NLP_NPR_ADISC;
+			spin_unlock_irq(shost->host_lock);
+			return 1;
+		}
 	}
 	ndlp->nlp_flag &= ~NLP_NPR_ADISC;
 	lpfc_unreg_rpi(vport, ndlp);
diff -upNr a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
--- a/drivers/scsi/lpfc/lpfc_sli.c	2008-01-14 13:06:49.000000000 -0500
+++ b/drivers/scsi/lpfc/lpfc_sli.c	2008-02-08 18:11:26.000000000 -0500
@@ -1,7 +1,7 @@
 /*******************************************************************
  * This file is part of the Emulex Linux Device Driver for         *
  * Fibre Channel Host Bus Adapters.                                *
- * Copyright (C) 2004-2007 Emulex.  All rights reserved.           *
+ * Copyright (C) 2004-2008 Emulex.  All rights reserved.           *
  * EMULEX and SLI are trademarks of Emulex.                        *
  * www.emulex.com                                                  *
  * Portions Copyright (C) 2004-2005 Christoph Hellwig              *
@@ -2404,9 +2404,7 @@ lpfc_do_config_port(struct lpfc_hba *phb
 	if ((pmb->mb.un.varCfgPort.sli_mode == 3) &&
 		(!pmb->mb.un.varCfgPort.cMA)) {
 		rc = -ENXIO;
-		goto do_prep_failed;
 	}
-	return rc;
 
 do_prep_failed:
 	mempool_free(pmb, phba->mbox_mem_pool);


