Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 05459C43334
	for <linux-scsi@archiver.kernel.org>; Fri,  8 Jul 2022 18:46:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239660AbiGHSqP (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 8 Jul 2022 14:46:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38352 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239647AbiGHSqL (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 8 Jul 2022 14:46:11 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AFD2B4507A
        for <linux-scsi@vger.kernel.org>; Fri,  8 Jul 2022 11:46:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1657305969; x=1688841969;
  h=subject:from:to:cc:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=tDPJH4Nh2wzTPRnGVmDsWDFs5/bDxQbw44tPrblcwDA=;
  b=gCVdV5PzpEQeNF59ddazFLwSHk9Zwbe7DDsRPhJmk1EeRS7eENhhZRo4
   yNbmpBsUqUWJtf5ER5g5V9eiJbrkRKanIk+hB2ACyDmH3A72XQFqEJlJV
   v7qeZ55uqnOc3EIHGdO+aVXTIfVnEjBSDNLzoSIkViaCFj0u0/Gmi8a7O
   3k43yBdBl80IgYevEveuS1iXcxdjy/7W35G/E5q4yu4pPX6xBEnQ65QBb
   xQnBy6rYBMPOkeY7fFb/OT1+oXcCcUSVCa/EZwecn6fTwYjms+ea1HD5U
   6NpLu/5eFU9+Q1LzbpDgOecnuVcg96H2bSKg7liq2GvT+Y9RxyRbW0A2z
   g==;
X-IronPort-AV: E=Sophos;i="5.92,256,1650956400"; 
   d="scan'208";a="171645963"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa3.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 08 Jul 2022 11:46:09 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Fri, 8 Jul 2022 11:46:08 -0700
Received: from brunhilda.pdev.net (10.10.115.15) by chn-vm-ex03.mchp-main.com
 (10.10.85.151) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.17 via Frontend
 Transport; Fri, 8 Jul 2022 11:46:08 -0700
Received: from brunhilda.pdev.net (localhost [127.0.0.1])
        by brunhilda.pdev.net (8.15.2/8.15.2/Debian-22ubuntu3) with ESMTP id 268IlFLd177344;
        Fri, 8 Jul 2022 13:47:15 -0500
Received: (from brace@localhost)
        by brunhilda.pdev.net (8.15.2/8.15.2/Submit) id 268IlFqQ177343;
        Fri, 8 Jul 2022 13:47:15 -0500
X-Authentication-Warning: brunhilda.pdev.net: brace set sender to don.brace@microchip.com using -f
Subject: [PATCH V2 06/16] smartpqi: fix PCI control linkdown system hang
From:   Don Brace <don.brace@microchip.com>
To:     <Kevin.Barnett@microchip.com>, <scott.teel@microchip.com>,
        <Justin.Lindley@microchip.com>, <scott.benesh@microchip.com>,
        <gerry.morong@microchip.com>, <mahesh.rajashekhara@microchip.com>,
        <mike.mcgowen@microchip.com>, <murthy.bhat@microchip.com>,
        <kumar.meiyappan@microchip.com>, <hch@infradead.org>,
        <jejb@linux.vnet.ibm.com>, <joseph.szczypek@hpe.com>,
        <POSWALD@suse.com>
CC:     <linux-scsi@vger.kernel.org>
Date:   Fri, 8 Jul 2022 13:47:15 -0500
Message-ID: <165730603578.177165.4699352086827187263.stgit@brunhilda>
In-Reply-To: <165730597930.177165.11663580730429681919.stgit@brunhilda>
References: <165730597930.177165.11663580730429681919.stgit@brunhilda>
User-Agent: StGit/1.5.dev2+g9ce680a52bd9
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Sagar Biradar <sagar.biradar@microchip.com>

Fail all outstanding requests after a PCI linkdown.

Block access to device SCSI attributes during the following conditions:
"Cable pull" is called PQI_CTRL_SURPRISE_REMOVAL.
"PCIe Link Down" is called PQI_CTRL_GRACEFUL_REMOVAL.

Block access to device SCSI attributes during and in rare instances when
the controller goes offline.

Either outstanding requests or the access of SCSI attributes post
linkdown can lead to a hang.

Post linkdown, driver does not fail the outstanding requests leading
to long wait time before all the IOs eventually fail.

Also access of the SCSI attributes by host applications can lead to a
system hang.

Reviewed-by: Scott Benesh <scott.benesh@microchip.com>
Reviewed-by: Scott Teel <scott.teel@microchip.com>
Reviewed-by: Mike McGowen <mike.mcgowen@microchip.com>
Reviewed-by: Kevin Barnett <kevin.barnett@microchip.com>
Signed-off-by: Sagar Biradar <sagar.biradar@microchip.com>
Signed-off-by: Don Brace <don.brace@microchip.com>
---
 drivers/scsi/smartpqi/smartpqi.h      |    7 +++++
 drivers/scsi/smartpqi/smartpqi_init.c |   48 ++++++++++++++++++++++++++++++---
 drivers/scsi/smartpqi/smartpqi_sis.c  |    2 +
 3 files changed, 52 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/smartpqi/smartpqi.h b/drivers/scsi/smartpqi/smartpqi.h
index aa8663e1b98b..f1145ded843e 100644
--- a/drivers/scsi/smartpqi/smartpqi.h
+++ b/drivers/scsi/smartpqi/smartpqi.h
@@ -1269,6 +1269,12 @@ struct pqi_event {
 #define PQI_CTRL_PRODUCT_REVISION_A	0
 #define PQI_CTRL_PRODUCT_REVISION_B	1
 
+enum pqi_ctrl_removal_state {
+	PQI_CTRL_PRESENT = 0,
+	PQI_CTRL_GRACEFUL_REMOVAL,
+	PQI_CTRL_SURPRISE_REMOVAL
+};
+
 struct pqi_ctrl_info {
 	unsigned int	ctrl_id;
 	struct pci_dev	*pci_dev;
@@ -1389,6 +1395,7 @@ struct pqi_ctrl_info {
 	struct work_struct ofa_quiesce_work;
 	u32		ofa_bytes_requested;
 	u16		ofa_cancel_reason;
+	enum pqi_ctrl_removal_state ctrl_removal_state;
 };
 
 enum pqi_ctrl_mode {
diff --git a/drivers/scsi/smartpqi/smartpqi_init.c b/drivers/scsi/smartpqi/smartpqi_init.c
index 11a8e224fe84..27b83db3e3dc 100644
--- a/drivers/scsi/smartpqi/smartpqi_init.c
+++ b/drivers/scsi/smartpqi/smartpqi_init.c
@@ -95,6 +95,7 @@ static void pqi_ofa_free_host_buffer(struct pqi_ctrl_info *ctrl_info);
 static int pqi_ofa_host_memory_update(struct pqi_ctrl_info *ctrl_info);
 static int pqi_device_wait_for_pending_io(struct pqi_ctrl_info *ctrl_info,
 	struct pqi_scsi_dev *device, u8 lun, unsigned long timeout_msecs);
+static void pqi_fail_all_outstanding_requests(struct pqi_ctrl_info *ctrl_info);
 
 /* for flags argument to pqi_submit_raid_request_synchronous() */
 #define PQI_SYNC_FLAGS_INTERRUPTABLE	0x1
@@ -6157,9 +6158,11 @@ static int pqi_device_wait_for_pending_io(struct pqi_ctrl_info *ctrl_info,
 	warning_timeout = (PQI_PENDING_IO_WARNING_TIMEOUT_SECS * HZ) + start_jiffies;
 
 	while ((cmds_outstanding = atomic_read(&device->scsi_cmds_outstanding[lun])) > 0) {
-		pqi_check_ctrl_health(ctrl_info);
-		if (pqi_ctrl_offline(ctrl_info))
-			return -ENXIO;
+		if (ctrl_info->ctrl_removal_state != PQI_CTRL_GRACEFUL_REMOVAL) {
+			pqi_check_ctrl_health(ctrl_info);
+			if (pqi_ctrl_offline(ctrl_info))
+				return -ENXIO;
+		}
 		msecs_waiting = jiffies_to_msecs(jiffies - start_jiffies);
 		if (msecs_waiting >= timeout_msecs) {
 			dev_err(&ctrl_info->pci_dev->dev,
@@ -6945,6 +6948,9 @@ static ssize_t pqi_unique_id_show(struct device *dev,
 	sdev = to_scsi_device(dev);
 	ctrl_info = shost_to_hba(sdev->host);
 
+	if (pqi_ctrl_offline(ctrl_info))
+		return -ENODEV;
+
 	spin_lock_irqsave(&ctrl_info->scsi_device_list_lock, flags);
 
 	device = sdev->hostdata;
@@ -6981,6 +6987,9 @@ static ssize_t pqi_lunid_show(struct device *dev,
 	sdev = to_scsi_device(dev);
 	ctrl_info = shost_to_hba(sdev->host);
 
+	if (pqi_ctrl_offline(ctrl_info))
+		return -ENODEV;
+
 	spin_lock_irqsave(&ctrl_info->scsi_device_list_lock, flags);
 
 	device = sdev->hostdata;
@@ -7016,6 +7025,9 @@ static ssize_t pqi_path_info_show(struct device *dev,
 	sdev = to_scsi_device(dev);
 	ctrl_info = shost_to_hba(sdev->host);
 
+	if (pqi_ctrl_offline(ctrl_info))
+		return -ENODEV;
+
 	spin_lock_irqsave(&ctrl_info->scsi_device_list_lock, flags);
 
 	device = sdev->hostdata;
@@ -7093,6 +7105,9 @@ static ssize_t pqi_sas_address_show(struct device *dev,
 	sdev = to_scsi_device(dev);
 	ctrl_info = shost_to_hba(sdev->host);
 
+	if (pqi_ctrl_offline(ctrl_info))
+		return -ENODEV;
+
 	spin_lock_irqsave(&ctrl_info->scsi_device_list_lock, flags);
 
 	device = sdev->hostdata;
@@ -7119,6 +7134,9 @@ static ssize_t pqi_ssd_smart_path_enabled_show(struct device *dev,
 	sdev = to_scsi_device(dev);
 	ctrl_info = shost_to_hba(sdev->host);
 
+	if (pqi_ctrl_offline(ctrl_info))
+		return -ENODEV;
+
 	spin_lock_irqsave(&ctrl_info->scsi_device_list_lock, flags);
 
 	device = sdev->hostdata;
@@ -7148,6 +7166,9 @@ static ssize_t pqi_raid_level_show(struct device *dev,
 	sdev = to_scsi_device(dev);
 	ctrl_info = shost_to_hba(sdev->host);
 
+	if (pqi_ctrl_offline(ctrl_info))
+		return -ENODEV;
+
 	spin_lock_irqsave(&ctrl_info->scsi_device_list_lock, flags);
 
 	device = sdev->hostdata;
@@ -7178,6 +7199,9 @@ static ssize_t pqi_raid_bypass_cnt_show(struct device *dev,
 	sdev = to_scsi_device(dev);
 	ctrl_info = shost_to_hba(sdev->host);
 
+	if (pqi_ctrl_offline(ctrl_info))
+		return -ENODEV;
+
 	spin_lock_irqsave(&ctrl_info->scsi_device_list_lock, flags);
 
 	device = sdev->hostdata;
@@ -7205,6 +7229,9 @@ static ssize_t pqi_sas_ncq_prio_enable_show(struct device *dev,
 	sdev = to_scsi_device(dev);
 	ctrl_info = shost_to_hba(sdev->host);
 
+	if (pqi_ctrl_offline(ctrl_info))
+		return -ENODEV;
+
 	spin_lock_irqsave(&ctrl_info->scsi_device_list_lock, flags);
 
 	device = sdev->hostdata;
@@ -8547,7 +8574,6 @@ static void pqi_free_interrupts(struct pqi_ctrl_info *ctrl_info)
 
 static void pqi_free_ctrl_resources(struct pqi_ctrl_info *ctrl_info)
 {
-	pqi_stop_heartbeat_timer(ctrl_info);
 	pqi_free_interrupts(ctrl_info);
 	if (ctrl_info->queue_memory_base)
 		dma_free_coherent(&ctrl_info->pci_dev->dev,
@@ -8572,8 +8598,15 @@ static void pqi_free_ctrl_resources(struct pqi_ctrl_info *ctrl_info)
 
 static void pqi_remove_ctrl(struct pqi_ctrl_info *ctrl_info)
 {
+	ctrl_info->controller_online = false;
+	pqi_stop_heartbeat_timer(ctrl_info);
+	pqi_ctrl_block_requests(ctrl_info);
 	pqi_cancel_rescan_worker(ctrl_info);
 	pqi_cancel_update_time_worker(ctrl_info);
+	if (ctrl_info->ctrl_removal_state == PQI_CTRL_SURPRISE_REMOVAL) {
+		pqi_fail_all_outstanding_requests(ctrl_info);
+		ctrl_info->pqi_mode_enabled = false;
+	}
 	pqi_remove_all_scsi_devices(ctrl_info);
 	pqi_unregister_scsi(ctrl_info);
 	if (ctrl_info->pqi_mode_enabled)
@@ -8914,11 +8947,18 @@ static int pqi_pci_probe(struct pci_dev *pci_dev,
 static void pqi_pci_remove(struct pci_dev *pci_dev)
 {
 	struct pqi_ctrl_info *ctrl_info;
+	u16 vendor_id;
 
 	ctrl_info = pci_get_drvdata(pci_dev);
 	if (!ctrl_info)
 		return;
 
+	pci_read_config_word(ctrl_info->pci_dev, PCI_SUBSYSTEM_VENDOR_ID, &vendor_id);
+	if (vendor_id == 0xffff)
+		ctrl_info->ctrl_removal_state = PQI_CTRL_SURPRISE_REMOVAL;
+	else
+		ctrl_info->ctrl_removal_state = PQI_CTRL_GRACEFUL_REMOVAL;
+
 	pqi_remove_ctrl(ctrl_info);
 }
 
diff --git a/drivers/scsi/smartpqi/smartpqi_sis.c b/drivers/scsi/smartpqi/smartpqi_sis.c
index 2b99b6e9cd71..59d9c2792371 100644
--- a/drivers/scsi/smartpqi/smartpqi_sis.c
+++ b/drivers/scsi/smartpqi/smartpqi_sis.c
@@ -138,7 +138,7 @@ bool sis_is_firmware_running(struct pqi_ctrl_info *ctrl_info)
 
 	status = readl(&ctrl_info->registers->sis_firmware_status);
 
-	if (status & SIS_CTRL_KERNEL_PANIC)
+	if (status != ~0 && (status & SIS_CTRL_KERNEL_PANIC))
 		running = false;
 	else
 		running = true;

