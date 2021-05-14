Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 96E55C43603
	for <linux-scsi@archiver.kernel.org>; Fri, 14 May 2021 21:35:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7D07161440
	for <linux-scsi@archiver.kernel.org>; Fri, 14 May 2021 21:35:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233419AbhENVgt (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 14 May 2021 17:36:49 -0400
Received: from mail-pg1-f173.google.com ([209.85.215.173]:41490 "EHLO
        mail-pg1-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233411AbhENVgm (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 14 May 2021 17:36:42 -0400
Received: by mail-pg1-f173.google.com with SMTP id t30so247567pgl.8
        for <linux-scsi@vger.kernel.org>; Fri, 14 May 2021 14:35:29 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=vJiWrRK/gssXKJ/acngQthRIJI+9PzFLnYjOWh9yIdY=;
        b=QSmmZLBgJiOyT8nc4UxyQWI1ufWpT6zldSshT3NhDbgow7fRTr2eWU4AAlKAim2CSc
         jrkV20wxS47v3oClpczn2AoasAyLN0Z6eZwkdG0yl+BBGojK9OwPFsGxEJuA7aZkTRF+
         3TY7C0idVKONBY9PMfAfauYsInpd9b1Ig+UQZA/FkfxW/9esugF56qb/D05vQetl4Em0
         bQjF65yYmuLqoHiIrzzj7mn2bprbnWBBfe9f2HWVQcAmxotdqPLLlocIKJZC4eKtMNa4
         d6+7Pr9xn9SryXCeB/THR8pmHtHz56URQpVdZyJq7CF0hDyFPXEjbKRcJ473tnfZVLOD
         RITQ==
X-Gm-Message-State: AOAM532c2c1id57Ch+RETORwLR/Yth1jZiLNA4iQ42S+QpFObvxpUnwh
        tUn/mYZG7yZYMuAxj5X5xjI=
X-Google-Smtp-Source: ABdhPJxfggWRDhpaSXfGtZS9SHjd8vNoFB2Vt1lbpMv7PrOc2ce2d8U+p/oMENLiYq7K2pGZm9AHYg==
X-Received: by 2002:a63:b211:: with SMTP id x17mr41249114pge.106.1621028129543;
        Fri, 14 May 2021 14:35:29 -0700 (PDT)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4000:d7:e40c:c579:7cd8:c046])
        by smtp.gmail.com with ESMTPSA id js6sm9307262pjb.0.2021.05.14.14.35.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 May 2021 14:35:29 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Mike Christie <michael.christie@oracle.com>,
        Bodo Stroesser <bostroesser@gmail.com>,
        Himanshu Madhani <himanshu.madhani@oracle.com>
Subject: [PATCH 48/50] tcm_loop: Use blk_req() instead of scsi_cmnd.request
Date:   Fri, 14 May 2021 14:33:03 -0700
Message-Id: <20210514213356.5264-49-bvanassche@acm.org>
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
 drivers/target/loopback/tcm_loop.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/target/loopback/tcm_loop.c b/drivers/target/loopback/tcm_loop.c
index 2687fd7d45db..19c4f21d4d10 100644
--- a/drivers/target/loopback/tcm_loop.c
+++ b/drivers/target/loopback/tcm_loop.c
@@ -183,7 +183,7 @@ static int tcm_loop_queuecommand(struct Scsi_Host *sh, struct scsi_cmnd *sc)
 
 	memset(tl_cmd, 0, sizeof(*tl_cmd));
 	tl_cmd->sc = sc;
-	tl_cmd->sc_cmd_tag = sc->request->tag;
+	tl_cmd->sc_cmd_tag = blk_req(sc)->tag;
 
 	tcm_loop_target_queue_cmd(tl_cmd);
 	return 0;
@@ -249,7 +249,7 @@ static int tcm_loop_abort_task(struct scsi_cmnd *sc)
 	tl_hba = *(struct tcm_loop_hba **)shost_priv(sc->device->host);
 	tl_tpg = &tl_hba->tl_hba_tpgs[sc->device->id];
 	ret = tcm_loop_issue_tmr(tl_tpg, sc->device->lun,
-				 sc->request->tag, TMR_ABORT_TASK);
+				 blk_req(sc)->tag, TMR_ABORT_TASK);
 	return (ret == TMR_FUNCTION_COMPLETE) ? SUCCESS : FAILED;
 }
 
