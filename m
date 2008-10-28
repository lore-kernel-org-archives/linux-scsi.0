From: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [PATCH 1/2] cciss: fix sysfs broken symlink regression
Date: Wed, 29 Oct 2008 00:14:23 +0100
Message-ID: <200810290014.24221.rjw@sisk.pl>
References: <20081027210136.GA9438@roadking.ldev.net>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ogre.sisk.pl ([217.79.144.158]:39670 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752393AbYJ1XJt (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 28 Oct 2008 19:09:49 -0400
In-Reply-To: <20081027210136.GA9438@roadking.ldev.net>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Miller <mike.miller@hp.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Jens Axboe <jens.axboe@oracle.com>, LKML <linux-kernel@vger.kernel.org>, LKML-scsi <linux-scsi@vger.kernel.org>

On Monday, 27 of October 2008, Mike Miller wrote:
> Patch 1 of 2
> 
> Regression introduced by commit 6ae5ce8e8d4de666f31286808d2285aa6a50fa40.
> This patch fixes a broken symlink in sysfs that was introduced by the above
> commit also called "cciss: remove redundant code." We broke it in 2.6.27-rc
> on or about 20080804. Some installers are broken if this symlink does not
> exist and they may not detect the logical drives configured on the
> controller.
> It does not require being backported into 2.6.26.x or earlier kernels.
> 
> Please consider this for inclusion.
> 
> Andrew, do I need to resubmit 2 of 2? Or is that one still in your queue?
> 
> Signed-off-by: Mike Miller <mike.miller@hp.com>
> 
> diff --git a/drivers/block/cciss.c b/drivers/block/cciss.c
> index 1e1f915..0f367b1 100644
> --- a/drivers/block/cciss.c
> +++ b/drivers/block/cciss.c
> @@ -1365,6 +1365,7 @@ static void cciss_add_disk(ctlr_info_t *h, struct gendisk *disk,
>  	disk->first_minor = drv_index << NWD_SHIFT;
>  	disk->fops = &cciss_fops;
>  	disk->private_data = &h->drv[drv_index];
> +	disk->driverfs_dev = &h->pdev->dev;
>  
>  	/* Set up queue information */
>  	blk_queue_bounce_limit(disk->queue, h->pdev->dma_mask);
> --

Is this a patch for bug #11404 or for another regression?

Rafael
