Return-Path: <SRS0=JvOq=BQ=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_2 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 09676C433F1
	for <linux-scsi@archiver.kernel.org>; Thu,  6 Aug 2020 11:17:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4EFB622D06
	for <linux-scsi@archiver.kernel.org>; Thu,  6 Aug 2020 11:17:05 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="LX/2tKPP"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729442AbgHFKpm (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 6 Aug 2020 06:45:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42624 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729408AbgHFKkU (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 6 Aug 2020 06:40:20 -0400
Received: from mail-ej1-x643.google.com (mail-ej1-x643.google.com [IPv6:2a00:1450:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4BDDBC0617A3;
        Thu,  6 Aug 2020 03:28:53 -0700 (PDT)
Received: by mail-ej1-x643.google.com with SMTP id o23so22289128ejr.1;
        Thu, 06 Aug 2020 03:28:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=message-id:subject:from:to:cc:date:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=LlvslduPzOtH0DRIKETCIQxDIw610HLROiARW0lqIBE=;
        b=LX/2tKPPbErTdpK+WcwSwgM956ZhidIL8F7d+Kmm18goixA3u5hIHit1IMmm0l+SqS
         hk1MhFxIG/bc1IJlRErwqjC5g65XccRMkDi8KOJjEkbO3MwK4ccbtStkiuSGGalwOhcJ
         hVTcdAqojXNuNYgDMFdoQGLxKqRLPC+mSiejjkP7/tQVqaxBC6yjj29T/h2z/tWdMHir
         N5fGI4QO62LZzgLNYoTxV9RIkVeC5A8J/TsAwFXWInXFut/7VrkbXJTUr7khHufrF6k6
         Jd6CptnlpuCtd8imCDIVsFpJn0scZT/6BXx4VzJ8DoBLbqpYILE65LOSXzsdanB7Y7Lu
         YPRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=LlvslduPzOtH0DRIKETCIQxDIw610HLROiARW0lqIBE=;
        b=YNnHDZh1EDZbJ07vHcBsveR2GlGRMi74kGTrjs99hb+OWExJT6raRPaOb1bPJ3VBgr
         bVcqRDsNA4mXj600/k3yDYt0NA5Rf47BuBIDMbjzXc2uRMabvmh2LBGcFmqECQ8/W2lu
         NUCXQAP6IDs3wNXaaUs0H+JKOnRBtPLQF1mPgBWg/uNgjFgwuUUCCitIZ01dFQWZKVZ3
         Lo+pvwC+BaCVB56Z0npnnIiKJWXXAw4r/iGG4Js+CEIMoE4keoKDW8R2hOyJXEOCYdXg
         68mGr9nHEwwzNMTW1bhj8gKY3Yfbzw9/7jqWuepakGZvqS6YeJmm6SiNIt41rxrHGZJp
         U/Hg==
X-Gm-Message-State: AOAM530Ru9f9TzFvhoST0IoapT+RUNVWQqS66ZfdXjoBb/VCoonnZNlp
        iWt3bmfU1K6C0OgCF1q2KF4=
X-Google-Smtp-Source: ABdhPJzv7grcfpFLMn19O+RYJNHGjYc2TXrIbgMb3k5DJPBXbgVvWbPFTlWSAsih5qL5mY6i/OnJRw==
X-Received: by 2002:a17:906:dbcb:: with SMTP id yc11mr3409762ejb.399.1596709731947;
        Thu, 06 Aug 2020 03:28:51 -0700 (PDT)
Received: from ubuntu-laptop ([2a01:598:b906:f0c9:15b9:533b:62ba:b5b3])
        by smtp.googlemail.com with ESMTPSA id dm5sm3252153edb.32.2020.08.06.03.28.49
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 06 Aug 2020 03:28:50 -0700 (PDT)
Message-ID: <e3aba7fba7c208ac58c638139bd615c871d2e52e.camel@gmail.com>
Subject: Re: [PATCH v8 0/4] scsi: ufs: Add Host Performance Booster Support
From:   Bean Huo <huobean@gmail.com>
To:     Avri Altman <Avri.Altman@wdc.com>,
        "daejun7.park@samsung.com" <daejun7.park@samsung.com>,
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
Date:   Thu, 06 Aug 2020 12:28:48 +0200
In-Reply-To: <SN6PR04MB4640210D586CBA053F56DCF0FC480@SN6PR04MB4640.namprd04.prod.outlook.com>
References: <CGME20200806073257epcms2p61564ed62e02fc42fc3c2b18fa92a038d@epcms2p6>
         <231786897.01596704281715.JavaMail.epsvc@epcpadp2>
         <7c59c7abf7b00c368228b3096e1bea8c9e2b2e80.camel@gmail.com>
         <SN6PR04MB4640CE297AAB3CF4D37EE002FC480@SN6PR04MB4640.namprd04.prod.outlook.com>
         <39c546268abead68f4c00f17dc47c1597f3e0273.camel@gmail.com>
         <SN6PR04MB4640210D586CBA053F56DCF0FC480@SN6PR04MB4640.namprd04.prod.outlook.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5-0ubuntu0.18.04.2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, 2020-08-06 at 10:12 +0000, Avri Altman wrote:
> > > 
> > 
> > we didn't see you Acked-by in the pathwork, would you like to add
> > them?
> > Just for reminding us that you have agreed to mainline this series
> > patchset.
> 
> I acked it - https://www.spinics.net/lists/linux-scsi/msg144660.html
> And asked Martin to move forward - 
> https://www.spinics.net/lists/linux-scsi/msg144738.html
> Which he did, and got some sparse errors: 
> https://www.spinics.net/lists/linux-scsi/msg144977.html
> Which I asked Daejun to fix - 
> https://www.spinics.net/lists/linux-scsi/msg144987.html
> 
> For the next chain of events I guess you can follow by yourself.
> 
> Thanks,
> Avri

Avri
Sorry for making you confusing. yes, I knew that, and following.
I mean Acked-by tag in the patchset, then we see your acked in the
patchwork, and let others know that you acked it, rather than going
backtrack history email.

Hi Daejun
I think you can add Avri's Acked-by tag in your patchset, just for
quickly moving forward and reminding.

thanks,
Bean

