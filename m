From: Don Brace <don.brace@microsemi.com>
Subject: [PATCH 2/7] smartpqi: enhance BMIC cache flush
Date: Thu, 10 Aug 2017 13:46:45 -0500
Message-ID: <150239080533.23771.3801846126568566831.stgit@brunhilda>
References: <150239072706.23771.1380444570336852695.stgit@brunhilda>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-by2nam01on0075.outbound.protection.outlook.com ([104.47.34.75]:49216
        "EHLO NAM01-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1753010AbdHJSrQ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 10 Aug 2017 14:47:16 -0400
In-Reply-To: <150239072706.23771.1380444570336852695.stgit@brunhilda>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: joseph.szczypek@hpe.com, gerry.morong@microsemi.com, john.hall@microsemi.com, jejb@linux.vnet.ibm.com, Kevin.Barnett@microsemi.com, Mahesh.Rajashekhara@microsemi.com, bader.alisaleh@microsemi.com, hch@infradead.org, scott.teel@microsemi.com, Viswas.G@microsemi.com, Justin.Lindley@microsemi.com, scott.benesh@microsemi.com, POSWALD@suse.com
Cc: linux-scsi@vger.kernel.org

From: Kevin Barnett <kevin.barnett@microseim.com>

 - distinguish between shutdown and non-shutdown.

Reviewed-by: Scott Benesh <scott.benesh@microsemi.com>
Signed-off-by: Kevin Barnett <kevin.barnett@microsemi.com>
Signed-off-by: Don Brace <don.brace@microsemi.com>
---
 drivers/scsi/smartpqi/smartpqi.h      |   21 +++++++++++++++++++--
 drivers/scsi/smartpqi/smartpqi_init.c |   27 ++++++++++++++-------------
 2 files changed, 33 insertions(+), 15 deletions(-)

diff --git a/drivers/scsi/smartpqi/smartpqi.h b/drivers/scsi/smartpqi/smartpqi.h
index 6dd0449..dc3a054 100644
--- a/drivers/scsi/smartpqi/smartpqi.h
+++ b/drivers/scsi/smartpqi/smartpqi.h
@@ -1079,9 +1079,9 @@ enum pqi_ctrl_mode {
 #define BMIC_SENSE_CONTROLLER_PARAMETERS	0x64
 #define BMIC_SENSE_SUBSYSTEM_INFORMATION	0x66
 #define BMIC_WRITE_HOST_WELLNESS		0xa5
-#define BMIC_CACHE_FLUSH			0xc2
+#define BMIC_FLUSH_CACHE			0xc2
 
-#define SA_CACHE_FLUSH				0x1
+#define SA_FLUSH_CACHE				0x1
 
 #define MASKED_DEVICE(lunid)			((lunid)[3] & 0xc0)
 #define CISS_GET_LEVEL_2_BUS(lunid)		((lunid)[7] & 0x3f)
@@ -1187,6 +1187,23 @@ struct bmic_identify_physical_device {
 	u8	padding_to_multiple_of_512[9];
 };
 
+struct bmic_flush_cache {
+	u8	disable_flag;
+	u8	system_power_action;
+	u8	ndu_flush;
+	u8	shutdown_event;
+	u8	reserved[28];
+};
+
+/* for shutdown_event member of struct bmic_flush_cache */
+enum bmic_flush_cache_shutdown_event {
+	NONE_CACHE_FLUSH_ONLY = 0,
+	SHUTDOWN = 1,
+	HIBERNATE = 2,
+	SUSPEND = 3,
+	RESTART = 4
+};
+
 #pragma pack()
 
 int pqi_add_sas_host(struct Scsi_Host *shost, struct pqi_ctrl_info *ctrl_info);
diff --git a/drivers/scsi/smartpqi/smartpqi_init.c b/drivers/scsi/smartpqi/smartpqi_init.c
index ffdc32b..b36d338 100644
--- a/drivers/scsi/smartpqi/smartpqi_init.c
+++ b/drivers/scsi/smartpqi/smartpqi_init.c
@@ -431,10 +431,10 @@ static int pqi_build_raid_path_request(struct pqi_ctrl_info *ctrl_info,
 		cdb[1] = CISS_GET_RAID_MAP;
 		put_unaligned_be32(buffer_length, &cdb[6]);
 		break;
-	case SA_CACHE_FLUSH:
+	case SA_FLUSH_CACHE:
 		request->data_direction = SOP_WRITE_FLAG;
 		cdb[0] = BMIC_WRITE;
-		cdb[6] = BMIC_CACHE_FLUSH;
+		cdb[6] = BMIC_FLUSH_CACHE;
 		put_unaligned_be16(buffer_length, &cdb[7]);
 		break;
 	case BMIC_IDENTIFY_CONTROLLER:
@@ -585,14 +585,13 @@ static int pqi_identify_physical_device(struct pqi_ctrl_info *ctrl_info,
 	return rc;
 }
 
-#define SA_CACHE_FLUSH_BUFFER_LENGTH	4
-
-static int pqi_flush_cache(struct pqi_ctrl_info *ctrl_info)
+static int pqi_flush_cache(struct pqi_ctrl_info *ctrl_info,
+	enum bmic_flush_cache_shutdown_event shutdown_event)
 {
 	int rc;
 	struct pqi_raid_path_request request;
 	int pci_direction;
-	u8 *buffer;
+	struct bmic_flush_cache *flush_cache;
 
 	/*
 	 * Don't bother trying to flush the cache if the controller is
@@ -601,13 +600,15 @@ static int pqi_flush_cache(struct pqi_ctrl_info *ctrl_info)
 	if (pqi_ctrl_offline(ctrl_info))
 		return -ENXIO;
 
-	buffer = kzalloc(SA_CACHE_FLUSH_BUFFER_LENGTH, GFP_KERNEL);
-	if (!buffer)
+	flush_cache = kzalloc(sizeof(*flush_cache), GFP_KERNEL);
+	if (!flush_cache)
 		return -ENOMEM;
 
+	flush_cache->shutdown_event = shutdown_event;
+
 	rc = pqi_build_raid_path_request(ctrl_info, &request,
-		SA_CACHE_FLUSH, RAID_CTLR_LUNID, buffer,
-		SA_CACHE_FLUSH_BUFFER_LENGTH, 0, &pci_direction);
+		SA_FLUSH_CACHE, RAID_CTLR_LUNID, flush_cache,
+		sizeof(*flush_cache), 0, &pci_direction);
 	if (rc)
 		goto out;
 
@@ -618,7 +619,7 @@ static int pqi_flush_cache(struct pqi_ctrl_info *ctrl_info)
 		pci_direction);
 
 out:
-	kfree(buffer);
+	kfree(flush_cache);
 
 	return rc;
 }
@@ -6693,7 +6694,7 @@ static void pqi_shutdown(struct pci_dev *pci_dev)
 	 * Write all data in the controller's battery-backed cache to
 	 * storage.
 	 */
-	rc = pqi_flush_cache(ctrl_info);
+	rc = pqi_flush_cache(ctrl_info, SHUTDOWN);
 	if (rc == 0)
 		return;
 
@@ -6737,7 +6738,7 @@ static __maybe_unused int pqi_suspend(struct pci_dev *pci_dev, pm_message_t stat
 	pqi_cancel_rescan_worker(ctrl_info);
 	pqi_wait_until_scan_finished(ctrl_info);
 	pqi_wait_until_lun_reset_finished(ctrl_info);
-	pqi_flush_cache(ctrl_info);
+	pqi_flush_cache(ctrl_info, SUSPEND);
 	pqi_ctrl_block_requests(ctrl_info);
 	pqi_ctrl_wait_until_quiesced(ctrl_info);
 	pqi_wait_until_inbound_queues_empty(ctrl_info);
