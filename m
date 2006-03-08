From: James Smart <James.Smart@Emulex.Com>
Subject: [PATCH Repost 2/2] Block I/O while SG reset operation in progress
	- lpfc portion
Date: Wed, 08 Mar 2006 14:50:18 -0500
Message-ID: <1141847418.28879.7.camel@localhost.localdomain>
Reply-To: James.Smart@Emulex.Com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:4853 "EHLO emulex.emulex.com")
	by vger.kernel.org with ESMTP id S932208AbWCHTuV (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 8 Mar 2006 14:50:21 -0500
Received: from xbl3.ad.emulex.com (xbl3.ma.emulex.com [138.239.73.12])
	by emulex.emulex.com (8.12.10/8.12.10) with ESMTP id k28JoJrf005045
	for <linux-scsi@vger.kernel.org>; Wed, 8 Mar 2006 11:50:20 -0800 (PST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


This removes the duplicate functionality which had been added to
the lpfc driver.

Signed-off-by: James Smart <James.Smart@emulex.com>

diff -upNr a/lpfc.h b/lpfc.h
--- a/lpfc.h	2006-02-23 09:43:02.000000000 -0500
+++ b/lpfc.h	2006-02-23 09:58:23.000000000 -0500
@@ -176,7 +176,6 @@ struct lpfc_hba {
 	dma_addr_t slim2p_mapping;
 	uint16_t pci_cfg_value;
 
-	struct semaphore hba_can_block;
 	int32_t hba_state;
 
 #define LPFC_STATE_UNKNOWN        0    /* HBA state is unknown */
diff -upNr a/lpfc_init.c b/lpfc_init.c
--- a/lpfc_init.c	2006-02-23 09:43:02.000000000 -0500
+++ b/lpfc_init.c	2006-02-23 09:58:31.000000000 -0500
@@ -1463,7 +1463,6 @@ lpfc_pci_probe_one(struct pci_dev *pdev,
 		goto out_put_host;
 
 	host->unique_id = phba->brd_no;
-	init_MUTEX(&phba->hba_can_block);
 	INIT_LIST_HEAD(&phba->ctrspbuflist);
 	INIT_LIST_HEAD(&phba->rnidrspbuflist);
 	INIT_LIST_HEAD(&phba->freebufList);
diff -upNr a/lpfc_scsi.c b/lpfc_scsi.c
--- a/lpfc_scsi.c	2006-02-23 09:43:02.000000000 -0500
+++ b/lpfc_scsi.c	2006-02-23 09:58:41.000000000 -0500
@@ -41,20 +41,6 @@
 #define LPFC_ABORT_WAIT  2
 

-static inline void
-lpfc_block_requests(struct lpfc_hba * phba)
-{
-	down(&phba->hba_can_block);
-	scsi_block_requests(phba->host);
-}
-
-static inline void
-lpfc_unblock_requests(struct lpfc_hba * phba)
-{
-	scsi_unblock_requests(phba->host);
-	up(&phba->hba_can_block);
-}
-
 /*
  * This routine allocates a scsi buffer, which contains all the necessary
  * information needed to initiate a SCSI I/O.  The non-DMAable buffer region
@@ -891,7 +877,6 @@ lpfc_abort_handler(struct scsi_cmnd *cmn
 	unsigned int loop_count = 0;
 	int ret = SUCCESS;
 
-	lpfc_block_requests(phba);
 	spin_lock_irq(shost->host_lock);
 
 	lpfc_cmd = (struct lpfc_scsi_buf *)cmnd->host_scribble;
@@ -977,7 +962,6 @@ lpfc_abort_handler(struct scsi_cmnd *cmn
 			cmnd->device->lun, cmnd->serial_number);
 
 	spin_unlock_irq(shost->host_lock);
-	lpfc_unblock_requests(phba);
 
 	return ret;
 }
@@ -995,7 +979,6 @@ lpfc_reset_lun_handler(struct scsi_cmnd 
 	int ret = FAILED;
 	int cnt, loopcnt;
 
-	lpfc_block_requests(phba);
 	spin_lock_irq(shost->host_lock);
 	/*
 	 * If target is not in a MAPPED state, delay the reset until
@@ -1091,7 +1074,6 @@ out_free_scsi_buf:
 
 out:
 	spin_unlock_irq(shost->host_lock);
-	lpfc_unblock_requests(phba);
 	return ret;
 }
 
@@ -1107,7 +1089,6 @@ lpfc_reset_bus_handler(struct scsi_cmnd 
 	unsigned int midlayer_id = 0;
 	struct lpfc_scsi_buf * lpfc_cmd;
 
-	lpfc_block_requests(phba);
 	spin_lock_irq(shost->host_lock);
 
 	lpfc_cmd = lpfc_get_scsi_buf(phba);
@@ -1193,7 +1174,6 @@ lpfc_reset_bus_handler(struct scsi_cmnd 
 			phba->brd_no, ret);
 out:
 	spin_unlock_irq(shost->host_lock);
-	lpfc_unblock_requests(phba);
 	return ret;
 }
 


