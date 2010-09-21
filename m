From: Malahal Naineni <malahal@us.ibm.com>
Subject: [PATCH] block: set the bounce_pfn to the actual DMA limit rather than
	to max memory
Date: Tue, 21 Sep 2010 15:22:30 -0700
Message-ID: <c9516154fabc03112353.1285107750@malahal>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e34.co.us.ibm.com ([32.97.110.152]:35316 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751905Ab0IUWXT (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 21 Sep 2010 18:23:19 -0400
Received: from d03relay05.boulder.ibm.com (d03relay05.boulder.ibm.com [9.17.195.107])
	by e34.co.us.ibm.com (8.14.4/8.13.1) with ESMTP id o8LMDwoV022379
	for <linux-scsi@vger.kernel.org>; Tue, 21 Sep 2010 16:13:58 -0600
Received: from d03av01.boulder.ibm.com (d03av01.boulder.ibm.com [9.17.195.167])
	by d03relay05.boulder.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id o8LMNH2o077642
	for <linux-scsi@vger.kernel.org>; Tue, 21 Sep 2010 16:23:18 -0600
Received: from d03av01.boulder.ibm.com (loopback [127.0.0.1])
	by d03av01.boulder.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id o8LMNHwq027176
	for <linux-scsi@vger.kernel.org>; Tue, 21 Sep 2010 16:23:17 -0600
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jaxboe@fusionio.com, dm-devel@redhat.com, linux-scsi@vger.kernel.org

The bounce_pfn of the request queue in 64 bit systems is set to the
current max_low_pfn. Adding more memory later makes this incorrect.
Memory allocated beyond this boot time max_low_pfn appear to require
bounce buffers (bounce buffers are actually not allocated but used in
calculating segments that may result in "over max segments limit"
errors).

Signed-off-by: Malahal Naineni (malahal@us.ibm.com)

diff -r 09daf852c1c5 -r c9516154fabc block/blk-settings.c
--- a/block/blk-settings.c	Thu Sep 09 12:10:43 2010 -0700
+++ b/block/blk-settings.c	Mon Sep 13 10:15:24 2010 -0700
@@ -214,16 +214,14 @@ void blk_queue_bounce_limit(struct reque
 	 */
 	if (b_pfn < (min_t(u64, 0xffffffffUL, BLK_BOUNCE_HIGH) >> PAGE_SHIFT))
 		dma = 1;
-	q->limits.bounce_pfn = max_low_pfn;
 #else
 	if (b_pfn < blk_max_low_pfn)
 		dma = 1;
+#endif
 	q->limits.bounce_pfn = b_pfn;
-#endif
 	if (dma) {
 		init_emergency_isa_pool();
 		q->limits.bounce_gfp = GFP_NOIO | GFP_DMA;
-		q->limits.bounce_pfn = b_pfn;
 	}
 }
 EXPORT_SYMBOL(blk_queue_bounce_limit);
