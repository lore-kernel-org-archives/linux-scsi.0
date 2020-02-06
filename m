Return-Path: <SRS0=lyXb=32=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.0 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 167E9C352A2
	for <linux-scsi@archiver.kernel.org>; Thu,  6 Feb 2020 20:42:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D36FD21927
	for <linux-scsi@archiver.kernel.org>; Thu,  6 Feb 2020 20:42:24 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="vfyUCEYv"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727918AbgBFUmW (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 6 Feb 2020 15:42:22 -0500
Received: from mail-pl1-f195.google.com ([209.85.214.195]:37708 "EHLO
        mail-pl1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727698AbgBFUmV (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 6 Feb 2020 15:42:21 -0500
Received: by mail-pl1-f195.google.com with SMTP id c23so37093plz.4;
        Thu, 06 Feb 2020 12:42:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=fFfXRy75SE2j99TG+GoZCaMqB60SsrG/AWbtbzm954o=;
        b=vfyUCEYvfOWSkNNXqfG/5nISqzUTck+tjMPtcs9vkWIAwYR4PdMEd2JPuBPLk3MRBP
         iB0DV7pGMZ30CksONlqCvv1BhUdPCTUfEoONuxoYlXI877TJmACrWBjuV1Q1eYqWyPyg
         Pe8JauYeCeL2JEdhxNQHhs+pTQzIefbdBcP0VvQrT03GoO7TDWKVsOT7H7Q12FxJKI02
         v3fkL4B1XNKYB18u6Yq0V9JLfS+TIG0xaUrUKtyEO85BxS5rNjR8sRX3ReI2Ex3JtGiK
         GZgSPvO9NTJButHxyHjhe5vOCD4gPm+OaTsheqZtKNaTOt8c34y/Q5BsJ+ulB/j9MmXo
         bkxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=fFfXRy75SE2j99TG+GoZCaMqB60SsrG/AWbtbzm954o=;
        b=GXp9KUYQQ6+avp5MCpfg4grHUabkny3mOn9cz+LKxBPLh6z6bacRPbx8f3vrW1qqmO
         PPJjG9Ix1r3gkLBbpX3bvvqqw2Ry6tt+NGsXf8b7x8apxC/F2D7H25CzdrMy7NIa69bI
         cjO+NNc6IwUMGsJ37Gl6NAiLXB4fGPMgxoz/jnKbrrX7n3TRtD0kDpqC1pX9bXFhMPm1
         7JUjtiNgZAwYe4eE9YehXRXyLbkGhzabAwCZUIYx20e/58ggxu87yG97o65onJXeIlnu
         x2LSq2Juf0vIpriwCmFvh8oiCBbe38nFApvJPyOOAFlpJopjlmIyIGZy/G6n3CfVUXzn
         1BSQ==
X-Gm-Message-State: APjAAAU63msMm0ZnaWQq9IGmrimM2LpBKo7nfu6gAm5Drc6qBEwtu39c
        qeojd+a1qdU+jy9mTD/XySk=
X-Google-Smtp-Source: APXvYqx5yR2ZczceH5wIR6HuJ+bErQxHhRXOcOq0d+aG9E/CJcFKyjSK7GF7CCEhOml3smJinBJ1mQ==
X-Received: by 2002:a17:902:9890:: with SMTP id s16mr5737406plp.71.1581021740994;
        Thu, 06 Feb 2020 12:42:20 -0800 (PST)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id b12sm287311pfr.26.2020.02.06.12.42.19
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 06 Feb 2020 12:42:20 -0800 (PST)
Date:   Thu, 6 Feb 2020 12:42:19 -0800
From:   Guenter Roeck <linux@roeck-us.net>
To:     Avri Altman <Avri.Altman@wdc.com>
Cc:     Julian Calaby <julian.calaby@gmail.com>,
        Avi Shchislowski <Avi.Shchislowski@wdc.com>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Subject: Re: [PATCH 0/5] scsi: ufs: ufs device as a temperature sensor
Message-ID: <20200206204218.GA23857@roeck-us.net>
References: <MN2PR04MB69910152F14A7D481029E4ECFC000@MN2PR04MB6991.namprd04.prod.outlook.com>
 <20200203214733.GA30898@roeck-us.net>
 <BY5PR04MB69809A3BEFD629A67FB563CDFC030@BY5PR04MB6980.namprd04.prod.outlook.com>
 <MN2PR04MB6190D9E63717D37285DADBB09A1D0@MN2PR04MB6190.namprd04.prod.outlook.com>
 <CAGRGNgWG2fvY33j0m00SkguU8N4TJttY4KeNtOxZ7HzTTXA=yw@mail.gmail.com>
 <MN2PR04MB6991848EBC8DED439FCD7C49FC1D0@MN2PR04MB6991.namprd04.prod.outlook.com>
 <CAGRGNgUA=LHbWqZY+hsYjfsTbyftc3uoGv6S3p8E4zPQyqsOGQ@mail.gmail.com>
 <MN2PR04MB699190E3474F82BEF9B91A58FC1D0@MN2PR04MB6991.namprd04.prod.outlook.com>
 <CAGRGNgWob+0t35AYXfzCqKtLjBgw=p8MhqDCKF=5_JGe5veqtQ@mail.gmail.com>
 <MN2PR04MB699192FB02C86DE567785A83FC1D0@MN2PR04MB6991.namprd04.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <MN2PR04MB699192FB02C86DE567785A83FC1D0@MN2PR04MB6991.namprd04.prod.outlook.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, Feb 06, 2020 at 07:32:12PM +0000, Avri Altman wrote:
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

You have established nothing. What exactly is not an option ?
To create alarm attributes ? No one forces you to create any of those
if you don't want to.

> 
> > 
> > thermal_notify_framework() is a way to notify the "other side" of a
> > thermal zone to do something to reduce the temperature of that zone.
> > E.g. spin up a fan or switch to a lower-power state to cool a CPU.
> > Looking at your code, you're only implementing the "sensor" side of
> > the thermal zone functionality, so your calls to
> > thermal_notify_framework() won't do anything.
> Right.  The thermal core allows to react to such notifications,
> Provided that the thermal zone device has a governor defined,
> And/or notify ops etc.
> 
> Should the current patches implement those callbacks or not,
> Can be discussed during their review process.
> But the important thing is that the thermal core support it in an intuitive and simple way,
> While the hwmon doesn't.
> 
> We are indifference with respect of which subsystem to use.

Not really. Quite the opposite; you are quite obviously heavily
opposed to a hwmon driver.

> The thermal core was our first choice because we bumped into it,
> Looking for a way to raise thermal exceptions.
> It provides the functionality we need, and other devices uses it,
> Why the insistence not to use it?
> 

As mentioned before, the hwmon subsystem lets you create a bridge
to the thermal subsystem, it creates standard attributes to report
temperatures instead of the private ones your patch provides,
and it would result in simpler code.

Why the insistence to _not_ use the hwmon subsystem ?

Guenter
