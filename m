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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 46F79C4338F
	for <linux-scsi@archiver.kernel.org>; Wed,  4 Aug 2021 18:21:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2B780610CD
	for <linux-scsi@archiver.kernel.org>; Wed,  4 Aug 2021 18:21:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240208AbhHDSV4 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 4 Aug 2021 14:21:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52268 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238225AbhHDSVy (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 4 Aug 2021 14:21:54 -0400
Received: from mail-wm1-x334.google.com (mail-wm1-x334.google.com [IPv6:2a00:1450:4864:20::334])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25B4CC06179E;
        Wed,  4 Aug 2021 11:21:40 -0700 (PDT)
Received: by mail-wm1-x334.google.com with SMTP id n11so1728924wmd.2;
        Wed, 04 Aug 2021 11:21:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=X9/XirZyPGqfcWkK+RkVlCuaFc9xmCxe9G0B+gDsYv0=;
        b=ky2CiTZ9wjVXtdkptRoOWXQmScPD6SAaQUWeq/D/V+/qQ1fM2OQuy8ZbelPSbeaVAK
         ZTfL3IKxlnQizo7JEoqQwbxHvWNBNyrqbCHFQTfQ/izOMg7Too+Fa0hZhmjlEWkMBHJ1
         CAqJZQ3KdJ9sU8nRbmDfM47ug2yJKME9K6oFt+69pth1EtcrUcUrgzoFjF4U8RV9p0PK
         zrQWYgkwdvgDquts2AoV6q12sWfy0nQu5x+JaTovrCENjRQ67vb+Jtn9wR/Qt/vIgewf
         IIDuzWPoqHTtZ9rFSopRu2Q2pM1FTPvMDKu9FehpY2r8QPuQsity8ynstddSFqsnODnp
         vYSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=X9/XirZyPGqfcWkK+RkVlCuaFc9xmCxe9G0B+gDsYv0=;
        b=J6wITgT2jRI6FWSNJ74wZsKjL8AU8c9p7ZCAWLTrMoTDZdhHjEUPfsejBNbFrMEw1l
         rQRXyvFrLEMnsQY/RAQPnbk3pstKdM9p8o4GmVmcQob02GtBQXXj3zsKsGZ0AZeKszfQ
         AX/Uxo+UMBgDi1QefK+1TF93R0EGZzEFw9sWCIydeIn4L1wU9SYaRHeEyiatT0POyTcc
         9f6nWfBNR+VdIwJSMugcKY6YXZYSUF74NaXKuxZVgnJ6o6TVfqUaiQVTKG0GIUUcn3/1
         PLSubGyVg2Yte4wDYpDIO66rqCfrUwViy10Pbu6tbLOLOU4RNzgv5Ju7Pmto/noVXSaH
         hk5g==
X-Gm-Message-State: AOAM533Gy24xEt9D9l440qnlDcJ4g280P8TqPM0o3Vfo+HogOLDcT6MQ
        v/yBXjnEfgaLW+lEUrF9wW0=
X-Google-Smtp-Source: ABdhPJztFy1g8TAyEPNqF2wldkPnT4N1xzOx4EfbYvqig+9IcCgBfIDyjwMOrtAInST6Gc+6LSZnHw==
X-Received: by 2002:a1c:980e:: with SMTP id a14mr826899wme.123.1628101298817;
        Wed, 04 Aug 2021 11:21:38 -0700 (PDT)
Received: from localhost.localdomain (ip5f5bfdd7.dynamic.kabel-deutschland.de. [95.91.253.215])
        by smtp.gmail.com with ESMTPSA id n5sm2914880wme.47.2021.08.04.11.21.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Aug 2021 11:21:38 -0700 (PDT)
From:   Bean Huo <huobean@gmail.com>
To:     alim.akhtar@samsung.com, avri.altman@wdc.com,
        asutoshd@codeaurora.org, jejb@linux.ibm.com,
        martin.petersen@oracle.com, stanley.chu@mediatek.com,
        beanhuo@micron.com, bvanassche@acm.org, cang@codeaurora.org,
        daejun7.park@samsung.com
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v1 1/2] scsi: ufs: Add L2P entry swap quirk for Micron UFS in HPB READ command
Date:   Wed,  4 Aug 2021 20:21:27 +0200
Message-Id: <20210804182128.458356-2-huobean@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210804182128.458356-1-huobean@gmail.com>
References: <20210804182128.458356-1-huobean@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Bean Huo <beanhuo@micron.com>

For the Micron UFS, L2P entry need to be swapped in HPB READ command
before sending HPB READ command to the UFS device. Add this quirk
UFS_DEVICE_QUIRK_SWAP_L2P_ENTRY_FOR_HPB_READ to fix this inconsistency.

Fixes: 2fff76f87542 ("scsi: ufs: ufshpb: Prepare HPB read for cached sub-region")
Signed-off-by: Bean Huo <beanhuo@micron.com>
---
 drivers/scsi/ufs/ufs_quirks.h |  6 ++++++
 drivers/scsi/ufs/ufshcd.c     |  3 ++-
 drivers/scsi/ufs/ufshpb.c     | 15 ++++++++++-----
 3 files changed, 18 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/ufs/ufs_quirks.h b/drivers/scsi/ufs/ufs_quirks.h
index 07f559ac5883..35ec9ea79869 100644
--- a/drivers/scsi/ufs/ufs_quirks.h
+++ b/drivers/scsi/ufs/ufs_quirks.h
@@ -116,4 +116,10 @@ struct ufs_dev_fix {
  */
 #define UFS_DEVICE_QUIRK_DELAY_AFTER_LPM        (1 << 11)
 
+/*
+ * Some UFS devices require L2P entry should be swapped before being sent to the
+ * UFS device for HPB READ command.
+ */
+#define UFS_DEVICE_QUIRK_SWAP_L2P_ENTRY_FOR_HPB_READ (1 << 12)
+
 #endif /* UFS_QUIRKS_H_ */
diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 47a5085f16a9..c3a14d3b0030 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -199,7 +199,8 @@ ufs_get_desired_pm_lvl_for_dev_link_state(enum ufs_dev_pwr_mode dev_state,
 static struct ufs_dev_fix ufs_fixups[] = {
 	/* UFS cards deviations table */
 	UFS_FIX(UFS_VENDOR_MICRON, UFS_ANY_MODEL,
-		UFS_DEVICE_QUIRK_DELAY_BEFORE_LPM),
+		UFS_DEVICE_QUIRK_DELAY_BEFORE_LPM |
+		UFS_DEVICE_QUIRK_SWAP_L2P_ENTRY_FOR_HPB_READ),
 	UFS_FIX(UFS_VENDOR_SAMSUNG, UFS_ANY_MODEL,
 		UFS_DEVICE_QUIRK_DELAY_BEFORE_LPM |
 		UFS_DEVICE_QUIRK_HOST_PA_TACTIVATE |
diff --git a/drivers/scsi/ufs/ufshpb.c b/drivers/scsi/ufs/ufshpb.c
index 54e8e019bdbe..d0eb14be47a3 100644
--- a/drivers/scsi/ufs/ufshpb.c
+++ b/drivers/scsi/ufs/ufshpb.c
@@ -323,15 +323,19 @@ ufshpb_get_pos_from_lpn(struct ufshpb_lu *hpb, unsigned long lpn, int *rgn_idx,
 }
 
 static void
-ufshpb_set_hpb_read_to_upiu(struct ufshpb_lu *hpb, struct ufshcd_lrb *lrbp,
-			    u32 lpn, __be64 ppn, u8 transfer_len, int read_id)
+ufshpb_set_hpb_read_to_upiu(struct ufs_hba *hba, struct ufshpb_lu *hpb,
+			    struct ufshcd_lrb *lrbp, u32 lpn, __be64 ppn,
+			    u8 transfer_len, int read_id)
 {
 	unsigned char *cdb = lrbp->cmd->cmnd;
-
+	__be64 ppn_tmp = ppn;
 	cdb[0] = UFSHPB_READ;
 
+	if (hba->dev_quirks & UFS_DEVICE_QUIRK_SWAP_L2P_ENTRY_FOR_HPB_READ)
+		ppn_tmp = swab64(ppn);
+
 	/* ppn value is stored as big-endian in the host memory */
-	memcpy(&cdb[6], &ppn, sizeof(__be64));
+	memcpy(&cdb[6], &ppn_tmp, sizeof(__be64));
 	cdb[14] = transfer_len;
 	cdb[15] = read_id;
 
@@ -689,7 +693,8 @@ int ufshpb_prep(struct ufs_hba *hba, struct ufshcd_lrb *lrbp)
 		}
 	}
 
-	ufshpb_set_hpb_read_to_upiu(hpb, lrbp, lpn, ppn, transfer_len, read_id);
+	ufshpb_set_hpb_read_to_upiu(hba, hpb, lrbp, lpn, ppn, transfer_len,
+				    read_id);
 
 	hpb->stats.hit_cnt++;
 	return 0;
-- 
2.25.1

