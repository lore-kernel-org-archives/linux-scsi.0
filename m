Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8D19EC433EF
	for <linux-scsi@archiver.kernel.org>; Thu,  2 Sep 2021 22:38:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 651E261059
	for <linux-scsi@archiver.kernel.org>; Thu,  2 Sep 2021 22:38:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347727AbhIBWjT (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 2 Sep 2021 18:39:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49772 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347699AbhIBWjT (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 2 Sep 2021 18:39:19 -0400
Received: from mail-lj1-x233.google.com (mail-lj1-x233.google.com [IPv6:2a00:1450:4864:20::233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC4C7C061575
        for <linux-scsi@vger.kernel.org>; Thu,  2 Sep 2021 15:38:19 -0700 (PDT)
Received: by mail-lj1-x233.google.com with SMTP id s3so6400994ljp.11
        for <linux-scsi@vger.kernel.org>; Thu, 02 Sep 2021 15:38:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=E3bDRRGamHQKrcPLswNiJqifcyyJaRoHVapcNrMpIBg=;
        b=TELzSBJxOmBC5S0WOFI/aa7wb9vGW6scfdZvQuva6oYyVCKQ9V28bh0Yh46K/1iriY
         jxEb4rGfTI2L+rMplSI20e3MqbSX5Nj4Zv7iqAEY+rgAClrR2yQh/5ziz4oTTAhaM0m7
         BhsJqOd30mNyZlbDS8SH2qhM4TlbGsU7l3f/w=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=E3bDRRGamHQKrcPLswNiJqifcyyJaRoHVapcNrMpIBg=;
        b=iWUfJKpVsERmzhHU5efh19pL6JwnyFif74bJYi5s6FS/wkJ6gzmIXy6zMJZCM4yNz0
         4KtTIY2dwgu/DzWxATqDgA6MVAGLoUr7eLxKWtQ2DSp0ErBN8NxEncqwp72FoRYV6vGJ
         0iKUtTRxdvjAzC5REiGwUB55BJ2Z8GDo3NnvnIbly7Mb5tF8wwl5UYfc9oSw4cZRr/XE
         2/6Hmg3td9bV8/kV/ORZgIfloLH05/fCVsH0Jh1onAiIsvpMAKiXfE2T6t8q1S3uoe+m
         m4Bz1qzF4dbN218bPDTDccrkVGbN+2euWGgXQBX0K1v/E0W0uHvA8SkTbaWLzfU4DDAT
         uz4Q==
X-Gm-Message-State: AOAM531X0RYrI/XC+/T4f4yNRYBTrd/crjWeqzDPL7WrRW7ahpXNgYL+
        n6dipPmywxnllaGKqhQZpzWgfnV8w/ifVvMHESk=
X-Google-Smtp-Source: ABdhPJx1hq+c8w6bXeJKUIGDMHkU6bg0oNXxm6Czp90063sRry/zx8VHi/Mhk4fNb5+RtulN9NHhyg==
X-Received: by 2002:a2e:a7cf:: with SMTP id x15mr449221ljp.227.1630622298013;
        Thu, 02 Sep 2021 15:38:18 -0700 (PDT)
Received: from mail-lj1-f171.google.com (mail-lj1-f171.google.com. [209.85.208.171])
        by smtp.gmail.com with ESMTPSA id x4sm378857ljm.98.2021.09.02.15.38.17
        for <linux-scsi@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 02 Sep 2021 15:38:17 -0700 (PDT)
Received: by mail-lj1-f171.google.com with SMTP id s3so6400911ljp.11
        for <linux-scsi@vger.kernel.org>; Thu, 02 Sep 2021 15:38:17 -0700 (PDT)
X-Received: by 2002:a2e:7d0e:: with SMTP id y14mr438741ljc.251.1630622297342;
 Thu, 02 Sep 2021 15:38:17 -0700 (PDT)
MIME-Version: 1.0
References: <fc14fbbf0d7c27b7356bc6271ba2a5599d46af58.camel@HansenPartnership.com>
In-Reply-To: <fc14fbbf0d7c27b7356bc6271ba2a5599d46af58.camel@HansenPartnership.com>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Thu, 2 Sep 2021 15:38:01 -0700
X-Gmail-Original-Message-ID: <CAHk-=wi99u+xj93-pLG0Na7SZmjvWg6n60Pq9Wt9PgO6=exdUA@mail.gmail.com>
Message-ID: <CAHk-=wi99u+xj93-pLG0Na7SZmjvWg6n60Pq9Wt9PgO6=exdUA@mail.gmail.com>
Subject: Re: [GIT PULL] first round of SCSI updates for the 5.14+ merge window
To:     James Bottomley <James.Bottomley@hansenpartnership.com>,
        Jens Axboe <axboe@kernel.dk>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, Sep 2, 2021 at 9:50 AM James Bottomley
<James.Bottomley@hansenpartnership.com> wrote:
>
> We also picked up a non trivial conflict with the already upstream
> block tree in st.c

Hmm. Resolving that conflict, I just reacted to how the st.c code
passes in a NULL gendisk to scsi_ioctl() and then on to
blk_execute_rq().

Just checking that was fine, and I notice how *many* places do that.

Should the blk_execute_rq() function even take that "struct gendisk
*bd_disk" argument at all?

Maybe the right thing to do would be for the people who care to just
set rq->rq_disk before starting the request..

But I guess it's traditional, and nobody cares.

            Linus
