Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F313CC433EF
	for <linux-scsi@archiver.kernel.org>; Mon, 15 Nov 2021 21:28:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D558761BE5
	for <linux-scsi@archiver.kernel.org>; Mon, 15 Nov 2021 21:28:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350296AbhKOVaz (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 15 Nov 2021 16:30:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57244 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353235AbhKOUza (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 15 Nov 2021 15:55:30 -0500
Received: from mail-lj1-x231.google.com (mail-lj1-x231.google.com [IPv6:2a00:1450:4864:20::231])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B27CC0613B9
        for <linux-scsi@vger.kernel.org>; Mon, 15 Nov 2021 12:40:37 -0800 (PST)
Received: by mail-lj1-x231.google.com with SMTP id k2so30675297lji.4
        for <linux-scsi@vger.kernel.org>; Mon, 15 Nov 2021 12:40:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=lucidpixels.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=uNjovAaYEwEX+9pEiPHL3nyMOKYDJCekov5XCnVxgSM=;
        b=K9LARW9f0PVDjm+kSpfLEsn7QhEtjlOxiiT/vf4RvIztYbfjRBWnViIhK8FBmQZpfF
         139J6qLOAOOwndotjONQjKTcg5TgqflwSq+q56EpdajW1paaUd6B00yH8mfAN4exUPDh
         UQ8d5XxuZo5YrXejK6lvLKfS3jerO5bXuxU1g=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=uNjovAaYEwEX+9pEiPHL3nyMOKYDJCekov5XCnVxgSM=;
        b=Rg5e8fHzE5MOZvnIT57HOo99blV7kd1T5+lsv0HrW6aJeAB7t1I19YpdHGb+d3XOY8
         dOwYoWEtw2E8YFEvvPiJWOaTh3JRnHkEOkr+cbCiMyY3wez6QNjKvxRiagq5eF2uap5B
         UW1by29TrsijT5INafXsDAj6xephL1jZWfiGWSVCshsyrntAxo2d4SfUtRQjUpjapoeL
         vFWlZBylxVfsZ5VB5F9AgNUcrsTEPJq9b0MLX2mAeK24lyc4Ml4JqqVB9Bb2ewygvevA
         zPHSTtQkdW4IUpiZtO2Het0i6oI+8MXdQvIDaDPXv0I1DmVVLvhc3C2Ue0aI2Rfz9tSl
         aoVw==
X-Gm-Message-State: AOAM532aVTBgqGW5G0gYkJGsgSD2NuqckB+t+qyr7zWHwHVlI/ecXvYV
        +AboLpEVJePWwcaweue1lsGX9bwOAik8cfkWX/jW0Q==
X-Google-Smtp-Source: ABdhPJy46/oA5NQEOvwBsbpyFAKV6VUxSr2NwSGUgy9eBRPnDjHeAl/tOF30YpAfDqsQbO8zFhO+aDFgD1tgvDWeExY=
X-Received: by 2002:a2e:530b:: with SMTP id h11mr1404687ljb.95.1637008835332;
 Mon, 15 Nov 2021 12:40:35 -0800 (PST)
MIME-Version: 1.0
References: <006a01d7cead$b9262d70$2b728850$@lucidpixels.com>
 <a4a88807-8f52-ef9a-c58e-0ff454da5ade@acm.org> <CAO9zADxiobgwDE5dtvo98EL0djdgQyrGJA_w4Oxb+pZ9pvOEjQ@mail.gmail.com>
 <CAO9zADycForyq9cmh=epw9r-Wzz=xt32vL3mePuBAPehCgUTjw@mail.gmail.com>
 <50a16ee2-dfa4-d009-17c5-1984cf0a6161@linux.vnet.ibm.com> <CAO9zADwVnuKU-tfZxm4USjf76yJhTZqWfZw4yspv8sc93RuBbQ@mail.gmail.com>
 <e0c2935d-d961-11a0-1b4c-580b55dc6b59@acm.org> <002401d7d305$082971b0$187c5510$@lucidpixels.com>
 <CAO9zADzWcpwZkfJ5VZGZZJT39KQEUr9yGqqCnP18mk7ZAZxbBw@mail.gmail.com> <3bca3296-d998-98a5-bf8f-53b0720869d3@linux.vnet.ibm.com>
In-Reply-To: <3bca3296-d998-98a5-bf8f-53b0720869d3@linux.vnet.ibm.com>
From:   Justin Piszcz <jpiszcz@lucidpixels.com>
Date:   Mon, 15 Nov 2021 15:40:22 -0500
Message-ID: <CAO9zADzTO+ArYgbUkvAPVD0Ay2+iwmaMpQsysnsBL509oCnsYA@mail.gmail.com>
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

On Mon, Nov 8, 2021 at 9:16 AM Douglas Miller
<dougmill@linux.vnet.ibm.com> wrote:
>
> The commit I referenced earlier does point back to the commit that
> caused the problem (that I saw). There was a series of commits related
> to IRQ domains, this one seems to have actually caused the problem I saw:
>
> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=a5f3d2c17b07

Incase anyone runs into this issue, it appears to be fixed in
5.16.0-rc1, no more freezing at boot:

$ uname -a
Linux atom 5.16.0-rc1 #2 SMP Mon Nov 15 15:37:25 EST 2021 x86_64 GNU/Linux

Justin.
