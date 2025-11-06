Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB5F8339B3B
	for <linux-scsi@vger.kernel.org>; Thu,  6 Nov 2025 16:39:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=68.232.153.233
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762447155; cv=none; b=GydqS5QCUIMNlvnp1jE8N+6dng2pJNb24afIzJbvoB/OWVxmh6SBC1cIYD+lN4FEsXrgMw8DbnVgBKPA0Tx5KekEtbF+bYZqOjsqcsmel0ECpkPYSbHKxt0/V4QSbFI9g8b6hj0LuBfd8hJJiPKTi2VFbHJDsCkJ17uoqEoJOeA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762447155; c=relaxed/simple;
	bh=eHzAeyqLo5xvnIERBLpJofpwtaqbOJiSf2EG0j0HRiM=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=n4zg6cpv8szYs6Y9ySYMPviudPdMsns7pOcLLgIv8FVOlARM1hsltjQd15ei8BWQtAqiyF029PdnLxtPvX8KS6ynKQZY8fIJlJcv7sbl962cnedcvTeIw6+IzhNnMdeNP6ytWG1e+2mWUYg9sJYpc4bbbH40X8IxNo3NrCWnHIU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=microchip.com; spf=pass smtp.mailfrom=microchip.com; dkim=pass (2048-bit key) header.d=microchip.com header.i=@microchip.com header.b=MMFVqy81; arc=none smtp.client-ip=68.232.153.233
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=microchip.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=microchip.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=microchip.com header.i=@microchip.com header.b="MMFVqy81"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1762447154; x=1793983154;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=eHzAeyqLo5xvnIERBLpJofpwtaqbOJiSf2EG0j0HRiM=;
  b=MMFVqy81EI1zIAN7+Nzi4jHUZ6uJuLltmSvKEAygs+A793wRr8Tu34ss
   elMatCkcPdCPtU2dX83bVxDNzFa4LPj91R1/ef1EvvBLFo1FsXc6lKEUi
   QPv4DGDdj2bPNu5wWz6lmpq/pPjJw+JZERTdaRUEhMMh5LYnZvNLcuaud
   Gf+9LBTb4ImCu55uYu4sKGS92INvJpxdGoK6/l3mmS5PHjuBl8oF2quni
   9LC+JQd+KpuPhGEiw9JhOowmphl6Ojuh1qScbpcfSHuo9KMZ/VHCeNbRO
   1WQ9+bzOYS8umpyJZkuKc9vPJgEtOLXbMG4NBV19qbmrZJJYnd4GgHFHl
   Q==;
X-CSE-ConnectionGUID: p1tMouI0Q3+X2WA6PzuktQ==
X-CSE-MsgGUID: sF3HJdW8T16Z9yMlwJp0uA==
X-IronPort-AV: E=Sophos;i="6.19,284,1754982000"; 
   d="scan'208";a="280159943"
X-Amp-Result: SKIPPED(no attachment in message)
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa5.microchip.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 06 Nov 2025 09:39:06 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.58; Thu, 6 Nov 2025 09:38:25 -0700
Received: from brunhilda.pdev.net (10.10.85.11) by chn-vm-ex03.mchp-main.com
 (10.10.85.151) with Microsoft SMTP Server id 15.1.2507.58 via Frontend
 Transport; Thu, 6 Nov 2025 09:38:24 -0700
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
Subject: [PATCH 1/4] smartpqi: Add timeout value to RAID path requests to physical devices
Date: Thu, 6 Nov 2025 10:38:19 -0600
Message-ID: <20251106163823.786828-2-don.brace@microchip.com>
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

From: Mike McGowen <Mike.McGowen@microchip.com>

Add a timeout value to requests sent to physical devices via the RAID path.

A timeout value of zero means wait indefinitely, which may cause the OS to
issue Target Management Function (TMF) commands if the device does not
respond.

For input timeouts of 8 seconds or greater, the value sent to firmware
is reduced by 3 seconds to provide an earlier firmware timeout and allow
the OS additional time before timing out.

This change improves timeout handling between the driver, firmware,
and OS, helping to better manage device responsiveness and avoid
indefinite waits.

Reviewed-by: David Strahan <david.strahan@microchip.com>
Reviewed-by: Scott Benesh <scott.benesh@microchip.com>
Reviewed-by: Scott Teel <scott.teel@microchip.com>
Signed-off-by: Mike McGowen <Mike.McGowen@microchip.com>
Signed-off-by: Don Brace <don.brace@microchip.com>
---
 drivers/scsi/smartpqi/smartpqi_init.c | 17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/drivers/scsi/smartpqi/smartpqi_init.c b/drivers/scsi/smartpqi/smartpqi_init.c
index b5e71ff26e8e..f5fb262e9c03 100644
--- a/drivers/scsi/smartpqi/smartpqi_init.c
+++ b/drivers/scsi/smartpqi/smartpqi_init.c
@@ -5555,14 +5555,25 @@ static void pqi_raid_io_complete(struct pqi_io_request *io_request,
 	pqi_scsi_done(scmd);
 }
 
+/*
+ * Adjust the timeout value for physical devices sent to the firmware
+ * by subtracting 3 seconds for timeouts greater than or equal to 8 seconds.
+ *
+ * This provides the firmware with additional time to attempt early recovery
+ * before the OS-level timeout occurs.
+ */
+#define ADJUST_SECS_TIMEOUT_VALUE(tv)   (((tv) >= 8) ? ((tv) - 3) : (tv))
+
 static int pqi_raid_submit_io(struct pqi_ctrl_info *ctrl_info,
 	struct pqi_scsi_dev *device, struct scsi_cmnd *scmd,
 	struct pqi_queue_group *queue_group, bool io_high_prio)
 {
 	int rc;
+	u32 timeout;
 	size_t cdb_length;
 	struct pqi_io_request *io_request;
 	struct pqi_raid_path_request *request;
+	struct request *rq;
 
 	io_request = pqi_alloc_io_request(ctrl_info, scmd);
 	if (!io_request)
@@ -5634,6 +5645,12 @@ static int pqi_raid_submit_io(struct pqi_ctrl_info *ctrl_info,
 		return SCSI_MLQUEUE_HOST_BUSY;
 	}
 
+	if (device->is_physical_device) {
+		rq = scsi_cmd_to_rq(scmd);
+		timeout = rq->timeout / HZ;
+		put_unaligned_le32(ADJUST_SECS_TIMEOUT_VALUE(timeout), &request->timeout);
+	}
+
 	pqi_start_io(ctrl_info, queue_group, RAID_PATH, io_request);
 
 	return 0;
-- 
2.52.0.rc0.28.g4cf919bd7b

