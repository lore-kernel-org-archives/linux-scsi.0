From: 'Christoph Hellwig' <hch@infradead.org>
Subject: Re: [ANNOUNCE]: megaraid driver version 2.20.0.rc2
Date: Fri, 28 May 2004 15:02:38 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040528140238.GA28249@infradead.org>
References: <0E3FA95632D6D047BA649F95DAB60E57033BC694@exa-atlanta>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from [213.146.154.40] ([213.146.154.40]:46518 "EHLO
	pentafluge.infradead.org") by vger.kernel.org with ESMTP
	id S263089AbUE1OCk (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 28 May 2004 10:02:40 -0400
Content-Disposition: inline
In-Reply-To: <0E3FA95632D6D047BA649F95DAB60E57033BC694@exa-atlanta>
List-Id: linux-scsi@vger.kernel.org
To: "Mukker, Atul" <Atulm@lsil.com>
Cc: "'linux-scsi@vger.kernel.org'" <linux-scsi@vger.kernel.org>

[Cc-list cut down, everyone who cares enough should be on linux-scsi anyway]


 - the Kconfig needs to be reworked, the old and new driver aren exclusive,
   allow both of them (especially important for vendor kernels)
 - I don't think megaraid is widely enough used for the default y/m lines
 - please rename the new driver for mailbox-based HBAs to e.g. megraid_mbox
 - #include "../scsi.h" must go, please use <scsi/*.h>
 - the macros in kdep.h should go away, and the include in there should
   got into the individual source files aswell
 - kill PCI_DIR, just use scp->sc_data_direction directly
 - lockscope_t is unused, kill it
 - any chance to use less typedefs, e.g. struct srb instead of srb_t?
   struct adapter instead of adapter_t and maybe mraid_ prefixes to avoid
   namespace clashes?
 - MRAID_GET_DEVICE_MAP is far too large for a macro, please make it a
   function call or opencode it in the callers
 - please kill mraid_driver_t in favour of individual global variables
 - you are _still_ using your own pci-pool reimplementation!
 - instead of mraid_sleep please use msleep()
 - any chance to rework megaraid_mbox.c to need less forward-declarations
   by reordering the function in their natural order?
 - pci_id_table_g would be much more readable when not using C99 initializers
 - please fix the MRAID_TEMPLATE/megaraid_template_g/megaraid_template_gp
   mess.  You need one struct scsi_host_template and can initialize it
   at calltime, no need for macros or additional pointers.
 - your probe for existing device in megaraid_probe_one is completely
   bogus as it doesn't take pci domains into account.  Just kill the
   device_list and that check, it's the PCI layers business to assure
   you don't get multiple probe calls.
 - alloc_adapter_f/init_mbox_f in megaraid_probe_one and use proper gotos
   as I did in the old megaraid driver
 - mraid_driver_g.attach_count--; isn't used ever, just kill it
 - the device list walk in megaraid_mbox_shutdown is bogus, again please
   trust the upper layers
 - the detach path is bogus.  You need to do scshi_remove_host first before
   tearing down anything and scsi_host_put last
 - megaraid_info is not needed, for static info just stuff it into
   scsi_host_template.name
 - the _f variable vs goto comment applies to megaraid_init_mbox aswell
 - WTF is status_t?
 - your locking looks far to fine-grained to me.  Did you benchmark it?
   Where was the bottleneck with a single per-host lock?
 - please always use list_for_each_entry instead of list_for_each,
   dito for _safe
 - please don't reintroduce megaraid_mm_open/close.  I killed the superflous
   open/close routines in megaraid a few times already and they still come
   back silently.
