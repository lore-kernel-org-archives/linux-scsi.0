From: Ballabio_Dario@emc.com
Subject: RE: eata irq abuse (was: Re: Linux 2.5.60)
Date: Wed, 12 Feb 2003 10:37:36 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <70652A801D9E0C469C28A0F8BCF49CF9012EBAB3@itmi1mx2.corp.emc.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Return-path: <linux-scsi-owner@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@steeleye.com, hch@infradead.org
Cc: Ballabio_Dario@emc.com, manfred@colorfullife.com, warp@mercury.d2dc.net, linux-scsi@vger.kernel.org

local_irq_disable/enable could be sufficient as long as
there are not two instances of the detect routine 
running simultaneously, which is hopefully the case
with actual lk, even when loading the driver as a module.
Moreover the local_irq primitives are relatively new,
while spin_lock_irq has been available for years. 
There is nothing special with eata driver concerning
this aspect, what you see is common to the majority
of scsi low level drivers. As long as interrupts are
disabled while accessing board registers _and_ the
detect routine is known to lk to be non re-entrant, any
protection scheme would fit.
-db


-----Original Message-----
From: James Bottomley [mailto:James.Bottomley@steeleye.com]
Sent: Wednesday, February 12, 2003 3:55 PM
To: Christoph Hellwig
Cc: Ballabio_Dario@emc.com; manfred@colorfullife.com;
warp@mercury.d2dc.net; SCSI Mailing List
Subject: Re: eata irq abuse (was: Re: Linux 2.5.60)


On Wed, 2003-02-12 at 08:51, Christoph Hellwig wrote:
> On Wed, Feb 12, 2003 at 08:40:34AM -0600, James Bottomley wrote:
> > > Ah, you don't need the lock but the disabled interrupts!
> > 
> > In general, that's not correct: most HBA registers have to be accessed
> > in sequence, thus you need global protection from anyone else touching
> > them while you're at the registers.  This is what host_lock was designed
> > for.
> 
> Of course.  but that's not how driver_lock in eata.c works.  It's taken
> when we enter eata2x_detect(), dropped before scsi_register(), reacquired
> afterwards and released when we leave eata2x_detect().  I don't really
> see what it is supposed to protect.

I agree, I'll look over the driver while I'm travelling today and see if
we can do better.  I just didn't want to give the impression that
local_irq_disable() is sufficient protection when accessing board
registers (having seen one or two SMP problems related to this).

James

