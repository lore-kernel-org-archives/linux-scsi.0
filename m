Return-Path: <SRS0=qNH0=5X=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EE709C2BB55
	for <linux-scsi@archiver.kernel.org>; Tue,  7 Apr 2020 22:04:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CA0B0206C0
	for <linux-scsi@archiver.kernel.org>; Tue,  7 Apr 2020 22:04:35 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="EDpSU9+3"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726492AbgDGWEf (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 7 Apr 2020 18:04:35 -0400
Received: from mail-vs1-f66.google.com ([209.85.217.66]:37366 "EHLO
        mail-vs1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726393AbgDGWEf (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 7 Apr 2020 18:04:35 -0400
Received: by mail-vs1-f66.google.com with SMTP id o3so3487634vsd.4
        for <linux-scsi@vger.kernel.org>; Tue, 07 Apr 2020 15:04:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=FcYVbwRy7qPzYPxF2uVobHVwbwhKOGFJJ0f6jVVp4qc=;
        b=EDpSU9+3vSDiHbPzXJwkVB41VD773ddvZ2XAEKXuJacwUm5dvTEpqcpoGt1jjkYg9Z
         /4FL46J2z60kPy/RlHgBbfan5YGebhTpD4W1ejOHuri5M3XeaXe5P8dVtFqdLAjEL+ed
         axbbvcHv0tSnEQKhza5grVDB+jYhJdXTCUDkY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=FcYVbwRy7qPzYPxF2uVobHVwbwhKOGFJJ0f6jVVp4qc=;
        b=aEHn3mi2MZlOR9pBNv3MLmGYurS7JKGeVs5Ku+Avv8AbGPLMnOtzc5lX5R3X9vQoH+
         MaXf/xX5XC2t9UQQTMQUq7cIVnfAM0aaQpBAX4BHogf8BfdRkGqD3HUGyfOgNg0SIUnx
         UFZvfs+CmcsnODbKeF89WLqgRa9aC86afz0A1NXf8BNlrDPe8IzhZqTDq9g0e2YW/QaT
         eVbdXkt5rhgSc+7TsuFXmflxr9aMePe7S2aB8GbUhGZAqJQPnr8Wn4aNAiD1k1kkcC4f
         1tmz7JVwO/r7mN+mCq6DQuwv9/y7sq1cJWbE1UTTG2EvlK2igifqJnwUO7y3Zn/nMq+J
         T5kw==
X-Gm-Message-State: AGi0Pubs+BNrGWzjpTTAhcsM0Oht6JiL6D/s6er76FOWQzFsWYUax5SW
        kLh8ZpkYETuAy3OfuGN+yZo2y3vs3vA=
X-Google-Smtp-Source: APiQypK3urz74l2EotoJMyIm1A8hQPm8sDNf3azAyaWD2TFA7h5np5YeLzMYNLKUPqh+hom4Ei3xCw==
X-Received: by 2002:a67:2fd8:: with SMTP id v207mr3749565vsv.233.1586297073793;
        Tue, 07 Apr 2020 15:04:33 -0700 (PDT)
Received: from mail-ua1-f46.google.com (mail-ua1-f46.google.com. [209.85.222.46])
        by smtp.gmail.com with ESMTPSA id m82sm5844434vke.53.2020.04.07.15.04.32
        for <linux-scsi@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 07 Apr 2020 15:04:32 -0700 (PDT)
Received: by mail-ua1-f46.google.com with SMTP id d23so1972684uak.1
        for <linux-scsi@vger.kernel.org>; Tue, 07 Apr 2020 15:04:32 -0700 (PDT)
X-Received: by 2002:a9f:2478:: with SMTP id 111mr3368330uaq.0.1586297071641;
 Tue, 07 Apr 2020 15:04:31 -0700 (PDT)
MIME-Version: 1.0
References: <20200402155130.8264-1-dianders@chromium.org> <20200402085050.v2.2.I28278ef8ea27afc0ec7e597752a6d4e58c16176f@changeid>
 <20200403013356.GA6987@ming.t460p> <CAD=FV=Ub6zhVvTj79SWPUv19RDvD0gt5EjJV-FZSbYxUy_T1OA@mail.gmail.com>
 <CAD=FV=Vsk0SjkA+DbUwJxvO6NFcr0CO9=H1FD7okJ2PxMt5pYA@mail.gmail.com>
 <20200405091446.GA3421@localhost.localdomain> <CAD=FV=WQZA7PGEbv_fKikGOEijP+qEEZgYXWifgjDzV6BVOUMQ@mail.gmail.com>
 <20200407021403.GB5779@localhost.localdomain>
In-Reply-To: <20200407021403.GB5779@localhost.localdomain>
From:   Doug Anderson <dianders@chromium.org>
Date:   Tue, 7 Apr 2020 15:04:20 -0700
X-Gmail-Original-Message-ID: <CAD=FV=UmdL5d13FqpwVC8MokY8yzMV=_wNe=42vtDx9OVNvpkQ@mail.gmail.com>
Message-ID: <CAD=FV=UmdL5d13FqpwVC8MokY8yzMV=_wNe=42vtDx9OVNvpkQ@mail.gmail.com>
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

On Mon, Apr 6, 2020 at 7:14 PM Ming Lei <ming.lei@redhat.com> wrote:
>
> On Sun, Apr 05, 2020 at 09:26:39AM -0700, Doug Anderson wrote:
> > Hi,
> >
> > On Sun, Apr 5, 2020 at 2:15 AM Ming Lei <ming.lei@redhat.com> wrote:
> > >
> > > @@ -103,6 +104,9 @@ static void blk_mq_do_dispatch_sched(struct blk_mq_hw_ctx *hctx)
> > >                 rq = e->type->ops.dispatch_request(hctx);
> > >                 if (!rq) {
> > >                         blk_mq_put_dispatch_budget(hctx);
> > > +
> > > +                       if (e->type->ops.has_work && e->type->ops.has_work(hctx))
> > > +                               blk_mq_delay_run_hw_queue(hctx, BLK_MQ_BUDGET_DELAY);
> >
> > To really close the race, don't we need to run all the queues
> > associated with the hctx?  I haven't traced it through, but I've been
> > assuming that the multiple "hctx"s associated with the same queue will
> > have the same budget associated with them and thus they can block each
> > other out.
>
> Yeah, we should run all hctxs which share the same budget space.
>
> Also, in theory, we don't have to add the delay, however BFQ may plug the
> dispatch for 9 ms, so looks delay run queue is required.

I have posted up v3.  A few notes:

* Since we should run all "hctxs" I took out the check for has_work()
before kicking the queue.

* As far as I can tell the theoretical race happens for _anyone_ who
puts budget, so I added it to blk_mq_put_dispatch_budget().  Feel free
to shout at me in response to v3 if you believe I'm wrong about that.

Thanks for all your reviews and suggestions so far!

-Doug
