Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 20F65C433F5
	for <linux-scsi@archiver.kernel.org>; Wed, 15 Dec 2021 08:02:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240688AbhLOIC5 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 15 Dec 2021 03:02:57 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:35809 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S240686AbhLOIC5 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 15 Dec 2021 03:02:57 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1639555376;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Ib1r4fL5lB72LTGGaAZuG7Q8cvmRDji/TRRHBnqodI4=;
        b=NccD5fiHZchR4R4/QY5qmT9FBED0b6utzXMBkIgFtAK9MmDVfTQuY/c/SaMY7/PTH1a+ku
        A7kF2QUtxQUZEYcs5MDQ7bZ4fyz4u+kEWIJYHdDAopOKcWdrr1ifANlf9IFCFlNNupF89x
        BhMXMw0r8WjsTaW2eqR7yCX1JJ+Cwhg=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-297-6tf8RyjHNhCVyAxcB-Ce2Q-1; Wed, 15 Dec 2021 03:02:55 -0500
X-MC-Unique: 6tf8RyjHNhCVyAxcB-Ce2Q-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C20751018720;
        Wed, 15 Dec 2021 08:02:53 +0000 (UTC)
Received: from T590 (ovpn-8-24.pek2.redhat.com [10.72.8.24])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 25E1179A28;
        Wed, 15 Dec 2021 08:02:25 +0000 (UTC)
Date:   Wed, 15 Dec 2021 16:02:20 +0800
From:   Ming Lei <ming.lei@redhat.com>
To:     Kashyap Desai <kashyap.desai@broadcom.com>
Cc:     luojiaxing <luojiaxing@huawei.com>, Jens Axboe <axboe@kernel.dk>,
        linux-block@vger.kernel.org, linux-scsi@vger.kernel.org,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        John Garry <john.garry@huawei.com>
Subject: Re: [PATCH] blk-mq: avoid to iterate over stale request
Message-ID: <YbmhDNrnVLcfbK/l@T590>
References: <20210906065003.439019-1-ming.lei@redhat.com>
 <0d8666c9983158a4954f30f6b429e797@mail.gmail.com>
 <YblitnLqJtkK/xBt@T590>
 <86f2fb27dd6bc53fec3d8677c078937e@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <86f2fb27dd6bc53fec3d8677c078937e@mail.gmail.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, Dec 15, 2021 at 01:00:49PM +0530, Kashyap Desai wrote:
> >
> > Hello Kashyap,
> >
> > On Wed, Dec 15, 2021 at 12:11:13AM +0530, Kashyap Desai wrote:
> > > + John Garry
> > >
> > > > blk-mq can't run allocating driver tag and updating ->rqs[tag]
> > > atomically,
> > > > meantime blk-mq doesn't clear ->rqs[tag] after the driver tag is
> > > released.
> > > >
> > > > So there is chance to iterating over one stale request just after
> > > > the
> > > tag is
> > > > allocated and before updating ->rqs[tag].
> > > >
> > > > scsi_host_busy_iter() calls scsi_host_check_in_flight() to count
> > > > scsi
> > > in-flight
> > > > requests after scsi host is blocked, so no new scsi command can be
> > > marked as
> > > > SCMD_STATE_INFLIGHT. However, driver tag allocation still can be run
> > > > by
> > > blk-
> > > > mq core. One request is marked as SCMD_STATE_INFLIGHT, but this
> > > > request may have been kept in another slot of ->rqs[], meantime the
> > > > slot can be allocated out but ->rqs[] isn't updated yet. Then this
> > > > in-flight request
> > > is
> > > > counted twice as SCMD_STATE_INFLIGHT. This way causes trouble in
> > > handling
> > > > scsi error.
> > >
> > > Hi Ming,
> > >
> > > We found similar issue on RHEL8.5 (kernel  does not have this patch in
> > > discussion.). Issue reproduced on 5.15 kernel as well.
> > > I understood this commit will fix specific race condition and avoid
> > > reading incorrect host_busy value.
> > > As per commit message - That incorrect host_busy will be just
> transient.
> > > If we read after some delay, correct host_busy count will be
> available.
> > > Right ?
> >
> > Yeah, any counter(include atomic counter) works in this way.
> >
> > But here it may be 'permanent' because one stale request pointer may
> stay in
> > one slot of ->rqs[] for long enough time if this slot isn't reused,
> meantime the
> > same request can be reallocated in case of real io scheduler. Maybe the
> > commit log should be improved a bit for making it explicit.
> 
> Changing commit log description will help.
> 
> >
> > >
> > > In my case (I am using shared host tag enabled driver), it is not race
> > > condition issue but stale rqs[] entries create permanent incorrect
> > > count of host_busy.
> > > Example - There are two pending IOs. This IOs are timed out. Bitmap of
> > > pending IO is tag#5 (actually belongs to hctx0), tag#10 (actually
> > > belongs to hctx1).  Note  - This is a shared bit map.
> > > If hctx0 has same address of the request at 5th and 10th index, we
> > > will
> >
> > It shouldn't be possible, since ->rqs[] is per-tags. If it is shared bit
> map, both
> > tag#5 and tag#10 are set, and both shared_tags->rqs[5] & shared_tags-
> > >rqs[10] should point to the updated requests(timed out).
> Updated pointers will be there for actual hctx.  Below is possible and
> that is what causing problem in original issue.
> 
> shared_tags->rqs[5] of hctx0 is having scmd = 0xAA (inflight command)
> shared_tags->rqs[10] of hctx0 is having scmd = 0xAA (inflight command)  <-
> This is incorrect. While looping on hctx0 tags[], bitmap = 10 this entry
> is also found which is actually outstanding on hctx1.
> shared_tags->rqs[10] of hctx1 is having scmd = 0xBB (inflight command)

Sorry, I am a bit confused, please look at the following code and
blk_mq_find_and_get_req()(<-bt_tags_iter).

void blk_mq_tagset_busy_iter(struct blk_mq_tag_set *tagset,
                busy_tag_iter_fn *fn, void *priv)
{
        unsigned int flags = tagset->flags;
        int i, nr_tags;

        nr_tags = blk_mq_is_shared_tags(flags) ? 1 : tagset->nr_hw_queues;

        for (i = 0; i < nr_tags; i++) {
                if (tagset->tags && tagset->tags[i])
                        __blk_mq_all_tag_iter(tagset->tags[i], fn, priv,
                                              BT_TAG_ITER_STARTED);
        }
}

In case of shared tags, only tagset->tags[0] is iterated over, so both
5 and 10 are checked, and shared_tags->rqs[5] and shared_tags->rqs[10]
shouldn't just point to the two latest requests? How can both 0xAA &
0xBB be retrieved from shared_tags->rqs[10]?

> Issue noticed by me is the exact same issue described @ below -
> https://lore.kernel.org/linux-scsi/fe5cf6c4-ce5e-4a0f-f4ab-5c10539492cb@hu
> awei.com/
> 
> Issue is only exposed to shared host tagset. I got the required
> information. Thanks.
> 
> Kashyap
> >
> > > count total 2 inflight commands instead of 1 from hctx0 context + From
> > > hctx1 context, we will count 1 inflight command = Total is 3.
> > > Even though we read after some delay, host_busy will be incorrect. We
> > > expect host_busy = 2 but it will return 3.
> > >
> > > This patch fix my issue explained above for shared host-tag case.  I
> > > am confused reading the commit message. You may not have intentionally
> > > fix the issue as I explained but indirectly it fixes my issue. Am I
> correct ?
> > >
> > > What was an issue reported by Luojiaxiang ? I am interested to know if
> > > issue reported by Luojiaxiang had shared host tagset enabled ?
> >
> > https://lore.kernel.org/linux-scsi/fe5cf6c4-ce5e-4a0f-f4ab-
> > 5c10539492cb@huawei.com/
> 
> I check this. It is same issue as what I am seeing on Broadcom controller
> only if shared host tagset is enabled.

But 67f3b2f822b7 ("blk-mq: avoid to iterate over stale request") isn't
only for shared tags.



Thanks 
Ming

