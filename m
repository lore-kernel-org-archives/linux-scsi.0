From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: [PATCH] block: fix q->max_segment_size checking in
 blk_recalc_rq_segments about VMERGE
Date: Wed, 16 Jul 2008 00:30:43 +0900
Message-ID: <20080716003047P.fujita.tomonori@lab.ntt.co.jp>
References: <Pine.LNX.4.64.0807150924250.21598@devserv.devel.redhat.com>
	<20080715231956A.fujita.tomonori@lab.ntt.co.jp>
	<Pine.LNX.4.64.0807151033040.25390@devserv.devel.redhat.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-parisc-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.64.0807151033040.25390@devserv.devel.redhat.com>
Sender: linux-parisc-owner@vger.kernel.org
To: mpatocka@redhat.com
Cc: fujita.tomonori@lab.ntt.co.jp, jens.axboe@oracle.com, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, davem@davemloft.net, linux-parisc@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Tue, 15 Jul 2008 10:37:58 -0400 (EDT)
Mikulas Patocka <mpatocka@redhat.com> wrote:

> >>> This bug could happen on alpha, parisc, and sparc, which use VMERGE.
> >>
> >> Parisc doesn't use virtual merge accounting (there is variable for it but
> >> it's always 0).
> >
> > Hmm, really? Looks like PARISC IOMMUs (ccio-dma.c and sba_iomm.c) set
> > parisc_vmerge_boundary (CC'ed PARISC mailing list).
> 
> That's right, I looked only at arch and include.
> 
> >> On sparc64 it is broken anyway with or without your patch.
> >
> > Yeah, we need to modify SPARC64 IOMMU code (I'm not sure that it's
> > worth). Right now, the best fix is setting BIO_VMERGE_BOUNDARY to 0.
> 
> Even if we fix it now, the question is: how long it will stay fixed? Until 
> someone makes another change to struct device that restricts boundaries on 
> some wacky hardware.

I'm not sure how the boundary restriction of a device can break
the VMERGE accounting.
