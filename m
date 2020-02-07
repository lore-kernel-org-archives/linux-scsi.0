Return-Path: <SRS0=jGTy=33=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 72122C352A3
	for <linux-scsi@archiver.kernel.org>; Fri,  7 Feb 2020 00:47:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3EC2F2082E
	for <linux-scsi@archiver.kernel.org>; Fri,  7 Feb 2020 00:47:35 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="hZQYTq7W"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726674AbgBGArc (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 6 Feb 2020 19:47:32 -0500
Received: from mail-lj1-f193.google.com ([209.85.208.193]:44866 "EHLO
        mail-lj1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726509AbgBGArc (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 6 Feb 2020 19:47:32 -0500
Received: by mail-lj1-f193.google.com with SMTP id q8so251540ljj.11;
        Thu, 06 Feb 2020 16:47:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=AY8ajexCAjKq8Bc5ioUkiIPxTkipEMTNRaq2FmUDl74=;
        b=hZQYTq7WKtFbU46SHYU9FbNPt7fDY32V6tPM8LIdbg29M/Hhxr5KOsJeXzzGcM9H9/
         EFtEwDiiYf9IJUT5cFwmYzIDR1RpyhQZem3mS07l8ORF74yatZkc35OGVGH/4lcQfkSm
         ghl82f09qpkYNh/FUGB7hgDpW/nrB7acERxNLGwared71ctAoeW2GBJwrxSH8fz8Km5W
         zrfgqDHUpSE6EbqjDMu+lUpS5Vn8NCQv5PntRn+d/54eJKcqPnB+MyN9/HMDPuZgnSSk
         6tOhAaNvnlpHbS3axVeGiLdNxvgHHkGCslCGy0X1Oks5457PIOO9dLKs/bT5xREoaSyo
         1N7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=AY8ajexCAjKq8Bc5ioUkiIPxTkipEMTNRaq2FmUDl74=;
        b=S97OPjCm1qBqy1+TiVbxxvbHiNLfcBe7NCwoWq0UIDJIQX4zGjNly8ZHfk06tL8FRw
         ldmpdOg0EJlreXxisuGpLkcbyf3dicHJTT8shCNKHp48PWX0zm7gf1my1I6G7BOZobQG
         DoNLudYe4m3kRT0bpKa5Q/XZbCr8LCGlwrEaCwjmuZyFUOhHtrNLUBCmmjTLMu1TayMy
         fjCiJ2yvNYikd1UD9G34LMHUppgbqiZEroP5ENE2KOwvv18v6pa0b9BoRQodsfBmNQLD
         4I/Kdck9iZ0LQuPJQbC5MLiS+ACu1Y0nhaLg1f9mdI0yoSOmRfVTTCeppQN6iOy8dhLf
         x6gw==
X-Gm-Message-State: APjAAAUwQ+uCu00xNnhm45uJHXCVli/DID3E86S0pBQTeNxWOMUtoPnc
        H+zPCD8akHRm4xw01CJt6RLqeY/b76y4RRoCznI=
X-Google-Smtp-Source: APXvYqwTSf415WHuEeaUU89V7hBvGUArwzaJGD0UfY1+2mGcyXuC3ndtrGSJYGiImDHSEfMPoo124DodUi9SmfE6D3U=
X-Received: by 2002:a2e:b6ce:: with SMTP id m14mr3412822ljo.99.1581036449777;
 Thu, 06 Feb 2020 16:47:29 -0800 (PST)
MIME-Version: 1.0
References: <1580640419-6703-1-git-send-email-avi.shchislowski@wdc.com>
 <20200202192105.GA20107@roeck-us.net> <MN2PR04MB61906E820FAF0F17082D53AE9A000@MN2PR04MB6190.namprd04.prod.outlook.com>
 <94cb1e97-18ed-ebec-23c2-b4d87434726a@roeck-us.net> <MN2PR04MB69910152F14A7D481029E4ECFC000@MN2PR04MB6991.namprd04.prod.outlook.com>
 <20200203214733.GA30898@roeck-us.net> <BY5PR04MB69809A3BEFD629A67FB563CDFC030@BY5PR04MB6980.namprd04.prod.outlook.com>
 <MN2PR04MB6190D9E63717D37285DADBB09A1D0@MN2PR04MB6190.namprd04.prod.outlook.com>
 <CAGRGNgWG2fvY33j0m00SkguU8N4TJttY4KeNtOxZ7HzTTXA=yw@mail.gmail.com>
 <MN2PR04MB6991848EBC8DED439FCD7C49FC1D0@MN2PR04MB6991.namprd04.prod.outlook.com>
 <CAGRGNgUA=LHbWqZY+hsYjfsTbyftc3uoGv6S3p8E4zPQyqsOGQ@mail.gmail.com>
 <MN2PR04MB699190E3474F82BEF9B91A58FC1D0@MN2PR04MB6991.namprd04.prod.outlook.com>
 <CAGRGNgWob+0t35AYXfzCqKtLjBgw=p8MhqDCKF=5_JGe5veqtQ@mail.gmail.com> <MN2PR04MB699192FB02C86DE567785A83FC1D0@MN2PR04MB6991.namprd04.prod.outlook.com>
In-Reply-To: <MN2PR04MB699192FB02C86DE567785A83FC1D0@MN2PR04MB6991.namprd04.prod.outlook.com>
From:   Julian Calaby <julian.calaby@gmail.com>
Date:   Fri, 7 Feb 2020 11:47:18 +1100
Message-ID: <CAGRGNgXWiJ1BVU_kKTMYfxnGRnSJU-YUAWogrLmxagVm9_W1+g@mail.gmail.com>
Subject: Re: [PATCH 0/5] scsi: ufs: ufs device as a temperature sensor
To:     Avri Altman <Avri.Altman@wdc.com>
Cc:     Avi Shchislowski <Avi.Shchislowski@wdc.com>,
        Guenter Roeck <linux@roeck-us.net>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Avri,

On Fri, Feb 7, 2020 at 6:32 AM Avri Altman <Avri.Altman@wdc.com> wrote:
>
> Hi Julian,
>
> >
> >
> > Hi Avri,
> >
> > On Fri, Feb 7, 2020 at 12:41 AM Avri Altman <Avri.Altman@wdc.com> wrote:
> > >
> > > >
> > > > Hi Avri,
> > > >
> > > > On Thu, Feb 6, 2020 at 11:08 PM Avri Altman <Avri.Altman@wdc.com>
> > > > wrote:
> > > > >
> > > > >
> > > > > >
> > > > > > Hi Avi,
> > > > > >
> > > > > > On Thu, Feb 6, 2020 at 9:48 PM Avi Shchislowski
> > > > > > <Avi.Shchislowski@wdc.com> wrote:
> > > > > > >
> > > > > > > As it become evident that the hwmon is not a viable option to
> > > > implement
> > > > > > ufs thermal notification, I would appreciate some concrete comments
> > of
> > > > this
> > > > > > series.
> > > > > >
> > > > > > That isn't my reading of this thread.
> > > > > >
> > > > > > You have two options:
> > > > > > 1. extend drivetemp if that makes sense for this particular application.
> > > > > > 2. follow the model of other devices that happen to have a built-in
> > > > > > temperature sensor and expose the hwmon compatible attributes as
> > a
> > > > > > subdevice
> > > > > >
> > > > > > It appears that option 1 isn't viable, so what about option 2?
> > > > > This will require to export the ufs device management commands,
> > > > > Which is privet to the ufs driver.
> > > > >
> > > > > This is not a viable option as well, because it will allow unrestricted
> > access
> > > > > (Including format etc.) to the storage device.
> > > > >
> > > > > Sorry for not making it clearer before.
> > > >
> > > > I should have clarified further: I meant having the UFS device
> > > > register a HWMON driver using this API:
> > > > https://www.kernel.org/doc/html/latest/hwmon/hwmon-kernel-
> > api.html
> > > >
> > > > *Not* writing a separate HWMON driver that uses some private
> > interface.
> > > Ok.
> > > Just one last question:
> > > The ufs spec requires to be able to react upon an exception event from the
> > device.
> > > The thermal core provides an api in the form of
> > thermal_notify_framework().
> > > What would be the hwmon equivalent for that?
> >
> > My understanding is that HWMON is just a standardised way to report
> > hardware sensor data to userspace. There are "alarm" files that can be
> > used to report fault conditions, so any action taken would have to be
> > either managed by userspace or configured using thermal zones
> > configured in the hardware's devicetree.
> Those "alarms" are  implemented as part of the modules under drivers/hwmon/ isn't it?
> We already established that this is not an option for the ufs driver.

The HWMON API I pointed you to is a way for _any_ driver to implement
the necessary bits and pieces to report temperatures, alarms, etc.

It is _not_ restricted to modules under drivers/hwmon/ - you can
implement all parts of the HWMON interface from any driver anywhere.

Which means that all that is required to report alarms is to simply
implement support for that particular type of file.

> > thermal_notify_framework() is a way to notify the "other side" of a
> > thermal zone to do something to reduce the temperature of that zone.
> > E.g. spin up a fan or switch to a lower-power state to cool a CPU.
> > Looking at your code, you're only implementing the "sensor" side of
> > the thermal zone functionality, so your calls to
> > thermal_notify_framework() won't do anything.
> Right.  The thermal core allows to react to such notifications,
> Provided that the thermal zone device has a governor defined,
> And/or notify ops etc.

Yes, but you don't define a cooling device, so there's nothing to
react to those notifications.

> Should the current patches implement those callbacks or not,
> Can be discussed during their review process.
> But the important thing is that the thermal core support it in an intuitive and simple way,
> While the hwmon doesn't.
>
> We are indifference with respect of which subsystem to use.
> The thermal core was our first choice because we bumped into it,
> Looking for a way to raise thermal exceptions.
> It provides the functionality we need, and other devices uses it,
> Why the insistence not to use it?

Other devices using the thermal zone subsystem implement both "sides"
of the zone: a sensor that monitors the device and cooling device(s)
which should be able to react to that. E.g. lowering the clock speed
of a CPU, slowing the transmission speed of a WiFi card, etc.

Your implementation doesn't do that.

Thanks,

-- 
Julian Calaby

Email: julian.calaby@gmail.com
Profile: http://www.google.com/profiles/julian.calaby/
