From: James Bottomley <James.Bottomley@steeleye.com>
Subject: Re: eata irq abuse (was: Re: Linux 2.5.60)
Date: 12 Feb 2003 08:54:51 -0600
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1045061694.1738.10.camel@mulgrave>
References: <70652A801D9E0C469C28A0F8BCF49CF9012EBA97@itmi1mx2.corp.emc.com>
	<20030212142541.A8262@infradead.org> <1045060838.1823.7.camel@mulgrave>
	<20030212145121.A8963@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: (from root@localhost)
	by pogo.mtv1.steeleye.com (8.9.3/8.9.3) id GAA08865
	for <linux-scsi@vger.kernel.org>; Wed, 12 Feb 2003 06:55:02 -0800
In-Reply-To: <20030212145121.A8963@infradead.org>
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: Ballabio_Dario@emc.com, manfred@colorfullife.com, warp@mercury.d2dc.net, SCSI Mailing List <linux-scsi@vger.kernel.org>

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


