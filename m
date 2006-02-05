From: Andrew Morton <akpm@osdl.org>
Subject: Re: [Bug 6009] tcpdump causes kernel panic
Date: Sat, 4 Feb 2006 16:51:56 -0800
Message-ID: <20060204165156.6024702b.akpm@osdl.org>
References: <200602042315.k14NFwuS006966@fire-2.osdl.org>
	<20060204153118.4b0270b4.akpm@osdl.org>
	<1139098731.2957.2.camel@mulgrave.il.steeleye.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.4]:57511 "EHLO smtp.osdl.org")
	by vger.kernel.org with ESMTP id S1751272AbWBEAwd (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 4 Feb 2006 19:52:33 -0500
In-Reply-To: <1139098731.2957.2.camel@mulgrave.il.steeleye.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: bugme-daemon@bugzilla.kernel.org, linux-scsi@vger.kernel.org, greg@kroah.com

James Bottomley <James.Bottomley@SteelEye.com> wrote:
>
> On Sat, 2006-02-04 at 15:31 -0800, Andrew Morton wrote:
> > James, I don't recall whether we've fixed this or not?  It was non-trivial,
> > wasn't it?
> 
> It's not fixed, and pretty non-trivial.  Basically we'd have to redo
> most of our generic device (or kobject) handling through workqueues.
> 
> What I'd like for this is a way to tell context.  We know the locking
> context and can cope with that, but it would be nice to tell if we have
> user context or not and then only go through the workqueue for the
> softirq or hardirq contexts.
> 
> If we can get the check, it would probably make sense to do the actual
> manipulation in put_device().
> 

in_interrupt() will return true in hard- or soft-irq context on all
architectures and all .configs - you can certainly use that.

What we cannot use is in_atomic() to detect whether we're inside spinlock -
that only works if CONFIG_PREEMPT.



Regarding this bug, Donny: are you saying that the 3ware failure is caused
by putting the NIC into promiscuous mode (or something related)?  That it
is caused by running tcpdump?

