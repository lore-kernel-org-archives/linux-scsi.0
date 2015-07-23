From: Rajinikanth Pandurangan <Rajinikanth.Pandurangan@pmcs.com>
Subject: RE: [PATCH V5 10/11] [SCSI] aacraid: Replace pci_enable_msix() with
 pci_enable_msix_range()
Date: Thu, 23 Jul 2015 13:52:26 +0000
Message-ID: <E34C6B6293F0214497D0C55B92526C05EAFF844A@BBYEXM02.pmc-sierra.internal>
References: <1437583757-5449-1-git-send-email-rajinikanth.pandurangan@pmcs.com>
 <1437583757-5449-11-git-send-email-rajinikanth.pandurangan@pmcs.com>
 <55B0E3F6.5040808@redhat.com>
 <7000_1437658952_55B0EF48_7000_4689_1_E34C6B6293F0214497D0C55B92526C05EAFF8421@BBYEXM02.pmc-sierra.internal>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bby1mta03.pmc-sierra.com ([216.241.235.118]:34861 "EHLO
	bby1mta03.pmc-sierra.bc.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751457AbbGWNw2 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 23 Jul 2015 09:52:28 -0400
In-Reply-To: <7000_1437658952_55B0EF48_7000_4689_1_E34C6B6293F0214497D0C55B92526C05EAFF8421@BBYEXM02.pmc-sierra.internal>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Rajinikanth Pandurangan <Rajinikanth.Pandurangan@pmcs.com>, Tomas Henzl <thenzl@redhat.com>, "jbottomley@parallels.com" <jbottomley@parallels.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Cc: "aacraid@pmc-sierra.com" <aacraid@pmc-sierra.com>, Harry Yang <Harry.Yang@pmcs.com>, Rich Bono <Rich.Bono@pmcs.com>, Mahesh Rajashekhara <Mahesh.Rajashekhara@pmcs.com>, Achim Leubner <Achim.Leubner@pmcs.com>, Murthy Bhat <Murthy.Bhat@pmcs.com>

Hello Tomas,

Our real intention was to replace pci_enable_msix() with pci_enable_msix_range().
In V4, I had min as 8 and max as msi_count (which could be max of 32).  So range was 8 - 32.  But then as you suggested to make separate patch if I wanted to set the min range different, I have created patch 11 in V5.
In patch 10 of V5, set range as (1 - 32). - I thought this would reflect our original intention.
After discussed internally, we wanted to have at least minimum of 2 MSIx, so it reflects in patch 11 of V5.

Please let me know if you still think I missed something.

Thanks,

-----Original Message-----
From: Tomas Henzl [mailto:thenzl@redhat.com]
Sent: Thursday, July 23, 2015 5:54 AM
To: Rajinikanth Pandurangan; jbottomley@parallels.com; linux-scsi@vger.kernel.org
Cc: aacraid@pmc-sierra.com; Harry Yang; Rich Bono; Mahesh Rajashekhara; Achim Leubner; Murthy Bhat
Subject: Re: [PATCH V5 10/11] [SCSI] aacraid: Replace pci_enable_msix() with pci_enable_msix_range()

On 22.7.2015 18:49, rajinikanth.pandurangan@pmcs.com wrote:
> From: Rajinikanth Pandurangan <rajinikanth.pandurangan@pmcs.com>
> 
> Description:
>         As pci_enable_msix() deprecated, replaced with
> pci_enable_msix_range()
> 
> V4 Reviewed/commented by:
> 	Tomas Henzl <thenzl@redhat.com>
> 
> Changes from V4:
> 	Changed to 1 as minimum msix range in pci_enable_msix_range() to 
> match with original code.
I don't this is correct, your original code hasn't allowed a single msi-x line too, it allowed it in an exact same range <2,8> like it is now with 10+11/11 patch applied.
It looks like you have decided to not change the minimal supported value in the end, that means that not two but a single patch is preferred. If you for any reason repost your series, please merge
10+11 into a single patch.
I can accept it in the current form too so -

Reviewed-by: Tomas Henzl <thenzl@redhat.com>

Tomas

> 
> Signed-off-by: Rajinikanth Pandurangan 
> <rajinikanth.pandurangan@pmcs.com>
> ---
>  drivers/scsi/aacraid/comminit.c | 20 ++++++--------------
>  1 file changed, 6 insertions(+), 14 deletions(-)
> 
> diff --git a/drivers/scsi/aacraid/comminit.c 
> b/drivers/scsi/aacraid/comminit.c index b4b6088..a02cfb3 100644
> --- a/drivers/scsi/aacraid/comminit.c
> +++ b/drivers/scsi/aacraid/comminit.c
> @@ -338,7 +338,7 @@ static int aac_comm_init(struct aac_dev * dev)
>  
>  void aac_define_int_mode(struct aac_dev *dev)  {
> -	int i, msi_count;
> +	int i, msi_count, min_msix;
>  
>  	msi_count = i = 0;
>  	/* max. vectors from GET_COMM_PREFERRED_SETTINGS */ @@ -366,22
> +366,14 @@ void aac_define_int_mode(struct aac_dev *dev)
>  
>  	if (msi_count > 1 &&
>  	    pci_find_capability(dev->pdev, PCI_CAP_ID_MSIX)) {
> -		i = pci_enable_msix(dev->pdev,
> +		min_msix = 1;
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

--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" in the body of a message to majordomo@vger.kernel.org More majordomo info at  http://vger.kernel.org/majordomo-info.html
