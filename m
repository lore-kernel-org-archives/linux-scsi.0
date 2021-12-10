Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B77F6C433F5
	for <linux-scsi@archiver.kernel.org>; Fri, 10 Dec 2021 02:03:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235719AbhLJCG7 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 9 Dec 2021 21:06:59 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:41785 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235704AbhLJCG6 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 9 Dec 2021 21:06:58 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1639101804;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=1777qpxXy+ZqI8dbPbWtlD5bwoogfer6ZBV0Xkzt0Ts=;
        b=Fw0++REutrax2R4E5woi1D/9qh+8AMtaFxe+p0n3IYI6TowcoTjyNn0DI83BqoDq4VBdX4
        4s0yYnJjbS567G6rD0doEP393eAtAgh9J2fGRBFjZ77AbY0VLybzskI1iARoK/uZ4GNjRn
        64dJcR1l9tlyPWzhBQ/vYYzYupLVBUU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-13-ehU7CmpdOeaaqgsc8xHoqA-1; Thu, 09 Dec 2021 21:03:21 -0500
X-MC-Unique: ehU7CmpdOeaaqgsc8xHoqA-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 728AD1006AA0;
        Fri, 10 Dec 2021 02:03:19 +0000 (UTC)
Received: from T590 (ovpn-8-20.pek2.redhat.com [10.72.8.20])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 2DF8260BF1;
        Fri, 10 Dec 2021 02:02:56 +0000 (UTC)
Date:   Fri, 10 Dec 2021 10:02:52 +0800
From:   Ming Lei <ming.lei@redhat.com>
To:     Sagi Grimberg <sagi@grimberg.me>
Cc:     Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-block@vger.kernel.org, linux-nvme@lists.infradead.org,
        linux-scsi@vger.kernel.org, Keith Busch <kbusch@kernel.org>
Subject: Re: [PATCH 3/5] blk-mq: add helper of blk_mq_global_quiesce_wait()
Message-ID: <YbK1TLTkHrut1FJ+@T590>
References: <20211119021849.2259254-1-ming.lei@redhat.com>
 <20211119021849.2259254-4-ming.lei@redhat.com>
 <8f6b6452-9abb-fd89-0262-9fb9d00d42a5@grimberg.me>
 <YZuagPbZJ6CjiUNi@T590>
 <38b9661e-c5b8-ae18-f2ab-b30f9d3e7115@grimberg.me>
 <YZwzEBtFug6JEmMZ@T590>
 <a3ea006a-738b-af69-4dd5-f33444e3559d@grimberg.me>
 <YaWNZF3ZYWPQBSbk@T590>
 <4394200f-782b-5d75-4570-79a1f63110b1@grimberg.me>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4394200f-782b-5d75-4570-79a1f63110b1@grimberg.me>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, Dec 08, 2021 at 02:49:25PM +0200, Sagi Grimberg wrote:
> 
> 
> On 11/30/21 4:33 AM, Ming Lei wrote:
> > On Tue, Nov 23, 2021 at 11:00:45AM +0200, Sagi Grimberg wrote:
> > > 
> > > > > > > > Add helper of blk_mq_global_quiesce_wait() for supporting to quiesce
> > > > > > > > queues in parallel, then we can just wait once if global quiesce wait
> > > > > > > > is allowed.
> > > > > > > 
> > > > > > > blk_mq_global_quiesce_wait() is a poor name... global is scope-less and
> > > > > > > obviously it has a scope.
> > > > > > 
> > > > > > How about blk_mq_shared_quiesce_wait()? or any suggestion?
> > > > > 
> > > > > Shared between what?
> > > > 
> > > > All request queues in one host-wide, both scsi and nvme has such
> > > > requirement.
> > > > 
> > > > > 
> > > > > Maybe if the queue has a non-blocking tagset, it can have a "quiesced"
> > > > > flag that is cleared in unquiesce? then the callers can just continue
> > > > > to iterate but will only wait the rcu grace period once.
> > > > 
> > > > Yeah, that is what these patches try to implement.
> > > 
> > > I was suggesting to "hide" it in the interface.
> > > Maybe something like:
> > > --
> > > diff --git a/block/blk-mq.c b/block/blk-mq.c
> > > index 8799fa73ef34..627b631db1f9 100644
> > > --- a/block/blk-mq.c
> > > +++ b/block/blk-mq.c
> > > @@ -263,14 +263,18 @@ void blk_mq_wait_quiesce_done(struct request_queue *q)
> > >          unsigned int i;
> > >          bool rcu = false;
> > > 
> > > +       if (!q->has_srcu && q->quiesced)
> > > +               return;
> > >          queue_for_each_hw_ctx(q, hctx, i) {
> > >                  if (hctx->flags & BLK_MQ_F_BLOCKING)
> > >                          synchronize_srcu(hctx->srcu);
> > >                  else
> > >                          rcu = true;
> > >          }
> > > -       if (rcu)
> > > +       if (rcu) {
> > >                  synchronize_rcu();
> > > +               q->quiesced = true;
> > > +       }
> > >   }
> > >   EXPORT_SYMBOL_GPL(blk_mq_wait_quiesce_done);
> > > 
> > > @@ -308,6 +312,7 @@ void blk_mq_unquiesce_queue(struct request_queue *q)
> > >          } else if (!--q->quiesce_depth) {
> > >                  blk_queue_flag_clear(QUEUE_FLAG_QUIESCED, q);
> > >                  run_queue = true;
> > > +               q->quiesced = false;
> > 
> > Different request queues are passed to blk_mq_wait_quiesce_done() during
> > the iteration, so marking 'quiesced' doesn't make any difference here.
> 
> I actually meant q->tag_set->quiesced, such that the flag will be
> used in the tag_set reference. This way this sharing will be kept
> hidden from the callers.

That looks easy, but not true really from API viewpoint, q->tag_set has different
lifetime which is covered by driver, not mention other request queues may touch
q->tag_set->quiesced from other code path, so things will become much complicated,
also what is the meaning of quiesced state for tagset wide?

Here I prefer to philosophy of 'Worse is better'[1], and simplicity over perfection
by adding one simple helper of blk_mq_shared_quiesce_wait() for improving the case
very easily.

[1] ihttps://ipfs.fleek.co/ipfs/QmXoypizjW3WknFiJnKLwHCnL72vedxjQkDDP1mXWo6uco/wiki/Unix_philosophy.html


Thanks,
Ming

