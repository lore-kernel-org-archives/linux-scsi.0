Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AFEEDC11F6E
	for <linux-scsi@archiver.kernel.org>; Mon, 12 Jul 2021 07:42:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9AE1A6144D
	for <linux-scsi@archiver.kernel.org>; Mon, 12 Jul 2021 07:42:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345839AbhGLHpZ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 12 Jul 2021 03:45:25 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:43311 "EHLO
        mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345453AbhGLHnz (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 12 Jul 2021 03:43:55 -0400
Received: from epcas2p3.samsung.com (unknown [182.195.41.55])
        by mailout1.samsung.com (KnoxPortal) with ESMTP id 20210712074103epoutp0193ff13b60fdc4de42b0fd25027182da5~Q_zNdbu_S1664416644epoutp01V
        for <linux-scsi@vger.kernel.org>; Mon, 12 Jul 2021 07:41:03 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20210712074103epoutp0193ff13b60fdc4de42b0fd25027182da5~Q_zNdbu_S1664416644epoutp01V
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1626075663;
        bh=2c5u7YnhtEg30lI89hG/IzITRY3EaB+sahCxhN8Yfis=;
        h=Subject:Reply-To:From:To:CC:Date:References:From;
        b=E/zb3y7LEe9SzQTRTdLF6yCduNLTDitqaDMqsZ4L4yixKPtPTx81WyiTwrC/TED9c
         L4CQ3YHG7KJ9kBzxnhGJOIoAlnHku8gGdOB3UHBz5h+/Edif4ZjyIgTzW9npqgO1kU
         Cqzfp9z2vTiT1C5F+4LaGwYz9joK1pNmywH51JqQ=
Received: from epsnrtp1.localdomain (unknown [182.195.42.162]) by
        epcas2p3.samsung.com (KnoxPortal) with ESMTP id
        20210712074102epcas2p3769da39d93d2fb1fe0753e0c13faab10~Q_zMmdIuX2798927989epcas2p3D;
        Mon, 12 Jul 2021 07:41:02 +0000 (GMT)
Received: from epsmges2p3.samsung.com (unknown [182.195.40.188]) by
        epsnrtp1.localdomain (Postfix) with ESMTP id 4GNbKl36DLz4x9QR; Mon, 12 Jul
        2021 07:40:59 +0000 (GMT)
X-AuditID: b6c32a47-5f3ff70000002545-99-60ebf20b9465
Received: from epcas2p3.samsung.com ( [182.195.41.55]) by
        epsmges2p3.samsung.com (Symantec Messaging Gateway) with SMTP id
        8D.33.09541.B02FBE06; Mon, 12 Jul 2021 16:40:59 +0900 (KST)
Mime-Version: 1.0
Subject: [PATCH v39 0/4] scsi: ufs: Add Host Performance Booster Support
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
        Sung-Jun Park <sungjun07.park@samsung.com>,
        Jinyoung CHOI <j-young.choi@samsung.com>,
        Dukhyun Kwon <d_hyun.kwon@samsung.com>,
        Keoseong Park <keosung.park@samsung.com>,
        Jaemyung Lee <jaemyung.lee@samsung.com>,
        Jieon Seol <jieon.seol@samsung.com>
X-Priority: 3
X-Content-Kind-Code: NORMAL
X-CPGS-Detection: blocking_info_exchange
X-Drm-Type: N,general
X-Msg-Generator: Mail
X-Msg-Type: PERSONAL
X-Reply-Demand: N
Message-ID: <20210712074058epcms2p6df1a446574fccaa2c6e2654226f59e0b@epcms2p6>
Date:   Mon, 12 Jul 2021 16:40:58 +0900
X-CMS-MailID: 20210712074058epcms2p6df1a446574fccaa2c6e2654226f59e0b
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
X-CPGSPASS: Y
X-CPGSPASS: Y
CMS-TYPE: 102P
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrOJsWRmVeSWpSXmKPExsWy7bCmuS73p9cJBr9Oclo8mLeNzWJv2wl2
        i5c/r7JZTPvwk9ni0/plrBYvD2la7Dp4kM1i1YNwi+bF69ks5pxtYLLo7d/KZrH54AZmi8d3
        PrNbLLqxjcmi/187i8W2z4IWx0++Y7S4vGsOm0X39R1sFsuP/2OyWLr1JqNF5/Q1LA5iHpev
        eHtc7utl8tg56y67x4RFBxg99s9dw+7RcnI/i8fHp7dYPPq2rGL0+LxJzqP9QDdTAFdUjk1G
        amJKapFCal5yfkpmXrqtkndwvHO8qZmBoa6hpYW5kkJeYm6qrZKLT4CuW2YO0JtKCmWJOaVA
        oYDE4mIlfTubovzSklSFjPziElul1IKUnAJDwwK94sTc4tK8dL3k/FwrQwMDI1OgyoScjL5P
        E9gKlltXLH5i08D4Vq+LkZNDQsBEouvJT7YuRi4OIYEdjBIzZ00Ccjg4eAUEJf7uEAapERbw
        kNhyp58FxBYSUJJYf3EWO0RcT+LWwzWMIDabgI7E9BP32UHmiAi0skhs+3YRzGEWOM8ssedG
        OyPENl6JGe1PWSBsaYnty7dCxTUkfizrZYawRSVurn7LDmO/PzYfqkZEovXeWagaQYkHP3dD
        xSUlju3+wARh10tsvfOLEWSxhEAPo8ThnbdYIRL6Etc6NoIt5hXwlehu2gwWZxFQleg52gq1
        zEXiwdRLYDXMAvIS29/OYQaFBLOApsT6XfogpoSAssSRWywwrzRs/M2OzmYW4JPoOPwXLr5j
        3hOo09Qk1v1czwQxRkbi1jzGCYxKsxAhPQvJ2lkIaxcwMq9iFEstKM5NTy02KjBGjttNjOAU
        r+W+g3HG2w96hxiZOBgPMUpwMCuJ8H7rfZUgxJuSWFmVWpQfX1Sak1p8iNEU6OGJzFKiyfnA
        LJNXEm9oamRmZmBpamFqZmShJM7LwX4oQUggPbEkNTs1tSC1CKaPiYNTqoFpw+/8y1s7atxs
        5qyrCApm/X487mXcD7cv/0PjtnMoquz+5KWy/566iUjD039t0/5oxbj7J0c9mia0fKW61hXf
        dw9y0h6Y+My7xjQppv6t51ZTg50Bhwy+FezzNrXfLe+mxWwoc3+vel1vd5LDh51FM8Ornqn/
        Yiia2Vxkd7PT5GCxvMD/2/fEHB/5nJY2TMxsyZgkpLztuTmjzwEB3+eb/IsZpqzp4ErqTqmc
        JLknttIo488XZnHXuNU7nzwvPbroFcPBhra1a6dsvOrwVzlZaN67406XLrjw/Yufx5nlp7rc
        uOgv961Jrw9tMN4oy3q9QWv53FXe8kfLVRu9Xm8sNHqo58i8cNEMTsZbOQ+UWIozEg21mIuK
        EwG2XAjAegQAAA==
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20210712074058epcms2p6df1a446574fccaa2c6e2654226f59e0b
References: <CGME20210712074058epcms2p6df1a446574fccaa2c6e2654226f59e0b@epcms2p6>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Changelog:

v38 -> v39
Address Barts' comments. (documentation, data type, indent)

v37 -> v38
1. Fix argument of find_next_bit API.
2. rebase 5.14 scsi-staging

v36 -> v37
1. Fix wrong usage of find_next_bit API.
2. Address Barts' comments. (sysfs, documentation, return type)
3. Change HPB_MULTI_CHUNK_HIGH for 1MB-sized request.

v35 -> v36
1. Changed ppn variable type from u64 to __be64.
2. Added WARN_ON_ONCE() to check for HPB read IO size exceeded.

v34 -> v35
1. Addressed Bart's comments (type casting)
2. Rebase 5.14 scsi-queue

v33 -> v34
Fix warning about NULL check before some freeing functions is not needed.

v32 -> v33
1. Fix wrong usage of scsi_command_normalize_sense.
2. Addressed Bart's comments (func. name, type casting, parentheses)

v31 -> v32
Delete unused parameter of unmap API.

v30 -> v31
Delete unnecessary debug message.

v29 -> v30
1. Add support to reuse bio of pre-request.
2. Delete unreached code in the ufshpb_issue_map_req.

v28 -> v29
1. Remove unused variable that reported by kernel test robot.

v27 -> v28
1. Fix wrong return value of ufshpb_prep.

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
 drivers/scsi/ufs/ufshcd.c                  |   73 +-
 drivers/scsi/ufs/ufshcd.h                  |   30 +
 drivers/scsi/ufs/ufshpb.c                  | 2380 ++++++++++++++++++++
 drivers/scsi/ufs/ufshpb.h                  |  277 +++
 9 files changed, 3006 insertions(+), 2 deletions(-)
 create mode 100644 drivers/scsi/ufs/ufshpb.c
 create mode 100644 drivers/scsi/ufs/ufshpb.h

-- 
2.25.1

