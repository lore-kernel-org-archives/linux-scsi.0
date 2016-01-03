From: Finn Thain <fthain@telegraphics.com.au>
Subject: [PATCH v4 23/78] ncr5380: Always retry arbitration and selection
Date: Sun, 03 Jan 2016 16:05:24 +1100
Message-ID: <20160103050507.131597293@telegraphics.com.au>
References: <20160103050501.042035135@telegraphics.com.au>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline; filename=ncr5380-retry-selection-phase
Sender: linux-kernel-owner@vger.kernel.org
To: "James E.J. Bottomley" <JBottomley@odin.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Michael Schmitz <schmitzmic@gmail.com>, linux-m68k@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
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
Reviewed-by: Hannes Reinecke <hare@suse.com>
Tested-by: Ondrej Zary <linux@rainbow-software.org>
Tested-by: Michael Schmitz <schmitzmic@gmail.com>

---
 drivers/scsi/NCR5380.c       |    3 +--
 drivers/scsi/atari_NCR5380.c |    1 +
 2 files changed, 2 insertions(+), 2 deletions(-)

Index: linux/drivers/scsi/NCR5380.c
===================================================================
--- linux.orig/drivers/scsi/NCR5380.c	2016-01-03 16:03:28.000000000 +1100
+++ linux/drivers/scsi/NCR5380.c	2016-01-03 16:03:30.000000000 +1100
@@ -1052,8 +1052,7 @@ static void NCR5380_main(struct work_str
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
--- linux.orig/drivers/scsi/atari_NCR5380.c	2016-01-03 16:03:28.000000000 +1100
+++ linux/drivers/scsi/atari_NCR5380.c	2016-01-03 16:03:30.000000000 +1100
@@ -1181,6 +1181,7 @@ static void NCR5380_main(struct work_str
 #endif
 						hostdata->retain_dma_intr--;
 						local_irq_restore(flags);
+						done = 0;
 						dprintk(NDEBUG_MAIN, "scsi%d: main(): select() failed, "
 							    "returned to issue_queue\n", HOSTNO);
 					}
