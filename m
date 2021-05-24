Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B0D8DC47082
	for <linux-scsi@archiver.kernel.org>; Mon, 24 May 2021 03:09:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9216C6115C
	for <linux-scsi@archiver.kernel.org>; Mon, 24 May 2021 03:09:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232272AbhEXDLI (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 23 May 2021 23:11:08 -0400
Received: from mail-pj1-f41.google.com ([209.85.216.41]:33487 "EHLO
        mail-pj1-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232270AbhEXDLG (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 23 May 2021 23:11:06 -0400
Received: by mail-pj1-f41.google.com with SMTP id v13-20020a17090abb8db029015f9f7d7290so714526pjr.0
        for <linux-scsi@vger.kernel.org>; Sun, 23 May 2021 20:09:38 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=BXtTQ2I0chGLVFDPUBP1oOczi6q1HSGnELz/RdjTOaQ=;
        b=p9jd+CxtzuhQCkKd46j0g6gv/L1q/drvnUnZeD9bHHF2AaTw2DloXaTbt09L/D83qo
         AL7/C7he7UD0dO3cbobvCJWVJ8CEqrEu8qI1q+p4eZj1rC7rmOwhFq1kY60Kn1KdWCbm
         lMlavpLNpqOnAb1xGNmc2fRvGp2/6gAnD/IDRGyu95vUXhWDFkGJZoOWDgjnUviR9lxz
         4VLUnffwxh9PPA/tv4HUgcMnam8gyhxZGE7RHx8oS2gdfm2vheQqFC6vC6TymZ5CMzzr
         bzWK9MQLCABdXJRdyfaCnYaFqAkPrYM5yFNaaVye3hFk5d8fxLWBFDBs4Q6QAsO9oXpW
         MlnA==
X-Gm-Message-State: AOAM5334mZ7qVdyHW2yduONDz7cMHqTBLvI8KNE31eU84rBZJGj4qkH3
        TmXaZ0u1B+KxKbDyGW1Yzlzknpt4UVqSpA==
X-Google-Smtp-Source: ABdhPJxRzVBk6XD1YD4yaD59kk7W+P8konyC23hFlCWOrpsbiXSX1axsgwNWVudbuG/arvmPufwZOQ==
X-Received: by 2002:a17:90b:4b0f:: with SMTP id lx15mr21781825pjb.184.1621825778068;
        Sun, 23 May 2021 20:09:38 -0700 (PDT)
Received: from asus.hsd1.ca.comcast.net (c-73-241-217-19.hsd1.ca.comcast.net. [73.241.217.19])
        by smtp.gmail.com with ESMTPSA id v9sm11131863pjd.26.2021.05.23.20.09.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 23 May 2021 20:09:37 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org,
        Bart Van Assche <bvanassche@acm.org>,
        John Garry <john.garry@huawei.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH v3 21/51] hisi_sas: Use scsi_cmd_to_rq() instead of scsi_cmnd.request
Date:   Sun, 23 May 2021 20:08:26 -0700
Message-Id: <20210524030856.2824-22-bvanassche@acm.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210524030856.2824-1-bvanassche@acm.org>
References: <20210524030856.2824-1-bvanassche@acm.org>
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
