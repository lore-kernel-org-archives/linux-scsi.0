From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH] remove that anoying in_atomic()...
Date: Sat, 23 Nov 2002 03:42:06 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20021123034206.A11347@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@steeleye.com
Cc: linux-scsi@vger.kernel.org

We're always called from scsi_prep_fn which is guaranteed to be called
under a spinlock from the block layer.

Also nuke more broken includes.


--- 1.54/drivers/scsi/scsi_lib.c	Fri Nov 22 12:59:03 2002
+++ edited/drivers/scsi/scsi_lib.c	Sat Nov 23 02:45:56 2002
@@ -7,18 +7,15 @@
  *                        of people at Linux Expo.
  */
 
-#include <linux/string.h>
-#include <linux/slab.h>
 #include <linux/bio.h>
-#include <linux/kernel.h>
 #include <linux/blk.h>
-#include <asm/hardirq.h>
-#include <linux/smp_lock.h>
 #include <linux/completion.h>
+#include <linux/kernel.h>
+#include <linux/slab.h>
 
 #include "scsi.h"
 #include "hosts.h"
-#include <scsi/scsi_ioctl.h>
+
 
 /*
  * Function:    scsi_insert_special_cmd()
@@ -665,7 +662,7 @@
 {
 	struct request     *req = SCpnt->request;
 	struct scatterlist *sgpnt;
-	int count, gfp_mask, ret = 0;
+	int count, ret = 0;
 
 	/*
 	 * if this is a rq->data based REQ_BLOCK_PC, setup for a non-sg xfer
@@ -685,16 +682,10 @@
 	 */
 	SCpnt->use_sg = req->nr_phys_segments;
 
-	gfp_mask = GFP_NOIO;
-	if (likely(in_atomic())) {
-		gfp_mask &= ~__GFP_WAIT;
-		gfp_mask |= __GFP_HIGH;
-	}
-
 	/*
 	 * if sg table allocation fails, requeue request later.
 	 */
-	sgpnt = scsi_alloc_sgtable(SCpnt, gfp_mask);
+	sgpnt = scsi_alloc_sgtable(SCpnt, GFP_ATOMIC);
 	if (unlikely(!sgpnt)) {
 		req->flags |= REQ_SPECIAL;
 		ret = BLKPREP_DEFER;
