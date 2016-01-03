From: Finn Thain <fthain@telegraphics.com.au>
Subject: [PATCH v4 12/78] ncr5380: Remove unused hostdata->aborted flag
Date: Sun, 03 Jan 2016 16:05:13 +1100
Message-ID: <20160103050504.231786500@telegraphics.com.au>
References: <20160103050501.042035135@telegraphics.com.au>
Return-path: <linux-m68k-owner@vger.kernel.org>
Content-Disposition: inline; filename=ncr5380-remove-unused-aborted-flag
Sender: linux-m68k-owner@vger.kernel.org
To: "James E.J. Bottomley" <JBottomley@odin.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Michael Schmitz <schmitzmic@gmail.com>, linux-m68k@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

The aborted flag was introduced in v1.1.38 but never used. Remove it.

Signed-off-by: Finn Thain <fthain@telegraphics.com.au>
Reviewed-by: Hannes Reinecke <hare@suse.com>
Tested-by: Ondrej Zary <linux@rainbow-software.org>
Tested-by: Michael Schmitz <schmitzmic@gmail.com>

---
 drivers/scsi/NCR5380.c       |    2 --
 drivers/scsi/NCR5380.h       |    1 -
 drivers/scsi/atari_NCR5380.c |    2 --
 3 files changed, 5 deletions(-)

Index: linux/drivers/scsi/NCR5380.c
===================================================================
--- linux.orig/drivers/scsi/NCR5380.c	2016-01-03 16:03:12.000000000 +1100
+++ linux/drivers/scsi/NCR5380.c	2016-01-03 16:03:13.000000000 +1100
@@ -781,7 +781,6 @@ static int NCR5380_init(struct Scsi_Host
 	if(in_interrupt())
 		printk(KERN_ERR "NCR5380_init called with interrupts off!\n");
 
-	hostdata->aborted = 0;
 	hostdata->id_mask = 1 << instance->this_id;
 	for (i = hostdata->id_mask; i <= 0x80; i <<= 1)
 		if (i > hostdata->id_mask)
@@ -2574,7 +2573,6 @@ static int NCR5380_abort(struct scsi_cmn
 
 	if (hostdata->connected == cmd) {
 		dprintk(NDEBUG_ABORT, "scsi%d : aborting connected command\n", instance->host_no);
-		hostdata->aborted = 1;
 /*
  * We should perform BSY checking, and make sure we haven't slipped
  * into BUS FREE.
Index: linux/drivers/scsi/atari_NCR5380.c
===================================================================
--- linux.orig/drivers/scsi/atari_NCR5380.c	2016-01-03 16:03:12.000000000 +1100
+++ linux/drivers/scsi/atari_NCR5380.c	2016-01-03 16:03:13.000000000 +1100
@@ -813,7 +813,6 @@ static int __init NCR5380_init(struct Sc
 	SETUP_HOSTDATA(instance);
 
 	hostdata->host = instance;
-	hostdata->aborted = 0;
 	hostdata->id_mask = 1 << instance->this_id;
 	hostdata->id_higher_mask = 0;
 	for (i = hostdata->id_mask; i <= 0x80; i <<= 1)
@@ -2834,7 +2833,6 @@ int NCR5380_abort(struct scsi_cmnd *cmd)
 		 */
 
 		if (do_abort(instance) == 0) {
-			hostdata->aborted = 1;
 			hostdata->connected = NULL;
 			cmd->result = DID_ABORT << 16;
 #ifdef SUPPORT_TAGS
Index: linux/drivers/scsi/NCR5380.h
===================================================================
--- linux.orig/drivers/scsi/NCR5380.h	2016-01-03 16:03:09.000000000 +1100
+++ linux/drivers/scsi/NCR5380.h	2016-01-03 16:03:13.000000000 +1100
@@ -271,7 +271,6 @@ struct NCR5380_hostdata {
 	volatile int restart_select;		/* we have disconnected,
 						   used to restart 
 						   NCR5380_select() */
-	volatile unsigned aborted:1;		/* flag, says aborted */
 	int flags;
 	unsigned long time_expires;		/* in jiffies, set prior to sleeping */
 	int select_time;			/* timer in select for target response */
