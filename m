Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D0C6EC433DB
	for <linux-scsi@archiver.kernel.org>; Thu, 11 Mar 2021 20:18:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9997C64F8B
	for <linux-scsi@archiver.kernel.org>; Thu, 11 Mar 2021 20:18:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230016AbhCKUR6 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 11 Mar 2021 15:17:58 -0500
Received: from esa.microchip.iphmx.com ([68.232.153.233]:49199 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230047AbhCKUR1 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 11 Mar 2021 15:17:27 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1615493847; x=1647029847;
  h=subject:from:to:cc:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Lbdri0mPjq54DXS3WGahfh2719IxrvUSSzfsv5d3Btg=;
  b=BJ+kboA7XovFXiyw4Ye8KlY5+sapUs+eHaX1M2Lsp2JnoJt85VJnMVNq
   ZtI+WXpwx+VRQm9WVXDP+l/Il1oD7FN5S25aLEVaNjzoqnQNQ4HNOLmMo
   ZNLPVLV/1nhAuWvaONOoQYERN6v0WRjfsMhLx3uiiEbUr0T/M+k/kbVIn
   1o474SgcpSFXNuI6Ju3OU3FGRxAeqVH9s5k1Pe/uWr+7mJm5X7WQaLVe5
   F1P05dLht9DqPURW9RQLAOGpNA/0IMhYTKNMoZYYygV9ZtfZxfCrpS9yn
   BpBJIBbB0X5VdxvOabw6UDwdZjAnKQ4BhUeWbeJfQ6wH7crpeSG4EgGhp
   Q==;
IronPort-SDR: rf7o4FeAn6LKRIOG0nUsxjDmyIuZ5c8tpU44HRta6PlazRHFMjQAAjQz/mT1H2Dp2nsRZMCusV
 vGFMAcxfUsPpAIoNN2g5Ab9vJfQHg6Tr8C2q/Oa8H2TYjpwh7T8dySdL+oQ6kjDmHKUKpMHoqU
 YjEA6i8NpFQxUwhxKb++EVYSMwxKC6HgDEKRsfYZ4hWhNx7cEo9tK9qmiX3NC71iYL+0Vopp/+
 MsYa9/jYVrnTM47ay+q0F7j60qajI/Tsn+4VLdSC4NAdJnCqLX5/aKfvghZnh8+zNVrjUStLtH
 1QY=
X-IronPort-AV: E=Sophos;i="5.81,241,1610434800"; 
   d="scan'208";a="118559172"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa1.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 11 Mar 2021 13:17:26 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Thu, 11 Mar 2021 13:17:20 -0700
Received: from [127.0.1.1] (10.10.115.15) by chn-vm-ex04.mchp-main.com
 (10.10.85.152) with Microsoft SMTP Server id 15.1.2176.2 via Frontend
 Transport; Thu, 11 Mar 2021 13:17:19 -0700
Subject: [PATCH V5 25/31] smartpqi: add phy id support for the physical
 drives
From:   Don Brace <don.brace@microchip.com>
To:     <Kevin.Barnett@microchip.com>, <scott.teel@microchip.com>,
        <Justin.Lindley@microchip.com>, <scott.benesh@microchip.com>,
        <gerry.morong@microchip.com>, <mahesh.rajashekhara@microchip.com>,
        <mike.mcgowen@microchip.com>, <murthy.bhat@microchip.com>,
        <hch@infradead.org>, <jejb@linux.vnet.ibm.com>,
        <joseph.szczypek@hpe.com>, <POSWALD@suse.com>
CC:     <linux-scsi@vger.kernel.org>
Date:   Thu, 11 Mar 2021 14:17:19 -0600
Message-ID: <161549383947.25025.16977895345376485056.stgit@brunhilda>
In-Reply-To: <161549045434.25025.17473629602756431540.stgit@brunhilda>
References: <161549045434.25025.17473629602756431540.stgit@brunhilda>
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
index 761d7ec6d2b2..0e433223aea4 100644
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

