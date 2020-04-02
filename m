Return-Path: <SRS0=+0y/=5S=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 52E7FC2BA12
	for <linux-scsi@archiver.kernel.org>; Thu,  2 Apr 2020 15:53:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 287072063A
	for <linux-scsi@archiver.kernel.org>; Thu,  2 Apr 2020 15:53:15 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="SlMrIQk0"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389575AbgDBPxO (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 2 Apr 2020 11:53:14 -0400
Received: from mail-ua1-f65.google.com ([209.85.222.65]:37788 "EHLO
        mail-ua1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389384AbgDBPxO (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 2 Apr 2020 11:53:14 -0400
Received: by mail-ua1-f65.google.com with SMTP id l18so1368728uak.4
        for <linux-scsi@vger.kernel.org>; Thu, 02 Apr 2020 08:53:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=7eeld/knQPBWgODPyyjL7AYipdgQCeX/lwMGVDPIUXk=;
        b=SlMrIQk0FbHoFXUBmYGR7SVnFVueYsbknDCKTTsm/4DdvhFw51M47Aud6C5bAz+mNm
         8X2lmjNIltMcbGrJmZHzKbETTaqLKN5+QVDKB5vOKRufB7KdcrpYeFkXsydwyB5QUMHY
         ZHw0WVrZwx4lC3Baz+zy9xLHyMUJOVHXBJtHU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=7eeld/knQPBWgODPyyjL7AYipdgQCeX/lwMGVDPIUXk=;
        b=Ote0t4CV+FJ11gqA07UYz4Q4O6zQGazurmGEs5DRP2pp/MTLtdcYh9UfjKuv2krSeP
         gu/bEoCYXx8v6+oDlMcTUJ6/fN/3SVwV0Zt6bmWonrDB7sxumTu/G7Bgf/0qkF+ba/rJ
         2pwswCrvlLTPVuKZqaIYmcePE+qvU0B2enDUhFQA2uH1l3BLui2Fa0x7yfOtrRHqUykK
         XhuoPul9gSurVm3VvqB8IZU4TX52DZJcvwtlzVUXe4DDLebntCEaS1NqU/NQGf5IHoO3
         lnmbfSapdMlgOJVRum49WYL0tk8Ske/GxNGGkMCgvwe8UDWZCa6KU3sLJeEUFso7SyKH
         slGA==
X-Gm-Message-State: AGi0PuaHy2z87LogX1dj1MNjjIVe9KebcaYQrtu6XlxevnFNSc2OiiB7
        x0NOkZaV7G9g+6cSIi0PpstqZo69ifM=
X-Google-Smtp-Source: APiQypIXdptGyiOU52Axw7Q8n1jdykSh28YdIgmbOZe5dv8OcRO9inpByNVnXRu5j9qEJJqjlKuH+w==
X-Received: by 2002:ab0:3743:: with SMTP id i3mr3215868uat.38.1585842792859;
        Thu, 02 Apr 2020 08:53:12 -0700 (PDT)
Received: from mail-ua1-f42.google.com (mail-ua1-f42.google.com. [209.85.222.42])
        by smtp.gmail.com with ESMTPSA id c206sm1570915vkc.0.2020.04.02.08.53.11
        for <linux-scsi@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 02 Apr 2020 08:53:11 -0700 (PDT)
Received: by mail-ua1-f42.google.com with SMTP id f9so1363759uaq.8
        for <linux-scsi@vger.kernel.org>; Thu, 02 Apr 2020 08:53:11 -0700 (PDT)
X-Received: by 2002:a9f:2478:: with SMTP id 111mr3073972uaq.0.1585842791113;
 Thu, 02 Apr 2020 08:53:11 -0700 (PDT)
MIME-Version: 1.0
References: <20200330144907.13011-1-dianders@chromium.org> <20200330074856.2.I28278ef8ea27afc0ec7e597752a6d4e58c16176f@changeid>
 <20200331014109.GA20230@ming.t460p> <D38AB98D-7F6A-4C61-8A8F-C22C53671AC8@linaro.org>
 <d6af2344-11f7-5862-daed-e21cbd496d92@kernel.dk> <CAD=FV=WHYFDoUKLnwMCm-o=gEQDCzZFeMAvia3wpJzm9XX7Bow@mail.gmail.com>
 <02968c1d-bd3a-af9c-77e7-23a9d9aa9af4@kernel.dk> <1D4B63FC-FA4B-4C73-B70F-6639CC41D3A6@linaro.org>
In-Reply-To: <1D4B63FC-FA4B-4C73-B70F-6639CC41D3A6@linaro.org>
From:   Doug Anderson <dianders@chromium.org>
Date:   Thu, 2 Apr 2020 08:52:59 -0700
X-Gmail-Original-Message-ID: <CAD=FV=XX+S==bz1OQFYyQxNmsPdMQoJ7AJSs++D9dP_r0Rc93A@mail.gmail.com>
Message-ID: <CAD=FV=XX+S==bz1OQFYyQxNmsPdMQoJ7AJSs++D9dP_r0Rc93A@mail.gmail.com>
Subject: Re: [PATCH 2/2] scsi: core: Fix stall if two threads request budget
 at the same time
To:     Paolo Valente <paolo.valente@linaro.org>
Cc:     Jens Axboe <axboe@kernel.dk>, Ming Lei <ming.lei@redhat.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-block <linux-block@vger.kernel.org>,
        Guenter Roeck <groeck@chromium.org>,
        linux-scsi@vger.kernel.org, Salman Qazi <sqazi@google.com>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi,

On Wed, Apr 1, 2020 at 12:48 AM Paolo Valente <paolo.valente@linaro.org> wrote:
>
> >> 28977309us - PID 2167 got the budget.
> >> 28977518us - BFQ told PID 2167 that there was nothing to dispatch.
> >> 28977702us - BFQ idle timer fires.
> >> 28977725us - We start to try to dispatch as a result of BFQ's idle timer.
> >> 28977732us - Dispatching that was a result of BFQ's idle timer can't get
> >>             budget and thus does nothing.
> >> 28977780us - PID 2167 put the budget and exits since there was nothing
> >>             to dispatch.
> >>
> >> This is only one particular trace, but in this case BFQ did attempt to
> >> rerun the queue after it returned NULL, but that ran almost
> >> immediately after it returned NULL and thus ran into the race.  :(
> >
> > OK, and then it doesn't trigger again? It's key that it keeps doing this
> > timeout and re-dispatch if it fails, not just once.
> >
>
> The goal of BFQ's timer is to make BFQ switch from non-work-conserving
> to work-conserving mode, just because not doing so would cause a
> stall.  In contrast, it sounds a little weird that an I/O scheduler
> systematically kicks I/O periodically (how can BFQ know when no more
> kicking is needed?).  IOW, it doesn't seem very robust that blk-mq may
> need a series of periodic kicks to finally restart, like a flooded
> engine.
>
> Compared with this solution, I'd still prefer one where BFQ doesn't
> trigger this blk-mq stall at all.

I spent more time thinking about this / testing things.  Probably the
best summary of my thoughts can be found at
<https://crbug.com/1061950#c79>.  The quick summary is that I believe
the problem is that BFQ has faith that when it calls
blk_mq_run_hw_queues() that it will eventually cause BFQ to be called
back at least once to dispatch.  That doesn't always happen due to the
race we're trying to solve here.  If we fix the race / make
blk_mq_run_hw_queues() reliable then I don't think there's a need for
BFQ to implement some type of timeout/retry mechanism.


> > But BFQ really should be smarter here. It's the same caller etc that
> > asks whether it has work and whether it can dispatch, yet the answer is
> > different. That's just kind of silly, and it'd make more sense if BFQ
> > actually implemented the ->has_work() as a "would I actually dispatch
> > for this guy, now".

I prototyped this and I think it would solve the problem (though I
haven't had time to do extensive testing yet).  It certainly makes
BFQ's has_work() more expensive in some cases, but it might be worth
it.  Someone setup to do benchmarking would need to say for sure.

However, I think I've figured out an inexpensive / lightweight
solution that means we can let has_work() be inexact.  It's mostly the
same as this patch but implemented at the blk-mq layer (not the SCSI
layer) and doesn't add a spinlock.  I'll post a v2 and you can see if
you hate it or if it looks OK.  You can find it at:

https://lore.kernel.org/r/20200402085050.v2.2.I28278ef8ea27afc0ec7e597752a6d4e58c16176f@changeid

-Doug
