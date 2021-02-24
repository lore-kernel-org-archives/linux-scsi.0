Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 82989C433DB
	for <linux-scsi@archiver.kernel.org>; Wed, 24 Feb 2021 04:54:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 214F164E6C
	for <linux-scsi@archiver.kernel.org>; Wed, 24 Feb 2021 04:54:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233354AbhBXEyR (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 23 Feb 2021 23:54:17 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:10229 "EHLO
        mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233207AbhBXEyO (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 23 Feb 2021 23:54:14 -0500
Received: from epcas2p4.samsung.com (unknown [182.195.41.56])
        by mailout4.samsung.com (KnoxPortal) with ESMTP id 20210224045330epoutp04ddf9d90d7592f223414dda11519a360c~mlfhbObkV0536005360epoutp04s
        for <linux-scsi@vger.kernel.org>; Wed, 24 Feb 2021 04:53:30 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20210224045330epoutp04ddf9d90d7592f223414dda11519a360c~mlfhbObkV0536005360epoutp04s
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1614142410;
        bh=Ms5t9CK5JU3ssrtrdYArr+/bb7zfHQkAiy2mZy/2TkU=;
        h=Subject:Reply-To:From:To:CC:Date:References:From;
        b=BsBXxkq+bDsxfzww9qMzJkN5Ltbi0n2B3tYkZGLPfT7Q5vAU9StZlg0o9+wAhfyVs
         lNTEpOaznFKv/N9c63LwK2XphpIBpSxlvGJZf8yPERrhu/og2k3t9lX7wlOERMGwMv
         Z5fmCZx9YDet5jJULc92yrW70kEfbVL49mH3vNfQ=
Received: from epsnrtp2.localdomain (unknown [182.195.42.163]) by
        epcas2p3.samsung.com (KnoxPortal) with ESMTP id
        20210224045328epcas2p32effceb4416529291d2879af354a48ae~mlfftfvip3214832148epcas2p3U;
        Wed, 24 Feb 2021 04:53:28 +0000 (GMT)
Received: from epsmges2p4.samsung.com (unknown [182.195.40.184]) by
        epsnrtp2.localdomain (Postfix) with ESMTP id 4Dlk845lpdz4x9Q3; Wed, 24 Feb
        2021 04:53:24 +0000 (GMT)
X-AuditID: b6c32a48-4f9ff7000000cd1f-6a-6035dbc4030a
Received: from epcas2p1.samsung.com ( [182.195.41.53]) by
        epsmges2p4.samsung.com (Symantec Messaging Gateway) with SMTP id
        B6.42.52511.4CBD5306; Wed, 24 Feb 2021 13:53:24 +0900 (KST)
Mime-Version: 1.0
Subject: [PATCH v24 0/4] scsi: ufs: Add Host Performance Booster Support
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
Message-ID: <20210224045323epcms2p66cc6a4b73086621e050da37f12f432f0@epcms2p6>
Date:   Wed, 24 Feb 2021 13:53:23 +0900
X-CMS-MailID: 20210224045323epcms2p66cc6a4b73086621e050da37f12f432f0
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
X-CPGSPASS: Y
X-CPGSPASS: Y
CMS-TYPE: 102P
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrLLsWRmVeSWpSXmKPExsWy7bCmqe6R26YJBp8btSwezNvGZrG37QS7
        xcufV9ksDt9+x24x7cNPZotP65exWrw8pGmx6kG4RfPi9WwWc842MFn09m9ls3h85zO7xaIb
        25gs+v+1s1hc3jWHzaL7+g42i+XH/zFZ3N7CZbF0601Gi87pa1gsFi3czeIg6nH5irfH5b5e
        Jo+ds+6ye0xYdIDRY//cNeweLSf3s3h8fHqLxaNvyypGj8+b5DzaD3QzBXBFNTDaJBYlZ2SW
        pSqk5iXnp2TmpdsqhYa46VooKWTkF5fYKkUbWhjpGVqa6plY6hmZx1oZGhgYmSop5CXmptoq
        VehCdSspFCUXAFWXpBaXFKUmpwKFihyKSxLTU/WKE3OLS/PS9ZLzc5UUyhJzSoH6lPTtbDJS
        E1NSixQSnjBm9Db9Zi24r1vxaJNBA2OTShcjJ4eEgInEnvap7F2MXBxCAjsYJZ6uOMjYxcjB
        wSsgKPF3hzBIjbCAh8TvKdsZQWwhASWJ9RdnsUPE9SRuPVwDFmcT0JGYfuI+2BwRgVYWiW3f
        LoI5zAJLmSVWP21ghtjGKzGj/SkLhC0tsX35VkYIW0Pix7JeqBpRiZur37LD2O+PzYeqEZFo
        vXcWqkZQ4sHP3VBxSYljuz8wQdj1Elvv/GIEWSwh0MMocXjnLVaIhL7EtY6NYIt5BXwl1p2d
        AWazCKhKvHy3BKrZRWL2lSdgi5kF5CW2v53DDAoJZgFNifW79EFMCQFliSO3WGBeadj4mx2d
        zSzAJ9Fx+C9cfMe8J1DT1STW/VzPBDFGRuLWPMYJjEqzECE9C8naWQhrFzAyr2IUSy0ozk1P
        LTYqMEGO502M4Cyg5bGDcfbbD3qHGJk4GA8xSnAwK4nwst01ShDiTUmsrEotyo8vKs1JLT7E
        WAX08ERmKdHkfGAeyiuJNzQzMDIzNTYxNjY1MSVb2NTIzMzA0tTC1MzIQkmct8jgQbyQQHpi
        SWp2ampBahHMciYOTqkGprhtF9d9scjjXH+Kb2nm6oTbdcF6oTUL/6Zl/ZqkELBC1PXEs/fr
        54jJObPbmAcqVKz51JJqYlD4XlQnW2r7n+DJt9zevfy4dMeh3h9bpneZBcjqLd90RSz32rwK
        qeptcw5O/25WGxO0KDN7eY4if/mbmFDlTUo/NTWu3iys2CTWfF23m+XmVvfjH+ae2at7nmuL
        XX3BPlfXzEv86RWyOru86uofS3Dnf5h6ll813PdsL1floysXziTtjjKwa3oXeyPk1rJg+dfn
        Fb4tTLllXWOedtRrptDU1yvqz+S434m59aBbMurldO2drwV+v/t177S2UZ30rX699EyHU7yX
        Nr6e4T1zZ2JIsNI+US7NUCWW4oxEQy3mouJEAANusL7QBAAA
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20210224045323epcms2p66cc6a4b73086621e050da37f12f432f0
References: <CGME20210224045323epcms2p66cc6a4b73086621e050da37f12f432f0@epcms2p6>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Changelog:

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
 drivers/scsi/ufs/ufshcd.c                  |   69 +-
 drivers/scsi/ufs/ufshcd.h                  |   29 +
 drivers/scsi/ufs/ufshpb.c                  | 2379 ++++++++++++++++++++
 drivers/scsi/ufs/ufshpb.h                  |  276 +++
 9 files changed, 2985 insertions(+), 2 deletions(-)
 create mode 100644 drivers/scsi/ufs/ufshpb.c
 create mode 100644 drivers/scsi/ufs/ufshpb.h

-- 
2.25.1

