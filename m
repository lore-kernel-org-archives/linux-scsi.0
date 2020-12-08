Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_2 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0015FC433FE
	for <linux-scsi@archiver.kernel.org>; Tue,  8 Dec 2020 09:42:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AE1F323A9B
	for <linux-scsi@archiver.kernel.org>; Tue,  8 Dec 2020 09:42:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728871AbgLHJmG (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 8 Dec 2020 04:42:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49480 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727844AbgLHJmG (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 8 Dec 2020 04:42:06 -0500
Received: from mail-ej1-x62e.google.com (mail-ej1-x62e.google.com [IPv6:2a00:1450:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 97D4EC061749;
        Tue,  8 Dec 2020 01:41:25 -0800 (PST)
Received: by mail-ej1-x62e.google.com with SMTP id b9so13370369ejy.0;
        Tue, 08 Dec 2020 01:41:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=message-id:subject:from:to:cc:date:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=gHzl/uWiYLo8FvoZ+prOSIPKAbDS1mKoOLJ/17Oi3Yg=;
        b=nEEegRY7MAaR/8obBCLLBJ/RpfQwBI8+Bv/vJ+H2oH5JeY7kO9z11Q06qoS1o2ldEa
         XEhtAo/rr5Su0egvjG0Yl21qWVNRX+OQFbQzPdFZGfQGgzB+Oud72Em9Md0AidYCStzQ
         d+0XbL9nDFmMnkJSPx9uKvNziCYBTV7rSv62KI8zmKA7VWAWjdWt/W7eH3RdyuNEC4Bf
         ZtT6rP39kWRtNczuQsQt9ouTBVDEEQ67cYNT7hWKhKIrDTNC7qD+YbilSL03lft6LQ3N
         hGSC9zVzXEOYAhV30g7MMfYMqXnSbvfAlz37X3/3I46hfMenUcQMd5m8uOTxPcI2CzTN
         RSsw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=gHzl/uWiYLo8FvoZ+prOSIPKAbDS1mKoOLJ/17Oi3Yg=;
        b=mlizTyamxbiJJXBMhVh29C62pznYYuSE6qH4+TlUrr6/++qohr8M5FGepeWjeVx83F
         HwOQ4Q0eO9Mii1ivNFVWomkCXcM5Od9quhHIWE/rUoVN0hYj96a64e2c0gn9gIqM3iEI
         ZYF4tv3zwZjQMuOPI5bhCAs500g+41VUEQsl8Zc2hA0HmNg1iE8mV0i/wUW5wykU+sBu
         x0aAdK6mcbiAmoIKKFwSmIjGkgBIWz8f60sAod7WTTNX0yUSMmbnBTbvBcO0FLZRWUMB
         +nTrUdhc+IyLrPY0LLsoL22ioR0qRYZ8e/LYPXTdKyUsM13mew/0A1lH7Tb+t61pbC5I
         rCgg==
X-Gm-Message-State: AOAM530feeBzFZBHPul7ZRNK585u1K3Ud57EzFtiXFHZSh399QY9ZSyL
        R/sgYl0AuhyryvAJPPy4s22a8QgFl5A=
X-Google-Smtp-Source: ABdhPJxsse4stlAtQaFm8734Iz9OFP4KsJGLHm2qf0Sc2QMBu1mMb+k+IgAJISdtcVlfCLITNAyQxA==
X-Received: by 2002:a17:907:2070:: with SMTP id qp16mr22297756ejb.503.1607420484311;
        Tue, 08 Dec 2020 01:41:24 -0800 (PST)
Received: from ubuntu-laptop (ip5f5bfce9.dynamic.kabel-deutschland.de. [95.91.252.233])
        by smtp.googlemail.com with ESMTPSA id c14sm16493744edy.56.2020.12.08.01.41.22
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 08 Dec 2020 01:41:23 -0800 (PST)
Message-ID: <7a66077d6e5a3590d027756941850d6058ccb40c.camel@gmail.com>
Subject: Re: [PATCH v2 2/3] scsi: ufs: Keep device active mode only
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
Date:   Tue, 08 Dec 2020 10:41:22 +0100
In-Reply-To: <DM6PR04MB657584B4590496FA6BF11725FCCD0@DM6PR04MB6575.namprd04.prod.outlook.com>
References: <20201206101335.3418-1-huobean@gmail.com>
         <20201206101335.3418-3-huobean@gmail.com>
         <DM6PR04MB6575AED736BE44CA8D4B8998FCCE0@DM6PR04MB6575.namprd04.prod.outlook.com>
         <2ef12e328ecdc411e7d145a331d7c8ce668bf2be.camel@gmail.com>
         <DM6PR04MB657584B4590496FA6BF11725FCCD0@DM6PR04MB6575.namprd04.prod.outlook.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5-0ubuntu0.18.04.2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, 2020-12-08 at 09:05 +0000, Avri Altman wrote:
> > "
> > If fWriteBoosterBufferFlushDuringHibernate ==0, device will not
> > flush
> > WB, even if you keep device as "active mode" and LINK in hibernate
> > state.
> 
> OK, so what you are actually saying, is that since we are only
> toggling this flag once per
> link startup / recovery, in case of a failure, however rare - the
> host may be still keep vcc on
> for nothing, as the device will do nothing in that extra wake time. 
> Right?
> 

again, this is a BUG, BUG...
Bug is a Bug, doesn't matter it is rare or not rare. 

Tell me why we retry three times in ufshcd_query_flag_retry() in case
of failure?


> But every time ufshcd_wb_need_flush() is called we are reading some
> other flags/attributes?
> What about them? Why not protecting them as well?
> 

did you read ufshcd_wb_need_flush() fully? they have been properly
protected.

> Sorry - the whole idea doesn't make any sense to me.
> 

Thanks very much for sharing your opinion, I am very happy to hear your
opinion. Because you don't believe this is a bug, I will ask other UFS
guys to review, let Martin make the last decision.


Thanks agaion for your review.

Bean

