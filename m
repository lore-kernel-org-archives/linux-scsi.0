From: James Bottomley <James.Bottomley@steeleye.com>
Subject: Re: eata irq abuse (was: Re: Linux 2.5.60)
Date: 12 Feb 2003 08:40:34 -0600
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1045060838.1823.7.camel@mulgrave>
References: <70652A801D9E0C469C28A0F8BCF49CF9012EBA97@itmi1mx2.corp.emc.com>
	<20030212142541.A8262@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: (from root@localhost)
	by pogo.mtv1.steeleye.com (8.9.3/8.9.3) id GAA07054
	for <linux-scsi@vger.kernel.org>; Wed, 12 Feb 2003 06:40:46 -0800
In-Reply-To: <20030212142541.A8262@infradead.org>
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: Ballabio_Dario@emc.com, manfred@colorfullife.com, warp@mercury.d2dc.net, SCSI Mailing List <linux-scsi@vger.kernel.org>

On Wed, 2003-02-12 at 08:25, Christoph Hellwig wrote:
> On Wed, Feb 12, 2003 at 09:13:10AM -0500, Ballabio_Dario@emc.com wrote:
> > Last time I tried to run the detect routine with interrupts enabled,
> > it just hung at the first occurrence on an inb() from
> > the board registers. If someone is able to have it 
> > working with interrupts enabled and qualifies the
> > solution on all the platforms and eata boards,
> > I'd be more than happy to remove it.
> 
> Ah, you don't need the lock but the disabled interrupts!

In general, that's not correct: most HBA registers have to be accessed
in sequence, thus you need global protection from anyone else touching
them while you're at the registers.  This is what host_lock was designed
for.

James


