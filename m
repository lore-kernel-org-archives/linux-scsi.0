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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 61B16C433E1
	for <linux-scsi@archiver.kernel.org>; Wed, 12 Aug 2020 14:37:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2C7FC2078B
	for <linux-scsi@archiver.kernel.org>; Wed, 12 Aug 2020 14:37:25 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="nNIGnlJ4"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726690AbgHLOhU (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 12 Aug 2020 10:37:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47702 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726678AbgHLOhT (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 12 Aug 2020 10:37:19 -0400
Received: from mail-ej1-x644.google.com (mail-ej1-x644.google.com [IPv6:2a00:1450:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 85502C061383;
        Wed, 12 Aug 2020 07:37:18 -0700 (PDT)
Received: by mail-ej1-x644.google.com with SMTP id kq25so2525248ejb.3;
        Wed, 12 Aug 2020 07:37:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=k0jt6enCU+k6/1ZLIPsFzlCB9yQOeFwEasaJxWTCsu4=;
        b=nNIGnlJ4cxzSXBBlnAdU22ZeY2sWhmhZUfKtM9/2nnn/li9/ertILnExUwm/EVvs49
         hh/q/fu++uLyx/Ja+S57sIDuOpttKx0bRe0QiHnIBzDIQsVOfO0fcSrmCNpx6b+e8YL4
         sqVdm/Bg3+0dtjyY/jiCan59vHfcakWNTZHQfTl0/SQOaL7TPRqzL8DHA/vrSYjtsyAa
         lMLCr4f0S97Yxm4Nye0p5C8ZiEHcoSs91dx9TINFHH7TE/8EamhqG7Zpiy0mgzQFfPuw
         ZU24VJRRRVRC1jHws2TWXqoLky473FUA6synd04/H7lop1nP35s/hEli0SKieJGTJBN8
         I72A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=k0jt6enCU+k6/1ZLIPsFzlCB9yQOeFwEasaJxWTCsu4=;
        b=a3QHIXw6wiI71e4H4zMSAeDxAXgR9HHXToebiJXbvBfM05npOmpRaqMykzixO2AhPT
         dTw6KjgGtEVq56Ud1O2xROmxA2LDSZLNhpioqK8/mL8vVAHYxyeVYkm3Wl3q9fE/bHAd
         ZFEYDFvcMHJZ4OH/Br+TUVMLkGBpaeO6N1+V8TWMs01v36KEE1/5aV6jDgnuH5IiTErJ
         mK/jsJNVj3g/TjXu8XVbAJ+GLGPEGw9otzQyxtvAbCctYxVHxcqVEAdbmHBBMgLue3xW
         v0dHMoPlp8LkekAEFrXpIU/owlONx5ibQ6FFc9JHrhlijKzJmJ5CZEY2qAVz0d06Tzvl
         Gsiw==
X-Gm-Message-State: AOAM532JPXQLLPiXBgtk4SDKNV9qEU1DYav+MpLy70vXiSM0EgfpX4kn
        RpR7afXBp03JzTgUYbm4c8A=
X-Google-Smtp-Source: ABdhPJypeCnLUIuX2FrykbNFJM6Kdp/anVO6jkBnXd6M3Oh/7cvrXbhufq6pzC/kcuxFAFjbQVElFA==
X-Received: by 2002:a17:906:e17:: with SMTP id l23mr79692eji.13.1597243037318;
        Wed, 12 Aug 2020 07:37:17 -0700 (PDT)
Received: from localhost.localdomain ([2a01:598:b90f:8e5c:44c:d55b:5f94:2fc4])
        by smtp.gmail.com with ESMTPSA id d20sm1661179ejj.10.2020.08.12.07.37.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 Aug 2020 07:37:16 -0700 (PDT)
From:   Bean Huo <huobean@gmail.com>
To:     alim.akhtar@samsung.com, avri.altman@wdc.com,
        asutoshd@codeaurora.org, jejb@linux.ibm.com,
        martin.petersen@oracle.com, stanley.chu@mediatek.com,
        beanhuo@micron.com, bvanassche@acm.org, tomas.winkler@intel.com,
        cang@codeaurora.org
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2 2/2] scsi: ufs: remove several redundant goto statements
Date:   Wed, 12 Aug 2020 16:37:04 +0200
Message-Id: <20200812143704.30245-3-huobean@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200812143704.30245-1-huobean@gmail.com>
References: <20200812143704.30245-1-huobean@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Bean Huo <beanhuo@micron.com>

Signed-off-by: Bean Huo <beanhuo@micron.com>
---
 drivers/scsi/ufs/ufshcd.c | 26 +++++---------------------
 1 file changed, 5 insertions(+), 21 deletions(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index e3663b85e8ee..cd742c4f78b6 100644
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
@@ -8036,7 +8021,6 @@ static int ufshcd_set_dev_pwr_mode(struct ufs_hba *hba,
 	}
 
 	cmd[4] = pwr_mode << 4;
-
 	/*
 	 * Current function would be generally called from the power management
 	 * callbacks hence set the RQF_PM flag so that it doesn't resume the
-- 
2.17.1

