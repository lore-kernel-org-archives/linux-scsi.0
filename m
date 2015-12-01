From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 18/18] scsi_dh_alua: use scsi_vpd_tpg_id()
Date: Tue,  1 Dec 2015 10:16:58 +0100
Message-ID: <1448961418-29013-19-git-send-email-hare@suse.de>
References: <1448961418-29013-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:41605 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755584AbbLAJRO (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 1 Dec 2015 04:17:14 -0500
In-Reply-To: <1448961418-29013-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, Ewan Milne <emilne@redhat.com>, James Bottomley <jbottomley@odin.com>, Johannes Thumshirn <jthumshirn@suse.com>, Bart van Assche <bart.vanassche@sandisk.com>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>

Use the common function 'scsi_vpd_tpg_id()' instead of open-coding
it in scsi_dh_alua.

Reviewed-by: Johannes Thumshirn <jthumshirn@suse.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/scsi/device_handler/scsi_dh_alua.c | 39 +++++-------------------------
 1 file changed, 6 insertions(+), 33 deletions(-)

diff --git a/drivers/scsi/device_handler/scsi_dh_alua.c b/drivers/scsi/device_handler/scsi_dh_alua.c
index abf05b4..20fe981 100644
--- a/drivers/scsi/device_handler/scsi_dh_alua.c
+++ b/drivers/scsi/device_handler/scsi_dh_alua.c
@@ -320,38 +320,10 @@ static int alua_check_tpgs(struct scsi_device *sdev)
  */
 static int alua_check_vpd(struct scsi_device *sdev, struct alua_dh_data *h)
 {
-	unsigned char *d;
-	unsigned char __rcu *vpd_pg83;
+	int rel_port = -1, group_id;
 
-	rcu_read_lock();
-	if (!rcu_dereference(sdev->vpd_pg83)){
-		rcu_read_unlock();
-		return SCSI_DH_DEV_UNSUPP;
-	}
-
-	/*
-	 * Look for the correct descriptor.
-	 */
-	vpd_pg83 = rcu_dereference(sdev->vpd_pg83);
-	d = vpd_pg83 + 4;
-	while (d < vpd_pg83 + sdev->vpd_pg83_len) {
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
-	rcu_read_unlock();
-
-	if (h->group_id == -1) {
+	group_id = scsi_vpd_tpg_id(sdev, &rel_port);
+	if (group_id < 0) {
 		/*
 		 * Internal error; TPGS supported but required
 		 * VPD identification descriptors not present.
@@ -360,10 +332,11 @@ static int alua_check_vpd(struct scsi_device *sdev, struct alua_dh_data *h)
 		sdev_printk(KERN_INFO, sdev,
 			    "%s: No target port descriptors found\n",
 			    ALUA_DH_NAME);
-		h->state = TPGS_STATE_OPTIMIZED;
-		h->tpgs = TPGS_MODE_NONE;
 		return SCSI_DH_DEV_UNSUPP;
 	}
+	h->rel_port = rel_port;
+	h->group_id = group_id;
+
 	sdev_printk(KERN_INFO, sdev,
 		    "%s: port group %02x rel port %02x\n",
 		    ALUA_DH_NAME, h->group_id, h->rel_port);
-- 
1.8.5.6

