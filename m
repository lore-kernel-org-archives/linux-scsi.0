Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 55619C433E9
	for <linux-scsi@archiver.kernel.org>; Fri, 29 Jan 2021 05:29:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 07EA464E12
	for <linux-scsi@archiver.kernel.org>; Fri, 29 Jan 2021 05:29:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231734AbhA2F3k (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 29 Jan 2021 00:29:40 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:63376 "EHLO
        mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229459AbhA2F3h (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 29 Jan 2021 00:29:37 -0500
Received: from epcas2p2.samsung.com (unknown [182.195.41.54])
        by mailout1.samsung.com (KnoxPortal) with ESMTP id 20210129052852epoutp016ede7299e97b3e927528793cca83ce17~enM-LHXtP2122621226epoutp01b
        for <linux-scsi@vger.kernel.org>; Fri, 29 Jan 2021 05:28:52 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20210129052852epoutp016ede7299e97b3e927528793cca83ce17~enM-LHXtP2122621226epoutp01b
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1611898132;
        bh=/PYH+j5T2650ih3jInbn5tr4ZN8BrOmlxjFqLLzFLGk=;
        h=Subject:Reply-To:From:To:CC:Date:References:From;
        b=OgpWKUxGuIyR9cUxnctJRMLrnaOQmte6o+MokUdJax4ip+Ia4rhNsCr2I/RVd//l8
         +mthLrMwWja46nGOPR5Kjdigl9pOVNlIe/v7WmXi3xjMaMiLzsVNjIfQe/UEG0eLBd
         Zddtcejf/QYfVMUrY27m/mqobjWUKdox31aXGKtU=
Received: from epsnrtp4.localdomain (unknown [182.195.42.165]) by
        epcas2p3.samsung.com (KnoxPortal) with ESMTP id
        20210129052852epcas2p342cd5ef4d2f784f2fb8e5e060ee6b0b7~enM_gkvwd2720027200epcas2p3P;
        Fri, 29 Jan 2021 05:28:52 +0000 (GMT)
Received: from epsmges2p3.samsung.com (unknown [182.195.40.182]) by
        epsnrtp4.localdomain (Postfix) with ESMTP id 4DRm8x2rQfz4x9Pv; Fri, 29 Jan
        2021 05:28:49 +0000 (GMT)
X-AuditID: b6c32a47-b81ff7000000148e-e9-60139d115225
Received: from epcas2p3.samsung.com ( [182.195.41.55]) by
        epsmges2p3.samsung.com (Symantec Messaging Gateway) with SMTP id
        14.FB.05262.11D93106; Fri, 29 Jan 2021 14:28:49 +0900 (KST)
Mime-Version: 1.0
Subject: [PATCH v19 0/3] scsi: ufs: Add Host Performance Booster Support
Reply-To: daejun7.park@samsung.com
Sender: Daejun Park <daejun7.park@samsung.com>
From:   Daejun Park <daejun7.park@samsung.com>
To:     Greg KH <gregkh@linuxfoundation.org>,
        "avri.altman@wdc.com" <avri.altman@wdc.com>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "asutoshd@codeaurora.org" <asutoshd@codeaurora.org>,
        "stanley.chu@mediatek.com" <stanley.chu@mediatek.com>,
        "cang@codeaurora.org" <cang@codeaurora.org>,
        "huobean@gmail.com" <huobean@gmail.com>,
        "bvanassche@acm.org" <bvanassche@acm.org>,
        ALIM AKHTAR <alim.akhtar@samsung.com>,
        Daejun Park <daejun7.park@samsung.com>
CC:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Sung-Jun Park <sungjun07.park@samsung.com>,
        yongmyung lee <ymhungry.lee@samsung.com>,
        Jinyoung CHOI <j-young.choi@samsung.com>,
        BoRam Shin <boram.shin@samsung.com>,
        SEUNGUK SHIN <seunguk.shin@samsung.com>
X-Priority: 3
X-Content-Kind-Code: NORMAL
X-CPGS-Detection: blocking_info_exchange
X-Drm-Type: N,general
X-Msg-Generator: Mail
X-Msg-Type: PERSONAL
X-Reply-Demand: N
Message-ID: <20210129052848epcms2p6e5797efd94e6282b76ad9ae6c99e3ab5@epcms2p6>
Date:   Fri, 29 Jan 2021 14:28:48 +0900
X-CMS-MailID: 20210129052848epcms2p6e5797efd94e6282b76ad9ae6c99e3ab5
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
X-CPGSPASS: Y
X-CPGSPASS: Y
CMS-TYPE: 102P
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrBJsWRmVeSWpSXmKPExsWy7bCmua7gXOEEg5d3BS0ezNvGZrG37QS7
        xcufV9ksDt9+x24x7cNPZotP65exWrw8pGmx6kG4RfPi9WwWc842MFn09m9ls1h0YxuTxeVd
        c9gsuq/vYLNYfvwfk8XtLVwWS7feZLTonL6GxWLRwt0sDsIel694e1zu62Xy2DnrLrvHhEUH
        GD32z13D7tFycj+Lx8ent1g8+rasYvT4vEnOo/1AN1MAV1SOTUZqYkpqkUJqXnJ+SmZeuq2S
        d3C8c7ypmYGhrqGlhbmSQl5ibqqtkotPgK5bZg7QX0oKZYk5pUChgMTiYiV9O5ui/NKSVIWM
        /OISW6XUgpScAkPDAr3ixNzi0rx0veT8XCtDAwMjU6DKhJyMh6v3shbcUqn4vOMPSwPjQ5ku
        Rk4OCQETiZ0Xj7N1MXJxCAnsYJSYs2EHSxcjBwevgKDE3x3CIDXCAh4SL9ZcYwSxhQSUJNZf
        nMUOEdeTuPVwDVicTUBHYvqJ++wgc0QEWlkkzh6awgKSYBa4xCTxd74jxDJeiRntT1kgbGmJ
        7cu3MkLYGhI/lvUyQ9iiEjdXv2WHsd8fmw9VIyLReu8sVI2gxIOfu6HikhLHdn9ggrDrJbbe
        +cUIcoSEQA+jxOGdt1ghEvoS1zo2gi3mFfCVuPh5IxuIzSKgKjFrylqoGheJ693L2SCOlpfY
        /nYOMyggmAU0Jdbv0gcxJQSUJY7cYoF5pWHjb3Z0NrMAn0TH4b9w8R3znkCdpiax7ud6Jogx
        MhK35jFOYFSahQjoWUjWzkJYu4CReRWjWGpBcW56arFRgTFy3G5iBCdxLfcdjDPeftA7xMjE
        wXiIUYKDWUmE9+0coQQh3pTEyqrUovz4otKc1OJDjKZAD09klhJNzgfmkbySeENTIzMzA0tT
        C1MzIwslcd5igwfxQgLpiSWp2ampBalFMH1MHJxSDUwxf/VLgu8k//l9W+f5zPDLP5rZG0uF
        +LP42j96pJi+XuUVXHytyCfIaV+Mkf8qB47Q7jd8l1fvyT6/6PoL27tss4q2qf++Z7Ao/4+d
        9y+9DKalNlWi6qZTp0eevLv555z6FI/CH2/n+kdxz9p7pubnCsaVUyrZZuzlm91oX7Fn2gXV
        xa4vFDtauecddi+5+YQvLN5rwp+Xa5h7rFnnL5zn1vqyk2WP7/pvT3mtf57gMO977mGovbJn
        0Z0eE44//VUt3P55qtNCkoy0606kbw/8Yrdi0dlplmb5LPlVM9Zcur7ywPZm5QVzphbM3ZHs
        csxDMmfRZrtpk+S27NwbeJrB1dnM1/uMvkPKXY21UwqUWIozEg21mIuKEwHvcVagawQAAA==
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20210129052848epcms2p6e5797efd94e6282b76ad9ae6c99e3ab5
References: <CGME20210129052848epcms2p6e5797efd94e6282b76ad9ae6c99e3ab5@epcms2p6>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Changelog:

v18 -> 19
1. Fix null pointer error when printing sysfs from non-HPB LU.
2. Apply HPB read opcode in lrbp->cmd->cmnd (from Can Guo's review).
3. Rebase the patch on 5.12/scsi-queue.

v17 -> v18
Fix build error which reported by kernel test robot.

v16 -> v17
1. Rename hpb_state_lock to rgn_state_lock and move it to corresponding
patch.
2. Remove redundant information messages.

v15 -> v16
1. Add missed sysfs ABI documentation.

v14 -> v15
1. Remove duplicated sysfs ABI entries in documentation.
2. Add experiment result of HPB performance testing with iozone.

v13 -> v14
1. Cleanup codes by commentted in Greg's review.
2. Add documentation for sysfs entries (from Greg's review).
3. Add experiment result of HPB performance testing.

v12 -> v13
1. Cleanup codes by comments from Can Guo.
2. Add HPB related descriptor/flag/attributes in sysfs.
3. Change base commit from 5.10/scsi-queue to 5.11/scsi-queue.

v11 -> v12
1. Fixed to return error value when HPB fails to initialize pinned active 
region.
2. Fixed to disable HPB feature if HPB fails to allocate essential memory
and workqueue.
3. Fixed to change proper sub-region state when region is already evicted.

v10 -> v11
Add a newline at end the last line on Kconfig file.

v9 -> v10
1. Fixed 64-bit division error
2. Fixed problems commentted in Bart's review.

v8 -> v9
1. Change sysfs initialization.
2. Change reading descriptor during HPB initialization
3. Fixed problems commentted in Bart's review.
4. Change base commit from 5.9/scsi-queue to 5.10/scsi-queue.

v7 -> v8
Remove wrongly added tags.

v6 -> v7
1. Remove UFS feature layer.
2. Cleanup for sparse error.

v5 -> v6
Change base commit to b53293fa662e28ae0cdd40828dc641c09f133405

v4 -> v5
Delete unused macro define.

v3 -> v4
1. Cleanup.

v2 -> v3
1. Add checking input module parameter value.
2. Change base commit from 5.8/scsi-queue to 5.9/scsi-queue.
3. Cleanup for unused variables and label.

v1 -> v2
1. Change the full boilerplate text to SPDX style.
2. Adopt dynamic allocation for sub-region data structure.
3. Cleanup.

NAND flash memory-based storage devices use Flash Translation Layer (FTL)
to translate logical addresses of I/O requests to corresponding flash
memory addresses. Mobile storage devices typically have RAM with
constrained size, thus lack in memory to keep the whole mapping table.
Therefore, mapping tables are partially retrieved from NAND flash on
demand, causing random-read performance degradation.

To improve random read performance, JESD220-3 (HPB v1.0) proposes HPB
(Host Performance Booster) which uses host system memory as a cache for the
FTL mapping table. By using HPB, FTL data can be read from host memory
faster than from NAND flash memory. 

The current version only supports the DCM (device control mode).
This patch consists of 3 parts to support HPB feature.

1) HPB probe and initialization process
2) READ -> HPB READ using cached map information
3) L2P (logical to physical) map management

In the HPB probe and init process, the device information of the UFS is
queried. After checking supported features, the data structure for the HPB
is initialized according to the device information.

A read I/O in the active sub-region where the map is cached is changed to
HPB READ by the HPB.

The HPB manages the L2P map using information received from the
device. For active sub-region, the HPB caches through ufshpb_map
request. For the in-active region, the HPB discards the L2P map.
When a write I/O occurs in an active sub-region area, associated dirty
bitmap checked as dirty for preventing stale read.

HPB is shown to have a performance improvement of 58 - 67% for random read
workload. [1]

[1]:
https://www.usenix.org/conference/hotstorage17/program/presentation/jeong

Daejun Park (3):
  scsi: ufs: Introduce HPB feature
  scsi: ufs: L2P map management for HPB read
  scsi: ufs: Prepare HPB read for cached sub-region

 Documentation/ABI/testing/sysfs-driver-ufs |   71 +
 drivers/scsi/ufs/Kconfig                   |    9 +
 drivers/scsi/ufs/Makefile                  |    1 +
 drivers/scsi/ufs/ufs-sysfs.c               |   18 +
 drivers/scsi/ufs/ufs.h                     |   51 +
 drivers/scsi/ufs/ufshcd.c                  |   55 +
 drivers/scsi/ufs/ufshcd.h                  |   22 +
 drivers/scsi/ufs/ufshpb.c                  | 1758 ++++++++++++++++++++
 drivers/scsi/ufs/ufshpb.h                  |  231 +++
 9 files changed, 2216 insertions(+)
 create mode 100644 drivers/scsi/ufs/ufshpb.c
 create mode 100644 drivers/scsi/ufs/ufshpb.h

-- 
2.25.1

