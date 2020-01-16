Return-Path: <SRS0=K2E6=3F=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8FEB5C33CAF
	for <linux-scsi@archiver.kernel.org>; Thu, 16 Jan 2020 22:00:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 62DAD20748
	for <linux-scsi@archiver.kernel.org>; Thu, 16 Jan 2020 22:00:30 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="S7P2LqYN"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389532AbgAPWA0 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 16 Jan 2020 17:00:26 -0500
Received: from mail-wm1-f66.google.com ([209.85.128.66]:39012 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389531AbgAPWA0 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 16 Jan 2020 17:00:26 -0500
Received: by mail-wm1-f66.google.com with SMTP id 20so5431809wmj.4;
        Thu, 16 Jan 2020 14:00:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=U/6r3jTv6/TdVEpoQsUJwaQM0ILgr42fKAvijPLEpt4=;
        b=S7P2LqYN1YayIOtXg5qoVWjCYl4aKil1O2WWLa8e9ywWG5d38XSvUVh+LiMpWWc1wg
         BPDd4QqsdfUfqFNUi1IG1dQIO38VQDgH0HamG2bJUnoza7acaJh72W+c2wjmLFl7NLRF
         8Iwvps2Ao9lL1rQewneKoejnPKqChayl1+H5D7n0VfUYxbgXyYOXn1wWogfeK+lyvFam
         6echBlIGv1ZsxIwIrvwPuqd9UYmKIOxdZQU790fkqFagptNz8omJwAUhlEN1JDTKsq+d
         jtS62/xF2rNNakmiud+k+CteXf25uljIpGKUlkM37R8kXCOl4SdzdX3ngq+X9mBB7Ccg
         RY8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=U/6r3jTv6/TdVEpoQsUJwaQM0ILgr42fKAvijPLEpt4=;
        b=VW9nSgI4qUJUNCEM5GNMPX8OuyvjLYSYHOFP661bmsR+V8WY4a4qnRtVnhaQhdImAq
         0Io5Yfwa+dletCGrvYNHiT6DjJ29PTIPJKZtOrupxkT2CnOKvCGfbGf4WylhYehnh81R
         39lovBULaua7YKzUDhMj1GtoavPEcfUAD7tdFmUN/wP6hOxAaghnFEi/nlZrHvE+Du8N
         BX25WuLOAwi94zWKqk1a0q9Bsz5Um7AMDFBN7FYuufingayS+1TURyH7vsY1ngbPHqBE
         LvYSs8X7Foln0eVWPU9diOLPZZT93/IxcVekm+Se9s24EJk5g6gaV+4icRRyhWskwPBA
         rkdA==
X-Gm-Message-State: APjAAAUmKL+6TrTVnGd0kGjnSxJC0kNFiYvueLcFrzPAFO7EspEN+V3F
        GurHzhoMtVCe0gUI3yfpDoY=
X-Google-Smtp-Source: APXvYqwrE80ZmcxOSJcuZUEUfwOB+x/TX9GpQjCBu2Ztjn6Np9rNv+PhpuWi8kQDzYeOOfJ7zYfCBg==
X-Received: by 2002:a1c:f218:: with SMTP id s24mr1206970wmc.128.1579212024492;
        Thu, 16 Jan 2020 14:00:24 -0800 (PST)
Received: from localhost.localdomain (ip5f5bee3c.dynamic.kabel-deutschland.de. [95.91.238.60])
        by smtp.gmail.com with ESMTPSA id a14sm32418131wrx.81.2020.01.16.14.00.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Jan 2020 14:00:24 -0800 (PST)
From:   Bean Huo <huobean@gmail.com>
To:     alim.akhtar@samsung.com, avri.altman@wdc.com,
        asutoshd@codeaurora.org, jejb@linux.ibm.com,
        martin.petersen@oracle.com, stanley.chu@mediatek.com,
        beanhuo@micron.com, bvanassche@acm.org, tomas.winkler@intel.com,
        cang@codeaurora.org
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2 6/9] scsi: ufs: Delete is_init_prefetch from struct ufs_hba
Date:   Thu, 16 Jan 2020 22:59:11 +0100
Message-Id: <20200116215914.16015-7-huobean@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200116215914.16015-1-huobean@gmail.com>
References: <20200116215914.16015-1-huobean@gmail.com>
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
index 44b7c0a44b8d..31b6e2a7c166 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -6967,8 +6967,7 @@ static int ufs_lu_add(struct ufs_hba *hba)
 {
 	int ret;
 
-	if (!hba->is_init_prefetch)
-		ufshcd_init_icc_levels(hba);
+	ufshcd_init_icc_levels(hba);
 
 	/* Add required well known logical units to scsi mid layer */
 	ret = ufshcd_scsi_add_wlus(hba);
@@ -6994,8 +6993,6 @@ static int ufs_lu_add(struct ufs_hba *hba)
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

