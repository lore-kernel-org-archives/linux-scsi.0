From: Domen Puncer <domen@coderock.org>
Subject: Re: [patch 06/11] drivers/scsi/aacraid/*: convert to pci_register_driver
Date: Tue, 15 Mar 2005 16:57:12 +0100
Message-ID: <20050315155712.GE3955@nd47.coderock.org>
References: <60807403EABEB443939A5A7AA8A7458BE5AF5F@otce2k01.adaptec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Received: from coderock.org ([193.77.147.115]:482 "EHLO trashy.coderock.org")
	by vger.kernel.org with ESMTP id S261344AbVCOP5W (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 15 Mar 2005 10:57:22 -0500
Content-Disposition: inline
In-Reply-To: <60807403EABEB443939A5A7AA8A7458BE5AF5F@otce2k01.adaptec.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Salyzyn, Mark" <mark_salyzyn@adaptec.com>
Cc: James.Bottomley@SteelEye.com, linux-scsi@vger.kernel.org, c.lucas@ifrance.com

On 15/03/05 08:38 -0500, Salyzyn, Mark wrote:
> I have to reject this change since pci_module_init() has a different
> return code than pci_register_driver().

pci.h: #define pci_module_init pci_register_driver

pci-driver.c: pci_register_driver:
	"Returns a negative value on error, otherwise 0."

So... since it can't return positive number, these conditions are the same.


> 
> The patch should look like:
> 
> -	error = pci_module_init(&aac_pci_driver);
> +	error = pci_register_driver(&aac_pci_driver);
> -	if (error)
> +	if (error < 0)
>  		return error;
> 
> Sincerely -- Mark Salyzyn
> 
> -----Original Message-----
> From: linux-scsi-owner@vger.kernel.org
> [mailto:linux-scsi-owner@vger.kernel.org] On Behalf Of
> domen@coderock.org
> Sent: Sunday, March 06, 2005 5:27 PM
> To: James.Bottomley@SteelEye.com
> Cc: linux-scsi@vger.kernel.org; domen@coderock.org; c.lucas@ifrance.com
> Subject: [patch 06/11] drivers/scsi/aacraid/*: convert to
> pci_register_driver
> 
> 
> convert from pci_module_init to pci_register_driver
> (from:http://kerneljanitors.org/TODO).
> 
> Signed-off-by: Christophe Lucas <c.lucas@ifrance.com>
> Signed-off-by: Domen Puncer <domen@coderock.org>
> ---
> 
> 
>  kj-domen/drivers/scsi/aacraid/linit.c |    2 +-
>  1 files changed, 1 insertion(+), 1 deletion(-)
> 
> diff -puN
> drivers/scsi/aacraid/linit.c~pci_register_driver-drivers_scsi_aacraid
> drivers/scsi/aacraid/linit.c
> ---
> kj/drivers/scsi/aacraid/linit.c~pci_register_driver-drivers_scsi_aacraid
> 2005-03-05 16:12:51.000000000 +0100
> +++ kj-domen/drivers/scsi/aacraid/linit.c	2005-03-05
> 16:12:51.000000000 +0100
> @@ -690,7 +690,7 @@ static int __init aac_init(void)
>  	printk(KERN_INFO "Red Hat/Adaptec aacraid driver (%s %s)\n",
>  			AAC_DRIVER_VERSION, AAC_DRIVER_BUILD_DATE);
>  
> -	error = pci_module_init(&aac_pci_driver);
> +	error = pci_register_driver(&aac_pci_driver);
>  	if (error)
>  		return error;
>  
> _
> -
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
