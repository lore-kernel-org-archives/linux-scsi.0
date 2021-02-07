Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_2 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 76714C433DB
	for <linux-scsi@archiver.kernel.org>; Sun,  7 Feb 2021 10:45:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 497F464E49
	for <linux-scsi@archiver.kernel.org>; Sun,  7 Feb 2021 10:45:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229548AbhBGKpm (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 7 Feb 2021 05:45:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54368 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229522AbhBGKpk (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 7 Feb 2021 05:45:40 -0500
Received: from mail-ej1-x62a.google.com (mail-ej1-x62a.google.com [IPv6:2a00:1450:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 08D2DC06174A;
        Sun,  7 Feb 2021 02:45:00 -0800 (PST)
Received: by mail-ej1-x62a.google.com with SMTP id hs11so20122831ejc.1;
        Sun, 07 Feb 2021 02:44:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=message-id:subject:from:to:cc:date:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=3IGbIM3G5/TPBw50jfxVOTum5oKaSu4oHa8fy1eVeCg=;
        b=ZhqUx+/OVXJaazlJ1KTjrpIlkFBKBh6euygDDz7fw5of/OoOAD8j+nf/p+Ct6QPme8
         Az0TXMycKD7OMzgMg225sA18v3cgMjSqbV0wrisZ2cGLpx5vCwtqFP01XAObDPolrz1T
         gT3ZuDIW7I+Nqw5wBooMvVvqQBefSutMhLqZmMqIgzFkcq3acZgfEAmiklzgOnA7A67p
         Ru0Q12A6O83Jz/4Lt+zpcTfs4k7+HbInuL4YZkXgDo9iQLViw0eXOnmsr5cTWunoPXqO
         swpHArmO/6iNilkvtFKkLXBtTkCJrvx5wXSGoxVztnVobcbgTaVm7n49CGIp5SwcOaqT
         wqAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=3IGbIM3G5/TPBw50jfxVOTum5oKaSu4oHa8fy1eVeCg=;
        b=h/PeTNCAz28dTIiNAFw8pgoOZsvB+IPDJ9kp/buPB0DMndI1DJM05dMR538He1TgXh
         J/s9gqu9irhg+3lWIoIOLEcRtdUvSmFq4UaZdhFDGX3GMSckiDcf6/poMkR6r9/eLzOd
         asl0+fMAxaVkAi3mLFUE93jvi2iim8irTk+7LXT5MDmyMUkKlbmQdTK5/z4dphoixPrw
         8ZzDQTriEjxZQKLAP3pBRPPcA2prV2meKAitOEwPQntgMrTs5KDXpApxXzzPJbgfuJI6
         QDVQhZwFZ7yA5g2nR7I42v/AVSsiAO2m0twwVXjBXOPVmGiXG0jD3G0yp1eKRy1VHeua
         4m8Q==
X-Gm-Message-State: AOAM532UHXLbFvXY28GEbbjV1hP0DB46GFtvInKiOlT8uYM+hYGTeCoK
        iShLjxb11PqL1NnRoDNLilk=
X-Google-Smtp-Source: ABdhPJy29cByRXEPWMZGZSLuR/2jLDllsyl7Dv+ArERUaYgpHwrqkpWmcvB75hzanxOZIzxQIWE6Ug==
X-Received: by 2002:a17:906:b106:: with SMTP id u6mr11973612ejy.313.1612694698816;
        Sun, 07 Feb 2021 02:44:58 -0800 (PST)
Received: from ubuntu-laptop (ip5f5bee1b.dynamic.kabel-deutschland.de. [95.91.238.27])
        by smtp.googlemail.com with ESMTPSA id e24sm1855425ejb.121.2021.02.07.02.44.57
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Sun, 07 Feb 2021 02:44:58 -0800 (PST)
Message-ID: <19a3cf32c556455f43f9c0f61a408eda65f6d7ec.camel@gmail.com>
Subject: Re: [PATCH v19 3/3] scsi: ufs: Prepare HPB read for cached
 sub-region
From:   Bean Huo <huobean@gmail.com>
To:     Can Guo <cang@codeaurora.org>
Cc:     Avri Altman <Avri.Altman@wdc.com>, daejun7.park@samsung.com,
        Greg KH <gregkh@linuxfoundation.org>, jejb@linux.ibm.com,
        martin.petersen@oracle.com, asutoshd@codeaurora.org,
        stanley.chu@mediatek.com, bvanassche@acm.org,
        ALIM AKHTAR <alim.akhtar@samsung.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Sung-Jun Park <sungjun07.park@samsung.com>,
        yongmyung lee <ymhungry.lee@samsung.com>,
        Jinyoung CHOI <j-young.choi@samsung.com>,
        BoRam Shin <boram.shin@samsung.com>,
        SEUNGUK SHIN <seunguk.shin@samsung.com>
Date:   Sun, 07 Feb 2021 11:44:56 +0100
In-Reply-To: <ba7943ab40720df96a9fedb04ab0e4c8@codeaurora.org>
References: <20210129052848epcms2p6e5797efd94e6282b76ad9ae6c99e3ab5@epcms2p6>
         <CGME20210129052848epcms2p6e5797efd94e6282b76ad9ae6c99e3ab5@epcms2p5>
         <20210129053042epcms2p538e7fa396c3c2104594c44e48be53eb8@epcms2p5>
         <7f25ccb1d857131baa1c0424c4542e33@codeaurora.org>
         <b6a8652c00411e3f71d33e7a6322f49eb5701039.camel@gmail.com>
         <DM6PR04MB657522B94AB436CF096460F6FCB29@DM6PR04MB6575.namprd04.prod.outlook.com>
         <12a011cd895dc9be5ec6c4f964b6011af492f06d.camel@gmail.com>
         <ba7943ab40720df96a9fedb04ab0e4c8@codeaurora.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5-0ubuntu0.18.04.2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Sun, 2021-02-07 at 15:36 +0800, Can Guo wrote:
> > 
> > Thanks, I tested Daejun's patchset before, it is also ok (I don't
> > know
> > which version patchset). maybe we can keep current implementation
> > as
> > default, then if there is conflict, and submit the quirk.
> > 
> 
> Yeah, you've tested it, are you sure that Micron's UFS devices are OK
> with this specific code line?
> 
> Micron UFS FW team has confirmed that Micron's HPB entries read out
> by
> "HPB Buffer Read" cmd are in big-endian byte ordering.

Aha, I think you didn't check with right person :), ping me, let me
tell you this confusing story. and see my HPB patch, I didn't the same
with here:

https://patchwork.kernel.org/project/linux-scsi/patch/20200504142032.16619-6-beanhuo@micron.com/

Bean



