Return-Path: <SRS0=Rfh9=BB=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=BAYES_00,DATE_IN_PAST_96_XX,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_2 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 44B63C433E0
	for <linux-scsi@archiver.kernel.org>; Wed, 22 Jul 2020 14:59:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2111520771
	for <linux-scsi@archiver.kernel.org>; Wed, 22 Jul 2020 14:59:47 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="e7uwKCVt"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732775AbgGVO7o (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 22 Jul 2020 10:59:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56506 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730870AbgGVO7o (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 22 Jul 2020 10:59:44 -0400
Received: from mail-ej1-x643.google.com (mail-ej1-x643.google.com [IPv6:2a00:1450:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0BD99C0619DC;
        Wed, 22 Jul 2020 07:59:44 -0700 (PDT)
Received: by mail-ej1-x643.google.com with SMTP id a21so2526029ejj.10;
        Wed, 22 Jul 2020 07:59:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=message-id:subject:from:to:cc:in-reply-to:references:mime-version
         :date:content-transfer-encoding;
        bh=URRzOHpgQhWz8k04t/0LNtBaTy9pE9Bui1vrbzjXhfI=;
        b=e7uwKCVt6D3jSem4PO+P9pzhJVScJ7gidvn9qlcv2TgMZh4TtkZ2Nlxv2iZbVr0QT1
         I5ur5Gxim9UapTLNIomFJ53fYjqFeqf7cVoEkGCCz2PUynwz/5jhzyz3QA7xIRbSVXyl
         ZugspPMGasrEZvItvBiZbvc7XTZT4L4d2cfXcjb4Wu8KMTfHa7tN7Q9ht4xyj42HkOXO
         gjoMQr4yNH3A0fQo3VOqyOw+EYiS38uvxBMKG0ttAiURk/pOZda47DLf3uTs8mfK6Mw6
         fTo6nt5bF0U/obvwSAH8K2NRoRdtXnnOalZIevQDaiKHtbFeyBiA4yenH1ELOoAPA07i
         XdIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:cc:in-reply-to
         :references:mime-version:date:content-transfer-encoding;
        bh=URRzOHpgQhWz8k04t/0LNtBaTy9pE9Bui1vrbzjXhfI=;
        b=NbSLniTT6GqokBzY66UQ9cF1YWZsQR6TmhGD+MrRdVlzXfoMTEdLRsOK3gVyMDjJku
         caYBCJXtxUDsUl541g77DYjqsbFnGbia+qxkHKSYFpTbNIc7XjGJHC9KAnUAQNzeFBgC
         XlxXvzbQc47ZHzkexShveqkeqiYlVwmbvxGOY3tOPtUVpK3HWZt3iabF5RVIjynAJi5a
         Mfbq0XBy1b4Gpu/6cx2DgVEP7csiC9ewXhqvZnTRMWYhEQEfYm9Mz5yUEICMp6foJVal
         ldoQEq+PT21LIS3EKO0bTfUgu3HqNDDr+Ji7NlLQ+OVgZl1Y+dr+OpScRHOtQFuWrUi8
         vXpA==
X-Gm-Message-State: AOAM532dITZ14N9J8d8gt1/nnaQYT1r7XGasm6V8sP6+ABp8f4UDoXNe
        ba702ivP1m5T7JP2x4Ma820=
X-Google-Smtp-Source: ABdhPJy7OGFfe2ZmIbIPJgSKdIxz7vpB5TeN9Z25EU/fegE+4BuZZsw1np3Tb5T0TkZ8dgiUZTy26A==
X-Received: by 2002:a17:906:6558:: with SMTP id u24mr26724151ejn.364.1595429982763;
        Wed, 22 Jul 2020 07:59:42 -0700 (PDT)
Received: from ubuntu-laptop (ip5f5bee3d.dynamic.kabel-deutschland.de. [95.91.238.61])
        by smtp.googlemail.com with ESMTPSA id d12sm65543edx.80.2020.07.22.07.59.41
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 22 Jul 2020 07:59:42 -0700 (PDT)
Message-ID: <c2450609677d4b3df172545a9aaad5373402e23c.camel@gmail.com>
Subject: Re: [PATCH v6 0/5] scsi: ufs: Add Host Performance Booster Support
From:   Bean Huo <huobean@gmail.com>
To:     Avi Shchislowski <Avi.Shchislowski@wdc.com>,
        "daejun7.park@samsung.com" <daejun7.park@samsung.com>,
        Avri Altman <Avri.Altman@wdc.com>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "asutoshd@codeaurora.org" <asutoshd@codeaurora.org>,
        "beanhuo@micron.com" <beanhuo@micron.com>,
        "stanley.chu@mediatek.com" <stanley.chu@mediatek.com>,
        "cang@codeaurora.org" <cang@codeaurora.org>,
        "bvanassche@acm.org" <bvanassche@acm.org>,
        "tomas.winkler@intel.com" <tomas.winkler@intel.com>,
        ALIM AKHTAR <alim.akhtar@samsung.com>
Cc:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Sang-yoon Oh <sangyoon.oh@samsung.com>,
        Sung-Jun Park <sungjun07.park@samsung.com>,
        yongmyung lee <ymhungry.lee@samsung.com>,
        Jinyoung CHOI <j-young.choi@samsung.com>,
        Adel Choi <adel.choi@samsung.com>,
        BoRam Shin <boram.shin@samsung.com>
In-Reply-To: <SN6PR04MB38720C3D8FC176C3C7FB51B89A7E0@SN6PR04MB3872.namprd04.prod.outlook.com>
References: <CGME20200713103423epcms2p8442ee7cc22395e4a4cedf224f95c45e8@epcms2p8>
         <963815509.21594636682161.JavaMail.epsvc@epcpadp2>
         <SN6PR04MB38720C3D8FC176C3C7FB51B89A7E0@SN6PR04MB3872.namprd04.prod.outlook.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Date:   Thu, 16 Jul 2020 10:13:33 +0200
X-Mailer: Evolution 3.28.5-0ubuntu0.18.04.2 
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, 2020-07-15 at 18:34 +0000, Avi Shchislowski wrote:
> Hello All,
> My name is Avi Shchislowski, I am managing the WDC's Linux Host R&D
> team in which Avri is a member of.
> As the review process of HPB is progressing very constructively, we
> are getting more and more requests from OEMs, Inquiring about HPB in
> general, and host control mode in particular.
> 
> Their main concern is that HPB will make it to 5.9 merge window, but
> the host control mode patches will not.
> Thus, because of recent Google's GKI, the next Android LTS might not
> include HPB with host control mode.
> 
> Aside of those requests, initial host control mode testing are
> showing promising prospective with respect of performance gain.
> 
> What would be, in your opinion, the best policy that host control
> mode is included in next Android LTS?
> 
> Thanks,
> Avi
> 

Hi Avi
IMO, no matter how did the driver implement, if you truly want the HPB
host mode driver you mentioned to be mainlined in the upstream Linux,
the best policy is that you should first post the driver in the SCSI
maillist community, let us firstly review here. I didn't see your
driver, I don't know how to provide the correct answer.

Thanks,
Bean



