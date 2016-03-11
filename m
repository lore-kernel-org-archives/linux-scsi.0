From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH] scsi: disable automatic target scan
Date: Fri, 11 Mar 2016 16:33:40 +0100
Message-ID: <1457710420-37769-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:36156 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932486AbcCKPdo (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 11 Mar 2016 10:33:44 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, James Bottomley <james.bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>

On larger installations it is useful to disable automatic LUN
scanning, and only add the required LUNs via udev rules.
This can speed up bootup dramatically.

This patch introduces a scan_type 'disabled', which work like
'none', but can be overriden by setting the 'rescan' value
from scsi_scan_target to '2'.
And it updates all relevant callers to set the 'rescan' value
to '2' if invoked via the 'scan' option in sysfs.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/scsi/scsi_scan.c            | 17 ++++++++++++-----
 drivers/scsi/scsi_sysfs.c           |  2 +-
 drivers/scsi/scsi_transport_fc.c    |  2 +-
 drivers/scsi/scsi_transport_iscsi.c |  2 +-
 drivers/scsi/scsi_transport_sas.c   |  2 +-
 5 files changed, 16 insertions(+), 9 deletions(-)

diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
index 97074c9..929204b 100644
--- a/drivers/scsi/scsi_scan.c
+++ b/drivers/scsi/scsi_scan.c
@@ -96,10 +96,11 @@ MODULE_PARM_DESC(max_luns,
 #define SCSI_SCAN_TYPE_DEFAULT "sync"
 #endif
 
-char scsi_scan_type[6] = SCSI_SCAN_TYPE_DEFAULT;
+char scsi_scan_type[9] = SCSI_SCAN_TYPE_DEFAULT;
 
-module_param_string(scan, scsi_scan_type, sizeof(scsi_scan_type), S_IRUGO);
-MODULE_PARM_DESC(scan, "sync, async or none");
+module_param_string(scan, scsi_scan_type, sizeof(scsi_scan_type),
+		    S_IRUGO|S_IWUSR);
+MODULE_PARM_DESC(scan, "sync, async, disabled, or none");
 
 static unsigned int scsi_inq_timeout = SCSI_TIMEOUT/HZ + 18;
 
@@ -1604,7 +1605,9 @@ static void __scsi_scan_target(struct device *parent, unsigned int channel,
  * @channel:	channel to scan
  * @id:		target id to scan
  * @lun:	Specific LUN to scan or SCAN_WILD_CARD
- * @rescan:	passed to LUN scanning routines
+ * @rescan:	passed to LUN scanning routines; 0 for no rescan, 1 to rescan
+ *              existing LUNs, and 2 to override any 'scan_disabled' setting
+ *              from the host.
  *
  * Description:
  *     Scan the target id on @parent, @channel, and @id. Scan at least LUN 0,
@@ -1621,6 +1624,9 @@ void scsi_scan_target(struct device *parent, unsigned int channel,
 	if (strncmp(scsi_scan_type, "none", 4) == 0)
 		return;
 
+	if (rescan < 2 && strncmp(scsi_scan_type, "disabled", 8) == 0)
+		return;
+
 	mutex_lock(&shost->scan_mutex);
 	if (!shost->async_scan)
 		scsi_complete_async_scans();
@@ -1844,7 +1850,8 @@ void scsi_scan_host(struct Scsi_Host *shost)
 {
 	struct async_scan_data *data;
 
-	if (strncmp(scsi_scan_type, "none", 4) == 0)
+	if (strncmp(scsi_scan_type, "none", 4) == 0 ||
+	    strncmp(scsi_scan_type, "disabled", 8) == 0)
 		return;
 	if (scsi_autopm_get_host(shost) < 0)
 		return;
diff --git a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
index 92ffd24..d805d55 100644
--- a/drivers/scsi/scsi_sysfs.c
+++ b/drivers/scsi/scsi_sysfs.c
@@ -143,7 +143,7 @@ static int scsi_scan(struct Scsi_Host *shost, const char *str)
 	if (shost->transportt->user_scan)
 		res = shost->transportt->user_scan(shost, channel, id, lun);
 	else
-		res = scsi_scan_host_selected(shost, channel, id, lun, 1);
+		res = scsi_scan_host_selected(shost, channel, id, lun, 2);
 	return res;
 }
 
diff --git a/drivers/scsi/scsi_transport_fc.c b/drivers/scsi/scsi_transport_fc.c
index 8a88226..018b2da 100644
--- a/drivers/scsi/scsi_transport_fc.c
+++ b/drivers/scsi/scsi_transport_fc.c
@@ -2110,7 +2110,7 @@ fc_user_scan_tgt(struct Scsi_Host *shost, uint channel, uint id, u64 lun)
 		if ((channel == rport->channel) &&
 		    (id == rport->scsi_target_id)) {
 			spin_unlock_irqrestore(shost->host_lock, flags);
-			scsi_scan_target(&rport->dev, channel, id, lun, 1);
+			scsi_scan_target(&rport->dev, channel, id, lun, 2);
 			return;
 		}
 	}
diff --git a/drivers/scsi/scsi_transport_iscsi.c b/drivers/scsi/scsi_transport_iscsi.c
index 4414816..2941598 100644
--- a/drivers/scsi/scsi_transport_iscsi.c
+++ b/drivers/scsi/scsi_transport_iscsi.c
@@ -1819,7 +1819,7 @@ static int iscsi_user_scan_session(struct device *dev, void *data)
 		    (scan_data->id == SCAN_WILD_CARD ||
 		     scan_data->id == id))
 			scsi_scan_target(&session->dev, 0, id,
-					 scan_data->lun, 1);
+					 scan_data->lun, 2);
 	}
 
 user_scan_exit:
diff --git a/drivers/scsi/scsi_transport_sas.c b/drivers/scsi/scsi_transport_sas.c
index deb3fde..1e0664f 100644
--- a/drivers/scsi/scsi_transport_sas.c
+++ b/drivers/scsi/scsi_transport_sas.c
@@ -1740,7 +1740,7 @@ static int sas_user_scan(struct Scsi_Host *shost, uint channel,
 		if ((channel == SCAN_WILD_CARD || channel == 0) &&
 		    (id == SCAN_WILD_CARD || id == rphy->scsi_target_id)) {
 			scsi_scan_target(&rphy->dev, 0,
-					 rphy->scsi_target_id, lun, 1);
+					 rphy->scsi_target_id, lun, 2);
 		}
 	}
 	mutex_unlock(&sas_host->lock);
-- 
1.8.5.6

