From: Hannes Reinecke <hare@suse.de>
Subject: [PATCHv6 09/23] scsi_dh_alua: simplify alua_initialize()
Date: Fri, 12 Feb 2016 09:25:32 +0100
Message-ID: <1455265546-44470-10-git-send-email-hare@suse.de>
References: <1455265546-44470-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:52042 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751288AbcBLIZu (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 12 Feb 2016 03:25:50 -0500
In-Reply-To: <1455265546-44470-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, Bart van Assche <bart.vanassche@sandisk.com>, James Bottomley <james.bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org, Ewan Milne <emilne@redhat.com>, Johannes Thumshirn <jthumshirn@suse.de>, Hannes Reinecke <hare@suse.de>

Rework alua_check_vpd() to use scsi_vpd_get_tpg()
and move the port group selection into the function, too.
With that we can simplify alua_initialize() to just
call alua_check_tpgs() and alua_check_vpd();

Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/scsi/device_handler/scsi_dh_alua.c | 38 +++++++++++++-----------------
 1 file changed, 17 insertions(+), 21 deletions(-)

diff --git a/drivers/scsi/device_handler/scsi_dh_alua.c b/drivers/scsi/device_handler/scsi_dh_alua.c
index 0262085..a1bcad3 100644
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
+	if (IS_ERR(h->pg)) {
+		if (PTR_ERR(h->pg) == -ENOMEM)
+			return SCSI_DH_NOMEM;
+		return SCSI_DH_DEV_UNSUPP;
+	}
+	h->rel_port = rel_port;
 
 	sdev_printk(KERN_INFO, sdev,
-		    "%s: port group %x rel port %x\n",
-		    ALUA_DH_NAME, h->group_id, h->rel_port);
+		    "%s: device %s port group %x rel port %x\n",
+		    ALUA_DH_NAME, h->pg->device_id_str,
+		    h->group_id, h->rel_port);
 
-	return 0;
+	return alua_rtpg(sdev, h->pg, 0);
 }
 
 static char print_alua_state(int state)
@@ -635,23 +645,9 @@ static int alua_initialize(struct scsi_device *sdev, struct alua_dh_data *h)
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
-	if (IS_ERR(h->pg)) {
-		if (PTR_ERR(h->pg) == -ENOMEM)
-			err = SCSI_DH_NOMEM;
-		goto out;
-	}
-	kref_get(&h->pg->kref);
-	err = alua_rtpg(sdev, h->pg, 0);
-	kref_put(&h->pg->kref, release_port_group);
-out:
 	return err;
 }
 /*
-- 
1.8.5.6

