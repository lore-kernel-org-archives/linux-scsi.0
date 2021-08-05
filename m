Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BF4F6C4338F
	for <linux-scsi@archiver.kernel.org>; Thu,  5 Aug 2021 19:19:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A840F60BD3
	for <linux-scsi@archiver.kernel.org>; Thu,  5 Aug 2021 19:19:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242921AbhHETTk (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 5 Aug 2021 15:19:40 -0400
Received: from mail-pj1-f54.google.com ([209.85.216.54]:41704 "EHLO
        mail-pj1-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242931AbhHETTc (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 5 Aug 2021 15:19:32 -0400
Received: by mail-pj1-f54.google.com with SMTP id u5-20020a17090ae005b029017842fe8f82so2728066pjy.0
        for <linux-scsi@vger.kernel.org>; Thu, 05 Aug 2021 12:19:17 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=tiqvXqd1pqntIXtxFdPnTU/mxlHzMDJV7Vq8vn+v5fw=;
        b=k3Kbxvg9/oe/pokKh6jEKxNKP9fZgl4aKqbMZGUV5ODFByqfMV0QLchPSa6sWP44FL
         y848wCYJWtAILwRSPp5u5isuMB+qBw5JyJTEWGiF7vle35dBgyAzXtkbhvL/Wr79jtFK
         2w4EMbD0dDvCXfP69iLEMg2eJ9ICBt7W5k6Y0wv8mdp+6T0JO7VXF54qVIOTsVbt6Jgv
         XJPqOOHsDsztADcSQhMcUo+IvgGnZ+mIQCrVGeB7IRGkGFcXtnYFs7N3ny1cIujO/ubQ
         4/Zz4bjn/8qeK098bJqH4jbbtY2/96yW060gCK5kb4yQtjzEYniaflZcvgrOp2WtBHok
         z/xA==
X-Gm-Message-State: AOAM533KTmI4gjGuioyAJtVZ+Fh8fUwtUFvJdZesx2pPOgI81radYfe9
        Ws0p6PM+TzfznSoD6g900ya88sFDdR6t8TR/
X-Google-Smtp-Source: ABdhPJwZzsVMMJkJvxd7D7J3VTVDoMb8iaTHfKdP2HqltHYByQRuzqfwsKfoI4cOV8zNowwHN7zjtw==
X-Received: by 2002:a63:e807:: with SMTP id s7mr510453pgh.200.1628191157079;
        Thu, 05 Aug 2021 12:19:17 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:1:93c2:eaf5:530d:627d])
        by smtp.gmail.com with ESMTPSA id t1sm8859429pgr.65.2021.08.05.12.19.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Aug 2021 12:19:16 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        John Garry <john.garry@huawei.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH v4 21/52] hisi_sas: Use scsi_cmd_to_rq() instead of scsi_cmnd.request
Date:   Thu,  5 Aug 2021 12:17:57 -0700
Message-Id: <20210805191828.3559897-22-bvanassche@acm.org>
X-Mailer: git-send-email 2.32.0.605.g8dce9f2422-goog
In-Reply-To: <20210805191828.3559897-1-bvanassche@acm.org>
References: <20210805191828.3559897-1-bvanassche@acm.org>
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
index 3a903e8e0384..9515c45affa5 100644
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
index a4885d03afe2..3ab669dc806f 100644
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
