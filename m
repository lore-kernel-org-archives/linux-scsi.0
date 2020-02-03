Return-Path: <SRS0=0hmW=3X=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.1 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 426F2C35247
	for <linux-scsi@archiver.kernel.org>; Mon,  3 Feb 2020 21:47:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1686D20CC7
	for <linux-scsi@archiver.kernel.org>; Mon,  3 Feb 2020 21:47:40 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="qa78Up9/"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726834AbgBCVrg (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 3 Feb 2020 16:47:36 -0500
Received: from mail-pg1-f193.google.com ([209.85.215.193]:36950 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726287AbgBCVrg (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 3 Feb 2020 16:47:36 -0500
Received: by mail-pg1-f193.google.com with SMTP id z12so1575629pgl.4;
        Mon, 03 Feb 2020 13:47:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=RGNVxrU90gISQofDn3ld3ulUbE2HDozF3FT41GjKBOc=;
        b=qa78Up9/k/3UtY77zjTlle9nc7P1UzT1c2Cra4u53D3tWHUfXRBDjHKOK0h2wdB/+E
         krKxMv0aEhkqw4D2Bd86u2p7t6ZNiQhHxQBhOtYjQv++Mwfl1c386MfpxMJosK4pWhIe
         QNVPapK20oJaX+uc113uolkfTu4dSD4z4bz48PxwUyCRotTBth1ZBVb9gI4Vy2o8KjI6
         TgYU6oS7wUtYNquVXi/+6A/xEztrcZFdSDW5/avgoK7+sVSzm92E1ruIT1uDl3KxwfPf
         ILIJqCmgoOK+i1qojy/rS3a7V29Rg2GVQpx3YOAsPGpv28UeSIhLURuYLrfpswk02ymq
         Ux2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=RGNVxrU90gISQofDn3ld3ulUbE2HDozF3FT41GjKBOc=;
        b=EWXJcqYf247iPB8zdoJS/VHKCSCFFxdOessYzfm8oXXZyaeg4rj573IufRSqthUjSr
         K1p8Yo4MUMPjopmvClPryzOewIEZdJ87IWLb0JCWGiAp+oJu6ijfruUeipdFJ6ZiBDWn
         lheaunyHiV4ltr/DgWqNnIxDYGYLBP+fscOwmnZIhzSTJf6fS03OowxNdI+aLBSuTEhh
         YZ55E/1xfp7kn+Z3ZoMqtexKQkMxY5LfKzgCrByQbjvw40wRpggdaTOg3u/D1fNkKoJY
         qiqoZWy4mEY69X4Mi5MJ3Hnv3dHkxanGoUjSmHNviP5Gh3LsU3/s/EmqW5EwDu5PqdfZ
         g1Hw==
X-Gm-Message-State: APjAAAWNxwCoqOICbppu4zX8tZQtoga/wz8j/fZsroTH98QtuBkRTPln
        +zI+eK18iJg4RvjBV+w/PaE=
X-Google-Smtp-Source: APXvYqyjUfzLm+Q3qDlGxlZuviDk2X8CFeFvuvTWdk95tuY0fIoPryKCEAm5fnULaH6i7VA/T3yCIQ==
X-Received: by 2002:a17:902:694b:: with SMTP id k11mr25457304plt.334.1580766455323;
        Mon, 03 Feb 2020 13:47:35 -0800 (PST)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id m101sm430819pje.13.2020.02.03.13.47.33
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 03 Feb 2020 13:47:34 -0800 (PST)
Date:   Mon, 3 Feb 2020 13:47:33 -0800
From:   Guenter Roeck <linux@roeck-us.net>
To:     Avri Altman <Avri.Altman@wdc.com>
Cc:     Avi Shchislowski <Avi.Shchislowski@wdc.com>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Subject: Re: [PATCH 0/5] scsi: ufs: ufs device as a temperature sensor
Message-ID: <20200203214733.GA30898@roeck-us.net>
References: <1580640419-6703-1-git-send-email-avi.shchislowski@wdc.com>
 <20200202192105.GA20107@roeck-us.net>
 <MN2PR04MB61906E820FAF0F17082D53AE9A000@MN2PR04MB6190.namprd04.prod.outlook.com>
 <94cb1e97-18ed-ebec-23c2-b4d87434726a@roeck-us.net>
 <MN2PR04MB69910152F14A7D481029E4ECFC000@MN2PR04MB6991.namprd04.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <MN2PR04MB69910152F14A7D481029E4ECFC000@MN2PR04MB6991.namprd04.prod.outlook.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, Feb 03, 2020 at 09:29:57PM +0000, Avri Altman wrote:
> > >> Can you add an explanation why this can't be added to the just-
> > introduced
> > >> 'drivetemp' driver in the hwmon subsystem, and why it make sense to
> > have
> > >> proprietary attributes for temperature and temperature limits ?
> 
> 
> Guenter hi,
> Yeah - I see your point. But here is the thing - 
> UFS devices support only a subset of scsi commands.
> It does not support ATA_16 nor SMART attributes.
> Moreover, you can't read UFS attributes using any other scsi/ATA/SATA
> Commands, nor it obey the ATA temperature sensing conventions.
> So unless you want to totally break the newly born drivetemp - 
> Better to leave ufs devices out of it.
> 

drivetemp is written with extensibility in mind. For example, Martin has a
prototype enhancement which supports SCSI drive temperature sensors. 
As long as a device can be identified as ufs device, and as long as there
is a means to pass-through commands, adding a new type would be easy.

> Another option is to put a ufs module under hwmon.
> Do you see why would that be more advantageous to using the thermal core?
> Provided that you are not going to deprecate it (Intel's wifi card is still using it)...
> 

Deprecate what, and what does this discussion have to do with Intel's wifi
card ?

Either case, the hardware monitoring subsystem provides standard attributes,
and it provides a bridge to the thermal subsystem. The question should be
why _not_ to use the hwmon subsystem, and this question should be answered
as part of this patch series.

Guenter
