Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DCB07C433F5
	for <linux-scsi@archiver.kernel.org>; Sun,  7 Nov 2021 13:47:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BE3F16044F
	for <linux-scsi@archiver.kernel.org>; Sun,  7 Nov 2021 13:47:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235422AbhKGNtx (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 7 Nov 2021 08:49:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51754 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230128AbhKGNtw (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 7 Nov 2021 08:49:52 -0500
Received: from mail-lf1-x12e.google.com (mail-lf1-x12e.google.com [IPv6:2a00:1450:4864:20::12e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E28CC061570
        for <linux-scsi@vger.kernel.org>; Sun,  7 Nov 2021 05:47:09 -0800 (PST)
Received: by mail-lf1-x12e.google.com with SMTP id b40so565972lfv.10
        for <linux-scsi@vger.kernel.org>; Sun, 07 Nov 2021 05:47:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=lucidpixels.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=RqyROr9ApPxu/JZ1Q/EKRmNX6vkXC18N6kT/PZWoRP8=;
        b=jxeV21n7iYgsnnLYx9dw3wR8o9vrTEbgfxVrw766SWKApkbT2W+I7me0SFf22rIeA7
         EXdLLcxN6he9/zILczfiHTb4z+8xucDH+0EJql0So2j95oOI+/iX9hL9TuQ2QZwvyLJS
         Nk3SjeB4Z4xe378Im3Ruj0CuYpm7aZp9K0Qg0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=RqyROr9ApPxu/JZ1Q/EKRmNX6vkXC18N6kT/PZWoRP8=;
        b=Zh8IsD2Ewq0W3DHzq0ZRqSRe0SRl29WmOJF7aPlz7/UESZZ6SviFyXlnBvoJ1UukKQ
         YdWzui83CvFx7zriqKLv33ukeJPV0JeBodrXA+7rM6uFE6RETtpHMezDoGY5tQY7/+o6
         +UOPiVwvSoM+lIR8M50LotOxb2wCsh19CLWhjSfylnMn1ksdTpifzTlJfvHAUTawnuvR
         9QkRXC2zqRlhfxOQBGIYa7zwgH3o09Awqoq42S+UJx5aoXBib50qiS+k5vtfMb+rAfax
         TCrlXp7ZgqF9bUsfon7E4sK/2Mnc4esIS01jNrw5U1CSnklAz55WQPumURFqTpBvj2jZ
         RyxA==
X-Gm-Message-State: AOAM531pQ/v0U9kkifYFw12g/sN+dco4/YtjliZDqj8lGfX5+loH6Mfd
        WM+xcdQcDNRHo+/Nw5ElWfmC9lVlC6IbQx/PVEtJAA==
X-Google-Smtp-Source: ABdhPJzw1EnLJGkuZP1Xf4IaMZXAjiUdUQ4xrFbTuGea9jXiieQ5PCN1QhNvJ1XmViTD1xALcSLRfVImhzb2UsoVIys=
X-Received: by 2002:a05:6512:1323:: with SMTP id x35mr71202909lfu.613.1636292827818;
 Sun, 07 Nov 2021 05:47:07 -0800 (PST)
MIME-Version: 1.0
References: <006a01d7cead$b9262d70$2b728850$@lucidpixels.com>
 <a4a88807-8f52-ef9a-c58e-0ff454da5ade@acm.org> <CAO9zADxiobgwDE5dtvo98EL0djdgQyrGJA_w4Oxb+pZ9pvOEjQ@mail.gmail.com>
 <CAO9zADycForyq9cmh=epw9r-Wzz=xt32vL3mePuBAPehCgUTjw@mail.gmail.com>
 <50a16ee2-dfa4-d009-17c5-1984cf0a6161@linux.vnet.ibm.com> <CAO9zADwVnuKU-tfZxm4USjf76yJhTZqWfZw4yspv8sc93RuBbQ@mail.gmail.com>
 <e0c2935d-d961-11a0-1b4c-580b55dc6b59@acm.org> <002401d7d305$082971b0$187c5510$@lucidpixels.com>
In-Reply-To: <002401d7d305$082971b0$187c5510$@lucidpixels.com>
From:   Justin Piszcz <jpiszcz@lucidpixels.com>
Date:   Sun, 7 Nov 2021 08:46:56 -0500
Message-ID: <CAO9zADzWcpwZkfJ5VZGZZJT39KQEUr9yGqqCnP18mk7ZAZxbBw@mail.gmail.com>
Subject: Re: kernel 5.15 does not boot with 3ware card (never had this issue
 <= 5.14) - scsi 0:0:0:0: WARNING: (0x06:0x002C) : Command (0x12) timed out,
 resetting card
To:     Bart Van Assche <bvanassche@acm.org>,
        Douglas Miller <dougmill@linux.vnet.ibm.com>
Cc:     LKML <linux-kernel@vger.kernel.org>, linux-scsi@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Sat, Nov 6, 2021 at 7:54 AM Justin Piszcz <jpiszcz@lucidpixels.com> wrote:
>
>
>
> -----Original Message-----
> From: Bart Van Assche <bvanassche@acm.org>
> Sent: Wednesday, November 3, 2021 12:23 PM
> To: Justin Piszcz <jpiszcz@lucidpixels.com>; Douglas Miller <dougmill@linux.vnet.ibm.com>
> Cc: LKML <linux-kernel@vger.kernel.org>; linux-scsi@vger.kernel.org
> Subject: Re: kernel 5.15 does not boot with 3ware card (never had this issue <= 5.14) - scsi 0:0:0:0: WARNING: (0x06:0x002C) : Command (0x12) timed out, resetting card
>
> On 11/3/21 9:18 AM, Justin Piszcz wrote:
> > Thanks!-- Has anyone else reading run into this issue and/or are there
> > any suggestions how I can troubleshoot this further (as all -rc's have
> > the same issue)?
>
> How about bisecting this issue
> (https://www.kernel.org/doc/html/latest/admin-guide/bug-bisect.html)?
>
> [ .. ]
>
> I was having some issues finding a list of changes with git bisect, so I started checking the kernel .config and boot parameters:
>
> I found the option that was causing the system not to boot (tested with 5.15.0 and latest linux-git as of 6 NOV 2021)
> append="3w-sas.use_msi=1"
>
> 3w-sas.use_msi defaults to 0 (so now it is using IR-IO-APIC instead of MSI but now the machine boots using 5.15)
> https://lwn.net/Articles/358679/
>
> Something between 5.14 and 5.15 changed regarding x86_64's handling of Message Signaled Interrupts.
> ... which causes the kernel to no longer boot when 3w-sas.use_msi=1 is specified starting with 5.15.

This only partially fixes the issues, trying to reboot also results in
a hard lockup on cpu 1 (this is semi-reproducible)
https://installkernel.tripod.com/5.15-reboot-lockup.jpg

Back to 5.14.x for now...



Justin.
