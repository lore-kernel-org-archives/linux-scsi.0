From: Hannes Reinecke <hare@suse.de>
Subject: [PATCHv7 11/23] scsi_dh_alua: move optimize_stpg evaluation
Date: Mon, 15 Feb 2016 09:24:38 +0100
Message-ID: <1455524690-121073-12-git-send-email-hare@suse.de>
References: <1455524690-121073-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:46058 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752331AbcBOIY4 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 15 Feb 2016 03:24:56 -0500
In-Reply-To: <1455524690-121073-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, Bart van Assche <bart.vanassche@sandisk.com>, James Bottomley <james.bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org, Ewan Milne <emilne@redhat.com>, Johannes Thumshirn <jthumshirn@suse.de>, Hannes Reinecke <hare@suse.de>, Hannes Reinecke <hare@suse.com>

When the optimize_stpg module option is set we should just set it
once during port_group allocation. Doing so allows us to override
it later with device specific settings.

Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Hannes Reinecke <hare@suse.com>
---
 drivers/scsi/device_handler/scsi_dh_alua.c | 13 ++++++-------
 1 file changed, 6 insertions(+), 7 deletions(-)

diff --git a/drivers/scsi/device_handler/scsi_dh_alua.c b/drivers/scsi/device_handler/scsi_dh_alua.c
index 61c67e6..0212aee 100644
--- a/drivers/scsi/device_handler/scsi_dh_alua.c
+++ b/drivers/scsi/device_handler/scsi_dh_alua.c
@@ -64,6 +64,10 @@
 #define ALUA_OPTIMIZE_STPG		1
 #define ALUA_RTPG_EXT_HDR_UNSUPP	2
 
+static uint optimize_stpg;
+module_param(optimize_stpg, uint, S_IRUGO|S_IWUSR);
+MODULE_PARM_DESC(optimize_stpg, "Allow use of a non-optimized path, rather than sending a STPG, when implicit TPGS is supported (0=No,1=Yes). Default is 0.");
+
 static LIST_HEAD(port_group_list);
 static DEFINE_SPINLOCK(port_group_lock);
 
@@ -219,6 +223,8 @@ struct alua_port_group *alua_alloc_pg(struct scsi_device *sdev,
 	pg->group_id = group_id;
 	pg->tpgs = tpgs;
 	pg->state = TPGS_STATE_OPTIMIZED;
+	if (optimize_stpg)
+		pg->flags |= ALUA_OPTIMIZE_STPG;
 	kref_init(&pg->kref);
 
 	spin_lock(&port_group_lock);
@@ -680,10 +686,6 @@ static int alua_set_params(struct scsi_device *sdev, const char *params)
 	return result;
 }
 
-static uint optimize_stpg;
-module_param(optimize_stpg, uint, S_IRUGO|S_IWUSR);
-MODULE_PARM_DESC(optimize_stpg, "Allow use of a non-optimized path, rather than sending a STPG, when implicit TPGS is supported (0=No,1=Yes). Default is 0.");
-
 /*
  * alua_activate - activate a path
  * @sdev: device on the path to be activated
@@ -705,9 +707,6 @@ static int alua_activate(struct scsi_device *sdev,
 
 	kref_get(&h->pg->kref);
 
-	if (optimize_stpg)
-		h->pg->flags |= ALUA_OPTIMIZE_STPG;
-
 	err = alua_rtpg(sdev, h->pg);
 	if (err != SCSI_DH_OK) {
 		kref_put(&h->pg->kref, release_port_group);
-- 
1.8.5.6

