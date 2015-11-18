From: Finn Thain <fthain@telegraphics.com.au>
Subject: [PATCH 23/71] ncr5380: Always retry arbitration and selection
Date: Wed, 18 Nov 2015 19:35:18 +1100
Message-ID: <20151118083501.871737103@telegraphics.com.au>
References: <20151118083455.331768508@telegraphics.com.au>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline; filename=ncr5380-retry-selection-phase
Sender: linux-kernel-owner@vger.kernel.org
To: "James E.J. Bottomley" <JBottomley@odin.com>, Michael Schmitz <schmitzmic@gmail.com>, linux-m68k@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

If NCR5380_select() returns -1, it means arbitration was lost or selection
failed and should be retried. If the main loop simply terminates when there
are still commands on the issue queue, they will remain queued until they
expire.

Fix this by clearing the 'done' flag after selection failure or lost
arbitration.

The "else break" clause in NCR5380_main() that gets removed here appears
to be a vestige of a long-gone loop that iterated over host instances.
See commit 491447e1fcff ("[PATCH] next NCR5380 updates") in
history/history.git.

Signed-off-by: Finn Thain <fthain@telegraphics.com.au>

---
 drivers/scsi/NCR5380.c       |    3 +--
 drivers/scsi/atari_NCR5380.c |    1 +
 2 files changed, 2 insertions(+), 2 deletions(-)

Index: linux/drivers/scsi/NCR5380.c
===================================================================
--- linux.orig/drivers/scsi/NCR5380.c	2015-11-18 19:33:33.000000000 +1100
+++ linux/drivers/scsi/NCR5380.c	2015-11-18 19:33:34.000000000 +1100
@@ -1045,8 +1045,7 @@ static void NCR5380_main(struct work_str
 			NCR5380_information_transfer(instance);
 			dprintk(NDEBUG_MAIN, "scsi%d : main() : done set false\n", instance->host_no);
 			done = 0;
-		} else
-			break;
+		}
 	} while (!done);
 	
 	spin_unlock_irq(instance->host_lock);
Index: linux/drivers/scsi/atari_NCR5380.c
===================================================================
--- linux.orig/drivers/scsi/atari_NCR5380.c	2015-11-18 19:33:33.000000000 +1100
+++ linux/drivers/scsi/atari_NCR5380.c	2015-11-18 19:33:34.000000000 +1100
@@ -1175,6 +1175,7 @@ static void NCR5380_main(struct work_str
 #endif
 						hostdata->retain_dma_intr--;
 						local_irq_restore(flags);
+						done = 0;
 						dprintk(NDEBUG_MAIN, "scsi%d: main(): select() failed, "
 							    "returned to issue_queue\n", HOSTNO);
 					}
