Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DAABDC432BE
	for <linux-scsi@archiver.kernel.org>; Mon,  9 Aug 2021 23:04:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B95B960FE3
	for <linux-scsi@archiver.kernel.org>; Mon,  9 Aug 2021 23:04:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236999AbhHIXFE (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 9 Aug 2021 19:05:04 -0400
Received: from mail-pj1-f52.google.com ([209.85.216.52]:38616 "EHLO
        mail-pj1-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237026AbhHIXE4 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 9 Aug 2021 19:04:56 -0400
Received: by mail-pj1-f52.google.com with SMTP id lw7-20020a17090b1807b029017881cc80b7so1426425pjb.3
        for <linux-scsi@vger.kernel.org>; Mon, 09 Aug 2021 16:04:35 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=tiqvXqd1pqntIXtxFdPnTU/mxlHzMDJV7Vq8vn+v5fw=;
        b=HZQb3B3Gwgdkj5lXImiM+BS+w0szzKrsP+D1yfbfwgaHwu5ySKO0i6qK5TbNAUs0Mj
         iuStux/0FUuIJtDHXEcogmXxIh3gt8pTnvHIz3e+hrdtRckWpXyBXyFAXdcdZQVqKFEV
         Y5qF3cvtdiTFNSSmsJVCne/FSdpgKEdfJ3lXKTKtkLLpcHy5XG302Cu49Eo6Fs+r8Pax
         xssUtz1rnce0/0zCWy+cIzVkEnv3YySKehmT1BuUNLR4TZwbYR+p3RDwzKOO1QQZBfXx
         L+fuHNh/gTExjCpjO1PG/v6GsRmXp1ThKsMZyslssG2qQX3XrT8RTqmc70ljByqwTWZ8
         maDA==
X-Gm-Message-State: AOAM533RJiDmweAkqq2xy+TyPMMysJ+XF6exSNOIkCitYKGyJW+WaSl7
        3ZMHD3sTxWaJRvn4/PrD+wQ=
X-Google-Smtp-Source: ABdhPJx4nr+ykBq3gEqdvxlBE7Ax9p8XQmuHNUjiY39mWQMQsGXXLF8dkDhGNZAwm0Ql+g2ntmukDA==
X-Received: by 2002:a17:90a:6684:: with SMTP id m4mr1518496pjj.127.1628550275567;
        Mon, 09 Aug 2021 16:04:35 -0700 (PDT)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4000:d7:7dd4:e46e:368b:7454])
        by smtp.gmail.com with ESMTPSA id j6sm24102260pgq.0.2021.08.09.16.04.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Aug 2021 16:04:35 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        John Garry <john.garry@huawei.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH v5 21/52] hisi_sas: Use scsi_cmd_to_rq() instead of scsi_cmnd.request
Date:   Mon,  9 Aug 2021 16:03:24 -0700
Message-Id: <20210809230355.8186-22-bvanassche@acm.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210809230355.8186-1-bvanassche@acm.org>
References: <20210809230355.8186-1-bvanassche@acm.org>
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
