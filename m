Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E15F7C11F67
	for <linux-scsi@archiver.kernel.org>; Thu,  1 Jul 2021 21:13:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C849F61405
	for <linux-scsi@archiver.kernel.org>; Thu,  1 Jul 2021 21:13:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233811AbhGAVPz (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 1 Jul 2021 17:15:55 -0400
Received: from mail-pl1-f172.google.com ([209.85.214.172]:42755 "EHLO
        mail-pl1-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229934AbhGAVPy (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 1 Jul 2021 17:15:54 -0400
Received: by mail-pl1-f172.google.com with SMTP id v13so4408694ple.9
        for <linux-scsi@vger.kernel.org>; Thu, 01 Jul 2021 14:13:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=BcLOumkWjxXSrw0lsUXBmNDTMMbqTdhadkQZCqHLM0E=;
        b=GbSLSOrg/i3VxUpwLSWEVMN9w4UDVy2in+hsq/yl6YWJ6Jh5Xl9UVEuCx9jS4EFKmu
         xmKjLdsn5fxAogvoD3VA1uFZ2Qy6l4+lwjIfuCR6OaYxt4Nt2sc8pwFd+zEkyfiELDtQ
         u20rE1JDSvnNWSR/VniblMip1uegFzjpD/3XQ/DdXbN5Grh32zxbgItsJ01UCGEjCthm
         u+qbzQgEtt4yByYnJTgg+AlxOXFPKskyE0ek66o8rBHcpc+2316RRde89OjRAYz7uXHK
         ZN4AFBgfQdL6xudC6INefZC7vtG5jt0ec9B6lOfj1x7ndcLkK9ledX4oIU8XthGr585i
         xhKQ==
X-Gm-Message-State: AOAM532gZ/8dIMDZ1zuzxKtRIExleAHyYuBpyWFczV55wTpzwO/bA4XY
        NL7KU4Fz13/zC+TKnGTyu2g=
X-Google-Smtp-Source: ABdhPJz71KQhzol1wszhKrVmxktdSJTIPZpVmatCr2qumz0F/u6o+KE+vSBqvZV0E0MMMDpleZ8h0A==
X-Received: by 2002:a17:90a:db8a:: with SMTP id h10mr12059040pjv.50.1625174002823;
        Thu, 01 Jul 2021 14:13:22 -0700 (PDT)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4000:d7:6a75:b07:a0d:8bd5])
        by smtp.gmail.com with ESMTPSA id k25sm900832pfa.213.2021.07.01.14.13.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 Jul 2021 14:13:22 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Jaegeuk Kim <jaegeuk@kernel.org>,
        Bart Van Assche <bvanassche@acm.org>,
        Avri Altman <avri.altman@wdc.com>,
        Can Guo <cang@codeaurora.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Bean Huo <beanhuo@micron.com>,
        Asutosh Das <asutoshd@codeaurora.org>,
        Adrian Hunter <adrian.hunter@intel.com>
Subject: [PATCH 12/21] ufs: Improve static type checking for the host controller state
Date:   Thu,  1 Jul 2021 14:12:15 -0700
Message-Id: <20210701211224.17070-13-bvanassche@acm.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210701211224.17070-1-bvanassche@acm.org>
References: <20210701211224.17070-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Assign a name to the enumeration type for UFS host controller states and
remove the default clause from switch statements on this enumeration type
to make the compiler warn about unhandled enumeration labels.

Reviewed-by: Avri Altman <avri.altman@wdc.com>
Cc: Can Guo <cang@codeaurora.org>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/ufs/ufshcd.c | 15 ---------------
 drivers/scsi/ufs/ufshcd.h | 25 +++++++++++++++++++++++--
 2 files changed, 23 insertions(+), 17 deletions(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 1262f1a63e0b..7091798e6245 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -128,15 +128,6 @@ enum {
 	UFSHCD_CAN_QUEUE	= 32,
 };
 
-/* UFSHCD states */
-enum {
-	UFSHCD_STATE_RESET,
-	UFSHCD_STATE_ERROR,
-	UFSHCD_STATE_OPERATIONAL,
-	UFSHCD_STATE_EH_SCHEDULED_FATAL,
-	UFSHCD_STATE_EH_SCHEDULED_NON_FATAL,
-};
-
 /* UFSHCD error handling flags */
 enum {
 	UFSHCD_EH_IN_PROGRESS = (1 << 0),
@@ -2735,12 +2726,6 @@ static int ufshcd_queuecommand(struct Scsi_Host *host, struct scsi_cmnd *cmd)
 		set_host_byte(cmd, DID_ERROR);
 		cmd->scsi_done(cmd);
 		goto out;
-	default:
-		dev_WARN_ONCE(hba->dev, 1, "%s: invalid state %d\n",
-				__func__, hba->ufshcd_state);
-		set_host_byte(cmd, DID_BAD_TARGET);
-		cmd->scsi_done(cmd);
-		goto out;
 	}
 
 	hba->req_abort_count = 0;
diff --git a/drivers/scsi/ufs/ufshcd.h b/drivers/scsi/ufs/ufshcd.h
index 0dfb5e97ec0d..f8766e8f3cac 100644
--- a/drivers/scsi/ufs/ufshcd.h
+++ b/drivers/scsi/ufs/ufshcd.h
@@ -476,6 +476,27 @@ struct ufs_stats {
 	struct ufs_event_hist event[UFS_EVT_CNT];
 };
 
+/**
+ * enum ufshcd_state - UFS host controller state
+ * @UFSHCD_STATE_RESET: Link is not operational. Postpone SCSI command
+ *	processing.
+ * @UFSHCD_STATE_OPERATIONAL: The host controller is operational and can process
+ *	SCSI commands.
+ * @UFSHCD_STATE_EH_SCHEDULED_NON_FATAL: The error handler has been scheduled.
+ *	SCSI commands may be submitted to the controller.
+ * @UFSHCD_STATE_EH_SCHEDULED_FATAL: The error handler has been scheduled. Fail
+ *	newly submitted SCSI commands with error code DID_BAD_TARGET.
+ * @UFSHCD_STATE_ERROR: An unrecoverable error occurred, e.g. link recovery
+ *	failed. Fail all SCSI commands with error code DID_ERROR.
+ */
+enum ufshcd_state {
+	UFSHCD_STATE_RESET,
+	UFSHCD_STATE_OPERATIONAL,
+	UFSHCD_STATE_EH_SCHEDULED_NON_FATAL,
+	UFSHCD_STATE_EH_SCHEDULED_FATAL,
+	UFSHCD_STATE_ERROR,
+};
+
 enum ufshcd_quirks {
 	/* Interrupt aggregation support is broken */
 	UFSHCD_QUIRK_BROKEN_INTR_AGGR			= 1 << 0,
@@ -687,7 +708,7 @@ struct ufs_hba_monitor {
  * @tmf_tag_set: TMF tag set.
  * @tmf_queue: Used to allocate TMF tags.
  * @pwr_done: completion for power mode change
- * @ufshcd_state: UFSHCD states
+ * @ufshcd_state: UFSHCD state
  * @eh_flags: Error handling flags
  * @intr_mask: Interrupt Mask Bits
  * @ee_ctrl_mask: Exception event control mask
@@ -785,7 +806,7 @@ struct ufs_hba {
 	struct mutex uic_cmd_mutex;
 	struct completion *uic_async_done;
 
-	u32 ufshcd_state;
+	enum ufshcd_state ufshcd_state;
 	u32 eh_flags;
 	u32 intr_mask;
 	u16 ee_ctrl_mask; /* Exception event mask */
