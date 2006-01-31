From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH] lpfc: mutex conversion
Date: Tue, 31 Jan 2006 18:17:16 +0100
Message-ID: <20060131171716.GC28889@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.210]:27825 "EHLO mail.lst.de")
	by vger.kernel.org with ESMTP id S1751281AbWAaRRY (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 31 Jan 2006 12:17:24 -0500
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: james.smart@emulex.com, jejb@steeleye.com
Cc: linux-scsi@vger.kernel.org

switch lpfc from semaphore to mutex locking


Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: linux-2.6/drivers/scsi/lpfc/lpfc.h
===================================================================
--- linux-2.6.orig/drivers/scsi/lpfc/lpfc.h	2006-01-06 12:51:02.000000000 +0100
+++ linux-2.6/drivers/scsi/lpfc/lpfc.h	2006-01-31 14:09:46.000000000 +0100
@@ -173,7 +173,7 @@
 	dma_addr_t slim2p_mapping;
 	uint16_t pci_cfg_value;
 
-	struct semaphore hba_can_block;
+	struct mutex hba_can_block;
 	uint32_t hba_state;
 
 #define LPFC_INIT_START           1	/* Initial state after board reset */
Index: linux-2.6/drivers/scsi/lpfc/lpfc_init.c
===================================================================
--- linux-2.6.orig/drivers/scsi/lpfc/lpfc_init.c	2006-01-06 12:51:02.000000000 +0100
+++ linux-2.6/drivers/scsi/lpfc/lpfc_init.c	2006-01-31 14:10:09.000000000 +0100
@@ -1393,7 +1393,7 @@
 		goto out_put_host;
 
 	host->unique_id = phba->brd_no;
-	init_MUTEX(&phba->hba_can_block);
+	mutex_init(&phba->hba_can_block);
 	INIT_LIST_HEAD(&phba->ctrspbuflist);
 	INIT_LIST_HEAD(&phba->rnidrspbuflist);
 	INIT_LIST_HEAD(&phba->freebufList);
Index: linux-2.6/drivers/scsi/lpfc/lpfc_scsi.c
===================================================================
--- linux-2.6.orig/drivers/scsi/lpfc/lpfc_scsi.c	2006-01-31 12:23:38.000000000 +0100
+++ linux-2.6/drivers/scsi/lpfc/lpfc_scsi.c	2006-01-31 14:10:01.000000000 +0100
@@ -44,7 +44,7 @@
 static inline void
 lpfc_block_requests(struct lpfc_hba * phba)
 {
-	down(&phba->hba_can_block);
+	mutex_lock(&phba->hba_can_block);
 	scsi_block_requests(phba->host);
 }
 
@@ -52,7 +52,7 @@
 lpfc_unblock_requests(struct lpfc_hba * phba)
 {
 	scsi_unblock_requests(phba->host);
-	up(&phba->hba_can_block);
+	mutex_unlock(&phba->hba_can_block);
 }
 
 /*
