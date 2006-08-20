From: Andrew Morton <akpm@osdl.org>
Subject: Re: Bugs on Linux 2.6.18-rc2 sg code?
Date: Sun, 20 Aug 2006 10:47:51 -0700
Message-ID: <20060820104751.9a15d6fd.akpm@osdl.org>
References: <8202f4270608101843r7df002d2l40e03eca3271b050@mail.gmail.com>
	<44E6388D.1000206@torque.net>
	<44E68F76.4010702@torque.net>
	<20060819172024.GS4340@parisc-linux.org>
	<44E74C21.8040108@torque.net>
	<20060819104109.588604bd.akpm@osdl.org>
	<20060819202323.GT4340@parisc-linux.org>
	<44E7B439.2070602@torque.net>
	<1156068441.23756.23.camel@laptopd505.fenrus.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.4]:54237 "EHLO smtp.osdl.org")
	by vger.kernel.org with ESMTP id S1751089AbWHTRsU (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sun, 20 Aug 2006 13:48:20 -0400
In-Reply-To: <1156068441.23756.23.camel@laptopd505.fenrus.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Arjan van de Ven <arjan@fenrus.demon.nl>
Cc: dougg@torque.net, Matthew Wilcox <matthew@wil.cx>, Fajun Chen <fajunchen@gmail.com>, linux-scsi@vger.kernel.org, James.Bottomley@SteelEye.com

On Sun, 20 Aug 2006 12:07:21 +0200
Arjan van de Ven <arjan@fenrus.demon.nl> wrote:

> On Sat, 2006-08-19 at 21:00 -0400, Douglas Gilbert wrote:
> > Matthew Wilcox wrote:
> > > On Sat, Aug 19, 2006 at 10:41:09AM -0700, Andrew Morton wrote:
> > >> ow, GFP_ATOMIC is bad.  Can we avoid that?
> > > 
> > > I believe all the GFP_ATOMIC calls in sg.c can be downgraded to
> > > GFP_KERNEL.
> > 
> > Well, if memory serves, we have been around this loop
> > before. The GFP_ATOMIC flags were removed, users
> > complained about unexplained, unbounded waits unrelated
> > to the SCSI transport or device.
> 
> this is not a fair answer... in a way GFP_ATOMIC is an antisocial
> behavior that should only be done when there is an absolute need. You'll
> dip into the VM reserves by using it after all!

Thing is, SG is (for some reason) using order-3 allocations.  Those can
indeed send the VM into a large amount of reclaim when combined with
GFP_KERNEL.

SG will fall back to lower-order pages if the higher-order attempt didn't
work out.

If we were to fine-tune this then perhaps:

	alloc_pages(GFP_ATOMIC & ~__GFP_HIGH, 3)
	alloc_pages(GFP_ATOMIC & ~__GFP_HIGH, 2)
	alloc_pages(GFP_ATOMIC & ~__GFP_HIGH, 1)
	alloc_pages(GFP_KERNEL, 0)

would suit.

