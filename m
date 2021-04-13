Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C8757C433ED
	for <linux-scsi@archiver.kernel.org>; Tue, 13 Apr 2021 17:07:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AB3F6613B7
	for <linux-scsi@archiver.kernel.org>; Tue, 13 Apr 2021 17:07:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347071AbhDMRHm (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 13 Apr 2021 13:07:42 -0400
Received: from mail-pj1-f44.google.com ([209.85.216.44]:37507 "EHLO
        mail-pj1-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347068AbhDMRHl (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 13 Apr 2021 13:07:41 -0400
Received: by mail-pj1-f44.google.com with SMTP id e8-20020a17090a7288b029014e51f5a6baso4010552pjg.2
        for <linux-scsi@vger.kernel.org>; Tue, 13 Apr 2021 10:07:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=BdbZQ2gr0JrwdWn6uZddgTtiGW3iUyqvuUmU2iNR/0M=;
        b=PdJFkoJzXRb0jL4k/y599upw7UPIXxZdzCNS8xD139VrmwcJ9QRg6rDeukMA2QU+Jn
         HTReSVY2u6lPtMKZI516uOLbbV32AikEr/hSd8gOYwYnhMvW5NIqpKvXuwlhcnSGFcWf
         UZcvd/yGPUlBxei+D3BcTpoV8WT/SHSxu4O38XAF7/zj2Wf8sLHSOunLAosdw9tkCTFa
         OiqYoVHpxIXLzAf91VNHQuFyBj5wd9GJG29ydVdcjL9v1phV+k3dWsnxkTvSU3ix0Xby
         oOPZVaawZ7lDxlw8lTAQKtfiK+rycgiqpzxW73TNLni/Kkrc06Lk26twFrhgy6kOsInD
         Hbmg==
X-Gm-Message-State: AOAM531Dwatk/nuI8jYzoeAxv3QzxZfBA7hq8hABBa0p5yAqIf2R8FFc
        bCD5L8CKpDHJNlOWXwXM09k=
X-Google-Smtp-Source: ABdhPJxwAGslvNWEU/i3ZnSEPYPteOhMqDvvK1EuFZLWYUSVhXXxnCK31Xrv7+7hwLyRYCmIru/rjg==
X-Received: by 2002:a17:90a:a895:: with SMTP id h21mr1064174pjq.13.1618333642009;
        Tue, 13 Apr 2021 10:07:22 -0700 (PDT)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4000:d7:345f:c70d:97e0:e2ef])
        by smtp.gmail.com with ESMTPSA id z10sm6736078pfe.218.2021.04.13.10.07.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 13 Apr 2021 10:07:21 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>
Cc:     linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        Bart Van Assche <bvanassche@acm.org>,
        Johannes Thumshirn <johannes.thumshirn@wdc.com>,
        Hannes Reinecke <hare@suse.de>, Daniel Wagner <dwagner@suse.de>
Subject: [PATCH 01/20] Make the scsi_alloc_sgtables() documentation more accurate
Date:   Tue, 13 Apr 2021 10:06:55 -0700
Message-Id: <20210413170714.2119-2-bvanassche@acm.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210413170714.2119-1-bvanassche@acm.org>
References: <20210413170714.2119-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The current scsi_alloc_sgtables() documentation does not accurately explain
what this function does. Hence improve the documentation of this function.

Cc: Christoph Hellwig <hch@lst.de>
Cc: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Cc: Hannes Reinecke <hare@suse.de>
Cc: Daniel Wagner <dwagner@suse.de>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/scsi_lib.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 66e670aedd4c..985ed427445f 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -999,8 +999,11 @@ static inline bool scsi_cmd_needs_dma_drain(struct scsi_device *sdev,
 }
 
 /**
- * scsi_alloc_sgtables - allocate S/G tables for a command
- * @cmd:  command descriptor we wish to initialize
+ * scsi_alloc_sgtables - Allocate and initialize data and integrity scatterlists
+ * @cmd: SCSI command data structure to initialize.
+ *
+ * Initializes @cmd->sdb and also @cmd->prot_sdb if data integrity is enabled
+ * for @cmd.
  *
  * Returns:
  * * BLK_STS_OK       - on success
