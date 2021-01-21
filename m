Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-19.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 51CAFC4332D
	for <linux-scsi@archiver.kernel.org>; Thu, 21 Jan 2021 08:39:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 18628239A1
	for <linux-scsi@archiver.kernel.org>; Thu, 21 Jan 2021 08:39:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726381AbhAUIjp (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 21 Jan 2021 03:39:45 -0500
Received: from mail.kernel.org ([198.145.29.99]:54574 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726777AbhAUIYB (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 21 Jan 2021 03:24:01 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 326D52399A;
        Thu, 21 Jan 2021 08:23:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611217400;
        bh=QbeE9MQBd7zs5w6Q8wyNKWSY+K0sfedfVA8kFcC/D1k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=er3RUMK+lFXY2DFzbTF9CSYtSuui5eXC0t7O1MEkvjbrAsWlvaj8iaVwEAviw6c3M
         wMPFN1vNwMfplL19rvBkA4StC4p/20vilN/ijhyn7sC/e3RAJjg0TsfweUY3udICyI
         czbAVEW3GllqQ+3g2npTy+2tU2VrcncJJ9dS95nHdeDX9RO6OJojkzx8uS+p36F0Bb
         5Tmd788QRFX1MzV+tcAEuq4SwqjzJ/RwkFSZwGGqEiniuJNevbxrMySdo+QOAOiDWb
         x8mBI4Pm2bDJcHzuac18B/NWm9xSX1ulxYEkHC6aZ8n5IRZbjVESbLxnKlzDOZaAkV
         DmekpAbpSakfQ==
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-block@vger.kernel.org, linux-mmc@vger.kernel.org,
        linux-scsi@vger.kernel.org
Cc:     Satya Tangirala <satyat@google.com>,
        Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH 2/2] scsi: ufs: use devm_blk_ksm_init()
Date:   Thu, 21 Jan 2021 00:21:55 -0800
Message-Id: <20210121082155.111333-3-ebiggers@kernel.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210121082155.111333-1-ebiggers@kernel.org>
References: <20210121082155.111333-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

Use the new resource-managed variant of blk_ksm_init() so that the UFS
driver doesn't have to manually call blk_ksm_destroy().

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 drivers/scsi/ufs/ufshcd-crypto.c | 9 ++-------
 drivers/scsi/ufs/ufshcd-crypto.h | 5 -----
 drivers/scsi/ufs/ufshcd.c        | 1 -
 3 files changed, 2 insertions(+), 13 deletions(-)

diff --git a/drivers/scsi/ufs/ufshcd-crypto.c b/drivers/scsi/ufs/ufshcd-crypto.c
index 07310b12a5dc8..153dd5765d9ca 100644
--- a/drivers/scsi/ufs/ufshcd-crypto.c
+++ b/drivers/scsi/ufs/ufshcd-crypto.c
@@ -179,8 +179,8 @@ int ufshcd_hba_init_crypto_capabilities(struct ufs_hba *hba)
 	}
 
 	/* The actual number of configurations supported is (CFGC+1) */
-	err = blk_ksm_init(&hba->ksm,
-			   hba->crypto_capabilities.config_count + 1);
+	err = devm_blk_ksm_init(hba->dev, &hba->ksm,
+				hba->crypto_capabilities.config_count + 1);
 	if (err)
 		goto out_free_caps;
 
@@ -238,8 +238,3 @@ void ufshcd_crypto_setup_rq_keyslot_manager(struct ufs_hba *hba,
 	if (hba->caps & UFSHCD_CAP_CRYPTO)
 		blk_ksm_register(&hba->ksm, q);
 }
-
-void ufshcd_crypto_destroy_keyslot_manager(struct ufs_hba *hba)
-{
-	blk_ksm_destroy(&hba->ksm);
-}
diff --git a/drivers/scsi/ufs/ufshcd-crypto.h b/drivers/scsi/ufs/ufshcd-crypto.h
index d53851be55416..78a58e788dff9 100644
--- a/drivers/scsi/ufs/ufshcd-crypto.h
+++ b/drivers/scsi/ufs/ufshcd-crypto.h
@@ -43,8 +43,6 @@ void ufshcd_init_crypto(struct ufs_hba *hba);
 void ufshcd_crypto_setup_rq_keyslot_manager(struct ufs_hba *hba,
 					    struct request_queue *q);
 
-void ufshcd_crypto_destroy_keyslot_manager(struct ufs_hba *hba);
-
 #else /* CONFIG_SCSI_UFS_CRYPTO */
 
 static inline void ufshcd_prepare_lrbp_crypto(struct request *rq,
@@ -69,9 +67,6 @@ static inline void ufshcd_init_crypto(struct ufs_hba *hba) { }
 static inline void ufshcd_crypto_setup_rq_keyslot_manager(struct ufs_hba *hba,
 						struct request_queue *q) { }
 
-static inline void ufshcd_crypto_destroy_keyslot_manager(struct ufs_hba *hba)
-{ }
-
 #endif /* CONFIG_SCSI_UFS_CRYPTO */
 
 #endif /* _UFSHCD_CRYPTO_H */
diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index e31d2c5c7b23b..d905c84474c2c 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -9139,7 +9139,6 @@ EXPORT_SYMBOL_GPL(ufshcd_remove);
  */
 void ufshcd_dealloc_host(struct ufs_hba *hba)
 {
-	ufshcd_crypto_destroy_keyslot_manager(hba);
 	scsi_host_put(hba->host);
 }
 EXPORT_SYMBOL_GPL(ufshcd_dealloc_host);
-- 
2.30.0

