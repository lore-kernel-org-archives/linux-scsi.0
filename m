Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C6E8FC433F5
	for <linux-scsi@archiver.kernel.org>; Mon, 25 Oct 2021 14:39:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9D2C860F92
	for <linux-scsi@archiver.kernel.org>; Mon, 25 Oct 2021 14:39:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231437AbhJYOmT (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 25 Oct 2021 10:42:19 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:54163 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230137AbhJYOmS (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 25 Oct 2021 10:42:18 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1635172795;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Xgy1u2Ud/fpC9Bcm8vfEj4fghodyhaIO7zE9kfbbm2U=;
        b=Hh19d8wYUJhMbN6fwn9MdCpUvSRqKM7bU/nuYf/iSuoivYxj3n/9j/A1tWhhb+4QyTGpcM
        rzqVfKzQHnpy1cbMiLXQapWbJ9b4sEuSrYl5+oTayu/pmwyHyB0gIdwrRrTlNsNyY77uqA
        oUfbYIfG1nB0KgHDkv7GkLG2E71ik1c=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-330-x--vMTBDNiSkVUWSaF5ZIA-1; Mon, 25 Oct 2021 10:39:54 -0400
X-MC-Unique: x--vMTBDNiSkVUWSaF5ZIA-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 80F0E1882FB3
        for <linux-scsi@vger.kernel.org>; Mon, 25 Oct 2021 14:39:53 +0000 (UTC)
Received: from emilne.bos.redhat.com (unknown [10.18.25.205])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 4FA0D5D9D5
        for <linux-scsi@vger.kernel.org>; Mon, 25 Oct 2021 14:39:53 +0000 (UTC)
From:   "Ewan D. Milne" <emilne@redhat.com>
To:     linux-scsi@vger.kernel.org
Subject: [PATCH 1/2] scsi: core: avoid leaving shost->last_reset with stale value if EH does not run
Date:   Mon, 25 Oct 2021 10:39:51 -0400
Message-Id: <20211025143952.17128-2-emilne@redhat.com>
In-Reply-To: <20211025143952.17128-1-emilne@redhat.com>
References: <20211025143952.17128-1-emilne@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The changes to issue the abort from the scmd->abort_work instead of the EH
thread introduced a problem if eh_deadline is used.  If aborting the command(s)
is successful, and there are never any scmds added to the shost->eh_cmd_q,
there is no code path which will reset the ->last_reset value back to zero.

The effect of this is that after a successful abort with no EH thread activity,
a subsequent timeout, perhaps a long time later, might immediately be considered
past a user-set eh_deadline time, and the host will be reset with no attempt at
recovery.

Fix this by resetting ->last_reset back to zero in scmd_eh_abort_handler()
if it is determined that the EH thread will not run to do this.

Thanks to Gopinath Marappan for investigating this problem.

Reported-by: Gopinath Marappan <marappan_gopinath@emc.com>
Fixes: e494f6a72839 ("[SCSI] improved eh timeout handler")
Cc: stable@vger.kernel.org
Signed-off-by: Ewan D. Milne <emilne@redhat.com>
---
 drivers/scsi/hosts.c      |  1 +
 drivers/scsi/scsi_error.c | 44 +++++++++++++++++++++++++++++++++++++++++---
 drivers/scsi/scsi_lib.c   |  1 +
 include/scsi/scsi_cmnd.h  |  2 +-
 include/scsi/scsi_host.h  |  1 +
 5 files changed, 45 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/hosts.c b/drivers/scsi/hosts.c
index 3f6f14f..ff82f25 100644
--- a/drivers/scsi/hosts.c
+++ b/drivers/scsi/hosts.c
@@ -387,6 +387,7 @@ struct Scsi_Host *scsi_host_alloc(struct scsi_host_template *sht, int privsize)
 	shost->shost_state = SHOST_CREATED;
 	INIT_LIST_HEAD(&shost->__devices);
 	INIT_LIST_HEAD(&shost->__targets);
+	INIT_LIST_HEAD(&shost->eh_abort_list);
 	INIT_LIST_HEAD(&shost->eh_cmd_q);
 	INIT_LIST_HEAD(&shost->starved_list);
 	init_waitqueue_head(&shost->host_wait);
diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
index b6c86cc..9f4001e 100644
--- a/drivers/scsi/scsi_error.c
+++ b/drivers/scsi/scsi_error.c
@@ -151,9 +151,11 @@ scmd_eh_abort_handler(struct work_struct *work)
 	struct scsi_cmnd *scmd =
 		container_of(work, struct scsi_cmnd, abort_work.work);
 	struct scsi_device *sdev = scmd->device;
+	struct Scsi_Host *shost = sdev->host;
 	enum scsi_disposition rtn;
+	unsigned long flags;
 
-	if (scsi_host_eh_past_deadline(sdev->host)) {
+	if (scsi_host_eh_past_deadline(shost)) {
 		SCSI_LOG_ERROR_RECOVERY(3,
 			scmd_printk(KERN_INFO, scmd,
 				    "eh timeout, not aborting\n"));
@@ -161,10 +163,10 @@ scmd_eh_abort_handler(struct work_struct *work)
 		SCSI_LOG_ERROR_RECOVERY(3,
 			scmd_printk(KERN_INFO, scmd,
 				    "aborting command\n"));
-		rtn = scsi_try_to_abort_cmd(sdev->host->hostt, scmd);
+		rtn = scsi_try_to_abort_cmd(shost->hostt, scmd);
 		if (rtn == SUCCESS) {
 			set_host_byte(scmd, DID_TIME_OUT);
-			if (scsi_host_eh_past_deadline(sdev->host)) {
+			if (scsi_host_eh_past_deadline(shost)) {
 				SCSI_LOG_ERROR_RECOVERY(3,
 					scmd_printk(KERN_INFO, scmd,
 						    "eh timeout, not retrying "
@@ -175,12 +177,42 @@ scmd_eh_abort_handler(struct work_struct *work)
 				SCSI_LOG_ERROR_RECOVERY(3,
 					scmd_printk(KERN_WARNING, scmd,
 						    "retry aborted command\n"));
+
+				spin_lock_irqsave(shost->host_lock, flags);
+				list_del_init(&scmd->eh_entry);
+
+				/*
+				 * If the abort succeeds, and there is no further
+				 * EH action, clear the ->last_reset time.
+				 */
+				if (list_empty(&shost->eh_abort_list) &&
+				    list_empty(&shost->eh_cmd_q))
+					if (shost->eh_deadline != -1)
+						shost->last_reset = 0;
+
+				spin_unlock_irqrestore(shost->host_lock, flags);
+
 				scsi_queue_insert(scmd, SCSI_MLQUEUE_EH_RETRY);
 				return;
 			} else {
 				SCSI_LOG_ERROR_RECOVERY(3,
 					scmd_printk(KERN_WARNING, scmd,
 						    "finish aborted command\n"));
+
+				spin_lock_irqsave(shost->host_lock, flags);
+				list_del_init(&scmd->eh_entry);
+
+				/*
+				 * If the abort succeeds, and there is no further
+				 * EH action, clear the ->last_reset time.
+				 */
+				if (list_empty(&shost->eh_abort_list) &&
+				    list_empty(&shost->eh_cmd_q))
+					if (shost->eh_deadline != -1)
+						shost->last_reset = 0;
+
+				spin_unlock_irqrestore(shost->host_lock, flags);
+
 				scsi_finish_command(scmd);
 				return;
 			}
@@ -193,6 +225,10 @@ scmd_eh_abort_handler(struct work_struct *work)
 		}
 	}
 
+	spin_lock_irqsave(shost->host_lock, flags);
+	list_del_init(&scmd->eh_entry);
+	spin_unlock_irqrestore(shost->host_lock, flags);
+
 	scsi_eh_scmd_add(scmd);
 }
 
@@ -223,6 +259,8 @@ scsi_abort_command(struct scsi_cmnd *scmd)
 	spin_lock_irqsave(shost->host_lock, flags);
 	if (shost->eh_deadline != -1 && !shost->last_reset)
 		shost->last_reset = jiffies;
+	BUG_ON(!list_empty(&scmd->eh_entry));
+	list_add_tail(&scmd->eh_entry, &shost->eh_abort_list);
 	spin_unlock_irqrestore(shost->host_lock, flags);
 
 	scmd->eh_eflags |= SCSI_EH_ABORT_SCHEDULED;
diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 5726738..05f8f6e 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -1143,6 +1143,7 @@ void scsi_init_command(struct scsi_device *dev, struct scsi_cmnd *cmd)
 	cmd->sense_buffer = buf;
 	cmd->prot_sdb = prot;
 	cmd->flags = flags;
+	INIT_LIST_HEAD(&cmd->eh_entry);
 	INIT_DELAYED_WORK(&cmd->abort_work, scmd_eh_abort_handler);
 	cmd->jiffies_at_alloc = jiffies_at_alloc;
 	cmd->retries = retries;
diff --git a/include/scsi/scsi_cmnd.h b/include/scsi/scsi_cmnd.h
index eaf04c9..59afe87 100644
--- a/include/scsi/scsi_cmnd.h
+++ b/include/scsi/scsi_cmnd.h
@@ -68,7 +68,7 @@ struct scsi_pointer {
 struct scsi_cmnd {
 	struct scsi_request req;
 	struct scsi_device *device;
-	struct list_head eh_entry; /* entry for the host eh_cmd_q */
+	struct list_head eh_entry; /* entry for the host eh_abort_list/eh_cmd_q */
 	struct delayed_work abort_work;
 
 	struct rcu_head rcu;
diff --git a/include/scsi/scsi_host.h b/include/scsi/scsi_host.h
index 7536370..1a02e58 100644
--- a/include/scsi/scsi_host.h
+++ b/include/scsi/scsi_host.h
@@ -556,6 +556,7 @@ struct Scsi_Host {
 
 	struct mutex		scan_mutex;/* serialize scanning activity */
 
+	struct list_head	eh_abort_list;
 	struct list_head	eh_cmd_q;
 	struct task_struct    * ehandler;  /* Error recovery thread. */
 	struct completion     * eh_action; /* Wait for specific actions on the
-- 
2.1.0

