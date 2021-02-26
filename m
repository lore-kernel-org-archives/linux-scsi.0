Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 03CFDC433DB
	for <linux-scsi@archiver.kernel.org>; Fri, 26 Feb 2021 07:33:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9509364ED3
	for <linux-scsi@archiver.kernel.org>; Fri, 26 Feb 2021 07:33:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229598AbhBZHd3 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 26 Feb 2021 02:33:29 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:35854 "EHLO
        mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229541AbhBZHd2 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 26 Feb 2021 02:33:28 -0500
Received: from epcas2p2.samsung.com (unknown [182.195.41.54])
        by mailout2.samsung.com (KnoxPortal) with ESMTP id 20210226073245epoutp027b2ebe877f8666b3606025cd5eef4ba2~nO9I9ljkA2962329623epoutp02I
        for <linux-scsi@vger.kernel.org>; Fri, 26 Feb 2021 07:32:45 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com 20210226073245epoutp027b2ebe877f8666b3606025cd5eef4ba2~nO9I9ljkA2962329623epoutp02I
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1614324765;
        bh=6c30olBcHiEGJKFmy6+akYe4979MF2VCBrE+xy+YWdk=;
        h=Subject:Reply-To:From:To:CC:Date:References:From;
        b=dA1qEcsZbCtT4kXORxNA4Sk3RsCYoiVVYQzkosKg2SATgNdFZAjN+aKrPI+Brj9uW
         rD+yNP/fRnP5jjTxw+G3r0RelkJlg7l99hGDdNB7vwKD3W4Yj1QTueF0vMW/poiF6c
         DzwehjpjpK/+c1e6jxR8Z7CxePB09oegPZ/cWX4Q=
Received: from epsnrtp4.localdomain (unknown [182.195.42.165]) by
        epcas2p1.samsung.com (KnoxPortal) with ESMTP id
        20210226073237epcas2p160f7a39c141899b2a40f6706df408360~nO9Bm6UZs1507815078epcas2p1-;
        Fri, 26 Feb 2021 07:32:37 +0000 (GMT)
Received: from epsmges2p4.samsung.com (unknown [182.195.40.188]) by
        epsnrtp4.localdomain (Postfix) with ESMTP id 4Dn1Zp6dv4z4x9Q1; Fri, 26 Feb
        2021 07:32:34 +0000 (GMT)
X-AuditID: b6c32a48-50fff7000000cd1f-0c-6038a412a31e
Received: from epcas2p1.samsung.com ( [182.195.41.53]) by
        epsmges2p4.samsung.com (Symantec Messaging Gateway) with SMTP id
        88.BB.52511.214A8306; Fri, 26 Feb 2021 16:32:34 +0900 (KST)
Mime-Version: 1.0
Subject: [PATCH v25 0/4] scsi: ufs: Add Host Performance Booster Support
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
Message-ID: <20210226073233epcms2p80fca2dffabea03143a9414838f757633@epcms2p8>
Date:   Fri, 26 Feb 2021 16:32:33 +0900
X-CMS-MailID: 20210226073233epcms2p80fca2dffabea03143a9414838f757633
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
X-CPGSPASS: Y
X-CPGSPASS: Y
CMS-TYPE: 102P
X-Brightmail-Tracker: H4sIAAAAAAAAA12Te0xTVxzHPfdeei/Nul0KuCN7iJc5hABtma0HkcUHW65xjjoWXbY/SgM3
        LbO0XQvGddkk7kEFQZZtsPFSi4IysiLK2wVGDbJslRgQKTgpA7YgFgs4ByzAKC3T7L/P+Z7v
        +X3P7zwoXDjCC6HStZmcQavUMDw+0WiLkEYLz6EUcZ01CDkrGnnoxy+6STQxf4uHbENTJCpy
        z+NoxlrlhyY6I1CN8xD6tNLKQ2X2bAzln2rgodE7sySyDDRi6NRSDoF6W8t4KO92Mw9VX1/C
        0NAVPjrf4ADoRHEtgSxn24idwWxv3z62tyAfY1tKfiPZQksHYNvLa0n2s5/bCXZ6fJBgC67U
        AHa2/kU2pyMPk/Pf1exQc8o0zhDKaVN1aelaVQKzL1mxRyGViSXRkji0jQnVKjO4BCbxDXn0
        6+malQ6Z0CNKTdaKJFcajYzo1R0GXVYmF6rWGTMTGE6fptFLJPoYozLDmKVVxaTqMrZLxOJY
        6YozRaM+0enE9TOio8PO+GwwtjkX+FOQ3gqHzbfJXMCnhHQzgGZ7B5YLKEpAB8DF5kCPJ5Bm
        4ez0H6SHhTQDrTdLSK8eAwdHaoGHeXQULO4eXq0TRNcTcM7lAJ4BTi9gsHvUDbxpAvhtzjjh
        5edgU3WDT98C56rycS8HQ8f3LnKNH3Sd9nmC4Od37T5PAHTOt/n0DbCrzY15+RhsuLOwGgzp
        kwDaWgb9vBMi2G++tBosoPdD61g3z8MEvRneqOsnPR1DOhGOVL/gkXF6I2xyleEeGacjoLVV
        5HWEwWuDxFon2Zf+If/POP00NNsW/9ObK8Z8O3sZ/jBvxbxlnoeDFaAQMCWPD7rkidiSx7Fn
        AF4D1nN6Y4aKM8bqtz55tfVg9a1Hss2g1OWO6QQYBToBpHAmSHB5SZoiFKQpPzRxBp3CkKXh
        jJ1AutLvl3hIcKpu5bNoMxUSaaxMJo6TIqksFjHPCgxip0JIq5SZ3GGO03OGtXUY5R+SjeUd
        lr9V/D5eGf6Nazlsk5b688Dx15hs1ehR+yNVwfimqCKTKe6nqE+SHj1QH4tu+GUqwYS6kr86
        X4V1zBGTU7t39dtaplsmy8ULOw2OmYGCmRHr78Fnlodo6VM3Tr/58Ijj6neB6spwt7tv6mIV
        Zl5o2nuuN8n2kdRyS1zUc8++/mBYK2M5lJSe1ndyqR0tpVSVvucHXspaFt1PVNyviz+Yf9e8
        7cLu/dx44bq3I5L3vFJ+NW7LNc1fpg1+E3ml7dtjJbJ+dcG9D5Jde53xPe84n7msomZkFw48
        XPy6hu8vGgjZVXPx47/r48XhPZPLN39NPxsUuU6elC+5fjw4YGN/rclJMoRRrZRE4gaj8l8O
        50xWdAQAAA==
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20210226073233epcms2p80fca2dffabea03143a9414838f757633
References: <CGME20210226073233epcms2p80fca2dffabea03143a9414838f757633@epcms2p8>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Changelog:

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
 drivers/scsi/ufs/ufshpb.c                  | 2387 ++++++++++++++++++++
 drivers/scsi/ufs/ufshpb.h                  |  276 +++
 9 files changed, 2997 insertions(+), 2 deletions(-)
 create mode 100644 drivers/scsi/ufs/ufshpb.c
 create mode 100644 drivers/scsi/ufs/ufshpb.h

-- 
2.25.1

