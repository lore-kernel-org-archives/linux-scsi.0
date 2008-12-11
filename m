From: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [PATCH][RFC 13/23]: Export of alloc_io_context() function
Date: Thu, 11 Dec 2008 20:06:27 +0100
Message-ID: <20081211190627.GA23742@kernel.dk>
References: <494009D7.4020602@vlnb.net> <49400F2F.4050603@vlnb.net> <20081211133424.GU23742@kernel.dk> <4941592E.8070303@vlnb.net> <20081211184100.GX23742@kernel.dk> <4941636A.3050303@vlnb.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from brick.kernel.dk ([93.163.65.50]:28236 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756352AbYLKTGq (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 11 Dec 2008 14:06:46 -0500
Content-Disposition: inline
In-Reply-To: <4941636A.3050303@vlnb.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Vladislav Bolkhovitin <vst@vlnb.net>
Cc: linux-scsi@vger.kernel.org, James Bottomley <James.Bottomley@HansenPartnership.com>, Andrew Morton <akpm@linux-foundation.org>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Mike Christie <michaelc@cs.wisc.edu>, Jeff Garzik <jeff@garzik.org>, Boaz Harrosh <bharrosh@panasas.com>, Linus Torvalds <torvalds@linux-foundation.org>, linux-kernel@vger.kernel.org, scst-devel@lists.sourceforge.net, Bart Van Assche <bart.vanassche@gmail.com>, "Nicholas A. Bellinger" <nab@linux-iscsi.org>

On Thu, Dec 11 2008, Vladislav Bolkhovitin wrote:
> Jens Axboe wrote:
> >On Thu, Dec 11 2008, Vladislav Bolkhovitin wrote:
> >>Jens Axboe wrote:
> >>>On Wed, Dec 10 2008, Vladislav Bolkhovitin wrote:
> >>>>This patch exports alloc_io_context() function. For performance reasons 
> >>>>SCST queues commands using a pool of IO threads. It is considerably 
> >>>>better for performance (>30% increase on sequential reads) if threads 
> >>>>in a pool have the same IO context. Since SCST can be built as a 
> >>>> module, it needs alloc_io_context() function exported.
> >>>>
> >>>>Signed-off-by: Vladislav Bolkhovitin <vst@vlnb.net>
> >>>>---
> >>>> block/blk-ioc.c |    1 +
> >>>> 1 file changed, 1 insertion(+)
> >>>>
> >>>>diff -upkr linux-2.6.27.2/block/blk-ioc.c linux-2.6.27.2/block/blk-ioc.c
> >>>>--- linux-2.6.27.2/block/blk-ioc.c	2008-10-10 02:13:53.000000000 +0400
> >>>>+++ linux-2.6.27.2/block/blk-ioc.c	2008-11-25 21:27:01.000000000 +0300
> >>>>@@ -105,6 +105,7 @@ struct io_context *alloc_io_context(gfp_
> >>>>
> >>>>	return ret;
> >>>>}
> >>>>+EXPORT_SYMBOL(alloc_io_context);
> >>>Why is this needed, can't you just use CLONE_IO?
> >>There are two reasons for that:
> >>
> >>1. kthread interface doesn't support passing CLONE_IO flag.
> >
> >Then you fix that instead of working around it! :-)
> 
> It doesn't worth the effort, because of (2) below.
> 
> >>2. Each (virtual) device has own pool of threads, which serves it. 
> >>Threads in each such pools should have a common IO context, but 
> >>different pools should have different IO contexts. So, it would be 
> >>necessary to implement two levels start of IO threads in each pool. At 
> >>first, one thread would be started. Then it would call get_io_context() 
> >>to gain io_context. Then it would create the remaining threads with 
> >>CLONE_IO flag. Definitely, it's a lot more complicated than a simple 
> >>call of alloc_io_context() and assignment of the returned context to 
> >>each just created thread in a loop before they were ran.
> >
> >Just start the first thread without CLONE_IO, and subsequent threads
> >fork off that with CLONE_IO set? 
> 
> Yes, that would be the two stages threads creation. A *LOT* more 
> complicated, than with the direct io_context assignment using 
> alloc_io_context().
> 
> >I think we need to make sure that we
> >allocate an IO context for the 'parent' if it doesn't have one already
> >and CLONE_IO is set, but that is something that can easily be rectified.
> 
> Sorry, I don't feel I understood you here..

Sure I understand that it's then a two-stage rocket for the first
context you fork off. I don't see how you qualify that as a *LOT* more
complicated...

> >It may seem more complex, but if you use this approach you are pretty
> >much free to worry about any changes in the future there.
> 
> Worrying about future changes is regular in Linux kernel, where there is 
> no stable API ;-)

Sure, but if your stuff gets merged then *I* have to fiddle with your
stuff as well when making changes. If you plan to keep your stuff out of
the kernel and maintain it there, fine, but I think you probably don't.

It's not a HUGE deal for this case, since you basically just want to use
alloc_io_context() and ioc_task_link(). So we can make the export and be
done with it.

-- 
Jens Axboe

