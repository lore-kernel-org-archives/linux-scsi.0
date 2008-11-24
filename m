From: malahal@us.ibm.com
Subject: Re: next-20081119: general protection fault:
	get_next_timer_interrupt()
Date: Mon, 24 Nov 2008 15:42:14 -0800
Message-ID: <20081124234214.GA23553@us.ibm.com>
References: <a4423d670811190714k13721ae8s125e63d520892440@mail.gmail.com> <alpine.LFD.2.00.0811191308030.3119@localhost.localdomain> <a4423d670811210250t6b75645evd9646ffb07745867@mail.gmail.com> <alpine.LFD.2.00.0811241816120.3301@localhost.localdomain> <1227554117.25499.46.camel@localhost.localdomain> <alpine.LFD.2.00.0811242018370.3235@localhost.localdomain> <20081124213517.GA25898@linux.vnet.ibm.com> <alpine.LFD.2.00.0811242327130.3235@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e1.ny.us.ibm.com ([32.97.182.141]:43897 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753581AbYKXXmS (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 24 Nov 2008 18:42:18 -0500
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.0811242327130.3235@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Mike Anderson <andmike@linux.vnet.ibm.com>, James Bottomley <James.Bottomley@HansenPartnership.com>, Alexander Beregalov <a.beregalov@gmail.com>, LKML <linux-kernel@vger.kernel.org>, linux-next@vger.kernel.org, Ingo Molnar <mingo@elte.hu>, linux-scsi@vger.kernel.org, David Miller <davem@davemloft.net>, Jens Axboe <jens.axboe@oracle.com>

Thomas Gleixner [tglx@linutronix.de] wrote:
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
> 
> Wrong. 
> 
> The problem is not a timer which is armed in the first place.

No, this could be a problem if such a timer is not dis-armed! As fas as
I know, the queue timer will be dis-armed in end_that_request_last() if
needed. Do we know end_that_request_last() gets called for every request
queued?

> The problem is an armed timer which is not canceled before the data
> structure which contains it is freed.
> 
> So not arming the timer will probably prevent this particular scan
> problem, but it does not solve the general wreckage of freeing a data
> structure with a possibly armed timer in it.
> 
> You need to fix the code path which frees the data structure which
> contains the timer and cancel the timer _before_ freeing the data
> structure.

Agreed but the timer is armed when a request is sent and is dis-armed
when it is completed. Essentially there should NOT be any active
timer(s) when you try to free the request queue. In other words, the
code which frees the data structure (request queue) is correct and there
is no need to cancel the timer there!

--Malahal.
