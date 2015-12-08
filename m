From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 09/20] scsi_dh_alua: simplify alua_initialize()
Date: Tue,  8 Dec 2015 08:37:29 +0100
Message-ID: <1449560260-53407-10-git-send-email-hare@suse.de>
References: <1449560260-53407-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:46089 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933170AbbLHHhp (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 8 Dec 2015 02:37:45 -0500
In-Reply-To: <1449560260-53407-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: James Bottomley <jbottomley@odin.com>, Christoph Hellwig <hch@lst.de>, Ewan Milne <emilne@redhat.com>, Bart van Assche <bart.vanassche@sandisk.com>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>

Rework alua_check_vpd() to use scsi_vpd_get_tpg()
and move the port group selection into the function, too.
With that we can simplify alua_initialize() to just
call alua_check_tpgs() and alua_check_vpd();

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/scsi/device_handler/scsi_dh_alua.c | 70 +++++++++++++-----------------
 1 file changed, 29 insertions(+), 41 deletions(-)

diff --git a/drivers/scsi/device_handler/scsi_dh_alua.c b/drivers/scsi/device_handler/scsi_dh_alua.c
index 688e0f7..1eacf3f 100644
--- a/drivers/scsi/device_handler/scsi_dh_alua.c
+++ b/drivers/scsi/device_handler/scsi_dh_alua.c
@@ -82,7 +82,6 @@ struct alua_port_group {
 
 struct alua_dh_data {
 	struct alua_port_group	*pg;
-	int			group_id;
 	int			rel_port;
 	struct scsi_device	*sdev;
 	activate_complete	callback_fn;
@@ -92,6 +91,7 @@ struct alua_dh_data {
 #define ALUA_POLICY_SWITCH_CURRENT	0
 #define ALUA_POLICY_SWITCH_ALL		1
 
+static int alua_rtpg(struct scsi_device *, struct alua_port_group *, int);
 static char print_alua_state(int);
 
 static void release_port_group(struct kref *kref)
@@ -288,10 +288,15 @@ static int alua_check_tpgs(struct scsi_device *sdev)
  *
  * Extract the relative target port and the target port group
  * descriptor from the list of identificators.
+ *
+ * Returns 0 or SCSI_DH_ error code on failure.
  */
-static int alua_check_vpd(struct scsi_device *sdev, struct alua_dh_data *h)
+static int alua_check_vpd(struct scsi_device *sdev, struct alua_dh_data *h,
+			  int tpgs)
 {
 	int rel_port = -1, group_id;
+	char id_str[256];
+	int id_size;
 
 	group_id = scsi_vpd_tpg_id(sdev, &rel_port);
 	if (group_id < 0) {
@@ -305,14 +310,28 @@ static int alua_check_vpd(struct scsi_device *sdev, struct alua_dh_data *h)
 			    ALUA_DH_NAME);
 		return SCSI_DH_DEV_UNSUPP;
 	}
-	h->state = TPGS_STATE_OPTIMIZED;
-	h->group_id = group_id;
+	h->rel_port = rel_port;
 
+	id_size = scsi_vpd_lun_id(sdev, id_str, 256);
+	if (id_size <= 0) {
+		/*
+		 * Internal error: TPGS supported but no device
+		 * identifcation found. Disable ALUA support.
+		 */
+		sdev_printk(KERN_INFO, sdev,
+			    "%s: No device descriptors found\n",
+			    ALUA_DH_NAME);
+		return SCSI_DH_DEV_UNSUPP;
+	}
 	sdev_printk(KERN_INFO, sdev,
-		    "%s: port group %02x rel port %02x\n",
-		    ALUA_DH_NAME, h->group_id, h->rel_port);
+		    "%s: device %s port group %02x rel port %02x\n",
+		    ALUA_DH_NAME, id_str, group_id, h->rel_port);
 
-	return 0;
+	h->pg = alua_get_pg(sdev, group_id, tpgs, id_str, id_size);
+	if (!h->pg)
+		return SCSI_DH_NOMEM;
+
+	return alua_rtpg(sdev, h->pg, 0);
 }
 
 static char print_alua_state(int state)
@@ -631,45 +650,14 @@ static unsigned alua_stpg(struct scsi_device *sdev, struct alua_port_group *pg)
 static int alua_initialize(struct scsi_device *sdev, struct alua_dh_data *h)
 {
 	int err = SCSI_DH_DEV_UNSUPP, tpgs;
-	char device_id_str[256];
-	int device_id_len;
 
 	tpgs = alua_check_tpgs(sdev);
-	if (tpgs == TPGS_MODE_NONE)
-		goto out;
-
-	err = alua_check_vpd(sdev, h);
-	if (err != SCSI_DH_OK)
-		goto out;
+	if (tpgs != TPGS_MODE_NONE)
+		err = alua_check_vpd(sdev, h, tpgs);
 
-	device_id_len = scsi_vpd_lun_id(sdev, device_id_str,
-					sizeof(device_id_str));
-	if (device_id_len <= 0) {
-		/*
-		 * Internal error: TPGS supported but no device
-		 * identifcation found. Disable ALUA support.
-		 */
-		sdev_printk(KERN_INFO, sdev,
-			    "%s: No device descriptors found\n",
-			    ALUA_DH_NAME);
-		goto out;
-	}
-	sdev_printk(KERN_INFO, sdev,
-		    "%s: device %s port group %02x rel port %02x\n",
-		    ALUA_DH_NAME, device_id_str, h->group_id, h->rel_port);
-
-	h->pg = alua_get_pg(sdev, h->group_id, tpgs,
-			    device_id_str, device_id_len);
-	if (!h->pg) {
-		err = SCSI_DH_NOMEM;
-		goto out;
-	}
-	kref_get(&h->pg->kref);
-	err = alua_rtpg(sdev, h->pg, 0);
-	kref_put(&h->pg->kref, release_port_group);
-out:
 	return err;
 }
+
 /*
  * alua_set_params - set/unset the optimize flag
  * @sdev: device on the path to be activated
-- 
1.8.5.6

