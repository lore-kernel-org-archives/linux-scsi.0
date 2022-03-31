Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 62251C433F5
	for <linux-scsi@archiver.kernel.org>; Thu, 31 Mar 2022 22:36:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242577AbiCaWiU (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 31 Mar 2022 18:38:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60026 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242564AbiCaWiN (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 31 Mar 2022 18:38:13 -0400
Received: from mail-pg1-f171.google.com (mail-pg1-f171.google.com [209.85.215.171])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 904E01F42F3
        for <linux-scsi@vger.kernel.org>; Thu, 31 Mar 2022 15:36:25 -0700 (PDT)
Received: by mail-pg1-f171.google.com with SMTP id b130so871626pga.13
        for <linux-scsi@vger.kernel.org>; Thu, 31 Mar 2022 15:36:25 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=8A3lmX9gl51Y3wb88G4Gpv9Hep6JrNv+1jNwvXeLpq4=;
        b=b4MMvIZL9c4//i8f6fPIO3tHzl35+Yn5B2vPpcu9hrW3O2q6E4s850yDkUdu7YPmLQ
         iv1l3mrE1oamck8AgymHJJ//74DKbgmYmnI3i7Rr1vaP5Pjfd13lDI15hx4y2BPZAKql
         A3gIhILs3hL230euBI/fawFxPdu8UB1icrd1FuiIjCjYSvWxYtlP9/s0XBTcEBqf/H4a
         R5mQm33yfVEZlN+jtz3pNjoRDx//8w9agpiwdU8+pmBglfMRtXGGosWVaIROURZrV7/3
         aBgkHcsJTbCoune6OY+FD4bBSFchgPsXBBFCledb9o5VsTz/hpILoD09GbeTM9Fx/rqH
         JOaQ==
X-Gm-Message-State: AOAM533DAq4dVo7fth8zlSL6orPPwiSk0ZbRPIPCsmw/3whjgq40cqZT
        /jrJFdZRK0AAyAKvm+v9Cjc=
X-Google-Smtp-Source: ABdhPJwWX3qgmHfG+88d5vFp4AVLip9/x1GA2n2uUke47LG3VWBlo3lpTIDxw7EAx1r1uoopq86B8w==
X-Received: by 2002:a65:6941:0:b0:381:fea7:f3d8 with SMTP id w1-20020a656941000000b00381fea7f3d8mr12777560pgq.235.1648766184971;
        Thu, 31 Mar 2022 15:36:24 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:6375:fa54:efe8:6c8f])
        by smtp.gmail.com with ESMTPSA id p3-20020a056a000b4300b004faee36ea56sm483481pfo.155.2022.03.31.15.36.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 31 Mar 2022 15:36:24 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Jaegeuk Kim <jaegeuk@kernel.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Daejun Park <daejun7.park@samsung.com>,
        Bean Huo <beanhuo@micron.com>,
        Avri Altman <avri.altman@wdc.com>,
        Jinyoung Choi <j-young.choi@samsung.com>,
        Can Guo <cang@codeaurora.org>,
        Asutosh Das <quic_asutoshd@quicinc.com>
Subject: [PATCH 11/29] scsi: ufs: Remove unused constants and code
Date:   Thu, 31 Mar 2022 15:34:06 -0700
Message-Id: <20220331223424.1054715-12-bvanassche@acm.org>
X-Mailer: git-send-email 2.35.1.1094.g7c7d902a7c-goog
In-Reply-To: <20220331223424.1054715-1-bvanassche@acm.org>
References: <20220331223424.1054715-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Commit 5b44a07b6bb2 ("scsi: ufs: Remove pre-defined initial voltage values
of device power") removed the code that uses the UFS_VREG_VCC* constants
and also the code that sets the min_uV and max_uV member variables. Hence
also remove these constants and that member variable.

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
index 1ed54f6aef82..a48362165672 100644
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
