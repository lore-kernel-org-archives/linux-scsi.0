From: Finn Thain <fthain@telegraphics.com.au>
Subject: [PATCH 18/71] ncr5380: Eliminate USLEEP_WAITLONG delay
Date: Wed, 18 Nov 2015 19:35:13 +1100
Message-ID: <20151118083500.081770795@telegraphics.com.au>
References: <20151118083455.331768508@telegraphics.com.au>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from kvm5.telegraphics.com.au ([98.124.60.144]:43836 "EHLO
	kvm5.telegraphics.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932540AbbKRIqX (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 18 Nov 2015 03:46:23 -0500
Content-Disposition: inline; filename=ncr5380-eliminate-USLEEP_WAITLONG
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "James E.J. Bottomley" <JBottomley@odin.com>, Michael Schmitz <schmitzmic@gmail.com>, linux-m68k@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

Linux 2.1.105 introduced the USLEEP_WAITLONG delay, apparently "needed for
Mustek scanners". It is intended to stall the issue queue for 5 seconds.
There are a number of problems with this.

1. Only g_NCR5380 enables the delay, which implies that the other five
   drivers using the NCR5380.c core driver remain incompatible with
   Mustek scanners.

2. The delay is not implemented by atari_NCR5380.c, which is problematic
   for re-unifying the two core driver forks.

3. The delay is implemented using NCR5380_set_timer() which makes it
   unreliable. A new command queued by the mid-layer cancels the delay.

4. The delay is applied indiscriminately in several situations in which
   NCR5380_select() returns -1. These are-- reselection by the target,
   failure of the target to assert BSY, and failure of the target to
   assert REQ. It's clear from the comments that USLEEP_WAITLONG is not
   relevant to the reselection case. And reportedly, these scanners do
   not disconnect.

5. atari_NCR5380.c was forked before Linux 2.1.105, so it was spared some
   of the damage done to NCR5380.c. In this case, the atari_NCR5380.c core
   driver was more standard-compliant and may not have needed any
   workaround like the USLEEP_WAITLONG kludge. The compliance issue was
   addressed in the previous patch.

If these scanners still don't work, we need a better solution. Retrying
selection until EH aborts a command offers equivalent robustness. Bugs in
the existing driver prevent EH working correctly but this is addressed in
a subsequent patch. Remove USLEEP_WAITLONG.

Signed-off-by: Finn Thain <fthain@telegraphics.com.au>

---
 drivers/scsi/NCR5380.c   |   19 +++++--------------
 drivers/scsi/g_NCR5380.c |    1 -
 2 files changed, 5 insertions(+), 15 deletions(-)

Index: linux/drivers/scsi/NCR5380.c
===================================================================
--- linux.orig/drivers/scsi/NCR5380.c	2015-11-18 19:33:24.000000000 +1100
+++ linux/drivers/scsi/NCR5380.c	2015-11-18 19:33:25.000000000 +1100
@@ -468,10 +468,6 @@ static void NCR5380_print_phase(struct S
 #ifndef USLEEP_POLL
 #define USLEEP_POLL msecs_to_jiffies(200)
 #endif
-#ifndef USLEEP_WAITLONG
-/* RvC: (reasonable time to wait on select error) */
-#define USLEEP_WAITLONG USLEEP_SLEEP
-#endif
 
 /* 
  * Function : int should_disconnect (unsigned char cmd)
@@ -619,8 +615,8 @@ static void prepare_info(struct Scsi_Hos
 	         "can_queue %d, cmd_per_lun %d, "
 	         "sg_tablesize %d, this_id %d, "
 	         "flags { %s%s%s%s}, "
-#if defined(USLEEP_POLL) && defined(USLEEP_WAITLONG)
-		 "USLEEP_POLL %lu, USLEEP_WAITLONG %lu, "
+#if defined(USLEEP_POLL) && defined(USLEEP_SLEEP)
+		 "USLEEP_POLL %lu, USLEEP_SLEEP %lu, "
 #endif
 	         "options { %s} ",
 	         instance->hostt->name, instance->io_port, instance->n_io_port,
@@ -631,8 +627,8 @@ static void prepare_info(struct Scsi_Hos
 	         hostdata->flags & FLAG_DTC3181E      ? "DTC3181E "      : "",
 	         hostdata->flags & FLAG_NO_PSEUDO_DMA ? "NO_PSEUDO_DMA " : "",
 	         hostdata->flags & FLAG_TOSHIBA_DELAY ? "TOSHIBA_DELAY "  : "",
-#if defined(USLEEP_POLL) && defined(USLEEP_WAITLONG)
-	         USLEEP_POLL, USLEEP_WAITLONG,
+#if defined(USLEEP_POLL) && defined(USLEEP_SLEEP)
+	         USLEEP_POLL, USLEEP_SLEEP,
 #endif
 #ifdef AUTOPROBE_IRQ
 	         "AUTOPROBE_IRQ "
@@ -1030,15 +1026,10 @@ static void NCR5380_main(struct work_str
 			if (!NCR5380_select(instance, tmp)) {
 				/* OK or bad target */
 			} else {
-				/* RvC: device failed, so we wait a long time
-				   this is needed for Mustek scanners, that
-				   do not respond to commands immediately
-				   after a scan */
-				printk(KERN_DEBUG "scsi%d: device %d did not respond in time\n", instance->host_no, tmp->device->id);
 				LIST(tmp, hostdata->issue_queue);
 				tmp->host_scribble = (unsigned char *) hostdata->issue_queue;
 				hostdata->issue_queue = tmp;
-				NCR5380_set_timer(hostdata, USLEEP_WAITLONG);
+				done = 0;
 			}
 		}	/* if hostdata->selecting */
 		if (hostdata->connected
Index: linux/drivers/scsi/g_NCR5380.c
===================================================================
--- linux.orig/drivers/scsi/g_NCR5380.c	2015-11-18 19:33:12.000000000 +1100
+++ linux/drivers/scsi/g_NCR5380.c	2015-11-18 19:33:25.000000000 +1100
@@ -59,7 +59,6 @@
 /* settings for DTC3181E card with only Mustek scanner attached */
 #define USLEEP_POLL	msecs_to_jiffies(10)
 #define USLEEP_SLEEP	msecs_to_jiffies(200)
-#define USLEEP_WAITLONG	msecs_to_jiffies(5000)
 
 #define AUTOPROBE_IRQ
 


