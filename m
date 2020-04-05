Return-Path: <SRS0=3U4t=5V=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A78E6C2BA15
	for <linux-scsi@archiver.kernel.org>; Sun,  5 Apr 2020 16:16:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6710320659
	for <linux-scsi@archiver.kernel.org>; Sun,  5 Apr 2020 16:16:49 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="P3tSPTDy"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726921AbgDEQQs (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 5 Apr 2020 12:16:48 -0400
Received: from mail-vk1-f196.google.com ([209.85.221.196]:34799 "EHLO
        mail-vk1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726771AbgDEQQs (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 5 Apr 2020 12:16:48 -0400
Received: by mail-vk1-f196.google.com with SMTP id p123so3328094vkg.1
        for <linux-scsi@vger.kernel.org>; Sun, 05 Apr 2020 09:16:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=T6xRDGarxRrQ+McG4oPgKgxZsvgT+lL55o+pn4FdRW0=;
        b=P3tSPTDy1xRCb4k4SD8xFq/6fzytUsmxxMdM64YWsMUx3U5tS7FSoWOyXGdQXL/yx2
         aPc7DVKSQ/3ZhfEsfW2SSW5Et/Zl/uzf4kwog2W8BEUyD0Rv7WDaRQc7KpiT+IvUT5XV
         p/eA9XCxpHNeW8oBcj+LcVOmpJfnXskYJ0SaM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=T6xRDGarxRrQ+McG4oPgKgxZsvgT+lL55o+pn4FdRW0=;
        b=BIikjGibQqSSXwtfKnVDJzt8RA/GQGuHfnLBCgNXaYONNAbpimri/HF29PNBcHoiyc
         OehSSmxhm7toFB0eB5Rs6PYoJ9Tg/HuQVeVUF0/wKf/Z9ewfQbUtJ74gKxNdzB+Jnoi0
         dOyw/zdyESZzJVCLS0QIuCPlL5LdpbeGZLw721pcNdxbSQutteSFSSgg95bnvygp73y3
         VJ+BsPXqmmQJq5GyqPcvBGbbKMJS3dHmOnOtFu1ywrNBF+hClyYuM01tuwjb1OdWMbJ9
         BpBJjO4X/smLOGUpnG4KhTfURQf+iBDMkV9oR9VuAggCH5aSQCqfOZkbbs674QDCw5QQ
         Fo0Q==
X-Gm-Message-State: AGi0Pubf/m7gKfqDhP4OjYgKD9XGsE4FzSlcXGgANWN6xoKef5hlD/ub
        kC+dkIPJiNrn5PXG9NsUc/Xik/YDYsY=
X-Google-Smtp-Source: APiQypKNCD0Tvq3vDUIMySb73ouQ2xdcjXNFPEJF2N7evnHyfWCWQpuwE/9V7/f1hDH0WopfS5i1dw==
X-Received: by 2002:a1f:38c6:: with SMTP id f189mr11801644vka.52.1586103406465;
        Sun, 05 Apr 2020 09:16:46 -0700 (PDT)
Received: from mail-ua1-f42.google.com (mail-ua1-f42.google.com. [209.85.222.42])
        by smtp.gmail.com with ESMTPSA id u187sm3944638vku.29.2020.04.05.09.16.43
        for <linux-scsi@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 05 Apr 2020 09:16:45 -0700 (PDT)
Received: by mail-ua1-f42.google.com with SMTP id g24so4578160uan.10
        for <linux-scsi@vger.kernel.org>; Sun, 05 Apr 2020 09:16:43 -0700 (PDT)
X-Received: by 2002:ab0:2389:: with SMTP id b9mr10876340uan.120.1586103403434;
 Sun, 05 Apr 2020 09:16:43 -0700 (PDT)
MIME-Version: 1.0
References: <20200402155130.8264-1-dianders@chromium.org> <20200402085050.v2.2.I28278ef8ea27afc0ec7e597752a6d4e58c16176f@changeid>
 <20200403013356.GA6987@ming.t460p> <CAD=FV=Ub6zhVvTj79SWPUv19RDvD0gt5EjJV-FZSbYxUy_T1OA@mail.gmail.com>
 <CAD=FV=Vsk0SjkA+DbUwJxvO6NFcr0CO9=H1FD7okJ2PxMt5pYA@mail.gmail.com>
 <20200405091446.GA3421@localhost.localdomain> <CAD=FV=X_S_YHvKkp96f3HVM3uX0VFTCKBxNK3fEu9Yt=NB8wEQ@mail.gmail.com>
 <E316A36E-1B2B-47E8-A78C-7DD3F354425A@linaro.org>
In-Reply-To: <E316A36E-1B2B-47E8-A78C-7DD3F354425A@linaro.org>
From:   Doug Anderson <dianders@chromium.org>
Date:   Sun, 5 Apr 2020 09:16:30 -0700
X-Gmail-Original-Message-ID: <CAD=FV=UK=4OW2Q5i2FhrJw_+A-q+R=K8E5ui-PCQXvYhDY3ZHw@mail.gmail.com>
Message-ID: <CAD=FV=UK=4OW2Q5i2FhrJw_+A-q+R=K8E5ui-PCQXvYhDY3ZHw@mail.gmail.com>
Subject: Re: [PATCH v2 2/2] blk-mq: Rerun dispatching in the case of budget contention
To:     Paolo Valente <paolo.valente@linaro.org>
Cc:     Ming Lei <ming.lei@redhat.com>, Jens Axboe <axboe@kernel.dk>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
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
Content-Type: text/plain; charset="UTF-8"
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi,

On Sun, Apr 5, 2020 at 7:55 AM Paolo Valente <paolo.valente@linaro.org> wrote:
>
> > Il giorno 5 apr 2020, alle ore 16:00, Doug Anderson <dianders@chromium.org> ha scritto:
> >
> > Hi,
> >
> > On Sun, Apr 5, 2020 at 2:15 AM Ming Lei <ming.lei@redhat.com> wrote:
> >>
> >> OK, looks it isn't specific on BFQ any more.
> >>
> >> Follows another candidate approach for this issue, given it is so hard
> >> to trigger, we can make it more reliable by rerun queue when has_work()
> >> returns true after ops->dispath_request() returns NULL.
> >>
> >> diff --git a/block/blk-mq-sched.c b/block/blk-mq-sched.c
> >> index 74cedea56034..4408e5d4fcd8 100644
> >> --- a/block/blk-mq-sched.c
> >> +++ b/block/blk-mq-sched.c
> >> @@ -80,6 +80,7 @@ void blk_mq_sched_restart(struct blk_mq_hw_ctx *hctx)
> >>        blk_mq_run_hw_queue(hctx, true);
> >> }
> >>
> >> +#define BLK_MQ_BUDGET_DELAY    3               /* ms units */
> >> /*
> >>  * Only SCSI implements .get_budget and .put_budget, and SCSI restarts
> >>  * its queue by itself in its completion handler, so we don't need to
> >> @@ -103,6 +104,9 @@ static void blk_mq_do_dispatch_sched(struct blk_mq_hw_ctx *hctx)
> >>                rq = e->type->ops.dispatch_request(hctx);
> >>                if (!rq) {
> >>                        blk_mq_put_dispatch_budget(hctx);
> >> +
> >> +                       if (e->type->ops.has_work && e->type->ops.has_work(hctx))
> >> +                               blk_mq_delay_run_hw_queue(hctx, BLK_MQ_BUDGET_DELAY);
> >
> > I agree that your patch should solve the race.  With the current BFQ's
> > has_work() it's a bit of a disaster though. It will essentially put
> > blk-mq into a busy-wait loop (with a 3 ms delay between each poll)
> > while BFQ's has_work() says "true" but BFQ doesn't dispatch anything.
> >
> > ...so I guess the question that still needs to be answered: does
> > has_work() need to be exact?  If so then we need the patch you propose
> > plus one to BFQ.  If not, we should continue along the lines of my
> > patch.
> >
>
> Some more comments.  BFQ's I/O plugging lasts 9 ms by default.  So,
> with this last Ming's patch, BFQ may happen to be polled every 3ms,
> for at most three times.

Ah!  I did not know this.  OK, then Ming's patch seems like it should
work.  If nothing else it should fix the problem.  If this ends up
making BFQ chew up too much CPU time then presumably someone will
notice and BFQ's has_work() can be improved.

Ming: how do you want to proceed?  Do you want to formally post the
patch?  Do you want me to post a v3 of my series where I place patch
#2 with your patch?  Do you want authorship (which implies adding your
Signed-off-by)?


> On the opposite end, making bfq_has_work plugging aware costs more
> complexity, and possibly one more lock.  While avoiding the above
> occasional polling, this may imply a lot of overhead or CPU stalls on
> every dispatch.

I still think it would be interesting to run performance tests with my
proof-of-concept solution for has_work().  Even if it's not ideal,
knowing whether performance increased, decreased, or stayed the same
would give information about how much more effort should be put into
this.

-Doug
