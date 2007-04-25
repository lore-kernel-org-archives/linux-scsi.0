From: James Smart <James.Smart@Emulex.Com>
Subject: [PATCH 3/16] lpfc 8.1.12 : Rework offline path to solve HBA reset
	issues
Date: Wed, 25 Apr 2007 09:51:45 -0400
Message-ID: <1177509105.23155.10.camel@localhost.localdomain>
Reply-To: James.Smart@Emulex.Com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:51549 "EHLO
	emulex.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031007AbXDYNvh (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 25 Apr 2007 09:51:37 -0400
Received: from xbl3.ad.emulex.com (xbl3.ma.emulex.com [138.239.73.12])
	by emulex.emulex.com (8.13.6/8.13.6) with ESMTP id l3PDpaDA006477
	for <linux-scsi@vger.kernel.org>; Wed, 25 Apr 2007 06:51:36 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Rework offline path to solve HBA reset issues

Signed-off-by: James Smart <James.Smart@emulex.com>


diff -upNr a/drivers/scsi/lpfc/lpfc_attr.c b/drivers/scsi/lpfc/lpfc_attr.c
--- a/drivers/scsi/lpfc/lpfc_attr.c	2007-04-24 11:12:40.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_attr.c	2007-04-24 11:12:41.000000000 -0400
@@ -20,6 +20,7 @@
  *******************************************************************/
 
 #include <linux/ctype.h>
+#include <linux/delay.h>
 #include <linux/pci.h>
 #include <linux/interrupt.h>
 
@@ -213,6 +214,7 @@ lpfc_issue_lip(struct Scsi_Host *host)
 	int mbxstatus = MBXERR_ERROR;
 
 	if ((phba->fc_flag & FC_OFFLINE_MODE) ||
+	    (phba->fc_flag & FC_BLOCK_MGMT_IO) ||
 	    (phba->hba_state != LPFC_HBA_READY))
 		return -EPERM;
 
@@ -247,19 +249,62 @@ lpfc_issue_lip(struct Scsi_Host *host)
 }
 
 static int
-lpfc_selective_reset(struct lpfc_hba *phba)
+lpfc_do_offline(struct lpfc_hba *phba, uint32_t type)
 {
 	struct completion online_compl;
+	struct lpfc_sli_ring *pring;
+	struct lpfc_sli *psli;
 	int status = 0;
+	int cnt = 0;
+	int i;
 
 	init_completion(&online_compl);
 	lpfc_workq_post_event(phba, &status, &online_compl,
-			      LPFC_EVT_OFFLINE);
+			      LPFC_EVT_OFFLINE_PREP);
 	wait_for_completion(&online_compl);
 
 	if (status != 0)
 		return -EIO;
 
+	psli = &phba->sli;
+
+	for (i = 0; i < psli->num_rings; i++) {
+		pring = &psli->ring[i];
+		/* The linkdown event takes 30 seconds to timeout. */
+		while (pring->txcmplq_cnt) {
+			msleep(10);
+			if (cnt++ > 3000) {
+				lpfc_printf_log(phba,
+					KERN_WARNING, LOG_INIT,
+					"%d:0466 Outstanding IO when "
+					"bringing Adapter offline\n",
+					phba->brd_no);
+				break;
+			}
+		}
+	}
+
+	init_completion(&online_compl);
+	lpfc_workq_post_event(phba, &status, &online_compl, type);
+	wait_for_completion(&online_compl);
+
+	if (status != 0)
+		return -EIO;
+
+	return 0;
+}
+
+static int
+lpfc_selective_reset(struct lpfc_hba *phba)
+{
+	struct completion online_compl;
+	int status = 0;
+
+	status = lpfc_do_offline(phba, LPFC_EVT_OFFLINE);
+
+	if (status != 0)
+		return status;
+
 	init_completion(&online_compl);
 	lpfc_workq_post_event(phba, &status, &online_compl,
 			      LPFC_EVT_ONLINE);
@@ -324,23 +369,19 @@ lpfc_board_mode_store(struct class_devic
 
 	init_completion(&online_compl);
 
-	if(strncmp(buf, "online", sizeof("online") - 1) == 0)
+	if(strncmp(buf, "online", sizeof("online") - 1) == 0) {
 		lpfc_workq_post_event(phba, &status, &online_compl,
 				      LPFC_EVT_ONLINE);
-	else if (strncmp(buf, "offline", sizeof("offline") - 1) == 0)
-		lpfc_workq_post_event(phba, &status, &online_compl,
-				      LPFC_EVT_OFFLINE);
+		wait_for_completion(&online_compl);
+	} else if (strncmp(buf, "offline", sizeof("offline") - 1) == 0)
+		status = lpfc_do_offline(phba, LPFC_EVT_OFFLINE);
 	else if (strncmp(buf, "warm", sizeof("warm") - 1) == 0)
-		lpfc_workq_post_event(phba, &status, &online_compl,
-				      LPFC_EVT_WARM_START);
- 	else if (strncmp(buf, "error", sizeof("error") - 1) == 0)
-		lpfc_workq_post_event(phba, &status, &online_compl,
-				      LPFC_EVT_KILL);
+		status = lpfc_do_offline(phba, LPFC_EVT_WARM_START);
+	else if (strncmp(buf, "error", sizeof("error") - 1) == 0)
+		status = lpfc_do_offline(phba, LPFC_EVT_KILL);
 	else
 		return -EINVAL;
 
-	wait_for_completion(&online_compl);
-
 	if (!status)
 		return strlen(buf);
 	else
@@ -645,9 +686,7 @@ lpfc_soft_wwpn_store(struct class_device
 	dev_printk(KERN_NOTICE, &phba->pcidev->dev,
 		   "lpfc%d: Reinitializing to use soft_wwpn\n", phba->brd_no);
 
-	init_completion(&online_compl);
-	lpfc_workq_post_event(phba, &stat1, &online_compl, LPFC_EVT_OFFLINE);
-	wait_for_completion(&online_compl);
+	stat1 = lpfc_do_offline(phba, LPFC_EVT_OFFLINE);
 	if (stat1)
 		lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
 			"%d:0463 lpfc_soft_wwpn attribute set failed to reinit "
@@ -1307,6 +1346,12 @@ sysfs_mbox_read(struct kobject *kobj, ch
 			return -EPERM;
 		}
 
+		if (phba->fc_flag & FC_BLOCK_MGMT_IO) {
+			sysfs_mbox_idle(phba);
+			spin_unlock_irq(host->host_lock);
+			return  -EAGAIN;
+		}
+
 		if ((phba->fc_flag & FC_OFFLINE_MODE) ||
 		    (!(phba->sli.sli_flag & LPFC_SLI2_ACTIVE))){
 
@@ -1551,6 +1596,9 @@ lpfc_get_stats(struct Scsi_Host *shost)
 	unsigned long seconds;
 	int rc = 0;
 
+	if (phba->fc_flag & FC_BLOCK_MGMT_IO)
+		return NULL;
+
 	pmboxq = mempool_alloc(phba->mbox_mem_pool, GFP_KERNEL);
 	if (!pmboxq)
 		return NULL;
@@ -1651,6 +1699,9 @@ lpfc_reset_stats(struct Scsi_Host *shost
 	MAILBOX_t *pmb;
 	int rc = 0;
 
+	if (phba->fc_flag & FC_BLOCK_MGMT_IO)
+		return;
+
 	pmboxq = mempool_alloc(phba->mbox_mem_pool, GFP_KERNEL);
 	if (!pmboxq)
 		return;
diff -upNr a/drivers/scsi/lpfc/lpfc_crtn.h b/drivers/scsi/lpfc/lpfc_crtn.h
--- a/drivers/scsi/lpfc/lpfc_crtn.h	2007-04-24 11:12:40.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_crtn.h	2007-04-24 11:12:41.000000000 -0400
@@ -112,7 +112,10 @@ void lpfc_hba_init(struct lpfc_hba *, ui
 int lpfc_post_buffer(struct lpfc_hba *, struct lpfc_sli_ring *, int, int);
 void lpfc_decode_firmware_rev(struct lpfc_hba *, char *, int);
 int lpfc_online(struct lpfc_hba *);
-int lpfc_offline(struct lpfc_hba *);
+void lpfc_block_mgmt_io(struct lpfc_hba *);
+void lpfc_unblock_mgmt_io(struct lpfc_hba *);
+void lpfc_offline_prep(struct lpfc_hba *);
+void lpfc_offline(struct lpfc_hba *);
 
 int lpfc_sli_setup(struct lpfc_hba *);
 int lpfc_sli_queue_setup(struct lpfc_hba *);
diff -upNr a/drivers/scsi/lpfc/lpfc_disc.h b/drivers/scsi/lpfc/lpfc_disc.h
--- a/drivers/scsi/lpfc/lpfc_disc.h	2007-03-12 13:56:16.000000000 -0500
+++ b/drivers/scsi/lpfc/lpfc_disc.h	2007-04-24 11:12:41.000000000 -0400
@@ -31,6 +31,7 @@
 /* worker thread events */
 enum lpfc_work_type {
 	LPFC_EVT_ONLINE,
+	LPFC_EVT_OFFLINE_PREP,
 	LPFC_EVT_OFFLINE,
 	LPFC_EVT_WARM_START,
 	LPFC_EVT_KILL,
diff -upNr a/drivers/scsi/lpfc/lpfc.h b/drivers/scsi/lpfc/lpfc.h
--- a/drivers/scsi/lpfc/lpfc.h	2007-04-24 11:12:40.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc.h	2007-04-24 11:12:41.000000000 -0400
@@ -244,6 +244,7 @@ struct lpfc_hba {
 #define FC_FABRIC               0x100	/* We are fabric attached */
 #define FC_ESTABLISH_LINK       0x200	/* Reestablish Link */
 #define FC_RSCN_DISCOVERY       0x400	/* Authenticate all devices after RSCN*/
+#define FC_BLOCK_MGMT_IO        0x800   /* Don't allow mgmt mbx or iocb cmds */
 #define FC_LOADING		0x1000	/* HBA in process of loading drvr */
 #define FC_UNLOADING		0x2000	/* HBA in process of unloading drvr */
 #define FC_SCSI_SCAN_TMO        0x4000	/* scsi scan timer running */
diff -upNr a/drivers/scsi/lpfc/lpfc_hbadisc.c b/drivers/scsi/lpfc/lpfc_hbadisc.c
--- a/drivers/scsi/lpfc/lpfc_hbadisc.c	2007-04-24 11:12:40.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_hbadisc.c	2007-04-24 11:12:41.000000000 -0400
@@ -185,29 +185,35 @@ lpfc_work_list_done(struct lpfc_hba * ph
 				*(int *)(evtp->evt_arg1)  = 0;
 			complete((struct completion *)(evtp->evt_arg2));
 			break;
-		case LPFC_EVT_OFFLINE:
+		case LPFC_EVT_OFFLINE_PREP:
 			if (phba->hba_state >= LPFC_LINK_DOWN)
-				lpfc_offline(phba);
+				lpfc_offline_prep(phba);
+			*(int *)(evtp->evt_arg1) = 0;
+			complete((struct completion *)(evtp->evt_arg2));
+			break;
+		case LPFC_EVT_OFFLINE:
+			lpfc_offline(phba);
 			lpfc_sli_brdrestart(phba);
 			*(int *)(evtp->evt_arg1) =
-				lpfc_sli_brdready(phba,HS_FFRDY | HS_MBRDY);
+				lpfc_sli_brdready(phba, HS_FFRDY | HS_MBRDY);
+			lpfc_unblock_mgmt_io(phba);
 			complete((struct completion *)(evtp->evt_arg2));
 			break;
 		case LPFC_EVT_WARM_START:
-			if (phba->hba_state >= LPFC_LINK_DOWN)
-				lpfc_offline(phba);
+			lpfc_offline(phba);
 			lpfc_reset_barrier(phba);
 			lpfc_sli_brdreset(phba);
 			lpfc_hba_down_post(phba);
 			*(int *)(evtp->evt_arg1) =
 				lpfc_sli_brdready(phba, HS_MBRDY);
+			lpfc_unblock_mgmt_io(phba);
 			complete((struct completion *)(evtp->evt_arg2));
 			break;
 		case LPFC_EVT_KILL:
-			if (phba->hba_state >= LPFC_LINK_DOWN)
-				lpfc_offline(phba);
+			lpfc_offline(phba);
 			*(int *)(evtp->evt_arg1)
 				= (phba->stopped) ? 0 : lpfc_sli_brdkill(phba);
+			lpfc_unblock_mgmt_io(phba);
 			complete((struct completion *)(evtp->evt_arg2));
 			break;
 		}
diff -upNr a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
--- a/drivers/scsi/lpfc/lpfc_init.c	2007-04-24 11:12:40.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_init.c	2007-04-24 11:12:41.000000000 -0400
@@ -549,12 +549,15 @@ lpfc_handle_eratt(struct lpfc_hba * phba
 		 * There was a firmware error.  Take the hba offline and then
 		 * attempt to restart it.
 		 */
+		lpfc_offline_prep(phba);
 		lpfc_offline(phba);
 		lpfc_sli_brdrestart(phba);
 		if (lpfc_online(phba) == 0) {	/* Initialize the HBA */
 			mod_timer(&phba->fc_estabtmo, jiffies + HZ * 60);
+			lpfc_unblock_mgmt_io(phba);
 			return;
 		}
+		lpfc_unblock_mgmt_io(phba);
 	} else {
 		/* The if clause above forces this code path when the status
 		 * failure is a value other than FFER6.  Do not call the offline
@@ -572,7 +575,9 @@ lpfc_handle_eratt(struct lpfc_hba * phba
 				SCSI_NL_VID_TYPE_PCI | PCI_VENDOR_ID_EMULEX);
 
 		psli->sli_flag &= ~LPFC_SLI2_ACTIVE;
+		lpfc_offline_prep(phba);
 		lpfc_offline(phba);
+		lpfc_unblock_mgmt_io(phba);
 		phba->hba_state = LPFC_HBA_ERROR;
 		lpfc_hba_down_post(phba);
 	}
@@ -1286,55 +1291,87 @@ lpfc_online(struct lpfc_hba * phba)
 		       "%d:0458 Bring Adapter online\n",
 		       phba->brd_no);
 
-	if (!lpfc_sli_queue_setup(phba))
+	lpfc_block_mgmt_io(phba);
+
+	if (!lpfc_sli_queue_setup(phba)) {
+		lpfc_unblock_mgmt_io(phba);
 		return 1;
+	}
 
-	if (lpfc_sli_hba_setup(phba))	/* Initialize the HBA */
+	if (lpfc_sli_hba_setup(phba)) {	/* Initialize the HBA */
+		lpfc_unblock_mgmt_io(phba);
 		return 1;
+	}
 
 	spin_lock_irq(phba->host->host_lock);
 	phba->fc_flag &= ~FC_OFFLINE_MODE;
 	spin_unlock_irq(phba->host->host_lock);
 
+	lpfc_unblock_mgmt_io(phba);
 	return 0;
 }
 
-int
-lpfc_offline(struct lpfc_hba * phba)
+void
+lpfc_block_mgmt_io(struct lpfc_hba * phba)
 {
-	struct lpfc_sli_ring *pring;
-	struct lpfc_sli *psli;
 	unsigned long iflag;
-	int i;
-	int cnt = 0;
 
-	if (!phba)
-		return 0;
+	spin_lock_irqsave(phba->host->host_lock, iflag);
+	phba->fc_flag |= FC_BLOCK_MGMT_IO;
+	spin_unlock_irqrestore(phba->host->host_lock, iflag);
+}
+
+void
+lpfc_unblock_mgmt_io(struct lpfc_hba * phba)
+{
+	unsigned long iflag;
+
+	spin_lock_irqsave(phba->host->host_lock, iflag);
+	phba->fc_flag &= ~FC_BLOCK_MGMT_IO;
+	spin_unlock_irqrestore(phba->host->host_lock, iflag);
+}
+
+void
+lpfc_offline_prep(struct lpfc_hba * phba)
+{
+	struct lpfc_nodelist  *ndlp, *next_ndlp;
+	struct list_head *listp, *node_list[7];
+	int i;
 
 	if (phba->fc_flag & FC_OFFLINE_MODE)
-		return 0;
+		return;
 
-	psli = &phba->sli;
+	lpfc_block_mgmt_io(phba);
 
 	lpfc_linkdown(phba);
-	lpfc_sli_flush_mbox_queue(phba);
 
-	for (i = 0; i < psli->num_rings; i++) {
-		pring = &psli->ring[i];
-		/* The linkdown event takes 30 seconds to timeout. */
-		while (pring->txcmplq_cnt) {
-			msleep(10);
-			if (cnt++ > 3000) {
-				lpfc_printf_log(phba,
-					KERN_WARNING, LOG_INIT,
-					"%d:0466 Outstanding IO when "
-					"bringing Adapter offline\n",
-					phba->brd_no);
-				break;
-			}
-		}
+	/* Issue an unreg_login to all nodes */
+	node_list[0] = &phba->fc_npr_list;  /* MUST do this list first */
+	node_list[1] = &phba->fc_nlpmap_list;
+	node_list[2] = &phba->fc_nlpunmap_list;
+	node_list[3] = &phba->fc_prli_list;
+	node_list[4] = &phba->fc_reglogin_list;
+	node_list[5] = &phba->fc_adisc_list;
+	node_list[6] = &phba->fc_plogi_list;
+	for (i = 0; i < 7; i++) {
+		listp = node_list[i];
+		if (list_empty(listp))
+			continue;
+
+		list_for_each_entry_safe(ndlp, next_ndlp, listp, nlp_listp)
+			lpfc_unreg_rpi(phba, ndlp);
 	}
 
+	lpfc_sli_flush_mbox_queue(phba);
+}
+
+void
+lpfc_offline(struct lpfc_hba * phba)
+{
+	unsigned long iflag;
+
+	if (phba->fc_flag & FC_OFFLINE_MODE)
+		return;
 
 	/* stop all timers associated with this hba */
 	lpfc_stop_timer(phba);
@@ -1354,7 +1391,6 @@ lpfc_offline(struct lpfc_hba * phba)
 	spin_lock_irqsave(phba->host->host_lock, iflag);
 	phba->fc_flag |= FC_OFFLINE_MODE;
 	spin_unlock_irqrestore(phba->host->host_lock, iflag);
-	return 0;
 }
 
 /******************************************************************************


