Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BFD88C4361B
	for <linux-scsi@archiver.kernel.org>; Fri,  4 Dec 2020 23:03:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9872822D49
	for <linux-scsi@archiver.kernel.org>; Fri,  4 Dec 2020 23:03:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727333AbgLDXDr (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 4 Dec 2020 18:03:47 -0500
Received: from esa1.microchip.iphmx.com ([68.232.147.91]:5002 "EHLO
        esa1.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727281AbgLDXDr (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 4 Dec 2020 18:03:47 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1607123026; x=1638659026;
  h=subject:from:to:cc:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=dyUwGWM8h9A0H0neVeGhBqagcjisxhVZ4ImqZkSlN/k=;
  b=if2XGfv6Mw4lwH9bS0ol0CiUYXUpk9ySoua4qBBt2YqbfRrhzCtXT9en
   TA5yuXFhk5/4iK1/AW5yckv4ay/KBt+ZtK5MDzUHbrCeMaWoVrshUDteK
   bk/hQyyNQ8jGpSRbxSSGlFLFI/qQnapkbjl47ZetRPAU55mDgeumqv/Qo
   g4U7HCfhpbF1dHaX6BdO8cNG8kesKW1uxWgnwuk49XeMLrmNQ3x+4+sRP
   iXKDTBZsa8LlJT18PBgqeRoYNg/pZt9ZkEN25DjU7UpiydpEqAViUrWB4
   elAMSOJrZeEZNQcSmPlpvrIoOdLwKe+74LnNbKagkKoDxEkGrm1vWPzYq
   A==;
IronPort-SDR: 906txNOwydQmtczgLZjKcdRHfcO5QTjSlBu6FuwXXsiGVBJQq2h1hCNLQALiFoG8hb0YxggI17
 NKW5lk9RcxWClOoDaKcP+txz8Yo89T896yq8ytscIAUqAP5ZChC4TvpGqruT1Bz/0YoC7at6AV
 CU93V3BKOm+laoCNQs/0G1l0k+5CdefdjWYoEjeRrPMIS0KcGCzRJpf0+ueQ/Ge6jXSi4lAP0b
 NqWcHM78WaBi8b+96hx6XMNzTxMfK8ZJwHBsRhbxZi6lhs0V17OlOAg/zv6eJONkjyMW/IpjjZ
 ymQ=
X-IronPort-AV: E=Sophos;i="5.78,393,1599548400"; 
   d="scan'208";a="106273244"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa1.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 04 Dec 2020 16:02:42 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.85.144) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Fri, 4 Dec 2020 16:02:41 -0700
Received: from [127.0.1.1] (10.10.115.15) by chn-vm-ex02.mchp-main.com
 (10.10.85.144) with Microsoft SMTP Server id 15.1.1979.3 via Frontend
 Transport; Fri, 4 Dec 2020 16:02:41 -0700
Subject: [PATCH 19/25] smartpqi: add phy id support for the physical drives
From:   Don Brace <don.brace@microchip.com>
To:     <Kevin.Barnett@microchip.com>, <scott.teel@microchip.com>,
        <Justin.Lindley@microchip.com>, <scott.benesh@microchip.com>,
        <gerry.morong@microchip.com>, <mahesh.rajashekhara@microchip.com>,
        <hch@infradead.org>, <jejb@linux.vnet.ibm.com>,
        <joseph.szczypek@hpe.com>, <POSWALD@suse.com>
CC:     <linux-scsi@vger.kernel.org>
Date:   Fri, 4 Dec 2020 17:02:41 -0600
Message-ID: <160712296106.21372.12338709679674654994.stgit@brunhilda>
In-Reply-To: <160712276179.21372.51526310810782843.stgit@brunhilda>
References: <160712276179.21372.51526310810782843.stgit@brunhilda>
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
index 748735d71464..52ae3e7f75e1 100644
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

