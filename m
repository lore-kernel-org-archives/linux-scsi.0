From: 'Christoph Hellwig' <hch@infradead.org>
Subject: Re: [ANNOUNCE]: megaraid driver version 2.20.0.rc2
Date: Wed, 23 Jun 2004 21:33:50 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040623203350.GA29538@infradead.org>
References: <0E3FA95632D6D047BA649F95DAB60E57033BC694@exa-atlanta> <20040528140238.GA28249@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from [213.146.154.40] ([213.146.154.40]:7836 "EHLO
	pentafluge.infradead.org") by vger.kernel.org with ESMTP
	id S266657AbUFWUdx (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 23 Jun 2004 16:33:53 -0400
Content-Disposition: inline
In-Reply-To: <20040528140238.GA28249@infradead.org>
List-Id: linux-scsi@vger.kernel.org
To: "Mukker, Atul" <Atulm@lsil.com>
Cc: "'linux-scsi@vger.kernel.org'" <linux-scsi@vger.kernel.org>

Going through my old list what's done and what still needs to be done,

On Fri, May 28, 2004 at 03:02:38PM +0100, 'Christoph Hellwig' wrote:
> [Cc-list cut down, everyone who cares enough should be on linux-scsi anyway]
> 
> 
>  - the Kconfig needs to be reworked, the old and new driver aren exclusive,
>    allow both of them (especially important for vendor kernels)

OK.

>  - I don't think megaraid is widely enough used for the default y/m lines

still needs fixing

>  - please rename the new driver for mailbox-based HBAs to e.g. megraid_mbox

Ok.

>  - #include "../scsi.h" must go, please use <scsi/*.h>

Ok.

>  - the macros in kdep.h should go away, and the include in there should
>    got into the individual source files aswell

first is ok, the latter only moved to mega_common.h instead of the actual
source files

>  - kill PCI_DIR, just use scp->sc_data_direction directly

Ok.

>  - lockscope_t is unused, kill it

Ok.

>  - any chance to use less typedefs, e.g. struct srb instead of srb_t?
>    struct adapter instead of adapter_t and maybe mraid_ prefixes to avoid
>    namespace clashes?

Some of this seems to be done, thanks.  Please also remove the _t postfixes
of the struct names.

>  - MRAID_GET_DEVICE_MAP is far too large for a macro, please make it a
>    function call or opencode it in the callers

Still needs to be done.  There's only one caller anyway, so no need for
the macro

>  - please kill mraid_driver_t in favour of individual global variables

still there.

>  - you are _still_ using your own pci-pool reimplementation!

Ok.

>  - instead of mraid_sleep please use msleep()

Ok.

>  - any chance to rework megaraid_mbox.c to need less forward-declarations
>    by reordering the function in their natural order?

still quite a lot of those.

>  - pci_id_table_g would be much more readable when not using C99 initializers

still there.

>  - please fix the MRAID_TEMPLATE/megaraid_template_g/megaraid_template_gp
>    mess.  You need one struct scsi_host_template and can initialize it
>    at calltime, no need for macros or additional pointers.

done, thanks.  But you double-indented the megaraid_template_g members now.

>  - your probe for existing device in megaraid_probe_one is completely
>    bogus as it doesn't take pci domains into account.  Just kill the
>    device_list and that check, it's the PCI layers business to assure
>    you don't get multiple probe calls.

Done, thanks.

>  - alloc_adapter_f/init_mbox_f in megaraid_probe_one and use proper gotos
>    as I did in the old megaraid driver

still needs to be done.

>  - mraid_driver_g.attach_count--; isn't used ever, just kill it

done, thanks.

>  - the device list walk in megaraid_mbox_shutdown is bogus, again please
>    trust the upper layers

done, thanks.

>  - the detach path is bogus.  You need to do scshi_remove_host first before
>    tearing down anything and scsi_host_put last

still needs to be fixed.

>  - megaraid_info is not needed, for static info just stuff it into
>    scsi_host_template.name

done, thanks.

>  - the _f variable vs goto comment applies to megaraid_init_mbox aswell

dito

>  - your locking looks far to fine-grained to me.  Did you benchmark it?
>    Where was the bottleneck with a single per-host lock?

sill applies.

>  - please always use list_for_each_entry instead of list_for_each,
>    dito for _safe

done, thanks.

>  - please don't reintroduce megaraid_mm_open/close.  I killed the superflous
>    open/close routines in megaraid a few times already and they still come
>    back silently.

done, thanks.


Also a new quick observation:  mraid_driver_g.device_list is completely
unused, you can just remove it
