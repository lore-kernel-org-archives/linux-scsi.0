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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 24F28C4332E
	for <linux-scsi@archiver.kernel.org>; Mon, 11 Jan 2021 22:33:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0761022D06
	for <linux-scsi@archiver.kernel.org>; Mon, 11 Jan 2021 22:33:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390538AbhAKWc7 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 11 Jan 2021 17:32:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57222 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390193AbhAKWc4 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 11 Jan 2021 17:32:56 -0500
Received: from mail-ej1-x62b.google.com (mail-ej1-x62b.google.com [IPv6:2a00:1450:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4969AC06179F;
        Mon, 11 Jan 2021 14:32:15 -0800 (PST)
Received: by mail-ej1-x62b.google.com with SMTP id b9so713410ejy.0;
        Mon, 11 Jan 2021 14:32:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=q+wom0BMfaWQ690xBm+ubEDHR/EXGn4oiMHIKz+sgME=;
        b=iEQBHu5YmJ+yo34rUy1Pl/BzYp1e/5M966RFtPV9p85BHpAonfmevpw99OjscJazHH
         u9Sv0jGiK97nDqWiHGSK06Hy47ogAi9abVEzj1QBv1wvE7n3xnwGIqCfu77U8oT+r1JO
         mP60mLokG2Z9IGBgUqeS/r7pETY+lvhIrNHNJReqpOrVsO5J+RIbniYry1SLtOSYjGJ7
         /+Tqe7Ht98bmSOJjgfeq9D9brMZdm4Bcl1hiswRwHM8EWmEEcVntec4dVJua6g86Jp/U
         GOHEuZdPfNymLH77DsAOV0bVt1Wtzfen169Eg21rGz4+vG2qMDhYo93BTd22iYLXtisY
         j3Ug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=q+wom0BMfaWQ690xBm+ubEDHR/EXGn4oiMHIKz+sgME=;
        b=ikyBNBL7bpEpXu+UxkXwJyaOkUmgBylX6qqW9rZSph7QhZnPjdd0qbZNegVFazHyOO
         vMa4P3UrRKgtxRWmgs5MpE73VgXtAkkDSl6fiMaKhwUnlKa4xlomk5ceTxTlgEFEoGEt
         34v8ndN2eN7TaKuEStbyUHQ66cZUCiLvYSGGCZkhF3WOnujXRKLQ23ZG13gWbD0Byk4E
         LHa3KDdkDnT+bDzE3dvKdv3xoB35CNUbsRmA6eW2LHbsWWwWobzk7rzH+DaGnjn9+By/
         M4MzrlwxKHDI8FHt9g3AkqfnPl8euTVfksRNtxWI3MTiRUoc3tZShObsbcuFcIHKmzTs
         Scow==
X-Gm-Message-State: AOAM5309Jh4g2tYTs4O4w33x0Y6Kgs/56ArvxqBNwAbO8buUEqaqFTvc
        cwl7uXxZoJeCR8ouq8/tOIY=
X-Google-Smtp-Source: ABdhPJxxEyHeOY9mHKvJyxTFP4Vf3Uh3YJuJwLnI+t4sL6V6Vld0vSRW/n1WeRqPpQm70wuUgd12kQ==
X-Received: by 2002:a17:906:3712:: with SMTP id d18mr1131903ejc.178.1610404333886;
        Mon, 11 Jan 2021 14:32:13 -0800 (PST)
Received: from localhost.localdomain (ip5f5bfcff.dynamic.kabel-deutschland.de. [95.91.252.255])
        by smtp.gmail.com with ESMTPSA id r18sm550154edx.41.2021.01.11.14.32.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 Jan 2021 14:32:13 -0800 (PST)
From:   Bean Huo <huobean@gmail.com>
To:     alim.akhtar@samsung.com, avri.altman@wdc.com,
        john.garry@huawei.com, jejb@linux.ibm.com,
        martin.petersen@oracle.com, ebiggers@google.com, satyat@google.com,
        shipujin.t@gmail.com
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Bean Huo <beanhuo@micron.com>
Subject: [PATCH 2/2] scsi: ufs: Remove unnecessary devm_kfree
Date:   Mon, 11 Jan 2021 23:32:02 +0100
Message-Id: <20210111223202.26369-3-huobean@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210111223202.26369-1-huobean@gmail.com>
References: <20210111223202.26369-1-huobean@gmail.com>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Bean Huo <beanhuo@micron.com>

The memory allocated with devm_kzalloc() is freed automatically
no need to explicitly call devm_kfree.

Signed-off-by: Bean Huo <beanhuo@micron.com>
---
 drivers/scsi/ufs/ufshcd-crypto.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/scsi/ufs/ufshcd-crypto.c b/drivers/scsi/ufs/ufshcd-crypto.c
index 07310b12a5dc..ec80ec83cf85 100644
--- a/drivers/scsi/ufs/ufshcd-crypto.c
+++ b/drivers/scsi/ufs/ufshcd-crypto.c
@@ -182,7 +182,7 @@ int ufshcd_hba_init_crypto_capabilities(struct ufs_hba *hba)
 	err = blk_ksm_init(&hba->ksm,
 			   hba->crypto_capabilities.config_count + 1);
 	if (err)
-		goto out_free_caps;
+		goto out;
 
 	hba->ksm.ksm_ll_ops = ufshcd_ksm_ops;
 	/* UFS only supports 8 bytes for any DUN */
@@ -208,8 +208,6 @@ int ufshcd_hba_init_crypto_capabilities(struct ufs_hba *hba)
 
 	return 0;
 
-out_free_caps:
-	devm_kfree(hba->dev, hba->crypto_cap_array);
 out:
 	/* Indicate that init failed by clearing UFSHCD_CAP_CRYPTO */
 	hba->caps &= ~UFSHCD_CAP_CRYPTO;
-- 
2.17.1

