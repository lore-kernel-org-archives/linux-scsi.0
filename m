Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2A9FFC432BE
	for <linux-scsi@archiver.kernel.org>; Thu,  5 Aug 2021 19:19:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0C5AE6112F
	for <linux-scsi@archiver.kernel.org>; Thu,  5 Aug 2021 19:19:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242936AbhHETT5 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 5 Aug 2021 15:19:57 -0400
Received: from mail-pj1-f44.google.com ([209.85.216.44]:53789 "EHLO
        mail-pj1-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242925AbhHETT4 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 5 Aug 2021 15:19:56 -0400
Received: by mail-pj1-f44.google.com with SMTP id j1so11309272pjv.3
        for <linux-scsi@vger.kernel.org>; Thu, 05 Aug 2021 12:19:41 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=xd9HemrByuUGjpYnnrDmBhbtaxUf4pHqBSgHbpjCvco=;
        b=O8fuaOZAXR1Nv1ljNM2iHPlZCV84Mm6XlCNB+AQn9jDLe5cNtSLu67P9J+13h2ETwC
         Ryt56g7bUdXuYKEc8SglO1mdpN+YeGwvbNO/HxuTQfgJsXu//J6DWSMa86CrULBeKvMi
         A7tPBdWLkn+Ah/gRUhU2oCRXmak8AmPIu1ACMLqi6TCRTGDcVHZv9h35enXDdrIuaFCT
         iNN7f7cEXE60LHo2IhNYTS3DB4S18eEl7J89bcM5H7F2oCSiqCj6sefTPTsBU+2jtwZq
         SR7XO+PV6CWDt4dk0noLYSXaqDbr5avLhu7i1ExAC3cKx+7FsJj3Jzvtmx6JV3utTEa3
         4VFg==
X-Gm-Message-State: AOAM5325CPzeSbPJlulDreAsfImQmtIJQaNDEBiX/q9PJ2Gf1FPyaEZZ
        dWqJ/WgXhzJA2//0gfZHyzQ=
X-Google-Smtp-Source: ABdhPJzhoKAcKhL+JUswB0xnRC12C3d0vwgTbqR2pp3hCYeyysZIvUEP9ksp6dawxFwf9v867vM70Q==
X-Received: by 2002:a17:902:f542:b029:12c:a3eb:221 with SMTP id h2-20020a170902f542b029012ca3eb0221mr5628896plf.42.1628191180760;
        Thu, 05 Aug 2021 12:19:40 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:1:93c2:eaf5:530d:627d])
        by smtp.gmail.com with ESMTPSA id t1sm8859429pgr.65.2021.08.05.12.19.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Aug 2021 12:19:40 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Hannes Reinecke <hare@kernel.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH v4 32/52] myrb: Use scsi_cmd_to_rq() instead of scsi_cmnd.request
Date:   Thu,  5 Aug 2021 12:18:08 -0700
Message-Id: <20210805191828.3559897-33-bvanassche@acm.org>
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

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/myrb.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/myrb.c b/drivers/scsi/myrb.c
index 542ed88ef90d..a4a88323e020 100644
--- a/drivers/scsi/myrb.c
+++ b/drivers/scsi/myrb.c
@@ -1263,6 +1263,7 @@ static int myrb_host_reset(struct scsi_cmnd *scmd)
 static int myrb_pthru_queuecommand(struct Scsi_Host *shost,
 		struct scsi_cmnd *scmd)
 {
+	struct request *rq = scsi_cmd_to_rq(scmd);
 	struct myrb_hba *cb = shost_priv(shost);
 	struct myrb_cmdblk *cmd_blk = scsi_cmd_priv(scmd);
 	union myrb_cmd_mbox *mbox = &cmd_blk->mbox;
@@ -1286,7 +1287,7 @@ static int myrb_pthru_queuecommand(struct Scsi_Host *shost,
 	}
 
 	mbox->type3.opcode = MYRB_CMD_DCDB;
-	mbox->type3.id = scmd->request->tag + 3;
+	mbox->type3.id = rq->tag + 3;
 	mbox->type3.addr = dcdb_addr;
 	dcdb->channel = sdev->channel;
 	dcdb->target = sdev->id;
@@ -1305,11 +1306,11 @@ static int myrb_pthru_queuecommand(struct Scsi_Host *shost,
 		break;
 	}
 	dcdb->early_status = false;
-	if (scmd->request->timeout <= 10)
+	if (rq->timeout <= 10)
 		dcdb->timeout = MYRB_DCDB_TMO_10_SECS;
-	else if (scmd->request->timeout <= 60)
+	else if (rq->timeout <= 60)
 		dcdb->timeout = MYRB_DCDB_TMO_60_SECS;
-	else if (scmd->request->timeout <= 600)
+	else if (rq->timeout <= 600)
 		dcdb->timeout = MYRB_DCDB_TMO_10_MINS;
 	else
 		dcdb->timeout = MYRB_DCDB_TMO_24_HRS;
@@ -1550,7 +1551,7 @@ static int myrb_ldev_queuecommand(struct Scsi_Host *shost,
 	}
 
 	myrb_reset_cmd(cmd_blk);
-	mbox->type5.id = scmd->request->tag + 3;
+	mbox->type5.id = scsi_cmd_to_rq(scmd)->tag + 3;
 	if (scmd->sc_data_direction == DMA_NONE)
 		goto submit;
 	nsge = scsi_dma_map(scmd);
