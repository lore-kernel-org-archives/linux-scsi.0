From: Tomas Henzl <thenzl@redhat.com>
Subject: Re: [PATCH 01/11] hpsa: Correct double unlock of mutex
Date: Wed, 22 Jul 2015 17:16:20 +0200
Message-ID: <55AFB3C4.3030509@redhat.com>
References: <20150718160245.31955.16794.stgit@brunhilda>
 <20150718161222.31955.95845.stgit@brunhilda>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:44745 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933634AbbGVPQX (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 22 Jul 2015 11:16:23 -0400
In-Reply-To: <20150718161222.31955.95845.stgit@brunhilda>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Don Brace <don.brace@pmcs.com>, scott.teel@pmcs.com, Kevin.Barnett@pmcs.com, james.bottomley@parallels.com, hch@infradead.org, Justin.Lindley@pmcs.com, elliott@hp.com
Cc: linux-scsi@vger.kernel.org

On 18.7.2015 18:12, Don Brace wrote:
> Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
> Reviewed-by: Scott Teel <scott.teel@pmcs.com>
> Reviewed-by: Kevin Barnett <kevin.barnett@pmcs.com>
> Signed-off-by: Don Brace <don.brace@pmcs.com>
Reviewed-by: Tomas Henzl <thenzl@redhat.com>

Tomas
> ---
>  drivers/scsi/hpsa.c |    9 ++++-----
>  1 file changed, 4 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
> index 1dafeb4..1d5f4fd 100644
> --- a/drivers/scsi/hpsa.c
> +++ b/drivers/scsi/hpsa.c
> @@ -2749,11 +2749,10 @@ static int hpsa_do_reset(struct ctlr_info *h, struct hpsa_scsi_dev_t *dev,
>  			lockup_detected(h));
>  
>  	if (unlikely(lockup_detected(h))) {
> -			dev_warn(&h->pdev->dev,
> -				 "Controller lockup detected during reset wait\n");
> -			mutex_unlock(&h->reset_mutex);
> -			rc = -ENODEV;
> -		}
> +		dev_warn(&h->pdev->dev,
> +			 "Controller lockup detected during reset wait\n");
> +		rc = -ENODEV;
> +	}
>  
>  	if (unlikely(rc))
>  		atomic_set(&dev->reset_cmds_out, 0);
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

