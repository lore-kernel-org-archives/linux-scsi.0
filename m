Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 46D94C433F5
	for <linux-scsi@archiver.kernel.org>; Mon,  1 Nov 2021 10:36:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1DE0B610CA
	for <linux-scsi@archiver.kernel.org>; Mon,  1 Nov 2021 10:36:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231952AbhKAKjS (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 1 Nov 2021 06:39:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60458 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231841AbhKAKjR (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 1 Nov 2021 06:39:17 -0400
Received: from mail-lj1-x233.google.com (mail-lj1-x233.google.com [IPv6:2a00:1450:4864:20::233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C4A7C061714
        for <linux-scsi@vger.kernel.org>; Mon,  1 Nov 2021 03:36:44 -0700 (PDT)
Received: by mail-lj1-x233.google.com with SMTP id k22so7078109ljk.5
        for <linux-scsi@vger.kernel.org>; Mon, 01 Nov 2021 03:36:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=lucidpixels.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=pVQav619x2X4UjJPey8K98Bzw1lSGkzDCrHK2MvFUJI=;
        b=etJVtLo4xD9B0y1aSZRUUg46nSq4jP2Q7/rAydrcYobYd1vPVRNbqK8EBchgakuUHo
         aqFsDGqBHRhN2ps0gefV6pRk+WPGBUOLZA8T+M8kFGuSpOBnUVWup7o1yOaY9uuQoKOl
         qsjzEOOH0BYdJY/7s85nCiY7qsa63eKLmDPrg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=pVQav619x2X4UjJPey8K98Bzw1lSGkzDCrHK2MvFUJI=;
        b=aBcHhPWO2OL2Ufcfi6yp3AAOIY3ffAfbcw/REyOOsOPuAZ3ce3fWXsNSfYiDT2bBvk
         Fmkp5mBLA0N5I/nDOkBNB1uCAY1A1Q8TXbI8mOcJ4VYiC27NyLqRoNud1Xi0rIFrGbJK
         ILlLbIyW73kE55iE1F20ZKp4BH71UNNu0FRafqzT7H/TRd28rzfRtK3lEgkmGlqXGN1p
         X+0jn4/Lyhspnpz+MnApyQNtHCjupPrRt8bN9R3DAwQdQvHdaS+DXYWxZJppO0fKpwRX
         I8YDzfvHs0TpGxjVHurrJJFRHP0QxTnXuk2JbPd+7EaUKldHCxtbQXIdn4UthOQZiMDk
         GnbQ==
X-Gm-Message-State: AOAM533eQg1dQ0K9zgjbNxufqIPK0ulN4u3jrm9tSfJJcVOpAjaxqJv/
        hZ3nIgYExE0+2SVO9GyndNxCZ6JWLqxAa0HZE+rWZA==
X-Google-Smtp-Source: ABdhPJw4ZOW74T2/vG+sfv8hc085u8aY8g2XwvVtUnLvClybodH8isp1yXatVcjVtoTPTNUn9/a2+IcMzrlpDkG7Hrk=
X-Received: by 2002:a2e:b8cd:: with SMTP id s13mr12321124ljp.527.1635763002593;
 Mon, 01 Nov 2021 03:36:42 -0700 (PDT)
MIME-Version: 1.0
References: <006a01d7cead$b9262d70$2b728850$@lucidpixels.com> <a4a88807-8f52-ef9a-c58e-0ff454da5ade@acm.org>
In-Reply-To: <a4a88807-8f52-ef9a-c58e-0ff454da5ade@acm.org>
From:   Justin Piszcz <jpiszcz@lucidpixels.com>
Date:   Mon, 1 Nov 2021 06:36:31 -0400
Message-ID: <CAO9zADxiobgwDE5dtvo98EL0djdgQyrGJA_w4Oxb+pZ9pvOEjQ@mail.gmail.com>
Subject: Re: kernel 5.15 does not boot with 3ware card (never had this issue
 <= 5.14) - scsi 0:0:0:0: WARNING: (0x06:0x002C) : Command (0x12) timed out,
 resetting card
To:     Bart Van Assche <bvanassche@acm.org>
Cc:     linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Sun, Oct 31, 2021 at 7:52 PM Bart Van Assche <bvanassche@acm.org> wrote:
>
> On 10/31/21 16:19, Justin Piszcz wrote:
> > Diff between 5.14 and 5.15 .config files-- could it be something to do with
> > CONFIG_IOMMU_DEFAULT_DMA_LAZY=y?
>
> That's hard to say. Is CONFIG_MAGIC_SYSRQ enabled? If not, please enable
> it and hit Alt-Printscreen-t (dump task list; see also
> Documentation/admin-guide/sysrq.rst) and share the contents of the
> kernel log. If that would not be convenient, please try to bisect this
> issue.

[ .. ]

It appears at this point in the boot process the keyboard (USB and
PS2) are not yet available and/or do not respond in this scenario (I
do have CONFIG_MAGIC_SYSRQ enabled+have used it in the past).  I'll
build the prior 5.15-rc(1-7) to check where it stopped working and
reply back to the list when I have that info.

Thanks!

Justin.
