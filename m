Return-Path: <SRS0=rv89=A7=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CE51BC433E2
	for <linux-scsi@archiver.kernel.org>; Mon, 20 Jul 2020 10:39:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A823C22482
	for <linux-scsi@archiver.kernel.org>; Mon, 20 Jul 2020 10:39:55 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="RYgbbTdO"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728418AbgGTKjz (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 20 Jul 2020 06:39:55 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:28314 "EHLO
        mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728402AbgGTKjy (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 20 Jul 2020 06:39:54 -0400
Received: from epcas2p2.samsung.com (unknown [182.195.41.54])
        by mailout2.samsung.com (KnoxPortal) with ESMTP id 20200720103951epoutp02354b6c53207f918bde87d6768ba35bbd~jb8ahEIa01906719067epoutp02K
        for <linux-scsi@vger.kernel.org>; Mon, 20 Jul 2020 10:39:51 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com 20200720103951epoutp02354b6c53207f918bde87d6768ba35bbd~jb8ahEIa01906719067epoutp02K
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1595241591;
        bh=msJooRWxm5c4IIG3ZDyJ9Td1DXn7tpICLv05au1ohFo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RYgbbTdOkVgOgLGVDb59qbqHmf87vxogbZrEOW/nEKSUP+6HwEqzXBVlu9YxmP++w
         CyfeboAfWBKUe33PkM3ge3CVtNiIc3fYCucLcAcfXe1bg/luGFw7BssoqO9M3OrJWj
         4nRNPHTdl6E719mmmZrZ9HLJ8ibbumHXOGF+WjSg=
Received: from epsnrtp3.localdomain (unknown [182.195.42.164]) by
        epcas2p1.samsung.com (KnoxPortal) with ESMTP id
        20200720103951epcas2p1fa872f4b3ac13e0f41f16bf0f5f3d279~jb8aFb9ns1933419334epcas2p16;
        Mon, 20 Jul 2020 10:39:51 +0000 (GMT)
Received: from epsmges2p3.samsung.com (unknown [182.195.40.191]) by
        epsnrtp3.localdomain (Postfix) with ESMTP id 4B9JBs3G7wzMqYkY; Mon, 20 Jul
        2020 10:39:49 +0000 (GMT)
Received: from epcas2p2.samsung.com ( [182.195.41.54]) by
        epsmges2p3.samsung.com (Symantec Messaging Gateway) with SMTP id
        41.A0.27441.574751F5; Mon, 20 Jul 2020 19:39:49 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
        epcas2p4.samsung.com (KnoxPortal) with ESMTPA id
        20200720103949epcas2p4a49b245d9cebf0478d42fb6c607fc236~jb8X6IcQ43088630886epcas2p4Q;
        Mon, 20 Jul 2020 10:39:49 +0000 (GMT)
Received: from epsmgms1p2.samsung.com (unknown [182.195.42.42]) by
        epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20200720103949epsmtrp2e9794047573b488d69059729d55a8c27~jb8X5ZG3_2144421444epsmtrp2h;
        Mon, 20 Jul 2020 10:39:49 +0000 (GMT)
X-AuditID: b6c32a47-fafff70000006b31-06-5f15747588ce
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
        epsmgms1p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        13.3D.08303.474751F5; Mon, 20 Jul 2020 19:39:49 +0900 (KST)
Received: from rack03.dsn.sec.samsung.com (unknown [12.36.155.109]) by
        epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
        20200720103948epsmtip20563830e08c88fa97994587ce5f05143~jb8Xsk7XO0960109601epsmtip2k;
        Mon, 20 Jul 2020 10:39:48 +0000 (GMT)
From:   SEO HOYOUNG <hy50.seo@samsung.com>
To:     linux-scsi@vger.kernel.org, alim.akhtar@samsung.com,
        avri.altman@wdc.com, jejb@linux.ibm.com,
        martin.petersen@oracle.com, beanhuo@micron.com,
        asutoshd@codeaurora.org, cang@codeaurora.org, bvanassche@acm.org,
        grant.jung@samsung.com
Cc:     SEO HOYOUNG <hy50.seo@samsung.com>
Subject: [RFC PATCH v2 1/3] scsi: ufs: modify write booster
Date:   Mon, 20 Jul 2020 19:40:11 +0900
Message-Id: <a4db9e7982c4dcd00b4adbcb5d247261a7ec0c27.1595240433.git.hy50.seo@samsung.com>
X-Mailer: git-send-email 2.26.0
In-Reply-To: <cover.1595240433.git.hy50.seo@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrHJsWRmVeSWpSXmKPExsWy7bCmmW5piWi8wbLf4hYP5m1js9jbdoLd
        4uXPq2wWBx92slhM+/CT2eLT+mWsFr/+rme3WL34AYvFohvbmCy6r+9gs1h+/B+TA7fH5Sve
        Hpf7epk8Jiw6wOjxfX0Hm8fHp7dYPPq2rGL0+LxJzqP9QDdTAEdUjk1GamJKapFCal5yfkpm
        XrqtkndwvHO8qZmBoa6hpYW5kkJeYm6qrZKLT4CuW2YO0KFKCmWJOaVAoYDE4mIlfTubovzS
        klSFjPziElul1IKUnAJDwwK94sTc4tK8dL3k/FwrQwMDI1OgyoScjGXbulkKfmtWrLy2jq2B
        cYVSFyMnh4SAicTKo3fZuhi5OIQEdjBKLNg6gxHC+cQosaP9OlTmM6NE+7bTLDAtT1uvQiV2
        MUr0LD/BBJIQEvjBKLHxaBmIzSagIbHm2CEmkCIRgQ+MEkdXzGYFSTALqEl8vrsMbJKwgLXE
        tgP32UBsFgFVid4Nd4FqODh4BaIk3jeXQiyTl1jU8BtsPqeAhcScjY/AynkFBCVOznzCAjFS
        XqJ562xmkF0SAjM5JJb/ecMM0ewi0XD7IiOELSzx6vgWdghbSuLzu71sEHa9xJR7q1ggmnsY
        JfasgPhGQsBYYtazdkaQg5gFNCXW79IHMSUElCWO3ILayyfRcfgvO0SYV6KjTQiiUUnizNzb
        UGEJiYOzcyDCHhKLzr5nhgRbNzDYWi6zTWBUmIXkm1lIvpmFsHcBI/MqRrHUguLc9NRiowJj
        5AjexAhOuFruOxhnvP2gd4iRiYPxEKMEB7OSCO9EHuF4Id6UxMqq1KL8+KLSnNTiQ4ymwKCe
        yCwlmpwPTPl5JfGGpkZmZgaWphamZkYWSuK8xVYX4oQE0hNLUrNTUwtSi2D6mDg4pRqYaq4X
        mUkdvS7KFBXAGPU0a8KTXUW7gxZf03qzyFH25cFnormXUiodglZzhURt/Sge81fLTaXu3vUV
        7xInlP4NephWmtOR8Mxuy4zCjISO5Y0+6mtZzqt9iz5Q77rxagIre9S2lbe7Hv26vfXmJpWC
        mefCpjnrfTodt3ThvqzD87mzgr5Oq8xunXbOZY6i+IPaonNdP/arHTzsv3fV73WPzn+/Z7/y
        TP3jrNiLD/1uOR76U8dzduXWLllvqb9/BHqs+zh8pD0m1LpkKGp/Ds59f0Tmf7dAscauDzpn
        ojW4ulJsvvJ9sZQ5mH3lm6OLHtcX6bccXw6bma22uOGy/MkXI4/6mpBHT3ZvLRIKspGvVWIp
        zkg01GIuKk4EAPiTwftBBAAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrOLMWRmVeSWpSXmKPExsWy7bCSvG5piWi8wdEDjBYP5m1js9jbdoLd
        4uXPq2wWBx92slhM+/CT2eLT+mWsFr/+rme3WL34AYvFohvbmCy6r+9gs1h+/B+TA7fH5Sve
        Hpf7epk8Jiw6wOjxfX0Hm8fHp7dYPPq2rGL0+LxJzqP9QDdTAEcUl01Kak5mWWqRvl0CV8ay
        bd0sBb81K1ZeW8fWwLhCqYuRk0NCwETiaetVNhBbSGAHo8T6Q7UQcQmJ/4ubmCBsYYn7LUdY
        uxi5gGq+MUr0vp3ICpJgE9CQWHPsEFiRiMAfRolJp+NAbGYBNYnPd5exgNjCAtYS2w7cB1vA
        IqAq0bvhLlAvBwevQJTE++ZSiPnyEosafoON4RSwkJiz8RHUPeYS53c1MoPYvAKCEidnPmGB
        GC8v0bx1NvMERoFZSFKzkKQWMDKtYpRMLSjOTc8tNiwwykst1ytOzC0uzUvXS87P3cQIjgst
        rR2Me1Z90DvEyMTBeIhRgoNZSYR3Io9wvBBvSmJlVWpRfnxRaU5q8SFGaQ4WJXHer7MWxgkJ
        pCeWpGanphakFsFkmTg4pRqYmAJ37zMVXn79q1KIi/yXT3b+whOXL6yXXdE173Shlt/6RY1n
        vrEWiF5zU86qiV2ytmEv1+4TftrS7MefbjXW2ydwrbjxuBtjmtHDvlkv/7v/s/sb5J/FNcth
        L9uG3Oq483NfCDtczlrfaL/remf+4c7UlKmW1/W5nsutUcqbFWFv+1rsmJa6TdXXY4kKAlH2
        8+be3lz/T2luSdZVFo/jUoqm7g1+la/1fzzuizh7dP/EY5xBu17V5+vlNoSdPL8v68Pn/T9b
        t9VeehMoHX13yZRN4eoBUtN67k/f/PPPmuy87IsxzydGPVW4J90T6Xktw5aPpXa9Ms/B9g0+
        ua8KrK4z7LHmF1r3cPv0y8G/lViKMxINtZiLihMBS2TDI/oCAAA=
X-CMS-MailID: 20200720103949epcas2p4a49b245d9cebf0478d42fb6c607fc236
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
CMS-TYPE: 102P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20200720103949epcas2p4a49b245d9cebf0478d42fb6c607fc236
References: <cover.1595240433.git.hy50.seo@samsung.com>
        <CGME20200720103949epcas2p4a49b245d9cebf0478d42fb6c607fc236@epcas2p4.samsung.com>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Add vendor specific functions for WB
Use callback additional setting when use write booster.

Signed-off-by: SEO HOYOUNG <hy50.seo@samsung.com>
---
 drivers/scsi/ufs/ufshcd.c | 23 ++++++++++++++++-----
 drivers/scsi/ufs/ufshcd.h | 43 +++++++++++++++++++++++++++++++++++++++
 2 files changed, 61 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index efc0a6cbfe22..efa16bf4fd76 100644
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
@@ -8260,6 +8270,7 @@ static int ufshcd_suspend(struct ufs_hba *hba, enum ufs_pm_op pm_op)
 			/* make sure that auto bkops is disabled */
 			ufshcd_disable_auto_bkops(hba);
 		}
+
 		/*
 		 * If device needs to do BKOP or WB buffer flush during
 		 * Hibern8, keep device power mode as "active power mode"
@@ -8273,6 +8284,8 @@ static int ufshcd_suspend(struct ufs_hba *hba, enum ufs_pm_op pm_op)
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

