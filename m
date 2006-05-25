From: Vivek Goyal <vgoyal@in.ibm.com>
Subject: Re: [patch 20/20] kdump: mpt fusion driver initialization failure fix
Date: Thu, 25 May 2006 14:49:48 -0400
Message-ID: <20060525184948.GD18080@in.ibm.com>
References: <200604270934.k3R9YfsE025494@shell0.pdx.osdl.net>
Reply-To: vgoyal@in.ibm.com
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e5.ny.us.ibm.com ([32.97.182.145]:63894 "EHLO e5.ny.us.ibm.com")
	by vger.kernel.org with ESMTP id S1030321AbWEYSuQ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 25 May 2006 14:50:16 -0400
Received: from d01relay04.pok.ibm.com (d01relay04.pok.ibm.com [9.56.227.236])
	by e5.ny.us.ibm.com (8.12.11.20060308/8.12.11) with ESMTP id k4PIntQi031941
	for <linux-scsi@vger.kernel.org>; Thu, 25 May 2006 14:49:55 -0400
Received: from d01av02.pok.ibm.com (d01av02.pok.ibm.com [9.56.224.216])
	by d01relay04.pok.ibm.com (8.12.10/NCO/VER6.8) with ESMTP id k4PIntl5078928
	for <linux-scsi@vger.kernel.org>; Thu, 25 May 2006 14:49:55 -0400
Received: from d01av02.pok.ibm.com (loopback [127.0.0.1])
	by d01av02.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id k4PInsbG013863
	for <linux-scsi@vger.kernel.org>; Thu, 25 May 2006 14:49:55 -0400
Content-Disposition: inline
In-Reply-To: <200604270934.k3R9YfsE025494@shell0.pdx.osdl.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@steeleye.com
Cc: linux-scsi@vger.kernel.org, Eric.Moore@lsil.com, akpm@osdl.org

Hi James,

Are there any issues with this patch? Are you planning to push it to
Linus sometime?

Thanks
Vivek

On Thu, Apr 27, 2006 at 02:33:13AM -0700, akpm@osdl.org wrote:
> 
> From: Vivek Goyal <vgoyal@in.ibm.com>
> 
> MPT fusion driver initialization fails while second kernel is booting,
> after a system crash (if kdump kernel is configured).  Oops message is
> pasted below.  I have attached a patch to fix the issue.  Your suggestions
> are welcome.
> 
> *****************************************************************************
> Fusion MPT base driver 3.03.08
> Copyright (c) 1999-2005 LSI Logic Corporation
> Fusion MPT SAS Host driver 3.03.08 ACPI: PCI Interrupt 0000:01:00.0[A] -> Link [LNKA] -> GSI 5 (level, low) -> IRQ 5
> mptbase: Initiating ioc0 bringup
> BUG: unable to handle kernel paging request at virtual address 00002608
>  printing eip:
> c11782fd
> *pde = 00000000
> Oops: 0000 [#1]
> Modules linked in:
> CPU:    0
> EIP:    0060:[<c11782fd>]    Not tainted VLI
> EFLAGS: 00010046   (2.6.17-rc1-16M #2)
> EIP is at mptscsih_io_done+0x27/0x3a3
> eax: c4fed000   ebx: c4fed000   ecx: 00002600   edx: 00000298
> esi: c11782d6   edi: 00002600   ebp: 00000000   esp: c1332f74
> ds: 007b   es: 007b   ss: 0068
> Process swapper (pid: 0, threadinfo=c1332000 task=c128f9c0) Stack: <0>0000006c 00000020 00000298 00002600 c4fed000 c4fed000 c11782d6 0000260 0
>        00000000 c1172c49 c4fed000 c1305b40 00000005 00000000 c1172d75 c48877e0
>        c1029687 00000000 c1307fb8 00000000 c1305a00 00000001 00000000 c1307fb8
> Call Trace:
>  <c11782d6> mptscsih_io_done+0x0/0x3a3   <c1172c49> mpt_turbo_reply+0xbb/0xd3
>  <c1172d75> mpt_interrupt+0x22/0x2b   <c1029687> misrouted_irq+0x63/0xcb
>  <c10297b3> note_interrupt+0x43/0x98   <c10292f9> __do_IRQ+0x68/0x8f
>  <c1003fac> do_IRQ+0x36/0x4e
>  =======================
>  <c1002aa6> common_interrupt+0x1a/0x20   <c1001150> mwait_idle+0x1a/0x2a
>  <c10010bf> cpu_idle+0x40/0x5c   <c1308610> start_kernel+0x17a/0x17c Code: 5e 5f 5d c3 55 89 cd 57 56 53 83 ec 14 89 54 24 0c 89 44 24 10 8b 90 cc 00  00 00 8b 4c 24 0c 81 c2 98 02 00 00 85 ed 89 54 24 08 <0f> b7 79 08 89 fe 74 04  0f b7 75 08 66 39 f7 75 0d 8b 44 24 0c
> *******************************************************************************
> 
> o Kdump capture kernel boot fails during initialization of MPT fusion driver.
>   (LSI Logic / Symbios Logic SAS1064E PCI-Express Fusion-MPT SAS (rev 01))
> 
> o Problem is easily reproducible, if system crashed while some disk activity
>   like cp operation was going on.
> 
> o After a system crash, devices are not shutdown and capture kenrel starts
>   booting while skipping BIOS. Hence underlying device is left in operational
>   state. In this case scsi contoller was left with interrupt line asserted
>   reply FIFO was not empty. When driver starts initializing in the second
>   kernel, it receives the interrupt the moment request_irq() is called.
>   Interrupt handler, reads the message from reply FIFO and tries to access
>   the associated message frame and panics, as in the new kernel's context
>   that message frame is not valid at all.
> 
> o In this scenario, probably we should delay the request_irq() call. First
>   bring up the IOC, reset it if needed and then should register for irq.
> 
> o I have tested the patch with SAS1064E and 53c1030 controllers.
> 
> Signed-off-by: Vivek Goyal <vgoyal@in.ibm.com>
> Cc: "Moore, Eric Dean" <Eric.Moore@lsil.com>
> Signed-off-by: Andrew Morton <akpm@osdl.org>
> ---
> 
>  drivers/message/fusion/mptbase.c |   88 ++++++++++++++++-------------
>  1 files changed, 50 insertions(+), 38 deletions(-)
> 
> diff -puN drivers/message/fusion/mptbase.c~mpt-fusion-driver-initialization-failure-fix drivers/message/fusion/mptbase.c
> --- 25/drivers/message/fusion/mptbase.c~mpt-fusion-driver-initialization-failure-fix	Wed Apr 26 14:31:26 2006
> +++ 25-akpm/drivers/message/fusion/mptbase.c	Wed Apr 26 14:31:26 2006
> @@ -1386,39 +1386,6 @@ mpt_attach(struct pci_dev *pdev, const s
>  	/* Set lookup ptr. */
>  	list_add_tail(&ioc->list, &ioc_list);
>  
> -	ioc->pci_irq = -1;
> -	if (pdev->irq) {
> -		if (mpt_msi_enable && !pci_enable_msi(pdev))
> -			printk(MYIOC_s_INFO_FMT "PCI-MSI enabled\n", ioc->name);
> -
> -		r = request_irq(pdev->irq, mpt_interrupt, SA_SHIRQ, ioc->name, ioc);
> -
> -		if (r < 0) {
> -#ifndef __sparc__
> -			printk(MYIOC_s_ERR_FMT "Unable to allocate interrupt %d!\n",
> -					ioc->name, pdev->irq);
> -#else
> -			printk(MYIOC_s_ERR_FMT "Unable to allocate interrupt %s!\n",
> -					ioc->name, __irq_itoa(pdev->irq));
> -#endif
> -			list_del(&ioc->list);
> -			iounmap(mem);
> -			kfree(ioc);
> -			return -EBUSY;
> -		}
> -
> -		ioc->pci_irq = pdev->irq;
> -
> -		pci_set_master(pdev);			/* ?? */
> -		pci_set_drvdata(pdev, ioc);
> -
> -#ifndef __sparc__
> -		dprintk((KERN_INFO MYNAM ": %s installed at interrupt %d\n", ioc->name, pdev->irq));
> -#else
> -		dprintk((KERN_INFO MYNAM ": %s installed at interrupt %s\n", ioc->name, __irq_itoa(pdev->irq)));
> -#endif
> -	}
> -
>  	/* Check for "bound ports" (929, 929X, 1030, 1035) to reduce redundant resets.
>  	 */
>  	mpt_detect_bound_ports(ioc, pdev);
> @@ -1428,11 +1395,7 @@ mpt_attach(struct pci_dev *pdev, const s
>  		printk(KERN_WARNING MYNAM
>  		  ": WARNING - %s did not initialize properly! (%d)\n",
>  		  ioc->name, r);
> -
>  		list_del(&ioc->list);
> -		free_irq(ioc->pci_irq, ioc);
> -		if (mpt_msi_enable)
> -			pci_disable_msi(pdev);
>  		if (ioc->alt_ioc)
>  			ioc->alt_ioc->alt_ioc = NULL;
>  		iounmap(mem);
> @@ -1636,6 +1599,7 @@ mpt_do_ioc_recovery(MPT_ADAPTER *ioc, u3
>  	int	 handlers;
>  	int	 ret = 0;
>  	int	 reset_alt_ioc_active = 0;
> +	int	 irq_allocated = 0;
>  
>  	printk(KERN_INFO MYNAM ": Initiating %s %s\n",
>  			ioc->name, reason==MPT_HOSTEVENT_IOC_BRINGUP ? "bringup" : "recovery");
> @@ -1719,6 +1683,48 @@ mpt_do_ioc_recovery(MPT_ADAPTER *ioc, u3
>  		}
>  	}
>  
> +	/*
> +	 * Device is reset now. It must have de-asserted the interrupt line
> +	 * (if it was asserted) and it should be safe to register for the
> +	 * interrupt now.
> +	 */
> +	if ((ret == 0) && (reason == MPT_HOSTEVENT_IOC_BRINGUP)) {
> +		ioc->pci_irq = -1;
> +		if (ioc->pcidev->irq) {
> +			if (mpt_msi_enable && !pci_enable_msi(ioc->pcidev))
> +				printk(MYIOC_s_INFO_FMT "PCI-MSI enabled\n",
> +					ioc->name);
> +			rc = request_irq(ioc->pcidev->irq, mpt_interrupt,
> +					SA_SHIRQ, ioc->name, ioc);
> +			if (rc < 0) {
> +#ifndef __sparc__
> +				printk(MYIOC_s_ERR_FMT "Unable to allocate "
> +					"interrupt %d!\n", ioc->name,
> +					ioc->pcidev->irq);
> +#else
> +				printk(MYIOC_s_ERR_FMT "Unable to allocate "
> +					"interrupt %s!\n", ioc->name,
> +					__irq_itoa(ioc->pcidev->irq));
> +#endif
> +				if (mpt_msi_enable)
> +					pci_disable_msi(ioc->pcidev);
> +				return -EBUSY;
> +			}
> +			irq_allocated = 1;
> +			ioc->pci_irq = ioc->pcidev->irq;
> +			pci_set_master(ioc->pcidev);		/* ?? */
> +			pci_set_drvdata(ioc->pcidev, ioc);
> +#ifndef __sparc__
> +			dprintk((KERN_INFO MYNAM ": %s installed at interrupt "
> +				"%d\n", ioc->name, ioc->pcidev->irq));
> +#else
> +			dprintk((KERN_INFO MYNAM ": %s installed at interrupt "
> +				"%s\n", ioc->name,
> +				__irq_itoa(ioc->pcidev->irq)));
> +#endif
> +		}
> +	}
> +
>  	/* Prime reply & request queues!
>  	 * (mucho alloc's) Must be done prior to
>  	 * init as upper addresses are needed for init.
> @@ -1818,7 +1824,7 @@ mpt_do_ioc_recovery(MPT_ADAPTER *ioc, u3
>  				ret = mptbase_sas_persist_operation(ioc,
>  				    MPI_SAS_OP_CLEAR_NOT_PRESENT);
>  				if(ret != 0)
> -					return -1;
> +					goto out;
>  			}
>  
>  			/* Find IM volumes
> @@ -1899,6 +1905,12 @@ mpt_do_ioc_recovery(MPT_ADAPTER *ioc, u3
>  		/* FIXME?  Examine results here? */
>  	}
>  
> +out:
> +	if ((ret != 0) && irq_allocated) {
> +		free_irq(ioc->pci_irq, ioc);
> +		if (mpt_msi_enable)
> +			pci_disable_msi(ioc->pcidev);
> +	}
>  	return ret;
>  }
>  
> _
