From: Douglas Gilbert <dgilbert@interlog.com>
Subject: Re: [PATCH] scsi: sg: fix SG_DXFER_FROM_DEV transfers
Date: Thu, 6 Jul 2017 14:47:22 -0400
Message-ID: <54abb58b-3fe6-8e64-91aa-182fbef93467@interlog.com>
References: <20170705134934.1703-1-jthumshirn@suse.de>
Reply-To: dgilbert@interlog.com
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20170705134934.1703-1-jthumshirn@suse.de>
Content-Language: en-CA
Sender: linux-kernel-owner@vger.kernel.org
To: Johannes Thumshirn <jthumshirn@suse.de>, "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: Linux SCSI Mailinglist <linux-scsi@vger.kernel.org>, Linux Kernel Mailinglist <linux-kernel@vger.kernel.org>, Chris Clayton <chris2553@googlemail.com>
List-Id: linux-scsi@vger.kernel.org

On 2017-07-05 09:49 AM, Johannes Thumshirn wrote:
> SG_DXFER_FROM_DEV transfers do not have a dxferp as we set it to NULL,
> but must have a length bigger than 0. This fixes a regression introduced
> by commit 28676d869bbb ("scsi: sg: check for valid direction before
> starting the request")

It is not clear to me that dxferp is set to NULL for the newer sg_v3
interface. In the sg.c source of lk 4.12.0 around line 654 (in the
sg_write(...) function) only the older interface passes through; the
newer interface bypasses that section with a 'return sg_new_write(...)'
on line 606.

Can you check your patch with one of the utilities from sg3_utils
such as sg_inq which will use SG_DXFER_FROM_DEV with the newer
interface?


BTW I'm not sure why dxferp is set to NULL for SG_DXFER_FROM_DEV
transfers; perhaps some magic done by the block layer. Maybe a
comment in the code (e.g. on line 654) would help.

Also sg_is_valid_dxfer() is only called once and is more complex
than it looks; so perhaps it could be inlined back in
sg_common_write().

Doug Gilbert

> Signed-off-by: Johannes Thumshirn <jthumshirn@suse.de>
> Fixes: 28676d869bbb ("scsi: sg: check for valid direction before starting the request")
> Reported-by: Chris Clayton <chris2553@googlemail.com>
> Tested-by: Chris Clayton <chris2553@googlemail.com>
> Cc: Doug Gilbert <dgilbert@interlog.com>
> ---
>   drivers/scsi/sg.c | 5 ++++-
>   1 file changed, 4 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/scsi/sg.c b/drivers/scsi/sg.c
> index 21225d62b0c1..3c91593260aa 100644
> --- a/drivers/scsi/sg.c
> +++ b/drivers/scsi/sg.c
> @@ -758,8 +758,11 @@ static bool sg_is_valid_dxfer(sg_io_hdr_t *hp)
>   		if (hp->dxferp || hp->dxfer_len > 0)
>   			return false;
>   		return true;
> -	case SG_DXFER_TO_DEV:
>   	case SG_DXFER_FROM_DEV:
> +		if (hp->dxferp || hp->dxfer_len < 0)
> +			return false;
> +		return true;
> +	case SG_DXFER_TO_DEV:
>   	case SG_DXFER_TO_FROM_DEV:
>   		if (!hp->dxferp || hp->dxfer_len == 0)
>   			return false;
> 
