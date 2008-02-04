From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: Integration of SCST in the mainstream Linux kernel
Date: Mon, 04 Feb 2008 12:49:52 -0600
Message-ID: <1202150992.3096.76.camel@localhost.localdomain>
References: <e2e108260801230622x42045058v926e84c60f2be7f4@mail.gmail.com>
	 <1201639331.3069.58.camel@localhost.localdomain>
	 <47A05CBD.5050803@vlnb.net>  <47A7049A.9000105@vlnb.net>
	 <1202139015.3096.5.camel@localhost.localdomain> <47A73C86.3060604@vlnb.net>
	 <1202144767.3096.38.camel@localhost.localdomain>
	 <47A7488B.4080000@vlnb.net>
	 <1202145901.3096.49.camel@localhost.localdomain>
	 <alpine.LFD.1.00.0802041018390.3034@hp.linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:46489 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754600AbYBDSuK (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 4 Feb 2008 13:50:10 -0500
In-Reply-To: <alpine.LFD.1.00.0802041018390.3034@hp.linux-foundation.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Vladislav Bolkhovitin <vst@vlnb.net>, Bart Van Assche <bart.vanassche@gmail.com>, Andrew Morton <akpm@linux-foundation.org>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, linux-scsi@vger.kernel.org, scst-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org

On Mon, 2008-02-04 at 10:29 -0800, Linus Torvalds wrote:
> 
> On Mon, 4 Feb 2008, James Bottomley wrote:
> > 
> > The way a user space solution should work is to schedule mmapped I/O
> > from the backing store and then send this mmapped region off for target
> > I/O.
> 
> mmap'ing may avoid the copy, but the overhead of a mmap operation is 
> quite often much *bigger* than the overhead of a copy operation.
> 
> Please do not advocate the use of mmap() as a way to avoid memory copies. 
> It's not realistic. Even if you can do it with a single "mmap()" system 
> call (which is not at all a given, considering that block devices can 
> easily be much larger than the available virtual memory space), the fact 
> is that page table games along with the fault (and even just TLB miss) 
> overhead is easily more than the cost of copying a page in a nice 
> streaming manner.
> 
> Yes, memory is "slow", but dammit, so is mmap().
> 
> > You also have to pull tricks with the mmap region in the case of writes 
> > to prevent useless data being read in from the backing store.  However, 
> > none of this involves data copies.
> 
> "data copies" is irrelevant. The only thing that matters is performance. 
> And if avoiding data copies is more costly (or even of a similar cost) 
> than the copies themselves would have been, there is absolutely no upside, 
> and only downsides due to extra complexity.
> 
> If you want good performance for a service like this, you really generally 
> *do* need to in kernel space. You can play games in user space, but you're 
> fooling yourself if you think you can do as well as doing it in the 
> kernel. And you're *definitely* fooling yourself if you think mmap() 
> solves performance issues. "Zero-copy" does not equate to "fast". Memory 
> speeds may be slower that core CPU speeds, but not infinitely so!
> 
> (That said: there *are* alternatives to mmap, like "splice()", that really 
> do potentially solve some issues without the page table and TLB overheads. 
> But while splice() avoids the costs of paging, I strongly suspect it would 
> still have easily measurable latency issues. Switching between user and 
> kernel space multiple times is definitely not going to be free, although 
> it's probably not a huge issue if you have big enough requests).

Sorry ... this is really just a discussion of how something (zero copy)
could be done, rather than an implementation proposal.  (I'm not
actually planning to make the STGT people do anything ... although
investigating splice does sound interesting).

Right at the moment, STGT seems to be performing just fine on
measurements up to gigabit networks.  There are suggestions that there
may be a problem on 8G IB networks, but it's not definitive yet.

I'm already on record as saying I think the best fix for IB networks is
just to reduce the context switches by increasing the transfer size, but
the infrastructure to allow that only just went into git head.

James


