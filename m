Return-Path: <SRS0=HyWO=6K=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 54203C7C888
	for <linux-scsi@archiver.kernel.org>; Sun, 26 Apr 2020 17:42:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 30F5321556
	for <linux-scsi@archiver.kernel.org>; Sun, 26 Apr 2020 17:42:54 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="YPzC335g"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726472AbgDZRmu (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 26 Apr 2020 13:42:50 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:33761 "EHLO
        mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726397AbgDZRmQ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 26 Apr 2020 13:42:16 -0400
Received: from epcas5p3.samsung.com (unknown [182.195.41.41])
        by mailout3.samsung.com (KnoxPortal) with ESMTP id 20200426174214epoutp03f32276490c83f49312fa809bd5f78223~Jb37hHKUE0343203432epoutp03h
        for <linux-scsi@vger.kernel.org>; Sun, 26 Apr 2020 17:42:14 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com 20200426174214epoutp03f32276490c83f49312fa809bd5f78223~Jb37hHKUE0343203432epoutp03h
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1587922934;
        bh=x/NJP4BcylUgWL3qK+Vpk3L9Gg4VlYVDP50hn5tTzsY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YPzC335gWq4FKNsmz4zUxj0cx408Mr/ywT3mXo5TyE3MztXpYcDfulROseqeyo+oO
         T4IbUfLj5pVrvMysj/a3s24ZGkyUuYdQ49GsBOAFKDsB8sUwEUl4tvrH854qMp8a2J
         WbZ+qed6nwPrqLY8oe/d6wi3Ctz1V8p71ZYQjO7g=
Received: from epsmges5p3new.samsung.com (unknown [182.195.42.75]) by
        epcas5p2.samsung.com (KnoxPortal) with ESMTP id
        20200426174213epcas5p22d1d871bcae20c22c9a300c05f935d0e~Jb37Clgx40053600536epcas5p2g;
        Sun, 26 Apr 2020 17:42:13 +0000 (GMT)
Received: from epcas5p1.samsung.com ( [182.195.41.39]) by
        epsmges5p3new.samsung.com (Symantec Messaging Gateway) with SMTP id
        0B.DE.04736.5F7C5AE5; Mon, 27 Apr 2020 02:42:13 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
        epcas5p3.samsung.com (KnoxPortal) with ESMTPA id
        20200426174213epcas5p3f5b403eafe77d98cbe0b92ccb3fd56b2~Jb36kVMSB0554805548epcas5p3J;
        Sun, 26 Apr 2020 17:42:13 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
        epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20200426174213epsmtrp1d2367c630dce0e0840a41cf3c6625fe5~Jb36jh32o0798907989epsmtrp1S;
        Sun, 26 Apr 2020 17:42:13 +0000 (GMT)
X-AuditID: b6c32a4b-acbff70000001280-02-5ea5c7f5bffd
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
        epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        AB.FF.18461.5F7C5AE5; Mon, 27 Apr 2020 02:42:13 +0900 (KST)
Received: from Jaguar.sa.corp.samsungelectronics.net (unknown
        [107.108.73.139]) by epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
        20200426174211epsmtip10673fa7d201900c15d21f4d9f9dad6d5~Jb34tKWaM2817828178epsmtip1K;
        Sun, 26 Apr 2020 17:42:11 +0000 (GMT)
From:   Alim Akhtar <alim.akhtar@samsung.com>
To:     robh@kernel.org
Cc:     devicetree@vger.kernel.org, linux-scsi@vger.kernel.org,
        krzk@kernel.org, avri.altman@wdc.com, martin.petersen@oracle.com,
        kwmad.kim@samsung.com, stanley.chu@mediatek.com,
        cang@codeaurora.org, linux-samsung-soc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Alim Akhtar <alim.akhtar@samsung.com>
Subject: [PATCH v7 05/10] scsi: ufs: add quirk to fix abnormal ocs fatal
 error
Date:   Sun, 26 Apr 2020 23:00:19 +0530
Message-Id: <20200426173024.63069-6-alim.akhtar@samsung.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200426173024.63069-1-alim.akhtar@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupnleLIzCtJLcpLzFFi42LZdlhTXffr8aVxBhNP6Fs8mLeNzeLlz6ts
        Fp/WL2O1mH/kHKvF+fMb2C1ubjnKYrHp8TVWi8u75rBZzDi/j8mi+/oONovlx/8xWfzfs4Pd
        YunWm4wOvB6X+3qZPDat6mTz2Lyk3qPl5H4Wj49Pb7F49G1ZxejxeZOcR/uBbqYAjigum5TU
        nMyy1CJ9uwSujFMXdzAWXOetmPastoFxIXcXIyeHhICJRNejW4xdjFwcQgK7GSVaNs9kg3A+
        MUrc3bOSFcL5xihxeu5kFpiWRVffQVXtZZRoXPGbCcJpYZLoPHgLrIpNQFvi7vQtTCC2iICw
        xJFvbYwgNrPADSaJBytdQGxhgQCJBxN62EBsFgFViS1r/rGC2LwCNhIXHi9hhtgmL7F6wwEw
        m1PAVuLUjF1MEPFODonT7+IhbBeJzrMboOqFJV4d38IOYUtJvOxvA7I5gOxsiZ5dxhDhGoml
        845BPWMvceDKHBaQEmYBTYn1u/QhruST6P39hAmik1eio00IolpVovndVahOaYmJ3d2sELaH
        xJnNW6ChMIFRYtKhVrYJjLKzEKYuYGRcxSiZWlCcm55abFpgnJdarlecmFtcmpeul5yfu4kR
        nEy0vHcwbjrnc4hRgINRiYeXY/vSOCHWxLLiytxDjBIczEoivDEli+KEeFMSK6tSi/Lji0pz
        UosPMUpzsCiJ805ivRojJJCeWJKanZpakFoEk2Xi4JRqYPQPXsbi77fnwI91cc90GUt2pAhs
        sXHtY3T+KurYsf8T50PeO+Zfbh1XWn3j1eQd5auad259bb8951HgyYU/W4zO7px4Zkby7kdC
        8oedbCd+ffyKaWeCfK/7o8dqEcUuHy/GfKxs5LWNWP/oqNBNvRDnSYf38fd+KHE2kSwN41zx
        s1ptZ2y5RYASS3FGoqEWc1FxIgClp2bjIgMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrILMWRmVeSWpSXmKPExsWy7bCSnO7X40vjDD4/4rd4MG8bm8XLn1fZ
        LD6tX8ZqMf/IOVaL8+c3sFvc3HKUxWLT42usFpd3zWGzmHF+H5NF9/UdbBbLj/9jsvi/Zwe7
        xdKtNxkdeD0u9/UyeWxa1cnmsXlJvUfLyf0sHh+f3mLx6NuyitHj8yY5j/YD3UwBHFFcNimp
        OZllqUX6dglcGacu7mAsuM5bMe1ZbQPjQu4uRk4OCQETiUVX37F1MXJxCAnsZpR4e/49G0RC
        WuL6xgnsELawxMp/z9khipqYJGa82c8EkmAT0Ja4O30LmC0CVHTkWxsjiM0s8IxJ4tTDUhBb
        WMBPouXDf2YQm0VAVWLLmn+sIDavgI3EhcdLmCEWyEus3nAAzOYUsJU4NWMX0EwOoGU2EtPX
        +09g5FvAyLCKUTK1oDg3PbfYsMAwL7Vcrzgxt7g0L10vOT93EyM4lLU0dzBuX/VB7xAjEwfj
        IUYJDmYlEd6YkkVxQrwpiZVVqUX58UWlOanFhxilOViUxHlvFC6MExJITyxJzU5NLUgtgsky
        cXBKNTAlLUl58eV5fE3WweRjeyL0F020uThbiaNpeUrppVuOM/6c3OMintHw9ucmO0+NnSo3
        5wZ/a2XZ4LBEoszgv1ICa8UyB+8Pib/1brM5O/RzK2ZWcy2ZZ8Gzvuh/eKvez9CszIXOnO9M
        8nt8nGOPF4faneL/7Krzt7717Fr+D9/mvTGtdlt1draAWueXh6lKE1WdF2s7Nc9y1fevrTj2
        7KHFkXn/76s1b2xMmf/0tnKU9E/XCv+ccw5Fole+T/62OlTd3IxfRvXV8b/zn3y59fP83oCA
        GwlzP8Rqf/c7M/NQ55OTGp4HK3I+TWydxFzXX/s5/MUM/bo70h41M90Oz/KbbLxt9pxf1jlF
        QtcPWrUpsRRnJBpqMRcVJwIAZ+voQNQCAAA=
X-CMS-MailID: 20200426174213epcas5p3f5b403eafe77d98cbe0b92ccb3fd56b2
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
CMS-TYPE: 105P
X-CMS-RootMailID: 20200426174213epcas5p3f5b403eafe77d98cbe0b92ccb3fd56b2
References: <20200426173024.63069-1-alim.akhtar@samsung.com>
        <CGME20200426174213epcas5p3f5b403eafe77d98cbe0b92ccb3fd56b2@epcas5p3.samsung.com>
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

