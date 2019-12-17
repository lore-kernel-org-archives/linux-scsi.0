Return-Path: <SRS0=0Ioj=2H=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.1 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D714BC2D0CD
	for <linux-scsi@archiver.kernel.org>; Tue, 17 Dec 2019 15:47:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A87E42465E
	for <linux-scsi@archiver.kernel.org>; Tue, 17 Dec 2019 15:47:11 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Rqk/w/lO"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727843AbfLQPrI (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 17 Dec 2019 10:47:08 -0500
Received: from mail-pl1-f193.google.com ([209.85.214.193]:38565 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726191AbfLQPrH (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 17 Dec 2019 10:47:07 -0500
Received: by mail-pl1-f193.google.com with SMTP id f20so4516041plj.5;
        Tue, 17 Dec 2019 07:47:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=vOtwYzlf5BFOGPS2i3uFK7gceSiUI5q9A1BDB60vRjo=;
        b=Rqk/w/lOd9uHLGdW1G/qZzQfTemaMfGD4hQOOtBGTgUWHKhRZNu3P9rjW1IsUJgzdt
         G5aOMQVpp3oilAUveyqVWlgwEydUiDkWMRCZoCWgmBll1Dmck30d/HVzJO2rI0su7TyQ
         f1hr5Gtnt8TaHLZkHpF+JmIo6TJu/UJ9B92NvHn1YrBXLZJdhV0uRBvXZfttZKC1Uukp
         fgpUUI5HnfVo/cvULo2C8aWxZAUrDHMtZHUg1JyRIbJqYrQM7Cl1bXMNmACW4IVloUEv
         EJJTd1XpWzKBqxSjnWUiZS7dSrXeR97UHEVbcgQZS1cYNIsSDIMyF5tX+5CQZFZUmjQw
         h9bA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=vOtwYzlf5BFOGPS2i3uFK7gceSiUI5q9A1BDB60vRjo=;
        b=P0M3jdupyS4eBy9G5K1XJurJpb0SuzVKShz3KXovVgysgNhQbKKDD8T6GI8e4xTgjj
         tTx94q5oIDqvgTGeB8ZamTZKYkwK+Cxq3jqCGnqcdKOSPHE58rdkRDrH4Oyy72eZJSSo
         gMwAc65J8w/bHMRjmkSThBUKcdFcVF5H/WHPgWAiSemc0OKDh6shIgyicSyw1jk5GcYE
         2t87ewV+ZppWLs/7BVv6Z4WWSHLNh+dy+6lK+mvReiCUHKEmE1mqZLzsp6mqZAvUX6+f
         A6bAn7uMA2RoZq0CIJiGqqs+98c3NRhGQ2cuJ9eu4J7dnoiXXRJNSUkVGiUY15wiRhIY
         gizw==
X-Gm-Message-State: APjAAAXlg8mfrXSzsf5Oyq/PuUZsdLdVWA8b+M1luda1HxPDQeVhj4oO
        2PtfSWbkbblSo9LGoBwadhE=
X-Google-Smtp-Source: APXvYqwAMrF5r62qmk0u1vRjUs5ls5a3I5G16sxctobohr3j5fkV44s5Ng4U89e82VuPRn7IcUEXhQ==
X-Received: by 2002:a17:90a:a010:: with SMTP id q16mr6994619pjp.115.1576597626942;
        Tue, 17 Dec 2019 07:47:06 -0800 (PST)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id u1sm26067232pfn.133.2019.12.17.07.47.05
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 17 Dec 2019 07:47:06 -0800 (PST)
Date:   Tue, 17 Dec 2019 07:47:04 -0800
From:   Guenter Roeck <linux@roeck-us.net>
To:     Damien Le Moal <Damien.LeMoal@wdc.com>
Cc:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        "linux-hwmon@vger.kernel.org" <linux-hwmon@vger.kernel.org>,
        Jean Delvare <jdelvare@suse.com>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>
Subject: Re: [PATCH 0/1] Summary: hwmon driver for temperature sensors on
 SATA drives
Message-ID: <20191217154704.GA32673@roeck-us.net>
References: <20191209052119.32072-1-linux@roeck-us.net>
 <yq15zinmrmj.fsf@oracle.com>
 <67b75394-801d-ce91-55f2-f0c0db9cfffc@roeck-us.net>
 <yq1y2vbhe6i.fsf@oracle.com>
 <83d528fc-42b7-aa3f-5dd9-a000268da38e@roeck-us.net>
 <BYAPR04MB5816CA0C1CAFC21F7955F79FE7500@BYAPR04MB5816.namprd04.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BYAPR04MB5816CA0C1CAFC21F7955F79FE7500@BYAPR04MB5816.namprd04.prod.outlook.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, Dec 17, 2019 at 05:50:17AM +0000, Damien Le Moal wrote:
> On 2019/12/17 12:57, Guenter Roeck wrote:
> > On 12/16/19 6:35 PM, Martin K. Petersen wrote:
> >>
> >> Guenter,
> >>
> >>> If and when drives are detected which report bad information, such
> >>> drives can be added to a blacklist without impact on the core SCSI or
> >>> ATA code. Until that happens, not loading the driver solves the
> >>> problem on any affected system.
> >>
> >> My only concern with that is that we'll have blacklisting several
> >> places. We already have ATA and SCSI blacklists. If we now add a third
> >> place, that's going to be a maintenance nightmare.
> >>
> >> More on that below.
> >>
> >>>> My concerns are wrt. identifying whether SMART data is available for
> >>>> USB/UAS. I am not too worried about ATA and "real" SCSI (ignoring RAID
> >>>> controllers that hide the real drives in various ways).
> >>
> >> OK, so I spent my weekend tinkering with 15+ years of accumulated USB
> >> devices. And my conclusion is that no, we can't in any sensible manner,
> >> support USB storage monitoring in the kernel. There is no heuristic that
> >> I can find that identifies that "this is a hard drive or an SSD and
> >> attempting one of the various SMART methods may be safe". As opposed to
> >> "this is a USB key that's likely to lock up if you try". And that's
> >> ignoring the drives with USB-ATA bridges that I managed to wedge in my
> >> attempt at sending down commands.
> >>
> >> Even smartmontools is failing to work on a huge part of my vintage
> >> collection.  Thanks to a wide variety of bridges with random, custom
> >> interfaces.
> >>
> >> So my stance on all this is that I'm fine with your general approach for
> >> ATA. I will post a patch adding the required bits for SCSI. And if a
> >> device does not implement either of the two standard methods, people
> >> should use smartmontools.
> >>
> >> Wrt. name, since I've added SCSI support, satatemp is a bit of a
> >> misnomer. drivetemp, maybe? No particular preference.
> >>
> > Agreed, if we extend this to SCSI, satatemp is less than perfect.
> > drivetemp ? disktemp ? I am open to suggestions, with maybe a small
> > personal preference for disktemp out of those two.
> 
> "disk" tend to imply HDD, excluding SSDs. So my vote goes to
> "drivetemp", or even the more generic, "devtemp".
> 
"devtemp" would apply to all devices with temperature sensors, which
would be a bit too generic. I'll take that as a vote for "drivetemp".

Guenter
