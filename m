Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 507FFC4361B
	for <linux-scsi@archiver.kernel.org>; Wed, 16 Dec 2020 10:07:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EC9282313B
	for <linux-scsi@archiver.kernel.org>; Wed, 16 Dec 2020 10:07:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726057AbgLPKGw (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 16 Dec 2020 05:06:52 -0500
Received: from mail.kernel.org ([198.145.29.99]:55708 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726016AbgLPKGv (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 16 Dec 2020 05:06:51 -0500
Date:   Wed, 16 Dec 2020 11:07:12 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1608113171;
        bh=e6bhXWnqJJogoI0fJCOUs72QqeMzbdl+y1fGMDoIG+s=;
        h=From:To:Cc:Subject:References:In-Reply-To:From;
        b=U1Lg8Xy+6EY/Q10jzZz420/6yyvgMxkp+yn1o4qsFtReokZFzZcAwPdjj7q0ghwsg
         PeXiV0Od2uhle3mid4hX5z7s4hTsvmZoig7rIMcmGeDm5ZpNuqkfpmWTFK4np734pv
         5HencNwrqxRi7pVxEWy4uvE/7CbUuMiJD81ln92U=
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Daejun Park <daejun7.park@samsung.com>
Cc:     "avri.altman@wdc.com" <avri.altman@wdc.com>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "asutoshd@codeaurora.org" <asutoshd@codeaurora.org>,
        "stanley.chu@mediatek.com" <stanley.chu@mediatek.com>,
        "cang@codeaurora.org" <cang@codeaurora.org>,
        "bvanassche@acm.org" <bvanassche@acm.org>,
        "huobean@gmail.com" <huobean@gmail.com>,
        ALIM AKHTAR <alim.akhtar@samsung.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Sung-Jun Park <sungjun07.park@samsung.com>,
        yongmyung lee <ymhungry.lee@samsung.com>,
        Jinyoung CHOI <j-young.choi@samsung.com>,
        Adel Choi <adel.choi@samsung.com>,
        BoRam Shin <boram.shin@samsung.com>,
        SEUNGUK SHIN <seunguk.shin@samsung.com>
Subject: Re: [PATCH v14 0/3] scsi: ufs: Add Host Performance Booster Support
Message-ID: <X9ncUJH/vHO7Luqi@kroah.com>
References: <CGME20201215082235epcms2p88c9d8fd4dc773f6a4901dab241063306@epcms2p5>
 <20201216024444epcms2p5e69281911dd675306c473df3d2cef8b2@epcms2p5>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201216024444epcms2p5e69281911dd675306c473df3d2cef8b2@epcms2p5>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, Dec 16, 2020 at 11:44:44AM +0900, Daejun Park wrote:
> NAND flash memory-based storage devices use Flash Translation Layer (FTL)
> to translate logical addresses of I/O requests to corresponding flash
> memory addresses. Mobile storage devices typically have RAM with
> constrained size, thus lack in memory to keep the whole mapping table.
> Therefore, mapping tables are partially retrieved from NAND flash on
> demand, causing random-read performance degradation.
> 
> To improve random read performance, JESD220-3 (HPB v1.0) proposes HPB
> (Host Performance Booster) which uses host system memory as a cache for the
> FTL mapping table. By using HPB, FTL data can be read from host memory
> faster than from NAND flash memory. 
> 
> The current version only supports the DCM (device control mode).
> This patch consists of 3 parts to support HPB feature.
> 
> 1) HPB probe and initialization process
> 2) READ -> HPB READ using cached map information
> 3) L2P (logical to physical) map management
> 
> In the HPB probe and init process, the device information of the UFS is
> queried. After checking supported features, the data structure for the HPB
> is initialized according to the device information.
> 
> A read I/O in the active sub-region where the map is cached is changed to
> HPB READ by the HPB.
> 
> The HPB manages the L2P map using information received from the
> device. For active sub-region, the HPB caches through ufshpb_map
> request. For the in-active region, the HPB discards the L2P map.
> When a write I/O occurs in an active sub-region area, associated dirty
> bitmap checked as dirty for preventing stale read.
> 
> HPB is shown to have a performance improvement of 58 - 67% for random read
> workload. [1]
> 
> We measured the total start-up time of popular applications and observed
> the difference by enabling the HPB.
> Popular applications are 12 game apps and 24 non-game apps. Each target
> applications were launched in order. The cycle consists of running 36
> applications in sequence. We repeated the cycle for observing performance
> improvement by L2P mapping cache hit in HPB.
> 
> The Following is experiment environment:
>  - kernel version: 4.4.0 
>  - UFS 2.1 (64GB)
> 
> Result:
> +-------+----------+----------+-------+
> | cycle | baseline | with HPB | diff  |
> +-------+----------+----------+-------+
> | 1     | 272.4    | 264.9    | -7.5  |
> | 2     | 250.4    | 248.2    | -2.2  |
> | 3     | 226.2    | 215.6    | -10.6 |
> | 4     | 230.6    | 214.8    | -15.8 |
> | 5     | 232.0    | 218.1    | -13.9 |
> | 6     | 231.9    | 212.6    | -19.3 |
> +-------+----------+----------+-------+

I feel this was burried in the 00 email, shouldn't it go into the 01
commit changelog so that you can see this?

But why does the "cycle" matter here?

Can you run a normal benchmark, like fio, on here so we can get some
numbers we know how to compare to other systems with, and possible
reproduct it ourselves?  I'm sure fio will easily show random read
performance increases, right?

thanks,

greg k-h
