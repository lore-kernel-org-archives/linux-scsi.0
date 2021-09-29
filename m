Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 43722C433EF
	for <linux-scsi@archiver.kernel.org>; Wed, 29 Sep 2021 22:08:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 308A06140F
	for <linux-scsi@archiver.kernel.org>; Wed, 29 Sep 2021 22:08:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347210AbhI2WJx (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 29 Sep 2021 18:09:53 -0400
Received: from mail-pg1-f176.google.com ([209.85.215.176]:35785 "EHLO
        mail-pg1-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347053AbhI2WJq (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 29 Sep 2021 18:09:46 -0400
Received: by mail-pg1-f176.google.com with SMTP id e7so4167550pgk.2
        for <linux-scsi@vger.kernel.org>; Wed, 29 Sep 2021 15:08:04 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=QBW95v2yqxN3MisS4ps/ahCvNr8j5XfZY9gx5f9JmA0=;
        b=6hvHVHK2Bk9jKQz7akkPMsE43/95F/mqkRQrBvCgKMRrmzoAenekY4jE94Pv/LTQd+
         MwGVo6OaXlUAaE6jgb2JLZqTGpt1VMKy6Y2+gU4Ju4PbKJescV+06No3SgUmsod8/S/u
         L4X3zDOSvkZiJodenYBH+2wZv2dK58b2a4DhMqeqJp/dUNSB1DtfmZq79IgwKyJu5rk1
         o+R6U2u7+hkF68ZXtc7dRwlqje2w2sw0d9YTt9oFf4TbgJ16VH4klk717jCkqsQ1Agde
         t2u1R8JPQVm9ofXx42tLKbrCyFpsBGqXUNxxaiasD0Jx3XPIyZLyIgeFGXd7Bj9OW+Db
         1Lsw==
X-Gm-Message-State: AOAM532Q5khVqSSTm+48dZHcYWZj6+q9t/DT7rWTNQ8DytVAvKZbJkQe
        G5IF8v4R1yiSaW8QGuji1gM=
X-Google-Smtp-Source: ABdhPJx7JrNoY33FboJ/QfgIxCAVQkuRT64xCdy/R/uer4UB4oLDpMa360XBC9udvJNR4OjHKtQXGw==
X-Received: by 2002:a63:b54b:: with SMTP id u11mr1891994pgo.163.1632953284424;
        Wed, 29 Sep 2021 15:08:04 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:5c11:c4f:db56:119])
        by smtp.gmail.com with ESMTPSA id gk14sm2785585pjb.35.2021.09.29.15.08.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Sep 2021 15:08:03 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH v2 68/84] scsi_debug: Call scsi_done() directly
Date:   Wed, 29 Sep 2021 15:05:44 -0700
Message-Id: <20210929220600.3509089-69-bvanassche@acm.org>
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
