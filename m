Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	UNWANTED_LANGUAGE_BODY,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 40174C433DB
	for <linux-scsi@archiver.kernel.org>; Mon, 21 Dec 2020 01:36:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1135822C7B
	for <linux-scsi@archiver.kernel.org>; Mon, 21 Dec 2020 01:36:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726508AbgLUBgW (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 20 Dec 2020 20:36:22 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:47103 "EHLO
        mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726146AbgLUBgV (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 20 Dec 2020 20:36:21 -0500
Received: from epcas2p1.samsung.com (unknown [182.195.41.53])
        by mailout1.samsung.com (KnoxPortal) with ESMTP id 20201221013537epoutp0186b51f5d4461c0a3335493a4c8e7fcf3~Sl3MK6BVd0882108821epoutp01N
        for <linux-scsi@vger.kernel.org>; Mon, 21 Dec 2020 01:35:37 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20201221013537epoutp0186b51f5d4461c0a3335493a4c8e7fcf3~Sl3MK6BVd0882108821epoutp01N
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1608514537;
        bh=MGuh82DX6E5g8HiXvy+a7m1va7hecL227AUSV+OV2l8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:In-Reply-To:References:From;
        b=rYQrjZLYukc3kbojHNN8JsIeghS6BOHi03fd3lRtBgdIcQjtqxtJDtUjQgh5JBsLR
         QYbwS68L3srMuXD3LmrX9h3j2UttdSouFvhSY0EazSTAwW6e00YsXpNv/xMWheVm8e
         WWb7f1MWY9lV6bkLIRdnkIQuN3LgAGhccVfJaUCw=
Received: from epsnrtp4.localdomain (unknown [182.195.42.165]) by
        epcas2p4.samsung.com (KnoxPortal) with ESMTP id
        20201221013536epcas2p465770c7ce60d59d1582a9e8e20101d05~Sl3LdM_cF0233902339epcas2p4w;
        Mon, 21 Dec 2020 01:35:36 +0000 (GMT)
Received: from epsmges2p4.samsung.com (unknown [182.195.40.184]) by
        epsnrtp4.localdomain (Postfix) with ESMTP id 4Czhqp0NlSzMqYkd; Mon, 21 Dec
        2020 01:35:34 +0000 (GMT)
Received: from epcas2p3.samsung.com ( [182.195.41.55]) by
        epsmges2p4.samsung.com (Symantec Messaging Gateway) with SMTP id
        52.5C.52511.5EBFFDF5; Mon, 21 Dec 2020 10:35:33 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
        epcas2p2.samsung.com (KnoxPortal) with ESMTPA id
        20201221013533epcas2p2b4a9931d56ebd626a0fbc0490ac129c1~Sl3IgqrXW2735427354epcas2p2f;
        Mon, 21 Dec 2020 01:35:33 +0000 (GMT)
Received: from epsmgms1p2.samsung.com (unknown [182.195.42.42]) by
        epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20201221013533epsmtrp1c7af6f4e9af0c85346f77bebbab578eb~Sl3Ifmm0e0623206232epsmtrp1E;
        Mon, 21 Dec 2020 01:35:33 +0000 (GMT)
X-AuditID: b6c32a48-50fff7000000cd1f-af-5fdffbe56df5
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
        epsmgms1p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        10.43.08745.5EBFFDF5; Mon, 21 Dec 2020 10:35:33 +0900 (KST)
Received: from ubuntu.dsn.sec.samsung.com (unknown [12.36.155.120]) by
        epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
        20201221013533epsmtip272ddebbf649465675fd5dc4e2155ac8b~Sl3IUkIF-2616226162epsmtip2i;
        Mon, 21 Dec 2020 01:35:33 +0000 (GMT)
From:   Kiwoong Kim <kwmad.kim@samsung.com>
To:     linux-scsi@vger.kernel.org, alim.akhtar@samsung.com,
        avri.altman@wdc.com, jejb@linux.ibm.com,
        martin.petersen@oracle.com, beanhuo@micron.com,
        asutoshd@codeaurora.org, cang@codeaurora.org, bvanassche@acm.org,
        grant.jung@samsung.com, sc.suh@samsung.com, hy50.seo@samsung.com,
        sh425.lee@samsung.com, bhoon95.kim@samsung.com
Cc:     Kiwoong Kim <kwmad.kim@samsung.com>
Subject: [PATCH v3 1/2] ufs: add a quirk not to use default unipro timeout
 values
Date:   Mon, 21 Dec 2020 10:24:40 +0900
Message-Id: <1fedd3dea0ccc980913a5995a10510d86a5b01b9.1608513782.git.kwmad.kim@samsung.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <cover.1608513782.git.kwmad.kim@samsung.com>
In-Reply-To: <cover.1608513782.git.kwmad.kim@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprDJsWRmVeSWpSXmKPExsWy7bCmue7T3/fjDQ5PsLB4MG8bm8XethPs
        Fi9/XmWzOPiwk8Xi69JnrBbTPvxktvi0fhmrxa+/69ktVi9+wGKx6MY2JoubW46yWHRf38Fm
        sfz4PyaLrrs3GC2W/nvL4sDvcfmKt8flvl4mjwmLDjB6fF/fwebx8ektFo++LasYPT5vkvNo
        P9DNFMARlWOTkZqYklqkkJqXnJ+SmZduq+QdHO8cb2pmYKhraGlhrqSQl5ibaqvk4hOg65aZ
        A3S8kkJZYk4pUCggsbhYSd/Opii/tCRVISO/uMRWKbUgJafA0LBArzgxt7g0L10vOT/XytDA
        wMgUqDIhJ2POkrXsBf+lK66eeM3awLhCoouRg0NCwESif111FyMnh5DADkaJtkuKXYxcQPYn
        RolTK1rYIRKfGSVOrBAGsUHqZ2+eygpRtItR4tW9KVDOD0aJzxeWMINUsQloSjy9OZUJJCEi
        cIZJ4lrrWVaQBLOAusSuCSeYQFYLCwRLNH2NBzFZBFQlprxIA6ngFYiWODLhPyvEMjmJm+c6
        wUZyClhKtE5bx4TK5gKqmcshMWvGfEaIBheJw1O+MkPYwhKvjm9hh7ClJF72t0HZ9RL7pjaw
        QjT3MEo83fcPqtlYYtazdkaQg5iBHli/Sx8SQsoSR26xQFzPJ9Fx+C87RJhXoqNNCKJRWeLX
        pMlQQyQlZt68A7XJQ+LG5r1skOAB2vTm+RqmCYzysxAWLGBkXMUollpQnJueWmxUYIIcdZsY
        wclUy2MH4+y3H/QOMTJxMB5ilOBgVhLhNZO6Hy/Em5JYWZValB9fVJqTWnyI0RQYjhOZpUST
        84HpPK8k3tDUyMzMwNLUwtTMyEJJnDd0ZV+8kEB6YklqdmpqQWoRTB8TB6dUA5PK9gBtubgp
        eYuVNT8uubXvxCflOXbvXgaYL//mvrHIfZ3sr5rz8uu3vOsP4EqSklf7vUfH7nhp6GLFmyYl
        O6se3O869lvAV52BwWKWw+PJnAdvNffJJZ7S/XjGpZVhtnFxRJEq71mOO4s3PbyoM/lfb0JM
        buJ5vrogDw3R49t0J37tDLeMTD+hOe+3gpTA/Yez/23oiWx/P118IU/5j0XaMdmqO6dOKfpz
        xvDnaqkZFms1pY6rxrSwSL67ypnGb3IiKsNxI/dGkwv/Fk2wmH9dg3njnAbZvXJuf726okSi
        DtkZPrb/maXx9QLjmjkOE896qm28djJ9w6LJTjaM76MdRIo01zqZl2oH9bC17FJiKc5INNRi
        LipOBADJxcwPLwQAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrKLMWRmVeSWpSXmKPExsWy7bCSvO7T3/fjDeY8F7B4MG8bm8XethPs
        Fi9/XmWzOPiwk8Xi69JnrBbTPvxktvi0fhmrxa+/69ktVi9+wGKx6MY2JoubW46yWHRf38Fm
        sfz4PyaLrrs3GC2W/nvL4sDvcfmKt8flvl4mjwmLDjB6fF/fwebx8ektFo++LasYPT5vkvNo
        P9DNFMARxWWTkpqTWZZapG+XwJUxZ8la9oL/0hVXT7xmbWBcIdHFyMkhIWAiMXvzVNYuRi4O
        IYEdjBIXL+1jhEhISpzY+RzKFpa433IEqugbo8TmN6dYQRJsApoST29OZQJJiAjcY5K4NGEu
        M0iCWUBdYteEE0wgtrBAoMTE74dZuhg5OFgEVCWmvEgDCfMKREscmfCfFWKBnMTNc51grZwC
        lhKt09aBtQoJWEjcO/SUCZf4BEaBBYwMqxglUwuKc9Nziw0LjPJSy/WKE3OLS/PS9ZLzczcx
        gmNCS2sH455VH/QOMTJxMB5ilOBgVhLhNZO6Hy/Em5JYWZValB9fVJqTWnyIUZqDRUmc90LX
        yXghgfTEktTs1NSC1CKYLBMHp1QDU9mpiCuPWedd6tzzWrjf8IHg/iBOi07xpp0XFY0KxfJy
        L+6UNeELS6kVu6MQLMHoXFdi+X95ixS/wD/JmeqBFfLhGxb9Zs6QU5vfNu9bdTRTas+mwE3L
        EjlVpTYWK3M9exLuLnogt8WFY4rvi3SvEgfWz7ybco6t4fe3Dubb3aZ+2Tao+tNO966FBRuY
        ru2qYf/IblEu1yW++qbSrYvK2e7dHxb5H/ylsWPbkUNtHBxaPj5dryadXHrt1/VrylrBZekO
        mwNeWN+5U3dA9nqgyZeqnrhjE9jYczfuyl/4cOMLq0yHgyGNh1MivscecdUMKwkSVLjI9WBC
        eqrlpiPScZNZQ9c1b/pgofb+YrESS3FGoqEWc1FxIgD83o8o+AIAAA==
X-CMS-MailID: 20201221013533epcas2p2b4a9931d56ebd626a0fbc0490ac129c1
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
CMS-TYPE: 102P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20201221013533epcas2p2b4a9931d56ebd626a0fbc0490ac129c1
References: <cover.1608513782.git.kwmad.kim@samsung.com>
        <CGME20201221013533epcas2p2b4a9931d56ebd626a0fbc0490ac129c1@epcas2p2.samsung.com>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Unipro specification says attribute IDs of the following
thing are vendor-specific values, so some SoCs could have
no regions at the defined addresses
- DME_LocalFC0ProtectionTimeOutVal
- DME_LocalTC0ReplayTimeOutVal
- DME_LocalAFC0ReqTimeOutVal

The following things should be set considering the compatibility
between host and device, so those values must not be fixed and
you could use reset values or vendor specific values
- PA_PWRMODEUSERDATA0
- PA_PWRMODEUSERDATA1
- PA_PWRMODEUSERDATA2
- PA_PWRMODEUSERDATA3
- PA_PWRMODEUSERDATA4
- PA_PWRMODEUSERDATA5

Signed-off-by: Kiwoong Kim <kwmad.kim@samsung.com>
---
 drivers/scsi/ufs/ufshcd.c | 40 +++++++++++++++++++++-------------------
 drivers/scsi/ufs/ufshcd.h |  6 ++++++
 2 files changed, 27 insertions(+), 19 deletions(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 92d433d..9d3a41d 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -4153,25 +4153,27 @@ static int ufshcd_change_power_mode(struct ufs_hba *hba,
 		ufshcd_dme_set(hba, UIC_ARG_MIB(PA_HSSERIES),
 						pwr_mode->hs_rate);
 
-	ufshcd_dme_set(hba, UIC_ARG_MIB(PA_PWRMODEUSERDATA0),
-			DL_FC0ProtectionTimeOutVal_Default);
-	ufshcd_dme_set(hba, UIC_ARG_MIB(PA_PWRMODEUSERDATA1),
-			DL_TC0ReplayTimeOutVal_Default);
-	ufshcd_dme_set(hba, UIC_ARG_MIB(PA_PWRMODEUSERDATA2),
-			DL_AFC0ReqTimeOutVal_Default);
-	ufshcd_dme_set(hba, UIC_ARG_MIB(PA_PWRMODEUSERDATA3),
-			DL_FC1ProtectionTimeOutVal_Default);
-	ufshcd_dme_set(hba, UIC_ARG_MIB(PA_PWRMODEUSERDATA4),
-			DL_TC1ReplayTimeOutVal_Default);
-	ufshcd_dme_set(hba, UIC_ARG_MIB(PA_PWRMODEUSERDATA5),
-			DL_AFC1ReqTimeOutVal_Default);
-
-	ufshcd_dme_set(hba, UIC_ARG_MIB(DME_LocalFC0ProtectionTimeOutVal),
-			DL_FC0ProtectionTimeOutVal_Default);
-	ufshcd_dme_set(hba, UIC_ARG_MIB(DME_LocalTC0ReplayTimeOutVal),
-			DL_TC0ReplayTimeOutVal_Default);
-	ufshcd_dme_set(hba, UIC_ARG_MIB(DME_LocalAFC0ReqTimeOutVal),
-			DL_AFC0ReqTimeOutVal_Default);
+	if (!(hba->quirks & UFSHCD_QUIRK_SKIP_DEF_UNIPRO_TIMEOUT_SETTING)) {
+		ufshcd_dme_set(hba, UIC_ARG_MIB(PA_PWRMODEUSERDATA0),
+				DL_FC0ProtectionTimeOutVal_Default);
+		ufshcd_dme_set(hba, UIC_ARG_MIB(PA_PWRMODEUSERDATA1),
+				DL_TC0ReplayTimeOutVal_Default);
+		ufshcd_dme_set(hba, UIC_ARG_MIB(PA_PWRMODEUSERDATA2),
+				DL_AFC0ReqTimeOutVal_Default);
+		ufshcd_dme_set(hba, UIC_ARG_MIB(PA_PWRMODEUSERDATA3),
+				DL_FC1ProtectionTimeOutVal_Default);
+		ufshcd_dme_set(hba, UIC_ARG_MIB(PA_PWRMODEUSERDATA4),
+				DL_TC1ReplayTimeOutVal_Default);
+		ufshcd_dme_set(hba, UIC_ARG_MIB(PA_PWRMODEUSERDATA5),
+				DL_AFC1ReqTimeOutVal_Default);
+
+		ufshcd_dme_set(hba, UIC_ARG_MIB(DME_LocalFC0ProtectionTimeOutVal),
+				DL_FC0ProtectionTimeOutVal_Default);
+		ufshcd_dme_set(hba, UIC_ARG_MIB(DME_LocalTC0ReplayTimeOutVal),
+				DL_TC0ReplayTimeOutVal_Default);
+		ufshcd_dme_set(hba, UIC_ARG_MIB(DME_LocalAFC0ReqTimeOutVal),
+				DL_AFC0ReqTimeOutVal_Default);
+	}
 
 	ret = ufshcd_uic_change_pwr_mode(hba, pwr_mode->pwr_rx << 4
 			| pwr_mode->pwr_tx);
diff --git a/drivers/scsi/ufs/ufshcd.h b/drivers/scsi/ufs/ufshcd.h
index 61344c4..f36f73c8 100644
--- a/drivers/scsi/ufs/ufshcd.h
+++ b/drivers/scsi/ufs/ufshcd.h
@@ -549,6 +549,12 @@ enum ufshcd_quirks {
 	 */
 	UFSHCI_QUIRK_SKIP_MANUAL_WB_FLUSH_CTRL		= 1 << 12,
 
+	/*
+	 * This quirk needs to disable unipro timeout values
+	 * before power mode change
+	 */
+	UFSHCD_QUIRK_SKIP_DEF_UNIPRO_TIMEOUT_SETTING = 1 << 13,
+
 };
 
 enum ufshcd_caps {
-- 
2.7.4

