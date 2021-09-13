Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 77A7DC433EF
	for <linux-scsi@archiver.kernel.org>; Mon, 13 Sep 2021 08:11:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5FF2B60D42
	for <linux-scsi@archiver.kernel.org>; Mon, 13 Sep 2021 08:11:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237935AbhIMINM (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 13 Sep 2021 04:13:12 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:44499 "EHLO
        mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237914AbhIMINL (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 13 Sep 2021 04:13:11 -0400
Received: from epcas2p2.samsung.com (unknown [182.195.41.54])
        by mailout4.samsung.com (KnoxPortal) with ESMTP id 20210913081154epoutp045779b4384c238259279409810a28e3c5~kU3IVW__O2102621026epoutp04W
        for <linux-scsi@vger.kernel.org>; Mon, 13 Sep 2021 08:11:54 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20210913081154epoutp045779b4384c238259279409810a28e3c5~kU3IVW__O2102621026epoutp04W
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1631520714;
        bh=3wSQHp5OD1QCkfHTySNHB+gLas/bsdRLv0o5Kcm6c8I=;
        h=From:To:Cc:Subject:Date:References:From;
        b=RfDvSwQeDmgz+WouElNWE1QMonVAjjj8HJH/C18SmDdGX8znDjEQ5XI74oMZtQ4Kl
         9kbm0sfL+t5s9EH69M4ZARoaYWmUjlYl3XJZuiopi7y+tMhn/mjZeSStr53Bl/uDep
         BG6C/9SpuHXKC/N4Jrs2UU3tmr3jyX/SXnKmxZcM=
Received: from epsnrtp2.localdomain (unknown [182.195.42.163]) by
        epcas2p4.samsung.com (KnoxPortal) with ESMTP id
        20210913081153epcas2p4b7856cbd4b513c1577184913fec9dfaf~kU3HRGoLo0388903889epcas2p4C;
        Mon, 13 Sep 2021 08:11:53 +0000 (GMT)
Received: from epsmges2p2.samsung.com (unknown [182.195.40.186]) by
        epsnrtp2.localdomain (Postfix) with ESMTP id 4H7K2F3lYmz4x9Pv; Mon, 13 Sep
        2021 08:11:49 +0000 (GMT)
Received: from epcas2p2.samsung.com ( [182.195.41.54]) by
        epsmges2p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        A6.44.09816.5C70F316; Mon, 13 Sep 2021 17:11:49 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
        epcas2p2.samsung.com (KnoxPortal) with ESMTPA id
        20210913081148epcas2p21c23ca6a745f40083ee7d6e7da4d7c00~kU3Cvr2MH3185531855epcas2p2Q;
        Mon, 13 Sep 2021 08:11:48 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
        epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20210913081148epsmtrp227cf5e0f1b437beae00b7f902fcfe23f~kU3Cuvk082271422714epsmtrp25;
        Mon, 13 Sep 2021 08:11:48 +0000 (GMT)
X-AuditID: b6c32a46-625ff70000002658-37-613f07c50379
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
        epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        19.DD.09091.4C70F316; Mon, 13 Sep 2021 17:11:48 +0900 (KST)
Received: from ubuntu.dsn.sec.samsung.com (unknown [12.36.155.120]) by
        epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
        20210913081148epsmtip18983fb86545c8ea2b555ab1abff06d31~kU3CeIYZP0673006730epsmtip1y;
        Mon, 13 Sep 2021 08:11:48 +0000 (GMT)
From:   Kiwoong Kim <kwmad.kim@samsung.com>
To:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        alim.akhtar@samsung.com, avri.altman@wdc.com, jejb@linux.ibm.com,
        martin.petersen@oracle.com, beanhuo@micron.com,
        cang@codeaurora.org, adrian.hunter@intel.com, sc.suh@samsung.com,
        hy50.seo@samsung.com, sh425.lee@samsung.com,
        bhoon95.kim@samsung.com
Cc:     Kiwoong Kim <kwmad.kim@samsung.com>
Subject: [PATCH v2 0/3] scsi: ufs: introduce vendor isr
Date:   Mon, 13 Sep 2021 16:55:52 +0900
Message-Id: <cover.1631519695.git.kwmad.kim@samsung.com>
X-Mailer: git-send-email 2.7.4
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpik+LIzCtJLcpLzFFi42LZdljTTPcou32iwas/zBYnn6xhs3gwbxub
        xcufV9ksDj7sZLH4uvQZq8Wn9ctYLVYvfsBisejGNiaLm1uOslhc3jWHzaL7+g42i+XH/zFZ
        dN29wWix9N9bFgc+j8t9vUwei/e8ZPKYsOgAo8f39R1sHh+f3mLx6NuyitHj8yY5j/YD3UwB
        HFE5NhmpiSmpRQqpecn5KZl56bZK3sHxzvGmZgaGuoaWFuZKCnmJuam2Si4+AbpumTlAhysp
        lCXmlAKFAhKLi5X07WyK8ktLUhUy8otLbJVSC1JyCgwNC/SKE3OLS/PS9ZLzc60MDQyMTIEq
        E3Iy3vx8z1Ywn6Xi0qXJrA2M25m7GDk5JARMJNa9bGTtYuTiEBLYwSjx/PI0dgjnE6PErgMX
        oDLfGCU+netkgWlpXfOGCSKxl1Hi5fUTbBDOD0aJow8bmECq2AQ0JZ7enApmiwjsY5I4uisd
        xGYWUJfYNeEEWFxYwFxize3jYIewCKhKPD09ibGLkYODV8BCYt2ROIhlchI3z3Uyg8yXEPjJ
        LtG3fi0bRMJF4lPzWaiLhCVeHd/CDmFLSXx+txeqpl5i39QGVojmHkaJp/v+MUIkjCVmPWsH
        W8YMdOj6XfogpoSAssSRWywQZ/JJdBz+yw4R5pXoaBOCaFSW+DVpMtQQSYmZN+9AbfWQWLB+
        H9gnQgKxEpNOLmefwCg7C2H+AkbGVYxiqQXFuempxUYFRsiRtIkRnBi13HYwTnn7Qe8QIxMH
        4yFGCQ5mJRHebW9sE4V4UxIrq1KL8uOLSnNSiw8xmgKDayKzlGhyPjA155XEG5oamZkZWJpa
        mJoZWSiJ855/bZkoJJCeWJKanZpakFoE08fEwSnVwLRo+e2N21x+ZsSeVP+4/OvE6Quv+FyU
        Dqy41fpGtPRLxqN4axv7tMN/LqbVpUxem3aBKbhef/ryRuZN9XVaW1le/ym01v3hlPi5uPDD
        lxP/n95nf25j0J6+adHybfvDKz4s+3x9UedGt6bNTcaOjyQ3RBuvWeWyet4EoSCHyQ+0PJQD
        ueXrTyqZHPvIUeRle/i99WruOeFd6ttsFFKaZ740djn2yufCt1VPO0Nt5q1+E1dy7Oe557ov
        95YEzdhxfqLFoVNhAc2MCx8ZLRftnfE/Umjf498W18z7ubKOe177+kO9Tma38oa0mTtPLuaL
        UpDz4orc//miwN8pC/myZD1M/bYmnY57WXvgVEjMtkczlViKMxINtZiLihMBLbePVxUEAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrILMWRmVeSWpSXmKPExsWy7bCSnO4RdvtEgyevRCxOPlnDZvFg3jY2
        i5c/r7JZHHzYyWLxdekzVotP65exWqxe/IDFYtGNbUwWN7ccZbG4vGsOm0X39R1sFsuP/2Oy
        6Lp7g9Fi6b+3LA58Hpf7epk8Fu95yeQxYdEBRo/v6zvYPD4+vcXi0bdlFaPH501yHu0HupkC
        OKK4bFJSczLLUov07RK4Mt78fM9WMJ+l4tKlyawNjNuZuxg5OSQETCRa17xh6mLk4hAS2M0o
        MeFtBxtEQlLixM7njBC2sMT9liOsEEXfGCV6N7WDFbEJaEo8vTkVrFtE4ByTxNTLS5lAEswC
        6hK7JpwAs4UFzCXW3D4Oto5FQFXi6elJQFM5OHgFLCTWHYmDWCAncfNcJ/MERp4FjAyrGCVT
        C4pz03OLDQsM81LL9YoTc4tL89L1kvNzNzGCQ1VLcwfj9lUf9A4xMnEwHmKU4GBWEuHd9sY2
        UYg3JbGyKrUoP76oNCe1+BCjNAeLkjjvha6T8UIC6YklqdmpqQWpRTBZJg5OqQYmuaMHV0x6
        Ni1spsAlc2GGetkjq69OPyYqy5P9UIT/+DW3+OM3Ivyk/A5+/7yuZUZVo8/HM98Z9nFMLNM4
        zVRaMUmhlen3a+EHJ0XzNrKe2ux3qmySG0PX/zd/LbR7GvOff0pZdOrAzQI2TZlTLQJnVD+Z
        i6elqM6MmOT2SPirqPIFhztMB5YsduNI3/Bn6aVm4+XGcp3Vvza/YXvwRkftmGpF/obqerVu
        +YmXvM7HSa9Rq5Wvr7C8KTbv8JmwzONJy0xK8np2X5bYtlnv7gk9/3at+jMz6ud0PCkJsb+f
        sdFlY8jP43KnVK5wb14vnG+gv1cncVdhT6rXJB/ZKRkbi53OrK78mbb7Be8S0TOLlViKMxIN
        tZiLihMB6rQJ58QCAAA=
X-CMS-MailID: 20210913081148epcas2p21c23ca6a745f40083ee7d6e7da4d7c00
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
CMS-TYPE: 102P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20210913081148epcas2p21c23ca6a745f40083ee7d6e7da4d7c00
References: <CGME20210913081148epcas2p21c23ca6a745f40083ee7d6e7da4d7c00@epcas2p2.samsung.com>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This patch is to activate some interrupt sources
that aren't defined in UFSHCI specifications. Those
purpose could be error handling, workaround or whatever.

Kiwoong Kim (3):
  scsi: ufs: introduce vendor isr
  scsi: ufs: introduce force requeue
  scsi: ufs: ufs-exynos: implement exynos isr

 drivers/scsi/ufs/ufs-exynos.c | 84 ++++++++++++++++++++++++++++++++++++-------
 drivers/scsi/ufs/ufshcd.c     | 22 ++++++++++--
 drivers/scsi/ufs/ufshcd.h     |  2 ++
 3 files changed, 93 insertions(+), 15 deletions(-)

-- 
2.7.4

