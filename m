Return-Path: <SRS0=+RX4=AY=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 50E4CC433EB
	for <linux-scsi@archiver.kernel.org>; Mon, 13 Jul 2020 11:19:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 18BC12075B
	for <linux-scsi@archiver.kernel.org>; Mon, 13 Jul 2020 11:19:58 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="Xbpx6CPM"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729593AbgGMLT5 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 13 Jul 2020 07:19:57 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:33466 "EHLO
        mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728950AbgGMLT4 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 13 Jul 2020 07:19:56 -0400
Received: from epcas2p1.samsung.com (unknown [182.195.41.53])
        by mailout2.samsung.com (KnoxPortal) with ESMTP id 20200713111952epoutp0231f0bb1d557c7d7b1ef08fa5de327039~hS_WzMMp60644506445epoutp02P
        for <linux-scsi@vger.kernel.org>; Mon, 13 Jul 2020 11:19:52 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com 20200713111952epoutp0231f0bb1d557c7d7b1ef08fa5de327039~hS_WzMMp60644506445epoutp02P
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1594639193;
        bh=msJooRWxm5c4IIG3ZDyJ9Td1DXn7tpICLv05au1ohFo=;
        h=From:To:Cc:Subject:Date:References:From;
        b=Xbpx6CPMF02upNA6JuOC1uEls+qCj+FiJdrEn87dEqPScFE1cYr4OwhvX+LH2LcGZ
         o5cqGKNG8SWbnqwS5vnrgACqHXK4QJydZBrpYGgesqU0v64Uca6a+o++3j6zlfBVfw
         zil/e3Ka2oJ7QE6kIThy7lPrYVGnDtHt3sBbiGNo=
Received: from epsnrtp2.localdomain (unknown [182.195.42.163]) by
        epcas2p4.samsung.com (KnoxPortal) with ESMTP id
        20200713111951epcas2p4a715bc9d03dabdb95c69802f1a10d662~hS_VqBZAV0207602076epcas2p4S;
        Mon, 13 Jul 2020 11:19:51 +0000 (GMT)
Received: from epsmges2p1.samsung.com (unknown [182.195.40.186]) by
        epsnrtp2.localdomain (Postfix) with ESMTP id 4B51QF5bcwzMqYkb; Mon, 13 Jul
        2020 11:19:49 +0000 (GMT)
Received: from epcas2p2.samsung.com ( [182.195.41.54]) by
        epsmges2p1.samsung.com (Symantec Messaging Gateway) with SMTP id
        0D.42.19322.5534C0F5; Mon, 13 Jul 2020 20:19:49 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
        epcas2p4.samsung.com (KnoxPortal) with ESMTPA id
        20200713111949epcas2p47da38b91548e7a13123380b9a7093642~hS_TIQN6Y0207602076epcas2p4R;
        Mon, 13 Jul 2020 11:19:49 +0000 (GMT)
Received: from epsmgms1p2.samsung.com (unknown [182.195.42.42]) by
        epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20200713111949epsmtrp1867008e39f869b7edaac327c6c13a596~hS_THiS690537905379epsmtrp1G;
        Mon, 13 Jul 2020 11:19:49 +0000 (GMT)
X-AuditID: b6c32a45-7adff70000004b7a-c9-5f0c4355d856
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
        epsmgms1p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        88.25.08303.4534C0F5; Mon, 13 Jul 2020 20:19:48 +0900 (KST)
Received: from rack03.dsn.sec.samsung.com (unknown [12.36.155.109]) by
        epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
        20200713111948epsmtip1869f76597db5a047720c31204ad05af3~hS_S6NwP72595525955epsmtip1h;
        Mon, 13 Jul 2020 11:19:48 +0000 (GMT)
From:   SEO HOYOUNG <hy50.seo@samsung.com>
To:     linux-scsi@vger.kernel.org, alim.akhtar@samsung.com,
        avri.altman@wdc.com, jejb@linux.ibm.com,
        martin.petersen@oracle.com, beanhuo@micron.com,
        asutoshd@codeaurora.org, cang@codeaurora.org, bvanassche@acm.org,
        grant.jung@samsung.com
Cc:     SEO HOYOUNG <hy50.seo@samsung.com>
Subject: [RFC PATCH v1] scsi: ufs: modify write booster
Date:   Mon, 13 Jul 2020 20:20:22 +0900
Message-Id: <20200713112022.169887-1-hy50.seo@samsung.com>
X-Mailer: git-send-email 2.26.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrEJsWRmVeSWpSXmKPExsWy7bCmmW6oM0+8Qc8RbYsH87axWextO8Fu
        8fLnVTaLgw87WSymffjJbPFp/TJWi19/17NbrF78gMVi0Y1tTBbd13ewWSw//o/Jgdvj8hVv
        j8t9vUweExYdYPT4vr6DzePj01ssHn1bVjF6fN4k59F+oJspgCMqxyYjNTEltUghNS85PyUz
        L91WyTs43jne1MzAUNfQ0sJcSSEvMTfVVsnFJ0DXLTMH6FAlhbLEnFKgUEBicbGSvp1NUX5p
        SapCRn5xia1SakFKToGhYYFecWJucWleul5yfq6VoYGBkSlQZUJOxrJt3SwFvzUrVl5bx9bA
        uEKpi5GTQ0LARGLW/WtsXYxcHEICOxgl+me+hnI+MUq8mfiSFcL5zCix7c4mNpiWa1/7GSES
        uxgldpw+ygzh/GCUmPv2IDtIFZuAhsSaY4eYQBIiAh8YJY6umM0KkmAWUJP4fHcZSxcjB4ew
        gLnEpSsiIGEWAVWJs6+mM4PYvAJWEj92nIXaJi+xqOE3E0RcUOLkzCcsEGPkJZq3zgZbLCHQ
        yCFx6fw0VogGF4n9O36wQ9jCEq+Ob4GypSRe9rdB2fUSU+6tYoFo7mGU2LPiBBNEwlhi1rN2
        RpDjmAU0Jdbv0gcxJQSUJY7cgtrLJ9Fx+C87RJhXoqNNCKJRSeLM3NtQYQmJg7NzIMIeEpsO
        Pwb7REggVuL5z99MExjlZyF5ZhaSZ2YhrF3AyLyKUSy1oDg3PbXYqMAQOVI3MYITq5brDsbJ
        bz/oHWJk4mA8xCjBwawkwhstyhkvxJuSWFmVWpQfX1Sak1p8iNEUGLwTmaVEk/OBqT2vJN7Q
        1MjMzMDS1MLUzMhCSZw3V/FCnJBAemJJanZqakFqEUwfEwenVAPTHI3VM2ftUZjlsPabjGf7
        iZawtw3JYbHhl6ezcKxZc+vmz8dbsmT6Hnlqhtc8r9BoqN5zS///mSV1C9gmc/xucEp1Xp9z
        Juvlli4vjeVnerKlP7H9LzhyiSWZdW6N71mPbcIqE793TV/fL2Vd+1b6avS5MssZvwuiNkxs
        WBMm67qkPa58TsyDfJPkSyoXH7ncWH5LWSjZ9uYlCa/1IZw3oh78FfS6KSL/P6DObGnP6ph1
        q5Tv+f+vX9i2NE4262j3PAZus/3zq2d/5QvmfZ67dMra17OC0yv/SItOcF/5O/jT9x3rGJcK
        rl7b7DhR88LFd3Kme689uBxc4K6gLWh/OfLW6/kbn2mHXVwac68vVYmlOCPRUIu5qDgRAJvB
        LwI1BAAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrALMWRmVeSWpSXmKPExsWy7bCSnG6IM0+8wfOrVhYP5m1js9jbdoLd
        4uXPq2wWBx92slhM+/CT2eLT+mWsFr/+rme3WL34AYvFohvbmCy6r+9gs1h+/B+TA7fH5Sve
        Hpf7epk8Jiw6wOjxfX0Hm8fHp7dYPPq2rGL0+LxJzqP9QDdTAEcUl01Kak5mWWqRvl0CV8ay
        bd0sBb81K1ZeW8fWwLhCqYuRk0NCwETi2td+xi5GLg4hgR2MEjN2P2OFSEhI/F/cxARhC0vc
        bznCClH0jVHiyfmrjCAJNgENiTXHDoEViQj8YZSYdDoOxGYWUJP4fHcZSxcjB4ewgLnEpSsi
        IGEWAVWJs6+mM4PYvAJWEj92nGWDmC8vsajhNxNEXFDi5MwnLBBj5CWat85mnsDINwtJahaS
        1AJGplWMkqkFxbnpucWGBUZ5qeV6xYm5xaV56XrJ+bmbGMGBrqW1g3HPqg96hxiZOBgPMUpw
        MCuJ8EaLcsYL8aYkVlalFuXHF5XmpBYfYpTmYFES5/06a2GckEB6YklqdmpqQWoRTJaJg1Oq
        gWlbMP8E1sY32nmf5n8UnqCpvlMryiXKYPfi0/tXB0nHHbzlWlHm5TnTWrBOlMW1ns1qneM6
        P6NnH9a+lefnYI0s/ndaRjJH4bbuzz1TX768tSntZL/KIefHRS8vPylZ7rvAfW7wXrONM8Mf
        tR3TWfVr6xYnyZDt326snn6ha2+AllGTl8dquQOv9C0/KPu9mzJj97md6VG537v6jXgVDFw2
        5sWeXSBuPrXiovVyJ6FFNq8yr9VVCKXt/dnynLmZqdOn68/WYCNh7zN9E2X00zVr/89562HZ
        djRph1+dsbKiZf6hvOZUkcJpivUrOau8zAMc+e4bsF9T6ToatO/qksIOkXbpST7qN20rEyYG
        KbEUZyQaajEXFScCAH/UIQfjAgAA
X-CMS-MailID: 20200713111949epcas2p47da38b91548e7a13123380b9a7093642
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
CMS-TYPE: 102P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20200713111949epcas2p47da38b91548e7a13123380b9a7093642
References: <CGME20200713111949epcas2p47da38b91548e7a13123380b9a7093642@epcas2p4.samsung.com>
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

