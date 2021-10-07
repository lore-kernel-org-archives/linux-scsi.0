Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AA780C433F5
	for <linux-scsi@archiver.kernel.org>; Thu,  7 Oct 2021 20:29:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 941FA60E9B
	for <linux-scsi@archiver.kernel.org>; Thu,  7 Oct 2021 20:29:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241951AbhJGUbv (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 7 Oct 2021 16:31:51 -0400
Received: from mail-pj1-f52.google.com ([209.85.216.52]:45880 "EHLO
        mail-pj1-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241713AbhJGUbs (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 7 Oct 2021 16:31:48 -0400
Received: by mail-pj1-f52.google.com with SMTP id ls14-20020a17090b350e00b001a00e2251c8so6078941pjb.4
        for <linux-scsi@vger.kernel.org>; Thu, 07 Oct 2021 13:29:54 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=8MRMWPJSDpVLigpGgyfOKRrKOSbB0dYT6RnvRin88ZY=;
        b=6lpLDgbffK5xblVHoM1Ll+Kkuz1YBBcnI5LW2A1pbDnKSHmNL22SkdcKcXx1anYoSt
         gXpUKt4N8DFd6ZwcMUeg+UKMqsxMC/4LryTeWXFD/gWXwIQlx7xJirlvTICqxVZdg7l6
         dOPRrNqe/b3JsEwQ7NJn/NE1bdFbcVF+1UqwEAns5F7en30qktzzZLTxoj62ah18TU3F
         jqYYT1lTeOvCpe8c2ITUPCu8I8V7bpiEH1luXMN0Pm+is7Mv2Rr/DUo3DTMVy2liAvWT
         dL4XERDmbz21+3ffcuokpdtgGApDqz5+cNQxmJ0ZqrsOMnOZKB6Jgq8+uYN13ZiqWwFx
         YdYQ==
X-Gm-Message-State: AOAM533POfIVCVsKwq9KQsfcYBBE9xxBp1VZQZ7GmeT4B2X1XV3smEHy
        RbvNdHxnW3PmWjIvTSf4sTM=
X-Google-Smtp-Source: ABdhPJzXuQeUCMWnib8I+wmC1B5one2Sm335wuQVT9FoiTmPog7U91uPiDWsnSzTnGQ09teeg1hq7Q==
X-Received: by 2002:a17:90a:d905:: with SMTP id c5mr7778280pjv.65.1633638594401;
        Thu, 07 Oct 2021 13:29:54 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:ae88:8f16:b90b:5f1d])
        by smtp.gmail.com with ESMTPSA id x35sm303499pfh.52.2021.10.07.13.29.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Oct 2021 13:29:53 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH v3 14/88] a100u2w: Call scsi_done() directly
Date:   Thu,  7 Oct 2021 13:28:09 -0700
Message-Id: <20211007202923.2174984-15-bvanassche@acm.org>
X-Mailer: git-send-email 2.33.0.882.g93a45727a2-goog
In-Reply-To: <20211007202923.2174984-1-bvanassche@acm.org>
References: <20211007202923.2174984-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Conditional statements are faster than indirect calls. Hence call
scsi_done() directly.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/a100u2w.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/scsi/a100u2w.c b/drivers/scsi/a100u2w.c
index 028af6b1057c..68343bcb4616 100644
--- a/drivers/scsi/a100u2w.c
+++ b/drivers/scsi/a100u2w.c
@@ -917,7 +917,6 @@ static int inia100_queue_lck(struct scsi_cmnd * cmd, void (*done) (struct scsi_c
 	struct orc_host *host;		/* Point to Host adapter control block */
 
 	host = (struct orc_host *) cmd->device->host->hostdata;
-	cmd->scsi_done = done;
 	/* Get free SCSI control block  */
 	if ((scb = orc_alloc_scb(host)) == NULL)
 		return SCSI_MLQUEUE_HOST_BUSY;
@@ -1042,7 +1041,7 @@ static void inia100_scb_handler(struct orc_host *host, struct orc_scb *scb)
 	}
 	cmd->result = scb->tastat | (scb->hastat << 16);
 	scsi_dma_unmap(cmd);
-	cmd->scsi_done(cmd);	/* Notify system DONE           */
+	scsi_done(cmd);		/* Notify system DONE           */
 	orc_release_scb(host, scb);	/* Release SCB for current channel */
 }
 
