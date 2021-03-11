Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2B3A6C4332D
	for <linux-scsi@archiver.kernel.org>; Thu, 11 Mar 2021 20:16:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F1EE764F8E
	for <linux-scsi@archiver.kernel.org>; Thu, 11 Mar 2021 20:16:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230094AbhCKUQA (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 11 Mar 2021 15:16:00 -0500
Received: from esa.microchip.iphmx.com ([68.232.154.123]:58776 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230162AbhCKUPt (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 11 Mar 2021 15:15:49 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1615493750; x=1647029750;
  h=subject:from:to:cc:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=qlVwfCGacsuVoXpaTmBJUJG3+PhbC/SzDM0RydTmF3A=;
  b=jJT1FGO5vf3qLOtYn3wiejYIjll2A4oSQbIL2Rl8ofLx1Vrupvt5Z0yZ
   T4ZNzVlZg+zFjKCFLR+FlLqE4OH1Vpuzcs9i9vINipIb6PkRdCV4pj06W
   oR2L2vcJYhi2VItgmPHd1E65zLvo3FYCmu/0SxT5GYw+j1uX80WJr1RfV
   6EsrBAxxNc1/bsUtrbbJYOcV9A9/ooGd/b2m3TnSvRSclMEpkhVTV1HkH
   qXFGlt8oEu8vEYFu99kyvhsw7KaRFozLBpe7FTGG4cZx3zgoBq1iACrmn
   zRZsKKt0EEogAb1KKFqghLfjMFOH4nwKAQBzCJIfvhmTzA7nvM9A09k9f
   w==;
IronPort-SDR: 91lWM3bmf9WRT4H0nGTYHacLMJP2n7wi+Pe54a9mPS0Dx3KhexB4ZxcqlYtkkCKR0p2Kjrgnhn
 VycC3IaP6GXuyn44Srer1ovhFDUCm42AbYSN0Q88pb5HOLaAu4tVC1Vtfe52g8VQc6g2dJQD3E
 Npb9HDd/gIx23GkdvaaAxes5/uyIxtEi2tS2bYReo26lcwLcsLkn9ToKpJ0/suxGJDcrzPEaPM
 57Awgu/rtpKw8TeytCsRABWxmgOClmtSIX9zv7TEg7gj6kEE35Gs6Cjd9ElJR5rDSYmga0ZeSs
 +AY=
X-IronPort-AV: E=Sophos;i="5.81,241,1610434800"; 
   d="scan'208";a="109660022"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa2.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 11 Mar 2021 13:15:49 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Thu, 11 Mar 2021 13:15:45 -0700
Received: from [127.0.1.1] (10.10.115.15) by chn-vm-ex01.mchp-main.com
 (10.10.85.143) with Microsoft SMTP Server id 15.1.2176.2 via Frontend
 Transport; Thu, 11 Mar 2021 13:15:45 -0700
Subject: [PATCH V5 09/31] smartpqi: add support for long firmware version
From:   Don Brace <don.brace@microchip.com>
To:     <Kevin.Barnett@microchip.com>, <scott.teel@microchip.com>,
        <Justin.Lindley@microchip.com>, <scott.benesh@microchip.com>,
        <gerry.morong@microchip.com>, <mahesh.rajashekhara@microchip.com>,
        <mike.mcgowen@microchip.com>, <murthy.bhat@microchip.com>,
        <hch@infradead.org>, <jejb@linux.vnet.ibm.com>,
        <joseph.szczypek@hpe.com>, <POSWALD@suse.com>
CC:     <linux-scsi@vger.kernel.org>
Date:   Thu, 11 Mar 2021 14:15:45 -0600
Message-ID: <161549374508.25025.15467221395888158022.stgit@brunhilda>
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

* Add support for new "long" firmware version which requires
  minor driver changes to expose.

Reviewed-by: Scott Benesh <scott.benesh@microchip.com>
Reviewed-by: Mike McGowen <mike.mcgowen@microchip.com>
Reviewed-by: Scott Teel <scott.teel@microchip.com>
Signed-off-by: Kevin Barnett <kevin.barnett@microchip.com>
Signed-off-by: Don Brace <don.brace@microchip.com>
---
 drivers/scsi/smartpqi/smartpqi.h      |   14 +++++++++---
 drivers/scsi/smartpqi/smartpqi_init.c |   37 ++++++++++++++++++++++++++-------
 2 files changed, 39 insertions(+), 12 deletions(-)

diff --git a/drivers/scsi/smartpqi/smartpqi.h b/drivers/scsi/smartpqi/smartpqi.h
index 35e892579773..aaafaced596b 100644
--- a/drivers/scsi/smartpqi/smartpqi.h
+++ b/drivers/scsi/smartpqi/smartpqi.h
@@ -1226,7 +1226,7 @@ struct pqi_event {
 struct pqi_ctrl_info {
 	unsigned int	ctrl_id;
 	struct pci_dev	*pci_dev;
-	char		firmware_version[11];
+	char		firmware_version[32];
 	char		serial_number[17];
 	char		model[17];
 	char		vendor[9];
@@ -1404,7 +1404,7 @@ enum pqi_ctrl_mode {
 struct bmic_identify_controller {
 	u8	configured_logical_drive_count;
 	__le32	configuration_signature;
-	u8	firmware_version[4];
+	u8	firmware_version_short[4];
 	u8	reserved[145];
 	__le16	extended_logical_unit_count;
 	u8	reserved1[34];
@@ -1412,11 +1412,17 @@ struct bmic_identify_controller {
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
index 82f75a6be71c..6cc953dd9961 100644
--- a/drivers/scsi/smartpqi/smartpqi_init.c
+++ b/drivers/scsi/smartpqi/smartpqi_init.c
@@ -7228,13 +7228,24 @@ static int pqi_get_ctrl_product_details(struct pqi_ctrl_info *ctrl_info)
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
+			sizeof(ctrl_info->firmware_version) -
+			sizeof(identify->firmware_version_short),
+			"-%u",
+			get_unaligned_le16(&identify->firmware_build_number));
+	}
 
 	memcpy(ctrl_info->model, identify->product_id,
 		sizeof(identify->product_id));
@@ -9612,13 +9623,23 @@ static void __attribute__((unused)) verify_structures(void)
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

