Return-Path: <SRS0=WBt/=BK=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.0 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 058B8C433DF
	for <linux-scsi@archiver.kernel.org>; Fri, 31 Jul 2020 21:01:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D8BAD22B3F
	for <linux-scsi@archiver.kernel.org>; Fri, 31 Jul 2020 21:01:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729139AbgGaVBq (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 31 Jul 2020 17:01:46 -0400
Received: from esa4.microchip.iphmx.com ([68.232.154.123]:50866 "EHLO
        esa4.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729043AbgGaVBq (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 31 Jul 2020 17:01:46 -0400
IronPort-SDR: yPf/agnAjTg7MIgHj84m7Fi5jXddq+twdvupOVuCxiNK86Y+ncUN/URCVFw+qgGbzS1nHVhffs
 wt1yw7y0axCA34tfVDNEkhFc6BTOpsDAP2cZdiJnVsccseC0748huDX6MMcpUJeLiwG1SzPPlN
 +XgnUgdiV9RAfhlvMJgBX2fxiQ3bF2fbL1Of6vIb28r7nvQUIjUPOG7evT7GVm8zFyJ5YR/2hW
 AW7/c2AWWhPabdkwUml1PCObSvUHkA7YQ7Dp+THJhK0RtrK2KBKFj/Fkh8xD7nrU48Cq5pxcI3
 tKU=
X-IronPort-AV: E=Sophos;i="5.75,419,1589266800"; 
   d="scan'208";a="81993231"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa4.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 31 Jul 2020 14:01:45 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Fri, 31 Jul 2020 14:01:41 -0700
Received: from [127.0.1.1] (10.10.115.15) by chn-vm-ex01.mchp-main.com
 (10.10.85.143) with Microsoft SMTP Server id 15.1.1979.3 via Frontend
 Transport; Fri, 31 Jul 2020 14:01:43 -0700
Subject: [PATCH 6/7] smartpqi: add RAID bypass counter
From:   Don Brace <don.brace@microsemi.com>
To:     <Kevin.Barnett@microchip.com>, <scott.teel@microchip.com>,
        <Justin.Lindley@microchip.com>, <scott.benesh@microchip.com>,
        <bader.alisaleh@microchip.com>, <gerry.morong@microchip.com>,
        <mahesh.rajashekhara@microchip.com>, <hch@infradead.org>,
        <jejb@linux.vnet.ibm.com>, <joseph.szczypek@hpe.com>,
        <POSWALD@suse.com>
CC:     <linux-scsi@vger.kernel.org>
Date:   Fri, 31 Jul 2020 16:01:44 -0500
Message-ID: <159622930468.30579.13153724465552773544.stgit@brunhilda>
In-Reply-To: <159622890296.30579.6820363566594432069.stgit@brunhilda>
References: <159622890296.30579.6820363566594432069.stgit@brunhilda>
User-Agent: StGit/0.23-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Kevin Barnett <kevin.barnett@microsemi.com>

- Add a counter to assist in verifying
  when RAID bypass is being used.

Reviewed-by: Scott Teel <scott.teel@microsemi.com>
Reviewed-by: Scott Benesh <scott.benesh@microsemi.com>
Signed-off-by: Kevin Barnett <kevin.barnett@microsemi.com>
Signed-off-by: Don Brace <don.brace@microsemi.com>
---
 drivers/scsi/smartpqi/smartpqi.h      |    1 
 drivers/scsi/smartpqi/smartpqi_init.c |   77 +++++++++++++++++++++++----------
 2 files changed, 54 insertions(+), 24 deletions(-)

diff --git a/drivers/scsi/smartpqi/smartpqi.h b/drivers/scsi/smartpqi/smartpqi.h
index 631306d347db..d0c635971481 100644
--- a/drivers/scsi/smartpqi/smartpqi.h
+++ b/drivers/scsi/smartpqi/smartpqi.h
@@ -963,6 +963,7 @@ struct pqi_scsi_dev {
 	struct list_head delete_list_entry;
 
 	atomic_t scsi_cmds_outstanding;
+	atomic_t raid_bypass_cnt;
 };
 
 /* VPD inquiry pages */
diff --git a/drivers/scsi/smartpqi/smartpqi_init.c b/drivers/scsi/smartpqi/smartpqi_init.c
index 059b96ac846b..392d00cbef22 100644
--- a/drivers/scsi/smartpqi/smartpqi_init.c
+++ b/drivers/scsi/smartpqi/smartpqi_init.c
@@ -5377,19 +5377,18 @@ static int pqi_scsi_queue_command(struct Scsi_Host *shost,
 			!blk_rq_is_passthrough(scmd->request)) {
 			rc = pqi_raid_bypass_submit_scsi_cmd(ctrl_info, device,
 				scmd, queue_group);
-			if (rc == 0 || rc == SCSI_MLQUEUE_HOST_BUSY)
+			if (rc == 0 || rc == SCSI_MLQUEUE_HOST_BUSY) {
 				raid_bypassed = true;
+				atomic_inc(&device->raid_bypass_cnt);
+			}
 		}
 		if (!raid_bypassed)
-			rc = pqi_raid_submit_scsi_cmd(ctrl_info, device, scmd,
-				queue_group);
+			rc = pqi_raid_submit_scsi_cmd(ctrl_info, device, scmd, queue_group);
 	} else {
 		if (device->aio_enabled)
-			rc = pqi_aio_submit_scsi_cmd(ctrl_info, device, scmd,
-				queue_group);
+			rc = pqi_aio_submit_scsi_cmd(ctrl_info, device, scmd, queue_group);
 		else
-			rc = pqi_raid_submit_scsi_cmd(ctrl_info, device, scmd,
-				queue_group);
+			rc = pqi_raid_submit_scsi_cmd(ctrl_info, device, scmd, queue_group);
 	}
 
 out:
@@ -5867,8 +5866,7 @@ static void pqi_slave_destroy(struct scsi_device *sdev)
 	}
 }
 
-static int pqi_getpciinfo_ioctl(struct pqi_ctrl_info *ctrl_info,
-	void __user *arg)
+static int pqi_getpciinfo_ioctl(struct pqi_ctrl_info *ctrl_info, void __user *arg)
 {
 	struct pci_dev *pci_dev;
 	u32 subsystem_vendor;
@@ -5885,8 +5883,7 @@ static int pqi_getpciinfo_ioctl(struct pqi_ctrl_info *ctrl_info,
 	pciinfo.dev_fn = pci_dev->devfn;
 	subsystem_vendor = pci_dev->subsystem_vendor;
 	subsystem_device = pci_dev->subsystem_device;
-	pciinfo.board_id = ((subsystem_device << 16) & 0xffff0000) |
-		subsystem_vendor;
+	pciinfo.board_id = ((subsystem_device << 16) & 0xffff0000) | subsystem_vendor;
 
 	if (copy_to_user(arg, &pciinfo, sizeof(pciinfo)))
 		return -EFAULT;
@@ -6295,8 +6292,7 @@ static ssize_t pqi_unique_id_show(struct device *dev,
 
 	device = sdev->hostdata;
 	if (!device) {
-		spin_unlock_irqrestore(&ctrl_info->scsi_device_list_lock,
-			flags);
+		spin_unlock_irqrestore(&ctrl_info->scsi_device_list_lock, flags);
 		return -ENODEV;
 	}
 
@@ -6333,8 +6329,7 @@ static ssize_t pqi_lunid_show(struct device *dev,
 
 	device = sdev->hostdata;
 	if (!device) {
-		spin_unlock_irqrestore(&ctrl_info->scsi_device_list_lock,
-			flags);
+		spin_unlock_irqrestore(&ctrl_info->scsi_device_list_lock, flags);
 		return -ENODEV;
 	}
 
@@ -6369,8 +6364,7 @@ static ssize_t pqi_path_info_show(struct device *dev,
 
 	device = sdev->hostdata;
 	if (!device) {
-		spin_unlock_irqrestore(&ctrl_info->scsi_device_list_lock,
-			flags);
+		spin_unlock_irqrestore(&ctrl_info->scsi_device_list_lock, flags);
 		return -ENODEV;
 	}
 
@@ -6446,9 +6440,8 @@ static ssize_t pqi_sas_address_show(struct device *dev,
 	spin_lock_irqsave(&ctrl_info->scsi_device_list_lock, flags);
 
 	device = sdev->hostdata;
-	if (pqi_is_logical_device(device)) {
-		spin_unlock_irqrestore(&ctrl_info->scsi_device_list_lock,
-			flags);
+	if (!device || !pqi_is_device_with_sas_address(device)) {
+		spin_unlock_irqrestore(&ctrl_info->scsi_device_list_lock, flags);
 		return -ENODEV;
 	}
 
@@ -6473,6 +6466,11 @@ static ssize_t pqi_ssd_smart_path_enabled_show(struct device *dev,
 	spin_lock_irqsave(&ctrl_info->scsi_device_list_lock, flags);
 
 	device = sdev->hostdata;
+	if (!device) {
+		spin_unlock_irqrestore(&ctrl_info->scsi_device_list_lock, flags);
+		return -ENODEV;
+	}
+
 	buffer[0] = device->raid_bypass_enabled ? '1' : '0';
 	buffer[1] = '\n';
 	buffer[2] = '\0';
@@ -6497,6 +6495,10 @@ static ssize_t pqi_raid_level_show(struct device *dev,
 	spin_lock_irqsave(&ctrl_info->scsi_device_list_lock, flags);
 
 	device = sdev->hostdata;
+	if (!device) {
+		spin_unlock_irqrestore(&ctrl_info->scsi_device_list_lock, flags);
+		return -ENODEV;
+	}
 
 	if (pqi_is_logical_device(device))
 		raid_level = pqi_raid_level_to_string(device->raid_level);
@@ -6508,13 +6510,40 @@ static ssize_t pqi_raid_level_show(struct device *dev,
 	return snprintf(buffer, PAGE_SIZE, "%s\n", raid_level);
 }
 
+static ssize_t pqi_raid_bypass_cnt_show(struct device *dev,
+	struct device_attribute *attr, char *buffer)
+{
+	struct pqi_ctrl_info *ctrl_info;
+	struct scsi_device *sdev;
+	struct pqi_scsi_dev *device;
+	unsigned long flags;
+	int raid_bypass_cnt;
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
+	raid_bypass_cnt = atomic_read(&device->raid_bypass_cnt);
+
+	spin_unlock_irqrestore(&ctrl_info->scsi_device_list_lock, flags);
+
+	return snprintf(buffer, PAGE_SIZE, "0x%x\n", raid_bypass_cnt);
+}
+
 static DEVICE_ATTR(lunid, 0444, pqi_lunid_show, NULL);
 static DEVICE_ATTR(unique_id, 0444, pqi_unique_id_show, NULL);
 static DEVICE_ATTR(path_info, 0444, pqi_path_info_show, NULL);
 static DEVICE_ATTR(sas_address, 0444, pqi_sas_address_show, NULL);
-static DEVICE_ATTR(ssd_smart_path_enabled, 0444,
-	pqi_ssd_smart_path_enabled_show, NULL);
+static DEVICE_ATTR(ssd_smart_path_enabled, 0444, pqi_ssd_smart_path_enabled_show, NULL);
 static DEVICE_ATTR(raid_level, 0444, pqi_raid_level_show, NULL);
+static DEVICE_ATTR(raid_bypass_cnt, 0444, pqi_raid_bypass_cnt_show, NULL);
 
 static struct device_attribute *pqi_sdev_attrs[] = {
 	&dev_attr_lunid,
@@ -6523,6 +6552,7 @@ static struct device_attribute *pqi_sdev_attrs[] = {
 	&dev_attr_sas_address,
 	&dev_attr_ssd_smart_path_enabled,
 	&dev_attr_raid_level,
+	&dev_attr_raid_bypass_cnt,
 	NULL
 };
 
@@ -8539,8 +8569,7 @@ static int __init pqi_init(void)
 
 	pr_info(DRIVER_NAME "\n");
 
-	pqi_sas_transport_template =
-		sas_attach_transport(&pqi_sas_transport_functions);
+	pqi_sas_transport_template = sas_attach_transport(&pqi_sas_transport_functions);
 	if (!pqi_sas_transport_template)
 		return -ENODEV;
 

