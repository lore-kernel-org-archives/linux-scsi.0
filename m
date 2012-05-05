From: Bart Van Assche <bvanassche@acm.org>
Subject: Re: [PATCH 2/3] Stop accepting SCSI requests before removing a device
Date: Sat, 05 May 2012 13:04:28 +0000
Message-ID: <4FA5255C.10803@acm.org>
References: <4FA3EF10.3040104@acm.org> <4FA3F059.6020004@acm.org> <4FA43912.2060706@cs.wisc.edu> <4FA43C72.3000108@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from relay01ant.iops.be ([212.53.4.34]:35632 "EHLO
	relay01ant.iops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755653Ab2EENEe (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 5 May 2012 09:04:34 -0400
In-Reply-To: <4FA43C72.3000108@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Christie <michaelc@cs.wisc.edu>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, James Bottomley <jbottomley@parallels.com>, Jun'ichi Nomura <j-nomura@ce.jp.nec.com>, Stefan Richter <stefanr@s5r6.in-berlin.de>, Tomas Henzl <thenzl@redhat.com>, Mike Snitzer <snitzer@redhat.com>

On 05/04/12 20:30, Mike Christie wrote:
> diff --git a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
> index 42c35ff..11dc3ff 100644
> --- a/drivers/scsi/scsi_sysfs.c
> +++ b/drivers/scsi/scsi_sysfs.c
> @@ -955,24 +955,30 @@ int scsi_sysfs_add_sdev(struct scsi_device *sdev)
>  void __scsi_remove_device(struct scsi_device *sdev)
>  {
>  	struct device *dev = &sdev->sdev_gendev;
> +	struct request_queue *q = sdev->request_queue;
>  
>  	if (sdev->is_visible) {
>  		if (scsi_device_set_state(sdev, SDEV_CANCEL) != 0)
>  			return;
>  
> -		bsg_unregister_queue(sdev->request_queue);
> +		bsg_unregister_queue(q);
>  		device_unregister(&sdev->sdev_dev);
>  		transport_remove_device(dev);
>  		device_del(dev);
>  	} else
>  		put_device(&sdev->sdev_dev);
> +	/*
> +	 * Stop accepting new requests before tearing down the
> +	 * queue. Note: the actual queue deallocation happens in
> +	 * scsi_device_dev_release_usercontext().
> +	 */
> +	blk_cleanup_queue(q);
> +
>  	scsi_device_set_state(sdev, SDEV_DEL);
>  	if (sdev->host->hostt->slave_destroy)
>  		sdev->host->hostt->slave_destroy(sdev);
>  	transport_destroy_device(dev);
>  
> -	/* Freeing the queue signals to block that we're done */
> -	blk_cleanup_queue(sdev->request_queue);
>  	put_device(dev);
>  }

Now that we're looking at potential device removal races: since the host
lock push down scsi_dispatch_cmd() is invoked while a reference on the
device is hold but without holding the host lock or the device queue lock.
Shouldn't we make sure that invoking the SCSI device tear down code only
occurs once it is sure that hostt->queuecommand won't be invoked anymore ?

Bart.
