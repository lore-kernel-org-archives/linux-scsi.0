Return-Path: <SRS0=w4/B=3B=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 23759C32771
	for <linux-scsi@archiver.kernel.org>; Sun, 12 Jan 2020 13:45:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E5B4C2084D
	for <linux-scsi@archiver.kernel.org>; Sun, 12 Jan 2020 13:45:57 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="r07fONfQ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732927AbgALNpy (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 12 Jan 2020 08:45:54 -0500
Received: from mail-lf1-f68.google.com ([209.85.167.68]:36381 "EHLO
        mail-lf1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732915AbgALNpy (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 12 Jan 2020 08:45:54 -0500
Received: by mail-lf1-f68.google.com with SMTP id n12so4925761lfe.3;
        Sun, 12 Jan 2020 05:45:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=tGmFqY35zV+IscWAY4Mv8Yx1TIq5YT4ZN36b2g1WYdY=;
        b=r07fONfQAwy5RzyqTEQf4EfPz9f1HLu1lOEn7F5/GEnwlRMgE1nLWAUW0wXLkBHRPn
         Kj+zcMoHOD9r9rYKJ4p2onEDZAUSM+tXEeNSRMci3Aq9aEM3VveMdKPNcAmQMO9eyrNw
         bG2W/C86x19CelVHk+GAE6R+TkSoyfm0paVPsC0iT8GXPV+cfj8zSt36E9WPQzGRzcSr
         B/rKgUkOvKUyOTzG9IGYAkYoh6FvtPWPlHfkWiYpMZYbwa21536RTrZvkJ2cFydBdkA9
         dHGkIzkJBqnKU1eHx07hWzFQQQllewaxYrigGsxGJbGFhmKdzW0awpUyGjkSZS2QYsVE
         x7SQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=tGmFqY35zV+IscWAY4Mv8Yx1TIq5YT4ZN36b2g1WYdY=;
        b=VgJk97UBk8Jvp44JIxBEr07IqQffSXt2xSC69LItUNmf2JAfSWb+t8l6YA352y7JIh
         w9ZE3kNwgkUMfr6wfXe5vSepSBT1ZuwvxHr+qYvc9Rh/qsiCAljmfOjQMucNpGqKi5xS
         UJT1dMIa6mWWFlnwc1Xn9k99+KW8NTqIUX/jsVmGC4gru7uH4QTMe2K/EIIfrbtA/4zk
         AaP9ZfghSllSr+pT0n2MrKGqaA6Us5l6Rq8qf2PoNEO2xq6wZVnZvxxfO4SGrw+CqWmV
         RNhIW1ryQcqKzQgSsAoraXQPCscP0V7DWZBNyabNzrXTDPxQHOUA5nQnUXuXzz69dxGu
         8WwA==
X-Gm-Message-State: APjAAAU/AYyeLEUrVX7L9cfO0pQ7QF2ZRvb4SnCXG5HmMkV3qe9l74Wm
        t4/6/cxxzpn3xpttjq94yLQt1qWNVHd7dFYHAQ==
X-Google-Smtp-Source: APXvYqwGrYfWauC9mf6cSdgn/uQX40uwBo2drelGZOOiB9mHxaLBBLKg3Amx0FfHj92ttYiJ3YMwemwz6gokLvUvGC8=
X-Received: by 2002:a19:f811:: with SMTP id a17mr7261764lff.182.1578836752028;
 Sun, 12 Jan 2020 05:45:52 -0800 (PST)
MIME-Version: 1.0
References: <20191215174509.1847-1-linux@roeck-us.net> <20191215174509.1847-2-linux@roeck-us.net>
 <yq1r211dvck.fsf@oracle.com> <b22a519c-8f26-e731-345f-9deca1b2150e@roeck-us.net>
 <yq1sgkq21ll.fsf@oracle.com> <20200108153341.GB28530@roeck-us.net>
 <38af9fda-9edf-1b54-bd8d-92f712ae4cda@roeck-us.net> <CAEJqkgg_piiAWy4r3VD=KyQ7pi69bZNym2Ws=Tr8SY5wf+Sprg@mail.gmail.com>
 <CACRpkdYU7ZDcKp+BbXRCnEFDw1xwDkU_vXsfo-AZNUWGEVknXQ@mail.gmail.com>
 <CAEJqkggo3Mou1SykjisyYn+3SGGgNfnKagr=7ZPyw=Y=1MZ55w@mail.gmail.com>
 <CACRpkdayHFmdz4nAMaXR07Hcy=dLLGnnU8PkFhwQKuDTLnvOSw@mail.gmail.com> <e3caa946-b8f2-75c7-4bcb-69ad198de472@roeck-us.net>
In-Reply-To: <e3caa946-b8f2-75c7-4bcb-69ad198de472@roeck-us.net>
From:   Gabriel C <nix.or.die@gmail.com>
Date:   Sun, 12 Jan 2020 14:45:25 +0100
Message-ID: <CAEJqkggBvBus-G=TevSf0OUWLx_63qmZEThi-tNyPmAD2JXW-g@mail.gmail.com>
Subject: Re: [PATCH v2] hwmon: Driver for temperature sensors on SATA drives
To:     Guenter Roeck <linux@roeck-us.net>
Cc:     Linus Walleij <linus.walleij@linaro.org>,
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

Am So., 12. Jan. 2020 um 14:07 Uhr schrieb Guenter Roeck <linux@roeck-us.ne=
t>:
>
> On 1/12/20 4:07 AM, Linus Walleij wrote:
> > On Sun, Jan 12, 2020 at 1:03 PM Gabriel C <nix.or.die@gmail.com> wrote:
> >> Am So., 12. Jan. 2020 um 12:22 Uhr schrieb Linus Walleij
> >> <linus.walleij@linaro.org>:
> >>>
> >>> On Sun, Jan 12, 2020 at 12:18 PM Gabriel C <nix.or.die@gmail.com> wro=
te:
> >>>
> >>>> What I've noticed however is the nvme temperature low/high values on
> >>>> the Sensors X are strange here.
> >>> (...)
> >>>> Sensor 1:     +27.9=C2=B0C  (low  =3D -273.1=C2=B0C, high =3D +65261=
.8=C2=B0C)
> >>>> Sensor 2:     +29.9=C2=B0C  (low  =3D -273.1=C2=B0C, high =3D +65261=
.8=C2=B0C)
> >>> (...)
> >>>> Sensor 1:     +23.9=C2=B0C  (low  =3D -273.1=C2=B0C, high =3D +65261=
.8=C2=B0C)
> >>>> Sensor 2:     +25.9=C2=B0C  (low  =3D -273.1=C2=B0C, high =3D +65261=
.8=C2=B0C)
> >>>
> >>> That doesn't look strange to me. It seems like reasonable defaults
> >>> from the firmware if either it doesn't really log the min/max tempera=
tures
> >>> or hasn't been through a cycle of updating these yet. Just set both
> >>> to absolute min/max temperatures possible.
> >>
> >> Ok I'll check that.
> >>
> >> Do you mean by setting the temperatures to use a lmsensors config?
> >> Or is there a way to set these with a nvme command?
> >
> > Not that I know of.
> >
> > The min/max are the minumum and maximum temperatures the
> > device has experienced during this power-on cycle.
> >
>
> No, that would be lowest/highest. The above are (or should be) per-sensor
> setpoints. The default for those is typically the absolute minimum /
> maximum of the supported range.
>
> Some SATA drives report the lowest/highest temperatures experienced
> since power cycle, like here.
>
> drivetemp-scsi-5-0
> Adapter: SCSI adapter
> temp1:        +23.0=C2=B0C  (low  =3D  +0.0=C2=B0C, high =3D +60.0=C2=B0C=
)
>                         (crit low =3D -41.0=C2=B0C, crit =3D +85.0=C2=B0C=
)
>                         (lowest =3D +20.0=C2=B0C, highest =3D +31.0=C2=B0=
C)
>

The SATA temperatures are fine and reported like this here too, just
the nvme ones are strange.

drivetemp-scsi-4-0
Adapter: SCSI adapter
temp1:        +28.0=C2=B0C  (low  =3D  +1.0=C2=B0C, high =3D +61.0=C2=B0C)
                      (crit low =3D  +2.0=C2=B0C, crit =3D +60.0=C2=B0C)
                      (lowest =3D +16.0=C2=B0C, highest =3D +31.0=C2=B0C)

drivetemp-scsi-12-0
Adapter: SCSI adapter
temp1:        +29.0=C2=B0C  (low  =3D  +1.0=C2=B0C, high =3D +61.0=C2=B0C)
                      (crit low =3D  +2.0=C2=B0C, crit =3D +60.0=C2=B0C)
                      (lowest =3D +18.0=C2=B0C, highest =3D +32.0=C2=B0C)

and so on.

Btw, where I can find the code does these calculations?

Best regards,

Gabriel C.
