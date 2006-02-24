From: Brian King <brking@us.ibm.com>
Subject: [PATCH 1/1] scsi: scsi command retries off by one fix
Date: Fri, 24 Feb 2006 17:10:04 -0600
Message-ID: <200602242310.k1ONA5HM019918@d01av03.pok.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e1.ny.us.ibm.com ([32.97.182.141]:38348 "EHLO e1.ny.us.ibm.com")
	by vger.kernel.org with ESMTP id S964780AbWBXXKH (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 24 Feb 2006 18:10:07 -0500
Received: from d01relay02.pok.ibm.com (d01relay02.pok.ibm.com [9.56.227.234])
	by e1.ny.us.ibm.com (8.12.11/8.12.11) with ESMTP id k1ONA5o2020783
	for <linux-scsi@vger.kernel.org>; Fri, 24 Feb 2006 18:10:05 -0500
Received: from d01av03.pok.ibm.com (d01av03.pok.ibm.com [9.56.224.217])
	by d01relay02.pok.ibm.com (8.12.10/NCO/VERS6.8) with ESMTP id k1ONA6Af228838
	for <linux-scsi@vger.kernel.org>; Fri, 24 Feb 2006 18:10:06 -0500
Received: from d01av03.pok.ibm.com (loopback [127.0.0.1])
	by d01av03.pok.ibm.com (8.12.11/8.13.3) with ESMTP id k1ONA583020019
	for <linux-scsi@vger.kernel.org>; Fri, 24 Feb 2006 18:10:06 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@steeleye.com
Cc: linux-scsi@vger.kernel.org, brking@us.ibm.com


Fix up an off by one error in calculating retries for scsi
commands. This bug was discovered when an SG_IO request
was sent to scsi core with retries = 0, causing the overall
timeout check to go off in scsi_softirq_done.

Signed-off-by: Brian King <brking@us.ibm.com>
---

 linux-2.6-bjking1/drivers/scsi/scsi_error.c |    4 ++--
 linux-2.6-bjking1/drivers/scsi/scsi_lib.c   |    2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff -puN drivers/scsi/scsi_lib.c~scsi_fixup_retries drivers/scsi/scsi_lib.c
--- linux-2.6/drivers/scsi/scsi_lib.c~scsi_fixup_retries	2006-02-24 13:53:28.000000000 -0600
+++ linux-2.6-bjking1/drivers/scsi/scsi_lib.c	2006-02-24 13:53:47.000000000 -0600
@@ -1498,7 +1498,7 @@ static void scsi_kill_request(struct req
 static void scsi_softirq_done(struct request *rq)
 {
 	struct scsi_cmnd *cmd = rq->completion_data;
-	unsigned long wait_for = cmd->allowed * cmd->timeout_per_command;
+	unsigned long wait_for = (cmd->allowed + 1) * cmd->timeout_per_command;
 	int disposition;
 
 	INIT_LIST_HEAD(&cmd->eh_entry);
diff -puN drivers/scsi/scsi_error.c~scsi_fixup_retries drivers/scsi/scsi_error.c
--- linux-2.6/drivers/scsi/scsi_error.c~scsi_fixup_retries	2006-02-24 13:53:51.000000000 -0600
+++ linux-2.6-bjking1/drivers/scsi/scsi_error.c	2006-02-24 14:50:34.000000000 -0600
@@ -1308,7 +1308,7 @@ int scsi_decide_disposition(struct scsi_
 	 * the request was not marked fast fail.  Note that above,
 	 * even if the request is marked fast fail, we still requeue
 	 * for queue congestion conditions (QUEUE_FULL or BUSY) */
-	if ((++scmd->retries) < scmd->allowed 
+	if ((++scmd->retries) <= scmd->allowed
 	    && !blk_noretry_request(scmd->request)) {
 		return NEEDS_RETRY;
 	} else {
@@ -1433,7 +1433,7 @@ static void scsi_eh_flush_done_q(struct 
 		list_del_init(&scmd->eh_entry);
 		if (scsi_device_online(scmd->device) &&
 		    !blk_noretry_request(scmd->request) &&
-		    (++scmd->retries < scmd->allowed)) {
+		    (++scmd->retries <= scmd->allowed)) {
 			SCSI_LOG_ERROR_RECOVERY(3, printk("%s: flush"
 							  " retry cmd: %p\n",
 							  current->comm,
_
