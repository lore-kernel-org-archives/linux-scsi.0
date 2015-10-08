From: Jiang Liu <jiang.liu@linux.intel.com>
Subject: Re: [Bugfix v4 1/2] eata: Convert eata driver as normal PCI and
 platform device drivers
Date: Thu, 8 Oct 2015 11:10:08 +0800
Message-ID: <5615DE90.4090203@linux.intel.com>
References: <1444272675-14631-1-git-send-email-jiang.liu@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1444272675-14631-1-git-send-email-jiang.liu@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>, Thomas Gleixner <tglx@linutronix.de>, Bjorn Helgaas <bhelgaas@google.com>, Arthur Marsh <arthur.marsh@internode.on.net>, Hannes Reinecke <hare@suse.de>, Dario <dario.ballabio@emc.com>, Christoph Hellwig <hch@infradead.org>
Cc: linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org, linux-scsi@vger.kernel.org, x86@kernel.org
List-Id: linux-scsi@vger.kernel.org

On 2015/10/8 10:51, Jiang Liu wrote:
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

Hi all,
	Sorry, should add:
Reported-and-tested-by: Arthur Marsh <arthur.marsh@internode.on.net>

> Signed-off-by: Jiang Liu <jiang.liu@linux.intel.com>
> Cc: Hannes Reinecke <hare@suse.de>
> Cc: Ballabio, Dario <dario.ballabio@emc.com>
> Cc: Christoph Hellwig <hch@infradead.org>
> ---
