From: Douglas Gilbert <dougg@torque.net>
Subject: Re: Bugs on Linux 2.6.18-rc2 sg code?
Date: Sat, 19 Aug 2006 21:36:58 -0400
Message-ID: <44E7BCBA.5080105@torque.net>
References: <8202f4270608101843r7df002d2l40e03eca3271b050@mail.gmail.com>	 <44E6388D.1000206@torque.net>  <44E68F76.4010702@torque.net> <1156013713.3726.10.camel@mulgrave.il.steeleye.com>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:33431 "EHLO
	pentafluge.infradead.org") by vger.kernel.org with ESMTP
	id S932568AbWHTBhA (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 19 Aug 2006 21:37:00 -0400
In-Reply-To: <1156013713.3726.10.camel@mulgrave.il.steeleye.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: Fajun Chen <fajunchen@gmail.com>, linux-scsi@vger.kernel.org, akpm@osdl.org

James Bottomley wrote:
> On Sat, 2006-08-19 at 00:11 -0400, Douglas Gilbert wrote:
>> @@ -1164,7 +1164,7 @@
>>                 len = vma->vm_end - sa;
>>                 len = (len < sg->length) ? len : sg->length;
>>                 if (offset < len) {
>> -                       page = sg->page;
>> +                       page = virt_to_page(page_address(sg->page) + offset);
>>                         get_page(page); /* increment page count */
>>                         break;
>>                 }
> 
> Doing something like this always frightens people in linux because
> page_address() on highmem returns NULL.  I know, having looked, that in
> this case it can't happen, but since sg->page is really an array of
> pages, how about something simpler like
> 
> page = &sg->page[offset >> PAGE_SHIFT]

James,
Yes I saw code like that when I reviewed other vma
"nopage" callbacks. And that code frightens me :-)

> or (if you want to be more correct) something like the nth_page macro in
> linux/mm.h?

That nth_page() macro looks better. Is it guaranteed
not to return NULL? No vma "nopage" callbacks are
using nth_page() so I wasn't aware of it.

> It might also be worthwhile considering GFP_HIGHUSER for this allocation
> (in spite of all the kmap_atomic et al that would have to be added to
> the code), since that will increase the chance of a contiguous
> allocation on large memory machines.

Did you mean GFP_KERNEL | __GFP_HIGHMEM since the
allocation in question is for a scatter gather
list element that will be DMA-ed to or from?

Is the HIGHMEM stuff needed in 64 bits? I looked
at the kmap_atomic stuff and it just didn't look
worth the effort.


All good stuff for the lk 2.6.19 cycle. First I
would like to fix the reported bug with code
that was well tested ...


Doug Gilbert

