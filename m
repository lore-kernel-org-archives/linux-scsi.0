From: Douglas Gilbert <dgilbert@interlog.com>
Subject: Re: [PATCH 07/10] sg: protect sdp->exclude
Date: Mon, 23 Apr 2012 18:13:58 -0400
Message-ID: <4F95D426.7000406@interlog.com>
References: <20120412213217.GA17388@logfs.org> <20120412213418.GG17388@logfs.org>
Reply-To: dgilbert@interlog.com
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.infotech.no ([82.134.31.41]:54660 "EHLO smtp.infotech.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754102Ab2DWWOL (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 23 Apr 2012 18:14:11 -0400
In-Reply-To: <20120412213418.GG17388@logfs.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: =?UTF-8?B?SsO2cm4gRW5nZWw=?= <joern@logfs.org>
Cc: "James E.J. Bottomley" <JBottomley@parallels.com>, linux-scsi@vger.kernel.org

On 12-04-12 05:34 PM, J=C3=B6rn Engel wrote:
> sdp->exclude was previously protected by the BKL.  The sg_mutex, whic=
h
> replaced the BKL, only semi-protected it, as it was missing from
> sg_release() and sg_proc_seq_show_debug().  Take an explicit spinlock
> for it.
>
> Signed-off-by: Joern Engel<joern@logfs.org>
> ---
>   drivers/scsi/sg.c |   36 +++++++++++++++++++++++++++++-------
>   1 files changed, 29 insertions(+), 7 deletions(-)
>
> diff --git a/drivers/scsi/sg.c b/drivers/scsi/sg.c
> index 758e7b4..a70018e 100644
> --- a/drivers/scsi/sg.c
> +++ b/drivers/scsi/sg.c
> @@ -105,6 +105,7 @@ static int sg_add(struct device *, struct class_i=
nterface *);
>   static void sg_remove(struct device *, struct class_interface *);
>
>   static DEFINE_MUTEX(sg_mutex);
> +static DEFINE_SPINLOCK(sg_open_exclusive_lock);
>
>   static DEFINE_IDR(sg_index_idr);
>   static DEFINE_RWLOCK(sg_index_lock);	/* Also used to lock
> @@ -173,7 +174,8 @@ typedef struct sg_device { /* holds the state of =
each scsi generic device */
>   	u32 index;		/* device index number */
>   	struct list_head sfds;
>   	volatile char detached;	/* 0->attached, 1->detached pending remova=
l */
> -	volatile char exclude;	/* opened for exclusive access */
> +	/* exclude protected by sg_open_exclusive_lock */
> +	char exclude;		/* opened for exclusive access */
>   	char sgdebug;		/* 0->off, 1->sense, 9->dump dev, 10->  all devs */
>   	struct gendisk *disk;
>   	struct cdev * cdev;	/* char_dev [sysfs: /sys/cdev/major/sg<n>] */
> @@ -221,6 +223,26 @@ static int sg_allow_access(struct file *filp, un=
signed char *cmd)
>   	return blk_verify_command(cmd, filp->f_mode&  FMODE_WRITE);
>   }
>
> +static int get_exclude(Sg_device *sdp)
> +{
> +	unsigned long flags;
> +	int ret;
> +
> +	spin_lock_irqsave(&sg_open_exclusive_lock, flags);
> +	ret =3D sdp->exclude;
> +	spin_unlock_irqrestore(&sg_open_exclusive_lock, flags);
> +	return ret;
> +}
> +
> +static void set_exclude(Sg_device *sdp, char val)
> +{
> +	unsigned long flags;
> +
> +	spin_lock_irqsave(&sg_open_exclusive_lock, flags);
> +	sdp->exclude =3D val;
> +	spin_unlock_irqrestore(&sg_open_exclusive_lock, flags);
> +}
> +
>   static int
>   sg_open(struct inode *inode, struct file *filp)
>   {
> @@ -269,17 +291,17 @@ sg_open(struct inode *inode, struct file *filp)
>   			goto error_out;
>   		}
>   		res =3D wait_event_interruptible(sdp->o_excl_wait,
> -					   ((!list_empty(&sdp->sfds) || sdp->exclude) ? 0 : (sdp->exclu=
de =3D 1)));
> +					   ((!list_empty(&sdp->sfds) || get_exclude(sdp)) ? 0 : set_exc=
lude(sdp, 1), 1));

I have gone through the rest of this series of patches (10 of
them posted 12 April) and they look fine. The above line worries
me and I raised it with the author but have received no response.

A small test program suggests that the second argument to
wait_event_interruptible [a condition] will always be true
due to the trailing comma operator (i.e. the ", 1"). I suspect
another set of parentheses is needed:
   res =3D wait_event_interruptible(sdp->o_excl_wait,
              ((!list_empty(&sdp->sfds) || get_exclude(sdp)) ?
		      0 : (set_exclude(sdp, 1), 1)));

Doug Gilbert

--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
