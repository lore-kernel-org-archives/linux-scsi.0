Return-Path: <SRS0=SK/U=5F=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 671C5C4332D
	for <linux-scsi@archiver.kernel.org>; Fri, 20 Mar 2020 18:26:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3D2CA20767
	for <linux-scsi@archiver.kernel.org>; Fri, 20 Mar 2020 18:26:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726897AbgCTS0Z (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 20 Mar 2020 14:26:25 -0400
Received: from esa3.microchip.iphmx.com ([68.232.153.233]:23734 "EHLO
        esa3.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726851AbgCTS0Z (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 20 Mar 2020 14:26:25 -0400
IronPort-SDR: y2V49u56GcKqaKxOHwJoZDh62s4BG7wXjf6pOjpjXabTzzyX/mZIp6AJoZJMjFwNs+dDKx4c5y
 liRQhkGeyMJ3e5DSucIqnV45zQHzNYYoNKa1J1LwuKqZxSQQiav74yHCAPtBl4ZfM0bK8YFpjI
 tvMFdZTHxryZRzyaHSV95AGkjF1t4VudXGHT5WJqP8Sv5/JfYEDRKQTcpg0zSWtENdmwJCG7Gz
 u2IqkytsHZPYjyiNlj7lAEeHhc6cJ6pXyoa2DiqQEq7PXkKgRvvl784ae6vPTI0bl3vkbckAAa
 eoo=
X-IronPort-AV: E=Sophos;i="5.72,285,1580799600"; 
   d="scan'208";a="70713479"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa3.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 20 Mar 2020 11:26:23 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Fri, 20 Mar 2020 11:26:25 -0700
Received: from [127.0.1.1] (10.10.115.15) by chn-vm-ex01.mchp-main.com
 (10.10.85.143) with Microsoft SMTP Server id 15.1.1713.5 via Frontend
 Transport; Fri, 20 Mar 2020 11:26:22 -0700
Subject: [PATCH] hpsa: correct race condition in offload enabled
From:   Don Brace <don.brace@microsemi.com>
To:     <Kevin.Barnett@microchip.com>, <scott.teel@microchip.com>,
        <Justin.Lindley@microchip.com>, <scott.benesh@microchip.com>,
        <bader.alisaleh@microchip.com>, <gerry.morong@microchip.com>,
        <mahesh.rajashekhara@microchip.com>, <hch@infradead.org>,
        <jejb@linux.vnet.ibm.com>, <joseph.szczypek@hpe.com>,
        <POSWALD@suse.com>, <shunyong.yang@hxt-semitech.com>
CC:     <linux-scsi@vger.kernel.org>
Date:   Fri, 20 Mar 2020 13:26:18 -0500
Message-ID: <158472877894.14200.7077843399036368335.stgit@brunhilda>
User-Agent: StGit/0.21-58-ga79f
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

- correct race condition where ioaccel is re-enabled before the
  raid_map is updated. For RAID_1, RAID_1ADM, and RAID 5/6 there
  is a BUG_ON called which is bad.
  - change event thread to disable ioaccel only.
    - send all requests down the RAID path instead.
  - Have rescan thread handle offload_enable.
  - Since there is only one rescan allowed at a time, turning
    offload_enabled on/off should not be racy. Each handler
    queues up a rescan if one is already in progress.
  - For timing diagram, offload_enabled is initially off due
    to a change (transformation: splitmirror/remirror), ...

  otbe = offload_to_be_enabled
  oe   = offload_enabled

  Time Event         Rescan              Completion     Request
       Worker        Worker              Thread         Thread
  ---- ------        ------              ----------     -------
   T0   |             |                       + UA      |
   T1   |             + rescan started        | 0x3f    |
   T2   + Event       |                       | 0x0e    |
   T3   + Ack msg     |                       |         |
   T4   |             + if (!dev[i]->oe &&    |         |
   T5   |             |     dev[i]->otbe)     |         |
   T6   |             |      get_raid_map     |         |
   T7   + otbe = 1    |                       |         |
   T8   |             |                       |         |
   T9   |             + oe = otbe             |         |
   T10  |             |                       |         + ioaccel request
   T11                                                  * BUG_ON

  T0 - I/O completion with UA 0x3f 0x0e sets rescan flag.
  T1 - rescan worker thread starts a rescan.
  T2 - event comes in
  T3 - event thread starts and issues "Acknowledge" message
  ...
  T6 - rescan thread has bypassed code to reload new raid map.
  ...
  T7 - event thread runs and sets offload_to_be_enabled
  ...
  T9 - rescan thread turns on offload_enabled.
  T10- request comes in and goes down ioaccel path.
  T11- BUG_ON.


  - After the patch is applied, ioaccel_enabled can only be re-enabled
    in the re-scan thread.

Reviewed-by: Scott Benesh <scott.benesh@microsemi.com>
Reviewed-by: Scott Teel <scott.teel@microsemi.com>
Reviewed-by: Matt Perricone <matt.perricone@microsemi.com>
Signed-off-by: Don Brace <don.brace@microsemi.com>
---
 drivers/scsi/hpsa.c |   80 ++++++++++++++++++++++++++++++++++++---------------
 1 file changed, 57 insertions(+), 23 deletions(-)

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index 1a4ddfacb458..1e9302e99d05 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -504,6 +504,12 @@ static ssize_t host_store_rescan(struct device *dev,
 	return count;
 }
 
+static void hpsa_turn_off_ioaccel_for_device(struct hpsa_scsi_dev_t *device)
+{
+	device->offload_enabled = 0;
+	device->offload_to_be_enabled = 0;
+}
+
 static ssize_t host_show_firmware_revision(struct device *dev,
 	     struct device_attribute *attr, char *buf)
 {
@@ -1738,8 +1744,7 @@ static void hpsa_figure_phys_disk_ptrs(struct ctlr_info *h,
 				__func__,
 				h->scsi_host->host_no, logical_drive->bus,
 				logical_drive->target, logical_drive->lun);
-			logical_drive->offload_enabled = 0;
-			logical_drive->offload_to_be_enabled = 0;
+			hpsa_turn_off_ioaccel_for_device(logical_drive);
 			logical_drive->queue_depth = 8;
 		}
 	}
@@ -2499,8 +2504,7 @@ static void process_ioaccel2_completion(struct ctlr_info *h,
 			IOACCEL2_SERV_RESPONSE_FAILURE) {
 		if (c2->error_data.status ==
 			IOACCEL2_STATUS_SR_IOACCEL_DISABLED) {
-			dev->offload_enabled = 0;
-			dev->offload_to_be_enabled = 0;
+			hpsa_turn_off_ioaccel_for_device(dev);
 		}
 
 		if (dev->in_reset) {
@@ -3670,10 +3674,17 @@ static void hpsa_get_ioaccel_status(struct ctlr_info *h,
 	this_device->offload_config =
 		!!(ioaccel_status & OFFLOAD_CONFIGURED_BIT);
 	if (this_device->offload_config) {
-		this_device->offload_to_be_enabled =
+		bool offload_enabled =
 			!!(ioaccel_status & OFFLOAD_ENABLED_BIT);
-		if (hpsa_get_raid_map(h, scsi3addr, this_device))
-			this_device->offload_to_be_enabled = 0;
+		/*
+		 * Check to see if offload can be enabled.
+		 */
+		if (offload_enabled) {
+			rc = hpsa_get_raid_map(h, scsi3addr, this_device);
+			if (rc) /* could not load raid_map */
+				goto out;
+			this_device->offload_to_be_enabled = 1;
+		}
 	}
 
 out:
@@ -3996,8 +4007,7 @@ static int hpsa_update_device_info(struct ctlr_info *h,
 	} else {
 		this_device->raid_level = RAID_UNKNOWN;
 		this_device->offload_config = 0;
-		this_device->offload_enabled = 0;
-		this_device->offload_to_be_enabled = 0;
+		hpsa_turn_off_ioaccel_for_device(this_device);
 		this_device->hba_ioaccel_enabled = 0;
 		this_device->volume_offline = 0;
 		this_device->queue_depth = h->nr_cmds;
@@ -5230,8 +5240,12 @@ static int hpsa_scsi_ioaccel_raid_map(struct ctlr_info *h,
 		/* Handles load balance across RAID 1 members.
 		 * (2-drive R1 and R10 with even # of drives.)
 		 * Appropriate for SSDs, not optimal for HDDs
+		 * Ensure we have the correct raid_map.
 		 */
-		BUG_ON(le16_to_cpu(map->layout_map_count) != 2);
+		if (le16_to_cpu(map->layout_map_count) != 2) {
+			hpsa_turn_off_ioaccel_for_device(dev);
+			return IO_ACCEL_INELIGIBLE;
+		}
 		if (dev->offload_to_mirror)
 			map_index += le16_to_cpu(map->data_disks_per_row);
 		dev->offload_to_mirror = !dev->offload_to_mirror;
@@ -5239,8 +5253,12 @@ static int hpsa_scsi_ioaccel_raid_map(struct ctlr_info *h,
 	case HPSA_RAID_ADM:
 		/* Handles N-way mirrors  (R1-ADM)
 		 * and R10 with # of drives divisible by 3.)
+		 * Ensure we have the correct raid_map.
 		 */
-		BUG_ON(le16_to_cpu(map->layout_map_count) != 3);
+		if (le16_to_cpu(map->layout_map_count) != 3) {
+			hpsa_turn_off_ioaccel_for_device(dev);
+			return IO_ACCEL_INELIGIBLE;
+		}
 
 		offload_to_mirror = dev->offload_to_mirror;
 		raid_map_helper(map, offload_to_mirror,
@@ -5265,7 +5283,10 @@ static int hpsa_scsi_ioaccel_raid_map(struct ctlr_info *h,
 		r5or6_blocks_per_row =
 			le16_to_cpu(map->strip_size) *
 			le16_to_cpu(map->data_disks_per_row);
-		BUG_ON(r5or6_blocks_per_row == 0);
+		if (r5or6_blocks_per_row == 0) {
+			hpsa_turn_off_ioaccel_for_device(dev);
+			return IO_ACCEL_INELIGIBLE;
+		}
 		stripesize = r5or6_blocks_per_row *
 			le16_to_cpu(map->layout_map_count);
 #if BITS_PER_LONG == 32
@@ -8285,7 +8306,7 @@ static int detect_controller_lockup(struct ctlr_info *h)
  *
  * Called from monitor controller worker (hpsa_event_monitor_worker)
  *
- * A Volume (or Volumes that comprise an Array set may be undergoing a
+ * A Volume (or Volumes that comprise an Array set) may be undergoing a
  * transformation, so we will be turning off ioaccel for all volumes that
  * make up the Array.
  */
@@ -8308,6 +8329,9 @@ static void hpsa_set_ioaccel_status(struct ctlr_info *h)
 	 * Run through current device list used during I/O requests.
 	 */
 	for (i = 0; i < h->ndevices; i++) {
+		int offload_to_be_enabled = 0;
+		int offload_config = 0;
+
 		device = h->dev[i];
 
 		if (!device)
@@ -8325,25 +8349,35 @@ static void hpsa_set_ioaccel_status(struct ctlr_info *h)
 			continue;
 
 		ioaccel_status = buf[IOACCEL_STATUS_BYTE];
-		device->offload_config =
+
+		/*
+		 * Check if offload is still configured on
+		 */
+		offload_config =
 				!!(ioaccel_status & OFFLOAD_CONFIGURED_BIT);
-		if (device->offload_config)
-			device->offload_to_be_enabled =
+		/*
+		 * If offload is configured on, check to see if ioaccel
+		 * needs to be enabled.
+		 */
+		if (offload_config)
+			offload_to_be_enabled =
 				!!(ioaccel_status & OFFLOAD_ENABLED_BIT);
 
+		/*
+		 * If ioaccel is to be re-enabled, re-enable later during the
+		 * scan operation so the driver can get a fresh raidmap
+		 * before turning ioaccel back on.
+		 */
+		if (offload_to_be_enabled)
+			continue;
+
 		/*
 		 * Immediately turn off ioaccel for any volume the
 		 * controller tells us to. Some of the reasons could be:
 		 *    transformation - change to the LVs of an Array.
 		 *    degraded volume - component failure
-		 *
-		 * If ioaccel is to be re-enabled, re-enable later during the
-		 * scan operation so the driver can get a fresh raidmap
-		 * before turning ioaccel back on.
-		 *
 		 */
-		if (!device->offload_to_be_enabled)
-			device->offload_enabled = 0;
+		hpsa_turn_off_ioaccel_for_device(device);
 	}
 
 	kfree(buf);

