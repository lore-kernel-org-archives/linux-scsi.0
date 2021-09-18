Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9F82DC433F5
	for <linux-scsi@archiver.kernel.org>; Sat, 18 Sep 2021 00:07:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8009260F46
	for <linux-scsi@archiver.kernel.org>; Sat, 18 Sep 2021 00:07:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343922AbhIRAIc (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 17 Sep 2021 20:08:32 -0400
Received: from mail-pf1-f173.google.com ([209.85.210.173]:43770 "EHLO
        mail-pf1-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344048AbhIRAIb (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 17 Sep 2021 20:08:31 -0400
Received: by mail-pf1-f173.google.com with SMTP id c1so7728226pfp.10
        for <linux-scsi@vger.kernel.org>; Fri, 17 Sep 2021 17:07:08 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=FrjaDQynpsanZ6aSkHdGiM11iP+I2iU8QPoNUiJ3poU=;
        b=PJJAcMGcFH4SjgDKAZyHYw1BZeVLrJ+BTI9ThDYOz9B5ef6jxKMzMsIJPcwOmnQrb+
         X43hw5eNLXlsQ/BgkOXFJyeY0o5hkdVYtuuekfigzVKCO0hBZNdG4Gz1kvIE41fRBhqk
         OjgGwUPch8XBZV+m0V7ziShx+CBQO0eJOZTQQDJ4+JMSvU35yWfVFAYZT/8DDbKxsqVV
         ir3EmPwxjvq6wNpbYAZrv1/Hcv838g6q8pWfCOWwLL6ybg5ApSgc6dhRGQqIhMODBELQ
         dAULoV4plUSYg9kqaYKDp93gQYd0S5SQFjGWqcGv1uTmM+2+G6HBQqA2AdzngT968SmF
         oJIQ==
X-Gm-Message-State: AOAM532++gqYw49kRRmtpcs6p2AN1R0z8MwcnoBZrMtE4lCFh2XWWMZe
        e1z9GzI0Yg8DC6x0Ar8aVKxkPilxMkA=
X-Google-Smtp-Source: ABdhPJwP2kApZYY6ANr2VSG8wP596UpjpVECmLv4wDlybL7VRwEX4AMjkQc+OaeCS7J4IYnNIjmqNA==
X-Received: by 2002:a63:cd48:: with SMTP id a8mr12354392pgj.180.1631923628135;
        Fri, 17 Sep 2021 17:07:08 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:4c45:d635:d2d2:93])
        by smtp.gmail.com with ESMTPSA id bv16sm6403129pjb.12.2021.09.17.17.07.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Sep 2021 17:07:07 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Bradley Grove <linuxdrivers@attotech.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH 31/84] esas2r: Call scsi_done() directly
Date:   Fri, 17 Sep 2021 17:05:14 -0700
Message-Id: <20210918000607.450448-32-bvanassche@acm.org>
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
 drivers/scsi/esas2r/esas2r_main.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/esas2r/esas2r_main.c b/drivers/scsi/esas2r/esas2r_main.c
index 647f82898b6e..7a4eadad23d7 100644
--- a/drivers/scsi/esas2r/esas2r_main.c
+++ b/drivers/scsi/esas2r/esas2r_main.c
@@ -828,7 +828,7 @@ int esas2r_queuecommand(struct Scsi_Host *host, struct scsi_cmnd *cmd)
 
 	if (unlikely(test_bit(AF_DEGRADED_MODE, &a->flags))) {
 		cmd->result = DID_NO_CONNECT << 16;
-		cmd->scsi_done(cmd);
+		scsi_done(cmd);
 		return 0;
 	}
 
@@ -988,7 +988,7 @@ int esas2r_eh_abort(struct scsi_cmnd *cmd)
 
 		scsi_set_resid(cmd, 0);
 
-		cmd->scsi_done(cmd);
+		scsi_done(cmd);
 
 		return SUCCESS;
 	}
@@ -1054,7 +1054,7 @@ int esas2r_eh_abort(struct scsi_cmnd *cmd)
 
 	scsi_set_resid(cmd, 0);
 
-	cmd->scsi_done(cmd);
+	scsi_done(cmd);
 
 	return SUCCESS;
 }
@@ -1535,7 +1535,7 @@ void esas2r_complete_request_cb(struct esas2r_adapter *a,
 			scsi_set_resid(rq->cmd, 0);
 	}
 
-	rq->cmd->scsi_done(rq->cmd);
+	scsi_done(rq->cmd);
 
 	esas2r_free_request(a, rq);
 }
