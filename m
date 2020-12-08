Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.5 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AEBD9C19437
	for <linux-scsi@archiver.kernel.org>; Tue,  8 Dec 2020 20:16:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7D24023AA8
	for <linux-scsi@archiver.kernel.org>; Tue,  8 Dec 2020 20:16:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731165AbgLHUQF (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 8 Dec 2020 15:16:05 -0500
Received: from esa5.microchip.iphmx.com ([216.71.150.166]:32318 "EHLO
        esa5.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731157AbgLHUQD (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 8 Dec 2020 15:16:03 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1607458564; x=1638994564;
  h=subject:from:to:cc:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Mfgct4gdIBqvec2jMrxL86cLgeK5x+65APNKfgB70OU=;
  b=BJdoQIiy93ZbaFxxp//Ice6KzHFpIvvQjQSSPDjCuvKUAuzMyBDSY8ce
   2rcbhGXYyOGwLYlNOIBVDytpwqNyeI7esI4GFcJKd27K0wyHYCdDtLkmY
   vUHRY/2cqMUekd5JzLe6a/SAdoB/2+G4tByDoP4FqDnGznxEE8hD8jahc
   RnHZEavFqF29tAXOmTPVNj2sU7lKHwCP3OC9zLe1zLn7FlLhaFcg53bg4
   OG56umYN59Cn++4jJj2xRCSRC0hGsN1TbEOswsacHsainP5rstPKc2WCA
   d3AiuhAptskR2CQAgHMg41uTUHKAj9poUCCMYIdb/C7EMghkTIk2EiE5x
   g==;
IronPort-SDR: VsDUsXeKFNggDEsbNyHfrbu+b9ZA6PDxdbjv2wr5wSlQoRZSWwnURRFRljbL6dX+jTV64kvJe2
 cDLEubd0IuMBkacaiti5+o6kMzl5Dto8ZBo7c89zLQwZwdCPO6VlRlsyhIpA/v/aHe1mjS9wL1
 tAbkmTXlkgUmnzoed0VBkygMlys98bui0QmEYzFENiFX8sWPN+tjZ8l2+ZqnYm4RsJADZQykbV
 esKvIBFXgDh9aMolI3VAOwFiEBRXky2eqzPLGyWE2m13Lt9oFOGmB+OCSKXoOzTlbcrBV8anJR
 koA=
X-IronPort-AV: E=Sophos;i="5.78,403,1599548400"; 
   d="scan'208";a="101443207"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa5.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 08 Dec 2020 12:37:24 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Tue, 8 Dec 2020 12:37:22 -0700
Received: from [127.0.1.1] (10.10.115.15) by chn-vm-ex03.mchp-main.com
 (10.10.85.151) with Microsoft SMTP Server id 15.1.1979.3 via Frontend
 Transport; Tue, 8 Dec 2020 12:37:21 -0700
Subject: [PATCH V2 08/25] smartpqi: add support for long firmware version
From:   Don Brace <don.brace@microchip.com>
To:     <Kevin.Barnett@microchip.com>, <scott.teel@microchip.com>,
        <Justin.Lindley@microchip.com>, <scott.benesh@microchip.com>,
        <gerry.morong@microchip.com>, <mahesh.rajashekhara@microchip.com>,
        <hch@infradead.org>, <jejb@linux.vnet.ibm.com>,
        <joseph.szczypek@hpe.com>, <POSWALD@suse.com>
CC:     <linux-scsi@vger.kernel.org>
Date:   Tue, 8 Dec 2020 13:37:21 -0600
Message-ID: <160745624161.13450.7694909777094685376.stgit@brunhilda>
In-Reply-To: <160745609917.13450.11882890596851148601.stgit@brunhilda>
References: <160745609917.13450.11882890596851148601.stgit@brunhilda>
User-Agent: StGit/0.23-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Kevin Barnett <kevin.barnett@microchip.com>

* Add support for new "long" firmware version which requires
  minor driver changes to expose.

Reviewed-by: Scott Benesh <scott.benesh@microchip.com>
Reviewed-by: Scott Teel <scott.teel@microchip.com>
Signed-off-by: Kevin Barnett <kevin.barnett@microchip.com>
Signed-off-by: Don Brace <don.brace@microchip.com>
---
 drivers/scsi/smartpqi/smartpqi.h      |   14 ++++++++---
 drivers/scsi/smartpqi/smartpqi_init.c |   42 ++++++++++++++++++++++++---------
 2 files changed, 40 insertions(+), 16 deletions(-)

diff --git a/drivers/scsi/smartpqi/smartpqi.h b/drivers/scsi/smartpqi/smartpqi.h
index eb23c3cf59c0..f33244def944 100644
--- a/drivers/scsi/smartpqi/smartpqi.h
+++ b/drivers/scsi/smartpqi/smartpqi.h
@@ -1227,7 +1227,7 @@ struct pqi_event {
 struct pqi_ctrl_info {
 	unsigned int	ctrl_id;
 	struct pci_dev	*pci_dev;
-	char		firmware_version[11];
+	char		firmware_version[32];
 	char		serial_number[17];
 	char		model[17];
 	char		vendor[9];
@@ -1405,7 +1405,7 @@ enum pqi_ctrl_mode {
 struct bmic_identify_controller {
 	u8	configured_logical_drive_count;
 	__le32	configuration_signature;
-	u8	firmware_version[4];
+	u8	firmware_version_short[4];
 	u8	reserved[145];
 	__le16	extended_logical_unit_count;
 	u8	reserved1[34];
@@ -1413,11 +1413,17 @@ struct bmic_identify_controller {
 	u8	reserved2[8];
 	u8	vendor_id[8];
 	u8	product_id[16];
-	u8	reserved3[68];
+	u8	reserved3[62];
+	__le32	extra_controller_flags;
+	u8	reserved4[2];
 	u8	controller_mode;
-	u8	reserved4[32];
+	u8	spare_part_number[32];
+	u8	firmware_version_long[32];
 };
 
+/* constants for extra_controller_flags field of bmic_identify_controller */
+#define BMIC_IDENTIFY_EXTRA_FLAGS_LONG_FW_VERSION_SUPPORTED	0x20000000
+
 struct bmic_sense_subsystem_info {
 	u8	reserved[44];
 	u8	ctrl_serial_number[16];
diff --git a/drivers/scsi/smartpqi/smartpqi_init.c b/drivers/scsi/smartpqi/smartpqi_init.c
index 1830102d3d71..1c61f98f15dc 100644
--- a/drivers/scsi/smartpqi/smartpqi_init.c
+++ b/drivers/scsi/smartpqi/smartpqi_init.c
@@ -998,14 +998,12 @@ static void pqi_update_time_worker(struct work_struct *work)
 		PQI_UPDATE_TIME_WORK_INTERVAL);
 }
 
-static inline void pqi_schedule_update_time_worker(
-	struct pqi_ctrl_info *ctrl_info)
+static inline void pqi_schedule_update_time_worker(struct pqi_ctrl_info *ctrl_info)
 {
 	schedule_delayed_work(&ctrl_info->update_time_work, 0);
 }
 
-static inline void pqi_cancel_update_time_worker(
-	struct pqi_ctrl_info *ctrl_info)
+static inline void pqi_cancel_update_time_worker(struct pqi_ctrl_info *ctrl_info)
 {
 	cancel_delayed_work_sync(&ctrl_info->update_time_work);
 }
@@ -7239,13 +7237,23 @@ static int pqi_get_ctrl_product_details(struct pqi_ctrl_info *ctrl_info)
 	if (rc)
 		goto out;
 
-	memcpy(ctrl_info->firmware_version, identify->firmware_version,
-		sizeof(identify->firmware_version));
-	ctrl_info->firmware_version[sizeof(identify->firmware_version)] = '\0';
-	snprintf(ctrl_info->firmware_version +
-		strlen(ctrl_info->firmware_version),
-		sizeof(ctrl_info->firmware_version),
-		"-%u", get_unaligned_le16(&identify->firmware_build_number));
+	if (get_unaligned_le32(&identify->extra_controller_flags) &
+		BMIC_IDENTIFY_EXTRA_FLAGS_LONG_FW_VERSION_SUPPORTED) {
+		memcpy(ctrl_info->firmware_version,
+			identify->firmware_version_long,
+			sizeof(identify->firmware_version_long));
+	} else {
+		memcpy(ctrl_info->firmware_version,
+			identify->firmware_version_short,
+			sizeof(identify->firmware_version_short));
+		ctrl_info->firmware_version
+			[sizeof(identify->firmware_version_short)] = '\0';
+		snprintf(ctrl_info->firmware_version +
+			strlen(ctrl_info->firmware_version),
+			sizeof(ctrl_info->firmware_version),
+			"-%u",
+			get_unaligned_le16(&identify->firmware_build_number));
+	}
 
 	memcpy(ctrl_info->model, identify->product_id,
 		sizeof(identify->product_id));
@@ -9601,13 +9609,23 @@ static void __attribute__((unused)) verify_structures(void)
 	BUILD_BUG_ON(offsetof(struct bmic_identify_controller,
 		configuration_signature) != 1);
 	BUILD_BUG_ON(offsetof(struct bmic_identify_controller,
-		firmware_version) != 5);
+		firmware_version_short) != 5);
 	BUILD_BUG_ON(offsetof(struct bmic_identify_controller,
 		extended_logical_unit_count) != 154);
 	BUILD_BUG_ON(offsetof(struct bmic_identify_controller,
 		firmware_build_number) != 190);
+	BUILD_BUG_ON(offsetof(struct bmic_identify_controller,
+		vendor_id) != 200);
+	BUILD_BUG_ON(offsetof(struct bmic_identify_controller,
+		product_id) != 208);
+	BUILD_BUG_ON(offsetof(struct bmic_identify_controller,
+		extra_controller_flags) != 286);
 	BUILD_BUG_ON(offsetof(struct bmic_identify_controller,
 		controller_mode) != 292);
+	BUILD_BUG_ON(offsetof(struct bmic_identify_controller,
+		spare_part_number) != 293);
+	BUILD_BUG_ON(offsetof(struct bmic_identify_controller,
+		firmware_version_long) != 325);
 
 	BUILD_BUG_ON(offsetof(struct bmic_identify_physical_device,
 		phys_bay_in_box) != 115);

