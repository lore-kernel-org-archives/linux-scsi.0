Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BBC7BC433F5
	for <linux-scsi@archiver.kernel.org>; Wed,  3 Nov 2021 16:18:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8F83360EB8
	for <linux-scsi@archiver.kernel.org>; Wed,  3 Nov 2021 16:18:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232764AbhKCQVd (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 3 Nov 2021 12:21:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55556 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232756AbhKCQVa (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 3 Nov 2021 12:21:30 -0400
Received: from mail-lj1-x22e.google.com (mail-lj1-x22e.google.com [IPv6:2a00:1450:4864:20::22e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52199C061714
        for <linux-scsi@vger.kernel.org>; Wed,  3 Nov 2021 09:18:53 -0700 (PDT)
Received: by mail-lj1-x22e.google.com with SMTP id k24so4757484ljg.3
        for <linux-scsi@vger.kernel.org>; Wed, 03 Nov 2021 09:18:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=lucidpixels.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=lKZRM9TUFkVAeIb2C2Wso1kpJ0hOy7Q/4bXfr6arM1E=;
        b=dAvBHeKf4Qe6/Zt+fMgW+K0cbNVBgn5eP7UboBVX/IgaWCdhTUy7zaNXykU/kFaE6p
         73FFkm2wlVBYl8CIIOpl34J2Agfp5zsexl3n5+TB2EHv7/k1yBlMdCnZ8GLaost93oZl
         CgSkB8hLB4SEeeMLvVQUMh15LaEYc2p7Ljabo=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=lKZRM9TUFkVAeIb2C2Wso1kpJ0hOy7Q/4bXfr6arM1E=;
        b=Li9Yr7TYE43PCC7uY4TMCO1dgvX7Pnf4Te/3dLR/6ZvJl4lTX+H1ixETAcz0ZoEgGU
         t1Knx7GnsuKfLxnQUj5UF/1l7gXzTS03o7Xo02KeSpNrJ3VCKx2v8l2bbDpDKlBM/qNF
         kQSXvdLYuM3UHjP5DY2fO1wsFGDg76B9+ocVjiRk/qKZNuqf/xH2VzGGghlhtDStY5Q5
         2V3hB3CYNkCOVbM00IHUqpVIg+UJZ6kflcWqh7f6dVGqPLw016brpPSdwxuTbeNULRKm
         G3ppnZu1J7wvVzrBXvWSlgusAhaVwq6lUfWin6iUboTACz1H30kTedlvJ4xBBe7gpSmD
         YSEA==
X-Gm-Message-State: AOAM533fEQjaG8HAcV9y8OvR3KBNgg4IrVTMaYDb0LOfz5yTC1MkEYxH
        CZrVBSI3YUF0zpe23quARGH+I9Oy0QLVfMUFT3DC6g==
X-Google-Smtp-Source: ABdhPJwGtNFUjhgfwyP/7wcssx6KZPZbLQ+EQGmtuh5R31Mn16RgF5E3uRLtGagWxPk5lXX1Q3a48F6KWC1hH5yqg0I=
X-Received: by 2002:a2e:8605:: with SMTP id a5mr49690291lji.107.1635956331518;
 Wed, 03 Nov 2021 09:18:51 -0700 (PDT)
MIME-Version: 1.0
References: <006a01d7cead$b9262d70$2b728850$@lucidpixels.com>
 <a4a88807-8f52-ef9a-c58e-0ff454da5ade@acm.org> <CAO9zADxiobgwDE5dtvo98EL0djdgQyrGJA_w4Oxb+pZ9pvOEjQ@mail.gmail.com>
 <CAO9zADycForyq9cmh=epw9r-Wzz=xt32vL3mePuBAPehCgUTjw@mail.gmail.com> <50a16ee2-dfa4-d009-17c5-1984cf0a6161@linux.vnet.ibm.com>
In-Reply-To: <50a16ee2-dfa4-d009-17c5-1984cf0a6161@linux.vnet.ibm.com>
From:   Justin Piszcz <jpiszcz@lucidpixels.com>
Date:   Wed, 3 Nov 2021 12:18:40 -0400
Message-ID: <CAO9zADwVnuKU-tfZxm4USjf76yJhTZqWfZw4yspv8sc93RuBbQ@mail.gmail.com>
Subject: Re: kernel 5.15 does not boot with 3ware card (never had this issue
 <= 5.14) - scsi 0:0:0:0: WARNING: (0x06:0x002C) : Command (0x12) timed out,
 resetting card
To:     Douglas Miller <dougmill@linux.vnet.ibm.com>
Cc:     Bart Van Assche <bvanassche@acm.org>,
        LKML <linux-kernel@vger.kernel.org>, linux-scsi@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, Nov 1, 2021 at 4:03 PM Douglas Miller
<dougmill@linux.vnet.ibm.com> wrote:
>
> I have seen a problem, with a different adapter and arch but similar
> symptoms, where 5.14 worked and 5.15 did not. That was tracked down to a
> difference in IRQ domain handling between the two kernels, resulting in
> an IRQ essentially not working anymore. The fix was arch-specific and
> not x86_64, but might be of interest:
>
> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=5a4b0320783a
>

Thanks!-- Has anyone else reading run into this issue and/or are there
any suggestions how I can troubleshoot this further (as all -rc's have
the same issue)?

[ .. ]
