From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: Integration of SCST in the mainstream Linux kernel
Date: Mon, 04 Feb 2008 11:25:01 -0600
Message-ID: <1202145901.3096.49.camel@localhost.localdomain>
References: <e2e108260801230622x42045058v926e84c60f2be7f4@mail.gmail.com>
	 <1201639331.3069.58.camel@localhost.localdomain>
	 <47A05CBD.5050803@vlnb.net>  <47A7049A.9000105@vlnb.net>
	 <1202139015.3096.5.camel@localhost.localdomain> <47A73C86.3060604@vlnb.net>
	 <1202144767.3096.38.camel@localhost.localdomain>
	 <47A7488B.4080000@vlnb.net>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:50909 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754591AbYBDRZJ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 4 Feb 2008 12:25:09 -0500
In-Reply-To: <47A7488B.4080000@vlnb.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Vladislav Bolkhovitin <vst@vlnb.net>
Cc: Bart Van Assche <bart.vanassche@gmail.com>, Linus Torvalds <torvalds@linux-foundation.org>, Andrew Morton <akpm@linux-foundation.org>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, linux-scsi@vger.kernel.org, scst-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org


On Mon, 2008-02-04 at 20:16 +0300, Vladislav Bolkhovitin wrote:
> James Bottomley wrote:
> >>>>So, James, what is your opinion on the above? Or the overall SCSI target 
> >>>>project simplicity doesn't matter much for you and you think it's fine 
> >>>>to duplicate Linux page cache in the user space to keep the in-kernel 
> >>>>part of the project as small as possible?
> >>>
> >>>
> >>>The answers were pretty much contained here
> >>>
> >>>http://marc.info/?l=linux-scsi&m=120164008302435
> >>>
> >>>and here:
> >>>
> >>>http://marc.info/?l=linux-scsi&m=120171067107293
> >>>
> >>>Weren't they?
> >>
> >>No, sorry, it doesn't look so for me. They are about performance, but 
> >>I'm asking about the overall project's architecture, namely about one 
> >>part of it: simplicity. Particularly, what do you think about 
> >>duplicating Linux page cache in the user space to have zero-copy cached 
> >>I/O? Or can you suggest another architectural solution for that problem 
> >>in the STGT's approach?
> > 
> > 
> > Isn't that an advantage of a user space solution?  It simply uses the
> > backing store of whatever device supplies the data.  That means it takes
> > advantage of the existing mechanisms for caching.
> 
> No, please reread this thread, especially this message: 
> http://marc.info/?l=linux-kernel&m=120169189504361&w=2. This is one of 
> the advantages of the kernel space implementation. The user space 
> implementation has to have data copied between the cache and user space 
> buffer, but the kernel space one can use pages in the cache directly, 
> without extra copy.

Well, you've said it thrice (the bellman cried) but that doesn't make it
true.

The way a user space solution should work is to schedule mmapped I/O
from the backing store and then send this mmapped region off for target
I/O.  For reads, the page gather will ensure that the pages are up to
date from the backing store to the cache before sending the I/O out.
For writes, You actually have to do a msync on the region to get the
data secured to the backing store.  You also have to pull tricks with
the mmap region in the case of writes to prevent useless data being read
in from the backing store.  However, none of this involves data copies.

James


