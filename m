From: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>
Subject: [PATCH 21/35] hpsa: complete the ioaccel raidmap code
Date: Tue, 18 Feb 2014 13:56:55 -0600
Message-ID: <20140218195655.15787.56369.stgit@beardog.cce.hp.com>
References: <20140218195251.15787.55872.stgit@beardog.cce.hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g2t1383g.austin.hp.com ([15.217.136.92]:57077 "EHLO
	g2t1383g.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751982AbaBRT6V (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 18 Feb 2014 14:58:21 -0500
Received: from g4t3426.houston.hp.com (g4t3426.houston.hp.com [15.201.208.54])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by g2t1383g.austin.hp.com (Postfix) with ESMTPS id 8F8B11011
	for <linux-scsi@vger.kernel.org>; Tue, 18 Feb 2014 19:58:14 +0000 (UTC)
In-Reply-To: <20140218195251.15787.55872.stgit@beardog.cce.hp.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: james.bottomley@hansenpartnership.com
Cc: dab@hp.com, martin.petersen@oracle.com, linux-scsi@vger.kernel.org, stephenmcameron@gmail.com, joseph.t.handzik@hp.com, thenzl@redhat.com, michael.miller@canonical.com, scott.teel@hp.com

From: Scott Teel <scott.teel@hp.com>

Load balance across members of a N-way mirror set, and
handle the meta-RAID levels: R10, R50, R60.

Signed-off-by: Scott Teel <scott.teel@hp.com>
Acked-by: Stephen M. Cameron <scameron@beardog.cce.hp.com>
---
 drivers/scsi/hpsa.c |  174 +++++++++++++++++++++++++++++++++++++++++++++++++--
 1 files changed, 168 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index bcb48b5..10f48ba 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -423,6 +423,13 @@ static inline int is_logical_dev_addr_mode(unsigned char scsi3addr[])
 static const char *raid_label[] = { "0", "4", "1(1+0)", "5", "5+1", "ADG",
 	"1(ADM)", "UNKNOWN"
 };
+#define HPSA_RAID_0	0
+#define HPSA_RAID_4	1
+#define HPSA_RAID_1	2	/* also used for RAID 10 */
+#define HPSA_RAID_5	3	/* also used for RAID 50 */
+#define HPSA_RAID_51	4
+#define HPSA_RAID_6	5	/* also used for RAID 60 */
+#define HPSA_RAID_ADM	6	/* also used for RAID 1+0 ADM */
 #define RAID_UNKNOWN (ARRAY_SIZE(raid_label) - 1)
 
 static ssize_t raid_level_show(struct device *dev,
@@ -2941,6 +2948,31 @@ static int hpsa_scsi_ioaccel_queue_command(struct ctlr_info *h,
 						cdb, cdb_len, scsi3addr);
 }
 
+static void raid_map_helper(struct raid_map_data *map,
+		int offload_to_mirror, u32 *map_index, u32 *current_group)
+{
+	if (offload_to_mirror == 0)  {
+		/* use physical disk in the first mirrored group. */
+		*map_index %= map->data_disks_per_row;
+		return;
+	}
+	do {
+		/* determine mirror group that *map_index indicates */
+		*current_group = *map_index / map->data_disks_per_row;
+		if (offload_to_mirror == *current_group)
+			continue;
+		if (*current_group < (map->layout_map_count - 1)) {
+			/* select map index from next group */
+			*map_index += map->data_disks_per_row;
+			(*current_group)++;
+		} else {
+			/* select map index from first group */
+			*map_index %= map->data_disks_per_row;
+			*current_group = 0;
+		}
+	} while (offload_to_mirror != *current_group);
+}
+
 /*
  * Attempt to perform offload RAID mapping for a logical volume I/O.
  */
@@ -2959,6 +2991,14 @@ static int hpsa_scsi_ioaccel_raid_map(struct ctlr_info *h,
 	u64 first_row, last_row;
 	u32 first_row_offset, last_row_offset;
 	u32 first_column, last_column;
+	u64 r0_first_row, r0_last_row;
+	u32 r5or6_blocks_per_row;
+	u64 r5or6_first_row, r5or6_last_row;
+	u32 r5or6_first_row_offset, r5or6_last_row_offset;
+	u32 r5or6_first_column, r5or6_last_column;
+	u32 total_disks_per_row;
+	u32 stripesize;
+	u32 first_group, last_group, current_group;
 	u32 map_row;
 	u32 disk_handle;
 	u64 disk_block;
@@ -2968,6 +3008,7 @@ static int hpsa_scsi_ioaccel_raid_map(struct ctlr_info *h,
 #if BITS_PER_LONG == 32
 	u64 tmpdiv;
 #endif
+	int offload_to_mirror;
 
 	BUG_ON(!(dev->offload_config && dev->offload_enabled));
 
@@ -3070,19 +3111,140 @@ static int hpsa_scsi_ioaccel_raid_map(struct ctlr_info *h,
 		return IO_ACCEL_INELIGIBLE;
 
 	/* proceeding with driver mapping */
+	total_disks_per_row = map->data_disks_per_row +
+				map->metadata_disks_per_row;
 	map_row = ((u32)(first_row >> map->parity_rotation_shift)) %
 				map->row_cnt;
-	map_index = (map_row * (map->data_disks_per_row +
-				map->metadata_disks_per_row)) + first_column;
-	if (dev->raid_level == 2) {
-		/* simple round-robin balancing of RAID 1+0 reads across
-		 * primary and mirror members.  this is appropriate for SSD
-		 * but not optimal for HDD.
+	map_index = (map_row * total_disks_per_row) + first_column;
+
+	switch (dev->raid_level) {
+	case HPSA_RAID_0:
+		break; /* nothing special to do */
+	case HPSA_RAID_1:
+		/* Handles load balance across RAID 1 members.
+		 * (2-drive R1 and R10 with even # of drives.)
+		 * Appropriate for SSDs, not optimal for HDDs
 		 */
+		BUG_ON(map->layout_map_count != 2);
 		if (dev->offload_to_mirror)
 			map_index += map->data_disks_per_row;
 		dev->offload_to_mirror = !dev->offload_to_mirror;
+		break;
+	case HPSA_RAID_ADM:
+		/* Handles N-way mirrors  (R1-ADM)
+		 * and R10 with # of drives divisible by 3.)
+		 */
+		BUG_ON(map->layout_map_count != 3);
+
+		offload_to_mirror = dev->offload_to_mirror;
+		raid_map_helper(map, offload_to_mirror,
+				&map_index, &current_group);
+		/* set mirror group to use next time */
+		offload_to_mirror =
+			(offload_to_mirror >= map->layout_map_count - 1)
+			? 0 : offload_to_mirror + 1;
+		/* FIXME: remove after debug/dev */
+		BUG_ON(offload_to_mirror >= map->layout_map_count);
+		dev_warn(&h->pdev->dev,
+			"DEBUG: Using physical disk map index %d from mirror group %d\n",
+			map_index, offload_to_mirror);
+		dev->offload_to_mirror = offload_to_mirror;
+		/* Avoid direct use of dev->offload_to_mirror within this
+		 * function since multiple threads might simultaneously
+		 * increment it beyond the range of dev->layout_map_count -1.
+		 */
+		break;
+	case HPSA_RAID_5:
+	case HPSA_RAID_6:
+		if (map->layout_map_count <= 1)
+			break;
+
+		/* Verify first and last block are in same RAID group */
+		r5or6_blocks_per_row =
+			map->strip_size * map->data_disks_per_row;
+		BUG_ON(r5or6_blocks_per_row == 0);
+		stripesize = r5or6_blocks_per_row * map->layout_map_count;
+#if BITS_PER_LONG == 32
+		tmpdiv = first_block;
+		first_group = do_div(tmpdiv, stripesize);
+		tmpdiv = first_group;
+		(void) do_div(tmpdiv, r5or6_blocks_per_row);
+		first_group = tmpdiv;
+		tmpdiv = last_block;
+		last_group = do_div(tmpdiv, stripesize);
+		tmpdiv = last_group;
+		(void) do_div(tmpdiv, r5or6_blocks_per_row);
+		last_group = tmpdiv;
+#else
+		first_group = (first_block % stripesize) / r5or6_blocks_per_row;
+		last_group = (last_block % stripesize) / r5or6_blocks_per_row;
+		if (first_group != last_group)
+#endif
+			return IO_ACCEL_INELIGIBLE;
+
+		/* Verify request is in a single row of RAID 5/6 */
+#if BITS_PER_LONG == 32
+		tmpdiv = first_block;
+		(void) do_div(tmpdiv, stripesize);
+		first_row = r5or6_first_row = r0_first_row = tmpdiv;
+		tmpdiv = last_block;
+		(void) do_div(tmpdiv, stripesize);
+		r5or6_last_row = r0_last_row = tmpdiv;
+#else
+		first_row = r5or6_first_row = r0_first_row =
+						first_block / stripesize;
+		r5or6_last_row = r0_last_row = last_block / stripesize;
+#endif
+		if (r5or6_first_row != r5or6_last_row)
+			return IO_ACCEL_INELIGIBLE;
+
+
+		/* Verify request is in a single column */
+#if BITS_PER_LONG == 32
+		tmpdiv = first_block;
+		first_row_offset = do_div(tmpdiv, stripesize);
+		tmpdiv = first_row_offset;
+		first_row_offset = (u32) do_div(tmpdiv, r5or6_blocks_per_row);
+		r5or6_first_row_offset = first_row_offset;
+		tmpdiv = last_block;
+		r5or6_last_row_offset = do_div(tmpdiv, stripesize);
+		tmpdiv = r5or6_last_row_offset;
+		r5or6_last_row_offset = do_div(tmpdiv, r5or6_blocks_per_row);
+		tmpdiv = r5or6_first_row_offset;
+		(void) do_div(tmpdiv, map->strip_size);
+		first_column = r5or6_first_column = tmpdiv;
+		tmpdiv = r5or6_last_row_offset;
+		(void) do_div(tmpdiv, map->strip_size);
+		r5or6_last_column = tmpdiv;
+#else
+		first_row_offset = r5or6_first_row_offset =
+			(u32)((first_block % stripesize) %
+						r5or6_blocks_per_row);
+
+		r5or6_last_row_offset =
+			(u32)((last_block % stripesize) %
+						r5or6_blocks_per_row);
+
+		first_column = r5or6_first_column =
+			r5or6_first_row_offset / map->strip_size;
+		r5or6_last_column =
+			r5or6_last_row_offset / map->strip_size;
+#endif
+		if (r5or6_first_column != r5or6_last_column)
+			return IO_ACCEL_INELIGIBLE;
+
+		/* Request is eligible */
+		map_row = ((u32)(first_row >> map->parity_rotation_shift)) %
+			map->row_cnt;
+
+		map_index = (first_group *
+			(map->row_cnt * total_disks_per_row)) +
+			(map_row * total_disks_per_row) + first_column;
+		break;
+	default:
+		return IO_ACCEL_INELIGIBLE;
 	}
+
 	disk_handle = dd[map_index].ioaccel_handle;
 	disk_block = map->disk_starting_blk + (first_row * map->strip_size) +
 			(first_row_offset - (first_column * map->strip_size));

