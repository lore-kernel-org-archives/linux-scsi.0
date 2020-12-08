Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 94665C4361B
	for <linux-scsi@archiver.kernel.org>; Tue,  8 Dec 2020 20:16:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 649622388C
	for <linux-scsi@archiver.kernel.org>; Tue,  8 Dec 2020 20:16:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731160AbgLHUQE (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 8 Dec 2020 15:16:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36688 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731124AbgLHUOY (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 8 Dec 2020 15:14:24 -0500
Received: from mail-lf1-x141.google.com (mail-lf1-x141.google.com [IPv6:2a00:1450:4864:20::141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD080C061793
        for <linux-scsi@vger.kernel.org>; Tue,  8 Dec 2020 12:13:42 -0800 (PST)
Received: by mail-lf1-x141.google.com with SMTP id r24so25976352lfm.8
        for <linux-scsi@vger.kernel.org>; Tue, 08 Dec 2020 12:13:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=sgyQki4FzsYscH5k16Etbh421UMG+JihNWud51/vg7o=;
        b=Kf4+GRG3ICi22fvx5fccY4z9fvoThH7QoV401LvADvCQugMcp6btTNSih+yZOSoZ3j
         a2Q4gyueZSi5BP5D2Zdzf+u2ZyELugu0V4ZSQwUNMWysc21aPXKcL6d9WbJrfWoKkaDM
         5kD8tlsLhmWzjPSFqTPB6Xq+mP/fDQ7RtaM28=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=sgyQki4FzsYscH5k16Etbh421UMG+JihNWud51/vg7o=;
        b=c3NEZFMRL8x/hAvepg0W2EYINXThRp2kMYmbsQ0m/RRGxc87QgOClT6mAs1j9qPYoa
         QuJ/YN2eCflHasBEkmFlSucCzf6couFJjrqQGn/1U+Ao/GXdy8gjR5/yrex2pxmJcMX5
         goXTaBAZeb7DAzUqIFvWbK86vIbozWe3GwwiGu+IEy4obH1DRT1uZSM/HYA9JgaJXTXh
         O8ISGPKXecfhO+MOhdob72yl5FZlRFuA8+8HYQkIbhnz8c1PHXS+ogbhEkkEQ9dgjaou
         orFA8SUyb2YM+lvQCSrVDMIuTKH8tPiaj2bAnkVDJJIafXOWJrXL9kEnRQGN9ZO+Kf1f
         /sUQ==
X-Gm-Message-State: AOAM533bHeqEKUM3e8lMKBdwpZLhsCKuo06bxz+HtXL0Iv8jPQM+bSQU
        IUiSCz3nOXqkpaMQax8W8scdim372EXjlg==
X-Google-Smtp-Source: ABdhPJxUuZ1dX+aTjYcRgnGMGDzw2CWgBw6o5fJMZtxCYf4hgoPshs5EHrnNvU9heCzF/pRp/W3cyA==
X-Received: by 2002:a2e:97c8:: with SMTP id m8mr10903966ljj.338.1607456872469;
        Tue, 08 Dec 2020 11:47:52 -0800 (PST)
Received: from mail-lj1-f179.google.com (mail-lj1-f179.google.com. [209.85.208.179])
        by smtp.gmail.com with ESMTPSA id a26sm3540912ljn.137.2020.12.08.11.47.52
        for <linux-scsi@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 08 Dec 2020 11:47:52 -0800 (PST)
Received: by mail-lj1-f179.google.com with SMTP id f11so9395426ljm.8
        for <linux-scsi@vger.kernel.org>; Tue, 08 Dec 2020 11:47:52 -0800 (PST)
X-Received: by 2002:a2e:8995:: with SMTP id c21mr3342315lji.251.1607456869937;
 Tue, 08 Dec 2020 11:47:49 -0800 (PST)
MIME-Version: 1.0
References: <alpine.DEB.2.22.394.2012081813310.2680@hadrien>
 <CAHk-=wi=R7uAoaVK9ewDPdCYDn1i3i19uoOzXEW5Nn8UV-1_AA@mail.gmail.com>
 <yq1sg8gunxy.fsf@ca-mkp.ca.oracle.com> <CAHk-=whThuW=OckyeH0rkJ5vbbbpJzMdt3YiMEE7Y5JuU1EkUQ@mail.gmail.com>
 <alpine.DEB.2.22.394.2012082025310.16458@hadrien>
In-Reply-To: <alpine.DEB.2.22.394.2012082025310.16458@hadrien>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Tue, 8 Dec 2020 11:47:33 -0800
X-Gmail-Original-Message-ID: <CAHk-=wjVch4Y7wGKRROYCHN9vD0e5YK=KRWhcZMJ2zNQdc+_Jg@mail.gmail.com>
Message-ID: <CAHk-=wjVch4Y7wGKRROYCHN9vD0e5YK=KRWhcZMJ2zNQdc+_Jg@mail.gmail.com>
Subject: Re: problem booting 5.10
To:     Julia Lawall <julia.lawall@inria.fr>
Cc:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        nicolas.palix@univ-grenoble-alpes.fr,
        linux-scsi <linux-scsi@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, Dec 8, 2020 at 11:29 AM Julia Lawall <julia.lawall@inria.fr> wrote:
>
> A dmesg after successfully booting in 5.9 is attached.

Ok, from a quick look it's megaraid_sas.

The only thing I see there is that commit 103fbf8e4020 ("scsi:
megaraid_sas: Added support for shared host tagset for cpuhotplug").

Of course, it could be something entirely unrelated that just triggers
this, but I don't think I've seen any other reports, so at a first
guess I'd blame something specific to that hardware, rather than some
generic problem that just happens to hit Jula.

            Linus
