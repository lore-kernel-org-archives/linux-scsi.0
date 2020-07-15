Return-Path: <SRS0=K8op=A2=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7EC2CC433E2
	for <linux-scsi@archiver.kernel.org>; Wed, 15 Jul 2020 07:48:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 550E12064C
	for <linux-scsi@archiver.kernel.org>; Wed, 15 Jul 2020 07:48:05 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="A1+DEpWF"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729427AbgGOHsF (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 15 Jul 2020 03:48:05 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:30853 "EHLO
        mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729036AbgGOHsE (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 15 Jul 2020 03:48:04 -0400
Received: from epcas2p2.samsung.com (unknown [182.195.41.54])
        by mailout4.samsung.com (KnoxPortal) with ESMTP id 20200715074801epoutp04df1cbc420d0b280a9f3d670518a6c74f~h3X8dIHaB1256012560epoutp04R
        for <linux-scsi@vger.kernel.org>; Wed, 15 Jul 2020 07:48:01 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20200715074801epoutp04df1cbc420d0b280a9f3d670518a6c74f~h3X8dIHaB1256012560epoutp04R
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1594799281;
        bh=d9j6ewS3eviWkU6b3q9DxQvJgvOD9n1O9xJ2RYwvxIE=;
        h=From:To:Cc:Subject:Date:References:From;
        b=A1+DEpWFyuJAmqL/d4TeV4n4I/qaO/tZObx4vH+tQiaiQ4ec0eKmBDy/n/cQK5AMW
         qCGho2vUiLIotvz9OP5qnNG842aoQb7AVUGkDTP1nMPffANPLTKDdarIof6jBi+Fu5
         bZBl/pZ7B9E0ADdfebtMAFqDGNGCniTgoIfjqdH0=
Received: from epsnrtp3.localdomain (unknown [182.195.42.164]) by
        epcas2p1.samsung.com (KnoxPortal) with ESMTP id
        20200715074800epcas2p10c63043490bcd54883c131f95169f56d~h3X7xVGf82829028290epcas2p1q;
        Wed, 15 Jul 2020 07:48:00 +0000 (GMT)
Received: from epsmges2p2.samsung.com (unknown [182.195.40.182]) by
        epsnrtp3.localdomain (Postfix) with ESMTP id 4B68cs5MFnzMqYks; Wed, 15 Jul
        2020 07:47:57 +0000 (GMT)
Received: from epcas2p3.samsung.com ( [182.195.41.55]) by
        epsmges2p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        DD.55.18874.DA4BE0F5; Wed, 15 Jul 2020 16:47:57 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
        epcas2p3.samsung.com (KnoxPortal) with ESMTPA id
        20200715074757epcas2p344b4e188af3221655c1697405b9e17f4~h3X4ykLnQ2933129331epcas2p3M;
        Wed, 15 Jul 2020 07:47:57 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
        epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20200715074757epsmtrp14ebe53f14f85ab66e55a26f4f4633ec6~h3X4xwh3T1918819188epsmtrp1i;
        Wed, 15 Jul 2020 07:47:57 +0000 (GMT)
X-AuditID: b6c32a46-519ff700000049ba-3a-5f0eb4ad78c7
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
        epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        C1.00.08382.CA4BE0F5; Wed, 15 Jul 2020 16:47:57 +0900 (KST)
Received: from ubuntu.dsn.sec.samsung.com (unknown [12.36.155.120]) by
        epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
        20200715074756epsmtip296ce2e589bfffc6dd18d0e53706bc67c~h3X4jUAJj2957629576epsmtip29;
        Wed, 15 Jul 2020 07:47:56 +0000 (GMT)
From:   Kiwoong Kim <kwmad.kim@samsung.com>
To:     linux-scsi@vger.kernel.org, alim.akhtar@samsung.com,
        avri.altman@wdc.com, jejb@linux.ibm.com,
        martin.petersen@oracle.com, beanhuo@micron.com,
        asutoshd@codeaurora.org, cang@codeaurora.org, bvanassche@acm.org,
        grant.jung@samsung.com, sc.suh@samsung.com, hy50.seo@samsung.com,
        sh425.lee@samsung.com
Cc:     Kiwoong Kim <kwmad.kim@samsung.com>
Subject: [PATCH v6 0/3] ufs: exynos: introduce the way to get cmd info
Date:   Wed, 15 Jul 2020 16:39:54 +0900
Message-Id: <cover.1594798514.git.kwmad.kim@samsung.com>
X-Mailer: git-send-email 2.7.4
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpmk+LIzCtJLcpLzFFi42LZdljTXHftFr54g3fdGhYP5m1js9jbdoLd
        4uXPq2wWBx92slhM+/CT2eLT+mWsFr/+rme3WL34AYvFohvbmCxubjnKYtF9fQebxfLj/5gs
        uu7eYLRY+u8tiwOfx+Ur3h6X+3qZPCYsOsDo8X19B5vHx6e3WDz6tqxi9Pi8Sc6j/UA3UwBH
        VI5NRmpiSmqRQmpecn5KZl66rZJ3cLxzvKmZgaGuoaWFuZJCXmJuqq2Si0+ArltmDtDdSgpl
        iTmlQKGAxOJiJX07m6L80pJUhYz84hJbpdSClJwCQ8MCveLE3OLSvHS95PxcK0MDAyNToMqE
        nIz/L/cwFazgqrhwcT97A+N0ji5GTg4JAROJyScPMXcxcnEICexglPj2+hSU84lR4tjsyVDO
        N0aJ09c2sMO0XPt2ihEisZdRouNXF1TVD0aJL/e2sYBUsQloSjy9OZUJJCEisJlJ4tWC+8wg
        CWYBdYldE04wgdjCAm4ST5Z3sYLYLAKqEseWnAKzeQUsJP63LmKBWCcncfNcJ9gGCYGf7BK9
        5/+zQiRcJB6uu8wMYQtLvDq+Beo+KYmX/W1Qdr3EvqkNrBDNPYwST/f9Y4RIGEvMetYOZHMA
        XaQpsX6XPogpIaAsceQWC8SdfBIdh/+yQ4R5JTrahCAalSV+TZoMNURSYubNO1CbPCRedR0D
        e0tIIFbi5pmlrBMYZWchzF/AyLiKUSy1oDg3PbXYqMAIOZo2MYJTo5bbDsYpbz/oHWJk4mA8
        xCjBwawkwsvDxRsvxJuSWFmVWpQfX1Sak1p8iNEUGF4TmaVEk/OByTmvJN7Q1MjMzMDS1MLU
        zMhCSZy3XvFCnJBAemJJanZqakFqEUwfEwenVANT8/QEhjesG5pefstLi62ZsW3Ps8gTvGtc
        DpYEzMx+EqGi0XX6/1fV6DXsL3gvaR3v+L0uYsrxR2UbQlwuNCy/aeD7duNf5u2fC+zamcsS
        +Rq8A+79k1ix0fWeasd04afcGvXRu63O31G/73MqifVo/pkjnLL8vKf4ov8+XiO935pFfNqK
        vRPecqn3sWWs1p8eYDL3xS8rqeQnPoUntnEd6pz37ZG0ZYv24fvTLnKvVNNdL652QGTy0Yfs
        75k3yN86tzLqdGGrUi9r+lmu02df7+31UX0RdnZrm7ez5W+liVK3bfccWip1kKVg5ZlHTyTu
        eK4w+lln1hu67LXt70WdrRXef14aTTm15au/aNPKPCWW4oxEQy3mouJEAN51b60WBAAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrILMWRmVeSWpSXmKPExsWy7bCSvO7aLXzxBm9nM1o8mLeNzWJv2wl2
        i5c/r7JZHHzYyWIx7cNPZotP65exWvz6u57dYvXiBywWi25sY7K4ueUoi0X39R1sFsuP/2Oy
        6Lp7g9Fi6b+3LA58HpeveHtc7utl8piw6ACjx/f1HWweH5/eYvHo27KK0ePzJjmP9gPdTAEc
        UVw2Kak5mWWpRfp2CVwZ/1/uYSpYwVVx4eJ+9gbG6RxdjJwcEgImEte+nWLsYuTiEBLYzSix
        8eRsZoiEpMSJnc8ZIWxhifstR1ghir4xSjTdv8gOkmAT0JR4enMqE0hCROAwk8T/rc/BEswC
        6hK7JpxgArGFBdwknizvYgWxWQRUJY4tOQVm8wpYSPxvXcQCsUFO4ua5TuYJjDwLGBlWMUqm
        FhTnpucWGxYY5qWW6xUn5haX5qXrJefnbmIEh6qW5g7G7as+6B1iZOJgPMQowcGsJMLLw8Ub
        L8SbklhZlVqUH19UmpNafIhRmoNFSZz3RuHCOCGB9MSS1OzU1ILUIpgsEwenVAPTpn/PFFfa
        TOC/uMhtlSlv36bNHluXJ0vfP39vYcjL7WXbE7JllB6cK937yKyztndlxt2q4BP2lZ2bnvLd
        urv+iT8rb9z9BMOHwpXXlQ0mrd6o3rPM/GdemKwC9zdn9XZ2mdW7F+yaNtFBRagx45r+sSPT
        bj0Nlzt/mjOA78mVWWH+9S+jBThzTaY4aOkf6l/4bcPVQMlbPAk7L66Ja5QuteyIOWHnvv4o
        85pitTNsLDw5v1QexLp/Y+JeMefVgbu7/kV9+inqoShV73Tj7DHJANUTovnWjkp8abfvHJ3r
        kqyU9z/McnrmyQebSly5PQ2mnZ5/9ivHYoU57cnqEcHmN21vtdyPOjWF3fuKrpaWEktxRqKh
        FnNRcSIABNRJ8sQCAAA=
X-CMS-MailID: 20200715074757epcas2p344b4e188af3221655c1697405b9e17f4
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
CMS-TYPE: 102P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20200715074757epcas2p344b4e188af3221655c1697405b9e17f4
References: <CGME20200715074757epcas2p344b4e188af3221655c1697405b9e17f4@epcas2p3.samsung.com>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

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

Kiwoong Kim (3):
  ufs: introduce a callback to get info of command completion
  ufs: exynos: introduce command history
  ufs: exynos: implement dbg_register_dump

 drivers/scsi/ufs/Kconfig          |  14 +++
 drivers/scsi/ufs/Makefile         |   1 +
 drivers/scsi/ufs/ufs-exynos-dbg.c | 198 ++++++++++++++++++++++++++++++++++++++
 drivers/scsi/ufs/ufs-exynos-if.h  |  17 ++++
 drivers/scsi/ufs/ufs-exynos.c     |  38 ++++++++
 drivers/scsi/ufs/ufs-exynos.h     |  35 +++++++
 drivers/scsi/ufs/ufshcd.c         |   1 +
 drivers/scsi/ufs/ufshcd.h         |   8 ++
 8 files changed, 312 insertions(+)
 create mode 100644 drivers/scsi/ufs/ufs-exynos-dbg.c
 create mode 100644 drivers/scsi/ufs/ufs-exynos-if.h

-- 
2.7.4

