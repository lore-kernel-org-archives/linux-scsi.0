From: James Smart <james.smart@emulex.com>
Subject: [PATCH 1/7] lpfc 8.3.10: Fix Initialization issues
Date: Fri, 26 Feb 2010 14:12:57 -0500
Message-ID: <1267211597.3372.1.camel@wookie>
Reply-To: james.smart@emulex.com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from exht1.emulex.com ([138.239.113.183]:4809 "EHLO
	exht1.ad.emulex.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S965792Ab0BZTNm (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 26 Feb 2010 14:13:42 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


- Add NULL checks to the pointers for the config_async mailbox
  and dump_wakeup_params mailbox.
- Add code to check return value of lpfc_read_sparams everywhere
  and handle failures appropriately.


 Signed-off-by: James Smart <james.smart@emulex.com>

 ---

 lpfc_hbadisc.c |   32 ++++++++++++++++++--------------
 lpfc_init.c    |   19 +++++++++++++++++--
 lpfc_sli.c     |    8 +++++++-
 lpfc_vport.c   |    7 ++++++-
 4 files changed, 48 insertions(+), 18 deletions(-)


diff -upNr a/drivers/scsi/lpfc/lpfc_hbadisc.c b/drivers/scsi/lpfc/lpfc_hbadisc.c
--- a/drivers/scsi/lpfc/lpfc_hbadisc.c	2010-02-21 10:49:13.000000000 -0500
+++ b/drivers/scsi/lpfc/lpfc_hbadisc.c	2010-02-25 16:33:09.000000000 -0500
@@ -2024,8 +2024,6 @@ lpfc_mbx_process_link_up(struct lpfc_hba
 	int rc;
 	struct fcf_record *fcf_record;
 
-	sparam_mbox = mempool_alloc(phba->mbox_mem_pool, GFP_KERNEL);
-
 	spin_lock_irq(&phba->hbalock);
 	switch (la->UlnkSpeed) {
 	case LA_1GHZ_LINK:
@@ -2117,18 +2115,24 @@ lpfc_mbx_process_link_up(struct lpfc_hba
 	spin_unlock_irq(&phba->hbalock);
 
 	lpfc_linkup(phba);
-	if (sparam_mbox) {
-		lpfc_read_sparam(phba, sparam_mbox, 0);
-		sparam_mbox->vport = vport;
-		sparam_mbox->mbox_cmpl = lpfc_mbx_cmpl_read_sparam;
-		rc = lpfc_sli_issue_mbox(phba, sparam_mbox, MBX_NOWAIT);
-		if (rc == MBX_NOT_FINISHED) {
-			mp = (struct lpfc_dmabuf *) sparam_mbox->context1;
-			lpfc_mbuf_free(phba, mp->virt, mp->phys);
-			kfree(mp);
-			mempool_free(sparam_mbox, phba->mbox_mem_pool);
-			goto out;
-		}
+	sparam_mbox = mempool_alloc(phba->mbox_mem_pool, GFP_KERNEL);
+	if (!sparam_mbox)
+		goto out;
+
+	rc = lpfc_read_sparam(phba, sparam_mbox, 0);
+	if (rc) {
+		mempool_free(sparam_mbox, phba->mbox_mem_pool);
+		goto out;
+	}
+	sparam_mbox->vport = vport;
+	sparam_mbox->mbox_cmpl = lpfc_mbx_cmpl_read_sparam;
+	rc = lpfc_sli_issue_mbox(phba, sparam_mbox, MBX_NOWAIT);
+	if (rc == MBX_NOT_FINISHED) {
+		mp = (struct lpfc_dmabuf *) sparam_mbox->context1;
+		lpfc_mbuf_free(phba, mp->virt, mp->phys);
+		kfree(mp);
+		mempool_free(sparam_mbox, phba->mbox_mem_pool);
+		goto out;
 	}
 
 	if (!(phba->hba_flag & HBA_FCOE_SUPPORT)) {
diff -upNr a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
--- a/drivers/scsi/lpfc/lpfc_init.c	2010-02-21 10:49:13.000000000 -0500
+++ b/drivers/scsi/lpfc/lpfc_init.c	2010-02-25 16:33:09.000000000 -0500
@@ -350,7 +350,12 @@ lpfc_config_port_post(struct lpfc_hba *p
 	mb = &pmb->u.mb;
 
 	/* Get login parameters for NID.  */
-	lpfc_read_sparam(phba, pmb, 0);
+	rc = lpfc_read_sparam(phba, pmb, 0);
+	if (rc) {
+		mempool_free(pmb, phba->mbox_mem_pool);
+		return -ENOMEM;
+	}
+
 	pmb->vport = vport;
 	if (lpfc_sli_issue_mbox(phba, pmb, MBX_POLL) != MBX_SUCCESS) {
 		lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
@@ -359,7 +364,7 @@ lpfc_config_port_post(struct lpfc_hba *p
 				mb->mbxCommand, mb->mbxStatus);
 		phba->link_state = LPFC_HBA_ERROR;
 		mp = (struct lpfc_dmabuf *) pmb->context1;
-		mempool_free( pmb, phba->mbox_mem_pool);
+		mempool_free(pmb, phba->mbox_mem_pool);
 		lpfc_mbuf_free(phba, mp->virt, mp->phys);
 		kfree(mp);
 		return -EIO;
@@ -571,6 +576,11 @@ lpfc_config_port_post(struct lpfc_hba *p
 	}
 	/* MBOX buffer will be freed in mbox compl */
 	pmb = mempool_alloc(phba->mbox_mem_pool, GFP_KERNEL);
+	if (!pmb) {
+		phba->link_state = LPFC_HBA_ERROR;
+		return -ENOMEM;
+	}
+
 	lpfc_config_async(phba, pmb, LPFC_ELS_RING);
 	pmb->mbox_cmpl = lpfc_config_async_cmpl;
 	pmb->vport = phba->pport;
@@ -588,6 +598,11 @@ lpfc_config_port_post(struct lpfc_hba *p
 
 	/* Get Option rom version */
 	pmb = mempool_alloc(phba->mbox_mem_pool, GFP_KERNEL);
+	if (!pmb) {
+		phba->link_state = LPFC_HBA_ERROR;
+		return -ENOMEM;
+	}
+
 	lpfc_dump_wakeup_param(phba, pmb);
 	pmb->mbox_cmpl = lpfc_dump_wakeup_param_cmpl;
 	pmb->vport = phba->pport;
diff -upNr a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
--- a/drivers/scsi/lpfc/lpfc_sli.c	2010-02-21 10:49:13.000000000 -0500
+++ b/drivers/scsi/lpfc/lpfc_sli.c	2010-02-25 16:33:09.000000000 -0500
@@ -4388,7 +4388,13 @@ lpfc_sli4_hba_setup(struct lpfc_hba *phb
 	spin_unlock_irq(&phba->hbalock);
 
 	/* Read the port's service parameters. */
-	lpfc_read_sparam(phba, mboxq, vport->vpi);
+	rc = lpfc_read_sparam(phba, mboxq, vport->vpi);
+	if (rc) {
+		phba->link_state = LPFC_HBA_ERROR;
+		rc = -ENOMEM;
+		goto out_free_vpd;
+	}
+
 	mboxq->vport = vport;
 	rc = lpfc_sli_issue_mbox(phba, mboxq, MBX_POLL);
 	mp = (struct lpfc_dmabuf *) mboxq->context1;
diff -upNr a/drivers/scsi/lpfc/lpfc_vport.c b/drivers/scsi/lpfc/lpfc_vport.c
--- a/drivers/scsi/lpfc/lpfc_vport.c	2010-02-21 10:49:13.000000000 -0500
+++ b/drivers/scsi/lpfc/lpfc_vport.c	2010-02-25 16:33:09.000000000 -0500
@@ -123,7 +123,12 @@ lpfc_vport_sparm(struct lpfc_hba *phba, 
 	}
 	mb = &pmb->u.mb;
 
-	lpfc_read_sparam(phba, pmb, vport->vpi);
+	rc = lpfc_read_sparam(phba, pmb, vport->vpi);
+	if (rc) {
+		mempool_free(pmb, phba->mbox_mem_pool);
+		return -ENOMEM;
+	}
+
 	/*
 	 * Grab buffer pointer and clear context1 so we can use
 	 * lpfc_sli_issue_box_wait


