Return-Path: <SRS0=lyXb=32=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6E652C33CAC
	for <linux-scsi@archiver.kernel.org>; Thu,  6 Feb 2020 15:50:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3EB9221741
	for <linux-scsi@archiver.kernel.org>; Thu,  6 Feb 2020 15:50:13 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Q3t0/qNL"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727516AbgBFPuN (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 6 Feb 2020 10:50:13 -0500
Received: from mail-lj1-f193.google.com ([209.85.208.193]:34795 "EHLO
        mail-lj1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727389AbgBFPuM (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 6 Feb 2020 10:50:12 -0500
Received: by mail-lj1-f193.google.com with SMTP id x7so6643542ljc.1;
        Thu, 06 Feb 2020 07:50:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=2z7Od7AIdCSkZNC7374lA2NlsyOZzZfwKDy4TXEDbrY=;
        b=Q3t0/qNL+UoB49FPTKL2l6AygWLc2Ikx8S6igun8o4Sxcga+X8EBlP6Pcfh+DNmtYr
         1gbf48dby6DxuMWq7iBRglbsJuy96fVKHwh9mVPEpM9XW0mldy/RKnUlSzp7Hnb1O3gP
         cqJy9WpdlsV3SZbs9nvkP346zyS1FKB1Wn9M3DvrRWjBYnYflpKLtzoUIuZVLFQy31CW
         mp+SQkz2nIB49UmXKzWMZPWFCbSqBL6auKXhVeRFKlznHkJyiYVF+1HX2yRixP2pEI1s
         lZGt4cZ7yqtMnZ+sTl6kF8/BNS2A7rjzOcqZOT3jyTy/ZYFr0TuzL9lKDc69ftfQXy1b
         z2lQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=2z7Od7AIdCSkZNC7374lA2NlsyOZzZfwKDy4TXEDbrY=;
        b=dPuQ8B2e0VgTMP7Qrzfdt384HAB/OryfcqjXN09lLMhIr9JbiUP/KhIyunSXTc8qK3
         dhTnjlcVTNj4AvFS3dJtzDGN/pPsWX0OR1MW/KO+jwO17Y2vJVnt5W7FvxcHpK1eC7br
         Oj3nhjBKFntCJQITG6hh1bBeUOeXT9ethe3H9aupWyfdKQptbisOJOokQKFaxGhk96Ty
         4iQknQ4SjbLDL9Do9pPAxSdPxuiKPWD+1l96oOo+Sew9uRIC7ZETYVCXrYX3Eb6sN0eV
         H/4UTIhRInOWanhlqDZygxemVunWIi3GL9Qwl5UMIBV050ZVyIn1d40+Pj1mQQN3C+5N
         WLuw==
X-Gm-Message-State: APjAAAUnTAQILzcynd0guxyDlyvhVbED9TIoaZGr5ZiVv3yfMa5w2kke
        GlwJGXJbJRwnfyhWeBAbiFdWfY5xS0NFG0Oj+38=
X-Google-Smtp-Source: APXvYqysj+Ue4KAW4mCPufYx9BNobf4YllhVHp82p4KaVn4BbuKBI2bg4E7hwKbOE/6vveAIeznlIgtWI6njuazATlg=
X-Received: by 2002:a2e:7c08:: with SMTP id x8mr2432034ljc.185.1581004210164;
 Thu, 06 Feb 2020 07:50:10 -0800 (PST)
MIME-Version: 1.0
References: <1580640419-6703-1-git-send-email-avi.shchislowski@wdc.com>
 <20200202192105.GA20107@roeck-us.net> <MN2PR04MB61906E820FAF0F17082D53AE9A000@MN2PR04MB6190.namprd04.prod.outlook.com>
 <94cb1e97-18ed-ebec-23c2-b4d87434726a@roeck-us.net> <MN2PR04MB69910152F14A7D481029E4ECFC000@MN2PR04MB6991.namprd04.prod.outlook.com>
 <20200203214733.GA30898@roeck-us.net> <BY5PR04MB69809A3BEFD629A67FB563CDFC030@BY5PR04MB6980.namprd04.prod.outlook.com>
 <MN2PR04MB6190D9E63717D37285DADBB09A1D0@MN2PR04MB6190.namprd04.prod.outlook.com>
 <CAGRGNgWG2fvY33j0m00SkguU8N4TJttY4KeNtOxZ7HzTTXA=yw@mail.gmail.com>
 <MN2PR04MB6991848EBC8DED439FCD7C49FC1D0@MN2PR04MB6991.namprd04.prod.outlook.com>
 <CAGRGNgUA=LHbWqZY+hsYjfsTbyftc3uoGv6S3p8E4zPQyqsOGQ@mail.gmail.com> <MN2PR04MB699190E3474F82BEF9B91A58FC1D0@MN2PR04MB6991.namprd04.prod.outlook.com>
In-Reply-To: <MN2PR04MB699190E3474F82BEF9B91A58FC1D0@MN2PR04MB6991.namprd04.prod.outlook.com>
From:   Julian Calaby <julian.calaby@gmail.com>
Date:   Fri, 7 Feb 2020 02:49:58 +1100
Message-ID: <CAGRGNgWob+0t35AYXfzCqKtLjBgw=p8MhqDCKF=5_JGe5veqtQ@mail.gmail.com>
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

On Fri, Feb 7, 2020 at 12:41 AM Avri Altman <Avri.Altman@wdc.com> wrote:
>
> >
> > Hi Avri,
> >
> > On Thu, Feb 6, 2020 at 11:08 PM Avri Altman <Avri.Altman@wdc.com>
> > wrote:
> > >
> > >
> > > >
> > > > Hi Avi,
> > > >
> > > > On Thu, Feb 6, 2020 at 9:48 PM Avi Shchislowski
> > > > <Avi.Shchislowski@wdc.com> wrote:
> > > > >
> > > > > As it become evident that the hwmon is not a viable option to
> > implement
> > > > ufs thermal notification, I would appreciate some concrete comments of
> > this
> > > > series.
> > > >
> > > > That isn't my reading of this thread.
> > > >
> > > > You have two options:
> > > > 1. extend drivetemp if that makes sense for this particular application.
> > > > 2. follow the model of other devices that happen to have a built-in
> > > > temperature sensor and expose the hwmon compatible attributes as a
> > > > subdevice
> > > >
> > > > It appears that option 1 isn't viable, so what about option 2?
> > > This will require to export the ufs device management commands,
> > > Which is privet to the ufs driver.
> > >
> > > This is not a viable option as well, because it will allow unrestricted access
> > > (Including format etc.) to the storage device.
> > >
> > > Sorry for not making it clearer before.
> >
> > I should have clarified further: I meant having the UFS device
> > register a HWMON driver using this API:
> > https://www.kernel.org/doc/html/latest/hwmon/hwmon-kernel-api.html
> >
> > *Not* writing a separate HWMON driver that uses some private interface.
> Ok.
> Just one last question:
> The ufs spec requires to be able to react upon an exception event from the device.
> The thermal core provides an api in the form of thermal_notify_framework().
> What would be the hwmon equivalent for that?

My understanding is that HWMON is just a standardised way to report
hardware sensor data to userspace. There are "alarm" files that can be
used to report fault conditions, so any action taken would have to be
either managed by userspace or configured using thermal zones
configured in the hardware's devicetree.

thermal_notify_framework() is a way to notify the "other side" of a
thermal zone to do something to reduce the temperature of that zone.
E.g. spin up a fan or switch to a lower-power state to cool a CPU.
Looking at your code, you're only implementing the "sensor" side of
the thermal zone functionality, so your calls to
thermal_notify_framework() won't do anything.

Thanks,

--
Julian Calaby

Email: julian.calaby@gmail.com
Profile: http://www.google.com/profiles/julian.calaby/
