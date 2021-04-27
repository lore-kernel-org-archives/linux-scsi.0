Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 07F61C433ED
	for <linux-scsi@archiver.kernel.org>; Tue, 27 Apr 2021 00:12:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B782E60FE3
	for <linux-scsi@archiver.kernel.org>; Tue, 27 Apr 2021 00:12:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234084AbhD0AMw (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 26 Apr 2021 20:12:52 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:60176 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232022AbhD0AMv (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 26 Apr 2021 20:12:51 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1619482328;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=BCSdzykF8dlP5rp3rz+oohTLQeWc1Ih0ko80QMy0sl4=;
        b=Fz1+Zpn5mdTYXNgBfVN8VRFmZ3Ango9nicRxmMqMmUE9GaH4VGURYliDCKgFioWVgMcpng
        hgJefmvKU2u+3gzIyCPXDXf3lwrFRxXKQawMUb9XywF3PwOOsBj2OtFUrszUiUCnyssX/E
        ldT4T821geLlecRS9FiyLP1GkqDvsoU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-205-vkx-jId1P3W5Jz2illC8yA-1; Mon, 26 Apr 2021 20:12:05 -0400
X-MC-Unique: vkx-jId1P3W5Jz2illC8yA-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 7B8EC107ACE4;
        Tue, 27 Apr 2021 00:12:03 +0000 (UTC)
Received: from T590 (ovpn-12-63.pek2.redhat.com [10.72.12.63])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 83E4F9F64;
        Tue, 27 Apr 2021 00:11:53 +0000 (UTC)
Date:   Tue, 27 Apr 2021 08:11:59 +0800
From:   Ming Lei <ming.lei@redhat.com>
To:     Bart Van Assche <bvanassche@acm.org>
Cc:     Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org,
        Christoph Hellwig <hch@lst.de>,
        Daniel Wagner <dwagner@suse.de>,
        Khazhismel Kumykov <khazhy@google.com>,
        Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Hannes Reinecke <hare@suse.de>,
        Johannes Thumshirn <johannes.thumshirn@wdc.com>,
        John Garry <john.garry@huawei.com>, linux-scsi@vger.kernel.org
Subject: Re: [PATCH v7 3/5] blk-mq: Fix races between iterating over requests
 and freeing requests
Message-ID: <YIdWz8C5eklPvEiV@T590>
References: <20210421000235.2028-1-bvanassche@acm.org>
 <20210421000235.2028-4-bvanassche@acm.org>
 <YIDqa6YkNoD5OiKN@T590>
 <b717ffc0-a434-738f-9c63-32901bd164b2@acm.org>
 <YIEiElb9wxReV/oL@T590>
 <32a121b7-2444-ac19-420d-4961f2a18129@acm.org>
 <YIJEg9DLWoOJ06Kc@T590>
 <28607d75-042f-7a6a-f5d0-2ee03754917e@acm.org>
 <YISzLal7Ur7jyuiy@T590>
 <d1d3c068-4446-145b-34c6-12fa1f30d4da@acm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d1d3c068-4446-145b-34c6-12fa1f30d4da@acm.org>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, Apr 26, 2021 at 09:29:54AM -0700, Bart Van Assche wrote:
> On 4/24/21 5:09 PM, Ming Lei wrote:
> > Terminating all pending commands can't avoid the issue wrt. request UAF,
> > so far blk_mq_tagset_wait_completed_request() is used for making sure
> > that all pending requests are really aborted.
> > 
> > However, blk_mq_wait_for_tag_iter() still may return before
> > blk_mq_wait_for_tag_iter() is done because blk_mq_wait_for_tag_iter()
> > supposes all request reference is just done inside bt_tags_iter(),
> > especially .iter_rwsem and read rcu lock is added in bt_tags_iter().
> 
> Hi Ming,
> 
> I think that we agree that completing a request from inside a tag
> iteration callback function may cause the request completion to happen
> after tag iteration has finished. This can happen because
> blk_mq_complete_request() may redirect completion processing to another
> CPU via an IPI.
> 
> But can this mechanism trigger a use-after-free by itself? If request
> completion is redirected to another CPU, the request is still considered
> pending and request queue freezing won't complete. Request queue
> freezing will only succeed after __blk_mq_free_request() has been called
> because it is __blk_mq_free_request() that calls blk_queue_exit().
> 
> In other words, do we really need the new
> blk_mq_complete_request_locally() function?
> 
> Did I perhaps miss something?

Please see the example in the following link:

https://lore.kernel.org/linux-block/20210421000235.2028-4-bvanassche@acm.org/T/#m4d7bc9aa01108f03d5b4b7ee102eb26eb0c778aa

In short:

1) One async completion from interrupt context is pending, and one request
isn't really freed yet because its driver tag isn't released.

2) Meantime iterating code still can visit this request, and ->fn() schedules
a new remote completion, and returns.

3) The scheduled async completion in 1) is really done now,
but the scheduled async completion in 2) isn't started or done yet

4) queue becomes frozen because of one pending elevator switching, so
sched request pool is freed since there isn't any pending iterator ->fn()

5) request UAF is caused when running the scheduled async completion in 2)
now.


Thanks,
Ming

