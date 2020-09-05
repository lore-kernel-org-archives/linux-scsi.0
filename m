Return-Path: <SRS0=n0Yx=CO=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5DD0AC43461
	for <linux-scsi@archiver.kernel.org>; Sat,  5 Sep 2020 05:56:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F089C208DB
	for <linux-scsi@archiver.kernel.org>; Sat,  5 Sep 2020 05:56:26 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="SW5acDdX"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726203AbgIEF4Z (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 5 Sep 2020 01:56:25 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:21675 "EHLO
        mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725818AbgIEF4X (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 5 Sep 2020 01:56:23 -0400
Received: from epcas2p4.samsung.com (unknown [182.195.41.56])
        by mailout4.samsung.com (KnoxPortal) with ESMTP id 20200905055620epoutp0456357027d530330bd2a455165c9a382c~xzZSkAO593092530925epoutp04D
        for <linux-scsi@vger.kernel.org>; Sat,  5 Sep 2020 05:56:20 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20200905055620epoutp0456357027d530330bd2a455165c9a382c~xzZSkAO593092530925epoutp04D
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1599285381;
        bh=q2pbPNbffknjpXUlA3cfcKpw3Fz4sCC98x/yM5Ihxh0=;
        h=From:To:Cc:Subject:Date:References:From;
        b=SW5acDdX/CD77dc4RdDP585DmE255bRsElEVklP8H21dAlA1fPjaMe4lvqCh8+VCU
         e9IHiYT/1a8omdD894vs2UpKAuhdSY262SGyjBNDvqOzw9NEe/0ZIKN9cKWhfxTT2e
         yFbC/9atoogPwQ674hkeJloBFDUWHivPAK1awgkk=
Received: from epsnrtp3.localdomain (unknown [182.195.42.164]) by
        epcas2p4.samsung.com (KnoxPortal) with ESMTP id
        20200905055620epcas2p441069984459b07c414d133c5c1e42b91~xzZR-Q07-1604616046epcas2p43;
        Sat,  5 Sep 2020 05:56:20 +0000 (GMT)
Received: from epsmges2p1.samsung.com (unknown [182.195.40.182]) by
        epsnrtp3.localdomain (Postfix) with ESMTP id 4Bk3h1456gzMqYkZ; Sat,  5 Sep
        2020 05:56:17 +0000 (GMT)
Received: from epcas2p4.samsung.com ( [182.195.41.56]) by
        epsmges2p1.samsung.com (Symantec Messaging Gateway) with SMTP id
        EB.17.19322.188235F5; Sat,  5 Sep 2020 14:56:17 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
        epcas2p1.samsung.com (KnoxPortal) with ESMTPA id
        20200905055616epcas2p18fcdaa65c5040b9bf9fdc350ab075de3~xzZOpc-7f0317503175epcas2p1L;
        Sat,  5 Sep 2020 05:56:16 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
        epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20200905055616epsmtrp242154b72b658bf56c1c93d20c405173d~xzZOoiC4y1855018550epsmtrp2d;
        Sat,  5 Sep 2020 05:56:16 +0000 (GMT)
X-AuditID: b6c32a45-797ff70000004b7a-0e-5f53288169dc
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
        epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        07.91.08382.088235F5; Sat,  5 Sep 2020 14:56:16 +0900 (KST)
Received: from ubuntu.dsn.sec.samsung.com (unknown [12.36.155.120]) by
        epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
        20200905055616epsmtip1aff32283862c26002710a3a69d5747d4~xzZOaLulz2808628086epsmtip13;
        Sat,  5 Sep 2020 05:56:16 +0000 (GMT)
From:   Kiwoong Kim <kwmad.kim@samsung.com>
To:     linux-scsi@vger.kernel.org, alim.akhtar@samsung.com,
        avri.altman@wdc.com, jejb@linux.ibm.com,
        martin.petersen@oracle.com, beanhuo@micron.com,
        asutoshd@codeaurora.org, cang@codeaurora.org, bvanassche@acm.org,
        grant.jung@samsung.com, sc.suh@samsung.com, hy50.seo@samsung.com,
        sh425.lee@samsung.com
Cc:     Kiwoong Kim <kwmad.kim@samsung.com>
Subject: [PATCH v7 0/2] ufs: exynos: introduce the way to get cmd info
Date:   Sat,  5 Sep 2020 14:47:18 +0900
Message-Id: <cover.1599284713.git.kwmad.kim@samsung.com>
X-Mailer: git-send-email 2.7.4
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpkk+LIzCtJLcpLzFFi42LZdljTQrdRIzjeYPEqGYsH87axWextO8Fu
        8fLnVTaLgw87WSymffjJbPFp/TJWi19/17NbrF78gMVi0Y1tTBY3txxlsei+voPNYvnxf0wW
        XXdvMFos/feWxYHP4/IVb4/Lfb1MHhMWHWD0+L6+g83j49NbLB59W1YxenzeJOfRfqCbKYAj
        KscmIzUxJbVIITUvOT8lMy/dVsk7ON453tTMwFDX0NLCXEkhLzE31VbJxSdA1y0zB+huJYWy
        xJxSoFBAYnGxkr6dTVF+aUmqQkZ+cYmtUmpBSk6BoWGBXnFibnFpXrpecn6ulaGBgZEpUGVC
        Tsb9FbEFH7kqth5tZWxgPMPRxcjJISFgIvH45QPmLkYuDiGBHYwS51Y+ZIRwPjFKfLu9khXC
        +cYoserSVSaYllOTWtkgEnsZJXZe/88O4fxglGic+hCsik1AU+LpzalMIAkRgc1MEq8W3GcG
        STALqEvsmnACrEhYwE3ixMFtLCA2i4CqxKwVT9lBbF4BC4mFbXcYIdbJSdw818kMYf9kl3g+
        mQfCdpH492MeC4QtLPHq+BZ2CFtK4vO7vWwQdr3EvqkNYD9ICPQwSjzd9w9qqLHErGftQDYH
        0EGaEut36YOYEgLKEkdusUCcySfRcfgvO0SYV6KjTQiiUVni16TJUEMkJWbevAO11UPi/ryn
        YK1CArESDRPWMk1glJ2FMH8BI+MqRrHUguLc9NRiowJD5EjaxAhOi1quOxgnv/2gd4iRiYPx
        EKMEB7OSCK/HucB4Id6UxMqq1KL8+KLSnNTiQ4ymwOCayCwlmpwPTMx5JfGGpkZmZgaWpham
        ZkYWSuK8uYoX4oQE0hNLUrNTUwtSi2D6mDg4pRqYZnvdtjIxyQmbpnzdb9HGJyq/donsPbh2
        9SOnYBZ2pbNaP6Y/v1d2yJuzOToyz775es+zw2l9oobx9i69+dwzbjQ1/2YVDjzRff8x+w3G
        93/z65NC897v3PvrVFtphkNVTGmCo/I6Xr4CkaD+rpjNB/s/C2oHPcjxW3pzQZ9fX/D+h23q
        4SvWPGp9fr7jtgnPiyWGH9pq+GY//1SyP5Izvdo0R7wxZvJs4yRmqz973A9dUvr96NcRlf87
        ddZXOX9o0OrefvdpyeUrjSq3V2irCceez5w8P0am0yXf7+s8ZYf/bvbsZV/kHF+d2nhfdI+0
        j6tBk+rFTw8j5D6+Czj/Vmxbx3PdP4XKAnlGZ/SUWIozEg21mIuKEwHTOsXHFAQAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrALMWRmVeSWpSXmKPExsWy7bCSnG6DRnC8wfG/ahYP5m1js9jbdoLd
        4uXPq2wWBx92slhM+/CT2eLT+mWsFr/+rme3WL34AYvFohvbmCxubjnKYtF9fQebxfLj/5gs
        uu7eYLRY+u8tiwOfx+Ur3h6X+3qZPCYsOsDo8X19B5vHx6e3WDz6tqxi9Pi8Sc6j/UA3UwBH
        FJdNSmpOZllqkb5dAlfG/RWxBR+5KrYebWVsYDzD0cXIySEhYCJxalIrWxcjF4eQwG5Gibv9
        fawQCUmJEzufM0LYwhL3W46wQhR9Y5TY8v8oG0iCTUBT4unNqUwgCRGBw0wS/7c+ZwdJMAuo
        S+yacIIJxBYWcJM4cXAbC4jNIqAqMWvFU7AaXgELiYVtd6A2yEncPNfJPIGRZwEjwypGydSC
        4tz03GLDAsO81HK94sTc4tK8dL3k/NxNjOBA1dLcwbh91Qe9Q4xMHIyHGCU4mJVEeD3OBcYL
        8aYkVlalFuXHF5XmpBYfYpTmYFES571RuDBOSCA9sSQ1OzW1ILUIJsvEwSnVwLQlKn9Cxnn1
        RY4bVr5p4uqMbr3aP3uxQ1SdhEY4u8qz+f+6NS02bwj63bJQrHf9+bWr9p7l4srsf/LC5+D/
        /8vSLAXls+esXSS1j2su/9rdh0/GRTH3+zbprc5jSpD+H6FtfE9VJaay4KE4n90UjnvL3zbp
        LvZNiA0+3vyFQ2gtz0HlbTd1z+RMltJZwsyQtO/SQce+mP0HKlQ6PDcV7Yi/Nr/g0o1ruw73
        bt8iIPIqOUSqJOr3BvblxQ3nlh/s4nmuvPGhvcWqdbWPKybqlZ5YuFBxbkKrhMLRsOMT9z16
        M2nPtUUWAYdWmrcu772+Yu3V40tTO873HOm+LdK3R7M8zEaN54fin8Yvtnvu35RRYinOSDTU
        Yi4qTgQASvwaicMCAAA=
X-CMS-MailID: 20200905055616epcas2p18fcdaa65c5040b9bf9fdc350ab075de3
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
CMS-TYPE: 102P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20200905055616epcas2p18fcdaa65c5040b9bf9fdc350ab075de3
References: <CGME20200905055616epcas2p18fcdaa65c5040b9bf9fdc350ab075de3@epcas2p1.samsung.com>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

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
 drivers/scsi/ufs/ufs-exynos-dbg.c | 200 ++++++++++++++++++++++++++++++++++++++
 drivers/scsi/ufs/ufs-exynos-if.h  |  17 ++++
 drivers/scsi/ufs/ufs-exynos.c     |  38 ++++++++
 drivers/scsi/ufs/ufs-exynos.h     |  35 +++++++
 drivers/scsi/ufs/ufshcd.c         |   1 +
 drivers/scsi/ufs/ufshcd.h         |   8 ++
 8 files changed, 316 insertions(+), 1 deletion(-)
 create mode 100644 drivers/scsi/ufs/ufs-exynos-dbg.c
 create mode 100644 drivers/scsi/ufs/ufs-exynos-if.h

-- 
2.7.4

