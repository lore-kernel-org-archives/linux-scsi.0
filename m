Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4F8F9C433ED
	for <linux-scsi@archiver.kernel.org>; Wed, 31 Mar 2021 19:41:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 06CEA61056
	for <linux-scsi@archiver.kernel.org>; Wed, 31 Mar 2021 19:41:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236183AbhCaTks (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 31 Mar 2021 15:40:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56730 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235186AbhCaTkq (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 31 Mar 2021 15:40:46 -0400
Received: from mail-ej1-x62e.google.com (mail-ej1-x62e.google.com [IPv6:2a00:1450:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 22696C061574;
        Wed, 31 Mar 2021 12:40:46 -0700 (PDT)
Received: by mail-ej1-x62e.google.com with SMTP id u9so31788387ejj.7;
        Wed, 31 Mar 2021 12:40:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=message-id:subject:from:to:cc:date:in-reply-to:references
         :user-agent:mime-version:content-transfer-encoding;
        bh=6Yh8B7LxbmaaegPfpCFo+6onwLvIWY/EgGO9ntKTOmU=;
        b=mv5vcJzsO0W1NPhmjtCQ4tojMzho+hpAG5XnZhS+hoG9DDxClaQsZ+tdzvlohi7iXD
         f517MHoxePVdYGoXPbIWcvN0dk8XFSZMCKKXcfpugsi8ztQpSEqUwspYfkjjLtlJtPXQ
         W3gXYHGcXbgWuahvYuuZRhHv3l893obJGJ1s7DbPWZBRNgYRCj354iWThfFD2gHwOUWF
         mWPIBx4/6INLbbmYulmZCEr7yYs2Uj9xV+lERGo6q6337CIQUahYHnzt4X4BU93DiIXn
         veX7ACZwwyvrRp9qXoAhWlKmFqCPUHqU/C5gAjJjW7K8wztDkl+dSNxHHY/pxjDBdmQ6
         VhAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=6Yh8B7LxbmaaegPfpCFo+6onwLvIWY/EgGO9ntKTOmU=;
        b=gu1lEbp2imqvL9kX3RC/S8vVFbifxQnqb1gt5rlkX9+GvAKkGszln3VjBgZ2j1TYAw
         hbI62AzaeHnZm8tuVHGQPOexF5PiIUdP8NIclHWOro8f9LWbL7iZxznF8hum3WYYdQRe
         IvWvKaqVmU4ll92B7QgH9BtZhP4uTDNIvv8za561NszRqn3HLRqoZR8Swzr/kJKXd3Tc
         DzBXnWg39rAYR/EEeRzfc1a+mR4UIlkcJVSw2K2EqklppBulPgko/svpSps/A1BGi91c
         N9ZZ8Lc4Uo98qrsRnd5Tw1Xdk6f08kVjM63yfnR353cWBYzf6MnC00D7Pshk5OHfPgUk
         BA0Q==
X-Gm-Message-State: AOAM5333oexIwVMqCyLPQ4cDskLKs/x3UeBRtLWqqSmEwl8T8cMaCwav
        brINpJ3kWDNKvaVvWYCxaH8=
X-Google-Smtp-Source: ABdhPJxFqgHYupfgGWTcshfwdfP0cMJDMdQAfSq6MLc1WpQPIXljRO5oWccQ+pRQnTnIptoX7GaUbg==
X-Received: by 2002:a17:907:2bdd:: with SMTP id gv29mr5208555ejc.259.1617219644697;
        Wed, 31 Mar 2021 12:40:44 -0700 (PDT)
Received: from ubuntu-laptop (ip5f5bec5d.dynamic.kabel-deutschland.de. [95.91.236.93])
        by smtp.googlemail.com with ESMTPSA id q16sm2321341edv.61.2021.03.31.12.40.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 31 Mar 2021 12:40:44 -0700 (PDT)
Message-ID: <a57cc487bcd1ccea0bc328d394d3ebdafb67a2f5.camel@gmail.com>
Subject: Re: [PATCH v32 0/4] scsi: ufs: Add Host Performance Booster Support
From:   Bean Huo <huobean@gmail.com>
To:     daejun7.park@samsung.com, Greg KH <gregkh@linuxfoundation.org>,
        "avri.altman@wdc.com" <avri.altman@wdc.com>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "asutoshd@codeaurora.org" <asutoshd@codeaurora.org>,
        "stanley.chu@mediatek.com" <stanley.chu@mediatek.com>,
        "cang@codeaurora.org" <cang@codeaurora.org>,
        "bvanassche@acm.org" <bvanassche@acm.org>,
        ALIM AKHTAR <alim.akhtar@samsung.com>
Cc:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        JinHwan Park <jh.i.park@samsung.com>,
        Javier Gonzalez <javier.gonz@samsung.com>,
        Sung-Jun Park <sungjun07.park@samsung.com>,
        Jinyoung CHOI <j-young.choi@samsung.com>,
        Dukhyun Kwon <d_hyun.kwon@samsung.com>,
        Keoseong Park <keosung.park@samsung.com>,
        Jaemyung Lee <jaemyung.lee@samsung.com>,
        Jieon Seol <jieon.seol@samsung.com>
Date:   Wed, 31 Mar 2021 21:40:42 +0200
In-Reply-To: <20210331011526epcms2p37684869a9781d1eb45bfcbfe9babd217@epcms2p3>
References: <CGME20210331011526epcms2p37684869a9781d1eb45bfcbfe9babd217@epcms2p3>
         <20210331011526epcms2p37684869a9781d1eb45bfcbfe9babd217@epcms2p3>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.4-0ubuntu1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Martin

I don't know when/how do you plan to accept this patch. I think the
Mobile vendors and chipset vendors are all looking forward to this UFS
HPB feature that can be mainlined in the upstream Linux. Since the
first version HPB driver submitted in the community, it is now V32, and
we have been working on this feature for two years. Would you please
take a look at this? thanks.

Kind regards,
Bean



On Wed, 2021-03-31 at 10:15 +0900, Daejun Park wrote:
> Changelog:
> 
> v31 -> v32
> Delete unused parameter of unmap API.
> 
> v30 -> v31
> Delete unnecessary debug message.
> 
> v29 -> v30
> 1. Add support to reuse bio of pre-request.
> 2. Delete unreached code in the ufshpb_issue_map_req.
> 
> v28 -> v29
> 1. Remove unused variable that reported by kernel test robot.
> 
> v27 -> v28
> 1. Fix wrong return value of ufshpb_prep.
> 
> v26 -> v27
> 1. Fix wrong refernce of sense buffer in pre_req complete function.
> 2. Fix read_id error.
> 3. Fix chunk size checking for HPB 1.0.
> 4. Mute unnecessary messages before HPB initialization.
> 
> v25 -> v26
> 1. Fix wrong chunk size checking for HPB 1.0.
> 2. Fix wrong max data size for HPB single command.
> 3. Fix typo error.
> 
> v24 -> v25
> 1. Change write buffer API for unmap region.
> 2. Add checking hpb_enable for avoiding unnecessary memory
> allocation.
> 3. Change pr_info to dev_info.
> 4. Change default requeue timeout value for HPB read.
> 5. Fix wrong offset manipulation on ufshpb_prep_entry.
> 
> v23 -> v24
> 1. Fix build error reported by kernel test robot.
> 
> v22 -> v23
> 1. Add support compatibility of HPB 1.0.
> 2. Fix read id for single HPB read command.
> 3. Fix number of pre-allocated requests for write buffer.
> 4. Add fast path for response UPIU that has same LUN in sense data.
> 5. Remove WARN_ON for preventing kernel crash.
> 7. Fix wrong argument for read buffer command.
> 
> v21 -> v22
> 1. Add support processing response UPIU in suspend state.
> 2. Add support HPB hint from other LU.
> 3. Add sending write buffer with 0x03 after HPB init.
> 
> v20 -> v21
> 1. Add bMAX_DATA_SIZE_FOR_HPB_SINGLE_CMD attr. and fHPBen flag
> support.
> 
> v19 -> v20
> 1. Add documentation for sysfs entries of hpb->stat.
> 2. Fix read buffer command for under-sized sub-region.
> 3. Fix wrong condition checking for kick map work.
> 4. Delete redundant response UPIU checking.
> 5. Add LUN checking in response UPIU.
> 6. Fix possible deadlock problem due to runtime PM.
> 7. Add instant changing of sub-region state from response UPIU.
> 8. Fix endian problem in prefetched PPN.
> 9. Add JESD220-3A (HPB v2.0) support.
> 
> v18 -> 19
> 1. Fix null pointer error when printing sysfs from non-HPB LU.
> 2. Apply HPB read opcode in lrbp->cmd->cmnd (from Can Guo's review).
> 3. Rebase the patch on 5.12/scsi-queue.
> 
> v17 -> v18
> Fix build error which reported by kernel test robot.
> 
> v16 -> v17
> 1. Rename hpb_state_lock to rgn_state_lock and move it to
> corresponding
> patch.
> 2. Remove redundant information messages.
> 
> v15 -> v16
> 1. Add missed sysfs ABI documentation.
> 
> v14 -> v15
> 1. Remove duplicated sysfs ABI entries in documentation.
> 2. Add experiment result of HPB performance testing with iozone.
> 
> v13 -> v14
> 1. Cleanup codes by commentted in Greg's review.
> 2. Add documentation for sysfs entries (from Greg's review).
> 3. Add experiment result of HPB performance testing.
> 
> v12 -> v13
> 1. Cleanup codes by comments from Can Guo.
> 2. Add HPB related descriptor/flag/attributes in sysfs.
> 3. Change base commit from 5.10/scsi-queue to 5.11/scsi-queue.
> 
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
> This patch consists of 3 parts to support HPB feature.
> 
> 1) HPB probe and initialization process
> 2) READ -> HPB READ using cached map information
> 3) L2P (logical to physical) map management
> 
> In the HPB probe and init process, the device information of the UFS
> is
> queried. After checking supported features, the data structure for
> the HPB
> is initialized according to the device information.
> 
> A read I/O in the active sub-region where the map is cached is
> changed to
> HPB READ by the HPB.
> 
> The HPB manages the L2P map using information received from the
> device. For active sub-region, the HPB caches through ufshpb_map
> request. For the in-active region, the HPB discards the L2P map.
> When a write I/O occurs in an active sub-region area, associated
> dirty
> bitmap checked as dirty for preventing stale read.
> 
> HPB is shown to have a performance improvement of 58 - 67% for random
> read
> workload. [1]
> 
> [1]:
> https://www.usenix.org/conference/hotstorage17/program/presentation/jeong
> 
> Daejun Park (4):
>   scsi: ufs: Introduce HPB feature
>   scsi: ufs: L2P map management for HPB read
>   scsi: ufs: Prepare HPB read for cached sub-region
>   scsi: ufs: Add HPB 2.0 support
> 
>  Documentation/ABI/testing/sysfs-driver-ufs |  162 ++
>  drivers/scsi/ufs/Kconfig                   |    9 +
>  drivers/scsi/ufs/Makefile                  |    1 +
>  drivers/scsi/ufs/ufs-sysfs.c               |   22 +
>  drivers/scsi/ufs/ufs.h                     |   54 +-
>  drivers/scsi/ufs/ufshcd.c                  |   74 +-
>  drivers/scsi/ufs/ufshcd.h                  |   29 +
>  drivers/scsi/ufs/ufshpb.c                  | 2387
> ++++++++++++++++++++
>  drivers/scsi/ufs/ufshpb.h                  |  277 +++
>  9 files changed, 3013 insertions(+), 2 deletions(-)
>  create mode 100644 drivers/scsi/ufs/ufshpb.c
>  create mode 100644 drivers/scsi/ufs/ufshpb.h
> 

