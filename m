From: Finn Thain <fthain@telegraphics.com.au>
Subject: [PATCH 48/71] atari_NCR5380: Fix queue_size limit
Date: Wed, 18 Nov 2015 19:35:43 +1100
Message-ID: <20151118083510.491646451@telegraphics.com.au>
References: <20151118083455.331768508@telegraphics.com.au>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline; filename=atari_NCR5380-fix-queue_size-limit
Sender: linux-kernel-owner@vger.kernel.org
To: "James E.J. Bottomley" <JBottomley@odin.com>, Michael Schmitz <schmitzmic@gmail.com>, linux-m68k@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

When a target reports a QUEUE_FULL condition it causes the driver to
update the 'queue_size' limit with the number of currently allocated tags.
At least, that's what's supposed to happen, according to the comments.
Unfortunately the terms in the assignment are swapped. Fix this and
cleanup some obsolete comments.

Signed-off-by: Finn Thain <fthain@telegraphics.com.au>

---
 drivers/scsi/atari_NCR5380.c |   14 ++------------
 1 file changed, 2 insertions(+), 12 deletions(-)

Index: linux/drivers/scsi/atari_NCR5380.c
===================================================================
--- linux.orig/drivers/scsi/atari_NCR5380.c	2015-11-18 19:34:01.000000000 +1100
+++ linux/drivers/scsi/atari_NCR5380.c	2015-11-18 19:34:08.000000000 +1100
@@ -229,9 +229,7 @@ static void do_reset(struct Scsi_Host *)
  * cannot know it in advance :-( We just see a QUEUE_FULL status being
  * returned. So, in this case, the driver internal queue size assumption is
  * reduced to the number of active tags if QUEUE_FULL is returned by the
- * target. The command is returned to the mid-level, but with status changed
- * to BUSY, since --as I've seen-- the mid-level can't handle QUEUE_FULL
- * correctly.
+ * target.
  *
  * We're also not allowed running tagged commands as long as an untagged
  * command is active. And REQUEST SENSE commands after a contingent allegiance
@@ -2148,21 +2146,13 @@ static void NCR5380_information_transfer
 #ifdef SUPPORT_TAGS
 					cmd_free_tag(cmd);
 					if (status_byte(cmd->SCp.Status) == QUEUE_FULL) {
-						/* Turn a QUEUE FULL status into BUSY, I think the
-						 * mid level cannot handle QUEUE FULL :-( (The
-						 * command is retried after BUSY). Also update our
-						 * queue size to the number of currently issued
-						 * commands now.
-						 */
-						/* ++Andreas: the mid level code knows about
-						   QUEUE_FULL now. */
 						struct tag_alloc *ta = &hostdata->TagAlloc[scmd_id(cmd)][cmd->device->lun];
 						dprintk(NDEBUG_TAGS, "scsi%d: target %d lun %llu returned "
 							   "QUEUE_FULL after %d commands\n",
 							   HOSTNO, cmd->device->id, cmd->device->lun,
 							   ta->nr_allocated);
 						if (ta->queue_size > ta->nr_allocated)
-							ta->nr_allocated = ta->queue_size;
+							ta->queue_size = ta->nr_allocated;
 					}
 #else
 					hostdata->busy[cmd->device->id] &= ~(1 << cmd->device->lun);
