From: Jeremy Higdon <jeremy@sgi.com>
Subject: max_hw_segments vs. max_phys_segments and scsi_alloc_queue()
Date: Wed, 25 Feb 2004 23:15:58 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040226071558.GA559837@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtvcafw.sgi.com ([192.48.171.6]:12217 "EHLO rj.sgi.com")
	by vger.kernel.org with ESMTP id S262324AbUBZHP7 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 26 Feb 2004 02:15:59 -0500
Received: from cthulhu.engr.sgi.com (cthulhu.engr.sgi.com [192.26.80.2])
	by rj.sgi.com (8.12.9/8.12.9/linux-outbound_gateway-1.1) with ESMTP id i1Q6HtO9015377
	for <linux-scsi@vger.kernel.org>; Wed, 25 Feb 2004 22:17:55 -0800
Received: from classic.engr.sgi.com (classic.engr.sgi.com [163.154.5.111])
	by cthulhu.engr.sgi.com (SGI-8.12.5/8.12.5) with ESMTP id i1Q7Fwio14208160
	for <linux-scsi@vger.kernel.org>; Wed, 25 Feb 2004 23:15:58 -0800 (PST)
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: jbarnes@cthulhu.engr.sgi.com

In scsi_alloc_queue(), I see the following two lines:

	blk_queue_max_hw_segments(q, shost->sg_tablesize);
	blk_queue_max_phys_segments(q, MAX_PHYS_SEGMENTS);

I've been looking through the block code a bit, and it looks to me
as though max_phys_segments more accurately describes what the
I/O device hardware is capable of, while max_hw_segments is used
when you have an IOMMU.

That is, max_hw_segments is the number of discrete segments that
a PCI device would see, while max_phys_segments would be the
max s/g list size that a PCI device could handle.

It further seems as though when there is no IOMMU that the number
of hw_segments will equal the number of phys_segments, at least if I
understand the code in blk_recount_segments() and the comments
around the definition of BIO_VMERGE_BOUNDARY in
include/asm-ia64/io.h.

In particular, on ia64 machines, where BIO_VMERGE_BOUNDARY is
currently 0, and thus, the number of hw_segments equals the number
of phys_segments, we should be using the host's sg_tablesize to
set the max number of phys segments (as well as the max number
of hw segments).  I see no reason why this wouldn't carry forward
to the other architectures, though there may be limits to the
total amount of data that could be mapped.  This would have to
be fed to the block layer from the arch layer, though, I think.

Does this make sense, or have I completely missed something?

thanks

jeremy


===== drivers/scsi/scsi_lib.c 1.120 vs edited =====
--- 1.120/drivers/scsi/scsi_lib.c	Mon Feb 23 06:21:36 2004
+++ edited/drivers/scsi/scsi_lib.c	Wed Feb 25 23:13:35 2004
@@ -1285,7 +1285,7 @@
 	blk_queue_prep_rq(q, scsi_prep_fn);
 
 	blk_queue_max_hw_segments(q, shost->sg_tablesize);
-	blk_queue_max_phys_segments(q, MAX_PHYS_SEGMENTS);
+	blk_queue_max_phys_segments(q, shost->sg_tablesize);
 	blk_queue_max_sectors(q, shost->max_sectors);
 	blk_queue_bounce_limit(q, scsi_calculate_bounce_limit(shost));
 	blk_queue_segment_boundary(q, shost->dma_boundary);
