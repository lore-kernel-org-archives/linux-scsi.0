From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH] scsi: sg: fix SG_DXFER_FROM_DEV transfers
Date: Thu, 6 Jul 2017 13:44:00 +0200
Message-ID: <23ab491c-137b-84f0-20d6-3cc595d322a2@suse.de>
References: <20170705134934.1703-1-jthumshirn@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20170705134934.1703-1-jthumshirn@suse.de>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Johannes Thumshirn <jthumshirn@suse.de>, "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: Linux SCSI Mailinglist <linux-scsi@vger.kernel.org>, Linux Kernel Mailinglist <linux-kernel@vger.kernel.org>, Chris Clayton <chris2553@googlemail.com>, Doug Gilbert <dgilbert@interlog.com>
List-Id: linux-scsi@vger.kernel.org

On 07/05/2017 03:49 PM, Johannes Thumshirn wrote:
> SG_DXFER_FROM_DEV transfers do not have a dxferp as we set it to NULL,
> but must have a length bigger than 0. This fixes a regression introduced
> by commit 28676d869bbb ("scsi: sg: check for valid direction before
> starting the request")
> 
> Signed-off-by: Johannes Thumshirn <jthumshirn@suse.de>
> Fixes: 28676d869bbb ("scsi: sg: check for valid direction before starting the request")
> Reported-by: Chris Clayton <chris2553@googlemail.com>
> Tested-by: Chris Clayton <chris2553@googlemail.com>
> Cc: Doug Gilbert <dgilbert@interlog.com>
> ---
>  drivers/scsi/sg.c | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/scsi/sg.c b/drivers/scsi/sg.c
> index 21225d62b0c1..3c91593260aa 100644
> --- a/drivers/scsi/sg.c
> +++ b/drivers/scsi/sg.c
> @@ -758,8 +758,11 @@ static bool sg_is_valid_dxfer(sg_io_hdr_t *hp)
>  		if (hp->dxferp || hp->dxfer_len > 0)
>  			return false;
>  		return true;
> -	case SG_DXFER_TO_DEV:
>  	case SG_DXFER_FROM_DEV:
> +		if (hp->dxferp || hp->dxfer_len < 0)
> +			return false;
> +		return true;
> +	case SG_DXFER_TO_DEV:
>  	case SG_DXFER_TO_FROM_DEV:
>  		if (!hp->dxferp || hp->dxfer_len == 0)
>  			return false;
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
