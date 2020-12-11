Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A3A5BC433FE
	for <linux-scsi@archiver.kernel.org>; Fri, 11 Dec 2020 14:03:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6D87323ED2
	for <linux-scsi@archiver.kernel.org>; Fri, 11 Dec 2020 14:03:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405800AbgLKOCU (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 11 Dec 2020 09:02:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40374 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2395187AbgLKOCG (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 11 Dec 2020 09:02:06 -0500
Received: from mail-ed1-x541.google.com (mail-ed1-x541.google.com [IPv6:2a00:1450:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A8DBC0617A7;
        Fri, 11 Dec 2020 06:00:55 -0800 (PST)
Received: by mail-ed1-x541.google.com with SMTP id i24so9414517edj.8;
        Fri, 11 Dec 2020 06:00:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=gr2XJl42rv3oVZgNGsbktH407LTsgPIoPeTR72KZolo=;
        b=NHcmN/iXMsw6ZzTILGUUMUhiwjq8IFvbwnhr32AfUJUfERHb9Y2xP8ghOPITGb+Bor
         vjxEqGX6Xp05MY1TWiPyG9paCYtedoqplaPdYMKcu4N2/3tNWivr0egC68bdmrB3FSyr
         hA0ZAoa3Y/9apYZlJu1D1QePXSe+yYimZezjybYiyUPLXo9VSFQvmDehFu8m/YtQbFhL
         KrRIQsJKkXMuMEOaFSUpR59kHVFEa1BhTi2uGh2CDVdmYKin6TmiZd1VVyH4oxSguRiq
         KNFEHNXl0SD2MIeq7uHpNu7H7eGFreLgTHy7EZTCc03NQlNaBiMQB+04Zg2XOuOLVwsj
         mlDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=gr2XJl42rv3oVZgNGsbktH407LTsgPIoPeTR72KZolo=;
        b=bbS5jqSf3CrVjUvH9mnKVFuohGEgrDngJPmHb8elXUofOzIwQFTK58+GI45GOqDfOX
         R4VFxtb+uR3rPAnshxRbkJOT4Fk+hYLPJyyR9U5baaiuXddqJ/fkJNIxPd9sYV39rpN0
         N2ETayA1vu3R5QMovqGBvigY93pB80mq46oUY7+qMXpnzSw4mfzracG7B19sLBRUKZMQ
         v/BCQYJiJAxaecg7nKGjbcK0Rdk8WGYT3sZZFNSiM+aSkBeu2GYYVQaS3+hZCSq41J8e
         +nf2gGmCx9PrujznnQ569UYbWafNRElR1jNKCc0RyJ6/LS64826HPkY3rtBIWSd6G3NB
         biiw==
X-Gm-Message-State: AOAM5306ktZNoKqCnoCbraVRq2+TvfsJ9wYqtF4Ixx9+0og5Rer2p/3k
        pc4w+o3JpX8zh5IojCH48Lo=
X-Google-Smtp-Source: ABdhPJzGweQ185WwTWnQ72Qyip+ZPnmaRKQQYrLSNqrWQz4v2Rvf7vlEpc9Jqx6ADWmes4VbweRJWQ==
X-Received: by 2002:aa7:d919:: with SMTP id a25mr11609987edr.81.1607695253857;
        Fri, 11 Dec 2020 06:00:53 -0800 (PST)
Received: from localhost.localdomain (ip5f5bfce9.dynamic.kabel-deutschland.de. [95.91.252.233])
        by smtp.gmail.com with ESMTPSA id z24sm7797818edr.9.2020.12.11.06.00.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 11 Dec 2020 06:00:53 -0800 (PST)
From:   Bean Huo <huobean@gmail.com>
To:     alim.akhtar@samsung.com, avri.altman@wdc.com,
        asutoshd@codeaurora.org, jejb@linux.ibm.com,
        martin.petersen@oracle.com, stanley.chu@mediatek.com,
        beanhuo@micron.com, bvanassche@acm.org, tomas.winkler@intel.com,
        cang@codeaurora.org
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v4 5/6] scsi: ufs: Cleanup WB buffer flush toggle implementation
Date:   Fri, 11 Dec 2020 15:00:34 +0100
Message-Id: <20201211140035.20016-6-huobean@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20201211140035.20016-1-huobean@gmail.com>
References: <20201211140035.20016-1-huobean@gmail.com>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Bean Huo <beanhuo@micron.com>

Delete ufshcd_wb_buf_flush_enable() and ufshcd_wb_buf_flush_disable(),
move the implementation into ufshcd_wb_toggle_flush().

Signed-off-by: Bean Huo <beanhuo@micron.com>
---
 drivers/scsi/ufs/ufshcd.c | 69 ++++++++++++++-------------------------
 1 file changed, 24 insertions(+), 45 deletions(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 0998e6103cd7..fb3c98724005 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -244,10 +244,8 @@ static int ufshcd_setup_vreg(struct ufs_hba *hba, bool on);
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
 
@@ -5398,60 +5396,41 @@ static int ufshcd_wb_toggle_flush_during_h8(struct ufs_hba *hba, bool set)
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
 
+	if (enable)
+		hba->dev_info.wb_buf_flush_enabled = true;
+	else
+		hba->dev_info.wb_buf_flush_enabled = false;
+
+	dev_dbg(hba->dev, "WB-Buf Flush %s\n", enable ? "enabled" : "disabled");
+out:
 	return ret;
 }
 
-- 
2.17.1

