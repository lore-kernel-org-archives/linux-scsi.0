Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2F39BC433ED
	for <linux-scsi@archiver.kernel.org>; Fri, 14 May 2021 21:34:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 083D761446
	for <linux-scsi@archiver.kernel.org>; Fri, 14 May 2021 21:34:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233092AbhENVfw (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 14 May 2021 17:35:52 -0400
Received: from mail-pf1-f169.google.com ([209.85.210.169]:33582 "EHLO
        mail-pf1-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233077AbhENVfv (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 14 May 2021 17:35:51 -0400
Received: by mail-pf1-f169.google.com with SMTP id h16so690315pfk.0
        for <linux-scsi@vger.kernel.org>; Fri, 14 May 2021 14:34:39 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=CNhwrprZYmWxuMGbVuPnCv7S9U3K7+lKJs/YESFzhnc=;
        b=eVq5ClMhScKpBTk3zr+V7jl783KDT+YKt6ysZ5itanR57eVWUgis7izZEViCgxUe7o
         KbuhRQDMcPmLLBB9Ocw7P6kT2swFitAt3gk3c+2Y2QEXo6wMj0gnpXizAyUhL3RHl7yt
         Kfl821eLvBQtagZPUija6NvdLOZGP8j94Ef2pM09LFE50XCyQzd+dph8QgTeUl1Mrec/
         GoZ8SxytfuheOIdrmgMUqD6YlCbP3PASJlYqyQNHYiKSo3IaxfwxmVupqYpIqGU45a5t
         20BQRj920hOyamTPAf6h8XoaXUVa6qjbxGI0qeAz5Y1MD/t9vRRz6WDc5g+/KYwCyrDz
         2NMQ==
X-Gm-Message-State: AOAM533qokKO6AgHxVv72gRk5pR6jB3yiCXDpa5swCbuW6xSDf56Miui
        j2XUuWZBb6jbMt/68I5AR9A=
X-Google-Smtp-Source: ABdhPJzbJ+VZVQETXhgyL5TH71vq0tMxkv3S2chOjoUct5gimllPBUs+GWfQHLsKuMATV3t/ikZMLA==
X-Received: by 2002:a63:1e64:: with SMTP id p36mr1189382pgm.105.1621028079249;
        Fri, 14 May 2021 14:34:39 -0700 (PDT)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4000:d7:e40c:c579:7cd8:c046])
        by smtp.gmail.com with ESMTPSA id js6sm9307262pjb.0.2021.05.14.14.34.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 May 2021 14:34:38 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        John Garry <john.garry@huawei.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH 20/50] hisi_sas: Use blk_req() instead of scsi_cmnd.request
Date:   Fri, 14 May 2021 14:32:35 -0700
Message-Id: <20210514213356.5264-21-bvanassche@acm.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210514213356.5264-1-bvanassche@acm.org>
References: <20210514213356.5264-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Prepare for removal of the request pointer by using blk_req() instead. This
patch does not change any functionality.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/hisi_sas/hisi_sas_main.c  | 4 ++--
 drivers/scsi/hisi_sas/hisi_sas_v3_hw.c | 2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/hisi_sas/hisi_sas_main.c b/drivers/scsi/hisi_sas/hisi_sas_main.c
index 5a204074099c..9a93a3374d65 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_main.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_main.c
@@ -185,7 +185,7 @@ static int hisi_sas_slot_index_alloc(struct hisi_hba *hisi_hba,
 	void *bitmap = hisi_hba->slot_index_tags;
 
 	if (scsi_cmnd)
-		return scsi_cmnd->request->tag;
+		return blk_req(scsi_cmnd)->tag;
 
 	spin_lock(&hisi_hba->lock);
 	index = find_next_zero_bit(bitmap, hisi_hba->slot_index_count,
@@ -449,7 +449,7 @@ static int hisi_sas_task_prep(struct sas_task *task,
 		unsigned int dq_index;
 		u32 blk_tag;
 
-		blk_tag = blk_mq_unique_tag(scmd->request);
+		blk_tag = blk_mq_unique_tag(blk_req(scmd));
 		dq_index = blk_mq_unique_tag_to_hwq(blk_tag);
 		*dq_pointer = dq = &hisi_hba->dq[dq_index];
 	} else {
diff --git a/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c b/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
index 499c770d405c..ed02eecd606d 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
@@ -1153,7 +1153,7 @@ static void fill_prot_v3_hw(struct scsi_cmnd *scsi_cmnd,
 {
 	unsigned char prot_op = scsi_get_prot_op(scsi_cmnd);
 	unsigned int interval = scsi_prot_interval(scsi_cmnd);
-	u32 lbrt_chk_val = t10_pi_ref_tag(scsi_cmnd->request);
+	u32 lbrt_chk_val = t10_pi_ref_tag(blk_req(scsi_cmnd));
 
 	switch (prot_op) {
 	case SCSI_PROT_READ_INSERT:
