Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E213DC433F5
	for <linux-scsi@archiver.kernel.org>; Thu,  7 Oct 2021 20:31:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CB07560F23
	for <linux-scsi@archiver.kernel.org>; Thu,  7 Oct 2021 20:31:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242428AbhJGUdh (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 7 Oct 2021 16:33:37 -0400
Received: from mail-pj1-f52.google.com ([209.85.216.52]:53873 "EHLO
        mail-pj1-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242494AbhJGUdX (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 7 Oct 2021 16:33:23 -0400
Received: by mail-pj1-f52.google.com with SMTP id ls18so5797178pjb.3
        for <linux-scsi@vger.kernel.org>; Thu, 07 Oct 2021 13:31:29 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=QBW95v2yqxN3MisS4ps/ahCvNr8j5XfZY9gx5f9JmA0=;
        b=0pubAkOsRIBz6ccU7SKu2aeztTIQJQ4H+36r/m2OfzDqIiUkFgHohBDYWGSjAzRS/X
         uHQ0J9qS23F2MavR3FaxUDTs27HGkPjx1M2M1NcXtmQ8yncvW8ZBxdfyXZgOzZaCfiHk
         /cyDBciF+cMvS1+OR83ylc43Yig4B42NNSXsnDq7MO/UzQOxaoHi/ugDiUg4DQT0OvdL
         bqKUHstaoNFRsfMb0wspkdLAYUNvU3K+HRqIQPmH7PWMW60kUvbs6P/QOHW6pUK9pBgu
         vFG2qhSwLsOzbTcrJWPs0uBYqOXRwFbDW5VU96dS2+9Q/pFP+k5f+2lsWrlzkGKG6rFO
         G/Sw==
X-Gm-Message-State: AOAM532avRqNksVFKmD+EDpbSb7Z0PFB7Z7ll6EpPs397DKdhXaqPj6o
        1VTRiVMpNBc3bkMQNTxGk+4=
X-Google-Smtp-Source: ABdhPJxNRK+kqLLxsQZ2IApkQ5W2vLwmoA3Jc5rh12/KWD1SJtVfGsdPHtTH3ew7PGeOoDrJHFygoQ==
X-Received: by 2002:a17:90a:304:: with SMTP id 4mr7683963pje.124.1633638688690;
        Thu, 07 Oct 2021 13:31:28 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:ae88:8f16:b90b:5f1d])
        by smtp.gmail.com with ESMTPSA id x35sm303499pfh.52.2021.10.07.13.31.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Oct 2021 13:31:28 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH v3 69/88] scsi_debug: Call scsi_done() directly
Date:   Thu,  7 Oct 2021 13:29:04 -0700
Message-Id: <20211007202923.2174984-70-bvanassche@acm.org>
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
