Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 91147C433EF
	for <linux-scsi@archiver.kernel.org>; Tue, 12 Apr 2022 18:21:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357356AbiDLSXa (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 12 Apr 2022 14:23:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56636 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241256AbiDLSX2 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 12 Apr 2022 14:23:28 -0400
Received: from mail-pg1-f180.google.com (mail-pg1-f180.google.com [209.85.215.180])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 48C085D64B
        for <linux-scsi@vger.kernel.org>; Tue, 12 Apr 2022 11:21:10 -0700 (PDT)
Received: by mail-pg1-f180.google.com with SMTP id t13so17996110pgn.8
        for <linux-scsi@vger.kernel.org>; Tue, 12 Apr 2022 11:21:10 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=/6uWtAD/SeeR09KP91P5TwvCx574f8Z/VJ0xjlNkqlU=;
        b=eLfiRINlq1BaOyvMuwmSL1Qfcw563RrLH3EmWJzD9L/eKP+wnsZKCO3u5bhLsYQ1F5
         v59wOaz+5+j3jKPzTlcY/A55/QlVlfgWmqKjBephPcGF9jxxSrWlEQrI4nRZgoFxU3Fe
         bgnllBdhRMXZVz7zzdhLQYXuymLGd2vTa5DRW/ANYYTB3b93NjOuDGxbhZwLIPIETL4R
         2+tht0I2/4FfYTN1+PpSfkCzmVNfD3v2WyMJnxF7G9lcY5seY+ADSvgwRouRwJF+SCkO
         UQ6St84J6iTi6mP2Ax8+vrQDqjtmpo9Ktzgq+fBHdaOKzZlHVzyG5rkfWXXU6iDci57O
         TtVA==
X-Gm-Message-State: AOAM533zG5G9rUST62VOoJ4eSXjQhERoCJfN5ZSndt4VbZXYZUDdd2pp
        4GxXC5TC4Cn+HkM9ztNBoOM=
X-Google-Smtp-Source: ABdhPJxcjiSAdrDBAUK+TNOELNvjwpm2Sat/Vj+LyocDsuWO5Xfw9sw1/W40CUNTsGxwTY6Z8J3Spg==
X-Received: by 2002:a05:6a00:1d15:b0:505:d605:38fc with SMTP id a21-20020a056a001d1500b00505d60538fcmr5890516pfx.41.1649787669673;
        Tue, 12 Apr 2022 11:21:09 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:d4b2:56ee:d001:c159])
        by smtp.gmail.com with ESMTPSA id d18-20020a056a0010d200b004fa2e13ce80sm40367037pfu.76.2022.04.12.11.21.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Apr 2022 11:21:08 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Jaegeuk Kim <jaegeuk@kernel.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Stanley Chu <stanley.chu@mediatek.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Avri Altman <avri.altman@wdc.com>,
        Daejun Park <daejun7.park@samsung.com>,
        Bean Huo <beanhuo@micron.com>,
        Jinyoung Choi <j-young.choi@samsung.com>,
        Asutosh Das <quic_asutoshd@quicinc.com>
Subject: [PATCH v2 12/29] scsi: ufs: Remove unused constants and code
Date:   Tue, 12 Apr 2022 11:18:36 -0700
Message-Id: <20220412181853.3715080-13-bvanassche@acm.org>
X-Mailer: git-send-email 2.36.0.rc0.470.gd361397f0d-goog
In-Reply-To: <20220412181853.3715080-1-bvanassche@acm.org>
References: <20220412181853.3715080-1-bvanassche@acm.org>
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
