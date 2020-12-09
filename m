Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_2 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BD5ACC433FE
	for <linux-scsi@archiver.kernel.org>; Wed,  9 Dec 2020 22:07:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8D80823D1C
	for <linux-scsi@archiver.kernel.org>; Wed,  9 Dec 2020 22:07:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388424AbgLIWE4 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 9 Dec 2020 17:04:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50404 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388410AbgLIWEp (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 9 Dec 2020 17:04:45 -0500
Received: from mail-ej1-x643.google.com (mail-ej1-x643.google.com [IPv6:2a00:1450:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8961AC0613CF;
        Wed,  9 Dec 2020 14:04:04 -0800 (PST)
Received: by mail-ej1-x643.google.com with SMTP id n26so4414822eju.6;
        Wed, 09 Dec 2020 14:04:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=message-id:subject:from:to:cc:date:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=KbgQU9crSSKMI3WB4Hb7AvXbtn3o3JSe9ktRkCdRqIY=;
        b=POyEN/dsgfu2zRG3mv00xUXzVN2f4g8dTfAThMUG+K9hJ/iDpEo2Hg05IJyWUQsdA/
         SuIuJHGf0/We4B2vIouOng08tqghpKrGTzHZeRQxCiwI68wdIdDHuQSx9EaCHPMXL1R5
         VXSO+D+czQaCf4qcvCMgiGcvOsdH2b7Ox3+1gSu2CLF0nCa3VGSiOF2FsT1HuDFgPpF8
         1ojyin2AkfDiWIA1ElK3hbEbYSsT3XeF0+gqXtnHXvXaC0yLORVXGjHa3puh0/WsvU4T
         zrrKfRsDbxfkNfbwFvKpNDKypi45gBy18SXJlP5yQpUSFdqIVuVXP16Q1HpFswewhISH
         9Apg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=KbgQU9crSSKMI3WB4Hb7AvXbtn3o3JSe9ktRkCdRqIY=;
        b=Gdd8IG1CeCaJsTc0u85Ma+NQhKL3TYiW0CP5coUynQi5zjX5WxxSrJvXSCEO+EaTqM
         7i4eL/QGWFnKaaDYyUm0cljXViPDhN0VPQjK1mmM3Y39V5CEFTKfWqhQEarrPemJODyd
         cXMKMNjqGEIft/bg5E6ry0ZA4kJTAv+yx8FeWYj6v0EC0jlKK1fPh+gzLA4RtAA9LyZB
         eVFgoEqgfPl8OHh0RtxQFlvx9h4Toka1wSy2ib5mRPkzbpVTrS0f4lMESeK41c4SJFzW
         QqohQu8JvDT8jc4GjeLsmfXlyeHXrUX8t5PRaXtp6HWM/qmr4Hw0cHZjfVu2t2BavsU0
         0+Tg==
X-Gm-Message-State: AOAM532mv5twf/2jDQiB4AriuPme7UyMFzju0JYZv/NiZIi1AYaS0drU
        HLOjDptzzYdsCXuxplsjqts=
X-Google-Smtp-Source: ABdhPJy2qinC9zSv0AgbvyN91FLKOFuwEfaYAR4H40IjXSPEB1C9ITsg9aNnsOTFHgwF1Ua1XZNn+g==
X-Received: by 2002:a17:906:f9da:: with SMTP id lj26mr3727964ejb.467.1607551443327;
        Wed, 09 Dec 2020 14:04:03 -0800 (PST)
Received: from ubuntu-laptop (ip5f5bfce9.dynamic.kabel-deutschland.de. [95.91.252.233])
        by smtp.googlemail.com with ESMTPSA id z26sm3004027edl.71.2020.12.09.14.04.02
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 09 Dec 2020 14:04:02 -0800 (PST)
Message-ID: <c95e0518fd5c73dead0139054c04dda2243af620.camel@gmail.com>
Subject: Re: [PATCH v3 2/3] scsi: ufs: Keep device active mode only
 fWriteBoosterBufferFlushDuringHibernate == 1
From:   Bean Huo <huobean@gmail.com>
To:     Avri Altman <Avri.Altman@wdc.com>,
        "alim.akhtar@samsung.com" <alim.akhtar@samsung.com>,
        "asutoshd@codeaurora.org" <asutoshd@codeaurora.org>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "stanley.chu@mediatek.com" <stanley.chu@mediatek.com>,
        "beanhuo@micron.com" <beanhuo@micron.com>,
        "bvanassche@acm.org" <bvanassche@acm.org>,
        "tomas.winkler@intel.com" <tomas.winkler@intel.com>,
        "cang@codeaurora.org" <cang@codeaurora.org>
Cc:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date:   Wed, 09 Dec 2020 23:03:59 +0100
In-Reply-To: <DM6PR04MB6575B928898B319E8ACF1395FCCC0@DM6PR04MB6575.namprd04.prod.outlook.com>
References: <20201208210941.2177-1-huobean@gmail.com>
         <20201208210941.2177-3-huobean@gmail.com>
         <DM6PR04MB6575B928898B319E8ACF1395FCCC0@DM6PR04MB6575.namprd04.prod.outlook.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5-0ubuntu0.18.04.2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, 2020-12-09 at 07:40 +0000, Avri Altman wrote:
> > According to the JEDEC UFS 3.1 Spec, If
> > fWriteBoosterBufferFlushDuringHibernate
> > is set to one, the device flushes the WriteBooster Buffer data
> > automatically
> > whenever the link enters the hibernate (HIBERN8) state. While the
> > flushing
> > operation is in progress, the device should be kept in Active power
> > mode.
> > Currently, we set this flag during the UFSHCD probe stage, but we
> > didn't deal
> > with its programming failure. Even this failure is less likely to
> > occur, but
> > still it is possible.
> 
> How about reading it on every ufshcd_wb_need_flush?
> 
> Thanks,
> Avri


Hi Avri
I was using that way, no different from the current my way. Instead,
reading on every time will add some delay. As long as the UFS device
returns the successful, we assume that this flag has been properly
set.  so, just keeping is_hibern8_wb_flush if set, I think it is
enough.

Thanks,
Bean

