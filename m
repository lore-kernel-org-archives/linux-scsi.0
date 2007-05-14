From: "Miller, Mike (OS Dev)" <Mike.Miller@hp.com>
Subject: RE: [PATCH] cciss: Fix pci_driver.shutdown while device is still active
Date: Mon, 14 May 2007 19:06:45 -0000
Message-ID: <226E1C65E4F6164E8EA5FD3CC913AE8C011FF0D8@G3W0639.americas.hpqcorp.net>
References: <20070514175301.GA19871@zante.sekrit.org>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ccerelbas02.cce.hp.com ([161.114.21.105]:50672 "EHLO
	ccerelbas02.cce.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757398AbXENTHH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 14 May 2007 15:07:07 -0400
Content-class: urn:content-classes:message
In-Reply-To: <20070514175301.GA19871@zante.sekrit.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Gerald Britton <gbritton@alum.mit.edu>, torvalds@linux-foundation.org, akpm@linux-foundation.org, ISS StorageDev <iss_storagedev@hp.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

 

> -----Original Message-----
> From: Gerald Britton [mailto:gbritton@alum.mit.edu] 
> Sent: Monday, May 14, 2007 12:53 PM
> To: torvalds@linux-foundation.org; akpm@linux-foundation.org; 
> Miller, Mike (OS Dev); ISS StorageDev; 
> linux-scsi@vger.kernel.org; linux-kernel@vger.kernel.org
> Subject: [PATCH] cciss: Fix pci_driver.shutdown while device 
> is still active
> 
> Fix an Oops in the cciss driver caused by system shutdown 
> while a filesystem on a cciss device is still active.  The 
> cciss_remove_one function only properly removes the device if 
> the device has been cleanly released by its users, which is 
> not the case when the pci_driver.shutdown method is called.

Please send the Oops output.

mikem

> 
> This patch adds a new cciss_shutdown function to better match 
> the pattern used by various SCSI drivers: deactivate device 
> interrupts and flush caches.
> It also alters the cciss_remove_one function to match and 
> readds the __devexit annotation that was removed when 
> cciss_remove_one was serving as the pci_driver.shutdown method.
> 
> Signed-off-by: Gerald Britton <gbritton@alum.mit.edu>
> ---
> diff --git a/drivers/block/cciss.c b/drivers/block/cciss.c 
> index 370dfe1..5acc6c4 100644
> --- a/drivers/block/cciss.c
> +++ b/drivers/block/cciss.c
> @@ -3469,13 +3469,39 @@ static int __devinit 
> cciss_init_one(struct pci_dev *pdev,
>  	return -1;
>  }
>  
> -static void cciss_remove_one(struct pci_dev *pdev)
> +static void cciss_shutdown(struct pci_dev *pdev)
>  {
>  	ctlr_info_t *tmp_ptr;
> -	int i, j;
> +	int i;
>  	char flush_buf[4];
>  	int return_code;
>  
> +	tmp_ptr = pci_get_drvdata(pdev);
> +	if (tmp_ptr == NULL)
> +		return;
> +	i = tmp_ptr->ctlr;
> +	if (hba[i] == NULL)
> +		return;
> +
> +	/* Turn board interrupts off  and send the flush cache 
> command */
> +	/* sendcmd will turn off interrupt, and send the flush...
> +	 * To write all data in the battery backed cache to disks */
> +	memset(flush_buf, 0, 4);
> +	return_code = sendcmd(CCISS_CACHE_FLUSH, i, flush_buf, 
> 4, 0, 0, 0, NULL,
> +			      TYPE_CMD);
> +	if (return_code == IO_OK) {
> +		printk(KERN_INFO "Completed flushing cache on 
> controller %d\n", i);
> +	} else {
> +		printk(KERN_WARNING "Error flushing cache on 
> controller %d\n", i);
> +	}
> +	free_irq(hba[i]->intr[2], hba[i]);
> +}
> +
> +static void __devexit cciss_remove_one(struct pci_dev *pdev) {
> +	ctlr_info_t *tmp_ptr;
> +	int i, j;
> +
>  	if (pci_get_drvdata(pdev) == NULL) {
>  		printk(KERN_ERR "cciss: Unable to remove device \n");
>  		return;
> @@ -3506,18 +3532,7 @@ static void cciss_remove_one(struct 
> pci_dev *pdev)
>  
>  	cciss_unregister_scsi(i);	/* unhook from SCSI subsystem */
>  
> -	/* Turn board interrupts off  and send the flush cache 
> command */
> -	/* sendcmd will turn off interrupt, and send the flush...
> -	 * To write all data in the battery backed cache to disks */
> -	memset(flush_buf, 0, 4);
> -	return_code = sendcmd(CCISS_CACHE_FLUSH, i, flush_buf, 
> 4, 0, 0, 0, NULL,
> -			      TYPE_CMD);
> -	if (return_code == IO_OK) {
> -		printk(KERN_INFO "Completed flushing cache on 
> controller %d\n", i);
> -	} else {
> -		printk(KERN_WARNING "Error flushing cache on 
> controller %d\n", i);
> -	}
> -	free_irq(hba[i]->intr[2], hba[i]);
> +	cciss_shutdown(pdev);
>  
>  #ifdef CONFIG_PCI_MSI
>  	if (hba[i]->msix_vector)
> @@ -3550,7 +3565,7 @@ static struct pci_driver cciss_pci_driver = {
>  	.probe = cciss_init_one,
>  	.remove = __devexit_p(cciss_remove_one),
>  	.id_table = cciss_pci_device_id,	/* id_table */
> -	.shutdown = cciss_remove_one,
> +	.shutdown = cciss_shutdown,
>  };
>  
>  /*
> 
