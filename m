From: hare@suse.de (Hannes Reinecke)
Subject: [PATCH 2/2] Evaluate TGPS setting for device handler detection
Date: Thu, 19 Mar 2009 09:06:41 +0100
Message-ID: <20090319080642.4815418C79D@pentland.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:44284 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751827AbZCSIGp (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 19 Mar 2009 04:06:45 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi@vger.kernel.org


For correct ALUA support we should evaluate the TPGS setting
of the device and only attach the alua device handler to it
if not zero.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/scsi/device_handler/scsi_dh.c       |   11 ++++-
 drivers/scsi/device_handler/scsi_dh_alua.c  |   68 ++++-----------------------
 drivers/scsi/device_handler/scsi_dh_emc.c   |    8 ++--
 drivers/scsi/device_handler/scsi_dh_hp_sw.c |   10 ++--
 drivers/scsi/device_handler/scsi_dh_rdac.c  |   38 +++++++-------
 include/scsi/scsi_device.h                  |    1 +
 6 files changed, 47 insertions(+), 89 deletions(-)

diff --git a/drivers/scsi/device_handler/scsi_dh.c b/drivers/scsi/device_handler/scsi_dh.c
index a518f2e..5932083 100644
--- a/drivers/scsi/device_handler/scsi_dh.c
+++ b/drivers/scsi/device_handler/scsi_dh.c
@@ -28,6 +28,7 @@ struct scsi_dh_devinfo_list {
 	struct list_head node;
 	char vendor[9];
 	char model[17];
+	char tpgs;
 	struct scsi_device_handler *handler;
 };
 
@@ -56,11 +57,13 @@ scsi_dh_cache_lookup(struct scsi_device *sdev)
 {
 	struct scsi_dh_devinfo_list *tmp;
 	struct scsi_device_handler *found_dh = NULL;
+	int tpgs = scsi_device_tpgs(sdev);
 
 	spin_lock(&list_lock);
 	list_for_each_entry(tmp, &scsi_dh_dev_list, node) {
 		if (!strncmp(sdev->vendor, tmp->vendor, strlen(tmp->vendor)) &&
-		    !strncmp(sdev->model, tmp->model, strlen(tmp->model))) {
+		    !strncmp(sdev->model, tmp->model, strlen(tmp->model)) &&
+		    (!tmp->tpgs || (tpgs & tmp->tpgs) != 0)) {
 			found_dh = tmp->handler;
 			break;
 		}
@@ -74,12 +77,15 @@ static int scsi_dh_handler_lookup(struct scsi_device_handler *scsi_dh,
 				  struct scsi_device *sdev)
 {
 	int i, found = 0;
+	int tpgs = scsi_device_tpgs(sdev);
 
 	for(i = 0; scsi_dh->devlist[i].vendor; i++) {
 		if (!strncmp(sdev->vendor, scsi_dh->devlist[i].vendor,
 			     strlen(scsi_dh->devlist[i].vendor)) &&
 		    !strncmp(sdev->model, scsi_dh->devlist[i].model,
-			     strlen(scsi_dh->devlist[i].model))) {
+			     strlen(scsi_dh->devlist[i].model)) &&
+		    (!scsi_dh->devlist[i].tpgs ||
+		     (tpgs & scsi_dh->devlist[i].tpgs) != 0)) {
 			found = 1;
 			break;
 		}
@@ -128,6 +134,7 @@ device_handler_match(struct scsi_device_handler *scsi_dh,
 			strncpy(tmp->model, sdev->model, 16);
 			tmp->vendor[8] = '\0';
 			tmp->model[16] = '\0';
+			tmp->tpgs = scsi_device_tpgs(sdev);
 			tmp->handler = found_dh;
 			spin_lock(&list_lock);
 			list_add(&tmp->node, &scsi_dh_dev_list);
diff --git a/drivers/scsi/device_handler/scsi_dh_alua.c b/drivers/scsi/device_handler/scsi_dh_alua.c
index dba154c..e21460d 100644
--- a/drivers/scsi/device_handler/scsi_dh_alua.c
+++ b/drivers/scsi/device_handler/scsi_dh_alua.c
@@ -118,43 +118,6 @@ static struct request *get_alua_req(struct scsi_device *sdev,
 }
 
 /*
- * submit_std_inquiry - Issue a standard INQUIRY command
- * @sdev: sdev the command should be send to
- */
-static int submit_std_inquiry(struct scsi_device *sdev, struct alua_dh_data *h)
-{
-	struct request *rq;
-	int err = SCSI_DH_RES_TEMP_UNAVAIL;
-
-	rq = get_alua_req(sdev, h->inq, ALUA_INQUIRY_SIZE, READ);
-	if (!rq)
-		goto done;
-
-	/* Prepare the command. */
-	rq->cmd[0] = INQUIRY;
-	rq->cmd[1] = 0;
-	rq->cmd[2] = 0;
-	rq->cmd[4] = ALUA_INQUIRY_SIZE;
-	rq->cmd_len = COMMAND_SIZE(INQUIRY);
-
-	rq->sense = h->sense;
-	memset(rq->sense, 0, SCSI_SENSE_BUFFERSIZE);
-	rq->sense_len = h->senselen = 0;
-
-	err = blk_execute_rq(rq->q, NULL, rq, 1);
-	if (err == -EIO) {
-		sdev_printk(KERN_INFO, sdev,
-			    "%s: std inquiry failed with %x\n",
-			    ALUA_DH_NAME, rq->errors);
-		h->senselen = rq->sense_len;
-		err = SCSI_DH_IO;
-	}
-	blk_put_request(rq);
-done:
-	return err;
-}
-
-/*
  * submit_vpd_inquiry - Issue an INQUIRY VPD page 0x83 command
  * @sdev: sdev the command should be sent to
  */
@@ -281,23 +244,19 @@ done:
 }
 
 /*
- * alua_std_inquiry - Evaluate standard INQUIRY command
+ * alua_check_tpgs - Evaluate TPGS setting
  * @sdev: device to be checked
  *
- * Just extract the TPGS setting to find out if ALUA
+ * Just examine the TPGS setting of the device to find out if ALUA
  * is supported.
  */
-static int alua_std_inquiry(struct scsi_device *sdev, struct alua_dh_data *h)
+static int alua_check_tpgs(struct scsi_device *sdev, struct alua_dh_data *h)
 {
-	int err;
-
-	err = submit_std_inquiry(sdev, h);
-
-	if (err != SCSI_DH_OK)
-		return err;
+	int err = SCSI_DH_OK;
 
 	/* Check TPGS setting */
-	h->tpgs = (h->inq[5] >> 4) & 0x3;
+	h->tpgs = scsi_device_tpgs(sdev);
+
 	switch (h->tpgs) {
 	case TPGS_MODE_EXPLICIT|TPGS_MODE_IMPLICIT:
 		sdev_printk(KERN_INFO, sdev,
@@ -626,7 +585,7 @@ static int alua_initialize(struct scsi_device *sdev, struct alua_dh_data *h)
 {
 	int err;
 
-	err = alua_std_inquiry(sdev, h);
+	err = alua_check_tpgs(sdev, h);
 	if (err != SCSI_DH_OK)
 		goto out;
 
@@ -691,17 +650,8 @@ static int alua_prep_fn(struct scsi_device *sdev, struct request *req)
 }
 
 static const struct scsi_dh_devlist alua_dev_list[] = {
-	{"HP", "MSA VOLUME" },
-	{"HP", "HSV101" },
-	{"HP", "HSV111" },
-	{"HP", "HSV200" },
-	{"HP", "HSV210" },
-	{"HP", "HSV300" },
-	{"IBM", "2107900" },
-	{"IBM", "2145" },
-	{"Pillar", "Axiom" },
-	{"Intel", "Multi-Flex"},
-	{NULL, NULL}
+	{"", "", 3 },
+	{NULL, NULL, 0}
 };
 
 static int alua_bus_attach(struct scsi_device *sdev);
diff --git a/drivers/scsi/device_handler/scsi_dh_emc.c b/drivers/scsi/device_handler/scsi_dh_emc.c
index 0e572d2..ff2e653 100644
--- a/drivers/scsi/device_handler/scsi_dh_emc.c
+++ b/drivers/scsi/device_handler/scsi_dh_emc.c
@@ -563,10 +563,10 @@ done:
 }
 
 static const struct scsi_dh_devlist clariion_dev_list[] = {
-	{"DGC", "RAID"},
-	{"DGC", "DISK"},
-	{"DGC", "VRAID"},
-	{NULL, NULL},
+	{"DGC", "RAID", 0},
+	{"DGC", "DISK", 0},
+	{"DGC", "VRAID", 0},
+	{NULL, NULL, 0},
 };
 
 static int clariion_bus_attach(struct scsi_device *sdev);
diff --git a/drivers/scsi/device_handler/scsi_dh_hp_sw.c b/drivers/scsi/device_handler/scsi_dh_hp_sw.c
index f7da753..3dbfbbf 100644
--- a/drivers/scsi/device_handler/scsi_dh_hp_sw.c
+++ b/drivers/scsi/device_handler/scsi_dh_hp_sw.c
@@ -287,11 +287,11 @@ static int hp_sw_activate(struct scsi_device *sdev)
 }
 
 static const struct scsi_dh_devlist hp_sw_dh_data_list[] = {
-	{"COMPAQ", "MSA1000 VOLUME"},
-	{"COMPAQ", "HSV110"},
-	{"HP", "HSV100"},
-	{"DEC", "HSG80"},
-	{NULL, NULL},
+	{"COMPAQ", "MSA1000 VOLUME", 0},
+	{"COMPAQ", "HSV110", 0},
+	{"HP", "HSV100", 0},
+	{"DEC", "HSG80", 0},
+	{NULL, NULL, 0},
 };
 
 static int hp_sw_bus_attach(struct scsi_device *sdev);
diff --git a/drivers/scsi/device_handler/scsi_dh_rdac.c b/drivers/scsi/device_handler/scsi_dh_rdac.c
index 43b8c51..ad046bd 100644
--- a/drivers/scsi/device_handler/scsi_dh_rdac.c
+++ b/drivers/scsi/device_handler/scsi_dh_rdac.c
@@ -609,25 +609,25 @@ static int rdac_check_sense(struct scsi_device *sdev,
 }
 
 static const struct scsi_dh_devlist rdac_dev_list[] = {
-	{"IBM", "1722"},
-	{"IBM", "1724"},
-	{"IBM", "1726"},
-	{"IBM", "1742"},
-	{"IBM", "1814"},
-	{"IBM", "1815"},
-	{"IBM", "1818"},
-	{"IBM", "3526"},
-	{"SGI", "TP9400"},
-	{"SGI", "TP9500"},
-	{"SGI", "IS"},
-	{"STK", "OPENstorage D280"},
-	{"SUN", "CSM200_R"},
-	{"SUN", "LCSM100_F"},
-	{"DELL", "MD3000"},
-	{"DELL", "MD3000i"},
-	{"LSI", "INF-01-00"},
-	{"ENGENIO", "INF-01-00"},
-	{NULL, NULL},
+	{"IBM", "1722", 0},
+	{"IBM", "1724", 0},
+	{"IBM", "1726", 0},
+	{"IBM", "1742", 0},
+	{"IBM", "1814", 0},
+	{"IBM", "1815", 0},
+	{"IBM", "1818", 0},
+	{"IBM", "3526", 0},
+	{"SGI", "TP9400", 0},
+	{"SGI", "TP9500", 0},
+	{"SGI", "IS", 0},
+	{"STK", "OPENstorage D280", 0},
+	{"SUN", "CSM200_R", 0},
+	{"SUN", "LCSM100_F", 0},
+	{"DELL", "MD3000", 0},
+	{"DELL", "MD3000i", 0},
+	{"LSI", "INF-01-00", 0},
+	{"ENGENIO", "INF-01-00", 0},
+	{NULL, NULL, 0},
 };
 
 static int rdac_bus_attach(struct scsi_device *sdev);
diff --git a/include/scsi/scsi_device.h b/include/scsi/scsi_device.h
index 6ac6321..e4df232 100644
--- a/include/scsi/scsi_device.h
+++ b/include/scsi/scsi_device.h
@@ -172,6 +172,7 @@ struct scsi_device {
 struct scsi_dh_devlist {
 	char *vendor;
 	char *model;
+	char tpgs;
 };
 
 struct scsi_device_handler {
-- 
1.5.3.2

