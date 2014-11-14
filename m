From: Don Brace <don.brace@pmcs.com>
Subject: [PATCH 06/13] hpsa: fix allocation sizes for CISS_REPORT_LUNs
 commands
Date: Fri, 14 Nov 2014 17:26:54 -0600
Message-ID: <20141114232653.20808.56914.stgit@don-ProLiant-MicroServer-Gen8>
References: <20141114231145.20808.76898.stgit@don-ProLiant-MicroServer-Gen8>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g4t3426.houston.hp.com ([15.201.208.54]:58544 "EHLO
	g4t3426.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422933AbaKNXZT (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 14 Nov 2014 18:25:19 -0500
In-Reply-To: <20141114231145.20808.76898.stgit@don-ProLiant-MicroServer-Gen8>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: hch@infradead.org, webb.scales@hp.com, james.bottomley@parallels.com, brace@pmcs.com
Cc: linux-scsi@vger.kernel.org

From: Stephen M. Cameron <stephenmcameron@gmail.com>

We were allocating roughly double the amount of memory
we should be due to ReportLUNdata and ExtendedReportLUNdata
containing a non-zero sized array but adding extra memory
to allocate as if the array were zero sized.

Track the logical and physical sizes separately.
Allocate the memory based on the specific data
structure sizes.



Signed-off-by: Don Brace <don.brace@pmcs.com>
Reviewed-by: Webb Scales <webb.scales@hp.com>
---
 drivers/scsi/hpsa.c     |   14 +++++++-------
 drivers/scsi/hpsa_cmd.h |    2 +-
 2 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index 538fdea..a221f7b 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -2893,7 +2893,7 @@ static int hpsa_get_pdisk_of_ioaccel2(struct ctlr_info *h,
  * Returns 0 on success, -1 otherwise.
  */
 static int hpsa_gather_lun_info(struct ctlr_info *h,
-	int reportlunsize,
+	int reportphyslunsize, int reportloglunsize,
 	struct ReportLUNdata *physdev, u32 *nphysicals, int *physical_mode,
 	struct ReportLUNdata *logdev, u32 *nlogicals)
 {
@@ -2907,7 +2907,7 @@ static int hpsa_gather_lun_info(struct ctlr_info *h,
 		*physical_mode = HPSA_REPORT_PHYS_EXTENDED;
 		physical_entry_size = 24;
 	}
-	if (hpsa_scsi_do_report_phys_luns(h, physdev, reportlunsize,
+	if (hpsa_scsi_do_report_phys_luns(h, physdev, reportphyslunsize,
 							*physical_mode)) {
 		dev_err(&h->pdev->dev, "report physical LUNs failed.\n");
 		return -1;
@@ -2920,7 +2920,7 @@ static int hpsa_gather_lun_info(struct ctlr_info *h,
 			*nphysicals - HPSA_MAX_PHYS_LUN);
 		*nphysicals = HPSA_MAX_PHYS_LUN;
 	}
-	if (hpsa_scsi_do_report_log_luns(h, logdev, reportlunsize)) {
+	if (hpsa_scsi_do_report_log_luns(h, logdev, reportloglunsize)) {
 		dev_err(&h->pdev->dev, "report logical LUNs failed.\n");
 		return -1;
 	}
@@ -3013,15 +3013,14 @@ static void hpsa_update_scsi_devices(struct ctlr_info *h, int hostno)
 	u32 ndev_allocated = 0;
 	struct hpsa_scsi_dev_t **currentsd, *this_device, *tmpdevice;
 	int ncurrent = 0;
-	int reportlunsize = sizeof(*physdev_list) + HPSA_MAX_PHYS_LUN * 24;
 	int i, n_ext_target_devs, ndevs_to_allocate;
 	int raid_ctlr_position;
 	int rescan_hba_mode;
 	DECLARE_BITMAP(lunzerobits, MAX_EXT_TARGETS);
 
 	currentsd = kzalloc(sizeof(*currentsd) * HPSA_MAX_DEVICES, GFP_KERNEL);
-	physdev_list = kzalloc(reportlunsize, GFP_KERNEL);
-	logdev_list = kzalloc(reportlunsize, GFP_KERNEL);
+	physdev_list = kzalloc(sizeof(*physdev_list), GFP_KERNEL);
+	logdev_list = kzalloc(sizeof(*logdev_list), GFP_KERNEL);
 	tmpdevice = kzalloc(sizeof(*tmpdevice), GFP_KERNEL);
 
 	if (!currentsd || !physdev_list || !logdev_list || !tmpdevice) {
@@ -3041,7 +3040,8 @@ static void hpsa_update_scsi_devices(struct ctlr_info *h, int hostno)
 
 	h->hba_mode_enabled = rescan_hba_mode;
 
-	if (hpsa_gather_lun_info(h, reportlunsize,
+	if (hpsa_gather_lun_info(h,
+			sizeof(*physdev_list), sizeof(*logdev_list),
 			(struct ReportLUNdata *) physdev_list, &nphysicals,
 			&physical_mode, logdev_list, &nlogicals))
 		goto out;
diff --git a/drivers/scsi/hpsa_cmd.h b/drivers/scsi/hpsa_cmd.h
index b5125dc..9b19042f 100644
--- a/drivers/scsi/hpsa_cmd.h
+++ b/drivers/scsi/hpsa_cmd.h
@@ -252,7 +252,7 @@ struct ReportExtendedLUNdata {
 	u8 LUNListLength[4];
 	u8 extended_response_flag;
 	u8 reserved[3];
-	struct ext_report_lun_entry LUN[HPSA_MAX_LUN];
+	struct ext_report_lun_entry LUN[HPSA_MAX_PHYS_LUN];
 };
 
 struct SenseSubsystem_info {

