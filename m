Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4C36FC432BE
	for <linux-scsi@archiver.kernel.org>; Mon,  9 Aug 2021 23:04:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2E3DC60F38
	for <linux-scsi@archiver.kernel.org>; Mon,  9 Aug 2021 23:04:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237030AbhHIXFR (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 9 Aug 2021 19:05:17 -0400
Received: from mail-pj1-f46.google.com ([209.85.216.46]:37599 "EHLO
        mail-pj1-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237023AbhHIXFO (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 9 Aug 2021 19:05:14 -0400
Received: by mail-pj1-f46.google.com with SMTP id cp15-20020a17090afb8fb029017891959dcbso1458681pjb.2
        for <linux-scsi@vger.kernel.org>; Mon, 09 Aug 2021 16:04:54 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=xd9HemrByuUGjpYnnrDmBhbtaxUf4pHqBSgHbpjCvco=;
        b=k3nyFf6Nppkx4snv6HyKZweqG9inL7iHkO03mAEcPXA7JRJFv8/4dCAw+5E5cIJmc6
         nIv54VlWYH22CpmGkTLYhiAVgUODOR7lmRDN3B59nhOjoJkqh6jzNpvxvhxUY1/mGFx/
         YawwmmymhnNKjj9QH8L+DaFN8Gi01EXjnyoRZ7ldnSAFVyG+0Q4zzzcy09PORSaD5m8A
         73AaXf4Nx9zdVmm4QC8Uy/WStzbe6ASRX1qvl9vjH/76sj00BgWtK02WEIQmDwaUUAtG
         3nmntc6bVxgj1lQWQZzmgEiXCQ/nQS4xI3W+e4Bc0/LwHgCeUOABN/Oktiv3vBaQf/iC
         qSAw==
X-Gm-Message-State: AOAM5321TXImq7fe1QeVKQAlhFRWjjzxu07ySbUyiApQlxCuavDgKnVe
        d4ZWCrHlfC/yC9xoEiFlnVg=
X-Google-Smtp-Source: ABdhPJxZyGh4jJvjtaAD3/OG9seWpJJ0nS+AIANYFBsN591F+H3Jl+SxG9xpRd0tueeSPcrPJj94PQ==
X-Received: by 2002:a17:902:ed84:b029:129:73d9:b83d with SMTP id e4-20020a170902ed84b029012973d9b83dmr4958771plj.43.1628550293723;
        Mon, 09 Aug 2021 16:04:53 -0700 (PDT)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4000:d7:7dd4:e46e:368b:7454])
        by smtp.gmail.com with ESMTPSA id j6sm24102260pgq.0.2021.08.09.16.04.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Aug 2021 16:04:53 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Hannes Reinecke <hare@kernel.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH v5 32/52] myrb: Use scsi_cmd_to_rq() instead of scsi_cmnd.request
Date:   Mon,  9 Aug 2021 16:03:35 -0700
Message-Id: <20210809230355.8186-33-bvanassche@acm.org>
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
