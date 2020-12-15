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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 32225C4361B
	for <linux-scsi@archiver.kernel.org>; Tue, 15 Dec 2020 23:14:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 045A822D03
	for <linux-scsi@archiver.kernel.org>; Tue, 15 Dec 2020 23:14:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730358AbgLOXOt (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 15 Dec 2020 18:14:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38856 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731272AbgLOXG3 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 15 Dec 2020 18:06:29 -0500
Received: from mail-ed1-x544.google.com (mail-ed1-x544.google.com [IPv6:2a00:1450:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 48CAFC06138C;
        Tue, 15 Dec 2020 15:05:38 -0800 (PST)
Received: by mail-ed1-x544.google.com with SMTP id c7so22823373edv.6;
        Tue, 15 Dec 2020 15:05:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=r4FGDCmd+0tOnQUnhUjyrOq68wQ6sbCmcoaPkblTkR4=;
        b=SJK4VON4/+ArqS95wzCeyGs8tfpxllXc2Ib6ixSipQ6rDcD9br/DB4LtUVYwLfSiRH
         1z1WixGmki5TgSPAorMTGttULKDvMU09XCXElZd1fqXxHI63TP5agReIGhVeik5W33ll
         IHp2kIPVL9SzDJ1fpm7WJE/R0mgNlXtuA2L1TBh3hNvmDIiCTP59p7CuHwpAzmMBBNZ+
         a5yByLWAGvccISFga7gB6sfOe/wlHM89L8L1H6m2BCexDsUgvgSJ+2xmEYNm/qKXv66i
         KhH4ktJvqxM7q5F2qvlXPhdVhI4ORcmz1V2KJ9jlNijJBDh+2Y3z3CZPU40PCsbjOYy1
         8sCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=r4FGDCmd+0tOnQUnhUjyrOq68wQ6sbCmcoaPkblTkR4=;
        b=YJPjCKT71vOELCQrk5m6TzQLNMYxjZI981q+WdQ09RkqDjfWGlXklE73Tkw/zsTbzu
         KURmwfg0utp5maIw9pRu5JiDWXRLxRImsI6LoHz6mzUZM7C+0JenK6gxXl1h9zJwvWUT
         1iJFtv0sjCPRwjLm4QGhROACqDgP+E8SpsTu0vehmnpzFPDhdqdcuhxmbb0VkjeEyCm5
         eTz4NP6py7FzR6RKJz10458Zh2ros43dDDQC5zYVUkGJi4OMzx6U6gIAlsMB3J0SvmST
         wfqPLBQjdOh7veYw+lQLrMe5GMv6Z0gFJJmyg+CKnCXpEQmcxOJST2Y4hGgCjKm4my23
         DkEA==
X-Gm-Message-State: AOAM530Ip124JIA0T+zPyT1aTv4mfOMPM4Or7D9vFrKXo5is+cH+UI72
        Yyhgi0TOEzqjdOxkMrYf39Y=
X-Google-Smtp-Source: ABdhPJzObl9SHeHT0XSe0Qpl97mPQeJb9b5r1dk+z0mrWrJ9ywQUSpiALXbO6rftdANXuu+luCRAIw==
X-Received: by 2002:aa7:dc0d:: with SMTP id b13mr31773026edu.170.1608073537030;
        Tue, 15 Dec 2020 15:05:37 -0800 (PST)
Received: from localhost.localdomain (ip5f5bfce9.dynamic.kabel-deutschland.de. [95.91.252.233])
        by smtp.gmail.com with ESMTPSA id e11sm19280455edj.44.2020.12.15.15.05.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Dec 2020 15:05:36 -0800 (PST)
From:   Bean Huo <huobean@gmail.com>
To:     alim.akhtar@samsung.com, avri.altman@wdc.com,
        asutoshd@codeaurora.org, jejb@linux.ibm.com,
        martin.petersen@oracle.com, stanley.chu@mediatek.com,
        beanhuo@micron.com, bvanassche@acm.org, tomas.winkler@intel.com,
        cang@codeaurora.org
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v5 6/7] scsi: ufs: Cleanup WB buffer flush toggle implementation
Date:   Wed, 16 Dec 2020 00:05:18 +0100
Message-Id: <20201215230519.15158-7-huobean@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20201215230519.15158-1-huobean@gmail.com>
References: <20201215230519.15158-1-huobean@gmail.com>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Bean Huo <beanhuo@micron.com>

Delete ufshcd_wb_buf_flush_enable() and ufshcd_wb_buf_flush_disable(),
move the implementation into ufshcd_wb_toggle_flush().

Signed-off-by: Bean Huo <beanhuo@micron.com>
---
 drivers/scsi/ufs/ufshcd.c | 66 +++++++++++++--------------------------
 1 file changed, 21 insertions(+), 45 deletions(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 466a85051d54..ba8298f0d017 100644
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
 
@@ -5398,60 +5396,38 @@ static int ufshcd_wb_toggle_flush_during_h8(struct ufs_hba *hba, bool set)
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

