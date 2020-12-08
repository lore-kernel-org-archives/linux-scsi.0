Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.5 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8D6F0C2BBCF
	for <linux-scsi@archiver.kernel.org>; Tue,  8 Dec 2020 20:26:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6349823A7B
	for <linux-scsi@archiver.kernel.org>; Tue,  8 Dec 2020 20:26:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728768AbgLHU0l (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 8 Dec 2020 15:26:41 -0500
Received: from esa3.microchip.iphmx.com ([68.232.153.233]:25999 "EHLO
        esa3.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728685AbgLHU0i (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 8 Dec 2020 15:26:38 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1607459197; x=1638995197;
  h=subject:from:to:cc:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=3LoCXfVxE/rH9YAUW9zjN9mzugc2CLHP3DkRTvElokM=;
  b=oKWF0rh6a0hzUyGNg10G8RYd27SA5Vv3Y+rq9RfaD7gfhhdNLPcwAwPg
   ghPHpWBkwl6FJWOLylWlubrN7hO02TUEfQgQLKDrMEDEPF+P6mrkXfbT1
   aAmp+vtBVDd+SasrJ8JXARSxpUbqInEH5MycVKUI+18b5F8qTbOYri73z
   6yCWp+mJwcfELFuKQXJ8XDRZ7itEproQl9nHUf5sMVMxW8mqwoCj0Ye7E
   Z1MuxKSWGWj7aFpik6PakdZRSelyT+ofFfSOpmCNDHCjfWfT/14CWNK0A
   hXqk+8j2dX8G2YuF7dFMvWn50cfGKTaxGTzf2IbIwWFm1NW0WkA4g8CqS
   g==;
IronPort-SDR: A8YV2PpHfHXSB2u7pTr9zqfwlwXrpZZc7k9PF/kMxfWCSoBk82b1C8O4MgTXSpzLiWdLXGl4Du
 8MXYQUPyxyv1nUwKmlkTnN2xoRPvwAUIy7cFLIA4ecbIVh7FSjj6k6byOyRctC1RI1Twf/O59s
 hwdECJugycTqMK1UpQFILGI0GX7vdbYQNX+NO/zOWVkhehWFqDML1Jm8LqCF3C2C5+8sH57SmO
 TSjROu8Mj2XAyweXPeOVJhyFfiqjjXPofGJ/d0weF7oYezK8lFD5MpL1y04ivSKGQ+ewy6XMSD
 1PA=
X-IronPort-AV: E=Sophos;i="5.78,403,1599548400"; 
   d="scan'208";a="102012080"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa3.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 08 Dec 2020 12:37:28 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Tue, 8 Dec 2020 12:37:28 -0700
Received: from [127.0.1.1] (10.10.115.15) by chn-vm-ex01.mchp-main.com
 (10.10.85.143) with Microsoft SMTP Server id 15.1.1979.3 via Frontend
 Transport; Tue, 8 Dec 2020 12:37:27 -0700
Subject: [PATCH V2 09/25] smartpqi: align code with oob driver
From:   Don Brace <don.brace@microchip.com>
To:     <Kevin.Barnett@microchip.com>, <scott.teel@microchip.com>,
        <Justin.Lindley@microchip.com>, <scott.benesh@microchip.com>,
        <gerry.morong@microchip.com>, <mahesh.rajashekhara@microchip.com>,
        <hch@infradead.org>, <jejb@linux.vnet.ibm.com>,
        <joseph.szczypek@hpe.com>, <POSWALD@suse.com>
CC:     <linux-scsi@vger.kernel.org>
Date:   Tue, 8 Dec 2020 13:37:27 -0600
Message-ID: <160745624742.13450.4250823033315829317.stgit@brunhilda>
In-Reply-To: <160745609917.13450.11882890596851148601.stgit@brunhilda>
References: <160745609917.13450.11882890596851148601.stgit@brunhilda>
User-Agent: StGit/0.23-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Kevin Barnett <kevin.barnett@microchip.com>

* Non-functional changes.
* Reduce differences between out-of-box driver and
  kernel.org driver.

Reviewed-by: Scott Benesh <scott.benesh@microchip.com>
Reviewed-by: Scott Teel <scott.teel@microchip.com>
Signed-off-by: Kevin Barnett <kevin.barnett@microchip.com>
Signed-off-by: Don Brace <don.brace@microchip.com>
---
 drivers/scsi/smartpqi/smartpqi.h               |   54 +++---
 drivers/scsi/smartpqi/smartpqi_init.c          |  232 +++++++++---------------
 drivers/scsi/smartpqi/smartpqi_sas_transport.c |   10 +
 drivers/scsi/smartpqi/smartpqi_sis.c           |    4 
 4 files changed, 119 insertions(+), 181 deletions(-)

diff --git a/drivers/scsi/smartpqi/smartpqi.h b/drivers/scsi/smartpqi/smartpqi.h
index f33244def944..a5e271dd2742 100644
--- a/drivers/scsi/smartpqi/smartpqi.h
+++ b/drivers/scsi/smartpqi/smartpqi.h
@@ -129,7 +129,7 @@ struct pqi_iu_header {
 	__le16	iu_length;	/* in bytes - does not include the length */
 				/* of this header */
 	__le16	response_queue_id;	/* specifies the OQ where the */
-					/*   response IU is to be delivered */
+					/* response IU is to be delivered */
 	u8	work_area[2];	/* reserved for driver use */
 };
 
@@ -281,8 +281,7 @@ struct pqi_raid_path_request {
 	u8	cdb[16];
 	u8	reserved6[12];
 	__le32	timeout;
-	struct pqi_sg_descriptor
-		sg_descriptors[PQI_MAX_EMBEDDED_SG_DESCRIPTORS];
+	struct pqi_sg_descriptor sg_descriptors[PQI_MAX_EMBEDDED_SG_DESCRIPTORS];
 };
 
 struct pqi_aio_path_request {
@@ -309,8 +308,7 @@ struct pqi_aio_path_request {
 	u8	cdb_length;
 	u8	lun_number[8];
 	u8	reserved4[4];
-	struct pqi_sg_descriptor
-		sg_descriptors[PQI_MAX_EMBEDDED_SG_DESCRIPTORS];
+	struct pqi_sg_descriptor sg_descriptors[PQI_MAX_EMBEDDED_SG_DESCRIPTORS];
 };
 
 #define PQI_RAID1_NVME_XFER_LIMIT	(32 * 1024)	/* 32 KiB */
@@ -421,7 +419,7 @@ struct pqi_event_config {
 
 #define PQI_EVENT_OFA_MEMORY_ALLOCATION	0x0
 #define PQI_EVENT_OFA_QUIESCE		0x1
-#define PQI_EVENT_OFA_CANCELLED		0x2
+#define PQI_EVENT_OFA_CANCELED		0x2
 
 struct pqi_event_response {
 	struct pqi_iu_header header;
@@ -726,7 +724,7 @@ struct pqi_admin_queues_aligned {
 struct pqi_admin_queues {
 	void		*iq_element_array;
 	void		*oq_element_array;
-	pqi_index_t	*iq_ci;
+	pqi_index_t __iomem *iq_ci;
 	pqi_index_t __iomem *oq_pi;
 	dma_addr_t	iq_element_array_bus_addr;
 	dma_addr_t	oq_element_array_bus_addr;
@@ -751,8 +749,8 @@ struct pqi_queue_group {
 	dma_addr_t	oq_element_array_bus_addr;
 	__le32 __iomem	*iq_pi[2];
 	pqi_index_t	iq_pi_copy[2];
-	pqi_index_t __iomem	*iq_ci[2];
-	pqi_index_t __iomem	*oq_pi;
+	pqi_index_t __iomem *iq_ci[2];
+	pqi_index_t __iomem *oq_pi;
 	dma_addr_t	iq_ci_bus_addr[2];
 	dma_addr_t	oq_pi_bus_addr;
 	__le32 __iomem	*oq_ci;
@@ -765,7 +763,7 @@ struct pqi_event_queue {
 	u16		oq_id;
 	u16		int_msg_num;
 	void		*oq_element_array;
-	pqi_index_t __iomem	*oq_pi;
+	pqi_index_t __iomem *oq_pi;
 	dma_addr_t	oq_element_array_bus_addr;
 	dma_addr_t	oq_pi_bus_addr;
 	__le32 __iomem	*oq_ci;
@@ -836,22 +834,22 @@ struct pqi_config_table_firmware_features {
 /*	__le16	host_max_known_feature; */
 };
 
-#define PQI_FIRMWARE_FEATURE_OFA			0
-#define PQI_FIRMWARE_FEATURE_SMP			1
-#define PQI_FIRMWARE_FEATURE_MAX_KNOWN_FEATURE		2
-#define PQI_FIRMWARE_FEATURE_RAID_0_READ_BYPASS		3
-#define PQI_FIRMWARE_FEATURE_RAID_1_READ_BYPASS		4
-#define PQI_FIRMWARE_FEATURE_RAID_5_READ_BYPASS		5
-#define PQI_FIRMWARE_FEATURE_RAID_6_READ_BYPASS		6
-#define PQI_FIRMWARE_FEATURE_RAID_0_WRITE_BYPASS	7
-#define PQI_FIRMWARE_FEATURE_RAID_1_WRITE_BYPASS	8
-#define PQI_FIRMWARE_FEATURE_RAID_5_WRITE_BYPASS	9
-#define PQI_FIRMWARE_FEATURE_RAID_6_WRITE_BYPASS	10
-#define PQI_FIRMWARE_FEATURE_SOFT_RESET_HANDSHAKE	11
-#define PQI_FIRMWARE_FEATURE_UNIQUE_SATA_WWN		12
-#define PQI_FIRMWARE_FEATURE_RAID_IU_TIMEOUT		13
-#define PQI_FIRMWARE_FEATURE_TMF_IU_TIMEOUT		14
-#define PQI_FIRMWARE_FEATURE_MAXIMUM			14
+#define PQI_FIRMWARE_FEATURE_OFA				0
+#define PQI_FIRMWARE_FEATURE_SMP				1
+#define PQI_FIRMWARE_FEATURE_MAX_KNOWN_FEATURE			2
+#define PQI_FIRMWARE_FEATURE_RAID_0_READ_BYPASS			3
+#define PQI_FIRMWARE_FEATURE_RAID_1_READ_BYPASS			4
+#define PQI_FIRMWARE_FEATURE_RAID_5_READ_BYPASS			5
+#define PQI_FIRMWARE_FEATURE_RAID_6_READ_BYPASS			6
+#define PQI_FIRMWARE_FEATURE_RAID_0_WRITE_BYPASS		7
+#define PQI_FIRMWARE_FEATURE_RAID_1_WRITE_BYPASS		8
+#define PQI_FIRMWARE_FEATURE_RAID_5_WRITE_BYPASS		9
+#define PQI_FIRMWARE_FEATURE_RAID_6_WRITE_BYPASS		10
+#define PQI_FIRMWARE_FEATURE_SOFT_RESET_HANDSHAKE		11
+#define PQI_FIRMWARE_FEATURE_UNIQUE_SATA_WWN			12
+#define PQI_FIRMWARE_FEATURE_RAID_IU_TIMEOUT			13
+#define PQI_FIRMWARE_FEATURE_TMF_IU_TIMEOUT			14
+#define PQI_FIRMWARE_FEATURE_MAXIMUM				14
 
 struct pqi_config_table_debug {
 	struct pqi_config_table_section_header header;
@@ -1292,8 +1290,8 @@ struct pqi_ctrl_info {
 	u8		pqi_mode_enabled : 1;
 	u8		pqi_reset_quiesce_supported : 1;
 	u8		soft_reset_handshake_supported : 1;
-	u8		raid_iu_timeout_supported: 1;
-	u8		tmf_iu_timeout_supported: 1;
+	u8		raid_iu_timeout_supported : 1;
+	u8		tmf_iu_timeout_supported : 1;
 	u8		enable_r1_writes : 1;
 	u8		enable_r5_writes : 1;
 	u8		enable_r6_writes : 1;
diff --git a/drivers/scsi/smartpqi/smartpqi_init.c b/drivers/scsi/smartpqi/smartpqi_init.c
index 1c61f98f15dc..92a0b37ae35c 100644
--- a/drivers/scsi/smartpqi/smartpqi_init.c
+++ b/drivers/scsi/smartpqi/smartpqi_init.c
@@ -156,14 +156,12 @@ MODULE_PARM_DESC(lockup_action, "Action to take when controller locked up.\n"
 static int pqi_expose_ld_first;
 module_param_named(expose_ld_first,
 	pqi_expose_ld_first, int, 0644);
-MODULE_PARM_DESC(expose_ld_first,
-	"Expose logical drives before physical drives.");
+MODULE_PARM_DESC(expose_ld_first, "Expose logical drives before physical drives.");
 
 static int pqi_hide_vsep;
 module_param_named(hide_vsep,
 	pqi_hide_vsep, int, 0644);
-MODULE_PARM_DESC(hide_vsep,
-	"Hide the virtual SEP for direct attached drives.");
+MODULE_PARM_DESC(hide_vsep, "Hide the virtual SEP for direct attached drives.");
 
 static char *raid_levels[] = {
 	"RAID-0",
@@ -236,8 +234,7 @@ static inline bool pqi_is_hba_lunid(u8 *scsi3addr)
 	return pqi_scsi3addr_equal(scsi3addr, RAID_CTLR_LUNID);
 }
 
-static inline enum pqi_ctrl_mode pqi_get_ctrl_mode(
-	struct pqi_ctrl_info *ctrl_info)
+static inline enum pqi_ctrl_mode pqi_get_ctrl_mode(struct pqi_ctrl_info *ctrl_info)
 {
 	return sis_read_driver_scratch(ctrl_info);
 }
@@ -368,8 +365,8 @@ static inline bool pqi_ctrl_in_shutdown(struct pqi_ctrl_info *ctrl_info)
 	return ctrl_info->in_shutdown;
 }
 
-static inline void pqi_schedule_rescan_worker_with_delay(
-	struct pqi_ctrl_info *ctrl_info, unsigned long delay)
+static inline void pqi_schedule_rescan_worker_with_delay(struct pqi_ctrl_info *ctrl_info,
+	unsigned long delay)
 {
 	if (pqi_ctrl_offline(ctrl_info))
 		return;
@@ -386,8 +383,7 @@ static inline void pqi_schedule_rescan_worker(struct pqi_ctrl_info *ctrl_info)
 
 #define PQI_RESCAN_WORK_DELAY	(10 * PQI_HZ)
 
-static inline void pqi_schedule_rescan_worker_delayed(
-	struct pqi_ctrl_info *ctrl_info)
+static inline void pqi_schedule_rescan_worker_delayed(struct pqi_ctrl_info *ctrl_info)
 {
 	pqi_schedule_rescan_worker_with_delay(ctrl_info, PQI_RESCAN_WORK_DELAY);
 }
@@ -616,9 +612,8 @@ static int pqi_send_scsi_raid_request(struct pqi_ctrl_info *ctrl_info, u8 cmd,
 	struct pqi_raid_path_request request;
 	enum dma_data_direction dir;
 
-	rc = pqi_build_raid_path_request(ctrl_info, &request,
-		cmd, scsi3addr, buffer,
-		buffer_length, vpd_page, &dir);
+	rc = pqi_build_raid_path_request(ctrl_info, &request, cmd, scsi3addr,
+		buffer, buffer_length, vpd_page, &dir);
 	if (rc)
 		return rc;
 
@@ -738,17 +733,15 @@ static int pqi_get_advanced_raid_bypass_config(struct pqi_ctrl_info *ctrl_info)
 	if (!buffer)
 		return -ENOMEM;
 
-	rc = pqi_build_raid_path_request(ctrl_info, &request,
-		BMIC_SENSE_FEATURE, RAID_CTLR_LUNID, buffer,
-		sizeof(*buffer), 0, &dir);
+	rc = pqi_build_raid_path_request(ctrl_info, &request, BMIC_SENSE_FEATURE, RAID_CTLR_LUNID,
+		buffer, sizeof(*buffer), 0, &dir);
 	if (rc)
 		goto error;
 
 	request.cdb[2] = BMIC_SENSE_FEATURE_IO_PAGE;
 	request.cdb[3] = BMIC_SENSE_FEATURE_IO_PAGE_AIO_SUBPAGE;
 
-	rc = pqi_submit_raid_request_synchronous(ctrl_info, &request.header,
-		0, NULL, NO_TIMEOUT);
+	rc = pqi_submit_raid_request_synchronous(ctrl_info, &request.header, 0, NULL, NO_TIMEOUT);
 
 	pqi_pci_unmap(ctrl_info->pci_dev, request.sg_descriptors, 1, dir);
 
@@ -1008,15 +1001,13 @@ static inline void pqi_cancel_update_time_worker(struct pqi_ctrl_info *ctrl_info
 	cancel_delayed_work_sync(&ctrl_info->update_time_work);
 }
 
-static inline int pqi_report_luns(struct pqi_ctrl_info *ctrl_info, u8 cmd,
-	void *buffer, size_t buffer_length)
+static inline int pqi_report_luns(struct pqi_ctrl_info *ctrl_info, u8 cmd, void *buffer,
+	size_t buffer_length)
 {
-	return pqi_send_ctrl_raid_request(ctrl_info, cmd, buffer,
-		buffer_length);
+	return pqi_send_ctrl_raid_request(ctrl_info, cmd, buffer, buffer_length);
 }
 
-static int pqi_report_phys_logical_luns(struct pqi_ctrl_info *ctrl_info, u8 cmd,
-	void **buffer)
+static int pqi_report_phys_logical_luns(struct pqi_ctrl_info *ctrl_info, u8 cmd, void **buffer)
 {
 	int rc;
 	size_t lun_list_length;
@@ -1031,8 +1022,7 @@ static int pqi_report_phys_logical_luns(struct pqi_ctrl_info *ctrl_info, u8 cmd,
 		goto out;
 	}
 
-	rc = pqi_report_luns(ctrl_info, cmd, report_lun_header,
-		sizeof(*report_lun_header));
+	rc = pqi_report_luns(ctrl_info, cmd, report_lun_header, sizeof(*report_lun_header));
 	if (rc)
 		goto out;
 
@@ -1056,8 +1046,8 @@ static int pqi_report_phys_logical_luns(struct pqi_ctrl_info *ctrl_info, u8 cmd,
 	if (rc)
 		goto out;
 
-	new_lun_list_length = get_unaligned_be32(
-		&((struct report_lun_header *)lun_data)->list_length);
+	new_lun_list_length =
+		get_unaligned_be32(&((struct report_lun_header *)lun_data)->list_length);
 
 	if (new_lun_list_length > lun_list_length) {
 		lun_list_length = new_lun_list_length;
@@ -1078,15 +1068,12 @@ static int pqi_report_phys_logical_luns(struct pqi_ctrl_info *ctrl_info, u8 cmd,
 	return rc;
 }
 
-static inline int pqi_report_phys_luns(struct pqi_ctrl_info *ctrl_info,
-	void **buffer)
+static inline int pqi_report_phys_luns(struct pqi_ctrl_info *ctrl_info, void **buffer)
 {
-	return pqi_report_phys_logical_luns(ctrl_info, CISS_REPORT_PHYS,
-		buffer);
+	return pqi_report_phys_logical_luns(ctrl_info, CISS_REPORT_PHYS, buffer);
 }
 
-static inline int pqi_report_logical_luns(struct pqi_ctrl_info *ctrl_info,
-	void **buffer)
+static inline int pqi_report_logical_luns(struct pqi_ctrl_info *ctrl_info, void **buffer)
 {
 	return pqi_report_phys_logical_luns(ctrl_info, CISS_REPORT_LOG, buffer);
 }
@@ -1309,7 +1296,7 @@ static int pqi_get_raid_map(struct pqi_ctrl_info *ctrl_info,
 		if (get_unaligned_le32(&raid_map->structure_size)
 			!= raid_map_size) {
 			dev_warn(&ctrl_info->pci_dev->dev,
-				"Requested %d bytes, received %d bytes",
+				"requested %u bytes, received %u bytes\n",
 				raid_map_size,
 				get_unaligned_le32(&raid_map->structure_size));
 			goto error;
@@ -1666,8 +1653,7 @@ static int pqi_add_device(struct pqi_ctrl_info *ctrl_info,
 
 #define PQI_PENDING_IO_TIMEOUT_SECS	20
 
-static inline void pqi_remove_device(struct pqi_ctrl_info *ctrl_info,
-	struct pqi_scsi_dev *device)
+static inline void pqi_remove_device(struct pqi_ctrl_info *ctrl_info, struct pqi_scsi_dev *device)
 {
 	int rc;
 
@@ -1701,8 +1687,7 @@ static struct pqi_scsi_dev *pqi_find_scsi_dev(struct pqi_ctrl_info *ctrl_info,
 	return NULL;
 }
 
-static inline bool pqi_device_equal(struct pqi_scsi_dev *dev1,
-	struct pqi_scsi_dev *dev2)
+static inline bool pqi_device_equal(struct pqi_scsi_dev *dev1, struct pqi_scsi_dev *dev2)
 {
 	if (dev1->is_physical_device != dev2->is_physical_device)
 		return false;
@@ -1710,8 +1695,7 @@ static inline bool pqi_device_equal(struct pqi_scsi_dev *dev1,
 	if (dev1->is_physical_device)
 		return dev1->wwid == dev2->wwid;
 
-	return memcmp(dev1->volume_id, dev2->volume_id,
-		sizeof(dev1->volume_id)) == 0;
+	return memcmp(dev1->volume_id, dev2->volume_id, sizeof(dev1->volume_id)) == 0;
 }
 
 enum pqi_find_result {
@@ -1850,8 +1834,7 @@ static void pqi_scsi_update_device(struct pqi_scsi_dev *existing_device,
 	existing_device->bay = new_device->bay;
 	existing_device->box_index = new_device->box_index;
 	existing_device->phys_box_on_bus = new_device->phys_box_on_bus;
-	existing_device->phy_connected_dev_type =
-		new_device->phy_connected_dev_type;
+	existing_device->phy_connected_dev_type = new_device->phy_connected_dev_type;
 	memcpy(existing_device->box, new_device->box,
 		sizeof(existing_device->box));
 	memcpy(existing_device->phys_connector, new_device->phys_connector,
@@ -2054,7 +2037,7 @@ static inline bool pqi_is_supported_device(struct pqi_scsi_dev *device)
 	 */
 	if (device->device_type == SA_DEVICE_TYPE_CONTROLLER &&
 		!pqi_is_hba_lunid(device->scsi3addr))
-		return false;
+			return false;
 
 	return true;
 }
@@ -2087,8 +2070,7 @@ static inline bool pqi_is_device_with_sas_address(struct pqi_scsi_dev *device)
 
 static inline bool pqi_expose_device(struct pqi_scsi_dev *device)
 {
-	return !device->is_physical_device ||
-		!pqi_skip_device(device->scsi3addr);
+	return !device->is_physical_device || !pqi_skip_device(device->scsi3addr);
 }
 
 static int pqi_update_scsi_devices(struct pqi_ctrl_info *ctrl_info)
@@ -2152,11 +2134,8 @@ static int pqi_update_scsi_devices(struct pqi_ctrl_info *ctrl_info)
 			for (i = num_physicals - 1; i >= 0; i--) {
 				phys_lun_ext_entry =
 						&physdev_list->lun_entries[i];
-				if (CISS_GET_DRIVE_NUMBER(
-					phys_lun_ext_entry->lunid) ==
-						PQI_VSEP_CISS_BTL) {
-					pqi_mask_device(
-						phys_lun_ext_entry->lunid);
+				if (CISS_GET_DRIVE_NUMBER(phys_lun_ext_entry->lunid) == PQI_VSEP_CISS_BTL) {
+					pqi_mask_device(phys_lun_ext_entry->lunid);
 					break;
 				}
 			}
@@ -2246,8 +2225,7 @@ static int pqi_update_scsi_devices(struct pqi_ctrl_info *ctrl_info)
 			if (device->is_physical_device)
 				dev_warn(&ctrl_info->pci_dev->dev,
 					"obtaining device info failed, skipping physical device %016llx\n",
-					get_unaligned_be64(
-						&phys_lun_ext_entry->wwid));
+					get_unaligned_be64(&phys_lun_ext_entry->wwid));
 			else
 				dev_warn(&ctrl_info->pci_dev->dev,
 					"obtaining device info failed, skipping logical device %08x%08x\n",
@@ -2264,9 +2242,9 @@ static int pqi_update_scsi_devices(struct pqi_ctrl_info *ctrl_info)
 			if ((phys_lun_ext_entry->device_flags &
 				CISS_REPORT_PHYS_DEV_FLAG_AIO_ENABLED) &&
 				phys_lun_ext_entry->aio_handle) {
-				device->aio_enabled = true;
-				device->aio_handle =
-					phys_lun_ext_entry->aio_handle;
+					device->aio_enabled = true;
+					device->aio_handle =
+						phys_lun_ext_entry->aio_handle;
 			}
 		} else {
 			memcpy(device->volume_id, log_lun_ext_entry->volume_id,
@@ -2750,12 +2728,10 @@ static int pqi_raid_bypass_submit_scsi_cmd(struct pqi_ctrl_info *ctrl_info,
 
 	pqi_set_aio_cdb(&rmd);
 
-	if (get_unaligned_le16(&raid_map->flags) &
-			RAID_MAP_ENCRYPTION_ENABLED) {
+	if (get_unaligned_le16(&raid_map->flags) & RAID_MAP_ENCRYPTION_ENABLED) {
 		if (rmd.data_length > device->max_transfer_encrypted)
 			return PQI_RAID_BYPASS_INELIGIBLE;
-		pqi_set_encryption_info(&encryption_info, raid_map,
-			rmd.first_block);
+		pqi_set_encryption_info(&encryption_info, raid_map, rmd.first_block);
 		encryption_info_ptr = &encryption_info;
 	} else {
 		encryption_info_ptr = NULL;
@@ -2770,7 +2746,7 @@ static int pqi_raid_bypass_submit_scsi_cmd(struct pqi_ctrl_info *ctrl_info,
 		case SA_RAID_5:
 		case SA_RAID_6:
 			return pqi_aio_submit_r56_write_io(ctrl_info, scmd, queue_group,
-					encryption_info_ptr, device, &rmd);
+				encryption_info_ptr, device, &rmd);
 		}
 	}
 
@@ -3156,8 +3132,7 @@ static int pqi_process_io_intr(struct pqi_ctrl_info *ctrl_info, struct pqi_queue
 		case PQI_RESPONSE_IU_VENDOR_GENERAL:
 			io_request->status =
 				get_unaligned_le16(
-				&((struct pqi_vendor_general_response *)
-					response)->status);
+				&((struct pqi_vendor_general_response *)response)->status);
 			break;
 		case PQI_RESPONSE_IU_TASK_MANAGEMENT:
 			io_request->status =
@@ -3369,7 +3344,7 @@ static void pqi_ofa_process_event(struct pqi_ctrl_info *ctrl_info,
 		pqi_ofa_setup_host_buffer(ctrl_info,
 			le32_to_cpu(event->ofa_bytes_requested));
 		pqi_ofa_host_memory_update(ctrl_info);
-	} else if (event_id == PQI_EVENT_OFA_CANCELLED) {
+	} else if (event_id == PQI_EVENT_OFA_CANCELED) {
 		pqi_ofa_free_host_buffer(ctrl_info);
 		pqi_acknowledge_event(ctrl_info, event);
 		dev_info(&ctrl_info->pci_dev->dev,
@@ -3419,8 +3394,7 @@ static void pqi_heartbeat_timer_handler(struct timer_list *t)
 {
 	int num_interrupts;
 	u32 heartbeat_count;
-	struct pqi_ctrl_info *ctrl_info = from_timer(ctrl_info, t,
-						     heartbeat_timer);
+	struct pqi_ctrl_info *ctrl_info = from_timer(ctrl_info, t, heartbeat_timer);
 
 	pqi_check_ctrl_health(ctrl_info);
 	if (pqi_ctrl_offline(ctrl_info))
@@ -3493,7 +3467,7 @@ static void pqi_ofa_capture_event_payload(struct pqi_event *event,
 		if (event_id == PQI_EVENT_OFA_MEMORY_ALLOCATION) {
 			event->ofa_bytes_requested =
 			response->data.ofa_memory_allocation.bytes_requested;
-		} else if (event_id == PQI_EVENT_OFA_CANCELLED) {
+		} else if (event_id == PQI_EVENT_OFA_CANCELED) {
 			event->ofa_cancel_reason =
 			response->data.ofa_cancelled.reason;
 		}
@@ -3635,8 +3609,7 @@ static inline bool pqi_is_valid_irq(struct pqi_ctrl_info *ctrl_info)
 		valid_irq = true;
 		break;
 	case IRQ_MODE_INTX:
-		intx_status =
-			readl(&ctrl_info->pqi_registers->legacy_intx_status);
+		intx_status = readl(&ctrl_info->pqi_registers->legacy_intx_status);
 		if (intx_status & PQI_LEGACY_INTX_PENDING)
 			valid_irq = true;
 		else
@@ -3957,7 +3930,8 @@ static int pqi_alloc_admin_queues(struct pqi_ctrl_info *ctrl_info)
 		&admin_queues_aligned->iq_element_array;
 	admin_queues->oq_element_array =
 		&admin_queues_aligned->oq_element_array;
-	admin_queues->iq_ci = &admin_queues_aligned->iq_ci;
+	admin_queues->iq_ci =
+		(pqi_index_t __iomem *)&admin_queues_aligned->iq_ci;
 	admin_queues->oq_pi =
 		(pqi_index_t __iomem *)&admin_queues_aligned->oq_pi;
 
@@ -3971,8 +3945,8 @@ static int pqi_alloc_admin_queues(struct pqi_ctrl_info *ctrl_info)
 		ctrl_info->admin_queue_memory_base);
 	admin_queues->iq_ci_bus_addr =
 		ctrl_info->admin_queue_memory_base_dma_handle +
-		((void *)admin_queues->iq_ci -
-		ctrl_info->admin_queue_memory_base);
+		((void __iomem *)admin_queues->iq_ci -
+		(void __iomem *)ctrl_info->admin_queue_memory_base);
 	admin_queues->oq_pi_bus_addr =
 		ctrl_info->admin_queue_memory_base_dma_handle +
 		((void __iomem *)admin_queues->oq_pi -
@@ -4008,6 +3982,7 @@ static int pqi_create_admin_queues(struct pqi_ctrl_info *ctrl_info)
 		(PQI_ADMIN_OQ_NUM_ELEMENTS << 8) |
 		(admin_queues->int_msg_num << 16);
 	writel(reg, &pqi_registers->admin_iq_num_elements);
+
 	writel(PQI_CREATE_ADMIN_QUEUE_PAIR,
 		&pqi_registers->function_and_status_code);
 
@@ -4304,8 +4279,7 @@ static int pqi_submit_raid_request_synchronous(struct pqi_ctrl_info *ctrl_info,
 	io_request->io_complete_callback = pqi_raid_synchronous_complete;
 	io_request->context = &wait;
 
-	pqi_start_io(ctrl_info,
-		&ctrl_info->queue_groups[PQI_DEFAULT_QUEUE_GROUP], RAID_PATH,
+	pqi_start_io(ctrl_info, &ctrl_info->queue_groups[PQI_DEFAULT_QUEUE_GROUP], RAID_PATH,
 		io_request);
 
 	pqi_ctrl_unbusy(ctrl_info);
@@ -4323,13 +4297,11 @@ static int pqi_submit_raid_request_synchronous(struct pqi_ctrl_info *ctrl_info,
 
 	if (error_info) {
 		if (io_request->error_info)
-			memcpy(error_info, io_request->error_info,
-				sizeof(*error_info));
+			memcpy(error_info, io_request->error_info, sizeof(*error_info));
 		else
 			memset(error_info, 0, sizeof(*error_info));
 	} else if (rc == 0 && io_request->error_info) {
-		rc = pqi_process_raid_io_error_synchronous(
-			io_request->error_info);
+		rc = pqi_process_raid_io_error_synchronous(io_request->error_info);
 	}
 
 	pqi_free_io_request(io_request);
@@ -4407,8 +4379,7 @@ static int pqi_report_device_capability(struct pqi_ctrl_info *ctrl_info)
 	if (rc)
 		goto out;
 
-	rc = pqi_submit_admin_request_synchronous(ctrl_info, &request,
-		&response);
+	rc = pqi_submit_admin_request_synchronous(ctrl_info, &request, &response);
 
 	pqi_pci_unmap(ctrl_info->pci_dev,
 		&request.data.report_device_capability.sg_descriptor, 1,
@@ -4757,7 +4728,7 @@ static int pqi_configure_events(struct pqi_ctrl_info *ctrl_info,
 		event_descriptor = &event_config->descriptors[i];
 		if (enable_events &&
 			pqi_is_supported_event(event_descriptor->event_type))
-			put_unaligned_le16(ctrl_info->event_queue.oq_id,
+				put_unaligned_le16(ctrl_info->event_queue.oq_id,
 					&event_descriptor->oq_id);
 		else
 			put_unaligned_le16(0, &event_descriptor->oq_id);
@@ -4832,7 +4803,6 @@ static void pqi_free_all_io_requests(struct pqi_ctrl_info *ctrl_info)
 
 static inline int pqi_alloc_error_buffer(struct pqi_ctrl_info *ctrl_info)
 {
-
 	ctrl_info->error_buffer = dma_alloc_coherent(&ctrl_info->pci_dev->dev,
 				     ctrl_info->error_buffer_length,
 				     &ctrl_info->error_buffer_dma_handle,
@@ -4852,9 +4822,8 @@ static int pqi_alloc_io_resources(struct pqi_ctrl_info *ctrl_info)
 	struct device *dev;
 	struct pqi_io_request *io_request;
 
-	ctrl_info->io_request_pool =
-		kcalloc(ctrl_info->max_io_slots,
-			sizeof(ctrl_info->io_request_pool[0]), GFP_KERNEL);
+	ctrl_info->io_request_pool = kcalloc(ctrl_info->max_io_slots,
+		sizeof(ctrl_info->io_request_pool[0]), GFP_KERNEL);
 
 	if (!ctrl_info->io_request_pool) {
 		dev_err(&ctrl_info->pci_dev->dev,
@@ -4867,8 +4836,7 @@ static int pqi_alloc_io_resources(struct pqi_ctrl_info *ctrl_info)
 	io_request = ctrl_info->io_request_pool;
 
 	for (i = 0; i < ctrl_info->max_io_slots; i++) {
-		io_request->iu =
-			kmalloc(ctrl_info->max_inbound_iu_length, GFP_KERNEL);
+		io_request->iu = kmalloc(ctrl_info->max_inbound_iu_length, GFP_KERNEL);
 
 		if (!io_request->iu) {
 			dev_err(&ctrl_info->pci_dev->dev,
@@ -4888,8 +4856,7 @@ static int pqi_alloc_io_resources(struct pqi_ctrl_info *ctrl_info)
 
 		io_request->index = i;
 		io_request->sg_chain_buffer = sg_chain_buffer;
-		io_request->sg_chain_buffer_dma_handle =
-			sg_chain_buffer_dma_handle;
+		io_request->sg_chain_buffer_dma_handle = sg_chain_buffer_dma_handle;
 		io_request++;
 	}
 
@@ -5004,8 +4971,8 @@ static void pqi_calculate_queue_resources(struct pqi_ctrl_info *ctrl_info)
 		PQI_MAX_EMBEDDED_R56_SG_DESCRIPTORS;
 }
 
-static inline void pqi_set_sg_descriptor(
-	struct pqi_sg_descriptor *sg_descriptor, struct scatterlist *sg)
+static inline void pqi_set_sg_descriptor(struct pqi_sg_descriptor *sg_descriptor,
+	struct scatterlist *sg)
 {
 	u64 address = (u64)sg_dma_address(sg);
 	unsigned int length = sg_dma_len(sg);
@@ -5227,16 +5194,14 @@ static int pqi_raid_submit_scsi_cmd_with_io_request(
 	io_request->scmd = scmd;
 
 	request = io_request->iu;
-	memset(request, 0,
-		offsetof(struct pqi_raid_path_request, sg_descriptors));
+	memset(request, 0, offsetof(struct pqi_raid_path_request, sg_descriptors));
 
 	request->header.iu_type = PQI_REQUEST_IU_RAID_PATH_IO;
 	put_unaligned_le32(scsi_bufflen(scmd), &request->buffer_length);
 	request->task_attribute = SOP_TASK_ATTRIBUTE_SIMPLE;
 	put_unaligned_le16(io_request->index, &request->request_id);
 	request->error_index = request->request_id;
-	memcpy(request->lun_number, device->scsi3addr,
-		sizeof(request->lun_number));
+	memcpy(request->lun_number, device->scsi3addr, sizeof(request->lun_number));
 
 	cdb_length = min_t(size_t, scmd->cmd_len, sizeof(request->cdb));
 	memcpy(request->cdb, scmd->cmnd, cdb_length);
@@ -5246,30 +5211,20 @@ static int pqi_raid_submit_scsi_cmd_with_io_request(
 	case 10:
 	case 12:
 	case 16:
-		/* No bytes in the Additional CDB bytes field */
-		request->additional_cdb_bytes_usage =
-			SOP_ADDITIONAL_CDB_BYTES_0;
+		request->additional_cdb_bytes_usage = SOP_ADDITIONAL_CDB_BYTES_0;
 		break;
 	case 20:
-		/* 4 bytes in the Additional cdb field */
-		request->additional_cdb_bytes_usage =
-			SOP_ADDITIONAL_CDB_BYTES_4;
+		request->additional_cdb_bytes_usage = SOP_ADDITIONAL_CDB_BYTES_4;
 		break;
 	case 24:
-		/* 8 bytes in the Additional cdb field */
-		request->additional_cdb_bytes_usage =
-			SOP_ADDITIONAL_CDB_BYTES_8;
+		request->additional_cdb_bytes_usage = SOP_ADDITIONAL_CDB_BYTES_8;
 		break;
 	case 28:
-		/* 12 bytes in the Additional cdb field */
-		request->additional_cdb_bytes_usage =
-			SOP_ADDITIONAL_CDB_BYTES_12;
+		request->additional_cdb_bytes_usage = SOP_ADDITIONAL_CDB_BYTES_12;
 		break;
 	case 32:
 	default:
-		/* 16 bytes in the Additional cdb field */
-		request->additional_cdb_bytes_usage =
-			SOP_ADDITIONAL_CDB_BYTES_16;
+		request->additional_cdb_bytes_usage = SOP_ADDITIONAL_CDB_BYTES_16;
 		break;
 	}
 
@@ -5514,8 +5469,7 @@ static int pqi_aio_submit_io(struct pqi_ctrl_info *ctrl_info,
 	io_request->raid_bypass = raid_bypass;
 
 	request = io_request->iu;
-	memset(request, 0,
-		offsetof(struct pqi_raid_path_request, sg_descriptors));
+	memset(request, 0, offsetof(struct pqi_raid_path_request, sg_descriptors));
 
 	request->header.iu_type = PQI_REQUEST_IU_AIO_PATH_IO;
 	put_unaligned_le32(aio_handle, &request->nexus_id);
@@ -5573,7 +5527,6 @@ static  int pqi_aio_submit_r1_write_io(struct pqi_ctrl_info *ctrl_info,
 	struct scsi_cmnd *scmd, struct pqi_queue_group *queue_group,
 	struct pqi_encryption_info *encryption_info, struct pqi_scsi_dev *device,
 	struct pqi_scsi_dev_raid_map_data *rmd)
-
 {
 	int rc;
 	struct pqi_io_request *io_request;
@@ -5588,7 +5541,6 @@ static  int pqi_aio_submit_r1_write_io(struct pqi_ctrl_info *ctrl_info,
 	memset(r1_request, 0, offsetof(struct pqi_aio_r1_path_request, sg_descriptors));
 
 	r1_request->header.iu_type = PQI_REQUEST_IU_AIO_PATH_RAID1_IO;
-
 	put_unaligned_le16(*(u16 *)device->scsi3addr & 0x3fff, &r1_request->volume_id);
 	r1_request->num_drives = rmd->num_it_nexus_entries;
 	put_unaligned_le32(rmd->it_nexus[0], &r1_request->it_nexus_1);
@@ -5917,6 +5869,7 @@ static void pqi_fail_io_queued_for_device(struct pqi_ctrl_info *ctrl_info,
 			list_for_each_entry_safe(io_request, next,
 				&queue_group->request_list[path],
 				request_list_entry) {
+
 				scmd = io_request->scmd;
 				if (!scmd)
 					continue;
@@ -6110,8 +6063,7 @@ static int pqi_lun_reset(struct pqi_ctrl_info *ctrl_info,
 		put_unaligned_le16(PQI_LUN_RESET_TIMEOUT_SECS,
 					&request->timeout);
 
-	pqi_start_io(ctrl_info,
-		&ctrl_info->queue_groups[PQI_DEFAULT_QUEUE_GROUP], RAID_PATH,
+	pqi_start_io(ctrl_info, &ctrl_info->queue_groups[PQI_DEFAULT_QUEUE_GROUP], RAID_PATH,
 		io_request);
 
 	rc = pqi_wait_for_lun_reset_completion(ctrl_info, device, &wait);
@@ -6801,7 +6753,8 @@ static ssize_t pqi_unique_id_show(struct device *dev,
 	spin_unlock_irqrestore(&ctrl_info->scsi_device_list_lock, flags);
 
 	return snprintf(buffer, PAGE_SIZE,
-		"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X\n",
+		"%02X%02X%02X%02X%02X%02X%02X%02X"
+		"%02X%02X%02X%02X%02X%02X%02X%02X\n",
 		unique_id[0], unique_id[1], unique_id[2], unique_id[3],
 		unique_id[4], unique_id[5], unique_id[6], unique_id[7],
 		unique_id[8], unique_id[9], unique_id[10], unique_id[11],
@@ -7101,17 +7054,13 @@ static int pqi_register_scsi(struct pqi_ctrl_info *ctrl_info)
 
 	rc = scsi_add_host(shost, &ctrl_info->pci_dev->dev);
 	if (rc) {
-		dev_err(&ctrl_info->pci_dev->dev,
-			"scsi_add_host failed for controller %u\n",
-			ctrl_info->ctrl_id);
+		dev_err(&ctrl_info->pci_dev->dev, "scsi_add_host failed\n");
 		goto free_host;
 	}
 
 	rc = pqi_add_sas_host(shost, ctrl_info);
 	if (rc) {
-		dev_err(&ctrl_info->pci_dev->dev,
-			"add SAS host failed for controller %u\n",
-			ctrl_info->ctrl_id);
+		dev_err(&ctrl_info->pci_dev->dev, "add SAS host failed\n");
 		goto remove_host;
 	}
 
@@ -7181,8 +7130,7 @@ static int pqi_reset(struct pqi_ctrl_info *ctrl_info)
 		rc = sis_pqi_reset_quiesce(ctrl_info);
 		if (rc) {
 			dev_err(&ctrl_info->pci_dev->dev,
-				"PQI reset failed during quiesce with error %d\n",
-				rc);
+				"PQI reset failed during quiesce with error %d\n", rc);
 			return rc;
 		}
 	}
@@ -7422,12 +7370,10 @@ static void pqi_ctrl_update_feature_flags(struct pqi_ctrl_info *ctrl_info,
 			firmware_feature->enabled;
 		break;
 	case PQI_FIRMWARE_FEATURE_RAID_IU_TIMEOUT:
-		ctrl_info->raid_iu_timeout_supported =
-			firmware_feature->enabled;
+		ctrl_info->raid_iu_timeout_supported = firmware_feature->enabled;
 		break;
 	case PQI_FIRMWARE_FEATURE_TMF_IU_TIMEOUT:
-		ctrl_info->tmf_iu_timeout_supported =
-			firmware_feature->enabled;
+		ctrl_info->tmf_iu_timeout_supported = firmware_feature->enabled;
 		break;
 	}
 
@@ -7572,7 +7518,7 @@ static void pqi_process_firmware_features(
 		if (pqi_is_firmware_feature_enabled(firmware_features,
 			firmware_features_iomem_addr,
 			pqi_firmware_features[i].feature_bit)) {
-			pqi_firmware_features[i].enabled = true;
+				pqi_firmware_features[i].enabled = true;
 		}
 		pqi_firmware_feature_update(ctrl_info,
 			&pqi_firmware_features[i]);
@@ -7622,21 +7568,18 @@ static int pqi_process_config_table(struct pqi_ctrl_info *ctrl_info)
 	 * Copy the config table contents from I/O memory space into the
 	 * temporary buffer.
 	 */
-	table_iomem_addr = ctrl_info->iomem_base +
-		ctrl_info->config_table_offset;
+	table_iomem_addr = ctrl_info->iomem_base + ctrl_info->config_table_offset;
 	memcpy_fromio(config_table, table_iomem_addr, table_length);
 
 	section_info.ctrl_info = ctrl_info;
-	section_offset =
-		get_unaligned_le32(&config_table->first_section_offset);
+	section_offset = get_unaligned_le32(&config_table->first_section_offset);
 
 	while (section_offset) {
 		section = (void *)config_table + section_offset;
 
 		section_info.section = section;
 		section_info.section_offset = section_offset;
-		section_info.section_iomem_addr =
-			table_iomem_addr + section_offset;
+		section_info.section_iomem_addr = table_iomem_addr + section_offset;
 
 		switch (get_unaligned_le16(&section->section_id)) {
 		case PQI_CONFIG_TABLE_SECTION_FIRMWARE_FEATURES:
@@ -7650,8 +7593,7 @@ static int pqi_process_config_table(struct pqi_ctrl_info *ctrl_info)
 				ctrl_info->heartbeat_counter =
 					table_iomem_addr +
 					section_offset +
-					offsetof(
-					struct pqi_config_table_heartbeat,
+					offsetof(struct pqi_config_table_heartbeat,
 						heartbeat_counter);
 			break;
 		case PQI_CONFIG_TABLE_SECTION_SOFT_RESET:
@@ -7663,8 +7605,7 @@ static int pqi_process_config_table(struct pqi_ctrl_info *ctrl_info)
 			break;
 		}
 
-		section_offset =
-			get_unaligned_le16(&section->next_section_offset);
+		section_offset = get_unaligned_le16(&section->next_section_offset);
 	}
 
 	kfree(config_table);
@@ -7763,12 +7704,12 @@ static int pqi_ctrl_init(struct pqi_ctrl_info *ctrl_info)
 	if (reset_devices) {
 		if (ctrl_info->max_outstanding_requests >
 			PQI_MAX_OUTSTANDING_REQUESTS_KDUMP)
-			ctrl_info->max_outstanding_requests =
+				ctrl_info->max_outstanding_requests =
 					PQI_MAX_OUTSTANDING_REQUESTS_KDUMP;
 	} else {
 		if (ctrl_info->max_outstanding_requests >
 			PQI_MAX_OUTSTANDING_REQUESTS)
-			ctrl_info->max_outstanding_requests =
+				ctrl_info->max_outstanding_requests =
 					PQI_MAX_OUTSTANDING_REQUESTS;
 	}
 
@@ -8085,8 +8026,7 @@ static int pqi_ctrl_init_resume(struct pqi_ctrl_info *ctrl_info)
 	return 0;
 }
 
-static inline int pqi_set_pcie_completion_timeout(struct pci_dev *pci_dev,
-	u16 timeout)
+static inline int pqi_set_pcie_completion_timeout(struct pci_dev *pci_dev, u16 timeout)
 {
 	int rc;
 
@@ -8338,8 +8278,8 @@ static int pqi_ofa_alloc_mem(struct pqi_ctrl_info *ctrl_info,
 			break;
 
 		mem_descriptor = &ofap->sg_descriptor[i];
-		put_unaligned_le64 ((u64) dma_handle, &mem_descriptor->address);
-		put_unaligned_le32 (chunk_size, &mem_descriptor->length);
+		put_unaligned_le64((u64)dma_handle, &mem_descriptor->address);
+		put_unaligned_le32(chunk_size, &mem_descriptor->length);
 	}
 
 	if (!size || size < total_size)
diff --git a/drivers/scsi/smartpqi/smartpqi_sas_transport.c b/drivers/scsi/smartpqi/smartpqi_sas_transport.c
index c9b00b3368d7..77923c6ec2c6 100644
--- a/drivers/scsi/smartpqi/smartpqi_sas_transport.c
+++ b/drivers/scsi/smartpqi/smartpqi_sas_transport.c
@@ -107,8 +107,7 @@ static int pqi_sas_port_add_rphy(struct pqi_sas_port *pqi_sas_port,
 
 static struct sas_rphy *pqi_sas_rphy_alloc(struct pqi_sas_port *pqi_sas_port)
 {
-	if (pqi_sas_port->device &&
-		pqi_sas_port->device->is_expander_smp_device)
+	if (pqi_sas_port->device && pqi_sas_port->device->is_expander_smp_device)
 		return sas_expander_alloc(pqi_sas_port->port,
 				SAS_FANOUT_EXPANDER_DEVICE);
 
@@ -161,7 +160,7 @@ static void pqi_free_sas_port(struct pqi_sas_port *pqi_sas_port)
 
 	list_for_each_entry_safe(pqi_sas_phy, next,
 		&pqi_sas_port->phy_list_head, phy_list_entry)
-		pqi_free_sas_phy(pqi_sas_phy);
+			pqi_free_sas_phy(pqi_sas_phy);
 
 	sas_port_delete(pqi_sas_port->port);
 	list_del(&pqi_sas_port->port_list_entry);
@@ -191,7 +190,7 @@ static void pqi_free_sas_node(struct pqi_sas_node *pqi_sas_node)
 
 	list_for_each_entry_safe(pqi_sas_port, next,
 		&pqi_sas_node->port_list_head, port_list_entry)
-		pqi_free_sas_port(pqi_sas_port);
+			pqi_free_sas_port(pqi_sas_port);
 
 	kfree(pqi_sas_node);
 }
@@ -498,7 +497,7 @@ static unsigned int pqi_build_sas_smp_handler_reply(
 
 	job->reply_len = le16_to_cpu(error_info->sense_data_length);
 	memcpy(job->reply, error_info->data,
-			le16_to_cpu(error_info->sense_data_length));
+		le16_to_cpu(error_info->sense_data_length));
 
 	return job->reply_payload.payload_len -
 		get_unaligned_le32(&error_info->data_in_transferred);
@@ -547,6 +546,7 @@ void pqi_sas_smp_handler(struct bsg_job *job, struct Scsi_Host *shost,
 		goto out;
 
 	reslen = pqi_build_sas_smp_handler_reply(smp_buf, job, &error_info);
+
 out:
 	bsg_job_done(job, rc, reslen);
 }
diff --git a/drivers/scsi/smartpqi/smartpqi_sis.c b/drivers/scsi/smartpqi/smartpqi_sis.c
index f0199bd87dd1..c954620628e0 100644
--- a/drivers/scsi/smartpqi/smartpqi_sis.c
+++ b/drivers/scsi/smartpqi/smartpqi_sis.c
@@ -71,7 +71,7 @@ struct sis_base_struct {
 						/* error response data */
 	__le32	error_buffer_element_length;	/* length of each PQI error */
 						/* response buffer element */
-						/*   in bytes */
+						/* in bytes */
 	__le32	error_buffer_num_elements;	/* total number of PQI error */
 						/* response buffers available */
 };
@@ -146,7 +146,7 @@ bool sis_is_firmware_running(struct pqi_ctrl_info *ctrl_info)
 bool sis_is_kernel_up(struct pqi_ctrl_info *ctrl_info)
 {
 	return readl(&ctrl_info->registers->sis_firmware_status) &
-				SIS_CTRL_KERNEL_UP;
+		SIS_CTRL_KERNEL_UP;
 }
 
 u32 sis_get_product_id(struct pqi_ctrl_info *ctrl_info)

