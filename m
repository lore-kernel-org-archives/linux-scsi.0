From: Douglas Gilbert <dgilbert@interlog.com>
Subject: Re: [PATCH v2 08/10] sg: completely protect sfds
Date: Wed, 16 May 2012 17:57:48 -0400
Message-ID: <4FB422DC.9030305@interlog.com>
References: <20120412213217.GA17388@logfs.org> <20120412213445.GH17388@logfs.org> <20120425151729.GB23492@logfs.org>
Reply-To: dgilbert@interlog.com
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.infotech.no ([82.134.31.41]:54415 "EHLO smtp.infotech.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759685Ab2EPV6F (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 16 May 2012 17:58:05 -0400
In-Reply-To: <20120425151729.GB23492@logfs.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: =?UTF-8?B?SsO2cm4gRW5nZWw=?= <joern@logfs.org>
Cc: "James E.J. Bottomley" <JBottomley@parallels.com>, linux-scsi@vger.kernel.org

On 12-04-25 11:17 AM, J=C3=B6rn Engel wrote:
> sfds is protected by sg_index_lock - except for sg_open(), where it
> isn't.  Change that and add some documentation.
>
> Signed-off-by: Joern Engel<joern@logfs.org>

Acked-by: Douglas Gilbert <dgilbert@interlog.com>

> ---
>   drivers/scsi/sg.c |   19 ++++++++++++++++---
>   1 files changed, 16 insertions(+), 3 deletions(-)
>
> diff --git a/drivers/scsi/sg.c b/drivers/scsi/sg.c
> index e04b2a5..bb0514d 100644
> --- a/drivers/scsi/sg.c
> +++ b/drivers/scsi/sg.c
> @@ -146,6 +146,7 @@ typedef struct sg_request {	/* SG_MAX_QUEUE reque=
sts outstanding per file */
>   } Sg_request;
>
>   typedef struct sg_fd {		/* holds the state of a file descriptor */
> +	/* sfd_siblings is protected by sg_index_lock */
>   	struct list_head sfd_siblings;
>   	struct sg_device *parentdp;	/* owning device */
>   	wait_queue_head_t read_wait;	/* queue read until command done */
> @@ -172,6 +173,7 @@ typedef struct sg_device { /* holds the state of =
each scsi generic device */
>   	wait_queue_head_t o_excl_wait;	/* queue open() when O_EXCL in use =
*/
>   	int sg_tablesize;	/* adapter's max scatter-gather table size */
>   	u32 index;		/* device index number */
> +	/* sfds is protected by sg_index_lock */
>   	struct list_head sfds;
>   	volatile char detached;	/* 0->attached, 1->detached pending remova=
l */
>   	/* exclude protected by sg_open_exclusive_lock */
> @@ -244,6 +246,17 @@ static int set_exclude(Sg_device *sdp, char val)
>   	return val;
>   }
>
> +static int sfds_list_empty(Sg_device *sdp)
> +{
> +	unsigned long flags;
> +	int ret;
> +
> +	read_lock_irqsave(&sg_index_lock, flags);
> +	ret =3D list_empty(&sdp->sfds);
> +	read_unlock_irqrestore(&sg_index_lock, flags);
> +	return ret;
> +}
> +
>   static int
>   sg_open(struct inode *inode, struct file *filp)
>   {
> @@ -287,12 +300,12 @@ sg_open(struct inode *inode, struct file *filp)
>   			retval =3D -EPERM; /* Can't lock it with read only access */
>   			goto error_out;
>   		}
> -		if (!list_empty(&sdp->sfds)&&  (flags&  O_NONBLOCK)) {
> +		if (!sfds_list_empty(sdp)&&  (flags&  O_NONBLOCK)) {
>   			retval =3D -EBUSY;
>   			goto error_out;
>   		}
>   		res =3D wait_event_interruptible(sdp->o_excl_wait,
> -					   ((!list_empty(&sdp->sfds) || get_exclude(sdp)) ? 0 : set_exc=
lude(sdp, 1)));
> +					   ((!sfds_list_empty(sdp) || get_exclude(sdp)) ? 0 : set_exclu=
de(sdp, 1)));
>   		if (res) {
>   			retval =3D res;	/* -ERESTARTSYS because signal hit process */
>   			goto error_out;
> @@ -312,7 +325,7 @@ sg_open(struct inode *inode, struct file *filp)
>   		retval =3D -ENODEV;
>   		goto error_out;
>   	}
> -	if (list_empty(&sdp->sfds)) {	/* no existing opens on this device *=
/
> +	if (sfds_list_empty(sdp)) {	/* no existing opens on this device */
>   		sdp->sgdebug =3D 0;
>   		q =3D sdp->device->request_queue;
>   		sdp->sg_tablesize =3D queue_max_segments(q);

--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
