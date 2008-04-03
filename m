From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH 06/21] qla2xxx: Simplify interrupt handler locking.
Date: Thu, 03 Apr 2008 17:39:14 -0500
Message-ID: <1207262354.3048.68.camel@localhost.localdomain>
References: <20080403201152.GB8033@plap4.local>
	 <1207253612-15538-6-git-send-email-andrew.vasquez@qlogic.com>
	 <1207255010.3048.66.camel@localhost.localdomain>
	 <20080403220710.GA17338@plap4.local>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:34690 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752005AbYDCWjS (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 3 Apr 2008 18:39:18 -0400
In-Reply-To: <20080403220710.GA17338@plap4.local>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Vasquez <andrew.vasquez@qlogic.com>
Cc: Linux SCSI Mailing List <linux-scsi@vger.kernel.org>, Seokmann Ju <seokmann.ju@qlogic.com>

On Thu, 2008-04-03 at 15:07 -0700, Andrew Vasquez wrote:
> On Thu, 03 Apr 2008, James Bottomley wrote:
> 
> > On Thu, 2008-04-03 at 13:13 -0700, Andrew Vasquez wrote:
> > > There's no need to use the heavier (albiet safer)
> > > *_irq[save|restore]() locking primitives within the driver's
> > > interrupt handlers, interrupts are guaranteed to be
> > > non-reentrant.  Use lightweight spin_lock() and spin_unlock()
> > > primitives while acquiring the hardware_lock.
> > 
> > The above statement isn't entirely true: interrupts are not guaranteed
> > to be non re-entrant.  They are guaranteed not to be re-entered from the
> > *same* interrupt, but if you've got more than one card, the interrupt
> > routine can be executing simultaneously on an SMP system which is in
> > contravention of the classical definition of re-entrancy.
> >
> > So, the rules for locks in interrupt is that as long as the lock is
> > unique per interrupting instance (which it looks like yours are)
> 
> They are...

Thanks.

> > you can
> > get away with not requiring interrupt disables within critical sections
> > but if you have a more global lock which could be taken by different
> > interrupting entities then you must do interrupt disables still.
> 
> Thanks for the clarification.  Would you like me to resubmit with an
> altered changelog or can the current one glide in?

No .. that's OK ... I can't think of a better way to word it that won't
take up whole sentences.

James


