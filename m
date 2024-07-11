Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D59B19E807
	for <linux-scsi@vger.kernel.org>; Thu, 11 Jul 2024 19:47:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=68.232.154.123
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720727256; cv=none; b=iBalX+/ktScrfVKy7+BjMuNhYfsOB13Yd+V72eu/39/HN+lJgw754WUFDaBqD+JU98P1Z7L/M9xoEvol4oJWrF5TLJepD8vIbZ8TI21qidPpOlKuHsa9D1TRoq1v/eo92O579jNIOS83aUl7tYZYZZS4EyHbFMjiUfsWbE0d4oc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720727256; c=relaxed/simple;
	bh=T8opBRnQWtky6d94FwuVLCh+2RQZaga0U1YCkD0MuQw=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=pdxzSGfDbIFzERJAwp/eIgH/Agz1oOye7q3p5eks1ZfhiscC628Ab+9h5dpRv4Fgk4ayFKG3ZMah8ucDxe6MloMb673h2zMONXKq0tUc6LEjWl0spfjy9b0M40vr2DPBpJBrK2GlEku7fawSxu2jv0/2OUZbzeB4jdjKYeteu9M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=microchip.com; spf=pass smtp.mailfrom=microchip.com; dkim=pass (2048-bit key) header.d=microchip.com header.i=@microchip.com header.b=MUwjxtgo; arc=none smtp.client-ip=68.232.154.123
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=microchip.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=microchip.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=microchip.com header.i=@microchip.com header.b="MUwjxtgo"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1720727254; x=1752263254;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=T8opBRnQWtky6d94FwuVLCh+2RQZaga0U1YCkD0MuQw=;
  b=MUwjxtgoVdgZ0NtPDbVVoraONdpaOk6gXAbAF3tgt1jflC2VReMaYdhd
   o89RpHit2qKEvrijWmY6YrBkxPlbdjS5asLzv9lsz0plN2KgLd6t7hkaQ
   Wk7W7y/qsv6wOxC9slyWITqUVmwDEzTj4S8iGGHS/8BcOxUozhSGOouHi
   /JipFJiq8dX9FF3Gh4GgaLXyHULhfgb/ys9GemjqHpH4c7/WEgje+rfoN
   nB+4sBkJKjbU8mrXLx9QfEM+aVgYwnbwFc8v2APfng0CKBDZQOXOHPV+d
   GKdOF4xyA+Y4WmXDnnJidow1Nz7NKWF9BXXP5ljWqRYYoiAxDPHSEM+s/
   w==;
X-CSE-ConnectionGUID: lpLBJxwkSjifens90ReNAw==
X-CSE-MsgGUID: m35oC3sXT5CZ6AN98jqtWA==
X-IronPort-AV: E=Sophos;i="6.09,201,1716274800"; 
   d="scan'208";a="29106954"
X-Amp-Result: SKIPPED(no attachment in message)
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa4.microchip.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 11 Jul 2024 12:47:29 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.85.144) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Thu, 11 Jul 2024 12:47:07 -0700
Received: from brunhilda.pdev.net (10.10.85.11) by chn-vm-ex02.mchp-main.com
 (10.10.85.144) with Microsoft SMTP Server id 15.1.2507.35 via Frontend
 Transport; Thu, 11 Jul 2024 12:47:06 -0700
From: Don Brace <don.brace@microchip.com>
To: <don.brace@microchip.com>, <Kevin.Barnett@microchip.com>,
	<scott.teel@microchip.com>, <Justin.Lindley@microchip.com>,
	<scott.benesh@microchip.com>, <gerry.morong@microchip.com>,
	<mahesh.rajashekhara@microchip.com>, <mike.mcgowen@microchip.com>,
	<murthy.bhat@microchip.com>, <kumar.meiyappan@microchip.com>,
	<jeremy.reeves@microchip.com>, <david.strahan@microchip.com>,
	<hch@infradead.org>, James Bottomley <James.Bottomley@HansenPartnership.com>,
	Martin Petersen <martin.petersen@oracle.com>, <joseph.szczypek@hpe.com>,
	<POSWALD@suse.com>
CC: <linux-scsi@vger.kernel.org>
Subject: [PATCH 2/5] smartpqi: improve accuracy/performance of raid-bypass-counter.
Date: Thu, 11 Jul 2024 14:47:01 -0500
Message-ID: <20240711194704.982400-3-don.brace@microchip.com>
X-Mailer: git-send-email 2.45.2.827.g557ae147e6
In-Reply-To: <20240711194704.982400-1-don.brace@microchip.com>
References: <20240711194704.982400-1-don.brace@microchip.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Organization: Microchip Technology Inc.
Content-Transfer-Encoding: 8bit
Content-Type: text/plain

From: Kevin Barnett <kevin.barnett@microchip.com>

The original implementation of this counter used an atomic variable.
However, this implementation negatively impacted performance in some
configurations.

Switch to using per_cpu variables.

Reviewed-by: Scott Benesh <scott.benesh@microchip.com>
Reviewed-by: Scott Teel <scott.teel@microchip.com>
Reviewed-by: Mike McGowen <mike.mcgowen@microchip.com>
Co-developed-by: Mahesh Rajashekhara <mahesh.rajashekhara@microchip.com>
Signed-off-by: Mahesh Rajashekhara <mahesh.rajashekhara@microchip.com>
Signed-off-by: Kevin Barnett <kevin.barnett@microchip.com>
Signed-off-by: Don Brace <don.brace@microchip.com>
---
 drivers/scsi/smartpqi/smartpqi.h      |  2 +-
 drivers/scsi/smartpqi/smartpqi_init.c | 30 +++++++++++++++++++++++----
 2 files changed, 27 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/smartpqi/smartpqi.h b/drivers/scsi/smartpqi/smartpqi.h
index cdedc271857a..023fbce04e7a 100644
--- a/drivers/scsi/smartpqi/smartpqi.h
+++ b/drivers/scsi/smartpqi/smartpqi.h
@@ -1158,7 +1158,7 @@ struct pqi_scsi_dev {
 
 	struct pqi_stream_data stream_data[NUM_STREAMS_PER_LUN];
 	atomic_t scsi_cmds_outstanding[PQI_MAX_LUNS_PER_DEVICE];
-	unsigned int raid_bypass_cnt;
+	u64 __percpu *raid_bypass_cnt;
 
 	struct pqi_tmf_work tmf_work[PQI_MAX_LUNS_PER_DEVICE];
 };
diff --git a/drivers/scsi/smartpqi/smartpqi_init.c b/drivers/scsi/smartpqi/smartpqi_init.c
index 9166dfa1fedc..eaebe3cc00aa 100644
--- a/drivers/scsi/smartpqi/smartpqi_init.c
+++ b/drivers/scsi/smartpqi/smartpqi_init.c
@@ -1508,6 +1508,12 @@ static int pqi_get_raid_map(struct pqi_ctrl_info *ctrl_info,
 	if (rc)
 		goto error;
 
+	device->raid_bypass_cnt = alloc_percpu(u64);
+	if (!device->raid_bypass_cnt) {
+		rc = -ENOMEM;
+		goto error;
+	}
+
 	device->raid_map = raid_map;
 
 	return 0;
@@ -2099,6 +2105,10 @@ static void pqi_scsi_update_device(struct pqi_ctrl_info *ctrl_info,
 				/* To prevent this from being freed later. */
 				new_device->raid_map = NULL;
 			}
+			if (new_device->raid_bypass_enabled && existing_device->raid_bypass_cnt == NULL) {
+				existing_device->raid_bypass_cnt = new_device->raid_bypass_cnt;
+				new_device->raid_bypass_cnt = NULL;
+			}
 			existing_device->raid_bypass_configured = new_device->raid_bypass_configured;
 			existing_device->raid_bypass_enabled = new_device->raid_bypass_enabled;
 		}
@@ -2121,6 +2131,7 @@ static void pqi_scsi_update_device(struct pqi_ctrl_info *ctrl_info,
 static inline void pqi_free_device(struct pqi_scsi_dev *device)
 {
 	if (device) {
+		free_percpu(device->raid_bypass_cnt);
 		kfree(device->raid_map);
 		kfree(device);
 	}
@@ -6007,6 +6018,7 @@ static int pqi_scsi_queue_command(struct Scsi_Host *shost, struct scsi_cmnd *scm
 	u16 hw_queue;
 	struct pqi_queue_group *queue_group;
 	bool raid_bypassed;
+	u64 *raid_bypass_cnt;
 	u8 lun;
 
 	scmd->host_scribble = PQI_NO_COMPLETION;
@@ -6053,7 +6065,8 @@ static int pqi_scsi_queue_command(struct Scsi_Host *shost, struct scsi_cmnd *scm
 			rc = pqi_raid_bypass_submit_scsi_cmd(ctrl_info, device, scmd, queue_group);
 			if (rc == 0 || rc == SCSI_MLQUEUE_HOST_BUSY) {
 				raid_bypassed = true;
-				device->raid_bypass_cnt++;
+				raid_bypass_cnt = per_cpu_ptr(device->raid_bypass_cnt, smp_processor_id());
+				(*raid_bypass_cnt)++;
 			}
 		}
 		if (!raid_bypassed)
@@ -7350,7 +7363,9 @@ static ssize_t pqi_raid_bypass_cnt_show(struct device *dev,
 	struct scsi_device *sdev;
 	struct pqi_scsi_dev *device;
 	unsigned long flags;
-	unsigned int raid_bypass_cnt;
+	u64 raid_bypass_cnt;
+	int cpu;
+	u64 *per_cpu_bypass_cnt_ptr;
 
 	sdev = to_scsi_device(dev);
 	ctrl_info = shost_to_hba(sdev->host);
@@ -7366,11 +7381,18 @@ static ssize_t pqi_raid_bypass_cnt_show(struct device *dev,
 		return -ENODEV;
 	}
 
-	raid_bypass_cnt = device->raid_bypass_cnt;
+	raid_bypass_cnt = 0;
+
+	if (device->raid_bypass_cnt) {
+		for_each_online_cpu(cpu) {
+			per_cpu_bypass_cnt_ptr = per_cpu_ptr(device->raid_bypass_cnt, cpu);
+			raid_bypass_cnt += *per_cpu_bypass_cnt_ptr;
+		}
+	}
 
 	spin_unlock_irqrestore(&ctrl_info->scsi_device_list_lock, flags);
 
-	return scnprintf(buffer, PAGE_SIZE, "0x%x\n", raid_bypass_cnt);
+	return scnprintf(buffer, PAGE_SIZE, "0x%llx\n", raid_bypass_cnt);
 }
 
 static ssize_t pqi_sas_ncq_prio_enable_show(struct device *dev,
-- 
2.45.2.827.g557ae147e6

