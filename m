Return-Path: <SRS0=1R64=74=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E21A2C433E1
	for <linux-scsi@archiver.kernel.org>; Mon, 15 Jun 2020 07:18:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C1CE7206D7
	for <linux-scsi@archiver.kernel.org>; Mon, 15 Jun 2020 07:18:11 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="pKaIF39q"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728539AbgFOHSI (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 15 Jun 2020 03:18:08 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:59617 "EHLO
        mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728368AbgFOHSF (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 15 Jun 2020 03:18:05 -0400
Received: from epcas1p2.samsung.com (unknown [182.195.41.46])
        by mailout1.samsung.com (KnoxPortal) with ESMTP id 20200615071802epoutp01169084a5854375246aabbf632caf8de2~YpnNfsMm62152421524epoutp01I
        for <linux-scsi@vger.kernel.org>; Mon, 15 Jun 2020 07:18:02 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20200615071802epoutp01169084a5854375246aabbf632caf8de2~YpnNfsMm62152421524epoutp01I
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1592205482;
        bh=hIePvCahKROD7i1SFLGyXqFGsYiA33yIxFyYUgHZ4fM=;
        h=Subject:Reply-To:From:To:CC:Date:References:From;
        b=pKaIF39qBNaw0wWWBHQYaj0ezE4zIFkD1YBvskyXG0nCBV0Q+8a0S/d4f7GSMqh4B
         zlmSSogIE15AAUvcQOTST2hj6QlbNB/0WL+4vneQnBCGE0DftuBgugmSxTRx9digr/
         KdDwwGpDkEVNuWxIyYwBgKz5rWE+VzruF0QcZKig=
Received: from epcpadp2 (unknown [182.195.40.12]) by epcas1p1.samsung.com
        (KnoxPortal) with ESMTP id
        20200615071802epcas1p1142d77fd170dc68c4a793e71736844dd~YpnNBSPOb2304123041epcas1p1r;
        Mon, 15 Jun 2020 07:18:02 +0000 (GMT)
Mime-Version: 1.0
Subject: [RFC PATCH v2 0/5] scsi: ufs: Add Host Performance Booster Support
Reply-To: daejun7.park@samsung.com
From:   Daejun Park <daejun7.park@samsung.com>
To:     ALIM AKHTAR <alim.akhtar@samsung.com>,
        "avri.altman@wdc.com" <avri.altman@wdc.com>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "asutoshd@codeaurora.org" <asutoshd@codeaurora.org>,
        "beanhuo@micron.com" <beanhuo@micron.com>,
        "stanley.chu@mediatek.com" <stanley.chu@mediatek.com>,
        "cang@codeaurora.org" <cang@codeaurora.org>,
        "bvanassche@acm.org" <bvanassche@acm.org>,
        "tomas.winkler@intel.com" <tomas.winkler@intel.com>,
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
Message-ID: <231786897.01592205482200.JavaMail.epsvc@epcpadp2>
Date:   Mon, 15 Jun 2020 15:27:08 +0900
X-CMS-MailID: 20200615062708epcms2p19a7fbc051bcd5e843c29dcd58fff4210
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
X-CPGSPASS: Y
X-CPGSPASS: Y
X-Hop-Count: 3
X-CMS-RootMailID: 20200615062708epcms2p19a7fbc051bcd5e843c29dcd58fff4210
References: <CGME20200615062708epcms2p19a7fbc051bcd5e843c29dcd58fff4210@epcms2p1>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

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
This patch consists of 4 parts to support HPB feature.

1) UFS-feature layer
2) HPB probe and initialization process
3) READ -> HPB READ using cached map information
4) L2P (logical to physical) map management

The UFS-feature is an additional layer to avoid the structure in which the
UFS-core driver and the UFS-feature are entangled with each other in a 
single module.
By adding the layer, UFS-features composed of various combinations can be
supported. Also, even if a new feature is added, modification of the 
UFS-core driver can be minimized.

In the HPB probe and init process, the device information of the UFS is
queried. After checking supported features, the data structure for the HPB
is initialized according to the device information.

A read I/O in the active sub-region where the map is cached is changed to
HPB READ by the HPB module.

The HPB module manages the L2P map using information received from the
device. For active sub-region, the HPB module caches through ufshpb_map
request. For the in-active region, the HPB module discards the L2P map.
When a write I/O occurs in an active sub-region area, associated dirty
bitmap checked as dirty for preventing stale read.

HPB is shown to have a performance improvement of 58 - 67% for random read
workload. [1]

This series patches are based on the 5.8/scsi-queue branch.

[1]:
https://www.usenix.org/conference/hotstorage17/program/presentation/jeong

Changelog:

v1 -> v2
1. Change sub-region context DS static allocation to dynamic allocation.
2. Change the full boilerplate text to SPDX style.
3. Other cleanups.

Daejun park (5):
 scsi: ufs: Add UFS feature related parameter
 scsi: ufs: Add UFS feature layer
 scsi: ufs: Introduce HPB module
 scsi: ufs: L2P map management for HPB read
 scsi: ufs: Prepare HPB read for cached sub-region
 
 drivers/scsi/ufs/Kconfig      |    9 +
 drivers/scsi/ufs/Makefile     |    3 +-
 drivers/scsi/ufs/ufs.h        |   12 +
 drivers/scsi/ufs/ufsfeature.c |  148 +++
 drivers/scsi/ufs/ufsfeature.h |   69 ++
 drivers/scsi/ufs/ufshcd.c     |   19 +
 drivers/scsi/ufs/ufshcd.h     |    3 +
 drivers/scsi/ufs/ufshpb.c     | 1988 ++++++++++++++++++++++++++++++++++++
 drivers/scsi/ufs/ufshpb.h     |  234 +++++
 9 files changed, 2484 insertions(+), 1 deletion(-)
 created mode 100644 drivers/scsi/ufs/ufsfeature.c
 created mode 100644 drivers/scsi/ufs/ufsfeature.h
 created mode 100644 drivers/scsi/ufs/ufshpb.c
 created mode 100644 drivers/scsi/ufs/ufshpb.h
