From: Benjamin Block <bblock@linux.vnet.ibm.com>
Subject: Re: [PATCH v2 3/4] sd: Make synchronize cache upon shutdown
 asynchronous
Date: Wed, 12 Apr 2017 16:41:36 +0200
Message-ID: <20170412144135.GC22576@bblock-ThinkPad-W530>
References: <20170410175402.9003-1-bart.vanassche@sandisk.com>
 <20170410175402.9003-4-bart.vanassche@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:45208 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1752650AbdDLOlm (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 12 Apr 2017 10:41:42 -0400
Received: from pps.filterd (m0098413.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.20/8.16.0.20) with SMTP id v3CEYO3M024838
        for <linux-scsi@vger.kernel.org>; Wed, 12 Apr 2017 10:41:41 -0400
Received: from e06smtp15.uk.ibm.com (e06smtp15.uk.ibm.com [195.75.94.111])
        by mx0b-001b2d01.pphosted.com with ESMTP id 29scjeuc88-1
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Wed, 12 Apr 2017 10:41:41 -0400
Received: from localhost
        by e06smtp15.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-scsi@vger.kernel.org> from <bblock@linux.vnet.ibm.com>;
        Wed, 12 Apr 2017 15:41:39 +0100
Received: from d06av24.portsmouth.uk.ibm.com (d06av24.portsmouth.uk.ibm.com [9.149.105.60])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id v3CEfbam20054372
        for <linux-scsi@vger.kernel.org>; Wed, 12 Apr 2017 14:41:37 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 285F84204B
        for <linux-scsi@vger.kernel.org>; Wed, 12 Apr 2017 15:40:43 +0100 (BST)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 0F05342045
        for <linux-scsi@vger.kernel.org>; Wed, 12 Apr 2017 15:40:43 +0100 (BST)
Received: from bblock-ThinkPad-W530 (unknown [9.152.212.195])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP
        for <linux-scsi@vger.kernel.org>; Wed, 12 Apr 2017 15:40:42 +0100 (BST)
Content-Disposition: inline
In-Reply-To: <20170410175402.9003-4-bart.vanassche@sandisk.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bart.vanassche@sandisk.com>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>, James Bottomley <James.Bottomley@HansenPartnership.com>, linux-scsi@vger.kernel.org, Israel Rukshin <israelr@mellanox.com>, Max Gurtovoy <maxg@mellanox.com>, Hannes Reinecke <hare@suse.de>

On Mon, Apr 10, 2017 at 10:54:01AM -0700, Bart Van Assche wrote:
> This patch avoids that sd_shutdown() hangs on the SYNCHRONIZE CACHE
> command if the block layer queue has been stopped by
> scsi_target_block().
> 
> Signed-off-by: Bart Van Assche <bart.vanassche@sandisk.com>
> Cc: Israel Rukshin <israelr@mellanox.com>
> Cc: Max Gurtovoy <maxg@mellanox.com>
> Cc: Hannes Reinecke <hare@suse.de>
> ---
>  drivers/scsi/sd.c | 25 +++++++++++++++++++++++--
>  1 file changed, 23 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
> index fe0f7997074e..8e98b7684893 100644
> --- a/drivers/scsi/sd.c
> +++ b/drivers/scsi/sd.c
> @@ -1489,6 +1489,22 @@ static unsigned int sd_check_events(struct gendisk *disk, unsigned int clearing)
>  	return retval;
>  }
> 
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
> +	return scsi_execute_async(sdp, cmd, DMA_NONE, NULL, 0, timeout,
> +				  SD_MAX_RETRIES, 0, 0);
> +}
> +

OK, so I take it the problem is when the queue is stopped, then the
completion in blk_execute_rq() will never be triggered and then we wait
for a timeout there, or potentially forever?

But then what is the point in trying to do it async here anyway? Won't
that just be doomed in the same way, just that we don't see the effect?

>  static int sd_sync_cache(struct scsi_disk *sdkp)
>  {
>  	int retries, res;
> @@ -3356,6 +3372,8 @@ static int sd_start_stop_device(struct scsi_disk *sdkp, int start)
>  static void sd_shutdown(struct device *dev)
>  {
>  	struct scsi_disk *sdkp = dev_get_drvdata(dev);
> +	const bool stop_disk = system_state != SYSTEM_RESTART &&
> +		sdkp->device->manage_start_stop;
> 
>  	if (!sdkp)
>  		return;         /* this can happen */

That seems wrong then. You already dereference sdkp before the function
checks whether or not the pointer is valid (at least if you can trust
the comment there).

> @@ -3365,10 +3383,13 @@ static void sd_shutdown(struct device *dev)
> 
>  	if (sdkp->WCE && sdkp->media_present) {
>  		sd_printk(KERN_NOTICE, sdkp, "Synchronizing SCSI cache\n");
> -		sd_sync_cache(sdkp);
> +		if (stop_disk)
> +			sd_sync_cache(sdkp);
> +		else
> +			sd_sync_cache_async(sdkp);

That makes the function-documentation obsolete, doesn't it?


                                                    Beste Grüße / Best regards,
                                                      - Benjamin Block

>  	}
> 
> -	if (system_state != SYSTEM_RESTART && sdkp->device->manage_start_stop) {
> +	if (stop_disk) {
>  		sd_printk(KERN_NOTICE, sdkp, "Stopping disk\n");
>  		sd_start_stop_device(sdkp, 0);
>  	}
> -- 
> 2.12.0
> 
-- 
Linux on z Systems Development         /         IBM Systems & Technology Group
		  IBM Deutschland Research & Development GmbH 
Vorsitz. AufsR.: Martina Koederitz     /        Geschäftsführung: Dirk Wittkopp
Sitz der Gesellschaft: Böblingen / Registergericht: AmtsG Stuttgart, HRB 243294
