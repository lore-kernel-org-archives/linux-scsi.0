From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH] target: fix compile failure in linux-next
Date: Thu, 23 Dec 2010 14:42:52 -0800
Message-ID: <1293144172.4649.177.camel@haakon2.linux-iscsi.org>
References: <1293036459.3019.46.camel@mulgrave.site>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.linux-iscsi.org ([67.23.28.174]:39263 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752205Ab0LWWsr (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 23 Dec 2010 17:48:47 -0500
In-Reply-To: <1293036459.3019.46.camel@mulgrave.site>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Christoph Hellwig <hch@lst.de>, linux-scsi <linux-scsi@vger.kernel.org>, Stephen Rothwell <sfr@canb.auug.org.au>

On Wed, 2010-12-22 at 10:47 -0600, James Bottomley wrote:
> The interfaces open/close_bdev_exclusive are being eliminated in the
> merge window.  Fix by using the replacements.
> 
> James
> 

Hi James,

If you don't mind I am going to let srf carry this patch for now, and I
will begin a 'for-linux-next' branch to prevent future breakage from
drivers/target/.

Best Regards,

--nab

> ---
> 
> diff --git a/drivers/target/target_core_iblock.c b/drivers/target/target_core_iblock.c
> index e99bfc2..c6e0d75 100644
> --- a/drivers/target/target_core_iblock.c
> +++ b/drivers/target/target_core_iblock.c
> @@ -152,8 +152,8 @@ static struct se_device *iblock_create_virtdevice(
>  	printk(KERN_INFO  "IBLOCK: Claiming struct block_device: %s\n",
>  			ib_dev->ibd_udev_path);
>  
> -	bd = open_bdev_exclusive(ib_dev->ibd_udev_path,
> -			FMODE_WRITE|FMODE_READ, ib_dev);
> +	bd = blkdev_get_by_path(ib_dev->ibd_udev_path,
> +				FMODE_WRITE|FMODE_READ|FMODE_EXCL, ib_dev);
>  	if (!(bd))
>  		goto failed;
>  	/*
> @@ -220,7 +220,7 @@ static void iblock_free_device(void *p)
>  {
>  	struct iblock_dev *ib_dev = p;
>  
> -	close_bdev_exclusive(ib_dev->ibd_bd, FMODE_WRITE|FMODE_READ);
> +	blkdev_put(ib_dev->ibd_bd, FMODE_WRITE|FMODE_READ|FMODE_EXCL);
>  	bioset_free(ib_dev->ibd_bio_set);
>  	kfree(ib_dev);
>  }
> diff --git a/drivers/target/target_core_pscsi.c b/drivers/target/target_core_pscsi.c
> index 6a7495b..742d246 100644
> --- a/drivers/target/target_core_pscsi.c
> +++ b/drivers/target/target_core_pscsi.c
> @@ -460,10 +460,10 @@ static struct se_device *pscsi_create_type_disk(
>  	 * Claim exclusive struct block_device access to struct scsi_device
>  	 * for TYPE_DISK using supplied udev_path
>  	 */
> -	bd = open_bdev_exclusive(se_dev->se_dev_udev_path,
> -				FMODE_WRITE|FMODE_READ, pdv);
> +	bd = blkdev_get_by_path(se_dev->se_dev_udev_path,
> +				FMODE_WRITE|FMODE_READ|FMODE_EXCL, pdv);
>  	if (!(bd)) {
> -		printk("pSCSI: open_bdev_exclusive() failed\n");
> +		printk("pSCSI: blkdev_get_by_path() failed\n");
>  		scsi_device_put(sd);
>  		return NULL;
>  	}
> @@ -471,7 +471,7 @@ static struct se_device *pscsi_create_type_disk(
>  
>  	dev = pscsi_add_device_to_list(hba, se_dev, pdv, sd, dev_flags);
>  	if (!(dev)) {
> -		close_bdev_exclusive(pdv->pdv_bd, FMODE_WRITE|FMODE_READ);
> +		blkdev_put(pdv->pdv_bd, FMODE_WRITE|FMODE_READ|FMODE_EXCL);
>  		scsi_device_put(sd);
>  		return NULL;
>  	}
> @@ -680,8 +680,8 @@ static void pscsi_free_device(void *p)
>  		 * struct scsi_device with TYPE_DISK from pscsi_create_type_disk()
>  		 */
>  		if ((sd->type == TYPE_DISK) && pdv->pdv_bd) {
> -			close_bdev_exclusive(pdv->pdv_bd,
> -					FMODE_WRITE|FMODE_READ);
> +			blkdev_put(pdv->pdv_bd,
> +				   FMODE_WRITE|FMODE_READ|FMODE_EXCL);
>  			pdv->pdv_bd = NULL;
>  		}
>  		/*
> 
> 

