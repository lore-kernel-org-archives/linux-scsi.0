From: Finn Thain <fthain@telegraphics.com.au>
Subject: [PATCH v4 27/78] ncr5380: Add missing lock in eh_abort_handler
Date: Sun, 03 Jan 2016 16:05:28 +1100
Message-ID: <20160103050508.181787264@telegraphics.com.au>
References: <20160103050501.042035135@telegraphics.com.au>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline; filename=ncr5380-spin_unlock-crash
Sender: linux-kernel-owner@vger.kernel.org
To: "James E.J. Bottomley" <JBottomley@odin.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Michael Schmitz <schmitzmic@gmail.com>, linux-m68k@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

The host spin lock needs to be acquired by NCR5380_abort() before it calls
NCR5380_select(). This patch doesn't actually fix the EH issues in this
driver but it does avoid this:

BUG: spinlock already unlocked on CPU#0, kworker/u4:1/14
 lock: 0xc0c0f834, .magic: dead4ead, .owner: <none>/-1, .owner_cpu: -1
 CPU: 0 PID: 14 Comm: kworker/u4:1 Not tainted 3.15.5 #5
 Workqueue: scsi_tmf_4 scmd_eh_abort_handler
 Call Trace:
 [ef885d70] [c0008acc] show_stack+0x70/0x1bc (unreliable)
 [ef885db0] [c0492a00] dump_stack+0x84/0x684
 [ef885dc0] [c006f314] spin_dump+0xd0/0xe8
 [ef885dd0] [c006f460] do_raw_spin_unlock+0xd4/0xd8
 [ef885df0] [c0491c8c] _raw_spin_unlock_irq+0x10/0x3c
 [ef885e00] [f381fe3c] NCR5380_select+0x3e4/0x6e8 [dmx3191d]
 [ef885e40] [f382026c] NCR5380_abort+0x12c/0x190 [dmx3191d]
 [ef885e60] [c02fec9c] scmd_eh_abort_handler+0x100/0x460
 [ef885e80] [c0046470] process_one_work+0x16c/0x420
 [ef885ea0] [c0046870] worker_thread+0x14c/0x430
 [ef885ed0] [c004e4f4] kthread+0xd8/0xec
 [ef885f40] [c00124d4] ret_from_kernel_thread+0x5c/0x64

Signed-off-by: Finn Thain <fthain@telegraphics.com.au>
Reviewed-by: Hannes Reinecke <hare@suse.com>
Tested-by: Ondrej Zary <linux@rainbow-software.org>

---
 drivers/scsi/NCR5380.c |    9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

Index: linux/drivers/scsi/NCR5380.c
===================================================================
--- linux.orig/drivers/scsi/NCR5380.c	2016-01-03 16:03:35.000000000 +1100
+++ linux/drivers/scsi/NCR5380.c	2016-01-03 16:03:37.000000000 +1100
@@ -2374,6 +2374,7 @@ static int NCR5380_abort(struct scsi_cmn
 
 	scmd_printk(KERN_WARNING, cmd, "aborting command\n");
 
+	spin_lock_irq(instance->host_lock);
 	NCR5380_print_status(instance);
 
 	dprintk(NDEBUG_ABORT, "scsi%d : abort called\n", instance->host_no);
@@ -2420,6 +2421,7 @@ static int NCR5380_abort(struct scsi_cmn
 			REMOVE(5, *prev, tmp, tmp->host_scribble);
 			(*prev) = (struct scsi_cmnd *) tmp->host_scribble;
 			tmp->host_scribble = NULL;
+			spin_unlock_irq(instance->host_lock);
 			tmp->result = DID_ABORT << 16;
 			dprintk(NDEBUG_ABORT, "scsi%d : abort removed command from issue queue.\n", instance->host_no);
 			tmp->scsi_done(tmp);
@@ -2443,6 +2445,7 @@ static int NCR5380_abort(struct scsi_cmn
  */
 
 	if (hostdata->connected) {
+		spin_unlock_irq(instance->host_lock);
 		dprintk(NDEBUG_ABORT, "scsi%d : abort failed, command connected.\n", instance->host_no);
 		return FAILED;
 	}
@@ -2475,8 +2478,10 @@ static int NCR5380_abort(struct scsi_cmn
 		if (cmd == tmp) {
 			dprintk(NDEBUG_ABORT, "scsi%d : aborting disconnected command.\n", instance->host_no);
 
-			if (NCR5380_select(instance, cmd))
+			if (NCR5380_select(instance, cmd)) {
+				spin_unlock_irq(instance->host_lock);
 				return FAILED;
+			}
 			dprintk(NDEBUG_ABORT, "scsi%d : nexus reestablished.\n", instance->host_no);
 
 			do_abort(instance);
@@ -2486,6 +2491,7 @@ static int NCR5380_abort(struct scsi_cmn
 					REMOVE(5, *prev, tmp, tmp->host_scribble);
 					*prev = (struct scsi_cmnd *) tmp->host_scribble;
 					tmp->host_scribble = NULL;
+					spin_unlock_irq(instance->host_lock);
 					tmp->result = DID_ABORT << 16;
 					tmp->scsi_done(tmp);
 					return SUCCESS;
@@ -2500,6 +2506,7 @@ static int NCR5380_abort(struct scsi_cmn
  * so we won't panic, but we will notify the user in case something really
  * broke.
  */
+	spin_unlock_irq(instance->host_lock);
 	printk(KERN_WARNING "scsi%d : warning : SCSI command probably completed successfully\n"
 			"         before abortion\n", instance->host_no);
 	return FAILED;
