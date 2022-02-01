Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 609E4C433EF
	for <linux-scsi@archiver.kernel.org>; Tue,  1 Feb 2022 21:48:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236463AbiBAVsj (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 1 Feb 2022 16:48:39 -0500
Received: from esa.microchip.iphmx.com ([68.232.153.233]:31008 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236420AbiBAVsj (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 1 Feb 2022 16:48:39 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1643752119; x=1675288119;
  h=subject:from:to:cc:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=DEZbWvlQ/b7VBOwfF76O610SkYzx53clfPETm3e6phs=;
  b=tR7t/N4QvS6ffh8P/++Pl3eDqFrbP4gknHuoBYW5hdnSAi7r/ZD9kelM
   tUstb6AS8yVxrbhGwjzowEaZcd22DTzBQO0TIyGzYfyIcVRZ3G+9jP2qD
   0HFBzn1b1UMvM3lQlQ/oAyg1mdYR/vAFP6XEddzBbLC4s0+pNzzcCk/3m
   prauAo52UCbK2rEW1j//AZPWmhG89XVNqB8ON/xaFzezU0uMhenJiSdkv
   drjtGCylfrHb0VnP7MKM0KL7i7dpr2LMLHNMlLfYCIhnShT+qtgSfCsF8
   x6ZD+j80LYQBXryk0M6T2967eYNOZK0fuLRsAKjqQHBLC1QxpIlbg00xm
   Q==;
IronPort-SDR: kVkdxCXPYTyLpW/SkgnTPB1qpbBL4sV5NWARI+1ru2m1mEFAZFNvF12epl2aIwkplcs+7W7T8V
 KIO3O/oh7BAIoF4VD0nMoNO+PzWTs5IIXeC0vauFKbllXzfb5ZHbBTL8hMYrPeWT54iJ23hUsA
 D8923uGz4QPEDxeLBks33JJe8TsP4tGko29B+MNFidUSMJEnMTAObCLIfoGwrP/Ud9YxPERSk3
 gBgy46rBekdLbHM3KFxCAwAj48agd0lPY3u0vikn8Wmty/y8D9HprJBhvTmgMr7YDvits9EouL
 2+4Jr2teyyeGddqmHQg59B74
X-IronPort-AV: E=Sophos;i="5.88,335,1635231600"; 
   d="scan'208";a="151639093"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa5.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 01 Feb 2022 14:48:38 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.85.144) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Tue, 1 Feb 2022 14:48:38 -0700
Received: from brunhilda.pdev.net (10.10.115.15) by chn-vm-ex02.mchp-main.com
 (10.10.85.144) with Microsoft SMTP Server id 15.1.2375.17 via Frontend
 Transport; Tue, 1 Feb 2022 14:48:38 -0700
Received: from brunhilda.pdev.net (localhost [127.0.0.1])
        by brunhilda.pdev.net (Postfix) with ESMTP id 5AF7270236E;
        Tue,  1 Feb 2022 15:48:38 -0600 (CST)
Subject: [PATCH 10/18] smartpqi: update volume size after expansion
From:   Don Brace <don.brace@microchip.com>
To:     <Kevin.Barnett@microchip.com>, <scott.teel@microchip.com>,
        <Justin.Lindley@microchip.com>, <scott.benesh@microchip.com>,
        <gerry.morong@microchip.com>, <mahesh.rajashekhara@microchip.com>,
        <mike.mcgowen@microchip.com>, <murthy.bhat@microchip.com>,
        <hch@infradead.org>, <jejb@linux.vnet.ibm.com>,
        <joseph.szczypek@hpe.com>, <POSWALD@suse.com>
CC:     <linux-scsi@vger.kernel.org>
Date:   Tue, 1 Feb 2022 15:48:38 -0600
Message-ID: <164375211833.440833.17023155389220583731.stgit@brunhilda.pdev.net>
In-Reply-To: <164375113574.440833.13174600317115819605.stgit@brunhilda.pdev.net>
References: <164375113574.440833.13174600317115819605.stgit@brunhilda.pdev.net>
User-Agent: StGit/1.4.dev36+g39bf3b02665a
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Mahesh Rajashekhara <mahesh.rajashekhara@microchip.com>

Rescan devices after volume expansion.

After modifying logical volume size, lsblk command still shows up
previous size of logical volume.

When driver gets any event from f/w, driver schedules rescan worker
with delay of 10 seconds.

If array expansion is so quick and gets complete in a second,
driver could not catch logical volume expansion due to worker delay.

Since driver does not detect volume expansion, driver would not call
rescan device to update new size to the OS.

Reviewed-by: Kevin Barnett <kevin.barnett@microchip.com>
Reviewed-by: Mike McGowen <mike.mcgowen@microchip.com>
Reviewed-by: Scott Benesh <scott.benesh@microchip.com>
Reviewed-by: Scott Teel <scott.teel@microchip.com>
Signed-off-by: Mahesh Rajashekhara <mahesh.rajashekhara@microchip.com>
Signed-off-by: Don Brace <don.brace@microchip.com>
---
 drivers/scsi/smartpqi/smartpqi.h      |    1 +
 drivers/scsi/smartpqi/smartpqi_init.c |   20 ++++++++++++--------
 2 files changed, 13 insertions(+), 8 deletions(-)

diff --git a/drivers/scsi/smartpqi/smartpqi.h b/drivers/scsi/smartpqi/smartpqi.h
index 81ec5fbf570a..4f6e48854c66 100644
--- a/drivers/scsi/smartpqi/smartpqi.h
+++ b/drivers/scsi/smartpqi/smartpqi.h
@@ -1322,6 +1322,7 @@ struct pqi_ctrl_info {
 	bool		controller_online;
 	bool		block_requests;
 	bool		scan_blocked;
+	u8		logical_volume_rescan_needed : 1;
 	u8		inbound_spanning_supported : 1;
 	u8		outbound_spanning_supported : 1;
 	u8		pqi_mode_enabled : 1;
diff --git a/drivers/scsi/smartpqi/smartpqi_init.c b/drivers/scsi/smartpqi/smartpqi_init.c
index ab12507da436..de53180fab9c 100644
--- a/drivers/scsi/smartpqi/smartpqi_init.c
+++ b/drivers/scsi/smartpqi/smartpqi_init.c
@@ -2015,8 +2015,8 @@ static void pqi_dev_info(struct pqi_ctrl_info *ctrl_info,
 
 /* Assumes the SCSI device list lock is held. */
 
-static void pqi_scsi_update_device(struct pqi_scsi_dev *existing_device,
-	struct pqi_scsi_dev *new_device)
+static void pqi_scsi_update_device(struct pqi_ctrl_info *ctrl_info,
+	struct pqi_scsi_dev *existing_device, struct pqi_scsi_dev *new_device)
 {
 	existing_device->device_type = new_device->device_type;
 	existing_device->bus = new_device->bus;
@@ -2026,9 +2026,8 @@ static void pqi_scsi_update_device(struct pqi_scsi_dev *existing_device,
 		existing_device->target_lun_valid = true;
 	}
 
-	if ((existing_device->volume_status == CISS_LV_QUEUED_FOR_EXPANSION ||
-		existing_device->volume_status == CISS_LV_UNDERGOING_EXPANSION) &&
-		new_device->volume_status == CISS_LV_OK)
+	if (pqi_is_logical_device(existing_device) &&
+		ctrl_info->logical_volume_rescan_needed)
 		existing_device->rescan = true;
 
 	/* By definition, the scsi3addr and wwid fields are already the same. */
@@ -2146,7 +2145,7 @@ static void pqi_update_device_list(struct pqi_ctrl_info *ctrl_info,
 			 */
 			device->new_device = false;
 			matching_device->device_gone = false;
-			pqi_scsi_update_device(matching_device, device);
+			pqi_scsi_update_device(ctrl_info, matching_device, device);
 			break;
 		case DEVICE_NOT_FOUND:
 			/*
@@ -2218,8 +2217,8 @@ static void pqi_update_device_list(struct pqi_ctrl_info *ctrl_info,
 	}
 
 	/*
-	 * Notify the SCSI ML if the queue depth of any existing device has
-	 * changed.
+	 * Notify the SML of any existing device changes such as;
+	 * queue depth, device size.
 	 */
 	list_for_each_entry(device, &ctrl_info->scsi_device_list, scsi_device_list_entry) {
 		if (device->sdev && device->queue_depth != device->advertised_queue_depth) {
@@ -2248,6 +2247,9 @@ static void pqi_update_device_list(struct pqi_ctrl_info *ctrl_info,
 			}
 		}
 	}
+
+	ctrl_info->logical_volume_rescan_needed = false;
+
 }
 
 static inline bool pqi_is_supported_device(struct pqi_scsi_dev *device)
@@ -3703,6 +3705,8 @@ static void pqi_event_worker(struct work_struct *work)
 			} else {
 				ack_event = true;
 				rescan_needed = true;
+				if (event->event_type == PQI_EVENT_TYPE_LOGICAL_DEVICE)
+					ctrl_info->logical_volume_rescan_needed = true;
 			}
 			if (ack_event)
 				pqi_acknowledge_event(ctrl_info, event);


