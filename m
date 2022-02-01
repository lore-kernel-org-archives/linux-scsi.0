Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 67026C433F5
	for <linux-scsi@archiver.kernel.org>; Tue,  1 Feb 2022 21:48:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236099AbiBAVsH (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 1 Feb 2022 16:48:07 -0500
Received: from esa.microchip.iphmx.com ([68.232.153.233]:39807 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236074AbiBAVsE (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 1 Feb 2022 16:48:04 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1643752083; x=1675288083;
  h=subject:from:to:cc:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=+AjclKvQxtKx4gyF8Tdkv4vsdL2XPpiCOQvLwVLrHBw=;
  b=mbsDFZn7egWVIVjIRY3krs0E7S0o6D0YnsNe1jKEujPbyHLlaLzRAVjB
   ZSkljNWot3HQ+D/PhVnxgBRswcLNLmr9Zere0qpIrMVI/V1RhyEuOXOUP
   RNJs7pFS4LTF/BwFQrRWYgHqMXDNjuRq5f9+3IUANOT+VF5IovB40eBGr
   b83pHGqv+9JWpyOuvDrgEXcvbeY8RYRxLChdVlFzQzknfmWbfb7KhGp0p
   CBO+ToyU1G4nCHlayiSX8tHrJgqqXlhR5qFzFDzWSaPxrTU9Mian6Jqt3
   DZvDVtpuVpls6WZ3FSthcEQhXG8INt3fRzIR2teVdJDs4Ahz6lTahbXYM
   w==;
IronPort-SDR: Ny9Hbf6WeWcp3xqL4242/9BJaX/7i9DALTusXwvUZ+74WeSFogCll9OIKBaS0tMsZ2WHpQVnmL
 mPrT/gmjkdk65gcnnEYrVBMP2/AXA8fMH1c79UZhrM9wrIIYlRRV49I1MNhG0fRz/eT9m7Klse
 L35x0v4Bhd95XfktIaOXtkACSePWuypiGqeQNHhoY0zDeqpH6l23Nhlxpx8qZQIDyKCAv+p542
 L3WWI9Eap0B3+LUrAll8ifljn2kagIihr5SFEszOU/uFQGj74IdDoRQ1rLltN5XxPp7XeHg94/
 zzqYUTae2+rCAj2/0VGswQVo
X-IronPort-AV: E=Sophos;i="5.88,335,1635231600"; 
   d="scan'208";a="160764649"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa1.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 01 Feb 2022 14:48:03 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Tue, 1 Feb 2022 14:48:03 -0700
Received: from brunhilda.pdev.net (10.10.115.15) by chn-vm-ex03.mchp-main.com
 (10.10.85.151) with Microsoft SMTP Server id 15.1.2375.17 via Frontend
 Transport; Tue, 1 Feb 2022 14:48:03 -0700
Received: from brunhilda.pdev.net (localhost [127.0.0.1])
        by brunhilda.pdev.net (Postfix) with ESMTP id 187C070236E;
        Tue,  1 Feb 2022 15:48:03 -0600 (CST)
Subject: [PATCH 03/18] smartpqi: enable SATA NCQ priority in sysfs
From:   Don Brace <don.brace@microchip.com>
To:     <Kevin.Barnett@microchip.com>, <scott.teel@microchip.com>,
        <Justin.Lindley@microchip.com>, <scott.benesh@microchip.com>,
        <gerry.morong@microchip.com>, <mahesh.rajashekhara@microchip.com>,
        <mike.mcgowen@microchip.com>, <murthy.bhat@microchip.com>,
        <hch@infradead.org>, <jejb@linux.vnet.ibm.com>,
        <joseph.szczypek@hpe.com>, <POSWALD@suse.com>
CC:     <linux-scsi@vger.kernel.org>
Date:   Tue, 1 Feb 2022 15:48:03 -0600
Message-ID: <164375208306.440833.7392577382127815362.stgit@brunhilda.pdev.net>
In-Reply-To: <164375113574.440833.13174600317115819605.stgit@brunhilda.pdev.net>
References: <164375113574.440833.13174600317115819605.stgit@brunhilda.pdev.net>
User-Agent: StGit/1.4.dev36+g39bf3b02665a
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Gilbert Wu <Gilbert.Wu@microchip.com>

Add device attribute sas_ncq_prio_enable for IO utility
to enable SATA NCQ priority support and recognize IO priority in SCSI
command and then pass IO priority information to controller firmware.

This device attribute works only when device has NCQ priority support
and controller firmware can handle IO with NCQ priority attribute.

Reviewed-by: Mike McGowen <mike.mcgowen@microchip.com>
Reviewed-by: Scott Teel <scott.teel@microchip.com>
Signed-off-by: Gilbert Wu <Gilbert.Wu@microchip.com>
Signed-off-by: Don Brace <don.brace@microchip.com>
---
 drivers/scsi/smartpqi/smartpqi.h      |    2 +
 drivers/scsi/smartpqi/smartpqi_init.c |  119 ++++++++++++++++++++++++++++++++-
 2 files changed, 117 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/smartpqi/smartpqi.h b/drivers/scsi/smartpqi/smartpqi.h
index aac88ac0a0b7..f192745ee488 100644
--- a/drivers/scsi/smartpqi/smartpqi.h
+++ b/drivers/scsi/smartpqi/smartpqi.h
@@ -1127,6 +1127,8 @@ struct pqi_scsi_dev {
 	u8	box[8];
 	u16	phys_connector[8];
 	u8	phy_id;
+	u8	ncq_prio_enable;
+	u8	ncq_prio_support;
 	bool	raid_bypass_configured;	/* RAID bypass configured */
 	bool	raid_bypass_enabled;	/* RAID bypass enabled */
 	u32	next_bypass_group;
diff --git a/drivers/scsi/smartpqi/smartpqi_init.c b/drivers/scsi/smartpqi/smartpqi_init.c
index d34e49caa3f3..ad9fa1628a69 100644
--- a/drivers/scsi/smartpqi/smartpqi_init.c
+++ b/drivers/scsi/smartpqi/smartpqi_init.c
@@ -68,7 +68,7 @@ static int pqi_submit_raid_request_synchronous(struct pqi_ctrl_info *ctrl_info,
 static int pqi_aio_submit_io(struct pqi_ctrl_info *ctrl_info,
 	struct scsi_cmnd *scmd, u32 aio_handle, u8 *cdb,
 	unsigned int cdb_length, struct pqi_queue_group *queue_group,
-	struct pqi_encryption_info *encryption_info, bool raid_bypass);
+	struct pqi_encryption_info *encryption_info, bool raid_bypass, bool io_high_prio);
 static  int pqi_aio_submit_r1_write_io(struct pqi_ctrl_info *ctrl_info,
 	struct scsi_cmnd *scmd, struct pqi_queue_group *queue_group,
 	struct pqi_encryption_info *encryption_info, struct pqi_scsi_dev *device,
@@ -1549,6 +1549,7 @@ static void pqi_get_volume_status(struct pqi_ctrl_info *ctrl_info,
 	device->volume_offline = volume_offline;
 }
 
+#define PQI_DEVICE_NCQ_PRIO_SUPPORTED	0x01
 #define PQI_DEVICE_PHY_MAP_SUPPORTED	0x10
 
 static int pqi_get_physical_device_info(struct pqi_ctrl_info *ctrl_info,
@@ -1597,6 +1598,10 @@ static int pqi_get_physical_device_info(struct pqi_ctrl_info *ctrl_info,
 	else
 		device->phy_id = 0xFF;
 
+	device->ncq_prio_support =
+		((get_unaligned_le32(&id_phys->misc_drive_flags) >> 16) &
+		PQI_DEVICE_NCQ_PRIO_SUPPORTED);
+
 	return 0;
 }
 
@@ -3007,7 +3012,7 @@ static int pqi_raid_bypass_submit_scsi_cmd(struct pqi_ctrl_info *ctrl_info,
 
 	return pqi_aio_submit_io(ctrl_info, scmd, rmd.aio_handle,
 		rmd.cdb, rmd.cdb_length, queue_group,
-		encryption_info_ptr, true);
+		encryption_info_ptr, true, false);
 }
 
 #define PQI_STATUS_IDLE		0x0
@@ -5560,18 +5565,55 @@ static void pqi_aio_io_complete(struct pqi_io_request *io_request,
 	pqi_scsi_done(scmd);
 }
 
+static inline bool pqi_is_io_high_prioity(struct pqi_ctrl_info *ctrl_info,
+	struct pqi_scsi_dev *device, struct scsi_cmnd *scmd)
+{
+	bool io_high_prio;
+	int priority_class;
+
+	io_high_prio = false;
+	if (device->ncq_prio_enable) {
+		priority_class =
+			IOPRIO_PRIO_CLASS(req_get_ioprio(scsi_cmd_to_rq(scmd)));
+		if (priority_class == IOPRIO_CLASS_RT) {
+			/* set NCQ priority for read/write command */
+			switch (scmd->cmnd[0]) {
+			case WRITE_16:
+			case READ_16:
+			case WRITE_12:
+			case READ_12:
+			case WRITE_10:
+			case READ_10:
+			case WRITE_6:
+			case READ_6:
+				io_high_prio = true;
+				break;
+			default:
+				break;
+			}
+		}
+	}
+
+	return io_high_prio;
+}
+
 static inline int pqi_aio_submit_scsi_cmd(struct pqi_ctrl_info *ctrl_info,
 	struct pqi_scsi_dev *device, struct scsi_cmnd *scmd,
 	struct pqi_queue_group *queue_group)
 {
+	bool io_high_prio;
+
+	io_high_prio = pqi_is_io_high_prioity(ctrl_info, device, scmd);
 	return pqi_aio_submit_io(ctrl_info, scmd, device->aio_handle,
-		scmd->cmnd, scmd->cmd_len, queue_group, NULL, false);
+		scmd->cmnd, scmd->cmd_len, queue_group, NULL,
+		false, io_high_prio);
 }
 
 static int pqi_aio_submit_io(struct pqi_ctrl_info *ctrl_info,
 	struct scsi_cmnd *scmd, u32 aio_handle, u8 *cdb,
 	unsigned int cdb_length, struct pqi_queue_group *queue_group,
-	struct pqi_encryption_info *encryption_info, bool raid_bypass)
+	struct pqi_encryption_info *encryption_info, bool raid_bypass,
+	bool io_high_prio)
 {
 	int rc;
 	struct pqi_io_request *io_request;
@@ -5589,6 +5631,7 @@ static int pqi_aio_submit_io(struct pqi_ctrl_info *ctrl_info,
 	put_unaligned_le32(aio_handle, &request->nexus_id);
 	put_unaligned_le32(scsi_bufflen(scmd), &request->buffer_length);
 	request->task_attribute = SOP_TASK_ATTRIBUTE_SIMPLE;
+	request->command_priority = io_high_prio;
 	put_unaligned_le16(io_request->index, &request->request_id);
 	request->error_index = request->request_id;
 	if (cdb_length > sizeof(request->cdb))
@@ -7121,6 +7164,71 @@ static ssize_t pqi_raid_bypass_cnt_show(struct device *dev,
 	return scnprintf(buffer, PAGE_SIZE, "0x%x\n", raid_bypass_cnt);
 }
 
+static ssize_t pqi_sas_ncq_prio_enable_show(struct device *dev,
+		struct device_attribute *attr, char *buf)
+{
+	struct pqi_ctrl_info *ctrl_info;
+	struct scsi_device *sdev;
+	struct pqi_scsi_dev *device;
+	unsigned long flags;
+	int output_len = 0;
+
+	sdev = to_scsi_device(dev);
+	ctrl_info = shost_to_hba(sdev->host);
+
+	spin_lock_irqsave(&ctrl_info->scsi_device_list_lock, flags);
+
+	device = sdev->hostdata;
+	if (!device) {
+		spin_unlock_irqrestore(&ctrl_info->scsi_device_list_lock, flags);
+		return -ENODEV;
+	}
+
+	output_len = snprintf(buf, PAGE_SIZE, "%d\n",
+				device->ncq_prio_enable);
+	spin_unlock_irqrestore(&ctrl_info->scsi_device_list_lock, flags);
+
+	return output_len;
+}
+
+static ssize_t pqi_sas_ncq_prio_enable_store(struct device *dev,
+			struct device_attribute *attr,
+			const char *buf, size_t count)
+{
+	struct pqi_ctrl_info *ctrl_info;
+	struct scsi_device *sdev;
+	struct pqi_scsi_dev *device;
+	unsigned long flags;
+	u8 ncq_prio_enable = 0;
+
+	if (kstrtou8(buf, 0, &ncq_prio_enable))
+		return -EINVAL;
+
+	sdev = to_scsi_device(dev);
+	ctrl_info = shost_to_hba(sdev->host);
+
+	spin_lock_irqsave(&ctrl_info->scsi_device_list_lock, flags);
+
+	device = sdev->hostdata;
+
+	if (!device) {
+		spin_unlock_irqrestore(&ctrl_info->scsi_device_list_lock, flags);
+		return -ENODEV;
+	}
+
+	if (!device->ncq_prio_support ||
+		!device->is_physical_device) {
+		spin_unlock_irqrestore(&ctrl_info->scsi_device_list_lock, flags);
+		return -EINVAL;
+	}
+
+	device->ncq_prio_enable = ncq_prio_enable;
+
+	spin_unlock_irqrestore(&ctrl_info->scsi_device_list_lock, flags);
+
+	return  strlen(buf);
+}
+
 static DEVICE_ATTR(lunid, 0444, pqi_lunid_show, NULL);
 static DEVICE_ATTR(unique_id, 0444, pqi_unique_id_show, NULL);
 static DEVICE_ATTR(path_info, 0444, pqi_path_info_show, NULL);
@@ -7128,6 +7236,8 @@ static DEVICE_ATTR(sas_address, 0444, pqi_sas_address_show, NULL);
 static DEVICE_ATTR(ssd_smart_path_enabled, 0444, pqi_ssd_smart_path_enabled_show, NULL);
 static DEVICE_ATTR(raid_level, 0444, pqi_raid_level_show, NULL);
 static DEVICE_ATTR(raid_bypass_cnt, 0444, pqi_raid_bypass_cnt_show, NULL);
+static DEVICE_ATTR(sas_ncq_prio_enable, 0644,
+		pqi_sas_ncq_prio_enable_show, pqi_sas_ncq_prio_enable_store);
 
 static struct attribute *pqi_sdev_attrs[] = {
 	&dev_attr_lunid.attr,
@@ -7137,6 +7247,7 @@ static struct attribute *pqi_sdev_attrs[] = {
 	&dev_attr_ssd_smart_path_enabled.attr,
 	&dev_attr_raid_level.attr,
 	&dev_attr_raid_bypass_cnt.attr,
+	&dev_attr_sas_ncq_prio_enable.attr,
 	NULL
 };
 


