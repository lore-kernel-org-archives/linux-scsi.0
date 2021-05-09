Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 559F0C433ED
	for <linux-scsi@archiver.kernel.org>; Sun,  9 May 2021 21:43:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 35B7F613C5
	for <linux-scsi@archiver.kernel.org>; Sun,  9 May 2021 21:43:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229925AbhEIVoX (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 9 May 2021 17:44:23 -0400
Received: from mail-pg1-f179.google.com ([209.85.215.179]:36555 "EHLO
        mail-pg1-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229662AbhEIVoW (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 9 May 2021 17:44:22 -0400
Received: by mail-pg1-f179.google.com with SMTP id c21so11904418pgg.3
        for <linux-scsi@vger.kernel.org>; Sun, 09 May 2021 14:43:18 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=nSv5X4y9sOkTjDLwOr2XKXeP6Cfhir7BXtEsp9sc/Hc=;
        b=FMU33u5XSK2CogrcYirrUS00vgUyaWGWctfGdt7UTzSq95ZiRLBAL+McRVmUdTQtKx
         XzSl7kFaeZRA7BNamiY4g2qLgg7du63XYn700IxgTX60fAW5a50cySvsclCz7duehy2M
         U9WjxpmulTcZX2W3xhJ3W6yMRZOtzAjSsb8fLsI+YL5Bt5nnTBwA2sPL6yPrMbTvLUUY
         ADL4I5Hbwt6NOfiG+Dv8jtg7TvN58NFrNnvlP5hWv7ejm8YfZWqbYx9/7yzlbemJkZWa
         GCNrhHxVgPIZn53dTuNg+rBdqc5zl2KdhjvI5FMjpgrNi/wJnV9FHJnYSBOzv5WCLMDM
         u3ZQ==
X-Gm-Message-State: AOAM532oSuY0+1ubx4O1si0GJC0KCgGNoDzTrBen21KT85djoTL0FMA/
        PqULDA53vSMEYSvp16XVU0M=
X-Google-Smtp-Source: ABdhPJxN1cVG/omkovcQXjSFIE6uAkzVmWWRYD7fR0K6VLCT1yp+9a5TtY2s31WjBa8uOh6rYZ6WZQ==
X-Received: by 2002:aa7:8d5a:0:b029:227:7b07:7d8b with SMTP id s26-20020aa78d5a0000b02902277b077d8bmr21346530pfe.26.1620596597838;
        Sun, 09 May 2021 14:43:17 -0700 (PDT)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4000:d7:1f3e:222f:39bb:cb2e])
        by smtp.gmail.com with ESMTPSA id t4sm9712567pfq.165.2021.05.09.14.43.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 09 May 2021 14:43:17 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>
Cc:     linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        Hannes Reinecke <hare@suse.com>,
        Ming Lei <ming.lei@redhat.com>,
        Bart Van Assche <bvanassche@acm.org>,
        Sagi Grimberg <sagi@grimberg.me>
Subject: [PATCH 2/7] iser: Use scsi_get_pos() instead of scsi_get_lba()
Date:   Sun,  9 May 2021 14:43:02 -0700
Message-Id: <20210509214307.4610-3-bvanassche@acm.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210509214307.4610-1-bvanassche@acm.org>
References: <20210509214307.4610-1-bvanassche@acm.org>
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
