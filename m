Return-Path: <SRS0=qNH0=5X=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2D92DC2BA1A
	for <linux-scsi@archiver.kernel.org>; Tue,  7 Apr 2020 02:14:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 006A2206C0
	for <linux-scsi@archiver.kernel.org>; Tue,  7 Apr 2020 02:14:26 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="fi9LOrKg"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726393AbgDGCO0 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 6 Apr 2020 22:14:26 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:30754 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726287AbgDGCO0 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 6 Apr 2020 22:14:26 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1586225665;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=44SXGZt0xPbhcRSOYKE7iKipjDa+yIoa6ofEFx4YQKU=;
        b=fi9LOrKgg3xcteECVExZJqnk9L1JY2P2hZQ09+shqQoJhSeKHsRtYUeh6dMWdDxcKlcOml
        TBlqup3JAlePQlB5tSQVnda4dMoZFtYcBvU6NigPqYhuIw9Q1i4MBgQc2kITBFj63OsvHa
        WtumAo+maw7hXm5hxN0RNA/gyXlO+sY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-24-5WYMe6t2MHiYUIN2w1VJzA-1; Mon, 06 Apr 2020 22:14:23 -0400
X-MC-Unique: 5WYMe6t2MHiYUIN2w1VJzA-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 958A5107ACCC;
        Tue,  7 Apr 2020 02:14:20 +0000 (UTC)
Received: from localhost.localdomain (ovpn-8-35.pek2.redhat.com [10.72.8.35])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 191301001B28;
        Tue,  7 Apr 2020 02:14:08 +0000 (UTC)
Date:   Tue, 7 Apr 2020 10:14:03 +0800
From:   Ming Lei <ming.lei@redhat.com>
To:     Doug Anderson <dianders@chromium.org>
Cc:     Jens Axboe <axboe@kernel.dk>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Paolo Valente <paolo.valente@linaro.org>,
        Salman Qazi <sqazi@google.com>,
        linux-block <linux-block@vger.kernel.org>,
        linux-scsi@vger.kernel.org, Guenter Roeck <groeck@chromium.org>,
        Ajay Joshi <ajay.joshi@wdc.com>, Arnd Bergmann <arnd@arndb.de>,
        Bart Van Assche <bvanassche@acm.org>,
        Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>,
        Damien Le Moal <damien.lemoal@wdc.com>,
        Hou Tao <houtao1@huawei.com>,
        Pavel Begunkov <asml.silence@gmail.com>,
        Tejun Heo <tj@kernel.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 2/2] blk-mq: Rerun dispatching in the case of budget
 contention
Message-ID: <20200407021403.GB5779@localhost.localdomain>
References: <20200402155130.8264-1-dianders@chromium.org>
 <20200402085050.v2.2.I28278ef8ea27afc0ec7e597752a6d4e58c16176f@changeid>
 <20200403013356.GA6987@ming.t460p>
 <CAD=FV=Ub6zhVvTj79SWPUv19RDvD0gt5EjJV-FZSbYxUy_T1OA@mail.gmail.com>
 <CAD=FV=Vsk0SjkA+DbUwJxvO6NFcr0CO9=H1FD7okJ2PxMt5pYA@mail.gmail.com>
 <20200405091446.GA3421@localhost.localdomain>
 <CAD=FV=WQZA7PGEbv_fKikGOEijP+qEEZgYXWifgjDzV6BVOUMQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAD=FV=WQZA7PGEbv_fKikGOEijP+qEEZgYXWifgjDzV6BVOUMQ@mail.gmail.com>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Sun, Apr 05, 2020 at 09:26:39AM -0700, Doug Anderson wrote:
> Hi,
> 
> On Sun, Apr 5, 2020 at 2:15 AM Ming Lei <ming.lei@redhat.com> wrote:
> >
> > @@ -103,6 +104,9 @@ static void blk_mq_do_dispatch_sched(struct blk_mq_hw_ctx *hctx)
> >                 rq = e->type->ops.dispatch_request(hctx);
> >                 if (!rq) {
> >                         blk_mq_put_dispatch_budget(hctx);
> > +
> > +                       if (e->type->ops.has_work && e->type->ops.has_work(hctx))
> > +                               blk_mq_delay_run_hw_queue(hctx, BLK_MQ_BUDGET_DELAY);
> 
> To really close the race, don't we need to run all the queues
> associated with the hctx?  I haven't traced it through, but I've been
> assuming that the multiple "hctx"s associated with the same queue will
> have the same budget associated with them and thus they can block each
> other out.

Yeah, we should run all hctxs which share the same budget space.

Also, in theory, we don't have to add the delay, however BFQ may plug the
dispatch for 9 ms, so looks delay run queue is required.

thanks,
Ming

