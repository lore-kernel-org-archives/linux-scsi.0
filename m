Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 571A1C2BA12
	for <linux-scsi@archiver.kernel.org>; Wed,  3 Mar 2021 13:06:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2BB1B60234
	for <linux-scsi@archiver.kernel.org>; Wed,  3 Mar 2021 13:06:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1446827AbhCCMrM (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 3 Mar 2021 07:47:12 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:26969 "EHLO
        mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355215AbhCCG1Z (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 3 Mar 2021 01:27:25 -0500
Received: from epcas2p3.samsung.com (unknown [182.195.41.55])
        by mailout1.samsung.com (KnoxPortal) with ESMTP id 20210303062639epoutp018006ce07bf593f66ae48655d252d81f0~owR29R0WX0796407964epoutp01G
        for <linux-scsi@vger.kernel.org>; Wed,  3 Mar 2021 06:26:39 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20210303062639epoutp018006ce07bf593f66ae48655d252d81f0~owR29R0WX0796407964epoutp01G
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1614752799;
        bh=mR61ZBgTUmBvrMqVkU/3F+UG4SQJmMPqKc6kM+2E+FE=;
        h=Subject:Reply-To:From:To:CC:Date:References:From;
        b=KRGG/ivGJMMzvyy9jZKipIQMMkFa3Qg47nEBvcgnsn8yeEs0Jh5+mz1iRixNDvpi/
         Bvzhg/ATAcDFpeMGmJznQH4/VrtTqP3eiG/vSm9skITBG2a2lG+8h4Hh/FUUgI7eqM
         UbgM4CnW49SALEpGKPuwLSKSdA3JR9T+WQ+Ert20=
Received: from epsnrtp2.localdomain (unknown [182.195.42.163]) by
        epcas2p2.samsung.com (KnoxPortal) with ESMTP id
        20210303062638epcas2p29416ac5e369eb6565608a7c6449dc488~owR190D0h2298522985epcas2p2M;
        Wed,  3 Mar 2021 06:26:38 +0000 (GMT)
Received: from epsmges2p4.samsung.com (unknown [182.195.40.189]) by
        epsnrtp2.localdomain (Postfix) with ESMTP id 4Dr3tL4LHnz4x9Py; Wed,  3 Mar
        2021 06:26:34 +0000 (GMT)
X-AuditID: b6c32a48-50fff7000000cd1f-d3-603f2c19552f
Received: from epcas2p4.samsung.com ( [182.195.41.56]) by
        epsmges2p4.samsung.com (Symantec Messaging Gateway) with SMTP id
        CB.89.52511.91C2F306; Wed,  3 Mar 2021 15:26:33 +0900 (KST)
Mime-Version: 1.0
Subject: [PATCH v26 0/4] scsi: ufs: Add Host Performance Booster Support
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
        Daejun Park <daejun7.park@samsung.com>
CC:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        JinHwan Park <jh.i.park@samsung.com>,
        Javier Gonzalez <javier.gonz@samsung.com>,
        SEUNGUK SHIN <seunguk.shin@samsung.com>,
        Sung-Jun Park <sungjun07.park@samsung.com>,
        Jinyoung CHOI <j-young.choi@samsung.com>,
        BoRam Shin <boram.shin@samsung.com>
X-Priority: 3
X-Content-Kind-Code: NORMAL
X-CPGS-Detection: blocking_info_exchange
X-Drm-Type: N,general
X-Msg-Generator: Mail
X-Msg-Type: PERSONAL
X-Reply-Demand: N
Message-ID: <20210303062633epcms2p252227acd30ad15c1ca821d7e3f547b9e@epcms2p2>
Date:   Wed, 03 Mar 2021 15:26:33 +0900
X-CMS-MailID: 20210303062633epcms2p252227acd30ad15c1ca821d7e3f547b9e
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
X-CPGSPASS: Y
X-CPGSPASS: Y
CMS-TYPE: 102P
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrHJsWRmVeSWpSXmKPExsWy7bCmha6kjn2CwaomLYsH87axWextO8Fu
        8fLnVTaLw7ffsVtM+/CT2eLT+mWsFi8PaVqsehBu0bx4PZvFnLMNTBa9/VvZLB7f+cxusejG
        NiaL/n/tLBaXd81hs+i+voPNYvnxf0wWt7dwWSzdepPRonP6GhYHEY/LV7w9Lvf1MnnsnHWX
        3WPCogOMHvvnrmH3aDm5n8Xj49NbLB59W1YxenzeJOfRfqCbKYArKscmIzUxJbVIITUvOT8l
        My/dVsk7ON453tTMwFDX0NLCXEkhLzE31VbJxSdA1y0zB+g5JYWyxJxSoFBAYnGxkr6dTVF+
        aUmqQkZ+cYmtUmpBSk6BoWGBXnFibnFpXrpecn6ulaGBgZEpUGVCTsa7SbPZCr4ZVKz9upW5
        gfGEWhcjJ4eEgInE+oV3WbsYuTiEBHYwSvTfPMDexcjBwSsgKPF3hzBIjbCAh8SsAxPYQGwh
        ASWJ9RdnsUPE9SRuPVzDCGKzCehITD9xnx1kjohAK4vEtm8XwRxmgd9MEotP/meD2MYrMaP9
        KQuELS2xfflWRghbQ+LHsl5mCFtU4ubqt+ww9vtj86FqRCRa752FqhGUePBzN1RcUuLY7g9M
        EHa9xNY7vxhBFksI9DBKHN55ixUioS9xrWMj2GJeAV+JW0c3gjWwCKhKHF++DmqZi8SF//1g
        NrOAvMT2t3OYQSHBLKApsX6XPogpIaAsceQWC8wrDRt/s6OzmQX4JDoO/4WL75j3BOo0NYl1
        P9czQYyRkbg1j3ECo9IsREjPQrJ2FsLaBYzMqxjFUguKc9NTi40KTJAjdxMjOKFreexgnP32
        g94hRiYOxkOMEhzMSiK84i9tE4R4UxIrq1KL8uOLSnNSiw8xmgI9PJFZSjQ5H5hT8kriDU2N
        zMwMLE0tTM2MLJTEeYsMHsQLCaQnlqRmp6YWpBbB9DFxcEo1MM3zlWm+x79pXZKFfHuuDv/t
        Bw/MIr6/q9bI3TkzsPRe6p8jv8Prkrv+nZpQEXut4Kld0VmZmRcn/jGa+SdB+o1eyozKhZsq
        mOSXKaXo/Nq4Tz60XSwktaTt38FHAvIn/p7K3+t7K3eikX6Li9Dm55N+bjFz3M39eOnGjgtF
        7C928khIL5YTDo4/vyooo+9s2sSWri2Swd9Xv2lzt29JnftB75hUzO4cO6n12+NvSG7uteS/
        dOeHo6O+qLJJlXCn0fT+b58WmEZuTS5Z21fA2btJLC8xPezqSvnlf1wdyuav8r0QZu8cVnn4
        rHrhiZJ/J0qPlMbdfbv7c2d8/IbdXmvvs/MtEKqzXcP29eIhXyWW4oxEQy3mouJEAPh+LzFx
        BAAA
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20210303062633epcms2p252227acd30ad15c1ca821d7e3f547b9e
References: <CGME20210303062633epcms2p252227acd30ad15c1ca821d7e3f547b9e@epcms2p2>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Changelog:

v25 -> v26
1. Fix wrong chunk size checking for HPB 1.0.
2. Fix wrong max data size for HPB single command.
3. Fix typo error

v24 -> v25
1. Change write buffer API for unmap region.
2. Add checking hpb_enable for avoiding unnecessary memory allocation.
3. Change pr_info to dev_info.
4. Change default requeue timeout value for HPB read.
5. Fix wrong offset manipulation on ufshpb_prep_entry.

v23 -> v24
1. Fix build error reported by kernel test robot.

v22 -> v23
1. Add support compatibility of HPB 1.0.
2. Fix read id for single HPB read command.
3. Fix number of pre-allocated requests for write buffer.
4. Add fast path for response UPIU that has same LUN in sense data.
5. Remove WARN_ON for preventing kernel crash.
7. Fix wrong argument for read buffer command.

v21 -> v22
1. Add support processing response UPIU in suspend state.
2. Add support HPB hint from other LU.
3. Add sending write buffer with 0x03 after HPB init.

v20 -> v21
1. Add bMAX_DATA_SIZE_FOR_HPB_SINGLE_CMD attr. and fHPBen flag support.

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

 Documentation/ABI/testing/sysfs-driver-ufs |  150 ++
 drivers/scsi/ufs/Kconfig                   |    9 +
 drivers/scsi/ufs/Makefile                  |    1 +
 drivers/scsi/ufs/ufs-sysfs.c               |   20 +
 drivers/scsi/ufs/ufs.h                     |   54 +-
 drivers/scsi/ufs/ufshcd.c                  |   73 +-
 drivers/scsi/ufs/ufshcd.h                  |   29 +
 drivers/scsi/ufs/ufshpb.c                  | 2385 ++++++++++++++++++++
 drivers/scsi/ufs/ufshpb.h                  |  276 +++
 9 files changed, 2995 insertions(+), 2 deletions(-)
 create mode 100644 drivers/scsi/ufs/ufshpb.c
 create mode 100644 drivers/scsi/ufs/ufshpb.h

-- 
2.25.1

