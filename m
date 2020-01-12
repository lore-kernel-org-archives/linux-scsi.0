Return-Path: <SRS0=w4/B=3B=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 46519C33CAA
	for <linux-scsi@archiver.kernel.org>; Sun, 12 Jan 2020 22:27:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 07D26214AF
	for <linux-scsi@archiver.kernel.org>; Sun, 12 Jan 2020 22:27:09 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="P4cFTvUp"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387440AbgALW1H (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 12 Jan 2020 17:27:07 -0500
Received: from mail-lf1-f66.google.com ([209.85.167.66]:33078 "EHLO
        mail-lf1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727222AbgALW1H (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 12 Jan 2020 17:27:07 -0500
Received: by mail-lf1-f66.google.com with SMTP id n25so5454055lfl.0;
        Sun, 12 Jan 2020 14:27:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=Mx0X58/M+liK5b3REtC9PFWCFoWTiSER+fiitTumkCI=;
        b=P4cFTvUpl+Rr4K+1lvO+kIXcpcFZDKu57lnqGKP2vbtSHCsxuEWDirc+ESRZF7RvCc
         8uL8VCXIr/cZzJ5UfQAElzeHRqtwIrfGOiVn25rHwqyczxZtgf0TQ3Cw6q7VrwkdZDUu
         v4V3AmlFy6+VxSOLA3jg2BRdMC0sgeJFvTs6gWl8wVA2xoWOjtMKB0kKspWk4SlDO41I
         benzkOMPHZGRCJkT7xgQrIAKAyvuOzz3r5hpNwmEVE+pr7wBAth3jz+z0juXquuJxINe
         0dnUtqVL/9GTpnTBd2HR6vMa5JhE+AR5HFPcYgtPW/QNPhI/1nN+yL+RXciAvYntTf92
         WP9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=Mx0X58/M+liK5b3REtC9PFWCFoWTiSER+fiitTumkCI=;
        b=UV7y9RmT2Ng2WIshje02dTS7cyQr7fliu1m4J6zozQfLnSoO+9h17nZmfE0HuskA4w
         MqxaVJ3/mO3SDxA5z+89EkaffWz35mg+OzOUF9l3mmnTQgr9vMijVwfceKpvUzM/YBWw
         cPrH/MHQcHnf3NQ3nnshq3t0SDPW03gDnBVfWWZHnwsRG/QU6xcIz93TIRu5VmVof7ZL
         j0qbBGH7sM34lRqDnSMFPhgT7ecexi/1EtTUinTh5Fu4TridIG7745smw+UVX/f4hIfO
         f+rZ4SsxToScfnObp6QxgLOSMrNO1Ss/49SYSysyrVj3c1k+sqygkO9nC2cv78CnoOx8
         97KQ==
X-Gm-Message-State: APjAAAXzOFtpYpvxE6hEkpk5sxLv9KOOI1P6pSxOhWVMKhSRxK1QJIGx
        o/EIct/s8DjS75oYlrQFYKjWka8l+VMqOej4RQ==
X-Google-Smtp-Source: APXvYqwhqcO9vZMfti+ImW4YMmZADkQ3VzUtJDC5sggG88ki5gIlp++zg+h2GlYpbsXIY0vAw6eXd8/AJVddCtoKhMg=
X-Received: by 2002:ac2:5c4b:: with SMTP id s11mr8267686lfp.133.1578868023868;
 Sun, 12 Jan 2020 14:27:03 -0800 (PST)
MIME-Version: 1.0
References: <20191215174509.1847-1-linux@roeck-us.net> <20191215174509.1847-2-linux@roeck-us.net>
 <yq1r211dvck.fsf@oracle.com> <b22a519c-8f26-e731-345f-9deca1b2150e@roeck-us.net>
 <yq1sgkq21ll.fsf@oracle.com> <20200108153341.GB28530@roeck-us.net>
 <38af9fda-9edf-1b54-bd8d-92f712ae4cda@roeck-us.net> <CAEJqkgg_piiAWy4r3VD=KyQ7pi69bZNym2Ws=Tr8SY5wf+Sprg@mail.gmail.com>
 <CACRpkdYU7ZDcKp+BbXRCnEFDw1xwDkU_vXsfo-AZNUWGEVknXQ@mail.gmail.com>
 <CAEJqkggo3Mou1SykjisyYn+3SGGgNfnKagr=7ZPyw=Y=1MZ55w@mail.gmail.com>
 <CACRpkdayHFmdz4nAMaXR07Hcy=dLLGnnU8PkFhwQKuDTLnvOSw@mail.gmail.com>
 <e3caa946-b8f2-75c7-4bcb-69ad198de472@roeck-us.net> <CAEJqkggBvBus-G=TevSf0OUWLx_63qmZEThi-tNyPmAD2JXW-g@mail.gmail.com>
 <25c57e9d-94db-3a8b-5f68-f8a49e500b45@roeck-us.net> <CAEJqkggnQzPw1uyMUZ5F-nqSwKAu5Ur7C_VujhZxZrvv-iUt_g@mail.gmail.com>
 <de8861e8-f21b-6a66-4f5b-25acc8ff40e2@roeck-us.net>
In-Reply-To: <de8861e8-f21b-6a66-4f5b-25acc8ff40e2@roeck-us.net>
From:   Gabriel C <nix.or.die@gmail.com>
Date:   Sun, 12 Jan 2020 23:26:37 +0100
Message-ID: <CAEJqkgi1yDUmMcvfaQfuyukCBKjgnpY0n5BxvTTw0U_4+PoAHQ@mail.gmail.com>
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

Am So., 12. Jan. 2020 um 21:08 Uhr schrieb Guenter Roeck <linux@roeck-us.ne=
t>:
>
> On 1/12/20 10:37 AM, Gabriel C wrote:
> > Am So., 12. Jan. 2020 um 16:26 Uhr schrieb Guenter Roeck <linux@roeck-u=
s.net>:
> >>
> >> On 1/12/20 5:45 AM, Gabriel C wrote:
> >>> Am So., 12. Jan. 2020 um 14:07 Uhr schrieb Guenter Roeck <linux@roeck=
-us.net>:
> >>>>
> >>>> On 1/12/20 4:07 AM, Linus Walleij wrote:
> >>>>> On Sun, Jan 12, 2020 at 1:03 PM Gabriel C <nix.or.die@gmail.com> wr=
ote:
> >>>>>> Am So., 12. Jan. 2020 um 12:22 Uhr schrieb Linus Walleij
> >>>>>> <linus.walleij@linaro.org>:
> >>>>>>>
> >>>>>>> On Sun, Jan 12, 2020 at 12:18 PM Gabriel C <nix.or.die@gmail.com>=
 wrote:
> >>>>>>>
> >>>>>>>> What I've noticed however is the nvme temperature low/high value=
s on
> >>>>>>>> the Sensors X are strange here.
> >>>>>>> (...)
> >>>>>>>> Sensor 1:     +27.9=C2=B0C  (low  =3D -273.1=C2=B0C, high =3D +6=
5261.8=C2=B0C)
> >>>>>>>> Sensor 2:     +29.9=C2=B0C  (low  =3D -273.1=C2=B0C, high =3D +6=
5261.8=C2=B0C)
> >>>>>>> (...)
> >>>>>>>> Sensor 1:     +23.9=C2=B0C  (low  =3D -273.1=C2=B0C, high =3D +6=
5261.8=C2=B0C)
> >>>>>>>> Sensor 2:     +25.9=C2=B0C  (low  =3D -273.1=C2=B0C, high =3D +6=
5261.8=C2=B0C)
> >>>>>>>
> >>>>>>> That doesn't look strange to me. It seems like reasonable default=
s
> >>>>>>> from the firmware if either it doesn't really log the min/max tem=
peratures
> >>>>>>> or hasn't been through a cycle of updating these yet. Just set bo=
th
> >>>>>>> to absolute min/max temperatures possible.
> >>>>>>
> >>>>>> Ok I'll check that.
> >>>>>>
> >>>>>> Do you mean by setting the temperatures to use a lmsensors config?
> >>>>>> Or is there a way to set these with a nvme command?
> >>>>>
> >>>>> Not that I know of.
> >>>>>
> >>>>> The min/max are the minumum and maximum temperatures the
> >>>>> device has experienced during this power-on cycle.
> >>>>>
> >>>>
> >>>> No, that would be lowest/highest. The above are (or should be) per-s=
ensor
> >>>> setpoints. The default for those is typically the absolute minimum /
> >>>> maximum of the supported range.
> >>>>
> >>>> Some SATA drives report the lowest/highest temperatures experienced
> >>>> since power cycle, like here.
> >>>>
> >>>> drivetemp-scsi-5-0
> >>>> Adapter: SCSI adapter
> >>>> temp1:        +23.0=C2=B0C  (low  =3D  +0.0=C2=B0C, high =3D +60.0=
=C2=B0C)
> >>>>                           (crit low =3D -41.0=C2=B0C, crit =3D +85.0=
=C2=B0C)
> >>>>                           (lowest =3D +20.0=C2=B0C, highest =3D +31.=
0=C2=B0C)
> >>>>
> >>>
> >>> The SATA temperatures are fine and reported like this here too, just
> >>> the nvme ones are strange.
> >>>
> >>> drivetemp-scsi-4-0
> >>> Adapter: SCSI adapter
> >>> temp1:        +28.0=C2=B0C  (low  =3D  +1.0=C2=B0C, high =3D +61.0=C2=
=B0C)
> >>>                         (crit low =3D  +2.0=C2=B0C, crit =3D +60.0=C2=
=B0C)
> >>>                         (lowest =3D +16.0=C2=B0C, highest =3D +31.0=
=C2=B0C)
> >>>
> >>> drivetemp-scsi-12-0
> >>> Adapter: SCSI adapter
> >>> temp1:        +29.0=C2=B0C  (low  =3D  +1.0=C2=B0C, high =3D +61.0=C2=
=B0C)
> >>>                         (crit low =3D  +2.0=C2=B0C, crit =3D +60.0=C2=
=B0C)
> >>>                         (lowest =3D +18.0=C2=B0C, highest =3D +32.0=
=C2=B0C)
> >>>
> >>> and so on.
> >>>
> >>> Btw, where I can find the code does these calculations?
> >>>
> >>
> >> Not sure if that is what you are looking for, but the nvme hardware
> >> monitoring driver is at drivers/nvme/host/hwmon.c, the SATA hardware
> >> monitoring driver is at drivers/hwmon/drivetemp.c.
> >>
> >
> > I have a look thanks.
> >
> > I'm using your v2 patch for the nvme part since you posted it on 5.4 ke=
rnels.
> > This is probably why I find the way the temperatures are now reported
> > very strange.
> >
> > The ADATA XPG SX8200 Pro in my laptop seems to work better:
> >
> > nvme-pci-0200
> > Adapter: PCI adapter
> > Composite:    +37.9=C2=B0C  (low  =3D  -0.1=C2=B0C, high =3D +74.8=C2=
=B0C)
> >                        (crit =3D +79.8=C2=B0C)
> >
> > Low is 0=C2=B0 which is what the spec suggests.
> >
> >> The limits on nvme drives are configurable.
> >
> > Yes, I found this out already.
> >
> >> root@server:/sys/class/hwmon# sensors nvme-pci-0100
> >> nvme-pci-0100
> >> Adapter: PCI adapter
> >> Composite:    +40.9=C2=B0C  (low  =3D -273.1=C2=B0C, high =3D +84.8=C2=
=B0C)
> >>                          (crit =3D +84.8=C2=B0C)
> >> Sensor 1:     +40.9=C2=B0C  (low  =3D -273.1=C2=B0C, high =3D +65261.8=
=C2=B0C)
> >> Sensor 2:     +43.9=C2=B0C  (low  =3D -273.1=C2=B0C, high =3D +65261.8=
=C2=B0C)
> >>
> >> root@server:/sys/class/hwmon# echo 0 > hwmon1/temp2_min
> >> root@server:/sys/class/hwmon# echo 100000 > hwmon1/temp2_max
> >
> > An lm-sensors configuration will work too.
> >
> Sure, the above was just an example.
>
> >> root@server:/sys/class/hwmon# sensors nvme-pci-0100
> >> nvme-pci-0100
> >> Adapter: PCI adapter
> >> Composite:    +38.9=C2=B0C  (low  =3D -273.1=C2=B0C, high =3D +84.8=C2=
=B0C)
> >>                          (crit =3D +84.8=C2=B0C)
> >> Sensor 1:     +38.9=C2=B0C  (low  =3D  -0.1=C2=B0C, high =3D +99.8=C2=
=B0C)
> >> Sensor 2:     +42.9=C2=B0C  (low  =3D -273.1=C2=B0C, high =3D +65261.8=
=C2=B0C)
> >>
> >> If you dislike the defaults, just configure whatever you think is
> >> appropriate for your system.
> >
> > It's not about disliking the values. I want to find out if these Samsun=
g models
> > don't support that, or it is a bug somewhere in writing/calculating the=
 values.
> >
> No, this is not a bug. It is perfectly valid for individual sensors to ha=
ve
> uninitialized limits. If I recall correctly, the NVME specification
> specifically states that the default settings for individual sensors
> shall be those values (0 and 65535 Kelvin, specifically).
>
> And, yes, I would agree that is a bit odd that NVME drives report tempera=
tures
> in Kelvin, but such is the world.
>
> > In the case, Samsung and others don't support such a thing wouldn't be
> > better to just ignore
> > the bogus reading altogether?
>
> Again, you can set whatever limits you like. The default limits on many
> hardware sensor chips have odd values. Just looking at my system:
>
> nct6797-isa-0a20
> Adapter: ISA adapter
> in0:                    +0.48 V  (min =3D  +0.00 V, max =3D  +1.74 V)
> in1:                    +1.02 V  (min =3D  +0.00 V, max =3D  +0.00 V)  AL=
ARM
> in2:                    +3.39 V  (min =3D  +0.00 V, max =3D  +0.00 V)  AL=
ARM
> in3:                    +3.31 V  (min =3D  +0.00 V, max =3D  +0.00 V)  AL=
ARM
> in4:                    +1.00 V  (min =3D  +0.00 V, max =3D  +0.00 V)  AL=
ARM
> in5:                    +0.14 V  (min =3D  +0.00 V, max =3D  +0.00 V)  AL=
ARM
> in6:                    +0.82 V  (min =3D  +0.00 V, max =3D  +0.00 V)  AL=
ARM
> in7:                    +3.38 V  (min =3D  +0.00 V, max =3D  +0.00 V)  AL=
ARM
> in8:                    +3.26 V  (min =3D  +0.00 V, max =3D  +0.00 V)  AL=
ARM
> in9:                    +1.82 V  (min =3D  +0.00 V, max =3D  +0.00 V)  AL=
ARM
> in10:                   +0.00 V  (min =3D  +0.00 V, max =3D  +0.00 V)
> in11:                   +0.74 V  (min =3D  +0.00 V, max =3D  +0.00 V)  AL=
ARM
> in12:                   +1.20 V  (min =3D  +0.00 V, max =3D  +0.00 V)  AL=
ARM
> in13:                   +0.68 V  (min =3D  +0.00 V, max =3D  +0.00 V)  AL=
ARM
> in14:                   +1.50 V  (min =3D  +0.00 V, max =3D  +0.00 V)  AL=
ARM
>
>
> Are you suggesting that we should not support setting min/max values for
> all drivers just because they are often not initialized to reasonable val=
ues
> by default ?

No, I'm not suggesting that. I'm aware of strange I/O monitoring chips valu=
es
and the lack of documentation, so in this case, something is better
than nothing.

In the nvme case, these are only 2 values who either are working/supported
by firmware or not, so I thought it would be reasonable to have
known-good values
instead of 65261.8=C2=B0C, which will probably cause users to report that
as a bug a lot.

Can we at least have that documented and explain how the values can be
set/changed?
