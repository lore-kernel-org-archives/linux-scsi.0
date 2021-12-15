Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C50EFC433F5
	for <linux-scsi@archiver.kernel.org>; Wed, 15 Dec 2021 03:36:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239591AbhLODgm (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 14 Dec 2021 22:36:42 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:43993 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233398AbhLODgm (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 14 Dec 2021 22:36:42 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1639539401;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=688xFRa8AAKsWZUS1hmZAj1VYxcJEee8zqeqO6UTzIk=;
        b=REmNKzIVhC7whpB4hkzxouMoey5pNHodVme0Uxpk+rp/Z580EQ79iSoS2hz4JueR2PP8Ud
        93B6rlwhUK67DL8qTCfB09ppK5sVBirxeSXwWTs6SIx9q3NGmqnlOR3MV12Ae3hOY5cvMu
        VTi0B3eZm4HeEWxBBmEozqedNt6YJrE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-310-Axt8RJ6uNKWBD5pj22qyHg-1; Tue, 14 Dec 2021 22:36:38 -0500
X-MC-Unique: Axt8RJ6uNKWBD5pj22qyHg-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id ED05C2F48;
        Wed, 15 Dec 2021 03:36:36 +0000 (UTC)
Received: from T590 (ovpn-8-24.pek2.redhat.com [10.72.8.24])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 1D9052A18D;
        Wed, 15 Dec 2021 03:36:27 +0000 (UTC)
Date:   Wed, 15 Dec 2021 11:36:22 +0800
From:   Ming Lei <ming.lei@redhat.com>
To:     Kashyap Desai <kashyap.desai@broadcom.com>
Cc:     luojiaxing <luojiaxing@huawei.com>, Jens Axboe <axboe@kernel.dk>,
        linux-block@vger.kernel.org, linux-scsi@vger.kernel.org,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        John Garry <john.garry@huawei.com>
Subject: Re: [PATCH] blk-mq: avoid to iterate over stale request
Message-ID: <YblitnLqJtkK/xBt@T590>
References: <20210906065003.439019-1-ming.lei@redhat.com>
 <0d8666c9983158a4954f30f6b429e797@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0d8666c9983158a4954f30f6b429e797@mail.gmail.com>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hello Kashyap,

On Wed, Dec 15, 2021 at 12:11:13AM +0530, Kashyap Desai wrote:
> + John Garry
> 
> > blk-mq can't run allocating driver tag and updating ->rqs[tag]
> atomically,
> > meantime blk-mq doesn't clear ->rqs[tag] after the driver tag is
> released.
> >
> > So there is chance to iterating over one stale request just after the
> tag is
> > allocated and before updating ->rqs[tag].
> >
> > scsi_host_busy_iter() calls scsi_host_check_in_flight() to count scsi
> in-flight
> > requests after scsi host is blocked, so no new scsi command can be
> marked as
> > SCMD_STATE_INFLIGHT. However, driver tag allocation still can be run by
> blk-
> > mq core. One request is marked as SCMD_STATE_INFLIGHT, but this request
> > may have been kept in another slot of ->rqs[], meantime the slot can be
> > allocated out but ->rqs[] isn't updated yet. Then this in-flight request
> is
> > counted twice as SCMD_STATE_INFLIGHT. This way causes trouble in
> handling
> > scsi error.
> 
> Hi Ming,
> 
> We found similar issue on RHEL8.5 (kernel  does not have this patch in
> discussion.). Issue reproduced on 5.15 kernel as well.
> I understood this commit will fix specific race condition and avoid
> reading incorrect host_busy value.
> As per commit message - That incorrect host_busy will be just transient.
> If we read after some delay, correct host_busy count will be available.
> Right ?

Yeah, any counter(include atomic counter) works in this way.

But here it may be 'permanent' because one stale request pointer may stay in
one slot of ->rqs[] for long enough time if this slot isn't reused, meantime
the same request can be reallocated in case of real io scheduler. Maybe the
commit log should be improved a bit for making it explicit.

> 
> In my case (I am using shared host tag enabled driver), it is not race
> condition issue but stale rqs[] entries create permanent incorrect count
> of host_busy.
> Example - There are two pending IOs. This IOs are timed out. Bitmap of
> pending IO is tag#5 (actually belongs to hctx0), tag#10 (actually belongs
> to hctx1).  Note  - This is a shared bit map.
> If hctx0 has same address of the request at 5th and 10th index, we will

It shouldn't be possible, since ->rqs[] is per-tags. If it is shared bit
map, both tag#5 and tag#10 are set, and both shared_tags->rqs[5] &
shared_tags->rqs[10] should point to the updated requests(timed out).

> count total 2 inflight commands instead of 1 from hctx0 context + From
> hctx1 context, we will count 1 inflight command = Total is 3.
> Even though we read after some delay, host_busy will be incorrect. We
> expect host_busy = 2 but it will return 3.
> 
> This patch fix my issue explained above for shared host-tag case.  I am
> confused reading the commit message. You may not have intentionally fix
> the issue as I explained but indirectly it fixes my issue. Am I correct ?
> 
> What was an issue reported by Luojiaxiang ? I am interested to know if
> issue reported by Luojiaxiang had shared host tagset enabled ?

https://lore.kernel.org/linux-scsi/fe5cf6c4-ce5e-4a0f-f4ab-5c10539492cb@huawei.com/

It should be same with yours, and the original report described & explained
the issue in details.

thanks,
Ming

> 
> Kashyap
> 
> >
> > Fixes the issue by not iterating over stale request.
> >
> > Cc: linux-scsi@vger.kernel.org
> > Cc: "Martin K. Petersen" <martin.petersen@oracle.com>
> > Reported-by: luojiaxing <luojiaxing@huawei.com>
> > Signed-off-by: Ming Lei <ming.lei@redhat.com>
> > ---
> >  block/blk-mq-tag.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> >
> > diff --git a/block/blk-mq-tag.c b/block/blk-mq-tag.c index
> > 86f87346232a..ff5caeb82542 100644
> > --- a/block/blk-mq-tag.c
> > +++ b/block/blk-mq-tag.c
> > @@ -208,7 +208,7 @@ static struct request
> > *blk_mq_find_and_get_req(struct blk_mq_tags *tags,
> >
> >  	spin_lock_irqsave(&tags->lock, flags);
> >  	rq = tags->rqs[bitnr];
> > -	if (!rq || !refcount_inc_not_zero(&rq->ref))
> > +	if (!rq || rq->tag != bitnr || !refcount_inc_not_zero(&rq->ref))
> >  		rq = NULL;
> >  	spin_unlock_irqrestore(&tags->lock, flags);
> >  	return rq;
> > --
> > 2.31.1



-- 
Ming

