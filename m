Return-Path: <SRS0=qkKg=BY=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.1 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9DD2BC433E3
	for <linux-scsi@archiver.kernel.org>; Fri, 14 Aug 2020 09:51:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7AC0D206DA
	for <linux-scsi@archiver.kernel.org>; Fri, 14 Aug 2020 09:51:00 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="WJTRgBB5"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726974AbgHNJux (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 14 Aug 2020 05:50:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51204 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726932AbgHNJux (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 14 Aug 2020 05:50:53 -0400
Received: from mail-ed1-x544.google.com (mail-ed1-x544.google.com [IPv6:2a00:1450:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6DDD1C061385;
        Fri, 14 Aug 2020 02:50:51 -0700 (PDT)
Received: by mail-ed1-x544.google.com with SMTP id cq28so6365700edb.10;
        Fri, 14 Aug 2020 02:50:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=8Ev4gYxdQJBPen5vjwhLdew8Hi5m1sLHmKk6HbAlxZ0=;
        b=WJTRgBB5TMaJeKE2aPuBhSmJA+fDJlQK3zF9k/m2zWXnPa6Sh0SOVqRcjol8AEGtCM
         jlT+FKlZuwe5+RCG/kC6vC3MwZV0UsRWqrMZj07h5k9iC03JDjxQOtOGVOBLU6wGVSgT
         2FOLbBQvZao9huB51ZHaDkEjokLiENdcZbGk3VC7anY1d60XSAT9macoAik/whIqDxLk
         sJfoQB/u7WBTeiLiJUyK353Oa5inbj/hgwKpXZw+DA/QOWR1HXXQOs5ZM+lqznOA8U4O
         1w9Yne/gRldxnEECmplJUvYjkiyMFwG01dOe6jhbeGitMPis6QG5SVkd7nyZZZwoFIyJ
         vKoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=8Ev4gYxdQJBPen5vjwhLdew8Hi5m1sLHmKk6HbAlxZ0=;
        b=XLUPcfCfzk/XywT2HlrGJVL37/zPrfC9hE943AgfYHAZslnKudFNEwvQc22va9GeuU
         8UG/cCXGuP1dMWXcJz90TFxjEpnECOeRLpIJmogU5AX1SgVUDb3tlHUlTj3UcyWkKlxP
         f24Z1G/dCQ0SmKsoXwBGyB7LGjFCCv4VWnluXUfTvUQUOQaVmH0JC6tFlAgA2uEl4J2d
         rVjIpj4eq0sHdc8sHbzJWhWh32Uf61gh7TmVMkrpHx0wthOnQxka3hdcd8ygHPxTzbdk
         TiDsS7XkgCL+gHhnbElwBeE5JylcbYZAqRnubmfvtSg/8EGjwPJt/AwlfpJ2uNkSodCd
         M6IQ==
X-Gm-Message-State: AOAM531d4khb69wHmfE64RHrwykhOtiJ4xRyo11RpPB5prx3GO/dyxfT
        k8DtIhJkCrWQf6m4/let3dc=
X-Google-Smtp-Source: ABdhPJz3wkOyXQCS/InPYAr1DHg9y6xJ/3R8lEAION1T9cUzFG2wwJWLIoFUGnvcMfp0D6J6zCbybQ==
X-Received: by 2002:a05:6402:325:: with SMTP id q5mr1419796edw.343.1597398650172;
        Fri, 14 Aug 2020 02:50:50 -0700 (PDT)
Received: from localhost.localdomain ([2a01:598:8980:3d37:44c:d55b:5f94:2fc4])
        by smtp.gmail.com with ESMTPSA id r25sm6016448edy.93.2020.08.14.02.50.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 Aug 2020 02:50:49 -0700 (PDT)
From:   Bean Huo <huobean@gmail.com>
To:     alim.akhtar@samsung.com, avri.altman@wdc.com,
        asutoshd@codeaurora.org, jejb@linux.ibm.com,
        martin.petersen@oracle.com, stanley.chu@mediatek.com,
        beanhuo@micron.com, bvanassche@acm.org, tomas.winkler@intel.com,
        cang@codeaurora.org
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v3 2/2] scsi: ufs: remove several redundant goto statements
Date:   Fri, 14 Aug 2020 11:50:34 +0200
Message-Id: <20200814095034.20709-3-huobean@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200814095034.20709-1-huobean@gmail.com>
References: <20200814095034.20709-1-huobean@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Bean Huo <beanhuo@micron.com>

Signed-off-by: Bean Huo <beanhuo@micron.com>
---
 drivers/scsi/ufs/ufshcd.c | 25 +++++--------------------
 1 file changed, 5 insertions(+), 20 deletions(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index e3663b85e8ee..79b216c012d3 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -4256,10 +4256,8 @@ int ufshcd_make_hba_operational(struct ufs_hba *hba)
 		dev_err(hba->dev,
 			"Host controller not ready to process requests");
 		err = -EIO;
-		goto out;
 	}
 
-out:
 	return err;
 }
 EXPORT_SYMBOL_GPL(ufshcd_make_hba_operational);
@@ -5542,10 +5540,8 @@ static bool ufshcd_quirk_dl_nac_errors(struct ufs_hba *hba)
 			hba->saved_err &= ~UIC_ERROR;
 		/* clear NAC error */
 		hba->saved_uic_err &= ~UFSHCD_UIC_DL_NAC_RECEIVED_ERROR;
-		if (!hba->saved_uic_err) {
+		if (!hba->saved_uic_err)
 			err_handling = false;
-			goto out;
-		}
 	}
 out:
 	spin_unlock_irqrestore(hba->host->host_lock, flags);
@@ -7604,12 +7600,10 @@ static int ufshcd_config_vreg(struct device *dev,
 		if (vreg->min_uV && vreg->max_uV) {
 			min_uV = on ? vreg->min_uV : 0;
 			ret = regulator_set_voltage(reg, min_uV, vreg->max_uV);
-			if (ret) {
+			if (ret)
 				dev_err(dev,
 					"%s: %s set voltage failed, err=%d\n",
 					__func__, name, ret);
-				goto out;
-			}
 		}
 	}
 out:
@@ -7672,8 +7666,6 @@ static int ufshcd_setup_vreg(struct ufs_hba *hba, bool on)
 		goto out;
 
 	ret = ufshcd_toggle_vreg(dev, info->vccq2, on);
-	if (ret)
-		goto out;
 
 out:
 	if (ret) {
@@ -7719,10 +7711,8 @@ static int ufshcd_init_vreg(struct ufs_hba *hba)
 		goto out;
 
 	ret = ufshcd_get_vreg(dev, info->vccq);
-	if (ret)
-		goto out;
-
-	ret = ufshcd_get_vreg(dev, info->vccq2);
+	if (!ret)
+		ret = ufshcd_get_vreg(dev, info->vccq2);
 out:
 	return ret;
 }
@@ -7866,12 +7856,7 @@ static int ufshcd_variant_hba_init(struct ufs_hba *hba)
 
 	err = ufshcd_vops_setup_regulators(hba, true);
 	if (err)
-		goto out_exit;
-
-	goto out;
-
-out_exit:
-	ufshcd_vops_exit(hba);
+		ufshcd_vops_exit(hba);
 out:
 	if (err)
 		dev_err(hba->dev, "%s: variant %s init failed err %d\n",
-- 
2.17.1

