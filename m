Return-Path: <SRS0=pIAL=BG=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 685CCC433E5
	for <linux-scsi@archiver.kernel.org>; Mon, 27 Jul 2020 12:17:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3C9272075D
	for <linux-scsi@archiver.kernel.org>; Mon, 27 Jul 2020 12:17:16 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="gil97Hy6"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727078AbgG0MRO (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 27 Jul 2020 08:17:14 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:56862 "EHLO
        mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728235AbgG0MRN (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 27 Jul 2020 08:17:13 -0400
Received: from epcas2p2.samsung.com (unknown [182.195.41.54])
        by mailout3.samsung.com (KnoxPortal) with ESMTP id 20200727121709epoutp03ed95fb2c9c1875f00d99b4447b253e9f~lmyXf2pvf1611216112epoutp03k
        for <linux-scsi@vger.kernel.org>; Mon, 27 Jul 2020 12:17:09 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com 20200727121709epoutp03ed95fb2c9c1875f00d99b4447b253e9f~lmyXf2pvf1611216112epoutp03k
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1595852229;
        bh=CXuR99QjM7Td4Nchm2VXzRd5NLl1bnAmFBcUmxnouOo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gil97Hy6Kv0gsXx9SfXb7ImWwoEZ/5mj3HOFxogqXqADOyimluvDBfZtS7G7libaJ
         InlR/tWX3l3AgPTgsM/TJ2FdHZyJhOj/uw3+UfYwXiHK1AzR9LwxqklIvwBIAbZOls
         Um7HFJI1MIUiPquNBF5TJck4ln2e7VghII4jQo44=
Received: from epsnrtp1.localdomain (unknown [182.195.42.162]) by
        epcas2p4.samsung.com (KnoxPortal) with ESMTP id
        20200727121709epcas2p4006357b60337e4bdee6deb4bcb93cff0~lmyW9S9A52057320573epcas2p4H;
        Mon, 27 Jul 2020 12:17:09 +0000 (GMT)
Received: from epsmges2p3.samsung.com (unknown [182.195.40.181]) by
        epsnrtp1.localdomain (Postfix) with ESMTP id 4BFf1v3Ks8zMqYlv; Mon, 27 Jul
        2020 12:17:07 +0000 (GMT)
Received: from epcas2p3.samsung.com ( [182.195.41.55]) by
        epsmges2p3.samsung.com (Symantec Messaging Gateway) with SMTP id
        5B.D5.27441.3C5CE1F5; Mon, 27 Jul 2020 21:17:07 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
        epcas2p2.samsung.com (KnoxPortal) with ESMTPA id
        20200727121706epcas2p2403c31848cbaa8fda030b1bc8e76992e~lmyUHUmuJ1337813378epcas2p2Y;
        Mon, 27 Jul 2020 12:17:06 +0000 (GMT)
Received: from epsmgms1p2.samsung.com (unknown [182.195.42.42]) by
        epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20200727121706epsmtrp1b99f02b8798130cdda8005ce08c323ad~lmyUGk6DT1270612706epsmtrp1i;
        Mon, 27 Jul 2020 12:17:06 +0000 (GMT)
X-AuditID: b6c32a47-fc5ff70000006b31-1b-5f1ec5c36b47
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
        epsmgms1p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        F6.93.08303.2C5CE1F5; Mon, 27 Jul 2020 21:17:06 +0900 (KST)
Received: from rack03.dsn.sec.samsung.com (unknown [12.36.155.109]) by
        epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
        20200727121706epsmtip21a7dcb980a58b138ff55f7f7a10cddb3~lmyT2jtTN2379523795epsmtip2K;
        Mon, 27 Jul 2020 12:17:06 +0000 (GMT)
From:   SEO HOYOUNG <hy50.seo@samsung.com>
To:     linux-scsi@vger.kernel.org, alim.akhtar@samsung.com,
        avri.altman@wdc.com, jejb@linux.ibm.com,
        martin.petersen@oracle.com, beanhuo@micron.com,
        asutoshd@codeaurora.org, cang@codeaurora.org, bvanassche@acm.org,
        grant.jung@samsung.com, junwoo80.lee@samsung.com
Cc:     SEO HOYOUNG <hy50.seo@samsung.com>
Subject: [RFC PATCH v4 1/2] scsi: ufs: modify write booster
Date:   Mon, 27 Jul 2020 21:17:23 +0900
Message-Id: <32e5f27e68413355316fc8773ea313d9505cc1b1.1595850338.git.hy50.seo@samsung.com>
X-Mailer: git-send-email 2.26.0
In-Reply-To: <cover.1595850338.git.hy50.seo@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrIJsWRmVeSWpSXmKPExsWy7bCmue7ho3LxBjP/S1g8mLeNzWJv2wl2
        i5c/r7JZHHzYyWIx7cNPZotP65exWvz6u57dYvXiBywWi25sY7LY9beZyaL7+g42i+XH/zE5
        8HhcvuLtcbmvl8ljwqIDjB7f13eweXx8eovFo2/LKkaPz5vkPNoPdDMFcETl2GSkJqakFimk
        5iXnp2TmpdsqeQfHO8ebmhkY6hpaWpgrKeQl5qbaKrn4BOi6ZeYAXaukUJaYUwoUCkgsLlbS
        t7Mpyi8tSVXIyC8usVVKLUjJKTA0LNArTswtLs1L10vOz7UyNDAwMgWqTMjJePU4oeCIekX7
        /z1sDYz7FLoYOTkkBEwkjt1rYO1i5OIQEtjBKHHwwQwmCOcTo8TDxWuhnM+MEq93gjgcYC2v
        rjhCxHcxSuzZ8YkNwvnBKNHVfJ4dZC6bgIbEmmOHwLpFBLqYJB7u/MYEkmAWUJP4fHcZC4gt
        LGAtsfrMeWaQqSwCqhLTNxuChHkFoiReTj7DBHGfvMSiht9gNqeAhcSedwuYIWoEJU7OfMIC
        MVJeonnrbGaQXRICczkkZrycDtXsInFs82lGCFtY4tXxLewQtpTEy/42KLteYsq9VSwQzT1A
        76w4AdVsLDHrWTsjyHHMApoS63fpQ3yvLHHkFtRePomOw3/ZIcK8Eh1tQhCNShJn5t6GCktI
        HJydA2F6SExdaggJqW5Gibe35zFPYFSYheSZWUiemYWwdgEj8ypGsdSC4tz01GKjAmPk6N3E
        CE67Wu47GGe8/aB3iJGJg/EQowQHs5IIL7eoTLwQb0piZVVqUX58UWlOavEhRlNgSE9klhJN
        zgcm/rySeENTIzMzA0tTC1MzIwslcd5iqwtxQgLpiSWp2ampBalFMH1MHJxSDUwcG8XO7TJl
        S3vz2uzgc8bq0nOGPDk5P21UvMx6p086rxndW/uEX3dP7adp4ex3xReWKS45U2IbV7n9b5Df
        r3+/zGNY2RXDdnxg3LE05oZR2TH1deXHrSvic25+mhZRlFC99vLbyRlhSvXvHIWLan7aveF1
        yV0WHxYiyMj1/7R+QvSSu+Kna/6cTf0RsF3/08vrsXPyDqx+v/TPJaWL7EzsP/80TFUr2i0R
        ZJnf3tx/a/1WER0Lhxfamhcu6D/5Wxap12b9Y7uGeTZjWY312dwDtuGWkrUHKqvVl5U0Jyjs
        mHE24FPJ37VbzW9OTQ+QvvvLl2u9ANcv/fOv4qfxx7d+5lr1K2LGy4xjFk+b0pRYijMSDbWY
        i4oTAVWbrDlEBAAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrNLMWRmVeSWpSXmKPExsWy7bCSvO6ho3LxBj/uc1s8mLeNzWJv2wl2
        i5c/r7JZHHzYyWIx7cNPZotP65exWvz6u57dYvXiBywWi25sY7LY9beZyaL7+g42i+XH/zE5
        8HhcvuLtcbmvl8ljwqIDjB7f13eweXx8eovFo2/LKkaPz5vkPNoPdDMFcERx2aSk5mSWpRbp
        2yVwZbx6nFBwRL2i/f8etgbGfQpdjBwcEgImEq+uOHYxcnEICexglPh27RxTFyMnUFxC4v/i
        JihbWOJ+yxFWiKJvjBING66wgiTYBDQk1hw7xASSEBGYwSRxY8svZpAEs4CaxOe7y1hAbGEB
        a4nVZ84zg2xjEVCVmL7ZECTMKxAl8XLyGagF8hKLGn6D2ZwCFhJ73i0AKxcSMJdY908QolxQ
        4uTMJywQ0+UlmrfOZp7AKDALSWoWktQCRqZVjJKpBcW56bnFhgVGeanlesWJucWleel6yfm5
        mxjB8aGltYNxz6oPeocYmTgYDzFKcDArifByi8rEC/GmJFZWpRblxxeV5qQWH2KU5mBREuf9
        OmthnJBAemJJanZqakFqEUyWiYNTqoEptspLXEdqf+ZkVUdvIRfT5dte1aav9Kv52caf2JiT
        tp5z/Qbr3T8Yv1VKcXw+G7LEcMnXq1PP5i5z4dDWz9RQ0dpdoPog67hlwGaNBRH/Av88e19x
        yGbnDoPbGxxF9tn9CPJX6HaxCylS8Psb537BQOlTaNhFh3/hTnOXS2oqHfYrjYmxy6tYoZm7
        Zyeb1V/p7+s/zwpxWrjYPOiU/lpG33Lx9w/ajX7Vbz31efmeGJNPnoLJLutTXM0eRi9mc7E2
        CW37+zlridsqBtmyw9IaoeWe54pjrzmc6OcN0jkecaRtrY/pFMMKF/fDF1YdXBzmsMH35VzV
        GcGViw3zLl0R5r+U6N68s+38equ1D5RYijMSDbWYi4oTAW6kSIH+AgAA
X-CMS-MailID: 20200727121706epcas2p2403c31848cbaa8fda030b1bc8e76992e
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
CMS-TYPE: 102P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20200727121706epcas2p2403c31848cbaa8fda030b1bc8e76992e
References: <cover.1595850338.git.hy50.seo@samsung.com>
        <CGME20200727121706epcas2p2403c31848cbaa8fda030b1bc8e76992e@epcas2p2.samsung.com>
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
index efc0a6cbfe22..3eb139406a7c 100644
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
 
+	ufshcd_wb_reset_vendor(hba);
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
index 656c0691c858..61ae5259c62a 100644
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
+static int ufshcd_wb_reset_vendor(struct ufs_hba *hba)
+{
+	if (!hba->wb_ops || !hba->wb_ops->wb_reset_vendor)
+		return -1;
+
+	return hba->wb_ops->wb_reset_vendor(hba, false);
+}
 #endif /* End of Header */
-- 
2.26.0

