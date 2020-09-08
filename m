Return-Path: <SRS0=d5MZ=CR=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C6F6EC43461
	for <linux-scsi@archiver.kernel.org>; Tue,  8 Sep 2020 01:47:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 863B72137B
	for <linux-scsi@archiver.kernel.org>; Tue,  8 Sep 2020 01:47:31 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="gOc3DDat"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728140AbgIHBra (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 7 Sep 2020 21:47:30 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:40772 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728113AbgIHBr3 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 7 Sep 2020 21:47:29 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1599529646;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=8hiCj61KJfeUl7LkibCfArDkGhNR0/4KrqJWXopzPs4=;
        b=gOc3DDat/vn50MiPRg6aYIMyKOX71bvpO+omW+aqnYsmRKe5Y01i66VZ0ii5EexK1UskTv
        Naf/U4sZUpN0D+ZCcum1hMPWMvTv045W8BumNfhD5yCgN6vgcAUeSvTdSgHMZ0XtfFr8ZS
        fvk2sQDVmIWnQMxx4DjDR9VSj5DOp60=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-507-cJpZMPPkPeKTRUH_nTysew-1; Mon, 07 Sep 2020 21:47:23 -0400
X-MC-Unique: cJpZMPPkPeKTRUH_nTysew-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 51FDA801AC2;
        Tue,  8 Sep 2020 01:47:21 +0000 (UTC)
Received: from T590 (ovpn-12-217.pek2.redhat.com [10.72.12.217])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id AE2B910013D7;
        Tue,  8 Sep 2020 01:47:12 +0000 (UTC)
Date:   Tue, 8 Sep 2020 09:47:08 +0800
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
Message-ID: <20200908014708.GA1091256@T590>
References: <20200907071048.1078838-1-ming.lei@redhat.com>
 <4da219e6-7c2b-b93b-c6d0-2e18aa8ce11f@acm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4da219e6-7c2b-b93b-c6d0-2e18aa8ce11f@acm.org>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, Sep 07, 2020 at 09:52:42AM -0700, Bart Van Assche wrote:
> On 2020-09-07 00:10, Ming Lei wrote:
> > diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
> > index 7affaaf8b98e..a05e431ee62a 100644
> > --- a/drivers/scsi/scsi_lib.c
> > +++ b/drivers/scsi/scsi_lib.c
> > @@ -551,8 +551,25 @@ static void scsi_run_queue_async(struct scsi_device *sdev)
> >  	if (scsi_target(sdev)->single_lun ||
> >  	    !list_empty(&sdev->host->starved_list))
> >  		kblockd_schedule_work(&sdev->requeue_work);
> > -	else
> > -		blk_mq_run_hw_queues(sdev->request_queue, true);
> > +	else {
> 
> Please follow the Linux kernel coding style and balance braces.

Could you provide one document about such style? The patch does pass
checkpatch, or I am happy to follow your suggestion if checkpatch is
updated to this way.

> 
> > +		/*
> > +		 * smp_mb() implied in either rq->end_io or blk_mq_free_request
> > +		 * is for ordering writing .device_busy in scsi_device_unbusy()
> > +		 * and reading sdev->restarts.
> > +		 */
> > +		int old = atomic_read(&sdev->restarts);
> 
> scsi_run_queue_async() has two callers: scsi_end_request() and scsi_queue_rq().
> I don't see how ordering between scsi_device_unbusy() and the above atomic_read()
> could be guaranteed if this function is called from scsi_queue_rq()?
> 
> Regarding the I/O completion path, my understanding is that the I/O completion
> path is as follows if rq->end_io == NULL:
> 
> scsi_mq_done()
>   blk_mq_complete_request()
>     rq->q->mq_ops->complete(rq) = scsi_softirq_done
>       scsi_finish_command()
>         scsi_device_unbusy()

scsi_device_unbusy()
	atomic_dec(&sdev->device_busy);

>         scsi_cmd_to_driver(cmd)->done(cmd)
>         scsi_io_completion()
>           scsi_end_request()
>             blk_update_request()
>             scsi_mq_uninit_cmd()
>             __blk_mq_end_request()
>               blk_mq_free_request()
>                 __blk_mq_free_request()

__blk_mq_free_request()
	blk_mq_put_tag
		smp_mb__after_atomic()

>                   blk_queue_exit()
>             scsi_run_queue_async()
> 
> I haven't found any store memory barrier between the .device_busy change in
> scsi_device_unbusy() and the scsi_run_queue_async() call? Did I perhaps overlook
> something?
> 
> > +		/*
> > +		 * ->restarts has to be kept as non-zero if there new budget
> > +		 *  contention comes.
> 
> Please fix the grammar in the above sentence.

OK.

> 
> > +	/*
> > +	 * Order writing .restarts and reading .device_busy. Its pair is
> > +	 * implied by __blk_mq_end_request() in scsi_end_request() for
> > +	 * ordering writing .device_busy in scsi_device_unbusy() and
> > +	 * reading .restarts.
> > +	 */
> > +	smp_mb__after_atomic();
> 
> What does "its pair is implied" mean? Please make the above comment
> unambiguous.

See comment in scsi_run_queue_async().

> 
> > +	/*
> > +	 * If all in-flight requests originated from this LUN are completed
> > +	 * before setting .restarts, sdev->device_busy will be observed as
> > +	 * zero, then blk_mq_delay_run_hw_queues() will dispatch this request
> > +	 * soon. Otherwise, completion of one of these request will observe
> > +	 * the .restarts flag, and the request queue will be run for handling
> > +	 * this request, see scsi_end_request().
> > +	 */
> > +	if (unlikely(atomic_read(&sdev->device_busy) == 0 &&
> > +				!scsi_device_blocked(sdev)))
> > +		blk_mq_delay_run_hw_queues(sdev->request_queue, SCSI_QUEUE_DELAY);
> > +	return false;
> 
> What will happen if all in-flight requests complete after
> scsi_run_queue_async() has read .restarts and before it executes
> atomic_cmpxchg()?

One of these completions will run atomic_cmpxchg() successfully, and the
queue is re-run immediately from scsi_run_queue_async().

> Will that cause the queue to be run after a delay
> although it should be run immediately?

Yeah, blk_mq_delay_run_hw_queues() will be called, however:

If scsi_run_queue_async() has scheduled run queue already, this code path
won't queue a dwork successfully. On the other hand, if
blk_mq_delay_run_hw_queues(SCSI_QUEUE_DELAY) has queued a dwork,
scsi_run_queue_async() still can queue the dwork successfully, since the delay
timer can be deactivated easily, see try_to_grab_pending(). In short, the case
you described is an extremely unlikely event. Even though it happens,
forward progress is still guaranteed.


Thanks,
Ming

