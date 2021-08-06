Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.5 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1B52CC432BE
	for <linux-scsi@archiver.kernel.org>; Fri,  6 Aug 2021 06:49:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 02E07611CC
	for <linux-scsi@archiver.kernel.org>; Fri,  6 Aug 2021 06:49:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243446AbhHFGtv (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 6 Aug 2021 02:49:51 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:61380 "EHLO
        mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243429AbhHFGtp (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 6 Aug 2021 02:49:45 -0400
Received: from epcas2p3.samsung.com (unknown [182.195.41.55])
        by mailout1.samsung.com (KnoxPortal) with ESMTP id 20210806064928epoutp011088be9e8e4cd04f38f67a6228213634~YpOTZ8wGA0606406064epoutp01K
        for <linux-scsi@vger.kernel.org>; Fri,  6 Aug 2021 06:49:28 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20210806064928epoutp011088be9e8e4cd04f38f67a6228213634~YpOTZ8wGA0606406064epoutp01K
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1628232568;
        bh=NvnK/Fwh8b7Ur3W/GLRR5w7l6zGNytrKdH5pTrP4IEY=;
        h=From:To:Cc:Subject:Date:References:From;
        b=mg53Jtj/slVkESkqB9EwbNR82EbiE57V6N9FCXl4tOWdHVZjoxTbTUVNy2UEnqXbp
         KiJbPyzRMKJWrU6SJN//1TOl5Tqrr1m0Vt/UsTXlj/cDQZ1ODX5U11aRrulV1HInH9
         UuHdwd0r2nXjF1ZrRfLX5hRM8a4GHqSugYVzN/Uo=
Received: from epsnrtp1.localdomain (unknown [182.195.42.162]) by
        epcas2p4.samsung.com (KnoxPortal) with ESMTP id
        20210806064926epcas2p4806d0a8c3b3c5d2cedc2f1dd98e2cd85~YpOSDM9zM2541125411epcas2p4G;
        Fri,  6 Aug 2021 06:49:26 +0000 (GMT)
Received: from epsmges2p2.samsung.com (unknown [182.195.40.188]) by
        epsnrtp1.localdomain (Postfix) with ESMTP id 4Ggx0h1QH2z4x9QM; Fri,  6 Aug
        2021 06:49:24 +0000 (GMT)
Received: from epcas2p1.samsung.com ( [182.195.41.53]) by
        epsmges2p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        F2.92.09541.37BDC016; Fri,  6 Aug 2021 15:49:23 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
        epcas2p1.samsung.com (KnoxPortal) with ESMTPA id
        20210806064923epcas2p13dd6b442eed02404d87684afd9c1b229~YpOOzVuqx1862018620epcas2p1J;
        Fri,  6 Aug 2021 06:49:23 +0000 (GMT)
Received: from epsmgms1p2.samsung.com (unknown [182.195.42.42]) by
        epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20210806064923epsmtrp236082b7ae37728f51a0e8171f23cd635~YpOOybdt22658426584epsmtrp2a;
        Fri,  6 Aug 2021 06:49:23 +0000 (GMT)
X-AuditID: b6c32a46-095ff70000002545-73-610cdb7375c2
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
        epsmgms1p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        7F.11.32548.37BDC016; Fri,  6 Aug 2021 15:49:23 +0900 (KST)
Received: from ubuntu.dsn.sec.samsung.com (unknown [12.36.155.120]) by
        epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
        20210806064922epsmtip1578662061d7981f4d7841c3d43f5a84a~YpOOjjAAY3134831348epsmtip11;
        Fri,  6 Aug 2021 06:49:22 +0000 (GMT)
From:   Kiwoong Kim <kwmad.kim@samsung.com>
To:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        alim.akhtar@samsung.com, avri.altman@wdc.com, jejb@linux.ibm.com,
        martin.petersen@oracle.com, beanhuo@micron.com,
        cang@codeaurora.org, adrian.hunter@intel.com, sc.suh@samsung.com,
        hy50.seo@samsung.com, sh425.lee@samsung.com,
        bhoon95.kim@samsung.com
Cc:     Kiwoong Kim <kwmad.kim@samsung.com>
Subject: [RFC PATCH v1 0/2] scsi: ufs: introduce vendor isr
Date:   Fri,  6 Aug 2021 15:34:10 +0900
Message-Id: <cover.1628231581.git.kwmad.kim@samsung.com>
X-Mailer: git-send-email 2.7.4
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpgk+LIzCtJLcpLzFFi42LZdljTVLf4Nk+iwbpmc4uTT9awWTyYt43N
        4uXPq2wWBx92slh8XfqM1eLT+mWsFqsXP2CxWHRjG5PFzS1HWSwu75rDZtF9fQebxfLj/5gs
        uu7eYLRY+u8tiwOfx+W+XiaPxXteMnlMWHSA0eP7+g42j49Pb7F49G1ZxejxeZOcR/uBbqYA
        jqgcm4zUxJTUIoXUvOT8lMy8dFsl7+B453hTMwNDXUNLC3MlhbzE3FRbJRefAF23zBygw5UU
        yhJzSoFCAYnFxUr6djZF+aUlqQoZ+cUltkqpBSk5BYaGBXrFibnFpXnpesn5uVaGBgZGpkCV
        CTkZb//nFbxlrjh1dgl7A2MvcxcjJ4eEgInE02XzWLoYuTiEBHYwShy+dZoNwvnEKDF35yUo
        5zOjxI3mXnaYliczf0MldjFKzNs+hRHC+cEo8ftFLxtIFZuApsTTm1OZQGwRgX1MEkd3pYPY
        zALqErsmnACLCwtYS3zufwpWzyKgKnFpQxeYzStgIfF6Gcw2OYmb5zqhjv3KLrFuuxaE7SLx
        7XA7E4QtLPHq+BaoeimJz+/2skHY9RL7pjawghwnIdDDKPF03z9GiISxxKxn7UA2B9BBmhLr
        d+mDmBICyhJHbrFAnMkn0XH4LztEmFeio00IolFZ4tekyVBDJCVm3rwDtdVDYtOxU2wg5UIC
        sRJLN8ZOYJSdhTB+ASPjKkax1ILi3PTUYqMCI+Qo2sQITopabjsYp7z9oHeIkYmD8RCjBAez
        kghv8mKuRCHelMTKqtSi/Pii0pzU4kOMpsDQmsgsJZqcD0zLeSXxhqZGZmYGlqYWpmZGFkri
        vBpxXxOEBNITS1KzU1MLUotg+pg4OKUamHpmndO0uSQi13zPoap8tXBy+l21yGnPcxmVqvcE
        8ix6feOxWcWrWiv5TQx8GY9F+afHPN9bPsO8qMZyqtuffbG5C/tnLGaP/WN5Z6nOWZVnjda8
        37e7FnzM1HfTeZ9azGtgKNm8MDbE1mMZ+2tn8Tv/H//VvO8eGLw4Q7x4bkX8hUcNXDsEGd4v
        5Yhv7n5pWzVpUklezi4+w63anmfmnhfT+uv4lOfE1Ws6y27/0n3DyG8udUFh2fTNzinxmtdm
        nUs4mJ94iVE/THr7MsuE8z8eL5vM+f3XWZ5jPXUOfEc2hjm27TogNEG4nClY9Dn/qvKiU6/3
        P3PJYcqr8T5abNqy/dwvOc0sgcz5pevvKLEUZyQaajEXFScCAHukuboTBAAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrILMWRmVeSWpSXmKPExsWy7bCSnG7xbZ5Eg3kTWSxOPlnDZvFg3jY2
        i5c/r7JZHHzYyWLxdekzVotP65exWqxe/IDFYtGNbUwWN7ccZbG4vGsOm0X39R1sFsuP/2Oy
        6Lp7g9Fi6b+3LA58Hpf7epk8Fu95yeQxYdEBRo/v6zvYPD4+vcXi0bdlFaPH501yHu0HupkC
        OKK4bFJSczLLUov07RK4Mt7+zyt4y1xx6uwS9gbGXuYuRk4OCQETiSczf7N1MXJxCAnsYJSY
        8301G0RCUuLEzueMELawxP2WI6wQRd8YJVp+vQbrZhPQlHh6cyoTSEJE4ByTxNTLS5lAEswC
        6hK7JpwAs4UFrCU+9z8Fm8oioCpxaUMXmM0rYCHxelkvO8QGOYmb5zqZJzDyLGBkWMUomVpQ
        nJueW2xYYJSXWq5XnJhbXJqXrpecn7uJERyqWlo7GPes+qB3iJGJg/EQowQHs5IIb/JirkQh
        3pTEyqrUovz4otKc1OJDjNIcLErivBe6TsYLCaQnlqRmp6YWpBbBZJk4OKUamATFZbP+FM+9
        cJ9LTDXO9s8jrbiVD3IS0i3yteYWPbp6s5ldWel8Gg+Hc6zX9CvrqpMKYpY3/91z+/GC5ryP
        /OvEsn/3f9xyb1e65WXjBUq7Tn1O/iy9z72qWG+xekxN4Sbr2auYeHQusHT/y//G0N/hU6p/
        76jh54s7zrWJK8v82Hc861XamrILztEi7Feu61z/wL5pysWwQ6ef3IzO3pA/qTZ+x/0jV2w3
        rljdamVl/d0juOGe8lu+3bf9nzCUCPjlMgjl2SlW7z686/IzTq+96gLLmtUUGHx7j66Vf1+s
        oVt1+JXiq9LbTmuTKyO/8Pht/JhvMGO7QFLYLMn+/4ZzRTdu8TvlXLZe/5zifSWW4oxEQy3m
        ouJEAINGJQfEAgAA
X-CMS-MailID: 20210806064923epcas2p13dd6b442eed02404d87684afd9c1b229
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
CMS-TYPE: 102P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20210806064923epcas2p13dd6b442eed02404d87684afd9c1b229
References: <CGME20210806064923epcas2p13dd6b442eed02404d87684afd9c1b229@epcas2p1.samsung.com>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This patch is to activate some interrupt sources
that aren't defined in UFSHCI specifications. Those
purpose could be error handling, workaround or whatever.

Kiwoong Kim (2):
  scsi: ufs: introduce vendor isr
  scsi: ufs: ufs-exynos: implement exynos isr

 drivers/scsi/ufs/ufs-exynos.c | 78 +++++++++++++++++++++++++++++------
 drivers/scsi/ufs/ufshcd.c     | 10 +++++
 drivers/scsi/ufs/ufshcd.h     |  8 ++++
 3 files changed, 84 insertions(+), 12 deletions(-)

-- 
2.31.1

