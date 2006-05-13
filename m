From: Jesper Juhl <jesper.juhl@gmail.com>
Subject: [PATCH] fix (unlikely) memory leak in DAC960 driver
Date: Sun, 14 May 2006 00:39:38 +0200
Message-ID: <200605140039.38385.jesper.juhl@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from nf-out-0910.google.com ([64.233.182.185]:40325 "EHLO
	nf-out-0910.google.com") by vger.kernel.org with ESMTP
	id S932378AbWEMWip (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 13 May 2006 18:38:45 -0400
Received: by nf-out-0910.google.com with SMTP id p46so184226nfa
        for <linux-scsi@vger.kernel.org>; Sat, 13 May 2006 15:38:43 -0700 (PDT)
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@osdl.org>, James.Bottomley@hansenpartnership.com, James Bottomley <James.Bottomley@steeleye.com>, linux-scsi@vger.kernel.org, Jesper Juhl <jesper.juhl@gmail.com>

The Coverity checker found a memory leak (bug nr. 1245) in
 drivers/block/DAC960.c::DAC960_V2_ProcessCompletedCommand()

The leak is pretty unlikely since it requires that the first of two 
successive kmalloc() calls fail while the second one succeeds. But it can 
still happen even if it's unlikely.

If the first call that allocates 'PhysicalDeviceInfo' fails but the one 
that allocates 'InquiryUnitSerialNumber' succeeds, then we will leak the 
memory allocated to 'InquiryUnitSerialNumber' when the variable goes out 
of scope.

A simple fix for this is to change the existing code that frees 
'PhysicalDeviceInfo' if that one was allocated but 
'InquiryUnitSerialNumber' was not, into a check for either pointer 
being NULL and if so just free both. This is safe since kfree() can 
deal with being passed a NULL pointer and it avoids the leak.

While I was there I also removed the casts of the kmalloc() return 
value since it's pointless.
I also updated the driver version since this patch changes the workings of
the code (however slightly).

This issue could probably be fixed a lot more elegantly, but the code 
is a big mess IMHO and I just took the least intrusive route to a fix 
that I could find instead of starting on a cleanup as well (that can 
come later).
 
Please consider for inclusion.


Signed-off-by: Jesper Juhl <jesper.juhl@gmail.com>
---

 drivers/block/DAC960.c |   13 +++++++------
 1 files changed, 7 insertions(+), 6 deletions(-)

--- linux-2.6.17-rc4-git2-orig/drivers/block/DAC960.c	2006-05-13 21:28:19.000000000 +0200
+++ linux-2.6.17-rc4-git2/drivers/block/DAC960.c	2006-05-14 00:31:16.000000000 +0200
@@ -17,8 +17,8 @@
 */
 
 
-#define DAC960_DriverVersion			"2.5.47"
-#define DAC960_DriverDate			"14 November 2002"
+#define DAC960_DriverVersion			"2.5.48"
+#define DAC960_DriverDate			"14 May 2006"
 
 
 #include <linux/module.h>
@@ -4780,15 +4780,16 @@ static void DAC960_V2_ProcessCompletedCo
 	      (NewPhysicalDeviceInfo->LogicalUnit !=
 	       PhysicalDeviceInfo->LogicalUnit))
 	    {
-	      PhysicalDeviceInfo = (DAC960_V2_PhysicalDeviceInfo_T *)
+	      PhysicalDeviceInfo =
 		kmalloc(sizeof(DAC960_V2_PhysicalDeviceInfo_T), GFP_ATOMIC);
 	      InquiryUnitSerialNumber =
-		(DAC960_SCSI_Inquiry_UnitSerialNumber_T *)
 		  kmalloc(sizeof(DAC960_SCSI_Inquiry_UnitSerialNumber_T),
 			  GFP_ATOMIC);
-	      if (InquiryUnitSerialNumber == NULL &&
-		  PhysicalDeviceInfo != NULL)
+	      if (InquiryUnitSerialNumber == NULL ||
+		  PhysicalDeviceInfo == NULL)
 		{
+		  kfree(InquiryUnitSerialNumber);
+		  InquiryUnitSerialNumber = NULL;
 		  kfree(PhysicalDeviceInfo);
 		  PhysicalDeviceInfo = NULL;
 		}





