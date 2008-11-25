From: malahal@us.ibm.com
Subject: Re: next-20081119: general protection fault:
	get_next_timer_interrupt()
Date: Mon, 24 Nov 2008 16:09:02 -0800
Message-ID: <20081125000902.GA24251@us.ibm.com>
References: <a4423d670811190714k13721ae8s125e63d520892440@mail.gmail.com> <alpine.LFD.2.00.0811191308030.3119@localhost.localdomain> <a4423d670811210250t6b75645evd9646ffb07745867@mail.gmail.com> <alpine.LFD.2.00.0811241816120.3301@localhost.localdomain> <1227554117.25499.46.camel@localhost.localdomain> <alpine.LFD.2.00.0811242018370.3235@localhost.localdomain> <20081124213517.GA25898@linux.vnet.ibm.com> <alpine.LFD.2.00.0811242327130.3235@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e8.ny.us.ibm.com ([32.97.182.138]:55816 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752133AbYKYAJF (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 24 Nov 2008 19:09:05 -0500
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.0811242327130.3235@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Mike Anderson <andmike@linux.vnet.ibm.com>, James Bottomley <James.Bottomley@HansenPartnership.com>, Alexander Beregalov <a.beregalov@gmail.com>, LKML <linux-kernel@vger.kernel.org>, linux-next@vger.kernel.org, Ingo Molnar <mingo@elte.hu>, linux-scsi@vger.kernel.org, David Miller <davem@davemloft.net>, Jens Axboe <jens.axboe@oracle.com>

Thomas Gleixner [tglx@linutronix.de] wrote:
> On Mon, 24 Nov 2008, Mike Anderson wrote:
> > Thomas Gleixner <tglx@linutronix.de> wrote:
> > > Yeah, block could it be as well. Jens, Mike ?
> > 
> > I added a comment to bug 12020 on Thursday about a few other systems that
> > where seeing the signature shown in bug 12020. It appeared from debug that
> > there where a few paths that where adding timers for requests that where
> > not expected.
> > 
> > http://bugzilla.kernel.org/show_bug.cgi?id=12020
> > 
> > It would be good to know if the debug patch below effects your problem as while.
> > 
> > If it does we need to investigated a solution to resolve not adding a
> > timer for these requests.

The block timer code calls del_timer(), should it call del_timer_sync()?
It is possible although unlikely that you are hitting del_timer_sync vs
del_timer problem in the block timeout code. Can only be seen on SMP
systems though!

--Malahal.
