From: Finn Thain <fthain@telegraphics.com.au>
Subject: [PATCH v4 16/78] ncr5380: Proceed with next command after NCR5380_select() calls scsi_done
Date: Sun, 03 Jan 2016 16:05:17 +1100
Message-ID: <20160103050505.281832738@telegraphics.com.au>
References: <20160103050501.042035135@telegraphics.com.au>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline; filename=ncr5380-drop-completed-command
Sender: linux-kernel-owner@vger.kernel.org
To: "James E.J. Bottomley" <JBottomley@odin.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Michael Schmitz <schmitzmic@gmail.com>, linux-m68k@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

If a target disappears from the SCSI bus, NCR5380_select() may
subsequently fail with a time-out. In this situation, scsi_done is
called and NCR5380_select() returns 0. Both hostdata->connected and
hostdata->selecting are NULL and the main loop should proceed with
the next command in the issue queue. Clarify this logic.

Signed-off-by: Finn Thain <fthain@telegraphics.com.au>
Reviewed-by: Hannes Reinecke <hare@suse.com>
Tested-by: Ondrej Zary <linux@rainbow-software.org>
Tested-by: Michael Schmitz <schmitzmic@gmail.com>

---

Good code style would be,

	if (this) {
		/* do stuff */
	}

rather than,

	if (!this) {
	} else {
		/* do stuff */
	}

But I've used the latter form at this point in the series for a cleaner
diff between NCR5380.c and atari_NC5380.c, making it easier to gradually
reduce discrepancies. Code style gets fixed up along the way.

---
 drivers/scsi/NCR5380.c       |    8 ++++++--
 drivers/scsi/atari_NCR5380.c |    8 ++++----
 2 files changed, 10 insertions(+), 6 deletions(-)

Index: linux/drivers/scsi/NCR5380.c
===================================================================
--- linux.orig/drivers/scsi/NCR5380.c	2016-01-03 16:03:17.000000000 +1100
+++ linux/drivers/scsi/NCR5380.c	2016-01-03 16:03:18.000000000 +1100
@@ -1007,14 +1007,18 @@ static void NCR5380_main(struct work_str
 					 */
 
 					if (!NCR5380_select(instance, tmp)) {
-						break;
+						/* OK or bad target */
 					} else {
+						/* Need to retry */
 						LIST(tmp, hostdata->issue_queue);
 						tmp->host_scribble = (unsigned char *) hostdata->issue_queue;
 						hostdata->issue_queue = tmp;
 						done = 0;
 						dprintk(NDEBUG_MAIN|NDEBUG_QUEUES, "scsi%d : main(): select() failed, returned to issue_queue\n", instance->host_no);
 					}
+					if (hostdata->connected ||
+					    hostdata->selecting)
+						break;
 					/* lock held here still */
 				}	/* if target/lun is not busy */
 			}	/* for */
@@ -1024,7 +1028,7 @@ static void NCR5380_main(struct work_str
 			tmp = (struct scsi_cmnd *) hostdata->selecting;
 			/* Selection will drop and retake the lock */
 			if (!NCR5380_select(instance, tmp)) {
-				/* Ok ?? */
+				/* OK or bad target */
 			} else {
 				/* RvC: device failed, so we wait a long time
 				   this is needed for Mustek scanners, that
Index: linux/drivers/scsi/atari_NCR5380.c
===================================================================
--- linux.orig/drivers/scsi/atari_NCR5380.c	2016-01-03 16:03:17.000000000 +1100
+++ linux/drivers/scsi/atari_NCR5380.c	2016-01-03 16:03:18.000000000 +1100
@@ -1139,13 +1139,13 @@ static void NCR5380_main(struct work_str
 					cmd_get_tag(tmp, tmp->cmnd[0] != REQUEST_SENSE);
 #endif
 					if (!NCR5380_select(instance, tmp)) {
+						/* OK or bad target */
 						local_irq_disable();
 						hostdata->retain_dma_intr--;
-						/* release if target did not response! */
 						maybe_release_dma_irq(instance);
 						local_irq_restore(flags);
-						break;
 					} else {
+						/* Need to retry */
 						local_irq_disable();
 						LIST(tmp, hostdata->issue_queue);
 						SET_NEXT(tmp, hostdata->issue_queue);
@@ -1157,9 +1157,9 @@ static void NCR5380_main(struct work_str
 						local_irq_restore(flags);
 						dprintk(NDEBUG_MAIN, "scsi%d: main(): select() failed, "
 							    "returned to issue_queue\n", HOSTNO);
-						if (hostdata->connected)
-							break;
 					}
+					if (hostdata->connected)
+						break;
 				} /* if target/lun/target queue is not busy */
 			} /* for issue_queue */
 		} /* if (!hostdata->connected) */
