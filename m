From: Finn Thain <fthain@telegraphics.com.au>
Subject: [PATCH v3 23/77] ncr5380: Always retry arbitration and selection
Date: Tue, 22 Dec 2015 12:18:01 +1100
Message-ID: <20151222011744.275507291@telegraphics.com.au>
References: <20151222011737.980475848@telegraphics.com.au>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from kvm5.telegraphics.com.au ([98.124.60.144]:40507 "EHLO
	kvm5.telegraphics.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752737AbbLVCbM (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 21 Dec 2015 21:31:12 -0500
Content-Disposition: inline; filename=ncr5380-retry-selection-phase
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "James E.J. Bottomley" <JBottomley@odin.com>, Michael Schmitz <schmitzmic@gmail.com>, linux-m68k@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, "Martin K. Petersen" <martin.petersen@oracle.com>

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
--- linux.orig/drivers/scsi/NCR5380.c	2015-12-22 12:16:02.000000000 +1100
+++ linux/drivers/scsi/NCR5380.c	2015-12-22 12:16:04.000000000 +1100
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
--- linux.orig/drivers/scsi/atari_NCR5380.c	2015-12-22 12:16:02.000000000 +1100
+++ linux/drivers/scsi/atari_NCR5380.c	2015-12-22 12:16:04.000000000 +1100
@@ -1181,6 +1181,7 @@ static void NCR5380_main(struct work_str
 #endif
 						hostdata->retain_dma_intr--;
 						local_irq_restore(flags);
+						done = 0;
 						dprintk(NDEBUG_MAIN, "scsi%d: main(): select() failed, "
 							    "returned to issue_queue\n", HOSTNO);
 					}


