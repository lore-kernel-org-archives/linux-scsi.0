Return-Path: <SRS0=3U4t=5V=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F04A6C2BA1B
	for <linux-scsi@archiver.kernel.org>; Sun,  5 Apr 2020 14:55:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BD7E4206C3
	for <linux-scsi@archiver.kernel.org>; Sun,  5 Apr 2020 14:55:39 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="n4ExpK4P"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727486AbgDEOzg (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 5 Apr 2020 10:55:36 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:36330 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726776AbgDEOzg (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 5 Apr 2020 10:55:36 -0400
Received: by mail-wr1-f65.google.com with SMTP id k1so4874953wrm.3
        for <linux-scsi@vger.kernel.org>; Sun, 05 Apr 2020 07:55:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=Y6x9lF6LQaJ5xnnciow94qu/zy4NwccGTwrJvLeTDwc=;
        b=n4ExpK4P8iE8rM3NJlug2JEY4FKIQ3rbjACxOuNXrDlfaAlOQpBiMv3VGdkI4C7VBN
         Gxy01sm3AU7nRjxY15IQ6JGNYlGIwOuxxAmkVcBKr7kL5rlfonh0DU4rKq+Q7X/XdBy/
         QaAMwnWfdvnGwRILpLWOJyPaLsEkQwEWmbegBAEl2iliduX0YqBVkPlUjddTe7IHYCgH
         74rA6usdCAMbAnZRPmdaU2wfLCwSXDBrlA8vGtAFNrDElsHsdTKcsfqtfpYBSZTXGBTX
         T1imDwJSuKPx1Z2lyoyR2dxCnyb+R/VcW+lhItE4BhJ/knTpWfA3IeAFrKdIIcj3uKyn
         ZE0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=Y6x9lF6LQaJ5xnnciow94qu/zy4NwccGTwrJvLeTDwc=;
        b=l7NPRmXoNMsUTN7YzzjqTFTVQ4qIVcy3AelHVO/AeDbVcBzJFn5o6NfqaGyVJ+YUUR
         yo7aS9Uat9H4hyFTRblsY9hfHwwZp4JdX4fgQ8t0iIOxjJXeEQG4WjNgnsCQG/PVOumz
         1+YuZAK7UfJkImpRTjixSZCxjFdgUyvU2WbLiwzby2iiaalWPJf3tvuUk8KhDVEcRCKo
         2YEPVgIM4DoZJbqauOWd4TC7aQOCQsdYREu7o75nf/gMzTFyBw2HrbPXhax9E595SIV0
         zFWUUBUa7P6Wn2MF1xrTNtg30dsDLpIpWt5AenhTR62XedGBHgm8bkpY3wUsjXZksX+g
         8reQ==
X-Gm-Message-State: AGi0PuYVeJ5vcXryh0itCQBjDPRRG/l++Yj/uEcBSIiuMnyOmW0nfmjA
        JRMTRlHogbSpWAzxQd/pLhnrfA==
X-Google-Smtp-Source: APiQypKAnX3j9F4dmUp6HVYyvBV28MJlzLyCaJJV0MhAsgsx5LwcjN34/oH8ZpsI/t9CRdH8Rns2SQ==
X-Received: by 2002:a5d:6645:: with SMTP id f5mr19891689wrw.280.1586098533892;
        Sun, 05 Apr 2020 07:55:33 -0700 (PDT)
Received: from [192.168.0.103] ([84.33.141.94])
        by smtp.gmail.com with ESMTPSA id q4sm22566681wmj.1.2020.04.05.07.55.31
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 05 Apr 2020 07:55:33 -0700 (PDT)
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 12.4 \(3445.104.11\))
Subject: Re: [PATCH v2 2/2] blk-mq: Rerun dispatching in the case of budget
 contention
From:   Paolo Valente <paolo.valente@linaro.org>
In-Reply-To: <CAD=FV=X_S_YHvKkp96f3HVM3uX0VFTCKBxNK3fEu9Yt=NB8wEQ@mail.gmail.com>
Date:   Sun, 5 Apr 2020 16:57:13 +0200
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
Content-Transfer-Encoding: quoted-printable
Message-Id: <E316A36E-1B2B-47E8-A78C-7DD3F354425A@linaro.org>
References: <20200402155130.8264-1-dianders@chromium.org>
 <20200402085050.v2.2.I28278ef8ea27afc0ec7e597752a6d4e58c16176f@changeid>
 <20200403013356.GA6987@ming.t460p>
 <CAD=FV=Ub6zhVvTj79SWPUv19RDvD0gt5EjJV-FZSbYxUy_T1OA@mail.gmail.com>
 <CAD=FV=Vsk0SjkA+DbUwJxvO6NFcr0CO9=H1FD7okJ2PxMt5pYA@mail.gmail.com>
 <20200405091446.GA3421@localhost.localdomain>
 <CAD=FV=X_S_YHvKkp96f3HVM3uX0VFTCKBxNK3fEu9Yt=NB8wEQ@mail.gmail.com>
To:     Doug Anderson <dianders@chromium.org>
X-Mailer: Apple Mail (2.3445.104.11)
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org



> Il giorno 5 apr 2020, alle ore 16:00, Doug Anderson =
<dianders@chromium.org> ha scritto:
>=20
> Hi,
>=20
> On Sun, Apr 5, 2020 at 2:15 AM Ming Lei <ming.lei@redhat.com> wrote:
>>=20
>> OK, looks it isn't specific on BFQ any more.
>>=20
>> Follows another candidate approach for this issue, given it is so =
hard
>> to trigger, we can make it more reliable by rerun queue when =
has_work()
>> returns true after ops->dispath_request() returns NULL.
>>=20
>> diff --git a/block/blk-mq-sched.c b/block/blk-mq-sched.c
>> index 74cedea56034..4408e5d4fcd8 100644
>> --- a/block/blk-mq-sched.c
>> +++ b/block/blk-mq-sched.c
>> @@ -80,6 +80,7 @@ void blk_mq_sched_restart(struct blk_mq_hw_ctx =
*hctx)
>>        blk_mq_run_hw_queue(hctx, true);
>> }
>>=20
>> +#define BLK_MQ_BUDGET_DELAY    3               /* ms units */
>> /*
>>  * Only SCSI implements .get_budget and .put_budget, and SCSI =
restarts
>>  * its queue by itself in its completion handler, so we don't need to
>> @@ -103,6 +104,9 @@ static void blk_mq_do_dispatch_sched(struct =
blk_mq_hw_ctx *hctx)
>>                rq =3D e->type->ops.dispatch_request(hctx);
>>                if (!rq) {
>>                        blk_mq_put_dispatch_budget(hctx);
>> +
>> +                       if (e->type->ops.has_work && =
e->type->ops.has_work(hctx))
>> +                               blk_mq_delay_run_hw_queue(hctx, =
BLK_MQ_BUDGET_DELAY);
>=20
> I agree that your patch should solve the race.  With the current BFQ's
> has_work() it's a bit of a disaster though. It will essentially put
> blk-mq into a busy-wait loop (with a 3 ms delay between each poll)
> while BFQ's has_work() says "true" but BFQ doesn't dispatch anything.
>=20
> ...so I guess the question that still needs to be answered: does
> has_work() need to be exact?  If so then we need the patch you propose
> plus one to BFQ.  If not, we should continue along the lines of my
> patch.
>=20

Some more comments.  BFQ's I/O plugging lasts 9 ms by default.  So,
with this last Ming's patch, BFQ may happen to be polled every 3ms,
for at most three times.

On the opposite end, making bfq_has_work plugging aware costs more
complexity, and possibly one more lock.  While avoiding the above
occasional polling, this may imply a lot of overhead or CPU stalls on
every dispatch.

Paolo
=20
> -Doug

