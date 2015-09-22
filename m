From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [RFT v3] eata: Convert eata driver as normal PCI and platform
 device drivers
Date: Tue, 22 Sep 2015 15:45:29 -0700
Message-ID: <1442961929.15264.4.camel@HansenPartnership.com>
References: <20150916134211.GA21535@infradead.org>
	 <1442907023-12709-1-git-send-email-jiang.liu@linux.intel.com>
	 <5601D550.5000801@internode.on.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-pci-owner@vger.kernel.org>
In-Reply-To: <5601D550.5000801@internode.on.net>
Sender: linux-pci-owner@vger.kernel.org
To: Arthur Marsh <arthur.marsh@internode.on.net>
Cc: Jiang Liu <jiang.liu@linux.intel.com>, Thomas Gleixner <tglx@linutronix.de>, Bjorn Helgaas <bhelgaas@google.com>, Hannes Reinecke <hare@suse.de>, Ballabio Dario <dario.ballabio@emc.com>, Christoph Hellwig <hch@infradead.org>, Dario Ballabio <ballabio_dario@emc.com>, linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org, linux-scsi@vger.kernel.org, x86@kernel.org
List-Id: linux-scsi@vger.kernel.org

On Wed, 2015-09-23 at 07:55 +0930, Arthur Marsh wrote:
> 
> Jiang Liu wrote on 22/09/15 17:00:
> > Previously the eata driver just grabs and accesses eata PCI devices
> > without implementing a PCI device driver, that causes troubles with
> > latest IRQ related
> >
> > Commit 991de2e59090 ("PCI, x86: Implement pcibios_alloc_irq() and
> > pcibios_free_irq()") changes the way to allocate PCI legacy IRQ
> > for PCI devices on x86 platforms. Instead of allocating PCI legacy
> > IRQs when pcibios_enable_device() gets called, now pcibios_alloc_irq()
> > will be called by pci_device_probe() to allocate PCI legacy IRQs
> > when binding PCI drivers to PCI devices.
> >
> > But the eata driver directly accesses PCI devices without implementing
> > corresponding PCI drivers, so pcibios_alloc_irq() won't be called for
> > those PCI devices and wrong IRQ number may be used to manage the PCI
> > device.
> >
> > This patch implements a PCI device driver to manage eata PCI devices,
> > so eata driver could properly cooperate with the PCI core. It also
> > provides headroom for PCI hotplug with eata driver.
> >
> > It also represents non-PCI eata devices as platform devices, so it could
> > be managed as normal devices.
> >
> > Signed-off-by: Jiang Liu <jiang.liu@linux.intel.com>
> > Cc: Hannes Reinecke <hare@suse.de>
> > Cc: Ballabio, Dario <dario.ballabio@emc.com>
> > Cc: Christoph Hellwig <hch@infradead.org>
> > ---
> 
> Not really any change with this driver:
> 
> previously
> 
> http://www.users.on.net/~arthur.marsh/20150915547.jpg
> 
> now
> 
> http://www.users.on.net/~arthur.marsh/20150922553.jpg
> 
> If there was any way of capturing any more debug output I'd be happy to 
> do it.

It looks to be some problem in shut down.  Can you simply remove and
re-insert the driver successfully?  If it's your root disk driver,
you'll have to do this from an initrd so as not to have root mounted
from the eata controller.

If the remove and reinsert fails, it means we have a problem in the
driver shut down.  If not, it's likely something kexec related.

James
