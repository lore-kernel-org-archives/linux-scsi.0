Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C39D6C7EE26
	for <linux-scsi@archiver.kernel.org>; Thu,  4 May 2023 23:51:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229927AbjEDXvR (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 4 May 2023 19:51:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60236 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229892AbjEDXvP (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 4 May 2023 19:51:15 -0400
Received: from mail-pl1-f178.google.com (mail-pl1-f178.google.com [209.85.214.178])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0784012E95
        for <linux-scsi@vger.kernel.org>; Thu,  4 May 2023 16:51:15 -0700 (PDT)
Received: by mail-pl1-f178.google.com with SMTP id d9443c01a7336-1ab267e3528so8373635ad.0
        for <linux-scsi@vger.kernel.org>; Thu, 04 May 2023 16:51:15 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683244274; x=1685836274;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=VZc+Et9tF0UXe9FM/xTBBxaabqXfpabHUxRRUCkqqME=;
        b=In+Dgr8RvGQehv4jY2bLnO/4b5LdqQ2g0cRMV2zuk7Nn2t7zZq3pfIjl87j1I75SUM
         FrF7Q31Q6t2SatfgBvNEUwiqYJSEVwDFrEdmtCeiEzktXg5NOGeSvhnvjomjphr4v/ye
         NgLGwMGjh5o9YiqSIxEoLnYwC4NiuxMg3Sxt9DrUR2HHKbwyfoexDgPhR4gp1zbydpR5
         6lunypB9Ri/HwfuZbJz+Gn6vrdGYc+XwGwYi1xehkryZfOHWgWTIi8raVsNXq5QNMzi6
         +s+6HUYXq69i1poiBWLWlvLeaHFVE3w33JyqsWDi+a0GD3HUar1kSmyxzZbCdVNUaY4a
         NFJQ==
X-Gm-Message-State: AC+VfDwZWVjVPZZX32zDBBWFwAT/RGErI1bJQC5zwpL3yndOsgVEvvOJ
        0NPsNvy3iAJ8dPuPgOIHwC4=
X-Google-Smtp-Source: ACHHUZ6A62KETF+PbJWDXJhKugddm8FVLgj8gsNi7eSoWDWKGdLjhMJyVhjN4IIZ5u3xFmPg9jD4Dg==
X-Received: by 2002:a17:902:ce83:b0:1a5:2db2:2bb with SMTP id f3-20020a170902ce8300b001a52db202bbmr6351494plg.15.1683244274387;
        Thu, 04 May 2023 16:51:14 -0700 (PDT)
Received: from asus.hsd1.ca.comcast.net ([98.51.102.78])
        by smtp.gmail.com with ESMTPSA id j13-20020a170902758d00b001aad4be4503sm143169pll.2.2023.05.04.16.51.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 May 2023 16:51:13 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Jaegeuk Kim <jaegeuk@kernel.org>, linux-scsi@vger.kernel.org,
        Bart Van Assche <bvanassche@acm.org>,
        Mike Christie <michael.christie@oracle.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH 2/5] scsi: core: Support setting BLK_MQ_F_BLOCKING
Date:   Thu,  4 May 2023 16:50:49 -0700
Message-Id: <20230504235052.4423-3-bvanassche@acm.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230504235052.4423-1-bvanassche@acm.org>
References: <20230504235052.4423-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Prepare for adding code in ufshcd_queuecommand() that may sleep. This
patch is similar to a patch posted last year by Mike Christie. See also
https://lore.kernel.org/all/20220308003957.123312-2-michael.christie@oracle.com/

Cc: Mike Christie <michael.christie@oracle.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/scsi_lib.c  | 10 +++-------
 include/scsi/scsi_host.h |  3 +++
 2 files changed, 6 insertions(+), 7 deletions(-)

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 758a57616dd3..894af68babc2 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -1982,6 +1982,8 @@ int scsi_mq_setup_tags(struct Scsi_Host *shost)
 	tag_set->flags = BLK_MQ_F_SHOULD_MERGE;
 	tag_set->flags |=
 		BLK_ALLOC_POLICY_TO_MQ_FLAG(shost->hostt->tag_alloc_policy);
+	if (shost->hostt->queuecommand_may_block)
+		tag_set->flags |= BLK_MQ_F_BLOCKING;
 	tag_set->driver_data = shost;
 	if (shost->host_tagset)
 		tag_set->flags |= BLK_MQ_F_TAG_HCTX_SHARED;
@@ -2968,13 +2970,7 @@ scsi_host_block(struct Scsi_Host *shost)
 		}
 	}
 
-	/*
-	 * SCSI never enables blk-mq's BLK_MQ_F_BLOCKING flag so
-	 * calling synchronize_rcu() once is enough.
-	 */
-	WARN_ON_ONCE(shost->tag_set.flags & BLK_MQ_F_BLOCKING);
-
-	synchronize_rcu();
+	blk_mq_wait_quiesce_done(&shost->tag_set);
 
 	return 0;
 }
diff --git a/include/scsi/scsi_host.h b/include/scsi/scsi_host.h
index 0f29799efa02..37a8a2608dc2 100644
--- a/include/scsi/scsi_host.h
+++ b/include/scsi/scsi_host.h
@@ -458,6 +458,9 @@ struct scsi_host_template {
 	/* True if the host uses host-wide tagspace */
 	unsigned host_tagset:1;
 
+	/* The queuecommand callback may block. See also BLK_MQ_F_BLOCKING. */
+	unsigned queuecommand_may_block:1;
+
 	/*
 	 * Countdown for host blocking with no commands outstanding.
 	 */
