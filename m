Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5A8DBC001DB
	for <linux-scsi@archiver.kernel.org>; Sat,  2 Sep 2023 19:08:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232225AbjIBTIu (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 2 Sep 2023 15:08:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52614 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232135AbjIBTIu (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 2 Sep 2023 15:08:50 -0400
Received: from mail-ed1-x534.google.com (mail-ed1-x534.google.com [IPv6:2a00:1450:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 13105CC5
        for <linux-scsi@vger.kernel.org>; Sat,  2 Sep 2023 12:08:47 -0700 (PDT)
Received: by mail-ed1-x534.google.com with SMTP id 4fb4d7f45d1cf-52a4818db4aso149176a12.2
        for <linux-scsi@vger.kernel.org>; Sat, 02 Sep 2023 12:08:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1693681725; x=1694286525; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=mMRyrKbAp4LZVuQSTEbdVAQvbekmFXrSYzVfEdiyF4s=;
        b=IRn5VhmJInfK728yHiVkaYfbMMHaNh8ZCkuBFeASlG+uZ3dV430Zr4vKn30O60dr+J
         K23HM7LnGpoZWVf2U4Fx5gSr2I5pgfC3TOqTn31UR3L6u1v7DD4Y9uGPf0pvpN5G7fiO
         NVddr/ZG5yScD7aHsBo5upq2ZOoEwGlb15j8M=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1693681725; x=1694286525;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=mMRyrKbAp4LZVuQSTEbdVAQvbekmFXrSYzVfEdiyF4s=;
        b=VXg9jaIKVOLQSOed3Ktnonp2tyy+jckBpmbcbQyE3d2y7Mub0Tx6tgqbFbXlC73GqY
         6WdC6zKBIIUSoXyKxYYs/Jsj5BTKNvEWCmyrK2jDGDTqVPZHC0UWTy/ukVX9nngbMmfn
         y/jMl46ZSDh3h3lmHibmpJLGKmsnTIrHtDm1GPIfxZilMiE8LKCpTSJZ4b/TFDVh7N5D
         Zp39foW3Ax2c+4kUiY0rkCpe2DErdeaptvsmHIKi9bhDhJuhvCCOBPcywg1fPzwmQkWB
         HcMzQiMyNOK3ds1e0/+DHy/fj2NC1EObRBplnuHGE4jfX6zRYRJcFE/bspDVoy5ha5TH
         6wiA==
X-Gm-Message-State: AOJu0YyKYVWYG2O9hnAa3DEA2rxhlWachq1grPnX4T/rTE82Sriy8GA3
        w+1PHElnkheB2DHbmcyLJMIZHh4rOLlU8yFiCwJcyPGu
X-Google-Smtp-Source: AGHT+IHo7FgOlANzsMG19wnjb3g4TiAYqa6akA5XWDd7vpmHasJaUmmT+49xOcGqtCzsotUHcI3Aug==
X-Received: by 2002:aa7:d6d5:0:b0:523:3e77:7eb5 with SMTP id x21-20020aa7d6d5000000b005233e777eb5mr4001453edr.2.1693681725307;
        Sat, 02 Sep 2023 12:08:45 -0700 (PDT)
Received: from mail-wr1-f51.google.com (mail-wr1-f51.google.com. [209.85.221.51])
        by smtp.gmail.com with ESMTPSA id c24-20020a056402121800b005256d4d58a6sm3687774edw.18.2023.09.02.12.08.44
        for <linux-scsi@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 02 Sep 2023 12:08:44 -0700 (PDT)
Received: by mail-wr1-f51.google.com with SMTP id ffacd0b85a97d-31aeee69de0so92663f8f.2
        for <linux-scsi@vger.kernel.org>; Sat, 02 Sep 2023 12:08:44 -0700 (PDT)
X-Received: by 2002:a5d:6812:0:b0:317:df4f:4b97 with SMTP id
 w18-20020a5d6812000000b00317df4f4b97mr3843777wru.7.1693681724043; Sat, 02 Sep
 2023 12:08:44 -0700 (PDT)
MIME-Version: 1.0
References: <6908480e8808a2d025926f2ff1f9a2468d1b6bb9.camel@HansenPartnership.com>
In-Reply-To: <6908480e8808a2d025926f2ff1f9a2468d1b6bb9.camel@HansenPartnership.com>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Sat, 2 Sep 2023 12:08:26 -0700
X-Gmail-Original-Message-ID: <CAHk-=wgA6CBwnJ02H+vSgneKPcPRP0BWQ-Kx2Re1B56Y2hXkFQ@mail.gmail.com>
Message-ID: <CAHk-=wgA6CBwnJ02H+vSgneKPcPRP0BWQ-Kx2Re1B56Y2hXkFQ@mail.gmail.com>
Subject: Re: [GIT PULL] first round of SCSI updates for the 6.4+ merge window
To:     James Bottomley <James.Bottomley@hansenpartnership.com>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Sat, 2 Sept 2023 at 00:39, James Bottomley
<James.Bottomley@hansenpartnership.com> wrote:
>
> Updates to the usual drivers (ufs, lpfc, qla2xxx, mpi3mr, libsas) and
> the usual minor updates and bug fixes but no significant core changes.

Removing 3000+ lines for UFS HPB support wasn't even worth mentioning?

I am happy to see it gone, and maybe as a technology it was a failure
not worth it, but as a "we gave up on it as being worthless" might
still have been worth a word or two..

Sadly, I see from the commit message that apparently the next stage is
going to involve zoned storage. Now *there* is a technology that seems
to be a complete failure, brought to us by the same kind of failed
hardware people who tried to convince us that we should care about
64kB pages in SSD's.

Oh well. With enough thrust, even a pig will fly. I suspect that's the
motivating factor behind all those zoned storage things too.

                Linus
