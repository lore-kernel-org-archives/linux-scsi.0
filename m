From: Hannes Reinecke <hare@suse.de>
Subject: [PATCHv2] scsi: disable automatic target scan
Date: Tue, 15 Mar 2016 08:19:42 +0100
Message-ID: <1458026382-43338-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:52677 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932557AbcCOHTp (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 15 Mar 2016 03:19:45 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, James Bottomley <james.bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>

On larger installations it is useful to disable automatic LUN
scanning, and only add the required LUNs via udev rules.
This can speed up bootup dramatically.

This patch introduces a new scan module parameter value 'manual',
which works like 'none', but can be overriden by setting the 'rescan'
value from scsi_scan_target to 'SCSI_SCAN_MANUAL'.
And it updates all relevant callers to set the 'rescan' value
to 'SCSI_SCAN_MANUAL' if invoked via the 'scan' option in sysfs.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/scsi/scsi_scan.c            | 25 ++++++++++++++++++-------
 drivers/scsi/scsi_sysfs.c           |  3 ++-
 drivers/scsi/scsi_transport_fc.c    |  3 ++-
 drivers/scsi/scsi_transport_iscsi.c |  2 +-
 drivers/scsi/scsi_transport_sas.c   |  4 ++--
 include/scsi/scsi_device.h          |  6 ++++++
 6 files changed, 31 insertions(+), 12 deletions(-)

diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
index 97074c9..54dc517 100644
--- a/drivers/scsi/scsi_scan.c
+++ b/drivers/scsi/scsi_scan.c
@@ -96,10 +96,13 @@ MODULE_PARM_DESC(max_luns,
 #define SCSI_SCAN_TYPE_DEFAULT "sync"
 #endif
 
-char scsi_scan_type[6] = SCSI_SCAN_TYPE_DEFAULT;
+char scsi_scan_type[7] = SCSI_SCAN_TYPE_DEFAULT;
 
-module_param_string(scan, scsi_scan_type, sizeof(scsi_scan_type), S_IRUGO);
-MODULE_PARM_DESC(scan, "sync, async or none");
+module_param_string(scan, scsi_scan_type, sizeof(scsi_scan_type),
+		    S_IRUGO|S_IWUSR);
+MODULE_PARM_DESC(scan, "sync, async, manual, or none. "
+		 "Setting to 'manual' disables automatic scanning, but allows "
+		 "for manual device scan via the 'scan' sysfs attribute.");
 
 static unsigned int scsi_inq_timeout = SCSI_TIMEOUT/HZ + 18;
 
@@ -1040,7 +1043,8 @@ static unsigned char *scsi_inq_str(unsigned char *buf, unsigned char *inq,
  * @lun:	LUN of target device
  * @bflagsp:	store bflags here if not NULL
  * @sdevp:	probe the LUN corresponding to this scsi_device
- * @rescan:     if nonzero skip some code only needed on first scan
+ * @rescan:     if greater than SCSI_SCAN_NONE skip some code only
+ *              needed on first scan
  * @hostdata:	passed to scsi_alloc_sdev()
  *
  * Description:
@@ -1069,7 +1073,7 @@ static int scsi_probe_and_add_lun(struct scsi_target *starget,
 	 */
 	sdev = scsi_device_lookup_by_target(starget, lun);
 	if (sdev) {
-		if (rescan || !scsi_device_created(sdev)) {
+		if (rescan > SCSI_SCAN_NONE || !scsi_device_created(sdev)) {
 			SCSI_LOG_SCAN_BUS(3, sdev_printk(KERN_INFO, sdev,
 				"scsi scan: device exists on %s\n",
 				dev_name(&sdev->sdev_gendev)));
@@ -1604,7 +1608,9 @@ static void __scsi_scan_target(struct device *parent, unsigned int channel,
  * @channel:	channel to scan
  * @id:		target id to scan
  * @lun:	Specific LUN to scan or SCAN_WILD_CARD
- * @rescan:	passed to LUN scanning routines
+ * @rescan:	passed to LUN scanning routines; SCSI_SCAN_NONE for no rescan,
+ *              SCSI_SCAN_RESCAN to rescan existing LUNs, and SCSI_SCAN_MANUAL
+ *              to force scanning even if 'scan=manual' is set.
  *
  * Description:
  *     Scan the target id on @parent, @channel, and @id. Scan at least LUN 0,
@@ -1621,6 +1627,10 @@ void scsi_scan_target(struct device *parent, unsigned int channel,
 	if (strncmp(scsi_scan_type, "none", 4) == 0)
 		return;
 
+	if (rescan < SCSI_SCAN_MANUAL &&
+	    strncmp(scsi_scan_type, "manual", 6) == 0)
+		return;
+
 	mutex_lock(&shost->scan_mutex);
 	if (!shost->async_scan)
 		scsi_complete_async_scans();
@@ -1844,7 +1854,8 @@ void scsi_scan_host(struct Scsi_Host *shost)
 {
 	struct async_scan_data *data;
 
-	if (strncmp(scsi_scan_type, "none", 4) == 0)
+	if (strncmp(scsi_scan_type, "none", 4) == 0 ||
+	    strncmp(scsi_scan_type, "manual", 6) == 0)
 		return;
 	if (scsi_autopm_get_host(shost) < 0)
 		return;
diff --git a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
index 92ffd24..3b2045f 100644
--- a/drivers/scsi/scsi_sysfs.c
+++ b/drivers/scsi/scsi_sysfs.c
@@ -143,7 +143,8 @@ static int scsi_scan(struct Scsi_Host *shost, const char *str)
 	if (shost->transportt->user_scan)
 		res = shost->transportt->user_scan(shost, channel, id, lun);
 	else
-		res = scsi_scan_host_selected(shost, channel, id, lun, 1);
+		res = scsi_scan_host_selected(shost, channel, id, lun,
+					      SCSI_SCAN_MANUAL);
 	return res;
 }
 
diff --git a/drivers/scsi/scsi_transport_fc.c b/drivers/scsi/scsi_transport_fc.c
index 8a88226..3482a55 100644
--- a/drivers/scsi/scsi_transport_fc.c
+++ b/drivers/scsi/scsi_transport_fc.c
@@ -2110,7 +2110,8 @@ fc_user_scan_tgt(struct Scsi_Host *shost, uint channel, uint id, u64 lun)
 		if ((channel == rport->channel) &&
 		    (id == rport->scsi_target_id)) {
 			spin_unlock_irqrestore(shost->host_lock, flags);
-			scsi_scan_target(&rport->dev, channel, id, lun, 1);
+			scsi_scan_target(&rport->dev, channel, id, lun,
+					 SCSI_SCAN_MANUAL);
 			return;
 		}
 	}
diff --git a/drivers/scsi/scsi_transport_iscsi.c b/drivers/scsi/scsi_transport_iscsi.c
index 4414816..f4c16dc 100644
--- a/drivers/scsi/scsi_transport_iscsi.c
+++ b/drivers/scsi/scsi_transport_iscsi.c
@@ -1819,7 +1819,7 @@ static int iscsi_user_scan_session(struct device *dev, void *data)
 		    (scan_data->id == SCAN_WILD_CARD ||
 		     scan_data->id == id))
 			scsi_scan_target(&session->dev, 0, id,
-					 scan_data->lun, 1);
+					 scan_data->lun, SCSI_SCAN_MANUAL);
 	}
 
 user_scan_exit:
diff --git a/drivers/scsi/scsi_transport_sas.c b/drivers/scsi/scsi_transport_sas.c
index b6f958193..d8d38e6 100644
--- a/drivers/scsi/scsi_transport_sas.c
+++ b/drivers/scsi/scsi_transport_sas.c
@@ -1739,8 +1739,8 @@ static int sas_user_scan(struct Scsi_Host *shost, uint channel,
 
 		if ((channel == SCAN_WILD_CARD || channel == 0) &&
 		    (id == SCAN_WILD_CARD || id == rphy->scsi_target_id)) {
-			scsi_scan_target(&rphy->dev, 0,
-					 rphy->scsi_target_id, lun, 1);
+			scsi_scan_target(&rphy->dev, 0, rphy->scsi_target_id,
+					 lun, SCSI_SCAN_MANUAL);
 		}
 	}
 	mutex_unlock(&sas_host->lock);
diff --git a/include/scsi/scsi_device.h b/include/scsi/scsi_device.h
index c067019..f954272 100644
--- a/include/scsi/scsi_device.h
+++ b/include/scsi/scsi_device.h
@@ -50,6 +50,12 @@ enum scsi_device_state {
 	SDEV_CREATED_BLOCK,	/* same as above but for created devices */
 };
 
+enum scsi_scan_mode {
+	SCSI_SCAN_NONE = 0,
+	SCSI_SCAN_RESCAN,
+	SCSI_SCAN_MANUAL,
+};
+
 enum scsi_device_event {
 	SDEV_EVT_MEDIA_CHANGE	= 1,	/* media has changed */
 	SDEV_EVT_INQUIRY_CHANGE_REPORTED,		/* 3F 03  UA reported */
-- 
1.8.5.6

