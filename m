Return-Path: <SRS0=zqxZ=EL=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F3F5CC00A89
	for <linux-scsi@archiver.kernel.org>; Thu,  5 Nov 2020 08:16:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7E8E72083B
	for <linux-scsi@archiver.kernel.org>; Thu,  5 Nov 2020 08:16:56 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=mg.codeaurora.org header.i=@mg.codeaurora.org header.b="spgw02Bz"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730242AbgKEIQ4 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 5 Nov 2020 03:16:56 -0500
Received: from z5.mailgun.us ([104.130.96.5]:31356 "EHLO z5.mailgun.us"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728784AbgKEIQz (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 5 Nov 2020 03:16:55 -0500
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1604564214; h=Message-ID: References: In-Reply-To: Subject:
 Cc: To: From: Date: Content-Transfer-Encoding: Content-Type:
 MIME-Version: Sender; bh=Ofr/IU9q9HzUV/4oAnzXWDSWS1kDaOQDloGodFOhgDk=;
 b=spgw02BzjRVJcV/U7Ip0UjuuDgau+QnjpYAbP5GmicXVM2dcqyK4WWA/SmKbd4luNfPviW/H
 FmxmXf8PSoGR0qdSiMy0FouKtOiGckcnaGPZnOYMeMCsMp7qJwQttrD5ndnNGQawTnxgPijo
 MnabGb0bNCqgHT1A28RBnTKp4IU=
X-Mailgun-Sending-Ip: 104.130.96.5
X-Mailgun-Sid: WyJlNmU5NiIsICJsaW51eC1zY3NpQHZnZXIua2VybmVsLm9yZyIsICJiZTllNGEiXQ==
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n05.prod.us-east-1.postgun.com with SMTP id
 5fa3b4f6d71755da896b2102 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Thu, 05 Nov 2020 08:16:54
 GMT
Sender: cang=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 71C28C43385; Thu,  5 Nov 2020 08:16:53 +0000 (UTC)
Received: from mail.codeaurora.org (localhost.localdomain [127.0.0.1])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: cang)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id A9C54C433C6;
        Thu,  5 Nov 2020 08:16:51 +0000 (UTC)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Thu, 05 Nov 2020 16:16:51 +0800
From:   Can Guo <cang@codeaurora.org>
To:     daejun7.park@samsung.com
Cc:     avri.altman@wdc.com, jejb@linux.ibm.com,
        martin.petersen@oracle.com, asutoshd@codeaurora.org,
        beanhuo@micron.com, stanley.chu@mediatek.com, bvanassche@acm.org,
        tomas.winkler@intel.com, ALIM AKHTAR <alim.akhtar@samsung.com>,
        gregkh@google.com, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Sang-yoon Oh <sangyoon.oh@samsung.com>,
        Sung-Jun Park <sungjun07.park@samsung.com>,
        yongmyung lee <ymhungry.lee@samsung.com>,
        Jinyoung CHOI <j-young.choi@samsung.com>,
        Adel Choi <adel.choi@samsung.com>,
        BoRam Shin <boram.shin@samsung.com>,
        SEUNGUK SHIN <seunguk.shin@samsung.com>
Subject: Re: [PATCH v13 0/3] scsi: ufs: Add Host Performance Booster Support
In-Reply-To: <2038148563.21604378702426.JavaMail.epsvc@epcpadp3>
References: <CGME20201103044021epcms2p8f1556853fc23414442b9e958f20781ce@epcms2p8>
 <2038148563.21604378702426.JavaMail.epsvc@epcpadp3>
Message-ID: <b4d029e606a82b4b83c8b5c2cc0626fd@codeaurora.org>
X-Sender: cang@codeaurora.org
User-Agent: Roundcube Webmail/1.3.9
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2020-11-03 12:40, Daejun Park wrote:
> Changelog:
> 
> v12 -> v13
> 1. Cleanup codes by comments from Can Guo.
> 2. Add HPB related descriptor/flag/attributes in sysfs.
> 3. Change base commit from 5.10/scsi-queue to 5.11/scsi-queue.
> 

If you have changed the code based by comments left on Google gerrit, 
here is

Reviewed-by: Can Guo <cang@codeaurora.org>

> v11 -> v12
> 1. Fixed to return error value when HPB fails to initialize pinned 
> active
> region.
> 2. Fixed to disable HPB feature if HPB fails to allocate essential 
> memory
> and workqueue.
> 3. Fixed to change proper sub-region state when region is already 
> evicted.
> 
> v10 -> v11
> Add a newline at end the last line on Kconfig file.
> 
> v9 -> v10
> 1. Fixed 64-bit division error
> 2. Fixed problems commentted in Bart's review.
> 
> v8 -> v9
> 1. Change sysfs initialization.
> 2. Change reading descriptor during HPB initialization
> 3. Fixed problems commentted in Bart's review.
> 4. Change base commit from 5.9/scsi-queue to 5.10/scsi-queue.
> 
> v7 -> v8
> Remove wrongly added tags.
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
> This series patches are based on the 5.11/scsi-queue branch.
> 
> [1]:
> https://www.usenix.org/conference/hotstorage17/program/presentation/jeong
> 
> Daejun park (3):
>  scsi: ufs: Introduce HPB feature
>  scsi: ufs: L2P map management for HPB read
>  scsi: ufs: Prepare HPB read for cached sub-region
> 
>  drivers/scsi/ufs/Kconfig     |    9 +
>  drivers/scsi/ufs/Makefile    |    1 +
>  drivers/scsi/ufs/ufs-sysfs.c |   18 +
>  drivers/scsi/ufs/ufs.h       |   49 +
>  drivers/scsi/ufs/ufshcd.c    |   53 ++
>  drivers/scsi/ufs/ufshcd.h    |   23 +-
>  drivers/scsi/ufs/ufshpb.c    | 1784 
> +++++++++++++++++++++++++++++++++++++
>  drivers/scsi/ufs/ufshpb.h    |  230 +++++
>  8 files changed, 2166 insertions(+), 1 deletion(-)
>  created mode 100644 drivers/scsi/ufs/ufshpb.c
>  created mode 100644 drivers/scsi/ufs/ufshpb.h
