From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 05/10] scsi_dh: move device matching to the core code
Date: Thu, 27 Aug 2015 14:16:58 +0200
Message-ID: <1440677823-11695-6-git-send-email-hare@suse.de>
References: <1440677823-11695-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:44531 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753424AbbH0MRL (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 27 Aug 2015 08:17:11 -0400
In-Reply-To: <1440677823-11695-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <james.bottomley@hansenpartnership.com>
Cc: Christoph Hellwig <hch@lst.de>, "Martin K. Petersen" <martin.petersen@oracle.com>, Mike Snitzer <snitzer@redhat.com>, linux-scsi@vger.kernel.org

From: Christoph Hellwig <hch@lst.de>

Add a single list of devices that need non-ALUA device handlers to the core
scsi_dh code so that we can autoload the modules for them at probe time.

While this is a little ugly in terms of architecture it actually
significantly simplifies the code in addition to the new autoloading
functionality.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>
Reviewed-by: Hannes Reinecke <hare@suse.de>
Acked-by: Mike Snitzer <snitzer@redhat.com>
---
 drivers/scsi/device_handler/scsi_dh_alua.c  |  6 ---
 drivers/scsi/device_handler/scsi_dh_emc.c   | 29 ----------
 drivers/scsi/device_handler/scsi_dh_hp_sw.c | 30 -----------
 drivers/scsi/device_handler/scsi_dh_rdac.c  | 50 -----------------
 drivers/scsi/scsi_dh.c                      | 84 ++++++++++++++++++++++-------
 include/scsi/scsi_device.h                  |  1 -
 6 files changed, 66 insertions(+), 134 deletions(-)

diff --git a/drivers/scsi/device_handler/scsi_dh_alua.c b/drivers/scsi/device_handler/scsi_dh_alua.c
index 854b568..ace2457 100644
--- a/drivers/scsi/device_handler/scsi_dh_alua.c
+++ b/drivers/scsi/device_handler/scsi_dh_alua.c
@@ -819,11 +819,6 @@ static int alua_prep_fn(struct scsi_device *sdev, struct request *req)
 
 }
 
-static bool alua_match(struct scsi_device *sdev)
-{
-	return (scsi_device_tpgs(sdev) != 0);
-}
-
 /*
  * alua_bus_attach - Attach device handler
  * @sdev: device to be attached to
@@ -877,7 +872,6 @@ static struct scsi_device_handler alua_dh = {
 	.check_sense = alua_check_sense,
 	.activate = alua_activate,
 	.set_params = alua_set_params,
-	.match = alua_match,
 };
 
 static int __init alua_init(void)
diff --git a/drivers/scsi/device_handler/scsi_dh_emc.c b/drivers/scsi/device_handler/scsi_dh_emc.c
index 6ed1caa..fd31e67 100644
--- a/drivers/scsi/device_handler/scsi_dh_emc.c
+++ b/drivers/scsi/device_handler/scsi_dh_emc.c
@@ -622,34 +622,6 @@ done:
 	return result;
 }
 
-static const struct {
-	char *vendor;
-	char *model;
-} clariion_dev_list[] = {
-	{"DGC", "RAID"},
-	{"DGC", "DISK"},
-	{"DGC", "VRAID"},
-	{NULL, NULL},
-};
-
-static bool clariion_match(struct scsi_device *sdev)
-{
-	int i;
-
-	if (scsi_device_tpgs(sdev))
-		return false;
-
-	for (i = 0; clariion_dev_list[i].vendor; i++) {
-		if (!strncmp(sdev->vendor, clariion_dev_list[i].vendor,
-			strlen(clariion_dev_list[i].vendor)) &&
-		    !strncmp(sdev->model, clariion_dev_list[i].model,
-			strlen(clariion_dev_list[i].model))) {
-			return true;
-		}
-	}
-	return false;
-}
-
 static struct scsi_dh_data *clariion_bus_attach(struct scsi_device *sdev)
 {
 	struct clariion_dh_data *h;
@@ -698,7 +670,6 @@ static struct scsi_device_handler clariion_dh = {
 	.activate	= clariion_activate,
 	.prep_fn	= clariion_prep_fn,
 	.set_params	= clariion_set_params,
-	.match		= clariion_match,
 };
 
 static int __init clariion_init(void)
diff --git a/drivers/scsi/device_handler/scsi_dh_hp_sw.c b/drivers/scsi/device_handler/scsi_dh_hp_sw.c
index 485d995..1bf10d3 100644
--- a/drivers/scsi/device_handler/scsi_dh_hp_sw.c
+++ b/drivers/scsi/device_handler/scsi_dh_hp_sw.c
@@ -311,35 +311,6 @@ static int hp_sw_activate(struct scsi_device *sdev,
 	return 0;
 }
 
-static const struct {
-	char *vendor;
-	char *model;
-} hp_sw_dh_data_list[] = {
-	{"COMPAQ", "MSA1000 VOLUME"},
-	{"COMPAQ", "HSV110"},
-	{"HP", "HSV100"},
-	{"DEC", "HSG80"},
-	{NULL, NULL},
-};
-
-static bool hp_sw_match(struct scsi_device *sdev)
-{
-	int i;
-
-	if (scsi_device_tpgs(sdev))
-		return false;
-
-	for (i = 0; hp_sw_dh_data_list[i].vendor; i++) {
-		if (!strncmp(sdev->vendor, hp_sw_dh_data_list[i].vendor,
-			strlen(hp_sw_dh_data_list[i].vendor)) &&
-		    !strncmp(sdev->model, hp_sw_dh_data_list[i].model,
-			strlen(hp_sw_dh_data_list[i].model))) {
-			return true;
-		}
-	}
-	return false;
-}
-
 static struct scsi_dh_data *hp_sw_bus_attach(struct scsi_device *sdev)
 {
 	struct hp_sw_dh_data *h;
@@ -379,7 +350,6 @@ static struct scsi_device_handler hp_sw_dh = {
 	.detach		= hp_sw_bus_detach,
 	.activate	= hp_sw_activate,
 	.prep_fn	= hp_sw_prep_fn,
-	.match		= hp_sw_match,
 };
 
 static int __init hp_sw_init(void)
diff --git a/drivers/scsi/device_handler/scsi_dh_rdac.c b/drivers/scsi/device_handler/scsi_dh_rdac.c
index b46ace3..d89616f 100644
--- a/drivers/scsi/device_handler/scsi_dh_rdac.c
+++ b/drivers/scsi/device_handler/scsi_dh_rdac.c
@@ -778,55 +778,6 @@ static int rdac_check_sense(struct scsi_device *sdev,
 	return SCSI_RETURN_NOT_HANDLED;
 }
 
-static const struct {
-	char *vendor;
-	char *model;
-} rdac_dev_list[] = {
-	{"IBM", "1722"},
-	{"IBM", "1724"},
-	{"IBM", "1726"},
-	{"IBM", "1742"},
-	{"IBM", "1745"},
-	{"IBM", "1746"},
-	{"IBM", "1813"},
-	{"IBM", "1814"},
-	{"IBM", "1815"},
-	{"IBM", "1818"},
-	{"IBM", "3526"},
-	{"SGI", "TP9"},
-	{"SGI", "IS"},
-	{"STK", "OPENstorage D280"},
-	{"STK", "FLEXLINE 380"},
-	{"SUN", "CSM"},
-	{"SUN", "LCSM100"},
-	{"SUN", "STK6580_6780"},
-	{"SUN", "SUN_6180"},
-	{"SUN", "ArrayStorage"},
-	{"DELL", "MD3"},
-	{"NETAPP", "INF-01-00"},
-	{"LSI", "INF-01-00"},
-	{"ENGENIO", "INF-01-00"},
-	{NULL, NULL},
-};
-
-static bool rdac_match(struct scsi_device *sdev)
-{
-	int i;
-
-	if (scsi_device_tpgs(sdev))
-		return false;
-
-	for (i = 0; rdac_dev_list[i].vendor; i++) {
-		if (!strncmp(sdev->vendor, rdac_dev_list[i].vendor,
-			strlen(rdac_dev_list[i].vendor)) &&
-		    !strncmp(sdev->model, rdac_dev_list[i].model,
-			strlen(rdac_dev_list[i].model))) {
-			return true;
-		}
-	}
-	return false;
-}
-
 static struct scsi_dh_data *rdac_bus_attach(struct scsi_device *sdev)
 {
 	struct rdac_dh_data *h;
@@ -895,7 +846,6 @@ static struct scsi_device_handler rdac_dh = {
 	.attach = rdac_bus_attach,
 	.detach = rdac_bus_detach,
 	.activate = rdac_activate,
-	.match = rdac_match,
 };
 
 static int __init rdac_init(void)
diff --git a/drivers/scsi/scsi_dh.c b/drivers/scsi/scsi_dh.c
index 2d6a8bd..8f0a6dc 100644
--- a/drivers/scsi/scsi_dh.c
+++ b/drivers/scsi/scsi_dh.c
@@ -29,6 +29,67 @@
 static DEFINE_SPINLOCK(list_lock);
 static LIST_HEAD(scsi_dh_list);
 
+struct scsi_dh_blist {
+	const char *vendor;
+	const char *model;
+	const char *driver;
+};
+
+static const struct scsi_dh_blist scsi_dh_blist[] = {
+	{"DGC", "RAID",			"clariion" },
+	{"DGC", "DISK",			"clariion" },
+	{"DGC", "VRAID",		"clariion" },
+
+	{"COMPAQ", "MSA1000 VOLUME",	"hp_sw" },
+	{"COMPAQ", "HSV110",		"hp_sw" },
+	{"HP", "HSV100",		"hp_sw"},
+	{"DEC", "HSG80",		"hp_sw"},
+
+	{"IBM", "1722",			"rdac", },
+	{"IBM", "1724",			"rdac", },
+	{"IBM", "1726",			"rdac", },
+	{"IBM", "1742",			"rdac", },
+	{"IBM", "1745",			"rdac", },
+	{"IBM", "1746",			"rdac", },
+	{"IBM", "1813",			"rdac", },
+	{"IBM", "1814",			"rdac", },
+	{"IBM", "1815",			"rdac", },
+	{"IBM", "1818",			"rdac", },
+	{"IBM", "3526",			"rdac", },
+	{"SGI", "TP9",			"rdac", },
+	{"SGI", "IS",			"rdac", },
+	{"STK", "OPENstorage D280",	"rdac", },
+	{"STK", "FLEXLINE 380",		"rdac", },
+	{"SUN", "CSM",			"rdac", },
+	{"SUN", "LCSM100",		"rdac", },
+	{"SUN", "STK6580_6780",		"rdac", },
+	{"SUN", "SUN_6180",		"rdac", },
+	{"SUN", "ArrayStorage",		"rdac", },
+	{"DELL", "MD3",			"rdac", },
+	{"NETAPP", "INF-01-00",		"rdac", },
+	{"LSI", "INF-01-00",		"rdac", },
+	{"ENGENIO", "INF-01-00",	"rdac", },
+	{NULL, NULL,			NULL },
+};
+
+static const char *
+scsi_dh_find_driver(struct scsi_device *sdev)
+{
+	const struct scsi_dh_blist *b;
+
+	if (scsi_device_tpgs(sdev))
+		return "alua";
+
+	for (b = scsi_dh_blist; b->vendor; b++) {
+		if (!strncmp(sdev->vendor, b->vendor, strlen(b->vendor)) &&
+		    !strncmp(sdev->model, b->model, strlen(b->model))) {
+			return b->driver;
+		}
+	}
+	return NULL;
+}
+
+
 static struct scsi_device_handler *__scsi_dh_lookup(const char *name)
 {
 	struct scsi_device_handler *tmp, *found = NULL;
@@ -57,22 +118,6 @@ static struct scsi_device_handler *scsi_dh_lookup(const char *name)
 	return dh;
 }
 
-static struct scsi_device_handler *
-device_handler_match(struct scsi_device *sdev)
-{
-	struct scsi_device_handler *tmp_dh, *found_dh = NULL;
-
-	spin_lock(&list_lock);
-	list_for_each_entry(tmp_dh, &scsi_dh_list, list) {
-		if (tmp_dh->match && tmp_dh->match(sdev)) {
-			found_dh = tmp_dh;
-			break;
-		}
-	}
-	spin_unlock(&list_lock);
-	return found_dh;
-}
-
 /*
  * scsi_dh_handler_attach - Attach a device handler to a device
  * @sdev - SCSI device the device handler should attach to
@@ -183,14 +228,17 @@ static struct device_attribute scsi_dh_state_attr =
 
 int scsi_dh_add_device(struct scsi_device *sdev)
 {
-	struct scsi_device_handler *devinfo;
+	struct scsi_device_handler *devinfo = NULL;
+	const char *drv;
 	int err;
 
 	err = device_create_file(&sdev->sdev_gendev, &scsi_dh_state_attr);
 	if (err)
 		return err;
 
-	devinfo = device_handler_match(sdev);
+	drv = scsi_dh_find_driver(sdev);
+	if (drv)
+		devinfo = scsi_dh_lookup(drv);
 	if (devinfo)
 		err = scsi_dh_handler_attach(sdev, devinfo);
 	return err;
diff --git a/include/scsi/scsi_device.h b/include/scsi/scsi_device.h
index f4461cd..409e15b 100644
--- a/include/scsi/scsi_device.h
+++ b/include/scsi/scsi_device.h
@@ -214,7 +214,6 @@ struct scsi_device_handler {
 	int (*activate)(struct scsi_device *, activate_complete, void *);
 	int (*prep_fn)(struct scsi_device *, struct request *);
 	int (*set_params)(struct scsi_device *, const char *);
-	bool (*match)(struct scsi_device *);
 };
 
 struct scsi_dh_data {
-- 
1.8.5.6

