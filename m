From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 2/2] scsi_transport_fc: Implement 'async_user_scan' module parameter
Date: Mon, 22 Feb 2016 08:51:02 +0100
Message-ID: <1456127462-2817-3-git-send-email-hare@suse.de>
References: <1456127462-2817-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:49217 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753720AbcBVHvV (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 22 Feb 2016 02:51:21 -0500
In-Reply-To: <1456127462-2817-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, James Bottomley <james.bottomley@hansenpartnership.com>, Johannes Thumshirn <jthumshirn@suse.com>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>

When invoking a scan via the sysfs 'scan' attribute the process
will be blocked until the scan is completed, which can take a
very long time on large installations.
Enabling the 'async_user_scan' parameter moves the actual
LUN scanning to a workqueue, thereby unblocking the process.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/scsi/scsi_transport_fc.c | 29 +++++++++++++++++++++++++++--
 1 file changed, 27 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/scsi_transport_fc.c b/drivers/scsi/scsi_transport_fc.c
index 90228b4..3afe60a9 100644
--- a/drivers/scsi/scsi_transport_fc.c
+++ b/drivers/scsi/scsi_transport_fc.c
@@ -82,6 +82,21 @@ MODULE_PARM_DESC(disable_target_scan,
 		 "Disable target scan on remote ports (default=0)");
 
 /*
+ * async_user_scan: make 'scan' sysfs attribute asynchronous
+ *   on larger installations scanning can take a very long time
+ *   during which the process invoking the scan will be blocked
+ *   on writing to the 'scan' attribute. Enabling this attribute
+ *   will move scanning to a work queue, allowing the process
+ *   to return immediately.
+ */
+static bool fc_async_user_scan;
+
+module_param_named(async_user_scan, fc_async_user_scan,
+		   bool, S_IRUGO|S_IWUSR);
+MODULE_PARM_DESC(async_user_scan,
+		 "Allow for asynchronous user LUN scanning (default=0)");
+
+/*
  * Redefine so that we can have same named attributes in the
  * sdev/starget/host objects.
  */
@@ -2121,8 +2136,18 @@ fc_user_scan_tgt(struct Scsi_Host *shost, uint channel, uint id, u64 lun)
 
 		if ((channel == rport->channel) &&
 		    (id == rport->scsi_target_id)) {
-			spin_unlock_irqrestore(shost->host_lock, flags);
-			scsi_scan_target(&rport->dev, channel, id, lun, 1);
+			if (lun == SCAN_WILD_CARD &&
+			    fc_async_user_scan) {
+				if (!(rport->flags & FC_RPORT_SCAN_PENDING)) {
+					rport->flags |= FC_RPORT_SCAN_PENDING;
+					scsi_queue_work(shost,
+							&rport->scan_work);
+				}
+				spin_unlock_irqrestore(shost->host_lock, flags);
+			} else {
+				spin_unlock_irqrestore(shost->host_lock, flags);
+				scsi_scan_target(&rport->dev, channel, id, lun, 1);
+			}
 			return;
 		}
 	}
-- 
2.6.2

