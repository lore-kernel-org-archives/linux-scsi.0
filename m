Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8C9EDC433DB
	for <linux-scsi@archiver.kernel.org>; Fri, 12 Mar 2021 08:07:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4D65F64F81
	for <linux-scsi@archiver.kernel.org>; Fri, 12 Mar 2021 08:07:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231769AbhCLIG1 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 12 Mar 2021 03:06:27 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:46429 "EHLO
        mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231477AbhCLIGG (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 12 Mar 2021 03:06:06 -0500
Received: from epcas2p3.samsung.com (unknown [182.195.41.55])
        by mailout2.samsung.com (KnoxPortal) with ESMTP id 20210312080604epoutp0236e110d7e057517a402f6b045b685dbc~ricOkBjZ30714907149epoutp02M
        for <linux-scsi@vger.kernel.org>; Fri, 12 Mar 2021 08:06:04 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com 20210312080604epoutp0236e110d7e057517a402f6b045b685dbc~ricOkBjZ30714907149epoutp02M
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1615536364;
        bh=Sd2qH063k5RDdnf+F4rPAKDiBiRdG11Nwfvv1Q33aUg=;
        h=Subject:Reply-To:From:To:CC:Date:References:From;
        b=LeuRgI/jYWbMCeyMUNz9GfHYRQ7D7AAxmbNok2+71l4sIT/naNxKdn43aI55MSCKa
         k6Vt5bkvc7mGNzExmvok/Ibi7P0GHTl58HzF4s3Bn0D1XJwwG+tSbNEStI8w39amWr
         P51sR4JcaJTLmoTBx3277l8Y5zcsvoSsDuPUFLUM=
Received: from epsnrtp4.localdomain (unknown [182.195.42.165]) by
        epcas2p3.samsung.com (KnoxPortal) with ESMTP id
        20210312080603epcas2p33c4304c1870a05d1acf519270a4bccdb~ricNtVwxq1756817568epcas2p3U;
        Fri, 12 Mar 2021 08:06:03 +0000 (GMT)
Received: from epsmges2p2.samsung.com (unknown [182.195.40.182]) by
        epsnrtp4.localdomain (Postfix) with ESMTP id 4Dxdfw4PdDz4x9Q7; Fri, 12 Mar
        2021 08:06:00 +0000 (GMT)
X-AuditID: b6c32a46-1efff7000000dbf8-82-604b20e8b1a5
Received: from epcas2p2.samsung.com ( [182.195.41.54]) by
        epsmges2p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        5F.90.56312.8E02B406; Fri, 12 Mar 2021 17:06:00 +0900 (KST)
Mime-Version: 1.0
Subject: [PATCH v27 0/4] scsi: ufs: Add Host Performance Booster Support
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
Message-ID: <20210312080600epcms2p3f04061fbf25f2afb1588fa005541fbce@epcms2p3>
Date:   Fri, 12 Mar 2021 17:06:00 +0900
X-CMS-MailID: 20210312080600epcms2p3f04061fbf25f2afb1588fa005541fbce
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
X-CPGSPASS: Y
X-CPGSPASS: Y
CMS-TYPE: 102P
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrDJsWRmVeSWpSXmKPExsWy7bCmme4LBe8Eg8U7FSwezNvGZrG37QS7
        xcufV9ksDt9+x24x7cNPZotP65exWrw8pGmx6kG4RfPi9WwWc842MFn09m9ls3h85zO7xaIb
        25gs+v+1s1hc3jWHzaL7+g42i+XH/zFZ3N7CZbF0601Gi87pa1gcRDwuX/H2uNzXy+Sxc9Zd
        do8Jiw4weuyfu4bdo+XkfhaPj09vsXj0bVnF6PF5k5xH+4FupgCuqBybjNTElNQihdS85PyU
        zLx0WyXv4HjneFMzA0NdQ0sLcyWFvMTcVFslF58AXbfMHKDnlBTKEnNKgUIBicXFSvp2NkX5
        pSWpChn5xSW2SqkFKTkFhoYFesWJucWleel6yfm5VoYGBkamQJUJORnnL2UUHDaqWHp3OnMD
        41v1LkZODgkBE4mjz66zdDFycQgJ7GCU6OmcwdbFyMHBKyAo8XeHMEiNsICHxJs9/1hAbCEB
        JYn1F2exQ8T1JG49XMMIYrMJ6EhMP3GfHWSOiEAri8S2bxfBHGaB30wSi0/+Z4PYxisxo/0p
        C4QtLbF9+VZGCFtD4seyXmYIW1Ti5uq37DD2+2PzoWpEJFrvnYWqEZR48HM3VFxS4tjuD0wQ
        dr3E1ju/GEEWSwj0MEoc3nmLFSKhL3GtYyMLxGe+Eov+OYOEWQRUJabdeAdV4iJxsmM92G3M
        AvIS29/OYQYpZxbQlFi/Sx/ElBBQljhyiwXmk4aNv9nR2cwCfBIdh//CxXfMewJ1mZrEup/r
        mSDGyEjcmsc4gVFpFiKgZyFZOwth7QJG5lWMYqkFxbnpqcVGBUbIUbuJEZzMtdx2ME55+0Hv
        ECMTB+MhRgkOZiUR3gsvvRKEeFMSK6tSi/Lji0pzUosPMZoCPTyRWUo0OR+YT/JK4g1NjczM
        DCxNLUzNjCyUxHmLDR7ECwmkJ5akZqemFqQWwfQxcXBKNTCplWiLlpT1Xtz4+Zzssn2hYppb
        AtXYXrXtuZS78rxbbfWuWfISh/Yf8+ipc076OfeF4xIG49da0ys0K1z3378VEn9A75LuvoKg
        kJwbdeazmzplqp/0ivkmLuRy+6yRk/Uk9b1ZRmNpI9u/RGv20JT6sAdNv3e5+T0yuDpra3eV
        zgtujg8tS5ZE9TgJL2nqXHsrwufKvdZXTw3jp7/zd+MrPyufp7zzpadduVf0VM8/x47WvruR
        sD7a+lv5ox8cmgfjM3k3XbWc/UP524os/5t7T15daMNkNuPZmmN5QjcC9lUeljYKKs6c/2RF
        1kFZ296PXMYnpjivvb7OPSRex6A9zj0j4KbRmQxJNS8PLiWW4oxEQy3mouJEAHdhPq5vBAAA
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20210312080600epcms2p3f04061fbf25f2afb1588fa005541fbce
References: <CGME20210312080600epcms2p3f04061fbf25f2afb1588fa005541fbce@epcms2p3>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Changelog:

v26 -> v27
1. Fix wrong refernce of sense buffer in pre_req complete function.
2. Fix read_id error.
3. Fix chunk size checking for HPB 1.0.
4. Mute unnecessary messages before HPB initialization.

v25 -> v26
1. Fix wrong chunk size checking for HPB 1.0.
2. Fix wrong max data size for HPB single command.
3. Fix typo error.

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

 Documentation/ABI/testing/sysfs-driver-ufs |  162 ++
 drivers/scsi/ufs/Kconfig                   |    9 +
 drivers/scsi/ufs/Makefile                  |    1 +
 drivers/scsi/ufs/ufs-sysfs.c               |   22 +
 drivers/scsi/ufs/ufs.h                     |   54 +-
 drivers/scsi/ufs/ufshcd.c                  |   74 +-
 drivers/scsi/ufs/ufshcd.h                  |   29 +
 drivers/scsi/ufs/ufshpb.c                  | 2396 ++++++++++++++++++++
 drivers/scsi/ufs/ufshpb.h                  |  276 +++
 9 files changed, 3021 insertions(+), 2 deletions(-)
 create mode 100644 drivers/scsi/ufs/ufshpb.c
 create mode 100644 drivers/scsi/ufs/ufshpb.h

-- 
2.25.1

