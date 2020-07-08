Return-Path: <SRS0=1cZD=AT=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DBF39C433DF
	for <linux-scsi@archiver.kernel.org>; Wed,  8 Jul 2020 02:31:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9F83320774
	for <linux-scsi@archiver.kernel.org>; Wed,  8 Jul 2020 02:31:59 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="QppugzBI"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728934AbgGHCb7 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 7 Jul 2020 22:31:59 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:58124 "EHLO
        mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728366AbgGHCb6 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 7 Jul 2020 22:31:58 -0400
Received: from epcas2p1.samsung.com (unknown [182.195.41.53])
        by mailout4.samsung.com (KnoxPortal) with ESMTP id 20200708023155epoutp04fb0134fe61629f7b93e827df267bf4cb~fpi95GThA2857528575epoutp04e
        for <linux-scsi@vger.kernel.org>; Wed,  8 Jul 2020 02:31:55 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20200708023155epoutp04fb0134fe61629f7b93e827df267bf4cb~fpi95GThA2857528575epoutp04e
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1594175515;
        bh=Ex0he9zV1Lvlxw22T+osndxozMkoIgnNwKkGa3l630g=;
        h=From:To:Cc:Subject:Date:References:From;
        b=QppugzBI8R0/PxXvdlUr7VaB8fX/DulvgocbAWYwEsERuyX+rviaNzsIRLy/LlVbE
         cwrCdPO0UJS/GdGQh+DFbZ3LG1qDN3jkF6o6Z8pwg6O3eTobPhFrJfo/a7Re8iG/2r
         d0pW4horeNhzL7q589szRLD03N+2gB/fJ/8gqf/o=
Received: from epsnrtp4.localdomain (unknown [182.195.42.165]) by
        epcas2p2.samsung.com (KnoxPortal) with ESMTP id
        20200708023155epcas2p2fb95f0c29721f136d448bcfa3f834e8c~fpi9PkIo_1623016230epcas2p2W;
        Wed,  8 Jul 2020 02:31:55 +0000 (GMT)
Received: from epsmges2p2.samsung.com (unknown [182.195.40.184]) by
        epsnrtp4.localdomain (Postfix) with ESMTP id 4B1jxQ0c51zMqYkh; Wed,  8 Jul
        2020 02:31:54 +0000 (GMT)
Received: from epcas2p2.samsung.com ( [182.195.41.54]) by
        epsmges2p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        EF.0A.18874.910350F5; Wed,  8 Jul 2020 11:31:54 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
        epcas2p1.samsung.com (KnoxPortal) with ESMTPA id
        20200708023153epcas2p1fc18ee2920c5defa2896af34dd62865f~fpi7gP5rn1707617076epcas2p1e;
        Wed,  8 Jul 2020 02:31:53 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
        epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20200708023153epsmtrp10271535671ff6fc80cd37d7cedfd55f6~fpi7fbaZH1231912319epsmtrp1U;
        Wed,  8 Jul 2020 02:31:53 +0000 (GMT)
X-AuditID: b6c32a46-503ff700000049ba-5d-5f053019de13
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
        epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        61.BE.08382.910350F5; Wed,  8 Jul 2020 11:31:53 +0900 (KST)
Received: from ubuntu.dsn.sec.samsung.com (unknown [12.36.155.120]) by
        epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
        20200708023153epsmtip20215cab1f9172157bb8672cae2769cd0~fpi7L0D_K0606606066epsmtip2I;
        Wed,  8 Jul 2020 02:31:53 +0000 (GMT)
From:   Kiwoong Kim <kwmad.kim@samsung.com>
To:     linux-scsi@vger.kernel.org, alim.akhtar@samsung.com,
        avri.altman@wdc.com, jejb@linux.ibm.com,
        martin.petersen@oracle.com, beanhuo@micron.com,
        asutoshd@codeaurora.org, cang@codeaurora.org, bvanassche@acm.org,
        grant.jung@samsung.com, sc.suh@samsung.com, hy50.seo@samsung.com,
        sh425.lee@samsung.com
Cc:     Kiwoong Kim <kwmad.kim@samsung.com>
Subject: [RESEND RFC PATCH v4 0/3] ufs: exynos: introduce the way to get cmd
 info
Date:   Wed,  8 Jul 2020 11:23:58 +0900
Message-Id: <cover.1594174981.git.kwmad.kim@samsung.com>
X-Mailer: git-send-email 2.7.4
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpik+LIzCtJLcpLzFFi42LZdljTTFfKgDXeoOMFo8WDedvYLPa2nWC3
        ePnzKpvFwYedLBbTPvxktvi0fhmrxa+/69ktVi9+wGKx6MY2JoubW46yWHRf38Fmsfz4PyaL
        rrs3GC2W/nvL4sDncfmKt8flvl4mjwmLDjB6fF/fwebx8ektFo++LasYPT5vkvNoP9DNFMAR
        lWOTkZqYklqkkJqXnJ+SmZduq+QdHO8cb2pmYKhraGlhrqSQl5ibaqvk4hOg65aZA3S3kkJZ
        Yk4pUCggsbhYSd/Opii/tCRVISO/uMRWKbUgJafA0LBArzgxt7g0L10vOT/XytDAwMgUqDIh
        J2P//7dsBY0cFb8O/GdsYFzK1sXIySEhYCJxZtdE5i5GLg4hgR2MEnO39kA5nxgl+o9sY4Rw
        vjFKvDz3kRWm5UX7KTaIxF5GiUNf14IlhAR+MEoc+J4IYrMJaEo8vTmVCaRIRGAzk8SrBfeZ
        QRLMAuoSuyacYAKxhQWCJf5fPAhmswioSqx4sIUFxOYVsJA4dXAX1IFyEjfPdYLdJCHwlV2i
        e9lbqISLxJKD61kgbGGJV8e3sEPYUhIv+9ug7HqJfVMbWCGaexglnu77xwiRMJaY9awdyOYA
        ukhTYv0ufRBTQkBZ4sgtFog7+SQ6Dv9lhwjzSnS0CUE0Kkv8mjQZaoikxMybd6A2eUi8WLGO
        ERIOsRJ/NvQyT2CUnYUwfwEj4ypGsdSC4tz01GKjAiPkWNrECE6MWm47GKe8/aB3iJGJg/EQ
        owQHs5IIr4Eia7wQb0piZVVqUX58UWlOavEhRlNgeE1klhJNzgem5rySeENTIzMzA0tTC1Mz
        Iwslcd56xQtxQgLpiSWp2ampBalFMH1MHJxSDUwXFBP/TO8T/Gq+Yc7xhIOR2ZODz1w8E20j
        dbHr5pMFnmFTImoavshVlm+IfPbtTuyVX5PtUhyOXHWS0i84cNRnXYVFcYXA00V6fy3X18fH
        J2Z5PZ3tccUzf26O36tut9s/JLUl67etD6h7wZ29rLpmvRXLqjXH9P4kWnNt7DVps7bn+VLu
        aSDUXrVE1+nHtTXHTFMOz7j1Tlzzj2xj3M5Q5TSfixdfHe4J+tX3cYnw7cciovsck6QDp24L
        LHS9Vyv4/2RWy6XzB5cbzWUone78aXmxbtj/Ke3TJQ58DI+7dVR/1uH628sm+CQ9unjttprt
        jZeRxj/EVzCyTem3sf2tKuWc++ZVQ8ilPV9Dq+4qsRRnJBpqMRcVJwIAW5v8UhUEAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrALMWRmVeSWpSXmKPExsWy7bCSvK6kAWu8webLPBYP5m1js9jbdoLd
        4uXPq2wWBx92slhM+/CT2eLT+mWsFr/+rme3WL34AYvFohvbmCxubjnKYtF9fQebxfLj/5gs
        uu7eYLRY+u8tiwOfx+Ur3h6X+3qZPCYsOsDo8X19B5vHx6e3WDz6tqxi9Pi8Sc6j/UA3UwBH
        FJdNSmpOZllqkb5dAlfG/v9v2QoaOSp+HfjP2MC4lK2LkZNDQsBE4kX7KTBbSGA3o8SSG9oQ
        cUmJEzufM0LYwhL3W46wdjFyAdV8Y5S4/2MvC0iCTUBT4unNqUwgCRGBw0wS/7c+ZwdJMAuo
        S+yacIIJxBYWCJSYd3Y5K4jNIqAqseLBFrBmXgELiVMHd0FdISdx81wn8wRGngWMDKsYJVML
        inPTc4sNCwzzUsv1ihNzi0vz0vWS83M3MYIDVUtzB+P2VR/0DjEycTAeYpTgYFYS4TVQZI0X
        4k1JrKxKLcqPLyrNSS0+xCjNwaIkznujcGGckEB6YklqdmpqQWoRTJaJg1OqgclalKXtjtH7
        bD/Z3e3eyjXH3vvUZOj/MKj5/zhpdfdG7r2Jvo4xwRoZ8c8ltr9K7q/Xny6in1HttIBhs5jP
        BvepzUlfU1XDtDf9DgxiudE6p6Htm9PGvOcipct37BWxVlT/ujLFg/H7AseWK21/f+/q1/3E
        LNrO4inNWrrvyFG24AvO+5uTWQyWrOmexyy8V6OX+Z+hU5hYV+CUbx3LLOLDpF9N2cq6vslb
        PTCyfftNX/mMe6m8rVU7Nm972tH2WjlB86DNLt3N05606qSuPPX88+f2q3xzfrxwmuMtd+pp
        sazDlkny/ldEeNUmH0xUiknbWpnwVDlE5t2yg9yh2+qLnJ5KCFzU3SWeoeanxFKckWioxVxU
        nAgAjCg5lMMCAAA=
X-CMS-MailID: 20200708023153epcas2p1fc18ee2920c5defa2896af34dd62865f
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
CMS-TYPE: 102P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20200708023153epcas2p1fc18ee2920c5defa2896af34dd62865f
References: <CGME20200708023153epcas2p1fc18ee2920c5defa2896af34dd62865f@epcas2p1.samsung.com>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

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
 drivers/scsi/ufs/Makefile         |   2 +-
 drivers/scsi/ufs/ufs-exynos-dbg.c | 201 ++++++++++++++++++++++++++++++++++++++
 drivers/scsi/ufs/ufs-exynos-if.h  |  17 ++++
 drivers/scsi/ufs/ufs-exynos.c     |  61 ++++++++++++
 drivers/scsi/ufs/ufs-exynos.h     |  12 +++
 drivers/scsi/ufs/ufshcd.c         |   2 +
 drivers/scsi/ufs/ufshcd.h         |   8 ++
 8 files changed, 316 insertions(+), 1 deletion(-)
 create mode 100644 drivers/scsi/ufs/ufs-exynos-dbg.c
 create mode 100644 drivers/scsi/ufs/ufs-exynos-if.h

-- 
2.7.4

