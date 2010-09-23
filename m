From: michaelc@cs.wisc.edu
Subject: [RFC PATCH 2/7] fc class: remove fc_flush_work in fc_remote_port_add
Date: Thu, 23 Sep 2010 00:17:20 -0500
Message-ID: <1285219045-14645-3-git-send-email-michaelc@cs.wisc.edu>
References: <1285219045-14645-1-git-send-email-michaelc@cs.wisc.edu>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:56158 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752899Ab0IWFLl (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 23 Sep 2010 01:11:41 -0400
In-Reply-To: <1285219045-14645-1-git-send-email-michaelc@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Mike Christie <michaelc@cs.wisc.edu>

From: Mike Christie <michaelc@cs.wisc.edu>

With the last patch, if a remote port is matched in
fc_remote_port_add we will call cancel_work_sync on the
rport's stgt_delete_work before completing the rport addition.
So unless we wanted to wait for other rport's stgt_delete_work
to complete before adding a rport then the fc_flush_work is
not needed, and this patch removes it.

Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
---
 drivers/scsi/scsi_transport_fc.c |   21 ---------------------
 1 files changed, 0 insertions(+), 21 deletions(-)

diff --git a/drivers/scsi/scsi_transport_fc.c b/drivers/scsi/scsi_transport_fc.c
index d43f69a..3982a2b 100644
--- a/drivers/scsi/scsi_transport_fc.c
+++ b/drivers/scsi/scsi_transport_fc.c
@@ -2257,24 +2257,6 @@ fc_queue_work(struct Scsi_Host *shost, struct work_struct *work)
 }
 
 /**
- * fc_flush_work - Flush a fc_host's workqueue.
- * @shost:	Pointer to Scsi_Host bound to fc_host.
- */
-static void
-fc_flush_work(struct Scsi_Host *shost)
-{
-	if (!fc_host_work_q(shost)) {
-		printk(KERN_ERR
-			"ERROR: FC host '%s' attempted to flush work, "
-			"when no workqueue created.\n", shost->hostt->name);
-		dump_stack();
-		return;
-	}
-
-	flush_workqueue(fc_host_work_q(shost));
-}
-
-/**
  * fc_queue_devloss_work - Schedule work for the fc_host devloss workqueue.
  * @shost:	Pointer to Scsi_Host bound to fc_host.
  * @work:	Work to queue for execution.
@@ -2637,9 +2619,6 @@ fc_remote_port_add(struct Scsi_Host *shost, int channel,
 	unsigned long flags;
 	int match = 0;
 
-	/* ensure any stgt delete functions are done */
-	fc_flush_work(shost);
-
 	/*
 	 * Search the list of "active" rports, for an rport that has been
 	 * deleted, but we've held off the real delete while the target
-- 
1.7.2.2

