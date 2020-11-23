Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8B85AC63777
	for <linux-scsi@archiver.kernel.org>; Mon, 23 Nov 2020 07:02:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 433C12065C
	for <linux-scsi@archiver.kernel.org>; Mon, 23 Nov 2020 07:02:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728089AbgKWHCj (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 23 Nov 2020 02:02:39 -0500
Received: from mx2.suse.de ([195.135.220.15]:41626 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727922AbgKWHCj (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 23 Nov 2020 02:02:39 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id C9530ACC5;
        Mon, 23 Nov 2020 07:02:36 +0000 (UTC)
Subject: Re: [PATCH v3 7/9] scsi_transport_spi: Freeze request queues instead
 of quiescing
To:     Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>,
        Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@lst.de>,
        Ming Lei <ming.lei@redhat.com>, linux-scsi@vger.kernel.org,
        linux-block@vger.kernel.org,
        Alan Stern <stern@rowland.harvard.edu>,
        James Bottomley <James.Bottomley@HansenPartnership.com>,
        Woody Suwalski <terraluna977@gmail.com>,
        Can Guo <cang@codeaurora.org>,
        Stanley Chu <stanley.chu@mediatek.com>,
        "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>,
        Stan Johnson <userm57@yahoo.com>
References: <20201123031749.14912-1-bvanassche@acm.org>
 <20201123031749.14912-8-bvanassche@acm.org>
From:   Hannes Reinecke <hare@suse.de>
Message-ID: <12338292-47f8-8d1f-2c80-77912f030932@suse.de>
Date:   Mon, 23 Nov 2020 08:02:34 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.0
MIME-Version: 1.0
In-Reply-To: <20201123031749.14912-8-bvanassche@acm.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 11/23/20 4:17 AM, Bart Van Assche wrote:
> Instead of quiescing the request queues involved in domain validation,
> freeze these. As a result, the struct request_queue pm_only member is no
> longer set during domain validation. That will allow to modify
> scsi_execute() such that it stops setting the BLK_MQ_REQ_PREEMPT flag.
> Three additional changes in this patch are that scsi_mq_alloc_queue() is
> exported, that scsi_device_quiesce() is no longer exported and that
> scsi_target_{quiesce,resume}() have been changed into
> scsi_target_{freeze,unfreeze}().
> 
The description is now partially wrong, as scsi_mq_alloc_queue() is 
certainly not exported (why would it?).

And it also glosses over the main idea of this patch, namely that not
only sdev->request_queue is frozen, but also a completely _new_
request queue is allocated to send SPI DV requests over.

Please modify the description.

> Reviewed-by: Alan Stern <stern@rowland.harvard.edu>
> Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
> Cc: Woody Suwalski <terraluna977@gmail.com>
> Cc: Can Guo <cang@codeaurora.org>
> Cc: Stanley Chu <stanley.chu@mediatek.com>
> Cc: Ming Lei <ming.lei@redhat.com>
> Cc: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> Tested-by: Stan Johnson <userm57@yahoo.com>
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> ---
>   drivers/scsi/scsi_lib.c           | 21 ++++----
>   drivers/scsi/scsi_priv.h          |  2 +
>   drivers/scsi/scsi_transport_spi.c | 84 +++++++++++++++++++++----------
>   include/scsi/scsi_device.h        |  6 +--
>   4 files changed, 72 insertions(+), 41 deletions(-)
> 
> diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
> index b5449efc7283..fef4708f3778 100644
> --- a/drivers/scsi/scsi_lib.c
> +++ b/drivers/scsi/scsi_lib.c
> @@ -2555,7 +2555,6 @@ scsi_device_quiesce(struct scsi_device *sdev)
>   
>   	return err;
>   }
> -EXPORT_SYMBOL(scsi_device_quiesce);
>   
>   /**
>    *	scsi_device_resume - Restart user issued commands to a quiesced device.
> @@ -2584,30 +2583,30 @@ void scsi_device_resume(struct scsi_device *sdev)
>   EXPORT_SYMBOL(scsi_device_resume);
>   
>   static void
> -device_quiesce_fn(struct scsi_device *sdev, void *data)
> +device_freeze_fn(struct scsi_device *sdev, void *data)
>   {
> -	scsi_device_quiesce(sdev);
> +	blk_mq_freeze_queue(sdev->request_queue);
>   }
>   
>   void
> -scsi_target_quiesce(struct scsi_target *starget)
> +scsi_target_freeze(struct scsi_target *starget)
>   {
> -	starget_for_each_device(starget, NULL, device_quiesce_fn);
> +	starget_for_each_device(starget, NULL, device_freeze_fn);
>   }
> -EXPORT_SYMBOL(scsi_target_quiesce);
> +EXPORT_SYMBOL(scsi_target_freeze);
>   
>   static void
> -device_resume_fn(struct scsi_device *sdev, void *data)
> +device_unfreeze_fn(struct scsi_device *sdev, void *data)
>   {
> -	scsi_device_resume(sdev);
> +	blk_mq_unfreeze_queue(sdev->request_queue);
>   }
>   
>   void
> -scsi_target_resume(struct scsi_target *starget)
> +scsi_target_unfreeze(struct scsi_target *starget)
>   {
> -	starget_for_each_device(starget, NULL, device_resume_fn);
> +	starget_for_each_device(starget, NULL, device_unfreeze_fn);
>   }
> -EXPORT_SYMBOL(scsi_target_resume);
> +EXPORT_SYMBOL(scsi_target_unfreeze);
>   
>   /**
>    * scsi_internal_device_block_nowait - try to transition to the SDEV_BLOCK state
> diff --git a/drivers/scsi/scsi_priv.h b/drivers/scsi/scsi_priv.h
> index e34755986b47..18485595762a 100644
> --- a/drivers/scsi/scsi_priv.h
> +++ b/drivers/scsi/scsi_priv.h
> @@ -95,6 +95,8 @@ extern int scsi_mq_setup_tags(struct Scsi_Host *shost);
>   extern void scsi_mq_destroy_tags(struct Scsi_Host *shost);
>   extern void scsi_exit_queue(void);
>   extern void scsi_evt_thread(struct work_struct *work);
> +extern int scsi_device_quiesce(struct scsi_device *sdev);
> +extern void scsi_device_resume(struct scsi_device *sdev);
>   struct request_queue;
>   struct request;
>   
> diff --git a/drivers/scsi/scsi_transport_spi.c b/drivers/scsi/scsi_transport_spi.c
> index 959990f66865..2352c441302f 100644
> --- a/drivers/scsi/scsi_transport_spi.c
> +++ b/drivers/scsi/scsi_transport_spi.c
> @@ -983,6 +983,18 @@ spi_dv_device_internal(struct scsi_device *sdev, struct request_queue *q,
>   	}
>   }
>   
> +static struct request_queue *scsi_mq_alloc_queue(struct scsi_device *sdev)
> +{
> +	struct request_queue *q = blk_mq_init_queue(&sdev->host->tag_set);
> +
> +	if (IS_ERR(q))
> +		return NULL;
> +
> +	q->queuedata = sdev;
> +	__scsi_init_queue(sdev->host, q);
> +	blk_queue_flag_set(QUEUE_FLAG_SCSI_PASSTHROUGH, q);
> +	return q;
> +}
>   
>   /**	spi_dv_device - Do Domain Validation on the device
>    *	@sdev:		scsi device to validate
> @@ -997,59 +1009,79 @@ void
>   spi_dv_device(struct scsi_device *sdev)
>   {
>   	struct scsi_target *starget = sdev->sdev_target;
> +	struct request_queue *q2;
>   	u8 *buffer;
>   	const int len = SPI_MAX_ECHO_BUFFER_SIZE*2;
>   
>   	/*
> -	 * Because this function and the power management code both call
> -	 * scsi_device_quiesce(), it is not safe to perform domain validation
> -	 * while suspend or resume is in progress. Hence the
> -	 * lock/unlock_system_sleep() calls.
> +	 * Because this function creates a new request queue that is not
> +	 * visible to the rest of the system, this function must be serialized
> +	 * against suspend, resume and runtime power management. Hence the
> +	 * lock/unlock_system_sleep() and scsi_autopm_{get,put}_device()
> +	 * calls.
>   	 */
>   	lock_system_sleep();
>   
> +	if (scsi_autopm_get_device(sdev))
> +		goto unlock_system_sleep;
> +
>   	if (unlikely(spi_dv_in_progress(starget)))
> -		goto unlock;
> +		goto put_autopm;
>   
>   	if (unlikely(scsi_device_get(sdev)))
> -		goto unlock;
> -
> -	spi_dv_in_progress(starget) = 1;
> +		goto put_autopm;
>   
>   	buffer = kzalloc(len, GFP_KERNEL);
>   
>   	if (unlikely(!buffer))
> -		goto out_put;
> -
> -	/* We need to verify that the actual device will quiesce; the
> -	 * later target quiesce is just a nice to have */
> -	if (unlikely(scsi_device_quiesce(sdev)))
> -		goto out_free;
> -
> -	scsi_target_quiesce(starget);
> +		goto put_sdev;
>   
>   	spi_dv_pending(starget) = 1;
> +
>   	mutex_lock(&spi_dv_mutex(starget));
> +	if (unlikely(spi_dv_in_progress(starget)))
> +		goto clear_pending;
> +
> +	spi_dv_in_progress(starget) = 1;
>   
>   	starget_printk(KERN_INFO, starget, "Beginning Domain Validation\n");
>   
> -	spi_dv_device_internal(sdev, sdev->request_queue, buffer);
> +	q2 = scsi_mq_alloc_queue(sdev);
> +
> +	if (q2) {
> +		/*
> +		 * Freeze the target such that no other subsystem can submit
> +		 * SCSI commands to 'sdev'. Submitting SCSI commands through
> +		 * q2 may trigger the SCSI error handler. The SCSI error
> +		 * handler must be able to handle a frozen sdev->request_queue
> +		 * and must also use blk_mq_rq_from_pdu(q2)->q instead of
> +		 * sdev->request_queue if it would be necessary to access q2
> +		 * directly.
> +		 */

... 'it would be necessary' indicates that it doesn't do so, currently.
And the SPI DV code most certainly _is_ submitting SCSI commands.
So doesn't the above imply that SCSI EH will fail to work correctly?
And if so, why isn't it fixed with some later patch in this series?
Or how do you plan to address it?
Hmm?

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                Kernel Storage Architect
hare@suse.de                              +49 911 74053 688
SUSE Software Solutions GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), Geschäftsführer: Felix Imendörffer
