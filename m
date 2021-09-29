Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E5D3FC433F5
	for <linux-scsi@archiver.kernel.org>; Wed, 29 Sep 2021 22:06:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CEF316138F
	for <linux-scsi@archiver.kernel.org>; Wed, 29 Sep 2021 22:06:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347075AbhI2WIc (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 29 Sep 2021 18:08:32 -0400
Received: from mail-pg1-f177.google.com ([209.85.215.177]:41509 "EHLO
        mail-pg1-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347074AbhI2WIZ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 29 Sep 2021 18:08:25 -0400
Received: by mail-pg1-f177.google.com with SMTP id k24so4142308pgh.8
        for <linux-scsi@vger.kernel.org>; Wed, 29 Sep 2021 15:06:43 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=joWq+h12Lo/Sq7sVe1znK3TxxZQ/DHIjL3ukW1V1mF8=;
        b=5AZoK9wiAtfhYf/zVJid0hNrk6dR6YCPl3Rf99fHwmel6GxW5tvoFItGaMD9cKFmeO
         cZGM7gxeRFLSvPwInoqe3ot9FpJQ43oDAjx/CIkEOEKF/auuc0DKZINeUsKfQ6XyXelb
         RZqaRwjf9eM0Xl+SrgiuNdCgyStw1ce5mtEfn5nuJTeVkZEzlNjUmZwwxZxGha0/14DS
         tvpFC2ymTZ+82U0LSf0z+BgVTcPwhyerJU4AqpvwBv8XAtloBx3vwKSDREzWMXi0P34a
         yjvk5qOsh5J7ZFAy0qlf+0R8WdP3EIdKEPSSTUA6PUNVaeBBx0xeOKGCIovClwiqHXiC
         Myzg==
X-Gm-Message-State: AOAM530WbKzBqzNf5kDGuc4kmGEqnTceG6+XFbG5p0MPSyjS5/UcMYuR
        iGn1h0l2GCZiTKjpDxljAGU=
X-Google-Smtp-Source: ABdhPJyJtqzTC7Qhxm5E9n9Y3+3dwn5+rkJx3A82btJgtmLRJpUkZn+CYY5ChR5IH6R+x8AaumueGQ==
X-Received: by 2002:a63:9d4c:: with SMTP id i73mr1903144pgd.216.1632953203130;
        Wed, 29 Sep 2021 15:06:43 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:5c11:c4f:db56:119])
        by smtp.gmail.com with ESMTPSA id gk14sm2785585pjb.35.2021.09.29.15.06.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Sep 2021 15:06:42 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        "Juergen E. Fischer" <fischer@norbit.de>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH v2 19/84] aha152x: Call scsi_done() directly
Date:   Wed, 29 Sep 2021 15:04:55 -0700
Message-Id: <20210929220600.3509089-20-bvanassche@acm.org>
X-Mailer: git-send-email 2.33.0.685.g46640cef36-goog
In-Reply-To: <20210929220600.3509089-1-bvanassche@acm.org>
References: <20210929220600.3509089-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Conditional statements are faster than indirect calls. Hence call
scsi_done() and reset_done() directly. The changes in this patch are as
follows:
- Remove the 'done' argument from aha152x_internal_queue().
- Change ptr->scsi_done(ptr) into aha152x_scsi_done(ptr).
- Inside aha152x_scsi_done(), check the 'resetting' flag of SCp.phase
  since aha152x_internal_queue() specifies the 'reset_done' function
  pointer if and only if the third argument has the value 'resetting'.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/aha152x.c | 27 +++++++++++++++++----------
 1 file changed, 17 insertions(+), 10 deletions(-)

diff --git a/drivers/scsi/aha152x.c b/drivers/scsi/aha152x.c
index b13b5c85f3de..f07de9912790 100644
--- a/drivers/scsi/aha152x.c
+++ b/drivers/scsi/aha152x.c
@@ -905,13 +905,11 @@ static int setup_expected_interrupts(struct Scsi_Host *shpnt)
  *  Queue a command and setup interrupts for a free bus.
  */
 static int aha152x_internal_queue(struct scsi_cmnd *SCpnt,
-				  struct completion *complete,
-				  int phase, void (*done)(struct scsi_cmnd *))
+				  struct completion *complete, int phase)
 {
 	struct Scsi_Host *shpnt = SCpnt->device->host;
 	unsigned long flags;
 
-	SCpnt->scsi_done	= done;
 	SCpnt->SCp.phase	= not_issued | phase;
 	SCpnt->SCp.Status	= 0x1; /* Ilegal status by SCSI standard */
 	SCpnt->SCp.Message	= 0;
@@ -980,7 +978,8 @@ static int aha152x_internal_queue(struct scsi_cmnd *SCpnt,
 static int aha152x_queue_lck(struct scsi_cmnd *SCpnt,
 			     void (*done)(struct scsi_cmnd *))
 {
-	return aha152x_internal_queue(SCpnt, NULL, 0, done);
+	WARN_ON_ONCE(done != scsi_done);
+	return aha152x_internal_queue(SCpnt, NULL, 0);
 }
 
 static DEF_SCSI_QCMD(aha152x_queue)
@@ -998,6 +997,14 @@ static void reset_done(struct scsi_cmnd *SCpnt)
 	}
 }
 
+static void aha152x_scsi_done(struct scsi_cmnd *SCpnt)
+{
+	if (SCpnt->SCp.phase & resetting)
+		reset_done(SCpnt);
+	else
+		scsi_done(SCpnt);
+}
+
 /*
  *  Abort a command
  *
@@ -1064,7 +1071,7 @@ static int aha152x_device_reset(struct scsi_cmnd * SCpnt)
 
 	SCpnt->cmd_len         = 0;
 
-	aha152x_internal_queue(SCpnt, &done, resetting, reset_done);
+	aha152x_internal_queue(SCpnt, &done, resetting);
 
 	timeleft = wait_for_completion_timeout(&done, 100*HZ);
 	if (!timeleft) {
@@ -1439,12 +1446,12 @@ static void busfree_run(struct Scsi_Host *shpnt)
 				scsi_eh_prep_cmnd(ptr, &sc->ses, NULL, 0, ~0);
 
 				DO_UNLOCK(flags);
-				aha152x_internal_queue(ptr, NULL, check_condition, ptr->scsi_done);
+				aha152x_internal_queue(ptr, NULL, check_condition);
 				DO_LOCK(flags);
 			}
 		}
 
-		if(DONE_SC && DONE_SC->scsi_done) {
+		if (DONE_SC) {
 			struct scsi_cmnd *ptr = DONE_SC;
 			DONE_SC=NULL;
 
@@ -1453,13 +1460,13 @@ static void busfree_run(struct Scsi_Host *shpnt)
 			if (!HOSTDATA(shpnt)->commands)
 				SETPORT(PORTA, 0);	/* turn led off */
 
-			if(ptr->scsi_done != reset_done) {
+			if (!(ptr->SCp.phase & resetting)) {
 				kfree(ptr->host_scribble);
 				ptr->host_scribble=NULL;
 			}
 
 			DO_UNLOCK(flags);
-			ptr->scsi_done(ptr);
+			aha152x_scsi_done(ptr);
 			DO_LOCK(flags);
 		}
 
@@ -2258,7 +2265,7 @@ static void rsti_run(struct Scsi_Host *shpnt)
 			ptr->host_scribble=NULL;
 
 			set_host_byte(ptr, DID_RESET);
-			ptr->scsi_done(ptr);
+			aha152x_scsi_done(ptr);
 		}
 
 		ptr = next;
