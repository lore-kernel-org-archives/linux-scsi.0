From: "Mukker, Atul" <Atulm@lsil.com>
Subject: RE: [ANNOUNCE]: megaraid driver version 2.20.0.rc2
Date: Fri, 28 May 2004 10:56:29 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <0E3FA95632D6D047BA649F95DAB60E57033BC6C8@exa-atlanta>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:9460 "EHLO mail0.lsil.com")
	by vger.kernel.org with ESMTP id S263370AbUE1O5u (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 28 May 2004 10:57:50 -0400
List-Id: linux-scsi@vger.kernel.org
To: 'Christoph Hellwig' <hch@infradead.org>, "Mukker, Atul" <Atulm@lsil.com>
Cc: "'linux-scsi@vger.kernel.org'" <linux-scsi@vger.kernel.org>

Thanks for the exhaustive feedback, please see inline comments

>  - the Kconfig needs to be reworked, the old and new driver 
> aren exclusive,
Actually they are. You cannot, for example, have megaraid (legacy) and
megaraid mgmt module since both would try to own the device for management
apps.

>    allow both of them (especially important for vendor kernels)

>  - I don't think megaraid is widely enough used for the 
> default y/m lines
That was a missing patch for scsi/Makefile. Will be fixed in next rev

>  - please rename the new driver for mailbox-based HBAs to 
> e.g. megraid_mbox
>  - #include "../scsi.h" must go, please use <scsi/*.h>
>  - the macros in kdep.h should go away, and the include in 
> there should
>    got into the individual source files aswell
>  - kill PCI_DIR, just use scp->sc_data_direction directly
>  - lockscope_t is unused, kill it
All ok

>  - any chance to use less typedefs, e.g. struct srb instead of srb_t?
>    struct adapter instead of adapter_t and maybe mraid_ 
> prefixes to avoid
>    namespace clashes?
Too many changes, but will be done, but probably not in next rev.

>  - MRAID_GET_DEVICE_MAP is far too large for a macro, please make it a
>    function call or opencode it in the callers
ok

>  - please kill mraid_driver_t in favour of individual global variables
It is in fact like that already! mraid_driver_t is just a template for LLDs

>  - you are _still_ using your own pci-pool reimplementation!
It is being changed right now

>  - instead of mraid_sleep please use msleep()
msleep, is it a standart API? carmel.c and libata-core.c both seem to have
their own definitions for it.

>  - any chance to rework megaraid_mbox.c to need less 
> forward-declarations
>    by reordering the function in their natural order?
It can be done ofcourse. It is a big impact change though, so would be
deferred for now.

>  - pci_id_table_g would be much more readable when not using 
> C99 initializers
But then we would couple pci_id_table_g with current definition of pci
table. Isn't this one of the reasons to use C99 initializations?

>  - please fix the 
> MRAID_TEMPLATE/megaraid_template_g/megaraid_template_gp
>    mess.  You need one struct scsi_host_template and can initialize it
>    at calltime, no need for macros or additional pointers.
It is a residue from lk 2.4 support. Would be removed now

>  - your probe for existing device in megaraid_probe_one is completely
>    bogus as it doesn't take pci domains into account.  Just kill the
>    device_list and that check, it's the PCI layers business to assure
>    you don't get multiple probe calls.
ok

>  - alloc_adapter_f/init_mbox_f in megaraid_probe_one and use 
> proper gotos
>    as I did in the old megaraid driver
Again, what here?

>  - mraid_driver_g.attach_count--; isn't used ever, just kill it
ok

>  - the device list walk in megaraid_mbox_shutdown is bogus, 
> again please
>    trust the upper layers
ok

>  - the detach path is bogus.  You need to do 
> scshi_remove_host first before
>    tearing down anything and scsi_host_put last
megaraid_io_detach does it exactly like that

>  - megaraid_info is not needed, for static info just stuff it into
>    scsi_host_template.name
ok

>  - the _f variable vs goto comment applies to 
> megaraid_init_mbox aswell
This is generic scheme use throughout the driver. Also see,
megaraid_alloc_cmd_packets

>  - WTF is status_t?
nothing, being removed :-)

>  - your locking looks far to fine-grained to me.  Did you 
> benchmark it?
>    Where was the bottleneck with a single per-host lock?
This locks are more natural. We are benchmarking right now

>  - please always use list_for_each_entry instead of list_for_each,
>    dito for _safe
ok

>  - please don't reintroduce megaraid_mm_open/close.  I killed 
> the superflous
>    open/close routines in megaraid a few times already and 
> they still come
>    back silently.
> 
ok
