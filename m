From: Brian King <brking@linux.vnet.ibm.com>
Subject: Re: [PATCH 1/2] ipr: add MSI support
Date: Fri, 23 Jan 2009 12:39:19 -0600
Message-ID: <497A0ED7.3000009@linux.vnet.ibm.com>
References: <20090123165823.748742817@linux.vnet.ibm.com> <4979FBAF.9050008@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e36.co.us.ibm.com ([32.97.110.154]:41670 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753730AbZAWSkd (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 23 Jan 2009 13:40:33 -0500
Received: from d03relay02.boulder.ibm.com (d03relay02.boulder.ibm.com [9.17.195.227])
	by e36.co.us.ibm.com (8.13.1/8.13.1) with ESMTP id n0NIdUPU014997
	for <linux-scsi@vger.kernel.org>; Fri, 23 Jan 2009 11:39:30 -0700
Received: from d03av03.boulder.ibm.com (d03av03.boulder.ibm.com [9.17.195.169])
	by d03relay02.boulder.ibm.com (8.13.8/8.13.8/NCO v9.1) with ESMTP id n0NIeW8c197300
	for <linux-scsi@vger.kernel.org>; Fri, 23 Jan 2009 11:40:32 -0700
Received: from d03av03.boulder.ibm.com (loopback [127.0.0.1])
	by d03av03.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id n0NIeW5F025490
	for <linux-scsi@vger.kernel.org>; Fri, 23 Jan 2009 11:40:32 -0700
In-Reply-To: <4979FBAF.9050008@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Wayne Boyer <wayneb@linux.vnet.ibm.com>
Cc: linux-scsi@vger.kernel.org

Acked by: Brian King <brking@linux.vnet.ibm.com>

Wayne Boyer wrote:
> Enable MSI if available/supported.
> 
> Signed-off-by: Wayne Boyer <wayneb@linux.vnet.ibm.com>
> ---
>  drivers/scsi/ipr.c |    7 +++++++
>  drivers/scsi/ipr.h |    4 ++--
>  2 files changed, 9 insertions(+), 2 deletions(-)
> 
> Index: linux-2.6/drivers/scsi/ipr.c
> ===================================================================
> --- linux-2.6.orig/drivers/scsi/ipr.c	2009-01-21 10:19:59.000000000 -0800
> +++ linux-2.6/drivers/scsi/ipr.c	2009-01-22 15:50:59.000000000 -0800
> @@ -7147,6 +7147,7 @@
> 
>  	ENTER;
>  	free_irq(pdev->irq, ioa_cfg);
> +	pci_disable_msi(pdev);
>  	iounmap(ioa_cfg->hdw_dma_regs);
>  	pci_release_regions(pdev);
>  	ipr_free_mem(ioa_cfg);
> @@ -7432,6 +7433,11 @@
>  		goto out;
>  	}
> 
> +	if (!(rc = pci_enable_msi(pdev)))
> +		dev_info(&pdev->dev, "MSI enabled\n");
> +	else if (ipr_debug)
> +		dev_info(&pdev->dev, "Cannot enable MSI\n");
> +
>  	dev_info(&pdev->dev, "Found IOA with IRQ: %d\n", pdev->irq);
> 
>  	host = scsi_host_alloc(&driver_template, sizeof(*ioa_cfg));
> @@ -7574,6 +7580,7 @@
>  out_scsi_host_put:
>  	scsi_host_put(host);
>  out_disable:
> +	pci_disable_msi(pdev);
>  	pci_disable_device(pdev);
>  	goto out;
>  }
> Index: linux-2.6/drivers/scsi/ipr.h
> ===================================================================
> --- linux-2.6.orig/drivers/scsi/ipr.h	2009-01-21 10:19:57.000000000 -0800
> +++ linux-2.6/drivers/scsi/ipr.h	2009-01-21 15:23:02.000000000 -0800
> @@ -37,8 +37,8 @@
>  /*
>   * Literals
>   */
> -#define IPR_DRIVER_VERSION "2.4.1"
> -#define IPR_DRIVER_DATE "(April 24, 2007)"
> +#define IPR_DRIVER_VERSION "2.4.2"
> +#define IPR_DRIVER_DATE "(January 21, 2009)"
> 
>  /*
>   * IPR_MAX_CMD_PER_LUN: This defines the maximum number of outstanding
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


-- 
Brian King
Linux on Power Virtualization
IBM Linux Technology Center


