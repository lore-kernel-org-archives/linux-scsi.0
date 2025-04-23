Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B417479F5
	for <linux-scsi@vger.kernel.org>; Wed, 23 Apr 2025 18:32:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=68.232.154.123
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745433161; cv=none; b=goiZF8diwPo6x73EJwWytrWh6i9Z6K5IfWZ50+sfDheWdzSXS56bLDPVZ+OewfXPFa10v69ltlWiNJlscWnLFALkfSQAOgp0FWCmsgsMmkZY1RyWBZ1bpRmTgtzPJ079Aax3Byup/mO6HZF9NoIk0HIcvAiyaF8AXgg95Jl/yqA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745433161; c=relaxed/simple;
	bh=kKzhfxanVbNKZFHGAIo+Gl7flgds0DkIag9I8116Nn8=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=nbVn3ElfiT0egBJTNhPNZ0u6/XdwWFaxtiobLWjmDsTgc4PIuh0Fe/H1jsT3a87lKx8k1jDW6jR2zracGQOnWIgP6nxxFiYTKSX1e7jMJ15yK5zFJTKVOXs3bz6LxIY6aF9sVrqhI/K4cxXU3vagsCOWrFY5on8EnK7r/SgnKsU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=microchip.com; spf=pass smtp.mailfrom=microchip.com; dkim=pass (2048-bit key) header.d=microchip.com header.i=@microchip.com header.b=K4Za8k3I; arc=none smtp.client-ip=68.232.154.123
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=microchip.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=microchip.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=microchip.com header.i=@microchip.com header.b="K4Za8k3I"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1745433159; x=1776969159;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=kKzhfxanVbNKZFHGAIo+Gl7flgds0DkIag9I8116Nn8=;
  b=K4Za8k3I3bHHg2Zy1LSD776uF/hwlB0uwot4uBnTU+wFRKjqFTHXc6qu
   TGoQLHjnESHJSiroUYr6tMJx0oDxRR7ZR9DaT7gNO0tbTx452LOJUudbH
   4VBDu54Fr7nUIydkVP/vafmbini2sVwYqoo5Uav6/hb9CDZB4nBLEsVfi
   MN7G+kdVtx7XJX6RadPGtjgTRjG+hV6fTQdI57RAt/lCxQLuQa6GU/9e9
   E4oxulGxqqIfeTnN54hIt+bda2n9DYHlEphGyik5gaU5zLy8EskteNFhn
   3vT+qxfRUB8tS6JzsBNg4shdWgmnQzwBQUdBieGuYzunENjk+LTHy1deo
   Q==;
X-CSE-ConnectionGUID: Vsy3DPLGRV+QHyOkpBwADA==
X-CSE-MsgGUID: 2FNY+nCHR+24OUKj9Eww5A==
X-IronPort-AV: E=Sophos;i="6.15,233,1739862000"; 
   d="scan'208";a="208323914"
X-Amp-Result: SKIPPED(no attachment in message)
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa6.microchip.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 23 Apr 2025 11:32:33 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.44; Wed, 23 Apr 2025 11:32:31 -0700
Received: from brunhilda.pdev.net (10.10.85.11) by chn-vm-ex04.mchp-main.com
 (10.10.85.152) with Microsoft SMTP Server id 15.1.2507.44 via Frontend
 Transport; Wed, 23 Apr 2025 11:32:31 -0700
From: Don Brace <don.brace@microchip.com>
To: <don.brace@microchip.com>, <scott.teel@microchip.com>,
	<scott.benesh@microchip.com>, <gerry.morong@microchip.com>,
	<mahesh.rajashekhara@microchip.com>, <mike.mcgowen@microchip.com>,
	<murthy.bhat@microchip.com>, <kumar.meiyappan@microchip.com>,
	<jeremy.reeves@microchip.com>, <hch@infradead.org>,
	<James.Bottomley@HansenPartnership.com>, <martin.petersen@oracle.com>,
	<joseph.szczypek@hpe.com>, <POSWALD@suse.com>, <cameron.cumberland@suse.com>,
	Yi Zhang <yi.zhang@redhat.com>
CC: <linux-scsi@vger.kernel.org>
Subject: [PATCH 1/5] smartpqi: take drives offline when controller is offline
Date: Wed, 23 Apr 2025 13:32:25 -0500
Message-ID: <20250423183229.538572-2-don.brace@microchip.com>
X-Mailer: git-send-email 2.49.0.391.g4bbb303af6
In-Reply-To: <20250423183229.538572-1-don.brace@microchip.com>
References: <20250423183229.538572-1-don.brace@microchip.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Organization: Microchip Technology Inc.
Content-Transfer-Encoding: 8bit
Content-Type: text/plain

From: David Strahan <david.strahan@microchip.com>

When the controller is unexpectedly taken offline, show its drives
as offline.

During a controller lockup, the physical and logical drives under the
locked up controller are still listed at the OS level.

I.E.
The controller is offline but the status of each drive is 'running'.

Reviewed-by: Scott Benesh <scott.benesh@microchip.com>
Reviewed-by: Mike McGowen <mike.mcgowen@microchip.com>
Signed-off-by: David Strahan <david.strahan@microchip.com>
Co-developed-by: Don Brace <don.brace@microchip.com>
Signed-off-by: Don Brace <don.brace@microchip.com>
---
 drivers/scsi/smartpqi/smartpqi_init.c | 23 +++++++++++++++++++++++
 1 file changed, 23 insertions(+)

diff --git a/drivers/scsi/smartpqi/smartpqi_init.c b/drivers/scsi/smartpqi/smartpqi_init.c
index 88135fdb8bd1..73f576ccf511 100644
--- a/drivers/scsi/smartpqi/smartpqi_init.c
+++ b/drivers/scsi/smartpqi/smartpqi_init.c
@@ -67,6 +67,7 @@ static struct pqi_cmd_priv *pqi_cmd_priv(struct scsi_cmnd *cmd)
 static void pqi_verify_structures(void);
 static void pqi_take_ctrl_offline(struct pqi_ctrl_info *ctrl_info,
 	enum pqi_ctrl_shutdown_reason ctrl_shutdown_reason);
+static void pqi_take_ctrl_devices_offline(struct pqi_ctrl_info *ctrl_info);
 static void pqi_ctrl_offline_worker(struct work_struct *work);
 static int pqi_scan_scsi_devices(struct pqi_ctrl_info *ctrl_info);
 static void pqi_scan_start(struct Scsi_Host *shost);
@@ -9128,6 +9129,7 @@ static void pqi_take_ctrl_offline_deferred(struct pqi_ctrl_info *ctrl_info)
 	pqi_ctrl_wait_until_quiesced(ctrl_info);
 	pqi_fail_all_outstanding_requests(ctrl_info);
 	pqi_ctrl_unblock_requests(ctrl_info);
+	pqi_take_ctrl_devices_offline(ctrl_info);
 }
 
 static void pqi_ctrl_offline_worker(struct work_struct *work)
@@ -9202,6 +9204,27 @@ static void pqi_take_ctrl_offline(struct pqi_ctrl_info *ctrl_info,
 	schedule_work(&ctrl_info->ctrl_offline_work);
 }
 
+static void pqi_take_ctrl_devices_offline(struct pqi_ctrl_info *ctrl_info)
+{
+	int rc;
+	unsigned long flags;
+	struct pqi_scsi_dev *device;
+
+	spin_lock_irqsave(&ctrl_info->scsi_device_list_lock, flags);
+	list_for_each_entry(device, &ctrl_info->scsi_device_list, scsi_device_list_entry) {
+		rc = list_is_last(&device->scsi_device_list_entry, &ctrl_info->scsi_device_list);
+		if (rc)
+			continue;
+
+		/*
+		 * Is the sdev pointer NULL?
+		 */
+		if (device->sdev)
+			scsi_device_set_state(device->sdev, SDEV_OFFLINE);
+	}
+	spin_unlock_irqrestore(&ctrl_info->scsi_device_list_lock, flags);
+}
+
 static void pqi_print_ctrl_info(struct pci_dev *pci_dev,
 	const struct pci_device_id *id)
 {
-- 
2.49.0.391.g4bbb303af6

