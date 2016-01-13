From: Hannes Reinecke <hare@suse.de>
Subject: [PATCHv3 16/24] scsi_dh_alua: Add new blacklist flag 'BLIST_SYNC_ALUA'
Date: Wed, 13 Jan 2016 09:09:51 +0100
Message-ID: <1452672599-9820-17-git-send-email-hare@suse.de>
References: <1452672599-9820-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:58977 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754903AbcAMIKU (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 13 Jan 2016 03:10:20 -0500
In-Reply-To: <1452672599-9820-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: James Bottomley <james.bottomley@hansenpartnership.com>, Christoph Hellwig <hch@lst.de>, Bart von Assche <bart.vanassche@sandisk.com>, Ewan Milne <emilne@redhat.com>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>

Add a new blacklist flag BLIST_SYNC_ALUA to instruct the
alua device handler to use synchronous command submission
for ALUA commands.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/scsi/device_handler/scsi_dh_alua.c | 7 +++++++
 include/scsi/scsi_devinfo.h                | 1 +
 2 files changed, 8 insertions(+)

diff --git a/drivers/scsi/device_handler/scsi_dh_alua.c b/drivers/scsi/device_handler/scsi_dh_alua.c
index 36c515c..f0687ba 100644
--- a/drivers/scsi/device_handler/scsi_dh_alua.c
+++ b/drivers/scsi/device_handler/scsi_dh_alua.c
@@ -27,6 +27,7 @@
 #include <scsi/scsi_dbg.h>
 #include <scsi/scsi_eh.h>
 #include <scsi/scsi_dh.h>
+#include <scsi/scsi_devinfo.h>
 
 #define ALUA_DH_NAME "alua"
 #define ALUA_DH_VER "1.3"
@@ -335,6 +336,10 @@ static int alua_check_vpd(struct scsi_device *sdev, struct alua_dh_data *h,
 	int rel_port = -1, group_id;
 	struct alua_port_group *pg, *old_pg = NULL;
 	bool pg_updated = false;
+	unsigned int bflags = scsi_get_device_flags_keyed(sdev,
+							  &sdev->inquiry[8],
+							  &sdev->inquiry[16],
+							  SCSI_DEVINFO_GLOBAL);
 
 	group_id = scsi_vpd_tpg_id(sdev, &rel_port);
 	if (group_id < 0) {
@@ -373,6 +378,8 @@ static int alua_check_vpd(struct scsi_device *sdev, struct alua_dh_data *h,
 		rcu_assign_pointer(h->pg, pg);
 		pg_updated = true;
 	}
+	if (bflags & BLIST_SYNC_ALUA)
+		pg->flags |= ALUA_SYNC_STPG;
 	alua_rtpg_queue(h->pg, sdev, NULL);
 	spin_unlock(&h->pg_lock);
 
diff --git a/include/scsi/scsi_devinfo.h b/include/scsi/scsi_devinfo.h
index aca3c80..dc0cb5f 100644
--- a/include/scsi/scsi_devinfo.h
+++ b/include/scsi/scsi_devinfo.h
@@ -37,6 +37,7 @@
 #define BLIST_TRY_VPD_PAGES	0x10000000 /* Attempt to read VPD pages */
 #define BLIST_NO_RSOC		0x20000000 /* don't try to issue RSOC */
 #define BLIST_MAX_1024		0x40000000 /* maximum 1024 sector cdb length */
+#define BLIST_SYNC_ALUA		0x80000000 /* Synchronous ALUA commands */
 
 /* list of keys for the lists */
 enum {
-- 
1.8.5.6

