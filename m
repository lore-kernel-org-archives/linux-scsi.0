From: Andrew Morton <akpm@osdl.org>
Subject: Re: Bugs on Linux 2.6.18-rc2 sg code?
Date: Sat, 19 Aug 2006 10:41:09 -0700
Message-ID: <20060819104109.588604bd.akpm@osdl.org>
References: <8202f4270608101843r7df002d2l40e03eca3271b050@mail.gmail.com>
	<44E6388D.1000206@torque.net>
	<44E68F76.4010702@torque.net>
	<20060819172024.GS4340@parisc-linux.org>
	<44E74C21.8040108@torque.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.4]:23459 "EHLO smtp.osdl.org")
	by vger.kernel.org with ESMTP id S1751764AbWHSRlO (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sat, 19 Aug 2006 13:41:14 -0400
In-Reply-To: <44E74C21.8040108@torque.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: dougg@torque.net
Cc: Matthew Wilcox <matthew@wil.cx>, Fajun Chen <fajunchen@gmail.com>, linux-scsi@vger.kernel.org

On Sat, 19 Aug 2006 13:36:33 -0400
Douglas Gilbert <dougg@torque.net> wrote:

> Matthew Wilcox wrote:
> > On Sat, Aug 19, 2006 at 12:11:34AM -0400, Douglas Gilbert wrote:
> >>> Your point about the change to sg_vma_nopage() between
> >>> lk 2.6.15 and lk 2.6.16 also seems to be correct.
> >>> The most indented part of that function has been
> >>> changed from incrementing the change count on the
> >>> reported page (as indicated by 'offset') in a
> >>> compound page allocation to ignoring the 'offset'
> >>> and incrementing the page count on the first page
> >>> in a compound page allocation.
> >>  		if (offset < len) {
> >> -			page = sg->page;
> >> +			page = virt_to_page(page_address(sg->page) + offset);
> >>  			get_page(page);	/* increment page count */
> > 
> > But page_address can return NULL on highmem machines.  Or are you
> > guaranteed that these are lowmem pages?
> 
> Matthew,
> The allocation is typically compound done with:
>   alloc_pages(GFP_ATOMIC|__GFP_COMP|__GFP_NOWARN, order)
> where 'order' is 3 (hence 32 KB).

ow, GFP_ATOMIC is bad.  Can we avoid that?

> The lack of a '__GFP_HIGHMEM' flag should mean these are
> lowmem pages (?).

Yup.
