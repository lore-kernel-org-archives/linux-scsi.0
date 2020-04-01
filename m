Return-Path: <SRS0=ctNG=5R=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D0C76C2D0F1
	for <linux-scsi@archiver.kernel.org>; Wed,  1 Apr 2020 02:04:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A63D8214D8
	for <linux-scsi@archiver.kernel.org>; Wed,  1 Apr 2020 02:04:39 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="YSXG50L7"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731588AbgDACEi (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 31 Mar 2020 22:04:38 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:57838 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1731550AbgDACEi (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 31 Mar 2020 22:04:38 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1585706676;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=ufaOCEFCA4uXdrXl9mettuNypsTl5ZbRrfDLVi4fUdY=;
        b=YSXG50L7UCnaqqIdTNrbp4Oe16XCKyoz2yxHaZWczkL6F13SISds2bUQEtL2PorzCrEEBa
        Y2ycFMlRvP75bvTJG8hpmmSd0uKGWOttivh1FKjyT3Gbecq+7Iz1uS0C2Wqu6jpYVK0VPF
        EPd/H7rUF3sULTAWnIhv98S9aoRfSSg=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-488-PRoNgaLfMJKVdHw3z1WhnQ-1; Tue, 31 Mar 2020 22:04:32 -0400
X-MC-Unique: PRoNgaLfMJKVdHw3z1WhnQ-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 2302913F9;
        Wed,  1 Apr 2020 02:04:31 +0000 (UTC)
Received: from ming.t460p (ovpn-8-19.pek2.redhat.com [10.72.8.19])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 4733B5C1C5;
        Wed,  1 Apr 2020 02:04:22 +0000 (UTC)
Date:   Wed, 1 Apr 2020 10:04:18 +0800
From:   Ming Lei <ming.lei@redhat.com>
To:     Doug Anderson <dianders@chromium.org>
Cc:     Jens Axboe <axboe@kernel.dk>,
        Paolo Valente <paolo.valente@linaro.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-block <linux-block@vger.kernel.org>,
        Guenter Roeck <groeck@chromium.org>,
        linux-scsi@vger.kernel.org, Salman Qazi <sqazi@google.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/2] scsi: core: Fix stall if two threads request budget
 at the same time
Message-ID: <20200401020418.GA16793@ming.t460p>
References: <20200330144907.13011-1-dianders@chromium.org>
 <20200330074856.2.I28278ef8ea27afc0ec7e597752a6d4e58c16176f@changeid>
 <20200331014109.GA20230@ming.t460p>
 <D38AB98D-7F6A-4C61-8A8F-C22C53671AC8@linaro.org>
 <d6af2344-11f7-5862-daed-e21cbd496d92@kernel.dk>
 <CAD=FV=WHYFDoUKLnwMCm-o=gEQDCzZFeMAvia3wpJzm9XX7Bow@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAD=FV=WHYFDoUKLnwMCm-o=gEQDCzZFeMAvia3wpJzm9XX7Bow@mail.gmail.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, Mar 31, 2020 at 04:51:00PM -0700, Doug Anderson wrote:
> Hi,
> 
> On Tue, Mar 31, 2020 at 11:26 AM Jens Axboe <axboe@kernel.dk> wrote:
> >
> > On 3/31/20 12:07 PM, Paolo Valente wrote:
> > >> Il giorno 31 mar 2020, alle ore 03:41, Ming Lei <ming.lei@redhat.com> ha scritto:
> > >>
> > >> On Mon, Mar 30, 2020 at 07:49:06AM -0700, Douglas Anderson wrote:
> > >>> It is possible for two threads to be running
> > >>> blk_mq_do_dispatch_sched() at the same time with the same "hctx".
> > >>> This is because there can be more than one caller to
> > >>> __blk_mq_run_hw_queue() with the same "hctx" and hctx_lock() doesn't
> > >>> prevent more than one thread from entering.
> > >>>
> > >>> If more than one thread is running blk_mq_do_dispatch_sched() at the
> > >>> same time with the same "hctx", they may have contention acquiring
> > >>> budget.  The blk_mq_get_dispatch_budget() can eventually translate
> > >>> into scsi_mq_get_budget().  If the device's "queue_depth" is 1 (not
> > >>> uncommon) then only one of the two threads will be the one to
> > >>> increment "device_busy" to 1 and get the budget.
> > >>>
> > >>> The losing thread will break out of blk_mq_do_dispatch_sched() and
> > >>> will stop dispatching requests.  The assumption is that when more
> > >>> budget is available later (when existing transactions finish) the
> > >>> queue will be kicked again, perhaps in scsi_end_request().
> > >>>
> > >>> The winning thread now has budget and can go on to call
> > >>> dispatch_request().  If dispatch_request() returns NULL here then we
> > >>> have a potential problem.  Specifically we'll now call
> > >>
> > >> I guess this problem should be BFQ specific. Now there is definitely
> > >> requests in BFQ queue wrt. this hctx. However, looks this request is
> > >> only available from another loser thread, and it won't be retrieved in
> > >> the winning thread via e->type->ops.dispatch_request().
> > >>
> > >> Just wondering why BFQ is implemented in this way?
> > >>
> > >
> > > BFQ inherited this powerful non-working scheme from CFQ, some age ago.
> > >
> > > In more detail: if BFQ has at least one non-empty internal queue, then
> > > is says of course that there is work to do.  But if the currently
> > > in-service queue is empty, and is expected to receive new I/O, then
> > > BFQ plugs I/O dispatch to enforce service guarantees for the
> > > in-service queue, i.e., BFQ responds NULL to a dispatch request.
> >
> > What BFQ is doing is fine, IFF it always ensures that the queue is run
> > at some later time, if it returns "yep I have work" yet returns NULL
> > when attempting to retrieve that work. Generally this should happen from
> > subsequent IO completion, or whatever else condition will resolve the
> > issue that is currently preventing dispatch of that request. Last resort
> > would be a timer, but that can happen if you're slicing your scheduling
> > somehow.
> 
> I've been poking more at this today trying to understand why the idle
> timer that Paolo says is in BFQ isn't doing what it should be doing.
> I've been continuing to put most of my stream-of-consciousness at
> <https://crbug.com/1061950> to avoid so much spamming of this thread.
> In the trace I looked at most recently it looks like BFQ does try to
> ensure that the queue is run at a later time, but at least in this
> trace the later time is not late enough.  Specifically the quick
> summary of my recent trace:
> 
> 28977309us - PID 2167 got the budget.
> 28977518us - BFQ told PID 2167 that there was nothing to dispatch.
> 28977702us - BFQ idle timer fires.
> 28977725us - We start to try to dispatch as a result of BFQ's idle timer.
> 28977732us - Dispatching that was a result of BFQ's idle timer can't get
>              budget and thus does nothing.

Looks the BFQ idle timer may be re-tried given it knows there is work to do.

> 28977780us - PID 2167 put the budget and exits since there was nothing
>              to dispatch.
> 
> This is only one particular trace, but in this case BFQ did attempt to
> rerun the queue after it returned NULL, but that ran almost
> immediately after it returned NULL and thus ran into the race.  :(
> 
> 
> > > It would be very easy to change bfq_has_work so that it returns false
> > > in case the in-service queue is empty, even if there is I/O
> > > backlogged.  My only concern is: since everything has worked with the
> > > current scheme for probably 15 years, are we sure that everything is
> > > still ok after we change this scheme?
> >
> > You're comparing apples to oranges, CFQ never worked within the blk-mq
> > scheduling framework.
> >
> > That said, I don't think such a change is needed. If we currently have a
> > hang due to this discrepancy between has_work and gets_work, then it
> > sounds like we're not always re-running the queue as we should. From the
> > original patch, the budget putting is not something the scheduler is
> > involved with. Do we just need to ensure that if we put budget without
> > having dispatched a request, we need to kick off dispatching again?
> 
> By this you mean a change like this in blk_mq_do_dispatch_sched()?
> 
>   if (!rq) {
>     blk_mq_put_dispatch_budget(hctx);
> +    ret = true;
>     break;
>   }

From Jens's tree, blk_mq_do_dispatch_sched() returns nothing.

Which tree are you talking against?


Thanks, 
Ming

