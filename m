Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ED6CBC433B4
	for <linux-scsi@archiver.kernel.org>; Tue, 18 May 2021 17:45:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D2123611CE
	for <linux-scsi@archiver.kernel.org>; Tue, 18 May 2021 17:45:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351270AbhERRqx (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 18 May 2021 13:46:53 -0400
Received: from mail-pg1-f179.google.com ([209.85.215.179]:38741 "EHLO
        mail-pg1-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351286AbhERRqr (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 18 May 2021 13:46:47 -0400
Received: by mail-pg1-f179.google.com with SMTP id 6so7536638pgk.5
        for <linux-scsi@vger.kernel.org>; Tue, 18 May 2021 10:45:29 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=OeyFIWqldZ7BeKhFQtSfr7yT/XinEp7stWPBuGn6n7M=;
        b=iMJr2RNyQLjR4Wyplo8ViRtc+xNNgFUBd1A1IlPCXMaCIbjCJxoArESDEKIZZ8G4Ht
         zvSbQ5FqDKgrLwcfKspCC3WTIO42Rl8CS/DgkRlcwb9UHbzKCOLh6n9+Kf8LrJUfHlKB
         Zj7OraX1VdRi4aajKwI0no3UpXoRifjcr30pRbb/zeFnTYhQA1QI/2bhwXXY3NwOB/yN
         TxCP4L/qPMGL5C67PBJ72O+bZMINBmTdedHRLS7gFR5tTaKgpOE/xQct54UIMSnkW88+
         s+CUWVtX41QYMhR8RXC7BBFTlneE/N0xSo7LeAo1rqoIfmhPFMkU6z8+1c6CcZ6sepos
         ZKXQ==
X-Gm-Message-State: AOAM531wFKka6lhvRFTTVfA160hQKiBMgr7H+RXeRlRAOWZiJbw6kLYp
        qPsy4y9fPmP9wGegPsvAAZI=
X-Google-Smtp-Source: ABdhPJxh4IZesCledQrsMADJkFJGYEjEPKPHCOq8xdFTecTAca8RVvtvLAyxne8s3eh0oEgTfz6pqA==
X-Received: by 2002:a63:4a4e:: with SMTP id j14mr6134913pgl.221.1621359929346;
        Tue, 18 May 2021 10:45:29 -0700 (PDT)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4000:d7:4ae4:fc49:eafe:4150])
        by smtp.gmail.com with ESMTPSA id z27sm12656920pfr.46.2021.05.18.10.45.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 May 2021 10:45:29 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        John Garry <john.garry@huawei.com>,
        Jason Yan <yanaijie@huawei.com>,
        Luo Jiaxing <luojiaxing@huawei.com>,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        Jolly Shah <jollys@google.com>,
        Liu Shixin <liushixin2@huawei.com>
Subject: [PATCH v2 25/50] libsas: Use scsi_cmd_to_rq() instead of scsi_cmnd.request
Date:   Tue, 18 May 2021 10:44:25 -0700
Message-Id: <20210518174450.20664-26-bvanassche@acm.org>
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

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/libsas/sas_ata.c       | 2 +-
 drivers/scsi/libsas/sas_scsi_host.c | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/libsas/sas_ata.c b/drivers/scsi/libsas/sas_ata.c
index e9a86128f1f1..d007a5714923 100644
--- a/drivers/scsi/libsas/sas_ata.c
+++ b/drivers/scsi/libsas/sas_ata.c
@@ -595,7 +595,7 @@ void sas_ata_task_abort(struct sas_task *task)
 
 	/* Bounce SCSI-initiated commands to the SCSI EH */
 	if (qc->scsicmd) {
-		blk_abort_request(qc->scsicmd->request);
+		blk_abort_request(scsi_cmd_to_rq(qc->scsicmd));
 		return;
 	}
 
diff --git a/drivers/scsi/libsas/sas_scsi_host.c b/drivers/scsi/libsas/sas_scsi_host.c
index 1bf939818c98..b6cd9d87fbd0 100644
--- a/drivers/scsi/libsas/sas_scsi_host.c
+++ b/drivers/scsi/libsas/sas_scsi_host.c
@@ -908,7 +908,7 @@ void sas_task_abort(struct sas_task *task)
 	if (dev_is_sata(task->dev))
 		sas_ata_task_abort(task);
 	else
-		blk_abort_request(sc->request);
+		blk_abort_request(scsi_cmd_to_rq(sc));
 }
 
 void sas_target_destroy(struct scsi_target *starget)
