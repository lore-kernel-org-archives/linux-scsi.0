Return-Path: <SRS0=glVe=EF=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D5F80C4741F
	for <linux-scsi@archiver.kernel.org>; Fri, 30 Oct 2020 10:49:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 834FA20731
	for <linux-scsi@archiver.kernel.org>; Fri, 30 Oct 2020 10:49:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726511AbgJ3KtY convert rfc822-to-8bit (ORCPT
        <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 30 Oct 2020 06:49:24 -0400
Received: from mail-ot1-f67.google.com ([209.85.210.67]:38790 "EHLO
        mail-ot1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726317AbgJ3KtX (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 30 Oct 2020 06:49:23 -0400
Received: by mail-ot1-f67.google.com with SMTP id b2so5154075ots.5;
        Fri, 30 Oct 2020 03:49:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=DxbIWzNpadhYFOHMUtiUrYp7aLL+EHToyZld4U4MCe0=;
        b=MhheAvcgX4ZOGwew1TBqymQF/8E7x6GYpICMAF6C2hs5IwQyKKDpMNTWhG3qNrexxa
         b4p0LWtLBXcTFQOr8JlG514pgCtDUwywYvAclkSqkYKIUshKlzZECFKu0a5d2XUBz0IR
         O7tZOaQmckvx+ZKVc4gkVArPy0ZuhvRxpm/Og0UwIm17kN7DpcSm40ewmFrSkSSaXVUJ
         98pJaAk3SBMNrtIoDT99phP4qpGHc+7j2DhYq+t7Fk2OW+0H0NDyMIyCVzTHhN7tSOZL
         8VcvCxmV0GJ5dKLKQOz30LQdmT18xdoAebBnMc6mg8iwOcyT9t5f42tBUGPsCi5GLUPa
         ZyOg==
X-Gm-Message-State: AOAM530NyyD6AKstQLH+YDiiynbEybetZmp+DwhCTL9OzxDBtNuACx2z
        hsxu2EaGEKdGa3X0StmLm/YZ/Ui3uyG7ui7E/pU=
X-Google-Smtp-Source: ABdhPJy9u74BmkVjZUFAuaURT/kEEdBGpSqzi3KJMiCa3ikzKpuqxbG/v/dEUk5lGOwft38huDOCIItC4IP+PfOAO30=
X-Received: by 2002:a9d:5e14:: with SMTP id d20mr1064521oti.107.1604054962859;
 Fri, 30 Oct 2020 03:49:22 -0700 (PDT)
MIME-Version: 1.0
References: <20201029145841.144173-1-hch@lst.de> <20201029145841.144173-3-hch@lst.de>
 <20201029192236.GA991240@kroah.com> <20201029193242.GA4799@lst.de> <20201030104033.GA2392682@kroah.com>
In-Reply-To: <20201030104033.GA2392682@kroah.com>
From:   Geert Uytterhoeven <geert@linux-m68k.org>
Date:   Fri, 30 Oct 2020 11:49:11 +0100
Message-ID: <CAMuHMdXuzM0Z+yXXWqw8E2u-TNaC6C7NMRMH+X8oWQGaD=jckw@mail.gmail.com>
Subject: Re: [PATCH 02/18] block: open code kobj_map into in block/genhd.c
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Denis Efremov <efremov@linux.com>,
        "David S. Miller" <davem@davemloft.net>,
        Song Liu <song@kernel.org>, Al Viro <viro@zeniv.linux.org.uk>,
        Finn Thain <fthain@telegraphics.com.au>,
        Michael Schmitz <schmitzmic@gmail.com>,
        linux-block@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-ide@vger.kernel.org, linux-raid@vger.kernel.org,
        scsi <linux-scsi@vger.kernel.org>,
        linux-m68k <linux-m68k@lists.linux-m68k.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Greg,

On Fri, Oct 30, 2020 at 11:40 AM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
> On Thu, Oct 29, 2020 at 08:32:42PM +0100, Christoph Hellwig wrote:
> > On Thu, Oct 29, 2020 at 08:22:36PM +0100, Greg Kroah-Hartman wrote:
> > > After this, you want me to get rid of kobj_map, right?  Or you don't
> > > care as block doesn't use it anymore?  :)
> >
> > I have a patch to kill it, but it causes odd regressions with the
> > tpm driver according to the kernel test.  As I have grand plans that
> > build on the block ѕide of this series for 5.11, I plan to defer the
> > chardev side and address it for 5.12.
>
> Ok, sounds good.
>
> Wow, I just looked at the tpm code, and it is, um, "interesting" in how
> it thinks device lifespans work.  Nothing like having 4 different
> structures with different lifespans embedded within a single structure.
> Good thing that no one can dynamically remove a TPM device during
> "normal" operation.

/sys/.../unbind?

Gr{oetje,eeting}s,

                        Geert

-- 
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
