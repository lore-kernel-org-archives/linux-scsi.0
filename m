Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 97619C433B4
	for <linux-scsi@archiver.kernel.org>; Mon, 26 Apr 2021 16:03:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5B5506024A
	for <linux-scsi@archiver.kernel.org>; Mon, 26 Apr 2021 16:03:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234300AbhDZQEf (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 26 Apr 2021 12:04:35 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:34717 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234251AbhDZQEe (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 26 Apr 2021 12:04:34 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1619453032;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=JzDKZKjxJCfayrRJp1UGQCJlquU6MbrGl23upYnQwMg=;
        b=Ai3pcZDLjSuS4gESny/WkBnCk0xofHXJO627Y5haUJIrSg/az9SF5GzpLOJ/gZ4cPmLAQO
        U4rI88vzaJ+1Fyeo4L1LqSsTW6IcbZqZafb8SDmOCQhmYoJnXgX+PLpHKKLmh5Y3FjEUzw
        +i6GkJ4QS6F/JkCXq7JyPPuXl14LdLU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-239-JL5yiRUHN7-WeOHb2dH42w-1; Mon, 26 Apr 2021 12:03:49 -0400
X-MC-Unique: JL5yiRUHN7-WeOHb2dH42w-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 853AA107ACCA;
        Mon, 26 Apr 2021 16:03:47 +0000 (UTC)
Received: from T590 (ovpn-12-94.pek2.redhat.com [10.72.12.94])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id AFCCE5C1CF;
        Mon, 26 Apr 2021 16:03:37 +0000 (UTC)
Date:   Tue, 27 Apr 2021 00:03:43 +0800
From:   Ming Lei <ming.lei@redhat.com>
To:     John Garry <john.garry@huawei.com>
Cc:     Kashyap Desai <kashyap.desai@broadcom.com>,
        linux-block@vger.kernel.org, linux-scsi@vger.kernel.org,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Jens Axboe <axboe@kernel.dk>,
        Douglas Gilbert <dgilbert@interlog.com>,
        Hannes Reinecke <hare@suse.com>
Subject: Re: [bug report] shared tags causes IO hang and performance drop
Message-ID: <YIbkX2G0+dp3PV+u@T590>
References: <YHaez6iN2HHYxYOh@T590>
 <9a6145a5-e6ac-3d33-b52a-0823bfc3b864@huawei.com>
 <cb326d404c6e0785d03a7dfadc42832c@mail.gmail.com>
 <YHbOOfGNHwO4SMS7@T590>
 <87ceccf2-287b-9bd1-899a-f15026c9e65b@huawei.com>
 <YHe3M62agQET6o6O@T590>
 <0c85fe52-ebc7-68b3-2dbe-dfad5d604346@huawei.com>
 <c1d5abaa-c460-55f8-5351-16f09d6aa81f@huawei.com>
 <YIbS1dgSYrsAeGvZ@T590>
 <55743a51-4d6f-f481-cebf-e2af9c657911@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <55743a51-4d6f-f481-cebf-e2af9c657911@huawei.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, Apr 26, 2021 at 04:52:28PM +0100, John Garry wrote:
> On 26/04/2021 15:48, Ming Lei wrote:
> > >       --0.56%--sbitmap_get
> > > 
> > > I don't see this for hostwide tags - this may be because we have multiple
> > > hctx, and the IO sched tags are per hctx, so less chance of exhaustion. But
> > > this is not from hostwide tags specifically, but for multiple HW queues in
> > > general. As I understood, sched tags were meant to be per request queue,
> > > right? I am reading this correctly?
> > sched tags is still per-hctx.
> > 
> > I just found that you didn't change sched tags into per-request-queue
> > shared tags. Then for hostwide tags, each hctx still has its own
> > standalone sched tags and request pool, that is one big difference with
> > non hostwide tags.
> 
> For both hostwide and non-hostwide tags, we have standalone sched tags and
> request pool per hctx when q->nr_hw_queues > 1.

driver tags is shared for hostwide tags.

> 
> > That is why you observe that scheduler tag exhaustion
> > is easy to trigger in case of non-hostwide tags.
> > 
> > I'd suggest to add one per-request-queue sched tags, and make all hctxs
> > sharing it, just like what you did for driver tag.
> > 
> 
> That sounds reasonable.
> 
> But I don't see how this is related to hostwide tags specifically, but
> rather just having q->nr_hw_queues > 1, which NVMe PCI and some other SCSI
> MQ HBAs have (without using hostwide tags).

Before hostwide tags, the whole scheduler queue depth should be 256.
After hostwide tags, the whole scheduler queue depth becomes 256 *
nr_hw_queues. But the driver tag queue depth is _not_ changed.

More requests come and are tried to dispatch to LLD and can't succeed
because of limited driver tag depth, and CPU utilization could be increased.

Thanks,
Ming

