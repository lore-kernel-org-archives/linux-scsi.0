Return-Path: <SRS0=rv89=A7=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7DE97C433E0
	for <linux-scsi@archiver.kernel.org>; Mon, 20 Jul 2020 10:39:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2B1C622482
	for <linux-scsi@archiver.kernel.org>; Mon, 20 Jul 2020 10:39:55 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="YNbzxhY8"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728417AbgGTKjy (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 20 Jul 2020 06:39:54 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:41951 "EHLO
        mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728385AbgGTKjy (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 20 Jul 2020 06:39:54 -0400
Received: from epcas2p1.samsung.com (unknown [182.195.41.53])
        by mailout1.samsung.com (KnoxPortal) with ESMTP id 20200720103951epoutp01fe8c82214d508648cb8c9079fdaae988~jb8aS5P_X2667526675epoutp01g
        for <linux-scsi@vger.kernel.org>; Mon, 20 Jul 2020 10:39:51 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20200720103951epoutp01fe8c82214d508648cb8c9079fdaae988~jb8aS5P_X2667526675epoutp01g
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1595241591;
        bh=hZnd5UvtsMnDS9p28JV1d2YxmSMw16DWCosMukH/iZg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YNbzxhY8/XGe/4wk2aSsYvgYnMzOI15Omx/gAOX5zysruIIqPFZVCFywIdW3oyZU+
         IMNMuM0bmBZE4C5nxroY5HCbRxFCO63M65xLoupLT9U1PZY+ApHBTJpHYSfKMCXlhI
         R1ZYtJM19UA7+mPmRWDyy39DNom+5NHCDUNLdEwQ=
Received: from epsnrtp3.localdomain (unknown [182.195.42.164]) by
        epcas2p3.samsung.com (KnoxPortal) with ESMTP id
        20200720103951epcas2p3fc2256bfb6eab56cd1a9aa9cec3620d6~jb8ZzCJzV1127711277epcas2p3K;
        Mon, 20 Jul 2020 10:39:51 +0000 (GMT)
Received: from epsmges2p4.samsung.com (unknown [182.195.40.184]) by
        epsnrtp3.localdomain (Postfix) with ESMTP id 4B9JBr2SxpzMqYkZ; Mon, 20 Jul
        2020 10:39:48 +0000 (GMT)
Received: from epcas2p1.samsung.com ( [182.195.41.53]) by
        epsmges2p4.samsung.com (Symantec Messaging Gateway) with SMTP id
        13.AD.27013.474751F5; Mon, 20 Jul 2020 19:39:48 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
        epcas2p4.samsung.com (KnoxPortal) with ESMTPA id
        20200720103946epcas2p46e38e8d585d2882d167e5aa548e53217~jb8Vz0HKM3088630886epcas2p4K;
        Mon, 20 Jul 2020 10:39:46 +0000 (GMT)
Received: from epsmgms1p2.samsung.com (unknown [182.195.42.42]) by
        epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20200720103946epsmtrp129f631866dc34fd8104960a45f6298bd~jb8VwQ12Z1624116241epsmtrp1g;
        Mon, 20 Jul 2020 10:39:46 +0000 (GMT)
X-AuditID: b6c32a48-d35ff70000006985-f8-5f1574743530
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
        epsmgms1p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        32.3D.08303.274751F5; Mon, 20 Jul 2020 19:39:46 +0900 (KST)
Received: from rack03.dsn.sec.samsung.com (unknown [12.36.155.109]) by
        epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
        20200720103946epsmtip2d13f2727077b832c3d810287c6009b84~jb8VgkdOy0946209462epsmtip2w;
        Mon, 20 Jul 2020 10:39:46 +0000 (GMT)
From:   SEO HOYOUNG <hy50.seo@samsung.com>
To:     linux-scsi@vger.kernel.org, alim.akhtar@samsung.com,
        avri.altman@wdc.com, jejb@linux.ibm.com,
        martin.petersen@oracle.com, beanhuo@micron.com,
        asutoshd@codeaurora.org, cang@codeaurora.org, bvanassche@acm.org,
        grant.jung@samsung.com
Cc:     SEO HOYOUNG <hy50.seo@samsung.com>
Subject: [RFC PATCH v2 0/3] Support vendor specific operations for WB
Date:   Mon, 20 Jul 2020 19:40:10 +0900
Message-Id: <cover.1595240433.git.hy50.seo@samsung.com>
X-Mailer: git-send-email 2.26.0
In-Reply-To: <n>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrLJsWRmVeSWpSXmKPExsWy7bCmqW5JiWi8wfffAhYP5m1js9jbdoLd
        4uXPq2wWBx92slhM+/CT2eLT+mWsFr/+rme3WL34AYvFohvbmCy6r+9gs1h+/B+TA7fH5Sve
        Hpf7epk8Jiw6wOjxfX0Hm8fHp7dYPPq2rGL0+LxJzqP9QDdTAEdUjk1GamJKapFCal5yfkpm
        XrqtkndwvHO8qZmBoa6hpYW5kkJeYm6qrZKLT4CuW2YO0KFKCmWJOaVAoYDE4mIlfTubovzS
        klSFjPziElul1IKUnAJDwwK94sTc4tK8dL3k/FwrQwMDI1OgyoScjCcnD7EWzOGs+DgvtYFx
        AXsXIyeHhICJRNOCH8xdjFwcQgI7GCU6bryAcj4xSjw/fJARwvnMKLFs+VK4ljdPt7CB2EIC
        uxglLs21hSj6wSjR9fIHWIJNQENizbFDTCAJEYEPjBJHV8xmBUkwC6hJfL67jAXEFhZwldjw
        +AlYnEVAVeLKyc1MIDavgLnElKYJLBDb5CUWNfwGi3MKCEhsP30BqkZQ4uTMJywQM+UlmrfO
        BrtbQmAqh8SavuVQp7pIPJj4B2qQsMSr41ug4lISL/vboOx6iSn3VrFANPcwSuxZcYIJImEs
        MetZOzAAOIA2aEqs36UPYkoIKEscuQW1l0+i4/Bfdogwr0RHmxBEo5LEmbm3ocISEgdn50CE
        PSRubVsEDbdkidVt91knMCrMQvLMLCTPzEJYu4CReRWjWGpBcW56arFRgQly/G5iBKdbLY8d
        jLPfftA7xMjEwXiIUYKDWUmEdyKPcLwQb0piZVVqUX58UWlOavEhRlNgUE9klhJNzgcm/LyS
        eENTIzMzA0tTC1MzIwslcd53VhfihATSE0tSs1NTC1KLYPqYODilGpg4Nx+5+VO+mu/bNb2N
        3ezMZZ6p9455nOO6dlNf3zulUSb2g7aSYnm9FifnRwv9TzsMbX85mF94n2oda3TF2XdWiGF3
        C5/fynuC/0U/PJZaF/f4a5e3osbBt+W6Ip1qqvd/hHRy8risS1yQevH52cncQV8+f7GUucqy
        y6pLc1fppYZtf0Q9nFdGffu4PORa2LVsq99MW67WS0w9Zrzr//Kj8YcszMz9+pwPNX+x+3g9
        ffectyuneHt+bjGNviFpy6X3zCEoNHzZqbJ51SqmskcdzZ5cZWIp/ZS5qt+EV+7czO/R/29+
        WCr26n6HyYp7gZ86p9UcsbtyQqT7Y+l+iStSNwW/bNxukylw+3HFPVklluKMREMt5qLiRABQ
        K6BlQAQAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrBLMWRmVeSWpSXmKPExsWy7bCSvG5RiWi8wY8nmhYP5m1js9jbdoLd
        4uXPq2wWBx92slhM+/CT2eLT+mWsFr/+rme3WL34AYvFohvbmCy6r+9gs1h+/B+TA7fH5Sve
        Hpf7epk8Jiw6wOjxfX0Hm8fHp7dYPPq2rGL0+LxJzqP9QDdTAEcUl01Kak5mWWqRvl0CV8aT
        k4dYC+ZwVnycl9rAuIC9i5GTQ0LAROLN0y1sXYxcHEICOxgl3s45zwKRkJD4v7iJCcIWlrjf
        coQVougbo8SGzt1gRWwCGhJrjh0CKxIR+MMoMel0HIjNLKAm8fnuMrAaYQFXiQ2Pn7CC2CwC
        qhJXTm4Gq+cVMJeY0jQBapm8xKKG32BxTgEBie2nL4DZQgL8Em2b+xgh6gUlTs58wgIxX16i
        eets5gmMArOQpGYhSS1gZFrFKJlaUJybnltsWGCUl1quV5yYW1yal66XnJ+7iREcGVpaOxj3
        rPqgd4iRiYPxEKMEB7OSCO9EHuF4Id6UxMqq1KL8+KLSnNTiQ4zSHCxK4rxfZy2MExJITyxJ
        zU5NLUgtgskycXBKNTCZLLx70Typ5OLdCfM5r+wKyPz82WetY1N1f3DogdOiU34d3f418t6q
        HfsmvBDUitYxO3h/Zuuyirltf5v4tjNuCbaIKJb3tt82zf3ztZupnxI51933yHn2U8P9i/wi
        GdZ9kVcdJ+bemmT5mk9cUvu6j+b6xJ4jP46HRXi8Si4+5GfetyDGXs7c9WOm9IEyyV+3/V5q
        1nO+Fjqy+bvkYb8gxmQnptm/Zu90W5DikVVreCQvOMyP31Pm8qpCT0GWTdenTG3SWHo1JkAv
        zEujJ+ch+5I7Ny8tlGZ9oFb2WShX9Ikyh6Yas92+3R0J8m/uHvL/Jf81taDuSCL7bKWG2IXr
        ayfY6rgI/HxtJiNyylqJpTgj0VCLuag4EQBOxMgw+wIAAA==
X-CMS-MailID: 20200720103946epcas2p46e38e8d585d2882d167e5aa548e53217
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
CMS-TYPE: 102P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20200720103946epcas2p46e38e8d585d2882d167e5aa548e53217
References: <n>
        <CGME20200720103946epcas2p46e38e8d585d2882d167e5aa548e53217@epcas2p4.samsung.com>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi all,
Here is v2 of the patchset.
This patchs for supporting WB of vendor specific.
- when UFS reset and restore, need to cleare WB buffer.
- need to check WB buffer and flush operate before enter suspend
- do not enable WB with UFS probe.

[v1 -> v2]
- The ufshcd_reset_vendor() fuction for WB reset.
So I modified function name.
- uploade vendor wb code.


SEO HOYOUNG (3):
  scsi: ufs: modify write booster
  scsi: ufs: modify function call name When ufs reset and restore, need
    to disable write booster
  scsi: ufs: add vendor specific write booster To support the fuction of
    writebooster by vendor. The WB behavior that the vendor wants is
    slightly different. But we have to support it

 drivers/scsi/ufs/Makefile     |   1 +
 drivers/scsi/ufs/ufs-exynos.c |   6 +
 drivers/scsi/ufs/ufs_ctmwb.c  | 279 ++++++++++++++++++++++++++++++++++
 drivers/scsi/ufs/ufs_ctmwb.h  |  27 ++++
 drivers/scsi/ufs/ufshcd.c     |  23 ++-
 drivers/scsi/ufs/ufshcd.h     |  43 ++++++
 6 files changed, 374 insertions(+), 5 deletions(-)
 create mode 100644 drivers/scsi/ufs/ufs_ctmwb.c
 create mode 100644 drivers/scsi/ufs/ufs_ctmwb.h

-- 
2.26.0

