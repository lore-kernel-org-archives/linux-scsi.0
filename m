From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH] block: fix bsg_unregister and bsg_open race
Date: Thu, 14 Jun 2018 10:38:06 +0200
Message-ID: <20180614083806.GA18966@lst.de>
References: <20180613221417.GA22778@xldev-tmpl.dev.purestorage.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180613221417.GA22778@xldev-tmpl.dev.purestorage.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Anatoliy Glagolev <glagolig@gmail.com>
Cc: linux-block@vger.kernel.org, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Jens Axboe <axboe@kernel.dk>, linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Wed, Jun 13, 2018 at 04:14:18PM -0600, Anatoliy Glagolev wrote:
> The existing implementation allows races between bsg_unregister and
> bsg_open paths. bsg_ungegister and request_queue cleanup and
> deletion may start and complete right after bsg_get_device (in bsg_open path)
> retrieves bsg_class_device and releases the mutex. Then bsg_open path
> touches freed memory of bsg_class_device and request_queue.
> 
> One possible fix is to hold the mutex all the way through bsg_get_device
> instead of releasing it after bsg_class_device retrieval.

This looks generally fine to me.  Nitpicks below:

> @@ -746,16 +745,18 @@ static struct bsg_device *bsg_get_device(struct inode *inode, struct file *file)
>  	 */
>  	mutex_lock(&bsg_mutex);
>  	bcd = idr_find(&bsg_minor_idr, iminor(inode));
> -	mutex_unlock(&bsg_mutex);
>  
>  	if (!bcd)
>  		return ERR_PTR(-ENODEV);

This needs to unlock the mutex. E.g.

	if (!bcd) {
		bd = ERR_PTR(-ENODEV);
		goto out_unlock;
	}


>  	bd = __bsg_get_device(iminor(inode), bcd->queue);
> +	if (bd) {
> +		mutex_unlock(&bsg_mutex);
>  		return bd;
> +	}
>  
>  	bd = bsg_add_device(inode, bcd->queue, file);
> +	mutex_unlock(&bsg_mutex);
>  
>  	return bd;

I'd simply do:

	bd = __bsg_get_device(iminor(inode), bcd->queue);
	if (!bd)
		bd = bsg_add_device(inode, bcd->queue, file);
out_unlock:
	mutex_unlock(&bsg_mutex);
	return bd;
