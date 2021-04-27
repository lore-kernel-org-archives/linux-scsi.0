Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CF628C433ED
	for <linux-scsi@archiver.kernel.org>; Tue, 27 Apr 2021 09:12:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 89D56613B0
	for <linux-scsi@archiver.kernel.org>; Tue, 27 Apr 2021 09:12:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235075AbhD0JNW (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 27 Apr 2021 05:13:22 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:35457 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235096AbhD0JNS (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 27 Apr 2021 05:13:18 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1619514716;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=NnYQaX86Fcj9dAhMK+QIJGBc66dkfVgpeHVX/OOPAyQ=;
        b=IrZoNrOMI+BUNAFcw6C0QSYaCruoSMj3iHftO6zIN/4W9dDkoI7Slg1HqrWH4ZymXUwgzO
        4eSqhzVLoX/UTAIjuUXXn3HfI0qL8q5F8iSw10prttqQOHC93nZ8rqlBWkLf/NRbBxpM2A
        cVk2+5jt/tbhhp6x4hObhdI9Zth+hlA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-334-IUbn19S9MYCpzssk2HszLw-1; Tue, 27 Apr 2021 05:11:54 -0400
X-MC-Unique: IUbn19S9MYCpzssk2HszLw-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A81D6106BAE8;
        Tue, 27 Apr 2021 09:11:52 +0000 (UTC)
Received: from T590 (ovpn-13-248.pek2.redhat.com [10.72.13.248])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 722C06E50A;
        Tue, 27 Apr 2021 09:11:41 +0000 (UTC)
Date:   Tue, 27 Apr 2021 17:11:49 +0800
From:   Ming Lei <ming.lei@redhat.com>
To:     John Garry <john.garry@huawei.com>
Cc:     Kashyap Desai <kashyap.desai@broadcom.com>,
        linux-block@vger.kernel.org, linux-scsi@vger.kernel.org,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Jens Axboe <axboe@kernel.dk>,
        Douglas Gilbert <dgilbert@interlog.com>,
        Hannes Reinecke <hare@suse.com>
Subject: Re: [bug report] shared tags causes IO hang and performance drop
Message-ID: <YIfVVRheF9ZWjzbh@T590>
References: <87ceccf2-287b-9bd1-899a-f15026c9e65b@huawei.com>
 <YHe3M62agQET6o6O@T590>
 <0c85fe52-ebc7-68b3-2dbe-dfad5d604346@huawei.com>
 <c1d5abaa-c460-55f8-5351-16f09d6aa81f@huawei.com>
 <YIbS1dgSYrsAeGvZ@T590>
 <55743a51-4d6f-f481-cebf-e2af9c657911@huawei.com>
 <YIbkX2G0+dp3PV+u@T590>
 <9ad15067-ba7b-a335-ae71-8c4328856b91@huawei.com>
 <YIdTyyVE5azlYwtO@T590>
 <ab83eec4-20f1-ad74-7f43-52a4a87a8aa9@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ab83eec4-20f1-ad74-7f43-52a4a87a8aa9@huawei.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, Apr 27, 2021 at 08:52:53AM +0100, John Garry wrote:
> On 27/04/2021 00:59, Ming Lei wrote:
> > > Anyway, I'll look at adding code for a per-request queue sched tags to see
> > > if it helps. But I would plan to continue to use a per hctx sched request
> > > pool.
> > Why not switch to per hctx sched request pool?
> 
> I don't understand. The current code uses a per-hctx sched request pool, and
> I said that I don't plan to change that.

I forget why you didn't do that, because for hostwide tags, request
is always 1:1 for either sched tags(real io sched) or driver tags(none).

Maybe you want to keep request local to hctx, but never see related
performance data for supporting the point, sbitmap queue allocator has
been intelligent enough to allocate tag freed from native cpu.

Then you just waste lots of memory, I remember that scsi request payload
is a bit big.


Thanks,
Ming

