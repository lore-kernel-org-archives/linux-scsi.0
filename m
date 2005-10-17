From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 2/2] Convert megaraid to use pci_driver shutdown metho d
Date: Mon, 17 Oct 2005 14:42:28 +0100
Message-ID: <20051017134228.GA31938@infradead.org>
References: <0E3FA95632D6D047BA649F95DAB60E5707232141@exa-atlanta>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S932280AbVJQNmd@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <0E3FA95632D6D047BA649F95DAB60E5707232141@exa-atlanta>
Sender: linux-kernel-owner@vger.kernel.org
To: "Kolli, Neela Syam" <Neela.Kolli@engenio.com>
Cc: Russell King <rmk+lkml@arm.linux.org.uk>, Linux Kernel List <linux-kernel@vger.kernel.org>, Andrew Morton <akpm@osdl.org>, Greg KH <greg@kroah.com>, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Mon, Oct 17, 2005 at 09:26:12AM -0400, Kolli, Neela Syam wrote:
> Patch looks good.  Thanks for the patch.

another 2.6.14 candidate, without it we'd easily get corruption
on shutdown when the root filesystem is on megaraid.

> From: Russell King [mailto:rmk+lkml@arm.linux.org.uk] 
> Sent: Sunday, October 16, 2005 4:33 PM
> To: Linux Kernel List; Andrew Morton; Greg KH; Neela.Kolli@engenio.com
> Subject: Re: [PATCH 2/2] Convert megaraid to use pci_driver shutdown method
> 
> Convert megaraid to use pci_driver's shutdown method rather than
> the generic device_driver shutdown method.
> 
> Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>
> 
> diff --git a/drivers/scsi/megaraid/megaraid_mbox.c
> b/drivers/scsi/megaraid/megaraid_mbox.c
> --- a/drivers/scsi/megaraid/megaraid_mbox.c
> +++ b/drivers/scsi/megaraid/megaraid_mbox.c
> @@ -76,7 +76,7 @@ static void megaraid_exit(void);
>  
>  static int megaraid_probe_one(struct pci_dev*, const struct pci_device_id
> *);
>  static void megaraid_detach_one(struct pci_dev *);
> -static void megaraid_mbox_shutdown(struct device *);
> +static void megaraid_mbox_shutdown(struct pci_dev *);
>  
>  static int megaraid_io_attach(adapter_t *);
>  static void megaraid_io_detach(adapter_t *);
> @@ -369,9 +369,7 @@ static struct pci_driver megaraid_pci_dr
>  	.id_table	= pci_id_table_g,
>  	.probe		= megaraid_probe_one,
>  	.remove		= __devexit_p(megaraid_detach_one),
> -	.driver		= {
> -		.shutdown	= megaraid_mbox_shutdown,
> -	}
> +	.shutdown	= megaraid_mbox_shutdown,
>  };
>  
>  
> @@ -673,9 +671,9 @@ megaraid_detach_one(struct pci_dev *pdev
>   * Shutdown notification, perform flush cache
>   */
>  static void
> -megaraid_mbox_shutdown(struct device *device)
> +megaraid_mbox_shutdown(struct pci_dev *pdev)
>  {
> -	adapter_t		*adapter =
> pci_get_drvdata(to_pci_dev(device));
> +	adapter_t		*adapter = pci_get_drvdata(pdev);
>  	static int		counter;
>  
>  	if (!adapter) {
> 
