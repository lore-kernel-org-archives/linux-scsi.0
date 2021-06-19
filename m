Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F3325C48BE8
	for <linux-scsi@archiver.kernel.org>; Sat, 19 Jun 2021 00:52:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DB27B6124C
	for <linux-scsi@archiver.kernel.org>; Sat, 19 Jun 2021 00:52:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234632AbhFSAzC (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 18 Jun 2021 20:55:02 -0400
Received: from mail-pj1-f48.google.com ([209.85.216.48]:51735 "EHLO
        mail-pj1-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231819AbhFSAzB (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 18 Jun 2021 20:55:01 -0400
Received: by mail-pj1-f48.google.com with SMTP id k5so6707778pjj.1
        for <linux-scsi@vger.kernel.org>; Fri, 18 Jun 2021 17:52:51 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=amb2Z/3Vx8cJ+/PVG3i59QICoRf0etMRuqtCr11gny4=;
        b=unfQhzcF7Nz75UQQQ0qwfN4MBALWG3bsy/h/No4Y3645oVacJiIF8/waUGmmLPDtKP
         ynaabMf3BgIPU+n6QYxzigztCambkbY/Youlj/RThfG6Bh6tvHKx95DOmtStouNkY9/V
         EXSO2rjvurCZOAo0yB3SNFiP5AMw4hp/Cw7PR7WLRR8gVgarcT+DenoNBAW8JtRfRtDI
         Cd6MUfFbYeKbkA6YZggwcuQgeqZ3/6SZaTLSiVc2B7oAjVp4SjnEwPk46+F6YgPOWf2K
         kgmZUQWopHplrCQMz/bj34GJjezaVRs/oHo/nZHW4kJ4zoYdZqS0lv3qTpA8luHI/U2u
         sZ8A==
X-Gm-Message-State: AOAM530qBAs7rl3xpWZC1uNcol35FOvNLn+hE3sy+ziiMchIbogUhUPY
        Z3Mym5fJ9XuDLL1dCd4E6eE=
X-Google-Smtp-Source: ABdhPJzy/eyurlUybjtP0TH+RgKN1EtaUT3cNQW1nvRSG5jB/t/+pwJgw+7It5H3zdFD7ggzOVgevg==
X-Received: by 2002:a17:90a:70c7:: with SMTP id a7mr18882766pjm.31.1624063970853;
        Fri, 18 Jun 2021 17:52:50 -0700 (PDT)
Received: from asus.hsd1.ca.comcast.net (c-73-241-217-19.hsd1.ca.comcast.net. [73.241.217.19])
        by smtp.gmail.com with ESMTPSA id p6sm9934460pjh.24.2021.06.18.17.52.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Jun 2021 17:52:50 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Can Guo <cang@codeaurora.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Bean Huo <beanhuo@micron.com>,
        Avri Altman <avri.altman@wdc.com>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Asutosh Das <asutoshd@codeaurora.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Kiwoong Kim <kwmad.kim@samsung.com>
Subject: [PATCH RFC 3/4] ufs: Improve static type checking for the host controller state
Date:   Fri, 18 Jun 2021 17:52:27 -0700
Message-Id: <20210619005228.28569-4-bvanassche@acm.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210619005228.28569-1-bvanassche@acm.org>
References: <20210619005228.28569-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Assign a name to the enumeration type for UFS host controller states and
remove the default clause from switch statements on this enumeration type
to make the compiler warn about unhandled enumeration labels.

Cc: Can Guo <cang@codeaurora.org>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/ufs/ufshcd.c | 15 ---------------
 drivers/scsi/ufs/ufshcd.h | 25 +++++++++++++++++++++++--
 2 files changed, 23 insertions(+), 17 deletions(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 71c720d940a3..c213daec20f7 100644
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
@@ -2738,12 +2729,6 @@ static int ufshcd_queuecommand(struct Scsi_Host *host, struct scsi_cmnd *cmd)
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
index c98d540ac044..f2796ea25598 100644
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
