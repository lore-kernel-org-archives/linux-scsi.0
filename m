From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: Bugs on Linux 2.6.18-rc2 sg code?
Date: Sat, 19 Aug 2006 11:55:13 -0700
Message-ID: <1156013713.3726.10.camel@mulgrave.il.steeleye.com>
References: <8202f4270608101843r7df002d2l40e03eca3271b050@mail.gmail.com>
	 <44E6388D.1000206@torque.net>  <44E68F76.4010702@torque.net>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat9.steeleye.com ([209.192.50.41]:40668 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S1751773AbWHSSz3 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 19 Aug 2006 14:55:29 -0400
In-Reply-To: <44E68F76.4010702@torque.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: dougg@torque.net
Cc: Fajun Chen <fajunchen@gmail.com>, linux-scsi@vger.kernel.org, akpm@osdl.org

On Sat, 2006-08-19 at 00:11 -0400, Douglas Gilbert wrote:
> @@ -1164,7 +1164,7 @@
>                 len = vma->vm_end - sa;
>                 len = (len < sg->length) ? len : sg->length;
>                 if (offset < len) {
> -                       page = sg->page;
> +                       page = virt_to_page(page_address(sg->page) + offset);
>                         get_page(page); /* increment page count */
>                         break;
>                 }

Doing something like this always frightens people in linux because
page_address() on highmem returns NULL.  I know, having looked, that in
this case it can't happen, but since sg->page is really an array of
pages, how about something simpler like

page = &sg->page[offset >> PAGE_SHIFT]

or (if you want to be more correct) something like the nth_page macro in
linux/mm.h?

It might also be worthwhile considering GFP_HIGHUSER for this allocation
(in spite of all the kmap_atomic et al that would have to be added to
the code), since that will increase the chance of a contiguous
allocation on large memory machines.

James


