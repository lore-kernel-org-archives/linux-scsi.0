From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: GFP_DMA use in SCSI midlayer
Date: Mon, 02 Oct 2006 13:43:36 -0500
Message-ID: <1159814616.2945.7.camel@madmax>
References: <200610012213.24123.ak@suse.de>
	 <1159735218.3542.16.camel@mulgrave.il.steeleye.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:27104 "EHLO sabe.cs.wisc.edu")
	by vger.kernel.org with ESMTP id S1751017AbWJBSnt (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 2 Oct 2006 14:43:49 -0400
In-Reply-To: <1159735218.3542.16.camel@mulgrave.il.steeleye.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: Andi Kleen <ak@suse.de>, linux-scsi@vger.kernel.org, Christoph Lameter <clameter@sgi.com>

On Sun, 2006-10-01 at 15:40 -0500, James Bottomley wrote:
> On Sun, 2006-10-01 at 22:13 +0200, Andi Kleen wrote:
> > GFP_DMA in general is deprecated and should be replaced by appropiate
> > dma_alloc_coherent()
> 
> Um, no it shouldn't.
> 
> All of the places where we use GFP_DMA are because we might be
> addressing an ISA card or other strange mask limited card (gated usually
> by unchecked_isa_dma).  However, what is wanted in every case is
> ordinary memory, not coherent memory.  They can't simply be replaced
> with dma_alloc_coherent because
> 
> a) it will waste memory for platforms that only do it in page size
> multiples
> b) It will fail on platforms that can't do it at all.
> 
> Coherent memory is really only for device drivers to use in mailboxes
> and shared ring buffers.
> 
> > or similar.  And I can't imagine any modern systems still need them, and for 
> > the few still non CONFIG_BROKEN ISA drivers maybe some other way can be found?
> > And do they really require the mid layer data structures to be GFP_DMA too?
> 
> Well, it's the "or similar" that's still the problem.  All they need is
> ordinary memory which respects the device mask (then I can get rid of
> the unchecked_isa_dma flag as well).
> 
> One could argue, I suppose, that when we get every SCSI path to go via
> sg, then the block layer will bounce this for us, and we don't need to
> worry at all.


I think we might just need the blk_map_kern users now. For the async
execute I added the bounce code already and the block SG_IO has it
atleady. I think the blk_map_kern bounce code got dropped because we
thought the correct gfp_t would be passed in. But I think all we need is
the patch below and all the paths are take care of. The patch is not
tested. Patch was made against scsi-misc.

The last place that is sending non sg commands may just be md/dm-emc.c
but that is is just waiting on alasdair to take some patches that fix
that and a bunch of junk in there including adding bounce support. If
the patch below is ok though and dm-emc finally gets converted then it
will have sg and bonce buffer support.



Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>

diff --git a/block/ll_rw_blk.c b/block/ll_rw_blk.c
index 9c3a06b..e58b43a 100644
--- a/block/ll_rw_blk.c
+++ b/block/ll_rw_blk.c
@@ -2533,6 +2533,7 @@ int blk_rq_map_kern(request_queue_t *q, 
 	rq->bio = rq->biotail = bio;
 	blk_rq_bio_prep(q, rq, bio);
 
+	blk_queue_bounce(q, &rq->bio);
 	rq->buffer = rq->data = NULL;
 	rq->data_len = len;
 	return 0;
diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
diff --git a/fs/bio.c b/fs/bio.c


