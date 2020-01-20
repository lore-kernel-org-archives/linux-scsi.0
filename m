Return-Path: <SRS0=2tGB=3J=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A3D03C33CA1
	for <linux-scsi@archiver.kernel.org>; Mon, 20 Jan 2020 13:10:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 78FB322464
	for <linux-scsi@archiver.kernel.org>; Mon, 20 Jan 2020 13:10:00 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="q+WRM1cN"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728928AbgATNJ5 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 20 Jan 2020 08:09:57 -0500
Received: from mail-wm1-f68.google.com ([209.85.128.68]:33132 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726619AbgATNJ4 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 20 Jan 2020 08:09:56 -0500
Received: by mail-wm1-f68.google.com with SMTP id d139so14727544wmd.0;
        Mon, 20 Jan 2020 05:09:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=KLk7bHERzQdcb090yx1OHmdrZSniwsUQ3lMJ7bG4zOU=;
        b=q+WRM1cNNX8plyLJyEIHEtqIatyviQ9EQrnHDElmsDIC1F+XNpE6E2WwEt27/Vvj3O
         x36sO0NKYlHnUj6+PDrgX0BbtaUO/tD0dvyr75fFPqwROa6qctwj819PDJEDR1YJFM0N
         rCotVg0grb4LDXBI8BooI3tcjDbY7c2HwYO58cRGDTaGLcLpS0xehQbn+GIMJo5wOIlS
         x4FjnTVVXZtrba6b3DAMk31/B/e76BdQv/6Q5b2Ro9Auit5YIhX8YLv6/7PjqcLyQXhE
         e75nhJqTfUrkPryBkk9uraUZpSh3K8bSFS1FVKMl3ehXR8SpkK3yHSibCW04O51vVrqL
         0icQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=KLk7bHERzQdcb090yx1OHmdrZSniwsUQ3lMJ7bG4zOU=;
        b=VPuM8RmkNwIheoxR5JI/so0r7YcoelMYKuqHDgis2alRDL+Kx6GS4t2awsTrOOhdgX
         MUQSHFHgx7j+AieAZaK6UhCeBwJs9n181N0ecScpoJIEI16E5iMMXNiTf9d7sceauEYP
         NzIB7AchTJpj1hFstqb++yuBlJpzz/COylpdcFxqHu0oWj+MGeAhnFxBRp2R4VloNUBT
         cHlGKyFEnCQ7PQKkPROnck0V1DOdx5+5NxRodzxis7wZ+4Em4TjjB9Qp299va2GZdZDm
         LCvOwijRwmNE4OBB7ZaLluaP2dfE8mFzLgCFDAxCfnkZH3gE0maqzKJxP9oaIRiOPR/g
         nLHA==
X-Gm-Message-State: APjAAAWGWegAJlRsPK/xG4BA168BKsX+R/BHQ/iXquNDeW2wQuaaT0KB
        axGNWk2edTy7AC+kiBLbVJg=
X-Google-Smtp-Source: APXvYqwJh+sTAe00agX8D+AMFKZ0eukqYvg4n2kk/KOsxwe9dqrJtrKmnKzEB/1Tts9WLBKKBEwRGA==
X-Received: by 2002:a05:600c:224d:: with SMTP id a13mr19048454wmm.70.1579525794561;
        Mon, 20 Jan 2020 05:09:54 -0800 (PST)
Received: from ubuntu-G3.micron.com ([165.225.86.138])
        by smtp.gmail.com with ESMTPSA id p18sm23065386wmb.8.2020.01.20.05.09.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Jan 2020 05:09:54 -0800 (PST)
From:   Bean Huo <huobean@gmail.com>
To:     alim.akhtar@samsung.com, avri.altman@wdc.com,
        asutoshd@codeaurora.org, jejb@linux.ibm.com,
        martin.petersen@oracle.com, stanley.chu@mediatek.com,
        beanhuo@micron.com, bvanassche@acm.org, tomas.winkler@intel.com,
        cang@codeaurora.org
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v4 6/8] scsi: ufs: Delete is_init_prefetch from struct ufs_hba
Date:   Mon, 20 Jan 2020 14:08:18 +0100
Message-Id: <20200120130820.1737-7-huobean@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200120130820.1737-1-huobean@gmail.com>
References: <20200120130820.1737-1-huobean@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Bean Huo <beanhuo@micron.com>

Without variable is_init_prefetch, the current logic can guarantee
ufshcd_init_icc_levels() will execute only once, delete it now.

Signed-off-by: Bean Huo <beanhuo@micron.com>
---
 drivers/scsi/ufs/ufshcd.c | 5 +----
 drivers/scsi/ufs/ufshcd.h | 2 --
 2 files changed, 1 insertion(+), 6 deletions(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 3d3289bb3cad..0c859f239d1c 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -6967,8 +6967,7 @@ static int ufshcd_add_lus(struct ufs_hba *hba)
 {
 	int ret;
 
-	if (!hba->is_init_prefetch)
-		ufshcd_init_icc_levels(hba);
+	ufshcd_init_icc_levels(hba);
 
 	/* Add required well known logical units to scsi mid layer */
 	ret = ufshcd_scsi_add_wlus(hba);
@@ -6994,8 +6993,6 @@ static int ufshcd_add_lus(struct ufs_hba *hba)
 	scsi_scan_host(hba->host);
 	pm_runtime_put_sync(hba->dev);
 
-	if (!hba->is_init_prefetch)
-		hba->is_init_prefetch = true;
 out:
 	return ret;
 }
diff --git a/drivers/scsi/ufs/ufshcd.h b/drivers/scsi/ufs/ufshcd.h
index 32b6714f25a5..5c65d9fdeb14 100644
--- a/drivers/scsi/ufs/ufshcd.h
+++ b/drivers/scsi/ufs/ufshcd.h
@@ -501,7 +501,6 @@ struct ufs_stats {
  * @intr_mask: Interrupt Mask Bits
  * @ee_ctrl_mask: Exception event control mask
  * @is_powered: flag to check if HBA is powered
- * @is_init_prefetch: flag to check if data was pre-fetched in initialization
  * @init_prefetch_data: data pre-fetched during initialization
  * @eh_work: Worker to handle UFS errors that require s/w attention
  * @eeh_work: Worker to handle exception events
@@ -652,7 +651,6 @@ struct ufs_hba {
 	u32 intr_mask;
 	u16 ee_ctrl_mask;
 	bool is_powered;
-	bool is_init_prefetch;
 	struct ufs_init_prefetch init_prefetch_data;
 
 	/* Work Queues */
-- 
2.17.1

