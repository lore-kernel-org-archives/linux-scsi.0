Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E181FC433EF
	for <linux-scsi@archiver.kernel.org>; Tue, 30 Nov 2021 02:34:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237607AbhK3Chb (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 29 Nov 2021 21:37:31 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:31205 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233451AbhK3Chb (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 29 Nov 2021 21:37:31 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1638239652;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=BwYQSMaKGhnVjdlg6/XWIcbt1mryEgoJl23wrK4HkPE=;
        b=MjpKCvioQIROX5ptNgXJ0u/CdU7WVdDV48kGDHZWZpvWxz6XRs1MjCxDvJcxxm9AFsABVD
        V2d8gw2DiLli5ob+PXzUDEJb/rh8+Y79SmfdX0jUMbF79JRx6XDrIjpIw9+PBzS8u9gI6o
        JJtuRsiDR0vI8Qbc3w+2LDqKS8Eo72k=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-164-N5HmpV_gOPu2964hsrRfPg-1; Mon, 29 Nov 2021 21:34:08 -0500
X-MC-Unique: N5HmpV_gOPu2964hsrRfPg-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 370F183DD22;
        Tue, 30 Nov 2021 02:34:07 +0000 (UTC)
Received: from T590 (ovpn-8-17.pek2.redhat.com [10.72.8.17])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 67DA610016FE;
        Tue, 30 Nov 2021 02:33:13 +0000 (UTC)
Date:   Tue, 30 Nov 2021 10:33:08 +0800
From:   Ming Lei <ming.lei@redhat.com>
To:     Sagi Grimberg <sagi@grimberg.me>
Cc:     Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-block@vger.kernel.org, linux-nvme@lists.infradead.org,
        linux-scsi@vger.kernel.org, Keith Busch <kbusch@kernel.org>
Subject: Re: [PATCH 3/5] blk-mq: add helper of blk_mq_global_quiesce_wait()
Message-ID: <YaWNZF3ZYWPQBSbk@T590>
References: <20211119021849.2259254-1-ming.lei@redhat.com>
 <20211119021849.2259254-4-ming.lei@redhat.com>
 <8f6b6452-9abb-fd89-0262-9fb9d00d42a5@grimberg.me>
 <YZuagPbZJ6CjiUNi@T590>
 <38b9661e-c5b8-ae18-f2ab-b30f9d3e7115@grimberg.me>
 <YZwzEBtFug6JEmMZ@T590>
 <a3ea006a-738b-af69-4dd5-f33444e3559d@grimberg.me>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a3ea006a-738b-af69-4dd5-f33444e3559d@grimberg.me>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, Nov 23, 2021 at 11:00:45AM +0200, Sagi Grimberg wrote:
> 
> > > > > > Add helper of blk_mq_global_quiesce_wait() for supporting to quiesce
> > > > > > queues in parallel, then we can just wait once if global quiesce wait
> > > > > > is allowed.
> > > > > 
> > > > > blk_mq_global_quiesce_wait() is a poor name... global is scope-less and
> > > > > obviously it has a scope.
> > > > 
> > > > How about blk_mq_shared_quiesce_wait()? or any suggestion?
> > > 
> > > Shared between what?
> > 
> > All request queues in one host-wide, both scsi and nvme has such
> > requirement.
> > 
> > > 
> > > Maybe if the queue has a non-blocking tagset, it can have a "quiesced"
> > > flag that is cleared in unquiesce? then the callers can just continue
> > > to iterate but will only wait the rcu grace period once.
> > 
> > Yeah, that is what these patches try to implement.
> 
> I was suggesting to "hide" it in the interface.
> Maybe something like:
> --
> diff --git a/block/blk-mq.c b/block/blk-mq.c
> index 8799fa73ef34..627b631db1f9 100644
> --- a/block/blk-mq.c
> +++ b/block/blk-mq.c
> @@ -263,14 +263,18 @@ void blk_mq_wait_quiesce_done(struct request_queue *q)
>         unsigned int i;
>         bool rcu = false;
> 
> +       if (!q->has_srcu && q->quiesced)
> +               return;
>         queue_for_each_hw_ctx(q, hctx, i) {
>                 if (hctx->flags & BLK_MQ_F_BLOCKING)
>                         synchronize_srcu(hctx->srcu);
>                 else
>                         rcu = true;
>         }
> -       if (rcu)
> +       if (rcu) {
>                 synchronize_rcu();
> +               q->quiesced = true;
> +       }
>  }
>  EXPORT_SYMBOL_GPL(blk_mq_wait_quiesce_done);
> 
> @@ -308,6 +312,7 @@ void blk_mq_unquiesce_queue(struct request_queue *q)
>         } else if (!--q->quiesce_depth) {
>                 blk_queue_flag_clear(QUEUE_FLAG_QUIESCED, q);
>                 run_queue = true;
> +               q->quiesced = false;

Different request queues are passed to blk_mq_wait_quiesce_done() during
the iteration, so marking 'quiesced' doesn't make any difference here.


Thanks,
Ming

