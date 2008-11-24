From: Thomas Gleixner <tglx@linutronix.de>
Subject: Re: next-20081119: general protection fault:
 get_next_timer_interrupt()
Date: Mon, 24 Nov 2008 23:33:36 +0100 (CET)
Message-ID: <alpine.LFD.2.00.0811242327130.3235@localhost.localdomain>
References: <a4423d670811190714k13721ae8s125e63d520892440@mail.gmail.com> <alpine.LFD.2.00.0811191308030.3119@localhost.localdomain> <a4423d670811210250t6b75645evd9646ffb07745867@mail.gmail.com> <alpine.LFD.2.00.0811241816120.3301@localhost.localdomain>
 <1227554117.25499.46.camel@localhost.localdomain> <alpine.LFD.2.00.0811242018370.3235@localhost.localdomain> <20081124213517.GA25898@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-next-owner@vger.kernel.org>
In-Reply-To: <20081124213517.GA25898@linux.vnet.ibm.com>
Sender: linux-next-owner@vger.kernel.org
To: Mike Anderson <andmike@linux.vnet.ibm.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, Alexander Beregalov <a.beregalov@gmail.com>, LKML <linux-kernel@vger.kernel.org>, linux-next@vger.kernel.org, Ingo Molnar <mingo@elte.hu>, linux-scsi@vger.kernel.org, David Miller <davem@davemloft.net>, Jens Axboe <jens.axboe@oracle.com>
List-Id: linux-scsi@vger.kernel.org

On Mon, 24 Nov 2008, Mike Anderson wrote:
> Thomas Gleixner <tglx@linutronix.de> wrote:
> > Yeah, block could it be as well. Jens, Mike ?
> 
> I added a comment to bug 12020 on Thursday about a few other systems that
> where seeing the signature shown in bug 12020. It appeared from debug that
> there where a few paths that where adding timers for requests that where
> not expected.
> 
> http://bugzilla.kernel.org/show_bug.cgi?id=12020
> 
> It would be good to know if the debug patch below effects your problem as while.
> 
> If it does we need to investigated a solution to resolve not adding a
> timer for these requests.

Wrong. 

The problem is not a timer which is armed in the first place.

The problem is an armed timer which is not canceled before the data
structure which contains it is freed.

So not arming the timer will probably prevent this particular scan
problem, but it does not solve the general wreckage of freeing a data
structure with a possibly armed timer in it.

You need to fix the code path which frees the data structure which
contains the timer and cancel the timer _before_ freeing the data
structure.

Thanks,

	tglx
