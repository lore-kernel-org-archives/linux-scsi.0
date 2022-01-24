Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6693DC433F5
	for <linux-scsi@archiver.kernel.org>; Tue, 25 Jan 2022 00:31:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S3410885AbiAYAbK (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 24 Jan 2022 19:31:10 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:20837 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2361025AbiAXXi5 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 24 Jan 2022 18:38:57 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1643067534;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=abuo63c9unbIB0KgOA6si3wexVgqwYUCClSGn9/4mcM=;
        b=D7Zk2JIWEYojX8zqmf8UUoeoKw6fpKlRNq5w/kB1xyuwDniO6oTnkI7wEMiABvrNxJDfx4
        UPaX2EBcLRnfn4P44WsZnGm+ZhKj0TCc8+GJeSb6OMGAACgAQt78eM/hiJu/0EQItd384R
        PoXEa5y9Lz9dQXdZc+DFCkHU4cVNUAg=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-513-Yas22mTvPOmM9X3495v9DA-1; Mon, 24 Jan 2022 18:38:51 -0500
X-MC-Unique: Yas22mTvPOmM9X3495v9DA-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 9D6501083F60;
        Mon, 24 Jan 2022 23:38:49 +0000 (UTC)
Received: from T590 (ovpn-8-21.pek2.redhat.com [10.72.8.21])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 136BC56F83;
        Mon, 24 Jan 2022 23:38:39 +0000 (UTC)
Date:   Tue, 25 Jan 2022 07:38:34 +0800
From:   Ming Lei <ming.lei@redhat.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     Jens Axboe <axboe@kernel.dk>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-block@vger.kernel.org, linux-nvme@lists.infradead.org,
        linux-scsi@vger.kernel.org
Subject: Re: [PATCH V2 11/13] block: move blk_exit_queue into disk_release
Message-ID: <Ye84ehP7JQ6iwj7X@T590>
References: <20220122111054.1126146-1-ming.lei@redhat.com>
 <20220122111054.1126146-12-ming.lei@redhat.com>
 <20220124132221.GJ27269@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220124132221.GJ27269@lst.de>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, Jan 24, 2022 at 02:22:21PM +0100, Christoph Hellwig wrote:
> On Sat, Jan 22, 2022 at 07:10:52PM +0800, Ming Lei wrote:
> >  3 files changed, 41 insertions(+), 17 deletions(-)
> > 
> > diff --git a/block/blk-mq.c b/block/blk-mq.c
> > index d51b0aa2e4e4..72ae9955cf27 100644
> > --- a/block/blk-mq.c
> > +++ b/block/blk-mq.c
> > @@ -3101,6 +3101,9 @@ void blk_mq_free_rqs(struct blk_mq_tag_set *set, struct blk_mq_tags *tags,
> >  	struct blk_mq_tags *drv_tags;
> >  	struct page *page;
> >  
> > +	if (list_empty(&tags->page_list))
> > +		return;
> 
> Please split this out and document why it is needed.

Now blk_mq_sched_free_rqs() can be called from either blk_cleanup_queue
and disk_release(). If sched rq pool is freed in one of them, it can't
to be freed from another one.

> 
> > +/* Unconfigure the I/O scheduler and dissociate from the cgroup controller. */
> > +static void blk_exit_queue(struct request_queue *q)
> > +{
> > +	/*
> > +	 * Since the I/O scheduler exit code may access cgroup information,
> > +	 * perform I/O scheduler exit before disassociating from the block
> > +	 * cgroup controller.
> > +	 */
> > +	if (q->elevator) {
> > +		ioc_clear_queue(q);
> > +
> > +		mutex_lock(&q->sysfs_lock);
> > +		blk_mq_sched_free_rqs(q);
> > +		elevator_exit(q);
> > +		mutex_unlock(&q->sysfs_lock);
> > +	}
> > +}
> 
> Given that this all deals with the I/O scheduler the naming seems
> wrong.  It almost seems like we'd want to move ioc_clear_queue and
> blk_mq_sched_free_rqs into elevator_exit to have somewhat sensible
> helpers.

Looks good idea.



thanks, 
Ming

