From: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>
Subject: [PATCH 07/10] hpsa: hide logical drives with format in progress from
	linux
Date: Mon, 23 Sep 2013 13:34:01 -0500
Message-ID: <20130923183401.19995.99662.stgit@beardog.cce.hp.com>
References: <20130923183128.19995.7669.stgit@beardog.cce.hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g4t0017.houston.hp.com ([15.201.24.20]:30287 "EHLO
	g4t0017.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753819Ab3IWSeD (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 23 Sep 2013 14:34:03 -0400
In-Reply-To: <20130923183128.19995.7669.stgit@beardog.cce.hp.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: james.bottomley@hansenpartnership.com
Cc: stephenmcameron@gmail.com, mikem@beardog.cce.hp.com, thenzl@redhat.com, linux-scsi@vger.kernel.org, scott.teel@hp.com

From: Stephen M. Cameron <scameron@beardog.cce.hp.com>

SCSI mid layer doesn't seem to handle logical drives undergoing format
very well.  scsi_add_device on such devices seems to result in hitting
those devices with a TUR at a rate of 3Hz for awhile, transitioning
to hitting them with a READ(10) at a much higher rate indefinitely,
and at boot time, this prevents the system from coming up.  If we
do not expose such devices to the kernel, it isn't bothered by them.

Signed-off-by: Stephen M. Cameron <scameron@beardog.cce.hp.com>
---
 drivers/scsi/hpsa.c |   50 ++++++++++++++++++++++++++++++++++++++++++++++++--
 drivers/scsi/hpsa.h |    1 +
 2 files changed, 49 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index b7f405f..38e3af4 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -1010,6 +1010,20 @@ static void adjust_hpsa_scsi_table(struct ctlr_info *h, int hostno,
 	for (i = 0; i < nsds; i++) {
 		if (!sd[i]) /* if already added above. */
 			continue;
+
+		/* Don't add devices which are NOT READY, FORMAT IN PROGRESS
+		 * as the SCSI mid-layer does not handle such devices well.
+		 * It relentlessly loops sending TUR at 3Hz, then READ(10)
+		 * at 160Hz, and prevents the system from coming up.
+		 */
+		if (sd[i]->format_in_progress) {
+			dev_info(&h->pdev->dev,
+				"Logical drive format in progress, device c%db%dt%dl%d offline.\n",
+				h->scsi_host->host_no,
+				sd[i]->bus, sd[i]->target, sd[i]->lun);
+			continue;
+		}
+
 		device_change = hpsa_scsi_find_entry(sd[i], h->dev,
 					h->ndevices, &entry);
 		if (device_change == DEVICE_NOT_FOUND) {
@@ -1715,6 +1729,34 @@ static inline void hpsa_set_bus_target_lun(struct hpsa_scsi_dev_t *device,
 	device->lun = lun;
 }
 
+static unsigned char hpsa_format_in_progress(struct ctlr_info *h,
+		unsigned char scsi3addr[])
+{
+	struct CommandList *c;
+	unsigned char *sense, sense_key, asc, ascq;
+#define ASC_LUN_NOT_READY 0x04
+#define ASCQ_LUN_NOT_READY_FORMAT_IN_PROGRESS 0x04
+
+
+	c = cmd_special_alloc(h);
+	if (!c)
+		return 0;
+	fill_cmd(c, TEST_UNIT_READY, h, NULL, 0, 0, scsi3addr, TYPE_CMD);
+	hpsa_scsi_do_simple_cmd_core(h, c);
+	sense = c->err_info->SenseInfo;
+	sense_key = sense[2];
+	asc = sense[12];
+	ascq = sense[13];
+	if (c->err_info->CommandStatus == CMD_TARGET_STATUS &&
+		c->err_info->ScsiStatus == SAM_STAT_CHECK_CONDITION &&
+		sense_key == NOT_READY &&
+		asc == ASC_LUN_NOT_READY &&
+		ascq == ASCQ_LUN_NOT_READY_FORMAT_IN_PROGRESS)
+		return 1;
+	cmd_special_free(h, c);
+	return 0;
+}
+
 static int hpsa_update_device_info(struct ctlr_info *h,
 	unsigned char scsi3addr[], struct hpsa_scsi_dev_t *this_device,
 	unsigned char *is_OBDR_device)
@@ -1753,10 +1795,14 @@ static int hpsa_update_device_info(struct ctlr_info *h,
 		sizeof(this_device->device_id));
 
 	if (this_device->devtype == TYPE_DISK &&
-		is_logical_dev_addr_mode(scsi3addr))
+		is_logical_dev_addr_mode(scsi3addr)) {
 		hpsa_get_raid_level(h, scsi3addr, &this_device->raid_level);
-	else
+		this_device->format_in_progress =
+			hpsa_format_in_progress(h, scsi3addr);
+	} else {
 		this_device->raid_level = RAID_UNKNOWN;
+		this_device->format_in_progress = 0;
+	}
 
 	if (is_OBDR_device) {
 		/* See if this is a One-Button-Disaster-Recovery device
diff --git a/drivers/scsi/hpsa.h b/drivers/scsi/hpsa.h
index bc85e72..4fd0d45 100644
--- a/drivers/scsi/hpsa.h
+++ b/drivers/scsi/hpsa.h
@@ -46,6 +46,7 @@ struct hpsa_scsi_dev_t {
 	unsigned char vendor[8];        /* bytes 8-15 of inquiry data */
 	unsigned char model[16];        /* bytes 16-31 of inquiry data */
 	unsigned char raid_level;	/* from inquiry page 0xC1 */
+	unsigned char format_in_progress;
 };
 
 struct reply_pool {

