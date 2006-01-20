From: Andrew Morton <akpm@osdl.org>
Subject: Re: [patch] sg: simplify page_count manipulations
Date: Fri, 20 Jan 2006 02:47:02 -0800
Message-ID: <20060120024702.6f894a13.akpm@osdl.org>
References: <20060118155242.GB28418@wotan.suse.de>
	<20060118195937.3586c94f.akpm@osdl.org>
	<20060119144548.GF958@wotan.suse.de>
	<20060119140525.223a8ebf.akpm@osdl.org>
	<20060120101815.GD1756@wotan.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.4]:20420 "EHLO smtp.osdl.org")
	by vger.kernel.org with ESMTP id S1750809AbWATKrY (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 20 Jan 2006 05:47:24 -0500
In-Reply-To: <20060120101815.GD1756@wotan.suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
Cc: npiggin@suse.de, torvalds@osdl.org, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, dougg@torque.net

Nick Piggin <npiggin@suse.de> wrote:
>
> On Thu, Jan 19, 2006 at 02:05:25PM -0800, Andrew Morton wrote:
> > Nick Piggin <npiggin@suse.de> wrote:
> > >
> > > On Wed, Jan 18, 2006 at 07:59:37PM -0800, Andrew Morton wrote:
> > > > Nick Piggin <npiggin@suse.de> wrote:
> > > > > -	/* N.B. correction _not_ applied to base page of each allocation */
> > > > > -	for (k = 0; k < rsv_schp->k_use_sg; ++k, ++sg) {
> > > > > -		for (m = PAGE_SIZE; m < sg->length; m += PAGE_SIZE) {
> > > > > -			page = sg->page;
> > > > > -			if (startFinish)
> > > > > -				get_page(page);
> > > > > -			else {
> > > > > -				if (page_count(page) > 0)
> > > > > -					__put_page(page);
> > > > > -			}
> > > > > -		}
> > > > > -	}
> > > > > -}
> > > > 
> > > > What on earth is the above trying to do?  The inner loop is a rather
> > > > complex way of doing atomic_add(&page->count, sg->length/PAGE_SIZE).  One
> > > > suspects there's a missing "[m]" in there.
> > > > 
> > > 
> > > It does this on the first mmap of the device, in the hope that subsequent
> > > nopage, unmaps would not free the constituent pages in the scatterlist.
> > > 
> > 
> > But it's doing it wrongly, isn't it?  Or am I completely nuts?
> 
> No I think you're right. I'm not sure why this doesn't oops but I
> thought it was the (main) reason others wanted to get rid of this
> convoluted code earlier on. I see nobody else is planning to do anything
> about it though, so I figure I must have missed the reason why it isn't
> a problem.
> 
> But either way I don't think the code actually _does_ anything, even if
> its bugginess doesn't actually lead to a bug.
> 

I suspect nobody tried to munmap pages beyond the first one.

Yes, let's use a compound page in there and I expect Doug will be able to
test it for us sometime.

