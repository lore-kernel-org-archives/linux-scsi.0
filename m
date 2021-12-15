Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A566DC433EF
	for <linux-scsi@archiver.kernel.org>; Wed, 15 Dec 2021 12:57:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229686AbhLOM5m (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 15 Dec 2021 07:57:42 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:39103 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229643AbhLOM5l (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 15 Dec 2021 07:57:41 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1639573061;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=gbBXnTX3i0pGotRnsm5fy7R60ySCrQ0jVM7dlytIqDU=;
        b=V2QsM8AQTJG+lcILn8TUVepZLOR1eRqdVOFF5qcjv5r60n5lY/mHRkEaqzi8PJKaHFBQvL
        4tdvebS4J8nJt0KKNFC9ZPCl487HoPpQckhHGnqg5a2kRFHlf9megdXYSA+hZxqlQS4r/z
        Svt/JnCxK0RaqYIQuR2zLG4vZrGdZ8k=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-653-ttq6PNtHMyarGe1-dtwQgg-1; Wed, 15 Dec 2021 07:57:38 -0500
X-MC-Unique: ttq6PNtHMyarGe1-dtwQgg-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E78C1802C8F;
        Wed, 15 Dec 2021 12:57:35 +0000 (UTC)
Received: from T590 (ovpn-8-24.pek2.redhat.com [10.72.8.24])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id A33A11970E;
        Wed, 15 Dec 2021 12:56:52 +0000 (UTC)
Date:   Wed, 15 Dec 2021 20:56:47 +0800
From:   Ming Lei <ming.lei@redhat.com>
To:     Kashyap Desai <kashyap.desai@broadcom.com>
Cc:     luojiaxing <luojiaxing@huawei.com>, Jens Axboe <axboe@kernel.dk>,
        linux-block@vger.kernel.org, linux-scsi@vger.kernel.org,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        John Garry <john.garry@huawei.com>
Subject: Re: [PATCH] blk-mq: avoid to iterate over stale request
Message-ID: <YbnmD6yW1v7YWizf@T590>
References: <20210906065003.439019-1-ming.lei@redhat.com>
 <0d8666c9983158a4954f30f6b429e797@mail.gmail.com>
 <YblitnLqJtkK/xBt@T590>
 <86f2fb27dd6bc53fec3d8677c078937e@mail.gmail.com>
 <YbmhDNrnVLcfbK/l@T590>
 <3065cf1a25a99a2dd89e9065d679410e@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3065cf1a25a99a2dd89e9065d679410e@mail.gmail.com>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, Dec 15, 2021 at 02:15:51PM +0530, Kashyap Desai wrote:
> > >
> > > shared_tags->rqs[5] of hctx0 is having scmd = 0xAA (inflight command)
> > > shared_tags->rqs[10] of hctx0 is having scmd = 0xAA (inflight command)
> > > <- This is incorrect. While looping on hctx0 tags[], bitmap = 10 this
> > > entry is also found which is actually outstanding on hctx1.
> > > shared_tags->rqs[10] of hctx1 is having scmd = 0xBB (inflight command)
> >
> > Sorry, I am a bit confused, please look at the following code and
> > blk_mq_find_and_get_req()(<-bt_tags_iter).
> 
> 
> My issue is without shared tags. Below patch is certainly a fix for shared
> tags (for 5.16-rc).
> I have seen scsi eh deadlock issue on 5.15 kernel which does not have
> shared tags (but it has shared bitmap.)

OK, if you are talking about non-shared tags, your issue is exactly
addressed by 67f3b2f822b7 blk-mq: avoid to iterate over stale request

> 
> >
> > void blk_mq_tagset_busy_iter(struct blk_mq_tag_set *tagset,
> >                 busy_tag_iter_fn *fn, void *priv) {
> >         unsigned int flags = tagset->flags;
> >         int i, nr_tags;
> >
> >         nr_tags = blk_mq_is_shared_tags(flags) ? 1 :
> tagset->nr_hw_queues;
> >
> >         for (i = 0; i < nr_tags; i++) {
> >                 if (tagset->tags && tagset->tags[i])
> >                         __blk_mq_all_tag_iter(tagset->tags[i], fn, priv,
> >                                               BT_TAG_ITER_STARTED);
> >         }
> > }
> >
> > In case of shared tags, only tagset->tags[0] is iterated over, so both
> > 5 and 10 are checked, and shared_tags->rqs[5] and shared_tags->rqs[10]
> > shouldn't just point to the two latest requests? How can both 0xAA &
> 0xBB be
> > retrieved from shared_tags->rqs[10]?
> 
> Since I am not talking about shared tags, you can remap same condition
> now.
> In 5.15 kernel (shared bitmap is enabled but not shared tags) -

Shared bitmap and shared tags should have be same thing, that means all hw queues
share same tag space.

> blk_mq_tagset_busy_iter is called for each tags[] of nr_hw_queues times.
> It will call  bt_tags_for_each()  for hctx0.tags->[], hctx1.tags->[] ..
> Since tags->bitmap_tags is shared when it traverse hctx0.tags->[], it can

If ->birtmap_tags is shared, only one tags should be iterated over, so
the following commit was added:

0994c64eb415 blk-mq: Fix blk_mq_tagset_busy_iter() for shared tags

> find hctx0.tags[10].rq which is really stale entry.
> If the same request which is stale @ hctx0.tags[10] is really outstanding
> at some other tag#, stale entry will be counted in host_busy.
> 
> >
> > > Issue noticed by me is the exact same issue described @ below -
> > > https://lore.kernel.org/linux-scsi/fe5cf6c4-ce5e-4a0f-f4ab-5c10539492c
> > > b@hu
> > > awei.com/
> > >
> > > Issue is only exposed to shared host tagset. I got the required
> > > information. Thanks.
> > >
> > > Kashyap
> > > >
> > > > > count total 2 inflight commands instead of 1 from hctx0 context +
> > > > > From
> > > > > hctx1 context, we will count 1 inflight command = Total is 3.
> > > > > Even though we read after some delay, host_busy will be incorrect.
> > > > > We expect host_busy = 2 but it will return 3.
> > > > >
> > > > > This patch fix my issue explained above for shared host-tag case.
> > > > > I am confused reading the commit message. You may not have
> > > > > intentionally fix the issue as I explained but indirectly it fixes
> > > > > my issue. Am I
> > > correct ?
> > > > >
> > > > > What was an issue reported by Luojiaxiang ? I am interested to
> > > > > know if issue reported by Luojiaxiang had shared host tagset
> enabled ?
> > > >
> > > > https://lore.kernel.org/linux-scsi/fe5cf6c4-ce5e-4a0f-f4ab-
> > > > 5c10539492cb@huawei.com/
> > >
> > > I check this. It is same issue as what I am seeing on Broadcom
> > > controller only if shared host tagset is enabled.
> >
> > But 67f3b2f822b7 ("blk-mq: avoid to iterate over stale request") isn't
> only for
> > shared tags.
> 
> I mean, shared bitmap in my whole discussion. Megaraid_sas driver use
> shared bitmap, so it is exposed and It is confirmed from this discussion.
> Do we still have exposure (if "blk-mq: avoid to iterate over stale
> request" is not part of kernel)  to mpi3mr type driver which does not use
> shared bitmap but has nr_hw_queues > 1. ?

Not sure I understand your poing, but patch "blk-mq: avoid to iterate over stale
request" can cover both shared tags or not.



Thanks, 
Ming

