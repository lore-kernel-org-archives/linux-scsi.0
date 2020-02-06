Return-Path: <SRS0=lyXb=32=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 765DBC2D0B1
	for <linux-scsi@archiver.kernel.org>; Thu,  6 Feb 2020 12:42:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 43FEE217BA
	for <linux-scsi@archiver.kernel.org>; Thu,  6 Feb 2020 12:42:12 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="XLWUkzua"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727628AbgBFMmJ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 6 Feb 2020 07:42:09 -0500
Received: from mail-lf1-f66.google.com ([209.85.167.66]:45076 "EHLO
        mail-lf1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726538AbgBFMmJ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 6 Feb 2020 07:42:09 -0500
Received: by mail-lf1-f66.google.com with SMTP id 203so3988062lfa.12;
        Thu, 06 Feb 2020 04:42:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=NXcVSONSIjpWjvkmio9pr1+Iw6UBup0YHvSTK6KiGHE=;
        b=XLWUkzuadKKQtkp4j7n+1wwZuef6tmuW0MyzJuykCOgeKBbJUm7ae5bUSf6TTPc+Ho
         MbGNmsXdCmt3V2/3s5EN07O0WaKN1PTGoDvFVoALiJidSX8tdXxGwt6FVbZ9CzeuTsPp
         sG+Z7ws93utYpcmTHiQz3Xdrxg9M+RFz/VGOyNOqNyPdJgH1XG/SggabP0o4c2M/fixH
         +zA+Ru50ac/6zc69h0Y80bRlrTtPtlblxaPq+5sMFVU/9SF75wOrQTrlxIrjUogAZeZa
         SBPTR+prH//684PGpnZIXputynBnWKB3sc8yxGrDDnBmS9cn4NITjMqJFFTNt3da5312
         bWAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=NXcVSONSIjpWjvkmio9pr1+Iw6UBup0YHvSTK6KiGHE=;
        b=qv0gUgMkG0GPiyNrmXJ4XyfmVeeweIz9PGuOu/OZ6Wfx2r8a5fnmltcabVsjukL/8O
         5UmlyhgZZwqsswVG21EUg7uxPkmIuF5Lihqs2gqeK0ivSuVgqCQivMwl3XtXqitAEIgG
         fde/f3RAyi2zvF/Pzv18iVhRdyDBFeBjSSWkDLekrlCtSihy6S1zHKQmylNoZL9dXDyq
         tbsw2SVSVPnIOowewoK47b28c8smkXZrNmR8T0kbeEgKhIVSfmQzGkCw0dWA323LgwdI
         hjgG+PCqHs5dxgSQeKjPICjAoD4jeVHPsj3h1vqtImDC0l7oY+sbwq4Mxb/oqTpPBWol
         N3hg==
X-Gm-Message-State: APjAAAVsch0T8+2L/vBvnk5eP2T5qBt8PwgUZHtFbQElLm3146ItvLZU
        ilk166vJ9AklBOmBybvXn5S8a/UPy88BCu1xLOY=
X-Google-Smtp-Source: APXvYqxJTTS7Vnn522r2f7jdRFy8u1uNW3q2e0CgK6Ju5CUPBIXDv6/X2pFVsFi41r8q7EpkT5MTQDAozfNI22saGUg=
X-Received: by 2002:a19:c014:: with SMTP id q20mr1746757lff.209.1580992926731;
 Thu, 06 Feb 2020 04:42:06 -0800 (PST)
MIME-Version: 1.0
References: <1580640419-6703-1-git-send-email-avi.shchislowski@wdc.com>
 <20200202192105.GA20107@roeck-us.net> <MN2PR04MB61906E820FAF0F17082D53AE9A000@MN2PR04MB6190.namprd04.prod.outlook.com>
 <94cb1e97-18ed-ebec-23c2-b4d87434726a@roeck-us.net> <MN2PR04MB69910152F14A7D481029E4ECFC000@MN2PR04MB6991.namprd04.prod.outlook.com>
 <20200203214733.GA30898@roeck-us.net> <BY5PR04MB69809A3BEFD629A67FB563CDFC030@BY5PR04MB6980.namprd04.prod.outlook.com>
 <MN2PR04MB6190D9E63717D37285DADBB09A1D0@MN2PR04MB6190.namprd04.prod.outlook.com>
 <CAGRGNgWG2fvY33j0m00SkguU8N4TJttY4KeNtOxZ7HzTTXA=yw@mail.gmail.com> <MN2PR04MB6991848EBC8DED439FCD7C49FC1D0@MN2PR04MB6991.namprd04.prod.outlook.com>
In-Reply-To: <MN2PR04MB6991848EBC8DED439FCD7C49FC1D0@MN2PR04MB6991.namprd04.prod.outlook.com>
From:   Julian Calaby <julian.calaby@gmail.com>
Date:   Thu, 6 Feb 2020 23:41:55 +1100
Message-ID: <CAGRGNgUA=LHbWqZY+hsYjfsTbyftc3uoGv6S3p8E4zPQyqsOGQ@mail.gmail.com>
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

On Thu, Feb 6, 2020 at 11:08 PM Avri Altman <Avri.Altman@wdc.com> wrote:
>
>
> >
> > Hi Avi,
> >
> > On Thu, Feb 6, 2020 at 9:48 PM Avi Shchislowski
> > <Avi.Shchislowski@wdc.com> wrote:
> > >
> > > As it become evident that the hwmon is not a viable option to implement
> > ufs thermal notification, I would appreciate some concrete comments of this
> > series.
> >
> > That isn't my reading of this thread.
> >
> > You have two options:
> > 1. extend drivetemp if that makes sense for this particular application.
> > 2. follow the model of other devices that happen to have a built-in
> > temperature sensor and expose the hwmon compatible attributes as a
> > subdevice
> >
> > It appears that option 1 isn't viable, so what about option 2?
> This will require to export the ufs device management commands,
> Which is privet to the ufs driver.
>
> This is not a viable option as well, because it will allow unrestricted access
> (Including format etc.) to the storage device.
>
> Sorry for not making it clearer before.

I should have clarified further: I meant having the UFS device
register a HWMON driver using this API:
https://www.kernel.org/doc/html/latest/hwmon/hwmon-kernel-api.html

*Not* writing a separate HWMON driver that uses some private interface.

Thanks,

-- 
Julian Calaby

Email: julian.calaby@gmail.com
Profile: http://www.google.com/profiles/julian.calaby/
