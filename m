From: "Elliott, Robert (Server Storage)" <Elliott@hp.com>
Subject: RE: [RFC PATCH] Let device drivers disable msi on shutdown
Date: Tue, 24 Jun 2014 21:21:10 +0000
Message-ID: <94D0CD8314A33A4D9D801C0FE68B402958B4AD28@G9W0745.americas.hpqcorp.net>
References: <1403628537-16367-1-git-send-email-keith.busch@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g9t1613g.houston.hp.com ([15.240.0.71]:46291 "EHLO
	g9t1613g.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750985AbaFXVWx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 24 Jun 2014 17:22:53 -0400
In-Reply-To: <1403628537-16367-1-git-send-email-keith.busch@intel.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Keith Busch <keith.busch@intel.com>, "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Cc: Nagalakshmi Nandigama <Nagalakshmi.Nandigama@lsi.com>, Sreekanth Reddy <Sreekanth.Reddy@lsi.com>, Bjorn Helgaas <bhelgaas@google.com>



> -----Original Message-----
> From: linux-scsi-owner@vger.kernel.org [mailto:linux-scsi-
> owner@vger.kernel.org] On Behalf Of Keith Busch
> Sent: Tuesday, 24 June, 2014 11:49 AM
> To: linux-pci@vger.kernel.org; linux-scsi@vger.kernel.org
> Cc: Keith Busch; Nagalakshmi Nandigama; Sreekanth Reddy; Bjorn Helgaas
> Subject: [RFC PATCH] Let device drivers disable msi on shutdown
> 
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
> 
> To provide context why I want to do this asynchronously, NVM-Express has
> one PCI device per controller, of which there could be dozens in a system,
> and each one may take many seconds (I've heard over ten in some cases)
> to safely shutdown.
> 
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
> diff --git a/drivers/message/fusion/mptscsih.c
> b/drivers/message/fusion/mptscsih.c
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

1. That will cover the .shutdown function used by mptfc.c, mptspi.c, 
and mptscsih.c, but mptsas.c uses mptsas_shutdown rather than 
mptscsih_shutdown.  It doesn't call pci_disable_msi either.

2. mptscsih_suspend is another caller of mptscsih_shutdown
(although the latter does nothing right now).  This is done
before calling mpt_suspend, which writes to some chip registers 
to disable interrupts before calling pci_disable_msi.  Adding a 
pci_disable_msi call before those writes might not be safe.  

3. That mptscsih_suspend call chain will result in calling 
pci_disable_msi twice, which might trigger this in 
pci_disable_msi -> pci_msi_shutdown:
        BUG_ON(list_empty(&dev->msi_list));


---
Rob Elliott    HP Server Storage



