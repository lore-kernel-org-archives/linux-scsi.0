Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2F7E5C433F5
	for <linux-scsi@archiver.kernel.org>; Tue, 28 Sep 2021 23:54:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1718460C41
	for <linux-scsi@archiver.kernel.org>; Tue, 28 Sep 2021 23:54:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243361AbhI1X42 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 28 Sep 2021 19:56:28 -0400
Received: from esa.microchip.iphmx.com ([68.232.153.233]:42065 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242094AbhI1X4X (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 28 Sep 2021 19:56:23 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1632873283; x=1664409283;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=iF/4kuXzDkAVd+mWksaBB0pGLBAirFLXL2EWFVqRT4Q=;
  b=vZrfoOyKDqtGwp+4c6QvJNdgTwwbk+o6Bzf4zxer+wn/49FwMjt0eoQf
   54EVv9vYSpXDPsTdKtgV2MgKexuAvy150RhWcbE3m6aZyEw/MoBNK6SZh
   V2Df7zhmnbsxJGuYXPmAteekHdThKYOnRCdXn9N3aoK4Taxl910n3iOxH
   mO2gfTsFICAzwdI/4NeVNDG0LG9UAGlxAL7ce1kS53/aTlgHV9tVYUteL
   w2k3LBRnDqSaylKmrIpTGX5dUkGQBzmEynGRZdxeARMpb9vTRg8R0FVXs
   CenhDedqDUtfyYpG2jRHgUkgX2gvDeIEq8fs051jzm9kofYQxhQZryC6x
   A==;
IronPort-SDR: wg5R2EDbIiXfarGzsYlVYj4xaceK2eVRiyWmxFmXwPOnUPnPQod9DpklenoCH2JeNo2+uHWaCP
 FxQVo2SVxmH2tthhfR9jBeV7b6q4gttAXwJaVWy5EtF1UycrvwMVFFCUhU0Gu07uDP0icMj4fM
 AwiUi68zD8ARxd0kEa4mBJPmOGSxdDqiOVtVvEjQOYOgUQQNMcZHAph0CqM4Jmnk/T1ae+jjIH
 KemH5t8xmDg3FseOug56qqQAa6tU9oqfumaafuZG71KC6mlZ2og6r+OzwDYmnr3zmhBVKiPzeD
 VUwsuQ1NJNNQNbzHzFWi24Np
X-IronPort-AV: E=Sophos;i="5.85,330,1624345200"; 
   d="scan'208";a="146019803"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa1.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 28 Sep 2021 16:54:42 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.14; Tue, 28 Sep 2021 16:54:42 -0700
Received: from brunhilda.pdev.net (10.10.115.15) by chn-vm-ex01.mchp-main.com
 (10.10.85.143) with Microsoft SMTP Server id 15.1.2176.14 via Frontend
 Transport; Tue, 28 Sep 2021 16:54:42 -0700
Received: by brunhilda.pdev.net (Postfix, from userid 1467)
        id 63F51702853; Tue, 28 Sep 2021 18:54:42 -0500 (CDT)
From:   Don Brace <don.brace@microchip.com>
To:     <hch@infradead.org>, <martin.petersen@oracle.com>,
        <jejb@linux.vnet.ibm.com>, <linux-scsi@vger.kernel.org>
CC:     <Kevin.Barnett@microchip.com>, <scott.teel@microchip.com>,
        <Justin.Lindley@microchip.com>, <scott.benesh@microchip.com>,
        <gerry.morong@microchip.com>, <mahesh.rajashekhara@microchip.com>,
        <mike.mcgowen@microchip.com>, <murthy.bhat@microchip.com>,
        <balsundar.p@microchip.com>, <joseph.szczypek@hpe.com>,
        <jeff@canonical.com>, <POSWALD@suse.com>,
        <john.p.donnelly@oracle.com>, <mwilck@suse.com>,
        <pmenzel@molgen.mpg.de>, <linux-kernel@vger.kernel.org>
Subject: [smartpqi updates PATCH V2 02/11] smartpqi: add controller handshake during kdump
Date:   Tue, 28 Sep 2021 18:54:33 -0500
Message-ID: <20210928235442.201875-3-don.brace@microchip.com>
X-Mailer: git-send-email 2.28.0.rc1.9.ge7ae437ac1
In-Reply-To: <20210928235442.201875-1-don.brace@microchip.com>
References: <20210928235442.201875-1-don.brace@microchip.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Mahesh Rajashekhara <mahesh.rajashekhara@microchip.com>

Correct kdump hangs when controller is locked up.

There are occasions when a controller reboot
(controller soft reset) is issued when a controller
firmware crash dump is in progress.

This leads to incomplete controller firmware crash dump.
 - When the controller crash dump is in progress,
   and a kdump is initiated, the driver issues
   inbound doorbell reset to bring back the
   controller in SIS mode.
 - If the controller is in locked up state,
   the inbound doorbell reset does not work causing
   controller initialization failures. This results
   in the driver hanging waiting for SIS mode.

To avoid an incomplete controller crash dump, add in
a controller crash dump handshake.
 - Controller will indicate start and end of the controller
   crash dump by setting some register bits.
 - Driver will look these bits when a kdump is initiated.
   If a controller crash dump is in progress, the driver will
   wait for the controller crash dump to complete
   before issuing the controller soft reset then complete
   driver initialization.

Reviewed-by: Scott Benesh <scott.benesh@microchip.com>
Reviewed-by: Scott Teel <scott.teel@microchip.com>
Reviewed-by: Mike McGowen <mike.mcgowen@microchip.com>
Signed-off-by: Mahesh Rajashekhara <mahesh.rajashekhara@microchip.com>
Signed-off-by: Don Brace <don.brace@microchip.com>
---
 drivers/scsi/smartpqi/smartpqi_init.c | 41 +++++++++++++++++++--
 drivers/scsi/smartpqi/smartpqi_sis.c  | 51 +++++++++++++++++++++++++++
 drivers/scsi/smartpqi/smartpqi_sis.h  |  1 +
 3 files changed, 91 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/smartpqi/smartpqi_init.c b/drivers/scsi/smartpqi/smartpqi_init.c
index 97027574eb1f..5655d240f7a7 100644
--- a/drivers/scsi/smartpqi/smartpqi_init.c
+++ b/drivers/scsi/smartpqi/smartpqi_init.c
@@ -234,15 +234,46 @@ static inline bool pqi_is_hba_lunid(u8 *scsi3addr)
 	return pqi_scsi3addr_equal(scsi3addr, RAID_CTLR_LUNID);
 }
 
+#define PQI_DRIVER_SCRATCH_PQI_MODE			0x1
+#define PQI_DRIVER_SCRATCH_FW_TRIAGE_SUPPORTED		0x2
+
 static inline enum pqi_ctrl_mode pqi_get_ctrl_mode(struct pqi_ctrl_info *ctrl_info)
 {
-	return sis_read_driver_scratch(ctrl_info);
+	return sis_read_driver_scratch(ctrl_info) & PQI_DRIVER_SCRATCH_PQI_MODE ? PQI_MODE : SIS_MODE;
 }
 
 static inline void pqi_save_ctrl_mode(struct pqi_ctrl_info *ctrl_info,
 	enum pqi_ctrl_mode mode)
 {
-	sis_write_driver_scratch(ctrl_info, mode);
+	u32 driver_scratch;
+
+	driver_scratch = sis_read_driver_scratch(ctrl_info);
+
+	if (mode == PQI_MODE)
+		driver_scratch |= PQI_DRIVER_SCRATCH_PQI_MODE;
+	else
+		driver_scratch &= ~PQI_DRIVER_SCRATCH_PQI_MODE;
+
+	sis_write_driver_scratch(ctrl_info, driver_scratch);
+}
+
+static inline bool pqi_is_fw_triage_supported(struct pqi_ctrl_info *ctrl_info)
+{
+	return (sis_read_driver_scratch(ctrl_info) & PQI_DRIVER_SCRATCH_FW_TRIAGE_SUPPORTED) != 0;
+}
+
+static inline void pqi_save_fw_triage_setting(struct pqi_ctrl_info *ctrl_info, bool is_supported)
+{
+	u32 driver_scratch;
+
+	driver_scratch = sis_read_driver_scratch(ctrl_info);
+
+	if (is_supported)
+		driver_scratch |= PQI_DRIVER_SCRATCH_FW_TRIAGE_SUPPORTED;
+	else
+		driver_scratch &= ~PQI_DRIVER_SCRATCH_FW_TRIAGE_SUPPORTED;
+
+	sis_write_driver_scratch(ctrl_info, driver_scratch);
 }
 
 static inline void pqi_ctrl_block_scan(struct pqi_ctrl_info *ctrl_info)
@@ -7292,6 +7323,7 @@ static void pqi_ctrl_update_feature_flags(struct pqi_ctrl_info *ctrl_info,
 		ctrl_info->unique_wwid_in_report_phys_lun_supported =
 			firmware_feature->enabled;
 		break;
+		pqi_save_fw_triage_setting(ctrl_info, firmware_feature->enabled);
 	}
 
 	pqi_firmware_feature_status(ctrl_info, firmware_feature);
@@ -7618,6 +7650,11 @@ static int pqi_ctrl_init(struct pqi_ctrl_info *ctrl_info)
 	u32 product_id;
 
 	if (reset_devices) {
+		if (pqi_is_fw_triage_supported(ctrl_info)) {
+			rc = sis_wait_for_fw_triage_completion(ctrl_info);
+			if (rc)
+				return rc;
+		}
 		sis_soft_reset(ctrl_info);
 		msleep(PQI_POST_RESET_DELAY_SECS * PQI_HZ);
 	} else {
diff --git a/drivers/scsi/smartpqi/smartpqi_sis.c b/drivers/scsi/smartpqi/smartpqi_sis.c
index d63c46a8e38b..8acd3a80f582 100644
--- a/drivers/scsi/smartpqi/smartpqi_sis.c
+++ b/drivers/scsi/smartpqi/smartpqi_sis.c
@@ -51,12 +51,20 @@
 #define SIS_BASE_STRUCT_REVISION		9
 #define SIS_BASE_STRUCT_ALIGNMENT		16
 
+#define SIS_CTRL_KERNEL_FW_TRIAGE		0x3
 #define SIS_CTRL_KERNEL_UP			0x80
 #define SIS_CTRL_KERNEL_PANIC			0x100
 #define SIS_CTRL_READY_TIMEOUT_SECS		180
 #define SIS_CTRL_READY_RESUME_TIMEOUT_SECS	90
 #define SIS_CTRL_READY_POLL_INTERVAL_MSECS	10
 
+enum sis_fw_triage_status {
+	FW_TRIAGE_NOT_STARTED = 0,
+	FW_TRIAGE_STARTED,
+	FW_TRIAGE_COND_INVALID,
+	FW_TRIAGE_COMPLETED
+};
+
 #pragma pack(1)
 
 /* for use with SIS_CMD_INIT_BASE_STRUCT_ADDRESS command */
@@ -419,12 +427,55 @@ u32 sis_read_driver_scratch(struct pqi_ctrl_info *ctrl_info)
 	return readl(&ctrl_info->registers->sis_driver_scratch);
 }
 
+static inline enum sis_fw_triage_status
+	sis_read_firmware_triage_status(struct pqi_ctrl_info *ctrl_info)
+{
+	return ((enum sis_fw_triage_status)(readl(&ctrl_info->registers->sis_firmware_status) &
+		SIS_CTRL_KERNEL_FW_TRIAGE));
+}
+
 void sis_soft_reset(struct pqi_ctrl_info *ctrl_info)
 {
 	writel(SIS_SOFT_RESET,
 		&ctrl_info->registers->sis_host_to_ctrl_doorbell);
 }
 
+#define SIS_FW_TRIAGE_STATUS_TIMEOUT_SECS		300
+#define SIS_FW_TRIAGE_STATUS_POLL_INTERVAL_SECS		1
+
+int sis_wait_for_fw_triage_completion(struct pqi_ctrl_info *ctrl_info)
+{
+	int rc;
+	enum sis_fw_triage_status status;
+	unsigned long timeout;
+
+	timeout = (SIS_FW_TRIAGE_STATUS_TIMEOUT_SECS * PQI_HZ) + jiffies;
+	while (1) {
+		status = sis_read_firmware_triage_status(ctrl_info);
+		if (status == FW_TRIAGE_COND_INVALID) {
+			dev_err(&ctrl_info->pci_dev->dev,
+				"firmware triage condition invalid\n");
+			rc = -EINVAL;
+			break;
+		} else if (status == FW_TRIAGE_NOT_STARTED ||
+			status == FW_TRIAGE_COMPLETED) {
+			rc = 0;
+			break;
+		}
+
+		if (time_after(jiffies, timeout)) {
+			dev_err(&ctrl_info->pci_dev->dev,
+				"timed out waiting for firmware triage status\n");
+			rc = -ETIMEDOUT;
+			break;
+		}
+
+		ssleep(SIS_FW_TRIAGE_STATUS_POLL_INTERVAL_SECS);
+	}
+
+	return rc;
+}
+
 static void __attribute__((unused)) verify_structures(void)
 {
 	BUILD_BUG_ON(offsetof(struct sis_base_struct,
diff --git a/drivers/scsi/smartpqi/smartpqi_sis.h b/drivers/scsi/smartpqi/smartpqi_sis.h
index d29c1352a826..c1db93054c86 100644
--- a/drivers/scsi/smartpqi/smartpqi_sis.h
+++ b/drivers/scsi/smartpqi/smartpqi_sis.h
@@ -28,5 +28,6 @@ void sis_write_driver_scratch(struct pqi_ctrl_info *ctrl_info, u32 value);
 u32 sis_read_driver_scratch(struct pqi_ctrl_info *ctrl_info);
 void sis_soft_reset(struct pqi_ctrl_info *ctrl_info);
 u32 sis_get_product_id(struct pqi_ctrl_info *ctrl_info);
+int sis_wait_for_fw_triage_completion(struct pqi_ctrl_info *ctrl_info);
 
 #endif	/* _SMARTPQI_SIS_H */
-- 
2.28.0.rc1.9.ge7ae437ac1

