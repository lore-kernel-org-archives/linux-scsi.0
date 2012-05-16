From: Douglas Gilbert <dgilbert@interlog.com>
Subject: Re: [PATCH 02/10] sg: remove while (1) non-loop
Date: Wed, 16 May 2012 17:57:24 -0400
Message-ID: <4FB422C4.4030701@interlog.com>
References: <20120412213217.GA17388@logfs.org> <20120412213248.GB17388@logfs.org>
Reply-To: dgilbert@interlog.com
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.infotech.no ([82.134.31.41]:54378 "EHLO smtp.infotech.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759249Ab2EPV5k (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 16 May 2012 17:57:40 -0400
In-Reply-To: <20120412213248.GB17388@logfs.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: =?UTF-8?B?SsO2cm4gRW5nZWw=?= <joern@logfs.org>
Cc: "James E.J. Bottomley" <JBottomley@parallels.com>, linux-scsi@vger.kernel.org

On 12-04-12 05:32 PM, J=C3=B6rn Engel wrote:
> The while (1) construct isn't actually a loop at all.  So let's not
> pretent and obfuscate the code.
>
> Signed-off-by: Joern Engel<joern@logfs.org>

Acked-by: Douglas Gilbert <dgilbert@interlog.com>

> ---
>   drivers/scsi/sg.c |   30 +++++++++++++-----------------
>   1 files changed, 13 insertions(+), 17 deletions(-)
>
> diff --git a/drivers/scsi/sg.c b/drivers/scsi/sg.c
> index 14de843..f9e89b2 100644
> --- a/drivers/scsi/sg.c
> +++ b/drivers/scsi/sg.c
> @@ -801,25 +801,21 @@ sg_ioctl(struct file *filp, unsigned int cmd_in=
, unsigned long arg)
>   				 1, read_only, 1,&srp);
>   		if (result<  0)
>   			return result;
> -		while (1) {
> -			result =3D 0;	/* following macro to beat race condition */
> -			__wait_event_interruptible(sfp->read_wait,
> -				(srp->done || sdp->detached),
> -				result);
> -			if (sdp->detached)
> -				return -ENODEV;
> -			write_lock_irq(&sfp->rq_list_lock);
> -			if (srp->done) {
> -				srp->done =3D 2;
> -				write_unlock_irq(&sfp->rq_list_lock);
> -				break;
> -			}
> -			srp->orphan =3D 1;
> +		result =3D 0;	/* following macro to beat race condition */
> +		__wait_event_interruptible(sfp->read_wait,
> +			(srp->done || sdp->detached), result);
> +		if (sdp->detached)
> +			return -ENODEV;
> +		write_lock_irq(&sfp->rq_list_lock);
> +		if (srp->done) {
> +			srp->done =3D 2;
>   			write_unlock_irq(&sfp->rq_list_lock);
> -			return result;	/* -ERESTARTSYS because signal hit process */
> +			result =3D sg_new_read(sfp, p, SZ_SG_IO_HDR, srp);
> +			return (result<  0) ? result : 0;
>   		}
> -		result =3D sg_new_read(sfp, p, SZ_SG_IO_HDR, srp);
> -		return (result<  0) ? result : 0;
> +		srp->orphan =3D 1;
> +		write_unlock_irq(&sfp->rq_list_lock);
> +		return result;	/* -ERESTARTSYS because signal hit process */
>   	case SG_SET_TIMEOUT:
>   		result =3D get_user(val, ip);
>   		if (result)

--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
