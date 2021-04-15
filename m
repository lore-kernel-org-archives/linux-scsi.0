Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A88F2C433B4
	for <linux-scsi@archiver.kernel.org>; Thu, 15 Apr 2021 22:08:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 71088610FB
	for <linux-scsi@archiver.kernel.org>; Thu, 15 Apr 2021 22:08:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235279AbhDOWJC (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 15 Apr 2021 18:09:02 -0400
Received: from mail-pf1-f172.google.com ([209.85.210.172]:33467 "EHLO
        mail-pf1-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234654AbhDOWJA (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 15 Apr 2021 18:09:00 -0400
Received: by mail-pf1-f172.google.com with SMTP id a85so16559322pfa.0
        for <linux-scsi@vger.kernel.org>; Thu, 15 Apr 2021 15:08:37 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=BdbZQ2gr0JrwdWn6uZddgTtiGW3iUyqvuUmU2iNR/0M=;
        b=Piw536O+CiT0IfEvRHMBCTk7ukGL8kjUrlPDCRll1C7achAe9HvPmcjaE9lN/8jNpK
         wOABJg41nFWTQPQ8V5nHgY4pgDhVoNrrYxBtNc3/Zjm2eDHBoyalgGeLvxT70JxwuUA0
         EA/Kk9aeanNBIzZVsmo1tzkSSKmP1haZmTwTQrHv4aAfjHTctd2ujdsHOdOUKKsB8g/d
         owVl+mPA1z9MFmpEDEIv3QuJUhV87uu5ShqOyDUEoVWZ7zGGLHnO/LdNKNBCsSIHefy7
         TziZrfmRcqzFkrthHdKnOyFvpH2DuA+Rqr1ZW7HHeC7sWCyhW4DFMR0juBEfnrYS+mcO
         MpdQ==
X-Gm-Message-State: AOAM530LwlCXPTcPRoRR3BloiP55tjOFCUbemS3zJapNCJG9NYQQ7R85
        /5ob3ZfHQzeChH89rK+RKew=
X-Google-Smtp-Source: ABdhPJw/LUdnaYBOQNPd+5YTDXMSEQdRcqdMqQWjGwBwQiZLicdEjOzWbWwggKP4IXyyF1H/dpqgCw==
X-Received: by 2002:a63:d309:: with SMTP id b9mr5222616pgg.96.1618524516998;
        Thu, 15 Apr 2021 15:08:36 -0700 (PDT)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4000:d7:f031:1d3a:7e95:2876])
        by smtp.gmail.com with ESMTPSA id w4sm3311155pjk.55.2021.04.15.15.08.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Apr 2021 15:08:36 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>
Cc:     linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        Bart Van Assche <bvanassche@acm.org>,
        Johannes Thumshirn <johannes.thumshirn@wdc.com>,
        Hannes Reinecke <hare@suse.de>, Daniel Wagner <dwagner@suse.de>
Subject: [PATCH v2 01/20] Make the scsi_alloc_sgtables() documentation more accurate
Date:   Thu, 15 Apr 2021 15:08:07 -0700
Message-Id: <20210415220826.29438-2-bvanassche@acm.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210415220826.29438-1-bvanassche@acm.org>
References: <20210415220826.29438-1-bvanassche@acm.org>
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
