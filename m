Return-Path: <SRS0=lyXb=32=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D2BBFC2D0B1
	for <linux-scsi@archiver.kernel.org>; Thu,  6 Feb 2020 11:40:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9CFF720659
	for <linux-scsi@archiver.kernel.org>; Thu,  6 Feb 2020 11:40:06 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="J73kA2tt"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727518AbgBFLkG (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 6 Feb 2020 06:40:06 -0500
Received: from mail-lj1-f194.google.com ([209.85.208.194]:42025 "EHLO
        mail-lj1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726687AbgBFLkG (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 6 Feb 2020 06:40:06 -0500
Received: by mail-lj1-f194.google.com with SMTP id d10so5741269ljl.9;
        Thu, 06 Feb 2020 03:40:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=E/x3i/iaulUnT8LXM/M4q99+Z5/PyLR5bOHEeAbYoCA=;
        b=J73kA2ttGCREeSDP0w5WrBQcGL8kjwkCxPTMplLgzz2Q4XchBJipcRskkUjlhCxa5F
         zieZyUAhxHq2ZN6aoR9zsL1sug0ULnSi8aZmcHdxfyhhYXMyb+KcEKyoSYlr6KPAHRSP
         85BjMnAlRHiV/CFg/uMiJpiRdEXRiqeqCiPdVX5A8MeQrNr1kyUnrxH5JNS9EBSzTIVi
         3l0vy8By15ATWwYwYgIXFh6KRDMlDfN3votuYai3yIvbAs6KxZ43SztWT/rPPfbOhzrX
         VHm2CUgUdep7WqCHWQrCj8QYLxcu3gDiG2qHgPcgUsoUlMvI/PuKJeySUNYkGopKQGDt
         co2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=E/x3i/iaulUnT8LXM/M4q99+Z5/PyLR5bOHEeAbYoCA=;
        b=KVRD93GegjZKQXaQSPXSOMbZbKO/L5F6qmJmnBrV+CBFghvumt7QToZNBwRFdWuXyw
         JyDQ0Tj44hYgUGSYr+vfIL4iQ7L34AO8Q8EFZb4P0RqiTXhgTxe3/X2gK/vr79jhOilD
         GapNUTy4sUWJ5LR42aD0Tr7IOXp4yN624M5aS7miwidFYTlGIVTfT4kTyT9c4rUEVIx/
         1DPAI4tJc4MyrVXlz8yUsGTrfiJ8/nxKcTNsFQL7KRMGV/32nB91PbwW4SwTGyuSa0uY
         KfIpt5M/AVVJnLiwYuCFzxfpsdbfmt3j51s/7ycCG/8QSQfc+U3a9WVrde5VpocB8AQ8
         CoDw==
X-Gm-Message-State: APjAAAVTyr1ugBQdZSanXvwcQ8p7M/EuyQnlHAibDNV3HapzBn0o8cKV
        DIUkFv05O6htgEHetwsw/d3vm/4ZsVbU3bDjpmU=
X-Google-Smtp-Source: APXvYqxaXS2uIYYnKJrLyakdJf/slPOALwxpfHuy9wdGmf2aukH5k3neOFBVsWndmjUrgHwMGQBz/geNhd+16tE3vI0=
X-Received: by 2002:a2e:b007:: with SMTP id y7mr1693153ljk.215.1580989203944;
 Thu, 06 Feb 2020 03:40:03 -0800 (PST)
MIME-Version: 1.0
References: <1580640419-6703-1-git-send-email-avi.shchislowski@wdc.com>
 <20200202192105.GA20107@roeck-us.net> <MN2PR04MB61906E820FAF0F17082D53AE9A000@MN2PR04MB6190.namprd04.prod.outlook.com>
 <94cb1e97-18ed-ebec-23c2-b4d87434726a@roeck-us.net> <MN2PR04MB69910152F14A7D481029E4ECFC000@MN2PR04MB6991.namprd04.prod.outlook.com>
 <20200203214733.GA30898@roeck-us.net> <BY5PR04MB69809A3BEFD629A67FB563CDFC030@BY5PR04MB6980.namprd04.prod.outlook.com>
 <MN2PR04MB6190D9E63717D37285DADBB09A1D0@MN2PR04MB6190.namprd04.prod.outlook.com>
In-Reply-To: <MN2PR04MB6190D9E63717D37285DADBB09A1D0@MN2PR04MB6190.namprd04.prod.outlook.com>
From:   Julian Calaby <julian.calaby@gmail.com>
Date:   Thu, 6 Feb 2020 22:39:52 +1100
Message-ID: <CAGRGNgWG2fvY33j0m00SkguU8N4TJttY4KeNtOxZ7HzTTXA=yw@mail.gmail.com>
Subject: Re: [PATCH 0/5] scsi: ufs: ufs device as a temperature sensor
To:     Avi Shchislowski <Avi.Shchislowski@wdc.com>
Cc:     Avri Altman <Avri.Altman@wdc.com>,
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

Hi Avi,

On Thu, Feb 6, 2020 at 9:48 PM Avi Shchislowski
<Avi.Shchislowski@wdc.com> wrote:
>
> As it become evident that the hwmon is not a viable option to implement ufs thermal notification, I would appreciate some concrete comments of this series.

That isn't my reading of this thread.

You have two options:
1. extend drivetemp if that makes sense for this particular application.
2. follow the model of other devices that happen to have a built-in
temperature sensor and expose the hwmon compatible attributes as a
subdevice

It appears that option 1 isn't viable, so what about option 2?

Thanks,

-- 
Julian Calaby

Email: julian.calaby@gmail.com
Profile: http://www.google.com/profiles/julian.calaby/
