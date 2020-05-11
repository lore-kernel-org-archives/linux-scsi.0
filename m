Return-Path: <SRS0=B1Ch=6Z=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D5232C54E8B
	for <linux-scsi@archiver.kernel.org>; Mon, 11 May 2020 02:14:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B3847208CA
	for <linux-scsi@archiver.kernel.org>; Mon, 11 May 2020 02:14:39 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="mP7SePy0"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729479AbgEKCOI (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 10 May 2020 22:14:08 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:33861 "EHLO
        mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729439AbgEKCOD (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 10 May 2020 22:14:03 -0400
Received: from epcas5p3.samsung.com (unknown [182.195.41.41])
        by mailout4.samsung.com (KnoxPortal) with ESMTP id 20200511021358epoutp04e2f9ca259c86406b89290dd093890805~N14vF_ozY1437514375epoutp04M
        for <linux-scsi@vger.kernel.org>; Mon, 11 May 2020 02:13:58 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20200511021358epoutp04e2f9ca259c86406b89290dd093890805~N14vF_ozY1437514375epoutp04M
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1589163238;
        bh=nPCI6KtKTzdjjbh5jTvGpI1fKN6gjrCt7WH8b1I6htY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mP7SePy03rDnsqEWNKKDxUFk35ngwtwzBL5MA3nLxcAPwRO1maCXf8EDcZ6Ky8JdS
         i8NUrwpkv+LEOSGGAqfybLv2QNiSEcWNo3zXgqxKSIlpBWondPX8GcoEh7gDtT8qZ8
         Q1h19EL1ePB9MYZFBwEzQ/V2QxBCUKtfetSvDZIo=
Received: from epsmges5p3new.samsung.com (unknown [182.195.42.75]) by
        epcas5p3.samsung.com (KnoxPortal) with ESMTP id
        20200511021357epcas5p3b9ebc4be44662f2a9c3cc143b5ab86d3~N14t_O96x1506415064epcas5p3P;
        Mon, 11 May 2020 02:13:57 +0000 (GMT)
Received: from epcas5p1.samsung.com ( [182.195.41.39]) by
        epsmges5p3new.samsung.com (Symantec Messaging Gateway) with SMTP id
        CD.0A.23389.5E4B8BE5; Mon, 11 May 2020 11:13:57 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
        epcas5p3.samsung.com (KnoxPortal) with ESMTPA id
        20200511021357epcas5p31ca197c25742a50359b076f10d4938cd~N14tezyBe2929029290epcas5p3B;
        Mon, 11 May 2020 02:13:57 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
        epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20200511021356epsmtrp20e8a952fd61f692aad30c99a3c57a5fb~N14tVYRlg1520815208epsmtrp2I;
        Mon, 11 May 2020 02:13:56 +0000 (GMT)
X-AuditID: b6c32a4b-7adff70000005b5d-30-5eb8b4e58333
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
        epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        5C.E6.18461.4E4B8BE5; Mon, 11 May 2020 11:13:56 +0900 (KST)
Received: from Jaguar.sa.corp.samsungelectronics.net (unknown
        [107.108.73.139]) by epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
        20200511021354epsmtip2df48f4cdf9d3437091391a5eeeebdb6d~N14rJxPbn3209532095epsmtip2i;
        Mon, 11 May 2020 02:13:54 +0000 (GMT)
From:   Alim Akhtar <alim.akhtar@samsung.com>
To:     robh@kernel.org
Cc:     devicetree@vger.kernel.org, linux-scsi@vger.kernel.org,
        krzk@kernel.org, avri.altman@wdc.com, martin.petersen@oracle.com,
        kwmad.kim@samsung.com, stanley.chu@mediatek.com,
        cang@codeaurora.org, linux-samsung-soc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Alim Akhtar <alim.akhtar@samsung.com>
Subject: [PATCH v8 04/10] scsi: ufs: introduce UFSHCD_QUIRK_PRDT_BYTE_GRAN
 quirk
Date:   Mon, 11 May 2020 07:30:25 +0530
Message-Id: <20200511020031.25730-5-alim.akhtar@samsung.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200511020031.25730-1-alim.akhtar@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA0WSeUwTURDGfbvb7bZaXQviQD0xRMVQD5SsNzEGN8ErRo1RAza6AuFqWrwP
        EOrVChZFIYqKilTqhbjQBjygFhA0xYSighIrKCoaVIiN91G2xv9+M/N975tMHoXL00UBVFxS
        CqdJUiUEklKi/O74sSGveGvUpLfO0YzrdDnJvP3aTDI914pEzBm7Q8Q0NpaImRa+hmBKOx6J
        mKaKfJLJa7yNMYbHVpIx1f3CmN83rWLmQlkLCpexTVmZGFtqPkiyNwpTWV39HYL99KqVYLN4
        M2J7S0ew+6sM2FJqtXTWBi4hbjOnmThnnTT2049yXG0ZsjVP1yxOQ22D9UhCAT0VrtYXER6W
        05UIGjPG6JH0L/cgKPniJIXCjcB+sAv/57jyqNM7uIWg8uRzJBQ6DB6015MeFUlPgLZcHvOw
        L+0Ddvc+5GGcfoKBq3i+HlGUD70MjKfGedoEHQSHjlzuW0NGzwKL5bBYCBsJl0qq+oIl9Gw4
        nmYhPFlA76XA+ew8IYjmw/fbdq/BB7rqeC8HQG/3LdKTBXQ8HKoIFdo74cLpWq91LlQ58wmP
        BKfHw7WKicKWAyHz+0tMcMrgwD65oA6CjO5mr1MB2QaDSGAWGtqLxMIVjAgePrQgIxp+4v+r
        BQiZkT+n1ibGcNpp6tAkbotSq0rUbkqKUa5PTixFfd8kONKK2l0flTaEUciGgMIDfWWmRGuU
        XLZBtW07p0mO1mxK4LQ2pKCIwKGyjj18lJyOUaVw8Ryn5jT/phglCUjDBrvDsyKMTkf5kJyb
        10cvS88x+azrXlxbrXSbJkyqG+XvT4rGZHeOcoszM3rttv6p5qOGvMJF74tDG8JjCynFLsPc
        J5/XXH2z8s2lSqtJYZ6mCsutOZUa/XOQ6efCpjX6jBA2ZFFE7ccI8bglMzbG890134xl+sie
        6i8j+z3I0QdVNkzHV10/9uJ9Qeix1+fhZNxju3lq15T7uzouRraN3XnuxbwFr51pHxZ3tvjl
        Eo5VufkD3kHxwrN+Vam8Yo5DsrwteNjarXd8hw4L4Ir4zRK/Aoce+LCWHa3BFl56ZJsxOd3l
        Qq1heLTtpXrFDUyasrZQ2Vqtu/f09+4r6pkry3SBhDZWNTkY12hVfwCxpD2RlQMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrMLMWRmVeSWpSXmKPExsWy7bCSvO6TLTviDG5MMrd4MG8bm8XLn1fZ
        LD6tX8ZqMf/IOVaL8+c3sFvc3HKUxWLT42usFpd3zWGzmHF+H5NF9/UdbBbLj/9jsvi/Zwe7
        xdKtNxkdeD0u9/UyeWxa1cnmsXlJvUfLyf0sHh+f3mLx6NuyitHj8yY5j/YD3UwBHFFcNimp
        OZllqUX6dglcGR//bGMu2C5aMaPlKnsD413BLkZODgkBE4m1156xdTFycQgJ7GaU6Li5gxki
        IS1xfeMEdghbWGLlv+fsEEVNTBKNv5tZQBJsAtoSd6dvYQKxRYCKjnxrYwSxmQWeMUmcelgK
        YgsLBEgs/T0frJ5FQFWiZ9IaMJtXwEZi+/Z+qAXyEqs3HABbzClgKzGtYTtYjRBQzYxNm1kn
        MPItYGRYxSiZWlCcm55bbFhgmJdarlecmFtcmpeul5yfu4kRHM5amjsYt6/6oHeIkYmD8RCj
        BAezkgjv8twdcUK8KYmVValF+fFFpTmpxYcYpTlYlMR5bxQujBMSSE8sSc1OTS1ILYLJMnFw
        SjUw+S/ID024fTtx+YEF5h0rNi07kB2yvYarWlpf36abY/XZH0cUD57LPr5y4xyf27vEOP2b
        nsgkPan0nbb0j/w7xdhH/v4lcRNWxrhM158+M2WfxoW3666odd3a2m7ewrDd0yCSIyVQK/Hy
        /aWCtVYb62b4mHXcOd3AfGWJT6fclbgbSsyH18nVK7yQ+ZbuG25vwnxrfnmT+NosRRte+VwZ
        DimjU4ftw7bsPH670KB0qmvLi09MfzhuH0jUXWhd0mrzpbzo5rFevb/imcEyfTwfpr0yPK3Q
        uULzSqyg6dzQGdcfuugJNKw+PdXF5LbfO16V5wE56bpMM/tV1FclPso46G+21VVcWDjWZpvC
        5QYlluKMREMt5qLiRACW9gw11gIAAA==
X-CMS-MailID: 20200511021357epcas5p31ca197c25742a50359b076f10d4938cd
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
CMS-TYPE: 105P
X-CMS-RootMailID: 20200511021357epcas5p31ca197c25742a50359b076f10d4938cd
References: <20200511020031.25730-1-alim.akhtar@samsung.com>
        <CGME20200511021357epcas5p31ca197c25742a50359b076f10d4938cd@epcas5p3.samsung.com>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Some UFS host controllers like Exynos uses granularities of PRDT length and
offset as bytes, whereas others uses actual segment count.

Reviewed-by: Avri Altman <avri.altman@wdc.com>
Signed-off-by: Kiwoong Kim <kwmad.kim@samsung.com>
Signed-off-by: Alim Akhtar <alim.akhtar@samsung.com>
---
 drivers/scsi/ufs/ufshcd.c | 30 +++++++++++++++++++++++-------
 drivers/scsi/ufs/ufshcd.h |  6 ++++++
 2 files changed, 29 insertions(+), 7 deletions(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index ee30ed6cc805..ba093d0d0942 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -2151,8 +2151,14 @@ static int ufshcd_map_sg(struct ufs_hba *hba, struct ufshcd_lrb *lrbp)
 		return sg_segments;
 
 	if (sg_segments) {
-		lrbp->utr_descriptor_ptr->prd_table_length =
-			cpu_to_le16((u16)sg_segments);
+
+		if (hba->quirks & UFSHCD_QUIRK_PRDT_BYTE_GRAN)
+			lrbp->utr_descriptor_ptr->prd_table_length =
+				cpu_to_le16((sg_segments *
+					sizeof(struct ufshcd_sg_entry)));
+		else
+			lrbp->utr_descriptor_ptr->prd_table_length =
+				cpu_to_le16((u16) (sg_segments));
 
 		prd_table = (struct ufshcd_sg_entry *)lrbp->ucd_prdt_ptr;
 
@@ -3500,11 +3506,21 @@ static void ufshcd_host_memory_configure(struct ufs_hba *hba)
 				cpu_to_le32(upper_32_bits(cmd_desc_element_addr));
 
 		/* Response upiu and prdt offset should be in double words */
-		utrdlp[i].response_upiu_offset =
-			cpu_to_le16(response_offset >> 2);
-		utrdlp[i].prd_table_offset = cpu_to_le16(prdt_offset >> 2);
-		utrdlp[i].response_upiu_length =
-			cpu_to_le16(ALIGNED_UPIU_SIZE >> 2);
+		if (hba->quirks & UFSHCD_QUIRK_PRDT_BYTE_GRAN) {
+			utrdlp[i].response_upiu_offset =
+				cpu_to_le16(response_offset);
+			utrdlp[i].prd_table_offset =
+				cpu_to_le16(prdt_offset);
+			utrdlp[i].response_upiu_length =
+				cpu_to_le16(ALIGNED_UPIU_SIZE);
+		} else {
+			utrdlp[i].response_upiu_offset =
+				cpu_to_le16(response_offset >> 2);
+			utrdlp[i].prd_table_offset =
+				cpu_to_le16(prdt_offset >> 2);
+			utrdlp[i].response_upiu_length =
+				cpu_to_le16(ALIGNED_UPIU_SIZE >> 2);
+		}
 
 		ufshcd_init_lrb(hba, &hba->lrb[i], i);
 	}
diff --git a/drivers/scsi/ufs/ufshcd.h b/drivers/scsi/ufs/ufshcd.h
index f8d08cb9caf7..a9b9ace9fc72 100644
--- a/drivers/scsi/ufs/ufshcd.h
+++ b/drivers/scsi/ufs/ufshcd.h
@@ -535,6 +535,12 @@ enum ufshcd_quirks {
 	 * enabled via HCE register.
 	 */
 	UFSHCI_QUIRK_BROKEN_HCE				= 1 << 8,
+
+	/*
+	 * This quirk needs to be enabled if the host controller regards
+	 * resolution of the values of PRDTO and PRDTL in UTRD as byte.
+	 */
+	UFSHCD_QUIRK_PRDT_BYTE_GRAN			= 1 << 9,
 };
 
 enum ufshcd_caps {
-- 
2.17.1

