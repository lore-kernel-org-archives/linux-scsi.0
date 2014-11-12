From: Finn Thain <fthain@telegraphics.com.au>
Subject: [PATCH v3 34/37] atari_NCR5380: Move static TagAlloc array to host data
Date: Wed, 12 Nov 2014 16:12:20 +1100
Message-ID: <20141112051154.515485971@telegraphics.com.au>
References: <20141112051146.525489687@telegraphics.com.au>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from kvm5.telegraphics.com.au ([98.124.60.144]:40991 "EHLO
	kvm5.telegraphics.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753562AbaKLFnU (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 12 Nov 2014 00:43:20 -0500
Content-Disposition: inline; filename=atari_NCR5380-move-TagAlloc-array
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "James E.J. Bottomley" <JBottomley@parallels.com>
Cc: Michael Schmitz <schmitzmic@gmail.com>, Sam Creasey <sammy@sammy.net>, linux-scsi@vger.kernel.org, linux-m68k@vger.kernel.org

The atari_NCR5380.c core driver keeps some per-host data in a static
variable which limits the driver to a single instance. Fix this by moving
TagAlloc to the hostdata struct.

Signed-off-by: Finn Thain <fthain@telegraphics.com.au>
Reviewed-by: Hannes Reinecke <hare@suse.de>
Tested-by: Michael Schmitz <schmitzmic@gmail.com>

---
 drivers/scsi/NCR5380.h       |   12 ++++++++++++
 drivers/scsi/atari_NCR5380.c |   27 +++++++++------------------
 2 files changed, 21 insertions(+), 18 deletions(-)

Index: linux/drivers/scsi/NCR5380.h
===================================================================
--- linux.orig/drivers/scsi/NCR5380.h	2014-11-12 16:11:39.000000000 +1100
+++ linux/drivers/scsi/NCR5380.h	2014-11-12 16:11:41.000000000 +1100
@@ -245,6 +245,15 @@
 #define FLAG_TAGGED_QUEUING		64	/* as X3T9.2 spelled it */
 
 #ifndef ASM
+
+#ifdef SUPPORT_TAGS
+struct tag_alloc {
+	DECLARE_BITMAP(allocated, MAX_TAGS);
+	int nr_allocated;
+	int queue_size;
+};
+#endif
+
 struct NCR5380_hostdata {
 	NCR5380_implementation_fields;		/* implementation specific */
 	struct Scsi_Host *host;			/* Host backpointer */
@@ -274,6 +283,9 @@ struct NCR5380_hostdata {
 	int read_overruns;                /* number of bytes to cut from a
 	                                   * transfer to handle chip overruns */
 	int retain_dma_intr;
+#ifdef SUPPORT_TAGS
+	struct tag_alloc TagAlloc[8][8];	/* 8 targets and 8 LUNs */
+#endif
 #ifdef PSEUDO_DMA
 	unsigned spin_max_r;
 	unsigned spin_max_w;
Index: linux/drivers/scsi/atari_NCR5380.c
===================================================================
--- linux.orig/drivers/scsi/atari_NCR5380.c	2014-11-12 16:11:39.000000000 +1100
+++ linux/drivers/scsi/atari_NCR5380.c	2014-11-12 16:11:41.000000000 +1100
@@ -274,26 +274,17 @@ static struct scsi_host_template *the_te
  * important: the tag bit must be cleared before 'nr_allocated' is decreased.
  */
 
-typedef struct {
-	DECLARE_BITMAP(allocated, MAX_TAGS);
-	int nr_allocated;
-	int queue_size;
-} TAG_ALLOC;
-
-static TAG_ALLOC TagAlloc[8][8];	/* 8 targets and 8 LUNs */
-
-
 static void __init init_tags(struct NCR5380_hostdata *hostdata)
 {
 	int target, lun;
-	TAG_ALLOC *ta;
+	struct tag_alloc *ta;
 
 	if (!(hostdata->flags & FLAG_TAGGED_QUEUING))
 		return;
 
 	for (target = 0; target < 8; ++target) {
 		for (lun = 0; lun < 8; ++lun) {
-			ta = &TagAlloc[target][lun];
+			ta = &hostdata->TagAlloc[target][lun];
 			bitmap_zero(ta->allocated, MAX_TAGS);
 			ta->nr_allocated = 0;
 			/* At the beginning, assume the maximum queue size we could
@@ -324,8 +315,8 @@ static int is_lun_busy(struct scsi_cmnd
 	    !(hostdata->flags & FLAG_TAGGED_QUEUING) ||
 	    !cmd->device->tagged_supported)
 		return 0;
-	if (TagAlloc[cmd->device->id][lun].nr_allocated >=
-	    TagAlloc[cmd->device->id][lun].queue_size) {
+	if (hostdata->TagAlloc[scmd_id(cmd)][lun].nr_allocated >=
+	    hostdata->TagAlloc[scmd_id(cmd)][lun].queue_size) {
 		dprintk(NDEBUG_TAGS, "scsi%d: target %d lun %d: no free tags\n",
 			   H_NO(cmd), cmd->device->id, lun);
 		return 1;
@@ -355,7 +346,7 @@ static void cmd_get_tag(struct scsi_cmnd
 		dprintk(NDEBUG_TAGS, "scsi%d: target %d lun %d now allocated by untagged "
 			   "command\n", H_NO(cmd), cmd->device->id, lun);
 	} else {
-		TAG_ALLOC *ta = &TagAlloc[cmd->device->id][lun];
+		struct tag_alloc *ta = &hostdata->TagAlloc[scmd_id(cmd)][lun];
 
 		cmd->tag = find_first_zero_bit(ta->allocated, MAX_TAGS);
 		set_bit(cmd->tag, ta->allocated);
@@ -385,7 +376,7 @@ static void cmd_free_tag(struct scsi_cmn
 		printk(KERN_NOTICE "scsi%d: trying to free bad tag %d!\n",
 		       H_NO(cmd), cmd->tag);
 	} else {
-		TAG_ALLOC *ta = &TagAlloc[cmd->device->id][lun];
+		struct tag_alloc *ta = &hostdata->TagAlloc[scmd_id(cmd)][lun];
 		clear_bit(cmd->tag, ta->allocated);
 		ta->nr_allocated--;
 		dprintk(NDEBUG_TAGS, "scsi%d: freed tag %d for target %d lun %d\n",
@@ -397,14 +388,14 @@ static void cmd_free_tag(struct scsi_cmn
 static void free_all_tags(struct NCR5380_hostdata *hostdata)
 {
 	int target, lun;
-	TAG_ALLOC *ta;
+	struct tag_alloc *ta;
 
 	if (!(hostdata->flags & FLAG_TAGGED_QUEUING))
 		return;
 
 	for (target = 0; target < 8; ++target) {
 		for (lun = 0; lun < 8; ++lun) {
-			ta = &TagAlloc[target][lun];
+			ta = &hostdata->TagAlloc[target][lun];
 			bitmap_zero(ta->allocated, MAX_TAGS);
 			ta->nr_allocated = 0;
 		}
@@ -2205,7 +2196,7 @@ static void NCR5380_information_transfer
 						 */
 						/* ++Andreas: the mid level code knows about
 						   QUEUE_FULL now. */
-						TAG_ALLOC *ta = &TagAlloc[cmd->device->id][cmd->device->lun];
+						struct tag_alloc *ta = &hostdata->TagAlloc[scmd_id(cmd)][cmd->device->lun];
 						dprintk(NDEBUG_TAGS, "scsi%d: target %d lun %llu returned "
 							   "QUEUE_FULL after %d commands\n",
 							   HOSTNO, cmd->device->id, cmd->device->lun,


