From: Finn Thain <fthain@telegraphics.com.au>
Subject: [PATCH 2/6] ncr5380: Dont release lock for PIO transfer
Date: Tue, 23 Feb 2016 10:07:05 +1100
Message-ID: <20160222230704.504641476@telegraphics.com.au>
References: <20160222230703.994951661@telegraphics.com.au>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline; filename=ncr5380-transfer_pio-locking
Sender: linux-kernel-owner@vger.kernel.org
To: "James E.J. Bottomley" <JBottomley@odin.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Michael Schmitz <schmitzmic@gmail.com>, linux-m68k@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

The calls to NCR5380_transfer_pio() for DATA IN and DATA OUT phases will
modify cmd->SCp.this_residual, cmd->SCp.ptr and cmd->SCp.buffer. That
works as long as EH does not intervene, which became possible in
atari_NCR5380.c when I changed the locking to bring it closer to
NCR5380.c.

If error recovery aborts the command, the scsi_cmnd in question and its
buffer will be returned to the mid-layer. So the transfer has to cease,
but it can't be stopped by the initiator because the target controls the
bus phase.

The problem does not arise if the lock is not released. That was fine for
atari_scsi, because it implements DMA. For the other drivers, we have to
release the lock and re-enable interrupts for long PIO data transfers.

The solution is to split the transfer into small chunks. In between chunks
the main loop releases the lock and re-enables interrupts. Thus interrupts
can be serviced and eh_bus_reset_handler can intervene if need be.

This fixes an oops in NCR5380_transfer_pio() that can happen when the EH
abort handler is invoked during DATA IN or DATA OUT phase.

Fixes: 11d2f63b9cf5 ("ncr5380: Change instance->host_lock to hostdata->lock")
Reported-and-tested-by: Michael Schmitz <schmitzmic@gmail.com>
Signed-off-by: Finn Thain <fthain@telegraphics.com.au>

---
 drivers/scsi/NCR5380.c       |   16 +++++++++-------
 drivers/scsi/atari_NCR5380.c |   16 +++++++++-------
 2 files changed, 18 insertions(+), 14 deletions(-)

Index: linux/drivers/scsi/NCR5380.c
===================================================================
--- linux.orig/drivers/scsi/NCR5380.c	2016-02-23 10:06:56.000000000 +1100
+++ linux/drivers/scsi/NCR5380.c	2016-02-23 10:06:57.000000000 +1100
@@ -1759,9 +1759,7 @@ static void NCR5380_information_transfer
 	unsigned char msgout = NOP;
 	int sink = 0;
 	int len;
-#if defined(PSEUDO_DMA) || defined(REAL_DMA_POLL)
 	int transfersize;
-#endif
 	unsigned char *data;
 	unsigned char phase, tmp, extended_msg[10], old_phase = 0xff;
 	struct scsi_cmnd *cmd;
@@ -1854,13 +1852,17 @@ static void NCR5380_information_transfer
 				} else
 #endif				/* defined(PSEUDO_DMA) || defined(REAL_DMA_POLL) */
 				{
-					spin_unlock_irq(&hostdata->lock);
-					NCR5380_transfer_pio(instance, &phase,
-					                     (int *)&cmd->SCp.this_residual,
+					/* Break up transfer into 3 ms chunks,
+					 * presuming 6 accesses per handshake.
+					 */
+					transfersize = min((unsigned long)cmd->SCp.this_residual,
+					                   hostdata->accesses_per_ms / 2);
+					len = transfersize;
+					NCR5380_transfer_pio(instance, &phase, &len,
 					                     (unsigned char **)&cmd->SCp.ptr);
-					spin_lock_irq(&hostdata->lock);
+					cmd->SCp.this_residual -= transfersize - len;
 				}
-				break;
+				return;
 			case PHASE_MSGIN:
 				len = 1;
 				data = &tmp;
Index: linux/drivers/scsi/atari_NCR5380.c
===================================================================
--- linux.orig/drivers/scsi/atari_NCR5380.c	2016-02-23 10:06:56.000000000 +1100
+++ linux/drivers/scsi/atari_NCR5380.c	2016-02-23 10:06:57.000000000 +1100
@@ -1838,9 +1838,7 @@ static void NCR5380_information_transfer
 	unsigned char msgout = NOP;
 	int sink = 0;
 	int len;
-#if defined(REAL_DMA)
 	int transfersize;
-#endif
 	unsigned char *data;
 	unsigned char phase, tmp, extended_msg[10], old_phase = 0xff;
 	struct scsi_cmnd *cmd;
@@ -1983,18 +1981,22 @@ static void NCR5380_information_transfer
 				} else
 #endif /* defined(REAL_DMA) */
 				{
-					spin_unlock_irq(&hostdata->lock);
-					NCR5380_transfer_pio(instance, &phase,
-					                     (int *)&cmd->SCp.this_residual,
+					/* Break up transfer into 3 ms chunks,
+					 * presuming 6 accesses per handshake.
+					 */
+					transfersize = min((unsigned long)cmd->SCp.this_residual,
+					                   hostdata->accesses_per_ms / 2);
+					len = transfersize;
+					NCR5380_transfer_pio(instance, &phase, &len,
 					                     (unsigned char **)&cmd->SCp.ptr);
-					spin_lock_irq(&hostdata->lock);
+					cmd->SCp.this_residual -= transfersize - len;
 				}
 #if defined(CONFIG_SUN3) && defined(REAL_DMA)
 				/* if we had intended to dma that command clear it */
 				if (sun3_dma_setup_done == cmd)
 					sun3_dma_setup_done = NULL;
 #endif
-				break;
+				return;
 			case PHASE_MSGIN:
 				len = 1;
 				data = &tmp;
