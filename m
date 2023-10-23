Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8E914C25B49
	for <linux-scsi@archiver.kernel.org>; Mon, 23 Oct 2023 21:58:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233641AbjJWV6P (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 23 Oct 2023 17:58:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60942 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233546AbjJWV6O (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 23 Oct 2023 17:58:14 -0400
Received: from mail-pj1-f54.google.com (mail-pj1-f54.google.com [209.85.216.54])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E6E810C;
        Mon, 23 Oct 2023 14:58:13 -0700 (PDT)
Received: by mail-pj1-f54.google.com with SMTP id 98e67ed59e1d1-27d0e3d823fso2475309a91.1;
        Mon, 23 Oct 2023 14:58:13 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698098292; x=1698703092;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=BSMTtopnpnoVFRhHmUt+zlCmNcQ7/eLzIQS1hLfLLj0=;
        b=EKU8qibpePZhCEjMnIwJqpIDysuOJhuowpR2GuY9RVopt60XEpUKA+vdQS/x3dUa1X
         HFaVHEcASJQfL/4dwtnOhfYDNeqJSPlYJN237Cmxy6gTwnECXLu6alR5yXIws2DPTiDG
         UQpKoAL46uElTtumjfFSYXi01lQe5egE3tVhCSd9/lv3tC68z+qwDbQbbLwiAbOP3KF/
         +t+ZrzjRqd2Ee2sGTCbP/RlW3Z/u6TV1K7Nu/gSZg9a8FXhBnuBzrOohX8CtcPppIJuV
         iIOV/ly37S0BV28RC3c6J7NEgaHN2dStcfnOX0f8slxuVUJQsLuFYh0DlrnppHuMx6tk
         gyCQ==
X-Gm-Message-State: AOJu0YyeJtYedYIZgD8jRSYWBn6Z8K6pvB53BURnnPNJyZkGaREHYnOZ
        3t8SLCE3quEd91v0P0G+AAY=
X-Google-Smtp-Source: AGHT+IEwAJvhCcCxXwyfbALfHfqywFwwS4Tx58BIVtxt9V7KlwNwZY2Os1PvmqoQ5Au7rtdq2w5A/A==
X-Received: by 2002:a17:90a:e008:b0:27d:58a8:fa7f with SMTP id u8-20020a17090ae00800b0027d58a8fa7fmr9161361pjy.37.1698098292431;
        Mon, 23 Oct 2023 14:58:12 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:14f9:170e:9304:1c4e])
        by smtp.gmail.com with ESMTPSA id b12-20020a17090acc0c00b0027d12b1e29dsm7851029pju.25.2023.10.23.14.58.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Oct 2023 14:58:12 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     linux-block@vger.kernel.org, linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Christoph Hellwig <hch@lst.de>,
        Bart Van Assche <bvanassche@acm.org>,
        "Bao D . Nguyen" <quic_nguyenb@quicinc.com>,
        Can Guo <quic_cang@quicinc.com>,
        Avri Altman <avri.altman@wdc.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Manivannan Sadhasivam <mani@kernel.org>,
        Asutosh Das <quic_asutoshd@quicinc.com>,
        Bean Huo <beanhuo@micron.com>,
        Arthur Simchaev <Arthur.Simchaev@wdc.com>
Subject: [PATCH v14 17/19] scsi: ufs: Simplify ufshcd_auto_hibern8_update()
Date:   Mon, 23 Oct 2023 14:54:08 -0700
Message-ID: <20231023215638.3405959-18-bvanassche@acm.org>
X-Mailer: git-send-email 2.42.0.758.gaed0368e0e-goog
In-Reply-To: <20231023215638.3405959-1-bvanassche@acm.org>
References: <20231023215638.3405959-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Calls to ufshcd_auto_hibern8_update() are already serialized: this
function is either called if user space software is not running
(preparing to suspend) or from a single sysfs store callback function.
Kernfs serializes sysfs .store() callbacks.

No functionality is changed. This patch makes the next patch in this
series easier to read.

Reviewed-by: Bao D. Nguyen <quic_nguyenb@quicinc.com>
Reviewed-by: Can Guo <quic_cang@quicinc.com>
Cc: Martin K. Petersen <martin.petersen@oracle.com>
Cc: Avri Altman <avri.altman@wdc.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/ufs/core/ufshcd.c | 16 ++++------------
 1 file changed, 4 insertions(+), 12 deletions(-)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index d3718fbe51b9..3fc33794ce1f 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -4315,21 +4315,13 @@ static void ufshcd_configure_auto_hibern8(struct ufs_hba *hba)
 
 int ufshcd_auto_hibern8_update(struct ufs_hba *hba, u32 ahit)
 {
-	unsigned long flags;
-	bool update = false;
+	const u32 cur_ahit = READ_ONCE(hba->ahit);
 
-	if (!ufshcd_is_auto_hibern8_supported(hba))
+	if (!ufshcd_is_auto_hibern8_supported(hba) || cur_ahit == ahit)
 		return 0;
 
-	spin_lock_irqsave(hba->host->host_lock, flags);
-	if (hba->ahit != ahit) {
-		hba->ahit = ahit;
-		update = true;
-	}
-	spin_unlock_irqrestore(hba->host->host_lock, flags);
-
-	if (update &&
-	    !pm_runtime_suspended(&hba->ufs_device_wlun->sdev_gendev)) {
+	WRITE_ONCE(hba->ahit, ahit);
+	if (!pm_runtime_suspended(&hba->ufs_device_wlun->sdev_gendev)) {
 		ufshcd_rpm_get_sync(hba);
 		ufshcd_hold(hba);
 		ufshcd_configure_auto_hibern8(hba);
