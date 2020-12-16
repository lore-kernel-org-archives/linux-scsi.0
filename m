Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 88C93C4361B
	for <linux-scsi@archiver.kernel.org>; Wed, 16 Dec 2020 02:45:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 549E723103
	for <linux-scsi@archiver.kernel.org>; Wed, 16 Dec 2020 02:45:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725766AbgLPCpd (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 15 Dec 2020 21:45:33 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:19496 "EHLO
        mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725440AbgLPCpc (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 15 Dec 2020 21:45:32 -0500
Received: from epcas2p2.samsung.com (unknown [182.195.41.54])
        by mailout4.samsung.com (KnoxPortal) with ESMTP id 20201216024449epoutp042008f88666d6f744321b839eb36f26da~RElLt83GX0392603926epoutp04i
        for <linux-scsi@vger.kernel.org>; Wed, 16 Dec 2020 02:44:49 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20201216024449epoutp042008f88666d6f744321b839eb36f26da~RElLt83GX0392603926epoutp04i
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1608086689;
        bh=MGkeB468zkBzcgmDZFV0KJyIkPB1NRuv8YC3RyJqLv8=;
        h=Subject:Reply-To:From:To:CC:Date:References:From;
        b=G/f0grFJH6iHnj3h/DPI6/APS+H2xIDFBqXx0CztaUMtXUHVEOHEO5gqqsFwggy1l
         X4LuKkrTESK6H+gKnTMpf457hcQ2JS7K9VZwJ5bvGX53G1Z9Ujl+N7ObTH01EO4Kzh
         9OkJZPfFgyIQcfPSK6+SdYC+81mBw7zjEl8U/KUI=
Received: from epsnrtp1.localdomain (unknown [182.195.42.162]) by
        epcas2p3.samsung.com (KnoxPortal) with ESMTP id
        20201216024448epcas2p381f1850cf695c6898429e0cab3adcf37~RElKtoacy0210002100epcas2p3k;
        Wed, 16 Dec 2020 02:44:48 +0000 (GMT)
Received: from epsmges2p3.samsung.com (unknown [182.195.40.183]) by
        epsnrtp1.localdomain (Postfix) with ESMTP id 4Cwfbx2Sctz4x9Py; Wed, 16 Dec
        2020 02:44:45 +0000 (GMT)
X-AuditID: b6c32a47-b81ff7000000148e-ef-5fd9749c6275
Received: from epcas2p1.samsung.com ( [182.195.41.53]) by
        epsmges2p3.samsung.com (Symantec Messaging Gateway) with SMTP id
        D1.C4.05262.C9479DF5; Wed, 16 Dec 2020 11:44:44 +0900 (KST)
Mime-Version: 1.0
Subject: [PATCH v14 0/3] scsi: ufs: Add Host Performance Booster Support
Reply-To: daejun7.park@samsung.com
Sender: Daejun Park <daejun7.park@samsung.com>
From:   Daejun Park <daejun7.park@samsung.com>
To:     "avri.altman@wdc.com" <avri.altman@wdc.com>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "asutoshd@codeaurora.org" <asutoshd@codeaurora.org>,
        "stanley.chu@mediatek.com" <stanley.chu@mediatek.com>,
        "cang@codeaurora.org" <cang@codeaurora.org>,
        "bvanassche@acm.org" <bvanassche@acm.org>,
        "huobean@gmail.com" <huobean@gmail.com>,
        ALIM AKHTAR <alim.akhtar@samsung.com>,
        Daejun Park <daejun7.park@samsung.com>
CC:     Greg KH <gregkh@linuxfoundation.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Sung-Jun Park <sungjun07.park@samsung.com>,
        yongmyung lee <ymhungry.lee@samsung.com>,
        Jinyoung CHOI <j-young.choi@samsung.com>,
        Adel Choi <adel.choi@samsung.com>,
        BoRam Shin <boram.shin@samsung.com>,
        SEUNGUK SHIN <seunguk.shin@samsung.com>
X-Priority: 3
X-Content-Kind-Code: NORMAL
X-CPGS-Detection: blocking_info_exchange
X-Drm-Type: N,general
X-Msg-Generator: Mail
X-Msg-Type: PERSONAL
X-Reply-Demand: N
Message-ID: <20201216024444epcms2p5e69281911dd675306c473df3d2cef8b2@epcms2p5>
Date:   Wed, 16 Dec 2020 11:44:44 +0900
X-CMS-MailID: 20201216024444epcms2p5e69281911dd675306c473df3d2cef8b2
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
X-CPGSPASS: Y
X-CPGSPASS: Y
CMS-TYPE: 102P
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrHJsWRmVeSWpSXmKPExsWy7bCmqe6ckpvxBjeXKFhsvPuK1eLBvG1s
        FnvbTrBbvPx5lc3i8O137BbTPvxktvi0fhmrxctDmharHoRbNC9ez2Yx52wDk0Vv/1Y2i0U3
        tjFZXN41h82i+/oONovlx/8xWdzewmWxdOtNRovO6WtYLBYt3M3iIOJx+Yq3x+W+XiaPnbPu
        sntMWHSA0WP/3DXsHi0n97N4fHx6i8Wjb8sqRo/Pm+Q82g90MwVwReXYZKQmpqQWKaTmJeen
        ZOal2yp5B8c7x5uaGRjqGlpamCsp5CXmptoqufgE6Lpl5gA9p6RQlphTChQKSCwuVtK3synK
        Ly1JVcjILy6xVUotSMkpMDQs0CtOzC0uzUvXS87PtTI0MDAyBapMyMm49vofU8FT9Ypbcz8x
        NTC+keti5OSQEDCRuLjwLFsXIxeHkMAORone3vdADgcHr4CgxN8dwiA1wgIeEpvPn2MBsYUE
        lCTWX5zFDhHXk7j1cA0jiM0moCMx/cR9dpA5IgL3mSU6F75gAXGYBeYySxw9+4cZYhuvxIz2
        pywQtrTE9uVbGSFsDYkfy3qhakQlbq5+yw5jvz82H6pGRKL13lmoGkGJBz93Q8UlJY7t/sAE
        YddLbL3zixFksYRAD6PE4Z23WCES+hLXOjaCLeYV8JVYefInWJxFQFXi2rR/UAe5SMxe8Bts
        ELOAvMT2t3OYQSHBLKApsX6XPogpIaAsceQWC8wrDRt/s6OzmQX4JDoO/4WL75j3BOo0NYl1
        P9czQYyRkbg1j3ECo9IsREjPQrJ2FsLaBYzMqxjFUguKc9NTi40KjJEjdxMjOKFrue9gnPH2
        g94hRiYOxkOMEhzMSiK8f97eiBfiTUmsrEotyo8vKs1JLT7EaAr08ERmKdHkfGBOySuJNzQ1
        MjMzsDS1MDUzslAS5w1d2RcvJJCeWJKanZpakFoE08fEwSnVwLTk/79TDPtCVj5fZdKnn//o
        YcYH9sw4f0ZLtm+KTSI83BJm6i9nBExZwivxMeBVX8gswenqHrplJSESX/O4Xu0U/ten5TaT
        VzZnzobd/Gf+X162Ms1U43fxmfs/M+Nunl3J/23xVqkZf2fHB2QGqbIf/+jwL9GQL+h8wAOB
        DNcPdVsVfIX6JSZzqBkHzr9px/Yuu//zgVfnfvn3v+w/MJPD42cAg7Ky5lnfokTpgKa/nSn7
        GxxX7Mreu2HSO+0PuSUCjnZfSxak53+0/J1tnBz8a053rtMBL59PC5Zuy5xz6BqT4VqzAPY9
        5vp+U867lIj887m/QNJxtdmXWIYDfpsmdTwTeqFqUm1eUFi1VomlOCPRUIu5qDgRAPE/iOlx
        BAAA
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20201215082235epcms2p88c9d8fd4dc773f6a4901dab241063306
References: <CGME20201215082235epcms2p88c9d8fd4dc773f6a4901dab241063306@epcms2p5>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Changelog:

v13 -> v14
1. Cleanup codes by commentted in Greg's review.
2. Add documentation for sysfs entries (from Greg's review).
3. Add experiment result of HPB performance testing. (in this mail)

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

We measured the total start-up time of popular applications and observed
the difference by enabling the HPB.
Popular applications are 12 game apps and 24 non-game apps. Each target
applications were launched in order. The cycle consists of running 36
applications in sequence. We repeated the cycle for observing performance
improvement by L2P mapping cache hit in HPB.

The Following is experiment environment:
 - kernel version: 4.4.0 
 - UFS 2.1 (64GB)

Result:
+-------+----------+----------+-------+
| cycle | baseline | with HPB | diff  |
+-------+----------+----------+-------+
| 1     | 272.4    | 264.9    | -7.5  |
| 2     | 250.4    | 248.2    | -2.2  |
| 3     | 226.2    | 215.6    | -10.6 |
| 4     | 230.6    | 214.8    | -15.8 |
| 5     | 232.0    | 218.1    | -13.9 |
| 6     | 231.9    | 212.6    | -19.3 |
+-------+----------+----------+-------+

This series patches are based on the 5.11/scsi-queue branch.

[1]:
https://www.usenix.org/conference/hotstorage17/program/presentation/jeong

Daejun Park (3):
  scsi: ufs: Introduce HPB feature
  scsi: ufs: L2P map management for HPB read
  scsi: ufs: Prepare HPB read for cached sub-region

 Documentation/ABI/testing/sysfs-driver-ufs |   80 +
 drivers/scsi/ufs/Kconfig                   |    9 +
 drivers/scsi/ufs/Makefile                  |    1 +
 drivers/scsi/ufs/ufs-sysfs.c               |   18 +
 drivers/scsi/ufs/ufs.h                     |   49 +
 drivers/scsi/ufs/ufshcd.c                  |   53 +
 drivers/scsi/ufs/ufshcd.h                  |   23 +-
 drivers/scsi/ufs/ufshpb.c                  | 1767 ++++++++++++++++++++
 drivers/scsi/ufs/ufshpb.h                  |  230 +++
 9 files changed, 2229 insertions(+), 1 deletion(-)
 create mode 100644 drivers/scsi/ufs/ufshpb.c
 create mode 100644 drivers/scsi/ufs/ufshpb.h

--
2.25.1
