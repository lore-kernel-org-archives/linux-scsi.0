From: Jens Axboe <axboe@suse.de>
Subject: Re: [RFC]: performance improvement by coalescing requests?
Date: Tue, 21 Jun 2005 14:34:27 +0200
Message-ID: <20050621123422.GA12271@suse.de>
References: <60807403EABEB443939A5A7AA8A7458B01520FCF@otce2k01.adaptec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns.virtualhost.dk ([195.184.98.160]:41424 "EHLO virtualhost.dk")
	by vger.kernel.org with ESMTP id S261289AbVFUMdG (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 21 Jun 2005 08:33:06 -0400
Content-Disposition: inline
In-Reply-To: <60807403EABEB443939A5A7AA8A7458B01520FCF@otce2k01.adaptec.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Salyzyn, Mark" <mark_salyzyn@adaptec.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>

On Tue, Jun 21 2005, Salyzyn, Mark wrote:
> Jens Axboe [mailto:axboe@suse.de] 
> > On Mon, Jun 20 2005, Salyzyn, Mark wrote:
> >> Jens Axboe [mailto:axboe@suse.de] writes:
> >> > You say io, but I guess you mean writes in particular?
> >> 
> >> Read or writes. One of the test cases was:
> >> 
> >> dd if=/dev/sda of=/dev/null bs=512b
> >> 
> >> would break apart into 64 4K reads with no completion dependencies
> >> between them.
> > That's a silly test case though, because you are intentionally
> > issuing io in a really small size.
> 
> The io size is 256KB (the 'b' in dd size operands is 'blocks'). This is

You are right, my mistake, I misread that as 'bytes'.

> the worst case scenario (single thread, large enough i/o to stuff the
> controller full with 4K requests, then stops waiting for them to
> complete before issuing more).

For 256kb issued reads, you really should not see 4kb reaching the
controller. What happens if you access a file on the file system
instead?

> > real world cases?
> 
> It is not 'real world'. iozone was hard pressed to find much of a
> difference, real world is a mix of threaded, small, large, sequential
> and random; Focused on single thread large sequential and a surgical
> solution with zero affect on all other i/o styles.

Ok

> > and see lots of small requests, then that would be more strange.
> > Can you definitely verify this is what happens?
> 
> I can verify that OOB RHEL3 (2.4.21-4.EL) and SL9.1 (2.6.4-52) exhibited
> this issue. I will regroup, re-instrument and report back if this is
> still the case for a late model (distribution?) kernels.

Both of those kernels are ancient. Please just test with 2.6.12, no need
to mix distro kernels into this.

> 
> > The plugging is a block layer property, it's been in use for ages
> > (since at least 2.0, I forget when it was originall introduced).
> 
> Ok, so no recent changes that would affect my results. Regardless, I

Given how old kernels you tested, there are probably a ton of things
that could affect this.

> will assume there are differences between RHEL3/SL9.1 and 2.6.12 that
> may have an affect. Also, as Jeff pointed out, I should scrutinize the
> i/o schedulers, the 'fix' may be in tuning the selection.

Well there are so many differences between 2.4 and 2.6. I would suggest
you forget about 2.4 completely, as this is marginal stuff. Focus in
2.6.latest and see if you can find performance issues there, if you can
we will fix it and if it's something obvious it will often go to distro
kernels as well.

> >> The adapter can suck in 256 requests within a single ms.
> > I'm sure it can, I'm also sure that you can queue io orders of
> > magnitude faster than you can send them to hardware!
> 
> With the recent 'interrupt mitigation' patch to the aacraid driver, we
> don't even need to go to the hardware to queue the request after the
> first two are added and triggered. We can put 512 requests queued the
> controller in the time it takes to move each pointer, size and increment
> a produced index on the main memory. Regardless, before the patch it was
> one PCI write overhead between each, which 'only' adds 10us to that
> process for each request.

You still need to be invoked first, which should not happen unless
someone higher up unplugged the queue manually. 512 requests is really
insane anyways, you will completely kill the io scheduler with such deep
queue depths. At the very least increase the block layer queue size to
be _at least_ twice the hardware depth, or you can very easily provoke
bad behaviour such as this.

> Not sure if this is a flaw, or a feature ;-> But the fast disposition of
> queuing may be the root cause and not the Linux I/O system.

Nah, I don't think so.

-- 
Jens Axboe

