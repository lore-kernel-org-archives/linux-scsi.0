Return-Path: <SRS0=3U4t=5V=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2AAE5C2D0F4
	for <linux-scsi@archiver.kernel.org>; Sun,  5 Apr 2020 14:01:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E9511206F8
	for <linux-scsi@archiver.kernel.org>; Sun,  5 Apr 2020 14:01:01 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="Rgz2/Mn+"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726692AbgDEOBB (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 5 Apr 2020 10:01:01 -0400
Received: from mail-vs1-f66.google.com ([209.85.217.66]:39209 "EHLO
        mail-vs1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726669AbgDEOBB (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 5 Apr 2020 10:01:01 -0400
Received: by mail-vs1-f66.google.com with SMTP id u9so8032179vsp.6
        for <linux-scsi@vger.kernel.org>; Sun, 05 Apr 2020 07:01:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=D1Alutm8Kz0gIUiQDyHVyu0RXaT8qrBV0QAHZoy8LI8=;
        b=Rgz2/Mn+rn4dCEVcoawWzXBK5JL6tV65J4lw4QvmUiox3TESU526+qFxhBlUrPXdr6
         UOxz+3do+0YW5XmA1tmpOLMpXRfXXybaoSfMxUi28ozSZ2JMEQNzUDTr4VvmdjWwPLd4
         X4AStBSbH3MujuRQV3kB2CekDrMCOZAXxzkCU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=D1Alutm8Kz0gIUiQDyHVyu0RXaT8qrBV0QAHZoy8LI8=;
        b=EpGQKCWzzwH1NHchiXS54UoOAIQvnu/N5WO88dZRM9jYfqH+7+zPGMsZvvlnK/3EgZ
         2uJ/RSWFeWMvQW7VK6xKik18KCwpKGPug1gV4DjKhrBkodoHwypTYCCjAxhQFvwMWl8V
         rKUZFFMi5lJGeBSVnjmiErepICp16izjbNCGBYy1up0fqHnuwF8h7F5I7ykLhOHRlKR8
         mE4uzuTo/+M+8aaxE1j5gnx9uDbPURGzWBsSwxevlxBrQcx64qzMCPxFtLhp2gaV9o/2
         l6QXdhfO9bWV4aJa5lBeXE0E9yIHI7TQtxKz6W44PT8oHqLFgXLwRw1bItsebBy2C76Z
         o5iw==
X-Gm-Message-State: AGi0PuYakb/BTZ4S7ODZ98pNQHDdDurUIVWBE+7Bevd9nanxY3S3MNRn
        Q1WfzKFIpKs5iFft6C8qdmdDFOWoW4A=
X-Google-Smtp-Source: APiQypJ4v7gqFgJNfphiYdrwELRgsJtpEfd9o370SuD9cYVUECETT0J/TMgPh6o8r3FnDjsBxxEdpA==
X-Received: by 2002:a67:845:: with SMTP id 66mr12809238vsi.189.1586095260149;
        Sun, 05 Apr 2020 07:01:00 -0700 (PDT)
Received: from mail-vk1-f182.google.com (mail-vk1-f182.google.com. [209.85.221.182])
        by smtp.gmail.com with ESMTPSA id g25sm3656753vsq.21.2020.04.05.07.00.58
        for <linux-scsi@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 05 Apr 2020 07:00:59 -0700 (PDT)
Received: by mail-vk1-f182.google.com with SMTP id e20so3254271vke.9
        for <linux-scsi@vger.kernel.org>; Sun, 05 Apr 2020 07:00:58 -0700 (PDT)
X-Received: by 2002:a1f:a055:: with SMTP id j82mr11678218vke.75.1586095258097;
 Sun, 05 Apr 2020 07:00:58 -0700 (PDT)
MIME-Version: 1.0
References: <20200402155130.8264-1-dianders@chromium.org> <20200402085050.v2.2.I28278ef8ea27afc0ec7e597752a6d4e58c16176f@changeid>
 <20200403013356.GA6987@ming.t460p> <CAD=FV=Ub6zhVvTj79SWPUv19RDvD0gt5EjJV-FZSbYxUy_T1OA@mail.gmail.com>
 <CAD=FV=Vsk0SjkA+DbUwJxvO6NFcr0CO9=H1FD7okJ2PxMt5pYA@mail.gmail.com> <20200405091446.GA3421@localhost.localdomain>
In-Reply-To: <20200405091446.GA3421@localhost.localdomain>
From:   Doug Anderson <dianders@chromium.org>
Date:   Sun, 5 Apr 2020 07:00:46 -0700
X-Gmail-Original-Message-ID: <CAD=FV=X_S_YHvKkp96f3HVM3uX0VFTCKBxNK3fEu9Yt=NB8wEQ@mail.gmail.com>
Message-ID: <CAD=FV=X_S_YHvKkp96f3HVM3uX0VFTCKBxNK3fEu9Yt=NB8wEQ@mail.gmail.com>
Subject: Re: [PATCH v2 2/2] blk-mq: Rerun dispatching in the case of budget contention
To:     Ming Lei <ming.lei@redhat.com>
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
Content-Type: text/plain; charset="UTF-8"
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi,

On Sun, Apr 5, 2020 at 2:15 AM Ming Lei <ming.lei@redhat.com> wrote:
>
> OK, looks it isn't specific on BFQ any more.
>
> Follows another candidate approach for this issue, given it is so hard
> to trigger, we can make it more reliable by rerun queue when has_work()
> returns true after ops->dispath_request() returns NULL.
>
> diff --git a/block/blk-mq-sched.c b/block/blk-mq-sched.c
> index 74cedea56034..4408e5d4fcd8 100644
> --- a/block/blk-mq-sched.c
> +++ b/block/blk-mq-sched.c
> @@ -80,6 +80,7 @@ void blk_mq_sched_restart(struct blk_mq_hw_ctx *hctx)
>         blk_mq_run_hw_queue(hctx, true);
>  }
>
> +#define BLK_MQ_BUDGET_DELAY    3               /* ms units */
>  /*
>   * Only SCSI implements .get_budget and .put_budget, and SCSI restarts
>   * its queue by itself in its completion handler, so we don't need to
> @@ -103,6 +104,9 @@ static void blk_mq_do_dispatch_sched(struct blk_mq_hw_ctx *hctx)
>                 rq = e->type->ops.dispatch_request(hctx);
>                 if (!rq) {
>                         blk_mq_put_dispatch_budget(hctx);
> +
> +                       if (e->type->ops.has_work && e->type->ops.has_work(hctx))
> +                               blk_mq_delay_run_hw_queue(hctx, BLK_MQ_BUDGET_DELAY);

I agree that your patch should solve the race.  With the current BFQ's
has_work() it's a bit of a disaster though. It will essentially put
blk-mq into a busy-wait loop (with a 3 ms delay between each poll)
while BFQ's has_work() says "true" but BFQ doesn't dispatch anything.

...so I guess the question that still needs to be answered: does
has_work() need to be exact?  If so then we need the patch you propose
plus one to BFQ.  If not, we should continue along the lines of my
patch.

-Doug
