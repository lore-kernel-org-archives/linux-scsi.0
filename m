Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E0AB5C433F5
	for <linux-scsi@archiver.kernel.org>; Fri, 14 Jan 2022 13:46:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241421AbiANNqV (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 14 Jan 2022 08:46:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40066 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235680AbiANNqU (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 14 Jan 2022 08:46:20 -0500
Received: from mail-ed1-x52a.google.com (mail-ed1-x52a.google.com [IPv6:2a00:1450:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3CB68C061574
        for <linux-scsi@vger.kernel.org>; Fri, 14 Jan 2022 05:46:20 -0800 (PST)
Received: by mail-ed1-x52a.google.com with SMTP id z22so35139476edd.12
        for <linux-scsi@vger.kernel.org>; Fri, 14 Jan 2022 05:46:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=GWRH+rvwHqP1z4qchF8L9hZG2NGx1v2K+/SKPTErMzY=;
        b=YgoipMgKyro6jhYaoBISHi6o0+jzJtH4pf7nE3n8Il8c9EeiBNt04Y0WBlh3M+Lo1B
         DitUOHbXTcE8ForIPXgyFrU3bYuRCXzvRPEfCnoBL0exnKMjLqKN8+XdplsJ8ivFf2W4
         m0gOXN1tK9WVG8zjW79Cn57gnc105aPJuGABE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=GWRH+rvwHqP1z4qchF8L9hZG2NGx1v2K+/SKPTErMzY=;
        b=Vcffh1IWLVxD0IEuNG6tygsUKv3NgCoozxdwyn9UL+ZxOY0AjB8S3KVnSBLv34eO9N
         vVw2tF8F4Iv4KRCCEUGXTXTl48Q4+owDGxORblQDi+vE5j3ZZja3P3LEkOZJFBkWt8+Q
         aM/McWqppZKJN8W3ZQitwJ/Gx0PlAJNe7qIHD4DBrdYxUIHFOEYDyT5clAriR9e6wRWn
         xKZQpRMXr83b22hv+zMtoavQxvASClhWJZhQ/G/N4BLc46iLDTuy53YmlAmHxDHh0H4v
         638TMa9D/+Gb3SzrHEuEMPIo4d4yCMg7WxbNF5QGe6o7orpFMtGec54teL/RL1buwpU8
         +GNg==
X-Gm-Message-State: AOAM531XPm5urwhp9d3oaTanbCQpDw9OJSiMQ/NZ4Ji4P4hDpJPs2mHq
        olzomZt8/rQYFU9k+NuH+B0efkDDolYuSF6r
X-Google-Smtp-Source: ABdhPJwO0A4cmDQzji4pxNmA7xrqe1VF7+OYgAvYhpfMUWaCSdcZao5tQjYSeuVsmqZn80Of8dVWCQ==
X-Received: by 2002:a17:906:4781:: with SMTP id cw1mr7896277ejc.116.1642167978514;
        Fri, 14 Jan 2022 05:46:18 -0800 (PST)
Received: from mail-wr1-f45.google.com (mail-wr1-f45.google.com. [209.85.221.45])
        by smtp.gmail.com with ESMTPSA id 2sm1835547ejt.224.2022.01.14.05.46.17
        for <linux-scsi@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 14 Jan 2022 05:46:18 -0800 (PST)
Received: by mail-wr1-f45.google.com with SMTP id k18so15659601wrg.11
        for <linux-scsi@vger.kernel.org>; Fri, 14 Jan 2022 05:46:17 -0800 (PST)
X-Received: by 2002:a5d:4575:: with SMTP id a21mr8140206wrc.281.1642167977708;
 Fri, 14 Jan 2022 05:46:17 -0800 (PST)
MIME-Version: 1.0
References: <31f8716fbb4f1e2a332b2b3e3243a170e8b01145.camel@HansenPartnership.com>
In-Reply-To: <31f8716fbb4f1e2a332b2b3e3243a170e8b01145.camel@HansenPartnership.com>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Fri, 14 Jan 2022 14:46:01 +0100
X-Gmail-Original-Message-ID: <CAHk-=wjx_q9Aa=o5kiiSpCC_4U+H2D1=H3umFOwVMUbFmdQjGA@mail.gmail.com>
Message-ID: <CAHk-=wjx_q9Aa=o5kiiSpCC_4U+H2D1=H3umFOwVMUbFmdQjGA@mail.gmail.com>
Subject: Re: [GIT PULL] first round of SCSI updates for the 5.15+ merge window
To:     James Bottomley <James.Bottomley@hansenpartnership.com>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, Jan 13, 2022 at 9:22 PM James Bottomley
<James.Bottomley@hansenpartnership.com> wrote:
>
> Adrian Hunter (4):
>       scsi: ufs: ufs-pci: Add support for Intel ADL
>       scsi: ufs: Let devices remain runtime suspended during system suspend
>       scsi: ufs: core: Fix another task management completion race
>       scsi: ufs: core: Fix task management completion timeout race
[...]

You seem to have forgotten to fetch my upstream tree, so your shortlog
(or diffstat) doesn't seem to take the various fixes pulls you did for
5.16 into account.

The only actual new commit I got from Adrian was

Adrian Hunter (1):
      scsi: ufs: Let devices remain runtime suspended during system suspend

and the same for other fixes..

Not a big deal, but when the shortlog and diffstat don't match what I
get, I waste time figuring out why. So please do a "git fetch linus"
or whatever so that git can take all your previous pulls into
account..

                Linus
