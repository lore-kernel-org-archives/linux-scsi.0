Return-Path: <SRS0=xo/b=CM=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B7894C433E7
	for <linux-scsi@archiver.kernel.org>; Thu,  3 Sep 2020 01:39:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 909EF20665
	for <linux-scsi@archiver.kernel.org>; Thu,  3 Sep 2020 01:39:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726528AbgICBjb (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 2 Sep 2020 21:39:31 -0400
Received: from netrider.rowland.org ([192.131.102.5]:58453 "HELO
        netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with SMTP id S1726177AbgICBj0 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 2 Sep 2020 21:39:26 -0400
Received: (qmail 644172 invoked by uid 1000); 2 Sep 2020 21:39:25 -0400
Date:   Wed, 2 Sep 2020 21:39:25 -0400
From:   Alan Stern <stern@rowland.harvard.edu>
To:     Bart Van Assche <bvanassche@acm.org>
Cc:     linux-scsi@vger.kernel.org,
        Martin Kepplinger <martin.kepplinger@puri.sm>,
        Can Guo <cang@codeaurora.org>
Subject: Re: [PATCH RFC 5/6] scsi_transport_spi: Freeze request queues
 instead of quiescing
Message-ID: <20200903013925.GB643631@rowland.harvard.edu>
References: <20200831025357.32700-1-bvanassche@acm.org>
 <20200831025357.32700-6-bvanassche@acm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200831025357.32700-6-bvanassche@acm.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Sun, Aug 30, 2020 at 07:53:56PM -0700, Bart Van Assche wrote:
> Instead of quiescing the request queues involved in domain validation,
> freeze these. As a result, the struct request_queue pm_only member is no
> longer set during domain validation. That will allow to modify
> scsi_execute() such that it stops setting the BLK_MQ_REQ_PREEMPT flag.
> Three additional changes in this patch are that scsi_mq_alloc_queue() is
> exported, that scsi_device_quiesce() is no longer exported and that
> scsi_target_{quiesce,resume}() have been changed into
> scsi_target_{freeze,unfreeze}().
> 
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> ---

> --- a/drivers/scsi/scsi_transport_spi.c
> +++ b/drivers/scsi/scsi_transport_spi.c
> @@ -997,59 +997,75 @@ void
>  spi_dv_device(struct scsi_device *sdev)
>  {
>  	struct scsi_target *starget = sdev->sdev_target;
> +	struct request_queue *q1, *q2;
>  	u8 *buffer;
>  	const int len = SPI_MAX_ECHO_BUFFER_SIZE*2;
>  
>  	/*
> -	 * Because this function and the power management code both call
> -	 * scsi_device_quiesce(), it is not safe to perform domain validation
> -	 * while suspend or resume is in progress. Hence the
> -	 * lock/unlock_system_sleep() calls.
> +	 * Because creates a new request queue that is not visible to the rest
> +	 * of the system, domain validation must be serialized against suspend,
> +	 * resume and runtime power management. Hence the
> +	 * lock/unlock_system_sleep() and scsi_autopm_{get,put}_device() calls.
>  	 */
>  	lock_system_sleep();
>  
> +	if (scsi_autopm_get_device(sdev))
> +		goto unlock_system_sleep;
> +
>  	if (unlikely(spi_dv_in_progress(starget)))
> -		goto unlock;
> +		goto put_autopm;
>  
>  	if (unlikely(scsi_device_get(sdev)))
> -		goto unlock;
> +		goto put_autopm;
>  
>  	spi_dv_in_progress(starget) = 1;
>  
>  	buffer = kzalloc(len, GFP_KERNEL);
>  
>  	if (unlikely(!buffer))
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
>  	spi_dv_pending(starget) = 1;

I'm not familiar with this code.  What happens if the test and 
assignment of spi_dv_in_progress() race between two threads?

It looks like the first to acquire the spi_dv_mutex will do a domain 
validation, then clear the spi_dv_in_progress and spi_dv_pending flags.
Then the second thread will perform another domain validation with 
those flags set to 0.  Is it supposed to work like that?

>  	mutex_lock(&spi_dv_mutex(starget));
>  
>  	starget_printk(KERN_INFO, starget, "Beginning Domain Validation\n");
>  
> -	spi_dv_device_internal(sdev, sdev->request_queue, buffer);
> +	/*
> +	 * Save the request queue pointer before it is overwritten by
> +	 * scsi_mq_alloc_queue().
> +	 */
> +	q1 = sdev->request_queue;
> +	q2 = scsi_mq_alloc_queue(sdev);
> +
> +	if (q2) {
> +		/*
> +		 * Restore the request queue pointer such that no other
> +		 * subsystem can submit SCSI commands to 'sdev'.
> +		 */

Too bad there's a little window here during which external commands can 
get sent to q2.

> +		sdev->request_queue = q1;
> +		scsi_target_freeze(starget);
> +		spi_dv_device_internal(sdev, q2, buffer);
> +		blk_cleanup_queue(q2);
> +		scsi_target_unfreeze(starget);
> +	}

No error message if the domain validation couldn't be performed?

Also, do you need to restore sdev->request_queue if the allocation 
failed?  It would be a little safer to move the restoration line 
immediately after the scsi_mq_alloc_queue call.

Ideally scsi_mq_alloc_queue would return q2 without assigning it to 
sdev->request_queue.

>  
>  	starget_printk(KERN_INFO, starget, "Ending Domain Validation\n");
>  
>  	mutex_unlock(&spi_dv_mutex(starget));
>  	spi_dv_pending(starget) = 0;
>  
> -	scsi_target_resume(starget);
> -
>  	spi_initial_dv(starget) = 1;
>  
> - out_free:
>  	kfree(buffer);
> - out_put:
> +
> +put_sdev:
>  	spi_dv_in_progress(starget) = 0;
>  	scsi_device_put(sdev);
> -unlock:
> +
> +put_autopm:
> +	scsi_autopm_put_device(sdev);
> +
> +unlock_system_sleep:
>  	unlock_system_sleep();
>  }
>  EXPORT_SYMBOL(spi_dv_device);

Alan Stern
