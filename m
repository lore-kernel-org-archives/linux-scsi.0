From: Don Brace <don.brace@microsemi.com>
Subject: [PATCH V3 03/14] hpsa: update identify physical device structure
Date: Thu, 4 May 2017 14:08:19 -0500
Message-ID: <149392489917.10271.3680761871513413041.stgit@brunhilda>
References: <149392483740.10271.14468343789177475526.stgit@brunhilda>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bl2nam02on0042.outbound.protection.outlook.com ([104.47.38.42]:60384
        "EHLO NAM02-BL2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1754514AbdEDTIX (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 4 May 2017 15:08:23 -0400
In-Reply-To: <149392483740.10271.14468343789177475526.stgit@brunhilda>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: joseph.szczypek@hpe.com, gerry.morong@microsemi.com, john.hall@microsemi.com, jejb@linux.vnet.ibm.com, Kevin.Barnett@microsemi.com, Mahesh.Rajashekhara@microsemi.com, bader.alisaleh@microsemi.com, hch@infradead.org, scott.teel@microsemi.com, Viswas.G@microsemi.com, Justin.Lindley@microsemi.com, scott.benesh@microsemi.com, POSWALD@suse.com
Cc: linux-scsi@vger.kernel.org

 - align with latest spec.
 - added __attribute((aligned(512)))

Reviewed-by: Scott Teel <scott.teel@microsemi.com>
Reviewed-by: Scott Benesh <scott.benesh@microsemi.com>
Reviewed-by: Kevin Barnett <kevin.barnett@microsemi.com>
Signed-off-by: Don Brace <don.brace@microsemi.com>
---
 drivers/scsi/hpsa_cmd.h |   20 ++++++++++++++------
 1 file changed, 14 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/hpsa_cmd.h b/drivers/scsi/hpsa_cmd.h
index 5961705..078afe4 100644
--- a/drivers/scsi/hpsa_cmd.h
+++ b/drivers/scsi/hpsa_cmd.h
@@ -809,10 +809,7 @@ struct bmic_identify_physical_device {
 	u8     max_temperature_degreesC;
 	u8     logical_blocks_per_phys_block_exp; /* phyblocksize = 512*2^exp */
 	__le16 current_queue_depth_limit;
-	u8     switch_name[10];
-	__le16 switch_port;
-	u8     alternate_paths_switch_name[40];
-	u8     alternate_paths_switch_port[8];
+	u8     reserved_switch_stuff[60];
 	__le16 power_on_hours; /* valid only if gas gauge supported */
 	__le16 percent_endurance_used; /* valid only if gas gauge supported. */
 #define BMIC_PHYS_DRIVE_SSD_WEAROUT(idphydrv) \
@@ -828,11 +825,22 @@ struct bmic_identify_physical_device {
 	(idphydrv->smart_carrier_authentication == 0x01)
 	u8     smart_carrier_app_fw_version;
 	u8     smart_carrier_bootloader_fw_version;
+	u8     sanitize_support_flags;
+	u8     drive_key_flags;
 	u8     encryption_key_name[64];
 	__le32 misc_drive_flags;
 	__le16 dek_index;
-	u8     padding[112];
-};
+	__le16 hba_drive_encryption_flags;
+	__le16 max_overwrite_time;
+	__le16 max_block_erase_time;
+	__le16 max_crypto_erase_time;
+	u8     device_connector_info[5];
+	u8     connector_name[8][8];
+	u8     page_83_id[16];
+	u8     max_link_rate[256];
+	u8     neg_phys_link_rate[256];
+	u8     box_conn_name[8];
+} __attribute((aligned(512)));
 
 struct bmic_sense_subsystem_info {
 	u8	primary_slot_number;
