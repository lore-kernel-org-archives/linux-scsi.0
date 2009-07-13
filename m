From: Christof Schmitt <christof.schmitt@de.ibm.com>
Subject: [patch 09/13] zfcp: Recover from stalled outbound queue
Date: Mon, 13 Jul 2009 15:06:10 +0200
Message-ID: <20090713131043.854942000@de.ibm.com>
References: <20090713130601.304914000@de.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate3.de.ibm.com ([195.212.29.152]:36200 "EHLO
	mtagate3.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755846AbZGMNKz (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 13 Jul 2009 09:10:55 -0400
Content-Disposition: inline; filename=715-zfcp-outbound-queue.diff
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi@vger.kernel.org, linux-s390@vger.kernel.org, schwidefsky@de.ibm.com, heiko.carstens@de.ibm.com, Christof Schmitt <christof.schmitt@de.ibm.com>

From: Christof Schmitt <christof.schmitt@de.ibm.com>

Depending on interruptions on some storage systems, the complete
channel can stall which looks like an outbound queue stall to Linux.
When trying to acquire a free SBAL for a non-SCSI command, zfcp waits
for 5 seconds for a free slot to appear. This is the right place to
detect a queue stall: If the wait times out, we assume a stalled queue
and try to recover this. 

The overall strategy should be to trigger the erp from specific
events, and not try an overall escalation from one failed port to a
full-blown queue recovery. If we manage to send a command, the status
codes for this command or a timeout will trigger the right follow-on
actions.

Reviewed-by: Swen Schillig <swen@vnet.ibm.com>
Signed-off-by: Christof Schmitt <christof.schmitt@de.ibm.com>
---

 drivers/s390/scsi/zfcp_fsf.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/drivers/s390/scsi/zfcp_fsf.c	2009-07-13 13:18:08.000000000 +0200
+++ b/drivers/s390/scsi/zfcp_fsf.c	2009-07-13 13:18:10.000000000 +0200
@@ -670,8 +670,11 @@ static int zfcp_fsf_req_sbal_get(struct 
 			       zfcp_fsf_sbal_check(adapter), 5 * HZ);
 	if (ret > 0)
 		return 0;
-	if (!ret)
+	if (!ret) {
 		atomic_inc(&adapter->qdio_outb_full);
+		/* assume hanging outbound queue, try queue recovery */
+		zfcp_erp_adapter_reopen(adapter, 0, "fsrsg_1", NULL);
+	}
 
 	spin_lock_bh(&adapter->req_q_lock);
 	return -EIO;

