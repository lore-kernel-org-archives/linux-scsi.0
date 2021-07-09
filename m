Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.0 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B7209C07E99
	for <linux-scsi@archiver.kernel.org>; Fri,  9 Jul 2021 20:27:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9440A613C8
	for <linux-scsi@archiver.kernel.org>; Fri,  9 Jul 2021 20:27:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230375AbhGIUaI (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 9 Jul 2021 16:30:08 -0400
Received: from mail-pg1-f182.google.com ([209.85.215.182]:33676 "EHLO
        mail-pg1-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230316AbhGIUaI (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 9 Jul 2021 16:30:08 -0400
Received: by mail-pg1-f182.google.com with SMTP id 37so11123454pgq.0
        for <linux-scsi@vger.kernel.org>; Fri, 09 Jul 2021 13:27:24 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=+bUSeIVYQCY7hhVEVk8NWHD0iFRmd8p3U5mxrNOyxRU=;
        b=oLGFWEAu5i18xEe+J+PFylbkhgMfjPkD1RywHxRq7my9AhBo8YGuqveaRZbg+E5Tql
         F28T5udzgu60s4ZFBIfI9QLQitVzAx9+XSsBJjWwK1wywuLKRQhmCwgL3qOvDuR+aGxv
         fowl4HkT+Vx9If86xLlTwvXVVgll6N15J/uQU8mV/CRByz74PX/t7QxTyBck6Agc4eQb
         f5/lqtG8C5wvQUJ+M1+s98m3tGNxvPrEYZQdZtJNdSRkMPcKB569VYkFmDdP8TU5fVFC
         pGugrkyf9BwqyBr7qEWPuytdcd3QLMasdCG7WekoCSxcCdmTx21i6j0r1oBSXUgrWBNh
         +gjA==
X-Gm-Message-State: AOAM530r+7HPtaDTVMlIkeDTk40LR0S9xGaruc10ll+OXmbfpeCdQgUl
        5rAlgplN4Zw+jVvYcmdZqWU=
X-Google-Smtp-Source: ABdhPJyrbxaeAPLp0b9xkOZsoEGHyS8bsMCjrNR7WzQ9F2OVUz+DgVWJy29t9y6JiGm9N2iinPjKJw==
X-Received: by 2002:a05:6a00:2c3:b029:317:874a:391c with SMTP id b3-20020a056a0002c3b0290317874a391cmr39084575pft.5.1625862443975;
        Fri, 09 Jul 2021 13:27:23 -0700 (PDT)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4000:d7:eeaf:c266:e6cc:b591])
        by smtp.gmail.com with ESMTPSA id e16sm8812927pgl.54.2021.07.09.13.27.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 09 Jul 2021 13:27:23 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Jaegeuk Kim <jaegeuk@kernel.org>,
        Bart Van Assche <bvanassche@acm.org>,
        Akinobu Mita <akinobu.mita@gmail.com>,
        Avri Altman <avri.altman@wdc.com>,
        Can Guo <cang@codeaurora.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Bean Huo <beanhuo@micron.com>,
        Asutosh Das <asutoshd@codeaurora.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Kiwoong Kim <kwmad.kim@samsung.com>
Subject: [PATCH v2 08/19] scsi: ufs: Improve static type checking for the host controller state
Date:   Fri,  9 Jul 2021 13:26:27 -0700
Message-Id: <20210709202638.9480-10-bvanassche@acm.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210709202638.9480-1-bvanassche@acm.org>
References: <20210709202638.9480-1-bvanassche@acm.org>
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
index bf47ef41326e..1585eea27200 100644
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
@@ -2737,12 +2728,6 @@ static int ufshcd_queuecommand(struct Scsi_Host *host, struct scsi_cmnd *cmd)
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
