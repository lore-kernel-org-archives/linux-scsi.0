Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A878BC433E0
	for <linux-scsi@archiver.kernel.org>; Sat, 23 Jan 2021 06:26:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 77FDB23B08
	for <linux-scsi@archiver.kernel.org>; Sat, 23 Jan 2021 06:26:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726101AbhAWG0O (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 23 Jan 2021 01:26:14 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:34974 "EHLO
        mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725939AbhAWG0N (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 23 Jan 2021 01:26:13 -0500
Received: from epcas2p4.samsung.com (unknown [182.195.41.56])
        by mailout4.samsung.com (KnoxPortal) with ESMTP id 20210123062529epoutp04861ea80630fa68a05dec658279197eb8~cyGsfIwL12964029640epoutp04f
        for <linux-scsi@vger.kernel.org>; Sat, 23 Jan 2021 06:25:29 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20210123062529epoutp04861ea80630fa68a05dec658279197eb8~cyGsfIwL12964029640epoutp04f
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1611383129;
        bh=YBUdDDrkpvsLb6HxjCiLBnck1J1xSu5/Bi2p9OPEm0o=;
        h=From:To:Cc:Subject:Date:References:From;
        b=R3/Y4VJi8jW+WX/BygoOr04CDEhFZQ6XgufRX8rxPTIW8Jaz/5xshpR4bZKLI/WRX
         DpSFFhI0wF6NnWRqespfz4QZNICWpwXPyYrU5V/O1XJGy0uv/IHg7z0/kpPjtIeQfM
         EeGG1zVdnSGdHmpftq/TvIMhKlW9sdu8J5zdAovQ=
Received: from epsnrtp3.localdomain (unknown [182.195.42.164]) by
        epcas2p1.samsung.com (KnoxPortal) with ESMTP id
        20210123062527epcas2p11097445dcdb6319deed61ff77e2b041b~cyGq7xks32236222362epcas2p1G;
        Sat, 23 Jan 2021 06:25:27 +0000 (GMT)
Received: from epsmges2p1.samsung.com (unknown [182.195.40.190]) by
        epsnrtp3.localdomain (Postfix) with ESMTP id 4DN5j146pVz4x9Pp; Sat, 23 Jan
        2021 06:25:25 +0000 (GMT)
Received: from epcas2p1.samsung.com ( [182.195.41.53]) by
        epsmges2p1.samsung.com (Symantec Messaging Gateway) with SMTP id
        9F.CD.10621.551CB006; Sat, 23 Jan 2021 15:25:25 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
        epcas2p3.samsung.com (KnoxPortal) with ESMTPA id
        20210123062524epcas2p30522ab83455f8e2cc78d2824f0def515~cyGoE-ces2299422994epcas2p3t;
        Sat, 23 Jan 2021 06:25:24 +0000 (GMT)
Received: from epsmgms1p2.samsung.com (unknown [182.195.42.42]) by
        epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20210123062524epsmtrp2fdd893f53ff32ec6cd36c957c061cbd5~cyGoEEvnO1092210922epsmtrp2R;
        Sat, 23 Jan 2021 06:25:24 +0000 (GMT)
X-AuditID: b6c32a45-337ff7000001297d-4f-600bc155ea95
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
        epsmgms1p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        14.C2.08745.451CB006; Sat, 23 Jan 2021 15:25:24 +0900 (KST)
Received: from ubuntu.dsn.sec.samsung.com (unknown [12.36.155.120]) by
        epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
        20210123062524epsmtip10dab625b0175451f5cb4cef89b42374b~cyGn2WadK2504925049epsmtip1k;
        Sat, 23 Jan 2021 06:25:24 +0000 (GMT)
From:   Kiwoong Kim <kwmad.kim@samsung.com>
To:     linux-scsi@vger.kernel.org, alim.akhtar@samsung.com,
        avri.altman@wdc.com, jejb@linux.ibm.com,
        martin.petersen@oracle.com, beanhuo@micron.com,
        asutoshd@codeaurora.org, cang@codeaurora.org, bvanassche@acm.org,
        grant.jung@samsung.com, sc.suh@samsung.com, hy50.seo@samsung.com,
        sh425.lee@samsung.com, bhoon95.kim@samsung.com
Cc:     Kiwoong Kim <kwmad.kim@samsung.com>
Subject: [PATCH v1] scsi: ufs: export ufshcd_wb_ctrl func
Date:   Sat, 23 Jan 2021 15:13:57 +0900
Message-Id: <1611382437-187970-1-git-send-email-kwmad.kim@samsung.com>
X-Mailer: git-send-email 2.7.4
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupgk+LIzCtJLcpLzFFi42LZdljTVDf0IHeCwf958hYP5m1js9jbdoLd
        4uXPq2wWBx92slh8XfqM1WLah5/MFp/WL2O1+PV3PbvF6sUPWCwW3djGZHFzy1EWi+7rO9gs
        lh//x2TRdfcGo8XSf29ZHPg9Ll/x9rjc18vkMWHRAUaP7+s72Dw+Pr3F4tG3ZRWjx+dNch7t
        B7qZAjiicmwyUhNTUosUUvOS81My89JtlbyD453jTc0MDHUNLS3MlRTyEnNTbZVcfAJ03TJz
        gI5XUihLzCkFCgUkFhcr6dvZFOWXlqQqZOQXl9gqpRak5BQYGhboFSfmFpfmpesl5+daGRoY
        GJkCVSbkZBx8/Yq94JBQRW/TTKYGxof8XYycHBICJhJdE7czdjFycQgJ7GCUaJnxgxnC+cQo
        0XtyIlTmM6PEw/cv2WFa5uzfxwKR2MUocWHZCyYI5wejxL7T65hAqtgENCWe3pwKlhAROMMk
        ca31LCtIgllAXWLXhBNgRcIClhK/Oo6DxVkEVCUO7n/LDGLzCrhJXDt+jxlinZzEzXOdYEdJ
        CDRySHw72gGVcJE4fm46K4QtLPHq+Bao+6QkPr/bywZh10vsm9rACtHcwyjxdN8/RoiEscSs
        Z+1ANgfQRZoS63fpg5gSAsoSR26xQNzJJ9Fx+C87RJhXoqNNCKJRWeLXpMlQQyQlZt68A7XV
        Q+J1bwvYViGBWImVzavYJzDKzkKYv4CRcRWjWGpBcW56arFRgSFyNG1iBCdJLdcdjJPfftA7
        xMjEwXiIUYKDWUmE95ElR4IQb0piZVVqUX58UWlOavEhRlNgeE1klhJNzgem6bySeENTIzMz
        A0tTC1MzIwslcd5igwfxQgLpiSWp2ampBalFMH1MHJxSDUzNu77bPiw2XD4rPvWNbkaV2oRl
        pcsuv3WZZSp2mvv+C4EXbzMmzI2vq5N8zr1iheIRpqdHXs1uF6rQ2HRJ/KK4a8tvSaPTsiEn
        45fpHe5+uNdH8gDnETulDcr3nMuawue85M5IntJZ6HWLR14wNy3B7/iZ6nUun2v08vqfHTac
        L1fyMP0wh1ATs+vmzYs7BBmUs+6eTLW97JPj336dfbXNmTPvRE8EH6iXBKZqa5Htcvfj5h+8
        5XJvp+bW2Bnevge01ZbvEp/y6pKLtN6Bf9Ix3ucTr0lsWnK+LXHZ5dwJK5T/LU+7vcApIcvW
        Ol+jZ8nmlYfKzTtPep4ruW7rlrVwm+6Ho4c/zf2RuVF9WYQSS3FGoqEWc1FxIgDzZ4OLGwQA
        AA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrGLMWRmVeSWpSXmKPExsWy7bCSnG7IQe4Eg6Wv+SwezNvGZrG37QS7
        xcufV9ksDj7sZLH4uvQZq8W0Dz+ZLT6tX8Zq8evvenaL1YsfsFgsurGNyeLmlqMsFt3Xd7BZ
        LD/+j8mi6+4NRoul/96yOPB7XL7i7XG5r5fJY8KiA4we39d3sHl8fHqLxaNvyypGj8+b5Dza
        D3QzBXBEcdmkpOZklqUW6dslcGUcfP2KveCQUEVv00ymBsaH/F2MnBwSAiYSc/bvY+li5OIQ
        EtjBKNG65BILREJS4sTO54wQtrDE/ZYjrBBF3xglHm+7CJZgE9CUeHpzKhNIQkTgHpPEpQlz
        mUESzALqErsmnGACsYUFLCV+dRxnBbFZBFQlDu5/C1bDK+Amce34PWaIDXISN891Mk9g5FnA
        yLCKUTK1oDg3PbfYsMAoL7Vcrzgxt7g0L10vOT93EyM4aLW0djDuWfVB7xAjEwfjIUYJDmYl
        Ed5HlhwJQrwpiZVVqUX58UWlOanFhxilOViUxHkvdJ2MFxJITyxJzU5NLUgtgskycXBKNTCt
        bzMP1fr7XmFdx6SgZMHLVw2My8OLMnK9rc89Dsu8OOvOhjBRazNhhcvfFvIrarronFNYwnsi
        cqVYbcyRlk/b/qotdS62jLsbMu8bz4mIZ67265qPunoqui/0MFe01Llw9N1Svr5ji87lnmSs
        MBWbyP4yLPxl4vf1kRc/TmU/YfFDTGJVzuNVmuzmtV6a3KrTHizqCJRbzSnWc0+Kab/nz1Lr
        S3WKeUxB10U/Ve2fnbP1eeyzBr21x5y2zbvKu/L4ik0b2r5NLo4L3awkkrFR4BF36iR9R6m9
        636qHqt+EjSrxVdQ7X9RTt9sk4b4WxIyj1JLnnQ6389vezxdRyR01XamLTuKTtYk63+7wK/E
        UpyRaKjFXFScCADTkSkayQIAAA==
X-CMS-MailID: 20210123062524epcas2p30522ab83455f8e2cc78d2824f0def515
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
CMS-TYPE: 102P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20210123062524epcas2p30522ab83455f8e2cc78d2824f0def515
References: <CGME20210123062524epcas2p30522ab83455f8e2cc78d2824f0def515@epcas2p3.samsung.com>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: SEO HOYOUNG <hy50.seo@samsung.com>

Turning on write booster should eventually lead to
increasing power consumption and it needs be controlled
by a policy which should be vendor specific. Becasue
it's derived from system requirements.

So need to make this be called from outside.

Signed-off-by: Kiwoong Kim <kwmad.kim@samsung.com>
Signed-off-by: SEO HOYOUNG <hy50.seo@samsung.com>
---
 drivers/scsi/ufs/ufshcd.c | 5 +++--
 drivers/scsi/ufs/ufshcd.h | 1 +
 2 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index e221add..23603a6 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -246,7 +246,7 @@ static inline int ufshcd_config_vreg_hpm(struct ufs_hba *hba,
 static int ufshcd_try_to_abort_task(struct ufs_hba *hba, int tag);
 static int ufshcd_wb_buf_flush_enable(struct ufs_hba *hba);
 static int ufshcd_wb_buf_flush_disable(struct ufs_hba *hba);
-static int ufshcd_wb_ctrl(struct ufs_hba *hba, bool enable);
+int ufshcd_wb_ctrl(struct ufs_hba *hba, bool enable);
 static int ufshcd_wb_toggle_flush_during_h8(struct ufs_hba *hba, bool set);
 static inline void ufshcd_wb_toggle_flush(struct ufs_hba *hba, bool enable);
 static void ufshcd_hba_vreg_set_lpm(struct ufs_hba *hba);
@@ -5351,7 +5351,7 @@ static void ufshcd_bkops_exception_event_handler(struct ufs_hba *hba)
 				__func__, err);
 }
 
-static int ufshcd_wb_ctrl(struct ufs_hba *hba, bool enable)
+int ufshcd_wb_ctrl(struct ufs_hba *hba, bool enable)
 {
 	int ret;
 	u8 index;
@@ -5382,6 +5382,7 @@ static int ufshcd_wb_ctrl(struct ufs_hba *hba, bool enable)
 
 	return ret;
 }
+EXPORT_SYMBOL_GPL(ufshcd_wb_ctrl);
 
 static int ufshcd_wb_toggle_flush_during_h8(struct ufs_hba *hba, bool set)
 {
diff --git a/drivers/scsi/ufs/ufshcd.h b/drivers/scsi/ufs/ufshcd.h
index 9bb5f0e..abd710e 100644
--- a/drivers/scsi/ufs/ufshcd.h
+++ b/drivers/scsi/ufs/ufshcd.h
@@ -1060,6 +1060,7 @@ void ufshcd_map_desc_id_to_length(struct ufs_hba *hba, enum desc_idn desc_id,
 u32 ufshcd_get_local_unipro_ver(struct ufs_hba *hba);
 
 int ufshcd_send_uic_cmd(struct ufs_hba *hba, struct uic_command *uic_cmd);
+int ufshcd_wb_ctrl(struct ufs_hba *hba, bool enable);
 
 int ufshcd_exec_raw_upiu_cmd(struct ufs_hba *hba,
 			     struct utp_upiu_req *req_upiu,
-- 
2.7.4

