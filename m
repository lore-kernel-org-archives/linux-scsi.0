Return-Path: <SRS0=JvOq=BQ=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 12AA2C433DF
	for <linux-scsi@archiver.kernel.org>; Thu,  6 Aug 2020 17:11:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 68CC623119
	for <linux-scsi@archiver.kernel.org>; Thu,  6 Aug 2020 17:11:46 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Fc820Ka6"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730134AbgHFRLP (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 6 Aug 2020 13:11:15 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:55156 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1730229AbgHFRKP (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 6 Aug 2020 13:10:15 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1596733813;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=cl9dqFTVPcEMBvYqHZhhtle9pFIJZ5lHoW6WicsKYD8=;
        b=Fc820Ka63cB3PdJsPB1OxoApUWMwQxLAa3YoxdHvlo0jXaojQKjMv2dW0lrPta7AHUwZza
        /ShWW00WxWHS0Ip9rNImYGsdkp/xVYLywLqILrw5V7FWZOiQepoyX7/A8gV5mlKBECPRp1
        QVDe7i2OFjox9cpEHi2g6y9NomZyIDs=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-159-jL2iVwcbM8qIB6ugPhwK4A-1; Thu, 06 Aug 2020 09:38:37 -0400
X-MC-Unique: jL2iVwcbM8qIB6ugPhwK4A-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 1A6A5800470;
        Thu,  6 Aug 2020 13:38:35 +0000 (UTC)
Received: from T590 (ovpn-13-169.pek2.redhat.com [10.72.13.169])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 2C3DB5F1EF;
        Thu,  6 Aug 2020 13:38:23 +0000 (UTC)
Date:   Thu, 6 Aug 2020 21:38:19 +0800
From:   Ming Lei <ming.lei@redhat.com>
To:     Kashyap Desai <kashyap.desai@broadcom.com>
Cc:     John Garry <john.garry@huawei.com>, axboe@kernel.dk,
        jejb@linux.ibm.com, martin.petersen@oracle.com,
        don.brace@microsemi.com, Sumit Saxena <sumit.saxena@broadcom.com>,
        bvanassche@acm.org, hare@suse.com, hch@lst.de,
        Shivasharan Srikanteshwara 
        <shivasharan.srikanteshwara@broadcom.com>,
        linux-block@vger.kernel.org, linux-scsi@vger.kernel.org,
        esc.storagedev@microsemi.com, chenxiang66@hisilicon.com,
        "PDL,MEGARAIDLINUX" <megaraidlinux.pdl@broadcom.com>
Subject: Re: [PATCH RFC v7 10/12] megaraid_sas: switch fusion adapters to MQ
Message-ID: <20200806133819.GA2046861@T590>
References: <20200724024704.GB957464@T590>
 <6531e06c-9ce2-73e6-46fc-8e97400f07b2@huawei.com>
 <20200728084511.GA1326626@T590>
 <965cf22eea98c00618570da8424d0d94@mail.gmail.com>
 <20200729153648.GA1698748@T590>
 <7f94eaf2318cc26ceb64bde88d59d5e2@mail.gmail.com>
 <20200804083625.GA1958244@T590>
 <afe5eb1be7f416a48d7b5d473f3053d0@mail.gmail.com>
 <20200805084031.GA1995289@T590>
 <5adffdf805179428bdd0dd6c293a4f7d@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5adffdf805179428bdd0dd6c293a4f7d@mail.gmail.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, Aug 06, 2020 at 03:55:50PM +0530, Kashyap Desai wrote:
> > > Ming -
> > >
> > > I noted your comments.
> > >
> > > I have completed testing and this particular latest performance issue
> > > on Volume is outstanding.
> > > Currently it is 20-25% performance drop in IOPs and we want that to be
> > > closed before shared host tag is enabled for <megaraid_sas> driver.
> > > Just for my understanding - What will be the next steps on this ?
> > >
> > > I can validate any new approach/patch for this issue.
> > >
> >
> > Hello,
> >
> > What do you think of the following patch?
> 
> I tested this patch. I still see IO hang.
> 
> >
> > diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c index
> > c866a4f33871..49f0fc5c7a63 100644
> > --- a/drivers/scsi/scsi_lib.c
> > +++ b/drivers/scsi/scsi_lib.c
> > @@ -552,8 +552,24 @@ static void scsi_run_queue_async(struct scsi_device
> > *sdev)
> >  	if (scsi_target(sdev)->single_lun ||
> >  	    !list_empty(&sdev->host->starved_list))
> >  		kblockd_schedule_work(&sdev->requeue_work);
> > -	else
> > -		blk_mq_run_hw_queues(sdev->request_queue, true);
> > +	else {
> > +		/*
> > +		 * smp_mb() implied in either rq->end_io or
> > blk_mq_free_request
> > +		 * is for ordering writing .device_busy in
> scsi_device_unbusy()
> > +		 * and reading sdev->restarts.
> > +		 */
> > +		int old = atomic_read(&sdev->restarts);
> > +
> > +		if (old) {
> > +			blk_mq_run_hw_queues(sdev->request_queue, true);
> > +
> > +			/*
> > +			 * ->restarts has to be kept as non-zero if there
> is
> > +			 *  new budget contention comes.
> > +			 */
> > +			atomic_cmpxchg(&sdev->restarts, old, 0);
> > +		}
> > +	}
> >  }
> >
> >  /* Returns false when no more bytes to process, true if there are more
> */
> > @@ -1612,8 +1628,34 @@ static void scsi_mq_put_budget(struct
> > request_queue *q)  static bool scsi_mq_get_budget(struct request_queue
> *q)
> > {
> >  	struct scsi_device *sdev = q->queuedata;
> > +	int ret = scsi_dev_queue_ready(q, sdev);
> >
> > -	return scsi_dev_queue_ready(q, sdev);
> > +	if (ret)
> > +		return true;
> > +
> > +	/*
> > +	 * If all in-flight requests originated from this LUN are
> completed
> > +	 * before setting .restarts, sdev->device_busy will be observed as
> > +	 * zero, then blk_mq_delay_run_hw_queue() will dispatch this
> request
> > +	 * soon. Otherwise, completion of one of these request will
> observe
> > +	 * the .restarts flag, and the request queue will be run for
> handling
> > +	 * this request, see scsi_end_request().
> > +	 */
> > +	atomic_inc(&sdev->restarts);
> > +
> > +	/*
> > +	 * Order writing .restarts and reading .device_busy, and make sure
> > +	 * .restarts is visible to scsi_end_request(). Its pair is implied
> by
> > +	 * __blk_mq_end_request() in scsi_end_request() for ordering
> > +	 * writing .device_busy in scsi_device_unbusy() and reading
> .restarts.
> > +	 *
> > +	 */
> > +	smp_mb__after_atomic();
> > +
> > +	if (unlikely(atomic_read(&sdev->device_busy) == 0 &&
> > +				!scsi_device_blocked(sdev)))
> > +		blk_mq_delay_run_hw_queues(sdev->request_queue,
> > SCSI_QUEUE_DELAY);
> 
> Hi Ming -
> 
> There is still some race which is not handled.  Take a case of IO is not
> able to get budget and it has already marked <restarts> flag.
> <restarts> flag will be seen non-zero in completion path and completion
> path will attempt h/w queue run. (But this particular IO is still not in
> s/w queue.).
> Attempt of running h/w queue from completion path will not flush any IO
> since there is no IO in s/w queue.

Then where is the IO to be submitted in case of running out of budget?

Any IO request which is going to be added to hctx->dispatch, the queue will be
re-run via blk-mq core.

Any IO request being issued directly when running out of budget will be
insert to hctx->dispatch or sw/scheduler queue, will be run in the
submission path.


Thanks, 
Ming

