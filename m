From: Marcelo Tosatti <marcelo.tosatti@cyclades.com>
Subject: Re: SCSI aic7xxx driver: Initialization Failure over a kdump reboot
Date: Sun, 30 Jan 2005 13:27:49 -0200
Message-ID: <20050130152749.GF5186@logos.cnet>
References: <1105014959.2688.296.camel@2fwv946.in.ibm.com> <1105013524.4468.3.camel@laptopd505.fenrus.org> <20050106195043.4b77c63e.akpm@osdl.org> <41DE15C7.6030102@nit.ca> <20050107043832.GR27371@parcelfarce.linux.theplanet.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from parcelfarce.linux.theplanet.co.uk ([195.92.249.252]:18635 "EHLO
	parcelfarce.linux.theplanet.co.uk") by vger.kernel.org with ESMTP
	id S261643AbVA3SY3 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 30 Jan 2005 13:24:29 -0500
Content-Disposition: inline
In-Reply-To: <20050107043832.GR27371@parcelfarce.linux.theplanet.co.uk>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>
Cc: Lukasz Kosewski <lkosewsk@nit.ca>, Andrew Morton <akpm@osdl.org>, Arjan van de Ven <arjan@infradead.org>, vgoyal@in.ibm.com, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

On Fri, Jan 07, 2005 at 04:38:32AM +0000, Matthew Wilcox wrote:
> On Thu, Jan 06, 2005 at 11:53:27PM -0500, Lukasz Kosewski wrote:
> > I have an idea of something I might do for 2.6.11, but I doubt anyone
> > will actually agree with it.  Say we keep a counter of how many times
> > interrupt x has been fired off since the last timer interrupt
> > (obviously, a timer interrupt resets the counter).  Then we can pick an
> > arbitrary threshold for masking out this interrupt until another device
> > actually pines for it.
> > 
> > Or something.  The point is, we need a general solution to the problem,
> > not poking about in every single driver trying to tie it down.
> 
> Something like note_interrupt() in kernel/irq/spurious.c?

BTW I wonder if its feasible to add an interface on top of kernel/irq/spurious.c for 
notifying drivers about interrupts storms, so they can take appropriate action 
(try to reset the device).

For example I've seen a 8390 based pcnet_cs driven (Linksys EtherFast 10/100+ + 56K Modem) PCMCIA
card go nuts and trigger infinite interrupt storms on custom PowerPC hardware under certain situations, 
and resetting the device after a high limit of bogus interrupts "brought the hardware back", stabilizing
the system.

Would be nice to be able to change the current hardcoded nr-of-interrupt limits, and 
have a notification mechanism.

Not sure if this kind of problem is common enough that adding a generic API 
is worth it, though ?
