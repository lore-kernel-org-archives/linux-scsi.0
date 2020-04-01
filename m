Return-Path: <SRS0=ctNG=5R=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E9FB2C43331
	for <linux-scsi@archiver.kernel.org>; Wed,  1 Apr 2020 07:48:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AC6FB20714
	for <linux-scsi@archiver.kernel.org>; Wed,  1 Apr 2020 07:48:17 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="vERgFZtS"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731910AbgDAHsR (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 1 Apr 2020 03:48:17 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:43288 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731879AbgDAHsR (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 1 Apr 2020 03:48:17 -0400
Received: by mail-wr1-f68.google.com with SMTP id m11so23453894wrx.10
        for <linux-scsi@vger.kernel.org>; Wed, 01 Apr 2020 00:48:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=Lqlo+Tn7Tg2M14wJLKEZDcQDoUNo94atXFdRfztlgjI=;
        b=vERgFZtShKXGk8+XcSyKqRHMttP9ThUnz6Q1c5KyJ43+hp5MJhYniufdVrCsJ5nxQd
         FU4AaMAx+O/kg3pW6PRx0AJgey+OyXMqP34/UFKXnb0QAzAfCz5DdTCxG31/Ob8iL+dV
         FTSi15SZWQ9PYPpUodVPfYb3wMV/MMQCL6R8PMoh8EgW6+6hYO2YgRJuTD37qWAQmBpJ
         x/M+gqmYGBGuQE2j3jcg3q6QWwJEY/EAgeb/IgLDsGGLMdpzvsNtXJvbgVrshtLnESgJ
         GZNO/P/UCqDIfDdEiFiY6o5OdYRSdJ20imQVICakjcKcjilXHoVf59AfKeonjgFofSnB
         ubMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=Lqlo+Tn7Tg2M14wJLKEZDcQDoUNo94atXFdRfztlgjI=;
        b=hCytWmNDQnMmKP4SrCTw1IVEkIiMH3SyTJtcTw8MCbk1UTGWrs2YDrzGR9CQPtHbU0
         SQaypprR5ZCZXjeCi7UGrlfmXNeMp0cvDWFBh5d4bgmV3vEz05+QtnLbHImHt31wFST3
         /BouLEZLh5aq622jazJQntA/acbriunDdVpvquf4KKdtbCoxTPPriSooYjxJ22CTW1qS
         MT7ue5xMVD6xqTI5Ppn5x/mAYOlQQmJA4xBjyex5NwkB1UpQGfxguEGpRZ4O2GOkE5To
         5vlH31/rqemeQ72J5aFcYGq5dZjQfaOAIfCK76i3hlXuKuIEUI69lyK0kZGxZkrAMuzI
         0Hgg==
X-Gm-Message-State: ANhLgQ3RfkBx6uthzgoXnaxO9GHEHPP1E4U5p7/rThOTM6oR0gNZnh9Z
        Noj8x4hKpgbKUupBMGQE3Hmjag==
X-Google-Smtp-Source: ADFU+vu0BnN/UnzvN+DA+awjDremMq0c6GPFHN6sR1QaGITUYep+z/MlmIANQsTbRBvIoKXdZkabfQ==
X-Received: by 2002:adf:97c8:: with SMTP id t8mr24370675wrb.319.1585727294449;
        Wed, 01 Apr 2020 00:48:14 -0700 (PDT)
Received: from [192.168.0.102] ([84.33.172.71])
        by smtp.gmail.com with ESMTPSA id n2sm1891553wro.25.2020.04.01.00.48.12
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 01 Apr 2020 00:48:13 -0700 (PDT)
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 12.4 \(3445.104.11\))
Subject: Re: [PATCH 2/2] scsi: core: Fix stall if two threads request budget
 at the same time
From:   Paolo Valente <paolo.valente@linaro.org>
In-Reply-To: <02968c1d-bd3a-af9c-77e7-23a9d9aa9af4@kernel.dk>
Date:   Wed, 1 Apr 2020 09:49:40 +0200
Cc:     Doug Anderson <dianders@chromium.org>,
        Ming Lei <ming.lei@redhat.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-block <linux-block@vger.kernel.org>,
        Guenter Roeck <groeck@chromium.org>,
        linux-scsi@vger.kernel.org, Salman Qazi <sqazi@google.com>,
        LKML <linux-kernel@vger.kernel.org>
Content-Transfer-Encoding: quoted-printable
Message-Id: <1D4B63FC-FA4B-4C73-B70F-6639CC41D3A6@linaro.org>
References: <20200330144907.13011-1-dianders@chromium.org>
 <20200330074856.2.I28278ef8ea27afc0ec7e597752a6d4e58c16176f@changeid>
 <20200331014109.GA20230@ming.t460p>
 <D38AB98D-7F6A-4C61-8A8F-C22C53671AC8@linaro.org>
 <d6af2344-11f7-5862-daed-e21cbd496d92@kernel.dk>
 <CAD=FV=WHYFDoUKLnwMCm-o=gEQDCzZFeMAvia3wpJzm9XX7Bow@mail.gmail.com>
 <02968c1d-bd3a-af9c-77e7-23a9d9aa9af4@kernel.dk>
To:     Jens Axboe <axboe@kernel.dk>
X-Mailer: Apple Mail (2.3445.104.11)
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org



> Il giorno 1 apr 2020, alle ore 03:21, Jens Axboe <axboe@kernel.dk> ha =
scritto:
>=20
> On 3/31/20 5:51 PM, Doug Anderson wrote:
>> Hi,
>>=20
>> On Tue, Mar 31, 2020 at 11:26 AM Jens Axboe <axboe@kernel.dk> wrote:
>>>=20
>>> On 3/31/20 12:07 PM, Paolo Valente wrote:
>>>>> Il giorno 31 mar 2020, alle ore 03:41, Ming Lei =
<ming.lei@redhat.com> ha scritto:
>>>>>=20
>>>>> On Mon, Mar 30, 2020 at 07:49:06AM -0700, Douglas Anderson wrote:
>>>>>> It is possible for two threads to be running
>>>>>> blk_mq_do_dispatch_sched() at the same time with the same "hctx".
>>>>>> This is because there can be more than one caller to
>>>>>> __blk_mq_run_hw_queue() with the same "hctx" and hctx_lock() =
doesn't
>>>>>> prevent more than one thread from entering.
>>>>>>=20
>>>>>> If more than one thread is running blk_mq_do_dispatch_sched() at =
the
>>>>>> same time with the same "hctx", they may have contention =
acquiring
>>>>>> budget.  The blk_mq_get_dispatch_budget() can eventually =
translate
>>>>>> into scsi_mq_get_budget().  If the device's "queue_depth" is 1 =
(not
>>>>>> uncommon) then only one of the two threads will be the one to
>>>>>> increment "device_busy" to 1 and get the budget.
>>>>>>=20
>>>>>> The losing thread will break out of blk_mq_do_dispatch_sched() =
and
>>>>>> will stop dispatching requests.  The assumption is that when more
>>>>>> budget is available later (when existing transactions finish) the
>>>>>> queue will be kicked again, perhaps in scsi_end_request().
>>>>>>=20
>>>>>> The winning thread now has budget and can go on to call
>>>>>> dispatch_request().  If dispatch_request() returns NULL here then =
we
>>>>>> have a potential problem.  Specifically we'll now call
>>>>>=20
>>>>> I guess this problem should be BFQ specific. Now there is =
definitely
>>>>> requests in BFQ queue wrt. this hctx. However, looks this request =
is
>>>>> only available from another loser thread, and it won't be =
retrieved in
>>>>> the winning thread via e->type->ops.dispatch_request().
>>>>>=20
>>>>> Just wondering why BFQ is implemented in this way?
>>>>>=20
>>>>=20
>>>> BFQ inherited this powerful non-working scheme from CFQ, some age =
ago.
>>>>=20
>>>> In more detail: if BFQ has at least one non-empty internal queue, =
then
>>>> is says of course that there is work to do.  But if the currently
>>>> in-service queue is empty, and is expected to receive new I/O, then
>>>> BFQ plugs I/O dispatch to enforce service guarantees for the
>>>> in-service queue, i.e., BFQ responds NULL to a dispatch request.
>>>=20
>>> What BFQ is doing is fine, IFF it always ensures that the queue is =
run
>>> at some later time, if it returns "yep I have work" yet returns NULL
>>> when attempting to retrieve that work. Generally this should happen =
from
>>> subsequent IO completion, or whatever else condition will resolve =
the
>>> issue that is currently preventing dispatch of that request. Last =
resort
>>> would be a timer, but that can happen if you're slicing your =
scheduling
>>> somehow.
>>=20
>> I've been poking more at this today trying to understand why the idle
>> timer that Paolo says is in BFQ isn't doing what it should be doing.
>> I've been continuing to put most of my stream-of-consciousness at
>> <https://crbug.com/1061950> to avoid so much spamming of this thread.
>> In the trace I looked at most recently it looks like BFQ does try to
>> ensure that the queue is run at a later time, but at least in this
>> trace the later time is not late enough.  Specifically the quick
>> summary of my recent trace:
>>=20
>> 28977309us - PID 2167 got the budget.
>> 28977518us - BFQ told PID 2167 that there was nothing to dispatch.
>> 28977702us - BFQ idle timer fires.
>> 28977725us - We start to try to dispatch as a result of BFQ's idle =
timer.
>> 28977732us - Dispatching that was a result of BFQ's idle timer can't =
get
>>             budget and thus does nothing.
>> 28977780us - PID 2167 put the budget and exits since there was =
nothing
>>             to dispatch.
>>=20
>> This is only one particular trace, but in this case BFQ did attempt =
to
>> rerun the queue after it returned NULL, but that ran almost
>> immediately after it returned NULL and thus ran into the race.  :(
>=20
> OK, and then it doesn't trigger again? It's key that it keeps doing =
this
> timeout and re-dispatch if it fails, not just once.
>=20

The goal of BFQ's timer is to make BFQ switch from non-work-conserving
to work-conserving mode, just because not doing so would cause a
stall.  In contrast, it sounds a little weird that an I/O scheduler
systematically kicks I/O periodically (how can BFQ know when no more
kicking is needed?).  IOW, it doesn't seem very robust that blk-mq may
need a series of periodic kicks to finally restart, like a flooded
engine.

Compared with this solution, I'd still prefer one where BFQ doesn't
trigger this blk-mq stall at all.

Paolo

> But BFQ really should be smarter here. It's the same caller etc that
> asks whether it has work and whether it can dispatch, yet the answer =
is
> different. That's just kind of silly, and it'd make more sense if BFQ
> actually implemented the ->has_work() as a "would I actually dispatch
> for this guy, now".
>=20
>>>> It would be very easy to change bfq_has_work so that it returns =
false
>>>> in case the in-service queue is empty, even if there is I/O
>>>> backlogged.  My only concern is: since everything has worked with =
the
>>>> current scheme for probably 15 years, are we sure that everything =
is
>>>> still ok after we change this scheme?
>>>=20
>>> You're comparing apples to oranges, CFQ never worked within the =
blk-mq
>>> scheduling framework.
>>>=20
>>> That said, I don't think such a change is needed. If we currently =
have a
>>> hang due to this discrepancy between has_work and gets_work, then it
>>> sounds like we're not always re-running the queue as we should. =46rom=
 the
>>> original patch, the budget putting is not something the scheduler is
>>> involved with. Do we just need to ensure that if we put budget =
without
>>> having dispatched a request, we need to kick off dispatching again?
>>=20
>> By this you mean a change like this in blk_mq_do_dispatch_sched()?
>>=20
>>  if (!rq) {
>>    blk_mq_put_dispatch_budget(hctx);
>> +    ret =3D true;
>>    break;
>>  }
>>=20
>> I'm pretty sure that would fix the problems and I'd be happy to test,
>> but it feels like a heavy hammer.  IIUC we're essentially going to go
>> into a polling loop and keep calling has_work() and =
dispatch_request()
>> over and over again until has_work() returns false or we manage to
>> dispatch something...
>=20
> We obviously have to be careful not to introduce a busy-loop, where we
> just keep scheduling dispatch, only to fail.
>=20
> --=20
> Jens Axboe

