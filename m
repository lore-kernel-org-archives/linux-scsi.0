Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 55348C433F5
	for <linux-scsi@archiver.kernel.org>; Thu,  7 Oct 2021 20:30:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 425916103B
	for <linux-scsi@archiver.kernel.org>; Thu,  7 Oct 2021 20:30:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242204AbhJGUb5 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 7 Oct 2021 16:31:57 -0400
Received: from mail-pg1-f169.google.com ([209.85.215.169]:37698 "EHLO
        mail-pg1-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242095AbhJGUbz (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 7 Oct 2021 16:31:55 -0400
Received: by mail-pg1-f169.google.com with SMTP id r201so920338pgr.4
        for <linux-scsi@vger.kernel.org>; Thu, 07 Oct 2021 13:30:01 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=joWq+h12Lo/Sq7sVe1znK3TxxZQ/DHIjL3ukW1V1mF8=;
        b=Fox1dn/FaR4pPujpODxH28S1qAtsElTEuBPN+9TZitgfcWd5dJUsuqazuXjGMUIv0j
         KrD23C3fYEJWK2u6fV8H4OrBWRmJy7EueEc4mrsfDLjp99XtreimTuKaUnZk1uBkMfR2
         sIN2RZFdW4Ds2t2kYud9wpT6UIg6T2kS54z6Y53h8e27nG92peiH0JB+BnD9HfV82vlg
         3x4ef/XEvy9jZsyaBplaNFbOCKTFcKavVVwwMp6L5M0EXPgVo2YaJk0G53j+GMgmzDYa
         +rEEJE7BVvp0afypKdJdNHvLQ5oIcNmWNtMzFoRlgLVLszIfaNwWBsDrwQgBlDOjLUvs
         i+Cw==
X-Gm-Message-State: AOAM533/O48v72cJ1k6zpKmI0gH1W5ibeLpyw9hgsRjcKfQ3HVY32nyg
        tgIJgE4ApFaNeb6L4aBbHzQXRrU0v5g=
X-Google-Smtp-Source: ABdhPJyxm/99qVio2N3C7sZGVF5iSvmK1Z3Vduf9GVQ9aeiwXk2/OxcTC7TaFSs3vGM3zipy7Tt4+w==
X-Received: by 2002:aa7:843b:0:b0:44c:53b8:54bd with SMTP id q27-20020aa7843b000000b0044c53b854bdmr6159338pfn.22.1633638601341;
        Thu, 07 Oct 2021 13:30:01 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:ae88:8f16:b90b:5f1d])
        by smtp.gmail.com with ESMTPSA id x35sm303499pfh.52.2021.10.07.13.30.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Oct 2021 13:30:00 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        "Juergen E. Fischer" <fischer@norbit.de>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH v3 19/88] aha152x: Call scsi_done() directly
Date:   Thu,  7 Oct 2021 13:28:14 -0700
Message-Id: <20211007202923.2174984-20-bvanassche@acm.org>
X-Mailer: git-send-email 2.33.0.882.g93a45727a2-goog
In-Reply-To: <20211007202923.2174984-1-bvanassche@acm.org>
References: <20211007202923.2174984-1-bvanassche@acm.org>
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
