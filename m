Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 08964C3526C
	for <linux-scsi@archiver.kernel.org>; Sat, 19 Dec 2020 09:19:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CCE8F23C15
	for <linux-scsi@archiver.kernel.org>; Sat, 19 Dec 2020 09:19:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726454AbgLSJSx (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 19 Dec 2020 04:18:53 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:51551 "EHLO
        mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726416AbgLSJSu (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 19 Dec 2020 04:18:50 -0500
Received: from epcas2p2.samsung.com (unknown [182.195.41.54])
        by mailout1.samsung.com (KnoxPortal) with ESMTP id 20201219091807epoutp01f1032ed612d6743487468bd9676f9652~SE4btAP5b0083000830epoutp01a
        for <linux-scsi@vger.kernel.org>; Sat, 19 Dec 2020 09:18:07 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20201219091807epoutp01f1032ed612d6743487468bd9676f9652~SE4btAP5b0083000830epoutp01a
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1608369487;
        bh=vkp1ppZGlV6SBsUWrLpDOu85qJ0U8doPhmY+r2snzIk=;
        h=Subject:Reply-To:From:To:CC:Date:References:From;
        b=ekPgY4zxbLuechypL8De0Q6ACgbXqNKmgCiRvZktiwYjJv60hZk/5LUCVVXe48ADw
         iHKkpqFeC/pvQgRse7WQ+XfnVYAEsIO5UcHsB5glp6pzdM802Nl28U8uhWdr2TTvRz
         Bcbam40IJyH2iDtO7ooHUbwTfueazM0M/ftMPxCY=
Received: from epsnrtp4.localdomain (unknown [182.195.42.165]) by
        epcas2p4.samsung.com (KnoxPortal) with ESMTP id
        20201219091805epcas2p4ff2cbd9de424c9cdfbc415d4dc8cd36e~SE4aKt-of2948329483epcas2p4J;
        Sat, 19 Dec 2020 09:18:05 +0000 (GMT)
Received: from epsmges2p4.samsung.com (unknown [182.195.40.183]) by
        epsnrtp4.localdomain (Postfix) with ESMTP id 4CygBL6gdXzMqYkZ; Sat, 19 Dec
        2020 09:18:02 +0000 (GMT)
X-AuditID: b6c32a48-50fff7000000cd1f-cd-5fddc54a0c0e
Received: from epcas2p3.samsung.com ( [182.195.41.55]) by
        epsmges2p4.samsung.com (Symantec Messaging Gateway) with SMTP id
        26.77.52511.A45CDDF5; Sat, 19 Dec 2020 18:18:02 +0900 (KST)
Mime-Version: 1.0
Subject: [PATCH v16 0/3] scsi: ufs: Add Host Performance Booster Support
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
Message-ID: <20201219091802epcms2p2c86f7ae2e81aa015702572a8ef180dae@epcms2p2>
Date:   Sat, 19 Dec 2020 18:18:02 +0900
X-CMS-MailID: 20201219091802epcms2p2c86f7ae2e81aa015702572a8ef180dae
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
X-CPGSPASS: Y
X-CPGSPASS: Y
CMS-TYPE: 102P
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrHJsWRmVeSWpSXmKPExsWy7bCmua7X0bvxBrfXGFhsvPuK1eLBvG1s
        FnvbTrBbvPx5lc3i8O137BbTPvxktvi0fhmrxctDmharHoRbNC9ez2Yx52wDk0Vv/1Y2i0U3
        tjFZXN41h82i+/oONovlx/8xWdzewmWxdOtNRovO6WtYLBYt3M3iIOJx+Yq3x+W+XiaPnbPu
        sntMWHSA0WP/3DXsHi0n97N4fHx6i8Wjb8sqRo/Pm+Q82g90MwVwReXYZKQmpqQWKaTmJeen
        ZOal2yp5B8c7x5uaGRjqGlpamCsp5CXmptoqufgE6Lpl5gA9p6RQlphTChQKSCwuVtK3synK
        Ly1JVcjILy6xVUotSMkpMDQs0CtOzC0uzUvXS87PtTI0MDAyBapMyMlY2NjDVjBDveL5z262
        BsZTcl2MnBwSAiYSS9ZsZe1i5OIQEtjBKPHgxisgh4ODV0BQ4u8OYZAaYQEPiVnX+phAbCEB
        JYn1F2exQ8T1JG49XMMIYrMJ6EhMP3GfHWSOiEAri8TZQ1NYQBxmga9MEp+ez2aC2MYrMaP9
        KQuELS2xfflWRghbQ+LHsl5mCFtU4ubqt+ww9vtj86FqRCRa752FqhGUePBzN1RcUuLY7g9Q
        8+sltt75xQiyWEKgh1Hi8M5brBAJfYlrHRvBFvMK+Ep8/9bLBmKzCKhKbJgxCeogF4n/d9rB
        6pkF5CW2v53DDAoJZgFNifW79EFMCQFliSO3WGBeadj4mx2dzSzAJ9Fx+C9cfMe8J1CnqUms
        +7meCWKMjMSteYwTGJVmIUJ6FpK1sxDWLmBkXsUollpQnJueWmxUYIIcuZsYwQldy2MH4+y3
        H/QOMTJxMB5ilOBgVhLhDX1wO16INyWxsiq1KD++qDQntfgQoynQwxOZpUST84E5Ja8k3tDU
        yMzMwNLUwtTMyEJJnDd0ZV+8kEB6YklqdmpqQWoRTB8TB6dUA9OBh1yPK6Sr92WFbj7v/Fcq
        49XaP4Ifdksx/G1OW/CQJT2ueF/d+vOJz85N/6Tx85bZ5XeqRyobmn+2669Vi4tk+LlxtbeI
        l4lS2MTVIndSvhU7thi0b3EpCrtdYFTSWiU/7UF9iOqeUlnXfPeG2P9zEitEfrzIfx0wI3h3
        1uHdux5eSp4mkO7Hm7jW7JpHZry1bODi/i03VYW291s1J/kdKXrVd/Tvq8rz7qfkvYtOX02w
        rfnFHvlf/s46o/45nlOV1T6XqWm5ix82M+Io9/q3pefxPqcbK9kX99+KFuT8Vaen0fmlVD6q
        0iIijMfXMSSMuVbs0+HoBf/WMEaV+LZt4V4z766c2LIijrleSizFGYmGWsxFxYkALIFlHHEE
        AAA=
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20201219091802epcms2p2c86f7ae2e81aa015702572a8ef180dae
References: <CGME20201219091802epcms2p2c86f7ae2e81aa015702572a8ef180dae@epcms2p2>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Changelog:

v15 -> v16
1. Add missed sysfs ABI documentation.

v14 -> v15
1. Remove duplicated sysfs ABI entries in documentation.
2. Add experiment result of HPB performance testing with iozone.


v13 -> v14
1. Cleanup codes by commentted in Greg's review.
2. Add documentation for sysfs entries (from Greg's review).
3. Add experiment result of HPB performance testing. (in this mail)

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

 drivers/scsi/ufs/Kconfig     |    9 +
 drivers/scsi/ufs/Makefile    |    1 +
 drivers/scsi/ufs/ufs-sysfs.c |   18 +
 drivers/scsi/ufs/ufs.h       |   49 +
 drivers/scsi/ufs/ufshcd.c    |   53 +
 drivers/scsi/ufs/ufshcd.h    |   23 +-
 drivers/scsi/ufs/ufshpb.c    | 1767 ++++++++++++++++++++++++++++++++++
 drivers/scsi/ufs/ufshpb.h    |  230 +++++
 8 files changed, 2149 insertions(+), 1 deletion(-)
 create mode 100644 drivers/scsi/ufs/ufshpb.c
 create mode 100644 drivers/scsi/ufs/ufshpb.h

-- 
2.25.1


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
 drivers/scsi/ufs/ufshpb.c                  | 1767 ++++++++++++++++++++
 drivers/scsi/ufs/ufshpb.h                  |  230 +++
 9 files changed, 2220 insertions(+), 1 deletion(-)
 create mode 100644 drivers/scsi/ufs/ufshpb.c
 create mode 100644 drivers/scsi/ufs/ufshpb.h

-- 
2.25.1

