From: Andrew Morton <akpm@osdl.org>
Subject: Re: [patch] sg: simplify page_count manipulations
Date: Thu, 19 Jan 2006 14:05:25 -0800
Message-ID: <20060119140525.223a8ebf.akpm@osdl.org>
References: <20060118155242.GB28418@wotan.suse.de>
	<20060118195937.3586c94f.akpm@osdl.org>
	<20060119144548.GF958@wotan.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.4]:43143 "EHLO smtp.osdl.org")
	by vger.kernel.org with ESMTP id S1161450AbWASWEJ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 19 Jan 2006 17:04:09 -0500
In-Reply-To: <20060119144548.GF958@wotan.suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
Cc: npiggin@suse.de, torvalds@osdl.org, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

Nick Piggin <npiggin@suse.de> wrote:
>
> On Wed, Jan 18, 2006 at 07:59:37PM -0800, Andrew Morton wrote:
> > Nick Piggin <npiggin@suse.de> wrote:
> > > -	/* N.B. correction _not_ applied to base page of each allocation */
> > > -	for (k = 0; k < rsv_schp->k_use_sg; ++k, ++sg) {
> > > -		for (m = PAGE_SIZE; m < sg->length; m += PAGE_SIZE) {
> > > -			page = sg->page;
> > > -			if (startFinish)
> > > -				get_page(page);
> > > -			else {
> > > -				if (page_count(page) > 0)
> > > -					__put_page(page);
> > > -			}
> > > -		}
> > > -	}
> > > -}
> > 
> > What on earth is the above trying to do?  The inner loop is a rather
> > complex way of doing atomic_add(&page->count, sg->length/PAGE_SIZE).  One
> > suspects there's a missing "[m]" in there.
> > 
> 
> It does this on the first mmap of the device, in the hope that subsequent
> nopage, unmaps would not free the constituent pages in the scatterlist.
> 

But it's doing it wrongly, isn't it?  Or am I completely nuts?

