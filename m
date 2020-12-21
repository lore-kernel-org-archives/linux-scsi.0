Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 42B12C433E0
	for <linux-scsi@archiver.kernel.org>; Mon, 21 Dec 2020 08:39:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0CCE022C7E
	for <linux-scsi@archiver.kernel.org>; Mon, 21 Dec 2020 08:39:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728411AbgLUIj1 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 21 Dec 2020 03:39:27 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:16425 "EHLO
        mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726848AbgLUIj0 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 21 Dec 2020 03:39:26 -0500
Received: from epcas2p1.samsung.com (unknown [182.195.41.53])
        by mailout3.samsung.com (KnoxPortal) with ESMTP id 20201221083842epoutp0382a6b8cf0787192a3939f61be485691a~SrolwkabV2774727747epoutp03X
        for <linux-scsi@vger.kernel.org>; Mon, 21 Dec 2020 08:38:42 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com 20201221083842epoutp0382a6b8cf0787192a3939f61be485691a~SrolwkabV2774727747epoutp03X
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1608539922;
        bh=USdRd/SSXNTP7fB2I4fEhLeRaKAdtgq9jwCYfL9mn4w=;
        h=Subject:Reply-To:From:To:CC:Date:References:From;
        b=XPcWW3UcS0VYPQSog1tO3PRS4bSoVh9JpfwqqYcpR3hbOw56wt4Y3RZiolPHRQU9Y
         CjRIh6dt81apEyEjZivmfEmFSRVEkLhPXnFAy36L5ha5pu8PH9bIFNNji8NNIVN/Zr
         9TXU1Sdh9hiXtDy5TKnIsXW1MxlZdTW+nkpiqNcA=
Received: from epsnrtp2.localdomain (unknown [182.195.42.163]) by
        epcas2p1.samsung.com (KnoxPortal) with ESMTP id
        20201221083841epcas2p1f74397dbaae7144da431d89eb107667d~SrolGkLU_2088320883epcas2p1R;
        Mon, 21 Dec 2020 08:38:41 +0000 (GMT)
Received: from epsmges2p4.samsung.com (unknown [182.195.40.184]) by
        epsnrtp2.localdomain (Postfix) with ESMTP id 4CztCy2blvz4x9Q7; Mon, 21 Dec
        2020 08:38:38 +0000 (GMT)
X-AuditID: b6c32a48-50fff7000000cd1f-a9-5fe05f0ee15c
Received: from epcas2p3.samsung.com ( [182.195.41.55]) by
        epsmges2p4.samsung.com (Symantec Messaging Gateway) with SMTP id
        B3.BA.52511.E0F50EF5; Mon, 21 Dec 2020 17:38:38 +0900 (KST)
Mime-Version: 1.0
Subject: [PATCH v17 0/3] scsi: ufs: Add Host Performance Booster Support
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
Message-ID: <20201221083837epcms2p4989308d3a20500027482279d92668839@epcms2p4>
Date:   Mon, 21 Dec 2020 17:38:37 +0900
X-CMS-MailID: 20201221083837epcms2p4989308d3a20500027482279d92668839
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
X-CPGSPASS: Y
X-CPGSPASS: Y
CMS-TYPE: 102P
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrDJsWRmVeSWpSXmKPExsWy7bCmuS5f/IN4g/7FQhYb775itXgwbxub
        xd62E+wWL39eZbM4fPsdu8W0Dz+ZLT6tX8Zq8fKQpsWqB+EWzYvXs1nMOdvAZNHbv5XNYtGN
        bUwWl3fNYbPovr6DzWL58X9MFre3cFks3XqT0aJz+hoWi0ULd7M4iHhcvuLtcbmvl8lj56y7
        7B4TFh1g9Ng/dw27R8vJ/SweH5/eYvHo27KK0ePzJjmP9gPdTAFcUTk2GamJKalFCql5yfkp
        mXnptkrewfHO8aZmBoa6hpYW5koKeYm5qbZKLj4Bum6ZOUDPKSmUJeaUAoUCEouLlfTtbIry
        S0tSFTLyi0tslVILUnIKDA0L9IoTc4tL89L1kvNzrQwNDIxMgSoTcjIWPD7KUvBKqeLFjnss
        DYxLpLsYOTkkBEwkbt67wdTFyMUhJLCDUeLjx072LkYODl4BQYm/O4RBTGEBD4mln+RAyoUE
        lCTWX5zFDmILC+hJ3Hq4hhHEZhPQkZh+4j47yBgRgVYWibOHprCAOMwCX5kkPj2fzQSxjFdi
        RvtTFghbWmL78q2MELaGxI9lvcwQtqjEzdVv2WHs98fmQ9WISLTeOwtVIyjx4OduqLikxLHd
        H6Dm10tsvfOLEWSxhEAPo8ThnbdYIRL6Etc6NoIt5hXwlVg2ezcLyGcsAqoS7dcrIUpcJP4/
        WQBWziwgL7H97RxmkBJmAU2J9bv0QUwJAWWJI7dYYD5p2PibHZ3NLMAn0XH4L1x8x7wnUJep
        Saz7uZ4JYoyMxK15jBMYlWYhwnkWkrWzENYuYGRexSiWWlCcm55abFRgghy1mxjByVzLYwfj
        7Lcf9A4xMnEwHmKU4GBWEuE1k7ofL8SbklhZlVqUH19UmpNafIjRFOjficxSosn5wHySVxJv
        aGpkZmZgaWphamZkoSTOW2TwIF5IID2xJDU7NbUgtQimj4mDU6qBqYVnwZnQLzdX9JidljkV
        Ely9ZeerLn/WYyq1FdZCMkZ+E28cbCvW161JeXX+x2+pVEaHWW4LDt97y9JaXnc8OYfzv+zn
        RT/tLxwW6xBg+nT+e8ISk/AJ81xv7Q/MFIvhDDV7voZtY+m9/+fcZn5fvevlXs7MWW8CWoJf
        f/nxSu9gFNPhvcss02e2iP9trhE6KxtwX1/UZNeSI5YMbaWttbJLy/ns7v/8Gve5LNv5+jFj
        xkmpilrPfkf/e1W65X/quSa1SY8+Bp68pPPjZcLiy6+P6rteM5pYFemtW3b1gcuhns3X8ufs
        qMt23yG1m3NV7AEm840qKdv1+NPYj2+11FwYtzLtnEbzD9dYRubz55RYijMSDbWYi4oTARq0
        /CBvBAAA
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20201221083837epcms2p4989308d3a20500027482279d92668839
References: <CGME20201221083837epcms2p4989308d3a20500027482279d92668839@epcms2p4>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Changelog:

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
 drivers/scsi/ufs/ufs.h                     |   49 +
 drivers/scsi/ufs/ufshcd.c                  |   53 +
 drivers/scsi/ufs/ufshcd.h                  |   23 +-
 drivers/scsi/ufs/ufshpb.c                  | 1753 ++++++++++++++++++++
 drivers/scsi/ufs/ufshpb.h                  |  231 +++
 9 files changed, 2207 insertions(+), 1 deletion(-)
 create mode 100644 drivers/scsi/ufs/ufshpb.c
 create mode 100644 drivers/scsi/ufs/ufshpb.h

-- 
2.25.1

