Return-Path: <SRS0=9DJi=72=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E9D0BC433E0
	for <linux-scsi@archiver.kernel.org>; Sat, 13 Jun 2020 03:04:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CADEB206F5
	for <linux-scsi@archiver.kernel.org>; Sat, 13 Jun 2020 03:04:50 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="bwwN0FW6"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726485AbgFMDEu (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 12 Jun 2020 23:04:50 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:45380 "EHLO
        mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726398AbgFMDEq (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 12 Jun 2020 23:04:46 -0400
Received: from epcas5p1.samsung.com (unknown [182.195.41.39])
        by mailout2.samsung.com (KnoxPortal) with ESMTP id 20200613030442epoutp02d3fae3c6f5c883f44b2dda9c14709195~X_3c1Xtit2744027440epoutp02u
        for <linux-scsi@vger.kernel.org>; Sat, 13 Jun 2020 03:04:42 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com 20200613030442epoutp02d3fae3c6f5c883f44b2dda9c14709195~X_3c1Xtit2744027440epoutp02u
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1592017482;
        bh=aZlGHc5xTiWwAyuHWOUJ6KyldBblFcw6DUpelUfBEa8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bwwN0FW6/dnxyAUFAqCbrxDiHDBzDzl8I8K0KDw2KZ5Vk/HQazObDWRiI5dKgQaOv
         G9+rDydS49SV85SfL6O4MKZA0fm+6IncOcWsDtYH29qvl0NUBRk4onyuTRDYJd/yNz
         ghhiuMy+p0CswQZCRFVCLKTg6pX+ecLCDwYyxsB8=
Received: from epsmges5p3new.samsung.com (unknown [182.195.42.75]) by
        epcas5p1.samsung.com (KnoxPortal) with ESMTP id
        20200613030441epcas5p19719f3023fcaaf11a11b54e14c35eec6~X_3cIQc3i1950519505epcas5p1D;
        Sat, 13 Jun 2020 03:04:41 +0000 (GMT)
Received: from epcas5p4.samsung.com ( [182.195.41.42]) by
        epsmges5p3new.samsung.com (Symantec Messaging Gateway) with SMTP id
        33.43.09475.94244EE5; Sat, 13 Jun 2020 12:04:41 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
        epcas5p1.samsung.com (KnoxPortal) with ESMTPA id
        20200613030440epcas5p121247d520b30ddca1a31b2d57bfc6b91~X_3bN1zKr3120931209epcas5p1Y;
        Sat, 13 Jun 2020 03:04:40 +0000 (GMT)
Received: from epsmgms1p2.samsung.com (unknown [182.195.42.42]) by
        epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20200613030440epsmtrp201a8ca9fdb6c075fd1f37b8ec3c12e8d~X_3bKVbLd2362123621epsmtrp2t;
        Sat, 13 Jun 2020 03:04:40 +0000 (GMT)
X-AuditID: b6c32a4b-389ff70000002503-b7-5ee44249e287
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
        epsmgms1p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        00.C4.08303.84244EE5; Sat, 13 Jun 2020 12:04:40 +0900 (KST)
Received: from Jaguar.sa.corp.samsungelectronics.net (unknown
        [107.108.73.139]) by epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
        20200613030438epsmtip268334da49cc409f5927505474ac332ec~X_3ZP7fba0568705687epsmtip2T;
        Sat, 13 Jun 2020 03:04:38 +0000 (GMT)
From:   Alim Akhtar <alim.akhtar@samsung.com>
To:     robh@kernel.org
Cc:     devicetree@vger.kernel.org, linux-scsi@vger.kernel.org,
        krzk@kernel.org, avri.altman@wdc.com, martin.petersen@oracle.com,
        kwmad.kim@samsung.com, stanley.chu@mediatek.com,
        cang@codeaurora.org, linux-samsung-soc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        kishon@ti.com, Alim Akhtar <alim.akhtar@samsung.com>
Subject: [RESEND PATCH v10 02/10] scsi: ufs: add quirk to disallow reset of
 interrupt aggregation
Date:   Sat, 13 Jun 2020 08:16:58 +0530
Message-Id: <20200613024706.27975-3-alim.akhtar@samsung.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200613024706.27975-1-alim.akhtar@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupmleLIzCtJLcpLzFFi42LZdlhTS9fT6UmcwfW5phYP5m1js3j58yqb
        xaf1y1gt5h85x2px4WkPm8X58xvYLW5uOcpisenxNVaLy7vmsFnMOL+PyaL7+g42i+XH/zFZ
        /N+zg91i6dabjA58Hpf7epk8Nq3qZPPYvKTeo+XkfhaPj09vsXj0bVnF6HH8xnYmj8+b5Dza
        D3QzBXBGcdmkpOZklqUW6dslcGVs2/2OreAWT8WE47eYGxgvc3UxcnJICJhI7Pv2ib2LkYtD
        SGA3o0TrrMVMIAkhgU+MErN/B0MkPjNKPO/rZ4Lp2Dx5KxtEYhejxIdnp5khnBYmietPVjKC
        VLEJaEvcnb4FrENEQFjiyLc2sDizwEsmiV2PCroYOTiEBZIl+pviQMIsAqoSJw4vYwWxeQVs
        JA5f3ssGsUxeYvWGA8wgNqeArcTB/wuYQHZJCMzkkOi/PI0ZoshFYuGTtSwQtrDEq+Nb2CFs
        KYnP70AGcQDZ2RI9u4whwjUSS+cdgyq3lzhwZQ4LSAmzgKbE+l36EFfySfT+fsIE0ckr0dEm
        BFGtKtH87ipUp7TExO5uVgjbQ2LnzGY2SLhNYJR497VwAqPsLIShCxgZVzFKphYU56anFpsW
        GOellusVJ+YWl+al6yXn525iBKcXLe8djI8efNA7xMjEwXiIUYKDWUmEV1D8YZwQb0piZVVq
        UX58UWlOavEhRmkOFiVxXqUfZ+KEBNITS1KzU1MLUotgskwcnFINTNo9ultPdliuUKrr7Whf
        JLj/6/PVrbr8mjO97rzrKVv1QX46i/vpdJ6W1xsKOF1WiqSXLhOt/CO0cPbXPR01D3U+Zydu
        f/JBlM3zadOazn1ahxe4MsQGfpzyWOF3S7Tx/qMVa257efY+/Z1i7m4ZvarhaOw9eUXeZfNv
        aFu/qfBZ9p+v2k1y8ynTPVfVd79rONi5Z91u+yWXzU2629W1N8l13PETKGJcK978bfE7jVre
        9jw3LfYj0XO3BPtssLwte0d6tV5Q3rzUsD1CMqxvvRmstb/t/7Bm7Qcr5/BtIqVbpLKysxX2
        XVvV7/VlycmylwZKXnuj3LqVtXZo6lR0zrTZ9/d/7I/E/RK7bn17pcRSnJFoqMVcVJwIAC6C
        +lmeAwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrHLMWRmVeSWpSXmKPExsWy7bCSvK6H05M4gwv7jC0ezNvGZvHy51U2
        i0/rl7FazD9yjtXiwtMeNovz5zewW9zccpTFYtPja6wWl3fNYbOYcX4fk0X39R1sFsuP/2Oy
        +L9nB7vF0q03GR34PC739TJ5bFrVyeaxeUm9R8vJ/SweH5/eYvHo27KK0eP4je1MHp83yXm0
        H+hmCuCM4rJJSc3JLEst0rdL4MrYtvsdW8EtnooJx28xNzBe5upi5OSQEDCR2Dx5K1sXIxeH
        kMAORolbr56zQySkJa5vnABlC0us/AcSBylqYpLovf+CBSTBJqAtcXf6FiYQWwSo6Mi3NkaQ
        ImaB70wSByZMYAZJCAskSjy8cg6sgUVAVeLE4WWsIDavgI3E4ct72SA2yEus3nAArJ5TwFbi
        4P8FYEOFgGp2H/3JOoGRbwEjwypGydSC4tz03GLDAqO81HK94sTc4tK8dL3k/NxNjOAg19La
        wbhn1Qe9Q4xMHIyHGCU4mJVEeAXFH8YJ8aYkVlalFuXHF5XmpBYfYpTmYFES5/06a2GckEB6
        YklqdmpqQWoRTJaJg1OqgUnqe+6RLf/tjXQmzEouTbhmunBVQNucI5x/9ySfXCB9gHFt7gc2
        Xr+GNc/KH/xex/5J/pnWbuEpS850eneEnW5b3F4SKy5zyud2Va3F7Ekh7+6nrp4o0pWksKHd
        91X9hZmHz35c3STeclh5w6bOOpGz3/Y6dewx2WFs/+ljouDbtbu+JN+0e3Hh7CfP/lWPJJlu
        2WXvsGuYEF2zt8DoZxv/YoN5Udl/uzZzmDNu/W+eUsXwq2b9NKVp+nePaEsXz62dc/l6uwdL
        w+GQZT+cfqeoHFiwtPGy573QwmiurKebDAKL897yOm+b8bjLx9vyiAPLh3Te/XwvWrZcPa9a
        forVhbHkqu+31hvlcyfufnRSiaU4I9FQi7moOBEAMTLlg+ECAAA=
X-CMS-MailID: 20200613030440epcas5p121247d520b30ddca1a31b2d57bfc6b91
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
CMS-TYPE: 105P
X-CMS-RootMailID: 20200613030440epcas5p121247d520b30ddca1a31b2d57bfc6b91
References: <20200613024706.27975-1-alim.akhtar@samsung.com>
        <CGME20200613030440epcas5p121247d520b30ddca1a31b2d57bfc6b91@epcas5p1.samsung.com>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Some host controllers support interrupt aggregation but don't allow
resetting counter and timer in software.

Reviewed-by: Avri Altman <avri.altman@wdc.com>
Signed-off-by: Seungwon Jeon <essuuj@gmail.com>
Signed-off-by: Alim Akhtar <alim.akhtar@samsung.com>
---
 drivers/scsi/ufs/ufshcd.c | 3 ++-
 drivers/scsi/ufs/ufshcd.h | 6 ++++++
 2 files changed, 8 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 3655b88fc862..0e9704da58bd 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -4884,7 +4884,8 @@ static irqreturn_t ufshcd_transfer_req_compl(struct ufs_hba *hba)
 	 * false interrupt if device completes another request after resetting
 	 * aggregation and before reading the DB.
 	 */
-	if (ufshcd_is_intr_aggr_allowed(hba))
+	if (ufshcd_is_intr_aggr_allowed(hba) &&
+	    !(hba->quirks & UFSHCI_QUIRK_SKIP_RESET_INTR_AGGR))
 		ufshcd_reset_intr_aggr(hba);
 
 	tr_doorbell = ufshcd_readl(hba, REG_UTP_TRANSFER_REQ_DOOR_BELL);
diff --git a/drivers/scsi/ufs/ufshcd.h b/drivers/scsi/ufs/ufshcd.h
index 071f0edf3f64..53096642f9a8 100644
--- a/drivers/scsi/ufs/ufshcd.h
+++ b/drivers/scsi/ufs/ufshcd.h
@@ -523,6 +523,12 @@ enum ufshcd_quirks {
 	 * Clear handling for transfer/task request list is just opposite.
 	 */
 	UFSHCI_QUIRK_BROKEN_REQ_LIST_CLR		= 1 << 6,
+
+	/*
+	 * This quirk needs to be enabled if host controller doesn't allow
+	 * that the interrupt aggregation timer and counter are reset by s/w.
+	 */
+	UFSHCI_QUIRK_SKIP_RESET_INTR_AGGR		= 1 << 7,
 };
 
 enum ufshcd_caps {
-- 
2.17.1

