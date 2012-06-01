From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [PATCH 2/3] Stop accepting SCSI requests before removing a device
Date: Thu, 31 May 2012 22:13:55 -0500
Message-ID: <4FC83373.3050709@cs.wisc.edu>
References: <4FA3EF10.3040104@acm.org> <4FA3F059.6020004@acm.org> <4FA43912.2060706@cs.wisc.edu> <4FA43C72.3000108@cs.wisc.edu> <4FA5255C.10803@acm.org> <4FC4E492.1000707@acm.org> <4FC508D2.7040606@cs.wisc.edu> <4FC5C488.4010307@acm.org> <4FC65888.3000907@cs.wisc.edu> <4FC67C74.4040209@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:40310 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758827Ab2FADOV (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 31 May 2012 23:14:21 -0400
In-Reply-To: <4FC67C74.4040209@acm.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bvanassche@acm.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, James Bottomley <jbottomley@parallels.com>, Jun'ichi Nomura <j-nomura@ce.jp.nec.com>, Stefan Richter <stefanr@s5r6.in-berlin.de>, Tomas Henzl <thenzl@redhat.com>, Mike Snitzer <snitzer@redhat.com>

On 05/30/2012 03:00 PM, Bart Van Assche wrote:
> On 05/30/12 17:27, Mike Christie wrote:
> 
>> It should be waiting now if the scsi_cmnd has a request backing
>> shouldn't it? We will allocate a request struct with blk_get_request or
>> one of the other blk helpers for each scsi_cmnd, and that will increment
>> the q->rq.count. If we then go down the error path because a cmd timed
>> out or because scsi_decide_disposition returned FAILED, then we will
>> still have that request backing the scsi cmnd and the count should still
>> be incremented for it. When we call scsi_send_eh_cmnd for eh operations
>> the request is then still there and not freed yet. The request will get
>> freed later when scsi_eh_flush_done_q is called. In there we will either
>> retry or call scsi_finish_command which will go through the normal
>> completion process and eventually call __blk_put_request and freed_request.
> 
> 
> OK, that means that the counter manipulation code can be left out.
> Skipping the queuecommand() call once device removal started is still
> useful though since when not doing that scsi_remove_host() sometimes
> takes much longer than expected. A call stack I obtained via echo w
>> /proc/sysrq-trigger while scsi_remove_host() took longer than expected
> is as follows:
> 
>  [<ffffffff81404799>] schedule+0x29/0x70
>  [<ffffffff81063c55>] async_synchronize_cookie_domain+0x75/0x120
>  [<ffffffff8105c940>] ? wake_up_bit+0x40/0x40
>  [<ffffffff812c88dc>] ? __pm_runtime_resume+0x6c/0xa0
>  [<ffffffff81063d15>] async_synchronize_cookie+0x15/0x20
>  [<ffffffff81063d3c>] async_synchronize_full+0x1c/0x40
>  [<ffffffffa015aaf6>] sd_remove+0x36/0xc0 [sd_mod]
>  [<ffffffff812bce1c>] __device_release_driver+0x7c/0xe0
>  [<ffffffff812bd00f>] device_release_driver+0x2f/0x50
>  [<ffffffff812bc6cb>] bus_remove_device+0xfb/0x170
>  [<ffffffff812b97cd>] device_del+0x12d/0x1c0
>  [<ffffffffa003e714>] __scsi_remove_device+0xd4/0xe0 [scsi_mod]
>  [<ffffffffa003d10f>] scsi_forget_host+0x6f/0x80 [scsi_mod]
>  [<ffffffffa003266a>] scsi_remove_host+0x7a/0x130 [scsi_mod]
>  [<ffffffffa0564096>] srp_remove_target+0xa6/0x100 [ib_srp]
>  [<ffffffffa05642d4>] srp_remove_work+0x64/0x90 [ib_srp]
>  [<ffffffff81054f98>] process_one_work+0x1a8/0x530
>  [<ffffffff81054f29>] ? process_one_work+0x139/0x530
>  [<ffffffffa0564270>] ? srp_remove_one+0x180/0x180 [ib_srp]
>  [<ffffffff81056cea>] worker_thread+0x16a/0x350
>  [<ffffffff81056b80>] ? manage_workers+0x250/0x250
>  [<ffffffff8105c12e>] kthread+0xae/0xc0
>  [<ffffffff8140f514>] kernel_thread_helper+0x4/0x10
> 
> With the patch below these delays do not occur:
> 
> diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
> index 386f0c5..0d6ab69 100644
> --- a/drivers/scsi/scsi_error.c
> +++ b/drivers/scsi/scsi_error.c
> @@ -791,14 +791,15 @@ static int scsi_send_eh_cmnd(struct scsi_cmnd *scmd, unsigned char *cmnd,
>  
>  	scsi_log_send(scmd);
>  	scmd->scsi_done = scsi_eh_done;
> -	shost->hostt->queuecommand(shost, scmd);
> -
> -	timeleft = wait_for_completion_timeout(&done, timeout);
> -
> +	if (sdev->sdev_state != SDEV_DEL &&
> +	    shost->hostt->queuecommand(shost, scmd) == 0) {
> +		timeleft = wait_for_completion_timeout(&done, timeout);
> +		scsi_log_completion(scmd, SUCCESS);
> +	} else {
> +		timeleft = 0;
> +	}
>  	shost->eh_action = NULL;
>  
> -	scsi_log_completion(scmd, SUCCESS);
> -
>  	SCSI_LOG_ERROR_RECOVERY(3,
>  		printk("%s: scmd: %p, timeleft: %ld\n",
>  			__func__, scmd, timeleft));
> diff --git a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
> index 42c35ff..f32757c 100644
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
> +
> +	/*
> +	 * Stop accepting new requests and wait until all queuecommand()
> +	 * invocations have finished before tearing down the device.
> +	 */
>  	scsi_device_set_state(sdev, SDEV_DEL);
> +	blk_cleanup_queue(q);
> +
>  	if (sdev->host->hostt->slave_destroy)
>  		sdev->host->hostt->slave_destroy(sdev);
>  	transport_destroy_device(dev);
>  
> -	/* Freeing the queue signals to block that we're done */
> -	blk_cleanup_queue(sdev->request_queue);
>  	put_device(dev);
>  }
>  

Looks ok to me.
