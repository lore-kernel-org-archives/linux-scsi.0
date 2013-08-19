From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH 1/2] ufs-pltfrm: initialize DMA mask for device-tree
 probed device
Date: Mon, 19 Aug 2013 07:32:00 -0700
Message-ID: <1376922720.2069.10.camel@dabdike.int.hansenpartnership.com>
References: <1376920566-20325-1-git-send-email-mita@fixstars.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:60525 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750876Ab3HSOcG (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 19 Aug 2013 10:32:06 -0400
In-Reply-To: <1376920566-20325-1-git-send-email-mita@fixstars.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Akinobu Mita <mita@fixstars.com>
Cc: linux-scsi@vger.kernel.org, Sujit Reddy Thumma <sthumma@codeaurora.org>, Vinayak Holikatti <vinholikatti@gmail.com>, Santosh Y <santoshsy@gmail.com>

On Mon, 2013-08-19 at 22:56 +0900, Akinobu Mita wrote:
> The device-tree probed device for ARM doesn't have dev->dma_mask.
> So dma_set_mask() for the device doesn't succeed.  The popular trick
> for this is - dev->dma_mask = &dev->coherent_dma_mask;
> 
> Currently there is no dma_set_mask() call in ufs-pltfrm, but the
> forthcoming fix needs proper DMA mask setting in ufs core driver.  So
> initializing dev->dma_mask as described above is required.
> 
> Signed-off-by: Akinobu Mita <mita@fixstars.com>
> Cc: Sujit Reddy Thumma <sthumma@codeaurora.org>
> Cc: Vinayak Holikatti <vinholikatti@gmail.com>
> Cc: Santosh Y <santoshsy@gmail.com>
> Cc: "James E.J. Bottomley" <JBottomley@parallels.com>
> Cc: linux-scsi@vger.kernel.org
> ---
>  drivers/scsi/ufs/ufshcd-pltfrm.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/drivers/scsi/ufs/ufshcd-pltfrm.c b/drivers/scsi/ufs/ufshcd-pltfrm.c
> index 94ba40c..c780840 100644
> --- a/drivers/scsi/ufs/ufshcd-pltfrm.c
> +++ b/drivers/scsi/ufs/ufshcd-pltfrm.c
> @@ -122,6 +122,9 @@ static int ufshcd_pltfrm_probe(struct platform_device *pdev)
>  		goto out;
>  	}
>  
> +	if (!dev->dma_mask)
> +		dev->dma_mask = &dev->coherent_dma_mask;
> +

If the DMA mask is NULL, it means there's buggy platform code somewhere;
I'm not sure we should be hacking a fix in a SCSI driver.

James


