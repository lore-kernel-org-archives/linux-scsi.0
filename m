Return-Path: <SRS0=2tzU=64=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.0 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 24A6BC433E0
	for <linux-scsi@archiver.kernel.org>; Thu, 14 May 2020 00:53:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3DEBC207C3
	for <linux-scsi@archiver.kernel.org>; Thu, 14 May 2020 00:53:09 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="ASA7O6Ds"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728685AbgENAxI (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 13 May 2020 20:53:08 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:46153 "EHLO
        mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729686AbgENAxH (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 13 May 2020 20:53:07 -0400
Received: from epcas5p4.samsung.com (unknown [182.195.41.42])
        by mailout4.samsung.com (KnoxPortal) with ESMTP id 20200514005303epoutp04153b0adf946a0ec3b84c8b98ea8eafb6~Ovt8V3_mW0825508255epoutp04y
        for <linux-scsi@vger.kernel.org>; Thu, 14 May 2020 00:53:03 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20200514005303epoutp04153b0adf946a0ec3b84c8b98ea8eafb6~Ovt8V3_mW0825508255epoutp04y
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1589417583;
        bh=8GKVEUkWRCQ4oEzg+kXJtv/h4uSMVZoIRkh5wQhVTwY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ASA7O6Dsy9m8BwwFJIq/MjQP2TGbOQELDzR8XqfaMKjs1mJrLrLXcnntgBz26A2aS
         riLJOUNW9zTLoRS0ZkfYPt4dekmftJQw68oo4znjDh1rhPByjXIGK13P6bGdbI36Dj
         VxDkei8wbZdtwa8e9Usu/RjyKxyh1c/K06qmw//0=
Received: from epsmges5p2new.samsung.com (unknown [182.195.42.74]) by
        epcas5p2.samsung.com (KnoxPortal) with ESMTP id
        20200514005303epcas5p20b4908df1bb8a0382aafb393ad782b84~Ovt73PI4f1336113361epcas5p28;
        Thu, 14 May 2020 00:53:03 +0000 (GMT)
Received: from epcas5p2.samsung.com ( [182.195.41.40]) by
        epsmges5p2new.samsung.com (Symantec Messaging Gateway) with SMTP id
        75.DC.23569.F669CBE5; Thu, 14 May 2020 09:53:03 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
        epcas5p1.samsung.com (KnoxPortal) with ESMTPA id
        20200514005302epcas5p1d2e99ba001cacc4d9e0d8dcf7de3155b~Ovt7ORcye0512105121epcas5p17;
        Thu, 14 May 2020 00:53:02 +0000 (GMT)
Received: from epsmgms1p2.samsung.com (unknown [182.195.42.42]) by
        epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20200514005302epsmtrp1db91eb220531ddbb6a7d682f1f64e34d~Ovt7NAEjp1129711297epsmtrp1Z;
        Thu, 14 May 2020 00:53:02 +0000 (GMT)
X-AuditID: b6c32a4a-3c7ff70000005c11-08-5ebc966f38f8
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
        epsmgms1p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        34.82.25866.E669CBE5; Thu, 14 May 2020 09:53:02 +0900 (KST)
Received: from Jaguar.sa.corp.samsungelectronics.net (unknown
        [107.108.73.139]) by epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
        20200514005300epsmtip2369ac19e580cac567e91518bfa9bb408~Ovt5T1EGp3258132581epsmtip2v;
        Thu, 14 May 2020 00:53:00 +0000 (GMT)
From:   Alim Akhtar <alim.akhtar@samsung.com>
To:     robh@kernel.org
Cc:     devicetree@vger.kernel.org, linux-scsi@vger.kernel.org,
        krzk@kernel.org, avri.altman@wdc.com, martin.petersen@oracle.com,
        kwmad.kim@samsung.com, stanley.chu@mediatek.com,
        cang@codeaurora.org, linux-samsung-soc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Alim Akhtar <alim.akhtar@samsung.com>
Subject: [PATCH v9 05/10] scsi: ufs: add quirk to fix abnormal ocs fatal
 error
Date:   Thu, 14 May 2020 06:09:09 +0530
Message-Id: <20200514003914.26052-6-alim.akhtar@samsung.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200514003914.26052-1-alim.akhtar@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpmleLIzCtJLcpLzFFi42LZdlhTQzd/2p44gymf+C0ezNvGZvHy51U2
        i0/rl7FazD9yjtXi/PkN7BY3txxlsdj0+BqrxeVdc9gsZpzfx2TRfX0Hm8Xy4/+YLP7v2cFu
        sXTrTUYHXo/Lfb1MHptWdbJ5bF5S79Fycj+Lx8ent1g8+rasYvT4vEnOo/1AN1MARxSXTUpq
        TmZZapG+XQJXxqYjP9gK2vkq1l++yNzAeIa7i5GDQ0LAROLfWZ8uRi4OIYHdjBIv+uayQjif
        GCXuNr2Ecj4zSpyd8hbI4QTraPw3Eyqxi1GidcNKFginhUni86MFYFVsAtoSd6dvYQKxRQSE
        JY58a2MEsZkFbjBJPFjpAmILCwRIXG1qYgGxWQRUJS4sn8wGYvMK2EgcujSPHWKbvMTqDQeY
        QWxOAVuJLV+OgW2WEGjlkNj5fQoLRJGLxNJZfxkhbGGJV8e3QDVLSbzsb2OHeDRbomeXMUS4
        RmLpvGNQrfYSB67MYQEpYRbQlFi/Sx/iTD6J3t9PmCA6eSU62oQgqlUlmt9dheqUlpjY3Q0N
        Ew+J840z2SDBMIFRovFVE9sERtlZCFMXMDKuYpRMLSjOTU8tNi0wykst1ytOzC0uzUvXS87P
        3cQITidaXjsYHz74oHeIkYmD8RCjBAezkgiv3/rdcUK8KYmVValF+fFFpTmpxYcYpTlYlMR5
        kxq3xAkJpCeWpGanphakFsFkmTg4pRqYkiO2hh3yrV0dW1t1WvPpagbuG7P7LhmtU13QLLau
        SGjl1/1xJ80P/PysHZXK/+qn6ZyLfAUFq4XLeTbwvpRv8PPwt/tg1/dgUez+r7u0Hz66ZPbv
        TZ5ZIJvE2XN9OkqZczRPHrF4H8B9izGu6a2d4ezm6NRYfaVkX869Fr8UlvtLVP9V4QQGuHBJ
        pOtKdta2lb9u3Raa87Qq/Xd033nzzQdfuDPv3vko/AZzzsWHjXPP1554Mp9h8YSVX1cGvXzw
        lomFMWTF8n/9pdOsvXWeTj8pMa1hh0T7HesYp58ZTQvPtqev8g9Ni2l7IV9eei03J0r4cdCO
        DYZdZ9fZ8my7dF91Z5ZF1OOwzzE1HPVKLMUZiYZazEXFiQA7sI+0lgMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrMLMWRmVeSWpSXmKPExsWy7bCSvG7etD1xBp2nFC0ezNvGZvHy51U2
        i0/rl7FazD9yjtXi/PkN7BY3txxlsdj0+BqrxeVdc9gsZpzfx2TRfX0Hm8Xy4/+YLP7v2cFu
        sXTrTUYHXo/Lfb1MHptWdbJ5bF5S79Fycj+Lx8ent1g8+rasYvT4vEnOo/1AN1MARxSXTUpq
        TmZZapG+XQJXxqYjP9gK2vkq1l++yNzAeIa7i5GTQ0LARKLx30zWLkYuDiGBHYwSl0+sZ4NI
        SEtc3ziBHcIWllj57zk7RFETk8TJ2fOZQRJsAtoSd6dvYQKxRYCKjnxrYwSxmQWeMUmcelgK
        YgsL+Emc/rQBrIZFQFXiwvLJYAt4BWwkDl2aB7VAXmL1hgNgMzkFbCW2fDnGCmILAdUsW7OM
        cQIj3wJGhlWMkqkFxbnpucWGBUZ5qeV6xYm5xaV56XrJ+bmbGMHhrKW1g3HPqg96hxiZOBgP
        MUpwMCuJ8Pqt3x0nxJuSWFmVWpQfX1Sak1p8iFGag0VJnPfrrIVxQgLpiSWp2ampBalFMFkm
        Dk6pBqZDi16aqnBILjaZs9/RUWvSZHex14Yfu6cFbJHQrY4N2Zj1c2axzObnzy259/qe8F9t
        F7lBL+bTleiFVVtsovc83XhIMOx9kuEjlznr51vwx75S82e4U9isnHCdpVjjkl3OLrl7G6cx
        HHUpbK6P7nt+yIWn8bCPy+63UhZ+/Ef87zyuDsjb4jU/sV6sj/PbpMNnfcUzLkT9/Hpy22+5
        9U+luv51J6sWt1udO/tAmc/xn0xnZN7x0NfWjdsT1nSUupmsc7C9He7wMPLcTwn7+2/j6iaL
        mBxZn1qn+DFty6nzddJ3pAQM3nKfCS6bHi31OYX1aJT7lWU7V79mrmLf4XrM/HogLytXgsf2
        Ju21fEosxRmJhlrMRcWJABdlsjXWAgAA
X-CMS-MailID: 20200514005302epcas5p1d2e99ba001cacc4d9e0d8dcf7de3155b
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
CMS-TYPE: 105P
X-CMS-RootMailID: 20200514005302epcas5p1d2e99ba001cacc4d9e0d8dcf7de3155b
References: <20200514003914.26052-1-alim.akhtar@samsung.com>
        <CGME20200514005302epcas5p1d2e99ba001cacc4d9e0d8dcf7de3155b@epcas5p1.samsung.com>
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

