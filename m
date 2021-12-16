Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 337CBC433F5
	for <linux-scsi@archiver.kernel.org>; Thu, 16 Dec 2021 07:22:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231972AbhLPHWn (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 16 Dec 2021 02:22:43 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:45220 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231388AbhLPHWn (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 16 Dec 2021 02:22:43 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1639639363;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Gh7OfxB6gHNNIY1MGf+TNdGG2hD+gXIjCaTRnCEV9Xc=;
        b=CEtRMdTZQUiBGAuB8iSmIiLXq8T8M6RIZiYR1CjeEbVNfEA+y7+eXmruK0Mqd+gJOo5wa3
        6Zz5Y43f0Xsqsd3puN28Sg/WSwE5CxfAuhh6T4K5y24uM57SNl0LUKmBAnqD/6kSd02v2E
        MF6DM3uyF35RF29kAjGjh8DUGTQFTuQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-622-f-ujoBuZPmif9U0Fx45zQA-1; Thu, 16 Dec 2021 02:22:39 -0500
X-MC-Unique: f-ujoBuZPmif9U0Fx45zQA-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 643618042F6;
        Thu, 16 Dec 2021 07:22:38 +0000 (UTC)
Received: from T590 (ovpn-8-20.pek2.redhat.com [10.72.8.20])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id A8CF47EBDD;
        Thu, 16 Dec 2021 07:22:15 +0000 (UTC)
Date:   Thu, 16 Dec 2021 15:22:09 +0800
From:   Ming Lei <ming.lei@redhat.com>
To:     Bart Van Assche <bvanassche@acm.org>
Cc:     Jens Axboe <axboe@kernel.dk>,
        Christoph Hellwig <hch@infradead.org>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        Dexuan Cui <decui@microsoft.com>, linux-scsi@vger.kernel.org,
        Tejun Heo <tj@kernel.org>,
        Lai Jiangshan <jiangshanlai@gmail.com>
Subject: Re: [PATCH] block: reduce kblockd_mod_delayed_work_on() CPU
 consumption
Message-ID: <YbrpIQUs4WOhyiIX@T590>
References: <bc529a3e-31d5-c266-8633-91095b346b19@kernel.dk>
 <YbiyhcbZmnNbed3O@infradead.org>
 <53b6fac0-10cb-80ab-16e7-ee851b720d5e@kernel.dk>
 <883ad44e-8421-1cb5-f3f4-4a8d193e2d5a@acm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <883ad44e-8421-1cb5-f3f4-4a8d193e2d5a@acm.org>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, Dec 15, 2021 at 09:40:38AM -0800, Bart Van Assche wrote:
> On 12/14/21 7:59 AM, Jens Axboe wrote:
> > On 12/14/21 8:04 AM, Christoph Hellwig wrote:
> > > So why not do a non-delayed queue_work for that case?  Might be good
> > > to get the scsi and workqueue maintaines involved to understand the
> > > issue a bit better first.
> > 
> > We can probably get by with doing just that, and just ignore if a delayed
> > work timer is already running.
> > 
> > Dexuan, can you try this one?
> > 
> > diff --git a/block/blk-core.c b/block/blk-core.c
> > index 1378d084c770..c1833f95cb97 100644
> > --- a/block/blk-core.c
> > +++ b/block/blk-core.c
> > @@ -1484,6 +1484,8 @@ EXPORT_SYMBOL(kblockd_schedule_work);
> >   int kblockd_mod_delayed_work_on(int cpu, struct delayed_work *dwork,
> >   				unsigned long delay)
> >   {
> > +	if (!delay)
> > +		return queue_work_on(cpu, kblockd_workqueue, &dwork->work);
> >   	return mod_delayed_work_on(cpu, kblockd_workqueue, dwork, delay);
> >   }
> >   EXPORT_SYMBOL(kblockd_mod_delayed_work_on);
> 
> As Christoph already mentioned, it would be great to receive feedback from the
> workqueue maintainer about this patch since I'm not aware of other kernel code
> that queues delayed_work in a similar way.
> Regarding the feedback from the view of the SCSI subsystem: I'd like to see the
> block layer core track whether or not a queue needs to be run such that the
> scsi_run_queue_async() call can be removed from scsi_end_request(). No such call

scsi_run_queue_async() is just for handling restart from running out of
scsi's device queue limit, which shouldn't be hot now, and it is for
handling scsi's own queue limit.

> was present in the original conversion of the SCSI core from the legacy block
> layer to blk-mq. See also commit d285203cf647 ("scsi: add support for a blk-mq
> based I/O path.").

That isn't true, see scsi_next_command()->scsi_run_queue().


Thanks,
Ming

