Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CB635C43381
	for <linux-scsi@archiver.kernel.org>; Wed, 10 Mar 2021 20:02:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9B71C64FCE
	for <linux-scsi@archiver.kernel.org>; Wed, 10 Mar 2021 20:02:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231418AbhCJUBy (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 10 Mar 2021 15:01:54 -0500
Received: from esa.microchip.iphmx.com ([68.232.154.123]:51721 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232153AbhCJUBj (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 10 Mar 2021 15:01:39 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1615406499; x=1646942499;
  h=subject:from:to:cc:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=tMCzC3Q3iDeH6DQ2jGC5uD7JGpK/Qp0g2SAYaK7qHGU=;
  b=BCeMaJLjv8ruccEIq3b3YrrYMeYV1CDigaeCX0Nru8iSre+8DMjWJc3D
   E8Rwb1GDRwvcA4dpOF6oCpYcA8CyM9kvtC6Peui7Jow6ylNDk4YiESaBK
   ysrVL8kpDq98wd2j37ZBL/j5EGOzqkfG6peQU1t4EUiniaSAABRqbI9Yt
   ZnjGx1bcGFiLpTHYfxRH3tSYFkzJe4GPgPev9Bw8lfvzdd6tNJqMyuUZp
   V3lq8m1S7HUF7u9bSFH4jEtq8+IutiLl+VGj2lLSEP3UVe12LYPDeSzWm
   RcBrwmY96/OgRvnWQW9++6us+LkOcW7P8EgCEekwPtdmY76REdw+smfI/
   g==;
IronPort-SDR: CyXdQoK++BNIZoXkz9GXb2bV/ByUmlvrKIYvdm1N1ZfMZY2TVLxW2TWNCE0Pct23Pev3HBPJ4M
 dmHvFoV+fRZwMR+wYzOMzsk/hoh6P25sA6m+PyqpW/d6pKNjMgKwTH/V5tQXJ2khSZ+38vgYVk
 Ckdpgnclg05mYS7YcQnbtlEqMCbV9KFMh6dUwiq4ZfZwOWIjs8CgDu/5dP70kNtK4Clvdqe/Ff
 JRzRqFGEDBl6Zp6igPI4LSNYs339I2KyjnYJRk7t4mJRvaZcmc0Vve7TBLkMVIh9lhVf4O6T7M
 GmA=
X-IronPort-AV: E=Sophos;i="5.81,238,1610434800"; 
   d="scan'208";a="47022470"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa6.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 10 Mar 2021 13:01:38 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Wed, 10 Mar 2021 13:01:38 -0700
Received: from [127.0.1.1] (10.10.115.15) by chn-vm-ex03.mchp-main.com
 (10.10.85.151) with Microsoft SMTP Server id 15.1.2176.2 via Frontend
 Transport; Wed, 10 Mar 2021 13:01:37 -0700
Subject: [PATCH V4 09/31] smartpqi: add support for long firmware version
From:   Don Brace <don.brace@microchip.com>
To:     <Kevin.Barnett@microchip.com>, <scott.teel@microchip.com>,
        <Justin.Lindley@microchip.com>, <scott.benesh@microchip.com>,
        <gerry.morong@microchip.com>, <mahesh.rajashekhara@microchip.com>,
        <mike.mcgowen@microchip.com>, <hch@infradead.org>,
        <jejb@linux.vnet.ibm.com>, <joseph.szczypek@hpe.com>,
        <POSWALD@suse.com>
CC:     <linux-scsi@vger.kernel.org>
Date:   Wed, 10 Mar 2021 14:01:37 -0600
Message-ID: <161540649762.19430.3798320865695298307.stgit@brunhilda>
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
index 5aae36e4cdf3..051bece31f83 100644
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

