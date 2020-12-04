Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 225CFC4361A
	for <linux-scsi@archiver.kernel.org>; Fri,  4 Dec 2020 23:02:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E4E3722D01
	for <linux-scsi@archiver.kernel.org>; Fri,  4 Dec 2020 23:02:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726294AbgLDXCK (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 4 Dec 2020 18:02:10 -0500
Received: from esa2.microchip.iphmx.com ([68.232.149.84]:45753 "EHLO
        esa2.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725960AbgLDXCK (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 4 Dec 2020 18:02:10 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1607122929; x=1638658929;
  h=subject:from:to:cc:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=SkZpuKQLM+gM32cFQhRmC2YIjTDAlqRus7vYfonSnLU=;
  b=i32lsrB6ZtHshxhig3NZvEGeMxaqn3k1xsQ/p4BZnPqWGBlLfFseUgcW
   iI1cfTATcyXwNM6yhcH3+WmN4/GswgUvMA5uLm/3zWngvG4wg8DvGTFdD
   VH8Z2yPWAQJerKw322IrXMtrU8o8Uw4HlQwrBwk7obPMPYpTTeS4x9FyP
   7+4/kdYlqCI2ByflGXo+FRHH2ohRTYGO403qfG0OHnlMyB+fDZHwO2DdK
   TkuCBjcHdIm/nNilvpWvmHoN4IK+a8fIMETT9a+ZhHXEs12unAhCNnCYL
   qjXHnPEJg5YLWq7n+PBD0gpBC4GGZNIJZ1b/WwZ29y7Gj48uld0+RCwJG
   w==;
IronPort-SDR: fUdBRQIolWo7f13BFvgj5+ay9f1LvRE4y4p54S5MQOIgMZCbyejo5+BgEwx1YoijbU5smD5b7h
 zTeqQq2w48CyIpYs5lC6jNOxgXR7lZFfsrq0YIK91tGfeN1/lgwS+LJJw3ICMr+uMNs7kXqTpt
 /OYTriAob4pIcRuE3PWBNPifPCg7FtNDwlmepbCxKO4GloUalIXn7p9CV5yEFdHtLtd6GbwgLI
 SH+BVTM6DDH8F56KVAGb/6O5Iwb1q+zKiBk5EDHzEjuUG5+hTpGobTwvPUYRjX6XC0+rceFNcr
 MQY=
X-IronPort-AV: E=Sophos;i="5.78,393,1599548400"; 
   d="scan'208";a="98683787"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa2.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 04 Dec 2020 16:01:03 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Fri, 4 Dec 2020 16:01:02 -0700
Received: from [127.0.1.1] (10.10.115.15) by chn-vm-ex04.mchp-main.com
 (10.10.85.152) with Microsoft SMTP Server id 15.1.1979.3 via Frontend
 Transport; Fri, 4 Dec 2020 16:01:02 -0700
Subject: [PATCH 02/25] smartpqi: refactor aio submission code
From:   Don Brace <don.brace@microchip.com>
To:     <Kevin.Barnett@microchip.com>, <scott.teel@microchip.com>,
        <Justin.Lindley@microchip.com>, <scott.benesh@microchip.com>,
        <gerry.morong@microchip.com>, <mahesh.rajashekhara@microchip.com>,
        <hch@infradead.org>, <jejb@linux.vnet.ibm.com>,
        <joseph.szczypek@hpe.com>, <POSWALD@suse.com>
CC:     <linux-scsi@vger.kernel.org>
Date:   Fri, 4 Dec 2020 17:01:02 -0600
Message-ID: <160712286220.21372.7483811214753573704.stgit@brunhilda>
In-Reply-To: <160712276179.21372.51526310810782843.stgit@brunhilda>
References: <160712276179.21372.51526310810782843.stgit@brunhilda>
User-Agent: StGit/0.23-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

* No functional changes.
  * Refactor aio submission code:
    1. remove 32-bit calculations.
    2. break-up function into smaller functions.
    3. add common block of data to carry around
       into newly added functions.

Reviewed-by: Scott Benesh <scott.benesh@microchip.com>
Reviewed-by: Scott Teel <scott.teel@microchip.com>
Reviewed-by: Kevin Barnett <kevin.barnett@microchip.com>
Signed-off-by: Don Brace <don.brace@microchip.com>
---
 drivers/scsi/smartpqi/smartpqi.h      |   52 +++
 drivers/scsi/smartpqi/smartpqi_init.c |  515 ++++++++++++++++-----------------
 2 files changed, 309 insertions(+), 258 deletions(-)

diff --git a/drivers/scsi/smartpqi/smartpqi.h b/drivers/scsi/smartpqi/smartpqi.h
index 7d3f956e949f..d486a2ec3045 100644
--- a/drivers/scsi/smartpqi/smartpqi.h
+++ b/drivers/scsi/smartpqi/smartpqi.h
@@ -908,6 +908,58 @@ struct raid_map {
 
 #pragma pack()
 
+struct pqi_scsi_dev_raid_map_data {
+	bool	is_write;
+	u8	raid_level;
+	u32	map_index;
+	u64	first_block;
+	u64	last_block;
+	u32	data_length;
+	u32	block_cnt;
+	u32	blocks_per_row;
+	u64	first_row;
+	u64	last_row;
+	u32	first_row_offset;
+	u32	last_row_offset;
+	u32	first_column;
+	u32	last_column;
+	u64	r5or6_first_row;
+	u64	r5or6_last_row;
+	u32	r5or6_first_row_offset;
+	u32	r5or6_last_row_offset;
+	u32	r5or6_first_column;
+	u32	r5or6_last_column;
+	u16	data_disks_per_row;
+	u32	total_disks_per_row;
+	u16	layout_map_count;
+	u32	stripesize;
+	u16	strip_size;
+	u32	first_group;
+	u32	last_group;
+	u32	current_group;
+	u32	map_row;
+	u32	aio_handle;
+	u64	disk_block;
+	u32	disk_block_cnt;
+	u8	cdb[16];
+	u8	cdb_length;
+	int	offload_to_mirror;
+
+	/* RAID1 specific */
+#define NUM_RAID1_MAP_ENTRIES 3
+	u32	num_it_nexus_entries;
+	u32	it_nexus[NUM_RAID1_MAP_ENTRIES];
+
+	/* RAID5 RAID6 specific */
+	u32	p_parity_it_nexus; /* aio_handle */
+	u32	q_parity_it_nexus; /* aio_handle */
+	u8	xor_mult;
+	u64	row;
+	u64	stripe_lba;
+	u32	p_index;
+	u32	q_index;
+};
+
 #define RAID_CTLR_LUNID		"\0\0\0\0\0\0\0\0"
 
 struct pqi_scsi_dev {
diff --git a/drivers/scsi/smartpqi/smartpqi_init.c b/drivers/scsi/smartpqi/smartpqi_init.c
index 68fc4327944e..99ea384d8211 100644
--- a/drivers/scsi/smartpqi/smartpqi_init.c
+++ b/drivers/scsi/smartpqi/smartpqi_init.c
@@ -2237,332 +2237,331 @@ static inline void pqi_set_encryption_info(
  * Attempt to perform RAID bypass mapping for a logical volume I/O.
  */
 
+static bool pqi_aio_raid_level_supported(struct pqi_scsi_dev_raid_map_data *rmd)
+{
+	bool is_supported = true;
+
+	switch (rmd->raid_level) {
+	case SA_RAID_0:
+		break;
+	case SA_RAID_1:
+		if (rmd->is_write)
+			is_supported = false;
+		break;
+	case SA_RAID_5:
+		fallthrough;
+	case SA_RAID_6:
+		if (rmd->is_write)
+			is_supported = false;
+		break;
+	case SA_RAID_ADM:
+		if (rmd->is_write)
+			is_supported = false;
+		break;
+	default:
+		is_supported = false;
+	}
+
+	return is_supported;
+}
+
 #define PQI_RAID_BYPASS_INELIGIBLE	1
 
-static int pqi_raid_bypass_submit_scsi_cmd(struct pqi_ctrl_info *ctrl_info,
-	struct pqi_scsi_dev *device, struct scsi_cmnd *scmd,
-	struct pqi_queue_group *queue_group)
+static int pqi_get_aio_lba_and_block_count(struct scsi_cmnd *scmd,
+			struct pqi_scsi_dev_raid_map_data *rmd)
 {
-	struct raid_map *raid_map;
-	bool is_write = false;
-	u32 map_index;
-	u64 first_block;
-	u64 last_block;
-	u32 block_cnt;
-	u32 blocks_per_row;
-	u64 first_row;
-	u64 last_row;
-	u32 first_row_offset;
-	u32 last_row_offset;
-	u32 first_column;
-	u32 last_column;
-	u64 r0_first_row;
-	u64 r0_last_row;
-	u32 r5or6_blocks_per_row;
-	u64 r5or6_first_row;
-	u64 r5or6_last_row;
-	u32 r5or6_first_row_offset;
-	u32 r5or6_last_row_offset;
-	u32 r5or6_first_column;
-	u32 r5or6_last_column;
-	u16 data_disks_per_row;
-	u32 total_disks_per_row;
-	u16 layout_map_count;
-	u32 stripesize;
-	u16 strip_size;
-	u32 first_group;
-	u32 last_group;
-	u32 current_group;
-	u32 map_row;
-	u32 aio_handle;
-	u64 disk_block;
-	u32 disk_block_cnt;
-	u8 cdb[16];
-	u8 cdb_length;
-	int offload_to_mirror;
-	struct pqi_encryption_info *encryption_info_ptr;
-	struct pqi_encryption_info encryption_info;
-#if BITS_PER_LONG == 32
-	u64 tmpdiv;
-#endif
-
 	/* Check for valid opcode, get LBA and block count. */
 	switch (scmd->cmnd[0]) {
 	case WRITE_6:
-		is_write = true;
+		rmd->is_write = true;
 		fallthrough;
 	case READ_6:
-		first_block = (u64)(((scmd->cmnd[1] & 0x1f) << 16) |
+		rmd->first_block = (u64)(((scmd->cmnd[1] & 0x1f) << 16) |
 			(scmd->cmnd[2] << 8) | scmd->cmnd[3]);
-		block_cnt = (u32)scmd->cmnd[4];
-		if (block_cnt == 0)
-			block_cnt = 256;
+		rmd->block_cnt = (u32)scmd->cmnd[4];
+		if (rmd->block_cnt == 0)
+			rmd->block_cnt = 256;
 		break;
 	case WRITE_10:
-		is_write = true;
+		rmd->is_write = true;
 		fallthrough;
 	case READ_10:
-		first_block = (u64)get_unaligned_be32(&scmd->cmnd[2]);
-		block_cnt = (u32)get_unaligned_be16(&scmd->cmnd[7]);
+		rmd->first_block = (u64)get_unaligned_be32(&scmd->cmnd[2]);
+		rmd->block_cnt = (u32)get_unaligned_be16(&scmd->cmnd[7]);
 		break;
 	case WRITE_12:
-		is_write = true;
+		rmd->is_write = true;
 		fallthrough;
 	case READ_12:
-		first_block = (u64)get_unaligned_be32(&scmd->cmnd[2]);
-		block_cnt = get_unaligned_be32(&scmd->cmnd[6]);
+		rmd->first_block = (u64)get_unaligned_be32(&scmd->cmnd[2]);
+		rmd->block_cnt = get_unaligned_be32(&scmd->cmnd[6]);
 		break;
 	case WRITE_16:
-		is_write = true;
+		rmd->is_write = true;
 		fallthrough;
 	case READ_16:
-		first_block = get_unaligned_be64(&scmd->cmnd[2]);
-		block_cnt = get_unaligned_be32(&scmd->cmnd[10]);
+		rmd->first_block = get_unaligned_be64(&scmd->cmnd[2]);
+		rmd->block_cnt = get_unaligned_be32(&scmd->cmnd[10]);
 		break;
 	default:
 		/* Process via normal I/O path. */
 		return PQI_RAID_BYPASS_INELIGIBLE;
 	}
 
-	/* Check for write to non-RAID-0. */
-	if (is_write && device->raid_level != SA_RAID_0)
-		return PQI_RAID_BYPASS_INELIGIBLE;
+	put_unaligned_le32(scsi_bufflen(scmd), &rmd->data_length);
 
-	if (unlikely(block_cnt == 0))
-		return PQI_RAID_BYPASS_INELIGIBLE;
+	return 0;
+}
 
-	last_block = first_block + block_cnt - 1;
-	raid_map = device->raid_map;
+static int pci_get_aio_common_raid_map_values(struct pqi_ctrl_info *ctrl_info,
+					struct pqi_scsi_dev_raid_map_data *rmd,
+					struct raid_map *raid_map)
+{
+	rmd->last_block = rmd->first_block + rmd->block_cnt - 1;
 
 	/* Check for invalid block or wraparound. */
-	if (last_block >= get_unaligned_le64(&raid_map->volume_blk_cnt) ||
-		last_block < first_block)
+	if (rmd->last_block >=
+		get_unaligned_le64(&raid_map->volume_blk_cnt) ||
+		rmd->last_block < rmd->first_block)
 		return PQI_RAID_BYPASS_INELIGIBLE;
 
-	data_disks_per_row = get_unaligned_le16(&raid_map->data_disks_per_row);
-	strip_size = get_unaligned_le16(&raid_map->strip_size);
-	layout_map_count = get_unaligned_le16(&raid_map->layout_map_count);
+	rmd->data_disks_per_row =
+			get_unaligned_le16(&raid_map->data_disks_per_row);
+	rmd->strip_size = get_unaligned_le16(&raid_map->strip_size);
+	rmd->layout_map_count = get_unaligned_le16(&raid_map->layout_map_count);
 
 	/* Calculate stripe information for the request. */
-	blocks_per_row = data_disks_per_row * strip_size;
-#if BITS_PER_LONG == 32
-	tmpdiv = first_block;
-	do_div(tmpdiv, blocks_per_row);
-	first_row = tmpdiv;
-	tmpdiv = last_block;
-	do_div(tmpdiv, blocks_per_row);
-	last_row = tmpdiv;
-	first_row_offset = (u32)(first_block - (first_row * blocks_per_row));
-	last_row_offset = (u32)(last_block - (last_row * blocks_per_row));
-	tmpdiv = first_row_offset;
-	do_div(tmpdiv, strip_size);
-	first_column = tmpdiv;
-	tmpdiv = last_row_offset;
-	do_div(tmpdiv, strip_size);
-	last_column = tmpdiv;
-#else
-	first_row = first_block / blocks_per_row;
-	last_row = last_block / blocks_per_row;
-	first_row_offset = (u32)(first_block - (first_row * blocks_per_row));
-	last_row_offset = (u32)(last_block - (last_row * blocks_per_row));
-	first_column = first_row_offset / strip_size;
-	last_column = last_row_offset / strip_size;
-#endif
+	rmd->blocks_per_row = rmd->data_disks_per_row * rmd->strip_size;
+	rmd->first_row = rmd->first_block / rmd->blocks_per_row;
+	rmd->last_row = rmd->last_block / rmd->blocks_per_row;
+	rmd->first_row_offset = (u32)(rmd->first_block -
+				(rmd->first_row * rmd->blocks_per_row));
+	rmd->last_row_offset = (u32)(rmd->last_block - (rmd->last_row *
+				rmd->blocks_per_row));
+	rmd->first_column = rmd->first_row_offset / rmd->strip_size;
+	rmd->last_column = rmd->last_row_offset / rmd->strip_size;
 
 	/* If this isn't a single row/column then give to the controller. */
-	if (first_row != last_row || first_column != last_column)
+	if (rmd->first_row != rmd->last_row ||
+			rmd->first_column != rmd->last_column)
 		return PQI_RAID_BYPASS_INELIGIBLE;
 
 	/* Proceeding with driver mapping. */
-	total_disks_per_row = data_disks_per_row +
+	rmd->total_disks_per_row = rmd->data_disks_per_row +
 		get_unaligned_le16(&raid_map->metadata_disks_per_row);
-	map_row = ((u32)(first_row >> raid_map->parity_rotation_shift)) %
+	rmd->map_row = ((u32)(rmd->first_row >>
+		raid_map->parity_rotation_shift)) %
+		get_unaligned_le16(&raid_map->row_cnt);
+	rmd->map_index = (rmd->map_row * rmd->total_disks_per_row) +
+			rmd->first_column;
+
+	return 0;
+}
+
+static int pqi_calc_aio_raid_adm(struct pqi_scsi_dev_raid_map_data *rmd,
+				struct pqi_scsi_dev *device)
+{
+	/* RAID ADM */
+	/*
+	 * Handles N-way mirrors  (R1-ADM) and R10 with # of drives
+	 * divisible by 3.
+	 */
+	rmd->offload_to_mirror = device->offload_to_mirror;
+
+	if (rmd->offload_to_mirror == 0)  {
+		/* use physical disk in the first mirrored group. */
+		rmd->map_index %= rmd->data_disks_per_row;
+	} else {
+		do {
+			/*
+			 * Determine mirror group that map_index
+			 * indicates.
+			 */
+			rmd->current_group =
+				rmd->map_index / rmd->data_disks_per_row;
+
+			if (rmd->offload_to_mirror !=
+					rmd->current_group) {
+				if (rmd->current_group <
+					rmd->layout_map_count - 1) {
+					/*
+					 * Select raid index from
+					 * next group.
+					 */
+					rmd->map_index += rmd->data_disks_per_row;
+					rmd->current_group++;
+				} else {
+					/*
+					 * Select raid index from first
+					 * group.
+					 */
+					rmd->map_index %= rmd->data_disks_per_row;
+					rmd->current_group = 0;
+				}
+			}
+		} while (rmd->offload_to_mirror != rmd->current_group);
+	}
+
+	/* Set mirror group to use next time. */
+	rmd->offload_to_mirror =
+		(rmd->offload_to_mirror >= rmd->layout_map_count - 1) ?
+			0 : rmd->offload_to_mirror + 1;
+	device->offload_to_mirror = rmd->offload_to_mirror;
+	/*
+	 * Avoid direct use of device->offload_to_mirror within this
+	 * function since multiple threads might simultaneously
+	 * increment it beyond the range of device->layout_map_count -1.
+	 */
+
+	return 0;
+}
+
+static int pqi_calc_aio_r5_or_r6(struct pqi_scsi_dev_raid_map_data *rmd,
+				struct raid_map *raid_map)
+{
+	/* RAID 50/60 */
+	/* Verify first and last block are in same RAID group */
+	rmd->stripesize = rmd->blocks_per_row * rmd->layout_map_count;
+	rmd->first_group = (rmd->first_block %
+			rmd->stripesize) / rmd->blocks_per_row;
+	rmd->last_group = (rmd->last_block %
+			rmd->stripesize) / rmd->blocks_per_row;
+	if (rmd->first_group != rmd->last_group)
+		return PQI_RAID_BYPASS_INELIGIBLE;
+
+	/* Verify request is in a single row of RAID 5/6 */
+	rmd->first_row = rmd->r5or6_first_row =
+		rmd->first_block / rmd->stripesize;
+	rmd->r5or6_last_row = rmd->last_block / rmd->stripesize;
+	if (rmd->r5or6_first_row != rmd->r5or6_last_row)
+		return PQI_RAID_BYPASS_INELIGIBLE;
+
+	/* Verify request is in a single column */
+	rmd->first_row_offset = rmd->r5or6_first_row_offset =
+		(u32)((rmd->first_block %
+				rmd->stripesize) %
+				rmd->blocks_per_row);
+
+	rmd->r5or6_last_row_offset =
+		(u32)((rmd->last_block % rmd->stripesize) %
+		rmd->blocks_per_row);
+
+	rmd->first_column =
+			rmd->r5or6_first_row_offset / rmd->strip_size;
+	rmd->r5or6_first_column = rmd->first_column;
+	rmd->r5or6_last_column = rmd->r5or6_last_row_offset / rmd->strip_size;
+	if (rmd->r5or6_first_column != rmd->r5or6_last_column)
+		return PQI_RAID_BYPASS_INELIGIBLE;
+
+	/* Request is eligible */
+	rmd->map_row =
+		((u32)(rmd->first_row >> raid_map->parity_rotation_shift)) %
 		get_unaligned_le16(&raid_map->row_cnt);
-	map_index = (map_row * total_disks_per_row) + first_column;
+
+	rmd->map_index = (rmd->first_group *
+		(get_unaligned_le16(&raid_map->row_cnt) *
+		rmd->total_disks_per_row)) +
+		(rmd->map_row * rmd->total_disks_per_row) + rmd->first_column;
+
+	return 0;
+}
+
+static void pqi_set_aio_cdb(struct pqi_scsi_dev_raid_map_data *rmd)
+{
+	/* Build the new CDB for the physical disk I/O. */
+	if (rmd->disk_block > 0xffffffff) {
+		rmd->cdb[0] = rmd->is_write ? WRITE_16 : READ_16;
+		rmd->cdb[1] = 0;
+		put_unaligned_be64(rmd->disk_block, &rmd->cdb[2]);
+		put_unaligned_be32(rmd->disk_block_cnt, &rmd->cdb[10]);
+		rmd->cdb[14] = 0;
+		rmd->cdb[15] = 0;
+		rmd->cdb_length = 16;
+	} else {
+		rmd->cdb[0] = rmd->is_write ? WRITE_10 : READ_10;
+		rmd->cdb[1] = 0;
+		put_unaligned_be32((u32)rmd->disk_block, &rmd->cdb[2]);
+		rmd->cdb[6] = 0;
+		put_unaligned_be16((u16)rmd->disk_block_cnt, &rmd->cdb[7]);
+		rmd->cdb[9] = 0;
+		rmd->cdb_length = 10;
+	}
+}
+
+static int pqi_raid_bypass_submit_scsi_cmd(struct pqi_ctrl_info *ctrl_info,
+	struct pqi_scsi_dev *device, struct scsi_cmnd *scmd,
+	struct pqi_queue_group *queue_group)
+{
+	struct raid_map *raid_map;
+	int rc;
+	struct pqi_encryption_info *encryption_info_ptr;
+	struct pqi_encryption_info encryption_info;
+	struct pqi_scsi_dev_raid_map_data rmd = {0};
+
+	rc = pqi_get_aio_lba_and_block_count(scmd, &rmd);
+	if (rc)
+		return PQI_RAID_BYPASS_INELIGIBLE;
+
+	rmd.raid_level = device->raid_level;
+
+	if (!pqi_aio_raid_level_supported(&rmd))
+		return PQI_RAID_BYPASS_INELIGIBLE;
+
+	if (unlikely(rmd.block_cnt == 0))
+		return PQI_RAID_BYPASS_INELIGIBLE;
+
+	raid_map = device->raid_map;
+
+	rc = pci_get_aio_common_raid_map_values(ctrl_info, &rmd, raid_map);
+	if (rc)
+		return PQI_RAID_BYPASS_INELIGIBLE;
 
 	/* RAID 1 */
 	if (device->raid_level == SA_RAID_1) {
 		if (device->offload_to_mirror)
-			map_index += data_disks_per_row;
+			rmd.map_index += rmd.data_disks_per_row;
 		device->offload_to_mirror = !device->offload_to_mirror;
 	} else if (device->raid_level == SA_RAID_ADM) {
-		/* RAID ADM */
-		/*
-		 * Handles N-way mirrors  (R1-ADM) and R10 with # of drives
-		 * divisible by 3.
-		 */
-		offload_to_mirror = device->offload_to_mirror;
-		if (offload_to_mirror == 0)  {
-			/* use physical disk in the first mirrored group. */
-			map_index %= data_disks_per_row;
-		} else {
-			do {
-				/*
-				 * Determine mirror group that map_index
-				 * indicates.
-				 */
-				current_group = map_index / data_disks_per_row;
-
-				if (offload_to_mirror != current_group) {
-					if (current_group <
-						layout_map_count - 1) {
-						/*
-						 * Select raid index from
-						 * next group.
-						 */
-						map_index += data_disks_per_row;
-						current_group++;
-					} else {
-						/*
-						 * Select raid index from first
-						 * group.
-						 */
-						map_index %= data_disks_per_row;
-						current_group = 0;
-					}
-				}
-			} while (offload_to_mirror != current_group);
-		}
-
-		/* Set mirror group to use next time. */
-		offload_to_mirror =
-			(offload_to_mirror >= layout_map_count - 1) ?
-				0 : offload_to_mirror + 1;
-		device->offload_to_mirror = offload_to_mirror;
-		/*
-		 * Avoid direct use of device->offload_to_mirror within this
-		 * function since multiple threads might simultaneously
-		 * increment it beyond the range of device->layout_map_count -1.
-		 */
+		rc = pqi_calc_aio_raid_adm(&rmd, device);
 	} else if ((device->raid_level == SA_RAID_5 ||
-		device->raid_level == SA_RAID_6) && layout_map_count > 1) {
-		/* RAID 50/60 */
-		/* Verify first and last block are in same RAID group */
-		r5or6_blocks_per_row = strip_size * data_disks_per_row;
-		stripesize = r5or6_blocks_per_row * layout_map_count;
-#if BITS_PER_LONG == 32
-		tmpdiv = first_block;
-		first_group = do_div(tmpdiv, stripesize);
-		tmpdiv = first_group;
-		do_div(tmpdiv, r5or6_blocks_per_row);
-		first_group = tmpdiv;
-		tmpdiv = last_block;
-		last_group = do_div(tmpdiv, stripesize);
-		tmpdiv = last_group;
-		do_div(tmpdiv, r5or6_blocks_per_row);
-		last_group = tmpdiv;
-#else
-		first_group = (first_block % stripesize) / r5or6_blocks_per_row;
-		last_group = (last_block % stripesize) / r5or6_blocks_per_row;
-#endif
-		if (first_group != last_group)
-			return PQI_RAID_BYPASS_INELIGIBLE;
-
-		/* Verify request is in a single row of RAID 5/6 */
-#if BITS_PER_LONG == 32
-		tmpdiv = first_block;
-		do_div(tmpdiv, stripesize);
-		first_row = r5or6_first_row = r0_first_row = tmpdiv;
-		tmpdiv = last_block;
-		do_div(tmpdiv, stripesize);
-		r5or6_last_row = r0_last_row = tmpdiv;
-#else
-		first_row = r5or6_first_row = r0_first_row =
-			first_block / stripesize;
-		r5or6_last_row = r0_last_row = last_block / stripesize;
-#endif
-		if (r5or6_first_row != r5or6_last_row)
-			return PQI_RAID_BYPASS_INELIGIBLE;
-
-		/* Verify request is in a single column */
-#if BITS_PER_LONG == 32
-		tmpdiv = first_block;
-		first_row_offset = do_div(tmpdiv, stripesize);
-		tmpdiv = first_row_offset;
-		first_row_offset = (u32)do_div(tmpdiv, r5or6_blocks_per_row);
-		r5or6_first_row_offset = first_row_offset;
-		tmpdiv = last_block;
-		r5or6_last_row_offset = do_div(tmpdiv, stripesize);
-		tmpdiv = r5or6_last_row_offset;
-		r5or6_last_row_offset = do_div(tmpdiv, r5or6_blocks_per_row);
-		tmpdiv = r5or6_first_row_offset;
-		do_div(tmpdiv, strip_size);
-		first_column = r5or6_first_column = tmpdiv;
-		tmpdiv = r5or6_last_row_offset;
-		do_div(tmpdiv, strip_size);
-		r5or6_last_column = tmpdiv;
-#else
-		first_row_offset = r5or6_first_row_offset =
-			(u32)((first_block % stripesize) %
-			r5or6_blocks_per_row);
-
-		r5or6_last_row_offset =
-			(u32)((last_block % stripesize) %
-			r5or6_blocks_per_row);
-
-		first_column = r5or6_first_row_offset / strip_size;
-		r5or6_first_column = first_column;
-		r5or6_last_column = r5or6_last_row_offset / strip_size;
-#endif
-		if (r5or6_first_column != r5or6_last_column)
+		device->raid_level == SA_RAID_6) && rmd.layout_map_count > 1) {
+		rc = pqi_calc_aio_r5_or_r6(&rmd, raid_map);
+		if (rc)
 			return PQI_RAID_BYPASS_INELIGIBLE;
-
-		/* Request is eligible */
-		map_row =
-			((u32)(first_row >> raid_map->parity_rotation_shift)) %
-			get_unaligned_le16(&raid_map->row_cnt);
-
-		map_index = (first_group *
-			(get_unaligned_le16(&raid_map->row_cnt) *
-			total_disks_per_row)) +
-			(map_row * total_disks_per_row) + first_column;
 	}
 
-	aio_handle = raid_map->disk_data[map_index].aio_handle;
-	disk_block = get_unaligned_le64(&raid_map->disk_starting_blk) +
-		first_row * strip_size +
-		(first_row_offset - first_column * strip_size);
-	disk_block_cnt = block_cnt;
+	if (unlikely(rmd.map_index >= RAID_MAP_MAX_ENTRIES))
+		return PQI_RAID_BYPASS_INELIGIBLE;
+
+	rmd.aio_handle = raid_map->disk_data[rmd.map_index].aio_handle;
+	rmd.disk_block = get_unaligned_le64(&raid_map->disk_starting_blk) +
+		rmd.first_row * rmd.strip_size +
+		(rmd.first_row_offset - rmd.first_column * rmd.strip_size);
+	rmd.disk_block_cnt = rmd.block_cnt;
 
 	/* Handle differing logical/physical block sizes. */
 	if (raid_map->phys_blk_shift) {
-		disk_block <<= raid_map->phys_blk_shift;
-		disk_block_cnt <<= raid_map->phys_blk_shift;
+		rmd.disk_block <<= raid_map->phys_blk_shift;
+		rmd.disk_block_cnt <<= raid_map->phys_blk_shift;
 	}
 
-	if (unlikely(disk_block_cnt > 0xffff))
+	if (unlikely(rmd.disk_block_cnt > 0xffff))
 		return PQI_RAID_BYPASS_INELIGIBLE;
 
-	/* Build the new CDB for the physical disk I/O. */
-	if (disk_block > 0xffffffff) {
-		cdb[0] = is_write ? WRITE_16 : READ_16;
-		cdb[1] = 0;
-		put_unaligned_be64(disk_block, &cdb[2]);
-		put_unaligned_be32(disk_block_cnt, &cdb[10]);
-		cdb[14] = 0;
-		cdb[15] = 0;
-		cdb_length = 16;
-	} else {
-		cdb[0] = is_write ? WRITE_10 : READ_10;
-		cdb[1] = 0;
-		put_unaligned_be32((u32)disk_block, &cdb[2]);
-		cdb[6] = 0;
-		put_unaligned_be16((u16)disk_block_cnt, &cdb[7]);
-		cdb[9] = 0;
-		cdb_length = 10;
-	}
+	pqi_set_aio_cdb(&rmd);
 
 	if (get_unaligned_le16(&raid_map->flags) &
 		RAID_MAP_ENCRYPTION_ENABLED) {
 		pqi_set_encryption_info(&encryption_info, raid_map,
-			first_block);
+			rmd.first_block);
 		encryption_info_ptr = &encryption_info;
 	} else {
 		encryption_info_ptr = NULL;
 	}
 
-	return pqi_aio_submit_io(ctrl_info, scmd, aio_handle,
-		cdb, cdb_length, queue_group, encryption_info_ptr, true);
+	return pqi_aio_submit_io(ctrl_info, scmd, rmd.aio_handle,
+				rmd.cdb, rmd.cdb_length, queue_group,
+				encryption_info_ptr, true);
 }
 
 #define PQI_STATUS_IDLE		0x0

