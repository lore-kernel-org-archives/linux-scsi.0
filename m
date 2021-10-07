Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7E85CC43219
	for <linux-scsi@archiver.kernel.org>; Thu,  7 Oct 2021 08:12:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 665BF610CC
	for <linux-scsi@archiver.kernel.org>; Thu,  7 Oct 2021 08:12:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240688AbhJGIOo (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 7 Oct 2021 04:14:44 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:43251 "EHLO
        mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240651AbhJGIOP (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 7 Oct 2021 04:14:15 -0400
Received: from epcas2p4.samsung.com (unknown [182.195.41.56])
        by mailout1.samsung.com (KnoxPortal) with ESMTP id 20211007081220epoutp01be63d96d7d52d862a1924f0439ddae8b~rsWXffgIG1645416454epoutp01Y
        for <linux-scsi@vger.kernel.org>; Thu,  7 Oct 2021 08:12:20 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20211007081220epoutp01be63d96d7d52d862a1924f0439ddae8b~rsWXffgIG1645416454epoutp01Y
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1633594340;
        bh=AtwWk/lYIXpuBY7dYqK7BJvBfyNG81wlZG2P/A0+EEU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VMEr970e06yTFgbZel043sHcTl9usJ1VAI12djJcfMf1FtsymdTdftCLMeZft8iPc
         uLI/UZtgKUA1FUAHZPAf+K8+kdEMUw9ZHjKlaDOjqAoX/Z6yemI4cRryl9TZXiNa5/
         mDL4vdRgk5dIlh8YVn347bnv6f9Uwzec6KXVtmLg=
Received: from epsnrtp3.localdomain (unknown [182.195.42.164]) by
        epcas2p1.samsung.com (KnoxPortal) with ESMTP id
        20211007081159epcas2p1e71d383171530e850798fc614d42f5a3~rsWDgtzvz2609026090epcas2p1d;
        Thu,  7 Oct 2021 08:11:59 +0000 (GMT)
Received: from epsmges2p3.samsung.com (unknown [182.195.36.89]) by
        epsnrtp3.localdomain (Postfix) with ESMTP id 4HQ3vG4xwNz4x9QM; Thu,  7 Oct
        2021 08:11:54 +0000 (GMT)
Received: from epcas2p1.samsung.com ( [182.195.41.53]) by
        epsmges2p3.samsung.com (Symantec Messaging Gateway) with SMTP id
        9E.E5.09749.7CBAE516; Thu,  7 Oct 2021 17:11:51 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
        epcas2p4.samsung.com (KnoxPortal) with ESMTPA id
        20211007081134epcas2p4b6c0673d5b47cd04d9aefcd3d07c75cc~rsVry-m1Z2566325663epcas2p4w;
        Thu,  7 Oct 2021 08:11:34 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
        epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20211007081134epsmtrp173201091d0670ec8be84a8899b3eee4a~rsVrxkjK62192321923epsmtrp1n;
        Thu,  7 Oct 2021 08:11:34 +0000 (GMT)
X-AuditID: b6c32a47-d13ff70000002615-7a-615eabc72477
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
        epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        8E.53.09091.5BBAE516; Thu,  7 Oct 2021 17:11:33 +0900 (KST)
Received: from localhost.localdomain (unknown [10.229.9.51]) by
        epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
        20211007081133epsmtip244070eeae98522b830d972e45b96fef7~rsVrfcs7J0566205662epsmtip27;
        Thu,  7 Oct 2021 08:11:33 +0000 (GMT)
From:   Chanho Park <chanho61.park@samsung.com>
To:     Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        "James E . J . Bottomley" <jejb@linux.ibm.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
Cc:     Bean Huo <beanhuo@micron.com>,
        Bart Van Assche <bvanassche@acm.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Christoph Hellwig <hch@infradead.org>,
        Can Guo <cang@codeaurora.org>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Jaehoon Chung <jh80.chung@samsung.com>,
        Gyunghoon Kwon <goodjob.kwon@samsung.com>,
        Sowon Na <sowon.na@samsung.com>,
        linux-samsung-soc@vger.kernel.org, linux-scsi@vger.kernel.org,
        jongmin jeong <jjmin.jeong@samsung.com>,
        Chanho Park <chanho61.park@samsung.com>
Subject: [PATCH v4 02/16] scsi: ufs: add quirk to enable host controller
 without ph configuration
Date:   Thu,  7 Oct 2021 17:09:20 +0900
Message-Id: <20211007080934.108804-3-chanho61.park@samsung.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211007080934.108804-1-chanho61.park@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA01TbUxTZxTOe2+5Lcxud0XGu4ZBd40zhYAtUrhOGQaMu4YuwbEtOofsjt4A
        oV9rywSzZK1DxodCiZtoGbNA3BQ1dQhYvrQCETsyGFSFsWzABNdqiAiZDgq4loub/55zzvOc
        85z3g4cKJjAhL1dtYHRqWklgQZzWHrEsuu/8AVpyphaSzqkLGDnxXStGehZuY+T1yVIOeWJ2
        ASXnbN8HkK5rUeTRthSy31yPkFM2C0rWj7Yi5OhicQB57g5J/jjzD0KeHLyKkOUjdoz8oW8F
        Ib0L3cgOAeW6lUpZjMcwylVxDKEun42kGjo9CNXUWIpR5noHoJ7YSjDq0fQYh6pobgTUfFM4
        9ZWjHElb92He9hyGVjA6EaPO0ihy1dmJRGp6ZkqmLF4ijZZuJRMIkZpWMYnETnla9K5cpW83
        QvQZrcz3pdJovZ7Y/NZ2nSbfwIhyNHpDIsFoFUptgjZGT6v0+ersGDVjeFMqkcTKfMSP83JO
        Db+urXmp4FyZAzGCX9eVgUAexOPgvY45rAwE8QS4HcDLQ10cNpgDcNLZhrLBYwBvuDt8NN6q
        ZPxMCpvvArBnqXaN9AhA52I95u+L4dGw+a/7wF9Yjz8EcOru11x/gOIeFN52znP9rYLxLHjJ
        E+4XcPCNsHa0fTXNx5Pg6DzC+ouAvYulqB8H4jtgZ/vF1f58/GXoPDXF8WPUx/mypWbVBMTd
        PHit1s1hxTth3cB8AIuD4f2+Zi6LhdBTWcxlBeUAHvnz6VrhPIClJjmLk+BidXOA3xCKi6Gt
        fTO7/QbYO7Y290VY0rPMZdN8WFIsYIWboONK9ZqD12D5t88cUHCy3YGwZ3UcwObD7gAzEFme
        W8fy3DqW/wdbAdoIXmG0elU2o4/VbvnvgrM0qiaw+tQj37aDkzOzMd0A4YFuAHkosZ6vScqg
        BXwFXXiI0WkydflKRt8NZL6zrkKFIVka319RGzKlcVslcfHx0oRYmSSBCOXXriTTAjybNjB5
        DKNldM90CC9QaERCd0mOO8wt3hl8JbEzSKWqmp/uc8kuXi02ewfvHf7knahKr31pdnD6UHKr
        LLVO2L9xaO/eYG7/vv0mhRWGc9794EnU+65kwS8xJQPlpbMi04bOlpqwjIcX5ApRsklZVace
        E7vD0u4Me+zy3XjcePoIMnPTFrEkzw4MuVHxG73fdOR6W0d8z9LPA7e874mHblYeDOsWW7+Z
        +NuZPHzw88Fp+wvMkFx5V2SZazja+6DgD/eBp9FTV6rL9lx6vCn3bOFImbXIZTidnvWp9PcQ
        4Z7YBxWzp8czPnrj1ROhRf3b2glNoekn3aSxwujJsHaFLxdEhG3b9wWaiuxu8C4rtliLxARH
        n0NLI1Gdnv4X/Q5l0HMEAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprJIsWRmVeSWpSXmKPExsWy7bCSvO7W1XGJBosOKVmcfLKGzeLBvG1s
        Fi9/XmWzOPiwk8Vi2oefzBaf1i9jtbi8X9uiZ6ezxekJi5gsnqyfxWyx6MY2Josbv9pYLVZe
        s7DY+PYHk8WM8/uYLLqv72CzWH78H5PF75+HmByEPC5f8faY1dDL5nG5r5fJY/MKLY/Fe14y
        eWxa1cnmMWHRAUaP7+s72Dw+Pr3F4tG3ZRWjx+dNch7tB7qZAniiuGxSUnMyy1KL9O0SuDJm
        XlIsmM1fsbLrAFMD402eLkYODgkBE4n7S527GLk4hAR2M0qcXH+MpYuREyguK/Hs3Q52CFtY
        4n7LEVaIoveMEo82zgFLsAnoSmx5/ooRxBYR+MgoMeebFkgRs8BXZolNR6cxgSSEBRIl3r+b
        CVbEIqAqMffGLnaQzbwC9hI3PjNBLJCXOPKrkxnE5hRwkNizay0bSIkQUEnX30iQMK+AoMTJ
        mU/AbmMGKm/eOpt5AqPALCSpWUhSCxiZVjFKphYU56bnFhsWGOallusVJ+YWl+al6yXn525i
        BMeeluYOxu2rPugdYmTiYDzEKMHBrCTCm28fmyjEm5JYWZValB9fVJqTWnyIUZqDRUmc90LX
        yXghgfTEktTs1NSC1CKYLBMHp1QDU5jBy8dv7NuY1Rs4t3AY7k68mcRVwPrednPIJDv9DXxb
        GJZmuhQXHg6evvrCI+fUlbXWjo1R7Jbnkmuf7rhy5HezGVM2w//l2z3cxPfpBzHvPHS9tKiz
        7WruNZtz6sF7YiqFvi9b7XR9SvU3o3dq5g07nlqemTDvj3AZt/Snrez/1j1sLtzlnsFj8uwQ
        MysXq7dQ1gdx3y4uH/PrB/u73JiiRTeY6U920OftXBJR55j84fOajG8/H34oOFVtPO3jVb89
        B+dFTrXkYcjvY1r+cnXr7sg7t7y5bi2ffc33Gavsp6X790wzWfHx6QG24mU9AY9v68Uz/fmX
        /37H+Qq/sPDdd74Ylt67pys0y2GqoRJLcUaioRZzUXEiAOR2OtYsAwAA
X-CMS-MailID: 20211007081134epcas2p4b6c0673d5b47cd04d9aefcd3d07c75cc
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
CMS-TYPE: 102P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20211007081134epcas2p4b6c0673d5b47cd04d9aefcd3d07c75cc
References: <20211007080934.108804-1-chanho61.park@samsung.com>
        <CGME20211007081134epcas2p4b6c0673d5b47cd04d9aefcd3d07c75cc@epcas2p4.samsung.com>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: jongmin jeong <jjmin.jeong@samsung.com>

samsung ExynosAuto SoC has two types of host controller interface to
support the virtualization of UFS Device.
One is the physical host(PH) that the same as conventaional UFSHCI,
and the other is the virtual host(VH) that support data transfer function only.

In this structure, the virtual host does not support like device management.
This patch skips the physical host interface configuration part that cannot
be performed in the virtual host.

Suggested-by: Alim Akhtar <alim.akhtar@samsung.com>
Cc: James E.J. Bottomley <jejb@linux.ibm.com>
Cc: Martin K. Petersen <martin.petersen@oracle.com>
Cc: Bart Van Assche <bvanassche@acm.org>
Reviewed-by: Alim Akhtar <alim.akhtar@samsung.com>
Signed-off-by: jongmin jeong <jjmin.jeong@samsung.com>
Signed-off-by: Chanho Park <chanho61.park@samsung.com>
---
 drivers/scsi/ufs/ufshcd.c | 3 +++
 drivers/scsi/ufs/ufshcd.h | 6 ++++++
 2 files changed, 9 insertions(+)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 7cf8e688aec8..aec18ce203b9 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -8053,6 +8053,9 @@ static int ufshcd_probe_hba(struct ufs_hba *hba, bool init_dev_params)
 	if (ret)
 		goto out;
 
+	if (hba->quirks & UFSHCD_QUIRK_SKIP_PH_CONFIGURATION)
+		goto out;
+
 	/* Debug counters initialization */
 	ufshcd_clear_dbg_ufs_stats(hba);
 
diff --git a/drivers/scsi/ufs/ufshcd.h b/drivers/scsi/ufs/ufshcd.h
index 5d485d65591f..aceaedcc1558 100644
--- a/drivers/scsi/ufs/ufshcd.h
+++ b/drivers/scsi/ufs/ufshcd.h
@@ -594,6 +594,12 @@ enum ufshcd_quirks {
 	 * support UIC command
 	 */
 	UFSHCD_QUIRK_BROKEN_UIC_CMD			= 1 << 15,
+
+	/*
+	 * This quirk needs to be enabled if the host controller cannot
+	 * support physical host configuration.
+	 */
+	UFSHCD_QUIRK_SKIP_PH_CONFIGURATION		= 1 << 16,
 };
 
 enum ufshcd_caps {
-- 
2.33.0

