Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 90C6FC433ED
	for <linux-scsi@archiver.kernel.org>; Mon, 26 Apr 2021 23:59:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 657F66113D
	for <linux-scsi@archiver.kernel.org>; Mon, 26 Apr 2021 23:59:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235224AbhDZX77 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 26 Apr 2021 19:59:59 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:20350 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235392AbhDZX76 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 26 Apr 2021 19:59:58 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1619481555;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=b3cF+pS/mZsuqO7vvgN0TXnQDB9Cd3N+SkueR7G1oCQ=;
        b=QG2tLDM6097CNP1LjHuLxTAo0sSS/f1RkoyraS1hZK03r5RQYhOlR5CvatMp+qYz2JtYSh
        joTyOFUgI0xWWHQnNMAhLXtiMARae4cHnjHMJSNJr/ipt5OiTpZ6/GeAZHhH1Z211fwjQ9
        tMeVQbUFg61RrV36nwD7EFR7aVRX/Jc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-97-7EfImAquOvmGr0vHzeIuEQ-1; Mon, 26 Apr 2021 19:59:11 -0400
X-MC-Unique: 7EfImAquOvmGr0vHzeIuEQ-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 0AD3510073AC;
        Mon, 26 Apr 2021 23:59:10 +0000 (UTC)
Received: from T590 (ovpn-12-63.pek2.redhat.com [10.72.12.63])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 17A8F69FB4;
        Mon, 26 Apr 2021 23:59:01 +0000 (UTC)
Date:   Tue, 27 Apr 2021 07:59:07 +0800
From:   Ming Lei <ming.lei@redhat.com>
To:     John Garry <john.garry@huawei.com>
Cc:     Kashyap Desai <kashyap.desai@broadcom.com>,
        linux-block@vger.kernel.org, linux-scsi@vger.kernel.org,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Jens Axboe <axboe@kernel.dk>,
        Douglas Gilbert <dgilbert@interlog.com>,
        Hannes Reinecke <hare@suse.com>
Subject: Re: [bug report] shared tags causes IO hang and performance drop
Message-ID: <YIdTyyVE5azlYwtO@T590>
References: <cb326d404c6e0785d03a7dfadc42832c@mail.gmail.com>
 <YHbOOfGNHwO4SMS7@T590>
 <87ceccf2-287b-9bd1-899a-f15026c9e65b@huawei.com>
 <YHe3M62agQET6o6O@T590>
 <0c85fe52-ebc7-68b3-2dbe-dfad5d604346@huawei.com>
 <c1d5abaa-c460-55f8-5351-16f09d6aa81f@huawei.com>
 <YIbS1dgSYrsAeGvZ@T590>
 <55743a51-4d6f-f481-cebf-e2af9c657911@huawei.com>
 <YIbkX2G0+dp3PV+u@T590>
 <9ad15067-ba7b-a335-ae71-8c4328856b91@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9ad15067-ba7b-a335-ae71-8c4328856b91@huawei.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, Apr 26, 2021 at 06:02:31PM +0100, John Garry wrote:
> On 26/04/2021 17:03, Ming Lei wrote:
> > > For both hostwide and non-hostwide tags, we have standalone sched tags and
> > > request pool per hctx when q->nr_hw_queues > 1.
> > driver tags is shared for hostwide tags.
> > 
> > > > That is why you observe that scheduler tag exhaustion
> > > > is easy to trigger in case of non-hostwide tags.
> > > > 
> > > > I'd suggest to add one per-request-queue sched tags, and make all hctxs
> > > > sharing it, just like what you did for driver tag.
> > > > 
> > > That sounds reasonable.
> > > 
> > > But I don't see how this is related to hostwide tags specifically, but
> > > rather just having q->nr_hw_queues > 1, which NVMe PCI and some other SCSI
> > > MQ HBAs have (without using hostwide tags).
> > Before hostwide tags, the whole scheduler queue depth should be 256.
> > After hostwide tags, the whole scheduler queue depth becomes 256 *
> > nr_hw_queues. But the driver tag queue depth is_not_  changed.
> 
> Fine.
> 
> > 
> > More requests come and are tried to dispatch to LLD and can't succeed
> > because of limited driver tag depth, and CPU utilization could be increased.
> 
> Right, maybe this is a problem.
> 
> I quickly added some debug, and see that
> __blk_mq_get_driver_tag()->__sbitmap_queue_get() fails ~7% for hostwide tags
> and 3% for non-hostwide tags.
> 
> Having it fail at all for non-hostwide tags seems a bit dubious... here's
> the code for deciding the rq sched tag depth:
> 
> q->nr_requests = 2 * min(q->tags_set->queue_depth [128], BLK_DEV_MAX_RQ
> [128])
> 
> So we get 256 for our test scenario, which is appreciably bigger than
> q->tags_set->queue_depth, so the failures make sense.
> 
> Anyway, I'll look at adding code for a per-request queue sched tags to see
> if it helps. But I would plan to continue to use a per hctx sched request
> pool.

Why not switch to per hctx sched request pool?

Thanks,
Ming

