From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 25/36] scsi_dh_alua: simplify alua_initialize()
Date: Tue, 29 Sep 2015 12:47:27 +0200
Message-ID: <1443523658-87622-26-git-send-email-hare@suse.de>
References: <1443523658-87622-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:42102 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934707AbbI2KsF (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 29 Sep 2015 06:48:05 -0400
In-Reply-To: <1443523658-87622-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <james.bottomley@hansenpartnership.com>
Cc: linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>, Bart van Assche <bart.vanassche@sandisk.com>, Ewan Milne <emilne@redhat.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Hannes Reinecke <hare@suse.de>

Rework alua_check_vpd() to use scsi_vpd_get_tpg()
and move the port group selection into the function, too.
With that we can simplify alua_initialize() to just
call alua_check_tpgs() and alua_check_vpd();

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/scsi/device_handler/scsi_dh_alua.c | 99 ++++++++++--------------------
 1 file changed, 34 insertions(+), 65 deletions(-)

diff --git a/drivers/scsi/device_handler/scsi_dh_alua.c b/drivers/scsi/device_handler/scsi_dh_alua.c
index e2e6177..1755591 100644
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
@@ -292,35 +292,18 @@ static int alua_check_tpgs(struct scsi_device *sdev)
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
-	unsigned char *d;
-
-	if (!sdev->vpd_pg83)
-		return SCSI_DH_DEV_UNSUPP;
-
-	/*
-	 * Look for the correct descriptor.
-	 */
-	d = sdev->vpd_pg83 + 4;
-	while (d < sdev->vpd_pg83 + sdev->vpd_pg83_len) {
-		switch (d[1] & 0xf) {
-		case 0x4:
-			/* Relative target port */
-			h->rel_port = get_unaligned_be16(&d[6]);
-			break;
-		case 0x5:
-			/* Target port group */
-			h->group_id = get_unaligned_be16(&d[6]);
-			break;
-		default:
-			break;
-		}
-		d += d[3] + 4;
-	}
+	int rel_port = -1, group_id;
+	char id_str[256];
+	int id_size;
 
-	if (h->group_id == -1) {
+	group_id = scsi_vpd_tpg_id(sdev, &rel_port);
+	if (group_id < 0) {
 		/*
 		 * Internal error; TPGS supported but required
 		 * VPD identification descriptors not present.
@@ -331,11 +314,29 @@ static int alua_check_vpd(struct scsi_device *sdev, struct alua_dh_data *h)
 			    ALUA_DH_NAME);
 		return SCSI_DH_DEV_UNSUPP;
 	}
+	h->rel_port = rel_port;
+
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
+		    "%s: device %s port group %02x "
+		    "rel port %02x\n", ALUA_DH_NAME,
+		    id_str, group_id, h->rel_port);
 
-	return 0;
+	h->pg = alua_get_pg(sdev, group_id, tpgs, id_str, id_size);
+	if (!h->pg)
+		return SCSI_DH_NOMEM;
+
+	return alua_rtpg(sdev, h->pg, 0);
 }
 
 static char print_alua_state(int state)
@@ -653,46 +654,14 @@ static unsigned alua_stpg(struct scsi_device *sdev, struct alua_port_group *pg)
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
-		    "%s: device %s port group %02x "
-		    "rel port %02x\n", ALUA_DH_NAME,
-		    device_id_str, h->group_id, h->rel_port);
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

