Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 84F90CCA47B
	for <linux-scsi@archiver.kernel.org>; Fri,  8 Jul 2022 18:47:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239682AbiGHSrL (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 8 Jul 2022 14:47:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39430 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239132AbiGHSrK (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 8 Jul 2022 14:47:10 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6FE0E796BF
        for <linux-scsi@vger.kernel.org>; Fri,  8 Jul 2022 11:47:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1657306029; x=1688842029;
  h=subject:from:to:cc:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=QuCbbpl7sCEQeP5cBnTlhO3tF+AhwUOxr3eKPGSOmsQ=;
  b=fj6F9vBxXQX5O0cQqHHtyyq3h7cZ+X4SGP2hQq4mkkc+Zmdk/aSt2Mg4
   9GPxVyDDHoBLZh6EMyU4+1rEo74Bx7nGAcQc5lY7OZCTZS7rrCh6NDPIi
   3NWTANYdBmrwilZRKhv3YeAMdg40bFvzjS5p4bFohyuAVbYTAlAAXSTT1
   WfckiObzTr28NG9tIRjs/C99E9cjPIJKmiMqdkkem3pM6EMn0OEJXD4lm
   NBYgdyF2YDUSf0E77xSUmcH0tExok9IstyZDLYnWWj2Kct7Apk3Zyig8p
   Bw59IxcrR+AL2gs3KE1mJfwZtjJaW86L/Ys26xBx+83syIz2mdg9BKL0b
   Q==;
X-IronPort-AV: E=Sophos;i="5.92,256,1650956400"; 
   d="scan'208";a="163971205"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa4.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 08 Jul 2022 11:46:59 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Fri, 8 Jul 2022 11:46:44 -0700
Received: from brunhilda.pdev.net (10.10.115.15) by chn-vm-ex01.mchp-main.com
 (10.10.85.143) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.17 via Frontend
 Transport; Fri, 8 Jul 2022 11:46:44 -0700
Received: from brunhilda.pdev.net (localhost [127.0.0.1])
        by brunhilda.pdev.net (8.15.2/8.15.2/Debian-22ubuntu3) with ESMTP id 268IlpSL177491;
        Fri, 8 Jul 2022 13:47:51 -0500
Received: (from brace@localhost)
        by brunhilda.pdev.net (8.15.2/8.15.2/Submit) id 268Ilpu9177490;
        Fri, 8 Jul 2022 13:47:51 -0500
X-Authentication-Warning: brunhilda.pdev.net: brace set sender to don.brace@microchip.com using -f
Subject: [PATCH V2 13/16] smartpqi: update deleting a LUN via sysfs
From:   Don Brace <don.brace@microchip.com>
To:     <Kevin.Barnett@microchip.com>, <scott.teel@microchip.com>,
        <Justin.Lindley@microchip.com>, <scott.benesh@microchip.com>,
        <gerry.morong@microchip.com>, <mahesh.rajashekhara@microchip.com>,
        <mike.mcgowen@microchip.com>, <murthy.bhat@microchip.com>,
        <kumar.meiyappan@microchip.com>, <hch@infradead.org>,
        <jejb@linux.vnet.ibm.com>, <joseph.szczypek@hpe.com>,
        <POSWALD@suse.com>
CC:     <linux-scsi@vger.kernel.org>
Date:   Fri, 8 Jul 2022 13:47:51 -0500
Message-ID: <165730607154.177165.9723066932202995774.stgit@brunhilda>
In-Reply-To: <165730597930.177165.11663580730429681919.stgit@brunhilda>
References: <165730597930.177165.11663580730429681919.stgit@brunhilda>
User-Agent: StGit/1.5.dev2+g9ce680a52bd9
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Kevin Barnett <kevin.barnett@microchip.com>

Change removing a LUN using sysfs from an internal driver function
pqi_remove_all_scsi_devices() to using the .slave_destroy entry in
the scsi_host_template.

A LUN can be deleted via sysfs using this syntax:

echo 1 > /sys/block/sdX/device/delete

Reviewed-by: Scott Teel <scott.teel@microchip.com>
Reviewed-by: Mike McGowen <mike.mcgowen@microchip.com>
Signed-off-by: Kevin Barnett <kevin.barnett@microchip.com>
Signed-off-by: Don Brace <don.brace@microchip.com>
---
 drivers/scsi/smartpqi/smartpqi_init.c |   48 +++++++++++++++++++++------------
 1 file changed, 30 insertions(+), 18 deletions(-)

diff --git a/drivers/scsi/smartpqi/smartpqi_init.c b/drivers/scsi/smartpqi/smartpqi_init.c
index 2df1e8453029..122772628a2f 100644
--- a/drivers/scsi/smartpqi/smartpqi_init.c
+++ b/drivers/scsi/smartpqi/smartpqi_init.c
@@ -2536,23 +2536,6 @@ static int pqi_update_scsi_devices(struct pqi_ctrl_info *ctrl_info)
 	return rc;
 }
 
-static void pqi_remove_all_scsi_devices(struct pqi_ctrl_info *ctrl_info)
-{
-	unsigned long flags;
-	struct pqi_scsi_dev *device;
-	struct pqi_scsi_dev *next;
-
-	list_for_each_entry_safe(device, next, &ctrl_info->scsi_device_list,
-		scsi_device_list_entry) {
-		if (pqi_is_device_added(device))
-			pqi_remove_device(ctrl_info, device);
-		spin_lock_irqsave(&ctrl_info->scsi_device_list_lock, flags);
-		list_del(&device->scsi_device_list_entry);
-		pqi_free_device(device);
-		spin_unlock_irqrestore(&ctrl_info->scsi_device_list_lock, flags);
-	}
-}
-
 static int pqi_scan_scsi_devices(struct pqi_ctrl_info *ctrl_info)
 {
 	int rc;
@@ -6476,6 +6459,35 @@ static int pqi_slave_configure(struct scsi_device *sdev)
 	return rc;
 }
 
+static void pqi_slave_destroy(struct scsi_device *sdev)
+{
+	struct pqi_ctrl_info *ctrl_info;
+	struct pqi_scsi_dev *device;
+	int mutex_acquired;
+	unsigned long flags;
+
+	ctrl_info = shost_to_hba(sdev->host);
+
+	mutex_acquired = mutex_trylock(&ctrl_info->scan_mutex);
+	if (!mutex_acquired)
+		return;
+
+	device = sdev->hostdata;
+	if (!device) {
+		mutex_unlock(&ctrl_info->scan_mutex);
+		return;
+	}
+
+	spin_lock_irqsave(&ctrl_info->scsi_device_list_lock, flags);
+	list_del(&device->scsi_device_list_entry);
+	spin_unlock_irqrestore(&ctrl_info->scsi_device_list_lock, flags);
+
+	mutex_unlock(&ctrl_info->scan_mutex);
+
+	pqi_dev_info(ctrl_info, "removed", device);
+	pqi_free_device(device);
+}
+
 static int pqi_getpciinfo_ioctl(struct pqi_ctrl_info *ctrl_info, void __user *arg)
 {
 	struct pci_dev *pci_dev;
@@ -7363,6 +7375,7 @@ static struct scsi_host_template pqi_driver_template = {
 	.ioctl = pqi_ioctl,
 	.slave_alloc = pqi_slave_alloc,
 	.slave_configure = pqi_slave_configure,
+	.slave_destroy = pqi_slave_destroy,
 	.map_queues = pqi_map_queues,
 	.sdev_groups = pqi_sdev_groups,
 	.shost_groups = pqi_shost_groups,
@@ -8649,7 +8662,6 @@ static void pqi_remove_ctrl(struct pqi_ctrl_info *ctrl_info)
 		pqi_fail_all_outstanding_requests(ctrl_info);
 		ctrl_info->pqi_mode_enabled = false;
 	}
-	pqi_remove_all_scsi_devices(ctrl_info);
 	pqi_unregister_scsi(ctrl_info);
 	if (ctrl_info->pqi_mode_enabled)
 		pqi_revert_to_sis_mode(ctrl_info);

