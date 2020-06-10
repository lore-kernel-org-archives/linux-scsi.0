Return-Path: <SRS0=mOiQ=7X=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_2 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 05748C433DF
	for <linux-scsi@archiver.kernel.org>; Wed, 10 Jun 2020 09:50:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D65EF206F4
	for <linux-scsi@archiver.kernel.org>; Wed, 10 Jun 2020 09:50:42 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="NIURHzhm"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727955AbgFJJuj (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 10 Jun 2020 05:50:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48596 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727866AbgFJJuj (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 10 Jun 2020 05:50:39 -0400
Received: from mail-wr1-x444.google.com (mail-wr1-x444.google.com [IPv6:2a00:1450:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4048AC03E96B;
        Wed, 10 Jun 2020 02:50:37 -0700 (PDT)
Received: by mail-wr1-x444.google.com with SMTP id x13so1521909wrv.4;
        Wed, 10 Jun 2020 02:50:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=message-id:subject:from:to:cc:date:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=FyXfHvm3MMekcs+9xT49s4KUAzm2maO5qTEi82BU+FQ=;
        b=NIURHzhm3u2S2cM7mdYKr96Wf/KxUdKbiohirALmYUKkKNHv4FfvLp0GPQ5cf2TH5S
         XI4u/ECyv1m9NfJSgNwKT0vCnmdceHbuf1DDBe918lwhO+UdyFnXeocz3YOfHolTOWXH
         GDBy7Gaga/lgwdF7eIBdNvakS9eDDCLASPnQWt9w6QIYIAx/JN7Bvi1Y7hEmdbvVuT01
         T0A/z4tNVdWmzxoHNyZG/6rtDMf6LNC2OVxgvzpVPl3s0RGgzjFvgPaXh2qkcjKxvhdn
         lQ69eHLl/gwOHshdTJJ8pNhB05ywICJzB1uKnMqNyyI8yBEDcviROKxbG9okdDlTEYC4
         YJjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=FyXfHvm3MMekcs+9xT49s4KUAzm2maO5qTEi82BU+FQ=;
        b=f6tCdQvX0LBDkt6ejBHsTkw2nZkiflYMDKf3DGeWfNetHAvQM+eVAQZ90ANu/5L6eF
         bKVh6iPjueAXa0WkYNmD/XttoVF53ur0S+D8lMb61pB69IzIryIkL7Gryw/Eh+XklCVX
         sxRvZbfoh6b0Eh3nklPbmTNcn0hXoLbObWVeAYufqVOSYlQUUqWREppVKFc0G5LKLkWD
         aSH8Cur/itNPMuzqfLkqd8/4Rz6TjiX0HMQaR06JFSsAnK/92dLeAjxXV9Zotzt2oh1H
         HgdazUbGrZC53HvKkU+/LApMfZcDAjrgEFbW3EX7/Ys/5Bxfl33pJwUvSp/T2/nEG6oV
         EQ1Q==
X-Gm-Message-State: AOAM533ijX6YQ5+CTgUoxZMoknonUGqNSDvHlDVkaF/y0eQ85827qLkQ
        xnpU5Iy+4nVomgsNr1egCEE=
X-Google-Smtp-Source: ABdhPJzoj7HXMmoyxrrVWlgjtCRYfG/Oq8XdPyV7VNBRh40akp8HAbCTMpRJHjCS6ByEEESO8vuAHA==
X-Received: by 2002:adf:ea03:: with SMTP id q3mr2600707wrm.286.1591782635837;
        Wed, 10 Jun 2020 02:50:35 -0700 (PDT)
Received: from ubuntu-laptop ([2a01:598:b90a:8f5:dd1:7313:78f9:539b])
        by smtp.googlemail.com with ESMTPSA id v66sm6392037wme.13.2020.06.10.02.50.32
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 10 Jun 2020 02:50:35 -0700 (PDT)
Message-ID: <e9cd1c4471daf97ff5ade2d8301903c4bbf834f1.camel@gmail.com>
Subject: Re: [RFC PATCH 0/5] scsi: ufs: Add Host Performance Booster Support
From:   Bean Huo <huobean@gmail.com>
To:     daejun7.park@samsung.com, ALIM AKHTAR <alim.akhtar@samsung.com>,
        "avri.altman@wdc.com" <avri.altman@wdc.com>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "asutoshd@codeaurora.org" <asutoshd@codeaurora.org>,
        "beanhuo@micron.com" <beanhuo@micron.com>,
        "stanley.chu@mediatek.com" <stanley.chu@mediatek.com>,
        "cang@codeaurora.org" <cang@codeaurora.org>,
        "bvanassche@acm.org" <bvanassche@acm.org>,
        "tomas.winkler@intel.com" <tomas.winkler@intel.com>
Cc:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Sang-yoon Oh <sangyoon.oh@samsung.com>,
        Sung-Jun Park <sungjun07.park@samsung.com>,
        yongmyung lee <ymhungry.lee@samsung.com>,
        Jinyoung CHOI <j-young.choi@samsung.com>,
        Adel Choi <adel.choi@samsung.com>,
        BoRam Shin <boram.shin@samsung.com>
Date:   Wed, 10 Jun 2020 11:50:32 +0200
In-Reply-To: <231786897.01591320001492.JavaMail.epsvc@epcpadp1>
References: <CGME20200605011604epcms2p8bec8ef6682583d7248dc7d9dc1bfc882@epcms2p8>
         <231786897.01591320001492.JavaMail.epsvc@epcpadp1>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5-0ubuntu0.18.04.2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Daejun

Nice to see your patch, I just run it on my testing workspace, work.
and in the next days, I can help you review your patch.

Thanks,
Bean
 

On Fri, 2020-06-05 at 10:16 +0900, Daejun Park wrote:
> NAND flash memory-based storage devices use Flash Translation Layer
> (FTL)
> to translate logical addresses of I/O requests to corresponding flash
> memory addresses. Mobile storage devices typically have RAM with
> constrained size, thus lack in memory to keep the whole mapping
> table.
> Therefore, mapping tables are partially retrieved from NAND flash on
> demand, causing random-read performance degradation.
> 
> To improve random read performance, we propose HPB (Host Performance
> Booster) which uses host system memory as a cache for the FTL mapping
> table. By using HPB, FTL data can be read from host memory faster
> than from
> NAND flash memory. 
> 
> The current version only supports the DCM (device control mode).
> This patch consists of 4 parts to support HPB feature.
> 
> 1) UFS-feature layer
> 2) HPB probe and initialization process
> 3) READ -> HPB READ using cached map information
> 4) L2P (logical to physical) map management
> 
> The UFS-feature is an additional layer to avoid the structure in
> which the
> UFS-core driver and the UFS-feature are entangled with each other in
> a 
> single module.
> By adding the layer, UFS-features composed of various combinations
> can be
> supported. Also, even if a new feature is added, modification of the 
> UFS-core driver can be minimized.
> 
> In the HPB probe and init process, the device information of the UFS
> is
> queried. After checking supported features, the data structure for
> the HPB
> is initialized according to the device information.
> 
> A read I/O in the active sub-region where the map is cached is
> changed to
> HPB READ by the HPB module.
> 
> The HPB module manages the L2P map using information received from
> the
> device. For active sub-region, the HPB module caches through
> ufshpb_map
> request. For the in-active region, the HPB module discards the L2P
> map.
> When a write I/O occurs in an active sub-region area, associated
> dirty
> bitmap checked as dirty for preventing stale read.
> 
> HPB is shown to have a performance improvement of 58 - 67% for random
> read
> workload. [1]
> 
> This series patches are based on the "5.8/scsi-queue" branch.
> 
> [1]:
> 
https://www.usenix.org/conference/hotstorage17/program/presentation/jeong
> 
> Daejun park (5):
>  scsi: ufs: Add UFS feature related parameter
>  scsi: ufs: Add UFS feature layer
>  scsi: ufs: Introduce HPB module
>  scsi: ufs: L2P map management for HPB read
>  scsi: ufs: Prepare HPB read for cached sub-region
>  
>  drivers/scsi/ufs/Kconfig      |    8 +
>  drivers/scsi/ufs/Makefile     |    3 +-
>  drivers/scsi/ufs/ufs.h        |   11 +
>  drivers/scsi/ufs/ufsfeature.c |  178 ++++
>  drivers/scsi/ufs/ufsfeature.h |   95 ++
>  drivers/scsi/ufs/ufshcd.c     |   19 +
>  drivers/scsi/ufs/ufshcd.h     |    3 +
>  drivers/scsi/ufs/ufshpb.c     | 2029
> +++++++++++++++++++++++++++++++++++++++++
>  drivers/scsi/ufs/ufshpb.h     |  257 ++++++
>  9 files changed, 2602 insertions(+), 1 deletion(-)
>  created mode 100644 drivers/scsi/ufs/ufsfeature.c
>  created mode 100644 drivers/scsi/ufs/ufsfeature.h
>  created mode 100644 drivers/scsi/ufs/ufshpb.c
>  created mode 100644 drivers/scsi/ufs/ufshpb.h

