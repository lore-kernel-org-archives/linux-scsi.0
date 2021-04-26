Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5B121C433B4
	for <linux-scsi@archiver.kernel.org>; Mon, 26 Apr 2021 00:42:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3907460FEE
	for <linux-scsi@archiver.kernel.org>; Mon, 26 Apr 2021 00:42:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231480AbhDZAml (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 25 Apr 2021 20:42:41 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:60668 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231247AbhDZAmk (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Sun, 25 Apr 2021 20:42:40 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1619397719;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=5ORXaELdusvpXv2pKAT8XVRpiy1Wq7qC5EdSGHfv2Oc=;
        b=XITrU96c0JY4tEfc1nlrGLtVStt6Bq0MOm4gg65KpvELNPa58WpIhvC27kaf/3tSDE/Wc2
        fYbalHEkYcOQ297njU394GoVXubu8sahA3tnMglcyWzS8DO99K/nq7A+W5RlqaGlzfhE54
        1hI9Q1KZ8BASSBlImifS7kI83GiXTpY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-434-VF_MbtitMnWIXyVVMnhjDg-1; Sun, 25 Apr 2021 20:41:58 -0400
X-MC-Unique: VF_MbtitMnWIXyVVMnhjDg-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id CD6E91006706;
        Mon, 26 Apr 2021 00:41:55 +0000 (UTC)
Received: from T590 (ovpn-12-48.pek2.redhat.com [10.72.12.48])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id C1A665D6BA;
        Mon, 26 Apr 2021 00:41:46 +0000 (UTC)
Date:   Mon, 26 Apr 2021 08:41:52 +0800
From:   Ming Lei <ming.lei@redhat.com>
To:     Bart Van Assche <bvanassche@acm.org>
Cc:     linux-nvme@lists.infradead.org, linux-scsi@vger.kernel.org,
        Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Christoph Hellwig <hch@lst.de>,
        Khazhy Kumykov <khazhy@google.com>,
        Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>,
        Hannes Reinecke <hare@suse.de>,
        John Garry <john.garry@huawei.com>,
        David Jeffery <djeffery@redhat.com>
Subject: Re: [PATCH 7/8] blk-mq: grab rq->refcount before calling ->fn in
 blk_mq_tagset_busy_iter
Message-ID: <YIYMUP2ZKLJZ3KoT@T590>
References: <20210425085753.2617424-1-ming.lei@redhat.com>
 <20210425085753.2617424-8-ming.lei@redhat.com>
 <6c0b0af9-ca71-d143-b1cc-384adfca5438@acm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6c0b0af9-ca71-d143-b1cc-384adfca5438@acm.org>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Sun, Apr 25, 2021 at 11:55:22AM -0700, Bart Van Assche wrote:
> On 4/25/21 1:57 AM, Ming Lei wrote:
> > However, still one request UAF not covered: refcount_inc_not_zero() may
> > read one freed request, and it will be handled in next patch.
> 
> This means that patch "blk-mq: clear stale request in tags->rq[] before
> freeing one request pool" should come before this patch.

It doesn't matter. This patch only can't avoid the UAF too, we need
to grab req->ref to prevent queue from being frozen.

> 
> > @@ -276,12 +277,15 @@ static bool bt_tags_iter(struct sbitmap *bitmap, unsigned int bitnr, void *data)
> >  		rq = tags->static_rqs[bitnr];
> >  	else
> >  		rq = tags->rqs[bitnr];
> > -	if (!rq)
> > +	if (!rq || !refcount_inc_not_zero(&rq->ref))
> >  		return true;
> >  	if ((iter_data->flags & BT_TAG_ITER_STARTED) &&
> >  	    !blk_mq_request_started(rq))
> > -		return true;
> > -	return iter_data->fn(rq, iter_data->data, reserved);
> > +		ret = true;
> > +	else
> > +		ret = iter_data->fn(rq, iter_data->data, reserved);
> > +	blk_mq_put_rq_ref(rq);
> > +	return ret;
> >  }
> 
> Even if patches 7/8 and 8/8 would be reordered, the above code
> introduces a new use-after-free, a use-after-free that is much worse
> than the UAF in kernel v5.11. The following sequence can be triggered by
> the above code:
> * bt_tags_iter() reads tags->rqs[bitnr] and stores the request pointer
> in the 'rq' variable.
> * Request 'rq' completes, tags->rqs[bitnr] is cleared and the memory
> that backs that request is freed.
> * The memory that backs 'rq' is used for another purpose and the request
> reference count becomes nonzero.

That means the 'rq' is re-allocated, and it becomes in-flight again.

> * bt_tags_iter() increments the request reference count and thereby
> corrupts memory.

No, When refcount_inc_not_zero() succeeds in bt_tags_iter(), no one can
free the request any more until ->fn() returns, why do you think memory
corrupts? This pattern isn't different with timeout's usage, is it?

If IO activity is allowed during iterating tagset requests, ->fn() and
in-flight IO can always be run concurrently. That is caller's
responsibility to handle the race. That is why you can see lots callers
do quiesce queues before calling blk_mq_tagset_busy_iter(), but
quiesce isn't required if ->fn() just READs request only.

Your patch or current in-tree code has same 'problem' too, if you think
it is a problem. Clearing ->rq[tag] or holding a lock before calling
->fn() can not avoid such thing, can it?

Finally it is a request walking in tagset wide, so it should be safe for
->fn to iterate over request in this way. The thing is just that req->tag may
become not same with 'bitnr' any more. We can handle it simply by checking
if 'req->tag == bitnr' in bt_tags_iter() after the req->ref is grabbed,
still not sure if it is absolutely necessary.


Thanks,
Ming

