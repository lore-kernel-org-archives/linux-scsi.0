Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0F5AAC433E2
	for <linux-scsi@archiver.kernel.org>; Mon, 22 Mar 2021 16:35:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E2C9961992
	for <linux-scsi@archiver.kernel.org>; Mon, 22 Mar 2021 16:35:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230269AbhCVQfU (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 22 Mar 2021 12:35:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:32816 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231455AbhCVQfF (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 22 Mar 2021 12:35:05 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8990B61992;
        Mon, 22 Mar 2021 16:35:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616430905;
        bh=P/e+nlC3rhtz4wGffiXgOFXFOB7KpPSZY/OKlHxrmb4=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=U3W2lJLAGk+szcIQ4bzXkU82UG6kn1wjRFDv74Vu4IgrbDdm2YCtmB87SR5TAZ0T6
         V8xVKHHFFAkZ0oZ2TcIDJa5dG8lDhj0NCYzdR/pFxsZ7GN8NX7ulyC8S8Sj847mqhR
         Tppa/vQ/L/DDqW+thHXf427/GQvVxjNoJT+ohRInOGq9zUlXp7eIj8I6395jkwuE+I
         l97QuFfsjcAabfGVP6Xmxd0d/91Zu9XiJpIfYbVKz1+7VlUpbsqyAlY9LpOq3/wfru
         LK4tFSVXy3If+5dzIcWaPrQK4XZJXujP5ae94gmSbjvZe8CUcMipdN5mTg7xRXAUgA
         bfwmE7HZqj9Yw==
Received: by mail-oo1-f42.google.com with SMTP id q127-20020a4a33850000b02901b646aa81b1so4244641ooq.8;
        Mon, 22 Mar 2021 09:35:05 -0700 (PDT)
X-Gm-Message-State: AOAM532F5U5vVwNyIqBx/Esi7/RZcnSOKYs3X2zqGDiveuSA8TLQGNPK
        AFwE4rBm87sOYMxN8QUOI2qTx3fFTKnfA4JF5go=
X-Google-Smtp-Source: ABdhPJxIzYfTcZhxZSF4SI7Bk4CUoruJRG30REQdck8btLdlHm89VQzQ7t5BuNP5EUt5DJhXMf3Br7h52nwK4Ec5Bpc=
X-Received: by 2002:a4a:244d:: with SMTP id v13mr340720oov.66.1616430904856;
 Mon, 22 Mar 2021 09:35:04 -0700 (PDT)
MIME-Version: 1.0
References: <20210322114441.3479365-1-arnd@kernel.org> <20210322154735.GA2079192@infradead.org>
 <20210322155344.GA23040@1wt.eu> <CAK8P3a1bb4QvNyM9kkt0KB9k70cdEZ-e+B-CHHtPhaPO6ouxeQ@mail.gmail.com>
 <20210322162601.GB23467@1wt.eu>
In-Reply-To: <20210322162601.GB23467@1wt.eu>
From:   Arnd Bergmann <arnd@kernel.org>
Date:   Mon, 22 Mar 2021 17:34:48 +0100
X-Gmail-Original-Message-ID: <CAK8P3a3f2vXBsEg_vWoc1qFBdy9dqO7txcwhpSTVCRBpGf9u=w@mail.gmail.com>
Message-ID: <CAK8P3a3f2vXBsEg_vWoc1qFBdy9dqO7txcwhpSTVCRBpGf9u=w@mail.gmail.com>
Subject: Re: [PATCH] target: pscsi: avoid Wempty-body warning
To:     Willy Tarreau <w@1wt.eu>
Cc:     Christoph Hellwig <hch@infradead.org>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Jens Axboe <axboe@kernel.dk>,
        Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>,
        Hannes Reinecke <hare@suse.de>,
        Bodo Stroesser <bstroesser@ts.fujitsu.com>,
        "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        Guoqing Jiang <guoqing.jiang@cloud.ionos.com>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        target-devel@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, Mar 22, 2021 at 5:26 PM Willy Tarreau <w@1wt.eu> wrote:
> On Mon, Mar 22, 2021 at 05:18:23PM +0100, Arnd Bergmann wrote:
> > and a lot mostly harmless code like
> >
> > #ifdef DEBUG_THIS_DRIVER /* always disabled */
> > #define dprintk(args...) printk(args)
> > #else
> > #define dprintk(args...)
> > #endif
> >     /* note the mismatched format string */
> >     dprintk(KERN_WARNING "error %d\n", &object);
> >
> > Turning the empty dprintk() into no_printk() means we can catch
> > the wrong format string during compile testing.
>
> Hmmm OK for this one. With this said, given how plenty of warnings seem
> to consider indent and whatever, I wouldn't be surprised if a difference
> is made between a totally empty body and one that results from an empty
> macro. But indeed this one can represent a real bug.

The -Wempty-body warning is actually really old and predates the compiler's
understanding of indentation, we just always disabled it by default so far.

As a lot of subsystems are W=1 clean these days, I just went for the
final 26 patches to shut up all empty-body warnings in randconfig builds.
Most of these were in the dprink() category, though none of this last set
actually had incorrect format strings.

          Arnd
