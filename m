Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EC45EC433EF
	for <linux-scsi@archiver.kernel.org>; Mon, 22 Nov 2021 13:20:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238838AbhKVNYE (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 22 Nov 2021 08:24:04 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:48253 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231444AbhKVNYE (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 22 Nov 2021 08:24:04 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1637587257;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=+lF/w7tD9pxUXDtV6yAcEsR2+KOGUo37EC26aybNgIE=;
        b=RrKMk8v/uAU2aXCEZw/cBJa4XbcEE/8QtLKjwP3K4m5ZZEruOV1I1frtcEEOtP8qCw5oLY
        8aNvTXDMSswHoUxkvoumUMW0Fv1fGsgsnQu630ynzr69iCT+qlBinTYFRBp8xBfUXDyl44
        gEHKZtYph2MUod8zh6c329NjQ9i2HUo=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-286-Y6l1Z9kiOSyzdEGWU2bqxQ-1; Mon, 22 Nov 2021 08:20:43 -0500
X-MC-Unique: Y6l1Z9kiOSyzdEGWU2bqxQ-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 1D04EA40C6;
        Mon, 22 Nov 2021 13:20:42 +0000 (UTC)
Received: from T590 (ovpn-8-23.pek2.redhat.com [10.72.8.23])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 5A92F5B826;
        Mon, 22 Nov 2021 13:20:14 +0000 (UTC)
Date:   Mon, 22 Nov 2021 21:20:10 +0800
From:   Ming Lei <ming.lei@redhat.com>
To:     Sagi Grimberg <sagi@grimberg.me>
Cc:     Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-block@vger.kernel.org, linux-nvme@lists.infradead.org,
        linux-scsi@vger.kernel.org, Keith Busch <kbusch@kernel.org>
Subject: Re: [PATCH 2/5] blk-mq: rename hctx_lock & hctx_unlock
Message-ID: <YZuZCsCIyQrc+539@T590>
References: <20211119021849.2259254-1-ming.lei@redhat.com>
 <20211119021849.2259254-3-ming.lei@redhat.com>
 <ed13ee7f-a017-874a-cd28-e40b3aa6b4a7@grimberg.me>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ed13ee7f-a017-874a-cd28-e40b3aa6b4a7@grimberg.me>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, Nov 22, 2021 at 09:53:53AM +0200, Sagi Grimberg wrote:
> 
> > -static inline void hctx_unlock(struct blk_mq_hw_ctx *hctx, int srcu_idx)
> > -	__releases(hctx->srcu)
> > +static inline void queue_unlock(struct request_queue *q, bool blocking,
> > +		int srcu_idx)
> > +	__releases(q->srcu)
> >   {
> > -	if (!(hctx->flags & BLK_MQ_F_BLOCKING))
> > +	if (!blocking)
> >   		rcu_read_unlock();
> >   	else
> > -		srcu_read_unlock(hctx->queue->srcu, srcu_idx);
> > +		srcu_read_unlock(q->srcu, srcu_idx);
> 
> Maybe instead of passing blocking bool just look at srcu_idx?
> 
> 	if (srcu_idx < 0)
> 		rcu_read_unlock();
> 	else
> 		srcu_read_unlock(q->srcu, srcu_idx);

This way needs to initialize srcu_idx in each callers.

> 
> Or look if the queue has srcu allocated?
> 
> 	if (!q->srcu)
> 		rcu_read_unlock();
> 	else
> 		srcu_read_unlock(q->srcu, srcu_idx);

This way is worse since q->srcu may involve one new cacheline fetch.

hctx->flags is always hot, so it is basically zero cost to check it.


Thanks,
Ming

