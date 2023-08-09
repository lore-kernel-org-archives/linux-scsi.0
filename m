Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 28707C001B0
	for <linux-scsi@archiver.kernel.org>; Wed,  9 Aug 2023 20:24:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234461AbjHIUYg (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 9 Aug 2023 16:24:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40320 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234460AbjHIUY3 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 9 Aug 2023 16:24:29 -0400
Received: from mail-pj1-f43.google.com (mail-pj1-f43.google.com [209.85.216.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A18922717;
        Wed,  9 Aug 2023 13:24:12 -0700 (PDT)
Received: by mail-pj1-f43.google.com with SMTP id 98e67ed59e1d1-267f8f36a3cso116762a91.2;
        Wed, 09 Aug 2023 13:24:12 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691612652; x=1692217452;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=/Ht/S5/IQaEQ/R/sr0BTkozacEwEufdvyDt4t1mhvhY=;
        b=PKQ1KvXU1peQ99snuRy9PYeOHleSeoRUiREHeDQm/YQDONSGTuBw/F1cTZMe0SacrI
         WD/FzLGJxYRduHJrv+AggRo3UaHcCCA9qbVBPQ54zyrBn0OJ+1264B6QgCX04nzIN0Qa
         qgHFLwbb7+Caxx8nv0Q5IJRNnbAXgQRUzB5e3Ke+OzkKcWVSEPBpbQFWENHS6yyCOV+U
         J1FAdTrWIROOml79ts98z1z/ckD9Z3Z1hO6B6Tnml6TqZKt3ZQP8d3AWCjimBQifsDyi
         PIEyvnR4BgXlqHygj7XUVaOoY7yHBGvay0hG/qCGjjKBtf7+hFqQ3w8g/2Dn2d+eHpX5
         BltQ==
X-Gm-Message-State: AOJu0YxBc28yaQPW6tIP9Dmc8TozZ5YLtwTSN6fr1nIlGDAy7zIsRsaf
        S14DMiXRNfXAdGyXGX7Why//rm99a+8=
X-Google-Smtp-Source: AGHT+IGQ5LGlRE73wBeepIM5upy78P9OT+PVzAFGP1skr0nh0yppeCi7DuQG7PcD6e7Y2E/1Is+nMA==
X-Received: by 2002:a17:90a:8b09:b0:268:2f2:cc88 with SMTP id y9-20020a17090a8b0900b0026802f2cc88mr332915pjn.12.1691612651996;
        Wed, 09 Aug 2023 13:24:11 -0700 (PDT)
Received: from bvanassche-glaptop2.roam.corp.google.com ([98.51.102.78])
        by smtp.gmail.com with ESMTPSA id gq9-20020a17090b104900b002694da8a9cdsm1868103pjb.48.2023.08.09.13.24.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Aug 2023 13:24:11 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     linux-block@vger.kernel.org, linux-scsi@vger.kernel.org,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Christoph Hellwig <hch@lst.de>,
        Bart Van Assche <bvanassche@acm.org>,
        Can Guo <quic_cang@quicinc.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Avri Altman <avri.altman@wdc.com>,
        Damien Le Moal <dlemoal@kernel.org>,
        Ming Lei <ming.lei@redhat.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Bean Huo <beanhuo@micron.com>,
        Asutosh Das <quic_asutoshd@quicinc.com>,
        "Bao D. Nguyen" <quic_nguyenb@quicinc.com>,
        Arthur Simchaev <Arthur.Simchaev@wdc.com>
Subject: [PATCH v7 6/7] scsi: ufs: Split an if-condition
Date:   Wed,  9 Aug 2023 13:23:47 -0700
Message-ID: <20230809202355.1171455-7-bvanassche@acm.org>
X-Mailer: git-send-email 2.41.0.640.ga95def55d0-goog
In-Reply-To: <20230809202355.1171455-1-bvanassche@acm.org>
References: <20230809202355.1171455-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Make the next patch in this series easier to read. No functionality is
changed.

Reviewed-by: Can Guo <quic_cang@quicinc.com>
Cc: Martin K. Petersen <martin.petersen@oracle.com>
Cc: Avri Altman <avri.altman@wdc.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Damien Le Moal <dlemoal@kernel.org>
Cc: Ming Lei <ming.lei@redhat.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/ufs/core/ufshcd.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index 129446775796..ae7b868f9c26 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -4352,8 +4352,9 @@ void ufshcd_auto_hibern8_update(struct ufs_hba *hba, u32 ahit)
 	}
 	spin_unlock_irqrestore(hba->host->host_lock, flags);
 
-	if (update &&
-	    !pm_runtime_suspended(&hba->ufs_device_wlun->sdev_gendev)) {
+	if (!update)
+		return;
+	if (!pm_runtime_suspended(&hba->ufs_device_wlun->sdev_gendev)) {
 		ufshcd_rpm_get_sync(hba);
 		ufshcd_hold(hba);
 		ufshcd_auto_hibern8_enable(hba);
