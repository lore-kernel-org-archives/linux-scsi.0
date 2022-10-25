Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 32A26C04A95
	for <linux-scsi@archiver.kernel.org>; Tue, 25 Oct 2022 08:05:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232117AbiJYIFQ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 25 Oct 2022 04:05:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48278 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232116AbiJYIFN (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 25 Oct 2022 04:05:13 -0400
Received: from mail-qt1-x82b.google.com (mail-qt1-x82b.google.com [IPv6:2607:f8b0:4864:20::82b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C991A57235
        for <linux-scsi@vger.kernel.org>; Tue, 25 Oct 2022 01:05:11 -0700 (PDT)
Received: by mail-qt1-x82b.google.com with SMTP id cr19so7087510qtb.0
        for <linux-scsi@vger.kernel.org>; Tue, 25 Oct 2022 01:05:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=2ZJWcRrcXlUszylutFW0IohiQReyikmhPoU9KgsRq0k=;
        b=TF4PuXGiXCYqD/V0jB5M2J9Vg5Y5IMXVLn1evzmJRLolqU1cJ9zuW5ouoFdmhTvU34
         QhyX80jsNZT2JpVA4Oy3elChWwD3tU8PQs0++iVwop1fHYGfr8fYdwOSBlM0K2ykdTeQ
         BOH8qWfTsunI0F2WnibUJe0dm4JgX13yuOyU0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=2ZJWcRrcXlUszylutFW0IohiQReyikmhPoU9KgsRq0k=;
        b=GkLXBP85rhnEVlKIVG9pWZZU3uOLI7SAEuKDq1VeMJZEm826QbS+6r092oz3vekt6C
         +4Pztf6pyI3bL0b2nlFTARkOGyWM/FrR+rRyxuaXyELmStfZtMXy+SAHfRmoCAw98NQC
         bX382SVVP4v9zxlR3t4qkZiaWn2DI+nZuOlowXsLtPtsi6N9FCsPSRQJo8VUiHUBjHtW
         ZY6hHieRMCSMxdI3JZ0rWkKUe02Bf0Nzp7EpHXtxI1HCWAVyWNOULqZdmvp47zAzFR+2
         ZPbOHQpbUGAgZpRNLeKMfTUIofPqhfAnAi2+WRP9e941Up9Fzd6F9fnnY+awcvhyC/M7
         HaAw==
X-Gm-Message-State: ACrzQf3772iUAKY9Q2dVvpj94EBPNH60R2ZVh7+8GgjuZxm8aoBVJPXY
        4URAkhmUW6QU5HDyrPELdXhZAdDtL04pPQ==
X-Google-Smtp-Source: AMsMyM42Neb1la97P9rktt7BFRVhtO/x0ozCnLXUwT3ZBzd2pza7jMcsB5Wy3xnZYQ3i0kiMBKzOjQ==
X-Received: by 2002:a05:622a:551:b0:39c:e5c7:8b1b with SMTP id m17-20020a05622a055100b0039ce5c78b1bmr30708124qtx.540.1666685110455;
        Tue, 25 Oct 2022 01:05:10 -0700 (PDT)
Received: from mail-yb1-f169.google.com (mail-yb1-f169.google.com. [209.85.219.169])
        by smtp.gmail.com with ESMTPSA id u12-20020a05620a0c4c00b006f6874aa615sm1664886qki.61.2022.10.25.01.05.09
        for <linux-scsi@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 25 Oct 2022 01:05:09 -0700 (PDT)
Received: by mail-yb1-f169.google.com with SMTP id l145so13729259ybl.0
        for <linux-scsi@vger.kernel.org>; Tue, 25 Oct 2022 01:05:09 -0700 (PDT)
X-Received: by 2002:a25:84cf:0:b0:6b3:c0c3:19d8 with SMTP id
 x15-20020a2584cf000000b006b3c0c319d8mr30758522ybm.349.1666685109488; Tue, 25
 Oct 2022 01:05:09 -0700 (PDT)
MIME-Version: 1.0
References: <4a450f81-b7e0-31e8-e8bb-03a1c87e829a@suse.com> <CAHk-=wjaK-TxrNaGtFDpL9qNHL1MVkWXO1TT6vObD5tXMSC4Zg@mail.gmail.com>
In-Reply-To: <CAHk-=wjaK-TxrNaGtFDpL9qNHL1MVkWXO1TT6vObD5tXMSC4Zg@mail.gmail.com>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Tue, 25 Oct 2022 01:04:53 -0700
X-Gmail-Original-Message-ID: <CAHk-=whaEJYeY6tPGbPGuchjrCirxaJ1jfiWsFgW0rd9JQgrow@mail.gmail.com>
Message-ID: <CAHk-=whaEJYeY6tPGbPGuchjrCirxaJ1jfiWsFgW0rd9JQgrow@mail.gmail.com>
Subject: Re: Inconsistency in torvalds/linux.git?
To:     Juergen Gross <jgross@suse.com>
Cc:     Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        linux-scsi <linux-scsi@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, Oct 25, 2022 at 12:48 AM Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> Thanks for noticing, and I'll also Cc this reply to the linux-scsi
> mailing list so that I can link to this longer explanation in my fix
> commit message.

Ok, the fix is now there as 1a2dcbdde82e ("scsi: mpt3sas: re-do lost
mpt3sas DMA mask fix").

Re-reading my commit message, I realize it's a bit confusing, because
I kept the authorship of the fix as Sreekanth, but then I wrote the
explanation as myself.

Oh well, the actual important information should be there - and
perhaps even more importantly, the fix itself should be active again.

And thanks again for noticing, this was all on me.

And honestly, it wasn't even a complicated merge conflict.

I think that what happened here was simply that the commit that
conflicted with the one-liner fix was

 (a) also from Sreekanth

 (b) also had that "DMA_BIT_MASK(32)" in it

So visually it looked like "Ahh, the SCSI tree already has this fix",
and so I just took the SCSI tree version of the code.

But while it had the same author, and while it had the same
"DMA_BIT_MASK(32)" textual pattern right there, it was just a
_different_ case of DMA_BIT_MASK(32).

So the DMA_BIT_MASK(32) fix two lines earlier from the new one got dropped.

                 Linus "D'oh" Torvalds
