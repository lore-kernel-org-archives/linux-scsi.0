Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BA8D8C43334
	for <linux-scsi@archiver.kernel.org>; Mon, 25 Jul 2022 02:11:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233163AbiGYCLg (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 24 Jul 2022 22:11:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37508 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232979AbiGYCLf (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 24 Jul 2022 22:11:35 -0400
Received: from mail-lf1-x134.google.com (mail-lf1-x134.google.com [IPv6:2a00:1450:4864:20::134])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7762FF5A5
        for <linux-scsi@vger.kernel.org>; Sun, 24 Jul 2022 19:11:34 -0700 (PDT)
Received: by mail-lf1-x134.google.com with SMTP id b16so3563988lfb.7
        for <linux-scsi@vger.kernel.org>; Sun, 24 Jul 2022 19:11:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=yezHjwgPoaOH6sKFBjWOYwIIAgJfYYzFB6mHvxAdSns=;
        b=Yr7Kf0kP1c1AudVOG7DafT3nig3V/eJCouHxXsPNRqTS9417uaWRbOXTVR6dv0f+O6
         5rOOIo1uf6PKwT/aRtTOraTiBoE+SsZOkBz3HOrmjooRvSYfFhiIYzOp++ifFEXDyfXF
         ZBB58mG/xhASR3zPVdKrc6ZR9DHr8Ycx0OQ0jOuDSd71H7ZBBTMwqIv1ErYMetA4oZUC
         hM/eshEUDjaQ1El9f5Vm6IXob1Q3bdTTxKAkg9vclEdIZaga3M1Vp6iNqLpnYpRxM6bd
         Hw974KufOsTZ5RlA++J1ztouUT76B4r8ZnZ+QGBuVWQudCeDNNE3U3QE5LIufMWCTEO4
         nPOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=yezHjwgPoaOH6sKFBjWOYwIIAgJfYYzFB6mHvxAdSns=;
        b=Iz9ciV5IcxSnP5d4NDb0yhL/K1Qh0qyCcqtNH3K338IZkfj2ICjOBMIwB3O2llIva/
         IQz9XiCeUgGDZNK+Y2J8v8zJutQ7eV9oJYU6ce+TlJxuptyXj6NWczYqIA3mzlisUY1/
         N1c0mbnr0Z6cdCnKsWOc9+t6vlD5yKkf5RNRoeybSkrAtUb9/WpmLu/yXRKSZMtlVtnK
         19Z+JbuPZYQ1dCPo8qU7JRMn0x4Twd8dGObH5Ll8plvkbj8G2Cil9ZGEYDRnYQy3hDEm
         0mpKUJE/MMBfOdlPOxMinVfHAtCHy6N6hOsRynwNbjAYUFqV/p1wQh/k7XeY3gfQSDKM
         e7fg==
X-Gm-Message-State: AJIora8gDdB6KKZZ6ktAlsKzjlFA5XGEptQbHG7cPVO/w0UazxBRC/dy
        Eq53mBcNYeKWQ73htZCk0BGUPxjE0LP7/qDU4Q==
X-Google-Smtp-Source: AGRyM1v1d0TKvlXD00AW4RAezRiyl0Jz+66+KOzoApRSsoxmBnebxvzlAZUkGI/prNqeAvW49t+9y60EsIuVRufmmaI=
X-Received: by 2002:a05:6512:e83:b0:489:e7de:56ea with SMTP id
 bi3-20020a0565120e8300b00489e7de56eamr4284325lfb.591.1658715092412; Sun, 24
 Jul 2022 19:11:32 -0700 (PDT)
MIME-Version: 1.0
References: <20220721065833.26887-1-peter.wang@mediatek.com> <2f66f4ba-f0d5-6b8a-cc3b-fa896a302d60@acm.org>
In-Reply-To: <2f66f4ba-f0d5-6b8a-cc3b-fa896a302d60@acm.org>
From:   Stanley Chu <chu.stanley@gmail.com>
Date:   Mon, 25 Jul 2022 10:11:20 +0800
Message-ID: <CAGaU9a8w3U8P_uivpqzuyWaw4FAWOTogrT2R-t_THaz65keVzQ@mail.gmail.com>
Subject: Re: [PATCH v3] scsi: ufs: correct ufshcd_shutdown flow
To:     Bart Van Assche <bvanassche@acm.org>
Cc:     peter.wang@mediatek.com, Stanley Chu <stanley.chu@mediatek.com>,
        linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Avri Altman <avri.altman@wdc.com>, alim.akhtar@samsung.com,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        wsd_upstream@mediatek.com, linux-mediatek@lists.infradead.org,
        chun-hung.wu@mediatek.com, alice.chao@mediatek.com,
        cc.chou@mediatek.com, chaotian.jing@mediatek.com,
        jiajie.hao@mediatek.com, powen.kao@mediatek.com,
        qilin.tan@mediatek.com, lin.gui@mediatek.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Sat, Jul 23, 2022 at 5:15 AM Bart Van Assche <bvanassche@acm.org> wrote:
>
> On 7/20/22 23:58, peter.wang@mediatek.com wrote:
> > Both ufshcd_shtdown and ufshcd_wl_shutdown could run concurrently.
> > And it have race condition when ufshcd_wl_shutdown on-going and
> > clock/power turn off by ufshcd_shutdown.
> >
> > The normal case:
> > ufshcd_wl_shutdown -> ufshcd_shtdown
> > ufshcd_shtdown should turn off clock/power.
> >
> > The abnormal case:
> > ufshcd_shtdown -> ufshcd_wl_shutdown
>
> How can this happen since device_shutdown() iterates over devices in the
> opposite order in which these have been created?
>

Is it possible for more than one initiator to invoke
kernel_power_off() at the same time?

In this case, the order of device shutdown is not promised anymore
because devices_kset is manipulated simultaneously by multiple
initiators in device_shutdown().

> Thanks,
>
> Bart.
