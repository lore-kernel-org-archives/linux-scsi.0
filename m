Return-Path: <SRS0=XqvZ=B5=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.4 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4A537C433DF
	for <linux-scsi@archiver.kernel.org>; Wed, 19 Aug 2020 04:12:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 23E3D20709
	for <linux-scsi@archiver.kernel.org>; Wed, 19 Aug 2020 04:12:30 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="c0JvyFa4"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725876AbgHSEM3 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 19 Aug 2020 00:12:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39434 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725280AbgHSEMZ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 19 Aug 2020 00:12:25 -0400
Received: from mail-io1-xd2d.google.com (mail-io1-xd2d.google.com [IPv6:2607:f8b0:4864:20::d2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A132C061389
        for <linux-scsi@vger.kernel.org>; Tue, 18 Aug 2020 21:12:25 -0700 (PDT)
Received: by mail-io1-xd2d.google.com with SMTP id v6so23305793iow.11
        for <linux-scsi@vger.kernel.org>; Tue, 18 Aug 2020 21:12:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=OcTKziOEwEGUuJmD0iWVrbsTAPHF8MYSOhMtKY97SCo=;
        b=c0JvyFa4FCkSm6zF0t8gmScQUMLHHKA7+kvhFQFD3fSyXgLZvdxoSWsvtxKw13lwqU
         Eq/f7FQ54BR2IVfb5610WB9p61+pfbg0QPN1Hxu37E+JSZyeZ3cSw+4UNreohN+ZjBGi
         NEF8oUCm9C6iIkodm9VYb3C2ONkdQ1P3uxUcasJAXOUg6Pe8FwqjMDZnV/rP86vq0Enu
         m2hF8C03fxVJcsRZHTDLwqJVOKPr2c36Zv6Z97Lyx5fS1BV0OKFu7BgDmx9KUdvYm5Fu
         rXwnCKUHt071wlw1A387mi/fBxfym464x7MRcXzPsXFv2B9zDlFSVD3UFsB/8nid9wVY
         AkAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=OcTKziOEwEGUuJmD0iWVrbsTAPHF8MYSOhMtKY97SCo=;
        b=UKN2YYN8jPL9YQkTAVyl8QWcjPQBsbRpdWGR669FJeolUcMXCqfAEep2vKgr4lQI43
         MA7Xh46xpzeKXW+zzQyqvzgZUbgjCpScmXhh4YYjyMxcnM54PAm9aafRX5bVDbyJ6Ln8
         d55atGUNDYCCPWQ+TBUQav7/2u2/mMuLNF8XgRHDkWkfRkBdNliIAtQ+IyrH4sGDMWT9
         5TxSwi8KD80F7tJz9TVL20ACjKSfdXImTxNXcO4OqtGlqYjIoBuz0iLcKZBKl20Bvoym
         CZs/nBnOB7IAxtrzY8pRjLg5Y+FTVgmk3JaHloVxneV3pp3YCpHS+/0goUZp8jWv2eGX
         e3bw==
X-Gm-Message-State: AOAM531ZHCODOCY7g9mXrg4wseWIOzK+B067yw8LgjtEUhtee10xAlg+
        OK8nWMTdHChvGVLCqOtUOeLMouVnJKDlEznA5a3tLg==
X-Google-Smtp-Source: ABdhPJz4sbg+830QpHm7VA/vsS536DBf55fY9I2bU1QJ14Edyy0y79HRAv3W0nS42bX0nJRh4lwy9Kj89D/vNZ0fwIw=
X-Received: by 2002:a6b:b5c1:: with SMTP id e184mr18823994iof.208.1597810344130;
 Tue, 18 Aug 2020 21:12:24 -0700 (PDT)
MIME-Version: 1.0
References: <CACqKpR-5=bDwODQFfMY+o8-XJMCQmtLVAOiCEY8ApFwQr04A8A@mail.gmail.com>
 <20200817174215.GB4230@mtj.thefacebook.com>
In-Reply-To: <20200817174215.GB4230@mtj.thefacebook.com>
From:   Akshat Jain <akshatzen@google.com>
Date:   Tue, 18 Aug 2020 21:12:13 -0700
Message-ID: <CACqKpR8i=9A6kb05yCyh39HMZ8aEhEGacXTCvQKyUS=nYkqRiQ@mail.gmail.com>
Subject: Re: Question on ata_gen_passthru_sense interpretation of fixed format
 sense buffer
To:     Tejun Heo <tj@kernel.org>
Cc:     Vishakha Channapattan <vishakhavc@google.com>,
        linux-ide@vger.kernel.org, John Grass <jgrass@google.com>,
        Thieu Le <thieule@google.com>, linux-scsi@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hello Tejun,
Thank you very much for your reply.

To answer your question:
1. Yes we will start working on a patch and send it for review.
2. We found this issue during our code review.

Another information I need to bring to your attention is that many
user libraries today decode the fixed format sense block based on the
format today's kernel (ata_gen_passthru_sense) provides. Rather than
the format specified in the SCSI Primary commands - 4 specification.
If we were to correct the field offsets for the fixed format sense block.
It may break such libraries. How do you assess the impact
of such a change?

Regards,
Akshat

On Mon, Aug 17, 2020 at 10:42 AM Tejun Heo <tj@kernel.org> wrote:
>
> Hello,
>
> On Mon, Aug 03, 2020 at 09:44:26AM -0700, Akshat Jain wrote:
> > Hello Jens Tejun,
> > I have a question regarding the ata_gen_passthru_sense function (libata-scsi.c).
> >
> > This function while generating fixed format sense blocks, puts the
> > INFORMATION field at offset 8 and COMMAND-SPECIFIC-INFORMATION at
> > offset 16.
> > While as per SCSI Primary commands - 4 specification, section 4.5.3
> > Fixed format sense data Table 53, the INFORMATION field is at offset 3
> > and COMMAND-SPECIFIC-INFORMATION is at offset 8.
>
> Sorry about the late reply. I could have been easily mistaken and don't
> think the path has been under any kind of scrutiny. The best way to proceed
> would be submitting a patch referencing the spec cc'ing linux-ide and
> linux-scsi. Have you guys got bitten by this or is this discovered through
> code review?
>
> Thanks.
>
> --
> tejun
