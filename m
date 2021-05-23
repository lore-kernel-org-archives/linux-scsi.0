Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E436DC2B9F2
	for <linux-scsi@archiver.kernel.org>; Sun, 23 May 2021 00:06:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BAC4961139
	for <linux-scsi@archiver.kernel.org>; Sun, 23 May 2021 00:06:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231482AbhEWAIK (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 22 May 2021 20:08:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34524 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231440AbhEWAIJ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 22 May 2021 20:08:09 -0400
Received: from mail-pg1-x533.google.com (mail-pg1-x533.google.com [IPv6:2607:f8b0:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B01EC06174A
        for <linux-scsi@vger.kernel.org>; Sat, 22 May 2021 17:06:43 -0700 (PDT)
Received: by mail-pg1-x533.google.com with SMTP id f22so16362946pgb.9
        for <linux-scsi@vger.kernel.org>; Sat, 22 May 2021 17:06:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=philpotter-co-uk.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=cfYRF1b1oHr6saSKxaH7T1g69quhuErgPZcFY9YPsBg=;
        b=rTcIVbsR4M8se90NJlGDq94mhnst/WOvRVsZjlbfzhUKglq3zLnaAB4D4AiPCXs/9v
         RKg3sV8nttBn7Z780gznjBVCIi3rVzAmwVv/ImnbGVtmDh0kJlgR3ZDxpet0cdGAZwUg
         YlLCYQeO02Ov0Pw1R3I9pLkB33x6NvrbCZRDbQHfkmh0rgCGPsg52DdAAF9eTkwpceoZ
         S2AV8plMjF5KCqneeF8yLPZ6f5cZAKA9MQXgdo/Aiy5C7d1jAYoa/xtYKCva/PJwqKWe
         kQ3N4mtaQRZlbPnGDaWxZl0CzO4hein1lpvMuPX9szWHY/o1yjdJ4meZeySvkpJqgOh7
         JZAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=cfYRF1b1oHr6saSKxaH7T1g69quhuErgPZcFY9YPsBg=;
        b=Q2boyLwE/lUETHMwsV9ZOFJSq04B3sWmNxENeG+l/i2omSlHg6We2V5h4ryPCpXfWj
         NNFEznWLu/jl7Jh7Zzb5RMJw1DbavfW+flq9NYq4ZR88ejBtptvMSDadWM00o7M9BeQD
         kOOdCz90SuKCunUOBLRGCKWsJSdy3SUOS7M3NnqVa1WNqhfaUKveaz/zY7jJVvQ9NH9w
         QmASdCTaalT0sqL4+00tvGe/jAJL9TvOwlNHTH6+WZPLR7Z7Ni/OZ+20H6YMHf6s07yz
         MM7hfDqRCHA0HHHlwGaNj9z1TSzLCR75ISv2KTcyklnFMxEbeQFr5wmV4djkFQ9zKvuB
         hpfg==
X-Gm-Message-State: AOAM531dkyraWyUKMOppV2ST8R6KpZN13DE9CTM74nb/zbQ6V2rgTDpJ
        Xb8dQSlcBZUwKYpJXXs1IKw/m1sARacej1VZLPORTQ==
X-Google-Smtp-Source: ABdhPJzGIprSQBgbiCV18q2GPN/AbrX/k4spM7a2Q/WdAtNtFDWDBhNtnrK+cKNwFZ85JIvOm6ruXKGrKw+Eq5n/byg=
X-Received: by 2002:aa7:868e:0:b029:2ca:ea6a:71a1 with SMTP id
 d14-20020aa7868e0000b02902caea6a71a1mr17296934pfo.32.1621728403003; Sat, 22
 May 2021 17:06:43 -0700 (PDT)
MIME-Version: 1.0
References: <20210506073610.33867-1-phil@philpotter.co.uk> <yq1pmxj526p.fsf@ca-mkp.ca.oracle.com>
In-Reply-To: <yq1pmxj526p.fsf@ca-mkp.ca.oracle.com>
From:   Phillip Potter <phil@philpotter.co.uk>
Date:   Sun, 23 May 2021 01:06:32 +0100
Message-ID: <CAA=Fs0ndZNqz-Tdhxxi6GFqyinAoS9v0syGrJf=uR768FcuuDA@mail.gmail.com>
Subject: Re: [PATCH] scsi: sd: skip checks when media is present if
 sd_read_capacity reports zero
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     jejb@linux.ibm.com, linux-scsi@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Fri, May 21, 2021 at 04:00:10PM -0400, Martin K. Petersen wrote:
>
> Hello Phillip!
>
> > In sd_revalidate_disk, if sdkp->media_present is set, then sdkp->capacity
> > should not be zero. Therefore, jump to end of if block and skip remaining
> > checks/calls. Fixes a KMSAN-found uninit-value bug reported by syzbot at:
> > https://syzkaller.appspot.com/bug?id=197c8a3a2de61720a9b500ad485a7aba0065c6af
>
> The reported read of an uninitialized value is in scsi_mode_sense()
> while inspecting a buffer returned from sending a MODE SENSE command to
> the device. The buffer in question is memset() before executing the MODE
> SENSE command. And we only look at the buffer contents if the MODE SENSE
> operation was successful.
>
> As far as I can tell the only way to end up reading uninitialized data
> is if the device successfully completes the command but fails to
> transfer the data buffer.
>
> But maybe I'm missing something?
>
> --
> Martin K. Petersen    Oracle Linux Engineering

Dear Martin,

Thank you for your feedback firstly, much appreciated.

I may be misunderstanding this issue, but in my mind, if this issue is
possible to
trigger with a reproducer, then uninitialised data is being read? It
occurred to me
that a capacity of zero for a media which is present would make the following
function calls/checks invalid, hence the motivation for my patch, as
skipping all
those checks with such a size prevents this bug.

Another thing I noticed was that (unless I'm reading this wrong which
is certainly
possible) the buffer is never fully memset. It is allocated to be 512
bytes in size
(as SD_BUF_SIZE) and yet sd_do_mode_sense/scsi_mode_sense is never called
with a len param of this size but in fact much lower. Perhaps you're
right though and
my patch is not required? Certainly many KMSAN bugs are probably in areas where
logic is not affected by the uninitialised access.

Regards,
Phil
