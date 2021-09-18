Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CBF92C433EF
	for <linux-scsi@archiver.kernel.org>; Sat, 18 Sep 2021 00:09:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B30D061164
	for <linux-scsi@archiver.kernel.org>; Sat, 18 Sep 2021 00:09:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234007AbhIRAK2 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 17 Sep 2021 20:10:28 -0400
Received: from mail-pj1-f43.google.com ([209.85.216.43]:52913 "EHLO
        mail-pj1-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345084AbhIRAJa (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 17 Sep 2021 20:09:30 -0400
Received: by mail-pj1-f43.google.com with SMTP id v19so8010110pjh.2
        for <linux-scsi@vger.kernel.org>; Fri, 17 Sep 2021 17:08:08 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=QBW95v2yqxN3MisS4ps/ahCvNr8j5XfZY9gx5f9JmA0=;
        b=at1hoW67SKq+qVaZ+pCWrCYE6XT1BluSZAQPxjP0fylD40I7d0bfU0+cGc7UZ0j+Ou
         Qb0ips6bX0MHvKm7dAM/z90YF+tGjqzyhuLqLEs4N8vOP1TY+8x5T+p1qmb0GhZdUr/b
         WZW9lRMLSruJ0azqcOthvnnkJCLNh280SdlKMMW76tZzNAm5QR+D2jqz+yHirRltQnTX
         LB9Yd1C+ikYXzN1H15+iVe8Emo9+2U88d1kspaBV6/BQlhojz2qMNDkmoLKNZLr28zle
         dOj+6u0hZsDiHt1tPGBZ7n2LVEujJZVe+C2t6zdodd+sf57h+Hy0uDVdK5V/P6QYE8LT
         BPWA==
X-Gm-Message-State: AOAM532/CHlf5FRs7LfyC0I1RtKfyX4QaKyv+g1CHyXITCM+gZ7A1IK6
        IdRsA4UHIskVSqqb8ii54ME=
X-Google-Smtp-Source: ABdhPJw9e0k/Tfwe/URZyLdvild2WMfQKyqfGIsIQKxqa9/gF7XELx25HD/uGl0pVk7UJ6LiC/AhdA==
X-Received: by 2002:a17:90b:46cd:: with SMTP id jx13mr15296056pjb.122.1631923687795;
        Fri, 17 Sep 2021 17:08:07 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:4c45:d635:d2d2:93])
        by smtp.gmail.com with ESMTPSA id bv16sm6403129pjb.12.2021.09.17.17.08.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Sep 2021 17:08:07 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH 68/84] scsi_debug: Call scsi_done() directly
Date:   Fri, 17 Sep 2021 17:05:51 -0700
Message-Id: <20210918000607.450448-69-bvanassche@acm.org>
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
 drivers/scsi/scsi_debug.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
index 66f507469a31..407f1ce15118 100644
--- a/drivers/scsi/scsi_debug.c
+++ b/drivers/scsi/scsi_debug.c
@@ -4809,7 +4809,7 @@ static void sdebug_q_cmd_complete(struct sdebug_defer *sd_dp)
 			pr_info("bypassing scsi_done() due to aborted cmd\n");
 		return;
 	}
-	scp->scsi_done(scp); /* callback to mid level */
+	scsi_done(scp); /* callback to mid level */
 }
 
 /* When high resolution timer goes off this function is called. */
@@ -5524,7 +5524,7 @@ static int schedule_resp(struct scsi_cmnd *cmnd, struct sdebug_dev_info *devip,
 					if (new_sd_dp)
 						kfree(sd_dp);
 					/* call scsi_done() from this thread */
-					cmnd->scsi_done(cmnd);
+					scsi_done(cmnd);
 					return 0;
 				}
 				/* otherwise reduce kt by elapsed time */
@@ -5604,7 +5604,7 @@ static int schedule_resp(struct scsi_cmnd *cmnd, struct sdebug_dev_info *devip,
 	cmnd->result &= ~SDEG_RES_IMMED_MASK;
 	if (cmnd->result == 0 && scsi_result != 0)
 		cmnd->result = scsi_result;
-	cmnd->scsi_done(cmnd);
+	scsi_done(cmnd);
 	return 0;
 }
 
@@ -7363,7 +7363,7 @@ static int sdebug_blk_mq_poll(struct Scsi_Host *shost, unsigned int queue_num)
 		}
 		sd_dp->defer_t = SDEB_DEFER_NONE;
 		spin_unlock_irqrestore(&sqp->qc_lock, iflags);
-		scp->scsi_done(scp); /* callback to mid level */
+		scsi_done(scp); /* callback to mid level */
 		spin_lock_irqsave(&sqp->qc_lock, iflags);
 		num_entries++;
 	}
