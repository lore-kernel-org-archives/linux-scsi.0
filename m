From: Douglas Gilbert <dgilbert@interlog.com>
Subject: Re: [PATCH 03/10] sg: remove while (1) non-loop
Date: Wed, 16 May 2012 17:57:28 -0400
Message-ID: <4FB422C8.7090608@interlog.com>
References: <20120412213217.GA17388@logfs.org> <20120412213310.GC17388@logfs.org>
Reply-To: dgilbert@interlog.com
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.infotech.no ([82.134.31.41]:54384 "EHLO smtp.infotech.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759249Ab2EPV5o (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 16 May 2012 17:57:44 -0400
In-Reply-To: <20120412213310.GC17388@logfs.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: =?UTF-8?B?SsO2cm4gRW5nZWw=?= <joern@logfs.org>
Cc: "James E.J. Bottomley" <JBottomley@parallels.com>, linux-scsi@vger.kernel.org

On 12-04-12 05:33 PM, J=C3=B6rn Engel wrote:
> The while (1) construct isn't actually a loop at all.  So let's not
> pretent and obfuscate the code.
>
> Signed-off-by: Joern Engel<joern@logfs.org>

Acked-by: Douglas Gilbert <dgilbert@interlog.com>

> ---
>   drivers/scsi/sg.c |   22 +++++++++-------------
>   1 files changed, 9 insertions(+), 13 deletions(-)
>
> diff --git a/drivers/scsi/sg.c b/drivers/scsi/sg.c
> index f9e89b2..be812e0 100644
> --- a/drivers/scsi/sg.c
> +++ b/drivers/scsi/sg.c
> @@ -398,19 +398,15 @@ sg_read(struct file *filp, char __user *buf, si=
ze_t count, loff_t * ppos)
>   			retval =3D -EAGAIN;
>   			goto free_old_hdr;
>   		}
> -		while (1) {
> -			retval =3D 0; /* following macro beats race condition */
> -			__wait_event_interruptible(sfp->read_wait,
> -				(sdp->detached ||
> -				(srp =3D sg_get_rq_mark(sfp, req_pack_id))),
> -				retval);
> -			if (sdp->detached) {
> -				retval =3D -ENODEV;
> -				goto free_old_hdr;
> -			}
> -			if (0 =3D=3D retval)
> -				break;
> -
> +		retval =3D 0; /* following macro beats race condition */
> +		__wait_event_interruptible(sfp->read_wait,
> +			(sdp->detached ||
> +			(srp =3D sg_get_rq_mark(sfp, req_pack_id))), retval);
> +		if (sdp->detached) {
> +			retval =3D -ENODEV;
> +			goto free_old_hdr;
> +		}
> +		if (retval) {
>   			/* -ERESTARTSYS as signal hit process */
>   			goto free_old_hdr;
>   		}

--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
