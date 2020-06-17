Return-Path: <SRS0=X8O6=76=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_2 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A9859C433E1
	for <linux-scsi@archiver.kernel.org>; Wed, 17 Jun 2020 09:42:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 84A2A207E8
	for <linux-scsi@archiver.kernel.org>; Wed, 17 Jun 2020 09:42:14 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="gyT2C3Ez"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726329AbgFQJmK (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 17 Jun 2020 05:42:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42750 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725860AbgFQJmK (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 17 Jun 2020 05:42:10 -0400
Received: from mail-wr1-x441.google.com (mail-wr1-x441.google.com [IPv6:2a00:1450:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 23533C061573;
        Wed, 17 Jun 2020 02:42:10 -0700 (PDT)
Received: by mail-wr1-x441.google.com with SMTP id e1so1604711wrt.5;
        Wed, 17 Jun 2020 02:42:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=message-id:subject:from:to:cc:date:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=s5ozDVklybETfefE88F2sjZVkweD0ju+SZP/9NGLYa8=;
        b=gyT2C3Ez7iMxPb7vqwPMGvcsX7VITaoe1qsg0YfpQqnm2CCBp28gq3zrZvTYcH50J1
         gBRUdOnjlfqpJMEmW1O3AnemaiyJ6s4G0ENVj8F8nSrve7VBvurLcgbSW5xzp+5aC/ok
         UBtdkAp3A3RP+qklRFcpE+yZ1trLHnBQInQxfeEWz2Lg42ZFM2v/SJevmp9iOHP87SPr
         YKyDtaVzvzag0dOK7KuQEdEA69kNcDrXH9xacY7p5fXlLeq4XaLxDImZJJB4rfMiCe8/
         2D9Xf2e6tP3jUerNtqXFucHxXPKmASKPI5dwZ5WbyHLS6c8eMHhC1Dk9SAC69d3U8IqC
         jbbw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=s5ozDVklybETfefE88F2sjZVkweD0ju+SZP/9NGLYa8=;
        b=J1A1sZXwFAzSR7bgVgJ9TNOnlhSHzAblgRJJcCkl/EuYejTkw9pZg0GQUZv7kkjSEM
         i8bPAZZNWlNHaZqjMIRdpaEOQKX/jErAJyxstZIGB6N+AhuorWRDKkQODv3FhvAfKEmJ
         cUeuoEkhzhUGKQgBn5lT6cCXmbZzrePPsypzbo/9uoWFA5J+7QsLTqkumEwGFfrgXh0z
         GR9UuZZXjhtIc6dDwSF6PnEUAGen6eFO4JouChCTst7MwE7u6vRbVvBx3qdzrW1TFx07
         NYWXXL6cEfxEvJCPqo0N11objswqAW0dx4DeCmexUyN/Imd2qjrEYe22oxmCmtRka0/M
         rDqg==
X-Gm-Message-State: AOAM530AHMK76ojSMtZ2ID9OsV0nfeujmO2Kjx3zaKeALclXC0ZP6Vtg
        V8w74au/j3grPzFbi5p9SQ0=
X-Google-Smtp-Source: ABdhPJwiZyyd7uIDvCDc5BecdMAiRd3nIVHPLNrLM0imVFwPv2vZH8nW7KujQiVAbHAhd2mRY+vjxw==
X-Received: by 2002:adf:a51a:: with SMTP id i26mr7395814wrb.406.1592386928901;
        Wed, 17 Jun 2020 02:42:08 -0700 (PDT)
Received: from ubuntu-laptop ([2a01:598:a011:30c:e489:2676:2097:fdba])
        by smtp.googlemail.com with ESMTPSA id j4sm8101512wma.7.2020.06.17.02.42.06
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 17 Jun 2020 02:42:08 -0700 (PDT)
Message-ID: <653426a77669eaced17e9e5aa87259ad57514c47.camel@gmail.com>
Subject: Re: [RFC PATCH v2 2/5] scsi: ufs: Add UFS-feature layer
From:   Bean Huo <huobean@gmail.com>
To:     Alim Akhtar <alim.akhtar@gmail.com>,
        Avri Altman <Avri.Altman@wdc.com>
Cc:     "daejun7.park@samsung.com" <daejun7.park@samsung.com>,
        ALIM AKHTAR <alim.akhtar@samsung.com>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "asutoshd@codeaurora.org" <asutoshd@codeaurora.org>,
        "beanhuo@micron.com" <beanhuo@micron.com>,
        "stanley.chu@mediatek.com" <stanley.chu@mediatek.com>,
        "cang@codeaurora.org" <cang@codeaurora.org>,
        "bvanassche@acm.org" <bvanassche@acm.org>,
        "tomas.winkler@intel.com" <tomas.winkler@intel.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Sang-yoon Oh <sangyoon.oh@samsung.com>,
        Sung-Jun Park <sungjun07.park@samsung.com>,
        yongmyung lee <ymhungry.lee@samsung.com>,
        Jinyoung CHOI <j-young.choi@samsung.com>,
        Adel Choi <adel.choi@samsung.com>,
        BoRam Shin <boram.shin@samsung.com>
Date:   Wed, 17 Jun 2020 11:41:55 +0200
In-Reply-To: <CAGOxZ50TUnvmmdspxr6dHWrpoxZqHtvR-1Wg6jAVH6k-w5LT2w@mail.gmail.com>
References: <47dcc56312229fc8f25f39c2beeb3a8ba811f3e9.camel@gmail.com>
         <336371513.41592205783606.JavaMail.epsvc@epcpadp2>
         <231786897.01592205482200.JavaMail.epsvc@epcpadp2>
         <231786897.01592212081335.JavaMail.epsvc@epcpadp2>
         <CGME20200615062708epcms2p19a7fbc051bcd5e843c29dcd58fff4210@epcms2p6>
         <1210830415.21592275802431.JavaMail.epsvc@epcpadp1>
         <SN6PR04MB4640EE125CF504AF9362B23FFC9A0@SN6PR04MB4640.namprd04.prod.outlook.com>
         <CAGOxZ50TUnvmmdspxr6dHWrpoxZqHtvR-1Wg6jAVH6k-w5LT2w@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5-0ubuntu0.18.04.2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, 2020-06-17 at 14:27 +0530, Alim Akhtar wrote:
> > > > > +       init_waitqueue_head(&hba->ufsf.sdev_wait);
> > > > > +       atomic_set(&hba->ufsf.slave_conf_cnt, 0);
> > > > > +
> > > > > +       if (hba->dev_info.wspecversion >=
> > > > > HPB_SUPPORTED_VERSION &&
> > > > > +           (hba->dev_info.b_ufs_feature_sup &
> > > > > UFS_DEV_HPB_SUPPORT))
> > > > 
> > > > How about removing this check "(hba->dev_info.wspecversion >=
> > > > HPB_SUPPORTED_VERSION" since ufs with lower version than v3.1
> > > > can add
> > > > HPB feature by FFU,
> > > > if (hba->dev_info.b_ufs_feature_sup 
> > > > &UFS_FEATURE_SUPPORT_HPB_BIT) is
> > > > enough.
> > > 
> > > OK, changing it seems no problem. But I want to know what other
> > > people
> > > think
> > > about this version checking code.
> > 
> > HPB1.0 isn't part of ufs3.1, but published only later.
> > Allowing earlier versions will required to quirk the descriptor
> > sizes.
> > I see Bean's point here, but I vote for adding it in a single
> > quirk, when the time comes.
> > 
> 
> I second Avri here, older devices need a quirk to handle, let do that
> as a separate patch.
> > Thanks,
> > Avri
> 
> 

what is useful point of adding a quirk for this?

From the customer side piont, they just get our FW image, and then do
FFU. If adding a quirk here, that means they also need to change UFS
driver. Also,  you expand the qurik structure.


from cambridge dictionary: 
Qurik: 
	an unusual habit or part of someone's personality, or something
	that
is strange and unexpected.

HPB feature is unexpected??


please tell me the useful point of adding a Quirk.

Bean
> 

