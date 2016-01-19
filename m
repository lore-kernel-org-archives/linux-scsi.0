From: Hannes Reinecke <hare@suse.de>
Subject: [PATCHv4 09/23] scsi_dh_alua: simplify alua_initialize()
Date: Tue, 19 Jan 2016 09:21:53 +0100
Message-ID: <1453191727-3626-10-git-send-email-hare@suse.de>
References: <1453191727-3626-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:60687 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757370AbcASIWe (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 19 Jan 2016 03:22:34 -0500
In-Reply-To: <1453191727-3626-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: James Bottomley <james.bottomley@hansenpartnership.com>, Christoph Hellwig <hch@infradead.org>, Ewan Milne <emilne@redhat.com>, Bart van Assche <bart.vanassche@sandisk.com>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>

Rework alua_check_vpd() to use scsi_vpd_get_tpg()
and move the port group selection into the function, too.
With that we can simplify alua_initialize() to just
call alua_check_tpgs() and alua_check_vpd();

Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/scsi/device_handler/scsi_dh_alua.c | 42 ++++++++++++------------------
 1 file changed, 17 insertions(+), 25 deletions(-)

diff --git a/drivers/scsi/device_handler/scsi_dh_alua.c b/drivers/scsi/device_handler/scsi_dh_alua.c
index ea0cf9f..79f5211 100644
--- a/drivers/scsi/device_handler/scsi_dh_alua.c
+++ b/drivers/scsi/device_handler/scsi_dh_alua.c
@@ -92,6 +92,7 @@ struct alua_dh_data {
 #define ALUA_POLICY_SWITCH_CURRENT	0
 #define ALUA_POLICY_SWITCH_ALL		1
 
+static int alua_rtpg(struct scsi_device *, struct alua_port_group *, int);
 static char print_alua_state(int);
 
 static void release_port_group(struct kref *kref)
@@ -294,7 +295,8 @@ static int alua_check_tpgs(struct scsi_device *sdev)
  * Extract the relative target port and the target port group
  * descriptor from the list of identificators.
  */
-static int alua_check_vpd(struct scsi_device *sdev, struct alua_dh_data *h)
+static int alua_check_vpd(struct scsi_device *sdev, struct alua_dh_data *h,
+			  int tpgs)
 {
 	int rel_port = -1, group_id;
 
@@ -310,13 +312,21 @@ static int alua_check_vpd(struct scsi_device *sdev, struct alua_dh_data *h)
 			    ALUA_DH_NAME);
 		return SCSI_DH_DEV_UNSUPP;
 	}
-	h->group_id = group_id;
+
+	h->pg = alua_alloc_pg(sdev, group_id, tpgs);
+	if (PTR_ERR(h->pg)) {
+		if (PTR_ERR(h->pg) == -ENOMEM)
+			return SCSI_DH_NOMEM;
+		return SCSI_DH_DEV_UNSUPP;
+	}
+	h->rel_port = rel_port;
 
 	sdev_printk(KERN_INFO, sdev,
-		    "%s: port group %02x rel port %02x\n",
-		    ALUA_DH_NAME, h->group_id, h->rel_port);
+		    "%s: device %s port group %02x rel port %02x\n",
+		    ALUA_DH_NAME, h->pg->device_id_str,
+		    h->group_id, h->rel_port);
 
-	return 0;
+	return alua_rtpg(sdev, h->pg, 0);
 }
 
 static char print_alua_state(int state)
@@ -637,27 +647,9 @@ static int alua_initialize(struct scsi_device *sdev, struct alua_dh_data *h)
 	int err = SCSI_DH_DEV_UNSUPP, tpgs;
 
 	tpgs = alua_check_tpgs(sdev);
-	if (tpgs == TPGS_MODE_NONE)
-		goto out;
-
-	err = alua_check_vpd(sdev, h);
-	if (err != SCSI_DH_OK)
-		goto out;
+	if (tpgs != TPGS_MODE_NONE)
+		err = alua_check_vpd(sdev, h, tpgs);
 
-	h->pg = alua_alloc_pg(sdev, h->group_id, tpgs);
-	if (PTR_ERR(h->pg)) {
-		if (PTR_ERR(h->pg) == -ENOMEM)
-			err = SCSI_DH_NOMEM;
-		goto out;
-	}
-	sdev_printk(KERN_INFO, sdev,
-		    "%s: device %s port group %02x rel port %02x\n",
-		    ALUA_DH_NAME, h->pg->device_id_str,
-		    h->group_id, h->rel_port);
-	kref_get(&h->pg->kref);
-	err = alua_rtpg(sdev, h->pg, 0);
-	kref_put(&h->pg->kref, release_port_group);
-out:
 	return err;
 }
 /*
-- 
1.8.5.6

