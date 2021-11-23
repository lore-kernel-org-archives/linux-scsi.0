Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CCFEEC433FE
	for <linux-scsi@archiver.kernel.org>; Tue, 23 Nov 2021 00:14:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231206AbhKWARJ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 22 Nov 2021 19:17:09 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:42546 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230394AbhKWARJ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 22 Nov 2021 19:17:09 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1637626441;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=JZvtms7pIknR/E/OjT1THTSkCWU334H5w7OLjmBgWow=;
        b=OoxLjCKnJ0ConmKTL+NKAVEExEBKQy1J0gzuHIT/Cxs0iaNoKNPobtivxB1vjCkzbZZq5+
        tBg54wlV8mvbpba2k9Y/XmFqMOCxyJjv9ZZ6HWip2fyjopFz7I+pX4KDuoteF4/kiOnPLm
        VlQshf5qI80pwaDVHQ33T4KRguc+++c=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-380-c8SRk3RGPVGc_5sOf5nBDQ-1; Mon, 22 Nov 2021 19:13:58 -0500
X-MC-Unique: c8SRk3RGPVGc_5sOf5nBDQ-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 018E21018720;
        Tue, 23 Nov 2021 00:13:57 +0000 (UTC)
Received: from T590 (ovpn-8-21.pek2.redhat.com [10.72.8.21])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 2411D18428;
        Tue, 23 Nov 2021 00:13:45 +0000 (UTC)
Date:   Tue, 23 Nov 2021 08:13:41 +0800
From:   Ming Lei <ming.lei@redhat.com>
To:     Sagi Grimberg <sagi@grimberg.me>
Cc:     Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-block@vger.kernel.org, linux-nvme@lists.infradead.org,
        linux-scsi@vger.kernel.org, Keith Busch <kbusch@kernel.org>,
        Chao Leng <lengchao@huawei.com>
Subject: Re: [PATCH 4/5] nvme: quiesce namespace queue in parallel
Message-ID: <YZwyNQWIh56hbgnq@T590>
References: <20211119021849.2259254-1-ming.lei@redhat.com>
 <20211119021849.2259254-5-ming.lei@redhat.com>
 <37036ab3-da87-898e-5af6-1abf228b4390@grimberg.me>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <37036ab3-da87-898e-5af6-1abf228b4390@grimberg.me>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, Nov 22, 2021 at 10:07:24AM +0200, Sagi Grimberg wrote:
> 
> 
> On 11/19/21 4:18 AM, Ming Lei wrote:
> > Chao Leng reported that in case of lots of namespaces, it may take quite a
> > while for nvme_stop_queues() to quiesce all namespace queues.
> > 
> > Improve nvme_stop_queues() by running quiesce in parallel, and just wait
> > once if global quiesce wait is allowed.
> > 
> > Link: https://lore.kernel.org/linux-block/cc732195-c053-9ce4-e1a7-e7f6dcf762ac@huawei.com/
> > Reported-by: Chao Leng <lengchao@huawei.com>
> > Signed-off-by: Ming Lei <ming.lei@redhat.com>
> > ---
> >   drivers/nvme/host/core.c | 9 ++++++---
> >   1 file changed, 6 insertions(+), 3 deletions(-)
> > 
> > diff --git a/drivers/nvme/host/core.c b/drivers/nvme/host/core.c
> > index 4b5de8f5435a..06741d3ed72b 100644
> > --- a/drivers/nvme/host/core.c
> > +++ b/drivers/nvme/host/core.c
> > @@ -4517,9 +4517,7 @@ static void nvme_start_ns_queue(struct nvme_ns *ns)
> >   static void nvme_stop_ns_queue(struct nvme_ns *ns)
> >   {
> >   	if (!test_and_set_bit(NVME_NS_STOPPED, &ns->flags))
> > -		blk_mq_quiesce_queue(ns->queue);
> > -	else
> > -		blk_mq_wait_quiesce_done(ns->queue);
> > +		blk_mq_quiesce_queue_nowait(ns->queue);
> >   }
> >   /*
> > @@ -4620,6 +4618,11 @@ void nvme_stop_queues(struct nvme_ctrl *ctrl)
> >   	down_read(&ctrl->namespaces_rwsem);
> >   	list_for_each_entry(ns, &ctrl->namespaces, list)
> >   		nvme_stop_ns_queue(ns);
> > +	list_for_each_entry(ns, &ctrl->namespaces, list) {
> > +		blk_mq_wait_quiesce_done(ns->queue);
> > +		if (blk_mq_global_quiesce_wait(ns->queue))
> > +			break;
> > +	}
> >   	up_read(&ctrl->namespaces_rwsem);
> 
> 
> Can you quantify how much of a difference it is to do rcu_read_unlock()
> for every queue? The big improvement here is that it is done in parallel
> instead of serially. Just wandering if it is worth the less than elegant
> interface...

The biggest improvement is N * synchronize_rcu() -> 1 * synchronize_rcu()
in case of non blocking, that is what Chao Leng complained before.

Even for blocking case, the parallel quiesce is still good, such as, when
one synchronize_srcu() is done, other srcu syncs should be done usually too.


thanks, 
Ming

