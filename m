From: Finn Thain <fthain@telegraphics.com.au>
Subject: [PATCH v3 14/37] ncr5380: Remove pointless compiler command line override macros
Date: Wed, 12 Nov 2014 16:12:00 +1100
Message-ID: <20141112051149.815461897@telegraphics.com.au>
References: <20141112051146.525489687@telegraphics.com.au>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from kvm5.telegraphics.com.au ([98.124.60.144]:40975 "EHLO
	kvm5.telegraphics.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753202AbaKLFnJ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 12 Nov 2014 00:43:09 -0500
Content-Disposition: inline; filename=ncr5380-remove-compiler-invocation-macros
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "James E.J. Bottomley" <JBottomley@parallels.com>
Cc: Michael Schmitz <schmitzmic@gmail.com>, Sam Creasey <sammy@sammy.net>, linux-scsi@vger.kernel.org, linux-m68k@vger.kernel.org

Compile-time override of scsi host defaults is pointless for drivers that
provide module parameters and __setup options for that. Too many macros make
the code hard to read so remove them.

Signed-off-by: Finn Thain <fthain@telegraphics.com.au>
Reviewed-by: Hannes Reinecke <hare@suse.de>
Tested-by: Michael Schmitz <schmitzmic@gmail.com>

---
 drivers/scsi/atari_scsi.c |    2 +-
 drivers/scsi/atari_scsi.h |    3 ---
 drivers/scsi/mac_scsi.c   |   19 +++++++++----------
 drivers/scsi/mac_scsi.h   |   16 ----------------
 drivers/scsi/sun3_scsi.c  |   20 ++++++++++----------
 drivers/scsi/sun3_scsi.h  |   18 ------------------
 6 files changed, 20 insertions(+), 58 deletions(-)

Index: linux/drivers/scsi/mac_scsi.c
===================================================================
--- linux.orig/drivers/scsi/mac_scsi.c	2014-11-12 16:11:06.000000000 +1100
+++ linux/drivers/scsi/mac_scsi.c	2014-11-12 16:11:11.000000000 +1100
@@ -177,13 +177,12 @@ int __init macscsi_detect(struct scsi_ho
     if (macintosh_config->scsi_type != MAC_SCSI_OLD)
 	return( 0 );
 
-    /* setup variables */
-    tpnt->can_queue =
-	(setup_can_queue > 0) ? setup_can_queue : CAN_QUEUE;
-    tpnt->cmd_per_lun =
-	(setup_cmd_per_lun > 0) ? setup_cmd_per_lun : CMD_PER_LUN;
-    tpnt->sg_tablesize = 
-	(setup_sg_tablesize >= 0) ? setup_sg_tablesize : SG_TABLESIZE;
+	if (setup_can_queue > 0)
+		tpnt->can_queue = setup_can_queue;
+	if (setup_cmd_per_lun > 0)
+		tpnt->cmd_per_lun = setup_cmd_per_lun;
+	if (setup_sg_tablesize >= 0)
+		tpnt->sg_tablesize = setup_sg_tablesize;
 
     if (setup_hostid >= 0)
 	tpnt->this_id = setup_hostid;
@@ -194,7 +193,7 @@ int __init macscsi_detect(struct scsi_ho
 
 #ifdef SUPPORT_TAGS
     if (setup_use_tagged_queuing < 0)
-	setup_use_tagged_queuing = USE_TAGGED_QUEUING;
+	setup_use_tagged_queuing = 0;
 #endif
 
     /* Once we support multiple 5380s (e.g. DuoDock) we'll do
@@ -496,10 +495,10 @@ static struct scsi_host_template driver_
 	.queuecommand			= macscsi_queue_command,
 	.eh_abort_handler		= macscsi_abort,
 	.eh_bus_reset_handler		= macscsi_bus_reset,
-	.can_queue			= CAN_QUEUE,
+	.can_queue			= 16,
 	.this_id			= 7,
 	.sg_tablesize			= SG_ALL,
-	.cmd_per_lun			= CMD_PER_LUN,
+	.cmd_per_lun			= 2,
 	.use_clustering			= DISABLE_CLUSTERING
 };
 
Index: linux/drivers/scsi/mac_scsi.h
===================================================================
--- linux.orig/drivers/scsi/mac_scsi.h	2014-11-12 16:11:06.000000000 +1100
+++ linux/drivers/scsi/mac_scsi.h	2014-11-12 16:11:11.000000000 +1100
@@ -17,22 +17,6 @@
 
 #ifndef ASM
 
-#ifndef CMD_PER_LUN
-#define CMD_PER_LUN 2
-#endif
-
-#ifndef CAN_QUEUE
-#define CAN_QUEUE 16
-#endif
-
-#ifndef SG_TABLESIZE
-#define SG_TABLESIZE SG_NONE
-#endif
-
-#ifndef USE_TAGGED_QUEUING
-#define	USE_TAGGED_QUEUING 0
-#endif
-
 #include <scsi/scsicam.h>
 
 #define NCR5380_implementation_fields /* none */
Index: linux/drivers/scsi/sun3_scsi.c
===================================================================
--- linux.orig/drivers/scsi/sun3_scsi.c	2014-11-12 16:11:06.000000000 +1100
+++ linux/drivers/scsi/sun3_scsi.c	2014-11-12 16:11:11.000000000 +1100
@@ -198,12 +198,12 @@ static int __init sun3scsi_detect(struct
 #endif
 
 	/* setup variables */
-	tpnt->can_queue =
-		(setup_can_queue > 0) ? setup_can_queue : CAN_QUEUE;
-	tpnt->cmd_per_lun =
-		(setup_cmd_per_lun > 0) ? setup_cmd_per_lun : CMD_PER_LUN;
-	tpnt->sg_tablesize = 
-		(setup_sg_tablesize >= 0) ? setup_sg_tablesize : SG_TABLESIZE;
+	if (setup_can_queue > 0)
+		tpnt->can_queue = setup_can_queue;
+	if (setup_cmd_per_lun > 0)
+		tpnt->cmd_per_lun = setup_cmd_per_lun;
+	if (setup_sg_tablesize >= 0)
+		tpnt->sg_tablesize = setup_sg_tablesize;
 
 	if (setup_hostid >= 0)
 		tpnt->this_id = setup_hostid;
@@ -257,7 +257,7 @@ static int __init sun3scsi_detect(struct
 #endif
 #ifdef SUPPORT_TAGS
 	if (setup_use_tagged_queuing < 0)
-		setup_use_tagged_queuing = USE_TAGGED_QUEUING;
+		setup_use_tagged_queuing = 1;
 #endif
 
 	instance = scsi_register (tpnt, sizeof(struct NCR5380_hostdata));
@@ -683,10 +683,10 @@ static struct scsi_host_template driver_
 	.queuecommand		= sun3scsi_queue_command,
 	.eh_abort_handler      	= sun3scsi_abort,
 	.eh_bus_reset_handler  	= sun3scsi_bus_reset,
-	.can_queue		= CAN_QUEUE,
+	.can_queue		= 16,
 	.this_id		= 7,
-	.sg_tablesize		= SG_TABLESIZE,
-	.cmd_per_lun		= CMD_PER_LUN,
+	.sg_tablesize		= SG_NONE,
+	.cmd_per_lun		= 2,
 	.use_clustering		= DISABLE_CLUSTERING
 };
 
Index: linux/drivers/scsi/sun3_scsi.h
===================================================================
--- linux.orig/drivers/scsi/sun3_scsi.h	2014-11-12 16:11:06.000000000 +1100
+++ linux/drivers/scsi/sun3_scsi.h	2014-11-12 16:11:11.000000000 +1100
@@ -31,25 +31,7 @@
 
 #define IOBASE_SUN3_VMESCSI 0xff200000
 
-#ifndef CMD_PER_LUN
-#define CMD_PER_LUN 2
-#endif
-
-#ifndef CAN_QUEUE
-#define CAN_QUEUE 16
-#endif
-
-#ifndef SG_TABLESIZE
-#define SG_TABLESIZE SG_NONE
-#endif
-
-#ifndef MAX_TAGS
 #define MAX_TAGS 32
-#endif
-
-#ifndef USE_TAGGED_QUEUING
-#define	USE_TAGGED_QUEUING 1
-#endif
 
 #include <scsi/scsicam.h>
 
Index: linux/drivers/scsi/atari_scsi.c
===================================================================
--- linux.orig/drivers/scsi/atari_scsi.c	2014-11-12 16:11:06.000000000 +1100
+++ linux/drivers/scsi/atari_scsi.c	2014-11-12 16:11:11.000000000 +1100
@@ -611,7 +611,7 @@ static int __init atari_scsi_detect(stru
 
 #ifdef SUPPORT_TAGS
 	if (setup_use_tagged_queuing < 0)
-		setup_use_tagged_queuing = DEFAULT_USE_TAGGED_QUEUING;
+		setup_use_tagged_queuing = 0;
 #endif
 #ifdef REAL_DMA
 	/* If running on a Falcon and if there's TT-Ram (i.e., more than one
Index: linux/drivers/scsi/atari_scsi.h
===================================================================
--- linux.orig/drivers/scsi/atari_scsi.h	2014-11-12 16:11:06.000000000 +1100
+++ linux/drivers/scsi/atari_scsi.h	2014-11-12 16:11:11.000000000 +1100
@@ -36,9 +36,6 @@
 #define ATARI_FALCON_CMD_PER_LUN	1
 #define ATARI_FALCON_SG_TABLESIZE	SG_NONE
 
-#define	DEFAULT_USE_TAGGED_QUEUING	0
-
-
 #define	NCR5380_implementation_fields	/* none */
 
 #define NCR5380_read(reg)		  atari_scsi_reg_read( reg )


