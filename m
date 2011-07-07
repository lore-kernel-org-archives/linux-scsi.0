From: Andi Kleen <andi@firstfloor.org>
Subject: solved was Re: Linux 3.0 oopses when pulling a USB CDROM
Date: Thu, 7 Jul 2011 22:47:47 +0200
Message-ID: <20110707204747.GL15637@one.firstfloor.org>
References: <20110702181146.GM23059@one.firstfloor.org> <Pine.LNX.4.44L0.1107021544550.16190-100000@netrider.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from one.firstfloor.org ([213.235.205.2]:41005 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751356Ab1GGUrt (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 7 Jul 2011 16:47:49 -0400
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.1107021544550.16190-100000@netrider.rowland.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Andi Kleen <andi@firstfloor.org>, axboe@kernel.dk, James Bottomley <James.Bottomley@HansenPartnership.com>, Dave Jones <davej@redhat.com>, SCSI development list <linux-scsi@vger.kernel.org>, Kernel development list <linux-kernel@vger.kernel.org>, "Rafael J. Wysocki" <rjw@sisk.pl>, USB list <linux-usb@vger.kernel.org>

> Would you like to try this patch to see if it fixes the problem?  As I 
> said before, I'm not certain it's the best thing to do, but it worked 
> on my system.

Sorry for the delay. I can confirm this patch fixes the problem for me.
I did a few pulls and all performed fine. Thanks!

-Andi
> 
> Alan Stern
> 
> 
> 
> 
> Index: usb-3.0/drivers/scsi/scsi_lib.c
> ===================================================================
> --- usb-3.0.orig/drivers/scsi/scsi_lib.c
> +++ usb-3.0/drivers/scsi/scsi_lib.c
> @@ -1247,6 +1247,8 @@ int scsi_prep_fn(struct request_queue *q
>  	struct scsi_device *sdev = q->queuedata;
>  	int ret = BLKPREP_KILL;
>  
> +	if (!sdev)
> +		return ret;
>  	if (req->cmd_type == REQ_TYPE_BLOCK_PC)
>  		ret = scsi_setup_blk_pc_cmnd(sdev, req);
>  	return scsi_prep_return(q, req, ret);
> Index: usb-3.0/drivers/scsi/scsi_sysfs.c
> ===================================================================
> --- usb-3.0.orig/drivers/scsi/scsi_sysfs.c
> +++ usb-3.0/drivers/scsi/scsi_sysfs.c
> @@ -322,6 +322,8 @@ static void scsi_device_dev_release_user
>  		kfree(evt);
>  	}
>  
> +	/* Freeing the queue signals to block that we're done */
> +	scsi_free_queue(sdev->request_queue);
>  	blk_put_queue(sdev->request_queue);
>  	/* NULL queue means the device can't be used */
>  	sdev->request_queue = NULL;
> @@ -936,8 +938,6 @@ void __scsi_remove_device(struct scsi_de
>  	/* cause the request function to reject all I/O requests */
>  	sdev->request_queue->queuedata = NULL;
>  
> -	/* Freeing the queue signals to block that we're done */
> -	scsi_free_queue(sdev->request_queue);
>  	put_device(dev);
>  }
>  
> 
> 

-- 
ak@linux.intel.com -- Speaking for myself only.
