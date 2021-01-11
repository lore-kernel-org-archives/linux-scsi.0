Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F1EF6C43217
	for <linux-scsi@archiver.kernel.org>; Tue, 12 Jan 2021 00:33:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DA12D22CB8
	for <linux-scsi@archiver.kernel.org>; Tue, 12 Jan 2021 00:33:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405530AbhALAZo (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 11 Jan 2021 19:25:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37332 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2403837AbhAKXLy (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 11 Jan 2021 18:11:54 -0500
Received: from mail-ed1-x536.google.com (mail-ed1-x536.google.com [IPv6:2a00:1450:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34128C06179F;
        Mon, 11 Jan 2021 15:11:14 -0800 (PST)
Received: by mail-ed1-x536.google.com with SMTP id g24so233999edw.9;
        Mon, 11 Jan 2021 15:11:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=MatKQSm+/WVgTUvqaobQ9dQnxxqAjemkbsMSuNsvDMg=;
        b=pHPNCZg38qIe/4vlk8/Un6gLukJz5+6c66WTixLp6AFkm3a6TAmvuS3M7dgpMJB7mz
         N0PwklTjnEku56YNfkYWD0JB++NoNa8xFciif71vvEH+IvQsIanTprDDwH2sxlaFIFnx
         pkS3/pXkXQy7FGWGTtGWL100zDQKtKkPKkGPaE0oUkBpz4E4fKhK0UHvXH7M0aq0j3qZ
         QFmv2w4ja3EKc+2NJYL6QE2+e3F17zTJOwoHv8RWGENYvqRN5u8yieIuU+0NqqPx/NvK
         xRqfhAP378dr79Tr138Uw3XEqSv0KHyPjq9TPtlBgPGDHv5fGZKzpY037H1soxzsyOM2
         9WAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=MatKQSm+/WVgTUvqaobQ9dQnxxqAjemkbsMSuNsvDMg=;
        b=UCl1/IF4szM9G4MjKvUVotl1gLibTKfq0H8YZgKbJnYvYRI/pnG2+YekK2Rimy5HDO
         wM/B/my5kq78VZbhHNmTFkXGn7EdfegWcJMPZwzbsA4zvacYUezSEJDSuFxEI0XFk5OC
         VVXn3kPemlfRKua3Dcfu2jUXghXf1a8tir7wnba9ujfLIAH4ipd+ywI9h8s2WQpgjoDv
         S8QnLVLMiq5UqvT0Y0xxx4WVwm4cxcoim2d+aT4WL6rhKeQ5+ohqaBH20y7k7RTRJ3MR
         zTBsu+fEnmVFK81lAWN57WY5/AJGzeQYooKahA5XSp9UvcWObwUUynb7h9C9Zoe+TAhq
         keTw==
X-Gm-Message-State: AOAM533lDJP/JektxiC5clx6ClCYXJi1KB+XD96UpRwtP/8z1riUXICP
        fa2/h6R3xyPrf7KLGqjYNNw=
X-Google-Smtp-Source: ABdhPJxt5k5IsscPQixApIEotRX7sO1nzIxCGin7x1BjBVuaE+52X+s/ICAse2ofVIWgqMrQitPoZg==
X-Received: by 2002:aa7:d459:: with SMTP id q25mr1145671edr.279.1610406672989;
        Mon, 11 Jan 2021 15:11:12 -0800 (PST)
Received: from localhost.localdomain (ip5f5bfcff.dynamic.kabel-deutschland.de. [95.91.252.255])
        by smtp.gmail.com with ESMTPSA id ch30sm598175edb.8.2021.01.11.15.11.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 Jan 2021 15:11:12 -0800 (PST)
From:   Bean Huo <huobean@gmail.com>
To:     alim.akhtar@samsung.com, avri.altman@wdc.com,
        john.garry@huawei.com, jejb@linux.ibm.com,
        martin.petersen@oracle.com, ebiggers@google.com, satyat@google.com,
        shipujin.t@gmail.com
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Bean Huo <beanhuo@micron.com>
Subject: [PATCH v2 2/2] scsi: ufs: Remove unnecessary devm_kfree
Date:   Tue, 12 Jan 2021 00:10:58 +0100
Message-Id: <20210111231058.14559-3-huobean@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210111231058.14559-1-huobean@gmail.com>
References: <20210111231058.14559-1-huobean@gmail.com>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Bean Huo <beanhuo@micron.com>

The memory allocated with devm_kzalloc() is freed automatically
no need to explicitly call devm_kfree.

Reviewed-by: Eric Biggers <ebiggers@google.com>
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

