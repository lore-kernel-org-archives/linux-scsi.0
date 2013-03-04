From: "Desai, Kashyap" <Kashyap.Desai@lsi.com>
Subject: RE: [PATCH 1/2] mptfusion, mpt2sas, mpt3sas: Don't remove dead IOC
 PCI device
Date: Mon, 4 Mar 2013 23:32:42 +0530
Message-ID: <B2FD678A64EAAD45B089B123FDFC3ED75E690FE449@inbmail01.lsi.com>
References: <alpine.DEB.2.02.1303041046230.1736@jlaw-desktop.mno.stratus.com>
 <alpine.DEB.2.02.1303041052420.1736@jlaw-desktop.mno.stratus.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from tx2ehsobe005.messaging.microsoft.com ([65.55.88.15]:21026 "EHLO
	tx2outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758158Ab3CDSC4 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 4 Mar 2013 13:02:56 -0500
In-Reply-To: <alpine.DEB.2.02.1303041052420.1736@jlaw-desktop.mno.stratus.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Joe Lawrence <Joe.Lawrence@stratus.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Cc: DL-MPT Fusion Linux <DL-MPTFusionLinux@lsi.com>, Support <support@lsi.com>, "Reddy, Sreekanth" <Sreekanth.Reddy@lsi.com>, "Nandigama, Nagalakshmi" <Nagalakshmi.Nandigama@lsi.com>, "James E.J. Bottomley" <JBottomley@parallels.com>, Bjorn Helgaas <bhelgaas@google.com>



> -----Original Message-----
> From: linux-scsi-owner@vger.kernel.org [mailto:linux-scsi-
> owner@vger.kernel.org] On Behalf Of Joe Lawrence
> Sent: Monday, March 04, 2013 9:26 PM
> To: linux-scsi@vger.kernel.org
> Cc: DL-MPT Fusion Linux; Support; Reddy, Sreekanth; Nandigama,
> Nagalakshmi; James E.J. Bottomley; Bjorn Helgaas
> Subject: [PATCH 1/2] mptfusion, mpt2sas, mpt3sas: Don't remove dead IOC
> PCI device
> 
> Device removal/addition is a PCI core function, not an HBA function.
> Calling pci_stop_and_remove_bus_device() from a SCSI LLD may introduce
> device removal races with PCI hotplug.  Remove these calls from
> mptfusion, mpt2sas, and mpt3sas, but leave remaining dead IOC code in
> place that flushes outstanding commands and sets IOC state.

Joe: I agree that only mptsas/mpt2sas/mpt3sas is calling " pci_stop_and_remove_bus_device" from LLD. If through sysfs we can hot add/remove the device, It would be OK to allow similar simulation from LLD. (In case it is really require.) I agree that calling " pci_stop_and_remove_bus_device" is PCI subsystem's responsibility. 
Please consider that finding bad IOC on field is very rare. 


In our case, user wants BAD IOC to be detected immediately (due to performance and mission critical IOs) and it should be removed from the topology ASAP to allow other good IOC and connected topology to work well.

With the new proposed change you posted with this patch half of the problem still do not resolve.

 Driver set ioc->remove_host = 1 when bad IOC is detected, but IOs to the connected topology will still continue to flood ( if we do not detach bad IOC from topology) and Scsi Mid layer be busy sending inactive IOs to the bad IOC, and IOs will be return to the OS with "DID_NO_CONNECT".

So finally to release the topology from BAD IOC from OS is also equally important. This can be achieved either calling ".remove" entry point or what currently driver is doing "remove the IOC from PCI layer which will allow better cleanup.

In summary, I do not ACK this patch due to practical reason where customers are expecting above mentioned behavior on field.

Thanks, Kashyap

> 
> Signed-off-by: Joe Lawrence <joe.lawrence@stratus.com>
> Cc: Bjorn Helgaas <bhelgaas@google.com>
> Cc: James E.J. Bottomley <JBottomley@parallels.com>
> Cc: Nagalakshmi Nandigama <Nagalakshmi.Nandigama@lsi.com>
> Cc: Sreekanth Reddy <Sreekanth.Reddy@lsi.com>
> Cc: support@lsi.com
> Cc: DL-MPTFusionLinux@lsi.com
> Cc: linux-scsi@vger.kernel.org
> ---
>  drivers/message/fusion/mptbase.c    | 41 +-----------------------------
> ------
>  drivers/scsi/mpt2sas/mpt2sas_base.c | 42 ++----------------------------
> -------
>  drivers/scsi/mpt3sas/mpt3sas_base.c | 40 ++----------------------------
> -----
>  3 files changed, 5 insertions(+), 118 deletions(-)
> 
> diff --git a/drivers/message/fusion/mptbase.c
> b/drivers/message/fusion/mptbase.c
> index fb69baa..28a421d 100644
> --- a/drivers/message/fusion/mptbase.c
> +++ b/drivers/message/fusion/mptbase.c
> @@ -63,7 +63,6 @@
>  #ifdef CONFIG_MTRR
>  #include <asm/mtrr.h>
>  #endif
> -#include <linux/kthread.h>
>  #include <scsi/scsi_host.h>
> 
>  #include "mptbase.h"
> @@ -328,31 +327,6 @@ mpt_is_discovery_complete(MPT_ADAPTER *ioc)
> 
> 
>  /**
> - *  mpt_remove_dead_ioc_func - kthread context to remove dead ioc
> - * @arg: input argument, used to derive ioc
> - *
> - * Return 0 if controller is removed from pci subsystem.
> - * Return -1 for other case.
> - */
> -static int mpt_remove_dead_ioc_func(void *arg) -{
> -	MPT_ADAPTER *ioc = (MPT_ADAPTER *)arg;
> -	struct pci_dev *pdev;
> -
> -	if ((ioc == NULL))
> -		return -1;
> -
> -	pdev = ioc->pcidev;
> -	if ((pdev == NULL))
> -		return -1;
> -
> -	pci_stop_and_remove_bus_device(pdev);
> -	return 0;
> -}
> -
> -
> -
> -/**
>   *	mpt_fault_reset_work - work performed on workq after ioc fault
>   *	@work: input argument, used to derive ioc
>   *
> @@ -366,7 +340,6 @@ mpt_fault_reset_work(struct work_struct *work)
>  	int		 rc;
>  	unsigned long	 flags;
>  	MPT_SCSI_HOST	*hd;
> -	struct task_struct *p;
> 
>  	if (ioc->ioc_reset_in_progress || !ioc->active)
>  		goto out;
> @@ -380,25 +353,13 @@ mpt_fault_reset_work(struct work_struct *work)
>  		/*
>  		 * Call mptscsih_flush_pending_cmds callback so that we
>  		 * flush all pending commands back to OS.
> -		 * This call is required to aovid deadlock at block layer.
> +		 * This call is required to avoid deadlock at block layer.
>  		 * Dead IOC will fail to do diag reset,and this call is safe
>  		 * since dead ioc will never return any command back from
> HW.
>  		 */
>  		hd = shost_priv(ioc->sh);
>  		ioc->schedule_dead_ioc_flush_running_cmds(hd);
> 
> -		/*Remove the Dead Host */
> -		p = kthread_run(mpt_remove_dead_ioc_func, ioc,
> -				"mpt_dead_ioc_%d", ioc->id);
> -		if (IS_ERR(p))	{
> -			printk(MYIOC_s_ERR_FMT
> -				"%s: Running mpt_dead_ioc thread failed !\n",
> -				ioc->name, __func__);
> -		} else {
> -			printk(MYIOC_s_WARN_FMT
> -				"%s: Running mpt_dead_ioc thread success !\n",
> -				ioc->name, __func__);
> -		}
>  		return; /* don't rearm timer */
>  	}
> 
> diff --git a/drivers/scsi/mpt2sas/mpt2sas_base.c
> b/drivers/scsi/mpt2sas/mpt2sas_base.c
> index ffd85c5..a97d10c 100644
> --- a/drivers/scsi/mpt2sas/mpt2sas_base.c
> +++ b/drivers/scsi/mpt2sas/mpt2sas_base.c
> @@ -57,7 +57,6 @@
>  #include <linux/sort.h>
>  #include <linux/io.h>
>  #include <linux/time.h>
> -#include <linux/kthread.h>
>  #include <linux/aer.h>
> 
>  #include "mpt2sas_base.h"
> @@ -115,29 +114,6 @@ module_param_call(mpt2sas_fwfault_debug,
> _scsih_set_fwfault_debug,
>      param_get_int, &mpt2sas_fwfault_debug, 0644);
> 
>  /**
> - *  mpt2sas_remove_dead_ioc_func - kthread context to remove dead ioc
> - * @arg: input argument, used to derive ioc
> - *
> - * Return 0 if controller is removed from pci subsystem.
> - * Return -1 for other case.
> - */
> -static int mpt2sas_remove_dead_ioc_func(void *arg) -{
> -		struct MPT2SAS_ADAPTER *ioc = (struct MPT2SAS_ADAPTER *)arg;
> -		struct pci_dev *pdev;
> -
> -		if ((ioc == NULL))
> -			return -1;
> -
> -		pdev = ioc->pdev;
> -		if ((pdev == NULL))
> -			return -1;
> -		pci_stop_and_remove_bus_device(pdev);
> -		return 0;
> -}
> -
> -
> -/**
>   * _base_fault_reset_work - workq handling ioc fault conditions
>   * @work: input argument, used to derive ioc
>   * Context: sleep.
> @@ -152,7 +128,6 @@ _base_fault_reset_work(struct work_struct *work)
>  	unsigned long	 flags;
>  	u32 doorbell;
>  	int rc;
> -	struct task_struct *p;
> 
>  	spin_lock_irqsave(&ioc->ioc_reset_in_progress_lock, flags);
>  	if (ioc->shost_recovery)
> @@ -166,29 +141,16 @@ _base_fault_reset_work(struct work_struct *work)
> 
>  		/*
>  		 * Call _scsih_flush_pending_cmds callback so that we flush
> all
> -		 * pending commands back to OS. This call is required to
> aovid
> +		 * pending commands back to OS. This call is required to
> avoid
>  		 * deadlock at block layer. Dead IOC will fail to do diag
> reset,
>  		 * and this call is safe since dead ioc will never return
> any
>  		 * command back from HW.
>  		 */
>  		ioc->schedule_dead_ioc_flush_running_cmds(ioc);
>  		/*
> -		 * Set remove_host flag early since kernel thread will
> -		 * take some time to execute.
> +		 * Indicate to scsi callbacks that the host has been
> removed.
>  		 */
>  		ioc->remove_host = 1;
> -		/*Remove the Dead Host */
> -		p = kthread_run(mpt2sas_remove_dead_ioc_func, ioc,
> -		    "mpt2sas_dead_ioc_%d", ioc->id);
> -		if (IS_ERR(p)) {
> -			printk(MPT2SAS_ERR_FMT
> -			"%s: Running mpt2sas_dead_ioc thread failed !!!!\n",
> -			ioc->name, __func__);
> -		} else {
> -		    printk(MPT2SAS_ERR_FMT
> -			"%s: Running mpt2sas_dead_ioc thread success !!!!\n",
> -			ioc->name, __func__);
> -		}
> 
>  		return; /* don't rearm timer */
>  	}
> diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.c
> b/drivers/scsi/mpt3sas/mpt3sas_base.c
> index 04f8010..24fd122 100644
> --- a/drivers/scsi/mpt3sas/mpt3sas_base.c
> +++ b/drivers/scsi/mpt3sas/mpt3sas_base.c
> @@ -57,7 +57,6 @@
>  #include <linux/dma-mapping.h>
>  #include <linux/io.h>
>  #include <linux/time.h>
> -#include <linux/kthread.h>
>  #include <linux/aer.h>
> 
> 
> @@ -111,28 +110,6 @@ module_param_call(mpt3sas_fwfault_debug,
> _scsih_set_fwfault_debug,
>  	param_get_int, &mpt3sas_fwfault_debug, 0644);
> 
>  /**
> - *  mpt3sas_remove_dead_ioc_func - kthread context to remove dead ioc
> - * @arg: input argument, used to derive ioc
> - *
> - * Return 0 if controller is removed from pci subsystem.
> - * Return -1 for other case.
> - */
> -static int mpt3sas_remove_dead_ioc_func(void *arg) -{
> -	struct MPT3SAS_ADAPTER *ioc = (struct MPT3SAS_ADAPTER *)arg;
> -	struct pci_dev *pdev;
> -
> -	if ((ioc == NULL))
> -		return -1;
> -
> -	pdev = ioc->pdev;
> -	if ((pdev == NULL))
> -		return -1;
> -	pci_stop_and_remove_bus_device(pdev);
> -	return 0;
> -}
> -
> -/**
>   * _base_fault_reset_work - workq handling ioc fault conditions
>   * @work: input argument, used to derive ioc
>   * Context: sleep.
> @@ -147,7 +124,6 @@ _base_fault_reset_work(struct work_struct *work)
>  	unsigned long	 flags;
>  	u32 doorbell;
>  	int rc;
> -	struct task_struct *p;
> 
> 
>  	spin_lock_irqsave(&ioc->ioc_reset_in_progress_lock, flags); @@ -
> 162,28 +138,16 @@ _base_fault_reset_work(struct work_struct *work)
> 
>  		/*
>  		 * Call _scsih_flush_pending_cmds callback so that we flush
> all
> -		 * pending commands back to OS. This call is required to
> aovid
> +		 * pending commands back to OS. This call is required to
> avoid
>  		 * deadlock at block layer. Dead IOC will fail to do diag
> reset,
>  		 * and this call is safe since dead ioc will never return
> any
>  		 * command back from HW.
>  		 */
>  		ioc->schedule_dead_ioc_flush_running_cmds(ioc);
>  		/*
> -		 * Set remove_host flag early since kernel thread will
> -		 * take some time to execute.
> +		 * Indicate to scsi callbacks that the host has been
> removed.
>  		 */
>  		ioc->remove_host = 1;
> -		/*Remove the Dead Host */
> -		p = kthread_run(mpt3sas_remove_dead_ioc_func, ioc,
> -		    "mpt3sas_dead_ioc_%d", ioc->id);
> -		if (IS_ERR(p))
> -			pr_err(MPT3SAS_FMT
> -			"%s: Running mpt3sas_dead_ioc thread failed !!!!\n",
> -			ioc->name, __func__);
> -		else
> -			pr_err(MPT3SAS_FMT
> -			"%s: Running mpt3sas_dead_ioc thread success !!!!\n",
> -			ioc->name, __func__);
>  		return; /* don't rearm timer */
>  	}
> 
> --
> 1.8.1.2
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org More majordomo info
> at  http://vger.kernel.org/majordomo-info.html

