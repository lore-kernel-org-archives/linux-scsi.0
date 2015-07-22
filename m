From: Tomas Henzl <thenzl@redhat.com>
Subject: Re: [PATCH 09/11] hpsa: add in new offline mode
Date: Wed, 22 Jul 2015 17:19:41 +0200
Message-ID: <55AFB48D.2000000@redhat.com>
References: <20150718160245.31955.16794.stgit@brunhilda>
 <20150718161304.31955.11191.stgit@brunhilda>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:52129 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934322AbbGVPTo (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 22 Jul 2015 11:19:44 -0400
In-Reply-To: <20150718161304.31955.11191.stgit@brunhilda>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Don Brace <don.brace@pmcs.com>, scott.teel@pmcs.com, Kevin.Barnett@pmcs.com, james.bottomley@parallels.com, hch@infradead.org, Justin.Lindley@pmcs.com, elliott@hp.com
Cc: linux-scsi@vger.kernel.org

On 18.7.2015 18:13, Don Brace wrote:
> From: Scott Benesh <scott.benesh@pmcs.com>
> 
> prevent adding volumes that are not available.
> 
> Reviewed-by: Kevin Barnett <kevin.barnett@pmcs.com>
> Reviewed-by: Scott Teel <scott.teel@pmcs.com>
> Reviewed-by: Justin Lindley <justin.lindley@pmcs.com>
> Signed-off-by: Don Brace <don.brace@pmcs.com>
Reviewed-by: Tomas Henzl <thenzl@redhat.com>

Tomas

> ---
>  drivers/scsi/hpsa.c     |   15 +++++++++++----
>  drivers/scsi/hpsa_cmd.h |    1 +
>  2 files changed, 12 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
> index df85f89..c72e900 100644
> --- a/drivers/scsi/hpsa.c
> +++ b/drivers/scsi/hpsa.c
> @@ -1481,17 +1481,23 @@ static void hpsa_show_volume_status(struct ctlr_info *h,
>  			h->scsi_host->host_no,
>  			sd->bus, sd->target, sd->lun);
>  		break;
> +	case HPSA_LV_NOT_AVAILABLE:
> +		dev_info(&h->pdev->dev,
> +			"C%d:B%d:T%d:L%d Volume is waiting for transforming volume.\n",
> +			h->scsi_host->host_no,
> +			sd->bus, sd->target, sd->lun);
> +		break;
>  	case HPSA_LV_UNDERGOING_RPI:
>  		dev_info(&h->pdev->dev,
> -			"C%d:B%d:T%d:L%d Volume is undergoing rapid parity initialization process.\n",
> +			"C%d:B%d:T%d:L%d Volume is undergoing rapid parity init.\n",
>  			h->scsi_host->host_no,
>  			sd->bus, sd->target, sd->lun);
>  		break;
>  	case HPSA_LV_PENDING_RPI:
>  		dev_info(&h->pdev->dev,
> -				"C%d:B%d:T%d:L%d Volume is queued for rapid parity initialization process.\n",
> -				h->scsi_host->host_no,
> -				sd->bus, sd->target, sd->lun);
> +			"C%d:B%d:T%d:L%d Volume is queued for rapid parity initialization process.\n",
> +			h->scsi_host->host_no,
> +			sd->bus, sd->target, sd->lun);
>  		break;
>  	case HPSA_LV_ENCRYPTED_NO_KEY:
>  		dev_info(&h->pdev->dev,
> @@ -3262,6 +3268,7 @@ static int hpsa_volume_offline(struct ctlr_info *h,
>  	/* Keep volume offline in certain cases: */
>  	switch (ldstat) {
>  	case HPSA_LV_UNDERGOING_ERASE:
> +	case HPSA_LV_NOT_AVAILABLE:
>  	case HPSA_LV_UNDERGOING_RPI:
>  	case HPSA_LV_PENDING_RPI:
>  	case HPSA_LV_ENCRYPTED_NO_KEY:
> diff --git a/drivers/scsi/hpsa_cmd.h b/drivers/scsi/hpsa_cmd.h
> index 1a98bbe..47c756b 100644
> --- a/drivers/scsi/hpsa_cmd.h
> +++ b/drivers/scsi/hpsa_cmd.h
> @@ -164,6 +164,7 @@
>  /* Logical volume states */
>  #define HPSA_VPD_LV_STATUS_UNSUPPORTED			0xff
>  #define HPSA_LV_OK                                      0x0
> +#define HPSA_LV_NOT_AVAILABLE				0x0b
>  #define HPSA_LV_UNDERGOING_ERASE			0x0F
>  #define HPSA_LV_UNDERGOING_RPI				0x12
>  #define HPSA_LV_PENDING_RPI				0x13
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

