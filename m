From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 1/2] scsi_transport_fc: implement 'disable_target_scan' module parameter
Date: Mon, 22 Feb 2016 08:51:01 +0100
Message-ID: <1456127462-2817-2-git-send-email-hare@suse.de>
References: <1456127462-2817-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:49215 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753719AbcBVHvV (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 22 Feb 2016 02:51:21 -0500
In-Reply-To: <1456127462-2817-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, James Bottomley <james.bottomley@hansenpartnership.com>, Johannes Thumshirn <jthumshirn@suse.com>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>

On larger installations it makes sense to disable the target scan
per default on boot, and scan the required LUNs directly via udev
rules.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/scsi/scsi_transport_fc.c | 18 +++++++++++++++++-
 1 file changed, 17 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/scsi_transport_fc.c b/drivers/scsi/scsi_transport_fc.c
index 8a88226..90228b4 100644
--- a/drivers/scsi/scsi_transport_fc.c
+++ b/drivers/scsi/scsi_transport_fc.c
@@ -70,6 +70,18 @@ MODULE_PARM_DESC(dev_loss_tmo,
 		 " fast_io_fail_tmo is not set.");
 
 /*
+ * disable_target_scan: Disable target scan per default
+ *   useful on larger installations where only a small
+ *   number of LUNs are required for booting.
+ */
+static bool fc_disable_target_scan;
+
+module_param_named(disable_target_scan, fc_disable_target_scan,
+		   bool, S_IRUGO|S_IWUSR);
+MODULE_PARM_DESC(disable_target_scan,
+		 "Disable target scan on remote ports (default=0)");
+
+/*
  * Redefine so that we can have same named attributes in the
  * sdev/starget/host objects.
  */
@@ -3272,10 +3284,14 @@ fc_scsi_scan_rport(struct work_struct *work)
 	struct Scsi_Host *shost = rport_to_shost(rport);
 	struct fc_internal *i = to_fc_internal(shost->transportt);
 	unsigned long flags;
+	bool disable_target_scan;
+
+	disable_target_scan = fc_disable_target_scan ?
+		fc_disable_target_scan : i->f->disable_target_scan;
 
 	if ((rport->port_state == FC_PORTSTATE_ONLINE) &&
 	    (rport->roles & FC_PORT_ROLE_FCP_TARGET) &&
-	    !(i->f->disable_target_scan)) {
+	    !disable_target_scan) {
 		scsi_scan_target(&rport->dev, rport->channel,
 			rport->scsi_target_id, SCAN_WILD_CARD, 1);
 	}
-- 
2.6.2

