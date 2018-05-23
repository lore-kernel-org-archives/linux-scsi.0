From: Bjorn Helgaas <helgaas@kernel.org>
Subject: Re: [PATCH V2] PCI/portdrv: do not disable device on reboot/shutdown
Date: Wed, 23 May 2018 16:32:49 -0500
Message-ID: <20180523213249.GD150632@bhelgaas-glaptop.roam.corp.google.com>
References: <1527043490-17268-1-git-send-email-okaya@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <stable-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1527043490-17268-1-git-send-email-okaya@codeaurora.org>
Sender: stable-owner@vger.kernel.org
To: Sinan Kaya <okaya@codeaurora.org>
Cc: linux-pci@vger.kernel.org, timur@codeaurora.org, ryan@finnie.org, linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, stable@vger.kernel.org, Bjorn Helgaas <bhelgaas@google.com>, "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Thomas Gleixner <tglx@linutronix.de>, Kate Stewart <kstewart@linuxfoundation.org>, Frederick Lawler <fred@fredlawl.com>, Dongdong Liu <liudongdong3@huawei.com>, Mika Westerberg <mika.westerberg@linux.intel.com>, open list <linux-kernel@vger.kernel.org>, Don Brace <don.brace@microsemi.com>, esc.storagedev@microsemi.com, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

[-cc Gabriele (invalid email address)]
[+cc Don, esc.storagedev, linux-scsi since hpsa is involved]

Background for newcomers:

  Ryan reported a panic on shutdown/reboot [1] on DL360 Gen9.  I think
  the problem is that the shutdown path clears PCI_COMMAND_MASTER on
  the Root Port leading to an hpsa device, the hpsa device attempts a
  DMA, the Root Port treats the DMA as an Unsupported Request (a fatal
  error), and that leads to a panic.

  This patch avoids the problem by changing the Root Port shutdown
  path so it doesn't clear PCI_COMMAND_MASTER.

  [1] https://bugzilla.kernel.org/show_bug.cgi?id=199779

On Tue, May 22, 2018 at 10:44:46PM -0400, Sinan Kaya wrote:
> 'Commit cc27b735ad3a ("PCI/portdrv: Turn off PCIe services during
> shutdown")' has been added to kernel to shutdown pending PCIe port
> service interrupts during reboot so that a newly started kexec kernel
> wouldn't observe pending interrupts.
> 
> pcie_port_device_remove() is disabling the root port and switches by
> calling pci_disable_device() after all PCIe service drivers are shutdown.

It's interesting and annoying that pci_enable_device() and
pci_disable_device() sound like they should be inverses, or at least
related, but they really aren't.

pci_enable_device() basically turns on PCI_COMMAND_MEMORY and/or
PCI_COMMAND_IO so the device will respond to programmed I/O.  But
pci_disable_device() leaves programmed I/O enabled and turns off
PCI_COMMAND_MASTER, which keeps the device from performing DMA or
forwarding transactions upstream (in the case of bridges).

Not an issue for this patch, just an observation :)

> pci_disable_device() has a much wider impact then port service itself and
> it prevents all inbound transactions to reach to the system and impacts
> the entire PCI traffic behind the bridge.
> 
> Issue is that pcie_port_device_remove() doesn't maintain any coordination
> with the rest of the PCI device drivers in the system before clearing the
> bus master bit.

I am interested in this part because if there really isn't any
coordination, that's a good argument for getting rid of portdrv, which
I want to do anyway.  But I haven't dug into this enough to verify it.

The portdrv does register as a regular PCI driver (pcie_portdriver),
and I'm pretty sure the driver core is smart enough to call the driver
entry points in a postorder traversal (children before parents), which
means the hpsa .shutdown() should be called before the portdrv
.shutdown().

The crash seems to indicate that the hpsa device attempted a DMA after
we cleared the Root Port's PCI_COMMAND_MASTER, which means
hpsa_shutdown() didn't stop DMA from the device (it looks like *most*
shutdown methods don't disable device DMA, so it's in good company).

> This has been found to cause crashes on HP DL360 Gen9 machines during
> reboot. Besides, kexec is already clearing the bus master bit in
> pci_device_shutdown() after all PCI drivers are removed.

The original path was:

  pci_device_shutdown(hpsa)
    drv->shutdown
      hpsa_shutdown                     # hpsa_pci_driver.shutdown
  ...
  pci_device_shutdown(RP)               # root port
    drv->shutdown
      pcie_portdrv_remove               # pcie_portdriver.shutdown
        pcie_port_device_remove
          pci_disable_device
            do_pci_disable_device
              # clear RP PCI_COMMAND_MASTER
    if (kexec)
      pci_clear_master(RP)
        # clear RP PCI_COMMAND_MASTER

If I understand correctly, the new path after this patch is:

  pci_device_shutdown(hpsa)
    drv->shutdown
      hpsa_shutdown                     # hpsa_pci_driver.shutdown
  ...
  pci_device_shutdown(RP)               # root port
    drv->shutdown
      pcie_portdrv_shutdown             # pcie_portdriver.shutdown
        __pcie_portdrv_remove(RP, false)
          pcie_port_device_remove(RP, false)
            # do NOT clear RP PCI_COMMAND_MASTER
    if (kexec)
      pci_clear_master(RP)
        # clear RP PCI_COMMAND_MASTER

I guess this patch avoids the panic during reboot because we're not in
the kexec path, so we never clear PCI_COMMAND_MASTER for the Root
Port, so the hpsa device can DMA happily until the lights go out.

But DMA continuing for some random amount of time before the reboot or
shutdown happens makes me a little queasy.  That doesn't sound safe.
The more I think about this, the more confused I get.  What am I
missing?  

> Just remove the extra clear in shutdown path by seperating the remove and
> shutdown APIs in the PORTDRV.
> 
> Signed-off-by: Sinan Kaya <okaya@codeaurora.org>
> Link: https://bugzilla.kernel.org/show_bug.cgi?id=199779
> Fixes: cc27b735ad3a ("PCI/portdrv: Turn off PCIe services during shutdown")
> Cc: stable@vger.kernel.org
> Reported-by: Ryan Finnie <ryan@finnie.org>
> ---
>  drivers/pci/pcie/portdrv.h      |  2 +-
>  drivers/pci/pcie/portdrv_core.c |  5 +++--
>  drivers/pci/pcie/portdrv_pci.c  | 16 +++++++++++++---
>  3 files changed, 17 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/pci/pcie/portdrv.h b/drivers/pci/pcie/portdrv.h
> index d0c6783..f6e88fe 100644
> --- a/drivers/pci/pcie/portdrv.h
> +++ b/drivers/pci/pcie/portdrv.h
> @@ -86,7 +86,7 @@ int pcie_port_device_register(struct pci_dev *dev);
>  int pcie_port_device_suspend(struct device *dev);
>  int pcie_port_device_resume(struct device *dev);
>  #endif
> -void pcie_port_device_remove(struct pci_dev *dev);
> +void pcie_port_device_remove(struct pci_dev *dev, bool disable);
>  int __must_check pcie_port_bus_register(void);
>  void pcie_port_bus_unregister(void);
>  
> diff --git a/drivers/pci/pcie/portdrv_core.c b/drivers/pci/pcie/portdrv_core.c
> index c9c0663..f35341e 100644
> --- a/drivers/pci/pcie/portdrv_core.c
> +++ b/drivers/pci/pcie/portdrv_core.c
> @@ -405,11 +405,12 @@ static int remove_iter(struct device *dev, void *data)
>   * Remove PCI Express port service devices associated with given port and
>   * disable MSI-X or MSI for the port.
>   */
> -void pcie_port_device_remove(struct pci_dev *dev)
> +void pcie_port_device_remove(struct pci_dev *dev, bool disable)
>  {
>  	device_for_each_child(&dev->dev, NULL, remove_iter);
>  	pci_free_irq_vectors(dev);
> -	pci_disable_device(dev);
> +	if (disable)
> +		pci_disable_device(dev);
>  }
>  
>  /**
> diff --git a/drivers/pci/pcie/portdrv_pci.c b/drivers/pci/pcie/portdrv_pci.c
> index 973f1b8..29afaf3 100644
> --- a/drivers/pci/pcie/portdrv_pci.c
> +++ b/drivers/pci/pcie/portdrv_pci.c
> @@ -137,7 +137,7 @@ static int pcie_portdrv_probe(struct pci_dev *dev,
>  	return 0;
>  }
>  
> -static void pcie_portdrv_remove(struct pci_dev *dev)
> +static void __pcie_portdrv_remove(struct pci_dev *dev, bool disable)
>  {
>  	if (pci_bridge_d3_possible(dev)) {
>  		pm_runtime_forbid(&dev->dev);
> @@ -145,7 +145,17 @@ static void pcie_portdrv_remove(struct pci_dev *dev)
>  		pm_runtime_dont_use_autosuspend(&dev->dev);
>  	}
>  
> -	pcie_port_device_remove(dev);
> +	pcie_port_device_remove(dev, disable);
> +}
> +
> +static void pcie_portdrv_remove(struct pci_dev *dev)
> +{
> +	return __pcie_portdrv_remove(dev, true);
> +}
> +
> +static void pcie_portdrv_shutdown(struct pci_dev *dev)
> +{
> +	return __pcie_portdrv_remove(dev, false);
>  }
>  
>  static pci_ers_result_t pcie_portdrv_error_detected(struct pci_dev *dev,
> @@ -218,7 +228,7 @@ static struct pci_driver pcie_portdriver = {
>  
>  	.probe		= pcie_portdrv_probe,
>  	.remove		= pcie_portdrv_remove,
> -	.shutdown	= pcie_portdrv_remove,
> +	.shutdown	= pcie_portdrv_shutdown,

What are the circumstances when we call .remove() vs .shutdown()?

I guess the main (maybe only) way to call .remove() is to hot-remove
the port?  And .shutdown() is basically used in the reboot and kexec
paths?

>  	.err_handler	= &pcie_portdrv_err_handler,
>  
> -- 
> 2.7.4
> 
