From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH] kill old EH constants
Date: Tue, 5 Apr 2005 10:29:04 +0200
Message-ID: <20050405082904.GA17367@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.210]:36788 "EHLO mail.lst.de")
	by vger.kernel.org with ESMTP id S261635AbVDEI3J (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 5 Apr 2005 04:29:09 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jejb@steeleye.com
Cc: linux-scsi@vger.kernel.org

Fix up two drivers that incorrectly were using the old return values for
their new-style EH methods and kill off scsi_obsolete.h that defined the
constants.  The initio driver has all these constansts defined locally
and uses them internally, I'll fix that up some time later.


--- 1.95/drivers/scsi/scsi.h	2005-03-29 19:28:04 +02:00
+++ edited/drivers/scsi/scsi.h	2005-04-04 16:09:48 +02:00
@@ -60,12 +60,6 @@
 #define scsi_to_pci_dma_dir(scsi_dir)	((int)(scsi_dir))
 #define scsi_to_sbus_dma_dir(scsi_dir)	((int)(scsi_dir))
 
-/*
- * This is the crap from the old error handling code.  We have it in a special
- * place so that we can more easily delete it later on.
- */
-#include "scsi_obsolete.h"
-
 /* obsolete typedef junk. */
 #include "scsi_typedefs.h"
 
--- 1.1/drivers/scsi/scsi_obsolete.h	2002-02-05 18:40:08 +01:00
+++ edited/drivers/scsi/scsi_obsolete.h	2005-04-04 16:09:33 +02:00
@@ -1,106 +0,0 @@
-/*
- *  scsi_obsolete.h Copyright (C) 1997 Eric Youngdale
- *
- */
-
-#ifndef _SCSI_OBSOLETE_H
-#define _SCSI_OBSOLETE_H
-
-/*
- * These are the return codes for the abort and reset functions.  The mid-level
- * code uses these to decide what to do next.  Each of the low level abort
- * and reset functions must correctly indicate what it has done.
- * The descriptions are written from the point of view of the mid-level code,
- * so that the return code is telling the mid-level drivers exactly what
- * the low level driver has already done, and what remains to be done.
- */
-
-/* We did not do anything.  
- * Wait some more for this command to complete, and if this does not work, 
- * try something more serious. */
-#define SCSI_ABORT_SNOOZE 0
-
-/* This means that we were able to abort the command.  We have already
- * called the mid-level done function, and do not expect an interrupt that 
- * will lead to another call to the mid-level done function for this command */
-#define SCSI_ABORT_SUCCESS 1
-
-/* We called for an abort of this command, and we should get an interrupt 
- * when this succeeds.  Thus we should not restore the timer for this
- * command in the mid-level abort function. */
-#define SCSI_ABORT_PENDING 2
-
-/* Unable to abort - command is currently on the bus.  Grin and bear it. */
-#define SCSI_ABORT_BUSY 3
-
-/* The command is not active in the low level code. Command probably
- * finished. */
-#define SCSI_ABORT_NOT_RUNNING 4
-
-/* Something went wrong.  The low level driver will indicate the correct
- * error condition when it calls scsi_done, so the mid-level abort function
- * can simply wait until this comes through */
-#define SCSI_ABORT_ERROR 5
-
-/* We do not know how to reset the bus, or we do not want to.  Bummer.
- * Anyway, just wait a little more for the command in question, and hope that
- * it eventually finishes.  If it never finishes, the SCSI device could
- * hang, so use this with caution. */
-#define SCSI_RESET_SNOOZE 0
-
-/* We do not know how to reset the bus, or we do not want to.  Bummer.
- * We have given up on this ever completing.  The mid-level code will
- * request sense information to decide how to proceed from here. */
-#define SCSI_RESET_PUNT 1
-
-/* This means that we were able to reset the bus.  We have restarted all of
- * the commands that should be restarted, and we should be able to continue
- * on normally from here.  We do not expect any interrupts that will return
- * DID_RESET to any of the other commands in the host_queue, and the mid-level
- * code does not need to do anything special to keep the commands alive. 
- * If a hard reset was performed then all outstanding commands on the
- * bus have been restarted. */
-#define SCSI_RESET_SUCCESS 2
-
-/* We called for a reset of this bus, and we should get an interrupt 
- * when this succeeds.  Each command should get its own status
- * passed up to scsi_done, but this has not happened yet. 
- * If a hard reset was performed, then we expect an interrupt
- * for *each* of the outstanding commands that will have the
- * effect of restarting the commands.
- */
-#define SCSI_RESET_PENDING 3
-
-/* We did a reset, but do not expect an interrupt to signal DID_RESET.
- * This tells the upper level code to request the sense info, and this
- * should keep the command alive. */
-#define SCSI_RESET_WAKEUP 4
-
-/* The command is not active in the low level code. Command probably
-   finished. */
-#define SCSI_RESET_NOT_RUNNING 5
-
-/* Something went wrong, and we do not know how to fix it. */
-#define SCSI_RESET_ERROR 6
-
-#define SCSI_RESET_SYNCHRONOUS		0x01
-#define SCSI_RESET_ASYNCHRONOUS		0x02
-#define SCSI_RESET_SUGGEST_BUS_RESET	0x04
-#define SCSI_RESET_SUGGEST_HOST_RESET	0x08
-/*
- * This is a bitmask that is ored with one of the above codes.
- * It tells the mid-level code that we did a hard reset.
- */
-#define SCSI_RESET_BUS_RESET 0x100
-/*
- * This is a bitmask that is ored with one of the above codes.
- * It tells the mid-level code that we did a host adapter reset.
- */
-#define SCSI_RESET_HOST_RESET 0x200
-/*
- * Used to mask off bits and to obtain the basic action that was
- * performed.  
- */
-#define SCSI_RESET_ACTION   0xff
-
-#endif				/* SCSI_OBSOLETE_H */
===== drivers/scsi/ultrastor.c 1.25 vs edited =====
--- 1.25/drivers/scsi/ultrastor.c	2005-03-11 21:32:31 +01:00
+++ edited/drivers/scsi/ultrastor.c	2005-04-04 16:09:02 +02:00
@@ -945,7 +945,7 @@
 	       config.mscp[mscp_index].SCint, SCpnt);
 #endif
     if (config.mscp[mscp_index].SCint == 0)
-	return SCSI_ABORT_NOT_RUNNING;
+	return FAILURE;
 
     if (config.mscp[mscp_index].SCint != SCpnt) panic("Bad abort");
     config.mscp[mscp_index].SCint = NULL;
@@ -1020,7 +1020,7 @@
 #endif
 
     spin_unlock_irqrestore(host->host_lock, flags);
-    return SCSI_RESET_SUCCESS;
+    return SUCCESS;
 
 }
 
--- 1.44/drivers/usb/image/microtek.c	2005-03-05 16:13:09 +01:00
+++ edited/drivers/usb/image/microtek.c	2005-04-04 16:09:02 +02:00
@@ -335,7 +335,7 @@
 
 	mts_urb_abort(desc);
 
-	return SCSI_ABORT_PENDING;
+	return FAILURE;
 }
 
 static int mts_scsi_host_reset (Scsi_Cmnd *srb)
