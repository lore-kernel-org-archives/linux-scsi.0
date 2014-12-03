From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 01/12] advansys: use host_reset
Date: Wed,  3 Dec 2014 12:44:54 +0100
Message-ID: <1417607105-85455-2-git-send-email-hare@suse.de>
References: <1417607105-85455-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:55169 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753231AbaLCLpK (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 3 Dec 2014 06:45:10 -0500
In-Reply-To: <1417607105-85455-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <jbottomley@parallels.com>
Cc: Christoph Hellwig <hch@lst.de>, Matthew Wilcox <matthew@wil.cx>, Doug Gilbert <dgilbert@interlog.com>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>

The advansys_reset() function is actually a host reset, not a
bus reset.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/scsi/advansys.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/advansys.c b/drivers/scsi/advansys.c
index 6719a33..d9b27ca 100644
--- a/drivers/scsi/advansys.c
+++ b/drivers/scsi/advansys.c
@@ -2079,9 +2079,9 @@ do { \
  *      ADV_TRUE(1) - Queue was successfully aborted.
  *      ADV_FALSE(0) - Queue was not found on the active queue list.
  */
-#define AdvAbortQueue(asc_dvc, scsiq) \
+#define AdvAbortQueue(asc_dvc, srb_tag) \
         AdvSendIdleCmd((asc_dvc), (ushort) IDLE_CMD_ABORT, \
-                       (ADV_DCNT) (scsiq))
+                       (ADV_DCNT) (srb_tag))
 
 /*
  * Send a Bus Device Reset Message to the specified target ID.
@@ -11250,7 +11250,7 @@ static struct scsi_host_template advansys_template = {
 	.name = DRV_NAME,
 	.info = advansys_info,
 	.queuecommand = advansys_queuecommand,
-	.eh_bus_reset_handler = advansys_reset,
+	.eh_host_reset_handler = advansys_reset,
 	.bios_param = advansys_biosparam,
 	.slave_configure = advansys_slave_configure,
 	/*
-- 
1.8.5.2

