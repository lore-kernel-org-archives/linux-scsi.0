From: 'Christoph Hellwig' <hch@infradead.org>
Subject: Re: [ANNOUNCE]: megaraid driver version 2.20.0.rc2
Date: Fri, 28 May 2004 16:06:30 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040528150630.GA29158@infradead.org>
References: <0E3FA95632D6D047BA649F95DAB60E57033BC6C8@exa-atlanta>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from [213.146.154.40] ([213.146.154.40]:27319 "EHLO
	pentafluge.infradead.org") by vger.kernel.org with ESMTP
	id S263413AbUE1PGc (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 28 May 2004 11:06:32 -0400
Content-Disposition: inline
In-Reply-To: <0E3FA95632D6D047BA649F95DAB60E57033BC6C8@exa-atlanta>
List-Id: linux-scsi@vger.kernel.org
To: "Mukker, Atul" <Atulm@lsil.com>
Cc: "'linux-scsi@vger.kernel.org'" <linux-scsi@vger.kernel.org>

On Fri, May 28, 2004 at 10:56:29AM -0400, Mukker, Atul wrote:
> >  - the Kconfig needs to be reworked, the old and new driver 
> > aren exclusive,
> Actually they are. You cannot, for example, have megaraid (legacy) and
> megaraid mgmt module since both would try to own the device for management
> apps.

Even if you can't load both you can still build both and the other will
fail to load (or at least should, if not that's a bug on your side ;-))

> >  - instead of mraid_sleep please use msleep()
> msleep, is it a standart API? carmel.c and libata-core.c both seem to have
> their own definitions for it.

We moved to a common implementation after 2.6.6 was released.

> >  - any chance to rework megaraid_mbox.c to need less 
> > forward-declarations
> >    by reordering the function in their natural order?
> It can be done ofcourse. It is a big impact change though, so would be
> deferred for now.

Sure, just sweep over it when everythign else it done.

> >  - pci_id_table_g would be much more readable when not using 
> > C99 initializers
> But then we would couple pci_id_table_g with current definition of pci
> table. Isn't this one of the reasons to use C99 initializations?

PCI table doesn't change, there's lots of users that prefer the more
readable variant.  And it's really far less and much easier to grok
lines without C99 initializers.


> >  - alloc_adapter_f/init_mbox_f in megaraid_probe_one and use 
> > proper gotos
> >    as I did in the old megaraid driver
> Again, what here?

Use goto's to jump to the appropinquate cleanup step instead of the
boolean foo_f variables and a single cleanup label.

> >  - the detach path is bogus.  You need to do 
> > scshi_remove_host first before
> >    tearing down anything and scsi_host_put last
> megaraid_io_detach does it exactly like that

No. In megaraid_detach_one your first set being_detached, and set
the pci driver data to NULL, then call megaraid_io_detach with
scsi_remove_host, then scsi_host_put (btw, please kill megaraid_io_detach
as a separate function),  then call megaraid_fini_mbox and kfree(adapter).


> >  - the _f variable vs goto comment applies to 
> > megaraid_init_mbox aswell
> This is generic scheme use throughout the driver. Also see,
> megaraid_alloc_cmd_packets

Right, that also needs fixing..

