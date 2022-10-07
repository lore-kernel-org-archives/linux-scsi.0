Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 32DCAC433FE
	for <linux-scsi@archiver.kernel.org>; Fri,  7 Oct 2022 19:17:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229688AbiJGTR3 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 7 Oct 2022 15:17:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43484 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229453AbiJGTR2 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 7 Oct 2022 15:17:28 -0400
Received: from mail-oi1-x231.google.com (mail-oi1-x231.google.com [IPv6:2607:f8b0:4864:20::231])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C2B3B10DA
        for <linux-scsi@vger.kernel.org>; Fri,  7 Oct 2022 12:17:27 -0700 (PDT)
Received: by mail-oi1-x231.google.com with SMTP id m130so6595227oif.6
        for <linux-scsi@vger.kernel.org>; Fri, 07 Oct 2022 12:17:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=2JDsqVdZnjWlaOQvu6EPe39LCBHFKQkuG1fa3tT0Gjw=;
        b=FayXRpNYC52MB8bTFhSz9+bsYprGVX95RfpxGW5qmC9ETLZKKhPBNDgsrYpSrOLKac
         x7J7OjkHOv2jzukOS0U+18mOEFxY76SKT3qOv1XfdOyEu1dfIvmA6dYbGzNed9AzfWSv
         9kakobjTxkn4LVnsYDdRzVAdFCA2TQ04sYgYk=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=2JDsqVdZnjWlaOQvu6EPe39LCBHFKQkuG1fa3tT0Gjw=;
        b=Kqbw4U8O2nr/pI3/xJ9UkqXzadML/WHiCgJDYiZloN8G1NHYH3LL+1S7Mil3JHyOtT
         K5rKl7fCZiP4owrxUrJloLTZ1HI3Bb4Mq8ZoHKDjWBZNx/CG1gN4Sbn8lBryVmC2uegr
         1NZ7OZ+tk9+vsnTXvhuLcbpmsaj+tk9I5znptFRZhhZcURq//O/vtpDsHTwwhfesdwxh
         a1Im+kVcEV/8OonEgGEJ0FbnXuRKr9Jzwf0JY8UesyU6pljDIf+OkNAzLpPaemMM1cwZ
         9K1QGqskkkH1XPXJ9yrw8BE/6aylnMu1pJXRDsKEiMNBqNmPIChrtp5Zu60qTbycuQ6X
         50gw==
X-Gm-Message-State: ACrzQf0P0b3nowIKEhqsisyR/qAPGVPK0+kBeZkG4pRilELx2F64H7Ot
        DEVbkbgQ6itv/uXOSpCbAoSHKUILTRNV/w==
X-Google-Smtp-Source: AMsMyM7w8n1p8mEA3qTtqr1/3OIE0ixqpE0y2lwiUZleE+gJ7KdNSCUSIzmxrfPvUeQugn2Ux6ieiw==
X-Received: by 2002:a05:6808:1997:b0:34f:d372:b790 with SMTP id bj23-20020a056808199700b0034fd372b790mr3237532oib.2.1665170246195;
        Fri, 07 Oct 2022 12:17:26 -0700 (PDT)
Received: from mail-oa1-f52.google.com (mail-oa1-f52.google.com. [209.85.160.52])
        by smtp.gmail.com with ESMTPSA id y21-20020a4ae715000000b00425678b9c4bsm1317917oou.0.2022.10.07.12.17.25
        for <linux-scsi@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 07 Oct 2022 12:17:25 -0700 (PDT)
Received: by mail-oa1-f52.google.com with SMTP id 586e51a60fabf-132af5e5543so6582403fac.8
        for <linux-scsi@vger.kernel.org>; Fri, 07 Oct 2022 12:17:25 -0700 (PDT)
X-Received: by 2002:a05:6870:c888:b0:12c:7f3b:d67d with SMTP id
 er8-20020a056870c88800b0012c7f3bd67dmr3561496oab.229.1665170244926; Fri, 07
 Oct 2022 12:17:24 -0700 (PDT)
MIME-Version: 1.0
References: <3727e267ba5a03e021ba06e46a97f260dcccc3e7.camel@HansenPartnership.com>
In-Reply-To: <3727e267ba5a03e021ba06e46a97f260dcccc3e7.camel@HansenPartnership.com>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Fri, 7 Oct 2022 12:17:09 -0700
X-Gmail-Original-Message-ID: <CAHk-=whAUVVgVQWHig=rK1sw7RhjVENrqXDcKGF_mP8mmU9oFA@mail.gmail.com>
Message-ID: <CAHk-=whAUVVgVQWHig=rK1sw7RhjVENrqXDcKGF_mP8mmU9oFA@mail.gmail.com>
Subject: Re: [GIT PULL] first round of SCSI updates for the 6.0+ merge window
To:     James Bottomley <James.Bottomley@hansenpartnership.com>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Fri, Oct 7, 2022 at 9:16 AM James Bottomley
<James.Bottomley@hansenpartnership.com> wrote:
>
> The patch is available here:
>
> git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git scsi-misc

Nope. Nothing there. That's just very old state from July.

And since the pull request isn't even standard 'git request-pull'
format, there's no indication of what the top commit *should* be.

Please fix and re-post a proper pull request,

               Linus
