Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.5 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 82136C0018C
	for <linux-scsi@archiver.kernel.org>; Thu, 10 Dec 2020 20:38:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5096323E25
	for <linux-scsi@archiver.kernel.org>; Thu, 10 Dec 2020 20:38:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393833AbgLJUiV (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 10 Dec 2020 15:38:21 -0500
Received: from esa.microchip.iphmx.com ([68.232.153.233]:13285 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2393719AbgLJUhl (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 10 Dec 2020 15:37:41 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1607632660; x=1639168660;
  h=subject:from:to:cc:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=9DRAT6Tgz7EtcWLq9GuHHyGfSMUzrYD2BG43a/coNGY=;
  b=OJ1FfdkN3sHZCmWx5k+53GeLFMsDjmd31Oh40Voo8Cputs2D02rsK5Zx
   VdGmpdSzhVLJlB06l4xm0D2dMZ1HrvFB879kMxyvmgUvC6SpNxh/YbhA2
   r5YhnslzZBF8J2WSHcmFZB+4SRJcPwRof62OlZAz1DujeaKyQ0FNBxUwy
   qEouI2D/H6FaurVlEhOCWpFUnQv7riL4vjbW8CLlcogOgtRB2MT6Dk9Dc
   qt23VVESQF5Dczrqj51dEI3F/itMSX9ZSuNVJ6YCR44yUrIIuz60n8a6u
   0A9qTy+qWzOm2KIRcLult+f9WcX66DTPhxQuyJ/hKOv3c9pVVr2iuVOI3
   Q==;
IronPort-SDR: TJ22uvnEQlAkQw70PfZBu3GPoNkx2TJ/DL8Y5SIuUj15R2cKdotCe9qmi4ihIHRnz7lyf5Szo2
 MpA82v0m5RI46SRcijHWiAfUMfZSh8X4nwHj/L/l0cOqlNUNMS6hRo6WY85vKUAkpYs8C3ZZwI
 TzyVDX9hyf+GZg6Gvx7QRygaoO9ApTGWzlbYukY4JWFe2jCIGmpjFJmjtP06JwkY194VWbgKvG
 T61jyjBcYQuhCLQ4ka2ZjlZ6cldMWy0f2ySyBeE3BoCyFjbNT1xrOX7yI+3Pny2lBLry5Hs6pU
 psI=
X-IronPort-AV: E=Sophos;i="5.78,409,1599548400"; 
   d="scan'208";a="102325239"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa3.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 10 Dec 2020 13:36:14 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Thu, 10 Dec 2020 13:36:11 -0700
Received: from [127.0.1.1] (10.10.115.15) by chn-vm-ex03.mchp-main.com
 (10.10.85.151) with Microsoft SMTP Server id 15.1.1979.3 via Frontend
 Transport; Thu, 10 Dec 2020 13:36:11 -0700
Subject: [PATCH V3 19/25] smartpqi: add phy id support for the physical
 drives
From:   Don Brace <don.brace@microchip.com>
To:     <Kevin.Barnett@microchip.com>, <scott.teel@microchip.com>,
        <Justin.Lindley@microchip.com>, <scott.benesh@microchip.com>,
        <gerry.morong@microchip.com>, <mahesh.rajashekhara@microchip.com>,
        <hch@infradead.org>, <jejb@linux.vnet.ibm.com>,
        <joseph.szczypek@hpe.com>, <POSWALD@suse.com>
CC:     <linux-scsi@vger.kernel.org>
Date:   Thu, 10 Dec 2020 14:36:10 -0600
Message-ID: <160763257085.26927.11572432608178521227.stgit@brunhilda>
In-Reply-To: <160763241302.26927.17487238067261230799.stgit@brunhilda>
References: <160763241302.26927.17487238067261230799.stgit@brunhilda>
User-Agent: StGit/0.23-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Murthy Bhat <Murthy.Bhat@microchip.com>

* Display topology using PHY numbers.
* PHY(both local and remote) numbers corresponding to physical drives
    are read from BMIC_IDENTIFY_PHYSICAL_DEVICE.

Reviewed-by: Scott Benesh <scott.benesh@microchip.com>
Reviewed-by: Scott Teel <scott.teel@microchip.com>
Reviewed-by: Kevin Barnett <kevin.barnett@microchip.com>
Signed-off-by: Murthy Bhat <Murthy.Bhat@microchip.com>
Signed-off-by: Don Brace <don.brace@microchip.com>
---
 drivers/scsi/smartpqi/smartpqi.h               |    1 +
 drivers/scsi/smartpqi/smartpqi_init.c          |   10 ++++++++++
 drivers/scsi/smartpqi/smartpqi_sas_transport.c |    1 +
 3 files changed, 12 insertions(+)

diff --git a/drivers/scsi/smartpqi/smartpqi.h b/drivers/scsi/smartpqi/smartpqi.h
index c3b103b15924..8220957bc69b 100644
--- a/drivers/scsi/smartpqi/smartpqi.h
+++ b/drivers/scsi/smartpqi/smartpqi.h
@@ -1089,6 +1089,7 @@ struct pqi_scsi_dev {
 	u8	phy_connected_dev_type;
 	u8	box[8];
 	u16	phys_connector[8];
+	u8	phy_id;
 	bool	raid_bypass_configured;	/* RAID bypass configured */
 	bool	raid_bypass_enabled;	/* RAID bypass enabled */
 	u32	next_bypass_group;
diff --git a/drivers/scsi/smartpqi/smartpqi_init.c b/drivers/scsi/smartpqi/smartpqi_init.c
index f6bc7d9850e0..6b624413c8e6 100644
--- a/drivers/scsi/smartpqi/smartpqi_init.c
+++ b/drivers/scsi/smartpqi/smartpqi_init.c
@@ -1435,6 +1435,8 @@ static void pqi_get_volume_status(struct pqi_ctrl_info *ctrl_info,
 	device->volume_offline = volume_offline;
 }
 
+#define PQI_DEVICE_PHY_MAP_SUPPORTED	0x10
+
 static int pqi_get_physical_device_info(struct pqi_ctrl_info *ctrl_info,
 	struct pqi_scsi_dev *device,
 	struct bmic_identify_physical_device *id_phys)
@@ -1474,6 +1476,13 @@ static int pqi_get_physical_device_info(struct pqi_ctrl_info *ctrl_info,
 	memcpy(&device->page_83_identifier, &id_phys->page_83_identifier,
 		sizeof(device->page_83_identifier));
 
+	if ((id_phys->even_more_flags & PQI_DEVICE_PHY_MAP_SUPPORTED) &&
+		id_phys->phy_count)
+		device->phy_id =
+			id_phys->phy_to_phy_map[device->active_path_index];
+	else
+		device->phy_id = 0xFF;
+
 	return 0;
 }
 
@@ -1840,6 +1849,7 @@ static void pqi_scsi_update_device(struct pqi_scsi_dev *existing_device,
 	existing_device->aio_handle = new_device->aio_handle;
 	existing_device->volume_status = new_device->volume_status;
 	existing_device->active_path_index = new_device->active_path_index;
+	existing_device->phy_id = new_device->phy_id;
 	existing_device->path_map = new_device->path_map;
 	existing_device->bay = new_device->bay;
 	existing_device->box_index = new_device->box_index;
diff --git a/drivers/scsi/smartpqi/smartpqi_sas_transport.c b/drivers/scsi/smartpqi/smartpqi_sas_transport.c
index 77923c6ec2c6..71e83d5fdd02 100644
--- a/drivers/scsi/smartpqi/smartpqi_sas_transport.c
+++ b/drivers/scsi/smartpqi/smartpqi_sas_transport.c
@@ -92,6 +92,7 @@ static int pqi_sas_port_add_rphy(struct pqi_sas_port *pqi_sas_port,
 
 	identify = &rphy->identify;
 	identify->sas_address = pqi_sas_port->sas_address;
+	identify->phy_identifier = pqi_sas_port->device->phy_id;
 
 	if (pqi_sas_port->device &&
 		pqi_sas_port->device->is_expander_smp_device) {

