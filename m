From: Christoph Hellwig <hch@infradead.org>
Subject: Re: eata irq abuse (was: Re: Linux 2.5.60)
Date: Wed, 12 Feb 2003 14:25:41 +0000
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030212142541.A8262@infradead.org>
References: <70652A801D9E0C469C28A0F8BCF49CF9012EBA97@itmi1mx2.corp.emc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <70652A801D9E0C469C28A0F8BCF49CF9012EBA97@itmi1mx2.corp.emc.com>; from Ballabio_Dario@emc.com on Wed, Feb 12, 2003 at 09:13:10AM -0500
List-Id: linux-scsi@vger.kernel.org
To: Ballabio_Dario@emc.com
Cc: hch@infradead.org, manfred@colorfullife.com, warp@mercury.d2dc.net, linux-scsi@vger.kernel.org

On Wed, Feb 12, 2003 at 09:13:10AM -0500, Ballabio_Dario@emc.com wrote:
> Last time I tried to run the detect routine with interrupts enabled,
> it just hung at the first occurrence on an inb() from
> the board registers. If someone is able to have it 
> working with interrupts enabled and qualifies the
> solution on all the platforms and eata boards,
> I'd be more than happy to remove it.

Ah, you don't need the lock but the disabled interrupts!

What about adding

local_irq_disable();
...
local_irq_enable();

around the sections that need interreupts disabled?  The spinlock is
really confusing.
