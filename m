Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EBA02C433F5
	for <linux-scsi@archiver.kernel.org>; Sat, 18 Sep 2021 00:07:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D23B8610C7
	for <linux-scsi@archiver.kernel.org>; Sat, 18 Sep 2021 00:07:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344506AbhIRAI6 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 17 Sep 2021 20:08:58 -0400
Received: from mail-pf1-f178.google.com ([209.85.210.178]:45925 "EHLO
        mail-pf1-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344514AbhIRAIn (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 17 Sep 2021 20:08:43 -0400
Received: by mail-pf1-f178.google.com with SMTP id w19so10577002pfn.12
        for <linux-scsi@vger.kernel.org>; Fri, 17 Sep 2021 17:07:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ZKOwJEfK2W3RLsiewHHTr3TAHecYRQgSmAIibHOLf7o=;
        b=xjCdddknGogo3GKLyWtn7jVzdmM+GvK58qYqUj9pWIKVNvmPgyEMS+O5ZSCPLTqpHO
         v94/RQIp8rYX6Jm/t5vPiqHjLdPDQCJHiUmgHNIptFCX4WWquHUV4e7efDQuwO9RCiaU
         8jvRN2zNzQP9fdRy0HRJqHtRqy01+wwT5nHNRlJACdgdEoHL6GKoux5UfR85SI9cxBHm
         maUV+61vyFmtmsb/Z29gSLWaX5ZspScdshJDnC8xGIq2qM+t849dx3oO00GeyKhCI9Ny
         RZXm5QrPuSiFyEfxOp8AoHhOllLgZmBB++dr9DzXGXcs2bkkVr05MCC+J+1QTHalgjOh
         P4Kg==
X-Gm-Message-State: AOAM530HP9BZoGKN7CkXFnaVXWhoUPtMiTcXMzUmzd6lV3xTzZ4OI3iN
        sCROXgFxGBBUQPVoZwSYxSU=
X-Google-Smtp-Source: ABdhPJy7lMbmiAvQQEqD1a3/3x78unmhps53xkCR1HtzNFfkKMVeZNa6FWjtY1eMuaV6j8MO+uw3qw==
X-Received: by 2002:a63:ed17:: with SMTP id d23mr12088561pgi.29.1631923641048;
        Fri, 17 Sep 2021 17:07:21 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:4c45:d635:d2d2:93])
        by smtp.gmail.com with ESMTPSA id bv16sm6403129pjb.12.2021.09.17.17.07.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Sep 2021 17:07:20 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH 40/84] initio: Call scsi_done() directly
Date:   Fri, 17 Sep 2021 17:05:23 -0700
Message-Id: <20210918000607.450448-41-bvanassche@acm.org>
X-Mailer: git-send-email 2.33.0.464.g1972c5931b-goog
In-Reply-To: <20210918000607.450448-1-bvanassche@acm.org>
References: <20210918000607.450448-1-bvanassche@acm.org>
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
 
