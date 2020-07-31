Return-Path: <SRS0=WBt/=BK=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.0 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A0974C433DF
	for <linux-scsi@archiver.kernel.org>; Fri, 31 Jul 2020 21:01:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 81FC722B42
	for <linux-scsi@archiver.kernel.org>; Fri, 31 Jul 2020 21:01:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729120AbgGaVBl (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 31 Jul 2020 17:01:41 -0400
Received: from esa2.microchip.iphmx.com ([68.232.149.84]:47361 "EHLO
        esa2.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729043AbgGaVBl (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 31 Jul 2020 17:01:41 -0400
IronPort-SDR: KtPal0viYlcY1nuMZiAo2lHC4792BAD6bUcu2ALM9zXiOuK7ZxYAqj/Y0T634PI38yXhtacBO9
 50KE49QnWITreEHmARGj0YYVWIe8m9KuP6X7+eH6yHMu1Qha8/9aC+rZe6b/ICBzUYNmo4cO6V
 3BaftkGCWmejeAUrGg4SrSef7ivq++FXhZfC3hCMgZR+0PDB7+TuJzRP6zfCeNFuQTbfM8+kdP
 MG0dZnEIdbka1OB+Df1p0eRQ1KuBCXTmpPgbR5gsZPPhZOuHWzeKb5MNM5wb+r4XCXZW4ZGkAw
 V5c=
X-IronPort-AV: E=Sophos;i="5.75,419,1589266800"; 
   d="scan'208";a="84056422"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa2.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 31 Jul 2020 14:01:39 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Fri, 31 Jul 2020 14:01:38 -0700
Received: from [127.0.1.1] (10.10.115.15) by chn-vm-ex01.mchp-main.com
 (10.10.85.143) with Microsoft SMTP Server id 15.1.1979.3 via Frontend
 Transport; Fri, 31 Jul 2020 14:01:37 -0700
Subject: [PATCH 5/7] smartpqi: support device deletion via sysfs
From:   Don Brace <don.brace@microsemi.com>
To:     <Kevin.Barnett@microchip.com>, <scott.teel@microchip.com>,
        <Justin.Lindley@microchip.com>, <scott.benesh@microchip.com>,
        <bader.alisaleh@microchip.com>, <gerry.morong@microchip.com>,
        <mahesh.rajashekhara@microchip.com>, <hch@infradead.org>,
        <jejb@linux.vnet.ibm.com>, <joseph.szczypek@hpe.com>,
        <POSWALD@suse.com>
CC:     <linux-scsi@vger.kernel.org>
Date:   Fri, 31 Jul 2020 16:01:38 -0500
Message-ID: <159622929885.30579.2727491506675011534.stgit@brunhilda>
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

- Support device deletion via sysfs.
  I.E: echo 1 > /sys/block/sd<X>/device/delete

Reviewed-by: Scott Teel <scott.teel@microsemi.com>
Reviewed-by: Scott Benesh <scott.benesh@microsemi.com>
Signed-off-by: Kevin Barnett <kevin.barnett@microsemi.com>
Signed-off-by: Don Brace <don.brace@microsemi.com>
---
 drivers/scsi/smartpqi/smartpqi_init.c |   92 +++++++++++++++------------------
 1 file changed, 43 insertions(+), 49 deletions(-)

diff --git a/drivers/scsi/smartpqi/smartpqi_init.c b/drivers/scsi/smartpqi/smartpqi_init.c
index d6a92de555c8..059b96ac846b 100644
--- a/drivers/scsi/smartpqi/smartpqi_init.c
+++ b/drivers/scsi/smartpqi/smartpqi_init.c
@@ -1531,11 +1531,10 @@ static inline void pqi_remove_device(struct pqi_ctrl_info *ctrl_info,
 
 	pqi_device_remove_start(device);
 
-	rc = pqi_device_wait_for_pending_io(ctrl_info, device,
-		PQI_PENDING_IO_TIMEOUT_SECS);
+	rc = pqi_device_wait_for_pending_io(ctrl_info, device, PQI_PENDING_IO_TIMEOUT_SECS);
 	if (rc)
 		dev_err(&ctrl_info->pci_dev->dev,
-			"scsi %d:%d:%d:%d removing device with %d outstanding commands\n",
+			"scsi %d:%d:%d:%d removing device with %d outstanding command(s)\n",
 			ctrl_info->scsi_host->host_no, device->bus,
 			device->target, device->lun,
 			atomic_read(&device->scsi_cmds_outstanding));
@@ -1553,10 +1552,8 @@ static struct pqi_scsi_dev *pqi_find_scsi_dev(struct pqi_ctrl_info *ctrl_info,
 {
 	struct pqi_scsi_dev *device;
 
-	list_for_each_entry(device, &ctrl_info->scsi_device_list,
-		scsi_device_list_entry)
-		if (device->bus == bus && device->target == target &&
-			device->lun == lun)
+	list_for_each_entry(device, &ctrl_info->scsi_device_list, scsi_device_list_entry)
+		if (device->bus == bus && device->target == target && device->lun == lun)
 			return device;
 
 	return NULL;
@@ -1582,15 +1579,12 @@ enum pqi_find_result {
 };
 
 static enum pqi_find_result pqi_scsi_find_entry(struct pqi_ctrl_info *ctrl_info,
-	struct pqi_scsi_dev *device_to_find,
-	struct pqi_scsi_dev **matching_device)
+	struct pqi_scsi_dev *device_to_find, struct pqi_scsi_dev **matching_device)
 {
 	struct pqi_scsi_dev *device;
 
-	list_for_each_entry(device, &ctrl_info->scsi_device_list,
-		scsi_device_list_entry) {
-		if (pqi_scsi3addr_equal(device_to_find->scsi3addr,
-			device->scsi3addr)) {
+	list_for_each_entry(device, &ctrl_info->scsi_device_list, scsi_device_list_entry) {
+		if (pqi_scsi3addr_equal(device_to_find->scsi3addr, device->scsi3addr)) {
 			*matching_device = device;
 			if (pqi_device_equal(device_to_find, device)) {
 				if (device_to_find->volume_offline)
@@ -1790,8 +1784,7 @@ static void pqi_update_device_list(struct pqi_ctrl_info *ctrl_info,
 	spin_lock_irqsave(&ctrl_info->scsi_device_list_lock, flags);
 
 	/* Assume that all devices in the existing list have gone away. */
-	list_for_each_entry(device, &ctrl_info->scsi_device_list,
-		scsi_device_list_entry)
+	list_for_each_entry(device, &ctrl_info->scsi_device_list, scsi_device_list_entry)
 		device->device_gone = true;
 
 	for (i = 0; i < num_new_devices; i++) {
@@ -1831,7 +1824,7 @@ static void pqi_update_device_list(struct pqi_ctrl_info *ctrl_info,
 	list_for_each_entry_safe(device, next, &ctrl_info->scsi_device_list,
 		scsi_device_list_entry) {
 		if (device->device_gone) {
-			list_del(&device->scsi_device_list_entry);
+			list_del_init(&device->scsi_device_list_entry);
 			list_add_tail(&device->delete_list_entry, &delete_list);
 		}
 	}
@@ -1856,18 +1849,19 @@ static void pqi_update_device_list(struct pqi_ctrl_info *ctrl_info,
 		pqi_ctrl_ofa_done(ctrl_info);
 
 	/* Remove all devices that have gone away. */
-	list_for_each_entry_safe(device, next, &delete_list,
-		delete_list_entry) {
+	list_for_each_entry_safe(device, next, &delete_list, delete_list_entry) {
 		if (device->volume_offline) {
 			pqi_dev_info(ctrl_info, "offline", device);
 			pqi_show_volume_status(ctrl_info, device);
-		} else {
-			pqi_dev_info(ctrl_info, "removed", device);
 		}
-		if (pqi_is_device_added(device))
-			pqi_remove_device(ctrl_info, device);
 		list_del(&device->delete_list_entry);
-		pqi_free_device(device);
+		if (pqi_is_device_added(device)) {
+			pqi_remove_device(ctrl_info, device);
+		} else {
+			if (!device->volume_offline)
+				pqi_dev_info(ctrl_info, "removed", device);
+			pqi_free_device(device);
+		}
 	}
 
 	/*
@@ -2158,31 +2152,6 @@ static int pqi_update_scsi_devices(struct pqi_ctrl_info *ctrl_info)
 	return rc;
 }
 
-static void pqi_remove_all_scsi_devices(struct pqi_ctrl_info *ctrl_info)
-{
-	unsigned long flags;
-	struct pqi_scsi_dev *device;
-
-	while (1) {
-		spin_lock_irqsave(&ctrl_info->scsi_device_list_lock, flags);
-
-		device = list_first_entry_or_null(&ctrl_info->scsi_device_list,
-			struct pqi_scsi_dev, scsi_device_list_entry);
-		if (device)
-			list_del(&device->scsi_device_list_entry);
-
-		spin_unlock_irqrestore(&ctrl_info->scsi_device_list_lock,
-			flags);
-
-		if (!device)
-			break;
-
-		if (pqi_is_device_added(device))
-			pqi_remove_device(ctrl_info, device);
-		pqi_free_device(device);
-	}
-}
-
 static int pqi_scan_scsi_devices(struct pqi_ctrl_info *ctrl_info)
 {
 	int rc = 0;
@@ -5873,6 +5842,31 @@ static int pqi_slave_configure(struct scsi_device *sdev)
 	return 0;
 }
 
+static void pqi_slave_destroy(struct scsi_device *sdev)
+{
+	unsigned long flags;
+	struct pqi_scsi_dev *device;
+	struct pqi_ctrl_info *ctrl_info;
+
+	ctrl_info = shost_to_hba(sdev->host);
+
+	spin_lock_irqsave(&ctrl_info->scsi_device_list_lock, flags);
+
+	device = sdev->hostdata;
+	if (device) {
+		sdev->hostdata = NULL;
+		if (!list_empty(&device->scsi_device_list_entry))
+			list_del(&device->scsi_device_list_entry);
+	}
+
+	spin_unlock_irqrestore(&ctrl_info->scsi_device_list_lock, flags);
+
+	if (device) {
+		pqi_dev_info(ctrl_info, "removed", device);
+		pqi_free_device(device);
+	}
+}
+
 static int pqi_getpciinfo_ioctl(struct pqi_ctrl_info *ctrl_info,
 	void __user *arg)
 {
@@ -6544,6 +6538,7 @@ static struct scsi_host_template pqi_driver_template = {
 	.ioctl = pqi_ioctl,
 	.slave_alloc = pqi_slave_alloc,
 	.slave_configure = pqi_slave_configure,
+	.slave_destroy = pqi_slave_destroy,
 	.map_queues = pqi_map_queues,
 	.sdev_attrs = pqi_sdev_attrs,
 	.shost_attrs = pqi_shost_attrs,
@@ -7630,7 +7625,6 @@ static void pqi_remove_ctrl(struct pqi_ctrl_info *ctrl_info)
 {
 	pqi_cancel_rescan_worker(ctrl_info);
 	pqi_cancel_update_time_worker(ctrl_info);
-	pqi_remove_all_scsi_devices(ctrl_info);
 	pqi_unregister_scsi(ctrl_info);
 	if (ctrl_info->pqi_mode_enabled)
 		pqi_revert_to_sis_mode(ctrl_info);

