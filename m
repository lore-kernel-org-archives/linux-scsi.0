Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 995C0C3A5A7
	for <linux-scsi@archiver.kernel.org>; Thu,  1 Dec 2022 23:33:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231288AbiLAXdf (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 1 Dec 2022 18:33:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59368 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232021AbiLAXdS (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 1 Dec 2022 18:33:18 -0500
Received: from mail-io1-xd32.google.com (mail-io1-xd32.google.com [IPv6:2607:f8b0:4864:20::d32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 14D939C602
        for <linux-scsi@vger.kernel.org>; Thu,  1 Dec 2022 15:33:05 -0800 (PST)
Received: by mail-io1-xd32.google.com with SMTP id n188so2120767iof.8
        for <linux-scsi@vger.kernel.org>; Thu, 01 Dec 2022 15:33:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=/F+CzXM67pZ6FwLYmRhadn93ZfRJjwdiZT8cLm8mwck=;
        b=emA2qlXO2an42eHY2SLSOzdZDNxzb7yUPGxmXbfhM/KIKNqnUiXcpVjkUGfRRzMcB5
         yJZwCVvgA9u2WwUuZyzbkr2OMIJReve4sfAGceGwczMXUqk2rr5Rosdt0+EZgfercRyi
         v2phsXe7uf24chU7LeIH6W/ljCoKtgD+B04hU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=/F+CzXM67pZ6FwLYmRhadn93ZfRJjwdiZT8cLm8mwck=;
        b=uDC/Vy7iEz94Fl9dRiAi3WzXWaK/qGYt7XIC6Z3ERdqxKw/VuKXE7Ivs45e45bO/rQ
         d742N65EiPmWEi/jUz3ItE4Hx11R5+QcJ9Li374FjFw97e4/yV+PSYWUKrmU9riVJLdv
         N7qn4cNAyWkHRStWLgwHgfBwZmMLy2GF37XulBUnornVsuJmOStIkekAVBNWkcMSPb6y
         ybL313gxMP70zAJMVZtnlbnr9AviWK6H6GLmFqw+Yzgn+8pat7mAL39fVccKcoPjlBY6
         kjUsN9wS3r2CX4gOCcSezS83sPbEMfX5f5+vfskJv7Q1I5zHkmuWeWvIgWM+1aMZ/pI9
         6hXA==
X-Gm-Message-State: ANoB5pkOzFEihJPjUfIWP+3c1wXsSAcbaZ4i0fZWZBcaiirt0ZzNn6Fs
        dMLC0KnbbqtZ08HjkLD0tMeDlm6KUucu0GWNpTg4oA==
X-Google-Smtp-Source: AA0mqf71yu2oELmppvrcvNk/0n9zFUKtJwMc9lGxI/HXhZleYOTd+laB/qRays/rTen1+zjk5nzHWF407FcnpvMdzYw=
X-Received: by 2002:a05:6638:1a98:b0:375:61b2:825a with SMTP id
 ce24-20020a0566381a9800b0037561b2825amr33367959jab.147.1669937584511; Thu, 01
 Dec 2022 15:33:04 -0800 (PST)
MIME-Version: 1.0
References: <20221101142410.31463-1-peter.wang@mediatek.com>
 <98bfafd3-c7b7-89b5-497a-aa694d0152dd@intel.com> <5e00ce60-3859-4964-11f7-e036f6dda56a@acm.org>
In-Reply-To: <5e00ce60-3859-4964-11f7-e036f6dda56a@acm.org>
From:   Daniil Lunev <dlunev@chromium.org>
Date:   Fri, 2 Dec 2022 10:32:53 +1100
Message-ID: <CAONX=-e1NA--3taTmfbUV+hR_LOSqvBqz_=1mPmYZWaKGGR=ig@mail.gmail.com>
Subject: Re: [PATCH v1] ufs: core: wlun suspend SSU fail recovery
To:     Bart Van Assche <bvanassche@acm.org>
Cc:     Adrian Hunter <adrian.hunter@intel.com>, peter.wang@mediatek.com,
        stanley.chu@mediatek.com, linux-scsi@vger.kernel.org,
        martin.petersen@oracle.com, avri.altman@wdc.com,
        alim.akhtar@samsung.com, jejb@linux.ibm.com,
        wsd_upstream@mediatek.com, linux-mediatek@lists.infradead.org,
        chun-hung.wu@mediatek.com, alice.chao@mediatek.com,
        cc.chou@mediatek.com, chaotian.jing@mediatek.com,
        jiajie.hao@mediatek.com, powen.kao@mediatek.com,
        qilin.tan@mediatek.com, lin.gui@mediatek.com,
        tun-yu.yu@mediatek.com, eddie.huang@mediatek.com,
        naomi.chu@mediatek.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, Dec 1, 2022 at 4:50 AM Bart Van Assche <bvanassche@acm.org> wrote:
>
> On 11/30/22 02:17, Adrian Hunter wrote:
> > On 1/11/22 16:24, peter.wang@mediatek.com wrote:
> >> From: Peter Wang <peter.wang@mediatek.com>
> >>
> >> When SSU fail in wlun suspend flow, trigger error handlder and
> >
> > handlder -> handler
> >
> > Why / how does SSU fail?
>
> I'm not sure but the issue that Peter is trying to fix with this patch
> may already have been fixed by my patch series "Fix a deadlock in the
> UFS driver".

We observe a similar failure scenario when a device tries to change
power mode (e.g. due to autosuspend) while "purge" is in progress. It
appears that in this case the "pm_only" counter is increased on the
device queue prior to the attempt of entering a runtime suspended
state, but not reduced upon it failing due to the device being busy
with an ongoing purge. That leads to a deadlock of subsequent IO
operations to the device.

--Daniil
