Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 95AA0C433DB
	for <linux-scsi@archiver.kernel.org>; Tue, 19 Jan 2021 18:28:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5FD1F22E00
	for <linux-scsi@archiver.kernel.org>; Tue, 19 Jan 2021 18:28:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389356AbhASQro (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 19 Jan 2021 11:47:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52614 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389013AbhASQkc (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 19 Jan 2021 11:40:32 -0500
Received: from mail-ed1-x52c.google.com (mail-ed1-x52c.google.com [IPv6:2a00:1450:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A8092C0613D3;
        Tue, 19 Jan 2021 08:39:10 -0800 (PST)
Received: by mail-ed1-x52c.google.com with SMTP id u19so22314848edx.2;
        Tue, 19 Jan 2021 08:39:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=xe4EHIL51ydV2x+6uQo+VrV4LDMVn0EUlA1wEftD2vA=;
        b=Thh2dbLWbb2kmBb+EScPBRhN955aWoSTH43AgNIqBUc/k2Hxc/x4lODsIwOtEbyEbO
         Ny/DRcqd3cRuQtR10n+7PopWhQlZ3Ikd6/vdmNYtb5yzO/FCn2/NdzbL+cXx9B4JRW0+
         kHIrZL53gKPLoCv7/HN5J8fb7+fBK6EQqjc7N6XxMAz/Okd3842qqCXVyZ5Fb+yRM921
         bLCKsSzBQRguTUWoRFQOxdT5sWw43Z6mOFSa5B16bY6mHEGpYyg3XCqJG72LRMdINyL2
         JLar48ETKMX0EFP6MIrq6sPAC4UERgAdKoJvJeprCmfFdY6FQ3JreXfrf6/I9lt4S2zs
         aJjw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=xe4EHIL51ydV2x+6uQo+VrV4LDMVn0EUlA1wEftD2vA=;
        b=T3jbPS1K8skbf6LWFJBV1ZvzlddlhlP589qUV7Tj132+7UbiVFN0C86943SDsKDF+r
         prVnF21SD2TilCucm9cOpHx9fut8c82BG2n+iLmuFJ3bp1aqK0pOGuBkOxc4v3Irqk3I
         V7IktulqRmFFjTCbnF8mvKP4hwNXrWoi/oEmPytsHwNLTMbZXBfzExSHeZ2xJQ6rFa7l
         HLrcCR+fJDbt5qugdWHHLNRYJyWzcEsQ2FxGBnIemsYarviz3C6n7X77dBYWSRS4Q9hi
         E38ziIQhwBN3HpYly4+5mswI+hFP59D63kGwfnJYr5FD3TA0wgGv/jBR9mrrArvQlt3F
         OWJQ==
X-Gm-Message-State: AOAM531puOpvV8+Y7y+Rz/GLCxypXHH7xEgKfxaDd5feMvn+HN1IcsXl
        X4tzWZi4k8DxXGzU5cWEfU8=
X-Google-Smtp-Source: ABdhPJy3EKWKx5LLVJjr+bfJPkDjeWay4JIASbzDCvcu5Snu8q9vHH/7PxPPDM59iYFmGGHT+sreRQ==
X-Received: by 2002:a50:9ee9:: with SMTP id a96mr4072520edf.343.1611074349476;
        Tue, 19 Jan 2021 08:39:09 -0800 (PST)
Received: from localhost.localdomain (ip5f5bee1b.dynamic.kabel-deutschland.de. [95.91.238.27])
        by smtp.gmail.com with ESMTPSA id k22sm9589993eji.101.2021.01.19.08.39.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Jan 2021 08:39:09 -0800 (PST)
From:   Bean Huo <huobean@gmail.com>
To:     alim.akhtar@samsung.com, avri.altman@wdc.com,
        asutoshd@codeaurora.org, jejb@linux.ibm.com,
        martin.petersen@oracle.com, stanley.chu@mediatek.com,
        beanhuo@micron.com, bvanassche@acm.org, tomas.winkler@intel.com,
        cang@codeaurora.org
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v7 6/6] scsi: ufs: Cleanup WB buffer flush toggle implementation
Date:   Tue, 19 Jan 2021 17:38:47 +0100
Message-Id: <20210119163847.20165-7-huobean@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210119163847.20165-1-huobean@gmail.com>
References: <20210119163847.20165-1-huobean@gmail.com>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Bean Huo <beanhuo@micron.com>

Delete ufshcd_wb_buf_flush_enable() and ufshcd_wb_buf_flush_disable(),
move the implementation into ufshcd_wb_toggle_flush().

Signed-off-by: Bean Huo <beanhuo@micron.com>
Reviewed-by: Stanley Chu <stanley.chu@mediatek.com>
Reviewed-by: Can Guo <cang@codeaurora.org>
Signed-off-by: Bean Huo <beanhuo@micron.com>
---
 drivers/scsi/ufs/ufshcd.c | 66 +++++++++++++--------------------------
 1 file changed, 21 insertions(+), 45 deletions(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 4f40891ea429..2d2a1bbfad92 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -247,10 +247,8 @@ static int ufshcd_setup_vreg(struct ufs_hba *hba, bool on);
 static inline int ufshcd_config_vreg_hpm(struct ufs_hba *hba,
 					 struct ufs_vreg *vreg);
 static int ufshcd_try_to_abort_task(struct ufs_hba *hba, int tag);
-static int ufshcd_wb_buf_flush_enable(struct ufs_hba *hba);
-static int ufshcd_wb_buf_flush_disable(struct ufs_hba *hba);
 static int ufshcd_wb_toggle_flush_during_h8(struct ufs_hba *hba, bool set);
-static inline void ufshcd_wb_toggle_flush(struct ufs_hba *hba, bool enable);
+static inline int ufshcd_wb_toggle_flush(struct ufs_hba *hba, bool enable);
 static void ufshcd_hba_vreg_set_lpm(struct ufs_hba *hba);
 static void ufshcd_hba_vreg_set_hpm(struct ufs_hba *hba);
 
@@ -5460,60 +5458,38 @@ static int ufshcd_wb_toggle_flush_during_h8(struct ufs_hba *hba, bool set)
 				index, NULL);
 }
 
-static inline void ufshcd_wb_toggle_flush(struct ufs_hba *hba, bool enable)
-{
-	if (hba->quirks & UFSHCI_QUIRK_SKIP_MANUAL_WB_FLUSH_CTRL)
-		return;
-
-	if (enable)
-		ufshcd_wb_buf_flush_enable(hba);
-	else
-		ufshcd_wb_buf_flush_disable(hba);
-
-}
-
-static int ufshcd_wb_buf_flush_enable(struct ufs_hba *hba)
+static inline int ufshcd_wb_toggle_flush(struct ufs_hba *hba, bool enable)
 {
 	int ret;
 	u8 index;
+	enum query_opcode opcode;
 
-	if (!ufshcd_is_wb_allowed(hba) || hba->dev_info.wb_buf_flush_enabled)
+	if (hba->quirks & UFSHCI_QUIRK_SKIP_MANUAL_WB_FLUSH_CTRL)
 		return 0;
 
-	index = ufshcd_wb_get_query_index(hba);
-	ret = ufshcd_query_flag_retry(hba, UPIU_QUERY_OPCODE_SET_FLAG,
-				      QUERY_FLAG_IDN_WB_BUFF_FLUSH_EN,
-				      index, NULL);
-	if (ret)
-		dev_err(hba->dev, "%s WB - buf flush enable failed %d\n",
-			__func__, ret);
-	else
-		hba->dev_info.wb_buf_flush_enabled = true;
-
-	dev_dbg(hba->dev, "WB - Flush enabled: %d\n", ret);
-	return ret;
-}
-
-static int ufshcd_wb_buf_flush_disable(struct ufs_hba *hba)
-{
-	int ret;
-	u8 index;
-
-	if (!ufshcd_is_wb_allowed(hba) || !hba->dev_info.wb_buf_flush_enabled)
+	if (!ufshcd_is_wb_allowed(hba) ||
+	    hba->dev_info.wb_buf_flush_enabled == enable)
 		return 0;
 
+	if (enable)
+		opcode = UPIU_QUERY_OPCODE_SET_FLAG;
+	else
+		opcode = UPIU_QUERY_OPCODE_CLEAR_FLAG;
+
 	index = ufshcd_wb_get_query_index(hba);
-	ret = ufshcd_query_flag_retry(hba, UPIU_QUERY_OPCODE_CLEAR_FLAG,
-				      QUERY_FLAG_IDN_WB_BUFF_FLUSH_EN,
-				      index, NULL);
+	ret = ufshcd_query_flag_retry(hba, opcode,
+				      QUERY_FLAG_IDN_WB_BUFF_FLUSH_EN, index,
+				      NULL);
 	if (ret) {
-		dev_warn(hba->dev, "%s: WB - buf flush disable failed %d\n",
-			 __func__, ret);
-	} else {
-		hba->dev_info.wb_buf_flush_enabled = false;
-		dev_dbg(hba->dev, "WB - Flush disabled: %d\n", ret);
+		dev_err(hba->dev, "%s WB-Buf Flush %s failed %d\n", __func__,
+			enable ? "enable" : "disable", ret);
+		goto out;
 	}
 
+	hba->dev_info.wb_buf_flush_enabled = enable;
+
+	dev_dbg(hba->dev, "WB-Buf Flush %s\n", enable ? "enabled" : "disabled");
+out:
 	return ret;
 }
 
-- 
2.17.1

