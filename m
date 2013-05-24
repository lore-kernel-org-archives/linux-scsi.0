From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 3/4] scsi: export functions for new fc timeout handler
Date: Fri, 24 May 2013 11:50:49 +0200
Message-ID: <1369389050-118628-4-git-send-email-hare@suse.de>
References: <1369389050-118628-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:40927 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752228Ab3EXJux (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 24 May 2013 05:50:53 -0400
In-Reply-To: <1369389050-118628-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Ewan Milne <emilne@redhat.com>, James Smart <james.smart@emulex.com>, Bryn Reeves <bmr@redhat.com>, Roland Dreier <roland@purestorage.com>, Hannes Reinecke <hare@suse.de>

Export some more functions which are used by the new FC timeout
handler.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/scsi/scsi_error.c | 5 ++++-
 drivers/scsi/scsi_lib.c   | 2 ++
 drivers/scsi/scsi_priv.h  | 2 ++
 3 files changed, 8 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
index bef6799e..f21ad7c 100644
--- a/drivers/scsi/scsi_error.c
+++ b/drivers/scsi/scsi_error.c
@@ -119,6 +119,7 @@ int scsi_eh_scmd_add(struct scsi_cmnd *scmd, int eh_flag)
 	spin_unlock_irqrestore(shost->host_lock, flags);
 	return ret;
 }
+EXPORT_SYMBOL_GPL(scsi_eh_scmd_add);
 
 /**
  * scsi_times_out - Timeout function for normal scsi commands.
@@ -659,13 +660,14 @@ static int scsi_try_bus_device_reset(struct scsi_cmnd *scmd)
 	return rtn;
 }
 
-static int scsi_try_to_abort_cmd(struct scsi_host_template *hostt, struct scsi_cmnd *scmd)
+int scsi_try_to_abort_cmd(struct scsi_host_template *hostt, struct scsi_cmnd *scmd)
 {
 	if (!hostt->eh_abort_handler)
 		return FAILED;
 
 	return hostt->eh_abort_handler(scmd);
 }
+EXPORT_SYMBOL_GPL(scsi_try_to_abort_cmd);
 
 static void scsi_abort_eh_cmnd(struct scsi_cmnd *scmd)
 {
@@ -1412,6 +1414,7 @@ int scsi_noretry_cmd(struct scsi_cmnd *scmd)
 
 	return 0;
 }
+EXPORT_SYMBOL_GPL(scsi_noretry_cmd);
 
 /**
  * scsi_decide_disposition - Disposition a cmd on return from LLD.
diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index a5515ec..7306aaa 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -210,6 +210,8 @@ void scsi_queue_insert(struct scsi_cmnd *cmd, int reason)
 {
 	__scsi_queue_insert(cmd, reason, 1);
 }
+EXPORT_SYMBOL_GPL(scsi_queue_insert);
+
 /**
  * scsi_execute - insert request and wait for the result
  * @sdev:	scsi device
diff --git a/drivers/scsi/scsi_priv.h b/drivers/scsi/scsi_priv.h
index 8f9a0ca..1d8d7d1 100644
--- a/drivers/scsi/scsi_priv.h
+++ b/drivers/scsi/scsi_priv.h
@@ -71,6 +71,8 @@ extern int scsi_error_handler(void *host);
 extern int scsi_decide_disposition(struct scsi_cmnd *cmd);
 extern void scsi_eh_wakeup(struct Scsi_Host *shost);
 extern int scsi_eh_scmd_add(struct scsi_cmnd *, int);
+extern int scsi_try_to_abort_cmd(struct scsi_host_template *hostt,
+				 struct scsi_cmnd *scmd);
 void scsi_eh_ready_devs(struct Scsi_Host *shost,
 			struct list_head *work_q,
 			struct list_head *done_q);
-- 
1.7.12.4

