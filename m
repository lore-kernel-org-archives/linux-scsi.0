Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C4DCCC433E6
	for <linux-scsi@archiver.kernel.org>; Thu, 11 Mar 2021 20:17:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 898E864F8C
	for <linux-scsi@archiver.kernel.org>; Thu, 11 Mar 2021 20:17:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230425AbhCKUR2 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 11 Mar 2021 15:17:28 -0500
Received: from esa.microchip.iphmx.com ([68.232.153.233]:49199 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230437AbhCKURW (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 11 Mar 2021 15:17:22 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1615493842; x=1647029842;
  h=subject:from:to:cc:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Qpv8j9BCn4w05E8SSLir2jrdRZZVJRJZc2no4Bsqwwc=;
  b=oLCVP++0edDtv1juFFzYgX1lh8ma3Fwe0NznkdXGyUklfswbA4FdJAuF
   3bhX5L9xeltHiRFJITNK+pR1JCdyjh5l6enOcAnJim6HKQKlc4Ykzusws
   IwpPXzpUAVuUfx/x/vma3xPv1FvGS26EZ/LuPBCGsQBQYpRIX9IxYSRuR
   Hm7KlrFcTEbUNv+iDbasrxjWEJaPVnxq3beMUXCD559mD82v6QDjSXYu4
   IszTOZa3KrUeBnMePnzydJQF31wHvyLijjTGRLLkCeQUqP59bEzaKTvJ+
   G2jJT0aUqHWzlSMrJ7UhlssbuGhD7vPrRMJEJp1hWW71GFXVATeWc/QtR
   Q==;
IronPort-SDR: i503+r3rSBhtwA5aINvGoT97+xNJE6ezaM3IZKX3kppnjRAiz6LGX/K+52QhEm3uASm7cxayHW
 nxxpiDqbVSgn0U7L0Br8LT80p4LTKYRwuhJ/sGXiTeF56tnR9Lo8fibr5sYjCTXo0s/v/+lECb
 1IHhRltJbPsJt+/gzn07XhIPjnkkj2zQEvCdLxAJ9InuJx4r5IbMs8kQt+TcJfm1IW08hCq8xG
 XbMTIxBoGPWU+BoYd1Ns4K7AH1NFmroyiWQ+ydRP9E42tbmGV5kzdEbq2+kp33rdPUN2QbvVQx
 gD8=
X-IronPort-AV: E=Sophos;i="5.81,241,1610434800"; 
   d="scan'208";a="118559140"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa1.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 11 Mar 2021 13:17:21 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.85.144) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Thu, 11 Mar 2021 13:17:08 -0700
Received: from [127.0.1.1] (10.10.115.15) by chn-vm-ex02.mchp-main.com
 (10.10.85.144) with Microsoft SMTP Server id 15.1.2176.2 via Frontend
 Transport; Thu, 11 Mar 2021 13:17:07 -0700
Subject: [PATCH V5 23/31] smartpqi: fix driver synchronization issues
From:   Don Brace <don.brace@microchip.com>
To:     <Kevin.Barnett@microchip.com>, <scott.teel@microchip.com>,
        <Justin.Lindley@microchip.com>, <scott.benesh@microchip.com>,
        <gerry.morong@microchip.com>, <mahesh.rajashekhara@microchip.com>,
        <mike.mcgowen@microchip.com>, <murthy.bhat@microchip.com>,
        <hch@infradead.org>, <jejb@linux.vnet.ibm.com>,
        <joseph.szczypek@hpe.com>, <POSWALD@suse.com>
CC:     <linux-scsi@vger.kernel.org>
Date:   Thu, 11 Mar 2021 14:17:07 -0600
Message-ID: <161549382770.25025.789855864026860170.stgit@brunhilda>
In-Reply-To: <161549045434.25025.17473629602756431540.stgit@brunhilda>
References: <161549045434.25025.17473629602756431540.stgit@brunhilda>
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
index 9f6ab2f4144f..8b512f39f9d9 100644
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

