Return-Path: <SRS0=JvOq=BQ=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 85C6AC4346F
	for <linux-scsi@archiver.kernel.org>; Thu,  6 Aug 2020 11:04:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 776BA204FD
	for <linux-scsi@archiver.kernel.org>; Thu,  6 Aug 2020 11:04:56 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=mg.codeaurora.org header.i=@mg.codeaurora.org header.b="qYNrma02"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728281AbgHFHUG (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 6 Aug 2020 03:20:06 -0400
Received: from m43-7.mailgun.net ([69.72.43.7]:45433 "EHLO m43-7.mailgun.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727105AbgHFHT7 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 6 Aug 2020 03:19:59 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1596698398; h=Message-ID: References: In-Reply-To: Subject:
 Cc: To: From: Date: Content-Transfer-Encoding: Content-Type:
 MIME-Version: Sender; bh=f0ZjW3geFihjbtauQAgHYAC5XRFZh7T0h3U/tjGyxaY=;
 b=qYNrma02Ci76slksPpgduJ/O902Gw3zd1CmmEi7VA/hJV53z4h+NrwRxj344d0e2mpvf2QEg
 cEm/QoUquyNaY0OT8VlfX9Rq9MrOEW36/eUTEn5wzlQ+Srpsucpe46Hm1wgyWt9jvVtXu6sg
 gq0RRqppBFCnTG/iQaSfumk/Ryk=
X-Mailgun-Sending-Ip: 69.72.43.7
X-Mailgun-Sid: WyJlNmU5NiIsICJsaW51eC1zY3NpQHZnZXIua2VybmVsLm9yZyIsICJiZTllNGEiXQ==
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n06.prod.us-west-2.postgun.com with SMTP id
 5f2baf1b668ab3fef666beeb (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Thu, 06 Aug 2020 07:19:55
 GMT
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 298E1C433A0; Thu,  6 Aug 2020 07:19:55 +0000 (UTC)
Received: from mail.codeaurora.org (localhost.localdomain [127.0.0.1])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: cang)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 01A4EC433C9;
        Thu,  6 Aug 2020 07:19:53 +0000 (UTC)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Thu, 06 Aug 2020 15:19:53 +0800
From:   Can Guo <cang@codeaurora.org>
To:     daejun7.park@samsung.com
Cc:     avri.altman@wdc.com, jejb@linux.ibm.com,
        martin.petersen@oracle.com, asutoshd@codeaurora.org,
        beanhuo@micron.com, stanley.chu@mediatek.com, bvanassche@acm.org,
        tomas.winkler@intel.com, ALIM AKHTAR <alim.akhtar@samsung.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Sang-yoon Oh <sangyoon.oh@samsung.com>,
        Sung-Jun Park <sungjun07.park@samsung.com>,
        yongmyung lee <ymhungry.lee@samsung.com>,
        Jinyoung CHOI <j-young.choi@samsung.com>,
        Adel Choi <adel.choi@samsung.com>,
        BoRam Shin <boram.shin@samsung.com>
Subject: Re: [PATCH v7 0/4] scsi: ufs: Add Host Performance Booster Support
In-Reply-To: <231786897.01596600181895.JavaMail.epsvc@epcpadp2>
References: <CGME20200805033750epcms2p3fd74b94500593df38d50e1bf426c2347@epcms2p3>
 <231786897.01596600181895.JavaMail.epsvc@epcpadp2>
Message-ID: <3e36260c917ce65963a1ee2cd040c0f3@codeaurora.org>
X-Sender: cang@codeaurora.org
User-Agent: Roundcube Webmail/1.3.9
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Daejun,

On 2020-08-05 11:37, Daejun Park wrote:
> Changelog:
> 
> v6 -> v7
> 1. Remove UFS feature layer.
> 2. Cleanup for sparse error.
> 
> v5 -> v6
> Change base commit to b53293fa662e28ae0cdd40828dc641c09f133405
> 
> v4 -> v5
> Delete unused macro define.
> 
> v3 -> v4
> 1. Cleanup.
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
> constrained size, thus lack in memory to keep the whole mapping table.
> Therefore, mapping tables are partially retrieved from NAND flash on
> demand, causing random-read performance degradation.
> 
> To improve random read performance, JESD220-3 (HPB v1.0) proposes HPB
> (Host Performance Booster) which uses host system memory as a cache for 
> the
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
> queried. After checking supported features, the data structure for the 
> HPB
> is initialized according to the device information.
> 
> A read I/O in the active sub-region where the map is cached is changed 
> to
> HPB READ by the HPB.
> 
> The HPB manages the L2P map using information received from the
> device. For active sub-region, the HPB caches through ufshpb_map
> request. For the in-active region, the HPB discards the L2P map.
> When a write I/O occurs in an active sub-region area, associated dirty
> bitmap checked as dirty for preventing stale read.
> 
> HPB is shown to have a performance improvement of 58 - 67% for random 
> read
> workload. [1]
> 
> This series patches are based on the 5.9/scsi-queue branch.
> 
> [1]:
> https://www.usenix.org/conference/hotstorage17/program/presentation/jeong
> 
> Daejun park (4):
>  scsi: ufs: Add UFS feature related parameter
>  scsi: ufs: Introduce HPB feature
>  scsi: ufs: L2P map management for HPB read
>  scsi: ufs: Prepare HPB read for cached sub-region
> 
>  drivers/scsi/ufs/Kconfig  |   18 +
>  drivers/scsi/ufs/Makefile |    1 +
>  drivers/scsi/ufs/ufs.h    |   12 +
>  drivers/scsi/ufs/ufshcd.c |   42 +
>  drivers/scsi/ufs/ufshcd.h |    9 +
>  drivers/scsi/ufs/ufshpb.c | 1926 
> ++++++++++++++++++++++++++++++++++++++++
>  drivers/scsi/ufs/ufshpb.h |  241 +++++
>  7 files changed, 2249 insertions(+)
>  created mode 100644 drivers/scsi/ufs/ufshpb.c
>  created mode 100644 drivers/scsi/ufs/ufshpb.h

I only gave my reviewed-by tag to the very first patch (changes to 
ufshcd.h),
but not the whole series. Please remove those tags accordingly.

Thanks,

Can Guo.
