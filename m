Return-Path: <SRS0=w4/B=3B=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DD49EC33CA9
	for <linux-scsi@archiver.kernel.org>; Sun, 12 Jan 2020 11:18:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B411422314
	for <linux-scsi@archiver.kernel.org>; Sun, 12 Jan 2020 11:18:20 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="cyVCkBL7"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732666AbgALLSR (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 12 Jan 2020 06:18:17 -0500
Received: from mail-lj1-f194.google.com ([209.85.208.194]:41507 "EHLO
        mail-lj1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732658AbgALLSR (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 12 Jan 2020 06:18:17 -0500
Received: by mail-lj1-f194.google.com with SMTP id h23so6859307ljc.8;
        Sun, 12 Jan 2020 03:18:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=HjXRltt9T4tv+AGiYUQm42ldtPkbKRPH1RFs4OFV4lQ=;
        b=cyVCkBL7WRXjVoO8jtQFhnNNUMwnbcQOlLSxf21gA6AK+Z9a6Ap+TyA2wdzxue9IEE
         03AN0F0bEvGYDjQIkOU37Q1gDB6MPD3rWx5PZUpNbCSpnPzGCa52QTOj/Oz13G9fqVAA
         /o9RLj+6jOIcUgB12Kt0JZFa7yPXs3KYOxYmj9y846cpnYY+3UnQwAIy7Sv1c7IZkD8C
         9kOoi1uxF9xGkrbSurYeGFTmK8DTwX1wPeljckJnkOCR+jqQBRIp2hThbZDkGy8zwhhS
         kT/L7ykyCx5umMQing6OQu4OLIzzituaPwLpyb1ulg4qMKt0QAT+xzkcvynF7Q7M+G5d
         duTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=HjXRltt9T4tv+AGiYUQm42ldtPkbKRPH1RFs4OFV4lQ=;
        b=KY5WHjuNjW4ZEvJo96vD+WCLfZaPDL3qxpE+WjhfH7Q9TsHX6wmd+fExnhMQzFaMd2
         dBX3KPIHquyIlwmVemGVAPfxMjY1aAspIPX+umqX7IG2p/01odO032ErZxLTh13EMYzg
         Al8TTbSDbRft+qQakNfD7jO95QKYld9tXRa4oew+ZPmPFl+75/F58r0elKcVmG50P43G
         30utNZCt7lxcq+p2w+Fo2PayYaekG7dQy4/IwVPJPd9C/ORjW+xY50acjvWBLcBNQst7
         hPg31DxEyGLl8XHHDvDz6nwwOuZSZB0KQdoO7YWBsz9gDJKGGjYa9alPhQxTZVs1cjAO
         ZwDA==
X-Gm-Message-State: APjAAAXjMogFFmEBRACs2nt27I2RZSWJE1Epci5D4If6M65NEXa+fdIj
        gulpzgHMg+z5eqpFWFr628y+D2JAIqAMbdGHbA==
X-Google-Smtp-Source: APXvYqyr4kX23bBdW15qFhtOcRO5VyBLK/8oruvsyi03Fs6rlVryKeoN+L4lw54xVhckTq1+tLd2QJmqMm8qMZ3jfe0=
X-Received: by 2002:a05:651c:1068:: with SMTP id y8mr7643976ljm.71.1578827895099;
 Sun, 12 Jan 2020 03:18:15 -0800 (PST)
MIME-Version: 1.0
References: <20191215174509.1847-1-linux@roeck-us.net> <20191215174509.1847-2-linux@roeck-us.net>
 <yq1r211dvck.fsf@oracle.com> <b22a519c-8f26-e731-345f-9deca1b2150e@roeck-us.net>
 <yq1sgkq21ll.fsf@oracle.com> <20200108153341.GB28530@roeck-us.net> <38af9fda-9edf-1b54-bd8d-92f712ae4cda@roeck-us.net>
In-Reply-To: <38af9fda-9edf-1b54-bd8d-92f712ae4cda@roeck-us.net>
From:   Gabriel C <nix.or.die@gmail.com>
Date:   Sun, 12 Jan 2020 12:17:48 +0100
Message-ID: <CAEJqkgg_piiAWy4r3VD=KyQ7pi69bZNym2Ws=Tr8SY5wf+Sprg@mail.gmail.com>
Subject: Re: [PATCH v2] hwmon: Driver for temperature sensors on SATA drives
To:     Guenter Roeck <linux@roeck-us.net>
Cc:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-hwmon@vger.kernel.org, Jean Delvare <jdelvare@suse.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Bart Van Assche <bvanassche@acm.org>,
        linux-doc@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        linux-ide@vger.kernel.org, Chris Healy <cphealy@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Am Sa., 11. Jan. 2020 um 21:24 Uhr schrieb Guenter Roeck <linux@roeck-us.ne=
t>:
>
> On 1/8/20 7:33 AM, Guenter Roeck wrote:
> > On Tue, Jan 07, 2020 at 08:12:06PM -0500, Martin K. Petersen wrote:
> >>
> >> Guenter,
> >>
> >>> Any idea how I might be able to reproduce this ? So far I have been
> >>> unsuccessful.
> >>>
> >>> Building drivetemp into the kernel, with ahci and everything SCSI
> >>> built as module, doesn't trigger the crash for me. This is with the
> >>> drivetemp patch (v3) as well as commit d188b0675b ("scsi: core: Add
> >>> sysfs attributes for VPD pages 0h and 89h") applied on top of v5.4.7.
> >>
> >> This is with 5.5-rc1. I'll try another kernel.
> >>
> >> My repro is:
> >>
> >> # modprobe drivetemp
> >> # modprobe <any SCSI driver, including ahci>
> >>
> > No luck on my side. Can you provide a traceback ? Maybe we can use it
> > to find out what is happening.
> >
>
> I tried again, this time with v5.5-rc5. Loading and unloading ahci and
> drivetemp in any order does not cause any problems for me.
>
> At this point I don't know what else I could test. I went ahead and
> applied the drivetemp patch to hwmon-next. Maybe we'll get some additiona=
l
> test feedback this way.

I've tested Linus git tree from right now + hwmon-next and I cannot
make it crash.
The driver seems to work fine here and temperature reportings are very accu=
rate
on all HDDs on that box. ( 8 x Seagate IronWolf 2 TB (ST2000VN004) )

What I've noticed however is the nvme temperature low/high values on
the Sensors X are strange here.
I'm not sure it is a v5.5 issue or a hwmon-next one right now, I
didn't boot a vanilla v5.5-rc5 yet.

Both nvme's are Samsung SSD 960 EVO 250GB.

They look like this:

nvme-pci-1300
Adapter: PCI adapter
Composite:    +27.9=C2=B0C  (low  =3D -273.1=C2=B0C, high =3D +76.8=C2=B0C)
                      (crit =3D +78.8=C2=B0C)
Sensor 1:     +27.9=C2=B0C  (low  =3D -273.1=C2=B0C, high =3D +65261.8=C2=
=B0C)
Sensor 2:     +29.9=C2=B0C  (low  =3D -273.1=C2=B0C, high =3D +65261.8=C2=
=B0C)

nvme-pci-6100
Adapter: PCI adapter
Composite:    +23.9=C2=B0C  (low  =3D -273.1=C2=B0C, high =3D +76.8=C2=B0C)
                      (crit =3D +78.8=C2=B0C)
Sensor 1:     +23.9=C2=B0C  (low  =3D -273.1=C2=B0C, high =3D +65261.8=C2=
=B0C)
Sensor 2:     +25.9=C2=B0C  (low  =3D -273.1=C2=B0C, high =3D +65261.8=C2=
=B0C)

Best Regards,

Gabriel C.
