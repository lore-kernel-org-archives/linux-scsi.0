From: 'Christoph Hellwig' <hch@infradead.org>
Subject: Re: [ANNOUNCE]: megaraid driver version 2.20.0.rc2
Date: Thu, 24 Jun 2004 10:46:51 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040624094651.GA6945@infradead.org>
References: <0E3FA95632D6D047BA649F95DAB60E57033BC7B5@exa-atlanta>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from [213.146.154.40] ([213.146.154.40]:11172 "EHLO
	pentafluge.infradead.org") by vger.kernel.org with ESMTP
	id S264160AbUFXJqx (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 24 Jun 2004 05:46:53 -0400
Content-Disposition: inline
In-Reply-To: <0E3FA95632D6D047BA649F95DAB60E57033BC7B5@exa-atlanta>
List-Id: linux-scsi@vger.kernel.org
To: "Mukker, Atul" <Atulm@lsil.com>
Cc: 'Christoph Hellwig' <hch@infradead.org>, "'linux-scsi@vger.kernel.org'" <linux-scsi@vger.kernel.org>

On Wed, Jun 23, 2004 at 11:45:14PM -0400, Mukker, Atul wrote:
> >  - I don't think megaraid is widely enough used for the default y/m lines
> 
> still needs fixing
> 
> AM> The statement is wrong. MegaRAID *is* a very widely used controller

Umm, of course.  But the default statements are usually only for things
which are nessecary to get a working ssystem.  E.g. the much more widely
used Intel PIIX or VIA IDE controller drivers found on just about every
motherboard don't have a default statement either.

> >  - the macros in kdep.h should go away, and the include in there should
> >    got into the individual source files aswell
> 
> first is ok, the latter only moved to mega_common.h instead of the actual
> source files
> AM> IMO, these subset of original macros make the translation to mid-layer
> to LLD very convenient.

I didn't actually complain about macros, but that the include files aren't
in the individual files.

> >  - MRAID_GET_DEVICE_MAP is far too large for a macro, please make it a
> >    function call or opencode it in the callers
> 
> Still needs to be done.  There's only one caller anyway, so no need for
> the macro
> AM> This code base uses at only one place, but there is another low level
> driver if offing which uses the same definitions. So this should stay.

then please convert it to an inline function.

> 
> >  - any chance to rework megaraid_mbox.c to need less forward-declarations
> >    by reordering the function in their natural order?
> 
> still quite a lot of those.
> AM> Again, this matches with our driver functions layout. If you observe
> closely, the driver functions (well mostly) are laid out in a breadth-first
> approach, with do-undo functions kept together. If this approach does not
> meet general driver guidelines, we will fix it, but next major rev

Well, it's okay, I just asked because I didn't get any feedback on it.

> >  - pci_id_table_g would be much more readable when not using C99
> initializers
> 
> still there.
> 
> AM> NO, foul! It has been corrected

Sorry, my apologies.  I still looked huge beause you have each ID spread
over multiple lines.  

> >  - alloc_adapter_f/init_mbox_f in megaraid_probe_one and use proper gotos
> >    as I did in the old megaraid driver
> 
> still needs to be done.
> 
> AM> I feel, this is a cleaner approach to up-wrap in case something goes
> bad. With goto 'many labels' the place you are going to jump from actually
> wants to undo (possibly unrelated) previous step

You usually want to undo all previous steps, exactly because of that the
goto approach is superior.

> >  - the detach path is bogus.  You need to do scshi_remove_host first
> before
> >    tearing down anything and scsi_host_put last
> 
> still needs to be fixed.
> AM> I must be missing something here. Please elaborate again.

Basic rule for a ->remove routine of a scsi driver is:

Call scsi_remove_host() first, then do all teardown of the hardware and
unregistration of ressources (release_region, iounmap, free_irq, etc..) and
then finally call scsi_host_put.

> >  - your locking looks far to fine-grained to me.  Did you benchmark it?
> >    Where was the bottleneck with a single per-host lock?
> 
> sill applies.
> AM> If fact, the performance did improve on the enterprise kernels with
> fine-grain locks. So, this locking mechanism should stay

Ok, that's why I asked for benchmark numbers.
