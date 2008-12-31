From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: [PATCH] sg: fix races during device removal
Date: Wed, 31 Dec 2008 17:37:33 +0900
Message-ID: <20081231173632N.fujita.tomonori@lab.ntt.co.jp>
References: <495A40D4.5030901@cybernetics.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sh.osrg.net ([192.16.179.4]:35088 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756167AbYLaIhr (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 31 Dec 2008 03:37:47 -0500
In-Reply-To: <495A40D4.5030901@cybernetics.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: tonyb@cybernetics.com
Cc: dgilbert@interlog.com, linux-scsi@vger.kernel.org, James.Bottomley@HansenPartnership.com

On Tue, 30 Dec 2008 10:40:04 -0500
Tony Battersby <tonyb@cybernetics.com> wrote:

> sg has the following races relating to device removal:
> 
> 1) It is not safe for sg_remove() to access sdp after setting
> sdp->detached = 1 and dropping sg_index_lock, since sg_release() or
> sg_cmd_done() may call sg_remove_sfp(), which may free sdp.  I have seen
> this race cause an oops.
> 
> 2) It is not safe for sg_open() to access sdp (especially after
> sleeping), since sg_remove() may free sdp anytime before sg_add_sfp() is
> called.  Similarly, sg_add_sfp() is unsafe because sg_remove() may free
> sdp anytime before the new sg_fd is linked into sdp->headfp.
> 
> 3) It is not safe for sg_release() or sg_cmd_done() to access sdp after
> calling sg_remove_sfp() (even if sg_remove_sfp() returns 0), because
> once sdp->headfp == NULL, sg_remove() may free sdp.
> 
> 4) It is not safe for sg_proc_* to access sdp, since sg_remove() may
> free it at any time.
> 
> 5) Various SCSI_LOG_TIMEOUT calls (e.g. in sg_release) use
> sdp->disk->disk_name after sg_remove may have set sdp->disk to NULL.

Looks like a nice fix.


> Signed-off-by: Tony Battersby <tonyb@cybernetics.com>
> ---
> 
> I noticed these problems when running a test program that used the sg
> driver to access SAS devices with mptsas.  When the SAS cable is
> unplugged, mptsas automatically deletes the devices, and the test also
> fails at the same time and closes its sg file descriptors.  Depending
> on the timing, this would sometimes produce an oops due to the races
> between deleting the device, closing the fds, and commands completing.
> 
> --- linux-2.6.28/drivers/scsi/sg.c.orig	2008-12-24 18:26:37.000000000 -0500
> +++ linux-2.6.28/drivers/scsi/sg.c	2008-12-30 09:59:56.000000000 -0500
> @@ -166,6 +166,13 @@ typedef struct sg_device { /* holds the 
>  	int sg_tablesize;	/* adapter's max scatter-gather table size */
>  	u32 index;		/* device index number */
>  	Sg_fd *headfp;		/* first open fd belonging to this device */
> +	/* To prevent races with device removal (sg_remove), if a function
> +	   holds a pointer to a sg_device where the pointer is not associated
> +	   with a sg_fd that remains linked into headfp for the entire duration
> +	   of the function, then that function must increment refcount while
> +	   holding a write lock on sg_index_lock.  When the function is done,
> +	   call sg_put_dev(). */
> +	int refcount;

Please use kref, the standard reference counting mechanism. Then you
don't need to use sg_index_lock for it.


>  	volatile char detached;	/* 0->attached, 1->detached pending removal */
>  	volatile char exclude;	/* opened for exclusive access */
>  	char sgdebug;		/* 0->off, 1->sense, 9->dump dev, 10-> all devs */
> @@ -194,13 +201,14 @@ static void sg_build_reserve(Sg_fd * sfp
>  static void sg_link_reserve(Sg_fd * sfp, Sg_request * srp, int size);
>  static void sg_unlink_reserve(Sg_fd * sfp, Sg_request * srp);
>  static Sg_fd *sg_add_sfp(Sg_device * sdp, int dev);
> -static int sg_remove_sfp(Sg_device * sdp, Sg_fd * sfp);
> +static void sg_remove_sfp(Sg_device * sdp, Sg_fd * sfp);
>  static void __sg_remove_sfp(Sg_device * sdp, Sg_fd * sfp);
>  static Sg_request *sg_get_rq_mark(Sg_fd * sfp, int pack_id);
>  static Sg_request *sg_add_request(Sg_fd * sfp);
>  static int sg_remove_request(Sg_fd * sfp, Sg_request * srp);
>  static int sg_res_in_use(Sg_fd * sfp);
>  static Sg_device *sg_get_dev(int dev);
> +static void sg_put_dev(Sg_device *sdp);
>  #ifdef CONFIG_SCSI_PROC_FS
>  static int sg_last_dev(void);
>  #endif
> @@ -238,10 +246,12 @@ sg_open(struct inode *inode, struct file
>  	SCSI_LOG_TIMEOUT(3, printk("sg_open: dev=%d, flags=0x%x\n", dev, flags));
>  	sdp = sg_get_dev(dev);
>  	if ((!sdp) || (!sdp->device)) {
> +		sg_put_dev(sdp);
>  		unlock_kernel();
>  		return -ENXIO;
>  	}
>  	if (sdp->detached) {
> +		sg_put_dev(sdp);
>  		unlock_kernel();
>  		return -ENODEV;
>  	}
> @@ -250,6 +260,7 @@ sg_open(struct inode *inode, struct file
>  	/* Prevent the device driver from vanishing while we sleep */
>  	retval = scsi_device_get(sdp->device);
>  	if (retval) {
> +		sg_put_dev(sdp);
>  		unlock_kernel();
>  		return retval;
>  	}
> @@ -290,29 +301,30 @@ sg_open(struct inode *inode, struct file
>  			goto error_out;
>  		}
>  	}
> -	if (sdp->detached) {
> -		retval = -ENODEV;
> -		goto error_out;
> -	}
>  	if (!sdp->headfp) {	/* no existing opens on this device */
>  		sdp->sgdebug = 0;
>  		q = sdp->device->request_queue;
>  		sdp->sg_tablesize = min(q->max_hw_segments,
>  					q->max_phys_segments);
>  	}
> -	if ((sfp = sg_add_sfp(sdp, dev)))
> +	sfp = sg_add_sfp(sdp, dev);
> +	if (!IS_ERR(sfp))
>  		filp->private_data = sfp;
>  	else {
> -		if (flags & O_EXCL)
> +		if (flags & O_EXCL) {
>  			sdp->exclude = 0;	/* undo if error */
> -		retval = -ENOMEM;
> +			wake_up_interruptible(&sdp->o_excl_wait);
> +		}
> +		retval = PTR_ERR(sfp);
>  		goto error_out;
>  	}
> +	sg_put_dev(sdp);
>  	unlock_kernel();
>  	return 0;
>  
>        error_out:
>  	scsi_device_put(sdp->device);
> +	sg_put_dev(sdp);
>  	unlock_kernel();
>  	return retval;
>  }
> @@ -323,17 +335,18 @@ sg_release(struct inode *inode, struct f
>  {
>  	Sg_device *sdp;
>  	Sg_fd *sfp;
> +	unsigned long iflags;
>  
>  	if ((!(sfp = (Sg_fd *) filp->private_data)) || (!(sdp = sfp->parentdp)))
>  		return -ENXIO;
>  	SCSI_LOG_TIMEOUT(3, printk("sg_release: %s\n", sdp->disk->disk_name));
> -	if (0 == sg_remove_sfp(sdp, sfp)) {	/* Returns 1 when sdp gone */
> -		if (!sdp->detached) {
> -			scsi_device_put(sdp->device);
> -		}
> -		sdp->exclude = 0;
> -		wake_up_interruptible(&sdp->o_excl_wait);
> -	}
> +	write_lock_irqsave(&sg_index_lock, iflags);
> +	sdp->refcount++;
> +	write_unlock_irqrestore(&sg_index_lock, iflags);
> +	sg_remove_sfp(sdp, sfp);
> +	sdp->exclude = 0;
> +	wake_up_interruptible(&sdp->o_excl_wait);
> +	sg_put_dev(sdp);
>  	return 0;

Looks a bit ugly. Touching refcount directly isn't not nice. Can you
avoid it (there are some other places that do the same)? e.g. you move
wake_up_interruptible() to sg_remove_sfp?
