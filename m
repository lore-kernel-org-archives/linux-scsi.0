From: Arthur Marsh <arthur.marsh@internode.on.net>
Subject: Re: [RFT v3] eata: Convert eata driver as normal PCI and platform
 device drivers
Date: Wed, 23 Sep 2015 07:55:20 +0930
Message-ID: <5601D550.5000801@internode.on.net>
References: <20150916134211.GA21535@infradead.org> <1442907023-12709-1-git-send-email-jiang.liu@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1442907023-12709-1-git-send-email-jiang.liu@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Jiang Liu <jiang.liu@linux.intel.com>, Thomas Gleixner <tglx@linutronix.de>, Bjorn Helgaas <bhelgaas@google.com>, Hannes Reinecke <hare@suse.de>, Ballabio Dario <dario.ballabio@emc.com>, Christoph Hellwig <hch@infradead.org>, Dario Ballabio <ballabio_dario@emc.com>, "James E.J. Bottomley" <JBottomley@odin.com>
Cc: linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org, linux-scsi@vger.kernel.org, x86@kernel.org
List-Id: linux-scsi@vger.kernel.org



Jiang Liu wrote on 22/09/15 17:00:
> Previously the eata driver just grabs and accesses eata PCI devices
> without implementing a PCI device driver, that causes troubles with
> latest IRQ related
>
> Commit 991de2e59090 ("PCI, x86: Implement pcibios_alloc_irq() and
> pcibios_free_irq()") changes the way to allocate PCI legacy IRQ
> for PCI devices on x86 platforms. Instead of allocating PCI legacy
> IRQs when pcibios_enable_device() gets called, now pcibios_alloc_irq()
> will be called by pci_device_probe() to allocate PCI legacy IRQs
> when binding PCI drivers to PCI devices.
>
> But the eata driver directly accesses PCI devices without implementing
> corresponding PCI drivers, so pcibios_alloc_irq() won't be called for
> those PCI devices and wrong IRQ number may be used to manage the PCI
> device.
>
> This patch implements a PCI device driver to manage eata PCI devices,
> so eata driver could properly cooperate with the PCI core. It also
> provides headroom for PCI hotplug with eata driver.
>
> It also represents non-PCI eata devices as platform devices, so it could
> be managed as normal devices.
>
> Signed-off-by: Jiang Liu <jiang.liu@linux.intel.com>
> Cc: Hannes Reinecke <hare@suse.de>
> Cc: Ballabio, Dario <dario.ballabio@emc.com>
> Cc: Christoph Hellwig <hch@infradead.org>
> ---

Not really any change with this driver:

previously

http://www.users.on.net/~arthur.marsh/20150915547.jpg

now

http://www.users.on.net/~arthur.marsh/20150922553.jpg

If there was any way of capturing any more debug output I'd be happy to 
do it.

Arthur.
