From: David Miller <davem@davemloft.net>
Subject: Re: [PATCH] SPARC64: fix iommu sg chaining
Date: Wed, 17 Oct 2007 03:54:41 -0700 (PDT)
Message-ID: <20071017.035441.74746708.davem@davemloft.net>
References: <20071017084528.GI5043@kernel.dk>
	<20071017.021305.74746838.davem@davemloft.net>
	<20071017091629.GK5043@kernel.dk>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:58441
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1753687AbXJQKy2 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 17 Oct 2007 06:54:28 -0400
In-Reply-To: <20071017091629.GK5043@kernel.dk>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jens.axboe@oracle.com
Cc: fujita.tomonori@lab.ntt.co.jp, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

From: Jens Axboe <jens.axboe@oracle.com>
Date: Wed, 17 Oct 2007 11:16:29 +0200

> On Wed, Oct 17 2007, David Miller wrote:
> > From: Jens Axboe <jens.axboe@oracle.com>
> > Date: Wed, 17 Oct 2007 10:45:28 +0200
> > 
> > > Righto, it's invalid to call sg_next() on the last entry!
> > 
> > Unfortunately, that's what the sparc64 code wanted to do, this
> > transformation in the sparc64 sg chaining patch is not equilavent:
> > 
> > -	struct scatterlist *sg_end = sg + nelems;
> > +	struct scatterlist *sg_end = sg_last(sg, nelems);
> >  ...
> > -			while (sg < sg_end &&
> > +			while (sg != sg_end &&
> 
> Auch indeed. That'd probably be better as a
> 
>         do {
>                 ...
>         } while (sg != sg_end);

Ok, next bug, introduced by this change:

commit f565913ef8a8d0cfa46a1faaf8340cc357a46f3a
Author: Jens Axboe <jens.axboe@oracle.com>
Date:   Fri Sep 21 10:44:19 2007 +0200

    block: convert to using sg helpers
    
    Convert the main rq mapper (blk_rq_map_sg()) to the sg helper setup.
    
    Signed-off-by: Jens Axboe <jens.axboe@oracle.com>

Specifically this part:

 new_segment:
-			memset(&sg[nsegs],0,sizeof(struct scatterlist));
-			sg[nsegs].page = bvec->bv_page;
-			sg[nsegs].length = nbytes;
-			sg[nsegs].offset = bvec->bv_offset;
+			sg = next_sg;
+			next_sg = sg_next(sg);
 
+			sg->page = bvec->bv_page;
+			sg->length = nbytes;
+			sg->offset = bvec->bv_offset;

You can't remove that memset(), it's there for a reason.  The IOMMU
layers depended upon the code zero'ing out the whole scatterlist
struct, there might be more to it than page, length and offset :-)

In sparc64's case, this zero'd the dma_address and dma_length members
and the mapping algorithms use that to their advantage.
