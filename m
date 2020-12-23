Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_2 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8F0D4C433E0
	for <linux-scsi@archiver.kernel.org>; Wed, 23 Dec 2020 08:36:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5187222248
	for <linux-scsi@archiver.kernel.org>; Wed, 23 Dec 2020 08:36:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728284AbgLWIf7 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 23 Dec 2020 03:35:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37178 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727744AbgLWIf7 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 23 Dec 2020 03:35:59 -0500
Received: from mail-ed1-x530.google.com (mail-ed1-x530.google.com [IPv6:2a00:1450:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C67B9C0613D6;
        Wed, 23 Dec 2020 00:35:18 -0800 (PST)
Received: by mail-ed1-x530.google.com with SMTP id cw27so15479351edb.5;
        Wed, 23 Dec 2020 00:35:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=message-id:subject:from:to:cc:date:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Eduj66RiVco+AT7g2a8p+pCQPzg2FWtlxEHzfdMi00s=;
        b=coPa26v03zKgNgMIpiXDgDAK86vnk2bCSzrIPk0VFBbiiJMDzyM1vB1vPnXVKNiao7
         rWGdceLVaZI1n581fdliq/J9m3IFMegzOh8pJ1qJMeT20oNPD8LrK0Bv5YgpVgN5uFmL
         tUXa4P4bkMWsn0asdt17IMNHhLRUz9kjrkwbFqdTj6JGkamIzNcgep43s8GaziH5/Avl
         rKsKHQgNt0k0dlR6pgsysNNLq5SkKf886D/XZoeBx/xp/boxJYKKQGaRow2a5+2e21yq
         S/x7aBW6U51fSsyo3w4O32R/aISR/4fysdF0Cdz3uUjHXPgVAPLWTTsMHkGPDYoMURkE
         zqvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Eduj66RiVco+AT7g2a8p+pCQPzg2FWtlxEHzfdMi00s=;
        b=Pn6ERDfPS2kuEnc+pQRC1AmI8uZDAkurcEI4oizXFlElX2L8AcXFuyyckbgLnhi49v
         3TPPOxnZ/ZRPlgpPaZ7wpVAl/K81J58gZGRo1Zg40H/Pmi0ZhxWDTvqkj+wEDeFrVs5I
         Erzw9FzmIAFefnmZunR3JTGqaVHVN9jBTV6EogpN0AxJ3nDyrhU7F2sLyrv88AvMiJHl
         tCPWv3bK1ceX5pNqApabnXGm6okhlqFU+rktk/wmbSc9Z4DH7jrKX0DQIJVYI2wIP6PP
         YaY6Hd66IJuuxIRL7b0Xj7oXCsKxw1nYYpeCCeEecmHO1m/jLMKPZ0o6Ygmhx2yQSJZ8
         crew==
X-Gm-Message-State: AOAM531wttnMrijCwQilLtWJ5mCUVVYg16NwR8fbZKOh2GmbcJ3qr5jQ
        fGv5+xa9qMsjyxOy8EZ2RjU=
X-Google-Smtp-Source: ABdhPJxgaqcz1/WGEx69Zgz5v3P94ZQkqyNKYnW4yoWdAxdZPuP9oYZy3mZfQkQD8FpuutRaDS1FaA==
X-Received: by 2002:a50:f61b:: with SMTP id c27mr23642613edn.61.1608712517605;
        Wed, 23 Dec 2020 00:35:17 -0800 (PST)
Received: from ubuntu-laptop (ip5f5bfce9.dynamic.kabel-deutschland.de. [95.91.252.233])
        by smtp.googlemail.com with ESMTPSA id ga11sm11349518ejb.34.2020.12.23.00.35.16
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 23 Dec 2020 00:35:17 -0800 (PST)
Message-ID: <8804b780b55f8dc0739e10a246d02cafcb00ab03.camel@gmail.com>
Subject: Re: [PATCH v1] scsi: ufs-mediatek: Enable
 UFSHCI_QUIRK_SKIP_MANUAL_WB_FLUSH_CTRL
From:   Bean Huo <huobean@gmail.com>
To:     Avri Altman <Avri.Altman@wdc.com>, Can Guo <cang@codeaurora.org>,
        Stanley Chu <stanley.chu@mediatek.com>
Cc:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "alim.akhtar@samsung.com" <alim.akhtar@samsung.com>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "beanhuo@micron.com" <beanhuo@micron.com>,
        "asutoshd@codeaurora.org" <asutoshd@codeaurora.org>,
        "matthias.bgg@gmail.com" <matthias.bgg@gmail.com>,
        "bvanassche@acm.org" <bvanassche@acm.org>,
        "linux-mediatek@lists.infradead.org" 
        <linux-mediatek@lists.infradead.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kuohong.wang@mediatek.com" <kuohong.wang@mediatek.com>,
        "peter.wang@mediatek.com" <peter.wang@mediatek.com>,
        "chun-hung.wu@mediatek.com" <chun-hung.wu@mediatek.com>,
        "andy.teng@mediatek.com" <andy.teng@mediatek.com>,
        "chaotian.jing@mediatek.com" <chaotian.jing@mediatek.com>,
        "cc.chou@mediatek.com" <cc.chou@mediatek.com>,
        "jiajie.hao@mediatek.com" <jiajie.hao@mediatek.com>,
        "alice.chao@mediatek.com" <alice.chao@mediatek.com>
Date:   Wed, 23 Dec 2020 09:35:15 +0100
In-Reply-To: <DM6PR04MB657598535F633F59A1DB1F22FCDE0@DM6PR04MB6575.namprd04.prod.outlook.com>
References: <20201222072928.32328-1-stanley.chu@mediatek.com>
         <c862866ec97516a7ffb891e5de3d132d@codeaurora.org>
         <1608697172.14045.5.camel@mtkswgap22>
         <c83d34ca8b0338526f6440f1c4ee43dd@codeaurora.org>
         <DM6PR04MB657598535F633F59A1DB1F22FCDE0@DM6PR04MB6575.namprd04.prod.outlook.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5-0ubuntu0.18.04.2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, 2020-12-23 at 07:47 +0000, Avri Altman wrote:
> > > could change the way it does: Keep manual flush disabled by
> > > default and
> > > remove this quirk.
> 
> Ack on that.
> I never understood why it was needed in the first place.
> Maybe just remove it, and allow to perform explicit flush from sysfs.
> 
> Thanks,
> Avr

Avri
I agree with you.
I don't understand why setting that at the begginnning, also assign
this feature the contrller to make desicion.

Bean


