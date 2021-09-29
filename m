Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6D1E7C433FE
	for <linux-scsi@archiver.kernel.org>; Wed, 29 Sep 2021 22:06:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 56BC1613CE
	for <linux-scsi@archiver.kernel.org>; Wed, 29 Sep 2021 22:06:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347073AbhI2WIY (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 29 Sep 2021 18:08:24 -0400
Received: from mail-pj1-f53.google.com ([209.85.216.53]:47097 "EHLO
        mail-pj1-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347075AbhI2WIS (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 29 Sep 2021 18:08:18 -0400
Received: by mail-pj1-f53.google.com with SMTP id me3-20020a17090b17c300b0019f44d2e401so1050930pjb.5
        for <linux-scsi@vger.kernel.org>; Wed, 29 Sep 2021 15:06:36 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=8MRMWPJSDpVLigpGgyfOKRrKOSbB0dYT6RnvRin88ZY=;
        b=f1HPa3VjMF8MA//WGjq9BBNQQki/n022hMY27kfXgy4UX563/vgBt4omT1ptkr19N6
         vDwmQFkiJgM+2WoezB5agS2LZGCG1Fy3ul0BvRGani42sEbFCd9Y45N8qmTjgs1+Z+Mt
         IQ2efIEBtwOICN26ZuDrx1pT7ewhFgznNmQMXL8WQaQSOf8wod0/PeiKtQZd0OWH3aWd
         znRuw1k9BiMP0qpy2vhILAiuF9EP+DArq8uGhU0BhXfLlc9gOiQNsRjsf3S1R+ERcDKu
         IeH2SE/7fbqcPhQdT2d5m2bx/2p53QK6dThDh6oApA+KH/xr0paDisyjjiIQ6x1XTzbX
         hUqA==
X-Gm-Message-State: AOAM5309YG4nlkKFl958yqWiG9e3deg3jBKshSGwuV9C9NGP/wIxAvo8
        g6qz/fqZv8ZQtA9L+3PueeY3meZ3h0A=
X-Google-Smtp-Source: ABdhPJyJFtVEu1vYJOMOBjxXcDgdVZIrngpyTLLnE6pXWUBpFtRE9itwZwbJ3O9G7f2OFdCYU3G1aQ==
X-Received: by 2002:a17:902:b286:b0:13e:1a30:ebc6 with SMTP id u6-20020a170902b28600b0013e1a30ebc6mr931960plr.72.1632953196315;
        Wed, 29 Sep 2021 15:06:36 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:5c11:c4f:db56:119])
        by smtp.gmail.com with ESMTPSA id gk14sm2785585pjb.35.2021.09.29.15.06.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Sep 2021 15:06:35 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH v2 14/84] a100u2w: Call scsi_done() directly
Date:   Wed, 29 Sep 2021 15:04:50 -0700
Message-Id: <20210929220600.3509089-15-bvanassche@acm.org>
X-Mailer: git-send-email 2.33.0.685.g46640cef36-goog
In-Reply-To: <20210929220600.3509089-1-bvanassche@acm.org>
References: <20210929220600.3509089-1-bvanassche@acm.org>
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
 
