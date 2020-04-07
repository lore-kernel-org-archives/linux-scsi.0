Return-Path: <SRS0=qNH0=5X=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 366CDC2BB85
	for <linux-scsi@archiver.kernel.org>; Tue,  7 Apr 2020 10:42:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 054252078A
	for <linux-scsi@archiver.kernel.org>; Tue,  7 Apr 2020 10:42:17 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="ZVsIwruV"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728386AbgDGKmQ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 7 Apr 2020 06:42:16 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:35969 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728362AbgDGKmP (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 7 Apr 2020 06:42:15 -0400
Received: by mail-wm1-f68.google.com with SMTP id d202so1299352wmd.1
        for <linux-scsi@vger.kernel.org>; Tue, 07 Apr 2020 03:42:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=qwoI7riVDu0AahmoSXPZbaJVLWK9qNlpZnhfM3M9Fk0=;
        b=ZVsIwruVeUye+mQQvLbyyVdlLUN12dHiYTZbkDZJRK5mBmzn1kqKnXKpHb1VZtkLTS
         ecHYgPu0S0sKnUd1uNQ+MzHs8zoxJFHoVC8rfc3mGxyWFwPUfXc6TjY2CKSBhfabbPGp
         puRg2p8PL9QRfce2n6nRy8s4OxClPWst8M78PMHXPyNHXDmIDQLcdxrR//WsZGSOSOaK
         qHeHL41NiYQvhz6e4sGihGccVYVbPrDmsaGDEdpt5dftN/eO7T+7V3jIjoNLLp5BbCyO
         5Uvks8G63sZJzf/toQyi3VLYIToL55zReTlvS1aLNpmwf6ylLh6KCE1AHJfoLcwtd/3Q
         EhCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=qwoI7riVDu0AahmoSXPZbaJVLWK9qNlpZnhfM3M9Fk0=;
        b=MHjomevBHvpcm1mS26je6BU/wsqRBni1n3dprLNUf9FGV1PeIgYHYcq4kEFE5Ww8v+
         pCmkat9Ikmfg58yEzvNknj0MWKrgdNZXvjktSVAx1xJhkwHmlEaTy/iaV3MMsqP34R8E
         aflmzZHbh7JLzBiFN7dt62lUX1yBP+Jf/mZEB8X5zGbG1q2dDFtQ7Jd0qDCrSavMaDk3
         MadNGHeIB6Fe/7I5FSNLvYscABEdMikRbPyFMmhPCJYpf9YySFvAjVQA0jwAG0jAZO5z
         /24hjyO9NxGuWUUcgiMOf8aBPR0n7PT3t+FweRY6Wyb/VxZR9yaJTk95lfhYJC7jVV3j
         /bDw==
X-Gm-Message-State: AGi0PuY5vzCfXkiV3ev2rujtrOwaX44FzuGcIfNQYcpdDTFdDYd7eaeE
        GI5J6IW09cbl/vtWD3o/4al1wQ==
X-Google-Smtp-Source: APiQypKDHeqfnBtlcrpc5vBuaPo8+WiRBN+xcEEELjZAHyRBT1S85K8BXirTii7Uh5nK4VgEhCiSlA==
X-Received: by 2002:a1c:5502:: with SMTP id j2mr1756335wmb.93.1586256131946;
        Tue, 07 Apr 2020 03:42:11 -0700 (PDT)
Received: from [192.168.0.105] ([84.33.141.156])
        by smtp.gmail.com with ESMTPSA id y22sm1908552wma.18.2020.04.07.03.42.10
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 07 Apr 2020 03:42:11 -0700 (PDT)
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 12.4 \(3445.104.11\))
Subject: Re: [PATCH v2 2/2] blk-mq: Rerun dispatching in the case of budget
 contention
From:   Paolo Valente <paolo.valente@linaro.org>
In-Reply-To: <CAD=FV=UK=4OW2Q5i2FhrJw_+A-q+R=K8E5ui-PCQXvYhDY3ZHw@mail.gmail.com>
Date:   Tue, 7 Apr 2020 12:43:58 +0200
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
Message-Id: <B7C03D1F-7048-4FDF-AAAF-BCD0F95132E6@linaro.org>
References: <20200402155130.8264-1-dianders@chromium.org>
 <20200402085050.v2.2.I28278ef8ea27afc0ec7e597752a6d4e58c16176f@changeid>
 <20200403013356.GA6987@ming.t460p>
 <CAD=FV=Ub6zhVvTj79SWPUv19RDvD0gt5EjJV-FZSbYxUy_T1OA@mail.gmail.com>
 <CAD=FV=Vsk0SjkA+DbUwJxvO6NFcr0CO9=H1FD7okJ2PxMt5pYA@mail.gmail.com>
 <20200405091446.GA3421@localhost.localdomain>
 <CAD=FV=X_S_YHvKkp96f3HVM3uX0VFTCKBxNK3fEu9Yt=NB8wEQ@mail.gmail.com>
 <E316A36E-1B2B-47E8-A78C-7DD3F354425A@linaro.org>
 <CAD=FV=UK=4OW2Q5i2FhrJw_+A-q+R=K8E5ui-PCQXvYhDY3ZHw@mail.gmail.com>
To:     Doug Anderson <dianders@chromium.org>
X-Mailer: Apple Mail (2.3445.104.11)
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org



> Il giorno 5 apr 2020, alle ore 18:16, Doug Anderson =
<dianders@chromium.org> ha scritto:
>=20
> Hi,
>=20
> On Sun, Apr 5, 2020 at 7:55 AM Paolo Valente =
<paolo.valente@linaro.org> wrote:
>>=20
>>> Il giorno 5 apr 2020, alle ore 16:00, Doug Anderson =
<dianders@chromium.org> ha scritto:
>>>=20
>>> Hi,
>>>=20
>>> On Sun, Apr 5, 2020 at 2:15 AM Ming Lei <ming.lei@redhat.com> wrote:
>>>>=20
>>>> OK, looks it isn't specific on BFQ any more.
>>>>=20
>>>> Follows another candidate approach for this issue, given it is so =
hard
>>>> to trigger, we can make it more reliable by rerun queue when =
has_work()
>>>> returns true after ops->dispath_request() returns NULL.
>>>>=20
>>>> diff --git a/block/blk-mq-sched.c b/block/blk-mq-sched.c
>>>> index 74cedea56034..4408e5d4fcd8 100644
>>>> --- a/block/blk-mq-sched.c
>>>> +++ b/block/blk-mq-sched.c
>>>> @@ -80,6 +80,7 @@ void blk_mq_sched_restart(struct blk_mq_hw_ctx =
*hctx)
>>>>       blk_mq_run_hw_queue(hctx, true);
>>>> }
>>>>=20
>>>> +#define BLK_MQ_BUDGET_DELAY    3               /* ms units */
>>>> /*
>>>> * Only SCSI implements .get_budget and .put_budget, and SCSI =
restarts
>>>> * its queue by itself in its completion handler, so we don't need =
to
>>>> @@ -103,6 +104,9 @@ static void blk_mq_do_dispatch_sched(struct =
blk_mq_hw_ctx *hctx)
>>>>               rq =3D e->type->ops.dispatch_request(hctx);
>>>>               if (!rq) {
>>>>                       blk_mq_put_dispatch_budget(hctx);
>>>> +
>>>> +                       if (e->type->ops.has_work && =
e->type->ops.has_work(hctx))
>>>> +                               blk_mq_delay_run_hw_queue(hctx, =
BLK_MQ_BUDGET_DELAY);
>>>=20
>>> I agree that your patch should solve the race.  With the current =
BFQ's
>>> has_work() it's a bit of a disaster though. It will essentially put
>>> blk-mq into a busy-wait loop (with a 3 ms delay between each poll)
>>> while BFQ's has_work() says "true" but BFQ doesn't dispatch =
anything.
>>>=20
>>> ...so I guess the question that still needs to be answered: does
>>> has_work() need to be exact?  If so then we need the patch you =
propose
>>> plus one to BFQ.  If not, we should continue along the lines of my
>>> patch.
>>>=20
>>=20
>> Some more comments.  BFQ's I/O plugging lasts 9 ms by default.  So,
>> with this last Ming's patch, BFQ may happen to be polled every 3ms,
>> for at most three times.
>=20
> Ah!  I did not know this.  OK, then Ming's patch seems like it should
> work.  If nothing else it should fix the problem.  If this ends up
> making BFQ chew up too much CPU time then presumably someone will
> notice and BFQ's has_work() can be improved.
>=20
> Ming: how do you want to proceed?  Do you want to formally post the
> patch?  Do you want me to post a v3 of my series where I place patch
> #2 with your patch?  Do you want authorship (which implies adding your
> Signed-off-by)?
>=20
>=20
>> On the opposite end, making bfq_has_work plugging aware costs more
>> complexity, and possibly one more lock.  While avoiding the above
>> occasional polling, this may imply a lot of overhead or CPU stalls on
>> every dispatch.
>=20
> I still think it would be interesting to run performance tests with my
> proof-of-concept solution for has_work().  Even if it's not ideal,
> knowing whether performance increased, decreased, or stayed the same
> would give information about how much more effort should be put into
> this.
>=20

Why not?  It is however hard to hope that we add only negligible
overhead and CPU stalls if we move from one lock-protected section per
I/O-request dispatch, to two or more lock-protected sections per
request (has_work may be invoked several times per request).

At any rate, if useful, one of the scripts in my S benchmark suite can
also measure max IOPS (when limited only by I/O processing) [1].  The
script is for Linux distros; I don't know whether it works in your
environments of interest, Doug.

Paolo

[1] =
https://github.com/Algodev-github/S/blob/master/throughput-sync/throughput=
-sync.sh

> -Doug

