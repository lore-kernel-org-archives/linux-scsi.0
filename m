From: Nick Piggin <npiggin@suse.de>
Subject: Re: [patch] sg: simplify page_count manipulations
Date: Thu, 19 Jan 2006 15:45:48 +0100
Message-ID: <20060119144548.GF958@wotan.suse.de>
References: <20060118155242.GB28418@wotan.suse.de> <20060118195937.3586c94f.akpm@osdl.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor.suse.de ([195.135.220.2]:13706 "EHLO mx1.suse.de")
	by vger.kernel.org with ESMTP id S1161176AbWASOpu (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 19 Jan 2006 09:45:50 -0500
Content-Disposition: inline
In-Reply-To: <20060118195937.3586c94f.akpm@osdl.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@osdl.org>
Cc: Nick Piggin <npiggin@suse.de>, torvalds@osdl.org, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

On Wed, Jan 18, 2006 at 07:59:37PM -0800, Andrew Morton wrote:
> Nick Piggin <npiggin@suse.de> wrote:
> > -	/* N.B. correction _not_ applied to base page of each allocation */
> > -	for (k = 0; k < rsv_schp->k_use_sg; ++k, ++sg) {
> > -		for (m = PAGE_SIZE; m < sg->length; m += PAGE_SIZE) {
> > -			page = sg->page;
> > -			if (startFinish)
> > -				get_page(page);
> > -			else {
> > -				if (page_count(page) > 0)
> > -					__put_page(page);
> > -			}
> > -		}
> > -	}
> > -}
> 
> What on earth is the above trying to do?  The inner loop is a rather
> complex way of doing atomic_add(&page->count, sg->length/PAGE_SIZE).  One
> suspects there's a missing "[m]" in there.
> 

It does this on the first mmap of the device, in the hope that subsequent
nopage, unmaps would not free the constituent pages in the scatterlist.

> Yes, using a compound page for the refcounting sounds sane, but I think
> this code is fragile and has monsters in it.


