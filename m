From: Al Viro <viro@parcelfarce.linux.theplanet.co.uk>
Subject: [PATCH] initio.c NULL noise removal
Date: Fri, 22 Oct 2004 03:36:19 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20041022023619.GX24336@parcelfarce.linux.theplanet.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from parcelfarce.linux.theplanet.co.uk ([195.92.249.252]:49359 "EHLO
	www.linux.org.uk") by vger.kernel.org with ESMTP id S271148AbUJVCgW
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 21 Oct 2004 22:36:22 -0400
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: Linus Torvalds <torvalds@osdl.org>
Cc: linux-scsi@vger.kernel.org

Signed-off-by: Al Viro <viro@parcelfarce.linux.theplanet.co.uk>
----
diff -urN RC9-bk4-ncr/drivers/scsi/initio.c RC9-bk4+final/drivers/scsi/initio.c
--- RC9-bk4-ncr/drivers/scsi/initio.c	Wed Oct 20 10:56:03 2004
+++ RC9-bk4+final/drivers/scsi/initio.c	Wed Oct 20 19:17:13 2004
@@ -316,7 +316,7 @@
 /*******************************************************************
 	Use memeory refresh time        ~ 15us * 2
 ********************************************************************/
-void tul_se2_wait()
+void tul_se2_wait(void)
 {
 #if 1
 	udelay(30);
@@ -815,7 +815,7 @@
 	printk("Release SCB %lx; ", (ULONG) scbp);
 #endif
 	spin_lock_irqsave(&(hcsp->HCS_AvailLock), flags);
-	scbp->SCB_Srb = 0;
+	scbp->SCB_Srb = NULL;
 	scbp->SCB_Status = 0;
 	scbp->SCB_NxtScb = NULL;
 	if (hcsp->HCS_LastAvail != NULL) {
@@ -1231,7 +1231,7 @@
 	pScb->SCB_Target = target;
 	pScb->SCB_Mode = 0;
 
-	pScb->SCB_Srb = 0;
+	pScb->SCB_Srb = NULL;
 	if (ResetFlags & SCSI_RESET_SYNCHRONOUS) {
 		pScb->SCB_Srb = pSrb;
 	}
@@ -2535,8 +2535,8 @@
 	TCS *pCurTcb;
 	int i;
 
-	pCurHcb->HCS_ActScb = 0;
-	pCurHcb->HCS_ActTcs = 0;
+	pCurHcb->HCS_ActScb = NULL;
+	pCurHcb->HCS_ActTcs = NULL;
 	pCurHcb->HCS_Flags = 0;
 
 	while ((pCurScb = tul_pop_busy_scb(pCurHcb)) != NULL) {
