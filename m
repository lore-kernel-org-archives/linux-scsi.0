Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AAE99C433F5
	for <linux-scsi@archiver.kernel.org>; Sat,  6 Nov 2021 11:54:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7FD356120A
	for <linux-scsi@archiver.kernel.org>; Sat,  6 Nov 2021 11:54:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234087AbhKFL5G (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 6 Nov 2021 07:57:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55628 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229968AbhKFL5G (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 6 Nov 2021 07:57:06 -0400
Received: from mail-qk1-x733.google.com (mail-qk1-x733.google.com [IPv6:2607:f8b0:4864:20::733])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E9051C061570
        for <linux-scsi@vger.kernel.org>; Sat,  6 Nov 2021 04:54:24 -0700 (PDT)
Received: by mail-qk1-x733.google.com with SMTP id c20so1140559qko.10
        for <linux-scsi@vger.kernel.org>; Sat, 06 Nov 2021 04:54:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=lucidpixels.com; s=google;
        h=from:to:cc:references:in-reply-to:subject:date:message-id
         :mime-version:content-transfer-encoding:content-language
         :thread-index;
        bh=dqPN2n6BjpQRetBTCE2FROhnqvD7qwFmp4cQx0DCJAE=;
        b=e8BP8vCKZPi9SAnUi2ZdXWN29CSndyqNyIBge6g4qsrac+Uc6hED/QUyuDPs5h53k+
         yWPhev/Verz2YkE83/2AJaJrnLflor+7LYbtdbM2SnV22dKzB8pmdUlcwsvKaxM4M/sb
         +OlNWTfOJxisRw5ispf4Sn7h9WsqqdQhwzasE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:references:in-reply-to:subject:date
         :message-id:mime-version:content-transfer-encoding:content-language
         :thread-index;
        bh=dqPN2n6BjpQRetBTCE2FROhnqvD7qwFmp4cQx0DCJAE=;
        b=zHmHxwSk4Q6EMLsYHH+pPC3iApnnbAZhCMZl6H09cr2av0WOPQys3JeeV5gkV3jMqn
         3Z0tPDhKX/RuDpITOw4qLoOdEc/wfpHyFCfJi0YxAMd3eQ27wIH4x2RK1+FiHPg8u1d2
         eGw0Vv/Dc4rebFioUhQFTSrA1TbFzs3eVVzLh+kz6Xs40NY+fSiLnFnEtxJ+yhIlotRJ
         QUmvLvD+Rr8xBWU59PT4mWeJBf4aBi1q1FpEvdRgmPGwOYbMvjzp0DVSK560//stNzY7
         w9Pv2j1rvBrJpsJkl/P1ZJegATkbGjmPn+aVJ7It4q0j8P5kyU9mp6Aa59jKga9ILW8w
         MwSA==
X-Gm-Message-State: AOAM533wSA2fffoAVrntKOQm3fFEiZmnawg4xp8miD4D8rQmhcN4XtmS
        YwJ1d8ZzlRk8brOwlpNLJZj/Yn9HWMULRJ5H
X-Google-Smtp-Source: ABdhPJyGC3/GU/JXOGG46ZDEFvTm4JDoKDH7HXKCf0YyFVsvRmMltjDzixYF1sWDURkeHN5fR4VC/A==
X-Received: by 2002:a05:620a:460a:: with SMTP id br10mr5225023qkb.314.1636199663730;
        Sat, 06 Nov 2021 04:54:23 -0700 (PDT)
Received: from WARPC (pool-70-106-225-116.clppva.fios.verizon.net. [70.106.225.116])
        by smtp.gmail.com with ESMTPSA id h11sm7328425qkp.46.2021.11.06.04.54.22
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 06 Nov 2021 04:54:23 -0700 (PDT)
From:   "Justin Piszcz" <jpiszcz@lucidpixels.com>
To:     "'Bart Van Assche'" <bvanassche@acm.org>,
        "'Douglas Miller'" <dougmill@linux.vnet.ibm.com>
Cc:     "'LKML'" <linux-kernel@vger.kernel.org>,
        <linux-scsi@vger.kernel.org>
References: <006a01d7cead$b9262d70$2b728850$@lucidpixels.com> <a4a88807-8f52-ef9a-c58e-0ff454da5ade@acm.org> <CAO9zADxiobgwDE5dtvo98EL0djdgQyrGJA_w4Oxb+pZ9pvOEjQ@mail.gmail.com> <CAO9zADycForyq9cmh=epw9r-Wzz=xt32vL3mePuBAPehCgUTjw@mail.gmail.com> <50a16ee2-dfa4-d009-17c5-1984cf0a6161@linux.vnet.ibm.com> <CAO9zADwVnuKU-tfZxm4USjf76yJhTZqWfZw4yspv8sc93RuBbQ@mail.gmail.com> <e0c2935d-d961-11a0-1b4c-580b55dc6b59@acm.org>
In-Reply-To: <e0c2935d-d961-11a0-1b4c-580b55dc6b59@acm.org>
Subject: RE: kernel 5.15 does not boot with 3ware card (never had this issue <= 5.14) - scsi 0:0:0:0: WARNING: (0x06:0x002C) : Command (0x12) timed out, resetting card
Date:   Sat, 6 Nov 2021 07:54:19 -0400
Message-ID: <002401d7d305$082971b0$187c5510$@lucidpixels.com>
MIME-Version: 1.0
Content-Type: text/plain;
        charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Mailer: Microsoft Outlook 16.0
Content-Language: en-us
Thread-Index: AQFvog4DBvS/YijzZ80RtFVSnXGKrgJY98sAAayFrYQByo6A5QHYGZ9yAapycYICkRDNnKxnoB7g
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org



-----Original Message-----
From: Bart Van Assche <bvanassche@acm.org>=20
Sent: Wednesday, November 3, 2021 12:23 PM
To: Justin Piszcz <jpiszcz@lucidpixels.com>; Douglas Miller =
<dougmill@linux.vnet.ibm.com>
Cc: LKML <linux-kernel@vger.kernel.org>; linux-scsi@vger.kernel.org
Subject: Re: kernel 5.15 does not boot with 3ware card (never had this =
issue <=3D 5.14) - scsi 0:0:0:0: WARNING: (0x06:0x002C) : Command (0x12) =
timed out, resetting card

On 11/3/21 9:18 AM, Justin Piszcz wrote:
> Thanks!-- Has anyone else reading run into this issue and/or are there
> any suggestions how I can troubleshoot this further (as all -rc's have
> the same issue)?

How about bisecting this issue
(https://www.kernel.org/doc/html/latest/admin-guide/bug-bisect.html)?

[ .. ]

I was having some issues finding a list of changes with git bisect, so I =
started checking the kernel .config and boot parameters:

I found the option that was causing the system not to boot (tested with =
5.15.0 and latest linux-git as of 6 NOV 2021)
append=3D"3w-sas.use_msi=3D1"

3w-sas.use_msi defaults to 0 (so now it is using IR-IO-APIC instead of =
MSI but now the machine boots using 5.15)
https://lwn.net/Articles/358679/

Something between 5.14 and 5.15 changed regarding x86_64's handling of =
Message Signaled Interrupts.
... which causes the kernel to no longer boot when 3w-sas.use_msi=3D1 is =
specified starting with 5.15.

Regards,

Justin.




