Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D48FBC433FE
	for <linux-scsi@archiver.kernel.org>; Tue,  8 Dec 2020 20:29:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A0D6123AA8
	for <linux-scsi@archiver.kernel.org>; Tue,  8 Dec 2020 20:29:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729520AbgLHU22 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 8 Dec 2020 15:28:28 -0500
Received: from esa3.microchip.iphmx.com ([68.232.153.233]:25111 "EHLO
        esa3.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728679AbgLHU21 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 8 Dec 2020 15:28:27 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1607459307; x=1638995307;
  h=subject:from:to:cc:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=o8n6IXsJ9+mt36VLdzraJcx72Zuw24OUqd5ySqIEO+M=;
  b=QBkaA7EQXbIZIBFZ8ivoxzK3qRjRKy7uTQk/gr5iqMjSt0vi/p2N1Mfd
   K7OPJpLYtLk6RSEeE5H8dXIJEgbq+yJxOVFpYTTycn6rT3SV6z/8go+zB
   bb2pZfzLsKJINP8fKXCzjyPP+qCFS8fOafNhqpBxB1ZYNu2rtgDCpjY0G
   DozLooZa0yfFPUb4DSEd1vd/5T+iqhAy0qJ1tbaICTY75p5LkGLJ96pFn
   Mx1eBnmHQw89F7NYSxowV4HR7Hl5W7XFpoaJ7mYzJFu6BDioCxjSh002Y
   g4AXw/cOgb6jx0gIbtmNuQBUzE52pqW+MyJl/DAi7OjCAxQgtIZhdxob6
   A==;
IronPort-SDR: AZHfpqfAZzBcpOel1gFXuRodcFvxaAzFTKl69swirfBJJ4LSFoI7CAo7FXWEJbzLrIsPdhGBGb
 +qAXNGTwgBJ35bK9JksAQjFYac32ikJr+TEmHKP3p6IZLssDTvZ0RuoXgymo4tweTLUW8p7PKF
 43LpnObtrxmW/JPg7Mv8eVKQ5mebfhuCQrVW+HI6t5HUv2RN8FCBvniWdiFE6znR8eljB75zKe
 ODZ6OePPBF6D9w3xIvyYPFTmBNlUEy+4laMOl59dW6HThHhh+RhyxYD+opsVvtyFJo99LVETA9
 ldY=
X-IronPort-AV: E=Sophos;i="5.78,403,1599548400"; 
   d="scan'208";a="102012279"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa3.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 08 Dec 2020 12:38:28 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Tue, 8 Dec 2020 12:38:26 -0700
Received: from [127.0.1.1] (10.10.115.15) by chn-vm-ex03.mchp-main.com
 (10.10.85.151) with Microsoft SMTP Server id 15.1.1979.3 via Frontend
 Transport; Tue, 8 Dec 2020 12:38:25 -0700
Subject: [PATCH V2 19/25] smartpqi: add phy id support for the physical
 drives
From:   Don Brace <don.brace@microchip.com>
To:     <Kevin.Barnett@microchip.com>, <scott.teel@microchip.com>,
        <Justin.Lindley@microchip.com>, <scott.benesh@microchip.com>,
        <gerry.morong@microchip.com>, <mahesh.rajashekhara@microchip.com>,
        <hch@infradead.org>, <jejb@linux.vnet.ibm.com>,
        <joseph.szczypek@hpe.com>, <POSWALD@suse.com>
CC:     <linux-scsi@vger.kernel.org>
Date:   Tue, 8 Dec 2020 13:38:25 -0600
Message-ID: <160745630568.13450.516225004166779126.stgit@brunhilda>
In-Reply-To: <160745609917.13450.11882890596851148601.stgit@brunhilda>
References: <160745609917.13450.11882890596851148601.stgit@brunhilda>
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
index 0cb137a46d6b..43e238b0c27d 100644
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

