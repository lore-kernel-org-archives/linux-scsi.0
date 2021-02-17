Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CB81CC433DB
	for <linux-scsi@archiver.kernel.org>; Wed, 17 Feb 2021 09:10:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 69B2064DF0
	for <linux-scsi@archiver.kernel.org>; Wed, 17 Feb 2021 09:10:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231810AbhBQJJo (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 17 Feb 2021 04:09:44 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:52822 "EHLO
        mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231582AbhBQJJl (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 17 Feb 2021 04:09:41 -0500
Received: from epcas2p3.samsung.com (unknown [182.195.41.55])
        by mailout1.samsung.com (KnoxPortal) with ESMTP id 20210217090857epoutp0186f52f01a3180dbd4c0b0f318476871a~kfdkO-P0o3139231392epoutp01O
        for <linux-scsi@vger.kernel.org>; Wed, 17 Feb 2021 09:08:57 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20210217090857epoutp0186f52f01a3180dbd4c0b0f318476871a~kfdkO-P0o3139231392epoutp01O
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1613552937;
        bh=FyuZ5gPr+UwaRqJkegFOtIlRBwjG5zDyiq5f7mSiCKA=;
        h=Subject:Reply-To:From:To:CC:Date:References:From;
        b=fpV1wydRl+wvzN0fI7P7PAQw0xDJb4h9+YgQBr1cse6VY3Ox92zZ5DIg7C3tixaQi
         UU+Zc9Q8LBWnr0MekZLkawHRwSSP2saz1eulIzWe9u64dYbjKCjM9DVzUwQT54/U7k
         ZwPHNuz8cqfDqZJ28/MmWzP5fpqbrSa5Gy9MePRc=
Received: from epsnrtp1.localdomain (unknown [182.195.42.162]) by
        epcas2p4.samsung.com (KnoxPortal) with ESMTP id
        20210217090856epcas2p4fb4b54994b9379abbce9d1d10a56f0c8~kfdjTEgpm1604616046epcas2p4E;
        Wed, 17 Feb 2021 09:08:56 +0000 (GMT)
Received: from epsmges2p2.samsung.com (unknown [182.195.40.189]) by
        epsnrtp1.localdomain (Postfix) with ESMTP id 4DgX856wgkz4x9Q1; Wed, 17 Feb
        2021 09:08:53 +0000 (GMT)
X-AuditID: b6c32a46-1d9ff7000000dbf8-f1-602cdd25f3e4
Received: from epcas2p4.samsung.com ( [182.195.41.56]) by
        epsmges2p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        B4.E3.56312.52DDC206; Wed, 17 Feb 2021 18:08:53 +0900 (KST)
Mime-Version: 1.0
Subject: [PATCH v20 0/4] scsi: ufs: Add Host Performance Booster Support
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
        "bvanassche@acm.org" <bvanassche@acm.org>,
        "huobean@gmail.com" <huobean@gmail.com>,
        ALIM AKHTAR <alim.akhtar@samsung.com>,
        Daejun Park <daejun7.park@samsung.com>,
        Javier Gonzalez <javier.gonz@samsung.com>
CC:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        JinHwan Park <jh.i.park@samsung.com>,
        SEUNGUK SHIN <seunguk.shin@samsung.com>,
        Sung-Jun Park <sungjun07.park@samsung.com>,
        yongmyung lee <ymhungry.lee@samsung.com>,
        Jinyoung CHOI <j-young.choi@samsung.com>,
        BoRam Shin <boram.shin@samsung.com>
X-Priority: 3
X-Content-Kind-Code: NORMAL
X-CPGS-Detection: blocking_info_exchange
X-Drm-Type: N,general
X-Msg-Generator: Mail
X-Msg-Type: PERSONAL
X-Reply-Demand: N
Message-ID: <20210217090853epcms2p17db2903a3a0c1a13e4ee071b9a39dbc8@epcms2p1>
Date:   Wed, 17 Feb 2021 18:08:53 +0900
X-CMS-MailID: 20210217090853epcms2p17db2903a3a0c1a13e4ee071b9a39dbc8
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
X-CPGSPASS: Y
X-CPGSPASS: Y
CMS-TYPE: 102P
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrIJsWRmVeSWpSXmKPExsWy7bCmha7qXZ0Eg9d/jS0ezNvGZrG37QS7
        xcufV9ksDt9+x24x7cNPZotP65exWrw8pGmx6kG4RfPi9WwWc842MFn09m9ls3h85zO7xaIb
        25gs+v+1s1hc3jWHzaL7+g42i+XH/zFZ3N7CZbF0601Gi87pa1gsFi3czeIg6nH5irfH5b5e
        Jo+ds+6ye0xYdIDRY//cNeweLSf3s3h8fHqLxaNvyypGj8+b5DzaD3QzBXBF5dhkpCampBYp
        pOYl56dk5qXbKnkHxzvHm5oZGOoaWlqYKynkJeam2iq5+AToumXmAH2opFCWmFMKFApILC5W
        0rezKcovLUlVyMgvLrFVSi1IySkwNCzQK07MLS7NS9dLzs+1MjQwMDIFqkzIyTg0bSJ7wTGN
        ittnl7E1MH6S72Lk4JAQMJFY8Maui5GLQ0hgB6PE65aPTCBxXgFBib87hLsYOTmEBTwknl6d
        yApiCwkoSay/OIsdIq4ncevhGkYQm01AR2L6ifvsIHNEBDaxSPx4e5MRxGEW+MUkceLxB7Aq
        CQFeiRntT1kgbGmJ7cu3QsU1JH4s62WGsEUlbq5+yw5jvz82H6pGRKL13lmoGkGJBz93Q8Ul
        JY7t/sAEYddLbL3zC2yxhEAPo8ThnbdYIRL6Etc6NoIt5hXwlfg0oxvMZhFQlWg8dpgdEhIu
        EnNbzUHCzALyEtvfzmEGCTMLaEqs36UPUaEsceQWC8wnDRt/s6OzmQX4JDoO/4WL75j3BOoy
        NYl1P9czQYyRkbg1j3ECo9IsREDPQrJ2FsLaBYzMqxjFUguKc9NTi40KjJCjdhMjOK1rue1g
        nPL2g94hRiYOxkOMEhzMSiK87J+1EoR4UxIrq1KL8uOLSnNSiw8xmgL9O5FZSjQ5H5hZ8kri
        DU2NzMwMLE0tTM2MLJTEeYsNHsQLCaQnlqRmp6YWpBbB9DFxcEo1MB1z/Jqu0dHlFDdxj+60
        NxvXM+R1Mc2SLMy/yTrLqvZ/X87V/w+EPcX925qXdUlOMlvRcjVCYOlZbdVA13ubNJKnbz4h
        4Sjx2mT+F6Gm3RXXF6jcuxUgnLhiKdM0jvP2Rw1XfkiqZPwt87mqM9a87fnSqPdqdx1YF6Vx
        COesOLvQzT5vrnhv6cmlYpzP4w1fV066xCPMfu5Yfaqu0LPpG48nCc/xDdZl/rm2eUnD/KQd
        k1JrKrUZFCszND2u/FD+vDD6/fOHb2evn7PcoHlivOoNf9O5T7nbLvGvS7zhW3P89eWD1fVJ
        za9W/t/ikKDl+3Ixp4181/+CYk2urOyVdvXJdRcZb8ycHP/kd/o+QSWW4oxEQy3mouJEAEF9
        eId0BAAA
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20210217090853epcms2p17db2903a3a0c1a13e4ee071b9a39dbc8
References: <CGME20210217090853epcms2p17db2903a3a0c1a13e4ee071b9a39dbc8@epcms2p1>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Changelog:

v19 -> v20
1. Add documentation for sysfs entries of hpb->stat.
2. Fix read buffer command for under-sized sub-region.
3. Fix wrong condition checking for kick map work.
4. Delete redundant response UPIU checking.
5. Add LUN checking in response UPIU.
6. Fix possible deadlock problem due to runtime PM.
7. Add instant changing of sub-region state from response UPIU.
8. Fix endian problem in prefetched PPN.
9. Add JESD220-3A (HPB v2.0) support.

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

Daejun Park (4):
  scsi: ufs: Introduce HPB feature
  scsi: ufs: L2P map management for HPB read
  scsi: ufs: Prepare HPB read for cached sub-region
  scsi: ufs: Add HPB 2.0 support

 Documentation/ABI/testing/sysfs-driver-ufs |  134 ++
 drivers/scsi/ufs/Kconfig                   |    9 +
 drivers/scsi/ufs/Makefile                  |    1 +
 drivers/scsi/ufs/ufs-sysfs.c               |   18 +
 drivers/scsi/ufs/ufs.h                     |   51 +
 drivers/scsi/ufs/ufshcd.c                  |   61 +
 drivers/scsi/ufs/ufshcd.h                  |   22 +
 drivers/scsi/ufs/ufshpb.c                  | 2264 ++++++++++++++++++++
 drivers/scsi/ufs/ufshpb.h                  |  270 +++
 9 files changed, 2830 insertions(+)
 create mode 100644 drivers/scsi/ufs/ufshpb.c
 create mode 100644 drivers/scsi/ufs/ufshpb.h

-- 
2.25.1
