From: Andi Kleen <andi@firstfloor.org>
Subject: Re: [patch 1/1] Switch ioctl functions of drivers/scsi/sg.c to unlocked_ioctl
Date: Thu, 10 Jan 2008 20:21:43 +0100
Message-ID: <20080110192143.GE747@one.firstfloor.org>
References: <20080110180529.GA32640@skl-net.de> <1199991298.3141.75.camel@localhost.localdomain> <20080110185944.GA1690@one.firstfloor.org> <20080110190324.GG18741@parisc-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from one.firstfloor.org ([213.235.205.2]:34230 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752770AbYAJTTJ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 10 Jan 2008 14:19:09 -0500
Content-Disposition: inline
In-Reply-To: <20080110190324.GG18741@parisc-linux.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>
Cc: Andi Kleen <andi@firstfloor.org>, James Bottomley <James.Bottomley@HansenPartnership.com>, Andre Noll <maan@systemlinux.org>, linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, kernel-janitors@vger.kernel.org, Richard Knutsson <ricknu-0@student.ltu.se>

On Thu, Jan 10, 2008 at 12:03:24PM -0700, Matthew Wilcox wrote:
> On Thu, Jan 10, 2008 at 07:59:44PM +0100, Andi Kleen wrote:
> > > Really, all this is doing is open coding what the ioctl handler is doing
> > > anyway, isn't it? in which case, why bother to change it at all?
> > 
> > Because once it's open coded it is visible and can then be eliminated.
> > Does SCSI need the BKL at all?
> > 
> > But perhaps for such a long ioctl handler it would be better to move
> > the lock/unlock_kernel()s into the individual case ...: statements;
> > then it could be eliminated step by step.
> 
> This style of conversion is going to cause a lot of churn --

If he pushes the lock_kernels() into the cases then not.

But even a few refactorings are not that bad if they result in
a BKL less SCSI.

> re-architecting this function to be single-exit, then presumably when
> the lock_kernel calls are pushed further down or eliminated, turning it
> back into a multiple-exit function.
> 
> I suggest that for complex ioctl handlers, it be left to the maintainers

Which have had years to convert their drivers, but they mostly didn't
do it. They need more incentive.

> to handle, and handle it properly all at once, rather than a gradual
> pushdown.
> 
> You could argue that unlocked_ioctl has been around for a long time and
> people haven't made that move yet.  But there's been no pressure before

Yes I argue exactly that.

> now to do so, and I think people would rather convert their own code
> than have somebody else do it.

Has been proven to not work.

I don't really blame the maintainers too much. The implicit BKL in ioctl
is actually pretty obscure. But making it explicit will force their
hand.

So in short I'm sorry, but you're wrong on that.

-Andi
