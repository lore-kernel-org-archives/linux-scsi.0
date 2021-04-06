Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 002E7C433B4
	for <linux-scsi@archiver.kernel.org>; Tue,  6 Apr 2021 05:27:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C0BAD613C3
	for <linux-scsi@archiver.kernel.org>; Tue,  6 Apr 2021 05:27:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242572AbhDFF1I (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 6 Apr 2021 01:27:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37272 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232874AbhDFF1H (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 6 Apr 2021 01:27:07 -0400
Received: from mail-ed1-x536.google.com (mail-ed1-x536.google.com [IPv6:2a00:1450:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 585DBC06174A
        for <linux-scsi@vger.kernel.org>; Mon,  5 Apr 2021 22:27:00 -0700 (PDT)
Received: by mail-ed1-x536.google.com with SMTP id h10so14925515edt.13
        for <linux-scsi@vger.kernel.org>; Mon, 05 Apr 2021 22:27:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ionos.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=O4Bg6lHEr1Bcp5d6hAJjcBdq76xAwkKeYR92aKtHBrs=;
        b=VMz+w4Z3Cf8+n+GEU9s0APy0+L0oywRZagtG4g41FfPnUb5CJW0hQryA99cORzbefn
         Ej04TiGNCvF+yUlQ4aihFZI5J6+PgCbfssuD4kjGR1w/hG3GWeIj2gy3V/bt5Oj8ksNR
         cieGQBP6RAGYirbYixfrugimIHCV7UWez6BGZgxlgIVwKA1ftzk2qbB/yoTzIMHeVbrR
         aIayZnAUk7pbRdzpnEf7tVqm7B64u/vuEZiAxpoAk0Zbplwjbv6PicO0JU0C0LAh1wmA
         7mRNKSrsfblKKvdHFVCmg/rS1rHC4rNvv0/nEC92Id0nOVufjtGbmNnV69ta43iKKr4Y
         /5TQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=O4Bg6lHEr1Bcp5d6hAJjcBdq76xAwkKeYR92aKtHBrs=;
        b=kBqh6gV45opnm5C/xkIwbYAPna2QEUM3kbuI7B9UwN7zvpeaTNlJYo5y/rxyLW5Xyh
         sSFgwbYArY7L/fwAEQUhjun2aJlUhktwlk3hDWgMRzoFWiIPZIewENLNcpd6DZgbrAFq
         tlTHsGi6MMMBDt0Uez/DU4axfwbosgR91iaGCopF2kDlHhYkgi9ncaFPGO0eOXQurrYv
         PUEipUSvAZB+ALB9/1ZubW8gLka6gczSCdZsS0Z0jk5eFOaJ4kzisd31MkyNHXBYXMP9
         KgNbI9s5SGKxz6Ag91JojioO6gck4FN3R0zPqMj4pDCh83HmfbslGn0wxCnpUhFHA+/A
         KUOQ==
X-Gm-Message-State: AOAM533kAkwCML/ViQndLqaKo0owKBWA6g2PO4rPK7YpCD/PvHXoaMIo
        gim2XIpRzSifP0Bldfg7HS9kRXG4ruOMISl0sKaDHw==
X-Google-Smtp-Source: ABdhPJx3y9Qe65TDZI1Pw1aAaP4YrrLaBKafANPnboI6z3akSWt8D9TMbGpmHJu9LAJXlyJf1aVxNSBsNc5FFZJCaYc=
X-Received: by 2002:a05:6402:447:: with SMTP id p7mr35524862edw.89.1617686818934;
 Mon, 05 Apr 2021 22:26:58 -0700 (PDT)
MIME-Version: 1.0
References: <20210402054212.17834-1-Viswas.G@microchip.com.com> <161768453466.32039.5842026607462396914.b4-ty@oracle.com>
In-Reply-To: <161768453466.32039.5842026607462396914.b4-ty@oracle.com>
From:   Jinpu Wang <jinpu.wang@ionos.com>
Date:   Tue, 6 Apr 2021 07:26:48 +0200
Message-ID: <CAMGffEnDBRjMfdbnJpCTGse+LoHLHoNE_QadrwBEMif5c+_6dw@mail.gmail.com>
Subject: Re: [PATCH 1/1] pm80xx: Fix chip initialization failure
To:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        Viswas G <Viswas.G@microchip.com.com>
Cc:     Linux SCSI Mailinglist <linux-scsi@vger.kernel.org>,
        Viswas G <Viswas.G@microchip.com>,
        Vasanthalakshmi.Tharmarajan@microchip.com, Ash Izat <ash@ai0.uk>,
        Jinpu Wang <jinpu.wang@cloud.ionos.com>,
        stable <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, Apr 6, 2021 at 6:52 AM Martin K. Petersen
<martin.petersen@oracle.com> wrote:
>
> On Fri, 2 Apr 2021 11:12:12 +0530, Viswas G wrote:
>
> > Inbound and outbound queues are not properly configured and
> > that leads to MPI configuration failure.
> >
> > Fixes: 05c6c029a44d ("scsi: pm80xx: Increase number of supported queues")
> >
> > Cc: stable@vger.kernel.org # 5.10+
>
> Applied to 5.12/scsi-fixes, thanks!

Thanks for taking care of this.

Regards!
>
> [1/1] pm80xx: Fix chip initialization failure
>       https://git.kernel.org/mkp/scsi/c/65df7d1986a1
>
> --
> Martin K. Petersen      Oracle Linux Engineering
