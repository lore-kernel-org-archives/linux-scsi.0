From: Finn Thain <fthain@telegraphics.com.au>
Subject: [PATCH 35/71] ncr5380: Dont wait for BUS FREE after disconnect
Date: Wed, 18 Nov 2015 19:35:30 +1100
Message-ID: <20151118083505.311723501@telegraphics.com.au>
References: <20151118083455.331768508@telegraphics.com.au>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline; filename=ncr5380-dont-wait-for-bus-free
Sender: linux-kernel-owner@vger.kernel.org
To: "James E.J. Bottomley" <JBottomley@odin.com>, Michael Schmitz <schmitzmic@gmail.com>, linux-m68k@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

When there is a queued command and no connected command, NCR5380_select()
is called and arbitration begins. The chip waits for BUS FREE once the
MR_ARBITRATE bit in the mode register is enabled. That means there is
no need to wait for BUS FREE after disconnecting.

There is presently no polling for BUS FREE after sending an ABORT or
other message that might lead to disconnection. It only happens after
COMMAND COMPLETE or DISCONNECT messages, which seems inconsistent.
Remove the polling for !BSY in the COMMAND COMPLETE and DISCONNECT
cases.

BTW, the comments say "avoid nasty timeouts" and perhaps BUS FREE polling
was somehow helpful back in Linux v0.99.14u, when it was introduced.
The relevant timeout is presently 1 second (for bus arbitration).

Signed-off-by: Finn Thain <fthain@telegraphics.com.au>

---
 drivers/scsi/NCR5380.c       |    7 -------
 drivers/scsi/atari_NCR5380.c |   11 -----------
 2 files changed, 18 deletions(-)

Index: linux/drivers/scsi/NCR5380.c
===================================================================
--- linux.orig/drivers/scsi/NCR5380.c	2015-11-18 19:33:47.000000000 +1100
+++ linux/drivers/scsi/NCR5380.c	2015-11-18 19:33:48.000000000 +1100
@@ -1969,9 +1969,6 @@ static void NCR5380_information_transfer
 					 * arbitration can resume.
 					 */
 					NCR5380_write(TARGET_COMMAND_REG, 0);
-
-					while ((NCR5380_read(STATUS_REG) & SR_BSY) && !hostdata->connected)
-						barrier();
 					return;
 				case MESSAGE_REJECT:
 					/* Accept message by clearing ACK */
@@ -2004,10 +2001,6 @@ static void NCR5380_information_transfer
 
 						/* Enable reselect interrupts */
 						NCR5380_write(SELECT_ENABLE_REG, hostdata->id_mask);
-						/* Wait for bus free to avoid nasty timeouts - FIXME timeout !*/
-						/* NCR538_poll_politely(instance, STATUS_REG, SR_BSY, 0, 30 * HZ); */
-						while ((NCR5380_read(STATUS_REG) & SR_BSY) && !hostdata->connected)
-							barrier();
 						return;
 					}
 					/* 
Index: linux/drivers/scsi/atari_NCR5380.c
===================================================================
--- linux.orig/drivers/scsi/atari_NCR5380.c	2015-11-18 19:33:47.000000000 +1100
+++ linux/drivers/scsi/atari_NCR5380.c	2015-11-18 19:33:48.000000000 +1100
@@ -2207,7 +2207,6 @@ static void NCR5380_information_transfer
 						  "completed\n", HOSTNO, cmd->device->id, cmd->device->lun);
 
 					local_irq_save(flags);
-					hostdata->retain_dma_intr++;
 					hostdata->connected = NULL;
 #ifdef SUPPORT_TAGS
 					cmd_free_tag(cmd);
@@ -2276,8 +2275,6 @@ static void NCR5380_information_transfer
 						cmd->scsi_done(cmd);
 					}
 
-					local_irq_restore(flags);
-
 					NCR5380_write(SELECT_ENABLE_REG, hostdata->id_mask);
 					/*
 					 * Restore phase bits to 0 so an interrupted selection,
@@ -2285,11 +2282,6 @@ static void NCR5380_information_transfer
 					 */
 					NCR5380_write(TARGET_COMMAND_REG, 0);
 
-					while ((NCR5380_read(STATUS_REG) & SR_BSY) && !hostdata->connected)
-						barrier();
-
-					local_irq_save(flags);
-					hostdata->retain_dma_intr--;
 					/* ++roman: For Falcon SCSI, release the lock on the
 					 * ST-DMA here if no other commands are waiting on the
 					 * disconnected queue.
@@ -2343,9 +2335,6 @@ static void NCR5380_information_transfer
 
 					/* Enable reselect interrupts */
 					NCR5380_write(SELECT_ENABLE_REG, hostdata->id_mask);
-					/* Wait for bus free to avoid nasty timeouts */
-					while ((NCR5380_read(STATUS_REG) & SR_BSY) && !hostdata->connected)
-						barrier();
 #ifdef SUN3_SCSI_VME
 					dregs->csr |= CSR_DMA_ENABLE;
 #endif
