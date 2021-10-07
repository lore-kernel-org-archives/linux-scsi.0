Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 44424C433EF
	for <linux-scsi@archiver.kernel.org>; Thu,  7 Oct 2021 20:30:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 27FEF61074
	for <linux-scsi@archiver.kernel.org>; Thu,  7 Oct 2021 20:30:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242395AbhJGUcj (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 7 Oct 2021 16:32:39 -0400
Received: from mail-pj1-f47.google.com ([209.85.216.47]:44707 "EHLO
        mail-pj1-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242338AbhJGUch (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 7 Oct 2021 16:32:37 -0400
Received: by mail-pj1-f47.google.com with SMTP id oa12-20020a17090b1bcc00b0019f715462a8so6085442pjb.3
        for <linux-scsi@vger.kernel.org>; Thu, 07 Oct 2021 13:30:43 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=MQERA3T4j1mewJlnCoSDIbhMa8LyGqwprFKISLrkUiY=;
        b=6OQSUZe3nA4hfdk5fuH/KxauJ8xH9TOSNYQnEymrbN4lBlIlsoLeoFrBqHpI/E106t
         BjhB5hdhMUnCDKzwPBsYXNtJRDabY82JF7l0HetmbsGwUm1yhIRhS3FzUzg9zxk8Xq+s
         F9JmPWvCJAorTUgYGhFud6Y6mJT9+5zQF2AxI1aC7nGgSHoqqnErBSvREoMT4EfKq1A+
         PXO5uyzoulLxE29XxiJAQWEG6wBYJ0cI5A2W3IYd6IbDcP6XWsLaO/zjeeJTT0CW9IRq
         Q83N22GFTz+8lWvrsHESh+rmmhkYXYjgA8Y0PYI9oqNwvTyMmQhFM49p9FCRdost46Ov
         BD/A==
X-Gm-Message-State: AOAM533HfH74wUiXcMKKAmdVHoCZ8PaL9OM21U1yOI/7dFVqeKtThOzH
        2ANHNUaoudCv3weO7fPb2qI=
X-Google-Smtp-Source: ABdhPJwJkpRGP/8jedHUjb8gQdsHcVJV6VK/9tmzINklRZBdzPC4HSccNHLzJFt6BBhXgm3KFmuG2g==
X-Received: by 2002:a17:903:1252:b0:13d:f3f6:2e1c with SMTP id u18-20020a170903125200b0013df3f62e1cmr5828436plh.73.1633638643097;
        Thu, 07 Oct 2021 13:30:43 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:ae88:8f16:b90b:5f1d])
        by smtp.gmail.com with ESMTPSA id x35sm303499pfh.52.2021.10.07.13.30.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Oct 2021 13:30:42 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Brian King <brking@us.ibm.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH v3 41/88] ipr: Call scsi_done() directly
Date:   Thu,  7 Oct 2021 13:28:36 -0700
Message-Id: <20211007202923.2174984-42-bvanassche@acm.org>
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
 drivers/scsi/ipr.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/ipr.c b/drivers/scsi/ipr.c
index 5d78f7e939a3..aa44216dcf9a 100644
--- a/drivers/scsi/ipr.c
+++ b/drivers/scsi/ipr.c
@@ -866,7 +866,7 @@ static void __ipr_scsi_eh_done(struct ipr_cmnd *ipr_cmd)
 	scsi_cmd->result |= (DID_ERROR << 16);
 
 	scsi_dma_unmap(ipr_cmd->scsi_cmd);
-	scsi_cmd->scsi_done(scsi_cmd);
+	scsi_done(scsi_cmd);
 	if (ipr_cmd->eh_comp)
 		complete(ipr_cmd->eh_comp);
 	list_add_tail(&ipr_cmd->queue, &ipr_cmd->hrrq->hrrq_free_q);
@@ -6065,7 +6065,7 @@ static void __ipr_erp_done(struct ipr_cmnd *ipr_cmd)
 		res->in_erp = 0;
 	}
 	scsi_dma_unmap(ipr_cmd->scsi_cmd);
-	scsi_cmd->scsi_done(scsi_cmd);
+	scsi_done(scsi_cmd);
 	if (ipr_cmd->eh_comp)
 		complete(ipr_cmd->eh_comp);
 	list_add_tail(&ipr_cmd->queue, &ipr_cmd->hrrq->hrrq_free_q);
@@ -6502,7 +6502,7 @@ static void ipr_erp_start(struct ipr_ioa_cfg *ioa_cfg,
 	}
 
 	scsi_dma_unmap(ipr_cmd->scsi_cmd);
-	scsi_cmd->scsi_done(scsi_cmd);
+	scsi_done(scsi_cmd);
 	if (ipr_cmd->eh_comp)
 		complete(ipr_cmd->eh_comp);
 	list_add_tail(&ipr_cmd->queue, &ipr_cmd->hrrq->hrrq_free_q);
@@ -6531,7 +6531,7 @@ static void ipr_scsi_done(struct ipr_cmnd *ipr_cmd)
 		scsi_dma_unmap(scsi_cmd);
 
 		spin_lock_irqsave(ipr_cmd->hrrq->lock, lock_flags);
-		scsi_cmd->scsi_done(scsi_cmd);
+		scsi_done(scsi_cmd);
 		if (ipr_cmd->eh_comp)
 			complete(ipr_cmd->eh_comp);
 		list_add_tail(&ipr_cmd->queue, &ipr_cmd->hrrq->hrrq_free_q);
@@ -6685,7 +6685,7 @@ static int ipr_queuecommand(struct Scsi_Host *shost,
 	spin_lock_irqsave(hrrq->lock, hrrq_flags);
 	memset(scsi_cmd->sense_buffer, 0, SCSI_SENSE_BUFFERSIZE);
 	scsi_cmd->result = (DID_NO_CONNECT << 16);
-	scsi_cmd->scsi_done(scsi_cmd);
+	scsi_done(scsi_cmd);
 	spin_unlock_irqrestore(hrrq->lock, hrrq_flags);
 	return 0;
 }
