From: Mike Christie <mikenc@us.ibm.com>
Subject: [patch] [resend] fixes compile error in inia100.c
Date: Mon, 16 Jun 2003 16:31:31 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3EEE5353.6080500@us.ibm.com>
Reply-To: mikenc@us.ibm.com
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------020606020100060908080002"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e6.ny.us.ibm.com ([32.97.182.106]:60911 "EHLO e6.ny.us.ibm.com")
	by vger.kernel.org with ESMTP id S264449AbTFPXRi (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 16 Jun 2003 19:17:38 -0400
Received: from northrelay02.pok.ibm.com (northrelay02.pok.ibm.com [9.56.224.150])
	by e6.ny.us.ibm.com (8.12.9/8.12.2) with ESMTP id h5GNVWxr136468
	for <linux-scsi@vger.kernel.org>; Mon, 16 Jun 2003 19:31:32 -0400
Received: from us.ibm.com (d01av02.pok.ibm.com [9.56.224.216])
	by northrelay02.pok.ibm.com (8.12.9/NCO/VER6.5) with ESMTP id h5GNVVHO032688
	for <linux-scsi@vger.kernel.org>; Mon, 16 Jun 2003 19:31:32 -0400
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

This is a multi-part message in MIME format.
--------------020606020100060908080002
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit

The attached patch fixes the compile errors in inia100.c described in
Bugzilla bug #345 at http://bugme.osdl.org/show_bug.cgi?id=345. It was
built against 2.5.71. I do not have the hardware, so I have only
verified that it compiles correctly.

Mike Christie
mikenc@us.ibm.com


inia100.c |    8 ++++----
1 files changed, 4 insertions(+), 4 deletions(-)


--------------020606020100060908080002
Content-Type: text/plain;
 name="inia100.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="inia100.patch"

--- linux-2.5.71/drivers/scsi/inia100.c	Sat Jun 14 12:18:06 2003
+++ linux-2.5.71_test/drivers/scsi/inia100.c	Mon Jun 16 15:48:22 2003
@@ -156,11 +156,11 @@
 
 	spin_lock_irqsave(&(pHCB->pSRB_lock), flags);
 
-	pSRB->next = NULL;	/* Pointer to next */
+	pSRB->SCp.ptr = NULL;	/* Pointer to next */
 	if (pHCB->pSRB_head == NULL)
 		pHCB->pSRB_head = pSRB;
 	else
-		pHCB->pSRB_tail->next = pSRB;	/* Pointer to next */
+		pHCB->pSRB_tail->SCp.ptr = (char *)pSRB;	/* Pointer to next */
 	pHCB->pSRB_tail = pSRB;
 	spin_unlock_irqrestore(&(pHCB->pSRB_lock), flags);
 	return;
@@ -179,8 +179,8 @@
 	ULONG flags;
 	spin_lock_irqsave(&(pHCB->pSRB_lock), flags);
 	if ((pSRB = (Scsi_Cmnd *) pHCB->pSRB_head) != NULL) {
-		pHCB->pSRB_head = pHCB->pSRB_head->next;
-		pSRB->next = NULL;
+		pHCB->pSRB_head = (Scsi_Cmnd *) pHCB->pSRB_head->SCp.ptr;
+		pSRB->SCp.ptr = NULL;
 	}
 	spin_unlock_irqrestore(&(pHCB->pSRB_lock), flags);
 	return (pSRB);

--------------020606020100060908080002--

