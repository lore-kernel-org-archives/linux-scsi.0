Return-Path: <SRS0=GT1C=7K=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6DB9CC433E1
	for <linux-scsi@archiver.kernel.org>; Thu, 28 May 2020 01:33:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 404CB20C56
	for <linux-scsi@archiver.kernel.org>; Thu, 28 May 2020 01:33:19 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="XDH9WqF2"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726487AbgE1Bcg (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 27 May 2020 21:32:36 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:50090 "EHLO
        mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726477AbgE1Bce (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 27 May 2020 21:32:34 -0400
Received: from epcas5p3.samsung.com (unknown [182.195.41.41])
        by mailout3.samsung.com (KnoxPortal) with ESMTP id 20200528013230epoutp031e88f9f341cdcb8d928c439b80532519~TDSYr0CcH0196701967epoutp03G
        for <linux-scsi@vger.kernel.org>; Thu, 28 May 2020 01:32:30 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com 20200528013230epoutp031e88f9f341cdcb8d928c439b80532519~TDSYr0CcH0196701967epoutp03G
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1590629551;
        bh=kDIy4u6dKypJDeZVrGE9ZKceZgeyPXJh8PvB97xxnQM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XDH9WqF2XVgv2fAZSobHV0jEBZUg8zUWP5CmPHMWcs6ObsFvSHqaWXeqCC1cZ8HF2
         D86OE99ZsZFARwE9Z3yH/0aL4UDN2pfO3ldUviJrvVr+ikKNhelfIPCTAD3a8Udelh
         Ve1qpNjCl6D8FJhZpTjjEHmSmXhvUQ4bCS5mwNC0=
Received: from epsmges5p3new.samsung.com (unknown [182.195.42.75]) by
        epcas5p3.samsung.com (KnoxPortal) with ESMTP id
        20200528013230epcas5p3487c2ce9cf64332b7a97d2e003ac2ace~TDSYNiVkK2924029240epcas5p36;
        Thu, 28 May 2020 01:32:30 +0000 (GMT)
Received: from epcas5p1.samsung.com ( [182.195.41.39]) by
        epsmges5p3new.samsung.com (Symantec Messaging Gateway) with SMTP id
        42.B2.09475.EA41FCE5; Thu, 28 May 2020 10:32:30 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
        epcas5p3.samsung.com (KnoxPortal) with ESMTPA id
        20200528013230epcas5p37b2d1980cfccf593242bef11e2076eb8~TDSX9DSz42924029240epcas5p33;
        Thu, 28 May 2020 01:32:30 +0000 (GMT)
Received: from epsmgms1p2.samsung.com (unknown [182.195.42.42]) by
        epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20200528013230epsmtrp24c836ade0f2ab2669f265b3f7e59d5f7~TDSX74IUM2107921079epsmtrp2i;
        Thu, 28 May 2020 01:32:30 +0000 (GMT)
X-AuditID: b6c32a4b-389ff70000002503-2b-5ecf14aee359
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
        epsmgms1p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        F9.77.08303.EA41FCE5; Thu, 28 May 2020 10:32:30 +0900 (KST)
Received: from Jaguar.sa.corp.samsungelectronics.net (unknown
        [107.108.73.139]) by epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
        20200528013228epsmtip14739227217a187ab1d3a87e17bf3f7ad~TDSWEnZGp1533515335epsmtip1V;
        Thu, 28 May 2020 01:32:28 +0000 (GMT)
From:   Alim Akhtar <alim.akhtar@samsung.com>
To:     robh@kernel.org
Cc:     devicetree@vger.kernel.org, linux-scsi@vger.kernel.org,
        krzk@kernel.org, avri.altman@wdc.com, martin.petersen@oracle.com,
        kwmad.kim@samsung.com, stanley.chu@mediatek.com,
        cang@codeaurora.org, linux-samsung-soc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Alim Akhtar <alim.akhtar@samsung.com>
Subject: [PATCH v10 03/10] scsi: ufs: add quirk to enable host controller
 without hce
Date:   Thu, 28 May 2020 06:46:51 +0530
Message-Id: <20200528011658.71590-4-alim.akhtar@samsung.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200528011658.71590-1-alim.akhtar@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpileLIzCtJLcpLzFFi42LZdlhTXXedyPk4gzO3JC0ezNvGZvHy51U2
        i0/rl7FazD9yjtXi/PkN7BY3txxlsdj0+BqrxeVdc9gsZpzfx2TRfX0Hm8Xy4/+YLP7v2cFu
        sXTrTUYHXo/Lfb1MHptWdbJ5bF5S79Fycj+Lx8ent1g8+rasYvT4vEnOo/1AN1MARxSXTUpq
        TmZZapG+XQJXxqwXh9gKNshVNDV+YWpgPCXRxcjJISFgIrG1/wRzFyMXh5DAbkaJp1c2M0I4
        nxglPv16zgLhfGaUWHx3KQtMy8zn19khErsYJZYunQbV0sIk8eXLRFaQKjYBbYm707cwgdgi
        AsISR761MYLYzAI3mCQerHQBsYUFwiWatsxnA7FZBFQl/pxbyQ5i8wrYSJzsaYfaJi+xesMB
        oAM5ODgFbCX2TnAA2SUh0Mohsej7FEaQuISAi8SRo9oQ5cISr45vYYewpSQ+v9vLBlGSLdGz
        yxgiXCOxdN4xqOn2EgeuzGEBKWEW0JRYv0sf4kg+id7fT5ggOnklOtqEIKpVJZrfXYXqlJaY
        2N3NCmF7SFx6PB0aVBMYJc5NXM88gVF2FsLUBYyMqxglUwuKc9NTi00LjPNSy/WKE3OLS/PS
        9ZLzczcxgpOJlvcOxkcPPugdYmTiYDzEKMHBrCTC63T2dJwQb0piZVVqUX58UWlOavEhRmkO
        FiVxXqUfZ+KEBNITS1KzU1MLUotgskwcnFINTHE108zkT5aznIr0uHfNZF5ymdMu4S8lydty
        pp7SUso7bVhiWrRNRGT74g+byo8min7dP+vquZ+sPm/q9qVfrdjv2xz3hP2MwOPH8s732srD
        EsS/6by3krxx99chPTNvXe8W/zfvf8nZnJ00kzu+5GEzw/y+76v+3TzuIdiQsbEz/W+S8HnW
        OxcYY7/LvJ64VU/6wBrhWfGfj2zhNf+887NqjcbC2X5/IqYyXhCZ1f/4hmKfSPOrZB+T8Dmd
        PE7yl2r8HL+Z7vRvnP2M27mIzUzJ+/Pb019ZfDl3TOY7fORVXqXQlnfibzkEpu2pKPjlOyk3
        tu0663ullQ1dmYaJ/4pL8g3Zo9heH/jU7MLQo8RSnJFoqMVcVJwIAMJkcpuVAwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrELMWRmVeSWpSXmKPExsWy7bCSnO46kfNxBpMWs1g8mLeNzeLlz6ts
        Fp/WL2O1mH/kHKvF+fMb2C1ubjnKYrHp8TVWi8u75rBZzDi/j8mi+/oONovlx/8xWfzfs4Pd
        YunWm4wOvB6X+3qZPDat6mTz2Lyk3qPl5H4Wj49Pb7F49G1ZxejxeZOcR/uBbqYAjigum5TU
        nMyy1CJ9uwSujFkvDrEVbJCraGr8wtTAeEqii5GTQ0LARGLm8+vsXYxcHEICOxgldnxfwwSR
        kJa4vnECO4QtLLHy33OooiYmiT+vDjCDJNgEtCXuTt8C1iACVHTkWxsjiM0s8IxJ4tTDUhBb
        WCBUYsX8LrBBLAKqEn/OrQSzeQVsJE72tLNALJCXWL0BZCYHB6eArcTeCQ4gYSGgkgmr9jJO
        YORbwMiwilEytaA4Nz232LDAKC+1XK84Mbe4NC9dLzk/dxMjOJi1tHYw7ln1Qe8QIxMH4yFG
        CQ5mJRFep7On44R4UxIrq1KL8uOLSnNSiw8xSnOwKInzfp21ME5IID2xJDU7NbUgtQgmy8TB
        KdXANFVO3uT3Lo5pwbw9l666Wud31e3apuHI3nTm/9szuunyk9jip+iL+bVbr3xh49TyJMNz
        0b+vncvPv9WpfcN+bMaZrrMr5Fo+r5Gb+3lftm3J92Ihtzjxk1/9psl9+jlnV11owvawcy6O
        txynr65crn1bKW/L3fdffu+2467Weibez2B2ii3oq7W2Qc+KQHWh+TmXAwt9qyv+Les8sbf9
        +ZIH66S+fpmw4IbWZJte/SKPXA7WC5LLpv+/XfrZKcnG2PuHUO70ivkibYX1hcv3PdqTvMCw
        WLYgcWMM78wjV81EQkV2dC15HOK7anGN1cPPxpzn7ly9XM1d8I/b0V97lVa691KviFDu2JAn
        PCJCSizFGYmGWsxFxYkA+hkfH9UCAAA=
X-CMS-MailID: 20200528013230epcas5p37b2d1980cfccf593242bef11e2076eb8
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
CMS-TYPE: 105P
X-CMS-RootMailID: 20200528013230epcas5p37b2d1980cfccf593242bef11e2076eb8
References: <20200528011658.71590-1-alim.akhtar@samsung.com>
        <CGME20200528013230epcas5p37b2d1980cfccf593242bef11e2076eb8@epcas5p3.samsung.com>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Some host controllers don't support host controller enable via HCE.

Reviewed-by: Can Guo <cang@codeaurora.org>
Reviewed-by: Avri Altman <avri.altman@wdc.com>
Signed-off-by: Seungwon Jeon <essuuj@gmail.com>
Signed-off-by: Alim Akhtar <alim.akhtar@samsung.com>
---
 drivers/scsi/ufs/ufshcd.c | 76 +++++++++++++++++++++++++++++++++++++--
 drivers/scsi/ufs/ufshcd.h |  6 ++++
 2 files changed, 80 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 0e9704da58bd..ee30ed6cc805 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -3534,6 +3534,52 @@ static int ufshcd_dme_link_startup(struct ufs_hba *hba)
 			"dme-link-startup: error code %d\n", ret);
 	return ret;
 }
+/**
+ * ufshcd_dme_reset - UIC command for DME_RESET
+ * @hba: per adapter instance
+ *
+ * DME_RESET command is issued in order to reset UniPro stack.
+ * This function now deal with cold reset.
+ *
+ * Returns 0 on success, non-zero value on failure
+ */
+static int ufshcd_dme_reset(struct ufs_hba *hba)
+{
+	struct uic_command uic_cmd = {0};
+	int ret;
+
+	uic_cmd.command = UIC_CMD_DME_RESET;
+
+	ret = ufshcd_send_uic_cmd(hba, &uic_cmd);
+	if (ret)
+		dev_err(hba->dev,
+			"dme-reset: error code %d\n", ret);
+
+	return ret;
+}
+
+/**
+ * ufshcd_dme_enable - UIC command for DME_ENABLE
+ * @hba: per adapter instance
+ *
+ * DME_ENABLE command is issued in order to enable UniPro stack.
+ *
+ * Returns 0 on success, non-zero value on failure
+ */
+static int ufshcd_dme_enable(struct ufs_hba *hba)
+{
+	struct uic_command uic_cmd = {0};
+	int ret;
+
+	uic_cmd.command = UIC_CMD_DME_ENABLE;
+
+	ret = ufshcd_send_uic_cmd(hba, &uic_cmd);
+	if (ret)
+		dev_err(hba->dev,
+			"dme-reset: error code %d\n", ret);
+
+	return ret;
+}
 
 static inline void ufshcd_add_delay_before_dme_cmd(struct ufs_hba *hba)
 {
@@ -4251,7 +4297,7 @@ static inline void ufshcd_hba_stop(struct ufs_hba *hba, bool can_sleep)
 }
 
 /**
- * ufshcd_hba_enable - initialize the controller
+ * ufshcd_hba_execute_hce - initialize the controller
  * @hba: per adapter instance
  *
  * The controller resets itself and controller firmware initialization
@@ -4260,7 +4306,7 @@ static inline void ufshcd_hba_stop(struct ufs_hba *hba, bool can_sleep)
  *
  * Returns 0 on success, non-zero value on failure
  */
-int ufshcd_hba_enable(struct ufs_hba *hba)
+static int ufshcd_hba_execute_hce(struct ufs_hba *hba)
 {
 	int retry;
 
@@ -4308,6 +4354,32 @@ int ufshcd_hba_enable(struct ufs_hba *hba)
 
 	return 0;
 }
+
+int ufshcd_hba_enable(struct ufs_hba *hba)
+{
+	int ret;
+
+	if (hba->quirks & UFSHCI_QUIRK_BROKEN_HCE) {
+		ufshcd_set_link_off(hba);
+		ufshcd_vops_hce_enable_notify(hba, PRE_CHANGE);
+
+		/* enable UIC related interrupts */
+		ufshcd_enable_intr(hba, UFSHCD_UIC_MASK);
+		ret = ufshcd_dme_reset(hba);
+		if (!ret) {
+			ret = ufshcd_dme_enable(hba);
+			if (!ret)
+				ufshcd_vops_hce_enable_notify(hba, POST_CHANGE);
+			if (ret)
+				dev_err(hba->dev,
+					"Host controller enable failed with non-hce\n");
+		}
+	} else {
+		ret = ufshcd_hba_execute_hce(hba);
+	}
+
+	return ret;
+}
 EXPORT_SYMBOL_GPL(ufshcd_hba_enable);
 
 static int ufshcd_disable_tx_lcc(struct ufs_hba *hba, bool peer)
diff --git a/drivers/scsi/ufs/ufshcd.h b/drivers/scsi/ufs/ufshcd.h
index 53096642f9a8..f8d08cb9caf7 100644
--- a/drivers/scsi/ufs/ufshcd.h
+++ b/drivers/scsi/ufs/ufshcd.h
@@ -529,6 +529,12 @@ enum ufshcd_quirks {
 	 * that the interrupt aggregation timer and counter are reset by s/w.
 	 */
 	UFSHCI_QUIRK_SKIP_RESET_INTR_AGGR		= 1 << 7,
+
+	/*
+	 * This quirks needs to be enabled if host controller cannot be
+	 * enabled via HCE register.
+	 */
+	UFSHCI_QUIRK_BROKEN_HCE				= 1 << 8,
 };
 
 enum ufshcd_caps {
-- 
2.17.1

