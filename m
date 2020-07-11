Return-Path: <SRS0=uOdR=AW=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9BC5BC433E0
	for <linux-scsi@archiver.kernel.org>; Sat, 11 Jul 2020 07:05:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 56A97207D4
	for <linux-scsi@archiver.kernel.org>; Sat, 11 Jul 2020 07:05:48 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="VcIdD3D0"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728049AbgGKHFr (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 11 Jul 2020 03:05:47 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:24782 "EHLO
        mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728012AbgGKHFr (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 11 Jul 2020 03:05:47 -0400
Received: from epcas2p4.samsung.com (unknown [182.195.41.56])
        by mailout3.samsung.com (KnoxPortal) with ESMTP id 20200711070545epoutp03ab37c7dc2c441f33f4cc624e7575c10f~goN5lGviz1716817168epoutp03l
        for <linux-scsi@vger.kernel.org>; Sat, 11 Jul 2020 07:05:45 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com 20200711070545epoutp03ab37c7dc2c441f33f4cc624e7575c10f~goN5lGviz1716817168epoutp03l
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1594451145;
        bh=zVBVl40no2gM9riy2DVV5Swj23xQTSKHXJmY7aWiPZA=;
        h=From:To:Cc:Subject:Date:References:From;
        b=VcIdD3D0bCG5pOdxA514TJzfvF5apA3kQvmsWTgNqZxTXOxDL1MnQYGrOgldjPJUu
         mwfqHqGVXustw0OJiEEcc0ArX5bmUD/XOTdd9iA6wnyv66DXFPYjv7D/1Z9l78z9hT
         F5zQOUBMhqCxwT1FiyJQlQpnruZ5A9DOdut7LwSk=
Received: from epsnrtp3.localdomain (unknown [182.195.42.164]) by
        epcas2p4.samsung.com (KnoxPortal) with ESMTP id
        20200711070544epcas2p4914bea8e836576eecab1ea4962711de6~goN4-W_xq1758017580epcas2p4B;
        Sat, 11 Jul 2020 07:05:44 +0000 (GMT)
Received: from epsmges2p3.samsung.com (unknown [182.195.40.187]) by
        epsnrtp3.localdomain (Postfix) with ESMTP id 4B3gsy2vkhzMqYkY; Sat, 11 Jul
        2020 07:05:42 +0000 (GMT)
Received: from epcas2p3.samsung.com ( [182.195.41.55]) by
        epsmges2p3.samsung.com (Symantec Messaging Gateway) with SMTP id
        EF.75.27441.6C4690F5; Sat, 11 Jul 2020 16:05:42 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
        epcas2p4.samsung.com (KnoxPortal) with ESMTPA id
        20200711070541epcas2p47678883840df461f649becfc73792da5~goN2SN_Xb1758017580epcas2p49;
        Sat, 11 Jul 2020 07:05:41 +0000 (GMT)
Received: from epsmgms1p2.samsung.com (unknown [182.195.42.42]) by
        epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20200711070541epsmtrp1f86e26fe1de25dc8faf682b2e4b82cd1~goN2RZ6ZS0578505785epsmtrp1W;
        Sat, 11 Jul 2020 07:05:41 +0000 (GMT)
X-AuditID: b6c32a47-fafff70000006b31-24-5f0964c621c6
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
        epsmgms1p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        DD.CE.08303.5C4690F5; Sat, 11 Jul 2020 16:05:41 +0900 (KST)
Received: from ubuntu.dsn.sec.samsung.com (unknown [12.36.155.120]) by
        epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
        20200711070541epsmtip28deaedd97b1f47ebd5f7008411fb78b5~goN2BxLJ03151531515epsmtip2d;
        Sat, 11 Jul 2020 07:05:41 +0000 (GMT)
From:   Kiwoong Kim <kwmad.kim@samsung.com>
To:     linux-scsi@vger.kernel.org, alim.akhtar@samsung.com,
        avri.altman@wdc.com, jejb@linux.ibm.com,
        martin.petersen@oracle.com, beanhuo@micron.com,
        asutoshd@codeaurora.org, cang@codeaurora.org, bvanassche@acm.org,
        grant.jung@samsung.com, sc.suh@samsung.com, hy50.seo@samsung.com,
        sh425.lee@samsung.com
Cc:     Kiwoong Kim <kwmad.kim@samsung.com>
Subject: [RFC PATCH v5 0/3] ufs: exynos: introduce the way to get cmd info
Date:   Sat, 11 Jul 2020 15:57:42 +0900
Message-Id: <cover.1594450408.git.kwmad.kim@samsung.com>
X-Mailer: git-send-email 2.7.4
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpik+LIzCtJLcpLzFFi42LZdljTXPdYCme8wYQ7QhYP5m1js9jbdoLd
        4uXPq2wWBx92slhM+/CT2eLT+mWsFr/+rme3WL34AYvFohvbmCxubjnKYtF9fQebxfLj/5gs
        uu7eYLRY+u8tiwOfx+Ur3h6X+3qZPCYsOsDo8X19B5vHx6e3WDz6tqxi9Pi8Sc6j/UA3UwBH
        VI5NRmpiSmqRQmpecn5KZl66rZJ3cLxzvKmZgaGuoaWFuZJCXmJuqq2Si0+ArltmDtDdSgpl
        iTmlQKGAxOJiJX07m6L80pJUhYz84hJbpdSClJwCQ8MCveLE3OLSvHS95PxcK0MDAyNToMqE
        nIyzS06xFezmrJjzdyV7A+MB9i5GTg4JAROJjT+es4LYQgI7GCWWTjDpYuQCsj8xStw/cIcZ
        wvnMKNHa/Y4NpmP+8TNQiV2MEjd3rmOBcH4wSly//xNsFpuApsTTm1OZQBIiApuZJF4tuM8M
        kmAWUJfYNeEEE4gtLOAlceLwVrCxLAKqEifXbwGr4RWwkLjVeIAZYp2cxM1znWDrJAS+skts
        XroLKuEicfHuEagvhCVeHd8CZUtJvOxvg7LrJfZNbWCFaO5hlHi67x8jRMJYYtazdiCbA+gi
        TYn1u/RBTAkBZYkjt1gg7uST6Dj8lx0izCvR0SYE0ags8WvSZKghkhIzb96B2uQh8eT2QhZI
        OMZKPD++gGUCo+wshPkLGBlXMYqlFhTnpqcWGxUYI8fSJkZwYtRy38E44+0HvUOMTByMhxgl
        OJiVRHijRTnjhXhTEiurUovy44tKc1KLDzGaAsNrIrOUaHI+MDXnlcQbmhqZmRlYmlqYmhlZ
        KInzFltdiBMSSE8sSc1OTS1ILYLpY+LglGpgyi/7rCGiP0Fs447GKb89P8f5Fa/9u7NSbmKs
        2xbpuPsid9dUc9b93a3FUFfFODGmL8jWPGr+nCbvvedaw3RvxF1t54laccfzA5OAwv7b6hk7
        bEQvftOOnrnk8Qwl/+g30k2moStUTj87d61si8echPfMlmKrl2j/Xxrn5X1mRvCLqdXR54X4
        b8U+UQ9vMNjkdWNPq0BAJZtkbIxTg0vF7C07bX9ccf/s0iww0e/57eVtfUJNx+YVvnX0k1Xw
        1Z0wxdBfPnjPaTF7biuPuKv8Z5rj1p1+5b5jpsW8M0Hn5TqdnJnnX70nXbqe5aJCUoNpwemf
        X2Y0J0jyujN5ZDZ+auUOkIwpCG1zcY4VZVZiKc5INNRiLipOBAA/9nzhFQQAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrALMWRmVeSWpSXmKPExsWy7bCSvO7RFM54gycPZSwezNvGZrG37QS7
        xcufV9ksDj7sZLGY9uEns8Wn9ctYLX79Xc9usXrxAxaLRTe2MVnc3HKUxaL7+g42i+XH/zFZ
        dN29wWix9N9bFgc+j8tXvD0u9/UyeUxYdIDR4/v6DjaPj09vsXj0bVnF6PF5k5xH+4FupgCO
        KC6blNSczLLUIn27BK6Ms0tOsRXs5qyY83clewPjAfYuRk4OCQETifnHzzCD2EICOxglLt/g
        gIhLSpzY+ZwRwhaWuN9yhLWLkQuo5hujxMkX58Ca2QQ0JZ7enMoEkhAROMwk8X/rc7AEs4C6
        xK4JJ5hAbGEBL4kTh7eygdgsAqoSJ9dvAdvGK2AhcavxADPEBjmJm+c6mScw8ixgZFjFKJla
        UJybnltsWGCUl1quV5yYW1yal66XnJ+7iREcqFpaOxj3rPqgd4iRiYPxEKMEB7OSCG+0KGe8
        EG9KYmVValF+fFFpTmrxIUZpDhYlcd6vsxbGCQmkJ5akZqemFqQWwWSZODilGpgypphbGj2v
        Nrb+azXJ1+uNgCCngeiBHNaK5dZFGr1/3ilk3qtS6oss1ihoKt+RO997ifqvX5Zy8lkc2TmM
        WsvZeb672r87/23L+kQfyXVzLr1ZFMYtL/rfPV6p6sjbmKtRxYu/HzHwOFJmExkVdsXc7MnR
        uArxjJoHE3fdn3bg9u6lCxYLVid0SeTO3HZvWc0urm3bku5GBZ+QML8TlRIUHNy7yZihZs5O
        3rhvc3zWuor12vHKX7npZZxqymmWtjvKhnNrHMOxvI08zCYfPzk0VkY5hEtNWrR7xoGd52bt
        OvFhwYL555L0JybOy7wvWtq8LX7qhtBZdzTTkubxT+OZ8mX3QjfpuunN/F45nUosxRmJhlrM
        RcWJADm9FUrDAgAA
X-CMS-MailID: 20200711070541epcas2p47678883840df461f649becfc73792da5
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
CMS-TYPE: 102P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20200711070541epcas2p47678883840df461f649becfc73792da5
References: <CGME20200711070541epcas2p47678883840df461f649becfc73792da5@epcas2p4.samsung.com>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

v4 -> v5
Rebased on Stanley's patch (scsi: ufs: Fix and simplify ..
Change cmd history print order
rename config to SCSI_UFS_EXYNOS_DBG
feature functions in ufs-exynos-dbg.c by SCSI_UFS_EXYNOS_DBG

v3 -> v4
seperate respective implementations of the callbacks
change the location of compl_xfer_req related stuffs
fix null pointer access

v2 -> v3
fix build errors

v1 -> v2
change callbacks
allocate memory for ufs_s_dbg_mgr dynamically, not static way

Kiwoong Kim (3):
  ufs: introduce a callback to get info of command completion
  ufs: exynos: introduce command history
  ufs: exynos: implement dbg_register_dump

 drivers/scsi/ufs/Kconfig          |  14 +++
 drivers/scsi/ufs/Makefile         |   1 +
 drivers/scsi/ufs/ufs-exynos-dbg.c | 197 ++++++++++++++++++++++++++++++++++++++
 drivers/scsi/ufs/ufs-exynos-if.h  |  17 ++++
 drivers/scsi/ufs/ufs-exynos.c     |  39 ++++++++
 drivers/scsi/ufs/ufs-exynos.h     |  35 +++++++
 drivers/scsi/ufs/ufshcd.c         |   1 +
 drivers/scsi/ufs/ufshcd.h         |   8 ++
 8 files changed, 312 insertions(+)
 create mode 100644 drivers/scsi/ufs/ufs-exynos-dbg.c
 create mode 100644 drivers/scsi/ufs/ufs-exynos-if.h

-- 
2.7.4

