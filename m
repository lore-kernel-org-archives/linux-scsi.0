Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5793BC433EF
	for <linux-scsi@archiver.kernel.org>; Fri, 19 Nov 2021 19:29:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 41EF860F4F
	for <linux-scsi@archiver.kernel.org>; Fri, 19 Nov 2021 19:29:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236012AbhKSTcq (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 19 Nov 2021 14:32:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43630 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235999AbhKSTcp (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 19 Nov 2021 14:32:45 -0500
Received: from mail-ed1-x530.google.com (mail-ed1-x530.google.com [IPv6:2a00:1450:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 33580C061574
        for <linux-scsi@vger.kernel.org>; Fri, 19 Nov 2021 11:29:43 -0800 (PST)
Received: by mail-ed1-x530.google.com with SMTP id l25so30399400eda.11
        for <linux-scsi@vger.kernel.org>; Fri, 19 Nov 2021 11:29:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=EcWMNc6Vpg51MXv4sgBrEJhLBETGzdtE97VuddJjcLc=;
        b=FoqppIpL9PH09xZ/j3XRcFrAQH3P0pqGLDIX7HSq0Xb+Hc2SihFt3aREYLVVwJb8hC
         mEgrdLC0kruoIuxf4cZZ8bCv46sqpNNq5K5EHHZjXw229OrWvjZq3zdA8xjhX9kWpgEy
         FbvD/p21wbE87Ilb/jZhIM5LtilfTq122kZ0s=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=EcWMNc6Vpg51MXv4sgBrEJhLBETGzdtE97VuddJjcLc=;
        b=zEiHB5s4HhXcSKPmZ3Rtg7upojXbd9NBVCkAm+gTZ+IP2EtLoE1/wKqqO1gHDIxDyh
         FfwR946THWXUjBmINx9VqcMQcgUbhu43QpYP8g2WkYhnJS0YteX1vvGOihqMoHIaCAEW
         rghQin8cbZgaur2xY2Wu187Q+WpEJn53O6Gbp409lZcaTg3EEipyhbZZokxGjgfke3lL
         HPHs1uF3BajTUVR2ZW29XLSLkkZjVbGLklF5UR8DfHb/NpEvc7JUDgIMofPOcPsCMRxL
         RdI61M8aN5GhWOWbiymGRDv517S5pPSVakhjmo34ml7v5KIS6VYcEofsaTpzU9oCXpTf
         +dNA==
X-Gm-Message-State: AOAM531IBK9O3dXBAgAvq97yjlY8rtLqMn7Hp1vdEGbyQQyGY2Tyq3/G
        bNtShf72SvLx8NjQKck6ETfFOa0zIK56WOOr
X-Google-Smtp-Source: ABdhPJzFEYZBLKIFPFDvvOm2t3hImd5idLB7fuw0r3Bw98MHEe5yggYNQ5YL17v2iPW18mAF1Yb/zQ==
X-Received: by 2002:a50:c909:: with SMTP id o9mr28066477edh.122.1637350181144;
        Fri, 19 Nov 2021 11:29:41 -0800 (PST)
Received: from mail-wr1-f47.google.com (mail-wr1-f47.google.com. [209.85.221.47])
        by smtp.gmail.com with ESMTPSA id sa17sm327232ejc.123.2021.11.19.11.29.40
        for <linux-scsi@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 19 Nov 2021 11:29:40 -0800 (PST)
Received: by mail-wr1-f47.google.com with SMTP id s13so19904907wrb.3
        for <linux-scsi@vger.kernel.org>; Fri, 19 Nov 2021 11:29:40 -0800 (PST)
X-Received: by 2002:adf:cf05:: with SMTP id o5mr10758365wrj.325.1637350180007;
 Fri, 19 Nov 2021 11:29:40 -0800 (PST)
MIME-Version: 1.0
References: <0a508ff31bbfa9cd73c24713c54a29ac459e3254.camel@HansenPartnership.com>
In-Reply-To: <0a508ff31bbfa9cd73c24713c54a29ac459e3254.camel@HansenPartnership.com>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Fri, 19 Nov 2021 11:29:24 -0800
X-Gmail-Original-Message-ID: <CAHk-=wjiTXOy3EJ4Eb++umuCgiDufJxrNZ9Z17_NhdORKZGbSA@mail.gmail.com>
Message-ID: <CAHk-=wjiTXOy3EJ4Eb++umuCgiDufJxrNZ9Z17_NhdORKZGbSA@mail.gmail.com>
Subject: Re: [GIT PULL] SCSI fixes for 5.16-rc1
To:     James Bottomley <James.Bottomley@hansenpartnership.com>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Fri, Nov 19, 2021 at 10:20 AM James Bottomley
<James.Bottomley@hansenpartnership.com> wrote:
>
> Six fixes, five in drivers (ufs, qla2xxx, iscsi) and one core change to
> fix a regression in user space device state setting, which is used by
> the iscsi daemons to effect device recovery.

Language nit.

One of the few correct uses of "to effect" - but perhaps best avoided
just because even native speakers get it wrong. And we have a lot of
non-native speakers too.

It might have been clearer to just say "to start device recovery" or
perhaps just "as part of device recovery". Just to avoid confusion
with "affect". Which it obviously _also_ does.

I kept your wording, but this is just a note that maybe commit
messages should strive to generally use fairly basic English language
and try to avoid things that are known to trip people up.

            Linus
