Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B4A0CC433FE
	for <linux-scsi@archiver.kernel.org>; Thu,  7 Oct 2021 20:30:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9EC2560E9B
	for <linux-scsi@archiver.kernel.org>; Thu,  7 Oct 2021 20:30:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242370AbhJGUcj (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 7 Oct 2021 16:32:39 -0400
Received: from mail-pf1-f176.google.com ([209.85.210.176]:44545 "EHLO
        mail-pf1-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242390AbhJGUcg (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 7 Oct 2021 16:32:36 -0400
Received: by mail-pf1-f176.google.com with SMTP id 145so6282080pfz.11
        for <linux-scsi@vger.kernel.org>; Thu, 07 Oct 2021 13:30:42 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ZKOwJEfK2W3RLsiewHHTr3TAHecYRQgSmAIibHOLf7o=;
        b=YcVdB69leAg3E24nz5FbMXpmxBe72kQRurOxo74sH5O4AygQ4TK0V6N1NXPXDKu4oG
         XUecefjRbgi4kDxopei2kwuWlyWFGqMcq8OAFClHGg+K6MpGHCNuo9J1rkOPsmNLBgBB
         KPA5EFLZUWiBXK6sb4yjywq/IYYR24Od8Bqy2JhWc9ZU+q6hfpBHx7KK4HH35tGigDA+
         /X9H4IepmOps+lPtAMbM75eHZDdnEOg1m22AvTasQwF901/+0wHZnYj79nH3iSdVpcJS
         OUUPm4RcXJT593w6LCGujadA09ByQHZKSCDtDi5QPnGqjCD6HfNbBuNv2k+wY7ax5oOJ
         vFIQ==
X-Gm-Message-State: AOAM5331riDqePltvFEE/dd/e7RYP9EDTyHzMGfduE4qccVY97uuEA08
        yRl1JJe4ll5MWNw0uqjxhZg=
X-Google-Smtp-Source: ABdhPJzw5222d2sxBCpy+0JH63dCC7jr9vCdAzxvxI6YoDSpJUFT4zfgGztv8LxX4Haf6lgZ7IGsPA==
X-Received: by 2002:a63:c045:: with SMTP id z5mr1352874pgi.374.1633638641702;
        Thu, 07 Oct 2021 13:30:41 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:ae88:8f16:b90b:5f1d])
        by smtp.gmail.com with ESMTPSA id x35sm303499pfh.52.2021.10.07.13.30.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Oct 2021 13:30:41 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH v3 40/88] initio: Call scsi_done() directly
Date:   Thu,  7 Oct 2021 13:28:35 -0700
Message-Id: <20211007202923.2174984-41-bvanassche@acm.org>
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
 drivers/scsi/initio.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/scsi/initio.c b/drivers/scsi/initio.c
index 9b75e19a9bab..183f95758636 100644
--- a/drivers/scsi/initio.c
+++ b/drivers/scsi/initio.c
@@ -2615,8 +2615,6 @@ static int i91u_queuecommand_lck(struct scsi_cmnd *cmd,
 	struct initio_host *host = (struct initio_host *) cmd->device->host->hostdata;
 	struct scsi_ctrl_blk *cmnd;
 
-	cmd->scsi_done = done;
-
 	cmnd = initio_alloc_scb(host);
 	if (!cmnd)
 		return SCSI_MLQUEUE_HOST_BUSY;
@@ -2788,7 +2786,7 @@ static void i91uSCBPost(u8 * host_mem, u8 * cblk_mem)
 
 	cmnd->result = cblk->tastat | (cblk->hastat << 16);
 	i91u_unmap_scb(host->pci_dev, cmnd);
-	cmnd->scsi_done(cmnd);	/* Notify system DONE           */
+	scsi_done(cmnd);	/* Notify system DONE           */
 	initio_release_scb(host, cblk);	/* Release SCB for current channel */
 }
 
