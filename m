Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F2620C4332B
	for <linux-scsi@archiver.kernel.org>; Wed, 10 Mar 2021 20:03:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BF3A164FBB
	for <linux-scsi@archiver.kernel.org>; Wed, 10 Mar 2021 20:03:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232128AbhCJUC4 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 10 Mar 2021 15:02:56 -0500
Received: from esa.microchip.iphmx.com ([68.232.153.233]:22697 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232659AbhCJUCn (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 10 Mar 2021 15:02:43 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1615406563; x=1646942563;
  h=subject:from:to:cc:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=49zsxU5UkKh6xGHhh7YcNeVAuhisHEwOkeGDKGJGTUo=;
  b=vMK1GoJW1gryHstXWjrP5ciGZPnFaC8i4lEbFlSuAjuQZvTlk2zYU1Tf
   74ow79v+kellATWPt1yVFkJEfM8BbGn5NseV43ngNw8dZOYVrYaJ4kb6O
   Z6kb2NYH8N0aaG73iMHCTM3SM/fX3kE6MZjYnXjK485hhZGlTk9P3lCwi
   spzgULuytr1fGS8KS9jSAjVhmahC+19llRGRae55T56ggFxqgDwsfUdzX
   4qtaHFIwsX5qg86SsNKLh9Twdg5TjFWysuRBAZj/qAzvp8N8XGPwxH3g+
   wEVKN2nhvQoi6hCVHTtA65P0zGuT4r33trm47Rmg37wNNuYLON9rigjki
   w==;
IronPort-SDR: ujJoIKPqhWGEInBkw6fJQRvx5/LiSoaoSOnkX+V4XDg+lz8jl4SizJJQ5yjn/pUQ02/49LCCgP
 2IpKYO+l4hlEdyXIf7h9RVzf4sr8wail5L68S2xJGfknYTvs0iBwput+jwk5SWfg+w4XjtI3Y9
 Css4Zn5HsBB5AV1UVS9Fl0E0p7rOdpHcF52MDIQl9UT5hl/fdKlziqpLHnhxtRAgPzWVWHj2E/
 id+dHPMJjaKr+DUlAoLgI80VExG8htMe6tRvx3MKJ0+oP5UhJjzdfOAzc1XthpxNLT9lTqX0zK
 rjw=
X-IronPort-AV: E=Sophos;i="5.81,238,1610434800"; 
   d="scan'208";a="118389647"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa1.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 10 Mar 2021 13:02:43 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Wed, 10 Mar 2021 13:02:24 -0700
Received: from [127.0.1.1] (10.10.115.15) by chn-vm-ex01.mchp-main.com
 (10.10.85.143) with Microsoft SMTP Server id 15.1.2176.2 via Frontend
 Transport; Wed, 10 Mar 2021 13:02:24 -0700
Subject: [PATCH V4 17/31] smartpqi: update soft reset management for OFA
From:   Don Brace <don.brace@microchip.com>
To:     <Kevin.Barnett@microchip.com>, <scott.teel@microchip.com>,
        <Justin.Lindley@microchip.com>, <scott.benesh@microchip.com>,
        <gerry.morong@microchip.com>, <mahesh.rajashekhara@microchip.com>,
        <mike.mcgowen@microchip.com>, <hch@infradead.org>,
        <jejb@linux.vnet.ibm.com>, <joseph.szczypek@hpe.com>,
        <POSWALD@suse.com>
CC:     <linux-scsi@vger.kernel.org>
Date:   Wed, 10 Mar 2021 14:02:24 -0600
Message-ID: <161540654429.19430.11256683628959450342.stgit@brunhilda>
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
index 2e8c1c09c622..f1f90c21045d 100644
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
 

