Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6D0D8C433DB
	for <linux-scsi@archiver.kernel.org>; Mon, 18 Jan 2021 20:13:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 42FAE230FF
	for <linux-scsi@archiver.kernel.org>; Mon, 18 Jan 2021 20:13:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437751AbhARUMw (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 18 Jan 2021 15:12:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43118 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2437838AbhARULk (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 18 Jan 2021 15:11:40 -0500
Received: from mail-ej1-x62f.google.com (mail-ej1-x62f.google.com [IPv6:2a00:1450:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AFE79C0613D6;
        Mon, 18 Jan 2021 12:10:59 -0800 (PST)
Received: by mail-ej1-x62f.google.com with SMTP id rv9so6598917ejb.13;
        Mon, 18 Jan 2021 12:10:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=fRVeJFHSbx0u4PcEewve+lvBzm+Q5dzCsl6CUEyzawk=;
        b=n7+6hKeJB/Fz3XHtf81zow6s4OMrwMLi9QFbuO1utYopq5HGH0Rlhi1y6SIBTKMQiP
         +enK3OXDKTbs6oXmI9VaV0G8KIWfIQxoTNKWkyKSyourTyYWQIulJrhuznl/vym/cjN3
         57GxUJv9HBBbQ7gkQI+IDd+DNdAOlsHg3I4i0pxhOYJwYv/cvQ3oGaclj5JD7sT61uf4
         ARHK/nFpLFo3Kt3v0vOjlXI8om+HN6mzGC/9WhXMJ16QxHUPV0cMS73mAhZmVQ5PACFG
         Mt5AF+/SytLG2fT18/Q4P3IZr6mGoPcAxI6s5d2ooNxbglb9beyiqrphKJsf15+o9e81
         QiTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=fRVeJFHSbx0u4PcEewve+lvBzm+Q5dzCsl6CUEyzawk=;
        b=RR8z6BlpIjPJQbidpE7mw49dueSmk8uL86poLR90Futkz6qw0w+/UkeZqvkKSrjaCN
         NXbL6SeU8FQ4svxFejBWyubeKXTymQ2sL3bWSJ47jW82XJomjKkhRuQNlybkOjUq9ej/
         iSFTek+8NQ2yH7d/ByjJHK6/TqktwiLyBFFRSYkjO7jXEQaOSFGcEVF384vZl6y05ZMp
         Tuy1CFK8dEP45u3XeGkGObG05s9c7UXP8upILWv71lmAmTs/V7ywmvtJL+O1qjOPLsF5
         U38FMsaVpFuKz7bsX0NU/AqxazTnRkTWZKxj5cWSWBZ7mJa72ruo9lv2FVCst4pNEOj/
         dFkw==
X-Gm-Message-State: AOAM531dKhySgsYg3LvUkqhKoX45PuPkr1JEmqMJEAUiyX0u3hey0FVT
        gU6fr07YM4089BEQLPlwvcw=
X-Google-Smtp-Source: ABdhPJwk8R8GnHh0gWYN7oDsd3SWhLTBfFUCuF2rToevpkMPR2/5z6Ctv6aOJuFgrVmTC7drsfJJSQ==
X-Received: by 2002:a17:907:7356:: with SMTP id dq22mr882714ejc.318.1611000658457;
        Mon, 18 Jan 2021 12:10:58 -0800 (PST)
Received: from localhost.localdomain (ip5f5bee1b.dynamic.kabel-deutschland.de. [95.91.238.27])
        by smtp.gmail.com with ESMTPSA id qh13sm3972543ejb.33.2021.01.18.12.10.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Jan 2021 12:10:58 -0800 (PST)
From:   Bean Huo <huobean@gmail.com>
To:     alim.akhtar@samsung.com, avri.altman@wdc.com,
        asutoshd@codeaurora.org, jejb@linux.ibm.com,
        martin.petersen@oracle.com, stanley.chu@mediatek.com,
        beanhuo@micron.com, bvanassche@acm.org, tomas.winkler@intel.com,
        cang@codeaurora.org
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v6 6/6] scsi: ufs: Cleanup WB buffer flush toggle implementation
Date:   Mon, 18 Jan 2021 21:10:39 +0100
Message-Id: <20210118201039.2398-7-huobean@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210118201039.2398-1-huobean@gmail.com>
References: <20210118201039.2398-1-huobean@gmail.com>
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
index 9f857af3766a..10bee49ccbc8 100644
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

