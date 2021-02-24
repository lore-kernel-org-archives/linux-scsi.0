Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 837B0C433E0
	for <linux-scsi@archiver.kernel.org>; Wed, 24 Feb 2021 09:43:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 32EC564E6F
	for <linux-scsi@archiver.kernel.org>; Wed, 24 Feb 2021 09:43:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234756AbhBXJnW (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 24 Feb 2021 04:43:22 -0500
Received: from mail-oi1-f170.google.com ([209.85.167.170]:38811 "EHLO
        mail-oi1-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234728AbhBXJmM (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 24 Feb 2021 04:42:12 -0500
Received: by mail-oi1-f170.google.com with SMTP id h17so1811194oih.5;
        Wed, 24 Feb 2021 01:41:57 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=cZ9CytVVC5Yaa0UfPYhQheWPQFCjnccaT1/jCSrnfZo=;
        b=kzIiBsIwz1byI3nw2DwH1CHNdI2UmQL5mrJmq7tfxnQY1VreSzferqly1SgixV1py+
         HHabpSCCDHTdPy0lu5du4oJidoDNL8TD53L8WHmsV1ehBv7Nhm2Tna/KeYtTXXQEqC+F
         4/JuZGoyldwEyPY75oDfLVOe8KevX5tLyTwFS4IijblRvcJ8yw1WfoW9BA5OthaKVi13
         VcVxuzF2/Ldd6gFEICNfdwvo3sqzLXRuvgeBhOtKgQT32a4687prhiE+aGUSJEaL5P6B
         5BtHmpkhht35QcQDS8T86M0wkwK5sG7UAYAMbdnibh7jmgIWdsxb5FJ7+/HeR6rtFOIy
         t2lA==
X-Gm-Message-State: AOAM530geLv2NF3B1lXpgs46oyZS1SKupxZ2pIMf9cfdoLhIE2VodEfB
        Ntwu0tIGDhDUZsJHIhhhzXuvjxkjkEDEx8bcxoP0UW8n
X-Google-Smtp-Source: ABdhPJzelJIMRKAJg5zZOc4I7Vsc4wo3CcI5kvLYqFc2nS60HoA07GehQkYi72Z7F/k8VhStOCwvDJeq6fMzXtK3iEY=
X-Received: by 2002:aca:d908:: with SMTP id q8mr2136302oig.148.1614159691871;
 Wed, 24 Feb 2021 01:41:31 -0800 (PST)
MIME-Version: 1.0
References: <1612697823-8073-1-git-send-email-tanxiaofei@huawei.com>
In-Reply-To: <1612697823-8073-1-git-send-email-tanxiaofei@huawei.com>
From:   Geert Uytterhoeven <geert@linux-m68k.org>
Date:   Wed, 24 Feb 2021 10:41:19 +0100
Message-ID: <CAMuHMdXwmjq_MPr=R9twkYRoun2buuSrPDbLo6zdkGFb7XQHoQ@mail.gmail.com>
Subject: Re: [PATCH for-next 00/32] spin lock usage optimization for SCSI drivers
To:     Xiaofei Tan <tanxiaofei@huawei.com>
Cc:     "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        scsi <linux-scsi@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linuxarm@openeuler.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Xiaofei,

On Sun, Feb 7, 2021 at 12:46 PM Xiaofei Tan <tanxiaofei@huawei.com> wrote:
> Replace spin_lock_irqsave with spin_lock in hard IRQ of SCSI drivers.
> There are no function changes, but may speed up if interrupt happen
> too often.

I'll bite: how much does this speed up interrupt processing?
What's the typical cost of saving/disabling, and restoring interrupt
state?  Is removing this cost worth the risk of introducing subtle
regressions on platforms you cannot test yourself?

BTW, how many of these legacy SCSI controllers do you have access to?

Thanks for your answers!

Gr{oetje,eeting}s,

                        Geert

-- 
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
