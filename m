Return-Path: <SRS0=1Um0=3I=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AB531C33CB7
	for <linux-scsi@archiver.kernel.org>; Sun, 19 Jan 2020 00:14:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 81E962467C
	for <linux-scsi@archiver.kernel.org>; Sun, 19 Jan 2020 00:14:12 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="B2/FrWN5"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728843AbgASAOJ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 18 Jan 2020 19:14:09 -0500
Received: from mail-wr1-f68.google.com ([209.85.221.68]:38201 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728811AbgASAOJ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 18 Jan 2020 19:14:09 -0500
Received: by mail-wr1-f68.google.com with SMTP id y17so26065247wrh.5;
        Sat, 18 Jan 2020 16:14:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=MRb5bXAWMY+l9HME4BWEKQK1eCgQVNeKGRrRGFvy7Iw=;
        b=B2/FrWN5PiQe/aTA5s7VuSedpHC2t/ZqQdcAwrd0ExqpHwthaMB9cq+df6CU+2tQXl
         iSKy9v5cJb/LkghYrXOZfyzrHsFH+VbKpRKnxYPVU2cJmdsnmRVnQHrT2aEgG2lCeMXh
         GfOGgYVOUrP881eKZcTOzGHFU/cDaNGwF4J/3662OuScc3v3lC8fMJPOO7a1ggydqhg1
         SUqR7fT6krqRh0W9sUiNH5H1I0FxMjQkZIgPPSWYLjvtFl9UkfPaYtjoRFvXfzeLqKA8
         ZXJm5Jwq/UMFrBUoHEwAywqnZJVZWffyLm2po+OKDne+T50m/BQdlZy/tQmQW1NVJWwY
         HIcw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=MRb5bXAWMY+l9HME4BWEKQK1eCgQVNeKGRrRGFvy7Iw=;
        b=HX3G2afWsP8TbNB5NMvDj4sf8IpGVmlRI+8C0fw0Ce8muKFkjQtj3GMmjmAiePCJaw
         kzDgj9uSB6EE8gILKKUs1ysbVTEgut9Z/g85ub37Z6mewnLPDH7r5jDzo9tuCMDSfTd5
         rm5OfYdilLajzo7N6MDQfuArCTjRSTiFuqrWCbZRAkz7+y283zNG1dBFarma2NZrF8qV
         mKOx+5IUNS8CSGPahO0gY4uHPMF2FbXQTjrhjQnK218/ZKkxcAYmgHCrJWmZev0EXTAE
         BVXFeIP/yqSFNtznD+Kk26jOoCpEY1vAiefY411noxcwSY08dQKGFU+9Iw6H68s+lcTl
         QEEQ==
X-Gm-Message-State: APjAAAXPJt/+Q5gOYb/GuknxydT+kNNoEL7XvbwQPZtLWLTNMGugKN8Z
        IUZw8NM/KrMQ7OqSBUvv2iE=
X-Google-Smtp-Source: APXvYqx1p0C2LUh20OSMagkpn12NTrQfI/tEv9uchn0D3d1IwZoDmcLMN6qcNLwqb7PMrb2fHmyoyA==
X-Received: by 2002:a5d:4481:: with SMTP id j1mr10609347wrq.348.1579392847120;
        Sat, 18 Jan 2020 16:14:07 -0800 (PST)
Received: from localhost.localdomain (ip5f5bee3c.dynamic.kabel-deutschland.de. [95.91.238.60])
        by smtp.gmail.com with ESMTPSA id i8sm42177432wro.47.2020.01.18.16.14.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 18 Jan 2020 16:14:06 -0800 (PST)
From:   Bean Huo <huobean@gmail.com>
To:     alim.akhtar@samsung.com, avri.altman@wdc.com,
        asutoshd@codeaurora.org, jejb@linux.ibm.com,
        martin.petersen@oracle.com, stanley.chu@mediatek.com,
        beanhuo@micron.com, bvanassche@acm.org, tomas.winkler@intel.com,
        cang@codeaurora.org
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v3 4/8] scsi: ufs: move ufshcd_get_max_pwr_mode() to ufs_init_params()
Date:   Sun, 19 Jan 2020 01:13:23 +0100
Message-Id: <20200119001327.29155-5-huobean@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200119001327.29155-1-huobean@gmail.com>
References: <20200119001327.29155-1-huobean@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Bean Huo <beanhuo@micron.com>

ufshcd_get_max_pwr_mode() only need to be called once while booting,
take it out from ufshcd_probe_hba() and inline into ufshcd_init_params().

Signed-off-by: Bean Huo <beanhuo@micron.com>
---
 drivers/scsi/ufs/ufshcd.c | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 54c127ef360b..925b31dc3110 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -6959,6 +6959,11 @@ static int ufshcd_init_params(struct ufs_hba *hba)
 			QUERY_FLAG_IDN_PWR_ON_WPE, &flag))
 		hba->dev_info.f_power_on_wp_en = flag;
 
+	/* Probe maximum power mode co-supported by both UFS host and device */
+	if (ufshcd_get_max_pwr_mode(hba))
+		dev_err(hba->dev,
+			"%s: Failed getting max supported power mode\n",
+			__func__);
 out:
 	return ret;
 }
@@ -7057,11 +7062,8 @@ static int ufshcd_probe_hba(struct ufs_hba *hba, bool async)
 	ufshcd_force_reset_auto_bkops(hba);
 	hba->wlun_dev_clr_ua = true;
 
-	if (ufshcd_get_max_pwr_mode(hba)) {
-		dev_err(hba->dev,
-			"%s: Failed getting max supported power mode\n",
-			__func__);
-	} else {
+	/* Gear up to HS gear if supported */
+	if (hba->max_pwr_info.is_valid) {
 		/*
 		 * Set the right value to bRefClkFreq before attempting to
 		 * switch to HS gears.
-- 
2.17.1

