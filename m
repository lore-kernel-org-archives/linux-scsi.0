From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 4/5] scsi_dh_alua: add 'state' callback function
Date: Wed,  8 Jul 2015 13:09:47 +0200
Message-ID: <1436353788-104911-5-git-send-email-hare@suse.de>
References: <1436353788-104911-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:45662 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933801AbbGHLJw (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 8 Jul 2015 07:09:52 -0400
In-Reply-To: <1436353788-104911-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <james.bottomley@hansenpartnership.com>
Cc: Bart van Assche <bart.vanassche@sandisk.com>, Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org, Ewan Milne <emilne@redhat.com>, Hannes Reinecke <hare@suse.de>

Add a 'state' callback function to display the current path
status in sysfs.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/scsi/device_handler/scsi_dh_alua.c | 47 ++++++++++++++++++++++++++++++
 1 file changed, 47 insertions(+)

diff --git a/drivers/scsi/device_handler/scsi_dh_alua.c b/drivers/scsi/device_handler/scsi_dh_alua.c
index 5b52017..99c4b0f 100644
--- a/drivers/scsi/device_handler/scsi_dh_alua.c
+++ b/drivers/scsi/device_handler/scsi_dh_alua.c
@@ -1182,6 +1182,52 @@ static void alua_check(struct scsi_device *sdev, bool force)
 }
 
 /*
+ * alua_state - report path status
+ * @sdev: device on the path to be checked
+ *
+ * Check the device status
+ */
+static int alua_state(struct scsi_device *sdev)
+{
+	struct alua_dh_data *h = sdev->handler_data;
+	struct alua_port_group *pg = NULL;
+	int access_state = SCSI_ACCESS_STATE_UNKNOWN;
+
+	rcu_read_lock();
+	if (h)
+		pg = rcu_dereference(h->pg);
+	if (pg) {
+		switch (pg->state) {
+		case TPGS_STATE_OPTIMIZED:
+			access_state = SCSI_ACCESS_STATE_OPTIMAL;
+			break;
+		case TPGS_STATE_NONOPTIMIZED:
+			access_state = SCSI_ACCESS_STATE_ACTIVE;
+			break;
+		case TPGS_STATE_STANDBY:
+			access_state = SCSI_ACCESS_STATE_PASSIVE;
+			break;
+		case TPGS_STATE_UNAVAILABLE:
+			access_state = SCSI_ACCESS_STATE_UNAVAILABLE;
+			break;
+		case TPGS_STATE_LBA_DEPENDENT:
+			access_state = SCSI_ACCESS_STATE_LBA;
+			break;
+		case TPGS_STATE_OFFLINE:
+			access_state = SCSI_ACCESS_STATE_OFFLINE;
+			break;
+		case TPGS_STATE_TRANSITIONING:
+			access_state = SCSI_ACCESS_STATE_TRANSITIONING;
+			break;
+		}
+		if (pg->pref)
+			access_state |= SCSI_ACCESS_STATE_PREFERRED;
+	}
+	rcu_read_unlock();
+	return access_state;
+}
+
+/*
  * alua_prep_fn - request callback
  *
  * Fail I/O to all paths not in state
@@ -1288,6 +1334,7 @@ static struct scsi_device_handler alua_dh = {
 	.activate = alua_activate,
 	.rescan = alua_rescan,
 	.set_params = alua_set_params,
+	.state = alua_state,
 };
 
 static int __init alua_init(void)
-- 
1.8.5.2

