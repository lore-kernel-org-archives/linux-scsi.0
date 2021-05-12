Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 28A8FC43461
	for <linux-scsi@archiver.kernel.org>; Wed, 12 May 2021 21:26:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EA4A2613E6
	for <linux-scsi@archiver.kernel.org>; Wed, 12 May 2021 21:26:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344089AbhELVXW (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 12 May 2021 17:23:22 -0400
Received: from mail-pl1-f173.google.com ([209.85.214.173]:46721 "EHLO
        mail-pl1-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1385588AbhELUKK (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 12 May 2021 16:10:10 -0400
Received: by mail-pl1-f173.google.com with SMTP id s20so13104373plr.13
        for <linux-scsi@vger.kernel.org>; Wed, 12 May 2021 13:09:00 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=nSv5X4y9sOkTjDLwOr2XKXeP6Cfhir7BXtEsp9sc/Hc=;
        b=nS6T8vi+B9FiX2Rio8uJYEeFsSRxWBHsSVrxPeyD7Nk7SNYCXMGbkW+MLrjVcOsBI5
         GvWgiv9dmBDVwIhl0wYG4K2Rxb8aGH2JYkKAnYVesF5CUw2JvSTL3PTuxN4JmIwNYX30
         UjXvW2W6SQoyuRjfOJyo5Mpi1F8bi8TPlFEJYOIQgVhA4IkB3x35umal6IIxN9v8HYN+
         9V9ATl7PfImkOSroAZ+uif6o9hTji4IQK1jnsMNl+a5BVV257Kky6dGtVIQkFMZBifs/
         S5+mJPoKm2Sjw9gRmRCIymOts7kUEciGp+go3FVtKfuLzTc3ZC3XN82AZ/3lgozCdZnX
         HJTw==
X-Gm-Message-State: AOAM531AezpH+e/4cLk1KktwzfU4SE7LatrSMuHe3Dvx6NKuz87CugPc
        nanO1nWRL3u3rY8UTajUocw=
X-Google-Smtp-Source: ABdhPJwMLaYLfxASh0NwVOlRQzmJVoc8uaxg5nZHWJmGAIikYD3hHgpTFTo6/azOSDIguSFrXdyZLw==
X-Received: by 2002:a17:902:7402:b029:ef:7d5c:62c1 with SMTP id g2-20020a1709027402b02900ef7d5c62c1mr5780178pll.4.1620850139701;
        Wed, 12 May 2021 13:08:59 -0700 (PDT)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4000:d7:993e:1516:b2ba:76fe])
        by smtp.gmail.com with ESMTPSA id l21sm513948pfc.114.2021.05.12.13.08.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 May 2021 13:08:59 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Bean Huo <beanhuo@micron.com>,
        Avri Altman <avri.altman@wdc.com>,
        Asutosh Das <asutoshd@codeaurora.org>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        Can Guo <cang@codeaurora.org>, linux-scsi@vger.kernel.org,
        Bart Van Assche <bvanassche@acm.org>,
        Sagi Grimberg <sagi@grimberg.me>
Subject: [PATCH v2 2/7] iser: Use scsi_get_pos() instead of scsi_get_lba()
Date:   Wed, 12 May 2021 13:08:44 -0700
Message-Id: <20210512200849.9002-3-bvanassche@acm.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210512200849.9002-1-bvanassche@acm.org>
References: <20210512200849.9002-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Use scsi_get_pos() instead of scsi_get_lba() since the name of the latter
is confusing. This patch does not change any functionality.

Cc: Sagi Grimberg <sagi@grimberg.me>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/infiniband/ulp/iser/iser_verbs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/infiniband/ulp/iser/iser_verbs.c b/drivers/infiniband/ulp/iser/iser_verbs.c
index 136f6c4492e0..c33e113eeee5 100644
--- a/drivers/infiniband/ulp/iser/iser_verbs.c
+++ b/drivers/infiniband/ulp/iser/iser_verbs.c
@@ -949,7 +949,7 @@ u8 iser_check_task_pi_status(struct iscsi_iser_task *iser_task,
 			sector_t sector_off = mr_status.sig_err.sig_err_offset;
 
 			sector_div(sector_off, sector_size + 8);
-			*sector = scsi_get_lba(iser_task->sc) + sector_off;
+			*sector = scsi_get_pos(iser_task->sc) + sector_off;
 
 			iser_err("PI error found type %d at sector %llx "
 			       "expected %x vs actual %x\n",
