From: Douglas Gilbert <dgilbert@interlog.com>
Subject: Re: [PATCH v2 07/10] sg: protect sdp->exclude
Date: Wed, 16 May 2012 17:57:44 -0400
Message-ID: <4FB422D8.5020401@interlog.com>
References: <20120412213217.GA17388@logfs.org> <20120412213418.GG17388@logfs.org> <4F95D426.7000406@interlog.com> <20120424201311.GB20610@logfs.org>
Reply-To: dgilbert@interlog.com
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.infotech.no ([82.134.31.41]:54409 "EHLO smtp.infotech.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759681Ab2EPV6A (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 16 May 2012 17:58:00 -0400
In-Reply-To: <20120424201311.GB20610@logfs.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: =?UTF-8?B?SsO2cm4gRW5nZWw=?= <joern@logfs.org>
Cc: "James E.J. Bottomley" <JBottomley@parallels.com>, linux-scsi@vger.kernel.org

On 12-04-24 04:13 PM, J=C3=B6rn Engel wrote:
> Changes since v1: set_exclude now returns the new value, which gets
> rid of the comma expression and the operator precedence bug.  Thanks
> to Douglas for spotting it.
>
> sdp->exclude was previously protected by the BKL.  The sg_mutex, whic=
h
> replaced the BKL, only semi-protected it, as it was missing from
> sg_release() and sg_proc_seq_show_debug().  Take an explicit spinlock
> for it.
>
> Signed-off-by: Joern Engel<joern@logfs.org>

Acked-by: Douglas Gilbert <dgilbert@interlog.com>

> ---
>   drivers/scsi/sg.c |   37 ++++++++++++++++++++++++++++++-------
>   1 files changed, 30 insertions(+), 7 deletions(-)
>
> diff --git a/drivers/scsi/sg.c b/drivers/scsi/sg.c
> index 758e7b4..e04b2a5 100644
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
> @@ -221,6 +223,27 @@ static int sg_allow_access(struct file *filp, un=
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
> +static int set_exclude(Sg_device *sdp, char val)
> +{
> +	unsigned long flags;
> +
> +	spin_lock_irqsave(&sg_open_exclusive_lock, flags);
> +	sdp->exclude =3D val;
> +	spin_unlock_irqrestore(&sg_open_exclusive_lock, flags);
> +	return val;
> +}
> +
>   static int
>   sg_open(struct inode *inode, struct file *filp)
>   {
> @@ -269,17 +292,17 @@ sg_open(struct inode *inode, struct file *filp)
>   			goto error_out;
>   		}
>   		res =3D wait_event_interruptible(sdp->o_excl_wait,
> -					   ((!list_empty(&sdp->sfds) || sdp->exclude) ? 0 : (sdp->exclu=
de =3D 1)));
> +					   ((!list_empty(&sdp->sfds) || get_exclude(sdp)) ? 0 : set_exc=
lude(sdp, 1)));
>   		if (res) {
>   			retval =3D res;	/* -ERESTARTSYS because signal hit process */
>   			goto error_out;
>   		}
> -	} else if (sdp->exclude) {	/* some other fd has an exclusive lock o=
n dev */
> +	} else if (get_exclude(sdp)) {	/* some other fd has an exclusive lo=
ck on dev */
>   		if (flags&  O_NONBLOCK) {
>   			retval =3D -EBUSY;
>   			goto error_out;
>   		}
> -		res =3D wait_event_interruptible(sdp->o_excl_wait, !sdp->exclude);
> +		res =3D wait_event_interruptible(sdp->o_excl_wait, !get_exclude(sd=
p));
>   		if (res) {
>   			retval =3D res;	/* -ERESTARTSYS because signal hit process */
>   			goto error_out;
> @@ -298,7 +321,7 @@ sg_open(struct inode *inode, struct file *filp)
>   		filp->private_data =3D sfp;
>   	else {
>   		if (flags&  O_EXCL) {
> -			sdp->exclude =3D 0;	/* undo if error */
> +			set_exclude(sdp, 0);	/* undo if error */
>   			wake_up_interruptible(&sdp->o_excl_wait);
>   		}
>   		retval =3D -ENOMEM;
> @@ -329,7 +352,7 @@ sg_release(struct inode *inode, struct file *filp=
)
>   		return -ENXIO;
>   	SCSI_LOG_TIMEOUT(3, printk("sg_release: %s\n", sdp->disk->disk_nam=
e));
>
> -	sdp->exclude =3D 0;
> +	set_exclude(sdp, 0);
>   	wake_up_interruptible(&sdp->o_excl_wait);
>
>   	scsi_autopm_put_device(sdp->device);
> @@ -2602,7 +2625,7 @@ static int sg_proc_seq_show_debug(struct seq_fi=
le *s, void *v)
>   			     scsidp->lun,
>   			     scsidp->host->hostt->emulated);
>   		seq_printf(s, " sg_tablesize=3D%d excl=3D%d\n",
> -			   sdp->sg_tablesize, sdp->exclude);
> +			   sdp->sg_tablesize, get_exclude(sdp));
>   		sg_proc_debug_helper(s, sdp);
>   	}
>   	read_unlock_irqrestore(&sg_index_lock, iflags);

--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
