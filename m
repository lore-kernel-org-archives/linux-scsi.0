From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [PATCH 2/3] Stop accepting SCSI requests before removing a device
Date: Fri, 04 May 2012 15:16:18 -0500
Message-ID: <4FA43912.2060706@cs.wisc.edu>
References: <4FA3EF10.3040104@acm.org> <4FA3F059.6020004@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:37913 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754325Ab2EDUQn (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 4 May 2012 16:16:43 -0400
In-Reply-To: <4FA3F059.6020004@acm.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bvanassche@acm.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, James Bottomley <jbottomley@parallels.com>, Jun'ichi Nomura <j-nomura@ce.jp.nec.com>, Stefan Richter <stefanr@s5r6.in-berlin.de>, Tomas Henzl <thenzl@redhat.com>, Mike Snitzer <snitzer@redhat.com>

On 05/04/2012 10:06 AM, Bart Van Assche wrote:
> diff --git a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
> index 42c35ff..f8fc240 100644
> --- a/drivers/scsi/scsi_sysfs.c
> +++ b/drivers/scsi/scsi_sysfs.c
> @@ -955,12 +955,20 @@ int scsi_sysfs_add_sdev(struct scsi_device *sdev)
>  void __scsi_remove_device(struct scsi_device *sdev)
>  {
>  	struct device *dev = &sdev->sdev_gendev;
> +	struct request_queue *q = sdev->request_queue;
> +
> +	/*
> +	 * Stop accepting new requests before tearing down the
> +	 * device. Note: the actual queue deallocation happens in
> +	 * scsi_device_dev_release_usercontext().
> +	 */
> +	blk_cleanup_queue(q);
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
> @@ -971,8 +979,6 @@ void __scsi_remove_device(struct scsi_device *sdev)

My fault. The blk_cleanup_queue call should be right before the
scsi_device_set_state(sdev, SDEV_DEL); call in this function.

It needs to be after the device_del call, because that triggers the SCSI
ULD removal which can send IO.


>  		sdev->host->hostt->slave_destroy(sdev);
>  	transport_destroy_device(dev);
>  
> -	/* Freeing the queue signals to block that we're done */
> -	blk_cleanup_queue(sdev->request_queue);
>  	put_device(dev);
>  }
>  
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

