From: Mark Haverkamp <markh@osdl.org>
Subject: [PATCH 6/8] aacraid: initialization timeout
Date: Thu, 08 Sep 2005 13:50:29 -0700
Message-ID: <1126212629.7479.24.camel@markh1.pdx.osdl.net>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.4]:53421 "EHLO smtp.osdl.org")
	by vger.kernel.org with ESMTP id S1751394AbVIHUxl (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 8 Sep 2005 16:53:41 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Mark Salyzyn <mark_salyzyn@adaptec.com>

Received from Mark Salyzyn from Adaptec.

In the rare instances where the adapter, or the motherboard, is
misbehaving; driver initialization or shutdown becomes problematic. By
introducing a 3 minute timeout on the first interrupt driven command
during initialization, or the issuance of the adapter shutdown command
during driver unload, we can resolve the lockup problems induced by
common (but rare) hardware misbehaviors.

The timeout during initialization, should it occur, is accompanied by a
message presented to the console and the logs indicating that the user
should inspect and resolve problems with interrupt routing.

Applies to the scsi-misc-2.6 git tree.

Signed-off-by: Mark Haverkamp <markh@osdl.org>



Index: scsi-misc-aac-2/drivers/scsi/aacraid/aachba.c
===================================================================
--- scsi-misc-aac-2.orig/drivers/scsi/aacraid/aachba.c	2005-09-08 11:32:23.000000000 -0700
+++ scsi-misc-aac-2/drivers/scsi/aacraid/aachba.c	2005-09-08 11:32:36.000000000 -0700
@@ -692,7 +692,7 @@
 			 fibptr, 
 			 sizeof(*info),
 			 FsaNormal, 
-			 1, 1, 
+			 -1, 1, /* First `interrupt' command uses special wait */
 			 NULL, 
 			 NULL);
 
Index: scsi-misc-aac-2/drivers/scsi/aacraid/comminit.c
===================================================================
--- scsi-misc-aac-2.orig/drivers/scsi/aacraid/comminit.c	2005-09-08 11:32:04.000000000 -0700
+++ scsi-misc-aac-2/drivers/scsi/aacraid/comminit.c	2005-09-08 11:32:36.000000000 -0700
@@ -195,7 +195,7 @@
 			  fibctx,
 			  sizeof(struct aac_close),
 			  FsaNormal,
-			  1, 1,
+			  -2 /* Timeout silently */, 1,
 			  NULL, NULL);
 
 	if (status == 0)
Index: scsi-misc-aac-2/drivers/scsi/aacraid/commsup.c
===================================================================
--- scsi-misc-aac-2.orig/drivers/scsi/aacraid/commsup.c	2005-09-08 11:32:23.000000000 -0700
+++ scsi-misc-aac-2/drivers/scsi/aacraid/commsup.c	2005-09-08 11:32:36.000000000 -0700
@@ -41,6 +41,7 @@
 #include <scsi/scsi_host.h>
 #include <scsi/scsi_device.h>
 #include <asm/semaphore.h>
+#include <asm/delay.h>
 
 #include "aacraid.h"
 
@@ -541,7 +542,34 @@
     
 	if (wait) {
 		spin_unlock_irqrestore(&fibptr->event_lock, flags);
-		down(&fibptr->event_wait);
+		/* Only set for first known interruptable command */
+		if (wait < 0) {
+			/*
+			 * *VERY* Dangerous to time out a command, the
+			 * assumption is made that we have no hope of
+			 * functioning because an interrupt routing or other
+			 * hardware failure has occurred.
+			 */
+			unsigned long count = 36000000L; /* 3 minutes */
+			unsigned long qflags;
+			while (down_trylock(&fibptr->event_wait)) {
+				if (--count == 0) {
+					spin_lock_irqsave(q->lock, qflags);
+					q->numpending--;
+					list_del(&fibptr->queue);
+					spin_unlock_irqrestore(q->lock, qflags);
+					if (wait == -1) {
+	        				printk(KERN_ERR "aacraid: fib_send: first asynchronous command timed out.\n"
+						  "Usually a result of a PCI interrupt routing problem;\n"
+						  "update mother board BIOS or consider utilizing one of\n"
+						  "the SAFE mode kernel options (acpi, apic etc)\n");
+					}
+					return -ETIMEDOUT;
+				}
+				udelay(5);
+			}
+		} else
+			down(&fibptr->event_wait);
 		if(fibptr->done == 0)
 			BUG();
 			

-- 
Mark Haverkamp <markh@osdl.org>

