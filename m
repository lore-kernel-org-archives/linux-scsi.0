From: Benjamin Block <bblock@linux.vnet.ibm.com>
Subject: Re: [PATCH v3 3/4] sd: Make synchronize cache upon shutdown
 asynchronous
Date: Tue, 18 Apr 2017 16:44:29 +0200
Message-ID: <20170418144429.GA28949@bblock-ThinkPad-W530>
References: <20170417173436.15555-1-bart.vanassche@sandisk.com>
 <20170417173436.15555-4-bart.vanassche@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:43878 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751520AbdDROof (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 18 Apr 2017 10:44:35 -0400
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.20/8.16.0.20) with SMTP id v3IEhgST006687
        for <linux-scsi@vger.kernel.org>; Tue, 18 Apr 2017 10:44:35 -0400
Received: from e06smtp13.uk.ibm.com (e06smtp13.uk.ibm.com [195.75.94.109])
        by mx0a-001b2d01.pphosted.com with ESMTP id 29wmrp07bh-1
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Tue, 18 Apr 2017 10:44:34 -0400
Received: from localhost
        by e06smtp13.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-scsi@vger.kernel.org> from <bblock@linux.vnet.ibm.com>;
        Tue, 18 Apr 2017 15:44:32 +0100
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id v3IEiUdx36831296
        for <linux-scsi@vger.kernel.org>; Tue, 18 Apr 2017 14:44:30 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 936F14C046
        for <linux-scsi@vger.kernel.org>; Tue, 18 Apr 2017 15:43:48 +0100 (BST)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 6D2864C04E
        for <linux-scsi@vger.kernel.org>; Tue, 18 Apr 2017 15:43:48 +0100 (BST)
Received: from bblock-ThinkPad-W530 (unknown [9.145.38.50])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP
        for <linux-scsi@vger.kernel.org>; Tue, 18 Apr 2017 15:43:48 +0100 (BST)
Content-Disposition: inline
In-Reply-To: <20170417173436.15555-4-bart.vanassche@sandisk.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bart.vanassche@sandisk.com>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>, James Bottomley <James.Bottomley@HansenPartnership.com>, linux-scsi@vger.kernel.org, Israel Rukshin <israelr@mellanox.com>, Max Gurtovoy <maxg@mellanox.com>, Hannes Reinecke <hare@suse.de>

Hej Bart,

sry for the late'ish reply, had a long weekend.

On Thu, Apr 13, 2017 at 12:28:54AM +0000, Bart Van Assche wrote:
> On Wed, 2017-04-12 at 16:41 +0200, Benjamin Block wrote:
> > On Mon, Apr 10, 2017 at 10:54:01AM -0700, Bart Van Assche wrote:
> > > [ ... ]
> > OK, so I take it the problem is when the queue is stopped, then the
> > completion in blk_execute_rq() will never be triggered and then we wait
> > for a timeout there, or potentially forever?
>
> Hello Benjamin,
>
> Thanks for the review.
>
> If a request is queued after a queue has been stopped then that request
> will never be started and hence even the timeout timer won't be started.
> blk_cleanup_queue() hangs if invoked for a stopped queue and one or more
> requests have not yet been started.
>
> > But then what is the point in trying to do it async here anyway? Won't
> > that just be doomed in the same way, just that we don't see the effect?
>
> Have you noticed that patch 4/4 in this series restarts the queue just
> before calling blk_cleanup_queue()?
>
> Anyway, can you have a look at the patch below and see whether this new
> version addresses all the concerns you had reported in your previous
> e-mail?
>

Yes, the code- and comment-changes in sd_shutdown() are good. Apparently
there is something new with the done-function now, but you got that from
Israel.

I still wonder why we try 'so hard' scheduling a command for a dead
device, but as that seems to be the status quo, and only lacks in the
case where the LLD is already half-way gone, its ok for me too. I mean,
the order is a bit screwed.. we apparently first remove the driver and
post-factum try to drain the queue.. that is strange.


- Benjamin

On Mon, Apr 17, 2017 at 10:34:35AM -0700, Bart Van Assche wrote:
> This patch avoids that sd_shutdown() hangs on the SYNCHRONIZE CACHE
> command if the block layer queue has been stopped by
> scsi_target_block().
> 
> Signed-off-by: Bart Van Assche <bart.vanassche@sandisk.com>
> Cc: Israel Rukshin <israelr@mellanox.com>
> Cc: Max Gurtovoy <maxg@mellanox.com>
> Cc: Hannes Reinecke <hare@suse.de>
> Cc: Benjamin Block <bblock@linux.vnet.ibm.com>
> ---
>  drivers/scsi/sd.c | 45 ++++++++++++++++++++++++++++++++++++++++-----
>  1 file changed, 40 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
> index fe0f7997074e..deff564fe649 100644
> --- a/drivers/scsi/sd.c
> +++ b/drivers/scsi/sd.c
> @@ -1489,6 +1489,33 @@ static unsigned int sd_check_events(struct gendisk *disk, unsigned int clearing)
>  	return retval;
>  }
> 
> +static void sd_sync_cache_done(struct request *rq, int e)
> +{
> +	struct scsi_disk *sdkp = scsi_disk(rq->rq_disk);
> +
> +	sd_printk(KERN_DEBUG, sdkp, "%s\n", __func__);
> +
> +	blk_put_request(rq);
> +}
> +
> +/*
> + * Issue a SYNCHRONIZE CACHE command asynchronously. Since blk_cleanup_queue()
> + * waits for all commands to finish, __scsi_remove_device() will wait for the
> + * SYNCHRONIZE CACHE command to finish.
> + */
> +static int sd_sync_cache_async(struct scsi_disk *sdkp)
> +{
> +	const struct scsi_device *sdp = sdkp->device;
> +	const int timeout = sdp->request_queue->rq_timeout *
> +			    SD_FLUSH_TIMEOUT_MULTIPLIER;
> +	const unsigned char cmd[10] = { SYNCHRONIZE_CACHE };
> +
> +	sd_printk(KERN_DEBUG, sdkp, "%s\n", __func__);
> +	return scsi_execute_async(sdp, sdkp->disk, cmd, DMA_NONE, NULL, 0,
> +				  timeout, SD_MAX_RETRIES, 0, 0,
> +				  sd_sync_cache_done);
> +}
> +
>  static int sd_sync_cache(struct scsi_disk *sdkp)
>  {
>  	int retries, res;
> @@ -3349,13 +3376,15 @@ static int sd_start_stop_device(struct scsi_disk *sdkp, int start)
>  }
> 
>  /*
> - * Send a SYNCHRONIZE CACHE instruction down to the device through
> - * the normal SCSI command structure.  Wait for the command to
> - * complete.
> + * Send a SYNCHRONIZE CACHE instruction down to the device through the normal
> + * SCSI command structure. When stopping the disk, wait for the command to
> + * complete. When not stopping the disk, the blk_cleanup_queue() call in
> + * __scsi_remove_device() will wait for this command to complete.
>   */
>  static void sd_shutdown(struct device *dev)
>  {
>  	struct scsi_disk *sdkp = dev_get_drvdata(dev);
> +	bool stop_disk;
> 
>  	if (!sdkp)
>  		return;         /* this can happen */
> @@ -3363,12 +3392,18 @@ static void sd_shutdown(struct device *dev)
>  	if (pm_runtime_suspended(dev))
>  		return;
> 
> +	stop_disk = system_state != SYSTEM_RESTART &&
> +		sdkp->device->manage_start_stop;
> +
>  	if (sdkp->WCE && sdkp->media_present) {
>  		sd_printk(KERN_NOTICE, sdkp, "Synchronizing SCSI cache\n");
> -		sd_sync_cache(sdkp);
> +		if (stop_disk)
> +			sd_sync_cache(sdkp);
> +		else
> +			sd_sync_cache_async(sdkp);
>  	}
> 
> -	if (system_state != SYSTEM_RESTART && sdkp->device->manage_start_stop) {
> +	if (stop_disk) {
>  		sd_printk(KERN_NOTICE, sdkp, "Stopping disk\n");
>  		sd_start_stop_device(sdkp, 0);
>  	}
> -- 
> 2.12.2
> 

-- 
Linux on z Systems Development         /         IBM Systems & Technology Group
		  IBM Deutschland Research & Development GmbH 
Vorsitz. AufsR.: Martina Koederitz     /        Geschäftsführung: Dirk Wittkopp
Sitz der Gesellschaft: Böblingen / Registergericht: AmtsG Stuttgart, HRB 243294
