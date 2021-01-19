Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6A786C433E0
	for <linux-scsi@archiver.kernel.org>; Tue, 19 Jan 2021 02:41:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3EF2822E00
	for <linux-scsi@archiver.kernel.org>; Tue, 19 Jan 2021 02:41:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2394491AbhASCl2 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 18 Jan 2021 21:41:28 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:12156 "EHLO
        mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2394318AbhASClR (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 18 Jan 2021 21:41:17 -0500
Received: from epcas2p4.samsung.com (unknown [182.195.41.56])
        by mailout1.samsung.com (KnoxPortal) with ESMTP id 20210119024015epoutp01e02039ab6ac82e9f433cbcd22a067168~bgc50t3vl1862818628epoutp01B
        for <linux-scsi@vger.kernel.org>; Tue, 19 Jan 2021 02:40:15 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20210119024015epoutp01e02039ab6ac82e9f433cbcd22a067168~bgc50t3vl1862818628epoutp01B
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1611024015;
        bh=PYId0D+AaqtP9cPa7UlXQ4T1x4pdoD75JkM7IuTDsJk=;
        h=From:To:Cc:Subject:Date:References:From;
        b=avhQQ/EucTbor/4JXtM6oSTZWki1L2WRCpsiC1q1YIIFf9O3fChMq6QiSOo5r40hD
         p+0uPctgHgNkbfTAyKJkZ53ZZIHa54R/DUsMKAZDqvd7lz72FeozBp8+YDSGOaEaaF
         9F745EQuMtqaYwRjVnmdVyNZeT6ZSohbf/Uxq1dM=
Received: from epsnrtp1.localdomain (unknown [182.195.42.162]) by
        epcas2p4.samsung.com (KnoxPortal) with ESMTP id
        20210119024014epcas2p4cc51b08d61d6f7f72758089344c8b955~bgc5I8hrb1487614876epcas2p40;
        Tue, 19 Jan 2021 02:40:14 +0000 (GMT)
Received: from epsmges2p1.samsung.com (unknown [182.195.40.189]) by
        epsnrtp1.localdomain (Postfix) with ESMTP id 4DKXtz5yq0z4x9Q1; Tue, 19 Jan
        2021 02:40:11 +0000 (GMT)
Received: from epcas2p3.samsung.com ( [182.195.41.55]) by
        epsmges2p1.samsung.com (Symantec Messaging Gateway) with SMTP id
        BE.3E.10621.B8646006; Tue, 19 Jan 2021 11:40:11 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
        epcas2p4.samsung.com (KnoxPortal) with ESMTPA id
        20210119024011epcas2p45256028f99195958140a6846d40b9143~bgc18Yanu1589715897epcas2p4o;
        Tue, 19 Jan 2021 02:40:11 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
        epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20210119024011epsmtrp1da92eb05400ee538701de33f185e78d9~bgc17UMHo1474014740epsmtrp1Y;
        Tue, 19 Jan 2021 02:40:11 +0000 (GMT)
X-AuditID: b6c32a45-337ff7000001297d-1e-6006468b54ef
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
        epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        F6.D6.13470.B8646006; Tue, 19 Jan 2021 11:40:11 +0900 (KST)
Received: from ubuntu.dsn.sec.samsung.com (unknown [12.36.155.120]) by
        epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
        20210119024010epsmtip23c9b9b78362d908ad53c7f0e9576f350~bgc1rh05a0144501445epsmtip2t;
        Tue, 19 Jan 2021 02:40:10 +0000 (GMT)
From:   Kiwoong Kim <kwmad.kim@samsung.com>
To:     linux-scsi@vger.kernel.org, alim.akhtar@samsung.com,
        avri.altman@wdc.com, jejb@linux.ibm.com,
        martin.petersen@oracle.com, beanhuo@micron.com,
        asutoshd@codeaurora.org, cang@codeaurora.org, bvanassche@acm.org,
        grant.jung@samsung.com, sc.suh@samsung.com, hy50.seo@samsung.com,
        sh425.lee@samsung.com, bhoon95.kim@samsung.com
Cc:     Kiwoong Kim <kwmad.kim@samsung.com>
Subject: [ PATCH v6 0/2] introduce a quirk to allow only page-aligned sg
 entries
Date:   Tue, 19 Jan 2021 11:28:47 +0900
Message-Id: <cover.1611023224.git.kwmad.kim@samsung.com>
X-Mailer: git-send-email 2.7.4
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmplk+LIzCtJLcpLzFFi42LZdljTXLfbjS3BYEervsWDedvYLPa2nWC3
        ePnzKpvFwYedLBZflz5jtZj24Sezxaf1y1gtfv1dz26xevEDFotFN7YxWdzccpTFovv6DjaL
        5cf/MVl03b3BaLH031sWB36Py1e8PS739TJ5TFh0gNHj+/oONo+PT2+xePRtWcXo8XmTnEf7
        gW6mAI6oHJuM1MSU1CKF1Lzk/JTMvHRbJe/geOd4UzMDQ11DSwtzJYW8xNxUWyUXnwBdt8wc
        oOOVFMoSc0qBQgGJxcVK+nY2RfmlJakKGfnFJbZKqQUpOQWGhgV6xYm5xaV56XrJ+blWhgYG
        RqZAlQk5GQ9XT2Ys+MVc0TqvmbmBsZu5i5GTQ0LAROLn45XsXYxcHEICOxglOi7sYwNJCAl8
        YpRo2WYOkfjGKNH4rR+u4+SypYwQib2MEm3TV7BAOD8YJTp/HGEFqWIT0JR4enMqE0hCROAM
        k8S11rNgCWYBdYldE04AJTg4hAWCJJZdrQUJswioSny7dpUdxOYVsJA492A5C8Q2OYmb5zqZ
        QeZICPxll9h4bAtUwkVi6vp3rBC2sMSr41vYIWwpiZf9bVB2vcS+qQ2sEM09jBJP9/1jhEgY
        S8x61s4IcgQz0KXrd+mDmBICyhJHbrFAnMkn0XH4LztEmFeio00IolFZ4tekyVBDJCVm3rwD
        tclDYn3rGbCvhARiJR5t8pzAKDsLYfwCRsZVjGKpBcW56anFRgWGyHG0iRGcHrVcdzBOfvtB
        7xAjEwfjIUYJDmYlEd7SdUwJQrwpiZVVqUX58UWlOanFhxhNgcE1kVlKNDkfmKDzSuINTY3M
        zAwsTS1MzYwslMR5iw0exAsJpCeWpGanphakFsH0MXFwSjUwVYfO2frlVX/4IlYnlaMaEWJB
        xveeuLTcvsbGYMn87dit2Rl7C6V6C7T3Cyn6cf7Kae7cfINjRzu7c+4E/lSNQ3WsyqHs9++1
        yp6/vIq/bKuT9LJX4QInaqfXFERqf47Is135k/f0y3LDy1etSr3fet80Obqs/KFtr+3psFgh
        r9sXt+afi7mkJcrj9rGldbK+ybOk3wX9nW732+7x+/lc8fBbE67JPod9ScmSAw1rJRs0RW4r
        slTO3bGHU0pococaQ4SXumRp+Lxs/pcmYusWXj5jzcJWs7b6Hl92r1IE85S2zM3HOiXaI041
        mHEYrpK/NuG+a93FtN1c2dbssu1MYbcZHvpezUmJ/PC3UYmlOCPRUIu5qDgRAFEI9VkYBAAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrGLMWRmVeSWpSXmKPExsWy7bCSvG63G1uCQddzTosH87axWextO8Fu
        8fLnVTaLgw87WSy+Ln3GajHtw09mi0/rl7Fa/Pq7nt1i9eIHLBaLbmxjsri55SiLRff1HWwW
        y4//Y7LounuD0WLpv7csDvwel694e1zu62XymLDoAKPH9/UdbB4fn95i8ejbsorR4/MmOY/2
        A91MARxRXDYpqTmZZalF+nYJXBkPV09mLPjFXNE6r5m5gbGbuYuRk0NCwETi5LKljF2MXBxC
        ArsZJW49P84GkZCUOLHzOSOELSxxv+UIK0TRN0aJrW8fghWxCWhKPL05lQkkISJwj0ni0oS5
        YGOZBdQldk04wQRiCwsESHRu2wZmswioSny7dpUdxOYVsJA492A5C8QGOYmb5zqZJzDyLGBk
        WMUomVpQnJueW2xYYJiXWq5XnJhbXJqXrpecn7uJERy0Wpo7GLev+qB3iJGJg/EQowQHs5II
        b+k6pgQh3pTEyqrUovz4otKc1OJDjNIcLErivBe6TsYLCaQnlqRmp6YWpBbBZJk4OKUamBIW
        e9QuuhwvN0+di2+lhZOpb1eSwXb1R4Xe35+KrlRSbd6Qd3ulHFdM7t0ZhasvpHvNXpCyzGfv
        mcQ01w/XJYRncCkEP9Zo2vH9Rmm/2KUdjSf+HEzcUNIRnu6lxfXgpMSSg/ck3aO8z0yOr/f4
        stHUvoRrjV2z793bKw6K/vNvOnVv76VXhXu/vda85P9F9v7n8tQ9mh+lJnzU9JORKHZjWvQt
        Kc30n9qTBOO0lpe7Ml7riGef6xM48z7v2+2brD0Tnzu4N2YtiRVbs7RjitJfmbpracxcm65+
        OsZ2Xpkhrqrl0gQJ/kzbtfFrPd8ItspNUe1cuq5C4d0qnst8ctcymFk37xE/Uf339lPdr0os
        xRmJhlrMRcWJACxiPVnJAgAA
X-CMS-MailID: 20210119024011epcas2p45256028f99195958140a6846d40b9143
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
CMS-TYPE: 102P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20210119024011epcas2p45256028f99195958140a6846d40b9143
References: <CGME20210119024011epcas2p45256028f99195958140a6846d40b9143@epcas2p4.samsung.com>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

v5 -> v6: collect received tags
v4 -> v5: collect received tags
v3 -> v4: fix some typos
v2 -> v3: rename exynos functions
v1 -> v2: rename the vops and fix some typos

Kiwoong Kim (2):
  ufs: introduce a quirk to allow only page-aligned sg entries
  ufs: ufs-exynos: use UFSHCD_QUIRK_ALIGN_SG_WITH_PAGE_SIZE

 drivers/scsi/ufs/ufs-exynos.c | 3 ++-
 drivers/scsi/ufs/ufshcd.c     | 2 ++
 drivers/scsi/ufs/ufshcd.h     | 4 ++++
 3 files changed, 8 insertions(+), 1 deletion(-)

-- 
2.7.4

