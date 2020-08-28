Return-Path: <SRS0=lsqi=CG=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 99745C433E6
	for <linux-scsi@archiver.kernel.org>; Fri, 28 Aug 2020 07:13:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 732F320CC7
	for <linux-scsi@archiver.kernel.org>; Fri, 28 Aug 2020 07:13:10 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="KiNfL2MY"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728320AbgH1HNJ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 28 Aug 2020 03:13:09 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:24491 "EHLO
        mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725858AbgH1HNG (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 28 Aug 2020 03:13:06 -0400
Received: from epcas1p1.samsung.com (unknown [182.195.41.45])
        by mailout4.samsung.com (KnoxPortal) with ESMTP id 20200828071302epoutp0423ed9471bafce6866c74f7273fdb144f~vXR_C-9TT1984919849epoutp04g
        for <linux-scsi@vger.kernel.org>; Fri, 28 Aug 2020 07:13:02 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20200828071302epoutp0423ed9471bafce6866c74f7273fdb144f~vXR_C-9TT1984919849epoutp04g
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1598598782;
        bh=dhb4o4jk0hfzRaKRK8AUBrnrMdhfXSXoi1n2XCF5SIE=;
        h=Subject:Reply-To:From:To:CC:Date:References:From;
        b=KiNfL2MY0/OWkWsS2zjAvbQBkSDJYo232ody3+8KoyTPhiSxHnUc/guuANtp0E4lq
         sTT0RnfKf+/FcHw/BMDnNLheVQwNUioxCu30px0Hg0Qmx1sdnhSPIaZ5z35kxxPcZJ
         0NyRGRjvk+kpivD4OU81omT1YzJmi6il7DOHmEZs=
Received: from epcpadp2 (unknown [182.195.40.12]) by epcas1p2.samsung.com
        (KnoxPortal) with ESMTP id
        20200828071302epcas1p2d94523b62da93756d326b26fc42d3aa9~vXR9ma-4V2556625566epcas1p2w;
        Fri, 28 Aug 2020 07:13:02 +0000 (GMT)
Mime-Version: 1.0
Subject: [PATCH v9 0/4] scsi: ufs: Add Host Performance Booster Support
Reply-To: daejun7.park@samsung.com
From:   Daejun Park <daejun7.park@samsung.com>
To:     "avri.altman@wdc.com" <avri.altman@wdc.com>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "asutoshd@codeaurora.org" <asutoshd@codeaurora.org>,
        "beanhuo@micron.com" <beanhuo@micron.com>,
        "stanley.chu@mediatek.com" <stanley.chu@mediatek.com>,
        "cang@codeaurora.org" <cang@codeaurora.org>,
        "bvanassche@acm.org" <bvanassche@acm.org>,
        "tomas.winkler@intel.com" <tomas.winkler@intel.com>,
        ALIM AKHTAR <alim.akhtar@samsung.com>,
        Daejun Park <daejun7.park@samsung.com>
CC:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Sang-yoon Oh <sangyoon.oh@samsung.com>,
        Sung-Jun Park <sungjun07.park@samsung.com>,
        yongmyung lee <ymhungry.lee@samsung.com>,
        Jinyoung CHOI <j-young.choi@samsung.com>,
        Adel Choi <adel.choi@samsung.com>,
        BoRam Shin <boram.shin@samsung.com>
X-Priority: 3
X-Content-Kind-Code: NORMAL
X-CPGS-Detection: blocking_info_exchange
X-Drm-Type: N,general
X-Msg-Generator: Mail
X-Msg-Type: PERSONAL
X-Reply-Demand: N
Message-ID: <963815509.21598598782155.JavaMail.epsvc@epcpadp2>
Date:   Fri, 28 Aug 2020 16:09:50 +0900
X-CMS-MailID: 20200828070950epcms2p5470bd43374be18d184dd802da09e73c8
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
X-CPGSPASS: Y
X-CPGSPASS: Y
X-Hop-Count: 3
X-CMS-RootMailID: 20200828070950epcms2p5470bd43374be18d184dd802da09e73c8
References: <CGME20200828070950epcms2p5470bd43374be18d184dd802da09e73c8@epcms2p5>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Changelog:

v8 -> v9
1. Change sysfs initialization.
2. Change reading descriptor during HPB initialization
3. Fix problems commentted in Bart's review.
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

This series patches are based on the 5.9/scsi-queue branch.

[1]:
https://www.usenix.org/conference/hotstorage17/program/presentation/jeong

Daejun park (4):
 scsi: ufs: Add HPB feature related parameters
 scsi: ufs: Introduce HPB feature
 scsi: ufs: L2P map management for HPB read
 scsi: ufs: Prepare HPB read for cached sub-region
 
 drivers/scsi/ufs/Kconfig  |    9 +
 drivers/scsi/ufs/Makefile |    1 +
 drivers/scsi/ufs/ufs.h    |   47 ++
 drivers/scsi/ufs/ufshcd.c |   58 ++
 drivers/scsi/ufs/ufshcd.h |   22 +-
 drivers/scsi/ufs/ufshpb.c | 1817 ++++++++++++++++++++++++++++++++++++++++
 drivers/scsi/ufs/ufshpb.h |  231 +++++
 7 files changed, 2184 insertions(+), 1 deletion(-)
 created mode 100644 drivers/scsi/ufs/ufshpb.c
 created mode 100644 drivers/scsi/ufs/ufshpb.h
