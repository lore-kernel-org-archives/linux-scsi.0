From: "Ewan D. Milne" <emilne@redhat.com>
Subject: [PATCH] [SCSI] scsi_debug: fix deadlock on module unload, also complete queued commands
Date: Wed, 12 Dec 2012 12:00:47 -0500
Message-ID: <1355331647-6604-1-git-send-email-emilne@redhat.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:3585 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753996Ab2LLRAv (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 12 Dec 2012 12:00:51 -0500
Received: from int-mx12.intmail.prod.int.phx2.redhat.com (int-mx12.intmail.prod.int.phx2.redhat.com [10.5.11.25])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id qBCH0nVW024784
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-scsi@vger.kernel.org>; Wed, 12 Dec 2012 12:00:50 -0500
Received: from emilne.csb (dhcp-186-175.bos.redhat.com [10.16.186.175])
	by int-mx12.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP id qBCH0mJB005383
	for <linux-scsi@vger.kernel.org>; Wed, 12 Dec 2012 12:00:49 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

From: "Ewan D. Milne" <emilne@redhat.com>

The module unload path in scsi_debug was calling del_timer_sync() with the
queued_arr_lock held.  The timer_intr_handler() function also takes this lock,
so if it executes as the timer is being removed, the kernel would deadlock.

Also changed to complete all queued commands if scsi_debug is unloaded instead
of discarding them, because the requests would eventually timeout after the
module was gone.

Signed-off-by: Ewan D. Milne <emilne@redhat.com>
---
 drivers/scsi/scsi_debug.c | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
index 182d5a5..f10c1a9 100644
--- a/drivers/scsi/scsi_debug.c
+++ b/drivers/scsi/scsi_debug.c
@@ -2483,8 +2483,15 @@ static int stop_queued_cmnd(struct scsi_cmnd *cmnd)
 	for (k = 0; k < scsi_debug_max_queue; ++k) {
 		sqcp = &queued_arr[k];
 		if (sqcp->in_use && (cmnd == sqcp->a_cmnd)) {
+			spin_unlock_irqrestore(&queued_arr_lock, iflags);
 			del_timer_sync(&sqcp->cmnd_timer);
+			spin_lock_irqsave(&queued_arr_lock, iflags);
 			sqcp->in_use = 0;
+			if (sqcp->done_funct) {
+				sqcp->a_cmnd->result = sqcp->scsi_result;
+				sqcp->done_funct(sqcp->a_cmnd);
+			}
+			sqcp->done_funct = NULL;
 			sqcp->a_cmnd = NULL;
 			break;
 		}
@@ -2504,8 +2511,15 @@ static void stop_all_queued(void)
 	for (k = 0; k < scsi_debug_max_queue; ++k) {
 		sqcp = &queued_arr[k];
 		if (sqcp->in_use && sqcp->a_cmnd) {
+			spin_unlock_irqrestore(&queued_arr_lock, iflags);
 			del_timer_sync(&sqcp->cmnd_timer);
+			spin_lock_irqsave(&queued_arr_lock, iflags);
 			sqcp->in_use = 0;
+			if (sqcp->done_funct) {
+				sqcp->a_cmnd->result = sqcp->scsi_result;
+				sqcp->done_funct(sqcp->a_cmnd);
+			}
+			sqcp->done_funct = NULL;
 			sqcp->a_cmnd = NULL;
 		}
 	}
-- 
1.7.11.7

