Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-19.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 400A4C4708A
	for <linux-scsi@archiver.kernel.org>; Thu, 27 May 2021 03:12:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1D99661358
	for <linux-scsi@archiver.kernel.org>; Thu, 27 May 2021 03:12:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234536AbhE0DOA (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 26 May 2021 23:14:00 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:17665 "EHLO
        mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234485AbhE0DN5 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 26 May 2021 23:13:57 -0400
Received: from epcas2p2.samsung.com (unknown [182.195.41.54])
        by mailout1.samsung.com (KnoxPortal) with ESMTP id 20210527031223epoutp0101852f8b97a36358506a82b5139ed0bd~Czdgef9Pb2072420724epoutp01_
        for <linux-scsi@vger.kernel.org>; Thu, 27 May 2021 03:12:23 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20210527031223epoutp0101852f8b97a36358506a82b5139ed0bd~Czdgef9Pb2072420724epoutp01_
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1622085143;
        bh=HipBXrBWXXNk1vESrMRc60iRUFRUwI0ebAavf6wYhVA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FX7XczwXdSFJUYMMBEGD9vQ+GCM6FdmETJ6xYX2WNNZ+n5K8+G5pryYIna4Ben+Wy
         XsxKQEe7qgW2LHuM7rAjy7TI+14vTzgtmAEKMztRFtdDXSMMuV1zeIy2erHrAtCSZ1
         TEk3kalpl+OYN9dzLpahI0AXpTiVIxLpN11Pi6jw=
Received: from epsnrtp3.localdomain (unknown [182.195.42.164]) by
        epcas2p1.samsung.com (KnoxPortal) with ESMTP id
        20210527031223epcas2p1fcfca4c922e820de32baa83fbdea5c89~Czdf1N6Li2841328413epcas2p1G;
        Thu, 27 May 2021 03:12:23 +0000 (GMT)
Received: from epsmges2p3.samsung.com (unknown [182.195.40.190]) by
        epsnrtp3.localdomain (Postfix) with ESMTP id 4FrCY03ZFnz4x9Pw; Thu, 27 May
        2021 03:12:20 +0000 (GMT)
Received: from epcas2p4.samsung.com ( [182.195.41.56]) by
        epsmges2p3.samsung.com (Symantec Messaging Gateway) with SMTP id
        E4.F0.09433.41E0FA06; Thu, 27 May 2021 12:12:20 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
        epcas2p3.samsung.com (KnoxPortal) with ESMTPA id
        20210527031219epcas2p313fcf248833cf14ec9a164dd91a1ca13~Czdchu-nU0938609386epcas2p3X;
        Thu, 27 May 2021 03:12:19 +0000 (GMT)
Received: from epsmgms1p2.samsung.com (unknown [182.195.42.42]) by
        epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20210527031219epsmtrp2536b6af45a8c4379d8cd1ef570074aef~Czdcg9nOk1054710547epsmtrp2d;
        Thu, 27 May 2021 03:12:19 +0000 (GMT)
X-AuditID: b6c32a47-f4bff700000024d9-29-60af0e1407c9
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
        epsmgms1p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        81.B2.08163.31E0FA06; Thu, 27 May 2021 12:12:19 +0900 (KST)
Received: from localhost.localdomain (unknown [10.229.9.60]) by
        epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
        20210527031219epsmtip24cdbf5606d17192f68dd2bae32456780~CzdcTpQCa2674926749epsmtip2J;
        Thu, 27 May 2021 03:12:19 +0000 (GMT)
From:   jongmin jeong <jjmin.jeong@samsung.com>
To:     jejb@linux.ibm.com, martin.petersen@oracle.com
Cc:     alim.akhtar@samsung.com, avri.altman@wdc.com, cang@codeaurora.org,
        beanhuo@micron.com, adrian.hunter@intel.com,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        jjmin.jeong@samsung.com
Subject: [PATCH 1/3] scsi: ufs: add quirk to handle broken UIC command
Date:   Thu, 27 May 2021 12:08:59 +0900
Message-Id: <20210527030901.88403-2-jjmin.jeong@samsung.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210527030901.88403-1-jjmin.jeong@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrKJsWRmVeSWpSXmKPExsWy7bCmha4I3/oEgzkPJS1OPlnDZvFg3jY2
        i5c/r7JZHHzYyWLxaf0yVotFN7YxWay8ZmFxedccNovu6zvYLJYf/8fkwOVxua+XyWPxnpdM
        HhMWHWD0+L6+g83j49NbLB59W1YxenzeJOfRfqCbKYAjKscmIzUxJbVIITUvOT8lMy/dVsk7
        ON453tTMwFDX0NLCXEkhLzE31VbJxSdA1y0zB+hGJYWyxJxSoFBAYnGxkr6dTVF+aUmqQkZ+
        cYmtUmpBSk6BoWGBXnFibnFpXrpecn6ulaGBgZEpUGVCTkZLs15BP2/Fvw8PmBoY33J1MXJy
        SAiYSExb2MPexcjFISSwg1FiXc9nFpCEkMAnRol/22MhEp8ZJba+PQdUxQHWMfe5GER8F6NE
        44s5jBANHxklTs7QBbHZBHQlzmx+yQxSLyJgJHFtlSdIPbPASUaJ3rMvmEFqhAXcJCbtmsUK
        YrMIqEqsmX0bbDGvgI3E82sfWCCuk5c4feIaI8gcTgFbiTVXMiFKBCVOznwCVsIMVNK8dTYz
        RPlEDomrl60hbBeJ85uWQY0Rlnh1fAs7hC0l8fndXjYIu15id8MeZpDbJAQmMEp0d16FarCX
        +DV9CyvIXmYBTYn1u/QhXleWOHILai2fRMfhv9AQ4ZXoaBOCaFSV2LJ4IyOELS2xdO1xqIEe
        Ej3HNzFCQg1o0/aejewTGBVmIflmFpJvZiEsXsDIvIpRLLWgODc9tdiowBg5cjcxgtOrlvsO
        xhlvP+gdYmTiYDzEKMHBrCTCe7B5bYIQb0piZVVqUX58UWlOavEhRlNgUE9klhJNzgcm+LyS
        eENTIzMzA0tTC1MzIwslcd6fqXUJQgLpiSWp2ampBalFMH1MHJxSDUwpiz7PXNYdufbn3bP5
        0QbtVrZf9lzwfHKd/SfHPe2pGT926a6YJLb64UPlf3XbGmJX71r98Z2a8YIZLndiWG990554
        eEnf5ejL7NnNNz1cHvqb8VQXFoute1nh2FPPGffTRDzleeA/lqSThua/JnYclGGoXLRe/1LP
        /rzEIC+Nj+5Xf06pum2Yly5dZ2HP//sL249ev4w3G7nmNnfdKdISdtEM2cTIyGvYxXg6ZloS
        p/f/fJHWRzUrf5RIJKlu3rNk2bJftkU2sVPa70m+urlL2Xcle/cKN97T9mecmx1z1ac8/ea8
        8uXHsPz3KdJu6S+dzki0K7vVbl24uXuyR/a8tr7EM9Osu40E0maJViuxFGckGmoxFxUnAgAr
        kuoMOAQAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrPLMWRmVeSWpSXmKPExsWy7bCSvK4w3/oEg/+TFS1OPlnDZvFg3jY2
        i5c/r7JZHHzYyWLxaf0yVotFN7YxWay8ZmFxedccNovu6zvYLJYf/8fkwOVxua+XyWPxnpdM
        HhMWHWD0+L6+g83j49NbLB59W1YxenzeJOfRfqCbKYAjissmJTUnsyy1SN8ugSujpVmvoJ+3
        4t+HB0wNjG+5uhg5OCQETCTmPhfrYuTiEBLYwSgxYeYZZoi4tMSaPdJdjJxAprDE/ZYjrBA1
        7xklVp99xAqSYBPQlTiz+SUziC0CNGfGrXdgcWaBy4wS089Fg9jCAm4Sk3bNAouzCKhKrJl9
        mwXE5hWwkXh+7QMLxAJ5idMnrjGC7OUUsJVYcyUTxBQCKnmxLAWiWlDi5MwnLBDT5SWat85m
        nsAoMAtJahaS1AJGplWMkqkFxbnpucWGBUZ5qeV6xYm5xaV56XrJ+bmbGMFxoKW1g3HPqg96
        hxiZOBgPMUpwMCuJ8B5sXpsgxJuSWFmVWpQfX1Sak1p8iFGag0VJnPdC18l4IYH0xJLU7NTU
        gtQimCwTB6dUA5PZyazY1oV+wveOlptYVh2Rz7gkGq7tlrkl5ujvbq6NMXuLJpz5Grbmhlxq
        m5xSqaXASUbGc/UuLVcv502/snjv9MfFqiV3s18etzJcM227julEz4mHPF+vF+XXdZnd/nLG
        as0N8z/6958+nvvkbzrbfY8TF/N+lGZVvLx5UMecMcNkivPede6H3X12rT5nHM2zIaZJ5uG2
        HekHV8vzr2j+YOuVvSD3kl77w6287fuOLtB8/3fmXv2SXctXiyi9uTevb99eFm+pe0w3re+r
        rjKLfuqxmCHmFJ+NenauxdTKcsuDy89yV56e5c9qqv93eTvj8+gOEa9bXcz9n54t09/nkxQc
        EBXyetMlm0O/mwKUWIozEg21mIuKEwHJGsIq8gIAAA==
X-CMS-MailID: 20210527031219epcas2p313fcf248833cf14ec9a164dd91a1ca13
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
CMS-TYPE: 102P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20210527031219epcas2p313fcf248833cf14ec9a164dd91a1ca13
References: <20210527030901.88403-1-jjmin.jeong@samsung.com>
        <CGME20210527031219epcas2p313fcf248833cf14ec9a164dd91a1ca13@epcas2p3.samsung.com>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

samsung ExynosAuto SoC has two types of host controller interface to
support the virtualization of UFS Device.
One is the physical host(PH) that the same as conventaional UFSHCI,
and the other is the virtual host(VH) that support data transfer function only.

In this structure, the virtual host does not support UIC command.
To support this, we add the quirk and return 0 when the UIC command
send function is called.

Change-Id: Ie528726b29bcb643149440bf1c90eaa5995c5ac1
Signed-off-by: jongmin jeong <jjmin.jeong@samsung.com>
---
 drivers/scsi/ufs/ufshcd.c | 3 +++
 drivers/scsi/ufs/ufshcd.h | 6 ++++++
 2 files changed, 9 insertions(+)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 4ba3bbf14df0..ec663cb58233 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -2318,6 +2318,9 @@ int ufshcd_send_uic_cmd(struct ufs_hba *hba, struct uic_command *uic_cmd)
 	int ret;
 	unsigned long flags;
 
+	if (hba->quirks & UFSHCD_QUIRK_BROKEN_UIC_CMD)
+		return 0;
+
 	ufshcd_hold(hba, false);
 	mutex_lock(&hba->uic_cmd_mutex);
 	ufshcd_add_delay_before_dme_cmd(hba);
diff --git a/drivers/scsi/ufs/ufshcd.h b/drivers/scsi/ufs/ufshcd.h
index 0f0e62bfdafd..4a929bf7cf8e 100644
--- a/drivers/scsi/ufs/ufshcd.h
+++ b/drivers/scsi/ufs/ufshcd.h
@@ -569,6 +569,12 @@ enum ufshcd_quirks {
 	 * This quirk allows only sg entries aligned with page size.
 	 */
 	UFSHCD_QUIRK_ALIGN_SG_WITH_PAGE_SIZE		= 1 << 14,
+
+	/*
+	 * This quirk needs to be enabled if the host controller does not
+	 * support UIC command
+	 */
+	UFSHCD_QUIRK_BROKEN_UIC_CMD			= 1 << 15,
 };
 
 enum ufshcd_caps {
-- 
2.31.1

