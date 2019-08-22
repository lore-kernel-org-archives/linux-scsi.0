Return-Path: <SRS0=BT6k=WS=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CDFE9C3A5A1
	for <linux-scsi@archiver.kernel.org>; Thu, 22 Aug 2019 20:39:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9FFAC233FD
	for <linux-scsi@archiver.kernel.org>; Thu, 22 Aug 2019 20:39:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393299AbfHVUj2 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 22 Aug 2019 16:39:28 -0400
Received: from esa6.microchip.iphmx.com ([216.71.154.253]:33164 "EHLO
        esa6.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2393297AbfHVUj2 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 22 Aug 2019 16:39:28 -0400
Authentication-Results: esa6.microchip.iphmx.com; dkim=none (message not signed) header.i=none; spf=Pass smtp.mailfrom=don.brace@microsemi.com; spf=None smtp.helo=postmaster@smtp.microsemi.com
Received-SPF: Pass (esa6.microchip.iphmx.com: domain of
  don.brace@microsemi.com designates 208.19.100.22 as permitted
  sender) identity=mailfrom; client-ip=208.19.100.22;
  receiver=esa6.microchip.iphmx.com;
  envelope-from="don.brace@microsemi.com";
  x-sender="don.brace@microsemi.com"; x-conformance=spf_only;
  x-record-type="v=spf1"; x-record-text="v=spf1
  ip4:208.19.100.20 ip4:208.19.100.21 ip4:208.19.100.22
  ip4:208.19.100.23 ip4:208.19.99.221 ip4:208.19.99.222
  ip4:208.19.99.223 ip4:208.19.99.225 -all"
Received-SPF: None (esa6.microchip.iphmx.com: no sender
  authenticity information available from domain of
  postmaster@smtp.microsemi.com) identity=helo;
  client-ip=208.19.100.22; receiver=esa6.microchip.iphmx.com;
  envelope-from="don.brace@microsemi.com";
  x-sender="postmaster@smtp.microsemi.com";
  x-conformance=spf_only
X-Ironport-Dmarc-Check-Result: validskip
IronPort-SDR: 8GRcxQ3vt2jhXXhiUDHF2Eulg3vKslJnEVmXqjO+lahD3fBbQhQVGvl/GZZ8JznVypS15zSdcD
 C6ulvN0vT5xVYY+tzZgumQ1NakIXq8BsGWSJsGmsFgAhLZW9tb/fPLzlotjfZh0js+7VyKjVgP
 ZCtLIDLaEvfvSPt+gwdVfmSxe28woDSIvvsYOFs6VrEin++2uUVV8ICZ6NltqDBmhwlZlufL99
 0SIy7h5ECYCUa++NOplfOg0iJ7gqoF4M1VDTsxN4Z9P9XZjRdPu5S6pqIelLnaOLg9Swu64GZ/
 G3w=
X-IronPort-AV: E=Sophos;i="5.64,418,1559545200"; 
   d="scan'208";a="43343481"
Received: from unknown (HELO smtp.microsemi.com) ([208.19.100.22])
  by esa6.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 22 Aug 2019 13:39:27 -0700
Received: from AVMBX3.microsemi.net (10.100.34.33) by AVMBX2.microsemi.net
 (10.100.34.32) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1713.5; Thu, 22 Aug
 2019 13:39:26 -0700
Received: from AVMBX2.microsemi.net (10.100.34.32) by AVMBX3.microsemi.net
 (10.100.34.33) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1713.5; Thu, 22 Aug
 2019 13:39:25 -0700
Received: from [127.0.1.1] (10.238.32.34) by avmbx2.microsemi.net
 (10.100.34.32) with Microsoft SMTP Server id 15.1.1713.5 via Frontend
 Transport; Thu, 22 Aug 2019 13:39:25 -0700
Subject: [PATCH 05/11] smartpqi: add bay identifier
From:   Don Brace <don.brace@microsemi.com>
To:     <Kevin.Barnett@microchip.com>, <scott.teel@microchip.com>,
        <Justin.Lindley@microchip.com>, <scott.benesh@microchip.com>,
        <bader.alisaleh@microchip.com>, <gerry.morong@microchip.com>,
        <mahesh.rajashekhara@microchip.com>, <hch@infradead.org>,
        <jejb@linux.vnet.ibm.com>, <joseph.szczypek@hpe.com>,
        <POSWALD@suse.com>, <shunyong.yang@hxt-semitech.com>
CC:     <linux-scsi@vger.kernel.org>
Date:   Thu, 22 Aug 2019 15:39:25 -0500
Message-ID: <156650636513.18562.11314063546225056331.stgit@brunhilda>
In-Reply-To: <156650628375.18562.9889154437665249418.stgit@brunhilda>
References: <156650628375.18562.9889154437665249418.stgit@brunhilda>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Gilbert Wu <gilbert.wu@microsemi.com>

 - return identify physical device "Phys_Bay_in_Box"
   as bay_identifier.

Reviewed-by: Scott Benesh <scott.benesh@microsemi.com>
Reviewed-by: Kevin Barnett <kevin.barnett@microsemi.com>
Signed-off-by: Gilbert Wu <gilbert.wu@microsemi.com>
Signed-off-by: Don Brace <don.brace@microsemi.com>
---
 drivers/scsi/smartpqi/smartpqi.h               |    4 +
 drivers/scsi/smartpqi/smartpqi_init.c          |   13 ++-
 drivers/scsi/smartpqi/smartpqi_sas_transport.c |  102 ++++++++++++++++++++++++
 3 files changed, 113 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/smartpqi/smartpqi.h b/drivers/scsi/smartpqi/smartpqi.h
index 2b21c4ebc491..79d2af36f655 100644
--- a/drivers/scsi/smartpqi/smartpqi.h
+++ b/drivers/scsi/smartpqi/smartpqi.h
@@ -931,6 +931,9 @@ struct pqi_scsi_dev {
 	u8	active_path_index;
 	u8	path_map;
 	u8	bay;
+	u8	box_index;
+	u8	phys_box_on_bus;
+	u8	phy_connected_dev_type;
 	u8	box[8];
 	u16	phys_connector[8];
 	bool	raid_bypass_configured;	/* RAID bypass configured */
@@ -1242,6 +1245,7 @@ struct bmic_sense_subsystem_info {
 };
 
 #define SA_EXPANDER_SMP_DEVICE		0x05
+#define SA_CONTROLLER_DEVICE		0x07
 /*SCSI Invalid Device Type for SAS devices*/
 #define PQI_SAS_SCSI_INVALID_DEVTYPE	0xff
 
diff --git a/drivers/scsi/smartpqi/smartpqi_init.c b/drivers/scsi/smartpqi/smartpqi_init.c
index 7d09998db1b1..a6cb49b8e5d0 100644
--- a/drivers/scsi/smartpqi/smartpqi_init.c
+++ b/drivers/scsi/smartpqi/smartpqi_init.c
@@ -1413,7 +1413,9 @@ static void pqi_get_physical_disk_info(struct pqi_ctrl_info *ctrl_info,
 		device->queue_depth = PQI_PHYSICAL_DISK_DEFAULT_MAX_QUEUE_DEPTH;
 		return;
 	}
-
+	device->box_index = id_phys->box_index;
+	device->phys_box_on_bus = id_phys->phys_box_on_bus;
+	device->phy_connected_dev_type = id_phys->phy_connected_dev_type[0];
 	device->queue_depth =
 		get_unaligned_le16(&id_phys->current_queue_depth_limit);
 	device->device_type = id_phys->device_type;
@@ -1740,6 +1742,10 @@ static void pqi_scsi_update_device(struct pqi_scsi_dev *existing_device,
 	existing_device->active_path_index = new_device->active_path_index;
 	existing_device->path_map = new_device->path_map;
 	existing_device->bay = new_device->bay;
+	existing_device->box_index = new_device->box_index;
+	existing_device->phys_box_on_bus = new_device->phys_box_on_bus;
+	existing_device->phy_connected_dev_type =
+		new_device->phy_connected_dev_type;
 	memcpy(existing_device->box, new_device->box,
 		sizeof(existing_device->box));
 	memcpy(existing_device->phys_connector, new_device->phys_connector,
@@ -2169,11 +2175,10 @@ static int pqi_update_scsi_devices(struct pqi_ctrl_info *ctrl_info)
 					device->aio_handle =
 						phys_lun_ext_entry->aio_handle;
 			}
-			if (device->devtype == TYPE_DISK ||
-				device->devtype == TYPE_ZBC) {
+
 				pqi_get_physical_disk_info(ctrl_info,
 					device, id_phys);
-			}
+
 		} else {
 			memcpy(device->volume_id, log_lun_ext_entry->volume_id,
 				sizeof(device->volume_id));
diff --git a/drivers/scsi/smartpqi/smartpqi_sas_transport.c b/drivers/scsi/smartpqi/smartpqi_sas_transport.c
index 5cca1b9ef1f1..6776dfc1d317 100644
--- a/drivers/scsi/smartpqi/smartpqi_sas_transport.c
+++ b/drivers/scsi/smartpqi/smartpqi_sas_transport.c
@@ -312,12 +312,110 @@ static int pqi_sas_get_linkerrors(struct sas_phy *phy)
 static int pqi_sas_get_enclosure_identifier(struct sas_rphy *rphy,
 	u64 *identifier)
 {
-	return 0;
+
+	int rc;
+	unsigned long flags;
+	struct Scsi_Host *shost;
+	struct pqi_ctrl_info *ctrl_info;
+	struct pqi_scsi_dev *found_device;
+	struct pqi_scsi_dev *device;
+
+	if (!rphy)
+		return -ENODEV;
+
+	shost = rphy_to_shost(rphy);
+	ctrl_info = shost_to_hba(shost);
+	spin_lock_irqsave(&ctrl_info->scsi_device_list_lock, flags);
+	found_device = pqi_find_device_by_sas_rphy(ctrl_info, rphy);
+
+	if (!found_device) {
+		rc = -ENODEV;
+		goto out;
+	}
+
+	if (found_device->devtype == TYPE_ENCLOSURE) {
+		*identifier = get_unaligned_be64(&found_device->wwid);
+		rc = 0;
+		goto out;
+	}
+
+	if (found_device->box_index == 0xff ||
+		found_device->phys_box_on_bus == 0 ||
+		found_device->bay == 0xff) {
+		rc = -EINVAL;
+		goto out;
+	}
+
+	list_for_each_entry(device, &ctrl_info->scsi_device_list,
+		scsi_device_list_entry) {
+		if (device->devtype == TYPE_ENCLOSURE &&
+			device->box_index == found_device->box_index &&
+			device->phys_box_on_bus ==
+				found_device->phys_box_on_bus &&
+			memcmp(device->phys_connector,
+				found_device->phys_connector, 2) == 0) {
+			*identifier =
+				get_unaligned_be64(&device->wwid);
+			rc = 0;
+			goto out;
+		}
+	}
+
+	if (found_device->phy_connected_dev_type != SA_CONTROLLER_DEVICE) {
+		rc = -EINVAL;
+		goto out;
+	}
+
+	list_for_each_entry(device, &ctrl_info->scsi_device_list,
+		scsi_device_list_entry) {
+		if (device->devtype == TYPE_ENCLOSURE &&
+			CISS_GET_DRIVE_NUMBER(device->scsi3addr) ==
+				PQI_VSEP_CISS_BTL) {
+			*identifier = get_unaligned_be64(&device->wwid);
+			rc = 0;
+			goto out;
+		}
+	}
+
+	rc = -EINVAL;
+out:
+	spin_unlock_irqrestore(&ctrl_info->scsi_device_list_lock, flags);
+
+	return rc;
+
 }
 
 static int pqi_sas_get_bay_identifier(struct sas_rphy *rphy)
 {
-	return -ENXIO;
+
+	int rc;
+	unsigned long flags;
+	struct pqi_ctrl_info *ctrl_info;
+	struct pqi_scsi_dev *device;
+	struct Scsi_Host *shost;
+
+	if (!rphy)
+		return -ENODEV;
+
+	shost = rphy_to_shost(rphy);
+	ctrl_info = shost_to_hba(shost);
+	spin_lock_irqsave(&ctrl_info->scsi_device_list_lock, flags);
+	device = pqi_find_device_by_sas_rphy(ctrl_info, rphy);
+
+	if (!device) {
+		rc = -ENODEV;
+		goto out;
+	}
+
+	if (device->bay == 0xff)
+		rc = -EINVAL;
+	else
+		rc = device->bay;
+
+out:
+	spin_unlock_irqrestore(&ctrl_info->scsi_device_list_lock, flags);
+
+	return rc;
 }
 
 static int pqi_sas_phy_reset(struct sas_phy *phy, int hard_reset)

