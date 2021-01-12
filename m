Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0F884C433DB
	for <linux-scsi@archiver.kernel.org>; Tue, 12 Jan 2021 09:22:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B739022DFB
	for <linux-scsi@archiver.kernel.org>; Tue, 12 Jan 2021 09:22:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392481AbhALJWW (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 12 Jan 2021 04:22:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55430 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390850AbhALJWW (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 12 Jan 2021 04:22:22 -0500
Received: from mail-ed1-x535.google.com (mail-ed1-x535.google.com [IPv6:2a00:1450:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B767CC061575;
        Tue, 12 Jan 2021 01:21:41 -0800 (PST)
Received: by mail-ed1-x535.google.com with SMTP id j16so1522809edr.0;
        Tue, 12 Jan 2021 01:21:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=y2/B+BoAg/TnrznhxPBcSM5FNoHP6+wMvjOswih44+w=;
        b=byTviTSlv6eGCuZSP05gT4JuVCYo759RSSLGjnXwbShj4pfxNv6MAJxxicqClaJ4IZ
         O9gzIQCgkpt5AN+YUZ+s0rOiyoM5nUKoM8XzTi0ELb2UpJ0ylK8Iuoxfj273O+UCVE4O
         897wO0m6SEw9GoAu2UX1jU/PssSpazZNnuB5sd3wFoSD3Ke8VaE4Q8itA/e8un4R1ZYr
         QN/vhLPXHMnsjyR1NuCnpYAwTDTsFAaJzWW+RhMPyzELhUk5Y8A4W/HE4e6KE+9b4rk3
         YOD3xy+lvQaMZ8AGoNGum6mup+BThyZICsJXAhNPkbM6iEjwgnz0Chc01LVrP57/J+p4
         jIiw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=y2/B+BoAg/TnrznhxPBcSM5FNoHP6+wMvjOswih44+w=;
        b=dae75q6IWQanxEnKVmR3OnjM+AyrQxwm/nvSc1k5lsV1bYYG72Tbl2wwJQ56JCcIzY
         0Y8TgCuy7KNy87QRr9AB7q4EVPT5sl90+SZd2CTVde0Y9UppASCy5Plr9WdnCGz56H3O
         /PsxtRtWaoaFRO32Pw3CJSTYO1iODpTlFcctBbiAnK7RIylVShPYLZ5xX2Gp+6Hu83dZ
         3aQzOcdwB2+0klnLRj5kkOO6ae7hHVAqeg0BvuhDAOD0hQpONXnps50/oSIRF7sPzzKj
         8QZoEs8aBvn+E77FTt8v2B63/nARlo/XwSIUNZ8eRDzmMC2CH/EnNnmN1P9Qo7i1JX+H
         AObQ==
X-Gm-Message-State: AOAM533sUycqw3IW0vbEI9SzDSJ0CINCk5SMQXSCuJgQIdGCX+KCoCmi
        tYIJUwNdFima2b89EnNFwsM=
X-Google-Smtp-Source: ABdhPJxWonWSPDG7r/++eckjilIn6aZULYt+CO/sCC1m6AM+Km+XRe04ZUNXwttLS+ID079fOyML8Q==
X-Received: by 2002:a05:6402:104e:: with SMTP id e14mr2692476edu.316.1610443300551;
        Tue, 12 Jan 2021 01:21:40 -0800 (PST)
Received: from localhost.localdomain (ip5f5bfcff.dynamic.kabel-deutschland.de. [95.91.252.255])
        by smtp.gmail.com with ESMTPSA id e11sm929885ejz.94.2021.01.12.01.21.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Jan 2021 01:21:39 -0800 (PST)
From:   Bean Huo <huobean@gmail.com>
To:     alim.akhtar@samsung.com, avri.altman@wdc.com,
        john.garry@huawei.com, jejb@linux.ibm.com,
        martin.petersen@oracle.com, ebiggers@google.com, satyat@google.com,
        shipujin.t@gmail.com
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Bean Huo <beanhuo@micron.com>
Subject: [PATCH v3] scsi: ufs: Remove unnecessary devm_kfree
Date:   Tue, 12 Jan 2021 10:21:28 +0100
Message-Id: <20210112092128.19295-1-huobean@gmail.com>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Bean Huo <beanhuo@micron.com>

The memory allocated with devm_kzalloc() is freed automatically
no need to explicitly call devm_kfree, so delete it and save some
instruction cycles.

Reviewed-by: Eric Biggers <ebiggers@google.com>
Signed-off-by: Bean Huo <beanhuo@micron.com>
---

Nothing changed in this patch, just drop one patch from the patchset:
https://patchwork.kernel.org/project/linux-scsi/cover/20210111231058.14559-1-huobean@gmail.com/

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

