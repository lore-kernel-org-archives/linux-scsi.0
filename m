From: Douglas Gilbert <dougg@torque.net>
Subject: Re: Bugs on Linux 2.6.18-rc2 sg code?
Date: Sat, 19 Aug 2006 13:36:33 -0400
Message-ID: <44E74C21.8040108@torque.net>
References: <8202f4270608101843r7df002d2l40e03eca3271b050@mail.gmail.com> <44E6388D.1000206@torque.net> <44E68F76.4010702@torque.net> <20060819172024.GS4340@parisc-linux.org>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:31651 "EHLO
	pentafluge.infradead.org") by vger.kernel.org with ESMTP
	id S1751642AbWHSRgk (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 19 Aug 2006 13:36:40 -0400
In-Reply-To: <20060819172024.GS4340@parisc-linux.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>
Cc: Fajun Chen <fajunchen@gmail.com>, linux-scsi@vger.kernel.org, akpm@osdl.org

Matthew Wilcox wrote:
> On Sat, Aug 19, 2006 at 12:11:34AM -0400, Douglas Gilbert wrote:
>>> Your point about the change to sg_vma_nopage() between
>>> lk 2.6.15 and lk 2.6.16 also seems to be correct.
>>> The most indented part of that function has been
>>> changed from incrementing the change count on the
>>> reported page (as indicated by 'offset') in a
>>> compound page allocation to ignoring the 'offset'
>>> and incrementing the page count on the first page
>>> in a compound page allocation.
>>  		if (offset < len) {
>> -			page = sg->page;
>> +			page = virt_to_page(page_address(sg->page) + offset);
>>  			get_page(page);	/* increment page count */
> 
> But page_address can return NULL on highmem machines.  Or are you
> guaranteed that these are lowmem pages?

Matthew,
The allocation is typically compound done with:
  alloc_pages(GFP_ATOMIC|__GFP_COMP|__GFP_NOWARN, order)
where 'order' is 3 (hence 32 KB).
The lack of a '__GFP_HIGHMEM' flag should mean these are
lowmem pages (?).

The (compound) pages in question would have already
been mmap()-ed by the user.

Doug Gilbert


