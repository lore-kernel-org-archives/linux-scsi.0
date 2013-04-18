From: James Smart <james.smart@emulex.com>
Subject: [PATCH 1/22] lpfc 8.3.39: Fixed VPI allocation issues after
 firmware dump is performed
Date: Wed, 17 Apr 2013 20:14:38 -0400
Message-ID: <1366244078.1513.1.camel@myfc17>
Reply-To: <james.smart@emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cmexedge2.ext.emulex.com ([138.239.224.100]:24282 "EHLO
	CMEXEDGE2.ext.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753752Ab3DRAOm (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 17 Apr 2013 20:14:42 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Fixed VPI allocation issues after firmware dump is performed


Signed-off-by: James Smart <james.smart@emulex.com>

 ---

 lpfc_hbadisc.c |   14 +++++++++++++-
 lpfc_init.c    |   12 +++++++++++-
 lpfc_sli.c     |    2 ++
 lpfc_vport.c   |   25 ++++++++++++++++++++++++-
 lpfc_vport.h   |    1 +
 5 files changed, 51 insertions(+), 3 deletions(-)


diff -upNr a/drivers/scsi/lpfc/lpfc_hbadisc.c b/drivers/scsi/lpfc/lpfc_hbadisc.c
--- a/drivers/scsi/lpfc/lpfc_hbadisc.c	2013-04-10 16:46:40.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_hbadisc.c	2013-04-15 18:26:14.814040614 -0400
@@ -2796,7 +2796,19 @@ void
 lpfc_issue_init_vpi(struct lpfc_vport *vport)
 {
 	LPFC_MBOXQ_t *mboxq;
-	int rc;
+	int rc, vpi;
+
+	if ((vport->port_type != LPFC_PHYSICAL_PORT) && (!vport->vpi)) {
+		vpi = lpfc_alloc_vpi(vport->phba);
+		if (!vpi) {
+			lpfc_printf_vlog(vport, KERN_ERR,
+					 LOG_MBOX,
+					 "3303 Failed to obtain vport vpi\n");
+			lpfc_vport_set_state(vport, FC_VPORT_FAILED);
+			return;
+		}
+		vport->vpi = vpi;
+	}
 
 	mboxq = mempool_alloc(vport->phba->mbox_mem_pool, GFP_KERNEL);
 	if (!mboxq) {
diff -upNr a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
--- a/drivers/scsi/lpfc/lpfc_init.c	2013-04-10 16:46:40.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_init.c	2013-04-15 18:26:14.875040617 -0400
@@ -2633,6 +2633,7 @@ lpfc_online(struct lpfc_hba *phba)
 	struct lpfc_vport *vport;
 	struct lpfc_vport **vports;
 	int i;
+	bool vpis_cleared = false;
 
 	if (!phba)
 		return 0;
@@ -2656,6 +2657,10 @@ lpfc_online(struct lpfc_hba *phba)
 			lpfc_unblock_mgmt_io(phba);
 			return 1;
 		}
+		spin_lock_irq(&phba->hbalock);
+		if (!phba->sli4_hba.max_cfg_param.vpi_used)
+			vpis_cleared = true;
+		spin_unlock_irq(&phba->hbalock);
 	} else {
 		if (lpfc_sli_hba_setup(phba)) {	/* Initialize SLI2/SLI3 HBA */
 			lpfc_unblock_mgmt_io(phba);
@@ -2672,8 +2677,13 @@ lpfc_online(struct lpfc_hba *phba)
 			vports[i]->fc_flag &= ~FC_OFFLINE_MODE;
 			if (phba->sli3_options & LPFC_SLI3_NPIV_ENABLED)
 				vports[i]->fc_flag |= FC_VPORT_NEEDS_REG_VPI;
-			if (phba->sli_rev == LPFC_SLI_REV4)
+			if (phba->sli_rev == LPFC_SLI_REV4) {
 				vports[i]->fc_flag |= FC_VPORT_NEEDS_INIT_VPI;
+				if ((vpis_cleared) &&
+				    (vports[i]->port_type !=
+					LPFC_PHYSICAL_PORT))
+					vports[i]->vpi = 0;
+			}
 			spin_unlock_irq(shost->host_lock);
 		}
 		lpfc_destroy_vport_work_array(phba, vports);
diff -upNr a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
--- a/drivers/scsi/lpfc/lpfc_sli.c	2013-04-10 16:46:40.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_sli.c	2013-04-15 18:26:14.915040617 -0400
@@ -5510,6 +5510,7 @@ lpfc_sli4_dealloc_extent(struct lpfc_hba
 			list_del_init(&rsrc_blk->list);
 			kfree(rsrc_blk);
 		}
+		phba->sli4_hba.max_cfg_param.vpi_used = 0;
 		break;
 	case LPFC_RSC_TYPE_FCOE_XRI:
 		kfree(phba->sli4_hba.xri_bmask);
@@ -5810,6 +5811,7 @@ lpfc_sli4_dealloc_resource_identifiers(s
 		lpfc_sli4_dealloc_extent(phba, LPFC_RSC_TYPE_FCOE_VFI);
 	} else {
 		kfree(phba->vpi_bmask);
+		phba->sli4_hba.max_cfg_param.vpi_used = 0;
 		kfree(phba->vpi_ids);
 		bf_set(lpfc_vpi_rsrc_rdy, &phba->sli4_hba.sli4_flags, 0);
 		kfree(phba->sli4_hba.xri_bmask);
diff -upNr a/drivers/scsi/lpfc/lpfc_vport.c b/drivers/scsi/lpfc/lpfc_vport.c
--- a/drivers/scsi/lpfc/lpfc_vport.c	2013-04-10 16:30:14.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_vport.c	2013-04-15 18:26:14.955040617 -0400
@@ -80,7 +80,7 @@ inline void lpfc_vport_set_state(struct
 	}
 }
 
-static int
+int
 lpfc_alloc_vpi(struct lpfc_hba *phba)
 {
 	unsigned long vpi;
@@ -568,6 +568,7 @@ lpfc_vport_delete(struct fc_vport *fc_vp
 	struct lpfc_vport *vport = *(struct lpfc_vport **)fc_vport->dd_data;
 	struct lpfc_hba   *phba = vport->phba;
 	long timeout;
+	bool ns_ndlp_referenced = false;
 
 	if (vport->port_type == LPFC_PHYSICAL_PORT) {
 		lpfc_printf_vlog(vport, KERN_ERR, LOG_VPORT,
@@ -628,6 +629,18 @@ lpfc_vport_delete(struct fc_vport *fc_vp
 
 	lpfc_debugfs_terminate(vport);
 
+	/*
+	 * The call to fc_remove_host might release the NameServer ndlp. Since
+	 * we might need to use the ndlp to send the DA_ID CT command,
+	 * increment the reference for the NameServer ndlp to prevent it from
+	 * being released.
+	 */
+	ndlp = lpfc_findnode_did(vport, NameServer_DID);
+	if (ndlp && NLP_CHK_NODE_ACT(ndlp)) {
+		lpfc_nlp_get(ndlp);
+		ns_ndlp_referenced = true;
+	}
+
 	/* Remove FC host and then SCSI host with the vport */
 	fc_remove_host(lpfc_shost_from_vport(vport));
 	scsi_remove_host(lpfc_shost_from_vport(vport));
@@ -734,6 +747,16 @@ lpfc_vport_delete(struct fc_vport *fc_vp
 		lpfc_discovery_wait(vport);
 
 skip_logo:
+
+	/*
+	 * If the NameServer ndlp has been incremented to allow the DA_ID CT
+	 * command to be sent, decrement the ndlp now.
+	 */
+	if (ns_ndlp_referenced) {
+		ndlp = lpfc_findnode_did(vport, NameServer_DID);
+		lpfc_nlp_put(ndlp);
+	}
+
 	lpfc_cleanup(vport);
 	lpfc_sli_host_down(vport);
 
diff -upNr a/drivers/scsi/lpfc/lpfc_vport.h b/drivers/scsi/lpfc/lpfc_vport.h
--- a/drivers/scsi/lpfc/lpfc_vport.h	2013-04-10 16:30:14.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_vport.h	2013-04-15 18:26:14.959040618 -0400
@@ -90,6 +90,7 @@ int lpfc_vport_getinfo(struct Scsi_Host
 int lpfc_vport_tgt_remove(struct Scsi_Host *, uint, uint);
 struct lpfc_vport **lpfc_create_vport_work_array(struct lpfc_hba *);
 void lpfc_destroy_vport_work_array(struct lpfc_hba *, struct lpfc_vport **);
+int lpfc_alloc_vpi(struct lpfc_hba *phba);
 
 /*
  *  queuecommand  VPORT-specific return codes. Specified in  the host byte code.



