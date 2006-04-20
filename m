From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: areca RAID driver
Date: Wed, 19 Apr 2006 21:04:25 -0600
Message-ID: <20060420030425.GN24104@parisc-linux.org>
References: <20060419155300.321c352e.akpm@osdl.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:63153 "EHLO
	palinux.external.hp.com") by vger.kernel.org with ESMTP
	id S1750887AbWDTDE3 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 19 Apr 2006 23:04:29 -0400
Content-Disposition: inline
In-Reply-To: <20060419155300.321c352e.akpm@osdl.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@osdl.org>
Cc: James Bottomley <James.Bottomley@steeleye.com>, Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@suse.de>, erich <erich@areca.com.tw>, billion.wu@areca.com.tw, linux-scsi@vger.kernel.org

On Wed, Apr 19, 2006 at 03:53:00PM -0700, Andrew Morton wrote:
> 
> Gents, Erich thinks that the Areca driver is pretty much ready to go.
> 
> We still have the weird read-past-EOF problem if MAX_XFER_SECTORS=4096, but
> this version of the driver has it set to 512, which makes the problem go
> away.  I've suggested that we can set that problem aside for now.
> 
> I've put a copy of the latest diff at
> http://www.zip.com.au/~akpm/linux/patches/stuff/areca-raid-linux-scsi-driver.patch.
>  Could you please take a look sometime, decide how we should proceed?

1.

+static int arcmsr_initialize(struct AdapterControlBlock *pACB, struct pci_dev *pdev)
[...]
+       pci_read_config_byte(pdev, PCI_COMMAND, &pcicmd);
+       pci_write_config_byte(pdev, PCI_COMMAND,
+               pcicmd | PCI_COMMAND_INVALIDATE | PCI_COMMAND_MASTER | PCI_COMMAND_MEMORY);

It's already calling pci_enable_device() and pci_set_master().  To set
PCI_COMMAND_INVALIDATE, it should also be calling pci_set_mwi().

2. arcmsr_attr_host_pci_info() is just weird.  I can't imagine why
anyone would need that information -- you can get it all from sysfs
already.

3. arcmsr_transport_functions are declared extern ... and never used.

4. There's a *lot* of unnecessarily long lines.  Often in documentation,
even!
+**             on the internal bus. Some time later, a PCI master attempts a Memory Read with the same address

5. The other sysfs files don't exactly conform to 'one value per file'
either.

6. It seems weird to split the driver into three files -- one with the
sysfs attributes in it, one with everything else, and a header file.
I don't see why it shouldn't *all* be in drivers/scsi/arcmsr.c

7. The 'linux bug' workaround in queue_command looks decidedly dodgy to
me, but I'd like someone more experienced to comment on it.
