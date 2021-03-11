Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E3097C433E6
	for <linux-scsi@archiver.kernel.org>; Thu, 11 Mar 2021 20:16:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B32B064F8E
	for <linux-scsi@archiver.kernel.org>; Thu, 11 Mar 2021 20:16:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230047AbhCKUPx (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 11 Mar 2021 15:15:53 -0500
Received: from esa.microchip.iphmx.com ([68.232.153.233]:62147 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230016AbhCKUPd (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 11 Mar 2021 15:15:33 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1615493732; x=1647029732;
  h=subject:from:to:cc:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=3h8IiAc1KljV8HYSj/exNq9V2SOvGa7hGNJiV61usm4=;
  b=1YgTDKDzap00TP7YnHTolkSWtgpgkVpJnYVaqf02vCy3bHFzLrqn4irY
   WUQ8mpJq1IIH51wF3vfHuIIIXINramS9+uAMOEZcgUMNEgER8m7oZdiae
   jeGjRAsop6dLeMJi19HC4zi9TXT55xrLYziDlkF/r6h399NGPaUNCxXeG
   bswXhD8Vlw6OEN8YHDEwJHVPww/dN9T8LRA0Kc6AcvjupNW6uyU0QOGc9
   AwTVhyYY09qiNhEx6k0M/dyzkUKQPW6CcOGfu8N9sHHv8CObwDJoz2tIN
   HAoU62mTqFyIE8j+z8w7QyDzPYVi7Xz+zj3g1zm4ZFisurqZSTE/UTZwx
   Q==;
IronPort-SDR: g01GbsmNkQIxl2bq5dbob2oFJqIuUFPlC7kh4T7sy2cc92mJowFfO5alQBd+VZuD1Q4oo31Y9T
 nDiW5pyZlutqtqNCp554s6KvIrrzHtIIGfPU/eEnqaRPYbb15bJtguQ7o/GJKmZEoYnbqZBNBT
 zy9FnA9iMymqtJ3YQU6P3nh0BNMu2miw/8RLivUiWitqMPrjS4n2t83vfIeZ6IOrry8Dz+nUrE
 29XxjGRSMpMNCslo/Y4z/4L7HKapXNhcpFA9IyH5dAoEJXQWQfiuUgg3mvnpB5fOWysgGQMj3q
 Pa8=
X-IronPort-AV: E=Sophos;i="5.81,241,1610434800"; 
   d="scan'208";a="112888320"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa3.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 11 Mar 2021 13:15:32 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Thu, 11 Mar 2021 13:15:28 -0700
Received: from [127.0.1.1] (10.10.115.15) by chn-vm-ex04.mchp-main.com
 (10.10.85.152) with Microsoft SMTP Server id 15.1.2176.2 via Frontend
 Transport; Thu, 11 Mar 2021 13:15:27 -0700
Subject: [PATCH V5 06/31] smartpqi: add support for raid5 and raid6 writes
From:   Don Brace <don.brace@microchip.com>
To:     <Kevin.Barnett@microchip.com>, <scott.teel@microchip.com>,
        <Justin.Lindley@microchip.com>, <scott.benesh@microchip.com>,
        <gerry.morong@microchip.com>, <mahesh.rajashekhara@microchip.com>,
        <mike.mcgowen@microchip.com>, <murthy.bhat@microchip.com>,
        <hch@infradead.org>, <jejb@linux.vnet.ibm.com>,
        <joseph.szczypek@hpe.com>, <POSWALD@suse.com>
CC:     <linux-scsi@vger.kernel.org>
Date:   Thu, 11 Mar 2021 14:15:27 -0600
Message-ID: <161549372734.25025.963261942897080281.stgit@brunhilda>
In-Reply-To: <161549045434.25025.17473629602756431540.stgit@brunhilda>
References: <161549045434.25025.17473629602756431540.stgit@brunhilda>
User-Agent: StGit/0.23-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

* Add in new IU definition.
* Add in support raid5 and raid6 writes.

Reviewed-by: Scott Benesh <scott.benesh@microchip.com>
Reviewed-by: Mike McGowen <mike.mcgowen@microchip.com>
Reviewed-by: Scott Teel <scott.teel@microchip.com>
Reviewed-by: Kevin Barnett <kevin.barnett@microchip.com>
Signed-off-by: Don Brace <don.brace@microchip.com>
---
 drivers/scsi/smartpqi/smartpqi.h      |   37 +++++
 drivers/scsi/smartpqi/smartpqi_init.c |  237 ++++++++++++++++++++++++++++++++-
 2 files changed, 268 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/smartpqi/smartpqi.h b/drivers/scsi/smartpqi/smartpqi.h
index 01e18da139e3..a2fd246c8ae8 100644
--- a/drivers/scsi/smartpqi/smartpqi.h
+++ b/drivers/scsi/smartpqi/smartpqi.h
@@ -257,6 +257,7 @@ struct pqi_device_capability {
 };
 
 #define PQI_MAX_EMBEDDED_SG_DESCRIPTORS		4
+#define PQI_MAX_EMBEDDED_R56_SG_DESCRIPTORS	3
 
 struct pqi_raid_path_request {
 	struct pqi_iu_header header;
@@ -312,6 +313,37 @@ struct pqi_aio_path_request {
 		sg_descriptors[PQI_MAX_EMBEDDED_SG_DESCRIPTORS];
 };
 
+struct pqi_aio_r56_path_request {
+	struct pqi_iu_header header;
+	__le16	request_id;
+	__le16	volume_id;		/* ID of the RAID volume */
+	__le32	data_it_nexus;		/* IT nexus for the data drive */
+	__le32	p_parity_it_nexus;	/* IT nexus for the P parity drive */
+	__le32	q_parity_it_nexus;	/* IT nexus for the Q parity drive */
+	__le32	data_length;		/* total bytes to read/write */
+	u8	data_direction : 2;
+	u8	partial : 1;
+	u8	mem_type : 1;		/* 0 = PCIe, 1 = DDR */
+	u8	fence : 1;
+	u8	encryption_enable : 1;
+	u8	reserved : 2;
+	u8	task_attribute : 3;
+	u8	command_priority : 4;
+	u8	reserved1 : 1;
+	__le16	data_encryption_key_index;
+	u8	cdb[16];
+	__le16	error_index;
+	u8	num_sg_descriptors;
+	u8	cdb_length;
+	u8	xor_multiplier;
+	u8	reserved2[3];
+	__le32	encrypt_tweak_lower;
+	__le32	encrypt_tweak_upper;
+	__le64	row;			/* row = logical LBA/blocks per row */
+	u8	reserved3[8];
+	struct pqi_sg_descriptor sg_descriptors[PQI_MAX_EMBEDDED_R56_SG_DESCRIPTORS];
+};
+
 struct pqi_io_response {
 	struct pqi_iu_header header;
 	__le16	request_id;
@@ -484,6 +516,8 @@ struct pqi_raid_error_info {
 #define PQI_REQUEST_IU_TASK_MANAGEMENT			0x13
 #define PQI_REQUEST_IU_RAID_PATH_IO			0x14
 #define PQI_REQUEST_IU_AIO_PATH_IO			0x15
+#define PQI_REQUEST_IU_AIO_PATH_RAID5_IO		0x18
+#define PQI_REQUEST_IU_AIO_PATH_RAID6_IO		0x19
 #define PQI_REQUEST_IU_GENERAL_ADMIN			0x60
 #define PQI_REQUEST_IU_REPORT_VENDOR_EVENT_CONFIG	0x72
 #define PQI_REQUEST_IU_SET_VENDOR_EVENT_CONFIG		0x73
@@ -1179,6 +1213,7 @@ struct pqi_ctrl_info {
 	u16		max_inbound_iu_length_per_firmware;
 	u16		max_inbound_iu_length;
 	unsigned int	max_sg_per_iu;
+	unsigned int	max_sg_per_r56_iu;
 	void		*admin_queue_memory_base;
 	u32		admin_queue_memory_length;
 	dma_addr_t	admin_queue_memory_base_dma_handle;
@@ -1210,6 +1245,8 @@ struct pqi_ctrl_info {
 	u8		soft_reset_handshake_supported : 1;
 	u8		raid_iu_timeout_supported: 1;
 	u8		tmf_iu_timeout_supported: 1;
+	u8		enable_r5_writes : 1;
+	u8		enable_r6_writes : 1;
 
 	struct list_head scsi_device_list;
 	spinlock_t	scsi_device_list_lock;
diff --git a/drivers/scsi/smartpqi/smartpqi_init.c b/drivers/scsi/smartpqi/smartpqi_init.c
index 0eb8d4744e3d..17b697022473 100644
--- a/drivers/scsi/smartpqi/smartpqi_init.c
+++ b/drivers/scsi/smartpqi/smartpqi_init.c
@@ -67,6 +67,10 @@ static int pqi_aio_submit_io(struct pqi_ctrl_info *ctrl_info,
 	struct scsi_cmnd *scmd, u32 aio_handle, u8 *cdb,
 	unsigned int cdb_length, struct pqi_queue_group *queue_group,
 	struct pqi_encryption_info *encryption_info, bool raid_bypass);
+static int pqi_aio_submit_r56_write_io(struct pqi_ctrl_info *ctrl_info,
+	struct scsi_cmnd *scmd, struct pqi_queue_group *queue_group,
+	struct pqi_encryption_info *encryption_info, struct pqi_scsi_dev *device,
+	struct pqi_scsi_dev_raid_map_data *rmd);
 static void pqi_ofa_ctrl_quiesce(struct pqi_ctrl_info *ctrl_info);
 static void pqi_ofa_ctrl_unquiesce(struct pqi_ctrl_info *ctrl_info);
 static int pqi_ofa_ctrl_restart(struct pqi_ctrl_info *ctrl_info);
@@ -2237,7 +2241,8 @@ static inline void pqi_set_encryption_info(
  * Attempt to perform RAID bypass mapping for a logical volume I/O.
  */
 
-static bool pqi_aio_raid_level_supported(struct pqi_scsi_dev_raid_map_data *rmd)
+static bool pqi_aio_raid_level_supported(struct pqi_ctrl_info *ctrl_info,
+	struct pqi_scsi_dev_raid_map_data *rmd)
 {
 	bool is_supported = true;
 
@@ -2249,9 +2254,11 @@ static bool pqi_aio_raid_level_supported(struct pqi_scsi_dev_raid_map_data *rmd)
 			is_supported = false;
 		break;
 	case SA_RAID_5:
-		fallthrough;
+		if (rmd->is_write && !ctrl_info->enable_r5_writes)
+			is_supported = false;
+		break;
 	case SA_RAID_6:
-		if (rmd->is_write)
+		if (rmd->is_write && !ctrl_info->enable_r6_writes)
 			is_supported = false;
 		break;
 	case SA_RAID_ADM:
@@ -2526,6 +2533,38 @@ static int pqi_calc_aio_r5_or_r6(struct pqi_scsi_dev_raid_map_data *rmd,
 		rmd->total_disks_per_row)) +
 		(rmd->map_row * rmd->total_disks_per_row) + rmd->first_column;
 
+	if (rmd->is_write) {
+		u32 index;
+
+		/*
+		 * p_parity_it_nexus and q_parity_it_nexus are pointers to the
+		 * parity entries inside the device's raid_map.
+		 *
+		 * A device's RAID map is bounded by: number of RAID disks squared.
+		 *
+		 * The devices RAID map size is checked during device
+		 * initialization.
+		 */
+		index = DIV_ROUND_UP(rmd->map_index + 1, rmd->total_disks_per_row);
+		index *= rmd->total_disks_per_row;
+		index -= get_unaligned_le16(&raid_map->metadata_disks_per_row);
+
+		rmd->p_parity_it_nexus = raid_map->disk_data[index].aio_handle;
+		if (rmd->raid_level == SA_RAID_6) {
+			rmd->q_parity_it_nexus = raid_map->disk_data[index + 1].aio_handle;
+			rmd->xor_mult = raid_map->disk_data[rmd->map_index].xor_mult[1];
+		}
+		if (rmd->blocks_per_row == 0)
+			return PQI_RAID_BYPASS_INELIGIBLE;
+#if BITS_PER_LONG == 32
+		tmpdiv = rmd->first_block;
+		do_div(tmpdiv, rmd->blocks_per_row);
+		rmd->row = tmpdiv;
+#else
+		rmd->row = rmd->first_block / rmd->blocks_per_row;
+#endif
+	}
+
 	return 0;
 }
 
@@ -2567,7 +2606,7 @@ static int pqi_raid_bypass_submit_scsi_cmd(struct pqi_ctrl_info *ctrl_info,
 
 	rmd.raid_level = device->raid_level;
 
-	if (!pqi_aio_raid_level_supported(&rmd))
+	if (!pqi_aio_raid_level_supported(ctrl_info, &rmd))
 		return PQI_RAID_BYPASS_INELIGIBLE;
 
 	if (unlikely(rmd.block_cnt == 0))
@@ -2587,7 +2626,8 @@ static int pqi_raid_bypass_submit_scsi_cmd(struct pqi_ctrl_info *ctrl_info,
 	} else if (device->raid_level == SA_RAID_ADM) {
 		rc = pqi_calc_aio_raid_adm(&rmd, device);
 	} else if ((device->raid_level == SA_RAID_5 ||
-		device->raid_level == SA_RAID_6) && rmd.layout_map_count > 1) {
+		device->raid_level == SA_RAID_6) &&
+		(rmd.layout_map_count > 1 || rmd.is_write)) {
 		rc = pqi_calc_aio_r5_or_r6(&rmd, raid_map);
 		if (rc)
 			return PQI_RAID_BYPASS_INELIGIBLE;
@@ -2622,9 +2662,27 @@ static int pqi_raid_bypass_submit_scsi_cmd(struct pqi_ctrl_info *ctrl_info,
 		encryption_info_ptr = NULL;
 	}
 
-	return pqi_aio_submit_io(ctrl_info, scmd, rmd.aio_handle,
+	if (rmd.is_write) {
+		switch (device->raid_level) {
+		case SA_RAID_0:
+			return pqi_aio_submit_io(ctrl_info, scmd, rmd.aio_handle,
 				rmd.cdb, rmd.cdb_length, queue_group,
 				encryption_info_ptr, true);
+		case SA_RAID_5:
+		case SA_RAID_6:
+			return pqi_aio_submit_r56_write_io(ctrl_info, scmd, queue_group,
+					encryption_info_ptr, device, &rmd);
+		default:
+			return pqi_aio_submit_io(ctrl_info, scmd, rmd.aio_handle,
+				rmd.cdb, rmd.cdb_length, queue_group,
+				encryption_info_ptr, true);
+		}
+	} else {
+		return pqi_aio_submit_io(ctrl_info, scmd, rmd.aio_handle,
+			rmd.cdb, rmd.cdb_length, queue_group,
+			encryption_info_ptr, true);
+	}
+
 }
 
 #define PQI_STATUS_IDLE		0x0
@@ -4844,6 +4902,12 @@ static void pqi_calculate_queue_resources(struct pqi_ctrl_info *ctrl_info)
 		PQI_OPERATIONAL_IQ_ELEMENT_LENGTH) /
 		sizeof(struct pqi_sg_descriptor)) +
 		PQI_MAX_EMBEDDED_SG_DESCRIPTORS;
+
+	ctrl_info->max_sg_per_r56_iu =
+		((ctrl_info->max_inbound_iu_length -
+		PQI_OPERATIONAL_IQ_ELEMENT_LENGTH) /
+		sizeof(struct pqi_sg_descriptor)) +
+		PQI_MAX_EMBEDDED_R56_SG_DESCRIPTORS;
 }
 
 static inline void pqi_set_sg_descriptor(
@@ -4931,6 +4995,42 @@ static int pqi_build_raid_sg_list(struct pqi_ctrl_info *ctrl_info,
 	return 0;
 }
 
+static int pqi_build_aio_r56_sg_list(struct pqi_ctrl_info *ctrl_info,
+	struct pqi_aio_r56_path_request *request, struct scsi_cmnd *scmd,
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
+	iu_length = offsetof(struct pqi_aio_r56_path_request, sg_descriptors) -
+		PQI_REQUEST_HEADER_LENGTH;
+	num_sg_in_iu = 0;
+
+	if (sg_count != 0) {
+		sg = scsi_sglist(scmd);
+		sg_descriptor = request->sg_descriptors;
+
+		num_sg_in_iu = pqi_build_sg_list(sg_descriptor, sg, sg_count, io_request,
+			ctrl_info->max_sg_per_r56_iu, &chained);
+
+		request->partial = chained;
+		iu_length += num_sg_in_iu * sizeof(*sg_descriptor);
+	}
+
+	put_unaligned_le16(iu_length, &request->header.iu_length);
+	request->num_sg_descriptors = num_sg_in_iu;
+
+	return 0;
+}
+
 static int pqi_build_aio_sg_list(struct pqi_ctrl_info *ctrl_info,
 	struct pqi_aio_path_request *request, struct scsi_cmnd *scmd,
 	struct pqi_io_request *io_request)
@@ -5335,6 +5435,71 @@ static int pqi_aio_submit_io(struct pqi_ctrl_info *ctrl_info,
 	return 0;
 }
 
+static int pqi_aio_submit_r56_write_io(struct pqi_ctrl_info *ctrl_info,
+	struct scsi_cmnd *scmd, struct pqi_queue_group *queue_group,
+	struct pqi_encryption_info *encryption_info, struct pqi_scsi_dev *device,
+	struct pqi_scsi_dev_raid_map_data *rmd)
+{
+	int rc;
+	struct pqi_io_request *io_request;
+	struct pqi_aio_r56_path_request *r56_request;
+
+	io_request = pqi_alloc_io_request(ctrl_info);
+	io_request->io_complete_callback = pqi_aio_io_complete;
+	io_request->scmd = scmd;
+	io_request->raid_bypass = true;
+
+	r56_request = io_request->iu;
+	memset(r56_request, 0, offsetof(struct pqi_aio_r56_path_request, sg_descriptors));
+
+	if (device->raid_level == SA_RAID_5 || device->raid_level == SA_RAID_51)
+		r56_request->header.iu_type = PQI_REQUEST_IU_AIO_PATH_RAID5_IO;
+	else
+		r56_request->header.iu_type = PQI_REQUEST_IU_AIO_PATH_RAID6_IO;
+
+	put_unaligned_le16(*(u16 *)device->scsi3addr & 0x3fff, &r56_request->volume_id);
+	put_unaligned_le32(rmd->aio_handle, &r56_request->data_it_nexus);
+	put_unaligned_le32(rmd->p_parity_it_nexus, &r56_request->p_parity_it_nexus);
+	if (rmd->raid_level == SA_RAID_6) {
+		put_unaligned_le32(rmd->q_parity_it_nexus, &r56_request->q_parity_it_nexus);
+		r56_request->xor_multiplier = rmd->xor_mult;
+	}
+	put_unaligned_le32(scsi_bufflen(scmd), &r56_request->data_length);
+	r56_request->task_attribute = SOP_TASK_ATTRIBUTE_SIMPLE;
+	put_unaligned_le64(rmd->row, &r56_request->row);
+
+	put_unaligned_le16(io_request->index, &r56_request->request_id);
+	r56_request->error_index = r56_request->request_id;
+
+	if (rmd->cdb_length > sizeof(r56_request->cdb))
+		rmd->cdb_length = sizeof(r56_request->cdb);
+	r56_request->cdb_length = rmd->cdb_length;
+	memcpy(r56_request->cdb, rmd->cdb, rmd->cdb_length);
+
+	/* The direction is always write. */
+	r56_request->data_direction = SOP_READ_FLAG;
+
+	if (encryption_info) {
+		r56_request->encryption_enable = true;
+		put_unaligned_le16(encryption_info->data_encryption_key_index,
+				&r56_request->data_encryption_key_index);
+		put_unaligned_le32(encryption_info->encrypt_tweak_lower,
+				&r56_request->encrypt_tweak_lower);
+		put_unaligned_le32(encryption_info->encrypt_tweak_upper,
+				&r56_request->encrypt_tweak_upper);
+	}
+
+	rc = pqi_build_aio_r56_sg_list(ctrl_info, r56_request, scmd, io_request);
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
 static inline u16 pqi_get_hw_queue(struct pqi_ctrl_info *ctrl_info,
 	struct scsi_cmnd *scmd)
 {
@@ -6302,6 +6467,60 @@ static ssize_t pqi_lockup_action_store(struct device *dev,
 	return -EINVAL;
 }
 
+static ssize_t pqi_host_enable_r5_writes_show(struct device *dev,
+	struct device_attribute *attr, char *buffer)
+{
+	struct Scsi_Host *shost = class_to_shost(dev);
+	struct pqi_ctrl_info *ctrl_info = shost_to_hba(shost);
+
+	return scnprintf(buffer, 10, "%x\n", ctrl_info->enable_r5_writes);
+}
+
+static ssize_t pqi_host_enable_r5_writes_store(struct device *dev,
+	struct device_attribute *attr, const char *buffer, size_t count)
+{
+	struct Scsi_Host *shost = class_to_shost(dev);
+	struct pqi_ctrl_info *ctrl_info = shost_to_hba(shost);
+	u8 set_r5_writes = 0;
+
+	if (kstrtou8(buffer, 0, &set_r5_writes))
+		return -EINVAL;
+
+	if (set_r5_writes > 0)
+		set_r5_writes = 1;
+
+	ctrl_info->enable_r5_writes = set_r5_writes;
+
+	return count;
+}
+
+static ssize_t pqi_host_enable_r6_writes_show(struct device *dev,
+	struct device_attribute *attr, char *buffer)
+{
+	struct Scsi_Host *shost = class_to_shost(dev);
+	struct pqi_ctrl_info *ctrl_info = shost_to_hba(shost);
+
+	return scnprintf(buffer, 10, "%x\n", ctrl_info->enable_r6_writes);
+}
+
+static ssize_t pqi_host_enable_r6_writes_store(struct device *dev,
+	struct device_attribute *attr, const char *buffer, size_t count)
+{
+	struct Scsi_Host *shost = class_to_shost(dev);
+	struct pqi_ctrl_info *ctrl_info = shost_to_hba(shost);
+	u8 set_r6_writes = 0;
+
+	if (kstrtou8(buffer, 0, &set_r6_writes))
+		return -EINVAL;
+
+	if (set_r6_writes > 0)
+		set_r6_writes = 1;
+
+	ctrl_info->enable_r6_writes = set_r6_writes;
+
+	return count;
+}
+
 static DEVICE_ATTR(driver_version, 0444, pqi_driver_version_show, NULL);
 static DEVICE_ATTR(firmware_version, 0444, pqi_firmware_version_show, NULL);
 static DEVICE_ATTR(model, 0444, pqi_model_show, NULL);
@@ -6310,6 +6529,10 @@ static DEVICE_ATTR(vendor, 0444, pqi_vendor_show, NULL);
 static DEVICE_ATTR(rescan, 0200, NULL, pqi_host_rescan_store);
 static DEVICE_ATTR(lockup_action, 0644,
 	pqi_lockup_action_show, pqi_lockup_action_store);
+static DEVICE_ATTR(enable_r5_writes, 0644,
+	pqi_host_enable_r5_writes_show, pqi_host_enable_r5_writes_store);
+static DEVICE_ATTR(enable_r6_writes, 0644,
+	pqi_host_enable_r6_writes_show, pqi_host_enable_r6_writes_store);
 
 static struct device_attribute *pqi_shost_attrs[] = {
 	&dev_attr_driver_version,
@@ -6319,6 +6542,8 @@ static struct device_attribute *pqi_shost_attrs[] = {
 	&dev_attr_vendor,
 	&dev_attr_rescan,
 	&dev_attr_lockup_action,
+	&dev_attr_enable_r5_writes,
+	&dev_attr_enable_r6_writes,
 	NULL
 };
 

