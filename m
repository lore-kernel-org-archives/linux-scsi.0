From: Douglas Gilbert <dgilbert@interlog.com>
Subject: Re: [PATCH v2] scsi: sg: fix SG_DXFER_FROM_DEV transfers
Date: Tue, 11 Jul 2017 15:05:41 -0400
Message-ID: <e34d9674-2e91-a32e-a96b-55028710f933@interlog.com>
References: <20170707085638.18939-1-jthumshirn@suse.de>
Reply-To: dgilbert@interlog.com
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20170707085638.18939-1-jthumshirn@suse.de>
Content-Language: en-CA
Sender: linux-kernel-owner@vger.kernel.org
To: Johannes Thumshirn <jthumshirn@suse.de>, "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: Linux SCSI Mailinglist <linux-scsi@vger.kernel.org>, Linux Kernel Mailinglist <linux-kernel@vger.kernel.org>, Chris Clayton <chris2553@googlemail.com>
List-Id: linux-scsi@vger.kernel.org

On 2017-07-07 04:56 AM, Johannes Thumshirn wrote:
> SG_DXFER_FROM_DEV transfers do not necessarily have a dxferp as we set
> it to NULL for the old sg_io read/write interface, but must have a length
> bigger than 0. This fixes a regression introduced by commit 28676d869bbb
> ("scsi: sg: check for valid direction before starting the request")
> 
> Signed-off-by: Johannes Thumshirn <jthumshirn@suse.de>
> Fixes: 28676d869bbb ("scsi: sg: check for valid direction before starting the request")
> Reported-by: Chris Clayton <chris2553@googlemail.com>
> Tested-by: Chris Clayton <chris2553@googlemail.com>
> Cc: Douglas Gilbert <dgilbert@interlog.com>
> Reviewed-by: Hannes Reinecke <hare@suse.com>

Acked-by: Douglas Gilbert <dgilbert@interlog.com>

> ---
> Changes to v1:
> * Fix breakage of the sg_io v3 interface, verified using sg_inq
> 
>   drivers/scsi/sg.c | 5 ++++-
>   1 file changed, 4 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/scsi/sg.c b/drivers/scsi/sg.c
> index 21225d62b0c1..1e82d4128a84 100644
> --- a/drivers/scsi/sg.c
> +++ b/drivers/scsi/sg.c
> @@ -758,8 +758,11 @@ static bool sg_is_valid_dxfer(sg_io_hdr_t *hp)
>   		if (hp->dxferp || hp->dxfer_len > 0)
>   			return false;
>   		return true;
> -	case SG_DXFER_TO_DEV:
>   	case SG_DXFER_FROM_DEV:
> +		if (hp->dxfer_len < 0)
> +			return false;
> +		return true;
> +	case SG_DXFER_TO_DEV:
>   	case SG_DXFER_TO_FROM_DEV:
>   		if (!hp->dxferp || hp->dxfer_len == 0)
>   			return false;
> 
