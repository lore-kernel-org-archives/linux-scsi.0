Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EFE86C43470
	for <linux-scsi@archiver.kernel.org>; Tue, 18 May 2021 17:45:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D476661074
	for <linux-scsi@archiver.kernel.org>; Tue, 18 May 2021 17:45:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351264AbhERRqm (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 18 May 2021 13:46:42 -0400
Received: from mail-pl1-f174.google.com ([209.85.214.174]:42608 "EHLO
        mail-pl1-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351246AbhERRqi (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 18 May 2021 13:46:38 -0400
Received: by mail-pl1-f174.google.com with SMTP id v13so5510833ple.9
        for <linux-scsi@vger.kernel.org>; Tue, 18 May 2021 10:45:20 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=BXtTQ2I0chGLVFDPUBP1oOczi6q1HSGnELz/RdjTOaQ=;
        b=UbqEcEtEbQGValI0qB8ID1gtFlR5nq2ijNzewE+q79/dVFrxrfquPDjzjDP628VEpK
         FAsL0OzhL7FycfICrIhBFiSRSqve3cXSMYt+IEvzFepBOrtOqoRja5sQtQzTkvMSQnxk
         2hpE0noYYBUiCAWN2rxiTSHu+gfp2RLPTI8PSAE0mWFGykKwZT4pWw+raZpuyEKlJ9ut
         0t/NdVoxX70tYulbZUwt2Z4x1wC0SGNs4X5LQKszWOSRreh24h2XZPyyj/Cf7o+Y4nGy
         RlHW1QDi8AQEmSGbsptO/9eQoo6o82byWoRYhhkLsHbct1dJZoT0G8N61XWZwL0lpCO4
         pb5w==
X-Gm-Message-State: AOAM532kZMnnKnTXl4Xc3fZcRClKIN9aVrjaPy8YBZE90eGPzdO0ZHhN
        E7BYJcYwApDtvdF8fgSFSvk=
X-Google-Smtp-Source: ABdhPJxgBU182PYyMnddM8Y/TD+GiFCZtyRK10W8jNLhBlrbe2sdiWVWL/WJ2f+9YxK19V9fzFW1FQ==
X-Received: by 2002:a17:90a:a087:: with SMTP id r7mr6384541pjp.84.1621359920406;
        Tue, 18 May 2021 10:45:20 -0700 (PDT)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4000:d7:4ae4:fc49:eafe:4150])
        by smtp.gmail.com with ESMTPSA id z27sm12656920pfr.46.2021.05.18.10.45.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 May 2021 10:45:20 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        John Garry <john.garry@huawei.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH v2 20/50] hisi_sas: Use scsi_cmd_to_rq() instead of scsi_cmnd.request
Date:   Tue, 18 May 2021 10:44:20 -0700
Message-Id: <20210518174450.20664-21-bvanassche@acm.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210518174450.20664-1-bvanassche@acm.org>
References: <20210518174450.20664-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Prepare for removal of the request pointer by using scsi_cmd_to_rq()
instead. This patch does not change any functionality.

Acked-by: John Garry <john.garry@huawei.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/hisi_sas/hisi_sas_main.c  | 4 ++--
 drivers/scsi/hisi_sas/hisi_sas_v3_hw.c | 2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/hisi_sas/hisi_sas_main.c b/drivers/scsi/hisi_sas/hisi_sas_main.c
index 5a204074099c..b9337aa6cf8b 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_main.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_main.c
@@ -185,7 +185,7 @@ static int hisi_sas_slot_index_alloc(struct hisi_hba *hisi_hba,
 	void *bitmap = hisi_hba->slot_index_tags;
 
 	if (scsi_cmnd)
-		return scsi_cmnd->request->tag;
+		return scsi_cmd_to_rq(scsi_cmnd)->tag;
 
 	spin_lock(&hisi_hba->lock);
 	index = find_next_zero_bit(bitmap, hisi_hba->slot_index_count,
@@ -449,7 +449,7 @@ static int hisi_sas_task_prep(struct sas_task *task,
 		unsigned int dq_index;
 		u32 blk_tag;
 
-		blk_tag = blk_mq_unique_tag(scmd->request);
+		blk_tag = blk_mq_unique_tag(scsi_cmd_to_rq(scmd));
 		dq_index = blk_mq_unique_tag_to_hwq(blk_tag);
 		*dq_pointer = dq = &hisi_hba->dq[dq_index];
 	} else {
diff --git a/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c b/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
index 499c770d405c..6ef7e950226c 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
@@ -1153,7 +1153,7 @@ static void fill_prot_v3_hw(struct scsi_cmnd *scsi_cmnd,
 {
 	unsigned char prot_op = scsi_get_prot_op(scsi_cmnd);
 	unsigned int interval = scsi_prot_interval(scsi_cmnd);
-	u32 lbrt_chk_val = t10_pi_ref_tag(scsi_cmnd->request);
+	u32 lbrt_chk_val = t10_pi_ref_tag(scsi_cmd_to_rq(scsi_cmnd));
 
 	switch (prot_op) {
 	case SCSI_PROT_READ_INSERT:
