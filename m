From: Patrick Mansfield <patmans@us.ibm.com>
Subject: Re: bug 2400
Date: Sun, 4 Apr 2004 21:33:07 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040404213307.A29446@beaverton.ibm.com>
References: <20040401131502.41136788.akpm@osdl.org> <1080862354.2118.78.camel@mulgrave> <1080949016.1804.161.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e2.ny.us.ibm.com ([32.97.182.102]:42168 "EHLO e2.ny.us.ibm.com")
	by vger.kernel.org with ESMTP id S263081AbUDEEdk (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 5 Apr 2004 00:33:40 -0400
Content-Disposition: inline
In-Reply-To: <1080949016.1804.161.camel@mulgrave>; from James.Bottomley@steeleye.com on Fri, Apr 02, 2004 at 06:36:55PM -0500
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>
Cc: Andrew Morton <akpm@osdl.org>, greg@kroah.com, Jens Axboe <axboe@suse.de>, linux-usb-devel@lists.sourceforge.net, SCSI Mailing List <linux-scsi@vger.kernel.org>

On Fri, Apr 02, 2004 at 06:36:55PM -0500, James Bottomley wrote:

> ===== drivers/scsi/sr.c 1.103 vs edited =====
> --- 1.103/drivers/scsi/sr.c	Fri Apr  2 11:30:44 2004
> +++ edited/drivers/scsi/sr.c	Fri Apr  2 17:29:06 2004
> @@ -424,8 +424,19 @@
>  
>  static int sr_block_release(struct inode *inode, struct file *file)
>  {
> +	int ret;
>  	struct scsi_cd *cd = scsi_cd(inode->i_bdev->bd_disk);
> -	return cdrom_release(&cd->cdi, file);
> +	struct scsi_device *sdev = cd->device;
> +	ret = cdrom_release(&cd->cdi, file);
> +	if(ret)
> +		return ret;
> +	
> +	unregister_cdrom(&cd->cdi);
> +	kfree(cd);
> +
> +	scsi_device_put(sdev);
> +
> +	return 0;
>  }
>  
>  static int sr_block_ioctl(struct inode *inode, struct file *file, unsigned cmd,
> @@ -500,7 +511,6 @@
>  	if (cd->device->sector_size > 2048)
>  		sr_set_blocklength(cd, 2048);
>  
> -	scsi_device_put(cd->device);
>  }
>  
>  static int sr_probe(struct device *dev)
> @@ -874,9 +884,6 @@
>  	spin_unlock(&sr_index_lock);
>  
>  	put_disk(cd->disk);
> -	unregister_cdrom(&cd->cdi);
> -	kfree(cd);
> -
>  	return 0;
>  }

How is unregister_cdrom(&cd->cdi) called if the device is not open?

-- Patrick Mansfield
