From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH] block: fix q->max_segment_size checking in
	blk_recalc_rq_segments about VMERGE
Date: Thu, 24 Jul 2008 23:47:50 -0400
Message-ID: <1216957670.4524.87.camel@localhost.localdomain>
References: <Pine.LNX.4.64.0807241232040.9412@devserv.devel.redhat.com>
	 <1216918371.4524.38.camel@localhost.localdomain>
	 <Pine.LNX.4.64.0807241727320.12036@devserv.devel.redhat.com>
	 <20080724.145336.41899163.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:49538 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752224AbYGYDzB (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 24 Jul 2008 23:55:01 -0400
In-Reply-To: <20080724.145336.41899163.davem@davemloft.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: David Miller <davem@davemloft.net>
Cc: mpatocka@redhat.com, fujita.tomonori@lab.ntt.co.jp, jens.axboe@oracle.com, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, linux-parisc@vger.kernel.org

On Thu, 2008-07-24 at 14:53 -0700, David Miller wrote:
> From: Mikulas Patocka <mpatocka@redhat.com>
> Date: Thu, 24 Jul 2008 17:49:14 -0400 (EDT)
> 
> > * it is prone to bugs and hard to maintain, because the same value must be 
> > calculated in blk-merge.c and in architectural iommu functions --- if the 
> > value differs, you create too long request, corrupt kernel memory and 
> > crash (happened on sparc64). Anyone changing blk-merge in the future will 
> > risk breaking something on the architectures that use BIO_VMERGE_BOUNDARY 
> > --- and because these architectures are so rare, the bug will go unnoticed 
> > for long time --- like in the case of sparc64.
> 
> I completely agree with this point.

So you think the parametrisation in the block layer is the wrong way to
approach the problem?  On this argument your next patch should be
removing physical merging as well because it also relies on a
parametrisation model of how the device builds the sg list.

> This VMERGE stuff is now a non-trivial maintainence burdon because
> anyone who wants to hack on the block layer has to be mindful of
> VMERGE but is very unlikely to have access to a system that it can
> even be tested on.

I'm sorry sparc broke, really I am ... but you changed your iommu code
from one with a working vmerge to one without and failed to turn off
vmerging.  Partly it wasn't noticed because at 2*PAGE_SIZE you have a
strange vmerge boundary, so it's harder to notice.   However, I can't
extrapolate that just because this happened on sparc it will inevitably
happen on all other architectures.

> And the answer isn't "James Bottomly will test your changes for you",
> because that simply doesn't scale.

Actually, parisc will test your code we have a PAGE_SIZE vmerge
boundary, so the effect is much more noticeable.

> I still say we should definitely remove the VMERGE code.  It's not
> worth the maintainence hassle just for some SG chaining test rig
> on some obscure platform.

OK ... well you've had your say and so have I.  The code in question is
the responsibility of a particular maintainer ... we'll let him decide.

> I really only hear one person who really wants this code around any
> more.  Is that the Linux way? :-) Can't he patch it into his tree when
> he needs it or write an alternative way to stress the SG chaining
> code?  He has the source, right? :-)))

You're advocating an out of tree patch as a solution?  I didn't know
you'd been appointed RHEL maintainer ;-)

James


