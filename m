Return-Path: <SRS0=19hD=BA=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 29CFEC433EA
	for <linux-scsi@archiver.kernel.org>; Tue, 21 Jul 2020 09:56:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 04ACD20729
	for <linux-scsi@archiver.kernel.org>; Tue, 21 Jul 2020 09:56:56 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="tWs6bCvx"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729081AbgGUJ4z (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 21 Jul 2020 05:56:55 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:35428 "EHLO
        mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726188AbgGUJ4y (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 21 Jul 2020 05:56:54 -0400
Received: from epcas2p3.samsung.com (unknown [182.195.41.55])
        by mailout2.samsung.com (KnoxPortal) with ESMTP id 20200721095652epoutp02e60189da4542b9cae1188eb8a99e1727~jvAKtjZJB3265932659epoutp02Z
        for <linux-scsi@vger.kernel.org>; Tue, 21 Jul 2020 09:56:52 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com 20200721095652epoutp02e60189da4542b9cae1188eb8a99e1727~jvAKtjZJB3265932659epoutp02Z
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1595325412;
        bh=pj2Pzo6iSbBr4ooSY6SDbdkWoHZuW2p1oFSErEspwRA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tWs6bCvxD1Fb750VuJBXiVF/JTEe+h57W6zhsfNLb0BzukVS/ThQ3BNbtWkeq9Vsm
         KpXog07dyls59o4hB6Q0BfLrhPUs4PsH24kB4ipWQIPYyIuYaM+YPwnEMchZJ6vwga
         5Nci0L+ukaa9e9+90uHX7aNg6OFDSVZtaYZi72Bg=
Received: from epsnrtp4.localdomain (unknown [182.195.42.165]) by
        epcas2p3.samsung.com (KnoxPortal) with ESMTP id
        20200721095652epcas2p3a7d298bb4f4ab77bcbc0cce777e351bb~jvAKDeeio2048120481epcas2p3g;
        Tue, 21 Jul 2020 09:56:52 +0000 (GMT)
Received: from epsmges2p1.samsung.com (unknown [182.195.40.182]) by
        epsnrtp4.localdomain (Postfix) with ESMTP id 4B9vBn5x1BzMqYkY; Tue, 21 Jul
        2020 09:56:49 +0000 (GMT)
Received: from epcas2p2.samsung.com ( [182.195.41.54]) by
        epsmges2p1.samsung.com (Symantec Messaging Gateway) with SMTP id
        51.F1.19322.0EBB61F5; Tue, 21 Jul 2020 18:56:48 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
        epcas2p1.samsung.com (KnoxPortal) with ESMTPA id
        20200721095648epcas2p18c3d496076ecd1537e47081c19dbb97e~jvAHAXLMA1027410274epcas2p1Z;
        Tue, 21 Jul 2020 09:56:48 +0000 (GMT)
Received: from epsmgms1p2.samsung.com (unknown [182.195.42.42]) by
        epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20200721095648epsmtrp123df3627a0e4239c399e5a6bd380cea9~jvAG-t55n3088630886epsmtrp10;
        Tue, 21 Jul 2020 09:56:48 +0000 (GMT)
X-AuditID: b6c32a45-7adff70000004b7a-c6-5f16bbe00fbe
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
        epsmgms1p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        F5.3A.08303.0EBB61F5; Tue, 21 Jul 2020 18:56:48 +0900 (KST)
Received: from rack03.dsn.sec.samsung.com (unknown [12.36.155.109]) by
        epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
        20200721095648epsmtip2728182b7a523aa64fc426264cf70f1a4~jvAGzoqb50305103051epsmtip21;
        Tue, 21 Jul 2020 09:56:48 +0000 (GMT)
From:   SEO HOYOUNG <hy50.seo@samsung.com>
To:     linux-scsi@vger.kernel.org, alim.akhtar@samsung.com,
        avri.altman@wdc.com, jejb@linux.ibm.com,
        martin.petersen@oracle.com, beanhuo@micron.com,
        asutoshd@codeaurora.org, cang@codeaurora.org, bvanassche@acm.org,
        grant.jung@samsung.com
Cc:     SEO HOYOUNG <hy50.seo@samsung.com>
Subject: [RFC PATCH v3 1/3] scsi: ufs: modify write booster
Date:   Tue, 21 Jul 2020 18:57:10 +0900
Message-Id: <90ad671ed4a2b4f6035e9858153a13f7c00a1904.1595325064.git.hy50.seo@samsung.com>
X-Mailer: git-send-email 2.26.0
In-Reply-To: <cover.1595325064.git.hy50.seo@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrPJsWRmVeSWpSXmKPExsWy7bCmme6D3WLxBr/uWVs8mLeNzWJv2wl2
        i5c/r7JZHHzYyWIx7cNPZotP65exWvz6u57dYvXiBywWi25sY7Lovr6DzWL58X9MDtwel694
        e1zu62XymLDoAKPH9/UdbB4fn95i8ejbsorR4/MmOY/2A91MARxROTYZqYkpqUUKqXnJ+SmZ
        eem2St7B8c7xpmYGhrqGlhbmSgp5ibmptkouPgG6bpk5QIcqKZQl5pQChQISi4uV9O1sivJL
        S1IVMvKLS2yVUgtScgoMDQv0ihNzi0vz0vWS83OtDA0MjEyBKhNyMqb+msRYsE+94ubEPYwN
        jDsUuhg5OSQETCQmv17G1sXIxSEksINR4vOxeywQzidGicWL9zNCOJ8ZJbavbWOGaXmw8hwb
        iC0ksItRYv2EBIiiH4wSL96/ZAFJsAloSKw5dogJJCEi8IFR4uiK2awgCWYBNYnPd5eBFQkL
        WEusPr4VLM4ioCpxcd8csA28AlESXbePsUBsk5dY1PCbCcTmFLCQODv7PDtEjaDEyZlPWCBm
        yks0b53NDLJMQmAuh8S0R7vZIZpdJE5PXsIKYQtLvDq+BSouJfGyvw3KrpeYcm8VC0RzD6PE
        nhUnmCASxhKznrUDA4ADaIOmxPpd+iCmhICyxJFbUHv5JDoO/2WHCPNKdLQJQTQqSZyZexsq
        LCFxcHYORNhDovfQEnZIWHUzSpz+sJ9tAqPCLCTfzELyzSyEvQsYmVcxiqUWFOempxYbFRgi
        x/AmRnDK1XLdwTj57Qe9Q4xMHIyHGCU4mJVEeCfyCMcL8aYkVlalFuXHF5XmpBYfYjQFhvVE
        ZinR5Hxg0s8riTc0NTIzM7A0tTA1M7JQEufNVbwQJySQnliSmp2aWpBaBNPHxMEp1cCk3+np
        z+cf6FCda/9XfvozR1bmvEe18Vn3X5ic96pPtFMNOZP78V2y+J3u3x57zXbaPL5ceHp7hOlC
        hQLXezplj24xXRDbePR1MVPP2hc+G+v0s0xNM0oWLdRfsf3NMf+PktXLTk1erZYhVXTMf8ep
        ++vq7UrX3NBWSWXc0SM01fgL+/y8bb6T9q88xX2wxHhK6J9vvCt+uZ3V2pSj9PrbEmuTo6Wz
        5jv7Z/9OSza9f7EuLiU/kNerSP7fjOecr6QE5s5+bi8bkeGe4eh9o/mF74HDnBnzlO8dE7iv
        H6l/wtv2RdaOl63yB2e+efC/SPbLCxPhlgbd/dEfzskfsTxvbvyu/aHfuicb1v+S/35OiaU4
        I9FQi7moOBEAvcDEP0IEAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrBLMWRmVeSWpSXmKPExsWy7bCSvO6D3WLxBtuXaFo8mLeNzWJv2wl2
        i5c/r7JZHHzYyWIx7cNPZotP65exWvz6u57dYvXiBywWi25sY7Lovr6DzWL58X9MDtwel694
        e1zu62XymLDoAKPH9/UdbB4fn95i8ejbsorR4/MmOY/2A91MARxRXDYpqTmZZalF+nYJXBlT
        f01iLNinXnFz4h7GBsYdCl2MnBwSAiYSD1aeY+ti5OIQEtjBKDHrzBd2iISExP/FTUwQtrDE
        /ZYjrBBF3xglvh9qZQVJsAloSKw5dgisSETgD6PEpNNxIDazgJrE57vLWEBsYQFridXHt4LV
        swioSlzcN4cZxOYViJLoun2MBWKBvMSiht9gczgFLCTOzj4PdAQH0DJzidlXCyHKBSVOznzC
        AjFeXqJ562zmCYwCs5CkZiFJLWBkWsUomVpQnJueW2xYYJSXWq5XnJhbXJqXrpecn7uJERwZ
        Wlo7GPes+qB3iJGJg/EQowQHs5II70Qe4Xgh3pTEyqrUovz4otKc1OJDjNIcLErivF9nLYwT
        EkhPLEnNTk0tSC2CyTJxcEo1MEm0NfIsrlLV+TfZZmWNP0NHqqnfzwqW6Jzg0F++l6ctc65J
        nXN/Tc2diZr9cVv+Xcje4baDqaj2EmecrIfXY99zT3S1yiZ8Sfn68mXJ/hkffp6pnbblSaJC
        cOZqDdHd9nttd9V/eunImSa2br/GAbWlxdy/bn163/TV+MgBQe5XvS/ePn3BOmnJ+lVlr/p2
        nRJZejhlpct9S32WyAVJZ9Y4H5kpnX6dK/eCd+m1C56vj3PKWGzkDebsjr9RWpO944LEZyYe
        98c/5jUey9N4uXqT6QbbNL0HweGVly1Pn3Blq2jz1z69Ub5/SduVCbyRxRoMnx6uTWDa/XK+
        c/VknuiHXlbV0xbLF8jbh5/h3aLEUpyRaKjFXFScCACzzpPb+wIAAA==
X-CMS-MailID: 20200721095648epcas2p18c3d496076ecd1537e47081c19dbb97e
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
CMS-TYPE: 102P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20200721095648epcas2p18c3d496076ecd1537e47081c19dbb97e
References: <cover.1595325064.git.hy50.seo@samsung.com>
        <CGME20200721095648epcas2p18c3d496076ecd1537e47081c19dbb97e@epcas2p1.samsung.com>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Add vendor specific functions for WB
Use callback additional setting when use write booster.

Signed-off-by: SEO HOYOUNG <hy50.seo@samsung.com>
---
 drivers/scsi/ufs/ufshcd.c | 22 +++++++++++++++-----
 drivers/scsi/ufs/ufshcd.h | 43 +++++++++++++++++++++++++++++++++++++++
 2 files changed, 60 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index efc0a6cbfe22..9261519e7e9a 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -3306,11 +3306,11 @@ int ufshcd_read_string_desc(struct ufs_hba *hba, u8 desc_index,
  *
  * Return 0 in case of success, non-zero otherwise
  */
-static inline int ufshcd_read_unit_desc_param(struct ufs_hba *hba,
-					      int lun,
-					      enum unit_desc_param param_offset,
-					      u8 *param_read_buf,
-					      u32 param_size)
+int ufshcd_read_unit_desc_param(struct ufs_hba *hba,
+				int lun,
+				enum unit_desc_param param_offset,
+				u8 *param_read_buf,
+				u32 param_size)
 {
 	/*
 	 * Unit descriptors are only available for general purpose LUs (LUN id
@@ -3322,6 +3322,7 @@ static inline int ufshcd_read_unit_desc_param(struct ufs_hba *hba,
 	return ufshcd_read_desc_param(hba, QUERY_DESC_IDN_UNIT, lun,
 				      param_offset, param_read_buf, param_size);
 }
+EXPORT_SYMBOL_GPL(ufshcd_read_unit_desc_param);
 
 static int ufshcd_get_ref_clk_gating_wait(struct ufs_hba *hba)
 {
@@ -5257,6 +5258,10 @@ static int ufshcd_wb_ctrl(struct ufs_hba *hba, bool enable)
 
 	if (!(enable ^ hba->wb_enabled))
 		return 0;
+
+	if (!ufshcd_wb_ctrl_vendor(hba, enable))
+		return 0;
+
 	if (enable)
 		opcode = UPIU_QUERY_OPCODE_SET_FLAG;
 	else
@@ -6610,6 +6615,8 @@ static int ufshcd_reset_and_restore(struct ufs_hba *hba)
 	int err = 0;
 	int retries = MAX_HOST_RESET_RETRIES;
 
+	ufshcd_reset_vendor(hba);
+
 	do {
 		/* Reset the attached device */
 		ufshcd_vops_device_reset(hba);
@@ -6903,6 +6910,9 @@ static void ufshcd_wb_probe(struct ufs_hba *hba, u8 *desc_buf)
 	if (!(dev_info->d_ext_ufs_feature_sup & UFS_DEV_WRITE_BOOSTER_SUP))
 		goto wb_disabled;
 
+	if (!ufshcd_wb_alloc_units_vendor(hba))
+		return;
+
 	/*
 	 * WB may be supported but not configured while provisioning.
 	 * The spec says, in dedicated wb buffer mode,
@@ -8273,6 +8283,8 @@ static int ufshcd_suspend(struct ufs_hba *hba, enum ufs_pm_op pm_op)
 			ufshcd_wb_need_flush(hba));
 	}
 
+	ufshcd_wb_toggle_flush_vendor(hba, pm_op);
+
 	if (req_dev_pwr_mode != hba->curr_dev_pwr_mode) {
 		if ((ufshcd_is_runtime_pm(pm_op) && !hba->auto_bkops_enabled) ||
 		    !ufshcd_is_runtime_pm(pm_op)) {
diff --git a/drivers/scsi/ufs/ufshcd.h b/drivers/scsi/ufs/ufshcd.h
index 656c0691c858..deb9577e0eaa 100644
--- a/drivers/scsi/ufs/ufshcd.h
+++ b/drivers/scsi/ufs/ufshcd.h
@@ -254,6 +254,13 @@ struct ufs_pwr_mode_info {
 	struct ufs_pa_layer_attr info;
 };
 
+struct ufs_wb_ops {
+	int (*wb_toggle_flush_vendor)(struct ufs_hba *hba, enum ufs_pm_op pm_op);
+	int (*wb_alloc_units_vendor)(struct ufs_hba *hba);
+	int (*wb_ctrl_vendor)(struct ufs_hba *hba, bool enable);
+	int (*wb_reset_vendor)(struct ufs_hba *hba, bool force);
+};
+
 /**
  * struct ufs_hba_variant_ops - variant specific callbacks
  * @name: variant name
@@ -752,6 +759,7 @@ struct ufs_hba {
 	struct request_queue	*bsg_queue;
 	bool wb_buf_flush_enabled;
 	bool wb_enabled;
+	struct ufs_wb_ops *wb_ops;
 	struct delayed_work rpm_dev_flush_recheck_work;
 
 #ifdef CONFIG_SCSI_UFS_CRYPTO
@@ -1004,6 +1012,10 @@ int ufshcd_exec_raw_upiu_cmd(struct ufs_hba *hba,
 			     u8 *desc_buff, int *buff_len,
 			     enum query_opcode desc_op);
 
+int ufshcd_read_unit_desc_param(struct ufs_hba *hba,
+				int lun, enum unit_desc_param param_offset,
+				u8 *param_read_buf, u32 param_size);
+
 /* Wrapper functions for safely calling variant operations */
 static inline const char *ufshcd_get_var_name(struct ufs_hba *hba)
 {
@@ -1181,4 +1193,35 @@ static inline u8 ufshcd_scsi_to_upiu_lun(unsigned int scsi_lun)
 int ufshcd_dump_regs(struct ufs_hba *hba, size_t offset, size_t len,
 		     const char *prefix);
 
+static inline int ufshcd_wb_toggle_flush_vendor(struct ufs_hba *hba, enum ufs_pm_op pm_op)
+{
+	if (!hba->wb_ops || !hba->wb_ops->wb_toggle_flush_vendor)
+		return -1;
+
+	return hba->wb_ops->wb_toggle_flush_vendor(hba, pm_op);
+}
+
+static int ufshcd_wb_alloc_units_vendor(struct ufs_hba *hba)
+{
+	if (!hba->wb_ops || !hba->wb_ops->wb_alloc_units_vendor)
+		return -1;
+
+	return hba->wb_ops->wb_alloc_units_vendor(hba);
+}
+
+static int ufshcd_wb_ctrl_vendor(struct ufs_hba *hba, bool enable)
+{
+	if (!hba->wb_ops || !hba->wb_ops->wb_ctrl_vendor)
+		return -1;
+
+	return hba->wb_ops->wb_ctrl_vendor(hba, enable);
+}
+
+static int ufshcd_reset_vendor(struct ufs_hba *hba)
+{
+	if (!hba->wb_ops || !hba->wb_ops->wb_reset_vendor)
+		return -1;
+
+	return hba->wb_ops->wb_reset_vendor(hba, false);
+}
 #endif /* End of Header */
-- 
2.26.0

