From: Mike Christie <mikenc@us.ibm.com>
Subject: [patch] fixes compile error in inia100.c
Date: Thu, 08 May 2003 16:17:12 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3EBAE578.3010301@us.ibm.com>
Reply-To: mikenc@us.ibm.com
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------010606010202030107000505"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e6.ny.us.ibm.com ([32.97.182.106]:54989 "EHLO e6.ny.us.ibm.com")
	by vger.kernel.org with ESMTP id S262219AbTEHXEl (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 8 May 2003 19:04:41 -0400
Received: from northrelay02.pok.ibm.com (northrelay02.pok.ibm.com [9.56.224.150])
	by e6.ny.us.ibm.com (8.12.9/8.12.2) with ESMTP id h48NHD9d075716
	for <linux-scsi@vger.kernel.org>; Thu, 8 May 2003 19:17:13 -0400
Received: from us.ibm.com (d01av02.pok.ibm.com [9.56.224.216])
	by northrelay02.pok.ibm.com (8.12.9/NCO/VER6.5) with ESMTP id h48NHAiO138784
	for <linux-scsi@vger.kernel.org>; Thu, 8 May 2003 19:17:10 -0400
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

This is a multi-part message in MIME format.
--------------010606010202030107000505
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit

The attached patch fixes the compile errors in inia100.c described in 
Bugzilla bug #345 at http://bugme.osdl.org/show_bug.cgi?id=345. It was 
built against 2.5.69. I do not have the hardware, so I have only 
verified that it compiles correctly.

Mike Christie
mikenc@us.ibm.com


inia100.c |    8 ++++----
1 files changed, 4 insertions(+), 4 deletions(-)

--------------010606010202030107000505
Content-Type: text/plain;
 name="inia100_patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="inia100_patch"

--- linux-2.5.69-orig/drivers/scsi/inia100.c	Sun May  4 16:53:08 2003
+++ linux-2.5.69-inia100/drivers/scsi/inia100.c	Wed May  7 11:39:57 2003
@@ -142,11 +142,11 @@
 
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
@@ -165,8 +165,8 @@
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

--------------010606010202030107000505--

