Return-Path: <SRS0=YE2i=4H=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 29662C3404C
	for <linux-scsi@archiver.kernel.org>; Wed, 19 Feb 2020 01:02:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id F330524655
	for <linux-scsi@archiver.kernel.org>; Wed, 19 Feb 2020 01:02:30 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="hNWL5Ely"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726964AbgBSBCa (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 18 Feb 2020 20:02:30 -0500
Received: from mail-ua1-f66.google.com ([209.85.222.66]:33878 "EHLO
        mail-ua1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726422AbgBSBCa (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 18 Feb 2020 20:02:30 -0500
Received: by mail-ua1-f66.google.com with SMTP id 1so8234855uao.1
        for <linux-scsi@vger.kernel.org>; Tue, 18 Feb 2020 17:02:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=zKYxJn8o8sOC3Z/alZQxaNqbcWkS5hUE59gccyoe7m0=;
        b=hNWL5ElyJ+18mT46x9M+DvNQvDH4nM11kFirs1yM+rGXlQLXUxN6AJE3qkfYpJFi4t
         /jQm5qXHlcPaXdLhGX6oGVsZMgcus6QhjgJLpv7zqNiaxuEwpX/9ogFNjvbTkyVu2qm8
         vQJduBG/PgJnIvDWPPY+h72AfvMWXH3M559IlHQgra5fdJjSWqyveZbtEzc5dekjL+ph
         sG8+8FX5M8RetkSJyouSl63XeJXFqMFilawEI5Z/shoKUxM/CRRz8HAYMPnXtKmW05Mc
         DGPOHKhCybXEbh3//bKhApUEuxEucP95EJCRKvWa5egasvS9QRvkUovtpHViYnTofyYm
         +iLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=zKYxJn8o8sOC3Z/alZQxaNqbcWkS5hUE59gccyoe7m0=;
        b=NAhuk0xM1XSqEUnlwfDC9w2Ut+Opdh//T40ll9dUoWMQeww5bdakG0a645Rsu+j+SM
         xuYxbFMvVOEvBreJSSLftM8ELUI+fIzuRHjSw5dJ/I7nyYhKLiTyk8avE16yYtva6Rf0
         IDRy17Sbo1tNCt6VSNKz2m7AobbcnT4pCenFGEpjaNCy5ugRvjreFNPiJRZpnS6fo7iI
         cK3KBML3kZmbQ7Zgi3lJf0pHRJ0cvv8Rkzixt9m6JSjHIfeKWTxYincM0Iq/Lf81+Lzv
         gQSn5RUT+4sydLBAxQJtMzcGfg5SLL0ODmi0GiZHXHBmjP3BnlD8PCaT/ytQWmOWyfyQ
         sepA==
X-Gm-Message-State: APjAAAXne36QKnqokri1qcmSKfAOvgaQJbNg8KxnR2ZoGOZwNlxVkMd9
        nsYffnA1FKQJar9Jg9BSgMdDLcG5D9iCKtv8wgw=
X-Google-Smtp-Source: APXvYqz49L4lRicu9AQUdZD9XvplsBshLY6qlyHceXgB1KVNZpyMD5nIWhyV2o7F972hzNAPjVA19Dy3blRZa0b+VvA=
X-Received: by 2002:ab0:1c0e:: with SMTP id a14mr11425846uaj.141.1582074148556;
 Tue, 18 Feb 2020 17:02:28 -0800 (PST)
MIME-Version: 1.0
References: <20200218234450.69412-1-hch@lst.de> <CGME20200218234505epcas2p1ddd6db560233ff6aab1e1f0c30fd4eb2@epcas2p1.samsung.com>
 <20200218234450.69412-2-hch@lst.de> <0afd01d5e6b7$988cddf0$c9a699d0$@samsung.com>
 <20200219004248.GB213946@gmail.com>
In-Reply-To: <20200219004248.GB213946@gmail.com>
From:   Alim Akhtar <alim.akhtar@gmail.com>
Date:   Wed, 19 Feb 2020 06:31:52 +0530
Message-ID: <CAGOxZ53WmT-_q6LwP6427JDsWpTQGcgWUwV_mctD_et6QQHp8w@mail.gmail.com>
Subject: Re: [PATCH 1/2] ufshcd: remove unused quirks
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     Kiwoong Kim <kwmad.kim@samsung.com>,
        Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Eric

On Wed, Feb 19, 2020 at 6:14 AM Eric Biggers <ebiggers@kernel.org> wrote:
>
> On Wed, Feb 19, 2020 at 09:00:26AM +0900, Kiwoong Kim wrote:
> >
> > Exynos specific driver sets and is using the following quirks but the driver
> > is not updated
> > yet. I'll do upstream it in the future.
> > - UFSHCI_QUIRK_BROKEN_REQ_LIST_CLR
> > - UFSHCD_QUIRK_PRDT_BYTE_GRAN
> > - UFSHCI_QUIRK_SKIP_RESET_INTR_AGGR
>
> These quirks have been there for 2-3 years without the driver that needs them
> even being posted to the mailing list since 2017.  Since we don't keep unused
> code in the upstream kernel, I support the removal of these quirks.  If you
> don't want them to be removed, you need to get your driver upstream.
>

Yes, understand it got delayed significantly, we will try to send
driver after fixing the previous review comments.
Thanks for heads-up.

> - Eric



-- 
Regards,
Alim
