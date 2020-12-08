Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E0F50C433FE
	for <linux-scsi@archiver.kernel.org>; Tue,  8 Dec 2020 22:53:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AAF5223A79
	for <linux-scsi@archiver.kernel.org>; Tue,  8 Dec 2020 22:53:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727914AbgLHWx2 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 8 Dec 2020 17:53:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33470 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729455AbgLHWxX (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 8 Dec 2020 17:53:23 -0500
Received: from mail-lj1-x244.google.com (mail-lj1-x244.google.com [IPv6:2a00:1450:4864:20::244])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C804C0613D6
        for <linux-scsi@vger.kernel.org>; Tue,  8 Dec 2020 14:52:43 -0800 (PST)
Received: by mail-lj1-x244.google.com with SMTP id y22so81464ljn.9
        for <linux-scsi@vger.kernel.org>; Tue, 08 Dec 2020 14:52:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ZplHny7NuMDeOaboy5Ojl3351+q3889Gr1PaS7aPZVw=;
        b=SoCAWoi6D80C376nwcmnYXhMLwlWp/fjLJB5XEgBGVMVfPU3bxnr2Ie6vmImL59rKa
         ZYJf3tAq9nvcbZXxr02MRDrL3FhZN7Z7fnYt9g8LdWhL66pWjHdR+8HvYC7DONcGTj0b
         jtZ8VS7TGo08Svsmicqpx2dbeSy5Ll1P+H440=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ZplHny7NuMDeOaboy5Ojl3351+q3889Gr1PaS7aPZVw=;
        b=LeNSKdvuFCbywsoiJghSxI/kQtEvDCazHsnVQt7V180N+Z0Q2PCpWeTj537qv8yEsA
         wd6+FAwKC+avK5mrMF+MtkQPhPSvHXmjDtIsn4+OAi1VnIHoK8tD+XPiXQytQ//vaYhK
         99OnY4hKHYH997G2pkD09657DyfVMxy1qb61FJlXscSYUenK9wW3a1ulnnZXewiG+h/C
         SMiGbcqQBOJGYNu242ZYJtWrSPZyeWfgsKQqRy9gnE0R7gKTNu57PDKYuO0C3ZDXzbq8
         BlTTV53DQ/a6bmE7Gdzy3UtfbCuwIc+Qc+eQcrN+qd9MiKEvSJJVLZdcEIQhuOuc6e2y
         DNSQ==
X-Gm-Message-State: AOAM530XxTObrRBNpqBJvEnKe2yT8IEioJ7FJ3BaYsyHZZIsgSvlGpPt
        +X0vHGQwYJ60yIdlDuKDxGctRISQXmegMg==
X-Google-Smtp-Source: ABdhPJyPduceYZ2P4/fFJc3JWoc+6L8w5TBNRuGwi5ORPRVTlVDrc6wZ0LcKUW1+hOqg80Li/boI3w==
X-Received: by 2002:a2e:b4af:: with SMTP id q15mr1414920ljm.507.1607467961584;
        Tue, 08 Dec 2020 14:52:41 -0800 (PST)
Received: from mail-lj1-f169.google.com (mail-lj1-f169.google.com. [209.85.208.169])
        by smtp.gmail.com with ESMTPSA id p15sm24171lfk.111.2020.12.08.14.52.41
        for <linux-scsi@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 08 Dec 2020 14:52:41 -0800 (PST)
Received: by mail-lj1-f169.google.com with SMTP id f24so52394ljk.13
        for <linux-scsi@vger.kernel.org>; Tue, 08 Dec 2020 14:52:41 -0800 (PST)
X-Received: by 2002:a2e:b4af:: with SMTP id q15mr1414834ljm.507.1607467958621;
 Tue, 08 Dec 2020 14:52:38 -0800 (PST)
MIME-Version: 1.0
References: <alpine.DEB.2.22.394.2012081813310.2680@hadrien>
 <CAHk-=wi=R7uAoaVK9ewDPdCYDn1i3i19uoOzXEW5Nn8UV-1_AA@mail.gmail.com>
 <yq1sg8gunxy.fsf@ca-mkp.ca.oracle.com> <CAHk-=whThuW=OckyeH0rkJ5vbbbpJzMdt3YiMEE7Y5JuU1EkUQ@mail.gmail.com>
 <9106e994-bb4b-4148-1280-f08f71427420@huawei.com> <CAHk-=wjsWB612YA0OSpVPkzePxQWyqcSGDaY1-x3R2AgjOCqSQ@mail.gmail.com>
 <alpine.DEB.2.22.394.2012082339470.16458@hadrien> <ca63ada5-76a6-dae9-e759-838386831f83@kernel.dk>
In-Reply-To: <ca63ada5-76a6-dae9-e759-838386831f83@kernel.dk>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Tue, 8 Dec 2020 14:52:21 -0800
X-Gmail-Original-Message-ID: <CAHk-=wikp9x+nz=9CHc+70aO11V0a0Ga=WSpRTySqr_r6dpiOw@mail.gmail.com>
Message-ID: <CAHk-=wikp9x+nz=9CHc+70aO11V0a0Ga=WSpRTySqr_r6dpiOw@mail.gmail.com>
Subject: Re: problem booting 5.10
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Julia Lawall <julia.lawall@inria.fr>,
        John Garry <john.garry@huawei.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        nicolas.palix@univ-grenoble-alpes.fr,
        linux-scsi <linux-scsi@vger.kernel.org>,
        Kashyap Desai <kashyap.desai@broadcom.com>,
        Ming Lei <ming.lei@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, Dec 8, 2020 at 2:47 PM Jens Axboe <axboe@kernel.dk> wrote:
>
> On Tue, Dec 8, 2020 at 3:42 PM Julia Lawall <julia.lawall@inria.fr> wrote:
> >
> > This solves the problem.  Starting from 5.10-rc7 and doing this
> > revert, I get a kernel that boots.
>
> Thanks for testing! Linus, do you just want to revert this, or do you
> want me to queue it up?

I'll just revert it in my tree directly, but you (or Martin) might
want to make sure that it gets re-enabled in 5.11.

           Linus
