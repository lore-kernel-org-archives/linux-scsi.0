Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 95E92C433DB
	for <linux-scsi@archiver.kernel.org>; Wed, 10 Mar 2021 20:03:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7278C64DFD
	for <linux-scsi@archiver.kernel.org>; Wed, 10 Mar 2021 20:03:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231953AbhCJUDb (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 10 Mar 2021 15:03:31 -0500
Received: from esa.microchip.iphmx.com ([68.232.153.233]:26074 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232874AbhCJUDA (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 10 Mar 2021 15:03:00 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1615406580; x=1646942580;
  h=subject:from:to:cc:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=MNZi8FAUYqKnwU8M+Cf+ku2zE3kR2v7egOIjH7/aacw=;
  b=1VNv0U4OJmqh+ea47aHr6BBJ1HamktrIEBgp8ZvlV+jp5ZjR/hSVH1ek
   Mh6VHYU/A5Ut4PAexm6jmwTDxON0HrQv1BaBcToertvl0VpBS0Qm+1cMf
   qbun57wbrIq9PTlqjW+Z+CHjPFBRpzSxUG+iDxnKZ7rI1LccBa7b8+HtK
   xb9LyEZihiWAjpcXys7EPAJXYMe0TRV7jlkQZ4vzWK66dMMhBN7NdYeZq
   2j00Whp/vQMl999mqOMhxLU3Dg2xExFpEIRqwGTiEkakeVqc9pmg7DPwm
   tmNDAHzsR7ZdhRFIIwhiq+uttufSbOPvdeNB8AfG8MaGtGO1vrTCLqH06
   w==;
IronPort-SDR: pcIDQdl9UxG92Q2CdT8xDf9kfKpP9G5r/QnEVUvll/d++uAv89TiKacpF40KxBh9bNrgORwBwG
 8EgAhMMCP5i5vas/NY8RiG3puwW2rB0/8ru6bZxQam1J/wCX+FrFzML+b3R0H+TmjAmAkWgJ42
 RmkYAuZ5jROPAXu6A/UNiBXcpEPHSv8IC2kNF7Obaq8zji16jgjaN30X6vVa4gXY0SJdabsY8k
 aEfv2+e1xW9NuXm3tzoaGjYTaLeu3QepE/Dmd6C3yrpQjIDYqlj5tTtd+VAASMDcBV1bnEOL+H
 nAo=
X-IronPort-AV: E=Sophos;i="5.81,238,1610434800"; 
   d="scan'208";a="112731879"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa3.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 10 Mar 2021 13:03:00 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.87.72) by
 chn-vm-ex02.mchp-main.com (10.10.87.72) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Wed, 10 Mar 2021 13:03:00 -0700
Received: from [127.0.1.1] (10.10.115.15) by chn-vm-ex02.mchp-main.com
 (10.10.85.144) with Microsoft SMTP Server id 15.1.2176.2 via Frontend
 Transport; Wed, 10 Mar 2021 13:02:59 -0700
Subject: [PATCH V4 23/31] smartpqi: fix driver synchronization issues
From:   Don Brace <don.brace@microchip.com>
To:     <Kevin.Barnett@microchip.com>, <scott.teel@microchip.com>,
        <Justin.Lindley@microchip.com>, <scott.benesh@microchip.com>,
        <gerry.morong@microchip.com>, <mahesh.rajashekhara@microchip.com>,
        <mike.mcgowen@microchip.com>, <hch@infradead.org>,
        <jejb@linux.vnet.ibm.com>, <joseph.szczypek@hpe.com>,
        <POSWALD@suse.com>
CC:     <linux-scsi@vger.kernel.org>
Date:   Wed, 10 Mar 2021 14:02:59 -0600
Message-ID: <161540657939.19430.4782360322856578212.stgit@brunhilda>
In-Reply-To: <161540568064.19430.11157730901022265360.stgit@brunhilda>
References: <161540568064.19430.11157730901022265360.stgit@brunhilda>
User-Agent: StGit/0.23-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Kevin Barnett <kevin.barnett@microchip.com>

* Synchronize: OFA, and controller offline events.
  Prevent I/O during the above conditions.
* Cleanup pqi_device_wait_for_pending_io by checking
  the device->scsi_cmds_outstanding instead of walking
  the devices list of commands.
* Stop failing all I/O for all devices. This was causing OS
  to retry them delaying OFA.
* Cleanup cache flush. The controller is checked for offline
  status in lower level functions.

Reviewed-by: Scott Benesh <scott.benesh@microchip.com>
Reviewed-by: Mike McGowen <mike.mcgowen@microchip.com>
Reviewed-by: Scott Teel <scott.teel@microchip.com>
Signed-off-by: Kevin Barnett <kevin.barnett@microchip.com>
Signed-off-by: Don Brace <don.brace@microchip.com>
---
 drivers/scsi/smartpqi/smartpqi_init.c |  106 +--------------------------------
 1 file changed, 3 insertions(+), 103 deletions(-)

diff --git a/drivers/scsi/smartpqi/smartpqi_init.c b/drivers/scsi/smartpqi/smartpqi_init.c
index fe764237f689..94a70e26fae2 100644
--- a/drivers/scsi/smartpqi/smartpqi_init.c
+++ b/drivers/scsi/smartpqi/smartpqi_init.c
@@ -813,13 +813,6 @@ static int pqi_flush_cache(struct pqi_ctrl_info *ctrl_info,
 	int rc;
 	struct bmic_flush_cache *flush_cache;
 
-	/*
-	 * Don't bother trying to flush the cache if the controller is
-	 * locked up.
-	 */
-	if (pqi_ctrl_offline(ctrl_info))
-		return -ENXIO;
-
 	flush_cache = kzalloc(sizeof(*flush_cache), GFP_KERNEL);
 	if (!flush_cache)
 		return -ENOMEM;
@@ -998,9 +991,6 @@ static void pqi_update_time_worker(struct work_struct *work)
 	ctrl_info = container_of(to_delayed_work(work), struct pqi_ctrl_info,
 		update_time_work);
 
-	if (pqi_ctrl_offline(ctrl_info))
-		return;
-
 	rc = pqi_write_current_time_to_host_wellness(ctrl_info);
 	if (rc)
 		dev_warn(&ctrl_info->pci_dev->dev,
@@ -5725,7 +5715,6 @@ static int pqi_scsi_queue_command(struct Scsi_Host *shost, struct scsi_cmnd *scm
 	}
 
 out:
-	pqi_ctrl_unbusy(ctrl_info);
 	if (rc)
 		atomic_dec(&device->scsi_cmds_outstanding);
 
@@ -5837,102 +5826,22 @@ static void pqi_fail_io_queued_for_device(struct pqi_ctrl_info *ctrl_info,
 	}
 }
 
-static void pqi_fail_io_queued_for_all_devices(struct pqi_ctrl_info *ctrl_info)
-{
-	unsigned int i;
-	unsigned int path;
-	struct pqi_queue_group *queue_group;
-	unsigned long flags;
-	struct pqi_io_request *io_request;
-	struct pqi_io_request *next;
-	struct scsi_cmnd *scmd;
-
-	for (i = 0; i < ctrl_info->num_queue_groups; i++) {
-		queue_group = &ctrl_info->queue_groups[i];
-
-		for (path = 0; path < 2; path++) {
-			spin_lock_irqsave(&queue_group->submit_lock[path],
-						flags);
-
-			list_for_each_entry_safe(io_request, next,
-				&queue_group->request_list[path],
-				request_list_entry) {
-
-				scmd = io_request->scmd;
-				if (!scmd)
-					continue;
-
-				list_del(&io_request->request_list_entry);
-				set_host_byte(scmd, DID_RESET);
-				pqi_free_io_request(io_request);
-				scsi_dma_unmap(scmd);
-				pqi_scsi_done(scmd);
-			}
-
-			spin_unlock_irqrestore(
-				&queue_group->submit_lock[path], flags);
-		}
-	}
-}
-
 static int pqi_device_wait_for_pending_io(struct pqi_ctrl_info *ctrl_info,
 	struct pqi_scsi_dev *device, unsigned long timeout_secs)
 {
 	unsigned long timeout;
 
-	timeout = (timeout_secs * PQI_HZ) + jiffies;
-
-	while (atomic_read(&device->scsi_cmds_outstanding)) {
-		pqi_check_ctrl_health(ctrl_info);
-		if (pqi_ctrl_offline(ctrl_info))
-			return -ENXIO;
-		if (timeout_secs != NO_TIMEOUT) {
-			if (time_after(jiffies, timeout)) {
-				dev_err(&ctrl_info->pci_dev->dev,
-					"timed out waiting for pending IO\n");
-				return -ETIMEDOUT;
-			}
-		}
-		usleep_range(1000, 2000);
-	}
-
-	return 0;
-}
-
-static int pqi_ctrl_wait_for_pending_io(struct pqi_ctrl_info *ctrl_info,
-	unsigned long timeout_secs)
-{
-	bool io_pending;
-	unsigned long flags;
-	unsigned long timeout;
-	struct pqi_scsi_dev *device;
 
 	timeout = (timeout_secs * PQI_HZ) + jiffies;
-	while (1) {
-		io_pending = false;
-
-		spin_lock_irqsave(&ctrl_info->scsi_device_list_lock, flags);
-		list_for_each_entry(device, &ctrl_info->scsi_device_list,
-			scsi_device_list_entry) {
-			if (atomic_read(&device->scsi_cmds_outstanding)) {
-				io_pending = true;
-				break;
-			}
-		}
-		spin_unlock_irqrestore(&ctrl_info->scsi_device_list_lock,
-					flags);
-
-		if (!io_pending)
-			break;
 
+	while (atomic_read(&device->scsi_cmds_outstanding)) {
 		pqi_check_ctrl_health(ctrl_info);
 		if (pqi_ctrl_offline(ctrl_info))
 			return -ENXIO;
-
 		if (timeout_secs != NO_TIMEOUT) {
 			if (time_after(jiffies, timeout)) {
 				dev_err(&ctrl_info->pci_dev->dev,
-					"timed out waiting for pending IO\n");
+					"timed out waiting for pending I/O\n");
 				return -ETIMEDOUT;
 			}
 		}
@@ -6013,8 +5922,6 @@ static int pqi_lun_reset(struct pqi_ctrl_info *ctrl_info,
 	return rc;
 }
 
-/* Performs a reset at the LUN level. */
-
 #define PQI_LUN_RESET_RETRIES			3
 #define PQI_LUN_RESET_RETRY_INTERVAL_MSECS	10000
 #define PQI_LUN_RESET_PENDING_IO_TIMEOUT_SECS	120
@@ -7659,8 +7566,6 @@ static int pqi_force_sis_mode(struct pqi_ctrl_info *ctrl_info)
 	return pqi_revert_to_sis_mode(ctrl_info);
 }
 
-#define PQI_POST_RESET_DELAY_B4_MSGU_READY	5000
-
 static int pqi_ctrl_init(struct pqi_ctrl_info *ctrl_info)
 {
 	int rc;
@@ -7668,7 +7573,7 @@ static int pqi_ctrl_init(struct pqi_ctrl_info *ctrl_info)
 
 	if (reset_devices) {
 		sis_soft_reset(ctrl_info);
-		msleep(PQI_POST_RESET_DELAY_B4_MSGU_READY);
+		msleep(PQI_POST_RESET_DELAY_SECS * PQI_HZ);
 	} else {
 		rc = pqi_force_sis_mode(ctrl_info);
 		if (rc)
@@ -8222,12 +8127,7 @@ static void pqi_ofa_ctrl_quiesce(struct pqi_ctrl_info *ctrl_info)
 	pqi_ctrl_block_device_reset(ctrl_info);
 	pqi_ctrl_block_requests(ctrl_info);
 	pqi_ctrl_wait_until_quiesced(ctrl_info);
-	pqi_ctrl_wait_for_pending_io(ctrl_info, PQI_PENDING_IO_TIMEOUT_SECS);
-	pqi_fail_io_queued_for_all_devices(ctrl_info);
-	pqi_wait_until_inbound_queues_empty(ctrl_info);
 	pqi_stop_heartbeat_timer(ctrl_info);
-	ctrl_info->pqi_mode_enabled = false;
-	pqi_save_ctrl_mode(ctrl_info, SIS_MODE);
 }
 
 static void pqi_ofa_ctrl_unquiesce(struct pqi_ctrl_info *ctrl_info)

