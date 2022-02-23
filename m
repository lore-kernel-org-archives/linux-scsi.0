Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7EB8CC433FE
	for <linux-scsi@archiver.kernel.org>; Wed, 23 Feb 2022 06:41:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238165AbiBWGmJ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 23 Feb 2022 01:42:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57646 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229761AbiBWGmI (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 23 Feb 2022 01:42:08 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 2845E276
        for <linux-scsi@vger.kernel.org>; Tue, 22 Feb 2022 22:41:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1645598489;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=wBXsULL6FKxPCfOIMZZZ9CXqJCCLgMAGkBRb7rLxB3Q=;
        b=SdvdiEpLwaBQFVG1z5W2NQKGvKMlVeL+jenYTGYLGwbuaXxE4DKZgmrr9TJu/2XJX1wpFP
        BE3nEmQHATGgXduMwXhfUlJkOrvoEY+cX+wolz9rdpXHZmT8b/HxZvqWCJcc3i2FUHffbE
        tRS1nBDnWWwxZkSCT3lJNtlUkEgbsjw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-41-HV9RbLaZPMKW3KQq2OnTxw-1; Wed, 23 Feb 2022 01:41:25 -0500
X-MC-Unique: HV9RbLaZPMKW3KQq2OnTxw-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id BE3611006AA6;
        Wed, 23 Feb 2022 06:41:23 +0000 (UTC)
Received: from T590 (ovpn-8-19.pek2.redhat.com [10.72.8.19])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id CAFB1646A9;
        Wed, 23 Feb 2022 06:41:14 +0000 (UTC)
Date:   Wed, 23 Feb 2022 14:41:09 +0800
From:   Ming Lei <ming.lei@redhat.com>
To:     Bart Van Assche <bvanassche@acm.org>
Cc:     Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-block@vger.kernel.org, linux-scsi@vger.kernel.org
Subject: Re: [PATCH 08/12] block: don't remove hctx debugfs dir from
 blk_mq_exit_queue
Message-ID: <YhXXBRSI8+a3eiHT@T590>
References: <20220222141450.591193-1-hch@lst.de>
 <20220222141450.591193-9-hch@lst.de>
 <6105afff-b4e1-1a38-2112-b21396829dd0@acm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6105afff-b4e1-1a38-2112-b21396829dd0@acm.org>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, Feb 22, 2022 at 08:06:31PM -0800, Bart Van Assche wrote:
> On 2/22/22 06:14, Christoph Hellwig wrote:
> > From: Ming Lei <ming.lei@redhat.com>
> > 
> > The queue's top debugfs dir is removed from blk_release_queue(), so all
> > hctx's debugfs dirs are removed from there. Given blk_mq_exit_queue()
> > is only called from blk_cleanup_queue(), it isn't necessary to remove
> > hctx debugfs from blk_mq_exit_queue().
> > 
> > So remove it from blk_mq_exit_queue().
> > 
> > Signed-off-by: Ming Lei <ming.lei@redhat.com>
> > Signed-off-by: Christoph Hellwig <hch@lst.de>
> > ---
> >   block/blk-mq.c | 1 -
> >   1 file changed, 1 deletion(-)
> > 
> > diff --git a/block/blk-mq.c b/block/blk-mq.c
> > index 63e2d3fd60946..540c8da30da72 100644
> > --- a/block/blk-mq.c
> > +++ b/block/blk-mq.c
> > @@ -3425,7 +3425,6 @@ static void blk_mq_exit_hw_queues(struct request_queue *q,
> >   	queue_for_each_hw_ctx(q, hctx, i) {
> >   		if (i == nr_queue)
> >   			break;
> > -		blk_mq_debugfs_unregister_hctx(hctx);
> >   		blk_mq_exit_hctx(q, set, hctx, i);
> >   	}
> >   }
> 
> What will happen if a new queue with the same name as a removed queue is
> created before blk_release_queue() for the removed queue has finished? Will
> that cause registration of debugfs attributes for the newly created queue to
> fail?

That may happen, but not related with this patch, since this patch just
delays removing of hctx's debug entry. And q->debugfs_dir is removed
from blk_release_queue().

So far, request queue doesn't has name, and just uses the disk's name
for creating debugfs entry. The trouble should have been there for long
time.


Thanks,
Ming

