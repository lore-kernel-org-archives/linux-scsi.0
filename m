Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E7E76C433E0
	for <linux-scsi@archiver.kernel.org>; Fri,  1 Jan 2021 21:23:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B703B20723
	for <linux-scsi@archiver.kernel.org>; Fri,  1 Jan 2021 21:23:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727382AbhAAVWw (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 1 Jan 2021 16:22:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48402 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727316AbhAAVWw (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 1 Jan 2021 16:22:52 -0500
Received: from mail-lf1-x12a.google.com (mail-lf1-x12a.google.com [IPv6:2a00:1450:4864:20::12a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC2E4C0613C1
        for <linux-scsi@vger.kernel.org>; Fri,  1 Jan 2021 13:22:11 -0800 (PST)
Received: by mail-lf1-x12a.google.com with SMTP id x20so50613889lfe.12
        for <linux-scsi@vger.kernel.org>; Fri, 01 Jan 2021 13:22:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=l/t+YUq5T+ELO4aOtS9plxw75Wi8Om3hyqh2Adc8MEI=;
        b=dKKZr5xFIrSTAlTu+ix1NH8DxFEU3G8oH6e6h8Sitlp3uawgNXOut539JreZMt5j1T
         9v/qLcylBLWlZEZSZSSzuQwezNhlXB7kzDwZLp5QX32/w8Tm3CXxTDDqu1T7Yulux+Yq
         RitFzhBm4N3B8EEuTDExRa5WHblQEeQ5Ktk0A=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=l/t+YUq5T+ELO4aOtS9plxw75Wi8Om3hyqh2Adc8MEI=;
        b=jJWxSJIudX3uj3GYQJZVbZZP6mNQr6MAmQUnCbcXgGkY/muEa2lEEmoZPN/rqaXQ5f
         I0oDq7fYnqI5ngygAlXfkJTVFqoBIvyuPuCduOCmhaqC3fqaey2lBhsdlZYUJ2JqkhYj
         O8Ow3ezLnlAGp+zcpkE6ApW+EXq7hX2u7SfHSpOj6He6UiQToErzj3kBmRMz/AcQ3a0w
         mBlRSDtxCaE2EAECUTCS45b655fSVcwEig2VFZuzqAytJG6umwmQOT0RxUc07xKIJtBT
         syF9sihIamzP8s2m8T+1Ba7t4VXHDApx+Vd/X7VvAXVpH0DXJ+eJKF/Mm2Ub92CW3i5r
         FW0A==
X-Gm-Message-State: AOAM532swEiP1eqQ6i/YbRXo99ywlK8PHeWGvgSNkaUPXH2/U21nwcKP
        GTEqLvrtpaJLoR0XdXHFcgxv2xSJqtifrQ==
X-Google-Smtp-Source: ABdhPJw4QI4wakGwvewiOktYbOyUHeCNtXcfgkiGS1P/QKXPJkDu9Tb+ry5POSu9L9Or9vrafhSALg==
X-Received: by 2002:a19:3811:: with SMTP id f17mr26046039lfa.28.1609536130050;
        Fri, 01 Jan 2021 13:22:10 -0800 (PST)
Received: from mail-lf1-f42.google.com (mail-lf1-f42.google.com. [209.85.167.42])
        by smtp.gmail.com with ESMTPSA id i11sm7932945ljb.19.2021.01.01.13.22.08
        for <linux-scsi@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 01 Jan 2021 13:22:09 -0800 (PST)
Received: by mail-lf1-f42.google.com with SMTP id h22so50726185lfu.2
        for <linux-scsi@vger.kernel.org>; Fri, 01 Jan 2021 13:22:08 -0800 (PST)
X-Received: by 2002:a19:8557:: with SMTP id h84mr25712082lfd.201.1609536128658;
 Fri, 01 Jan 2021 13:22:08 -0800 (PST)
MIME-Version: 1.0
References: <dd63a06d53c45f9511307085797086351784b1a3.camel@HansenPartnership.com>
In-Reply-To: <dd63a06d53c45f9511307085797086351784b1a3.camel@HansenPartnership.com>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Fri, 1 Jan 2021 13:21:52 -0800
X-Gmail-Original-Message-ID: <CAHk-=widrXOWKSaDmMLZyhJzUvKx6M0uDP1xGJzYB4YGAJqHJA@mail.gmail.com>
Message-ID: <CAHk-=widrXOWKSaDmMLZyhJzUvKx6M0uDP1xGJzYB4YGAJqHJA@mail.gmail.com>
Subject: Re: [GIT PULL] SCSI fixes for 5.11-rc1
To:     James Bottomley <James.Bottomley@hansenpartnership.com>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Fri, Jan 1, 2021 at 12:19 PM James Bottomley
<James.Bottomley@hansenpartnership.com> wrote:
>
> Originally this change was slated for the merge window but a late
> arriving build problem with CONFIG_PM=n derailed that.

So I've pulled this, but we need to have a policy for reverting this
quickly if it turns out to cause problems.

I'm not worried about any remaining build issues - but I'm simply
worried about some missed case where code depended on the block layer
passing commands through even while suspended.

The block bits would seem affect non-SCSI stuff too, how extensively
have any random odd special case been tested?

So I'm not so much with you on the "the scary case is the spi domain
validation case".  I'm more about "what about all the other random
cases for random special drivers"

                Linus
