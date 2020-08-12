Return-Path: <SRS0=c2qj=BW=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.1 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8BEA0C433DF
	for <linux-scsi@archiver.kernel.org>; Wed, 12 Aug 2020 14:37:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4F9BA20855
	for <linux-scsi@archiver.kernel.org>; Wed, 12 Aug 2020 14:37:26 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="XRtzaReD"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726518AbgHLOhS (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 12 Aug 2020 10:37:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47696 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726583AbgHLOhR (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 12 Aug 2020 10:37:17 -0400
Received: from mail-ed1-x544.google.com (mail-ed1-x544.google.com [IPv6:2a00:1450:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D36BC061383;
        Wed, 12 Aug 2020 07:37:17 -0700 (PDT)
Received: by mail-ed1-x544.google.com with SMTP id c10so1700729edk.6;
        Wed, 12 Aug 2020 07:37:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=Gn7ZCZ5XA2EnBwutA3QyCJrGM4TBiILm4xq3LoAVuYo=;
        b=XRtzaReDSvg5kTrtGXPdqHmRTxsd1SfMl/OI4Nfo3UiWo6Z9qimPgLI1GviIdOrSAQ
         9SXd89txWifead1bQWeppyUnPXISNO3fxHpHxS8Oj2hYb3S198vBBh9y1sLF0muN98eS
         RbPszq3gxDE+vmGkWS7DuGLcaxN8KaIWSebU2i7w2mJcMdJQ87GdAbknToJR/KZzGfdf
         Ygs2SGcRoASoob8agtkAcCMkchvrUaG3r7wq/DmUMheB8Fz9xOuUuzg0eKh7bKVZS/Z2
         6bq3rh1ZMyugTH86ctTwCR23PsXFxh/E/A2o/mKwk2ed5k5LwIXo5llmD/JZZK//SaEO
         fr2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=Gn7ZCZ5XA2EnBwutA3QyCJrGM4TBiILm4xq3LoAVuYo=;
        b=FY4UPG01YLlWI/u5o8xg4NqeLhnS4KIZf8m0kNWdS06NxPR05mVSbM8fNUvTtgyd9H
         FrzFnfgt+45lWWRrtYA0ZrBm84p6XYZNKxpED817P+WAqNnvOLk3ZPGmABynEbh88rlo
         fES6eqITiqJoyVW32XxcAgVg++/Z2zeMzhMkxhsam4KVQQ5K6UPmex4/F1rAWT4zijP2
         vMHJ9uDQ63chGABmcyqnL+5IoP0jIZY7rt7HDBCkVi7D7IH9pVr3f4NSi8XlukNkx2wK
         vWO2TjAfItS1ki6Y81K+6pvCw5Gj2rm6Il9PgW/I2X+8/JzMzy45vU9QOdkfmZqKbLPl
         fpIw==
X-Gm-Message-State: AOAM533Bq9zjU0SPOJHYD4Qdln86qo5VoBLJhT9lnLxI2I5dD494jHx9
        Aw685EvYiYUJ5puJMgPeyFA=
X-Google-Smtp-Source: ABdhPJwHUTCOq/7sG1xx2m0Srnm+e6Me9xBDEMaC0kGa0pCrpQaRo5JEga0wKCectWad1lQC9C+rag==
X-Received: by 2002:aa7:ca0c:: with SMTP id y12mr178248eds.251.1597243036013;
        Wed, 12 Aug 2020 07:37:16 -0700 (PDT)
Received: from localhost.localdomain ([2a01:598:b90f:8e5c:44c:d55b:5f94:2fc4])
        by smtp.gmail.com with ESMTPSA id d20sm1661179ejj.10.2020.08.12.07.37.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 Aug 2020 07:37:15 -0700 (PDT)
From:   Bean Huo <huobean@gmail.com>
To:     alim.akhtar@samsung.com, avri.altman@wdc.com,
        asutoshd@codeaurora.org, jejb@linux.ibm.com,
        martin.petersen@oracle.com, stanley.chu@mediatek.com,
        beanhuo@micron.com, bvanassche@acm.org, tomas.winkler@intel.com,
        cang@codeaurora.org
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2 1/2] scsi: ufs: change ufshcd_comp_devman_upiu() to ufshcd_compose_devman_upiu()
Date:   Wed, 12 Aug 2020 16:37:03 +0200
Message-Id: <20200812143704.30245-2-huobean@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200812143704.30245-1-huobean@gmail.com>
References: <20200812143704.30245-1-huobean@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Bean Huo <beanhuo@micron.com>

ufshcd_comp_devman_upiu() alwasy make me confuse that it is a request
completion calling function. Change it to ufshcd_compose_devman_upiu().

Signed-off-by: Bean Huo <beanhuo@micron.com>
Acked-by: Avri Altman <avri.altman@wdc.com>
---
 drivers/scsi/ufs/ufshcd.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 5f09cda7b21c..e3663b85e8ee 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -2391,12 +2391,13 @@ static inline void ufshcd_prepare_utp_nop_upiu(struct ufshcd_lrb *lrbp)
 }
 
 /**
- * ufshcd_comp_devman_upiu - UFS Protocol Information Unit(UPIU)
+ * ufshcd_compose_devman_upiu - UFS Protocol Information Unit(UPIU)
  *			     for Device Management Purposes
  * @hba: per adapter instance
  * @lrbp: pointer to local reference block
  */
-static int ufshcd_comp_devman_upiu(struct ufs_hba *hba, struct ufshcd_lrb *lrbp)
+static int ufshcd_compose_devman_upiu(struct ufs_hba *hba,
+				      struct ufshcd_lrb *lrbp)
 {
 	u8 upiu_flags;
 	int ret = 0;
@@ -2590,7 +2591,7 @@ static int ufshcd_compose_dev_cmd(struct ufs_hba *hba,
 	ufshcd_prepare_lrbp_crypto(NULL, lrbp);
 	hba->dev_cmd.type = cmd_type;
 
-	return ufshcd_comp_devman_upiu(hba, lrbp);
+	return ufshcd_compose_devman_upiu(hba, lrbp);
 }
 
 static int
-- 
2.17.1

