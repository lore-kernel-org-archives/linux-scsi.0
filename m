Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNWANTED_LANGUAGE_BODY,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CD426C433E9
	for <linux-scsi@archiver.kernel.org>; Wed, 10 Mar 2021 20:03:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A6ED064FCE
	for <linux-scsi@archiver.kernel.org>; Wed, 10 Mar 2021 20:03:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232132AbhCJUDc (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 10 Mar 2021 15:03:32 -0500
Received: from esa.microchip.iphmx.com ([68.232.153.233]:22782 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231418AbhCJUDM (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 10 Mar 2021 15:03:12 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1615406592; x=1646942592;
  h=subject:from:to:cc:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=VmFBtogxKnu/b0yUIXo97JcNzstpcqLqDMYvwF3dqCE=;
  b=a+0T12e61UsHyw0QavQJDLo0BJoosf+x1fUl060mXn0UsyjCzgNrE0aE
   CNQ1JE4Yrp1uw7yoDS9h2zEOwz6p9bMBfYLWZWuQjXwLtHxMJ8HAF3usb
   qJyuHSXPuPQ+nxDDsHY6cocI52M0o8uUcq/ijVROXat3wtMMFZqWSBXGg
   vV8FqfltteOw8uiB/GX1c52V1Ef5CRlqLw3kNemeJ41t6NBH+Ls614GT0
   FsR5Tx3IpHJtf12Oqq32yY4ZUIZAwtzt7wTlmkn8WYd2RmeeJ+e0SDr/d
   VZfYrPpAzQfS3n6xHJuTUbnvpo5SCwmM3YoDPne3/MBMgkEPGSy2uqg2n
   A==;
IronPort-SDR: +zWRs9xARo/xhZMBFMDHzpMZMIKkX/vOzS/bIiNSxoCc1sDCRp+kwaRuvv9m3dwQbbXQoIoJt9
 duCcb2pqB6DppgqotjAIg4lImiZ9ki7VLJQsPEy9jxtaalcnvevCMdy45PrmomY480o9Y1O1a9
 C6VMaKOzgIA/KNLCDieTG4dTtqvz3BGPo+U+Cizu6TN/PHxMu7g/SxXqrpklnZEPKk3NdmFE6t
 1sqRdvGawWk9tQ3Cw97O4PJPqgViswgbd5K2kVFPuhDfLM5mUqLoJTiWrjN61bKNUA08GBZOBQ
 Hto=
X-IronPort-AV: E=Sophos;i="5.81,238,1610434800"; 
   d="scan'208";a="118389743"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa1.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 10 Mar 2021 13:03:12 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.87.72) by
 chn-vm-ex02.mchp-main.com (10.10.87.72) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Wed, 10 Mar 2021 13:03:11 -0700
Received: from [127.0.1.1] (10.10.115.15) by chn-vm-ex02.mchp-main.com
 (10.10.85.144) with Microsoft SMTP Server id 15.1.2176.2 via Frontend
 Transport; Wed, 10 Mar 2021 13:03:11 -0700
Subject: [PATCH V4 25/31] smartpqi: add phy id support for the physical
 drives
From:   Don Brace <don.brace@microchip.com>
To:     <Kevin.Barnett@microchip.com>, <scott.teel@microchip.com>,
        <Justin.Lindley@microchip.com>, <scott.benesh@microchip.com>,
        <gerry.morong@microchip.com>, <mahesh.rajashekhara@microchip.com>,
        <mike.mcgowen@microchip.com>, <hch@infradead.org>,
        <jejb@linux.vnet.ibm.com>, <joseph.szczypek@hpe.com>,
        <POSWALD@suse.com>
CC:     <linux-scsi@vger.kernel.org>
Date:   Wed, 10 Mar 2021 14:03:11 -0600
Message-ID: <161540659104.19430.1784942268875283747.stgit@brunhilda>
In-Reply-To: <161540568064.19430.11157730901022265360.stgit@brunhilda>
References: <161540568064.19430.11157730901022265360.stgit@brunhilda>
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
Reviewed-by: Mike McGowen <mike.mcgowen@microchip.com>
Reviewed-by: Scott Teel <scott.teel@microchip.com>
Reviewed-by: Kevin Barnett <kevin.barnett@microchip.com>
Reviewed-by: Martin Wilck <mwilck@suse.com>
Signed-off-by: Murthy Bhat <Murthy.Bhat@microchip.com>
Signed-off-by: Don Brace <don.brace@microchip.com>
---
 drivers/scsi/smartpqi/smartpqi.h               |    1 +
 drivers/scsi/smartpqi/smartpqi_init.c          |   10 ++++++++++
 drivers/scsi/smartpqi/smartpqi_sas_transport.c |    1 +
 3 files changed, 12 insertions(+)

diff --git a/drivers/scsi/smartpqi/smartpqi.h b/drivers/scsi/smartpqi/smartpqi.h
index 0b94c755a74c..d7dac5572274 100644
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
index 872b2b136e91..7a14fc555500 100644
--- a/drivers/scsi/smartpqi/smartpqi_init.c
+++ b/drivers/scsi/smartpqi/smartpqi_init.c
@@ -1434,6 +1434,8 @@ static void pqi_get_volume_status(struct pqi_ctrl_info *ctrl_info,
 	device->volume_offline = volume_offline;
 }
 
+#define PQI_DEVICE_PHY_MAP_SUPPORTED	0x10
+
 static int pqi_get_physical_device_info(struct pqi_ctrl_info *ctrl_info,
 	struct pqi_scsi_dev *device,
 	struct bmic_identify_physical_device *id_phys)
@@ -1473,6 +1475,13 @@ static int pqi_get_physical_device_info(struct pqi_ctrl_info *ctrl_info,
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
 
@@ -1839,6 +1848,7 @@ static void pqi_scsi_update_device(struct pqi_scsi_dev *existing_device,
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

