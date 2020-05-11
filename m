Return-Path: <SRS0=B1Ch=6Z=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 15C15C54E92
	for <linux-scsi@archiver.kernel.org>; Mon, 11 May 2020 02:14:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E32FA2184D
	for <linux-scsi@archiver.kernel.org>; Mon, 11 May 2020 02:14:49 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="ckaOAs0g"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729393AbgEKCNy (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 10 May 2020 22:13:54 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:33783 "EHLO
        mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729255AbgEKCNx (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 10 May 2020 22:13:53 -0400
Received: from epcas5p3.samsung.com (unknown [182.195.41.41])
        by mailout4.samsung.com (KnoxPortal) with ESMTP id 20200511021351epoutp044e3c0ab54d26d29546a2d7e7fe7b6a3a~N14nzP_WM1313513135epoutp04O
        for <linux-scsi@vger.kernel.org>; Mon, 11 May 2020 02:13:51 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20200511021351epoutp044e3c0ab54d26d29546a2d7e7fe7b6a3a~N14nzP_WM1313513135epoutp04O
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1589163231;
        bh=HK/1/VP5ov7EOoNpQ0X08DtlhI52O+2EyAZ3cTvlQkI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ckaOAs0gsGJq81PVuaGOhgqOx9Ycv9S6e53dGdsD0n3HYUOnHTbnkZfqnMtMouHSD
         ZmzUU7jW7SadxqzB44K2daFcf1vI4OfbIBFudMmOdiHle+WiJ7cyWNJ6DObKpXspaz
         HEiQZkvbnCwfyLaEDtL2/oGSeyWhmM1mPhpwNcX8=
Received: from epsmges5p2new.samsung.com (unknown [182.195.42.74]) by
        epcas5p3.samsung.com (KnoxPortal) with ESMTP id
        20200511021350epcas5p3deba4bf4bfed536e912be972a6c1e503~N14nEAQah1506415064epcas5p33;
        Mon, 11 May 2020 02:13:50 +0000 (GMT)
Received: from epcas5p3.samsung.com ( [182.195.41.41]) by
        epsmges5p2new.samsung.com (Symantec Messaging Gateway) with SMTP id
        F9.9E.23569.ED4B8BE5; Mon, 11 May 2020 11:13:50 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
        epcas5p1.samsung.com (KnoxPortal) with ESMTPA id
        20200511021349epcas5p107f296543fe2c1e13a9e5cbffdab43d3~N14mq56c21462014620epcas5p1b;
        Mon, 11 May 2020 02:13:49 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
        epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20200511021349epsmtrp295b330462cb70980d26fc6c99382fffa~N14mk2MeC1467414674epsmtrp2M;
        Mon, 11 May 2020 02:13:49 +0000 (GMT)
X-AuditID: b6c32a4a-3c7ff70000005c11-e1-5eb8b4de483a
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
        epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        A7.E6.18461.DD4B8BE5; Mon, 11 May 2020 11:13:49 +0900 (KST)
Received: from Jaguar.sa.corp.samsungelectronics.net (unknown
        [107.108.73.139]) by epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
        20200511021347epsmtip2ee551f9828ade523b0deff03136d02ff~N14knFANd0194601946epsmtip2l;
        Mon, 11 May 2020 02:13:47 +0000 (GMT)
From:   Alim Akhtar <alim.akhtar@samsung.com>
To:     robh@kernel.org
Cc:     devicetree@vger.kernel.org, linux-scsi@vger.kernel.org,
        krzk@kernel.org, avri.altman@wdc.com, martin.petersen@oracle.com,
        kwmad.kim@samsung.com, stanley.chu@mediatek.com,
        cang@codeaurora.org, linux-samsung-soc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Alim Akhtar <alim.akhtar@samsung.com>
Subject: [PATCH v8 01/10] scsi: ufs: add quirk to fix mishandling
 utrlclr/utmrlclr
Date:   Mon, 11 May 2020 07:30:22 +0530
Message-Id: <20200511020031.25730-2-alim.akhtar@samsung.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200511020031.25730-1-alim.akhtar@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpmleLIzCtJLcpLzFFi42LZdlhTU/felh1xBjtucVg8mLeNzeLlz6ts
        Fp/WL2O1mH/kHKvF+fMb2C1ubjnKYrHp8TVWi8u75rBZzDi/j8mi+/oONovlx/8xWfzfs4Pd
        YunWm4wOvB6X+3qZPDat6mTz2Lyk3qPl5H4Wj49Pb7F49G1ZxejxeZOcR/uBbqYAjigum5TU
        nMyy1CJ9uwSujBdH17AU7Bao2P/hOHMD42veLkYODgkBE4k/i826GLk4hAR2M0osajzPBuF8
        YpToWHWdEcL5xihxYvFGoAwnWMfs7wuZIRJ7GSXmNk5lgnBamCTO7fnHCFLFJqAtcXf6FiYQ
        W0RAWOLItzawOLPADSaJBytdQGxhgRCJJzca2EFsFgFViTnPT4Bt4BWwkdjz6iIrxDZ5idUb
        DjCD2JwCthLTGrazgCyTEGjkkFj38jM7RJGLxNOby5ghbGGJV8e3QMWlJD6/28sG8Wi2RM8u
        Y4hwjcTSecdYIGx7iQNX5rCAlDALaEqs36UPcSafRO/vJ0wQnbwSHW1CENWqEs3vrkJ1SktM
        7O6GutJDomV+DzskGCYwSqy708M+gVF2FsLUBYyMqxglUwuKc9NTi00LjPJSy/WKE3OLS/PS
        9ZLzczcxgtOJltcOxocPPugdYmTiYDzEKMHBrCTCuzx3R5wQb0piZVVqUX58UWlOavEhRmkO
        FiVx3qTGLXFCAumJJanZqakFqUUwWSYOTqkGpl3+CYdDTOJ0N7aaTXz66Fh/ovrbh87Oavs/
        TNq0/H/F7Wn60o55Xzz3ck4PtvWIKy44V/3TPPIx8/z7kSlvOnv9/c9e6f8ceHeJ/dYDYgsk
        d6VdzUy01OjUF/K4OzO/8fdW+w/a505V1zIFzek9X3Xee/lupYSyx3MND2xrNCi0f5+3foaP
        4Nc0fjO95lna4Wd2THKZInXgb+DTyGntOzf8PegSnXJObfUyf/b9qfFX5NhLqs6emViz1Seo
        dbOm8exfv1fc5Xm29MH53pAPJhFcvv+827nLD52aGWLI9+rRHym+xPnznWzzlVfXNnMcz97t
        c/ynTsvspJmX43WvB+rPiypaHavpz/7uur2vmxJLcUaioRZzUXEiAK7XXCCWAwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrILMWRmVeSWpSXmKPExsWy7bCSvO7dLTviDO4dVLN4MG8bm8XLn1fZ
        LD6tX8ZqMf/IOVaL8+c3sFvc3HKUxWLT42usFpd3zWGzmHF+H5NF9/UdbBbLj/9jsvi/Zwe7
        xdKtNxkdeD0u9/UyeWxa1cnmsXlJvUfLyf0sHh+f3mLx6NuyitHj8yY5j/YD3UwBHFFcNimp
        OZllqUX6dglcGS+OrmEp2C1Qsf/DceYGxte8XYycHBICJhKzvy9kBrGFBHYzSizfGQcRl5a4
        vnECO4QtLLHy33N2iJomJok9rVkgNpuAtsTd6VuYQGwRoJoj39oYQWxmgWdMEqceloLYwgJB
        ErcOdoL1sgioSsx5foINxOYVsJHY8+oiK8R8eYnVGw6A3cApYCsxrWE7C8QuG4kZmzazTmDk
        W8DIsIpRMrWgODc9t9iwwDAvtVyvODG3uDQvXS85P3cTIziUtTR3MG5f9UHvECMTB+MhRgkO
        ZiUR3uW5O+KEeFMSK6tSi/Lji0pzUosPMUpzsCiJ894oXBgnJJCeWJKanZpakFoEk2Xi4JRq
        YCr8USzEKG/560ph5nLB+9vPGenNnnHw3Z+1t6r8ZE+us1w50X3rhFfHS0SvP12nsFztkG/Q
        nNuZTLN/ZW51ZV414VD5r7Kpp4X6Jaa8Wih4cU2mOvvLa8kevTwbUj05F+3ucYxtfuncxPJV
        9LVMRcT0oF0n7kiaCBz8fSKuW1ctUOT82bm/9TZsL4o7Z8FZ/z7N7oFT59GOtiUbxPKXqVfH
        nbja75vOZGRqEn9zgUXRrYxvfB3Gl8W1k84yy7deLz722si8esY23mOVKeHizxcF6qTJ3Wze
        FlfeKeittHdqkdSlQ+mHwqt1+3q5KyV3ur9reKE+q3yZghv7rhmil4RPet1ePXG39due6FSr
        ACWW4oxEQy3mouJEADAj0o/UAgAA
X-CMS-MailID: 20200511021349epcas5p107f296543fe2c1e13a9e5cbffdab43d3
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
CMS-TYPE: 105P
X-CMS-RootMailID: 20200511021349epcas5p107f296543fe2c1e13a9e5cbffdab43d3
References: <20200511020031.25730-1-alim.akhtar@samsung.com>
        <CGME20200511021349epcas5p107f296543fe2c1e13a9e5cbffdab43d3@epcas5p1.samsung.com>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

In the right behavior, setting the bit to '0' indicates clear and '1'
indicates no change. If host controller handles this the other way,
UFSHCI_QUIRK_BROKEN_REQ_LIST_CLR can be used.

Reviewed-by: Can Guo <cang@codeaurora.org>
Reviewed-by: Avri Altman <avri.altman@wdc.com>
Signed-off-by: Seungwon Jeon <essuuj@gmail.com>
Signed-off-by: Alim Akhtar <alim.akhtar@samsung.com>
---
 drivers/scsi/ufs/ufshcd.c | 11 +++++++++--
 drivers/scsi/ufs/ufshcd.h |  5 +++++
 2 files changed, 14 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 698e8d20b4ba..3655b88fc862 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -645,7 +645,11 @@ static inline int ufshcd_get_tr_ocs(struct ufshcd_lrb *lrbp)
  */
 static inline void ufshcd_utrl_clear(struct ufs_hba *hba, u32 pos)
 {
-	ufshcd_writel(hba, ~(1 << pos), REG_UTP_TRANSFER_REQ_LIST_CLEAR);
+	if (hba->quirks & UFSHCI_QUIRK_BROKEN_REQ_LIST_CLR)
+		ufshcd_writel(hba, (1 << pos), REG_UTP_TRANSFER_REQ_LIST_CLEAR);
+	else
+		ufshcd_writel(hba, ~(1 << pos),
+				REG_UTP_TRANSFER_REQ_LIST_CLEAR);
 }
 
 /**
@@ -655,7 +659,10 @@ static inline void ufshcd_utrl_clear(struct ufs_hba *hba, u32 pos)
  */
 static inline void ufshcd_utmrl_clear(struct ufs_hba *hba, u32 pos)
 {
-	ufshcd_writel(hba, ~(1 << pos), REG_UTP_TASK_REQ_LIST_CLEAR);
+	if (hba->quirks & UFSHCI_QUIRK_BROKEN_REQ_LIST_CLR)
+		ufshcd_writel(hba, (1 << pos), REG_UTP_TASK_REQ_LIST_CLEAR);
+	else
+		ufshcd_writel(hba, ~(1 << pos), REG_UTP_TASK_REQ_LIST_CLEAR);
 }
 
 /**
diff --git a/drivers/scsi/ufs/ufshcd.h b/drivers/scsi/ufs/ufshcd.h
index 6ffc08ad85f6..071f0edf3f64 100644
--- a/drivers/scsi/ufs/ufshcd.h
+++ b/drivers/scsi/ufs/ufshcd.h
@@ -518,6 +518,11 @@ enum ufshcd_quirks {
 	 * ops (get_ufs_hci_version) to get the correct version.
 	 */
 	UFSHCD_QUIRK_BROKEN_UFS_HCI_VERSION		= 1 << 5,
+
+	/*
+	 * Clear handling for transfer/task request list is just opposite.
+	 */
+	UFSHCI_QUIRK_BROKEN_REQ_LIST_CLR		= 1 << 6,
 };
 
 enum ufshcd_caps {
-- 
2.17.1

