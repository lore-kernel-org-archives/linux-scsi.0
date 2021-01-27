Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 79523C433DB
	for <linux-scsi@archiver.kernel.org>; Wed, 27 Jan 2021 05:04:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 40C092070A
	for <linux-scsi@archiver.kernel.org>; Wed, 27 Jan 2021 05:04:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234408AbhA0EWy (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 26 Jan 2021 23:22:54 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:35914 "EHLO
        mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237284AbhA0Dus (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 26 Jan 2021 22:50:48 -0500
Received: from epcas2p2.samsung.com (unknown [182.195.41.54])
        by mailout1.samsung.com (KnoxPortal) with ESMTP id 20210127035000epoutp016afcf698152c2f72ffc5db578473b654~d_kFRTo5Z1059510595epoutp015
        for <linux-scsi@vger.kernel.org>; Wed, 27 Jan 2021 03:50:00 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20210127035000epoutp016afcf698152c2f72ffc5db578473b654~d_kFRTo5Z1059510595epoutp015
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1611719400;
        bh=4HETnPbevVgt8Eoz7erisJrAWuMoelXpHOC2qaDcvnM=;
        h=From:To:Cc:Subject:Date:References:From;
        b=K9EGJHdoJ/KyAD/pGiVFM4dApivvh2mGPb2UbE0aCx+uvHSI1mizrvP80Cg67Nykq
         koTHw1IF+2hXuBreXhbV76A9cX1JAyTN7UlajAxSu5bFLHpi9w+XxXuLZ1gA9gLBlx
         7Sb8OBEQ79S9QutfG1GTxgqRwvEbYEcMpr/cnf+s=
Received: from epsnrtp2.localdomain (unknown [182.195.42.163]) by
        epcas2p3.samsung.com (KnoxPortal) with ESMTP id
        20210127034959epcas2p3d10b956027748bef7fe12b9948b6b9ca~d_kEp_Z5Q3134931349epcas2p3B;
        Wed, 27 Jan 2021 03:49:59 +0000 (GMT)
Received: from epsmges2p1.samsung.com (unknown [182.195.40.185]) by
        epsnrtp2.localdomain (Postfix) with ESMTP id 4DQV3m5h3Pz4x9Q0; Wed, 27 Jan
        2021 03:49:56 +0000 (GMT)
Received: from epcas2p2.samsung.com ( [182.195.41.54]) by
        epsmges2p1.samsung.com (Symantec Messaging Gateway) with SMTP id
        BF.22.10621.4E2E0106; Wed, 27 Jan 2021 12:49:56 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
        epcas2p1.samsung.com (KnoxPortal) with ESMTPA id
        20210127034956epcas2p12c2fcd059fe146dfc580fe39bcedf782~d_kBrmCwV0652606526epcas2p1l;
        Wed, 27 Jan 2021 03:49:56 +0000 (GMT)
Received: from epsmgms1p2.samsung.com (unknown [182.195.42.42]) by
        epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20210127034956epsmtrp249a795ef49eaa1f658b3986a91edfd2d~d_kBqn8hd2007320073epsmtrp2a;
        Wed, 27 Jan 2021 03:49:56 +0000 (GMT)
X-AuditID: b6c32a45-337ff7000001297d-fb-6010e2e47a95
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
        epsmgms1p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        E9.6C.08745.4E2E0106; Wed, 27 Jan 2021 12:49:56 +0900 (KST)
Received: from ubuntu.dsn.sec.samsung.com (unknown [12.36.155.120]) by
        epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
        20210127034956epsmtip25a77cc31c75c6e3dcd9c9263aff54b3d~d_kBd71852511225112epsmtip2E;
        Wed, 27 Jan 2021 03:49:56 +0000 (GMT)
From:   Kiwoong Kim <kwmad.kim@samsung.com>
To:     linux-scsi@vger.kernel.org, alim.akhtar@samsung.com,
        avri.altman@wdc.com, jejb@linux.ibm.com,
        martin.petersen@oracle.com, beanhuo@micron.com,
        asutoshd@codeaurora.org, cang@codeaurora.org, bvanassche@acm.org,
        grant.jung@samsung.com, sc.suh@samsung.com, hy50.seo@samsung.com,
        sh425.lee@samsung.com, bhoon95.kim@samsung.com
Cc:     Kiwoong Kim <kwmad.kim@samsung.com>
Subject: [PATCH v9 0/2] introduce the way to get cmd completion info
Date:   Wed, 27 Jan 2021 12:38:21 +0900
Message-Id: <cover.1611718633.git.kwmad.kim@samsung.com>
X-Mailer: git-send-email 2.7.4
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupgk+LIzCtJLcpLzFFi42LZdljTTPfJI4EEg79T1C0ezNvGZrG37QS7
        xcufV9ksDj7sZLH4uvQZq8W0Dz+ZLT6tX8Zq8evvenaL1YsfsFgsurGNyeLmlqMsFt3Xd7BZ
        LD/+j8mi6+4NRoul/96yOPB7XL7i7XG5r5fJY8KiA4we39d3sHl8fHqLxaNvyypGj8+b5Dza
        D3QzBXBE5dhkpCampBYppOYl56dk5qXbKnkHxzvHm5oZGOoaWlqYKynkJeam2iq5+AToumXm
        AB2vpFCWmFMKFApILC5W0rezKcovLUlVyMgvLrFVSi1IySkwNCzQK07MLS7NS9dLzs+1MjQw
        MDIFqkzIyTiz5QdbwUyeiqsX/7M3MJ7i7GLk5JAQMJF40jaFrYuRi0NIYAejxKn+/ywQzidG
        iReTNzBCOJ8ZJVa1X2GHaZm49yFU1S5GiRs3F0JV/WCUODC/ixmkik1AU+LpzalMIAkRgTNM
        Etdaz7KCJJgF1CV2TTjBBGILC7hIvNl2AGwsi4CqxN6GL2A2r4CFxKuW66wQ6+Qkbp7rZAYZ
        JCHQyCFx4O9SqISLxNGOP1A3CUu8Or4FypaS+PxuLxuEXS+xb2oDK0RzD6PE033/GCESxhKz
        nrUD2RxAF2lKrN+lD2JKCChLHLnFAnEnn0TH4b/sEGFeiY42IYhGZYlfkyZDDZGUmHnzDtRW
        D4npR+6BtQoJxEqcXLqQeQKj7CyE+QsYGVcxiqUWFOempxYbFRgiR9MmRnCS1HLdwTj57Qe9
        Q4xMHIyHGCU4mJVEeN8rCyQI8aYkVlalFuXHF5XmpBYfYjQFhtdEZinR5Hxgms4riTc0NTIz
        M7A0tTA1M7JQEuctNngQLySQnliSmp2aWpBaBNPHxMEp1cCUecSB7dCRCYuuTfmfvcyVZ6Kk
        84ml2+Q2fM+U2Xokm2PfpqN7+RvZ17duqiw8rBn2eIrHeiP5mtRbj2Vkz/49efB+zt0tmw4d
        49D66fL3wmPZ5bUqITZqGUU8fP8fi/reynPKfB6X/JBvfVPu28nGkTEtfwRevyk09z2mP/ft
        n6V8XX7vwyyVfK053OUnGcmuMnktPDtnotiy57/WL156Jth6uqX932f2D+d6LD/KYa4wWdeI
        zaHD6bL5I9NV66InTjeT/nX3XbPTza9H1+rK5hZrvRRQZteuaPLQtPN/k5s1Y+GpqeZ+25bE
        Xsp2lBFoetS+RjxbeNLXP3v5UxWl3tfvCHm4/nCwktjXbkVtJZbijERDLeai4kQAHAK4OBsE
        AAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrGLMWRmVeSWpSXmKPExsWy7bCSvO6TRwIJBqeXcFo8mLeNzWJv2wl2
        i5c/r7JZHHzYyWLxdekzVotpH34yW3xav4zV4tff9ewWqxc/YLFYdGMbk8XNLUdZLLqv72Cz
        WH78H5NF190bjBZL/71lceD3uHzF2+NyXy+Tx4RFBxg9vq/vYPP4+PQWi0ffllWMHp83yXm0
        H+hmCuCI4rJJSc3JLEst0rdL4Mo4s+UHW8FMnoqrF/+zNzCe4uxi5OSQEDCRmLj3IUsXIxeH
        kMAORon/ly+xQiQkJU7sfM4IYQtL3G85wgpR9I1R4t+Z42wgCTYBTYmnN6cygSREBO4xSVya
        MJcZJMEsoC6xa8IJJhBbWMBF4s22A+wgNouAqsTehi9gNq+AhcSrlutQ2+Qkbp7rZJ7AyLOA
        kWEVo2RqQXFuem6xYYFRXmq5XnFibnFpXrpecn7uJkZw0Gpp7WDcs+qD3iFGJg7GQ4wSHMxK
        IrzvlQUShHhTEiurUovy44tKc1KLDzFKc7AoifNe6DoZLySQnliSmp2aWpBaBJNl4uCUamDq
        vhew81iLRa8949tVas0iO6S/Mhw22ii5qP18/8eUiBPl+dq72hYnsXWKMfvySrsU5G/KEQpJ
        O+7yq/Xr1MazFy60pJXIKOttVXx3bE4eEz/br9r3GZJKlYpt25WDVu/zZ8p1XGt/a/vqCL3G
        eylvL7jtj4+J3WGmYlNg8f1JikPtk6qwKdtvyjm06L3apX5sl4cn+5v1c+9833Do62vd3Ylp
        jv0uz3vsX15gMnm2I359YmvPtzWXHF8sSK9+uPtQxpcZ9t/epop/N8msecc7IT7M9/Gkm2tf
        xD+OPPgwcmn9h+XSVi+546fb7bhTc7q5KePtuX9yQjbP/tWZGzn7KibM5ndM2KUT+2j5ngVK
        LMUZiYZazEXFiQAbFVwJyQIAAA==
X-CMS-MailID: 20210127034956epcas2p12c2fcd059fe146dfc580fe39bcedf782
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
CMS-TYPE: 102P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20210127034956epcas2p12c2fcd059fe146dfc580fe39bcedf782
References: <CGME20210127034956epcas2p12c2fcd059fe146dfc580fe39bcedf782@epcas2p1.samsung.com>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

v8 -> v9
fix the overflow case

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
 drivers/scsi/ufs/ufs-exynos-dbg.c | 207 ++++++++++++++++++++++++++++++++++++++
 drivers/scsi/ufs/ufs-exynos-dbg.h |  17 ++++
 drivers/scsi/ufs/ufs-exynos.c     |  37 +++++++
 drivers/scsi/ufs/ufs-exynos.h     |  34 +++++++
 drivers/scsi/ufs/ufshcd.c         |   1 +
 drivers/scsi/ufs/ufshcd.h         |   8 ++
 8 files changed, 321 insertions(+), 1 deletion(-)
 create mode 100644 drivers/scsi/ufs/ufs-exynos-dbg.c
 create mode 100644 drivers/scsi/ufs/ufs-exynos-dbg.h

-- 
2.7.4

