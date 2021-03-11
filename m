Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 62463C433E6
	for <linux-scsi@archiver.kernel.org>; Thu, 11 Mar 2021 20:17:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1639F64F87
	for <linux-scsi@archiver.kernel.org>; Thu, 11 Mar 2021 20:17:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230341AbhCKUQz (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 11 Mar 2021 15:16:55 -0500
Received: from esa.microchip.iphmx.com ([68.232.154.123]:58866 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230388AbhCKUQd (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 11 Mar 2021 15:16:33 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1615493793; x=1647029793;
  h=subject:from:to:cc:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=sdZ/YBUTUYwmxY8dR+qHhy72j26k8gqIVjEMWWhBn6E=;
  b=hyuacAJrwbNDjEpimb91eamDxY2Kd4tGiAT7eSmY+ZRArb7hhh6HWz3G
   rah0mddxUg7lKrengkwUKCe3vPstNV1xjpPqHyGZQ47p7NC1tGgznGefA
   pFUfyIWgQiLYS6wLt79P+1PhIFl0JB6tJIblcdKdXxx0zTZfs0xpO37mB
   6J55O5uhNETwpwyA6Me/astgUJAq9cumfDrmZwx1+DQMATz1bfhPMMGcH
   nHoeofLMcvWQw9txJPxLDy83kmQmwuZ7Ll/ibKMS6Iy1KqzYrYTnHvXiK
   eFa8sc8hVWm7IdlRfrUk5DANpNWGk2zG3BLbWZqUiblUZ4T3RtzihCLxt
   w==;
IronPort-SDR: DI5hNg+DytBUNXICpd2Zp/DsjYtyJckMpABZZTEQkba9rACDk2f4FoRQhdweYB957yGWQw3vHJ
 MXGbpj44re/Eq7zbBrSr2a2++plTACDmuCNrj2+2bMhTaLNPzpqGETzusjH0PH3fAZ2Twv9/9X
 MyGlhuxKzZz96me1PB8r0iO37aZYPZO3xub+k73tRV33yE1zxA+uQHn3o/cMWdRDbiMtgOFLf4
 sTuIjFwsuURcRQ06L17fjLbdfhI3X86wXqRQo6f/uC8kSgmXXl3BVw7T8Ik4x6LLIO31soXfpx
 +/M=
X-IronPort-AV: E=Sophos;i="5.81,241,1610434800"; 
   d="scan'208";a="109660146"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa2.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 11 Mar 2021 13:16:33 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Thu, 11 Mar 2021 13:16:32 -0700
Received: from [127.0.1.1] (10.10.115.15) by chn-vm-ex04.mchp-main.com
 (10.10.85.152) with Microsoft SMTP Server id 15.1.2176.2 via Frontend
 Transport; Thu, 11 Mar 2021 13:16:32 -0700
Subject: [PATCH V5 17/31] smartpqi: update soft reset management for OFA
From:   Don Brace <don.brace@microchip.com>
To:     <Kevin.Barnett@microchip.com>, <scott.teel@microchip.com>,
        <Justin.Lindley@microchip.com>, <scott.benesh@microchip.com>,
        <gerry.morong@microchip.com>, <mahesh.rajashekhara@microchip.com>,
        <mike.mcgowen@microchip.com>, <murthy.bhat@microchip.com>,
        <hch@infradead.org>, <jejb@linux.vnet.ibm.com>,
        <joseph.szczypek@hpe.com>, <POSWALD@suse.com>
CC:     <linux-scsi@vger.kernel.org>
Date:   Thu, 11 Mar 2021 14:16:32 -0600
Message-ID: <161549379215.25025.10654441314249183621.stgit@brunhilda>
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

Cleanup soft reset code for Online Firmware Activation (OFA)
   OFA allows controller FW updates without a reboot.

 * OFA updates require an on-line controller reset to activate
   the updated firmware. There were some missing actions for
   some of the reset cases. The controller is first set back to
   sis mode before returning to pqi mode. Check to ensure the
   controller is in sis mode.
   Some other cleanups:
   * Release QRM memory (OFA buffer) on OFA error conditions.
   * Cleanup controller state which can cause a kernel panic
     upon reboot after an unsuccessful OFA.

Reviewed-by: Scott Benesh <scott.benesh@microchip.com>
Reviewed-by: Mike McGowen <mike.mcgowen@microchip.com>
Reviewed-by: Scott Teel <scott.teel@microchip.com>
Signed-off-by: Kevin Barnett <kevin.barnett@microchip.com>
Signed-off-by: Don Brace <don.brace@microchip.com>
---
 drivers/scsi/smartpqi/smartpqi_init.c |   86 ++++++++++++++++++++-------------
 1 file changed, 53 insertions(+), 33 deletions(-)

diff --git a/drivers/scsi/smartpqi/smartpqi_init.c b/drivers/scsi/smartpqi/smartpqi_init.c
index 4c0962879029..41aa401e58eb 100644
--- a/drivers/scsi/smartpqi/smartpqi_init.c
+++ b/drivers/scsi/smartpqi/smartpqi_init.c
@@ -390,21 +390,15 @@ static inline u32 pqi_read_heartbeat_counter(struct pqi_ctrl_info *ctrl_info)
 
 static inline u8 pqi_read_soft_reset_status(struct pqi_ctrl_info *ctrl_info)
 {
-	if (!ctrl_info->soft_reset_status)
-		return 0;
-
 	return readb(ctrl_info->soft_reset_status);
 }
 
-static inline void pqi_clear_soft_reset_status(struct pqi_ctrl_info *ctrl_info, u8 clear)
+static inline void pqi_clear_soft_reset_status(struct pqi_ctrl_info *ctrl_info)
 {
 	u8 status;
 
-	if (!ctrl_info->soft_reset_status)
-		return;
-
 	status = pqi_read_soft_reset_status(ctrl_info);
-	status &= ~clear;
+	status &= ~PQI_SOFT_RESET_ABORT;
 	writeb(status, ctrl_info->soft_reset_status);
 }
 
@@ -3272,46 +3266,65 @@ static enum pqi_soft_reset_status pqi_poll_for_soft_reset_status(
 		if (status & PQI_SOFT_RESET_ABORT)
 			return RESET_ABORT;
 
+		if (!sis_is_firmware_running(ctrl_info))
+			return RESET_NORESPONSE;
+
 		if (time_after(jiffies, timeout)) {
-			dev_err(&ctrl_info->pci_dev->dev,
+			dev_warn(&ctrl_info->pci_dev->dev,
 				"timed out waiting for soft reset status\n");
 			return RESET_TIMEDOUT;
 		}
 
-		if (!sis_is_firmware_running(ctrl_info))
-			return RESET_NORESPONSE;
-
 		ssleep(PQI_SOFT_RESET_STATUS_POLL_INTERVAL_SECS);
 	}
 }
 
-static void pqi_process_soft_reset(struct pqi_ctrl_info *ctrl_info,
-	enum pqi_soft_reset_status reset_status)
+static void pqi_process_soft_reset(struct pqi_ctrl_info *ctrl_info)
 {
 	int rc;
+	enum pqi_soft_reset_status reset_status;
+
+	if (ctrl_info->soft_reset_handshake_supported)
+		reset_status = pqi_poll_for_soft_reset_status(ctrl_info);
+	else
+		reset_status = RESET_INITIATE_FIRMWARE;
 
 	switch (reset_status) {
-	case RESET_INITIATE_DRIVER:
 	case RESET_TIMEDOUT:
+		fallthrough;
+	case RESET_INITIATE_DRIVER:
 		dev_info(&ctrl_info->pci_dev->dev,
-			"resetting controller %u\n", ctrl_info->ctrl_id);
+				"Online Firmware Activation: resetting controller\n");
 		sis_soft_reset(ctrl_info);
 		fallthrough;
 	case RESET_INITIATE_FIRMWARE:
+		ctrl_info->pqi_mode_enabled = false;
+		pqi_save_ctrl_mode(ctrl_info, SIS_MODE);
 		rc = pqi_ofa_ctrl_restart(ctrl_info);
 		pqi_ofa_free_host_buffer(ctrl_info);
+		pqi_ctrl_ofa_done(ctrl_info);
 		dev_info(&ctrl_info->pci_dev->dev,
-			"Online Firmware Activation for controller %u: %s\n",
-			ctrl_info->ctrl_id, rc == 0 ? "SUCCESS" : "FAILED");
+				"Online Firmware Activation: %s\n",
+				rc == 0 ? "SUCCESS" : "FAILED");
 		break;
 	case RESET_ABORT:
-		pqi_ofa_ctrl_unquiesce(ctrl_info);
 		dev_info(&ctrl_info->pci_dev->dev,
-			"Online Firmware Activation for controller %u: %s\n",
-			ctrl_info->ctrl_id, "ABORTED");
+				"Online Firmware Activation ABORTED\n");
+		if (ctrl_info->soft_reset_handshake_supported)
+			pqi_clear_soft_reset_status(ctrl_info);
+		pqi_ofa_free_host_buffer(ctrl_info);
+		pqi_ctrl_ofa_done(ctrl_info);
+		pqi_ofa_ctrl_unquiesce(ctrl_info);
 		break;
 	case RESET_NORESPONSE:
+		fallthrough;
+	default:
+		dev_err(&ctrl_info->pci_dev->dev,
+			"unexpected Online Firmware Activation reset status: 0x%x\n",
+			reset_status);
 		pqi_ofa_free_host_buffer(ctrl_info);
+		pqi_ctrl_ofa_done(ctrl_info);
+		pqi_ofa_ctrl_unquiesce(ctrl_info);
 		pqi_take_ctrl_offline(ctrl_info);
 		break;
 	}
@@ -3321,7 +3334,6 @@ static void pqi_ofa_process_event(struct pqi_ctrl_info *ctrl_info,
 	struct pqi_event *event)
 {
 	u16 event_id;
-	enum pqi_soft_reset_status status;
 
 	event_id = get_unaligned_le16(&event->event_id);
 
@@ -3333,14 +3345,7 @@ static void pqi_ofa_process_event(struct pqi_ctrl_info *ctrl_info,
 			ctrl_info->ctrl_id);
 		pqi_ofa_ctrl_quiesce(ctrl_info);
 		pqi_acknowledge_event(ctrl_info, event);
-		if (ctrl_info->soft_reset_handshake_supported) {
-			status = pqi_poll_for_soft_reset_status(ctrl_info);
-			pqi_process_soft_reset(ctrl_info, status);
-		} else {
-			pqi_process_soft_reset(ctrl_info,
-					RESET_INITIATE_FIRMWARE);
-		}
-
+		pqi_process_soft_reset(ctrl_info);
 	} else if (event_id == PQI_EVENT_OFA_MEMORY_ALLOCATION) {
 		pqi_acknowledge_event(ctrl_info, event);
 		pqi_ofa_setup_host_buffer(ctrl_info,
@@ -7413,7 +7418,8 @@ static void pqi_ctrl_update_feature_flags(struct pqi_ctrl_info *ctrl_info,
 		break;
 	case PQI_FIRMWARE_FEATURE_SOFT_RESET_HANDSHAKE:
 		ctrl_info->soft_reset_handshake_supported =
-			firmware_feature->enabled;
+			firmware_feature->enabled &&
+			pqi_read_soft_reset_status(ctrl_info);
 		break;
 	case PQI_FIRMWARE_FEATURE_RAID_IU_TIMEOUT:
 		ctrl_info->raid_iu_timeout_supported = firmware_feature->enabled;
@@ -7609,6 +7615,19 @@ static void pqi_process_firmware_features_section(
  * of the PQI Configuration Table.
  */
 
+static void pqi_ctrl_reset_config(struct pqi_ctrl_info *ctrl_info)
+{
+	ctrl_info->heartbeat_counter = NULL;
+	ctrl_info->soft_reset_status = NULL;
+	ctrl_info->soft_reset_handshake_supported = false;
+	ctrl_info->enable_r1_writes = false;
+	ctrl_info->enable_r5_writes = false;
+	ctrl_info->enable_r6_writes = false;
+	ctrl_info->raid_iu_timeout_supported = false;
+	ctrl_info->tmf_iu_timeout_supported = false;
+	ctrl_info->unique_wwid_in_report_phys_lun_supported = false;
+}
+
 static int pqi_process_config_table(struct pqi_ctrl_info *ctrl_info)
 {
 	u32 table_length;
@@ -8051,6 +8070,8 @@ static int pqi_ctrl_init_resume(struct pqi_ctrl_info *ctrl_info)
 	ctrl_info->controller_online = true;
 	pqi_ctrl_unblock_requests(ctrl_info);
 
+	pqi_ctrl_reset_config(ctrl_info);
+
 	rc = pqi_process_config_table(ctrl_info);
 	if (rc)
 		return rc;
@@ -8314,8 +8335,7 @@ static void pqi_ofa_ctrl_unquiesce(struct pqi_ctrl_info *ctrl_info)
 	pqi_ctrl_unblock_requests(ctrl_info);
 	pqi_start_heartbeat_timer(ctrl_info);
 	pqi_schedule_update_time_worker(ctrl_info);
-	pqi_clear_soft_reset_status(ctrl_info,
-		PQI_SOFT_RESET_ABORT);
+	pqi_clear_soft_reset_status(ctrl_info);
 	pqi_scan_scsi_devices(ctrl_info);
 }
 

