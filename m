Return-Path: <SRS0=gfFE=7Q=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4101DC433DF
	for <linux-scsi@archiver.kernel.org>; Wed,  3 Jun 2020 09:20:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2103520674
	for <linux-scsi@archiver.kernel.org>; Wed,  3 Jun 2020 09:20:38 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Cg4iNhJR"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726827AbgFCJUV (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 3 Jun 2020 05:20:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36426 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725881AbgFCJUR (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 3 Jun 2020 05:20:17 -0400
Received: from mail-ed1-x541.google.com (mail-ed1-x541.google.com [IPv6:2a00:1450:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 265C0C05BD43;
        Wed,  3 Jun 2020 02:20:17 -0700 (PDT)
Received: by mail-ed1-x541.google.com with SMTP id x93so1115238ede.9;
        Wed, 03 Jun 2020 02:20:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=cB2Kq623XQ22+n48/sVsupZYgeDKXkx1f2JvNrAS7Eg=;
        b=Cg4iNhJRn5TfwR+U6is/i/hkAI1C9vOZvH39O2kJGvC1+kcpOFWBoj02RZ/8YCizw4
         TN4Du8QJBJI6OUxnRcqzguDlxAiP2/KLM+BEfrGuH9lodFpEJfOgGuFoDNXS79AFBz3x
         BSsx6G3o7UvIqUq6xWxHdBiWiemDcWfl6cIGF9cbZ+GTKMi12BzXwKqcEi6HcBKxQ0zv
         pxy2EWZTHcX0B82yUMVYkGAtDjECsP16RgEYII6rnhKDRvCVIk+Gf8BMCLbVKMdWjqQe
         TfSe3HOGF7SZHSRFfLJPR8Uk3oUhqjIqbBm7Lp4TXfH2nDfijmXfByJaWPWg0Tf5Dxhl
         Ksqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=cB2Kq623XQ22+n48/sVsupZYgeDKXkx1f2JvNrAS7Eg=;
        b=XsJliFSpgFNdkXhVOMaDoJvqsZi4OA665ECiLJ635kfRJ2/LyzgIHBq08cvMnVfOL5
         7mqI+TmhAXXO6/sl5WBqnrJvhzveskuWmaMKjIiuCcx1jDm1sxhlds0wb/IhReWv+V4J
         W1E4Ig3wJCa/HBTUuuRz6IdC5HwAYH4UrkydP+1IW/OUgGwb2FzuWcap73/CAivjq+ck
         ldog925ncIn2RQb/wKku9yCW6171KCMGnOOCG7XOVoaWh2sg2KX5lJ5dDrnH29GrKRI+
         FHkV2D3ZCKhVGhGd3EFmu0pRNkz3DSaqy6O5hPJPMnF59Z/lJ/4vvfspalGfwpXtqQX0
         Xhdg==
X-Gm-Message-State: AOAM530rHIpVSg+wpfTiJ+bJG06E42cwAlCiy+VxIT3z13X7qO1J8//I
        2dzuqaq3at8Xemd5gWQlZOk=
X-Google-Smtp-Source: ABdhPJy+qf+2utE3eFGUuUKDP3e9ahV4uH/A0a7cQZ4CwL43z9QvLnR4ACkNxsjTDJ9eKZfjk4AtuA==
X-Received: by 2002:a50:ac84:: with SMTP id x4mr31446589edc.124.1591176015916;
        Wed, 03 Jun 2020 02:20:15 -0700 (PDT)
Received: from localhost.localdomain ([2a01:598:d00c:464c:92b:aecc:3637:dc7c])
        by smtp.gmail.com with ESMTPSA id 64sm865636eda.85.2020.06.03.02.20.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Jun 2020 02:20:15 -0700 (PDT)
From:   Bean Huo <huobean@gmail.com>
To:     alim.akhtar@samsung.com, avri.altman@wdc.com,
        asutoshd@codeaurora.org, jejb@linux.ibm.com,
        martin.petersen@oracle.com, stanley.chu@mediatek.com,
        beanhuo@micron.com, bvanassche@acm.org, tomas.winkler@intel.com,
        cang@codeaurora.org
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        beanhuo@outlook.com
Subject: [RESENT PATCH v5 1/5] scsi: ufs: remove max_t in ufs_get_device_desc
Date:   Wed,  3 Jun 2020 11:19:55 +0200
Message-Id: <20200603091959.27618-2-huobean@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200603091959.27618-1-huobean@gmail.com>
References: <20200603091959.27618-1-huobean@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Bean Huo <beanhuo@micron.com>

For the UFS device, the maximum descriptor size is 255, max_t called
in ufs_get_device_desc() is useless.

Signed-off-by: Bart van Assche <bvanassche@acm.org>
Signed-off-by: Bean Huo <beanhuo@micron.com>
Acked-by: Avri Altman <avri.altman@wdc.com>
Reviewed-by: Stanley Chu <stanley.chu@mediatek.com>
---
 drivers/scsi/ufs/ufshcd.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index ad4fc829cbb2..2cf077ab9dfd 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -6903,14 +6903,11 @@ static void ufs_fixup_device_setup(struct ufs_hba *hba)
 static int ufs_get_device_desc(struct ufs_hba *hba)
 {
 	int err;
-	size_t buff_len;
 	u8 model_index;
 	u8 *desc_buf;
 	struct ufs_dev_info *dev_info = &hba->dev_info;
 
-	buff_len = max_t(size_t, hba->desc_size.dev_desc,
-			 QUERY_DESC_MAX_SIZE + 1);
-	desc_buf = kmalloc(buff_len, GFP_KERNEL);
+	desc_buf = kmalloc(QUERY_DESC_MAX_SIZE, GFP_KERNEL);
 	if (!desc_buf) {
 		err = -ENOMEM;
 		goto out;
-- 
2.17.1

