From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: PATCH: Quieten sparse on lpfc driver
Date: Thu, 15 Jun 2006 16:40:46 +0100
Message-ID: <1150386046.3490.94.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:5830 "EHLO
	lxorguk.ukuu.org.uk") by vger.kernel.org with ESMTP
	id S1030669AbWFOPYU (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 15 Jun 2006 11:24:20 -0400
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by lxorguk.ukuu.org.uk (8.13.6/8.13.4) with ESMTP id k5FFekX0006368
	for <linux-scsi@vger.kernel.org>; Thu, 15 Jun 2006 16:40:46 +0100
Received: (from alan@localhost)
	by localhost.localdomain (8.13.6/8.13.6/Submit) id k5FFekdh006367
	for linux-scsi@vger.kernel.org; Thu, 15 Jun 2006 16:40:46 +0100
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

No actual bugs I can see just labelling needed and 0/NULL fixes

Signed-off-by: Alan Cox <alan@redhat.com>

diff -u --new-file --recursive --exclude-from /usr/src/exclude linux.vanilla-2.6.17-rc6/drivers/scsi/lpfc/lpfc_els.c linux-2.6.17-rc6/drivers/scsi/lpfc/lpfc_els.c
--- linux.vanilla-2.6.17-rc6/drivers/scsi/lpfc/lpfc_els.c	2006-06-06 14:01:13.000000000 +0100
+++ linux-2.6.17-rc6/drivers/scsi/lpfc/lpfc_els.c	2006-06-15 12:39:40.265287136 +0100
@@ -821,7 +821,7 @@
 	pring = &psli->ring[LPFC_ELS_RING];	/* ELS ring */
 
 	cmdsize = (sizeof (uint32_t) + sizeof (struct serv_parm));
-	elsiocb = lpfc_prep_els_iocb(phba, 1, cmdsize, retry, 0, did,
+	elsiocb = lpfc_prep_els_iocb(phba, 1, cmdsize, retry, NULL, did,
 								ELS_CMD_PLOGI);
 	if (!elsiocb)
 		return 1;
@@ -2791,8 +2791,8 @@
 
 	ndlp = (struct lpfc_nodelist *) pmb->context2;
 	xri = (uint16_t) ((unsigned long)(pmb->context1));
-	pmb->context1 = 0;
-	pmb->context2 = 0;
+	pmb->context1 = NULL;
+	pmb->context2 = NULL;
 
 	if (mb->mbxStatus) {
 		mempool_free( pmb, phba->mbox_mem_pool);
diff -u --new-file --recursive --exclude-from /usr/src/exclude linux.vanilla-2.6.17-rc6/drivers/scsi/lpfc/lpfc_init.c linux-2.6.17-rc6/drivers/scsi/lpfc/lpfc_init.c
--- linux.vanilla-2.6.17-rc6/drivers/scsi/lpfc/lpfc_init.c	2006-06-06 14:01:13.000000000 +0100
+++ linux-2.6.17-rc6/drivers/scsi/lpfc/lpfc_init.c	2006-06-15 12:40:25.471414760 +0100
@@ -939,12 +939,12 @@
 					"10-port ", "PCIe"};
 			break;
 		default:
-			m = (typeof(m)){ 0 };
+			m = (typeof(m)){ NULL };
 			break;
 		}
 		break;
 	default:
-		m = (typeof(m)){ 0 };
+		m = (typeof(m)){ NULL };
 		break;
 	}
 
diff -u --new-file --recursive --exclude-from /usr/src/exclude linux.vanilla-2.6.17-rc6/drivers/scsi/lpfc/lpfc_sli.c linux-2.6.17-rc6/drivers/scsi/lpfc/lpfc_sli.c
--- linux.vanilla-2.6.17-rc6/drivers/scsi/lpfc/lpfc_sli.c	2006-06-06 14:01:13.000000000 +0100
+++ linux-2.6.17-rc6/drivers/scsi/lpfc/lpfc_sli.c	2006-06-15 12:35:31.548097896 +0100
@@ -1570,8 +1570,8 @@
 
 void lpfc_reset_barrier(struct lpfc_hba * phba)
 {
-	uint32_t * resp_buf;
-	uint32_t * mbox_buf;
+	uint32_t __iomem *resp_buf;
+	uint32_t __iomem *mbox_buf;
 	volatile uint32_t mbox;
 	uint32_t hc_copy;
 	int  i;
@@ -1587,7 +1587,7 @@
 	 * Tell the other part of the chip to suspend temporarily all
 	 * its DMA activity.
 	 */
-	resp_buf =  (uint32_t *)phba->MBslimaddr;
+	resp_buf =  (uint32_t __iomem *)phba->MBslimaddr;
 
 	/* Disable the error attention */
 	hc_copy = readl(phba->HCregaddr);
@@ -1605,7 +1605,7 @@
 	((MAILBOX_t *)&mbox)->mbxOwner = OWN_CHIP;
 
 	writel(BARRIER_TEST_PATTERN, (resp_buf + 1));
-	mbox_buf = (uint32_t *)phba->MBslimaddr;
+	mbox_buf = (uint32_t __iomem *)phba->MBslimaddr;
 	writel(mbox, mbox_buf);
 
 	for (i = 0;
@@ -1805,7 +1805,7 @@
 		skip_post = 0;
 		word0 = 0;	/* This is really setting up word1 */
 	}
-	to_slim = (uint8_t *) phba->MBslimaddr + sizeof (uint32_t);
+	to_slim = (uint8_t __iomem *) phba->MBslimaddr + sizeof (uint32_t);
 	writel(*(uint32_t *) mb, to_slim);
 	readl(to_slim); /* flush */
 

