From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 3/4] hpsa: remove coalescing settings for ioaccel2
Date: Thu, 27 Oct 2016 11:03:34 +0200
Message-ID: <38a10a15-a441-cfcb-bc06-0cbe27863c24@suse.de>
References: <147752001094.813.10247306839794156732.stgit@brunhilda>
 <147752051865.813.13621083415298379753.stgit@brunhilda>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:34301 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S942515AbcJ0ONv (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 27 Oct 2016 10:13:51 -0400
In-Reply-To: <147752051865.813.13621083415298379753.stgit@brunhilda>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Don Brace <don.brace@microsemi.com>, jejb@linux.vnet.ibm.com, john.hall@microsemi.com, Kevin.Barnett@microsemi.com, Mahesh.Rajashekhara@microsemi.com, hch@infradead.org, scott.teel@microsemi.com, Viswas.G@microsemi.com, Justin.Lindley@microsemi.com, scott.benesh@microsemi.com, elliott@hpe.com, POSWALD@suse.com
Cc: linux-scsi@vger.kernel.org

On 10/27/2016 12:21 AM, Don Brace wrote:
> - Setting coalescing has a significant negative
>   impact on low queue-depth performance.
> - Does not help high queue-depth performance.
> 
> Reviewed-by: Scott Benesh <scott.benesh@microsemi.com>
> Reviewed-by: Scott Teel <scott.teel@microsemi.com>
> Reviewed-by: Kevin Barnett <kevin.barnett@microsemi.com>
> Signed-off-by: Don Brace <don.brace@microsemi.com>
> ---
>  drivers/scsi/hpsa.c |    8 ++------
>  1 file changed, 2 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
> index 9fb739c..810c300 100644
> --- a/drivers/scsi/hpsa.c
> +++ b/drivers/scsi/hpsa.c
> @@ -9277,13 +9277,9 @@ static int hpsa_enter_performant_mode(struct ctlr_info *h, u32 trans_support)
>  		access = SA5_ioaccel_mode1_access;
>  		writel(10, &h->cfgtable->HostWrite.CoalIntDelay);
>  		writel(4, &h->cfgtable->HostWrite.CoalIntCount);
> -	} else {
> -		if (trans_support & CFGTBL_Trans_io_accel2) {
> +	} else
> +		if (trans_support & CFGTBL_Trans_io_accel2)
>  			access = SA5_ioaccel_mode2_access;
> -			writel(10, &h->cfgtable->HostWrite.CoalIntDelay);
> -			writel(4, &h->cfgtable->HostWrite.CoalIntCount);
> -		}
> -	}
>  	writel(CFGTBL_ChangeReq, h->vaddr + SA5_DOORBELL);
>  	if (hpsa_wait_for_mode_change_ack(h)) {
>  		dev_err(&h->pdev->dev,
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
Reviewed-by: Hannes Reinecke <hare@suse.com>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		   Teamlead Storage & Networking
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: F. Imendörffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG Nürnberg)
