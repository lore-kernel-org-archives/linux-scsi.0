From: Jeff Garzik <jeff@garzik.org>
Subject: Re: [PATCH] 3w-9xxx: use PCI resource length correctly
Date: Fri, 28 Sep 2007 10:50:34 -0400
Message-ID: <46FD14BA.7010508@garzik.org>
References: <20070928144556.GG4668@blackpad.ctb.virtua.com.br>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from srv5.dvmed.net ([207.36.208.214]:56300 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751145AbXI1Oui (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 28 Sep 2007 10:50:38 -0400
In-Reply-To: <20070928144556.GG4668@blackpad.ctb.virtua.com.br>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Eduardo Habkost <ehabkost@redhat.com>
Cc: linuxraid@amcc.com, linux-scsi@vger.kernel.org

Eduardo Habkost wrote:
> Trying to ioremap() a larger area than pci_resource_len()
> may fail (e.g. under Xen). Fixes 3w-9xxx to use pci_resource_len()
> as length parameter to ioremap() instead of PAGE_SIZE.
> 
> Signed-off-by: Eduardo Habkost <ehabkost@redhat.com>
> ---
>  drivers/scsi/3w-9xxx.c |   14 +++++++++-----
>  1 files changed, 9 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/scsi/3w-9xxx.c b/drivers/scsi/3w-9xxx.c
> index efd9d8d..885b340 100644
> --- a/drivers/scsi/3w-9xxx.c
> +++ b/drivers/scsi/3w-9xxx.c
> @@ -1999,7 +1999,8 @@ static int __devinit twa_probe(struct pci_dev *pdev, const struct pci_device_id
>  {
>  	struct Scsi_Host *host = NULL;
>  	TW_Device_Extension *tw_dev;
> -	u32 mem_addr;
> +	int bar;
> +	unsigned long mem_addr, mem_len;
>  	int retval = -ENODEV;
>  
>  	retval = pci_enable_device(pdev);
> @@ -2046,12 +2047,15 @@ static int __devinit twa_probe(struct pci_dev *pdev, const struct pci_device_id
>  	}
>  
>  	if (pdev->device == PCI_DEVICE_ID_3WARE_9000)
> -		mem_addr = pci_resource_start(pdev, 1);
> +		bar = 1;
>  	else
> -		mem_addr = pci_resource_start(pdev, 2);
> +		bar = 2;
> +
> +	mem_addr = pci_resource_start(pdev, bar);
> +	mem_len = pci_resource_len(pdev, bar);
>  
>  	/* Save base address */
> -	tw_dev->base_addr = ioremap(mem_addr, PAGE_SIZE);
> +	tw_dev->base_addr = ioremap(mem_addr, mem_len);

Have you verified that the hardware resource is always a reasonable size?

	Jeff



