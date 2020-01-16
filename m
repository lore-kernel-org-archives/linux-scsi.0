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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 364EDC33CAF
	for <linux-scsi@archiver.kernel.org>; Thu, 16 Jan 2020 22:00:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0A2EC2075B
	for <linux-scsi@archiver.kernel.org>; Thu, 16 Jan 2020 22:00:15 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="C+/gJd1X"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389474AbgAPWAL (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 16 Jan 2020 17:00:11 -0500
Received: from mail-wm1-f66.google.com ([209.85.128.66]:36283 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730816AbgAPWAL (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 16 Jan 2020 17:00:11 -0500
Received: by mail-wm1-f66.google.com with SMTP id p17so5456518wma.1;
        Thu, 16 Jan 2020 14:00:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=hIsYYM1tsKneNrgd2yUE9+XrcEkD0MuzrhyvDBfE4NE=;
        b=C+/gJd1XCusgb6Ajq2n1R3fBaeSyHr+kIXKR2Uo2dBn44BM8y4siOWP+/lNMY1WuKE
         JXPxXIDnTTy73p9pMkI8NhODCU6RFoFTZ+1KFXjUgYqV82jgUEKvEqVOTcfrDL53cHka
         mUaQhygHhRJtmdcGaPK413qpRJXmK2Vvt7f8m6h19cd/tiJytple49HTKZT6lQpWZm6d
         ivoiQ09K1axWmiIaYNSh5Uiq8DWwslNfkl7rWzMWbe8yP+5ZXFyUwmFPIzwc/Ia2+r5K
         G4A90OV8xY52whW0HDMlNlFqngkUp+BDQ1RJXNBggmTnj95o1oyWA6ZCHQ2mEkygPXxo
         ijnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=hIsYYM1tsKneNrgd2yUE9+XrcEkD0MuzrhyvDBfE4NE=;
        b=NB212BHwsHk7UysBrb5HskJHEw8zWvOLvaf5MRIJ28zEroUBfJ61eOHptAZ2eUa6K1
         mw53NS+6gta550bqrQmgEia/kTTJ4utebiypmpRpNUvF0d6kIg4XsNUQvOckbG4CBEIp
         +aTfApv1CdDdzKVqr06o9fPQKHhDb4N/1izb/I7kHuHjG9Ru2WQ05/FAa9ORxwvVAFAw
         8SKtNGl7PTxUmC9VRQFqqGFpuF9zcpViXr7fk7Aj87yOi7/m03zNkFEys18oEO1UEe+W
         BXM0QF6CA7YJsAoiE5JWAYdQqI+C0wQ9lNXs+7x6Kl6/2yGclq+BbA6sHe1rYN+alrBo
         bBAA==
X-Gm-Message-State: APjAAAWhNgP8/9l8HNE7nODNE72PheM7x2VEcJMtV21OWijMHkrK/RBI
        AcwcRS+9pMJSBGRmKc0tWBM=
X-Google-Smtp-Source: APXvYqyoaCb9cjni/ywIjpyAlL0Gwmq23XZtFG8fhEjpigcv6DWLUTehQJ4XAr3Un/JFZFTgoHMdNg==
X-Received: by 2002:a1c:1f51:: with SMTP id f78mr1157306wmf.60.1579212009005;
        Thu, 16 Jan 2020 14:00:09 -0800 (PST)
Received: from localhost.localdomain (ip5f5bee3c.dynamic.kabel-deutschland.de. [95.91.238.60])
        by smtp.gmail.com with ESMTPSA id a14sm32418131wrx.81.2020.01.16.14.00.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Jan 2020 14:00:08 -0800 (PST)
From:   Bean Huo <huobean@gmail.com>
To:     alim.akhtar@samsung.com, avri.altman@wdc.com,
        asutoshd@codeaurora.org, jejb@linux.ibm.com,
        martin.petersen@oracle.com, stanley.chu@mediatek.com,
        beanhuo@micron.com, bvanassche@acm.org, tomas.winkler@intel.com,
        cang@codeaurora.org
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2 4/9] scsi: ufs: Move ufshcd_get_max_pwr_mode() to ufs_init_params()
Date:   Thu, 16 Jan 2020 22:59:09 +0100
Message-Id: <20200116215914.16015-5-huobean@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200116215914.16015-1-huobean@gmail.com>
References: <20200116215914.16015-1-huobean@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Bean Huo <beanhuo@micron.com>

Take ufshcd_get_max_pwr_mode() out from ufshcd_probe_hba() and inline into
ufs_init_params().

Signed-off-by: Bean Huo <beanhuo@micron.com>
---
 drivers/scsi/ufs/ufshcd.c | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 2cec0816632c..087fd894a01b 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -6959,6 +6959,11 @@ static int ufs_init_params(struct ufs_hba *hba)
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

