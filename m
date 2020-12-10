Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0CA6EC4167B
	for <linux-scsi@archiver.kernel.org>; Thu, 10 Dec 2020 20:36:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C7B9623DE3
	for <linux-scsi@archiver.kernel.org>; Thu, 10 Dec 2020 20:36:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404026AbgLJUgF (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 10 Dec 2020 15:36:05 -0500
Received: from esa.microchip.iphmx.com ([68.232.154.123]:46625 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2393815AbgLJUgC (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 10 Dec 2020 15:36:02 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1607632561; x=1639168561;
  h=subject:from:to:cc:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=7zvSb4/Sr2kb2NPVdSqUfCZvEgMPFkqcieuUTdPUCT0=;
  b=hKODo7ZrC/GPMDv0Cx2YFWyv0blLblncIEeWc91l9aYTS01wWnWDTM7n
   /wl5ASDrK5v+Nz9k5aiYrV2kkIcBrRF/jezUqIr3m1JqYGiWd0tTCLxfa
   m1EA+7ahBpdUEJiDpNrOSkcrlRjfTWkYfoWDy9//vp37lKOLmiGvGIG1g
   +jX9D6vdMN9S6FJEiRM+euajdYUa6T8fG1Z7XxXCK+iJBrE8/sAWSYtm1
   hmWjh+UCSEy5ip3Y1e1Cl/L4SgOuDQU1FEAUvJLRZJM8DxfQiNoTOpifK
   OeBPvUMTJvrZ9gRK3/JyIuFXCM4DdaV6/DDPV6JfuFRau8gM9bN/Joj/x
   Q==;
IronPort-SDR: sFZzRIBv4CYttF6DdRCHohhsQXrVI39asDUo3VkM8DeNKxKu4zoHQaJygHyzxCzQR8Yeenypcg
 G/rI6zaQnbY2sgKvKdGarJw/lFFRz6aGCjAT5FUNi3hULWUmp4MNRjUFx7Ljj8S40YrJT1rVTi
 eZ1lpgu93w0/pYkmllMuXfaeYXOerOmMHv731s5HVQJvMbLEVXkRFp2oSvpBoYu9Ofdj8iuQti
 hjppw8/HaS6SYskEQT0pgySS/DbIiwFx2elIsNe5pnpj8jxP1emMbjAUf7a/0EjywTTooVKXGz
 EqY=
X-IronPort-AV: E=Sophos;i="5.78,409,1599548400"; 
   d="scan'208";a="99412667"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa2.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 10 Dec 2020 13:34:50 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.85.144) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Thu, 10 Dec 2020 13:34:49 -0700
Received: from [127.0.1.1] (10.10.115.15) by chn-vm-ex02.mchp-main.com
 (10.10.85.144) with Microsoft SMTP Server id 15.1.1979.3 via Frontend
 Transport; Thu, 10 Dec 2020 13:34:49 -0700
Subject: [PATCH V3 05/25] smartpqi: add support for raid1 writes
From:   Don Brace <don.brace@microchip.com>
To:     <Kevin.Barnett@microchip.com>, <scott.teel@microchip.com>,
        <Justin.Lindley@microchip.com>, <scott.benesh@microchip.com>,
        <gerry.morong@microchip.com>, <mahesh.rajashekhara@microchip.com>,
        <hch@infradead.org>, <jejb@linux.vnet.ibm.com>,
        <joseph.szczypek@hpe.com>, <POSWALD@suse.com>
CC:     <linux-scsi@vger.kernel.org>
Date:   Thu, 10 Dec 2020 14:34:49 -0600
Message-ID: <160763248937.26927.6012524710393214473.stgit@brunhilda>
In-Reply-To: <160763241302.26927.17487238067261230799.stgit@brunhilda>
References: <160763241302.26927.17487238067261230799.stgit@brunhilda>
User-Agent: StGit/0.23-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

* Add raid1 write IU.
* Add in raid1 write support.

Reviewed-by: Scott Benesh <scott.benesh@microchip.com>
Reviewed-by: Scott Teel <scott.teel@microchip.com>
Reviewed-by: Kevin Barnett <kevin.barnett@microchip.com>
Signed-off-by: Don Brace <don.brace@microchip.com>
---
 drivers/scsi/smartpqi/smartpqi.h      |   37 +++++
 drivers/scsi/smartpqi/smartpqi_init.c |  235 +++++++++++++++++++++++----------
 2 files changed, 196 insertions(+), 76 deletions(-)

diff --git a/drivers/scsi/smartpqi/smartpqi.h b/drivers/scsi/smartpqi/smartpqi.h
index e9844210c4a0..225ec6843c68 100644
--- a/drivers/scsi/smartpqi/smartpqi.h
+++ b/drivers/scsi/smartpqi/smartpqi.h
@@ -313,6 +313,36 @@ struct pqi_aio_path_request {
 		sg_descriptors[PQI_MAX_EMBEDDED_SG_DESCRIPTORS];
 };
 
+#define PQI_RAID1_NVME_XFER_LIMIT	(32 * 1024)	/* 32 KiB */
+struct pqi_aio_r1_path_request {
+	struct pqi_iu_header header;
+	__le16	request_id;
+	__le16	volume_id;	/* ID of the RAID volume */
+	__le32	it_nexus_1;	/* IT nexus of the 1st drive in the RAID volume */
+	__le32	it_nexus_2;	/* IT nexus of the 2nd drive in the RAID volume */
+	__le32	it_nexus_3;	/* IT nexus of the 3rd drive in the RAID volume */
+	__le32	data_length;	/* total bytes to read/write */
+	u8	data_direction : 2;
+	u8	partial : 1;
+	u8	memory_type : 1;
+	u8	fence : 1;
+	u8	encryption_enable : 1;
+	u8	reserved : 2;
+	u8	task_attribute : 3;
+	u8	command_priority : 4;
+	u8	reserved2 : 1;
+	__le16	data_encryption_key_index;
+	u8	cdb[16];
+	__le16	error_index;
+	u8	num_sg_descriptors;
+	u8	cdb_length;
+	u8	num_drives;	/* number of drives in the RAID volume (2 or 3) */
+	u8	reserved3[3];
+	__le32	encrypt_tweak_lower;
+	__le32	encrypt_tweak_upper;
+	struct pqi_sg_descriptor sg_descriptors[PQI_MAX_EMBEDDED_SG_DESCRIPTORS];
+};
+
 #define PQI_RAID56_XFER_LIMIT_4K	0x1000 /* 4Kib */
 #define PQI_RAID56_XFER_LIMIT_8K	0x2000 /* 8Kib */
 struct pqi_aio_r56_path_request {
@@ -520,6 +550,7 @@ struct pqi_raid_error_info {
 #define PQI_REQUEST_IU_AIO_PATH_IO			0x15
 #define PQI_REQUEST_IU_AIO_PATH_RAID5_IO		0x18
 #define PQI_REQUEST_IU_AIO_PATH_RAID6_IO		0x19
+#define PQI_REQUEST_IU_AIO_PATH_RAID1_IO		0x1A
 #define PQI_REQUEST_IU_GENERAL_ADMIN			0x60
 #define PQI_REQUEST_IU_REPORT_VENDOR_EVENT_CONFIG	0x72
 #define PQI_REQUEST_IU_SET_VENDOR_EVENT_CONFIG		0x73
@@ -972,14 +1003,12 @@ struct pqi_scsi_dev_raid_map_data {
 	u16	strip_size;
 	u32	first_group;
 	u32	last_group;
-	u32	current_group;
 	u32	map_row;
 	u32	aio_handle;
 	u64	disk_block;
 	u32	disk_block_cnt;
 	u8	cdb[16];
 	u8	cdb_length;
-	int	offload_to_mirror;
 
 	/* RAID1 specific */
 #define NUM_RAID1_MAP_ENTRIES 3
@@ -1040,8 +1069,7 @@ struct pqi_scsi_dev {
 	u16	phys_connector[8];
 	bool	raid_bypass_configured;	/* RAID bypass configured */
 	bool	raid_bypass_enabled;	/* RAID bypass enabled */
-	int	offload_to_mirror;	/* Send next RAID bypass request */
-					/* to mirror drive. */
+	u32	next_bypass_group;
 	struct raid_map *raid_map;	/* RAID bypass map */
 
 	struct pqi_sas_port *sas_port;
@@ -1247,6 +1275,7 @@ struct pqi_ctrl_info {
 	u8		soft_reset_handshake_supported : 1;
 	u8		raid_iu_timeout_supported: 1;
 	u8		tmf_iu_timeout_supported: 1;
+	u8		enable_r1_writes : 1;
 	u8		enable_r5_writes : 1;
 	u8		enable_r6_writes : 1;
 
diff --git a/drivers/scsi/smartpqi/smartpqi_init.c b/drivers/scsi/smartpqi/smartpqi_init.c
index c813cec10003..8da9031c9c0b 100644
--- a/drivers/scsi/smartpqi/smartpqi_init.c
+++ b/drivers/scsi/smartpqi/smartpqi_init.c
@@ -67,6 +67,10 @@ static int pqi_aio_submit_io(struct pqi_ctrl_info *ctrl_info,
 	struct scsi_cmnd *scmd, u32 aio_handle, u8 *cdb,
 	unsigned int cdb_length, struct pqi_queue_group *queue_group,
 	struct pqi_encryption_info *encryption_info, bool raid_bypass);
+static  int pqi_aio_submit_r1_write_io(struct pqi_ctrl_info *ctrl_info,
+	struct scsi_cmnd *scmd, struct pqi_queue_group *queue_group,
+	struct pqi_encryption_info *encryption_info, struct pqi_scsi_dev *device,
+	struct pqi_scsi_dev_raid_map_data *rmd);
 static int pqi_aio_submit_r56_write_io(struct pqi_ctrl_info *ctrl_info,
 	struct scsi_cmnd *scmd, struct pqi_queue_group *queue_group,
 	struct pqi_encryption_info *encryption_info, struct pqi_scsi_dev *device,
@@ -1717,7 +1721,7 @@ static void pqi_scsi_update_device(struct pqi_scsi_dev *existing_device,
 		sizeof(existing_device->box));
 	memcpy(existing_device->phys_connector, new_device->phys_connector,
 		sizeof(existing_device->phys_connector));
-	existing_device->offload_to_mirror = 0;
+	existing_device->next_bypass_group = 0;
 	kfree(existing_device->raid_map);
 	existing_device->raid_map = new_device->raid_map;
 	existing_device->raid_bypass_configured =
@@ -2250,7 +2254,10 @@ static bool pqi_aio_raid_level_supported(struct pqi_ctrl_info *ctrl_info,
 	case SA_RAID_0:
 		break;
 	case SA_RAID_1:
-		is_supported = false;
+		fallthrough;
+	case SA_RAID_ADM:
+		if (rmd->is_write && !ctrl_info->enable_r1_writes)
+			is_supported = false;
 		break;
 	case SA_RAID_5:
 		if (rmd->is_write && !ctrl_info->enable_r5_writes)
@@ -2260,10 +2267,6 @@ static bool pqi_aio_raid_level_supported(struct pqi_ctrl_info *ctrl_info,
 		if (rmd->is_write && !ctrl_info->enable_r6_writes)
 			is_supported = false;
 		break;
-	case SA_RAID_ADM:
-		if (rmd->is_write)
-			is_supported = false;
-		break;
 	default:
 		is_supported = false;
 	}
@@ -2385,64 +2388,6 @@ static int pci_get_aio_common_raid_map_values(struct pqi_ctrl_info *ctrl_info,
 	return 0;
 }
 
-static int pqi_calc_aio_raid_adm(struct pqi_scsi_dev_raid_map_data *rmd,
-				struct pqi_scsi_dev *device)
-{
-	/* RAID ADM */
-	/*
-	 * Handles N-way mirrors  (R1-ADM) and R10 with # of drives
-	 * divisible by 3.
-	 */
-	rmd->offload_to_mirror = device->offload_to_mirror;
-
-	if (rmd->offload_to_mirror == 0)  {
-		/* use physical disk in the first mirrored group. */
-		rmd->map_index %= rmd->data_disks_per_row;
-	} else {
-		do {
-			/*
-			 * Determine mirror group that map_index
-			 * indicates.
-			 */
-			rmd->current_group =
-				rmd->map_index / rmd->data_disks_per_row;
-
-			if (rmd->offload_to_mirror !=
-					rmd->current_group) {
-				if (rmd->current_group <
-					rmd->layout_map_count - 1) {
-					/*
-					 * Select raid index from
-					 * next group.
-					 */
-					rmd->map_index += rmd->data_disks_per_row;
-					rmd->current_group++;
-				} else {
-					/*
-					 * Select raid index from first
-					 * group.
-					 */
-					rmd->map_index %= rmd->data_disks_per_row;
-					rmd->current_group = 0;
-				}
-			}
-		} while (rmd->offload_to_mirror != rmd->current_group);
-	}
-
-	/* Set mirror group to use next time. */
-	rmd->offload_to_mirror =
-		(rmd->offload_to_mirror >= rmd->layout_map_count - 1) ?
-			0 : rmd->offload_to_mirror + 1;
-	device->offload_to_mirror = rmd->offload_to_mirror;
-	/*
-	 * Avoid direct use of device->offload_to_mirror within this
-	 * function since multiple threads might simultaneously
-	 * increment it beyond the range of device->layout_map_count -1.
-	 */
-
-	return 0;
-}
-
 static int pqi_calc_aio_r5_or_r6(struct pqi_scsi_dev_raid_map_data *rmd,
 				struct raid_map *raid_map)
 {
@@ -2577,12 +2522,34 @@ static void pqi_set_aio_cdb(struct pqi_scsi_dev_raid_map_data *rmd)
 	}
 }
 
+static void pqi_calc_aio_r1_nexus(struct raid_map *raid_map,
+				struct pqi_scsi_dev_raid_map_data *rmd)
+{
+	u32 index;
+	u32 group;
+
+	group = rmd->map_index / rmd->data_disks_per_row;
+
+	index = rmd->map_index - (group * rmd->data_disks_per_row);
+	rmd->it_nexus[0] = raid_map->disk_data[index].aio_handle;
+	index += rmd->data_disks_per_row;
+	rmd->it_nexus[1] = raid_map->disk_data[index].aio_handle;
+	if (rmd->layout_map_count > 2) {
+		index += rmd->data_disks_per_row;
+		rmd->it_nexus[2] = raid_map->disk_data[index].aio_handle;
+	}
+
+	rmd->num_it_nexus_entries = rmd->layout_map_count;
+}
+
 static int pqi_raid_bypass_submit_scsi_cmd(struct pqi_ctrl_info *ctrl_info,
 	struct pqi_scsi_dev *device, struct scsi_cmnd *scmd,
 	struct pqi_queue_group *queue_group)
 {
-	struct raid_map *raid_map;
 	int rc;
+	struct raid_map *raid_map;
+	u32 group;
+	u32 next_bypass_group;
 	struct pqi_encryption_info *encryption_info_ptr;
 	struct pqi_encryption_info encryption_info;
 	struct pqi_scsi_dev_raid_map_data rmd = {0};
@@ -2605,13 +2572,18 @@ static int pqi_raid_bypass_submit_scsi_cmd(struct pqi_ctrl_info *ctrl_info,
 	if (rc)
 		return PQI_RAID_BYPASS_INELIGIBLE;
 
-	/* RAID 1 */
-	if (device->raid_level == SA_RAID_1) {
-		if (device->offload_to_mirror)
-			rmd.map_index += rmd.data_disks_per_row;
-		device->offload_to_mirror = !device->offload_to_mirror;
-	} else if (device->raid_level == SA_RAID_ADM) {
-		rc = pqi_calc_aio_raid_adm(&rmd, device);
+	if (device->raid_level == SA_RAID_1 ||
+		device->raid_level == SA_RAID_ADM) {
+		if (rmd.is_write) {
+			pqi_calc_aio_r1_nexus(raid_map, &rmd);
+		} else {
+			group = device->next_bypass_group;
+			next_bypass_group = group + 1;
+			if (next_bypass_group >= rmd.layout_map_count)
+				next_bypass_group = 0;
+			device->next_bypass_group = next_bypass_group;
+			rmd.map_index += group * rmd.data_disks_per_row;
+		}
 	} else if ((device->raid_level == SA_RAID_5 ||
 		device->raid_level == SA_RAID_6) &&
 		(rmd.layout_map_count > 1 || rmd.is_write)) {
@@ -2655,6 +2627,10 @@ static int pqi_raid_bypass_submit_scsi_cmd(struct pqi_ctrl_info *ctrl_info,
 			return pqi_aio_submit_io(ctrl_info, scmd, rmd.aio_handle,
 				rmd.cdb, rmd.cdb_length, queue_group,
 				encryption_info_ptr, true);
+		case SA_RAID_1:
+		case SA_RAID_ADM:
+			return pqi_aio_submit_r1_write_io(ctrl_info, scmd, queue_group,
+				encryption_info_ptr, device, &rmd);
 		case SA_RAID_5:
 		case SA_RAID_6:
 			return pqi_aio_submit_r56_write_io(ctrl_info, scmd, queue_group,
@@ -4982,6 +4958,44 @@ static int pqi_build_raid_sg_list(struct pqi_ctrl_info *ctrl_info,
 	return 0;
 }
 
+static int pqi_build_aio_r1_sg_list(struct pqi_ctrl_info *ctrl_info,
+	struct pqi_aio_r1_path_request *request, struct scsi_cmnd *scmd,
+	struct pqi_io_request *io_request)
+{
+	u16 iu_length;
+	int sg_count;
+	bool chained;
+	unsigned int num_sg_in_iu;
+	struct scatterlist *sg;
+	struct pqi_sg_descriptor *sg_descriptor;
+
+	sg_count = scsi_dma_map(scmd);
+	if (sg_count < 0)
+		return sg_count;
+
+	iu_length = offsetof(struct pqi_aio_r1_path_request, sg_descriptors) -
+		PQI_REQUEST_HEADER_LENGTH;
+	num_sg_in_iu = 0;
+
+	if (sg_count == 0)
+		goto out;
+
+	sg = scsi_sglist(scmd);
+	sg_descriptor = request->sg_descriptors;
+
+	num_sg_in_iu = pqi_build_sg_list(sg_descriptor, sg, sg_count, io_request,
+		ctrl_info->max_sg_per_iu, &chained);
+
+	request->partial = chained;
+	iu_length += num_sg_in_iu * sizeof(*sg_descriptor);
+
+out:
+	put_unaligned_le16(iu_length, &request->header.iu_length);
+	request->num_sg_descriptors = num_sg_in_iu;
+
+	return 0;
+}
+
 static int pqi_build_aio_r56_sg_list(struct pqi_ctrl_info *ctrl_info,
 	struct pqi_aio_r56_path_request *request, struct scsi_cmnd *scmd,
 	struct pqi_io_request *io_request)
@@ -5424,6 +5438,83 @@ static int pqi_aio_submit_io(struct pqi_ctrl_info *ctrl_info,
 	return 0;
 }
 
+static  int pqi_aio_submit_r1_write_io(struct pqi_ctrl_info *ctrl_info,
+	struct scsi_cmnd *scmd, struct pqi_queue_group *queue_group,
+	struct pqi_encryption_info *encryption_info, struct pqi_scsi_dev *device,
+	struct pqi_scsi_dev_raid_map_data *rmd)
+
+{
+	int rc;
+	struct pqi_io_request *io_request;
+	struct pqi_aio_r1_path_request *r1_request;
+
+	io_request = pqi_alloc_io_request(ctrl_info);
+	io_request->io_complete_callback = pqi_aio_io_complete;
+	io_request->scmd = scmd;
+	io_request->raid_bypass = true;
+
+	r1_request = io_request->iu;
+	memset(r1_request, 0, offsetof(struct pqi_aio_r1_path_request, sg_descriptors));
+
+	r1_request->header.iu_type = PQI_REQUEST_IU_AIO_PATH_RAID1_IO;
+
+	put_unaligned_le16(*(u16 *)device->scsi3addr & 0x3fff, &r1_request->volume_id);
+	r1_request->num_drives = rmd->num_it_nexus_entries;
+	put_unaligned_le32(rmd->it_nexus[0], &r1_request->it_nexus_1);
+	put_unaligned_le32(rmd->it_nexus[1], &r1_request->it_nexus_2);
+	if (rmd->num_it_nexus_entries == 3)
+		put_unaligned_le32(rmd->it_nexus[2], &r1_request->it_nexus_3);
+
+	put_unaligned_le32(scsi_bufflen(scmd), &r1_request->data_length);
+	r1_request->task_attribute = SOP_TASK_ATTRIBUTE_SIMPLE;
+	put_unaligned_le16(io_request->index, &r1_request->request_id);
+	r1_request->error_index = r1_request->request_id;
+	if (rmd->cdb_length > sizeof(r1_request->cdb))
+		rmd->cdb_length = sizeof(r1_request->cdb);
+	r1_request->cdb_length = rmd->cdb_length;
+	memcpy(r1_request->cdb, rmd->cdb, rmd->cdb_length);
+
+	switch (scmd->sc_data_direction) {
+	case DMA_TO_DEVICE:
+		r1_request->data_direction = SOP_READ_FLAG;
+		break;
+	case DMA_FROM_DEVICE:
+		r1_request->data_direction = SOP_WRITE_FLAG;
+		break;
+	case DMA_NONE:
+		r1_request->data_direction = SOP_NO_DIRECTION_FLAG;
+		break;
+	case DMA_BIDIRECTIONAL:
+		r1_request->data_direction = SOP_BIDIRECTIONAL;
+		break;
+	default:
+		dev_err(&ctrl_info->pci_dev->dev,
+			"unknown data direction: %d\n",
+			scmd->sc_data_direction);
+		break;
+	}
+
+	if (encryption_info) {
+		r1_request->encryption_enable = true;
+		put_unaligned_le16(encryption_info->data_encryption_key_index,
+				&r1_request->data_encryption_key_index);
+		put_unaligned_le32(encryption_info->encrypt_tweak_lower,
+				&r1_request->encrypt_tweak_lower);
+		put_unaligned_le32(encryption_info->encrypt_tweak_upper,
+				&r1_request->encrypt_tweak_upper);
+	}
+
+	rc = pqi_build_aio_r1_sg_list(ctrl_info, r1_request, scmd, io_request);
+	if (rc) {
+		pqi_free_io_request(io_request);
+		return SCSI_MLQUEUE_HOST_BUSY;
+	}
+
+	pqi_start_io(ctrl_info, queue_group, AIO_PATH, io_request);
+
+	return 0;
+}
+
 static int pqi_aio_submit_r56_write_io(struct pqi_ctrl_info *ctrl_info,
 	struct scsi_cmnd *scmd, struct pqi_queue_group *queue_group,
 	struct pqi_encryption_info *encryption_info, struct pqi_scsi_dev *device,

