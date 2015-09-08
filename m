From: Bjorn Helgaas <bhelgaas@google.com>
Subject: Re: [Bugfix] PCI, x86: Correctly allocate IRQs for PCI devices
 managed by non-PCI drivers
Date: Tue, 8 Sep 2015 11:27:35 -0500
Message-ID: <20150908162735.GK829@google.com>
References: <55EE8106.6060100@internode.on.net>
 <1441697190-27993-1-git-send-email-jiang.liu@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-pci-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1441697190-27993-1-git-send-email-jiang.liu@linux.intel.com>
Sender: linux-pci-owner@vger.kernel.org
To: Jiang Liu <jiang.liu@linux.intel.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Arthur Marsh <arthur.marsh@internode.on.net>, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org, linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Hi Jiang,

I object to subject lines like "Correctly do such and such."  Nobody
writes code to do things *incorrectly*, so the word "correctly" takes
up space without contributing meaning.  In this case, it's at least
debatable whether this is even the "correct" approach; see below.

On Tue, Sep 08, 2015 at 03:26:29PM +0800, Jiang Liu wrote:
> Commit 991de2e59090 ("PCI, x86: Implement pcibios_alloc_irq() and
> pcibios_free_irq()") changes the way to allocate PCI legacy IRQ
> for PCI devices on x86 platforms. Instead of allocating PCI legacy
> IRQs when pcibios_enable_device() gets called, now pcibios_alloc_irq()
> will be called by pci_device_probe() to allocate PCI legacy IRQs
> when binding PCI drivers to PCI devices.
> 
> But some device drivers, such as eata, directly access PCI devices
> without implementing corresponding PCI drivers, so pcibios_alloc_irq()
> won't be called for those PCI devices and wrong IRQ number may be
> used to manage the PCI device.

I'm not sure this is wise.  

We normally call pcibios_alloc_irq() from pci_device_probe(), just
before we call the driver's .probe() method.

The eata driver does not use pci_register_driver(), so there is no
.probe() method (also no .remove(), .suspend(), etc.)  But eata *does*
use pci_enable_device() and other PCI interfaces.  So this patch adds
code in the x86 pci_enable_device() path for this case.

AFAICT, there's no real reason why eata doesn't register a PCI driver;
it's just a case of legacy code where nobody has been motivated to
update it.  I'm not in favor of catering to code like that because
then we have random special cases like this that clutter up the core
code.

I don't think we should necessarily expect the PCI core to support
calls to PCI interfaces when it hasn't had a chance to initialize
itself via driver registration.

> So detect such a case in pcibios_enable_device() by checking
> pci_dev->driver is NULL and call pcibios_alloc_irq() to allocate PCI
> legacy IRQs.
> 
> Signed-off-by: Jiang Liu <jiang.liu@linux.intel.com>
> ---
>  arch/x86/pci/common.c |   10 ++++++++++
>  1 file changed, 10 insertions(+)
> 
> diff --git a/arch/x86/pci/common.c b/arch/x86/pci/common.c
> index 09d3afc0a181..60b237783582 100644
> --- a/arch/x86/pci/common.c
> +++ b/arch/x86/pci/common.c
> @@ -685,6 +685,16 @@ void pcibios_free_irq(struct pci_dev *dev)
>  
>  int pcibios_enable_device(struct pci_dev *dev, int mask)
>  {
> +	/*
> +	 * By design, pcibios_alloc_irq() will be called by pci_device_probe()
> +	 * when binding a PCI device to a PCI driver. But some device drivers,
> +	 * such as eata, directly make use of PCI devices without implementing
> +	 * PCI device drivers, so pcibios_alloc_irq() won't be called for those
> +	 * PCI devices.
> +	 */
> +	if (!dev->driver)
> +		pcibios_alloc_irq(dev);

This is a point fix for x86 only, but I think eata can be built for
any architecture.  Won't other architectures still have the same
problem?

>  	return pci_enable_resources(dev, mask);
>  }
>  
> -- 
> 1.7.10.4
> 
