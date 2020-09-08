Return-Path: <SRS0=d5MZ=CR=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 51072C433E2
	for <linux-scsi@archiver.kernel.org>; Tue,  8 Sep 2020 10:02:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 16823215A4
	for <linux-scsi@archiver.kernel.org>; Tue,  8 Sep 2020 10:02:06 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="OUYxi5F8"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729057AbgIHKCG (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 8 Sep 2020 06:02:06 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:30095 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728828AbgIHKB7 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 8 Sep 2020 06:01:59 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1599559317;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=qbdadZHl4nAOXpeHcT7xreFsFuB8tAcppftKTd69eHA=;
        b=OUYxi5F8yZ1W9sMQXipOnojDZPPi39BYW8CXm9lbkDkVIchBFAx4SIxyyIPwgsAL6nxmU5
        3S09eazANA7nNeKAx8vUj2ktF8SSWxZTkZNYxc9CHbZ31brQUEJe7rLx65E80wVf9ioZA5
        ZryCg5piz07z+0eLusSguaoCwF6xbr8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-287-RWoqErYkO6GWc-jGPYLetw-1; Tue, 08 Sep 2020 06:01:55 -0400
X-MC-Unique: RWoqErYkO6GWc-jGPYLetw-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 26A8580EDA1;
        Tue,  8 Sep 2020 10:01:54 +0000 (UTC)
Received: from T590 (ovpn-12-217.pek2.redhat.com [10.72.12.217])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 88C3E1002388;
        Tue,  8 Sep 2020 10:01:46 +0000 (UTC)
Date:   Tue, 8 Sep 2020 18:01:39 +0800
From:   Ming Lei <ming.lei@redhat.com>
To:     Bart Van Assche <bvanassche@acm.org>
Cc:     James Bottomley <James.Bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        "Ewan D . Milne" <emilne@redhat.com>,
        Kashyap Desai <kashyap.desai@broadcom.com>,
        Hannes Reinecke <hare@suse.de>, Long Li <longli@microsoft.com>,
        John Garry <john.garry@huawei.com>, linux-block@vger.kernel.org
Subject: Re: [PATCH V5] scsi: core: only re-run queue in scsi_end_request()
 if device queue is busy
Message-ID: <20200908100139.GB1094743@T590>
References: <20200907071048.1078838-1-ming.lei@redhat.com>
 <4da219e6-7c2b-b93b-c6d0-2e18aa8ce11f@acm.org>
 <20200908014708.GA1091256@T590>
 <a51b0af4-219c-4cfc-f224-0cfff3d07ec3@acm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a51b0af4-219c-4cfc-f224-0cfff3d07ec3@acm.org>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, Sep 07, 2020 at 08:45:32PM -0700, Bart Van Assche wrote:
> On 2020-09-07 18:47, Ming Lei wrote:
> > On Mon, Sep 07, 2020 at 09:52:42AM -0700, Bart Van Assche wrote:
> >> On 2020-09-07 00:10, Ming Lei wrote:
> >>> diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
> >>> index 7affaaf8b98e..a05e431ee62a 100644
> >>> --- a/drivers/scsi/scsi_lib.c
> >>> +++ b/drivers/scsi/scsi_lib.c
> >>> @@ -551,8 +551,25 @@ static void scsi_run_queue_async(struct scsi_device *sdev)
> >>>  	if (scsi_target(sdev)->single_lun ||
> >>>  	    !list_empty(&sdev->host->starved_list))
> >>>  		kblockd_schedule_work(&sdev->requeue_work);
> >>> -	else
> >>> -		blk_mq_run_hw_queues(sdev->request_queue, true);
> >>> +	else {
> >>
> >> Please follow the Linux kernel coding style and balance braces.
> > 
> > Could you provide one document about such style? The patch does pass
> > checkpatch, or I am happy to follow your suggestion if checkpatch is
> > updated to this way.
> 
> Apparently the checkpatch script only warns about unbalanced braces with the
> option --strict. From commit e4c5babd32f9 ("checkpatch: notice unbalanced
> else braces in a patch") # v4.11:
> 
>     checkpatch: notice unbalanced else braces in a patch
> 
>     Patches that add or modify code like
> 
>             } else
>                     <foo>
>     or
>             else {
>                     <bar>
> 
>     where one branch appears to have a brace and the other branch does not
>     have a brace should emit a --strict style message.
> 
> [ ... ]
> 
> +# check for single line unbalanced braces
> +		if ($sline =~ /.\s*\}\s*else\s*$/ ||
> +		    $sline =~ /.\s*else\s*\{\s*$/) {
> +			CHK("BRACES", "Unbalanced braces around else statement\n" . $herecurr);
> +		}
> +
> 
> Anyway, I think the following output makes it clear that there are many more
> balanced than non-balanced else statements:
> 
> $ git grep -c "} else {" | awk 'BEGIN {FS=":"} {total+=$2} END {print total}'
> 66944
> $ git grep -Ec "$(printf "\t")else \{|\} else$" | awk 'BEGIN {FS=":"} {total+=$2} END {print total}'
> 12289

OK, looks it is still not something which must be obeyed, but I do not
want to waste time on this thing, so will switch to balanced brace.

> 
> >>> +		/*
> >>> +		 * smp_mb() implied in either rq->end_io or blk_mq_free_request
> >>> +		 * is for ordering writing .device_busy in scsi_device_unbusy()
> >>> +		 * and reading sdev->restarts.
> >>> +		 */
> >>> +		int old = atomic_read(&sdev->restarts);
> >>
> >> scsi_run_queue_async() has two callers: scsi_end_request() and scsi_queue_rq().
> >> I don't see how ordering between scsi_device_unbusy() and the above atomic_read()
> >> could be guaranteed if this function is called from scsi_queue_rq()?
> >>
> >> Regarding the I/O completion path, my understanding is that the I/O completion
> >> path is as follows if rq->end_io == NULL:
> >>
> >> scsi_mq_done()
> >>   blk_mq_complete_request()
> >>     rq->q->mq_ops->complete(rq) = scsi_softirq_done
> >>       scsi_finish_command()
> >>         scsi_device_unbusy()
> > 
> > scsi_device_unbusy()
> > 	atomic_dec(&sdev->device_busy);
> > 
> >>         scsi_cmd_to_driver(cmd)->done(cmd)
> >>         scsi_io_completion()
> >>           scsi_end_request()
> >>             blk_update_request()
> >>             scsi_mq_uninit_cmd()
> >>             __blk_mq_end_request()
> >>               blk_mq_free_request()
> >>                 __blk_mq_free_request()
> > 
> > __blk_mq_free_request()
> > 	blk_mq_put_tag
> > 		smp_mb__after_atomic()
> > 
> 
> Thanks for the clarification. How about changing the text "implied in either
> rq->end_io or blk_mq_free_request" into "present in sbitmap_queue_clear()"
> such that the person who reads the comment does not have to look up where
> the barrier occurs?

Fine.

> >>
> >>> +	/*
> >>> +	 * Order writing .restarts and reading .device_busy. Its pair is
> >>> +	 * implied by __blk_mq_end_request() in scsi_end_request() for
> >>> +	 * ordering writing .device_busy in scsi_device_unbusy() and
> >>> +	 * reading .restarts.
> >>> +	 */
> >>> +	smp_mb__after_atomic();
> >>
> >> What does "its pair is implied" mean? Please make the above comment
> >> unambiguous.
> > 
> > See comment in scsi_run_queue_async().
> 
> How about making the above comment more by changing it into the following?
> /*
>  * Orders atomic_inc(&sdev->restarts) and atomic_read(&sdev->device_busy).
>  * .restarts must be incremented before .device_busy is read because the code
>  * in scsi_run_queue_async() depends on the order of these operations.
>  */

OK.

> 
> >> Will that cause the queue to be run after a delay
> >> although it should be run immediately?
> > 
> > Yeah, blk_mq_delay_run_hw_queues() will be called, however:
> > 
> > If scsi_run_queue_async() has scheduled run queue already, this code path
> > won't queue a dwork successfully. On the other hand, if
> > blk_mq_delay_run_hw_queues(SCSI_QUEUE_DELAY) has queued a dwork,
> > scsi_run_queue_async() still can queue the dwork successfully, since the delay
> > timer can be deactivated easily, see try_to_grab_pending(). In short, the case
> > you described is an extremely unlikely event. Even though it happens,
> > forward progress is still guaranteed.
> 
> I think I would sleep better if that race would be fixed. I'm concerned

blk-mq has several similar handling, see delay run queue in the following functions:

	__blk_mq_do_dispatch_sched()
	blk_mq_do_dispatch_ctx()
	blk_mq_dispatch_rq_list()

> that sooner or later someone will run a workload that triggers that scenario
> systematically ...

After taking a close look at mod_delayed_work_on() & try_to_grab_pending(), I
think there isn't such issue you are worrying about.

mod_delayed_work_on() calls try_to_grab_pending() in the following way:

        do {
                ret = try_to_grab_pending(&dwork->work, true, &flags);
        } while (unlikely(ret == -EAGAIN));

The only two negative return values from try_to_grab_pending are -EAGAIN
and -ENOENT.

Both blk_mq_run_hw_queues()(called from scsi_run_queue_async) and
blk_mq_delay_run_hw_queues()(called from scsi_mq_get_budget) calls
mod_delayed_work_on() finally via kblockd_mod_delayed_work_on().

Both two calls of mod_delayed_work_on() will call __queue_delayed_work()
finally. blk_mq_run_hw_queues() will call __queue_work() to queue
the work immediately because delay is zero, blk_mq_delay_run_hw_queues()
just calls add_timer() to schedule a timer for running __queue_work()
because the delay is 3ms.

So blk_mq_delay_run_hw_queues() will _not_ cause a delay run queue.

Thanks,
Ming

