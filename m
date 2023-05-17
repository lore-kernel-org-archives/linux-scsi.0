Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8E2DAC77B7A
	for <linux-scsi@archiver.kernel.org>; Wed, 17 May 2023 22:24:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229449AbjEQWYO (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 17 May 2023 18:24:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60292 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229543AbjEQWYJ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 17 May 2023 18:24:09 -0400
Received: from mail-pj1-f47.google.com (mail-pj1-f47.google.com [209.85.216.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E7867469B
        for <linux-scsi@vger.kernel.org>; Wed, 17 May 2023 15:24:08 -0700 (PDT)
Received: by mail-pj1-f47.google.com with SMTP id 98e67ed59e1d1-24de9c66559so1104094a91.0
        for <linux-scsi@vger.kernel.org>; Wed, 17 May 2023 15:24:08 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684362248; x=1686954248;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=J+qpS/nRPOvdOChrLV2Q+o20PxkV9kqLgmi1qsutmfk=;
        b=G5E2lNavhVzh/fURfucieKVVzdd5dHl6WNEnH9qDZB8EWkrtl+kPIKFB2KYqemZtnz
         AIZMz9g7FA4zWYQWtleRXyv22B3R/2OGcQoxe9sVejp8yJ0I23Z3AEH5AeBR6GhJyIbI
         u2ukjar2KsDUVwHWmQre+qSWwIZiIHMMj/w1dzVbVQX+pNsFV9ZlZcWpPuwsxbo8ahaW
         6J8ftRrYQ2SbkSX/c+qkJukadUBED5bNuoiSA1Qx+6h87Fax8Xg34dEDg4igO9NBeo+K
         Os+VdKfZOxVyh9EKU96NsLxvKTGDteL7yU7lkGrbybTFrCey/qmf9A6oblPLiRnSvS4m
         G3Wg==
X-Gm-Message-State: AC+VfDyoVSBZLukoy7VtJKFgslvw9OD/zZWcyOzmlUUNrF4x9ViEww6H
        hrH4vg3Ues1Ov8ZKHQ5Lf0Y=
X-Google-Smtp-Source: ACHHUZ6SKcWrtTyRVGhXualOxouJYPzaUIwZF93tvK4GE6ZSJAC/zog5Sgbk1XghetdfJPF5KSBldg==
X-Received: by 2002:a17:90a:7563:b0:253:38ff:be4b with SMTP id q90-20020a17090a756300b0025338ffbe4bmr350794pjk.47.1684362248299;
        Wed, 17 May 2023 15:24:08 -0700 (PDT)
Received: from bvanassche-glaptop2.roam.corp.google.com ([98.51.102.78])
        by smtp.gmail.com with ESMTPSA id d32-20020a17090a6f2300b0024df6bbf5d8sm66273pjk.30.2023.05.17.15.24.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 May 2023 15:24:07 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH v2 3/4] scsi: ufs: Enable the BLK_MQ_F_BLOCKING flag
Date:   Wed, 17 May 2023 15:23:58 -0700
Message-ID: <20230517222359.1066918-4-bvanassche@acm.org>
X-Mailer: git-send-email 2.40.1.698.g37aff9b760-goog
In-Reply-To: <20230517222359.1066918-1-bvanassche@acm.org>
References: <20230517222359.1066918-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Prepare for adding code in ufshcd_queuecommand() that may sleep.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/ufs/core/ufshcd.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index 7ee150d67d49..993034ac1696 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -8756,6 +8756,7 @@ static const struct scsi_host_template ufshcd_driver_template = {
 	.max_host_blocked	= 1,
 	.track_queue_depth	= 1,
 	.skip_settle_delay	= 1,
+	.queuecommand_may_block = true,
 	.sdev_groups		= ufshcd_driver_groups,
 	.rpm_autosuspend_delay	= RPM_AUTOSUSPEND_DELAY_MS,
 };
