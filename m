From: Luben Tuikov <ltuikov@yahoo.com>
Subject: Re: DMA mapping on SCSI device?
Date: Tue, 29 Jan 2008 14:23:15 -0800 (PST)
Message-ID: <593242.13701.qm@web31807.mail.mud.yahoo.com>
References: <200801290528.00934.ak@suse.de>
Reply-To: ltuikov@yahoo.com
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from web31807.mail.mud.yahoo.com ([68.142.207.70]:42580 "HELO
	web31807.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1758546AbYA2WXQ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 29 Jan 2008 17:23:16 -0500
In-Reply-To: <200801290528.00934.ak@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Robert Hancock <hancockr@shaw.ca>, Andi Kleen <ak@suse.de>
Cc: linux-arch@vger.kernel.org, ide <linux-ide@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, linux-scsi@vger.kernel.org

--- On Mon, 1/28/08, Andi Kleen <ak@suse.de> wrote:
> > The ideal solution would be to do mapping against a
> different struct
> > device for each port, so that we could maintain the
> proper DMA mask for
> > each of them at all times. However I'm not sure if
> that's possible.
> 
> I cannot imagine why it should be that difficult. The PCI
> subsystem
> could over a pci_clone_device() or similar function.   For
> all complicated
> purposes (sysfs etc)  the original device could be used, so
> it would
> be hopefully not that difficult.
> 
> The alternative would be to add a new family of PCI mapping
> functions that take an explicit mask. Disadvantage would be
> changing 
> all architectures, but on the other hand the interface
> could be phase
> in one by one (and nF4 primarily only works on x86 anyways)
> 
> I suspect the later would be a little cleaner, although
> they don't
> make much difference.

Yes, I guess, that's certainly doable.

The current PCI abstraction is clean: HW DMA engine(s) implementation
is a property of the PCI function.

Marrying different behaviour of the HW DMA engine of the ASIC
depending on the SCSI end device at the PCI device abstraction doesn't
sound good. (An extreme design is a single DMA engine servicing
the ASIC.)

Although, the effect that Rob wants could be cleanly implemented
at a higher level, pci_map_sg() and such, or fixing 
blk_queue_bounce_limit() in x86_64 to that effect.

    Luben

