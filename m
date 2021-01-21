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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 98DC2C433E0
	for <linux-scsi@archiver.kernel.org>; Thu, 21 Jan 2021 19:10:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5491723A58
	for <linux-scsi@archiver.kernel.org>; Thu, 21 Jan 2021 19:10:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726427AbhAUTKg (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 21 Jan 2021 14:10:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56724 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726939AbhAUTJz (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 21 Jan 2021 14:09:55 -0500
Received: from mail-ed1-x530.google.com (mail-ed1-x530.google.com [IPv6:2a00:1450:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C16CC06178A;
        Thu, 21 Jan 2021 10:57:50 -0800 (PST)
Received: by mail-ed1-x530.google.com with SMTP id n6so3738799edt.10;
        Thu, 21 Jan 2021 10:57:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=DWKkorkSuzcODZKyQLmKsJHfB0QKivboYyFeNZx/BBE=;
        b=JKvmrraDWtUR4zoZKRUWKidZHOGdk8rx58ra0Wox7icgpShUwOUhosEB0FnyaDnjJE
         fQhu+M8aUfN3TfoVNWjvXa25QIEW093x0V0u1pIIs5fOeju32nk5JUud4K/AIfNJ1DaQ
         xnAGRZwHJ78aRNeBRgZtsims9OmZYFpbIkzy4N7tAJi2MYeqMi+HIgpcLzhZHUneE2I8
         kxPmUetJxGNFu8tjTDsLoStxIqrv72bBX0XUpRqFJfp4FzZ5LvuVGTeYOs9y9ZQSU3So
         x0iIIBHktQv+usBGOe2564XaAdMHSYbRX77fY2WORrWbNGp50WuxbZonbKpDJLNcDoq/
         GaZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=DWKkorkSuzcODZKyQLmKsJHfB0QKivboYyFeNZx/BBE=;
        b=sPNy4dNWImcNtbEmnsSKlFpqG1NgwpybOPS/2/+FBsuyEFK3b2CAjAV7SoqbzDyufo
         k5bR+lHZ3uoedo3fSvoFzzNW7BUAMwRR1DjZw1FOmhzdoiVlOAqR6xjle2TDn98n+kKJ
         OkBWJRAaeThf3L9Fyu4zNcGVTrzXvvtfyE/EHzmwNb1nZLOiQIfWMcUJfk7NnDEafyi4
         S99AjkfILQd8Tq9ih77/L18hduLAzhUpDaKX/grDUfqKTKfEwi+emiTjGzyDXboH2KhA
         MToM7RzhSvfrTD5x8T3/toP0NLjGo0DLQ5TTQb53Z5o6UAsxYnFkCbxht2/uAjLvvhAJ
         GmBA==
X-Gm-Message-State: AOAM5327Tf7aaY3UlcE+Aejy90DlpQzGGEr0Y8x4dcDr04POJOCAJFEO
        h8Ad4MdkTWBveZtvzfj+ihI=
X-Google-Smtp-Source: ABdhPJzPJplAOXxyT4TsfQajY2gvfoILUsvpWhjd/7sp1DdMXGjh1IFvkNIC/N3KXDO96XyssAtf1g==
X-Received: by 2002:a05:6402:d1:: with SMTP id i17mr432284edu.85.1611255469368;
        Thu, 21 Jan 2021 10:57:49 -0800 (PST)
Received: from localhost.localdomain (ip5f5bee1b.dynamic.kabel-deutschland.de. [95.91.238.27])
        by smtp.gmail.com with ESMTPSA id x17sm3236491edq.77.2021.01.21.10.57.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 Jan 2021 10:57:48 -0800 (PST)
From:   Bean Huo <huobean@gmail.com>
To:     alim.akhtar@samsung.com, avri.altman@wdc.com,
        asutoshd@codeaurora.org, jejb@linux.ibm.com,
        martin.petersen@oracle.com, stanley.chu@mediatek.com,
        beanhuo@micron.com, bvanassche@acm.org, tomas.winkler@intel.com,
        cang@codeaurora.org
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] scsi: ufs: Cleanup WB buffer flush toggle implementation
Date:   Thu, 21 Jan 2021 19:57:36 +0100
Message-Id: <20210121185736.12471-1-huobean@gmail.com>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Bean Huo <beanhuo@micron.com>

Delete ufshcd_wb_buf_flush_enable() and ufshcd_wb_buf_flush_disable(),
move the implementation into ufshcd_wb_toggle_flush().

Reviewed-by: Stanley Chu <stanley.chu@mediatek.com>
Reviewed-by: Can Guo <cang@codeaurora.org>
Signed-off-by: Bean Huo <beanhuo@micron.com>
---
    Changelog:
    1. Rebased the patch onto 5.12/scsi-staging, since existing one conflict
    with commit 21acf4601cc6 ("scsi: ufs: Relax the condition of
    UFSHCI_QUIRK_SKIP_MANUAL_WB_FLUSH_CTRL"), which results in applying failure.
---
 drivers/scsi/ufs/ufshcd.c | 61 ++++++++++++---------------------------
 1 file changed, 19 insertions(+), 42 deletions(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 9c691e4ab490..c8a862aa1f87 100644
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
 
@@ -5476,58 +5474,37 @@ static int ufshcd_wb_toggle_flush_during_h8(struct ufs_hba *hba, bool set)
 				index, NULL);
 }
 
-static inline void ufshcd_wb_toggle_flush(struct ufs_hba *hba, bool enable)
-{
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
+	if (!ufshcd_is_wb_allowed(hba) ||
+	    hba->dev_info.wb_buf_flush_enabled == enable)
 		return 0;
 
-	index = ufshcd_wb_get_query_index(hba);
-	ret = ufshcd_query_flag_retry(hba, UPIU_QUERY_OPCODE_SET_FLAG,
-				      QUERY_FLAG_IDN_WB_BUFF_FLUSH_EN,
-				      index, NULL);
-	if (ret)
-		dev_err(hba->dev, "%s WB - buf flush enable failed %d\n",
-			__func__, ret);
+	if (enable)
+		opcode = UPIU_QUERY_OPCODE_SET_FLAG;
 	else
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
-		return 0;
+		opcode = UPIU_QUERY_OPCODE_CLEAR_FLAG;
 
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
+
 }
 
 static bool ufshcd_wb_presrv_usrspc_keep_vcc_on(struct ufs_hba *hba,
-- 
2.17.1

