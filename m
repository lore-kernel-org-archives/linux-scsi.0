Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9704CC433C1
	for <linux-scsi@archiver.kernel.org>; Wed, 31 Mar 2021 01:16:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 70FB6619D7
	for <linux-scsi@archiver.kernel.org>; Wed, 31 Mar 2021 01:16:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233073AbhCaBPr (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 30 Mar 2021 21:15:47 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:23987 "EHLO
        mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230145AbhCaBPd (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 30 Mar 2021 21:15:33 -0400
Received: from epcas2p1.samsung.com (unknown [182.195.41.53])
        by mailout2.samsung.com (KnoxPortal) with ESMTP id 20210331011531epoutp029a2b37ccb87ef75496accf4a883314ac~xSGMf3KcC0476704767epoutp02V
        for <linux-scsi@vger.kernel.org>; Wed, 31 Mar 2021 01:15:31 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com 20210331011531epoutp029a2b37ccb87ef75496accf4a883314ac~xSGMf3KcC0476704767epoutp02V
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1617153331;
        bh=87i3H78RJH72hrx+ivnvKydBtnh7C3hFjhMv6+fPtH4=;
        h=Subject:Reply-To:From:To:CC:Date:References:From;
        b=JpZFbS+O2hzhfD9sHsLkiwagbX5uKBv1G2ma1n8swXG7FkXAYMuGv35ghGGfLDj/s
         PQhjqQH01/o/BUQ3bxL5oGR5+nPcnsXnNY5a6M2h7gJUN5Oin2W9/MJodNiODCWK3c
         woB/+x0GTwCJ6aDpYems7GJy+F894gNyDZ3+DZxI=
Received: from epsnrtp1.localdomain (unknown [182.195.42.162]) by
        epcas2p3.samsung.com (KnoxPortal) with ESMTP id
        20210331011530epcas2p3050e01e202cd18cdc07c64e19235b356~xSGLwVfpM2376323763epcas2p3_;
        Wed, 31 Mar 2021 01:15:30 +0000 (GMT)
Received: from epsmges2p4.samsung.com (unknown [182.195.40.191]) by
        epsnrtp1.localdomain (Postfix) with ESMTP id 4F97fR0Mhtz4x9Ps; Wed, 31 Mar
        2021 01:15:27 +0000 (GMT)
X-AuditID: b6c32a48-50fff7000000cd1f-28-6063cd2e206e
Received: from epcas2p3.samsung.com ( [182.195.41.55]) by
        epsmges2p4.samsung.com (Symantec Messaging Gateway) with SMTP id
        CC.8E.52511.E2DC3606; Wed, 31 Mar 2021 10:15:26 +0900 (KST)
Mime-Version: 1.0
Subject: [PATCH v32 0/4] scsi: ufs: Add Host Performance Booster Support
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
Message-ID: <20210331011526epcms2p37684869a9781d1eb45bfcbfe9babd217@epcms2p3>
Date:   Wed, 31 Mar 2021 10:15:26 +0900
X-CMS-MailID: 20210331011526epcms2p37684869a9781d1eb45bfcbfe9babd217
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
X-CPGSPASS: Y
X-CPGSPASS: Y
CMS-TYPE: 102P
X-Brightmail-Tracker: H4sIAAAAAAAAA12TfUxTVxjGd+4tt5Wt81JQztAJ3gW2kgG9HS0HIm6LbLlEICTL4uaWlDu4
        aYml7Vpgc4mhfmClfOkClFVEZSgJI1bBVsAtQGGACWiQjUEDo62ocwkMhH2wCRmlMM3++53n
        POd9zns+BLjoIREmyNXkc3oNq6aIQJ6jV5wQEzucnSWZKZcjd72DQN+dHOSjR8s/EqhmfhlH
        j22XA9Ajpxh19vQQqNl9AB3/2kagumEjhsor7QRq67mKo3uTi3zUMO7AUOWqiYcci0Fo4NYc
        QKOddQQq/amdQE0Dqxi6ZJ8AqMTSwntrOzP6w35mtKIcYzqsU3zmdEM3YLrOtfCZE7e6eMzC
        fRePqbjeDJjF1l2MqbsUyww8qN6j4tgcTh/BabK1ObkaZTK1/z3FPoVMLqFj6ESUQEVo2Dwu
        mUpJy4x5N1e91iYVUciqC9akTNZgoOL27tFrC/K5CJXWkJ9McboctY6mdbEGNs9QoFHGZmvz
        kmiJRCpbc2apVcWWY5juouxz49FZvhGsiM1giwCS8fBxxwJuBoECEdkOoK3GDMxAIBCSQXCl
        PdjnCSYZ2GZ3Yz4WkRS0jVj5fj0WujwtwMcE+Tq0DE7zfXVCyGIedPwxsj7AyTs4/HbcBPxp
        Qlhrus/z8w54o8m+ob8G/7pcjvt5G5z4Zpa/yb/1n9/whMDin4c3PEHQvXxzQ38J9t+cx/xc
        BO2TfwNfMCTLAOztcAX4J+Lg2Klr68FCMh0+WKkJ8HXJIyPhqGOH35ICTc6h9Zo4GQ5vzNbh
        PgtOiqGtM86HkHwF9rl4m50Yr/3D/z/j5IvwVO/Kf3p7/czGzqLglWUb5i+zE7rqwWlAWZ8e
        tPWZWOvT2AsAbwbbOZ0hT8kZpLr4Z++2Fay/+GimHZydnY91AkwAnAAKcCpEGNzNZomEOezh
        Lzi9VqEvUHMGJ5Ct9XsGD9uWrV37Mpp8BS2TyuWSRBmSyaWIChXqJW6FiFSy+dwhjtNx+s11
        mGBLmBFrsxVWeBvPpXtq6DckcuO4uzvh/UbdbnFVUXBTIfGwO+x8zPSTWdqizfb+WY2xxtbM
        ogDp1N2hJVuLbCnwaqrt4smhkamkkDtLpRMT3gsN8Rl0/PzhudTISKfkk73KKFtqwNjR58sO
        RTdGOUvouYJgpXV13+87g8Q1Uk3JkeccK5Odv0xUnUk6Hh46sHv6hbGuZNGBqq3UBybyWEZe
        a/1AuDfr+q9jLu+D5lDv932BR67Q3tskaOkfIZn5N98erP9IddBSGU68+k71Vyc8pruee599
        ueCw95W9jJd9ums4Y2bo49pajTnGnDgaeTst3vihKn1rteJSWpMn1PNk+mxKA8UzqFg6Gtcb
        2H8BQgxyI3oEAAA=
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20210331011526epcms2p37684869a9781d1eb45bfcbfe9babd217
References: <CGME20210331011526epcms2p37684869a9781d1eb45bfcbfe9babd217@epcms2p3>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Changelog:

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
 drivers/scsi/ufs/ufshcd.c                  |   74 +-
 drivers/scsi/ufs/ufshcd.h                  |   29 +
 drivers/scsi/ufs/ufshpb.c                  | 2387 ++++++++++++++++++++
 drivers/scsi/ufs/ufshpb.h                  |  277 +++
 9 files changed, 3013 insertions(+), 2 deletions(-)
 create mode 100644 drivers/scsi/ufs/ufshpb.c
 create mode 100644 drivers/scsi/ufs/ufshpb.h

-- 
2.25.1

