Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5DAC0C433E0
	for <linux-scsi@archiver.kernel.org>; Tue, 22 Dec 2020 01:57:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1CED522A83
	for <linux-scsi@archiver.kernel.org>; Tue, 22 Dec 2020 01:57:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725811AbgLVB5w (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 21 Dec 2020 20:57:52 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:54711 "EHLO
        mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725790AbgLVB5w (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 21 Dec 2020 20:57:52 -0500
Received: from epcas2p4.samsung.com (unknown [182.195.41.56])
        by mailout2.samsung.com (KnoxPortal) with ESMTP id 20201222015709epoutp02b8a9b2a517ca7be555f0f00fc218d7f1~S5zRj6mOa0167501675epoutp02x
        for <linux-scsi@vger.kernel.org>; Tue, 22 Dec 2020 01:57:09 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com 20201222015709epoutp02b8a9b2a517ca7be555f0f00fc218d7f1~S5zRj6mOa0167501675epoutp02x
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1608602229;
        bh=ApOUF2t53fPRqEF51InILOfNQdvqlRZzYkWPzLIOy44=;
        h=Subject:Reply-To:From:To:CC:Date:References:From;
        b=Chi9eXB57pkEZG/VDJG5cMAGWB8A706kYO2rCpXeMhRCVzDHd8AmW9b2mz51Bmj1L
         11r3Xsx9lhCiqk6KoRzn+flkxP6u7kXovh70Ekk27Ne5uo2kMrMcL5nZ1UQFynpM9T
         olojxwn/zO5N7mh8JqzfU98DnskvhMbivNHkItyg=
Received: from epsnrtp4.localdomain (unknown [182.195.42.165]) by
        epcas2p4.samsung.com (KnoxPortal) with ESMTP id
        20201222015708epcas2p43379e2080c57cffcc99144a3339c91d4~S5zQshrsG0104601046epcas2p4U;
        Tue, 22 Dec 2020 01:57:08 +0000 (GMT)
Received: from epsmges2p3.samsung.com (unknown [182.195.40.188]) by
        epsnrtp4.localdomain (Postfix) with ESMTP id 4D0KG902tRzMqYkt; Tue, 22 Dec
        2020 01:57:05 +0000 (GMT)
X-AuditID: b6c32a47-b97ff7000000148e-2e-5fe15270c14d
Received: from epcas2p4.samsung.com ( [182.195.41.56]) by
        epsmges2p3.samsung.com (Symantec Messaging Gateway) with SMTP id
        7F.75.05262.07251EF5; Tue, 22 Dec 2020 10:57:04 +0900 (KST)
Mime-Version: 1.0
Subject: [PATCH v18 0/3] scsi: ufs: Add Host Performance Booster Support
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
Message-ID: <20201222015704epcms2p643f0c5011064a7ce56b08331811a8509@epcms2p6>
Date:   Tue, 22 Dec 2020 10:57:04 +0900
X-CMS-MailID: 20201222015704epcms2p643f0c5011064a7ce56b08331811a8509
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
X-CPGSPASS: Y
X-CPGSPASS: Y
CMS-TYPE: 102P
X-Brightmail-Tracker: H4sIAAAAAAAAA11TfVBUVRyd+95jP5jWeSxQtzWLeQYCE7C7ueulEScK7M1oCEJhZm4bvIGt
        /XjtY7VsHHYmEVzElX8AEVAg0ZDcAWFZYMgVTKEJHYdAWFSgIAcDpcUsYqjYD9Lpv3PPPe+c
        e373PgEuvs2TCDT6PMaoV2spXiBh741CMezOSZX0ejdCzXfuB6CJGjsPdR/u46OZxSEe6h17
        wEdl84s4ctsaAtBMTxRqnMhEX9bbeKhqwIyhEmsbD9WN2DE02FnFQ8W3HDx09trfGBprDURn
        2kYBOlLeRKC62i7i9RB68Mdt9OCxEozuqLzDp4/XOQF9qbqJTx/qv0TQv027CPpYayOgF1pe
        pAudxVhq4G7t5lxGnc0Ywxh9liFbo89JoLalq95UKZRSWYwsHm2iwvRqHZNAJW1Pjdmq0a6U
        o8L2qbWmFSpVzXFU3JbNRoMpjwnLNXB5CRTDZmtZmYyN5dQ6zqTPic0y6F6TSaVyxYryQ22u
        e17CXlj/WY2lHTeDkbUWIBBAciP8xc5aQKBATDoAvDv8Nd/Di8gguOwItgChIJikYX1RNc+D
        xSQFbTcr+T4+Fromm4AH88hXYHnfON/jE0IWEND++KZ3gZO/Y9B97yTmUUFSBCsKpwkfXgvb
        z7YBH46EfzaU4D4cCkfPz/FX8cOrp/yaEFhwd8CvCYITi11+/nl4tWve758P227/BTzBkDwK
        YG+HK8C3EQeHi5q9wSLybdi9bPfWIchwWHfP7dckwX+cI14jnHwJts9V4Z5J4GQUtHXG+Ya1
        Hl5xEatVzM1L/P9jnFwDi3qX/+MdNVP+o0XAC4s2zGfzAnTVgOOAqnwy6cqnYiufxJ4GeCN4
        lmE5XQ7DydlXn77aFuB95tFvOUDF3HxsD8AEoAdAAU6FiJSScZVYlK3+/ABjNKiMJi3D9QDF
        SuFSXBKaZVj5T/R5KplCrlRK4xVIoZQj6jkRJ51QickcdR7zCcOwjHH1O0wglJixoFNZ+We+
        r92kF5eFCzobhNMnLFeGbtT0T53v7DamnZBLHm1wyg2SBcts4poIIfZFZteYOaPaZC3bf/Cy
        o0qiSbsRvDQ/m3J61yPLrWtCfuD+whRacy7o53hponMh9T13+V7RB4cjt3w6vi55b9GvwiBN
        liRl7AfJ1OzB8Mk37NYj1saqiAet31w+NGDviCQq+pN2bNe/+0d6qHE5n4mq/imD7k8mdqWO
        z3615+N18ReH3GMHkk+mj9Rj++JYRUUmuriwwypbmjEMl2Y8HE28njZY+l3x7o0zoS3mPbqj
        902ZLz/G8L6wEryoOs3sGul4vy/6o29tBbXPnJt+Z4rVu9uiKYLLVcuicSOn/he/VIIfbwQA
        AA==
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20201222015704epcms2p643f0c5011064a7ce56b08331811a8509
References: <CGME20201222015704epcms2p643f0c5011064a7ce56b08331811a8509@epcms2p6>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Changelog:

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
 drivers/scsi/ufs/ufshpb.c                  | 1754 ++++++++++++++++++++
 drivers/scsi/ufs/ufshpb.h                  |  231 +++
 9 files changed, 2208 insertions(+), 1 deletion(-)
 create mode 100644 drivers/scsi/ufs/ufshpb.c
 create mode 100644 drivers/scsi/ufs/ufshpb.h

-- 
2.25.1

