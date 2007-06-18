From: hare@suse.de (Hannes Reinecke)
Subject: [PATCH 4/11] Implement SDEV_NEW state
Date: Mon, 18 Jun 2007 11:01:46 +0200
Message-ID: <20070618090146.58E45D44CB@pentland.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns.suse.de ([195.135.220.2]:56573 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756034AbXFRJBr (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 18 Jun 2007 05:01:47 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: linux-scsi@vger.kernel.org


When a scsi_device is allocated it's state is set to SDEV_CREATED.
However, we don't have any chance to detect if slave_alloc() has
run successfully or not.
This patch introduces a state SDEV_NEW which is used instead of
SDEV_CREATED upon initial sdev creation. After slave_alloc() has
run successfully the state is changed to SDEV_CREATED.
This allows us to detect later on if we might call slave_destroy()
or not.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/scsi/scsi_lib.c    |   17 +++++++++++++----
 drivers/scsi/scsi_scan.c   |    9 ++++++++-
 drivers/scsi/scsi_sysfs.c  |    1 +
 include/scsi/scsi_device.h |    3 ++-
 4 files changed, 24 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 70454b4..bb32747 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -1933,12 +1933,21 @@ scsi_device_set_state(struct scsi_device
 		return 0;
 
 	switch (state) {
-	case SDEV_CREATED:
+	case SDEV_NEW:
 		/* There are no legal states that come back to
-		 * created.  This is the manually initialised start
+		 * new.  This is the manually initialised start
 		 * state */
 		goto illegal;
-			
+
+	case SDEV_CREATED:
+		switch (oldstate) {
+		case SDEV_NEW:
+			break;
+		default:
+			goto illegal;
+		}
+		break;
+
 	case SDEV_RUNNING:
 		switch (oldstate) {
 		case SDEV_CREATED:
@@ -1998,7 +2007,7 @@ scsi_device_set_state(struct scsi_device
 
 	case SDEV_DEL:
 		switch (oldstate) {
-		case SDEV_CREATED:
+		case SDEV_NEW:
 		case SDEV_RUNNING:
 		case SDEV_OFFLINE:
 		case SDEV_CANCEL:
diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
index 4874bdd..000f93d 100644
--- a/drivers/scsi/scsi_scan.c
+++ b/drivers/scsi/scsi_scan.c
@@ -239,7 +239,7 @@ static struct scsi_device *scsi_alloc_sd
 	sdev->id = starget->id;
 	sdev->lun = lun;
 	sdev->channel = starget->channel;
-	sdev->sdev_state = SDEV_CREATED;
+	sdev->sdev_state = SDEV_NEW;
 	INIT_LIST_HEAD(&sdev->siblings);
 	INIT_LIST_HEAD(&sdev->same_target_siblings);
 	INIT_LIST_HEAD(&sdev->cmd_list);
@@ -291,9 +291,16 @@ static struct scsi_device *scsi_alloc_sd
 			 */
 			if (ret == -ENXIO)
 				display_failure_msg = 0;
+			/*
+			 * sdev remains in SDEV_NEW as the release
+			 * function has to know whether slave_alloc()
+			 * failed or not.
+			 */
 			goto out_device_destroy;
 		}
 	}
+	/* Device is created properly */
+	scsi_device_set_state(sdev, SDEV_CREATED);
 
 	return sdev;
 
diff --git a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
index 7d67517..38dd598 100644
--- a/drivers/scsi/scsi_sysfs.c
+++ b/drivers/scsi/scsi_sysfs.c
@@ -24,6 +24,7 @@ static const struct {
 	enum scsi_device_state	value;
 	char			*name;
 } sdev_states[] = {
+	{ SDEV_NEW, "new" },
 	{ SDEV_CREATED, "created" },
 	{ SDEV_RUNNING, "running" },
 	{ SDEV_CANCEL, "cancel" },
diff --git a/include/scsi/scsi_device.h b/include/scsi/scsi_device.h
index dad55d2..b48fff2 100644
--- a/include/scsi/scsi_device.h
+++ b/include/scsi/scsi_device.h
@@ -28,7 +28,8 @@ struct scsi_mode_data {
  * scsi_lib:scsi_device_set_state().
  */
 enum scsi_device_state {
-	SDEV_CREATED = 1,	/* device created but not added to sysfs
+	SDEV_NEW = 1,		/* device created, slave_alloc has not run */
+	SDEV_CREATED,		/* device created but not added to sysfs
 				 * Only internal commands allowed (for inq) */
 	SDEV_RUNNING,		/* device properly configured
 				 * All commands allowed */
-- 
1.4.3.4

