Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4294634C134
	for <linux-scsi@vger.kernel.org>; Thu,  6 Nov 2025 16:40:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=68.232.154.123
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762447216; cv=none; b=SCj691m+2eJbsWULoAW+WwFC4IeQbqI205wnFM7fEHU/utqI9ggF854OxT5SKUYVxt5huFCleDrpHRrpgzqKYS3l7eqteN/i5liAvPP2b/RV9a8o0RGqqiQ1qmKDIDMt/X8+CiPLYcGkyavEWGqVh96R4xkvnvWb/ilzpnz/GPo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762447216; c=relaxed/simple;
	bh=4irQaHbgvx31lPEmHilH/zL3lNcnsHA8ufbHy/sIHwc=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=OS04TSQmanSYRWxqJlMRZ22vLjbsVHJST5vkJa90ZWR6PT97gEkVURrLw9MlImLFpqWd2PnLtOHCSuyavGc5ncVvtN6kXmSD0FAYRvShAdLlWVqO/VSjOSUzup8FbiNr5lsUs3ZsL73W/kVHpF7yQtNAsdv++G3iGij1GcQSkPY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=microchip.com; spf=pass smtp.mailfrom=microchip.com; dkim=pass (2048-bit key) header.d=microchip.com header.i=@microchip.com header.b=Zln3XC7u; arc=none smtp.client-ip=68.232.154.123
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=microchip.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=microchip.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=microchip.com header.i=@microchip.com header.b="Zln3XC7u"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1762447214; x=1793983214;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=4irQaHbgvx31lPEmHilH/zL3lNcnsHA8ufbHy/sIHwc=;
  b=Zln3XC7u5PBkPD+OHon5Gt9WKEe0yCWm2QqWDCYrombq4ByoGCyJvbNj
   yItlqoIO2bMk9ClEzphI6uH142Fl1qjHmOmJxygq4t7GOJSVyXMpBkiky
   O1pvEUMO2ZuJZsAWUlSGZRplj6Ozoe6/HUBBtnqHx8jpZEOFqbu33wdWI
   2wZ83ZOkD9frjP+ezDVgUq9qOgGUtElnvuJpuum8/aDZMB73GEalvWzRp
   gMRlNr0fUJh/3eCqtOcd4d+VpPJ5tGoYqYW9USK6tRc9lHkIzYHBlf7mP
   SGSxkHRlIvSOlWueNhUH5o+pTB4G9fhMEl4I0RQI2L312Rkg4wR9yitlh
   w==;
X-CSE-ConnectionGUID: 8munH+RCTFmmLDLy0P7ocg==
X-CSE-MsgGUID: U6WbG/sMQNeVC4Bwe/6d9A==
X-IronPort-AV: E=Sophos;i="6.19,284,1754982000"; 
   d="scan'208";a="48142643"
X-Amp-Result: SKIPPED(no attachment in message)
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa4.microchip.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Nov 2025 09:39:04 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.87.152) by
 chn-vm-ex1.mchp-main.com (10.10.87.30) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.2.2562.29; Thu, 6 Nov 2025 09:38:26 -0700
Received: from brunhilda.pdev.net (10.10.85.11) by chn-vm-ex03.mchp-main.com
 (10.10.85.151) with Microsoft SMTP Server id 15.1.2507.58 via Frontend
 Transport; Thu, 6 Nov 2025 09:38:25 -0700
From: Don Brace <don.brace@microchip.com>
To: <don.brace@microchip.com>, <scott.teel@microchip.com>,
	<scott.benesh@microchip.com>, <gerry.morong@microchip.com>,
	<mahesh.rajashekhara@microchip.com>, <mike.mcgowen@microchip.com>,
	<murthy.bhat@microchip.com>, <kumar.meiyappan@microchip.com>,
	<jeremy.reeves@microchip.com>, <david.strahan@microchip.com>,
	<hch@infradead.org>, <James.Bottomley@HansenPartnership.com>,
	<martin.petersen@oracle.com>, <joseph.szczypek@hpe.com>, <POSWALD@suse.com>,
	<cameron.cumberland@suse.com>, Yi Zhang <yi.zhang@redhat.com>
CC: <linux-scsi@vger.kernel.org>
Subject: [PATCH 2/4] smartpqi: Fix device resources accessed after device removal
Date: Thu, 6 Nov 2025 10:38:20 -0600
Message-ID: <20251106163823.786828-3-don.brace@microchip.com>
X-Mailer: git-send-email 2.52.0.rc0.28.g4cf919bd7b
In-Reply-To: <20251106163823.786828-1-don.brace@microchip.com>
References: <20251106163823.786828-1-don.brace@microchip.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Organization: Microchip Technology Inc.
Content-Transfer-Encoding: 8bit
Content-Type: text/plain

From: Mike McGowen <mike.mcgowen@microchip.com>

Correct possible race conditions during device removal.

Previously, a scheduled work item to reset a LUN could still execute after
the device was removed, leading to use-after-free and other resource
access issues.

This race condition occurs because the abort handler may schedule a LUN
reset concurrently with device removal via sdev_destroy(), leading to
use-after-free and improper access to freed resources.

This patch:

  - Checks in the device reset handler if the device is still present in
    the controller's SCSI device list before running; if not, the reset
    is skipped.
  - Cancels any pending TMF work that has not started in sdev_destroy().
  - Ensures device freeing in sdev_destroy() is done while holding the LUN
    reset mutex to avoid races with ongoing resets.

Fixes: 2d80f4054f7f ("scsi: smartpqi: Update deleting a LUN via sysfs")

Reviewed-by: Scott Teel <scott.teel@microchip.com>
Reviewed-by: Scott Benesh <scott.benesh@microchip.com>
Signed-off-by: Mike McGowen <mike.mcgowen@microchip.com>
Signed-off-by: Don Brace <don.brace@microchip.com>
---
 drivers/scsi/smartpqi/smartpqi_init.c | 19 +++++++++++++++++++
 1 file changed, 19 insertions(+)

diff --git a/drivers/scsi/smartpqi/smartpqi_init.c b/drivers/scsi/smartpqi/smartpqi_init.c
index f5fb262e9c03..8c4ea4dc5803 100644
--- a/drivers/scsi/smartpqi/smartpqi_init.c
+++ b/drivers/scsi/smartpqi/smartpqi_init.c
@@ -6427,10 +6427,22 @@ static int pqi_device_reset(struct pqi_ctrl_info *ctrl_info, struct pqi_scsi_dev
 
 static int pqi_device_reset_handler(struct pqi_ctrl_info *ctrl_info, struct pqi_scsi_dev *device, u8 lun, struct scsi_cmnd *scmd, u8 scsi_opcode)
 {
+	unsigned long flags;
 	int rc;
 
 	mutex_lock(&ctrl_info->lun_reset_mutex);
 
+	spin_lock_irqsave(&ctrl_info->scsi_device_list_lock, flags);
+	if (pqi_find_scsi_dev(ctrl_info, device->bus, device->target, device->lun) == NULL) {
+		dev_warn(&ctrl_info->pci_dev->dev,
+			"skipping reset of scsi %d:%d:%d:%u, device has been removed\n",
+			ctrl_info->scsi_host->host_no, device->bus, device->target, device->lun);
+		spin_unlock_irqrestore(&ctrl_info->scsi_device_list_lock, flags);
+		mutex_unlock(&ctrl_info->lun_reset_mutex);
+		return 0;
+	}
+	spin_unlock_irqrestore(&ctrl_info->scsi_device_list_lock, flags);
+
 	dev_err(&ctrl_info->pci_dev->dev,
 		"resetting scsi %d:%d:%d:%u SCSI cmd at %p due to cmd opcode 0x%02x\n",
 		ctrl_info->scsi_host->host_no, device->bus, device->target, lun, scmd, scsi_opcode);
@@ -6611,7 +6623,9 @@ static void pqi_sdev_destroy(struct scsi_device *sdev)
 {
 	struct pqi_ctrl_info *ctrl_info;
 	struct pqi_scsi_dev *device;
+	struct pqi_tmf_work *tmf_work;
 	int mutex_acquired;
+	unsigned int lun;
 	unsigned long flags;
 
 	ctrl_info = shost_to_hba(sdev->host);
@@ -6638,8 +6652,13 @@ static void pqi_sdev_destroy(struct scsi_device *sdev)
 
 	mutex_unlock(&ctrl_info->scan_mutex);
 
+	for (lun = 0, tmf_work = device->tmf_work; lun < PQI_MAX_LUNS_PER_DEVICE; lun++, tmf_work++)
+		cancel_work_sync(&tmf_work->work_struct);
+
+	mutex_lock(&ctrl_info->lun_reset_mutex);
 	pqi_dev_info(ctrl_info, "removed", device);
 	pqi_free_device(device);
+	mutex_unlock(&ctrl_info->lun_reset_mutex);
 }
 
 static int pqi_getpciinfo_ioctl(struct pqi_ctrl_info *ctrl_info, void __user *arg)
-- 
2.52.0.rc0.28.g4cf919bd7b

