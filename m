From: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>
Subject: [PATCH 2/9] hpsa: revert hide logical drives with format in progress
	from linux
Date: Wed, 04 Dec 2013 17:09:57 -0600
Message-ID: <20131204230957.21798.39979.stgit@beardog.cce.hp.com>
References: <20131204230123.21798.93593.stgit@beardog.cce.hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g4t0017.houston.hp.com ([15.201.24.20]:39580 "EHLO
	g4t0017.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752563Ab3LDXJ5 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 4 Dec 2013 18:09:57 -0500
In-Reply-To: <20131204230123.21798.93593.stgit@beardog.cce.hp.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: james.bottomley@hansenpartnership.com
Cc: stephenmcameron@gmail.com, mikem@beardog.cce.hp.com, thenzl@redhat.com, linux-scsi@vger.kernel.org, scott.teel@hp.com

From: Stephen M. Cameron <scameron@beardog.cce.hp.com>

This relies on a kernel thread which I wish to replace with a
work queue based solution.

Signed-off-by: Stephen M. Cameron <scameron@beardog.cce.hp.com>
---
 drivers/scsi/hpsa.c |   50 ++------------------------------------------------
 drivers/scsi/hpsa.h |    1 -
 2 files changed, 2 insertions(+), 49 deletions(-)

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index 961332b..75800f7 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -1007,20 +1007,6 @@ static void adjust_hpsa_scsi_table(struct ctlr_info *h, int hostno,
 	for (i = 0; i < nsds; i++) {
 		if (!sd[i]) /* if already added above. */
 			continue;
-
-		/* Don't add devices which are NOT READY, FORMAT IN PROGRESS
-		 * as the SCSI mid-layer does not handle such devices well.
-		 * It relentlessly loops sending TUR at 3Hz, then READ(10)
-		 * at 160Hz, and prevents the system from coming up.
-		 */
-		if (sd[i]->format_in_progress) {
-			dev_info(&h->pdev->dev,
-				"Logical drive format in progress, device c%db%dt%dl%d offline.\n",
-				h->scsi_host->host_no,
-				sd[i]->bus, sd[i]->target, sd[i]->lun);
-			continue;
-		}
-
 		device_change = hpsa_scsi_find_entry(sd[i], h->dev,
 					h->ndevices, &entry);
 		if (device_change == DEVICE_NOT_FOUND) {
@@ -1726,34 +1712,6 @@ static inline void hpsa_set_bus_target_lun(struct hpsa_scsi_dev_t *device,
 	device->lun = lun;
 }
 
-static unsigned char hpsa_format_in_progress(struct ctlr_info *h,
-		unsigned char scsi3addr[])
-{
-	struct CommandList *c;
-	unsigned char *sense, sense_key, asc, ascq;
-#define ASC_LUN_NOT_READY 0x04
-#define ASCQ_LUN_NOT_READY_FORMAT_IN_PROGRESS 0x04
-
-
-	c = cmd_special_alloc(h);
-	if (!c)
-		return 0;
-	fill_cmd(c, TEST_UNIT_READY, h, NULL, 0, 0, scsi3addr, TYPE_CMD);
-	hpsa_scsi_do_simple_cmd_core(h, c);
-	sense = c->err_info->SenseInfo;
-	sense_key = sense[2];
-	asc = sense[12];
-	ascq = sense[13];
-	if (c->err_info->CommandStatus == CMD_TARGET_STATUS &&
-		c->err_info->ScsiStatus == SAM_STAT_CHECK_CONDITION &&
-		sense_key == NOT_READY &&
-		asc == ASC_LUN_NOT_READY &&
-		ascq == ASCQ_LUN_NOT_READY_FORMAT_IN_PROGRESS)
-		return 1;
-	cmd_special_free(h, c);
-	return 0;
-}
-
 static int hpsa_update_device_info(struct ctlr_info *h,
 	unsigned char scsi3addr[], struct hpsa_scsi_dev_t *this_device,
 	unsigned char *is_OBDR_device)
@@ -1792,14 +1750,10 @@ static int hpsa_update_device_info(struct ctlr_info *h,
 		sizeof(this_device->device_id));
 
 	if (this_device->devtype == TYPE_DISK &&
-		is_logical_dev_addr_mode(scsi3addr)) {
+		is_logical_dev_addr_mode(scsi3addr))
 		hpsa_get_raid_level(h, scsi3addr, &this_device->raid_level);
-		this_device->format_in_progress =
-			hpsa_format_in_progress(h, scsi3addr);
-	} else {
+	else
 		this_device->raid_level = RAID_UNKNOWN;
-		this_device->format_in_progress = 0;
-	}
 
 	if (is_OBDR_device) {
 		/* See if this is a One-Button-Disaster-Recovery device
diff --git a/drivers/scsi/hpsa.h b/drivers/scsi/hpsa.h
index 04074f5..5f3f72f 100644
--- a/drivers/scsi/hpsa.h
+++ b/drivers/scsi/hpsa.h
@@ -46,7 +46,6 @@ struct hpsa_scsi_dev_t {
 	unsigned char vendor[8];        /* bytes 8-15 of inquiry data */
 	unsigned char model[16];        /* bytes 16-31 of inquiry data */
 	unsigned char raid_level;	/* from inquiry page 0xC1 */
-	unsigned char format_in_progress;
 };
 
 struct reply_pool {

