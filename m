Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0BA1FEE14C3
	for <linux-scsi@archiver.kernel.org>; Sat,  9 Sep 2023 19:08:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241718AbjIITHo (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 9 Sep 2023 15:07:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53450 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241593AbjIITHo (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 9 Sep 2023 15:07:44 -0400
Received: from mail-lj1-x22f.google.com (mail-lj1-x22f.google.com [IPv6:2a00:1450:4864:20::22f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF88C1AA
        for <linux-scsi@vger.kernel.org>; Sat,  9 Sep 2023 12:07:39 -0700 (PDT)
Received: by mail-lj1-x22f.google.com with SMTP id 38308e7fff4ca-2bccda76fb1so53725881fa.2
        for <linux-scsi@vger.kernel.org>; Sat, 09 Sep 2023 12:07:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1694286457; x=1694891257; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=2YnWP7VfXn+k9yatNje7Bpehe5l9b+P3goY1ZXeneT0=;
        b=YBR6GJjQ/aPZZlZzq2XGKS4Fr/2SpKHE2abeOpuSH/dAy1xCeKc7od7t0E4mRueeF4
         X+rWuQJDNDiRNdljJhRV18cUqf5WpocYShdhPqyUX6BibSTj14B0Nh/AXYWlJiJcFOhY
         TbvybSYXau6/pgVk0PVm6HRFqg6hRmsCyR8qQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1694286457; x=1694891257;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=2YnWP7VfXn+k9yatNje7Bpehe5l9b+P3goY1ZXeneT0=;
        b=SHtKx43FmOBw3miy8GdyHZuv4Iw4JeMwViA63JyB5RTyJ0d4X+t+IhN5nUHEE5f8+Y
         ewIZFP6MsAnZkP+Pvrv++cVglC1wn/GRwaYUxOZoOque/oXgJqV2U6O5VahegX9z0Fsn
         f1iuOd4oK8GwpnuaGT+4XhV7efyTevdNNoJIkUTlQ9/z1l69vBCflqchQ8RHL+GfQPTH
         JYLaw/fhmc3h5P9qLVSfyqodNeE56d2NZcyZE8dOBpmM7YcefkHJhKRLNx3foZQhuy+7
         /4WFtWWALGMpBtNtI4mYwsD1DYkiqdHqwYCotdMoEBW7ZU+xOoJ8K0p+V/aBrxfNw7sz
         7cWg==
X-Gm-Message-State: AOJu0YywOISg1GjeBS+f99dIA/WAdwJy99WFuCsh5FHbEDiGY/rADckl
        oNe7y9UElpz2u+cmIGWAWLOf+PEEmT5p07xi5+fweTkf
X-Google-Smtp-Source: AGHT+IGKtUDeqIxsuvY4fI9poM5zGYw2MEvo/p46yVAWWi5+WztmZpxUphqcsGEYl4jMgs8OaUtvUA==
X-Received: by 2002:a2e:9b0a:0:b0:2bc:d567:bdbd with SMTP id u10-20020a2e9b0a000000b002bcd567bdbdmr4631989lji.15.1694286457483;
        Sat, 09 Sep 2023 12:07:37 -0700 (PDT)
Received: from mail-ej1-f46.google.com (mail-ej1-f46.google.com. [209.85.218.46])
        by smtp.gmail.com with ESMTPSA id w26-20020a170906131a00b009a1c4d04989sm2670514ejb.217.2023.09.09.12.07.36
        for <linux-scsi@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 09 Sep 2023 12:07:37 -0700 (PDT)
Received: by mail-ej1-f46.google.com with SMTP id a640c23a62f3a-99bf3f59905so379211566b.3
        for <linux-scsi@vger.kernel.org>; Sat, 09 Sep 2023 12:07:36 -0700 (PDT)
X-Received: by 2002:a17:907:77c3:b0:9a1:cfd5:1f3a with SMTP id
 kz3-20020a17090777c300b009a1cfd51f3amr4317899ejc.13.1694286456638; Sat, 09
 Sep 2023 12:07:36 -0700 (PDT)
MIME-Version: 1.0
References: <285d43b9cbe7bc2b9aaa8537345f14aeec93c982.camel@HansenPartnership.com>
In-Reply-To: <285d43b9cbe7bc2b9aaa8537345f14aeec93c982.camel@HansenPartnership.com>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Sat, 9 Sep 2023 12:07:19 -0700
X-Gmail-Original-Message-ID: <CAHk-=wh9eoo+zHigat9FSeCLLCDjumFbY8Sb4Z5qgdc4MX0byw@mail.gmail.com>
Message-ID: <CAHk-=wh9eoo+zHigat9FSeCLLCDjumFbY8Sb4Z5qgdc4MX0byw@mail.gmail.com>
Subject: Re: [GIT PULL] final round of SCSI updates for the 6.5+ merge window
To:     James Bottomley <James.Bottomley@hansenpartnership.com>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Sat, 9 Sept 2023 at 07:47, James Bottomley
<James.Bottomley@hansenpartnership.com> wrote:
>
> Mostly small stragglers that missed the initial merge.  Driver updates
> are qla2xxx [..]

That's not even remotely a "small straggler". That's a thousand lines
of new code.

I've pulled this, but I'm not going to keep playing these games.
Getting pull requests with big changes in the last day before I close
the merge window is simply not ok.

The two weeks are for integrations, not for "we put them in the tree
at the last minute before the merge window, and needed the merge
window time to just have them actually get tested in linux-next".

And actively misleading pull requests only piss me off. I look at the
diffstat, stop trying to minimize or hide big last-minute changes.

              Linus
