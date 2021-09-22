Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5DB74C433F5
	for <linux-scsi@archiver.kernel.org>; Wed, 22 Sep 2021 16:26:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4658A60F9D
	for <linux-scsi@archiver.kernel.org>; Wed, 22 Sep 2021 16:26:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236623AbhIVQ16 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 22 Sep 2021 12:27:58 -0400
Received: from mail-pj1-f45.google.com ([209.85.216.45]:55094 "EHLO
        mail-pj1-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236621AbhIVQ16 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 22 Sep 2021 12:27:58 -0400
Received: by mail-pj1-f45.google.com with SMTP id me1so2437875pjb.4
        for <linux-scsi@vger.kernel.org>; Wed, 22 Sep 2021 09:26:28 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=d438B8uz2X7dv4EM4CLjoK5lXE0AO4mHS3+eYnxlwZM=;
        b=TXjPAHvMJw6HP5wtYvv0w2HqpCpc+EXTR2UsUsEVl2sMb5FA1IHcY+0mRK22en1mH6
         tyh+5nNZAUhQcFjlDlAjWqRdU2tneLvmMz6sIqP/wBkUBd98sfO/GQhhZDvooIa7fvTi
         asHw1Fg3qEwl+ZsqMm9r1yZNX1cbtyXZGM+7anvMzFt/npH2b8+I26XWwtMmKvdTm3nd
         h0FUMXAO3OHsa/dIyL3JG5qFjRwOfsNizvzATxmBmaM3LsQO8IjfD99+pyKGvOYGepeX
         3TC8KdHulm9OXLJ0oOZsA73y6imvf0QlTrx3DungBQWF7jvGQX9JK55N4EbBQfgEdHC7
         Y2Bw==
X-Gm-Message-State: AOAM531l2AYVCO5NOFcxlRAw+A/j7r2tRMQBnO4OTstALmlvEQmhT9gC
        cGaFJB1XCgjys40LJNY1LBY=
X-Google-Smtp-Source: ABdhPJy3cm5ADLJqYsczctG/PArE+YleKdJymGbSAYHVx06e8XBFvxcWXHrCog0lSD9pggFxCd2VMA==
X-Received: by 2002:a17:90a:bd08:: with SMTP id y8mr273469pjr.123.1632327987852;
        Wed, 22 Sep 2021 09:26:27 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:f3b9:da7d:f0c0:c71c])
        by smtp.gmail.com with ESMTPSA id p26sm2311697pfw.137.2021.09.22.09.26.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Sep 2021 09:26:27 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Juergen Gross <jgross@suse.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH 84/84] scsi_lib: Call scsi_done() directly
Date:   Wed, 22 Sep 2021 09:26:02 -0700
Message-Id: <20210922162603.476745-6-bvanassche@acm.org>
X-Mailer: git-send-email 2.33.0.464.g1972c5931b-goog
In-Reply-To: <20210922162603.476745-1-bvanassche@acm.org>
References: <20210918000607.450448-1-bvanassche@acm.org>
 <20210922162603.476745-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Conditional statements are faster than indirect calls. Hence call
scsi_done() directly. Since this patch removes the last user of the
scsi_done member, also remove that data structure member.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/scsi_lib.c  | 3 +--
 include/scsi/scsi_cmnd.h | 4 ----
 2 files changed, 1 insertion(+), 6 deletions(-)

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index c3a0283dbff0..be1a21cec54b 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -1520,7 +1520,7 @@ static int scsi_dispatch_cmd(struct scsi_cmnd *cmd)
 
 	return rtn;
  done:
-	cmd->scsi_done(cmd);
+	scsi_done(cmd);
 	return 0;
 }
 
@@ -1693,7 +1693,6 @@ static blk_status_t scsi_queue_rq(struct blk_mq_hw_ctx *hctx,
 
 	scsi_set_resid(cmd, 0);
 	memset(cmd->sense_buffer, 0, SCSI_SENSE_BUFFERSIZE);
-	cmd->scsi_done = scsi_done;
 
 	blk_mq_start_request(req);
 	reason = scsi_dispatch_cmd(cmd);
diff --git a/include/scsi/scsi_cmnd.h b/include/scsi/scsi_cmnd.h
index 5b230d06527f..045f8c08ab70 100644
--- a/include/scsi/scsi_cmnd.h
+++ b/include/scsi/scsi_cmnd.h
@@ -124,10 +124,6 @@ struct scsi_cmnd {
 				 * command (auto-sense). Length must be
 				 * SCSI_SENSE_BUFFERSIZE bytes. */
 
-	/* Low-level done function - can be used by low-level driver to point
-	 *        to completion function.  Not used by mid/upper level code. */
-	void (*scsi_done) (struct scsi_cmnd *);
-
 	/*
 	 * The following fields can be written to by the host specific code. 
 	 * Everything else should be left alone. 
