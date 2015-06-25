From: Tomas Henzl <thenzl@redhat.com>
Subject: Re: [Patch V2 3/9] [SCSI] aacraid: Enable MSI interrupt for series-6
 controller
Date: Thu, 25 Jun 2015 18:01:01 +0200
Message-ID: <558C25BD.4020205@redhat.com>
References: <1433986951-9033-1-git-send-email-rajinikanth.pandurangan@pmcs.com> <1433986951-9033-5-git-send-email-rajinikanth.pandurangan@pmcs.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:53493 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751241AbbFYQBF (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 25 Jun 2015 12:01:05 -0400
In-Reply-To: <1433986951-9033-5-git-send-email-rajinikanth.pandurangan@pmcs.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: rajinikanth.pandurangan@pmcs.com, jbottomley@parallels.com, linux-scsi@vger.kernel.org
Cc: aacraid@pmc-sierra.com, harry.yang@pmcs.com, mahesh.rajashekhara@pmcs.com, rich.bono@pmcs.com, achim.leubner@pmcs.com, murthy.bhat@pmcs.com

On 06/11/2015 03:42 AM, rajinikanth.pandurangan@pmcs.com wrote:
> From: Rajinikanth Pandurangan <rajinikanth.pandurangan@pmcs.com>
> 
> Description:
> 	Enable MSI interrupt mode for series-6 controller.
What seem problematic to me is that you still keep the module
option 'aac_msi' and a poor user might try
"IRQ handling. 0=PIC(default), 1=MSI, 2=MSI-X(unsupported, uses MSI)");
to manipulate the driver naturally withou any success.
Please either change the above description or add a new
option so it is not confusing.

Btw msi-x is now supported?

Cheers,
Tomas


> 
> Signed-off-by: Rajinikanth Pandurangan <rajinikanth.pandurangan@pmcs.com>
> ---
>  drivers/scsi/aacraid/src.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/scsi/aacraid/src.c b/drivers/scsi/aacraid/src.c
> index b147341..eb07b3d 100644
> --- a/drivers/scsi/aacraid/src.c
> +++ b/drivers/scsi/aacraid/src.c
> @@ -742,7 +742,7 @@ int aac_src_init(struct aac_dev *dev)
>  	if (dev->comm_interface != AAC_COMM_MESSAGE_TYPE1)
>  		goto error_iounmap;
>  
> -	dev->msi = aac_msi && !pci_enable_msi(dev->pdev);
> +	dev->msi = !pci_enable_msi(dev->pdev);
>  
>  	dev->aac_msix[0].vector_no = 0;
>  	dev->aac_msix[0].dev = dev;
> 

