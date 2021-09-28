Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 08AFBC4332F
	for <linux-scsi@archiver.kernel.org>; Tue, 28 Sep 2021 23:54:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CE6C460C41
	for <linux-scsi@archiver.kernel.org>; Tue, 28 Sep 2021 23:54:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243353AbhI1X41 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 28 Sep 2021 19:56:27 -0400
Received: from esa.microchip.iphmx.com ([68.232.154.123]:25123 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243306AbhI1X4X (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 28 Sep 2021 19:56:23 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1632873283; x=1664409283;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=td7o23GskVfiSY0dO8r9w3EBWzbiNIzAQelElBU1Ij0=;
  b=harIJ4EKEoEETp/hZNYpbTwMzaR7jqCkcb8QONNBW5/t2u3B8LuEb7J9
   XWRq1z9cefFDKZ2NxaaI/PPsRaUls7taK7n4nHIE0/DmXDSFnkMV43nIp
   Akh7T4jFql9rumgg+hTqW8WhyzLvHKggzXUdEiPC4lNlfFd0UAR8FRBC5
   1qLCBGyiEZojH6llHue8Ng5sXVFQfaVo6pASwrnMsOF/88sJG1PlbLk/u
   sDLwv9CecJWX5WxWB6Ot48saH+9fNQjIVvWkOKam8wEP3Ex/gK/J7I5+G
   nnyrOrZDvuPt81QVrAoIPftQPEbv11FLohtd/MKVOZcnn+Rof/ZBdxTsY
   w==;
IronPort-SDR: h3YmqRhU/uBus11I1DSIozoVQA/sQgRTJcKKY4NSO9BtvAr+qUTAhOJwqDA3xctAbsS9HTaJgC
 F3KBMx+D1cmRrx/8HTePjOS0Th2TxL/X9fBQLqetWXWEeC1H621u/PNoZKkFQpXdhbvpeedVqn
 uVH1Yr3pIs9t3bLR/Ey+rveb3mz9pP7Dqt++0E1bsZQMgoW4R0OHe/O1Om8dnUyATXbuQZnTMs
 AZigl/EROpE+RDxn+nuBUqXU1Atf/rnRXdTQquu9f5qE4qyZjYneCbXqG+uSt3EBV4c/gImU53
 f8LoWnDQd+m3a69PmgmEkGdZ
X-IronPort-AV: E=Sophos;i="5.85,330,1624345200"; 
   d="scan'208";a="131019745"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa4.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 28 Sep 2021 16:54:42 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.14; Tue, 28 Sep 2021 16:54:42 -0700
Received: from brunhilda.pdev.net (10.10.115.15) by chn-vm-ex01.mchp-main.com
 (10.10.85.143) with Microsoft SMTP Server id 15.1.2176.14 via Frontend
 Transport; Tue, 28 Sep 2021 16:54:42 -0700
Received: by brunhilda.pdev.net (Postfix, from userid 1467)
        id 5CC7470284F; Tue, 28 Sep 2021 18:54:42 -0500 (CDT)
From:   Don Brace <don.brace@microchip.com>
To:     <hch@infradead.org>, <martin.petersen@oracle.com>,
        <jejb@linux.vnet.ibm.com>, <linux-scsi@vger.kernel.org>
CC:     <Kevin.Barnett@microchip.com>, <scott.teel@microchip.com>,
        <Justin.Lindley@microchip.com>, <scott.benesh@microchip.com>,
        <gerry.morong@microchip.com>, <mahesh.rajashekhara@microchip.com>,
        <mike.mcgowen@microchip.com>, <murthy.bhat@microchip.com>,
        <balsundar.p@microchip.com>, <joseph.szczypek@hpe.com>,
        <jeff@canonical.com>, <POSWALD@suse.com>,
        <john.p.donnelly@oracle.com>, <mwilck@suse.com>,
        <pmenzel@molgen.mpg.de>, <linux-kernel@vger.kernel.org>
Subject: [smartpqi updates PATCH V2 01/11] smartpqi: update device removal management
Date:   Tue, 28 Sep 2021 18:54:32 -0500
Message-ID: <20210928235442.201875-2-don.brace@microchip.com>
X-Mailer: git-send-email 2.28.0.rc1.9.ge7ae437ac1
In-Reply-To: <20210928235442.201875-1-don.brace@microchip.com>
References: <20210928235442.201875-1-don.brace@microchip.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Update device removal path to handle issues for:
  rmmod - Correct stack trace when removing devices.
  rmmod - Synchronize SCSI cache.
  Update handling for removing devices using sysfs.

This patch also aligns the device removal code with
our out-of-box driver.

Reviewed-by: Scott Benesh <scott.benesh@microchip.com>
Reviewed-by: Scott Teel <scott.teel@microchip.com>
Reviewed-by: Mike McGowen <mike.mcgowen@microchip.com>
Signed-off-by: Don Brace <don.brace@microchip.com>
---
 drivers/scsi/smartpqi/smartpqi_init.c | 64 ++++++++++++---------------
 1 file changed, 28 insertions(+), 36 deletions(-)

diff --git a/drivers/scsi/smartpqi/smartpqi_init.c b/drivers/scsi/smartpqi/smartpqi_init.c
index ecb2af3f43ca..97027574eb1f 100644
--- a/drivers/scsi/smartpqi/smartpqi_init.c
+++ b/drivers/scsi/smartpqi/smartpqi_init.c
@@ -1693,8 +1693,6 @@ static inline void pqi_remove_device(struct pqi_ctrl_info *ctrl_info, struct pqi
 {
 	int rc;
 
-	pqi_device_remove_start(device);
-
 	rc = pqi_device_wait_for_pending_io(ctrl_info, device,
 		PQI_REMOVE_DEVICE_PENDING_IO_TIMEOUT_MSECS);
 	if (rc)
@@ -1708,6 +1706,8 @@ static inline void pqi_remove_device(struct pqi_ctrl_info *ctrl_info, struct pqi
 		scsi_remove_device(device->sdev);
 	else
 		pqi_remove_sas_device(device);
+
+	pqi_device_remove_start(device);
 }
 
 /* Assumes the SCSI device list lock is held. */
@@ -1986,7 +1986,7 @@ static void pqi_update_device_list(struct pqi_ctrl_info *ctrl_info,
 	list_for_each_entry_safe(device, next, &ctrl_info->scsi_device_list,
 		scsi_device_list_entry) {
 		if (device->device_gone) {
-			list_del_init(&device->scsi_device_list_entry);
+			list_del(&device->scsi_device_list_entry);
 			list_add_tail(&device->delete_list_entry, &delete_list);
 		}
 	}
@@ -2025,15 +2025,13 @@ static void pqi_update_device_list(struct pqi_ctrl_info *ctrl_info,
 		if (device->volume_offline) {
 			pqi_dev_info(ctrl_info, "offline", device);
 			pqi_show_volume_status(ctrl_info, device);
-		}
-		list_del(&device->delete_list_entry);
-		if (pqi_is_device_added(device)) {
-			pqi_remove_device(ctrl_info, device);
 		} else {
-			if (!device->volume_offline)
-				pqi_dev_info(ctrl_info, "removed", device);
-			pqi_free_device(device);
+			pqi_dev_info(ctrl_info, "removed", device);
 		}
+		if (pqi_is_device_added(device))
+			pqi_remove_device(ctrl_info, device);
+		list_del(&device->delete_list_entry);
+		pqi_free_device(device);
 	}
 
 	/*
@@ -2328,6 +2326,25 @@ static int pqi_update_scsi_devices(struct pqi_ctrl_info *ctrl_info)
 	return rc;
 }
 
+static void pqi_remove_all_scsi_devices(struct pqi_ctrl_info *ctrl_info)
+{
+	unsigned long flags;
+	struct pqi_scsi_dev *device;
+	struct pqi_scsi_dev *next;
+
+	spin_lock_irqsave(&ctrl_info->scsi_device_list_lock, flags);
+
+	list_for_each_entry_safe(device, next, &ctrl_info->scsi_device_list,
+		scsi_device_list_entry) {
+		if (pqi_is_device_added(device))
+			pqi_remove_device(ctrl_info, device);
+		list_del(&device->scsi_device_list_entry);
+		pqi_free_device(device);
+	}
+
+	spin_unlock_irqrestore(&ctrl_info->scsi_device_list_lock, flags);
+}
+
 static int pqi_scan_scsi_devices(struct pqi_ctrl_info *ctrl_info)
 {
 	int rc;
@@ -6120,31 +6137,6 @@ static int pqi_slave_configure(struct scsi_device *sdev)
 	return 0;
 }
 
-static void pqi_slave_destroy(struct scsi_device *sdev)
-{
-	unsigned long flags;
-	struct pqi_scsi_dev *device;
-	struct pqi_ctrl_info *ctrl_info;
-
-	ctrl_info = shost_to_hba(sdev->host);
-
-	spin_lock_irqsave(&ctrl_info->scsi_device_list_lock, flags);
-
-	device = sdev->hostdata;
-	if (device) {
-		sdev->hostdata = NULL;
-		if (!list_empty(&device->scsi_device_list_entry))
-			list_del(&device->scsi_device_list_entry);
-	}
-
-	spin_unlock_irqrestore(&ctrl_info->scsi_device_list_lock, flags);
-
-	if (device) {
-		pqi_dev_info(ctrl_info, "removed", device);
-		pqi_free_device(device);
-	}
-}
-
 static int pqi_getpciinfo_ioctl(struct pqi_ctrl_info *ctrl_info, void __user *arg)
 {
 	struct pci_dev *pci_dev;
@@ -6938,7 +6930,6 @@ static struct scsi_host_template pqi_driver_template = {
 	.ioctl = pqi_ioctl,
 	.slave_alloc = pqi_slave_alloc,
 	.slave_configure = pqi_slave_configure,
-	.slave_destroy = pqi_slave_destroy,
 	.map_queues = pqi_map_queues,
 	.sdev_attrs = pqi_sdev_attrs,
 	.shost_attrs = pqi_shost_attrs,
@@ -8169,6 +8160,7 @@ static void pqi_remove_ctrl(struct pqi_ctrl_info *ctrl_info)
 {
 	pqi_cancel_rescan_worker(ctrl_info);
 	pqi_cancel_update_time_worker(ctrl_info);
+	pqi_remove_all_scsi_devices(ctrl_info);
 	pqi_unregister_scsi(ctrl_info);
 	if (ctrl_info->pqi_mode_enabled)
 		pqi_revert_to_sis_mode(ctrl_info);
-- 
2.28.0.rc1.9.ge7ae437ac1

