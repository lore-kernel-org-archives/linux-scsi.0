Return-Path: <SRS0=1vUj=CL=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2A109C433E7
	for <linux-scsi@archiver.kernel.org>; Wed,  2 Sep 2020 07:02:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 085252087D
	for <linux-scsi@archiver.kernel.org>; Wed,  2 Sep 2020 07:02:21 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="g9HwN39v"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726467AbgIBHCU (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 2 Sep 2020 03:02:20 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:22941 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726130AbgIBHCR (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 2 Sep 2020 03:02:17 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1599030133;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=WuyrVPdjCUS9N2dJ5Cq4O023vSL+AzoSU8JYNbu18iA=;
        b=g9HwN39vOkNNm3az62/jbixrn4ffmCwbzNQ/8bm7F9ru1CEuFN5XEtz9unwxvgq+r4ZvK7
        OrxTswiZvaBAIq07UDsY8DY+e+O/5wE5LaIkmzR7flu6ZV2HlYDLIYkmMjjjfOj4AWxOjC
        Qlet8N3VwaYeWgUgdaN2kzlMqmRsi64=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-274-jB2cbp8mNdixDsdDzZcL-g-1; Wed, 02 Sep 2020 03:02:11 -0400
X-MC-Unique: jB2cbp8mNdixDsdDzZcL-g-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 159591005E5C;
        Wed,  2 Sep 2020 07:02:10 +0000 (UTC)
Received: from T590 (ovpn-12-189.pek2.redhat.com [10.72.12.189])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 338335D9CC;
        Wed,  2 Sep 2020 07:01:59 +0000 (UTC)
Date:   Wed, 2 Sep 2020 15:01:55 +0800
From:   Ming Lei <ming.lei@redhat.com>
To:     Bart Van Assche <bvanassche@acm.org>
Cc:     James Bottomley <James.Bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        "Ewan D . Milne" <emilne@redhat.com>,
        Kashyap Desai <kashyap.desai@broadcom.com>,
        Hannes Reinecke <hare@suse.de>, Long Li <longli@microsoft.com>,
        John Garry <john.garry@huawei.com>, linux-block@vger.kernel.org
Subject: Re: [PATCH V4] scsi: core: only re-run queue in scsi_end_request()
 if device queue is busy
Message-ID: <20200902070155.GD317674@T590>
References: <20200817100840.2496976-1-ming.lei@redhat.com>
 <93faff01-daf7-4805-edc6-9101495686ce@acm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <93faff01-daf7-4805-edc6-9101495686ce@acm.org>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, Sep 01, 2020 at 07:40:54PM -0700, Bart Van Assche wrote:
> On 2020-08-17 03:08, Ming Lei wrote:
> > diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
> > index 7c6dd6f75190..a62c29058d26 100644
> > --- a/drivers/scsi/scsi_lib.c
> > +++ b/drivers/scsi/scsi_lib.c
> > @@ -551,8 +551,27 @@ static void scsi_run_queue_async(struct scsi_device *sdev)
> >  	if (scsi_target(sdev)->single_lun ||
> >  	    !list_empty(&sdev->host->starved_list))
> >  		kblockd_schedule_work(&sdev->requeue_work);
> > -	else
> > -		blk_mq_run_hw_queues(sdev->request_queue, true);
> > +	else {
> 
> Has this patch been verified with checkpatch? Checkpatch should have warned
> about the unbalanced braces.

[linux]$ ./scripts/checkpatch.pl -g HEAD
total: 0 errors, 0 warnings, 71 lines checked

Commit 0cbe51645b54 ("scsi: core: only re-run queue in scsi_end_request() if device queue is busy") has no obvious style problems and is ready for submission.

> 
> > +		/*
> > +		 * smp_mb() implied in either rq->end_io or blk_mq_free_request
> > +		 * is for ordering writing .device_busy in scsi_device_unbusy()
> > +		 * and reading sdev->restarts.
> > +		 */
> 
> Hmm ... I don't see what orders the atomic_dec(&sdev->device_busy) from
> scsi_device_unbusy() and the atomic_read() below? I don't think that the block
> layer guarantees ordering of these two memory accesses since both accesses
> happen in the request completion path.

__blk_mq_end_request() is called between scsi_device_unbusy() and
scsi_run_queue_async(). When __blk_mq_end_request() is called, this
request is actually ended really because SCMD_STATE_COMPLETE is covered
race between timeout and normal completion, so:

1) either __blk_mq_free_request() is called, smp_mb__after_atomic() is
implied in sbitmap_queue_clear() called from blk_mq_put_tag()

2) or rq->end_io() is called. We don't have too many ->end_io()
implemented. Either wake_up_process() or blk_mq_free_request() is called
in ->end_io(), so memory barrier is implied.

> 
> > +		int old = atomic_read(&sdev->restarts);
> > +
> > +		if (old) {
> > +			/*
> > +			 * ->restarts has to be kept as non-zero if there is
> > +			 *  new budget contention comes.
> 
> There are two verbs in the above sentence ("is" and "comes"). Please remove
> "comes" such that the sentence becomes grammatically correct.
> 
> > +			 *
> > +			 *  No need to run queue when either another re-run
> > +			 *  queue wins in updating ->restarts or one new budget
> > +			 *  contention comes.
> > +			 */
> > +			if (atomic_cmpxchg(&sdev->restarts, old, 0) == old)
> > +				blk_mq_run_hw_queues(sdev->request_queue, true);
> > +		}
> > +	}
> 
> Please combine the two if-statements into a single if-statement using "&&"
> to keep the indentation level low.
> 
> > @@ -1611,8 +1630,34 @@ static void scsi_mq_put_budget(struct request_queue *q)
> >  static bool scsi_mq_get_budget(struct request_queue *q)
> >  {
> >  	struct scsi_device *sdev = q->queuedata;
> > +	int ret = scsi_dev_queue_ready(q, sdev);
> > +
> > +	if (ret)
> > +		return true;
> > +
> > +	atomic_inc(&sdev->restarts);
> >  
> > -	return scsi_dev_queue_ready(q, sdev);
> > +	/*
> > +	 * Order writing .restarts and reading .device_busy, and make sure
> > +	 * .restarts is visible to scsi_end_request(). Its pair is implied by
> > +	 * __blk_mq_end_request() in scsi_end_request() for ordering
> > +	 * writing .device_busy in scsi_device_unbusy() and reading .restarts.
> > +	 *
> > +	 */
> > +	smp_mb__after_atomic();
> 
> Barriers do not guarantee "is visible to". Barriers enforce ordering of memory
> accesses performed by a certain CPU core. Did you perhaps mean that
> sdev->restarts must be incremented before the code below reads sdev->device busy?

Right, ->restart has to be incremented before reading sdev->device_busy.


Thanks, 
Ming

