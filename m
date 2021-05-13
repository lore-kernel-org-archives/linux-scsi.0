Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 997CCC43460
	for <linux-scsi@archiver.kernel.org>; Thu, 13 May 2021 22:38:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7EE34610EA
	for <linux-scsi@archiver.kernel.org>; Thu, 13 May 2021 22:38:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233332AbhEMWjT (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 13 May 2021 18:39:19 -0400
Received: from mail-pf1-f177.google.com ([209.85.210.177]:34726 "EHLO
        mail-pf1-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230435AbhEMWjS (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 13 May 2021 18:39:18 -0400
Received: by mail-pf1-f177.google.com with SMTP id 10so23147966pfl.1
        for <linux-scsi@vger.kernel.org>; Thu, 13 May 2021 15:38:07 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=tIX5CSrqlFqAKpWAJvmKJ1rzEbqvrwxZubFYH1DN5o4=;
        b=B7JIWWLCrUNWu1hwapJC+0tmDHt0jOVV1glVeoE3igwEqmjINehXVQ+Oi4iwqdMj3U
         n0Rjmb1WHFeenEIzr6wczu1cZntprWS//fLDt9N01K8shBv3T+73+s/ZgEZyGhvrE62z
         cmxYW7+CL2o+0daw7olysQZmyy9cmajhK7w1HM+t3kgbs/9iVwsQ/QwGrKFMw+3KKes9
         1ApJdcC/tkKpBQExY7tXOL+6UG1th0kaewVYYXCd5rm6K4MkldpsXtcTsUqR+5k7awJP
         r8ogkkG7n57UqmClcyEhGGe2I01LanIBEaGAMcM6PlnNQP9OvVXpVkaiIwCZnSQdAJtU
         b+0g==
X-Gm-Message-State: AOAM532rSDkkKs5nFf3D/dn85010nABEZjWzf/evQgTJ/B7CTHvgSqzw
        VhEIgGPWJTy8R5GFUm3U38c=
X-Google-Smtp-Source: ABdhPJz2+B3NF+TIRWPr9YrWHgP71P7pPsM9YnXWGJbgnacqQE/bHoF2pwiI237N1xJL6Fe7MazANA==
X-Received: by 2002:a63:7a0f:: with SMTP id v15mr3195149pgc.100.1620945487398;
        Thu, 13 May 2021 15:38:07 -0700 (PDT)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4000:d7:54a8:4531:57a:cfd8])
        by smtp.gmail.com with ESMTPSA id j23sm2852582pfh.179.2021.05.13.15.38.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 13 May 2021 15:38:06 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>,
        Jaegeuk Kim <jaegeuk@kernel.org>, linux-scsi@vger.kernel.org,
        Bart Van Assche <bvanassche@acm.org>,
        Sagi Grimberg <sagi@grimberg.me>
Subject: [PATCH v3 2/8] iser: Use scsi_get_sector() instead of scsi_get_lba()
Date:   Thu, 13 May 2021 15:37:51 -0700
Message-Id: <20210513223757.3938-3-bvanassche@acm.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210513223757.3938-1-bvanassche@acm.org>
References: <20210513223757.3938-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Use scsi_get_sector() instead of scsi_get_lba() since the name of the
latter is confusing. This patch does not change any functionality.

Reviewed-by: Sagi Grimberg <sagi@grimberg.me>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/infiniband/ulp/iser/iser_verbs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/infiniband/ulp/iser/iser_verbs.c b/drivers/infiniband/ulp/iser/iser_verbs.c
index 136f6c4492e0..d6bbf1bf428c 100644
--- a/drivers/infiniband/ulp/iser/iser_verbs.c
+++ b/drivers/infiniband/ulp/iser/iser_verbs.c
@@ -949,7 +949,7 @@ u8 iser_check_task_pi_status(struct iscsi_iser_task *iser_task,
 			sector_t sector_off = mr_status.sig_err.sig_err_offset;
 
 			sector_div(sector_off, sector_size + 8);
-			*sector = scsi_get_lba(iser_task->sc) + sector_off;
+			*sector = scsi_get_sector(iser_task->sc) + sector_off;
 
 			iser_err("PI error found type %d at sector %llx "
 			       "expected %x vs actual %x\n",
