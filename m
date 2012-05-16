From: Douglas Gilbert <dgilbert@interlog.com>
Subject: Re: [PATCH 04/10] sg: use wait_event_interruptible()
Date: Wed, 16 May 2012 17:57:32 -0400
Message-ID: <4FB422CC.9060902@interlog.com>
References: <20120412213217.GA17388@logfs.org> <20120412213325.GD17388@logfs.org>
Reply-To: dgilbert@interlog.com
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.infotech.no ([82.134.31.41]:54390 "EHLO smtp.infotech.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759249Ab2EPV5s (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 16 May 2012 17:57:48 -0400
In-Reply-To: <20120412213325.GD17388@logfs.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: =?UTF-8?B?SsO2cm4gRW5nZWw=?= <joern@logfs.org>
Cc: "James E.J. Bottomley" <JBottomley@parallels.com>, linux-scsi@vger.kernel.org

On 12-04-12 05:33 PM, J=C3=B6rn Engel wrote:
> Afaics the use of __wait_event_interruptible() as opposed to
> wait_event_interruptible() is purely historic.  So let's follow the r=
est
> of the kernel and check the condition before prepare_to_wait() - and
> also make the code a bit nicer.
>
> Signed-off-by: Joern Engel<joern@logfs.org>

Acked-by: Douglas Gilbert <dgilbert@interlog.com>

> ---
>   drivers/scsi/sg.c |   19 +++++++------------
>   1 files changed, 7 insertions(+), 12 deletions(-)
>
> diff --git a/drivers/scsi/sg.c b/drivers/scsi/sg.c
> index be812e0..1a0be4f 100644
> --- a/drivers/scsi/sg.c
> +++ b/drivers/scsi/sg.c
> @@ -268,9 +268,8 @@ sg_open(struct inode *inode, struct file *filp)
>   			retval =3D -EBUSY;
>   			goto error_out;
>   		}
> -		res =3D 0;
> -		__wait_event_interruptible(sdp->o_excl_wait,
> -					   ((!list_empty(&sdp->sfds) || sdp->exclude) ? 0 : (sdp->exclu=
de =3D 1)), res);
> +		res =3D wait_event_interruptible(sdp->o_excl_wait,
> +					   ((!list_empty(&sdp->sfds) || sdp->exclude) ? 0 : (sdp->exclu=
de =3D 1)));
>   		if (res) {
>   			retval =3D res;	/* -ERESTARTSYS because signal hit process */
>   			goto error_out;
> @@ -280,9 +279,7 @@ sg_open(struct inode *inode, struct file *filp)
>   			retval =3D -EBUSY;
>   			goto error_out;
>   		}
> -		res =3D 0;
> -		__wait_event_interruptible(sdp->o_excl_wait, (!sdp->exclude),
> -					   res);
> +		res =3D wait_event_interruptible(sdp->o_excl_wait, !sdp->exclude);
>   		if (res) {
>   			retval =3D res;	/* -ERESTARTSYS because signal hit process */
>   			goto error_out;
> @@ -398,10 +395,9 @@ sg_read(struct file *filp, char __user *buf, siz=
e_t count, loff_t * ppos)
>   			retval =3D -EAGAIN;
>   			goto free_old_hdr;
>   		}
> -		retval =3D 0; /* following macro beats race condition */
> -		__wait_event_interruptible(sfp->read_wait,
> +		retval =3D wait_event_interruptible(sfp->read_wait,
>   			(sdp->detached ||
> -			(srp =3D sg_get_rq_mark(sfp, req_pack_id))), retval);
> +			(srp =3D sg_get_rq_mark(sfp, req_pack_id))));
>   		if (sdp->detached) {
>   			retval =3D -ENODEV;
>   			goto free_old_hdr;
> @@ -797,9 +793,8 @@ sg_ioctl(struct file *filp, unsigned int cmd_in, =
unsigned long arg)
>   				 1, read_only, 1,&srp);
>   		if (result<  0)
>   			return result;
> -		result =3D 0;	/* following macro to beat race condition */
> -		__wait_event_interruptible(sfp->read_wait,
> -			(srp->done || sdp->detached), result);
> +		result =3D wait_event_interruptible(sfp->read_wait,
> +			(srp->done || sdp->detached));
>   		if (sdp->detached)
>   			return -ENODEV;
>   		write_lock_irq(&sfp->rq_list_lock);

--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
