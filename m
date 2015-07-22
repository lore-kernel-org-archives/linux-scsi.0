From: Tomas Henzl <thenzl@redhat.com>
Subject: Re: [PATCH V4 10/10] [SCSI] aacraid: Replace pci_enable_msix() with
 pci_enable_msix_range()
Date: Wed, 22 Jul 2015 15:56:16 +0200
Message-ID: <55AFA100.7010708@redhat.com>
References: <1437501571-2475-1-git-send-email-rajinikanth.pandurangan@pmcs.com>
 <1437501571-2475-11-git-send-email-rajinikanth.pandurangan@pmcs.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:34400 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933478AbbGVN4U (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 22 Jul 2015 09:56:20 -0400
In-Reply-To: <1437501571-2475-11-git-send-email-rajinikanth.pandurangan@pmcs.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: rajinikanth.pandurangan@pmcs.com, jbottomley@parallels.com, linux-scsi@vger.kernel.org
Cc: aacraid@pmc-sierra.com, harry.yang@pmcs.com, rich.bono@pmcs.com, mahesh.rajashekhara@pmcs.com, achim.leubner@pmcs.com, murthy.bhat@pmcs.com

On 21.7.2015 19:59, rajinikanth.pandurangan@pmcs.com wrote:
> From: Rajinikanth Pandurangan <rajinikanth.pandurangan@pmcs.com>
> 
> Description:
>         As pci_enable_msix() deprecated, replaced with pci_enable_msix_range()
> 
> V3 Reviewed/commented by:
> 	Tomas Henzl <thenzl@redhat.com>
> 
> Changes from V3:
> 	Uses pci_enable_msix_range() instead of pci_enable_msix_exact()
> based on review comment.
> 
> Signed-off-by: Rajinikanth Pandurangan <rajinikanth.pandurangan@pmcs.com>
> ---
>  drivers/scsi/aacraid/comminit.c | 20 ++++++--------------
>  1 file changed, 6 insertions(+), 14 deletions(-)
> 
> diff --git a/drivers/scsi/aacraid/comminit.c b/drivers/scsi/aacraid/comminit.c
> index b4b6088..3ba6e97 100644
> --- a/drivers/scsi/aacraid/comminit.c
> +++ b/drivers/scsi/aacraid/comminit.c
> @@ -338,7 +338,7 @@ static int aac_comm_init(struct aac_dev * dev)
>  
>  void aac_define_int_mode(struct aac_dev *dev)
>  {
> -	int i, msi_count;
> +	int i, msi_count, min_msix;
>  
>  	msi_count = i = 0;
>  	/* max. vectors from GET_COMM_PREFERRED_SETTINGS */
> @@ -366,22 +366,14 @@ void aac_define_int_mode(struct aac_dev *dev)
>  
>  	if (msi_count > 1 &&
>  	    pci_find_capability(dev->pdev, PCI_CAP_ID_MSIX)) {
> -		i = pci_enable_msix(dev->pdev,
> +		min_msix = 8;
That^ will make the pci-enable function fail on boxes with less than
eight num-online-cpus

-tm

> +		i = pci_enable_msix_range(dev->pdev,
>  				    dev->msixentry,
> +				    min_msix,
>  				    msi_count);
> -		 /* Check how many MSIX vectors are allocated */
> -		if (i >= 0) {
> +		if (i > 0) {
>  			dev->msi_enabled = 1;
> -			if (i) {
> -				msi_count = i;
> -				if (pci_enable_msix(dev->pdev,
> -				    dev->msixentry,
> -				    msi_count)) {
> -					dev->msi_enabled = 0;
> -					printk(KERN_ERR "%s%d: MSIX not supported!! Will try MSI 0x%x.\n",
> -							dev->name, dev->id, i);
> -				}
> -			}
> +			msi_count = i;
>  		} else {
>  			dev->msi_enabled = 0;
>  			printk(KERN_ERR "%s%d: MSIX not supported!! Will try MSI 0x%x.\n",
> 

