Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 73F86C4361B
	for <linux-scsi@archiver.kernel.org>; Tue,  8 Dec 2020 20:33:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4840E23AC8
	for <linux-scsi@archiver.kernel.org>; Tue,  8 Dec 2020 20:33:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730240AbgLHUd1 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 8 Dec 2020 15:33:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39840 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726338AbgLHUdZ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 8 Dec 2020 15:33:25 -0500
Received: from mail-lj1-x242.google.com (mail-lj1-x242.google.com [IPv6:2a00:1450:4864:20::242])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F385C0613D6
        for <linux-scsi@vger.kernel.org>; Tue,  8 Dec 2020 12:32:39 -0800 (PST)
Received: by mail-lj1-x242.google.com with SMTP id f24so21823807ljk.13
        for <linux-scsi@vger.kernel.org>; Tue, 08 Dec 2020 12:32:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=XU1lJ/FiyE51Ek5hTlJjhkSrQF4pKw8F/EUPUJF0It8=;
        b=h/V9VvosYnXbDksZuJ62HRfIJnAPcg2Pgv5nAm5eT1C9zk0cin1MScSPABv1L/auoa
         VjONxS2l36zyTZJDXS7BPEyqz4Q2PrH+pWkkSZStGEmgNmWPNYCy/MnhLMOvnf7XGt3Q
         yHJJNfcM0C98Iripdiw84+Z8CbYGMWxZaeKFM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=XU1lJ/FiyE51Ek5hTlJjhkSrQF4pKw8F/EUPUJF0It8=;
        b=WeamuSNe0sBzepjqLmqjGT8tlWCMESLwU04TKeClL0vVDgMGetOfS3Z+sWf1lqv+Fy
         E0EWK9WeLoHVU/vnW06YAzlNvJH8Z8eE5P6HinbTIyvGBayJXG2sQVqDjc3hxWeVcvMO
         6iR5nY9gS7g36RvqjItceis8PCjUlAJmbksKLI8T665i5wKZNpfOH21a8ZG68ioxTnWU
         o3qJT19g5RvgNYBWcDd/CsbzS+a3iRPN+Tr7+uvQTZdNiM+L8SLRoTwVSEBvOG9QQhUz
         EAHvPtanAyV4H6zLYItgcDuVVsWnYAoAKLx9cwBPbW2GkRx9VHlldG9tKLxcRRUwv1vF
         q+5w==
X-Gm-Message-State: AOAM532WT396R7zrGBx/b0NAbotc62w5kUzh04y3wfdka3xuQSB1v1YV
        20MpOI6H113InZmyyG24hfURrGduF45BEg==
X-Google-Smtp-Source: ABdhPJykrVPz2B5OJVbfXdfC8PS7HReNS2aQTDAmC3oe7TtdCJN3d5kCtGSZwS3c/Er6ubJi4+TASw==
X-Received: by 2002:a2e:8118:: with SMTP id d24mr5339096ljg.105.1607455180975;
        Tue, 08 Dec 2020 11:19:40 -0800 (PST)
Received: from mail-lj1-f171.google.com (mail-lj1-f171.google.com. [209.85.208.171])
        by smtp.gmail.com with ESMTPSA id b4sm27776lfa.261.2020.12.08.11.19.39
        for <linux-scsi@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 08 Dec 2020 11:19:39 -0800 (PST)
Received: by mail-lj1-f171.google.com with SMTP id o24so21430672ljj.6
        for <linux-scsi@vger.kernel.org>; Tue, 08 Dec 2020 11:19:39 -0800 (PST)
X-Received: by 2002:a2e:90cb:: with SMTP id o11mr11600912ljg.465.1607455178788;
 Tue, 08 Dec 2020 11:19:38 -0800 (PST)
MIME-Version: 1.0
References: <alpine.DEB.2.22.394.2012081813310.2680@hadrien>
 <CAHk-=wi=R7uAoaVK9ewDPdCYDn1i3i19uoOzXEW5Nn8UV-1_AA@mail.gmail.com> <yq1sg8gunxy.fsf@ca-mkp.ca.oracle.com>
In-Reply-To: <yq1sg8gunxy.fsf@ca-mkp.ca.oracle.com>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Tue, 8 Dec 2020 11:19:22 -0800
X-Gmail-Original-Message-ID: <CAHk-=whThuW=OckyeH0rkJ5vbbbpJzMdt3YiMEE7Y5JuU1EkUQ@mail.gmail.com>
Message-ID: <CAHk-=whThuW=OckyeH0rkJ5vbbbpJzMdt3YiMEE7Y5JuU1EkUQ@mail.gmail.com>
Subject: Re: problem booting 5.10
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Julia Lawall <julia.lawall@inria.fr>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        nicolas.palix@univ-grenoble-alpes.fr,
        linux-scsi <linux-scsi@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, Dec 8, 2020 at 10:59 AM Martin K. Petersen
<martin.petersen@oracle.com> wrote:
>
> > So I'm adding SCSI people to the cc, just in case they go "Hmm..".
>
> Only change in this department was:
>
> 831e3405c2a3 scsi: core: Don't start concurrent async scan on same host

Yeah, I found that one too, and dismissed it for the same reason you
did - it wasn't in rc1. Plus it looked very simple.

That said, maybe Julia might have misspoken, and rc1 was ok, so I
guess it's possible. The scan_mutex does show up in that "locks held"
list, although I can't see why it would matter. But it does
potentially change timing (so it could expose some existing race), if
nothing else.

But let's make sure Jens is aware of this too, in case it's some ATA
issue. Not that any of those handful of 5.10 changes look remotely
likely _either_.

Jens, see

   https://lore.kernel.org/lkml/alpine.DEB.2.22.394.2012081813310.2680@hadrien/

if you don't already have the lkml thread locally.. There's not enough
of the dmesg to even really guess what Julia's actual hardware is,
apart from it being a Seagate SATA disk. Julia? What controllers and
disks do you have show up when things work?

             Linus
