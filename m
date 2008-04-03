From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH 06/21] qla2xxx: Simplify interrupt handler locking.
Date: Thu, 03 Apr 2008 15:36:50 -0500
Message-ID: <1207255010.3048.66.camel@localhost.localdomain>
References: <20080403201152.GB8033@plap4.local>
	 <1207253612-15538-6-git-send-email-andrew.vasquez@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:35766 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753470AbYDCUgx (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 3 Apr 2008 16:36:53 -0400
In-Reply-To: <1207253612-15538-6-git-send-email-andrew.vasquez@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Vasquez <andrew.vasquez@qlogic.com>
Cc: Linux SCSI Mailing List <linux-scsi@vger.kernel.org>, Seokmann Ju <seokmann.ju@qlogic.com>

On Thu, 2008-04-03 at 13:13 -0700, Andrew Vasquez wrote:
> There's no need to use the heavier (albiet safer)
> *_irq[save|restore]() locking primitives within the driver's
> interrupt handlers, interrupts are guaranteed to be
> non-reentrant.  Use lightweight spin_lock() and spin_unlock()
> primitives while acquiring the hardware_lock.

The above statement isn't entirely true: interrupts are not guaranteed
to be non re-entrant.  They are guaranteed not to be re-entered from the
*same* interrupt, but if you've got more than one card, the interrupt
routine can be executing simultaneously on an SMP system which is in
contravention of the classical definition of re-entrancy.

So, the rules for locks in interrupt is that as long as the lock is
unique per interrupting instance (which it looks like yours are) you can
get away with not requiring interrupt disables within critical sections
but if you have a more global lock which could be taken by different
interrupting entities then you must do interrupt disables still.

James


