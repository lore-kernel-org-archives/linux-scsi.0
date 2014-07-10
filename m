From: Bjorn Helgaas <bhelgaas@google.com>
Subject: Re: [RFC PATCH] Let device drivers disable msi on shutdown
Date: Thu, 10 Jul 2014 12:38:40 -0600
Message-ID: <20140710183840.GA12663@google.com>
References: <1403628537-16367-1-git-send-email-keith.busch@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-pci-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1403628537-16367-1-git-send-email-keith.busch@intel.com>
Sender: linux-pci-owner@vger.kernel.org
To: Keith Busch <keith.busch@intel.com>
Cc: linux-pci@vger.kernel.org, linux-scsi@vger.kernel.org, Nagalakshmi Nandigama <Nagalakshmi.Nandigama@lsi.com>, Sreekanth Reddy <Sreekanth.Reddy@lsi.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

[+cc LKML, Greg KH for driver core async shutdown question]

On Tue, Jun 24, 2014 at 10:48:57AM -0600, Keith Busch wrote:
> I'd like to do shutdowns asynchronously so I can shutdown multiple
> devices in parallel, but the pci-driver disables interrupts after my
> driver returns from its '.shutdown', though it needs to rely on these
> interrupts in its asynchronously scheduled shutdown.
> 
> I tracked the reason for pci disabling msi to ...
> 
> | commit d52877c7b1afb8c37ebe17e2005040b79cb618b0
> | Author: Yinghai Lu <yhlu.kernel.send@gmail.com>
> | Date:   Wed Apr 23 14:58:09 2008 -0700
> |
> |     pci/irq: let pci_device_shutdown to call pci_msi_shutdown v2
> 
> ... because mptfusion doesn't disable msi in its shutdown path.
> 
> Any reason we can't let the drivers do this instead?

I guess they *could*, but my general idea is that when we can do
something in the core, we probably should, because then we're not
depending on all the drivers to do the right thing.  So I would turn
this around and say "we need a pretty good reason to move something
out of the core and into the drivers."

A lot of the issues in the shutdown path are related to getting the
device to shut up so it doesn't cause problems with kexec.  So it does
seem like a good idea to have pci_device_shutdown() disable MSI to
remove one source of bothersome interrupts.

> To provide context why I want to do this asynchronously, NVM-Express has
> one PCI device per controller, of which there could be dozens in a system,
> and each one may take many seconds (I've heard over ten in some cases)
> to safely shutdown.

I don't see anything in device_shutdown() that would wait for this
sort of asynchronous shutdown to complete.  So how do we know it's
finished before we turn off the power, reset, kexec, etc.?

If we need to do asynchronous shutdown, it seems like we need some
sort of driver core infrastructure to manage that.

> In this patch, mptfusion was compile tested only; I didn't observe any
> adverse affects from running the pci portion.
> 
> Signed-off-by: Keith Busch <keith.busch@intel.com>
> Cc: Nagalakshmi Nandigama <Nagalakshmi.Nandigama@lsi.com>
> Cc: Sreekanth Reddy <Sreekanth.Reddy@lsi.com>
> Cc: Bjorn Helgaas <bhelgaas@google.com>
> ---
>  drivers/message/fusion/mptscsih.c |    3 +++
>  drivers/pci/pci-driver.c          |    2 --
>  2 files changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/message/fusion/mptscsih.c b/drivers/message/fusion/mptscsih.c
> index 2a1c6f2..3186e17 100644
> --- a/drivers/message/fusion/mptscsih.c
> +++ b/drivers/message/fusion/mptscsih.c
> @@ -1215,6 +1215,9 @@ mptscsih_remove(struct pci_dev *pdev)
>  void
>  mptscsih_shutdown(struct pci_dev *pdev)
>  {
> +	MPT_ADAPTER *ioc = pci_get_drvdata(pdev);
> +	if (ioc->msi_enable)
> +		pci_disable_msi(pdev);
>  }
>  
>  #ifdef CONFIG_PM
> diff --git a/drivers/pci/pci-driver.c b/drivers/pci/pci-driver.c
> index 3f8e3db..8079d98 100644
> --- a/drivers/pci/pci-driver.c
> +++ b/drivers/pci/pci-driver.c
> @@ -453,8 +453,6 @@ static void pci_device_shutdown(struct device *dev)
>  
>  	if (drv && drv->shutdown)
>  		drv->shutdown(pci_dev);
> -	pci_msi_shutdown(pci_dev);
> -	pci_msix_shutdown(pci_dev);
>  
>  #ifdef CONFIG_KEXEC
>  	/*
> -- 
> 1.7.10.4
> 
