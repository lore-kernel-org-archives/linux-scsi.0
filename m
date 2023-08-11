Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A403CC0015E
	for <linux-scsi@archiver.kernel.org>; Fri, 11 Aug 2023 21:36:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236970AbjHKVgj (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 11 Aug 2023 17:36:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41208 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235778AbjHKVgh (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 11 Aug 2023 17:36:37 -0400
Received: from mail-pl1-f174.google.com (mail-pl1-f174.google.com [209.85.214.174])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 38A37273E;
        Fri, 11 Aug 2023 14:36:31 -0700 (PDT)
Received: by mail-pl1-f174.google.com with SMTP id d9443c01a7336-1bbf8cb61aeso18058245ad.2;
        Fri, 11 Aug 2023 14:36:31 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691789791; x=1692394591;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=/Ht/S5/IQaEQ/R/sr0BTkozacEwEufdvyDt4t1mhvhY=;
        b=Qd/DF5uUJENlQAq6JNhPwmHm9A00QvG4vPZabvnNCglqSs8cZiNJCxNnUr9DtJPpbC
         VL+UNH7qcf8HBAWCzrNKvJy6PwRXiZ5ERVziheICVEN5XCPOMl/G7v7FFyxYgQTLiXsa
         3QMrVoe0yGhPguxgWuEPL5gfQha7g/OSaV/A5fS+Y3RbpcqhuTCr9WWG5v7AmuV45KK+
         R5ujYbiMgwRQxIwTNB4BxKRMGsims8DEsFrDXyIIoKbBsfDKGKDWjTkg1s/SfyBaceGB
         DhpFX8wLzeTaQLSrazJXm13bURMqR5TL0o8Ns8j1+hJE64VXF1503LpgpxJutlmbY9bf
         86ig==
X-Gm-Message-State: AOJu0Yw9SK/BXGeuPBjwU6tWPZMmvuqHOlDAD6yDa7QY7ODo9C8PZwzP
        CVpoombxcixtsVbcSd1o08M=
X-Google-Smtp-Source: AGHT+IGrohq1/jQlzRg4hcWKjYmERF7NLULiKTKhVGJtJ4WF1smTq76OcaO5hx5TK/lb6iXFe6Glsw==
X-Received: by 2002:a17:902:ea0c:b0:1b8:b3f9:58e5 with SMTP id s12-20020a170902ea0c00b001b8b3f958e5mr3507061plg.38.1691789790655;
        Fri, 11 Aug 2023 14:36:30 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:cdd8:4c3:2f3c:adea])
        by smtp.gmail.com with ESMTPSA id c10-20020a170903234a00b001b89c313185sm4394865plh.205.2023.08.11.14.36.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 11 Aug 2023 14:36:30 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     linux-block@vger.kernel.org, linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Christoph Hellwig <hch@lst.de>,
        Bart Van Assche <bvanassche@acm.org>,
        Can Guo <quic_cang@quicinc.com>,
        Avri Altman <avri.altman@wdc.com>,
        Damien Le Moal <dlemoal@kernel.org>,
        Ming Lei <ming.lei@redhat.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Bean Huo <beanhuo@micron.com>,
        Asutosh Das <quic_asutoshd@quicinc.com>,
        "Bao D. Nguyen" <quic_nguyenb@quicinc.com>,
        Arthur Simchaev <Arthur.Simchaev@wdc.com>
Subject: [PATCH v8 8/9] scsi: ufs: Split an if-condition
Date:   Fri, 11 Aug 2023 14:35:42 -0700
Message-ID: <20230811213604.548235-9-bvanassche@acm.org>
X-Mailer: git-send-email 2.41.0.640.ga95def55d0-goog
In-Reply-To: <20230811213604.548235-1-bvanassche@acm.org>
References: <20230811213604.548235-1-bvanassche@acm.org>
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
