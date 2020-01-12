Return-Path: <SRS0=w4/B=3B=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1C6DFC33CA7
	for <linux-scsi@archiver.kernel.org>; Sun, 12 Jan 2020 18:37:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EF44521744
	for <linux-scsi@archiver.kernel.org>; Sun, 12 Jan 2020 18:37:44 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Wmcp0eZt"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733208AbgALShm (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 12 Jan 2020 13:37:42 -0500
Received: from mail-lj1-f195.google.com ([209.85.208.195]:39947 "EHLO
        mail-lj1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732957AbgALShm (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 12 Jan 2020 13:37:42 -0500
Received: by mail-lj1-f195.google.com with SMTP id u1so7556227ljk.7;
        Sun, 12 Jan 2020 10:37:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=aYUTdEdA88iAaU2WKQRc+plb3LzpboGY1owsm5PSTjo=;
        b=Wmcp0eZtmOQpCID9WAKTL0LnbHZmQHXZc0oDKndV5oamwkMoWRZcvd459hgWSOs8E5
         rOGHEhF0hOIWWrl5ek2j9hglZQk642Yb3pJA5yGScmhG+tM01CBdUFXi/UPfDICfwM7i
         AyiLjkZs9bfoZ9+VBzdAJdVmHTuZ8cf+FKpW5/v/7cPKHCx+fFK+4oQqGSjUHBRFJGId
         6lSfyNqFx5n+urYdbaQt8GdugZ3/WZHvBxguuZzvWDH1Rphzc4qPDB/B5zik5Y/Ephs8
         eGipkRIjtrERimoNXIyrSZ9hMx64WCc+gS26+pHI+uPnUZK9EPepi0a1IBsuArp/7AJW
         VoLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=aYUTdEdA88iAaU2WKQRc+plb3LzpboGY1owsm5PSTjo=;
        b=aUKrhCwhajYBeQGJ2fZ6SAC5ESmQw4EA6UESVqiT6hv1q+vfL+OF2Qjfp51cypEkJg
         J0fSlHTcyHXcu0xeGYb0HtPptD5t+ymf4HOKC5YkYs8WIQ+/xkOSCm/oX3+Ba9nE3Vyl
         MkFikTeW6QfdpnDKlTvp3V3UE2XEEFW2kaZKMmAQ+pMvCVi/hGDPa3zULW5xBH8r9L0f
         ZU+iNKvMGJepCE88ww8Av5a4khKOz93aEQaPq9DNWMG7+Hq7PlNmi9hSapVl097uwt4i
         k9N3LyBuVnSuHwcE6OmHxsjg2LsTUrQS11uCzA9FlOSbowX3y5wRo720Fnk90PriBFE2
         2Npw==
X-Gm-Message-State: APjAAAUVbau2I6APeEO/kN2o0JAK7oBqt1v1tIzZ9ypYeaZVXQrCTCQw
        NFR+/ADVl0rTW9budtCS7JEsec0SmDG3dleI7w==
X-Google-Smtp-Source: APXvYqxCOAtf4JE/W1ENE4Iw8vF7fo5YIfCRuZ/lSOpqFtfxd+NgqpcgG4jUY05ud3+VeYUHP2x78cY8DcrFKFg7i9Q=
X-Received: by 2002:a2e:97d9:: with SMTP id m25mr8449506ljj.146.1578854258587;
 Sun, 12 Jan 2020 10:37:38 -0800 (PST)
MIME-Version: 1.0
References: <20191215174509.1847-1-linux@roeck-us.net> <20191215174509.1847-2-linux@roeck-us.net>
 <yq1r211dvck.fsf@oracle.com> <b22a519c-8f26-e731-345f-9deca1b2150e@roeck-us.net>
 <yq1sgkq21ll.fsf@oracle.com> <20200108153341.GB28530@roeck-us.net>
 <38af9fda-9edf-1b54-bd8d-92f712ae4cda@roeck-us.net> <CAEJqkgg_piiAWy4r3VD=KyQ7pi69bZNym2Ws=Tr8SY5wf+Sprg@mail.gmail.com>
 <CACRpkdYU7ZDcKp+BbXRCnEFDw1xwDkU_vXsfo-AZNUWGEVknXQ@mail.gmail.com>
 <CAEJqkggo3Mou1SykjisyYn+3SGGgNfnKagr=7ZPyw=Y=1MZ55w@mail.gmail.com>
 <CACRpkdayHFmdz4nAMaXR07Hcy=dLLGnnU8PkFhwQKuDTLnvOSw@mail.gmail.com>
 <e3caa946-b8f2-75c7-4bcb-69ad198de472@roeck-us.net> <CAEJqkggBvBus-G=TevSf0OUWLx_63qmZEThi-tNyPmAD2JXW-g@mail.gmail.com>
 <25c57e9d-94db-3a8b-5f68-f8a49e500b45@roeck-us.net>
In-Reply-To: <25c57e9d-94db-3a8b-5f68-f8a49e500b45@roeck-us.net>
From:   Gabriel C <nix.or.die@gmail.com>
Date:   Sun, 12 Jan 2020 19:37:12 +0100
Message-ID: <CAEJqkggnQzPw1uyMUZ5F-nqSwKAu5Ur7C_VujhZxZrvv-iUt_g@mail.gmail.com>
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

Am So., 12. Jan. 2020 um 16:26 Uhr schrieb Guenter Roeck <linux@roeck-us.ne=
t>:
>
> On 1/12/20 5:45 AM, Gabriel C wrote:
> > Am So., 12. Jan. 2020 um 14:07 Uhr schrieb Guenter Roeck <linux@roeck-u=
s.net>:
> >>
> >> On 1/12/20 4:07 AM, Linus Walleij wrote:
> >>> On Sun, Jan 12, 2020 at 1:03 PM Gabriel C <nix.or.die@gmail.com> wrot=
e:
> >>>> Am So., 12. Jan. 2020 um 12:22 Uhr schrieb Linus Walleij
> >>>> <linus.walleij@linaro.org>:
> >>>>>
> >>>>> On Sun, Jan 12, 2020 at 12:18 PM Gabriel C <nix.or.die@gmail.com> w=
rote:
> >>>>>
> >>>>>> What I've noticed however is the nvme temperature low/high values =
on
> >>>>>> the Sensors X are strange here.
> >>>>> (...)
> >>>>>> Sensor 1:     +27.9=C2=B0C  (low  =3D -273.1=C2=B0C, high =3D +652=
61.8=C2=B0C)
> >>>>>> Sensor 2:     +29.9=C2=B0C  (low  =3D -273.1=C2=B0C, high =3D +652=
61.8=C2=B0C)
> >>>>> (...)
> >>>>>> Sensor 1:     +23.9=C2=B0C  (low  =3D -273.1=C2=B0C, high =3D +652=
61.8=C2=B0C)
> >>>>>> Sensor 2:     +25.9=C2=B0C  (low  =3D -273.1=C2=B0C, high =3D +652=
61.8=C2=B0C)
> >>>>>
> >>>>> That doesn't look strange to me. It seems like reasonable defaults
> >>>>> from the firmware if either it doesn't really log the min/max tempe=
ratures
> >>>>> or hasn't been through a cycle of updating these yet. Just set both
> >>>>> to absolute min/max temperatures possible.
> >>>>
> >>>> Ok I'll check that.
> >>>>
> >>>> Do you mean by setting the temperatures to use a lmsensors config?
> >>>> Or is there a way to set these with a nvme command?
> >>>
> >>> Not that I know of.
> >>>
> >>> The min/max are the minumum and maximum temperatures the
> >>> device has experienced during this power-on cycle.
> >>>
> >>
> >> No, that would be lowest/highest. The above are (or should be) per-sen=
sor
> >> setpoints. The default for those is typically the absolute minimum /
> >> maximum of the supported range.
> >>
> >> Some SATA drives report the lowest/highest temperatures experienced
> >> since power cycle, like here.
> >>
> >> drivetemp-scsi-5-0
> >> Adapter: SCSI adapter
> >> temp1:        +23.0=C2=B0C  (low  =3D  +0.0=C2=B0C, high =3D +60.0=C2=
=B0C)
> >>                          (crit low =3D -41.0=C2=B0C, crit =3D +85.0=C2=
=B0C)
> >>                          (lowest =3D +20.0=C2=B0C, highest =3D +31.0=
=C2=B0C)
> >>
> >
> > The SATA temperatures are fine and reported like this here too, just
> > the nvme ones are strange.
> >
> > drivetemp-scsi-4-0
> > Adapter: SCSI adapter
> > temp1:        +28.0=C2=B0C  (low  =3D  +1.0=C2=B0C, high =3D +61.0=C2=
=B0C)
> >                        (crit low =3D  +2.0=C2=B0C, crit =3D +60.0=C2=B0=
C)
> >                        (lowest =3D +16.0=C2=B0C, highest =3D +31.0=C2=
=B0C)
> >
> > drivetemp-scsi-12-0
> > Adapter: SCSI adapter
> > temp1:        +29.0=C2=B0C  (low  =3D  +1.0=C2=B0C, high =3D +61.0=C2=
=B0C)
> >                        (crit low =3D  +2.0=C2=B0C, crit =3D +60.0=C2=B0=
C)
> >                        (lowest =3D +18.0=C2=B0C, highest =3D +32.0=C2=
=B0C)
> >
> > and so on.
> >
> > Btw, where I can find the code does these calculations?
> >
>
> Not sure if that is what you are looking for, but the nvme hardware
> monitoring driver is at drivers/nvme/host/hwmon.c, the SATA hardware
> monitoring driver is at drivers/hwmon/drivetemp.c.
>

I have a look thanks.

I'm using your v2 patch for the nvme part since you posted it on 5.4 kernel=
s.
This is probably why I find the way the temperatures are now reported
very strange.

The ADATA XPG SX8200 Pro in my laptop seems to work better:

nvme-pci-0200
Adapter: PCI adapter
Composite:    +37.9=C2=B0C  (low  =3D  -0.1=C2=B0C, high =3D +74.8=C2=B0C)
                      (crit =3D +79.8=C2=B0C)

Low is 0=C2=B0 which is what the spec suggests.

> The limits on nvme drives are configurable.

Yes, I found this out already.

> root@server:/sys/class/hwmon# sensors nvme-pci-0100
> nvme-pci-0100
> Adapter: PCI adapter
> Composite:    +40.9=C2=B0C  (low  =3D -273.1=C2=B0C, high =3D +84.8=C2=B0=
C)
>                         (crit =3D +84.8=C2=B0C)
> Sensor 1:     +40.9=C2=B0C  (low  =3D -273.1=C2=B0C, high =3D +65261.8=C2=
=B0C)
> Sensor 2:     +43.9=C2=B0C  (low  =3D -273.1=C2=B0C, high =3D +65261.8=C2=
=B0C)
>
> root@server:/sys/class/hwmon# echo 0 > hwmon1/temp2_min
> root@server:/sys/class/hwmon# echo 100000 > hwmon1/temp2_max

An lm-sensors configuration will work too.

> root@server:/sys/class/hwmon# sensors nvme-pci-0100
> nvme-pci-0100
> Adapter: PCI adapter
> Composite:    +38.9=C2=B0C  (low  =3D -273.1=C2=B0C, high =3D +84.8=C2=B0=
C)
>                         (crit =3D +84.8=C2=B0C)
> Sensor 1:     +38.9=C2=B0C  (low  =3D  -0.1=C2=B0C, high =3D +99.8=C2=B0C=
)
> Sensor 2:     +42.9=C2=B0C  (low  =3D -273.1=C2=B0C, high =3D +65261.8=C2=
=B0C)
>
> If you dislike the defaults, just configure whatever you think is
> appropriate for your system.

It's not about disliking the values. I want to find out if these Samsung mo=
dels
don't support that, or it is a bug somewhere in writing/calculating the val=
ues.

In the case, Samsung and others don't support such a thing wouldn't be
better to just ignore
the bogus reading altogether?
