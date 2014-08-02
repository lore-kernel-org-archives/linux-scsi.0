From: Ari Sundholm <asundhol@cs.hut.fi>
Subject: [PATCH] scsi/arcmsr: Add timeout module parameter
Date: Sat, 2 Aug 2014 22:42:06 +0300 (EEST)
Message-ID: <alpine.GSO.2.00.1408022058560.609@hutcs>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.cs.hut.fi ([130.233.192.7]:41167 "EHLO mail.cs.hut.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754735AbaHBTwP (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 2 Aug 2014 15:52:15 -0400
Received: from hutcs (hutcs.cs.hut.fi [130.233.192.10])
	by mail.cs.hut.fi (Postfix) with ESMTPS id C2608308A76
	for <linux-scsi@vger.kernel.org>; Sat,  2 Aug 2014 22:42:06 +0300 (EEST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

From: Ari Sundholm <asundhol@cs.hut.fi>

Backported from Areca's current version of the driver.

Signed-off-by: Ari Sundholm <asundhol@cs.hut.fi>
---
 drivers/scsi/arcmsr/arcmsr_hba.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/drivers/scsi/arcmsr/arcmsr_hba.c b/drivers/scsi/arcmsr/arcmsr_hba.c
index 652b41b..e79b62b 100644
--- a/drivers/scsi/arcmsr/arcmsr_hba.c
+++ b/drivers/scsi/arcmsr/arcmsr_hba.c
@@ -79,6 +79,9 @@ MODULE_VERSION(ARCMSR_DRIVER_VERSION);
 #define	ARCMSR_RETRYCOUNT	12
 
 wait_queue_head_t wait_q;
+static int timeout;
+module_param(timeout, int, 0644);
+MODULE_PARM_DESC(timeout, " scsi cmd timeout value (0 - 120 sec.)");
 static int arcmsr_iop_message_xfer(struct AdapterControlBlock *acb,
 					struct scsi_cmnd *cmd);
 static int arcmsr_iop_confirm(struct AdapterControlBlock *acb);
@@ -1151,6 +1154,14 @@ static int arcmsr_build_ccb(struct AdapterControlBlock *acb,
 	if (pcmd->sc_data_direction == DMA_TO_DEVICE)
 		arcmsr_cdb->Flags |= ARCMSR_CDB_FLAG_WRITE;
 	ccb->arc_cdb_size = arccdbsize;
+
+	if (timeout) {
+		pcmd->request->deadline = jiffies + timeout * HZ;
+		if (pcmd->device->request_queue->timeout.function)
+			mod_timer(&pcmd->device->request_queue->timeout,
+			          pcmd->request->deadline);
+	}
+
 	return SUCCESS;
 }
 
-- 
1.9.1
