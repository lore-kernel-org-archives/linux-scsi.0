Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 52B07C43460
	for <linux-scsi@archiver.kernel.org>; Tue, 27 Apr 2021 09:53:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 154B2613C3
	for <linux-scsi@archiver.kernel.org>; Tue, 27 Apr 2021 09:53:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235435AbhD0JyB (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 27 Apr 2021 05:54:01 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:52899 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235303AbhD0Jxs (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 27 Apr 2021 05:53:48 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1619517184;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=m5+c/+BZ4gIa5hUEWa4KddJnHEAW8qm6OVHAdVDDGUE=;
        b=GYRVd48Ab2JZ4M1NCc7XTlpOEXhrrmsavMFKo1DLVa2Iar164lfRmZu1qosE5LXb64SxPd
        VU1WBkuITr8dw2ws028Ue0Vx+fEvGc6h4Df8MYNVZOIKBEplc0XKuM8Xg+HAgHHsozXEC2
        kc6u2e2RxTHVKHGY3a/PhzGNLNnB5xY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-552-CX21mRDHPRC0STOasSqEuQ-1; Tue, 27 Apr 2021 05:52:59 -0400
X-MC-Unique: CX21mRDHPRC0STOasSqEuQ-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 9ABEE501E0;
        Tue, 27 Apr 2021 09:52:58 +0000 (UTC)
Received: from T590 (ovpn-13-248.pek2.redhat.com [10.72.13.248])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 1D33F19704;
        Tue, 27 Apr 2021 09:52:50 +0000 (UTC)
Date:   Tue, 27 Apr 2021 17:52:58 +0800
From:   Ming Lei <ming.lei@redhat.com>
To:     John Garry <john.garry@huawei.com>
Cc:     Kashyap Desai <kashyap.desai@broadcom.com>,
        linux-block@vger.kernel.org, linux-scsi@vger.kernel.org,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Jens Axboe <axboe@kernel.dk>,
        Douglas Gilbert <dgilbert@interlog.com>,
        Hannes Reinecke <hare@suse.com>
Subject: Re: [bug report] shared tags causes IO hang and performance drop
Message-ID: <YIfe+mpcV17XsHuL@T590>
References: <0c85fe52-ebc7-68b3-2dbe-dfad5d604346@huawei.com>
 <c1d5abaa-c460-55f8-5351-16f09d6aa81f@huawei.com>
 <YIbS1dgSYrsAeGvZ@T590>
 <55743a51-4d6f-f481-cebf-e2af9c657911@huawei.com>
 <YIbkX2G0+dp3PV+u@T590>
 <9ad15067-ba7b-a335-ae71-8c4328856b91@huawei.com>
 <YIdTyyVE5azlYwtO@T590>
 <ab83eec4-20f1-ad74-7f43-52a4a87a8aa9@huawei.com>
 <YIfVVRheF9ZWjzbh@T590>
 <cb81d990-e5a6-49b1-5d96-8079a80c73f5@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cb81d990-e5a6-49b1-5d96-8079a80c73f5@huawei.com>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, Apr 27, 2021 at 10:37:39AM +0100, John Garry wrote:
> On 27/04/2021 10:11, Ming Lei wrote:
> > On Tue, Apr 27, 2021 at 08:52:53AM +0100, John Garry wrote:
> > > On 27/04/2021 00:59, Ming Lei wrote:
> > > > > Anyway, I'll look at adding code for a per-request queue sched tags to see
> > > > > if it helps. But I would plan to continue to use a per hctx sched request
> > > > > pool.
> > > > Why not switch to per hctx sched request pool?
> > > I don't understand. The current code uses a per-hctx sched request pool, and
> > > I said that I don't plan to change that.
> > I forget why you didn't do that, because for hostwide tags, request
> > is always 1:1 for either sched tags(real io sched) or driver tags(none).
> > 
> > Maybe you want to keep request local to hctx, but never see related
> > performance data for supporting the point, sbitmap queue allocator has
> > been intelligent enough to allocate tag freed from native cpu.
> > 
> > Then you just waste lots of memory, I remember that scsi request payload
> > is a bit big.
> 
> It's true that we waste much memory for regular static requests for when
> using hostwide tags today.
> 
> One problem in trying to use a single set of "hostwide" static requests is
> that we call blk_mq_init_request(..., hctx_idx, ...) ->
> set->ops->init_request(.., hctx_idx, ...) for each static rq, and this would
> not work for a single set of "hostwide" requests.
> 
> And I see a similar problem for a "request queue-wide" sched static
> requests.
> 
> Maybe we can improve this in future.

OK, fair enough.

> 
> BTW, for the performance issue which Yanhui witnessed with megaraid sas, do
> you think it may because of the IO sched tags issue of total sched tag depth
> growing vs driver tags?

I think it is highly possible. Will you work a patch to convert to
per-request-queue sched tag?

> Are there lots of LUNs? I can imagine that megaraid
> sas has much larger can_queue than scsi_debug :)

No, there are just two LUNs, the 1st LUN is one commodity SSD(queue
depth is 32) and the performance issue is reported on this LUN, another is one
HDD(queue depth is 256) which is root disk, but the megaraid host tag depth is
228, another weird setting. But the issue still can be reproduced after we set
2nd LUN's depth as 64 for avoiding driver tag contention.



Thanks,
Ming

