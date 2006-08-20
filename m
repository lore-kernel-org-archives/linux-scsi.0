From: Arjan van de Ven <arjan@fenrus.demon.nl>
Subject: Re: Bugs on Linux 2.6.18-rc2 sg code?
Date: Sun, 20 Aug 2006 12:07:21 +0200
Message-ID: <1156068441.23756.23.camel@laptopd505.fenrus.org>
References: <8202f4270608101843r7df002d2l40e03eca3271b050@mail.gmail.com>
	 <44E6388D.1000206@torque.net> <44E68F76.4010702@torque.net>
	 <20060819172024.GS4340@parisc-linux.org> <44E74C21.8040108@torque.net>
	 <20060819104109.588604bd.akpm@osdl.org>
	 <20060819202323.GT4340@parisc-linux.org>  <44E7B439.2070602@torque.net>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from a222036.upc-a.chello.nl ([62.163.222.36]:5595 "EHLO
	laptopd505.fenrus.org") by vger.kernel.org with ESMTP
	id S1750708AbWHTKHj (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 20 Aug 2006 06:07:39 -0400
In-Reply-To: <44E7B439.2070602@torque.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: dougg@torque.net
Cc: Matthew Wilcox <matthew@wil.cx>, Andrew Morton <akpm@osdl.org>, Fajun Chen <fajunchen@gmail.com>, linux-scsi@vger.kernel.org, James.Bottomley@SteelEye.com

On Sat, 2006-08-19 at 21:00 -0400, Douglas Gilbert wrote:
> Matthew Wilcox wrote:
> > On Sat, Aug 19, 2006 at 10:41:09AM -0700, Andrew Morton wrote:
> >> ow, GFP_ATOMIC is bad.  Can we avoid that?
> > 
> > I believe all the GFP_ATOMIC calls in sg.c can be downgraded to
> > GFP_KERNEL.
> 
> Well, if memory serves, we have been around this loop
> before. The GFP_ATOMIC flags were removed, users
> complained about unexplained, unbounded waits unrelated
> to the SCSI transport or device.

this is not a fair answer... in a way GFP_ATOMIC is an antisocial
behavior that should only be done when there is an absolute need. You'll
dip into the VM reserves by using it after all!

And for normal allocations, people who get the kernel to ask for a lot
of memory need to do their fair share of waiting for memory, just to
have write throttling work correctly...
