From: Tomas Henzl <thenzl@redhat.com>
Subject: Re: [PATCH V3 10/10] [SCSI] aacraid: Replace pci_enable_msix() with
 pci_enable_msix_exact()
Date: Mon, 20 Jul 2015 17:53:56 +0200
Message-ID: <55AD1994.5040504@redhat.com>
References: <1436310984-4519-1-git-send-email-rajinikanth.pandurangan@pmcs.com>
 <1436310984-4519-11-git-send-email-rajinikanth.pandurangan@pmcs.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:38386 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754500AbbGTPx7 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 20 Jul 2015 11:53:59 -0400
In-Reply-To: <1436310984-4519-11-git-send-email-rajinikanth.pandurangan@pmcs.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: rajinikanth.pandurangan@pmcs.com, jbottomley@parallels.com, linux-scsi@vger.kernel.org
Cc: aacraid@pmc-sierra.com, harry.yang@pmcs.com, mahesh.rajashekhara@pmcs.com, rich.bono@pmcs.com, achim.leubner@pmcs.com, murthy.bhat@pmcs.com

On 8.7.2015 01:16, rajinikanth.pandurangan@pmcs.com wrote:
> From: Rajinikanth Pandurangan <rajinikanth.pandurangan@pmcs.com>
> 
> Description:
> 	As pci_enable_msix() deprecated, replaced with pci_enable_msix_exact()
> 
> Changes from V2:
>  Newly created for V3 based on review comment.
> 
> Signed-off-by: Rajinikanth Pandurangan <rajinikanth.pandurangan@pmcs.com>
> ---
>  drivers/scsi/aacraid/comminit.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)

> 
> diff --git a/drivers/scsi/aacraid/comminit.c b/drivers/scsi/aacraid/comminit.c
> index b4b6088..e4ff47e 100644
> --- a/drivers/scsi/aacraid/comminit.c
> +++ b/drivers/scsi/aacraid/comminit.c
> @@ -366,7 +366,7 @@ void aac_define_int_mode(struct aac_dev *dev)
>  
>  	if (msi_count > 1 &&
>  	    pci_find_capability(dev->pdev, PCI_CAP_ID_MSIX)) {
> -		i = pci_enable_msix(dev->pdev,
> +		i = pci_enable_msix_exact(dev->pdev,
>  				    dev->msixentry,
>  				    msi_count);
>  		 /* Check how many MSIX vectors are allocated */
> @@ -374,7 +374,7 @@ void aac_define_int_mode(struct aac_dev *dev)
>  			dev->msi_enabled = 1;
>  			if (i) {
Hi Rajinikanth,
the pci_enable_msix_exact is not a 1;1 replacement for pci_enable_msix,
you shouldn't use it this way - it never returns a positive value.
What you probably want is to use pci_enable_msix_range

Cheers,
Tomas

>  				msi_count = i;
> -				if (pci_enable_msix(dev->pdev,
> +				if (pci_enable_msix_exact(dev->pdev,
>  				    dev->msixentry,
>  				    msi_count)) {
>  					dev->msi_enabled = 0;
> 

