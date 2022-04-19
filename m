Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 31AD2C433FE
	for <linux-scsi@archiver.kernel.org>; Tue, 19 Apr 2022 22:58:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356526AbiDSXBf (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 19 Apr 2022 19:01:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52186 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358380AbiDSXB1 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 19 Apr 2022 19:01:27 -0400
Received: from mail-pj1-f43.google.com (mail-pj1-f43.google.com [209.85.216.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A02038781
        for <linux-scsi@vger.kernel.org>; Tue, 19 Apr 2022 15:58:43 -0700 (PDT)
Received: by mail-pj1-f43.google.com with SMTP id u5-20020a17090a6a8500b001d0b95031ebso199538pjj.3
        for <linux-scsi@vger.kernel.org>; Tue, 19 Apr 2022 15:58:43 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=/6uWtAD/SeeR09KP91P5TwvCx574f8Z/VJ0xjlNkqlU=;
        b=Cnli1oFsqfB/QbegkRYCHTsOyaFX1ariCQvuhRAVhsN+QhK0Z5hjcrCsIxE6RAUKIr
         ZOo82ZXaO9P8vEFNdf7IqzsdhNk0LJZV7q/X25noWkcekeyfR/dz+42RgGmEclw7Dfuz
         t0fzE+6WLNrvtMGQZ5FbVL43R7Xv2f2W7X8bSBtgRC5F8cXV3cRzaubHjQXy9Bw9lJRQ
         L7fjt+lDeA1ixCMxFEh4gpSBJtEVdMTpmcu6SX5LOUvbAhLgSVAj6PEDIvUcDi1bxNIE
         nUfsw2K+8dQvG8Vl/jkiel+g6hY/HqPNUfzPf0dAVsVwgeXVtsW3oNIAOZ+EGFpNVgYj
         ERCQ==
X-Gm-Message-State: AOAM532tuPVWHnq29gKsdvVIfWe+luOlGRX55QUxi7EuuuhM9jWIt0y+
        L9ZXct/83LIgU8aDV/MTkas=
X-Google-Smtp-Source: ABdhPJxn6X04Yvv/5BrBmYBsvouZIFypWHu9yuIDh7jlUawjiCP3LymZRRnu4Lz4BxikyTNpa6S1VA==
X-Received: by 2002:a17:903:40ce:b0:158:8178:8563 with SMTP id t14-20020a17090340ce00b0015881788563mr17378078pld.167.1650409122675;
        Tue, 19 Apr 2022 15:58:42 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:59ec:2e90:f751:1806])
        by smtp.gmail.com with ESMTPSA id c15-20020a63350f000000b003992202f95fsm17622557pga.38.2022.04.19.15.58.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Apr 2022 15:58:41 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Jaegeuk Kim <jaegeuk@kernel.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Stanley Chu <stanley.chu@mediatek.com>
Subject: [PATCH v3 12/28] scsi: ufs: Remove unused constants and code
Date:   Tue, 19 Apr 2022 15:57:55 -0700
Message-Id: <20220419225811.4127248-13-bvanassche@acm.org>
X-Mailer: git-send-email 2.36.0.rc0.470.gd361397f0d-goog
In-Reply-To: <20220419225811.4127248-1-bvanassche@acm.org>
References: <20220419225811.4127248-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Commit 5b44a07b6bb2 ("scsi: ufs: Remove pre-defined initial voltage values
of device power") removed the code that uses the UFS_VREG_VCC* constants
and also the code that sets the min_uV and max_uV member variables. Hence
also remove these constants and that member variable.

Reviewed-by: Stanley Chu <stanley.chu@mediatek.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/ufs/ufs.h    | 11 -----------
 drivers/scsi/ufs/ufshcd.c | 29 +++--------------------------
 2 files changed, 3 insertions(+), 37 deletions(-)

diff --git a/drivers/scsi/ufs/ufs.h b/drivers/scsi/ufs/ufs.h
index 4a00c24a3209..225b5b4a2a7e 100644
--- a/drivers/scsi/ufs/ufs.h
+++ b/drivers/scsi/ufs/ufs.h
@@ -562,15 +562,6 @@ struct ufs_query_res {
 	struct utp_upiu_query upiu_res;
 };
 
-#define UFS_VREG_VCC_MIN_UV	   2700000 /* uV */
-#define UFS_VREG_VCC_MAX_UV	   3600000 /* uV */
-#define UFS_VREG_VCC_1P8_MIN_UV    1700000 /* uV */
-#define UFS_VREG_VCC_1P8_MAX_UV    1950000 /* uV */
-#define UFS_VREG_VCCQ_MIN_UV	   1140000 /* uV */
-#define UFS_VREG_VCCQ_MAX_UV	   1260000 /* uV */
-#define UFS_VREG_VCCQ2_MIN_UV	   1700000 /* uV */
-#define UFS_VREG_VCCQ2_MAX_UV	   1950000 /* uV */
-
 /*
  * VCCQ & VCCQ2 current requirement when UFS device is in sleep state
  * and link is in Hibern8 state.
@@ -582,8 +573,6 @@ struct ufs_vreg {
 	const char *name;
 	bool always_on;
 	bool enabled;
-	int min_uV;
-	int max_uV;
 	int max_uA;
 };
 
diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index eabc6b6156fd..69198e37c976 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -8309,33 +8309,10 @@ static inline int ufshcd_config_vreg_hpm(struct ufs_hba *hba,
 static int ufshcd_config_vreg(struct device *dev,
 		struct ufs_vreg *vreg, bool on)
 {
-	int ret = 0;
-	struct regulator *reg;
-	const char *name;
-	int min_uV, uA_load;
-
-	BUG_ON(!vreg);
-
-	reg = vreg->reg;
-	name = vreg->name;
-
-	if (regulator_count_voltages(reg) > 0) {
-		uA_load = on ? vreg->max_uA : 0;
-		ret = ufshcd_config_vreg_load(dev, vreg, uA_load);
-		if (ret)
-			goto out;
+	if (regulator_count_voltages(vreg->reg) <= 0)
+		return 0;
 
-		if (vreg->min_uV && vreg->max_uV) {
-			min_uV = on ? vreg->min_uV : 0;
-			ret = regulator_set_voltage(reg, min_uV, vreg->max_uV);
-			if (ret)
-				dev_err(dev,
-					"%s: %s set voltage failed, err=%d\n",
-					__func__, name, ret);
-		}
-	}
-out:
-	return ret;
+	return ufshcd_config_vreg_load(dev, vreg, on ? vreg->max_uA : 0);
 }
 
 static int ufshcd_enable_vreg(struct device *dev, struct ufs_vreg *vreg)
