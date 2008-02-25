From: Andi Kleen <andi@firstfloor.org>
Subject: [PATCH] Don't use unnecessary GFP_ATOMIC in sg.c v2
Date: Mon, 25 Feb 2008 10:09:48 +0100
Message-ID: <20080225090948.GA5843@basil.nowhere.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp-out03.alice-dsl.net ([88.44.63.5]:14115 "EHLO
	smtp-out03.alice-dsl.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751978AbYBYJJv (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 25 Feb 2008 04:09:51 -0500
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org

Don't use unnecessary GFP_ATOMIC in sg.c v2

[Update for the previous version of the patch]

sg.c uses GFP_ATOMIC for a lot of allocations where it isn't necessary.
There are no locks hold and I don't see any other reasons why GFP_ATOMIC
should be needed here. So remove them.

Depends on the earlier GFP_DMA patchkit, but only because it happens
to patch the same places (no real functional dependency) 

Tested by burning a CD on a kernel with all lock/sleep/etc. debugging enabled.

v2: Actually always use GFP_KERNEL instead of 0 (which is equivalent to 
    GFP_ATOMIC). Retested.

Signed-off-by: Andi Kleen <ak@suse.de>

---
 drivers/scsi/sg.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

Index: linux/drivers/scsi/sg.c
===================================================================
--- linux.orig/drivers/scsi/sg.c
+++ linux/drivers/scsi/sg.c
@@ -745,7 +745,7 @@ sg_common_write(Sg_fd * sfp, Sg_request 
 	if (scsi_execute_async(sdp->device, cmnd, hp->cmd_len, data_dir, srp->data.buffer,
 				hp->dxfer_len, srp->data.k_use_sg, timeout,
 				SG_DEFAULT_RETRIES, srp, sg_cmd_done,
-				GFP_ATOMIC)) {
+				GFP_KERNEL)) {
 		SCSI_LOG_TIMEOUT(1, printk("sg_common_write: scsi_execute_async failed\n"));
 		/*
 		 * most likely out of mem, but could also be a bad map
@@ -1654,7 +1654,7 @@ static int
 sg_build_sgat(Sg_scatter_hold * schp, const Sg_fd * sfp, int tablesize)
 {
 	int sg_bufflen = tablesize * sizeof(struct scatterlist);
-	gfp_t gfp_flags = GFP_ATOMIC | __GFP_NOWARN;
+	gfp_t gfp_flags = GFP_KERNEL | __GFP_NOWARN;
 
 	schp->buffer = kzalloc(sg_bufflen, gfp_flags);
 	if (!schp->buffer)
@@ -1694,7 +1694,7 @@ st_map_user_pages(struct scatterlist *sg
 	if (count == 0)
 		return 0;
 
-	if ((pages = kmalloc(max_pages * sizeof(*pages), GFP_ATOMIC)) == NULL)
+	if ((pages = kmalloc(max_pages * sizeof(*pages), GFP_KERNEL)) == NULL)
 		return -ENOMEM;
 
         /* Try to fault in all of the necessary pages */
@@ -2323,7 +2323,7 @@ sg_add_sfp(Sg_device * sdp, int dev)
 	unsigned long iflags;
 	int bufflen;
 
-	sfp = kzalloc(sizeof(*sfp), GFP_ATOMIC | __GFP_NOWARN);
+	sfp = kzalloc(sizeof(*sfp), GFP_KERNEL|__GFP_NOWARN);
 	if (!sfp)
 		return NULL;
 
@@ -2452,7 +2452,7 @@ sg_page_malloc(int rqSz, int *retSzp)
 	if ((rqSz <= 0) || (NULL == retSzp))
 		return resp;
 
-	page_mask = GFP_ATOMIC | __GFP_COMP | __GFP_NOWARN;
+	page_mask = GFP_KERNEL | __GFP_COMP | __GFP_NOWARN;
 
 	for (order = 0, a_size = PAGE_SIZE; a_size < rqSz;
 	     order++, a_size <<= 1) ;
