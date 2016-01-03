From: Finn Thain <fthain@telegraphics.com.au>
Subject: [PATCH v4 29/78] ncr5380: Remove references to linked commands
Date: Sun, 03 Jan 2016 16:05:30 +1100
Message-ID: <20160103050508.711917458@telegraphics.com.au>
References: <20160103050501.042035135@telegraphics.com.au>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from kvm5.telegraphics.com.au ([98.124.60.144]:49423 "EHLO
	kvm5.telegraphics.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751634AbcACFSQ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 3 Jan 2016 00:18:16 -0500
Content-Disposition: inline; filename=ncr5380-remove-LINKED
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "James E.J. Bottomley" <JBottomley@odin.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Michael Schmitz <schmitzmic@gmail.com>, linux-m68k@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

From: Hannes Reinecke <hare@suse.de>

Some old drivers partially implemented support for linked commands using
a "proposed" next_link pointer in struct scsi_cmnd that never actually
existed. Remove this code.

Signed-off-by: Finn Thain <fthain@telegraphics.com.au>
Reviewed-by: Hannes Reinecke <hare@suse.com>
Tested-by: Ondrej Zary <linux@rainbow-software.org>
Tested-by: Michael Schmitz <schmitzmic@gmail.com>

---

This is a modified version of Hannes' patch so I have dropped his
signed-off-by tag. This version has a rewritten commit log and also
removes additional references to linked commands from comments. This
version also omits the sun3_NCR5380.c changes since that file no
longer exists.

---
 drivers/scsi/NCR5380.c       |   42 ------------------------------
 drivers/scsi/atari_NCR5380.c |   60 -------------------------------------------
 2 files changed, 102 deletions(-)

Index: linux/drivers/scsi/NCR5380.c
===================================================================
--- linux.orig/drivers/scsi/NCR5380.c	2016-01-03 16:03:38.000000000 +1100
+++ linux/drivers/scsi/NCR5380.c	2016-01-03 16:03:39.000000000 +1100
@@ -78,9 +78,6 @@
  * 
  * 4.  Test SCSI-II tagged queueing (I have no devices which support 
  *      tagged queueing)
- *
- * 5.  Test linked command handling code after Eric is ready with 
- *      the high level code.
  */
 #include <scsi/scsi_dbg.h>
 #include <scsi/scsi_transport_spi.h>
@@ -94,7 +91,6 @@
 #endif
 
 #ifndef notyet
-#undef LINKED
 #undef REAL_DMA
 #endif
 
@@ -191,8 +187,6 @@
  * DONT_USE_INTR - if defined, never use interrupts, even if we probe or
  *      override-configure an IRQ.
  *
- * LINKED - if defined, linked commands are supported.
- *
  * PSEUDO_DMA - if defined, PSEUDO DMA is used during the data transfer phases.
  *
  * REAL_DMA - if defined, REAL DMA is used during the data transfer phases.
@@ -1923,42 +1917,6 @@ static void NCR5380_information_transfer
 				cmd->SCp.Message = tmp;
 
 				switch (tmp) {
-					/*
-					 * Linking lets us reduce the time required to get the 
-					 * next command out to the device, hopefully this will
-					 * mean we don't waste another revolution due to the delays
-					 * required by ARBITRATION and another SELECTION.
-					 *
-					 * In the current implementation proposal, low level drivers
-					 * merely have to start the next command, pointed to by 
-					 * next_link, done() is called as with unlinked commands.
-					 */
-#ifdef LINKED
-				case LINKED_CMD_COMPLETE:
-				case LINKED_FLG_CMD_COMPLETE:
-					/* Accept message by clearing ACK */
-					NCR5380_write(INITIATOR_COMMAND_REG, ICR_BASE);
-					dprintk(NDEBUG_LINKED, "scsi%d : target %d lun %llu linked command complete.\n", instance->host_no, cmd->device->id, cmd->device->lun);
-					/* 
-					 * Sanity check : A linked command should only terminate with
-					 * one of these messages if there are more linked commands
-					 * available.
-					 */
-					if (!cmd->next_link) {
-					    printk("scsi%d : target %d lun %llu linked command complete, no next_link\n" instance->host_no, cmd->device->id, cmd->device->lun);
-						sink = 1;
-						do_abort(instance);
-						return;
-					}
-					initialize_SCp(cmd->next_link);
-					/* The next command is still part of this process */
-					cmd->next_link->tag = cmd->tag;
-					cmd->result = cmd->SCp.Status | (cmd->SCp.Message << 8);
-					dprintk(NDEBUG_LINKED, "scsi%d : target %d lun %llu linked request done, calling scsi_done().\n", instance->host_no, cmd->device->id, cmd->device->lun);
-					cmd->scsi_done(cmd);
-					cmd = hostdata->connected;
-					break;
-#endif				/* def LINKED */
 				case ABORT:
 				case COMMAND_COMPLETE:
 					/* Accept message by clearing ACK */
Index: linux/drivers/scsi/atari_NCR5380.c
===================================================================
--- linux.orig/drivers/scsi/atari_NCR5380.c	2016-01-03 16:03:38.000000000 +1100
+++ linux/drivers/scsi/atari_NCR5380.c	2016-01-03 16:03:39.000000000 +1100
@@ -66,12 +66,6 @@
  *
  */
 
-/*
- * Further development / testing that should be done :
- * 1.  Test linked command handling code after Eric is ready with
- *     the high level code.
- */
-
 /* Adapted for the sun3 by Sam Creasey. */
 
 #include <scsi/scsi_dbg.h>
@@ -98,10 +92,6 @@
 #define REMOVE(w,x,y,z)
 #endif
 
-#ifndef notyet
-#undef LINKED
-#endif
-
 /*
  * Design
  *
@@ -172,8 +162,6 @@
  * DIFFERENTIAL - if defined, NCR53c81 chips will use external differential
  *	transceivers.
  *
- * LINKED - if defined, linked commands are supported.
- *
  * REAL_DMA - if defined, REAL DMA is used during the data transfer phases.
  *
  * SUPPORT_TAGS - if defined, SCSI-2 tagged queuing is used where possible
@@ -2216,54 +2204,6 @@ static void NCR5380_information_transfer
 				cmd->SCp.Message = tmp;
 
 				switch (tmp) {
-				/*
-				 * Linking lets us reduce the time required to get the
-				 * next command out to the device, hopefully this will
-				 * mean we don't waste another revolution due to the delays
-				 * required by ARBITRATION and another SELECTION.
-				 *
-				 * In the current implementation proposal, low level drivers
-				 * merely have to start the next command, pointed to by
-				 * next_link, done() is called as with unlinked commands.
-				 */
-#ifdef LINKED
-				case LINKED_CMD_COMPLETE:
-				case LINKED_FLG_CMD_COMPLETE:
-					/* Accept message by clearing ACK */
-					NCR5380_write(INITIATOR_COMMAND_REG, ICR_BASE);
-
-					dprintk(NDEBUG_LINKED, "scsi%d: target %d lun %llu linked command "
-						   "complete.\n", HOSTNO, cmd->device->id, cmd->device->lun);
-
-					/* Enable reselect interrupts */
-					NCR5380_write(SELECT_ENABLE_REG, hostdata->id_mask);
-					/*
-					 * Sanity check : A linked command should only terminate
-					 * with one of these messages if there are more linked
-					 * commands available.
-					 */
-
-					if (!cmd->next_link) {
-						 printk(KERN_NOTICE "scsi%d: target %d lun %llu "
-							"linked command complete, no next_link\n",
-							HOSTNO, cmd->device->id, cmd->device->lun);
-						sink = 1;
-						do_abort(instance);
-						return;
-					}
-
-					initialize_SCp(cmd->next_link);
-					/* The next command is still part of this process; copy it
-					 * and don't free it! */
-					cmd->next_link->tag = cmd->tag;
-					cmd->result = cmd->SCp.Status | (cmd->SCp.Message << 8);
-					dprintk(NDEBUG_LINKED, "scsi%d: target %d lun %llu linked request "
-						   "done, calling scsi_done().\n",
-						   HOSTNO, cmd->device->id, cmd->device->lun);
-					cmd->scsi_done(cmd);
-					cmd = hostdata->connected;
-					break;
-#endif /* def LINKED */
 				case ABORT:
 				case COMMAND_COMPLETE:
 					/* Accept message by clearing ACK */


