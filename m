Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2B4A8C433F5
	for <linux-scsi@archiver.kernel.org>; Thu,  7 Oct 2021 20:30:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 150D660E9B
	for <linux-scsi@archiver.kernel.org>; Thu,  7 Oct 2021 20:30:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242382AbhJGUc1 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 7 Oct 2021 16:32:27 -0400
Received: from mail-pg1-f180.google.com ([209.85.215.180]:36377 "EHLO
        mail-pg1-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242320AbhJGUcW (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 7 Oct 2021 16:32:22 -0400
Received: by mail-pg1-f180.google.com with SMTP id 75so925940pga.3
        for <linux-scsi@vger.kernel.org>; Thu, 07 Oct 2021 13:30:28 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=FrjaDQynpsanZ6aSkHdGiM11iP+I2iU8QPoNUiJ3poU=;
        b=xJkD1SZhYf9Coos0FgQRHmUAMPGAAWWZetb2xAAICXMYvJicitzXrJUBvVW6JJFEyd
         4rvpjL27kPVe9fYxBkxKMhbBRVc7UkpIsylDbWrINIZNrpRHcWglfK0hVE36Y8fBi4dY
         PBGgW7eaOqnnCqzN+DEpHSopAZIAblos1R4pVKozelI0ZVOQ7zcOCd1edrY8JLmalkLw
         kY/8CtZ09bU4U0ecfDkhTLQtOTZUoYCZyEfUi4LqN7aa/P0A7wFM7Bdu/FnEj6wHxdxi
         6zL3yiwmSh+6s+57hisXdC6NjokzkmUbjJLa2cMIHTtNtLQ4Z+EpcX+TDRAGEM+X04p5
         ga1w==
X-Gm-Message-State: AOAM531UgEQ3JhCfGdNq3g0OVXnGOi2jfwxoobBmeAMhjpvLTl4Q2o2p
        GNzEsbu8UzjAY9E/QIR0Eog=
X-Google-Smtp-Source: ABdhPJzGjsC5bewS0h+q8FtaEwSBEQI20xoQtpONCbtHGgLHsEd2nUxPHZ7lz0QhWE20X/Y9UVLWlA==
X-Received: by 2002:aa7:9486:0:b0:44c:2605:72b3 with SMTP id z6-20020aa79486000000b0044c260572b3mr6493173pfk.22.1633638628010;
        Thu, 07 Oct 2021 13:30:28 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:ae88:8f16:b90b:5f1d])
        by smtp.gmail.com with ESMTPSA id x35sm303499pfh.52.2021.10.07.13.30.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Oct 2021 13:30:27 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Bradley Grove <linuxdrivers@attotech.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH v3 30/88] esas2r: Call scsi_done() directly
Date:   Thu,  7 Oct 2021 13:28:25 -0700
Message-Id: <20211007202923.2174984-31-bvanassche@acm.org>
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
