From: Christoph Hellwig <hch@infradead.org>
Subject: Re: eata irq abuse (was: Re: Linux 2.5.60)
Date: Wed, 12 Feb 2003 14:51:21 +0000
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030212145121.A8963@infradead.org>
References: <70652A801D9E0C469C28A0F8BCF49CF9012EBA97@itmi1mx2.corp.emc.com> <20030212142541.A8262@infradead.org> <1045060838.1823.7.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1045060838.1823.7.camel@mulgrave>; from James.Bottomley@steeleye.com on Wed, Feb 12, 2003 at 08:40:34AM -0600
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>
Cc: Ballabio_Dario@emc.com, manfred@colorfullife.com, warp@mercury.d2dc.net, SCSI Mailing List <linux-scsi@vger.kernel.org>

On Wed, Feb 12, 2003 at 08:40:34AM -0600, James Bottomley wrote:
> > Ah, you don't need the lock but the disabled interrupts!
> 
> In general, that's not correct: most HBA registers have to be accessed
> in sequence, thus you need global protection from anyone else touching
> them while you're at the registers.  This is what host_lock was designed
> for.

Of course.  but that's not how driver_lock in eata.c works.  It's taken
when we enter eata2x_detect(), dropped before scsi_register(), reacquired
afterwards and released when we leave eata2x_detect().  I don't really
see what it is supposed to protect.

