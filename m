Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0322DC678D5
	for <linux-scsi@archiver.kernel.org>; Tue,  7 Mar 2023 21:52:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230042AbjCGVwF (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 7 Mar 2023 16:52:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35528 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231493AbjCGVwD (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 7 Mar 2023 16:52:03 -0500
Received: from mail-pl1-f171.google.com (mail-pl1-f171.google.com [209.85.214.171])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2058DAD020
        for <linux-scsi@vger.kernel.org>; Tue,  7 Mar 2023 13:52:02 -0800 (PST)
Received: by mail-pl1-f171.google.com with SMTP id x11so11121190pln.12
        for <linux-scsi@vger.kernel.org>; Tue, 07 Mar 2023 13:52:02 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678225921;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=XiT8LCYHQIcCqp4F7sLHjjPGLxZXs9lgLIkbJlrnuTI=;
        b=BwaHp/vlpWXEB15aCHVcCfNDslFZoQBCIDp+8Ru2ViZ6UWeGisABAnbF6u8aV1AiMo
         jM3JrP/HnL9bZI3zerE0M94v6pKQ5UAxxzW1GGDY9DYz2ZKqO8PDhbXM5txbW2JjrnKg
         rvXYleaUnHDvM23lrFpJkyKhaGOsKq5y07V7ygZVk6XQ29m0yRLA4GENJO374PF2b0c4
         NLvTdWcK0+Sewx1Y4Vs8k453/e9+tXbU3pX8DRDiUM2kz47Pqpm5FofbiZflSMOsPqki
         Q/GqlwrwHVPSrhV+zwKDrQ8OziR3a+bkjzPCwl8KnkQF3DMdK1njqKT4DvNOR22o/Zzl
         HAJQ==
X-Gm-Message-State: AO0yUKUd0wjP22IlvmloMQXIBoT5BuA4+WS9ZsabfPuU9CQFxsRMvpCG
        IhmWRdyBd5unwcrRImtb2ZQ=
X-Google-Smtp-Source: AK7set/JyBN1JtommrmkiHtidICH53PtS9T0bnh/vzJsx6vjriXw3oTPHjFOSlV8Z04lWgNDLao62w==
X-Received: by 2002:a17:902:e801:b0:19e:839e:49d8 with SMTP id u1-20020a170902e80100b0019e839e49d8mr19112711plg.59.1678225921341;
        Tue, 07 Mar 2023 13:52:01 -0800 (PST)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:8361:6b6b:1140:bcbb])
        by smtp.gmail.com with ESMTPSA id u4-20020a170902e80400b0019d397b0f18sm8783280plg.214.2023.03.07.13.51.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Mar 2023 13:51:59 -0800 (PST)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Ming Lei <ming.lei@redhat.com>,
        Mike Christie <michael.christie@oracle.com>,
        John Garry <john.g.garry@oracle.com>,
        Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        Hannes Reinecke <hare@suse.de>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH] scsi: core: Simplify the code for waking up the error handler
Date:   Tue,  7 Mar 2023 13:51:51 -0800
Message-Id: <20230307215151.3705164-1-bvanassche@acm.org>
X-Mailer: git-send-email 2.40.0.rc0.216.gc4246ad0f0-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

scsi_dec_host_busy() is called from the hot path and hence must not
obtain the host lock if no commands have failed. scsi_dec_host_busy()
tests three different variables of which at least two are set if a
command failed. Commit 3bd6f43f5cb3 ("scsi: core: Ensure that the
SCSI error handler gets woken up") introduced a call_rcu() call to
ensure that all tasks observe the host state change before the
host_failed change. Simplify the approach for guaranteeing that the host
state and host_failed/host_eh_scheduled changes are observed in order by using
smp_store_release() to update host_failed or host_eh_scheduled after
having update the host state and smp_load_acquire() before reading the
host state.

Cc: Ming Lei <ming.lei@redhat.com>
Cc: Mike Christie <michael.christie@oracle.com>
Cc: John Garry <john.g.garry@oracle.com>
Cc: Damien Le Moal <damien.lemoal@opensource.wdc.com>
Cc: Hannes Reinecke <hare@suse.de>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/scsi_error.c | 22 ++++------------------
 drivers/scsi/scsi_lib.c   | 31 +++++++++----------------------
 include/scsi/scsi_cmnd.h  |  2 --
 3 files changed, 13 insertions(+), 42 deletions(-)

diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
index 2aa2c2aee6e7..2a809145da06 100644
--- a/drivers/scsi/scsi_error.c
+++ b/drivers/scsi/scsi_error.c
@@ -87,7 +87,8 @@ void scsi_schedule_eh(struct Scsi_Host *shost)
 
 	if (scsi_host_set_state(shost, SHOST_RECOVERY) == 0 ||
 	    scsi_host_set_state(shost, SHOST_CANCEL_RECOVERY) == 0) {
-		shost->host_eh_scheduled++;
+		smp_store_release(&shost->host_eh_scheduled,
+				  shost->host_eh_scheduled + 1);
 		scsi_eh_wakeup(shost);
 	}
 
@@ -278,18 +279,6 @@ static void scsi_eh_reset(struct scsi_cmnd *scmd)
 	}
 }
 
-static void scsi_eh_inc_host_failed(struct rcu_head *head)
-{
-	struct scsi_cmnd *scmd = container_of(head, typeof(*scmd), rcu);
-	struct Scsi_Host *shost = scmd->device->host;
-	unsigned long flags;
-
-	spin_lock_irqsave(shost->host_lock, flags);
-	shost->host_failed++;
-	scsi_eh_wakeup(shost);
-	spin_unlock_irqrestore(shost->host_lock, flags);
-}
-
 /**
  * scsi_eh_scmd_add - add scsi cmd to error handling.
  * @scmd:	scmd to run eh on.
@@ -312,12 +301,9 @@ void scsi_eh_scmd_add(struct scsi_cmnd *scmd)
 
 	scsi_eh_reset(scmd);
 	list_add_tail(&scmd->eh_entry, &shost->eh_cmd_q);
+	smp_store_release(&shost->host_failed, shost->host_failed + 1);
+	scsi_eh_wakeup(shost);
 	spin_unlock_irqrestore(shost->host_lock, flags);
-	/*
-	 * Ensure that all tasks observe the host state change before the
-	 * host_failed change.
-	 */
-	call_rcu_hurry(&scmd->rcu, scsi_eh_inc_host_failed);
 }
 
 /**
diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index b7c569a42aa4..e59eb0cbfc83 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -263,28 +263,24 @@ int scsi_execute_cmd(struct scsi_device *sdev, const unsigned char *cmd,
 }
 EXPORT_SYMBOL(scsi_execute_cmd);
 
-/*
- * Wake up the error handler if necessary. Avoid as follows that the error
- * handler is not woken up if host in-flight requests number ==
- * shost->host_failed: use call_rcu() in scsi_eh_scmd_add() in combination
- * with an RCU read lock in this function to ensure that this function in
- * its entirety either finishes before scsi_eh_scmd_add() increases the
- * host_failed counter or that it notices the shost state change made by
- * scsi_eh_scmd_add().
- */
+/* Wake up the error handler if necessary. */
 static void scsi_dec_host_busy(struct Scsi_Host *shost, struct scsi_cmnd *cmd)
 {
 	unsigned long flags;
 
-	rcu_read_lock();
 	__clear_bit(SCMD_STATE_INFLIGHT, &cmd->state);
-	if (unlikely(scsi_host_in_recovery(shost))) {
+	/*
+	 * Test host_failed and host_eh_scheduled before the host state to
+	 * ensure that the host state update is observed if the host_failed
+	 * and/or host_eh_scheduled updates are observed.
+	 */
+	if (unlikely((smp_load_acquire(&shost->host_failed) ||
+		      smp_load_acquire(&shost->host_eh_scheduled)))) {
 		spin_lock_irqsave(shost->host_lock, flags);
-		if (shost->host_failed || shost->host_eh_scheduled)
+		if (scsi_host_in_recovery(shost))
 			scsi_eh_wakeup(shost);
 		spin_unlock_irqrestore(shost->host_lock, flags);
 	}
-	rcu_read_unlock();
 }
 
 void scsi_device_unbusy(struct scsi_device *sdev, struct scsi_cmnd *cmd)
@@ -547,14 +543,6 @@ static bool scsi_end_request(struct request *req, blk_status_t error,
 		cmd->flags &= ~SCMD_INITIALIZED;
 	}
 
-	/*
-	 * Calling rcu_barrier() is not necessary here because the
-	 * SCSI error handler guarantees that the function called by
-	 * call_rcu() has been called before scsi_end_request() is
-	 * called.
-	 */
-	destroy_rcu_head(&cmd->rcu);
-
 	/*
 	 * In the MQ case the command gets freed by __blk_mq_end_request,
 	 * so we have to do all cleanup that depends on it earlier.
@@ -1124,7 +1112,6 @@ static void scsi_initialize_rq(struct request *rq)
 	memset(cmd->cmnd, 0, sizeof(cmd->cmnd));
 	cmd->cmd_len = MAX_COMMAND_SIZE;
 	cmd->sense_len = 0;
-	init_rcu_head(&cmd->rcu);
 	cmd->jiffies_at_alloc = jiffies;
 	cmd->retries = 0;
 }
diff --git a/include/scsi/scsi_cmnd.h b/include/scsi/scsi_cmnd.h
index c2cb5f69635c..7965f5114144 100644
--- a/include/scsi/scsi_cmnd.h
+++ b/include/scsi/scsi_cmnd.h
@@ -71,8 +71,6 @@ struct scsi_cmnd {
 	struct list_head eh_entry; /* entry for the host eh_abort_list/eh_cmd_q */
 	struct delayed_work abort_work;
 
-	struct rcu_head rcu;
-
 	int eh_eflags;		/* Used by error handlr */
 
 	int budget_token;
