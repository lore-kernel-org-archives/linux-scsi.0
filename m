Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D6EADC07E9D
	for <linux-scsi@archiver.kernel.org>; Thu, 22 Jul 2021 03:35:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C09986124B
	for <linux-scsi@archiver.kernel.org>; Thu, 22 Jul 2021 03:35:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230399AbhGVCyx (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 21 Jul 2021 22:54:53 -0400
Received: from mail-pj1-f43.google.com ([209.85.216.43]:36373 "EHLO
        mail-pj1-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230366AbhGVCyw (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 21 Jul 2021 22:54:52 -0400
Received: by mail-pj1-f43.google.com with SMTP id ds11-20020a17090b08cbb0290172f971883bso2319839pjb.1
        for <linux-scsi@vger.kernel.org>; Wed, 21 Jul 2021 20:35:27 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=JrnO2fd8PQeMK4bwjGvzeGCXA6m1dtIHE9vp+QYr+oU=;
        b=cf6Op478IcU04oOR+8tst+JoO9WL6wJjmP9uF4212Tc2qcfRGwK9TiXq+ojxiSAP8c
         19+3LpSbiNWDog7E7v+Gnkdd7/AZ5w8BNydBvzbtZvgnqw8t9HutiyQL6bagYr4pHp71
         Gn0B7N54miJWUv6csxIBPHDu+8yjYo4apV8NRlmiBYf537QH9II4okJrHTtuNoBeBb3S
         yx6A9Xk3WgHsfDf6410c6I6sQkEpwnMIejaU7loCXnKGRtpOTBnxB9ObaEjq9GY19IBm
         48OyY9BIkeaoEUySP3dbwrykWXoBrjnPWz140dfHKQpygDGniWEo426eX+XDl/9zuGem
         aEbQ==
X-Gm-Message-State: AOAM530ZQCbET+t5cEvX7kCja+eERJL9lcFUAlMy3TEN7mCVHZU3QgaW
        T1ThsN66cPsAaWZ8pawDQkQ=
X-Google-Smtp-Source: ABdhPJwrMwDlK6wmO5/HVN3g8jgVn90NRV1HzOad2FN3kdTJuCu9hce7PU8DGmjaUoo7vLetrK+fHw==
X-Received: by 2002:a17:902:8d92:b029:113:91e7:89d6 with SMTP id v18-20020a1709028d92b029011391e789d6mr30535549plo.85.1626924927021;
        Wed, 21 Jul 2021 20:35:27 -0700 (PDT)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4000:d7:30e2:954a:f4a0:3224])
        by smtp.gmail.com with ESMTPSA id n6sm32060258pgb.60.2021.07.21.20.35.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Jul 2021 20:35:26 -0700 (PDT)
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
        Adrian Hunter <adrian.hunter@intel.com>,
        Kiwoong Kim <kwmad.kim@samsung.com>,
        Keoseong Park <keosung.park@samsung.com>
Subject: [PATCH v3 08/18] scsi: ufs: Improve static type checking for the host controller state
Date:   Wed, 21 Jul 2021 20:34:29 -0700
Message-Id: <20210722033439.26550-9-bvanassche@acm.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210722033439.26550-1-bvanassche@acm.org>
References: <20210722033439.26550-1-bvanassche@acm.org>
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
index 233a1cf53dce..f467630be7df 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -127,15 +127,6 @@ enum {
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
@@ -2736,12 +2727,6 @@ static int ufshcd_queuecommand(struct Scsi_Host *host, struct scsi_cmnd *cmd)
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
index be9e6c683abe..8dcf0df770a2 100644
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
