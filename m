Return-Path: <SRS0=GT1C=7K=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DC56EC433E0
	for <linux-scsi@archiver.kernel.org>; Thu, 28 May 2020 01:33:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B712220C56
	for <linux-scsi@archiver.kernel.org>; Thu, 28 May 2020 01:33:13 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="b3aNaUEh"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726773AbgE1BdM (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 27 May 2020 21:33:12 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:50174 "EHLO
        mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726578AbgE1Bci (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 27 May 2020 21:32:38 -0400
Received: from epcas5p2.samsung.com (unknown [182.195.41.40])
        by mailout3.samsung.com (KnoxPortal) with ESMTP id 20200528013235epoutp036dbcbd63a0250a62f517965a99cd3471~TDSdJ6qRA0196701967epoutp03N
        for <linux-scsi@vger.kernel.org>; Thu, 28 May 2020 01:32:35 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com 20200528013235epoutp036dbcbd63a0250a62f517965a99cd3471~TDSdJ6qRA0196701967epoutp03N
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1590629555;
        bh=8GKVEUkWRCQ4oEzg+kXJtv/h4uSMVZoIRkh5wQhVTwY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=b3aNaUEhzmMSu2ykXpSJq73LDGbPO2GWqpzdjSkMkO06/up7GJXKkGdxH/HubcjfB
         tPvLsFH2REMtguana0dqFyEM3otJS4R8r8mL+fRwLJTk5ZTb80CvR5RcCiwbmGK0sK
         nziviO57s20Qtcqkbk2ZJjZgkLtwKYGCrEAWHnro=
Received: from epsmges5p2new.samsung.com (unknown [182.195.42.74]) by
        epcas5p2.samsung.com (KnoxPortal) with ESMTP id
        20200528013234epcas5p21cb88759af4e3f23ff005cf0e87987ea~TDScNi_aT3096230962epcas5p2I;
        Thu, 28 May 2020 01:32:34 +0000 (GMT)
Received: from epcas5p4.samsung.com ( [182.195.41.42]) by
        epsmges5p2new.samsung.com (Symantec Messaging Gateway) with SMTP id
        9B.58.09703.2B41FCE5; Thu, 28 May 2020 10:32:34 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
        epcas5p2.samsung.com (KnoxPortal) with ESMTPA id
        20200528013234epcas5p2fe5412e2775ff9b28a1b29e8e30ab69c~TDSb0sP683096230962epcas5p2H;
        Thu, 28 May 2020 01:32:34 +0000 (GMT)
Received: from epsmgms1p2.samsung.com (unknown [182.195.42.42]) by
        epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20200528013234epsmtrp1c36b17c2d81d989a82f9f7a72bcfa10e~TDSbz4oah0638506385epsmtrp1k;
        Thu, 28 May 2020 01:32:34 +0000 (GMT)
X-AuditID: b6c32a4a-4b5ff700000025e7-d6-5ecf14b2003f
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
        epsmgms1p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        7B.77.08303.2B41FCE5; Thu, 28 May 2020 10:32:34 +0900 (KST)
Received: from Jaguar.sa.corp.samsungelectronics.net (unknown
        [107.108.73.139]) by epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
        20200528013232epsmtip1a09102e03b8e80d37c4e285c8939a793~TDSZ9nwKx1673116731epsmtip1l;
        Thu, 28 May 2020 01:32:32 +0000 (GMT)
From:   Alim Akhtar <alim.akhtar@samsung.com>
To:     robh@kernel.org
Cc:     devicetree@vger.kernel.org, linux-scsi@vger.kernel.org,
        krzk@kernel.org, avri.altman@wdc.com, martin.petersen@oracle.com,
        kwmad.kim@samsung.com, stanley.chu@mediatek.com,
        cang@codeaurora.org, linux-samsung-soc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Alim Akhtar <alim.akhtar@samsung.com>
Subject: [PATCH v10 05/10] scsi: ufs: add quirk to fix abnormal ocs fatal
 error
Date:   Thu, 28 May 2020 06:46:53 +0530
Message-Id: <20200528011658.71590-6-alim.akhtar@samsung.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200528011658.71590-1-alim.akhtar@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpkleLIzCtJLcpLzFFi42LZdlhTS3eTyPk4g7svtCwezNvGZvHy51U2
        i0/rl7FazD9yjtXi/PkN7BY3txxlsdj0+BqrxeVdc9gsZpzfx2TRfX0Hm8Xy4/+YLP7v2cFu
        sXTrTUYHXo/Lfb1MHptWdbJ5bF5S79Fycj+Lx8ent1g8+rasYvT4vEnOo/1AN1MARxSXTUpq
        TmZZapG+XQJXxqYjP9gK2vkq1l++yNzAeIa7i5GTQ0LARKLxwQ2WLkYuDiGB3YwSc492MYMk
        hAQ+MUo0rZWDSHxmlPjRMJ29i5EDrGPePx6I+C5Gie7/l5ghnBYmiU//D7OBdLMJaEvcnb6F
        CcQWERCWOPKtjRHEZha4wSTxYKULiC0sECixdP0dFhCbRUBV4uHmBrDNvAI2EqvWdrFDnCcv
        sXrDAWaQxZwCthJ7JziA7JIQ6OSQ+NbWwwJR4yKx6vtRVghbWOLV8S1QvVISL/vboI7OlujZ
        ZQwRrpFYOu8YVKu9xIErc1hASpgFNCXW79KHuJJPovf3EyaITl6JjjYhiGpVieZ3V6E6pSUm
        dndDLfWQeLr3LyskFCYAg+riFvYJjLKzEKYuYGRcxSiZWlCcm55abFpglJdarlecmFtcmpeu
        l5yfu4kRnEq0vHYwPnzwQe8QIxMH4yFGCQ5mJRFep7On44R4UxIrq1KL8uOLSnNSiw8xSnOw
        KInzKv04EyckkJ5YkpqdmlqQWgSTZeLglGpgYorKXXJGHaiusKT3u5jd/OPqXheOFR8+0x24
        P37b3L/MTW/bSz/u5Tj85OP9fQuSU6SFTaN1nvn7PcvRM8mtMrz7sCfKOuF0l+/nqUmbNKc8
        EUqvyp2/6QG/9XcDRvFqx6nhfAa8fdqXS+bm9HZZz5JaddumrkyjY85njcjtej9Z/PgFP2w6
        FnzaxOMQf5y0893op8fuHxbY9c8/aIuvmbDLz5CN2SZnW24LWzscEecRPnLwdtsG/nNTuGyW
        tF/SyZgg9T30arqWCL/wJ7Gpse7vKkIu3L9yxWbLjfV9p1l71rhqazm/VZ0msvyUZefnVYbz
        VGevqnZpeXCxpEb1yE+Jt/az1Q+e8L0d8U+JpTgj0VCLuag4EQD6ahqblAMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrALMWRmVeSWpSXmKPExsWy7bCSnO4mkfNxBttv8Fk8mLeNzeLlz6ts
        Fp/WL2O1mH/kHKvF+fMb2C1ubjnKYrHp8TVWi8u75rBZzDi/j8mi+/oONovlx/8xWfzfs4Pd
        YunWm4wOvB6X+3qZPDat6mTz2Lyk3qPl5H4Wj49Pb7F49G1ZxejxeZOcR/uBbqYAjigum5TU
        nMyy1CJ9uwSujE1HfrAVtPNVrL98kbmB8Qx3FyMHh4SAicS8fzxdjFwcQgI7GCUmXvzE2sXI
        CRSXlri+cQI7hC0ssfLfczBbSKCJSWLhsjoQm01AW+Lu9C1MILYIUM2Rb22MIDazwDMmiVMP
        S0FsYQF/iY7pLWBxFgFViYebG5hBbF4BG4lVa7ug5stLrN5wgBnkHk4BW4m9ExwgVtlITFi1
        l3ECI98CRoZVjJKpBcW56bnFhgVGeanlesWJucWleel6yfm5mxjBgayltYNxz6oPeocYmTgY
        DzFKcDArifA6nT0dJ8SbklhZlVqUH19UmpNafIhRmoNFSZz366yFcUIC6YklqdmpqQWpRTBZ
        Jg5OqQYmswymRWf2/Hur7rzy4hyG/mWXu8sefjPe3/NKmPdIWd8Vp68P3ez/vApmm6dZf1yw
        WvtO5menk5KNn9qZXj4ok4prXHmtTYQh8H3h3Iwf72Ii2tOrFzxiX/M9SEXFqt8u9f2dE1JH
        peSfM/lmfCo92Jax5kFodvf90FRp0en3meSXL5p9yc95rVbKz9p/LfHlDIdPN6tvbLlmvrWB
        +Q57et6ESmlpmdV/O740heSZd8rNOX4oIv3itANnInq7Hr/I4ZxdaWD/gO9Xsf1SPZ6Xrz6L
        MffPkVTjbWD6liFxP9Vsgg//jdVBKq/9TI8bC1p97tmVeOltREfSIfmD51tWesoqzk8901jz
        6PDhR2xKLMUZiYZazEXFiQDNqBCL0wIAAA==
X-CMS-MailID: 20200528013234epcas5p2fe5412e2775ff9b28a1b29e8e30ab69c
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
CMS-TYPE: 105P
X-CMS-RootMailID: 20200528013234epcas5p2fe5412e2775ff9b28a1b29e8e30ab69c
References: <20200528011658.71590-1-alim.akhtar@samsung.com>
        <CGME20200528013234epcas5p2fe5412e2775ff9b28a1b29e8e30ab69c@epcas5p2.samsung.com>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Kiwoong Kim <kwmad.kim@samsung.com>

Some controller like Exynos determines if FATAL ERROR (0x7)
in OCS field in UTRD occurs for values other than GOOD (0x0)
in STATUS field in response upiu as well as errors that a
host controller can't cover.
This patch is to prevent from reporting command results in
those cases.

Signed-off-by: Kiwoong Kim <kwmad.kim@samsung.com>
Signed-off-by: Alim Akhtar <alim.akhtar@samsung.com>
Reviewed-by: Avri Altman <avri.altman@wdc.com>
---
 drivers/scsi/ufs/ufshcd.c | 6 ++++++
 drivers/scsi/ufs/ufshcd.h | 6 ++++++
 2 files changed, 12 insertions(+)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index ba093d0d0942..33ebffa8257d 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -4794,6 +4794,12 @@ ufshcd_transfer_rsp_status(struct ufs_hba *hba, struct ufshcd_lrb *lrbp)
 	/* overall command status of utrd */
 	ocs = ufshcd_get_tr_ocs(lrbp);
 
+	if (hba->quirks & UFSHCD_QUIRK_BROKEN_OCS_FATAL_ERROR) {
+		if (be32_to_cpu(lrbp->ucd_rsp_ptr->header.dword_1) &
+					MASK_RSP_UPIU_RESULT)
+			ocs = OCS_SUCCESS;
+	}
+
 	switch (ocs) {
 	case OCS_SUCCESS:
 		result = ufshcd_get_req_rsp(lrbp->ucd_rsp_ptr);
diff --git a/drivers/scsi/ufs/ufshcd.h b/drivers/scsi/ufs/ufshcd.h
index a9b9ace9fc72..e1d09c2c4302 100644
--- a/drivers/scsi/ufs/ufshcd.h
+++ b/drivers/scsi/ufs/ufshcd.h
@@ -541,6 +541,12 @@ enum ufshcd_quirks {
 	 * resolution of the values of PRDTO and PRDTL in UTRD as byte.
 	 */
 	UFSHCD_QUIRK_PRDT_BYTE_GRAN			= 1 << 9,
+
+	/*
+	 * This quirk needs to be enabled if the host controller reports
+	 * OCS FATAL ERROR with device error through sense data
+	 */
+	UFSHCD_QUIRK_BROKEN_OCS_FATAL_ERROR		= 1 << 10,
 };
 
 enum ufshcd_caps {
-- 
2.17.1

