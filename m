From: Rajinikanth Pandurangan <Rajinikanth.Pandurangan@pmcs.com>
Subject: RE: [PATCH V4 10/10] [SCSI] aacraid: Replace pci_enable_msix() with
 pci_enable_msix_range()
Date: Wed, 22 Jul 2015 14:55:18 +0000
Message-ID: <E34C6B6293F0214497D0C55B92526C05EAFF7E6D@BBYEXM02.pmc-sierra.internal>
References: <1437501571-2475-1-git-send-email-rajinikanth.pandurangan@pmcs.com>
 <1437501571-2475-11-git-send-email-rajinikanth.pandurangan@pmcs.com>
 <55AFA100.7010708@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bby1mta02.pmc-sierra.com ([216.241.235.117]:49061 "EHLO
	bby1mta02.pmc-sierra.bc.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932921AbbGVOzW convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 22 Jul 2015 10:55:22 -0400
In-Reply-To: <55AFA100.7010708@redhat.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Tomas Henzl <thenzl@redhat.com>, "jbottomley@parallels.com" <jbottomley@parallels.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Cc: "aacraid@pmc-sierra.com" <aacraid@pmc-sierra.com>, Harry Yang <Harry.Yang@pmcs.com>, Rich Bono <Rich.Bono@pmcs.com>, Mahesh Rajashekhara <Mahesh.Rajashekhara@pmcs.com>, Achim Leubner <Achim.Leubner@pmcs.com>, Murthy Bhat <Murthy.Bhat@pmcs.com>

Hello Tomas,

Yes, in case of failure, we'll fall into msi.

Thanks,
-----Original Message-----
From: Tomas Henzl [mailto:thenzl@redhat.com] 
Sent: Wednesday, July 22, 2015 6:56 AM
To: Rajinikanth Pandurangan; jbottomley@parallels.com; linux-scsi@vger.kernel.org
Cc: aacraid@pmc-sierra.com; Harry Yang; Rich Bono; Mahesh Rajashekhara; Achim Leubner; Murthy Bhat
Subject: Re: [PATCH V4 10/10] [SCSI] aacraid: Replace pci_enable_msix() with pci_enable_msix_range()

On 21.7.2015 19:59, rajinikanth.pandurangan@pmcs.com wrote:
> From: Rajinikanth Pandurangan <rajinikanth.pandurangan@pmcs.com>
> 
> Description:
>         As pci_enable_msix() deprecated, replaced with 
> pci_enable_msix_range()
> 
> V3 Reviewed/commented by:
> 	Tomas Henzl <thenzl@redhat.com>
> 
> Changes from V3:
> 	Uses pci_enable_msix_range() instead of pci_enable_msix_exact() based 
> on review comment.
> 
> Signed-off-by: Rajinikanth Pandurangan 
> <rajinikanth.pandurangan@pmcs.com>
> ---
>  drivers/scsi/aacraid/comminit.c | 20 ++++++--------------
>  1 file changed, 6 insertions(+), 14 deletions(-)
> 
> diff --git a/drivers/scsi/aacraid/comminit.c 
> b/drivers/scsi/aacraid/comminit.c index b4b6088..3ba6e97 100644
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
> +		min_msix = 8;
That^ will make the pci-enable function fail on boxes with less than eight num-online-cpus

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

