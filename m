From: Douglas Gilbert <dgilbert@interlog.com>
Subject: Re: [PATCH 09/10] sg: remove sg_mutex
Date: Wed, 16 May 2012 17:57:54 -0400
Message-ID: <4FB422E2.5090308@interlog.com>
References: <20120412213217.GA17388@logfs.org> <20120412213505.GI17388@logfs.org>
Reply-To: dgilbert@interlog.com
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.infotech.no ([82.134.31.41]:54421 "EHLO smtp.infotech.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759695Ab2EPV6K (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 16 May 2012 17:58:10 -0400
In-Reply-To: <20120412213505.GI17388@logfs.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: =?UTF-8?B?SsO2cm4gRW5nZWw=?= <joern@logfs.org>
Cc: "James E.J. Bottomley" <JBottomley@parallels.com>, linux-scsi@vger.kernel.org

On 12-04-12 05:35 PM, J=C3=B6rn Engel wrote:
> With the exception of the detached field, sg_mutex no longer adds any
> locking.  detached handling has been broken before and is still broke=
n
> and this patch does not seem to make things worse than they were to
> begin with.
>
> However, I have observed cases of tasks being blocked for>200s waitin=
g
> for sg_mutex.  So the removal clearly adds value for very little cost=
=2E
>
> Signed-off-by: Joern Engel<joern@logfs.org>

Acked-by: Douglas Gilbert <dgilbert@interlog.com>

> ---
>   drivers/scsi/sg.c |   19 ++-----------------
>   1 files changed, 2 insertions(+), 17 deletions(-)
>
> diff --git a/drivers/scsi/sg.c b/drivers/scsi/sg.c
> index a40b814..0c646f2 100644
> --- a/drivers/scsi/sg.c
> +++ b/drivers/scsi/sg.c
> @@ -104,7 +104,6 @@ static int scatter_elem_sz_prev =3D SG_SCATTER_SZ=
;
>   static int sg_add(struct device *, struct class_interface *);
>   static void sg_remove(struct device *, struct class_interface *);
>
> -static DEFINE_MUTEX(sg_mutex);
>   static DEFINE_SPINLOCK(sg_open_exclusive_lock);
>
>   static DEFINE_IDR(sg_index_idr);
> @@ -267,7 +266,6 @@ sg_open(struct inode *inode, struct file *filp)
>   	int res;
>   	int retval;
>
> -	mutex_lock(&sg_mutex);
>   	nonseekable_open(inode, filp);
>   	SCSI_LOG_TIMEOUT(3, printk("sg_open: dev=3D%d, flags=3D0x%x\n", de=
v, flags));
>   	sdp =3D sg_get_dev(dev);
> @@ -349,7 +347,6 @@ sdp_put:
>   sg_put:
>   	if (sdp)
>   		sg_put_dev(sdp);
> -	mutex_unlock(&sg_mutex);
>   	return retval;
>   }
>
> @@ -807,7 +804,7 @@ static int srp_done(Sg_fd *sfp, Sg_request *srp)
>   	return ret;
>   }
>
> -static int
> +static long
>   sg_ioctl(struct file *filp, unsigned int cmd_in, unsigned long arg)
>   {
>   	void __user *p =3D (void __user *)arg;
> @@ -1117,18 +1114,6 @@ sg_ioctl(struct file *filp, unsigned int cmd_i=
n, unsigned long arg)
>   	}
>   }
>
> -static long
> -sg_unlocked_ioctl(struct file *filp, unsigned int cmd_in, unsigned l=
ong arg)
> -{
> -	int ret;
> -
> -	mutex_lock(&sg_mutex);
> -	ret =3D sg_ioctl(filp, cmd_in, arg);
> -	mutex_unlock(&sg_mutex);
> -
> -	return ret;
> -}
> -
>   #ifdef CONFIG_COMPAT
>   static long sg_compat_ioctl(struct file *filp, unsigned int cmd_in,=
 unsigned long arg)
>   {
> @@ -1372,7 +1357,7 @@ static const struct file_operations sg_fops =3D=
 {
>   	.read =3D sg_read,
>   	.write =3D sg_write,
>   	.poll =3D sg_poll,
> -	.unlocked_ioctl =3D sg_unlocked_ioctl,
> +	.unlocked_ioctl =3D sg_ioctl,
>   #ifdef CONFIG_COMPAT
>   	.compat_ioctl =3D sg_compat_ioctl,
>   #endif

--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
