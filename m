Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C33F5C83014
	for <linux-scsi@archiver.kernel.org>; Mon, 30 Nov 2020 18:13:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6CE0620789
	for <linux-scsi@archiver.kernel.org>; Mon, 30 Nov 2020 18:13:07 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="EhmopWP8"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729579AbgK3SMn (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 30 Nov 2020 13:12:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54314 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726614AbgK3SMm (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 30 Nov 2020 13:12:42 -0500
Received: from mail-ej1-x642.google.com (mail-ej1-x642.google.com [IPv6:2a00:1450:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 33FC9C0613D4;
        Mon, 30 Nov 2020 10:12:01 -0800 (PST)
Received: by mail-ej1-x642.google.com with SMTP id f9so21360177ejw.4;
        Mon, 30 Nov 2020 10:12:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=KDipjwWhvzyuf6p2VfgEeN4YKE0FlgZ/bBRgOjYzpyY=;
        b=EhmopWP8k+3dyy/ahXG7QVWF5mrm02rm+rJsQknyFAklct2tM8/WXL2TGheNTOpEDJ
         YLi0WShSj8mlrpM6kMDyXB/FqofFLwGgxQqDlLX4SODZy8A8C0E9Jc3myNJTSYgvtBMH
         TAAi0MtTCvr97YBhTIZbvaH36WrjDhWv5QS6297qmDbWT5nnveYoZx/9c9tIKEmo2ee3
         jdEmFEABsCvYLnjRY5wFaX2tXu8HpEjrU7sfJVRal//Z4zsEs5k/TVUFyNc22D1N77RR
         cMYR2PoivYihYf0nYlQfCtcjoPt5NFjIqbcFN578obf2097nkVN9fSVxOpTCMidafBCl
         JELw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=KDipjwWhvzyuf6p2VfgEeN4YKE0FlgZ/bBRgOjYzpyY=;
        b=PLFxLDQTljkQ1yVr7BNU1G5kMxmfhV9POne4P+fWWKW1QM72po1wta34pzl88x9rR/
         cQJ34Uor+QeRY7/GoVdp6puRXsPEB3NoqCbGP6qozZ9ye7nzFirg7fpf6xl1L/G9/mHz
         Lmo4IRmiFpusuO4Z5HmHS+dM22emXrFzZ4+cl+LfuiS29gOohQcjSfLDX272Coz/syXX
         yXZdW1HcIPFNVvpCZsMlts02GfTnurBfmvHKiQ9YzmAgUmJi1fltKGdbcYFj593f0ch/
         t59KnkcawKhVVKF+IGfDFuGeAiwjbnt0MNLTZSr7B+OrH870huJsbtvCaf311wK9bSyA
         vZmQ==
X-Gm-Message-State: AOAM532OqL/AOR9qi/jLlbIQ+HASTxi2X3BZmXMLX5GlbDn5YFjGIxci
        37tL0T6AMvJgZWLb6s1QL+s=
X-Google-Smtp-Source: ABdhPJxdwAky6OvIpwUTc3n9Vt+7JQL7NsCyibABHjrU7zjuOUHwMzAD9F2fxiNB45gEpSbOeM2ZQg==
X-Received: by 2002:a17:906:edca:: with SMTP id sb10mr22038409ejb.284.1606759919976;
        Mon, 30 Nov 2020 10:11:59 -0800 (PST)
Received: from localhost.localdomain (ip5f5bfce9.dynamic.kabel-deutschland.de. [95.91.252.233])
        by smtp.gmail.com with ESMTPSA id d14sm2702899edn.31.2020.11.30.10.11.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 30 Nov 2020 10:11:59 -0800 (PST)
From:   Bean Huo <huobean@gmail.com>
To:     alim.akhtar@samsung.com, avri.altman@wdc.com,
        asutoshd@codeaurora.org, jejb@linux.ibm.com,
        martin.petersen@oracle.com, stanley.chu@mediatek.com,
        beanhuo@micron.com, bvanassche@acm.org, tomas.winkler@intel.com,
        cang@codeaurora.org
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 2/3] scsi: ufs: Keep device power on only fWriteBoosterBufferFlushDuringHibernate == 1
Date:   Mon, 30 Nov 2020 19:11:42 +0100
Message-Id: <20201130181143.5739-3-huobean@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20201130181143.5739-1-huobean@gmail.com>
References: <20201130181143.5739-1-huobean@gmail.com>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Bean Huo <beanhuo@micron.com>

Keep device power mode as active power mode and VCC supply only if
fWriteBoosterBufferFlushDuringHibernate setting 1 is successful.

Signed-off-by: Bean Huo <beanhuo@micron.com>
---
 drivers/scsi/ufs/ufs.h    |  2 ++
 drivers/scsi/ufs/ufshcd.c | 11 ++++++++++-
 2 files changed, 12 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/ufs/ufs.h b/drivers/scsi/ufs/ufs.h
index d593edb48767..311d5f7a024d 100644
--- a/drivers/scsi/ufs/ufs.h
+++ b/drivers/scsi/ufs/ufs.h
@@ -530,6 +530,8 @@ struct ufs_dev_info {
 	bool f_power_on_wp_en;
 	/* Keeps information if any of the LU is power on write protected */
 	bool is_lu_power_on_wp;
+	/* Indicates if flush WB buffer during hibern8 successfully enabled */
+	bool is_hibern8_wb_flush;
 	/* Maximum number of general LU supported by the UFS device */
 	u8 max_lu_supported;
 	u8 wb_dedicated_lu;
diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 639ba9d1ccbb..eb7a2534b072 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -285,10 +285,16 @@ static inline void ufshcd_wb_config(struct ufs_hba *hba)
 		dev_err(hba->dev, "%s: Enable WB failed: %d\n", __func__, ret);
 	else
 		dev_info(hba->dev, "%s: Write Booster Configured\n", __func__);
+
 	ret = ufshcd_wb_toggle_flush_during_h8(hba, true);
-	if (ret)
+	if (ret) {
 		dev_err(hba->dev, "%s: En WB flush during H8: failed: %d\n",
 			__func__, ret);
+		hba->dev_info.is_hibern8_wb_flush = false;
+	} else {
+		hba->dev_info.is_hibern8_wb_flush = true;
+	}
+
 	ufshcd_wb_toggle_flush(hba, true);
 }
 
@@ -5440,6 +5446,9 @@ static bool ufshcd_wb_need_flush(struct ufs_hba *hba)
 
 	if (!ufshcd_is_wb_allowed(hba))
 		return false;
+
+	if (!hba->dev_info.is_hibern8_wb_flush)
+		return false;
 	/*
 	 * The ufs device needs the vcc to be ON to flush.
 	 * With user-space reduction enabled, it's enough to enable flush
-- 
2.17.1

