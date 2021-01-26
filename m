Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 140B7C433DB
	for <linux-scsi@archiver.kernel.org>; Tue, 26 Jan 2021 06:48:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BCE7F22B51
	for <linux-scsi@archiver.kernel.org>; Tue, 26 Jan 2021 06:48:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389076AbhAZGsA (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 26 Jan 2021 01:48:00 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:16281 "EHLO
        mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389162AbhAZGqF (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 26 Jan 2021 01:46:05 -0500
Received: from epcas2p3.samsung.com (unknown [182.195.41.55])
        by mailout3.samsung.com (KnoxPortal) with ESMTP id 20210126064508epoutp038320b93eaa3fd39de870d146ecf10368~dtTt9xJvR2674426744epoutp03Z
        for <linux-scsi@vger.kernel.org>; Tue, 26 Jan 2021 06:45:08 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com 20210126064508epoutp038320b93eaa3fd39de870d146ecf10368~dtTt9xJvR2674426744epoutp03Z
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1611643508;
        bh=DhkGcpxq5DhmmGMg+sWb7jMNeb6KhzxfyXQqpuL2qjk=;
        h=From:To:Cc:Subject:Date:References:From;
        b=JR66LToEFN0u3J2rkYEH/XLvlAZLK6C/aMIDGcX8RtcWQ2Cc25QWl3cFDtJxdffHO
         5NsplHOiYw7MTXSyKJXLB3fwsREbLHXeXkzf6aqH78Qi9EdYcNlCnndpvYi3TROeyy
         R4ZpK+C9WFJJphO1KP2/XOdTehujlLNSRyE+FtjI=
Received: from epsnrtp1.localdomain (unknown [182.195.42.162]) by
        epcas2p4.samsung.com (KnoxPortal) with ESMTP id
        20210126064507epcas2p44001e4853707cf8f2d1f178b3d48d23b~dtTs_Ek5f1137211372epcas2p4t;
        Tue, 26 Jan 2021 06:45:07 +0000 (GMT)
Received: from epsmges2p2.samsung.com (unknown [182.195.40.188]) by
        epsnrtp1.localdomain (Postfix) with ESMTP id 4DPy0K01Pvz4x9Ps; Tue, 26 Jan
        2021 06:45:05 +0000 (GMT)
Received: from epcas2p2.samsung.com ( [182.195.41.54]) by
        epsmges2p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        79.99.56312.07ABF006; Tue, 26 Jan 2021 15:45:04 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
        epcas2p3.samsung.com (KnoxPortal) with ESMTPA id
        20210126064504epcas2p30f5c88e1aa8f24b8d597d73ec4abeb6a~dtTp-bFHr1451914519epcas2p3O;
        Tue, 26 Jan 2021 06:45:04 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
        epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20210126064504epsmtrp189284920041494c0543b1560251344e6~dtTp9uWwQ0312103121epsmtrp13;
        Tue, 26 Jan 2021 06:45:04 +0000 (GMT)
X-AuditID: b6c32a46-1efff7000000dbf8-26-600fba70da96
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
        epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        63.09.13470.07ABF006; Tue, 26 Jan 2021 15:45:04 +0900 (KST)
Received: from ubuntu.dsn.sec.samsung.com (unknown [12.36.155.120]) by
        epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
        20210126064504epsmtip2a458174850482805adff48ace28ba492~dtTpswwND1124411244epsmtip2F;
        Tue, 26 Jan 2021 06:45:04 +0000 (GMT)
From:   Kiwoong Kim <kwmad.kim@samsung.com>
To:     linux-scsi@vger.kernel.org, alim.akhtar@samsung.com,
        avri.altman@wdc.com, jejb@linux.ibm.com,
        martin.petersen@oracle.com, beanhuo@micron.com,
        asutoshd@codeaurora.org, cang@codeaurora.org, bvanassche@acm.org,
        grant.jung@samsung.com, sc.suh@samsung.com, hy50.seo@samsung.com,
        sh425.lee@samsung.com, bhoon95.kim@samsung.com
Cc:     Kiwoong Kim <kwmad.kim@samsung.com>
Subject: [PATCH v8 0/2] introduce the way to get cmd completion info
Date:   Tue, 26 Jan 2021 15:33:33 +0900
Message-Id: <cover.1611642467.git.kwmad.kim@samsung.com>
X-Mailer: git-send-email 2.7.4
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpnk+LIzCtJLcpLzFFi42LZdljTTLdgF3+CwazXFhYP5m1js9jbdoLd
        4uXPq2wWBx92slh8XfqM1WLah5/MFp/WL2O1+PV3PbvF6sUPWCwW3djGZHFzy1EWi+7rO9gs
        lh//x2TRdfcGo8XSf29ZHPg9Ll/x9rjc18vkMWHRAUaP7+s72Dw+Pr3F4tG3ZRWjx+dNch7t
        B7qZAjiicmwyUhNTUosUUvOS81My89JtlbyD453jTc0MDHUNLS3MlRTyEnNTbZVcfAJ03TJz
        gI5XUihLzCkFCgUkFhcr6dvZFOWXlqQqZOQXl9gqpRak5BQYGhboFSfmFpfmpesl5+daGRoY
        GJkCVSbkZGzvbGYq+MZdcf/cTpYGxk2cXYycHBICJhKt964zdzFycQgJ7GCUeDP9FhOE84lR
        YuGuXUwgVUIC3xglbp5Ogen4t+E5C0TRXkaJtvtn2SCcH4wSyxq/MYNUsQloSjy9ORVslIjA
        GSaJa61nWUESzALqErsmnAAbKyzgInG69QBYA4uAqsSnpneMIDavgIXE5jc9zBDr5CRunusE
        O1BCoJFDYubn1ywQCReJ5i19bBC2sMSr41vYIWwpiZf9bVB2vcS+qQ2sEM09jBJP9/1jhEgY
        S8x61g5kcwBdpCmxfpc+iCkhoCxx5BYLxJ18Eh2H/7JDhHklOtqEIBqVJX5Nmgw1RFJi5s07
        UJs8JG69+cwOCa1YiU3PdrFPYJSdhTB/ASPjKkax1ILi3PTUYqMCI+RY2sQITpFabjsYp7z9
        oHeIkYmD8RCjBAezkgjvbj2eBCHelMTKqtSi/Pii0pzU4kOMpsDwmsgsJZqcD0zSeSXxhqZG
        ZmYGlqYWpmZGFkrivMUGD+KFBNITS1KzU1MLUotg+pg4OKUamCoMUzcuFrmxIrb2sYVQk84E
        3lf/9GYxWj5fxlF2+WypD49Ct73nxsdPOa7d9k6b3C7SvO9qziXTFTdzw/4y6XDJnjA5k/RZ
        wyZT8cXBk/W95woqsn98Wf2Y98VltRWca2XahQVVry+eL/xmT5r3h32+3xqeLTvH+H/LnZC8
        rbx1r2vOP9P/FnPrUfu3WYd8ud8d3V95iWmKX9vFm7zRv5bqMVl4cj7/KpQ8Z06KYl//gn+T
        Ii78CFidzGLi11zjbC7f6bnLw7nzYc+bC2ya2xacb/nNc91P9MGaqJ1LbhrtPWk31/exsG3F
        hyelExV8OUqW69lWHlV9MmvT/+WOpr8+SjWvKPsuu+R07VaZKQeVWIozEg21mIuKEwHy9E+v
        GgQAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrGLMWRmVeSWpSXmKPExsWy7bCSvG7BLv4Eg43LRSwezNvGZrG37QS7
        xcufV9ksDj7sZLH4uvQZq8W0Dz+ZLT6tX8Zq8evvenaL1YsfsFgsurGNyeLmlqMsFt3Xd7BZ
        LD/+j8mi6+4NRoul/96yOPB7XL7i7XG5r5fJY8KiA4we39d3sHl8fHqLxaNvyypGj8+b5Dza
        D3QzBXBEcdmkpOZklqUW6dslcGVs72xmKvjGXXH/3E6WBsZNnF2MnBwSAiYS/zY8Z+li5OIQ
        EtjNKHFp1WU2iISkxImdzxkhbGGJ+y1HWCGKvjFKXJtyG6yITUBT4unNqUwgCRGBe0wSlybM
        ZQZJMAuoS+yacIIJxBYWcJE43XoALM4ioCrxqekd2FReAQuJzW96mCE2yEncPNfJPIGRZwEj
        wypGydSC4tz03GLDAsO81HK94sTc4tK8dL3k/NxNjOCg1dLcwbh91Qe9Q4xMHIyHGCU4mJVE
        eHfr8SQI8aYkVlalFuXHF5XmpBYfYpTmYFES573QdTJeSCA9sSQ1OzW1ILUIJsvEwSnVwJSy
        8FGMWcKiglP1Uw0jjU14lHN4bI7HCH0QPCP7PHbXeWffstxu36uP1st8nR9+Mk36go7Ks/Tm
        1Vu3nHm9sDTHv4VP77zQjbPbbq89n2Z+NuKdlOHSvSH1WYlhUg6TryqUpTE7T3Vk4NJvfHDg
        94W7QRzuzUFbj2wsWu/YfPq8zjvRLR/0/F0vzz7mpMH9dWFEV3SQ63ypG6zf7kg27mEtTvSa
        VWnlvfGdDpPIHct1umw7Js0svrSx8d/Zn4pvbA9skkyvYbwduuhC2LdI2919Z6+8c/23SPT9
        2rPSnCdDZy28Up8cGx3mN+vju+OddU9POCpE5R3+s+89U1vxssczf227Lrvn2KssocDCTHMl
        luKMREMt5qLiRABQ/LQnyQIAAA==
X-CMS-MailID: 20210126064504epcas2p30f5c88e1aa8f24b8d597d73ec4abeb6a
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
CMS-TYPE: 102P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20210126064504epcas2p30f5c88e1aa8f24b8d597d73ec4abeb6a
References: <CGME20210126064504epcas2p30f5c88e1aa8f24b8d597d73ec4abeb6a@epcas2p3.samsung.com>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

v7 -> v8
change a way to get a range of cmd history more intuitively
change the header name that is newly added
fix some typos

v6 -> v7
migrate this to 5.10.
shrink the patch set, two patches.
merge a fix for build errors

v5 -> v6
replace put_aligned with get_unaligned_be32 to set lba and sct
fix null pointer access symptom

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

Kiwoong Kim (2):
  ufs: introduce a callback to get info of command completion
  ufs: exynos: introduce command history

 drivers/scsi/ufs/Kconfig          |  14 +++
 drivers/scsi/ufs/Makefile         |   4 +-
 drivers/scsi/ufs/ufs-exynos-dbg.c | 206 ++++++++++++++++++++++++++++++++++++++
 drivers/scsi/ufs/ufs-exynos-dbg.h |  17 ++++
 drivers/scsi/ufs/ufs-exynos.c     |  37 +++++++
 drivers/scsi/ufs/ufs-exynos.h     |  34 +++++++
 drivers/scsi/ufs/ufshcd.c         |   1 +
 drivers/scsi/ufs/ufshcd.h         |   8 ++
 8 files changed, 320 insertions(+), 1 deletion(-)
 create mode 100644 drivers/scsi/ufs/ufs-exynos-dbg.c
 create mode 100644 drivers/scsi/ufs/ufs-exynos-dbg.h

-- 
2.7.4

