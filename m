Return-Path: <SRS0=wv9C=AK=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 87F2EC433E0
	for <linux-scsi@archiver.kernel.org>; Mon, 29 Jun 2020 19:43:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4B5FC2082F
	for <linux-scsi@archiver.kernel.org>; Mon, 29 Jun 2020 19:43:51 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="SPMC12hx"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731075AbgF2Tns (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 29 Jun 2020 15:43:48 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:20251 "EHLO
        mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387884AbgF2Tng (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 29 Jun 2020 15:43:36 -0400
Received: from epcas1p2.samsung.com (unknown [182.195.41.46])
        by mailout3.samsung.com (KnoxPortal) with ESMTP id 20200629064802epoutp03e37bf8054b140ece24bb4aa48e2e0830~c8PAXLeku0599605996epoutp03F
        for <linux-scsi@vger.kernel.org>; Mon, 29 Jun 2020 06:48:02 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com 20200629064802epoutp03e37bf8054b140ece24bb4aa48e2e0830~c8PAXLeku0599605996epoutp03F
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1593413282;
        bh=5X4YGRD6u1tf1xanJ6XnnURVxKYSn66IhirKFzp306A=;
        h=Subject:Reply-To:From:To:CC:Date:References:From;
        b=SPMC12hxUgafWKEWNFEiPmg9UAySkWDoyVAvbrzXlGQPmJTMtNIcmsVfOYMSfHZkW
         3eid/LP3jYkmdG1ZWyNS4s1GNWAk18a8OBoY2IP0rKEciqHORMZQXU+N2znZ8Vrj/E
         7PBWqyZI7Q5uOPsqlyy72B9l739OBPSFcobayJd4=
Received: from epcpadp2 (unknown [182.195.40.12]) by epcas1p1.samsung.com
        (KnoxPortal) with ESMTP id
        20200629064801epcas1p11b707090a0db8eb35b02cca951d76ea7~c8O--hFfq2909229092epcas1p1N;
        Mon, 29 Jun 2020 06:48:01 +0000 (GMT)
Mime-Version: 1.0
Subject: [PATCH v4 0/5] scsi: ufs: Add Host Performance Booster Support
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
Message-ID: <231786897.01593413281727.JavaMail.epsvc@epcpadp2>
Date:   Mon, 29 Jun 2020 15:43:23 +0900
X-CMS-MailID: 20200629064323epcms2p787baba58a416fef7fdd3927f8da701da
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
X-CPGSPASS: Y
X-CPGSPASS: Y
X-Hop-Count: 3
X-CMS-RootMailID: 20200629064323epcms2p787baba58a416fef7fdd3927f8da701da
References: <CGME20200629064323epcms2p787baba58a416fef7fdd3927f8da701da@epcms2p7>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Changelog:

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

This series patches are based on the 5.9/scsi-queue branch.

[1]:
https://www.usenix.org/conference/hotstorage17/program/presentation/jeong

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
 drivers/scsi/ufs/ufshpb.c     | 1997 ++++++++++++++++++++++++++++++++++++
 drivers/scsi/ufs/ufshpb.h     |  234 +++++
 9 files changed, 2493 insertions(+), 1 deletion(-)
 created mode 100644 drivers/scsi/ufs/ufsfeature.c
 created mode 100644 drivers/scsi/ufs/ufsfeature.h
 created mode 100644 drivers/scsi/ufs/ufshpb.c
 created mode 100644 drivers/scsi/ufs/ufshpb.h
