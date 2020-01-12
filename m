Return-Path: <SRS0=w4/B=3B=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D77BBC33CA2
	for <linux-scsi@archiver.kernel.org>; Sun, 12 Jan 2020 12:03:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AEAC521569
	for <linux-scsi@archiver.kernel.org>; Sun, 12 Jan 2020 12:03:25 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="lfj+bQ0p"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732763AbgALMDX (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 12 Jan 2020 07:03:23 -0500
Received: from mail-lf1-f65.google.com ([209.85.167.65]:32990 "EHLO
        mail-lf1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732724AbgALMDX (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 12 Jan 2020 07:03:23 -0500
Received: by mail-lf1-f65.google.com with SMTP id n25so4848185lfl.0;
        Sun, 12 Jan 2020 04:03:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=sEmJTxEE0PvPQVReFiQag94yiboJ+l0iwk94EmqCjTY=;
        b=lfj+bQ0pJ8FU4DOEcT4Cdwq3lX9IVDbLCEbU8xbToizF6Zvcv63z4q4n2FBHgMXLVw
         q9l5JnyW7lH3Or+0PEhfXmnmmxLhtND66h3Cu13hnAS1BVgLTS1GNveylGnKRUQSiy5Y
         l4gpRLBk7pYcaBX66u4FnYOmPjDDQNJ9ANlTR4YBEe5sqB8Ac3sQQNs5lj3yXNllacaO
         RHwiejTxdCJEuCbkpoQJItkRfRobWXexZ/cKY9CXtOqhIZLYXa8znCVCGxJvRS7cUIIO
         a3EMRzmAdLOhx37Lt1+ng3wxjhC01lwpr8+jToD39fP5fptt7wRL5ytvxaNGG9xCZJ3T
         oOag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=sEmJTxEE0PvPQVReFiQag94yiboJ+l0iwk94EmqCjTY=;
        b=mmpESsD/TVMhLWGIpPgcrSpmpi0Th2kq2PtODZDjgda4bgoMX5bpLKraXwttXmVA+4
         fA2XSe5KyW2I4kwcP2pLJ/dhdKa4BNjTSJJqBCAYVb3xBRYhf88zA3IsvjLah+Ns3Obn
         qBNmaZcRNDxyRDEoNY9dhIM32MWF9F8UiF8g9eWZ35wYFKo2UkoUsoM9qgedPp59ahcH
         1uYU/BgS1g3kHpbPGI56+S7F/sneFx5X0GxpslM+a9PI0R+cRt4+OI9zrPwIFnKCMERu
         lhd1fYIUk8mS73Yjl4BOsc7l5R76QqUfkgC/9BGbMFenR0DUz/et+49ZFbvInvS+1A+O
         KkxA==
X-Gm-Message-State: APjAAAWtvoQMagQx1vzI8HniG+0BNOjdJbhbu/QqhAhvzOgDNGY5ontM
        r6556Dfs7G/PEOnpadQhhrqJYIQ+SKRi30H43g==
X-Google-Smtp-Source: APXvYqzHuFhY3knllWMxVzoAhBYtL89Au5uCCd0wnHJQO2uuZ/d4ZXz1pZ0tIkmeoLdVL79DdbGTe4xIpMKT6UzH/jY=
X-Received: by 2002:a19:4b87:: with SMTP id y129mr7327020lfa.32.1578830600795;
 Sun, 12 Jan 2020 04:03:20 -0800 (PST)
MIME-Version: 1.0
References: <20191215174509.1847-1-linux@roeck-us.net> <20191215174509.1847-2-linux@roeck-us.net>
 <yq1r211dvck.fsf@oracle.com> <b22a519c-8f26-e731-345f-9deca1b2150e@roeck-us.net>
 <yq1sgkq21ll.fsf@oracle.com> <20200108153341.GB28530@roeck-us.net>
 <38af9fda-9edf-1b54-bd8d-92f712ae4cda@roeck-us.net> <CAEJqkgg_piiAWy4r3VD=KyQ7pi69bZNym2Ws=Tr8SY5wf+Sprg@mail.gmail.com>
 <CACRpkdYU7ZDcKp+BbXRCnEFDw1xwDkU_vXsfo-AZNUWGEVknXQ@mail.gmail.com>
In-Reply-To: <CACRpkdYU7ZDcKp+BbXRCnEFDw1xwDkU_vXsfo-AZNUWGEVknXQ@mail.gmail.com>
From:   Gabriel C <nix.or.die@gmail.com>
Date:   Sun, 12 Jan 2020 13:02:54 +0100
Message-ID: <CAEJqkggo3Mou1SykjisyYn+3SGGgNfnKagr=7ZPyw=Y=1MZ55w@mail.gmail.com>
Subject: Re: [PATCH v2] hwmon: Driver for temperature sensors on SATA drives
To:     Linus Walleij <linus.walleij@linaro.org>
Cc:     Guenter Roeck <linux@roeck-us.net>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-hwmon@vger.kernel.org, Jean Delvare <jdelvare@suse.com>,
        Bart Van Assche <bvanassche@acm.org>,
        Linux Doc Mailing List <linux-doc@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        "open list:LIBATA SUBSYSTEM (Serial and Parallel ATA drivers)" 
        <linux-ide@vger.kernel.org>, Chris Healy <cphealy@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Am So., 12. Jan. 2020 um 12:22 Uhr schrieb Linus Walleij
<linus.walleij@linaro.org>:
>
> On Sun, Jan 12, 2020 at 12:18 PM Gabriel C <nix.or.die@gmail.com> wrote:
>
> > What I've noticed however is the nvme temperature low/high values on
> > the Sensors X are strange here.
> (...)
> > Sensor 1:     +27.9=C2=B0C  (low  =3D -273.1=C2=B0C, high =3D +65261.8=
=C2=B0C)
> > Sensor 2:     +29.9=C2=B0C  (low  =3D -273.1=C2=B0C, high =3D +65261.8=
=C2=B0C)
> (...)
> > Sensor 1:     +23.9=C2=B0C  (low  =3D -273.1=C2=B0C, high =3D +65261.8=
=C2=B0C)
> > Sensor 2:     +25.9=C2=B0C  (low  =3D -273.1=C2=B0C, high =3D +65261.8=
=C2=B0C)
>
> That doesn't look strange to me. It seems like reasonable defaults
> from the firmware if either it doesn't really log the min/max temperature=
s
> or hasn't been through a cycle of updating these yet. Just set both
> to absolute min/max temperatures possible.

Ok I'll check that.

Do you mean by setting the temperatures to use a lmsensors config?
Or is there a way to set these with a nvme command?
