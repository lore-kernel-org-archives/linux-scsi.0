Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0AFDCC433EF
	for <linux-scsi@archiver.kernel.org>; Fri,  3 Sep 2021 18:38:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D158A61051
	for <linux-scsi@archiver.kernel.org>; Fri,  3 Sep 2021 18:38:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235931AbhICSjG (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 3 Sep 2021 14:39:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39858 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233502AbhICSjF (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 3 Sep 2021 14:39:05 -0400
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45EF7C061757
        for <linux-scsi@vger.kernel.org>; Fri,  3 Sep 2021 11:38:04 -0700 (PDT)
Received: by mail-pj1-x102f.google.com with SMTP id i13so146727pjv.5
        for <linux-scsi@vger.kernel.org>; Fri, 03 Sep 2021 11:38:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=philpotter-co-uk.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=AwMjWECVF5DouWRg4DDCdzuDm8b1FUkL2lfLjigAdrw=;
        b=yPp78YefA5OulhXKpgoj7VOFdGIMV4/hkTb7A7cYDExX5sMe0SIb9JkbU5kkQGNFqM
         Mg6TWDXyH0psAuuj9rC/blDlean6r4rAZvJFcVsg2vNblmUQ7B6FcN6+CmJvcBXbD6hR
         jQuMs6DQVKqMQoZ7R8b68PnqpPfWTimC9XLCS3XjH1aAFuGRghcl3XLNA/ox+qCk/OH8
         GDMml/nqQyANCVkw1+3m0IfZ4opjWUp7GampTB4girBWalOk3FiBI4A9wLbxy96eoEjT
         UCbxYj/7QdzJeTxBuCpebgB0CjRKtvIQEZkztGLX5zWqcyTuv+63lXWzU6UVt30o9BkG
         ++dg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=AwMjWECVF5DouWRg4DDCdzuDm8b1FUkL2lfLjigAdrw=;
        b=hU04t+5k7rJwLYzyT7M2pXJcrrydN4lSu2FMkMDT/NVJABWyxxHECYnG3tCQrPgrCM
         HA+gRIPauKEoPIi8+c0H71OiAnFegq4PmWbk/IaxE9NSGVy1KH+bEiod26JMd7IRGiw3
         I1fdYJ/m6RMFbXX+xOyacCj4lBsBo8X824TDxw7Rsahq21e2wN+ruUH6BwR5EcBooXQo
         dwyRaD0s2B9O/rjGyohOtHswqGYXoG6EtwJkFT9w4Te84r7xk+XRTZ51v4xsarfvJ4p/
         057/xJofZUcuTW6vXvVVKe013iPcKWt+qm9HR7VZIxVA/qBNEj/Ktg6MW0XGnpkKYgWO
         ulYw==
X-Gm-Message-State: AOAM532jQvKm7TvkCdToJPP6zmpVf8+wd6Jt4ytgVa3qaHHS1wawNSAF
        wsx1DkGO9coPq/AJ6yH6hVpucyZh+Os6QG/FK/liXEXHj20=
X-Google-Smtp-Source: ABdhPJyyj+KbMk2/1Jcy/3c5IkjNcQX5t+5qP+Gn0/3iNoyJbLgEOdEywfmmlMNyqFCeuS7aVFZovgcz/HSC0ZGSCsA=
X-Received: by 2002:a17:90a:414c:: with SMTP id m12mr342815pjg.100.1630694284100;
 Fri, 03 Sep 2021 11:38:04 -0700 (PDT)
MIME-Version: 1.0
References: <22d59432-1b8e-0125-96e9-51b041fe3536@kernel.dk>
 <20210827235623.1344-1-phil@philpotter.co.uk> <89679d81-7e9e-7cae-c335-b97d53fa68ab@kernel.dk>
In-Reply-To: <89679d81-7e9e-7cae-c335-b97d53fa68ab@kernel.dk>
From:   Phillip Potter <phil@philpotter.co.uk>
Date:   Fri, 3 Sep 2021 19:37:53 +0100
Message-ID: <CAA=Fs0kVfjn7vDSq-v=aQcUuZwoST0ucYRir90GEC5cU=K9Hrw@mail.gmail.com>
Subject: Re: Wanted: CDROM maintainer
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-scsi@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Fri, 3 Sept 2021 at 15:09, Jens Axboe <axboe@kernel.dk> wrote:
>
> On 8/27/21 5:56 PM, Phillip Potter wrote:
> > Dear Jens,
> >
> > Thought I'd reply publicly given the spirit of the mailing lists, hope this
> > is OK.
> >
> > Whilst I haven't worked on this area of the kernel, I would certainly like
> > to register my interest. Many thanks.
>
> Why don't we give it a try, then? Here's what I propose:
>
> 1) Send a patch that updates MAINTAINERS for the uniform cdrom driver to
>    yourself
>
> 2) Just send pull requests for changes through me, so I can keep an eye
>    on it at least initially
>
> I'll send in a patch to update the SCSI cdrom to just fall under SCSI,
> probably just removing that entry as that should then happen by default.
>
> --
> Jens Axboe
>

Dear Jens,

Many thanks, sounds great - I'll send through a patch this evening as suggested.

Regards,
Phil
