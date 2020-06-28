Return-Path: <SRS0=bO3J=AJ=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_2 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D1A2EC433E1
	for <linux-scsi@archiver.kernel.org>; Sun, 28 Jun 2020 12:26:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id ADFE8208C7
	for <linux-scsi@archiver.kernel.org>; Sun, 28 Jun 2020 12:26:16 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="H6Y1q6Nr"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726537AbgF1M0L (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 28 Jun 2020 08:26:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40922 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726317AbgF1M0L (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 28 Jun 2020 08:26:11 -0400
Received: from mail-ed1-x544.google.com (mail-ed1-x544.google.com [IPv6:2a00:1450:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD20CC061794;
        Sun, 28 Jun 2020 05:26:10 -0700 (PDT)
Received: by mail-ed1-x544.google.com with SMTP id dm19so4232407edb.13;
        Sun, 28 Jun 2020 05:26:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=message-id:subject:from:to:cc:date:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=oRC2cM8AdE9R5V1E/I9jGufFpdMDuKN52rDDkJBJ7IM=;
        b=H6Y1q6NrEepwAT8v66Es+5tfQH/KTuTZ6s1S8tLsSfa425xA6N+mwZQZyMtsLJalTf
         lX/uj7ongSCqzE5xWvENR1wy8J6KdHCBC7WLhMCmE2B4zmEFAxEXrZnZrnjRkP+E2Pdi
         2fY3hkmu43leG9t+iNcRFI+8JHsLV7BG/NDQlWj8DxLmFzqGHUkLuTFZMISVpyEJgx/1
         hKrphWK8Shzo2VbrjVOJ3K+IevnUCbH2uNcdjga6zfKdOos8+9FTkS/LTL0kMJ88nNGF
         XuzJOguU3BtFKh2mIq9X6cKqFsEF0yhw0xN9yO9ZUHsQ3zNNExf2beuQ078DmTZGwjjN
         x1Lg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=oRC2cM8AdE9R5V1E/I9jGufFpdMDuKN52rDDkJBJ7IM=;
        b=KSZqWLzEHPV97PUh/0mn+8ravJuYgzS8iklHSnEVYHPimrd/wj2obviI0xQRVazKHR
         2VHZt+JayYcdft0dnRhydLauYixyqQEYuLVth0nVKEyLbHKjNrciF+T4nFR+T7O1YjVT
         iN5LE7hJOK7gmMZRfJWfhgYY6CuKxlKhLb9PSRQfbpWVSQvZ2aeJOigLvDVn9eKNkb/l
         sGyAttBZGNCXbS/+Q2euOS9xVwrbrjzvzi4FHHpmLvrobFjOFGHG4Hm3l1sPOmQzMeqL
         5mhFjqKEkP/sdVNq6+O4sNOlvfQiUDOpiH7GxnxqxyIi+mua1xIs1gzgt+ccVcJixchB
         5Bdg==
X-Gm-Message-State: AOAM530WWtvXCk0dUktzQwAgjCMj8KFYOulK5P0bzLfwXEWxIcc8EcZU
        8P77jknxneHSQQYfXgOudWX2dcUg
X-Google-Smtp-Source: ABdhPJzIaGKu/ygx73vAEzoqSU9KkJ+UZ8ksczejJf6rqXb6ltoTM780Eth+82tJgiHYAu3f8aTgnw==
X-Received: by 2002:aa7:d802:: with SMTP id v2mr5755535edq.77.1593347169329;
        Sun, 28 Jun 2020 05:26:09 -0700 (PDT)
Received: from ubuntu-laptop (ip5f5bfcc0.dynamic.kabel-deutschland.de. [95.91.252.192])
        by smtp.googlemail.com with ESMTPSA id 36sm26159510edl.31.2020.06.28.05.26.07
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Sun, 28 Jun 2020 05:26:08 -0700 (PDT)
Message-ID: <948f573d136b39410f7d610e5019aafc9c04fe62.camel@gmail.com>
Subject: Re: [RFC PATCH v3 0/5] scsi: ufs: Add Host Performance Booster
 Support
From:   Bean Huo <huobean@gmail.com>
To:     daejun7.park@samsung.com,
        "avri.altman@wdc.com" <avri.altman@wdc.com>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "asutoshd@codeaurora.org" <asutoshd@codeaurora.org>,
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
Date:   Sun, 28 Jun 2020 14:26:07 +0200
In-Reply-To: <963815509.21592879582091.JavaMail.epsvc@epcpadp2>
References: <CGME20200623010201epcms2p11aebdf1fbc719b409968cba997507114@epcms2p1>
         <963815509.21592879582091.JavaMail.epsvc@epcpadp2>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5-0ubuntu0.18.04.2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Daejun

Seems you intentionally ignored to give you comments on my suggestion.
let me provide the reason.

Before submitting your next version patch, please check your L2P
mapping HPB reqeust submission logical algorithem. I have did
performance comparison testing on 4KB, there are about 13% performance
drop. Also the hit count is lower. I don't know if this is related to
your current work queue scheduling, since you didn't add the timer for
each HPB request.

Thanks,

Bean


On Tue, 2020-06-23 at 10:02 +0900, Daejun Park wrote:
> Changelog:
> 
> v2 -> v3
> 1. Add checking input module parameter value.
> 2. Change base commit from 5.8/scsi-queue to 5.9/scsi-queue.
> 3. Cleanup for unused variables and label.
> 
> v1 -> v2
> 1. Change the full boilerplate text to SPDX style.
> 2. Adopt dynamic allocation for sub-region data structure.
> 3. Cleanup.
> 
> NAND flash memory-based storage devices use Flash Translation Layer
> (FTL)
> to translate logical addresses of I/O requests to corresponding flash
> memory addresses. Mobile storage devices typically have RAM with
> constrained size, thus lack in memory to keep the whole mapping
> table.
> Therefore, mapping tables are partially retrieved from NAND flash on
> demand, causing random-read performance degradation.
> 
> To improve random read performance, JESD220-3 (HPB v1.0) proposes HPB
> (Host Performance Booster) which uses host system memory as a cache
> for the
> FTL mapping table. By using HPB, FTL data can be read from host
> memory
> faster than from NAND flash memory. 
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
> This series patches are based on the 5.9/scsi-queue branch.
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
>  drivers/scsi/ufs/Kconfig      |    9 +
>  drivers/scsi/ufs/Makefile     |    3 +-
>  drivers/scsi/ufs/ufs.h        |   12 +
>  drivers/scsi/ufs/ufsfeature.c |  148 +++
>  drivers/scsi/ufs/ufsfeature.h |   69 ++
>  drivers/scsi/ufs/ufshcd.c     |   23 +-
>  drivers/scsi/ufs/ufshcd.h     |    3 +
>  drivers/scsi/ufs/ufshpb.c     | 1996
> ++++++++++++++++++++++++++++++++++++
>  drivers/scsi/ufs/ufshpb.h     |  234 +++++
>  9 files changed, 2494 insertions(+), 3 deletions(-)
>  created mode 100644 drivers/scsi/ufs/ufsfeature.c
>  created mode 100644 drivers/scsi/ufs/ufsfeature.h
>  created mode 100644 drivers/scsi/ufs/ufshpb.c
>  created mode 100644 drivers/scsi/ufs/ufshpb.h

