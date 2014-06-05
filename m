From: Liu Ping Fan <kernelfans@gmail.com>
Subject: [PATCH] scsi: ibmvscsi: protect abort handler from done-scmd in flight
Date: Thu,  5 Jun 2014 14:16:44 +0800
Message-ID: <1401949004-17725-1-git-send-email-pingfank@linux.vnet.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-yk0-f181.google.com ([209.85.160.181]:45416 "EHLO
	mail-yk0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750809AbaFEGNo (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 5 Jun 2014 02:13:44 -0400
Received: by mail-yk0-f181.google.com with SMTP id 131so435079ykp.26
        for <linux-scsi@vger.kernel.org>; Wed, 04 Jun 2014 23:13:43 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Robert Jennings <rcj@linux.vnet.ibm.com>, Paolo Bonzini <pbonzini@redhat.com>

Take the following scene in guest:
seqA: scsi_done() -> gapX (before taking REQ_ATOM_COMPLETE)
seqB: scmd_eh_abort_handler()-> ...-> ibmvscsi_eh_abort_handler()->
      ...->scsi_put_command(scmd)

If seqA is scheduled at gapX, and seqB reclaims scmd. Then when seqA
comes back, it tries to access the scmd when is turned back to mempool.

This patch fixes the race by ensuring when ibmvscsi_eh_abort_handler()
returns, no scsi_done is in flight

Signed-off-by: Liu Ping Fan <pingfank@linux.vnet.ibm.com>
---
When trying to figure the scsi_cmnd in flight issue, I learned from Paolo (thanks).
He showed me the way how virtscsi resolves the race between abort-handler
and scsi_done in flight. And I think that this method is also needed by ibmvscsi.
---
 drivers/scsi/ibmvscsi/ibmvscsi.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/ibmvscsi/ibmvscsi.c b/drivers/scsi/ibmvscsi/ibmvscsi.c
index fa76440..325cef6 100644
--- a/drivers/scsi/ibmvscsi/ibmvscsi.c
+++ b/drivers/scsi/ibmvscsi/ibmvscsi.c
@@ -1828,16 +1828,19 @@ static void ibmvscsi_handle_crq(struct viosrp_crq *crq,
 
 	if ((crq->status != VIOSRP_OK && crq->status != VIOSRP_OK2) && evt_struct->cmnd)
 		evt_struct->cmnd->result = DID_ERROR << 16;
-	if (evt_struct->done)
-		evt_struct->done(evt_struct);
-	else
-		dev_err(hostdata->dev, "returned done() is NULL; not running it!\n");
 
 	/*
 	 * Lock the host_lock before messing with these structures, since we
 	 * are running in a task context
+	 * Also, this lock helps ibmvscsi_eh_abort_handler() to shield the
+	 * scsi_done() in flight.
 	 */
 	spin_lock_irqsave(evt_struct->hostdata->host->host_lock, flags);
+	if (evt_struct->done)
+		evt_struct->done(evt_struct);
+	else
+		dev_err(hostdata->dev, "returned done() is NULL; not running it!\n");
+
 	list_del(&evt_struct->list);
 	free_event_struct(&evt_struct->hostdata->pool, evt_struct);
 	spin_unlock_irqrestore(evt_struct->hostdata->host->host_lock, flags);
-- 
1.8.1.4

