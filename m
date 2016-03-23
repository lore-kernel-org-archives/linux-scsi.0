From: Finn Thain <fthain@telegraphics.com.au>
Subject: [PATCH v4 21/23] atari_scsi: Allow can_queue to be increased for Falcon
Date: Wed, 23 Mar 2016 21:10:30 +1100
Message-ID: <20160323101014.681781582@telegraphics.com.au>
References: <20160323101009.341929635@telegraphics.com.au>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline; filename=atari_scsi-can_queue
Sender: linux-kernel-owner@vger.kernel.org
To: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Michael Schmitz <schmitzmic@gmail.com>, linux-m68k@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Ondrej Zary <linux@rainbow-software.org>, Sam Creasey <sammy@sammy.net>
List-Id: linux-scsi@vger.kernel.org

The benefit of limiting can_queue to 1 is that atari_scsi shares the
ST DMA chip more fairly with other drivers (e.g. falcon-ide).

Unfortunately, this can limit SCSI bus utilization. On systems without
IDE, atari_scsi should issue SCSI commands whenever it can arbitrate for
the bus. Make that possible by making can_queue configurable.

Signed-off-by: Finn Thain <fthain@telegraphics.com.au>
Reviewed-by: Hannes Reinecke <hare@suse.com>
Tested-by: Michael Schmitz <schmitzmic@gmail.com>

---
 drivers/scsi/atari_scsi.c |   83 ++++++++++++----------------------------------
 1 file changed, 22 insertions(+), 61 deletions(-)

Index: linux/drivers/scsi/atari_scsi.c
===================================================================
--- linux.orig/drivers/scsi/atari_scsi.c	2016-03-23 21:10:03.000000000 +1100
+++ linux/drivers/scsi/atari_scsi.c	2016-03-23 21:10:04.000000000 +1100
@@ -14,55 +14,23 @@
  *
  */
 
-
-/**************************************************************************/
-/*                                                                        */
-/* Notes for Falcon SCSI:                                                 */
-/* ----------------------                                                 */
-/*                                                                        */
-/* Since the Falcon SCSI uses the ST-DMA chip, that is shared among       */
-/* several device drivers, locking and unlocking the access to this       */
-/* chip is required. But locking is not possible from an interrupt,       */
-/* since it puts the process to sleep if the lock is not available.       */
-/* This prevents "late" locking of the DMA chip, i.e. locking it just     */
-/* before using it, since in case of disconnection-reconnection           */
-/* commands, the DMA is started from the reselection interrupt.           */
-/*                                                                        */
-/* Two possible schemes for ST-DMA-locking would be:                      */
-/*  1) The lock is taken for each command separately and disconnecting    */
-/*     is forbidden (i.e. can_queue = 1).                                 */
-/*  2) The DMA chip is locked when the first command comes in and         */
-/*     released when the last command is finished and all queues are      */
-/*     empty.                                                             */
-/* The first alternative would result in bad performance, since the       */
-/* interleaving of commands would not be used. The second is unfair to    */
-/* other drivers using the ST-DMA, because the queues will seldom be      */
-/* totally empty if there is a lot of disk traffic.                       */
-/*                                                                        */
-/* For this reasons I decided to employ a more elaborate scheme:          */
-/*  - First, we give up the lock every time we can (for fairness), this    */
-/*    means every time a command finishes and there are no other commands */
-/*    on the disconnected queue.                                          */
-/*  - If there are others waiting to lock the DMA chip, we stop           */
-/*    issuing commands, i.e. moving them onto the issue queue.           */
-/*    Because of that, the disconnected queue will run empty in a         */
-/*    while. Instead we go to sleep on a 'fairness_queue'.                */
-/*  - If the lock is released, all processes waiting on the fairness      */
-/*    queue will be woken. The first of them tries to re-lock the DMA,     */
-/*    the others wait for the first to finish this task. After that,      */
-/*    they can all run on and do their commands...                        */
-/* This sounds complicated (and it is it :-(), but it seems to be a       */
-/* good compromise between fairness and performance: As long as no one     */
-/* else wants to work with the ST-DMA chip, SCSI can go along as          */
-/* usual. If now someone else comes, this behaviour is changed to a       */
-/* "fairness mode": just already initiated commands are finished and      */
-/* then the lock is released. The other one waiting will probably win     */
-/* the race for locking the DMA, since it was waiting for longer. And     */
-/* after it has finished, SCSI can go ahead again. Finally: I hope I      */
-/* have not produced any deadlock possibilities!                          */
-/*                                                                        */
-/**************************************************************************/
-
+/*
+ * Notes for Falcon SCSI DMA
+ *
+ * The 5380 device is one of several that all share the DMA chip. Hence
+ * "locking" and "unlocking" access to this chip is required.
+ *
+ * Two possible schemes for ST DMA acquisition by atari_scsi are:
+ * 1) The lock is taken for each command separately (i.e. can_queue == 1).
+ * 2) The lock is taken when the first command arrives and released
+ * when the last command is finished (i.e. can_queue > 1).
+ *
+ * The first alternative limits SCSI bus utilization, since interleaving
+ * commands is not possible. The second gives better performance but is
+ * unfair to other drivers needing to use the ST DMA chip. In order to
+ * allow the IDE and floppy drivers equal access to the ST DMA chip
+ * the default is can_queue == 1.
+ */
 
 #include <linux/module.h>
 #include <linux/types.h>
@@ -443,6 +411,10 @@ static int falcon_get_lock(struct Scsi_H
 	if (IS_A_TT())
 		return 1;
 
+	if (stdma_is_locked_by(scsi_falcon_intr) &&
+	    instance->hostt->can_queue > 1)
+		return 1;
+
 	if (in_interrupt())
 		return stdma_try_lock(scsi_falcon_intr, instance);
 
@@ -776,22 +748,11 @@ static int __init atari_scsi_probe(struc
 		atari_scsi_reg_write = atari_scsi_falcon_reg_write;
 	}
 
-	/* The values for CMD_PER_LUN and CAN_QUEUE are somehow arbitrary.
-	 * Higher values should work, too; try it!
-	 * (But cmd_per_lun costs memory!)
-	 *
-	 * But there seems to be a bug somewhere that requires CAN_QUEUE to be
-	 * 2*CMD_PER_LUN. At least on a TT, no spurious timeouts seen since
-	 * changed CMD_PER_LUN...
-	 *
-	 * Note: The Falcon currently uses 8/1 setting due to unsolved problems
-	 * with cmd_per_lun != 1
-	 */
 	if (ATARIHW_PRESENT(TT_SCSI)) {
 		atari_scsi_template.can_queue    = 16;
 		atari_scsi_template.sg_tablesize = SG_ALL;
 	} else {
-		atari_scsi_template.can_queue    = 8;
+		atari_scsi_template.can_queue    = 1;
 		atari_scsi_template.sg_tablesize = SG_NONE;
 	}
 
