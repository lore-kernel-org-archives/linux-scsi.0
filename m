Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62FC21D2788
	for <linux-scsi@vger.kernel.org>; Tue, 27 Aug 2024 18:55:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=68.232.154.123
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724784932; cv=none; b=mtpjtH/DsiocARQBKjgt/YroHdfYqFhrEvFwcYxfpLCQoAsK6ELsiV0theEJaz7U/u4jkKK82NjuRJl1zgrUTNIL0kRQ//dJosh22PpKLsYEltfAjGu8qb41PKt5fwzdwQIcZgiKSLQpqLvT9RxR4d7O1CwARxbGefi1MqVmfGk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724784932; c=relaxed/simple;
	bh=NnPnPIVgB9ooUOVRZqeP568PzsGVykprKbBt7dC9di0=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=UIrS3Fb/6ohy9DllmqosVfl1KMHi4GcohLyuH0jOksaRw/vZw9rBOYz4uBjP8Kdt24KabCScMXnYIXDiKH/+5CZqZEvhRWWdo71FgjUr7v4ESyeKPbcr8nyy7/CIgbvCg8xEcbSg0KBsGBMam/QX5Hj97vqdb9MkGqB5evWpBsU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=microchip.com; spf=pass smtp.mailfrom=microchip.com; dkim=pass (2048-bit key) header.d=microchip.com header.i=@microchip.com header.b=m1xTUM0b; arc=none smtp.client-ip=68.232.154.123
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=microchip.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=microchip.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=microchip.com header.i=@microchip.com header.b="m1xTUM0b"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1724784930; x=1756320930;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=NnPnPIVgB9ooUOVRZqeP568PzsGVykprKbBt7dC9di0=;
  b=m1xTUM0baFZUKRAw54Ke3fv9m2rx1gjnt483sdDNm6HgEVmbZSSX2SAm
   ac5gjTXyMZZrRCHd7uuRlK1eJZSNV0zzkMiJIcbWjB0FcsRCT8M+vI/hQ
   vF+SmrrLpR1fFHWGSQSBR+DJdOwf/gZ9ekJ9yZ9tnMlakZu6h/mT75Oah
   vB12lltSJtEi1AZpGmuUyv0r5kuWo73gHXzL9xylFTAwzDexxa1XFwxqF
   CIcSNnmcqUURoGOYe7/R8lz46xs9/ymtdWlWtGq6JWzflaP1QPBOxY6P2
   J6ByehrHGLq1h7Bi2LT8p+PwjJs8NLGhjjofygL7fRIU9bISc667nrXA3
   g==;
X-CSE-ConnectionGUID: HXogS4E1Q5emAr2ic36fkw==
X-CSE-MsgGUID: Ks6786yISJmNGBc+wBmclw==
X-IronPort-AV: E=Sophos;i="6.10,181,1719903600"; 
   d="scan'208";a="198399613"
X-Amp-Result: SKIPPED(no attachment in message)
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa6.microchip.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 27 Aug 2024 11:55:27 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Tue, 27 Aug 2024 11:54:58 -0700
Received: from brunhilda.pdev.net (10.10.85.11) by chn-vm-ex01.mchp-main.com
 (10.10.85.143) with Microsoft SMTP Server id 15.1.2507.35 via Frontend
 Transport; Tue, 27 Aug 2024 11:55:03 -0700
From: Don Brace <don.brace@microchip.com>
To: <don.brace@microchip.com>, <scott.teel@microchip.com>,
	<Justin.Lindley@microchip.com>, <scott.benesh@microchip.com>,
	<gerry.morong@microchip.com>, <mahesh.rajashekhara@microchip.com>,
	<mike.mcgowen@microchip.com>, <murthy.bhat@microchip.com>,
	<kumar.meiyappan@microchip.com>, <jeremy.reeves@microchip.com>,
	<david.strahan@microchip.com>, <hch@infradead.org>, James Bottomley
	<James.Bottomley@HansenPartnership.com>, Martin Petersen
	<martin.petersen@oracle.com>, <joseph.szczypek@hpe.com>, <POSWALD@suse.com>
CC: <linux-scsi@vger.kernel.org>
Subject: [PATCH 3/7] smartpqi: add counter for parity write stream requests
Date: Tue, 27 Aug 2024 13:54:57 -0500
Message-ID: <20240827185501.692804-4-don.brace@microchip.com>
X-Mailer: git-send-email 2.46.0.421.g159f2d50e7
In-Reply-To: <20240827185501.692804-1-don.brace@microchip.com>
References: <20240827185501.692804-1-don.brace@microchip.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Organization: Microchip Technology Inc.
Content-Transfer-Encoding: 8bit
Content-Type: text/plain

From: Mahesh Rajashekhara <mahesh.rajashekhara@microchip.com>

Add sysfs entry to check for write stream requests.

Move existing raid_bypass_cnt into a structure named
pqi_raid_io_stats and add member write_stream_cnt. These two counters
are related because write stream detection is only checked if an I/O
request is eligible for bypass (AIO).

Example usage:

lsscsi
[15:1:0:0]   disk    Adaptec  LOGICAL VOLUME   0129  /dev/sdae

cat /sys/block/sdae/device/ssd_smart_path_enabled
1
^
|
+---- NOTE: here bypass has been enabled on device sdae

To read the counter for parity write stream requests:

cat /sys/block/sdae/device/write_stream_cnt
0x60cd507

Reviewed-by: Scott Benesh <scott.benesh@microchip.com>
Reviewed-by: Mike McGowen <mike.mcgowen@microchip.com>
Signed-off-by: Mahesh Rajashekhara <mahesh.rajashekhara@microchip.com>
Co-developed-by: Kevin Barnett <kevin.barnett@microchip.com>
Signed-off-by: Kevin Barnett <kevin.barnett@microchip.com>
Signed-off-by: Don Brace <don.brace@microchip.com>
---
 drivers/scsi/smartpqi/smartpqi.h      |  7 ++-
 drivers/scsi/smartpqi/smartpqi_init.c | 62 +++++++++++++++++++++------
 2 files changed, 55 insertions(+), 14 deletions(-)

diff --git a/drivers/scsi/smartpqi/smartpqi.h b/drivers/scsi/smartpqi/smartpqi.h
index f493006bee9d..fae6db20a6e9 100644
--- a/drivers/scsi/smartpqi/smartpqi.h
+++ b/drivers/scsi/smartpqi/smartpqi.h
@@ -1106,6 +1106,11 @@ struct pqi_tmf_work {
 	u8	scsi_opcode;
 };
 
+struct pqi_raid_io_stats {
+	u64	raid_bypass_cnt;
+	u64	write_stream_cnt;
+};
+
 struct pqi_scsi_dev {
 	int	devtype;		/* as reported by INQUIRY command */
 	u8	device_type;		/* as reported by */
@@ -1168,7 +1173,7 @@ struct pqi_scsi_dev {
 
 	struct pqi_stream_data stream_data[NUM_STREAMS_PER_LUN];
 	atomic_t scsi_cmds_outstanding[PQI_MAX_LUNS_PER_DEVICE];
-	u64 __percpu *raid_bypass_cnt;
+	struct pqi_raid_io_stats __percpu *raid_io_stats;
 
 	struct pqi_tmf_work tmf_work[PQI_MAX_LUNS_PER_DEVICE];
 };
diff --git a/drivers/scsi/smartpqi/smartpqi_init.c b/drivers/scsi/smartpqi/smartpqi_init.c
index 8e2e71ab49ae..6a941735c982 100644
--- a/drivers/scsi/smartpqi/smartpqi_init.c
+++ b/drivers/scsi/smartpqi/smartpqi_init.c
@@ -1508,8 +1508,8 @@ static int pqi_get_raid_map(struct pqi_ctrl_info *ctrl_info,
 	if (rc)
 		goto error;
 
-	device->raid_bypass_cnt = alloc_percpu(u64);
-	if (!device->raid_bypass_cnt) {
+	device->raid_io_stats = alloc_percpu(struct pqi_raid_io_stats);
+	if (!device->raid_io_stats) {
 		rc = -ENOMEM;
 		goto error;
 	}
@@ -2105,9 +2105,9 @@ static void pqi_scsi_update_device(struct pqi_ctrl_info *ctrl_info,
 				/* To prevent this from being freed later. */
 				new_device->raid_map = NULL;
 			}
-			if (new_device->raid_bypass_enabled && existing_device->raid_bypass_cnt == NULL) {
-				existing_device->raid_bypass_cnt = new_device->raid_bypass_cnt;
-				new_device->raid_bypass_cnt = NULL;
+			if (new_device->raid_bypass_enabled && existing_device->raid_io_stats == NULL) {
+				existing_device->raid_io_stats = new_device->raid_io_stats;
+				new_device->raid_io_stats = NULL;
 			}
 			existing_device->raid_bypass_configured = new_device->raid_bypass_configured;
 			existing_device->raid_bypass_enabled = new_device->raid_bypass_enabled;
@@ -2131,7 +2131,7 @@ static void pqi_scsi_update_device(struct pqi_ctrl_info *ctrl_info,
 static inline void pqi_free_device(struct pqi_scsi_dev *device)
 {
 	if (device) {
-		free_percpu(device->raid_bypass_cnt);
+		free_percpu(device->raid_io_stats);
 		kfree(device->raid_map);
 		kfree(device);
 	}
@@ -5984,6 +5984,7 @@ static bool pqi_is_parity_write_stream(struct pqi_ctrl_info *ctrl_info,
 			pqi_stream_data->next_lba = rmd.first_block +
 				rmd.block_cnt;
 			pqi_stream_data->last_accessed = jiffies;
+			per_cpu_ptr(device->raid_io_stats, smp_processor_id())->write_stream_cnt++;
 			return true;
 		}
 
@@ -6016,7 +6017,6 @@ static int pqi_scsi_queue_command(struct Scsi_Host *shost, struct scsi_cmnd *scm
 	u16 hw_queue;
 	struct pqi_queue_group *queue_group;
 	bool raid_bypassed;
-	u64 *raid_bypass_cnt;
 	u8 lun;
 
 	scmd->host_scribble = PQI_NO_COMPLETION;
@@ -6063,8 +6063,7 @@ static int pqi_scsi_queue_command(struct Scsi_Host *shost, struct scsi_cmnd *scm
 			rc = pqi_raid_bypass_submit_scsi_cmd(ctrl_info, device, scmd, queue_group);
 			if (rc == 0 || rc == SCSI_MLQUEUE_HOST_BUSY) {
 				raid_bypassed = true;
-				raid_bypass_cnt = per_cpu_ptr(device->raid_bypass_cnt, smp_processor_id());
-				(*raid_bypass_cnt)++;
+				per_cpu_ptr(device->raid_io_stats, smp_processor_id())->raid_bypass_cnt++;
 			}
 		}
 		if (!raid_bypassed)
@@ -7363,7 +7362,6 @@ static ssize_t pqi_raid_bypass_cnt_show(struct device *dev,
 	unsigned long flags;
 	u64 raid_bypass_cnt;
 	int cpu;
-	u64 *per_cpu_bypass_cnt_ptr;
 
 	sdev = to_scsi_device(dev);
 	ctrl_info = shost_to_hba(sdev->host);
@@ -7381,10 +7379,9 @@ static ssize_t pqi_raid_bypass_cnt_show(struct device *dev,
 
 	raid_bypass_cnt = 0;
 
-	if (device->raid_bypass_cnt) {
+	if (device->raid_io_stats) {
 		for_each_online_cpu(cpu) {
-			per_cpu_bypass_cnt_ptr = per_cpu_ptr(device->raid_bypass_cnt, cpu);
-			raid_bypass_cnt += *per_cpu_bypass_cnt_ptr;
+			raid_bypass_cnt += per_cpu_ptr(device->raid_io_stats, cpu)->raid_bypass_cnt;
 		}
 	}
 
@@ -7472,6 +7469,43 @@ static ssize_t pqi_numa_node_show(struct device *dev,
 	return scnprintf(buffer, PAGE_SIZE, "%d\n", ctrl_info->numa_node);
 }
 
+static ssize_t pqi_write_stream_cnt_show(struct device *dev,
+	struct device_attribute *attr, char *buffer)
+{
+	struct pqi_ctrl_info *ctrl_info;
+	struct scsi_device *sdev;
+	struct pqi_scsi_dev *device;
+	unsigned long flags;
+	u64 write_stream_cnt;
+	int cpu;
+
+	sdev = to_scsi_device(dev);
+	ctrl_info = shost_to_hba(sdev->host);
+
+	if (pqi_ctrl_offline(ctrl_info))
+		return -ENODEV;
+
+	spin_lock_irqsave(&ctrl_info->scsi_device_list_lock, flags);
+
+	device = sdev->hostdata;
+	if (!device) {
+		spin_unlock_irqrestore(&ctrl_info->scsi_device_list_lock, flags);
+		return -ENODEV;
+	}
+
+	write_stream_cnt = 0;
+
+	if (device->raid_io_stats) {
+		for_each_online_cpu(cpu) {
+			write_stream_cnt += per_cpu_ptr(device->raid_io_stats, cpu)->write_stream_cnt;
+		}
+	}
+
+	spin_unlock_irqrestore(&ctrl_info->scsi_device_list_lock, flags);
+
+	return scnprintf(buffer, PAGE_SIZE, "0x%llx\n", write_stream_cnt);
+}
+
 static DEVICE_ATTR(lunid, 0444, pqi_lunid_show, NULL);
 static DEVICE_ATTR(unique_id, 0444, pqi_unique_id_show, NULL);
 static DEVICE_ATTR(path_info, 0444, pqi_path_info_show, NULL);
@@ -7482,6 +7516,7 @@ static DEVICE_ATTR(raid_bypass_cnt, 0444, pqi_raid_bypass_cnt_show, NULL);
 static DEVICE_ATTR(sas_ncq_prio_enable, 0644,
 		pqi_sas_ncq_prio_enable_show, pqi_sas_ncq_prio_enable_store);
 static DEVICE_ATTR(numa_node, 0444, pqi_numa_node_show, NULL);
+static DEVICE_ATTR(write_stream_cnt, 0444, pqi_write_stream_cnt_show, NULL);
 
 static struct attribute *pqi_sdev_attrs[] = {
 	&dev_attr_lunid.attr,
@@ -7493,6 +7528,7 @@ static struct attribute *pqi_sdev_attrs[] = {
 	&dev_attr_raid_bypass_cnt.attr,
 	&dev_attr_sas_ncq_prio_enable.attr,
 	&dev_attr_numa_node.attr,
+	&dev_attr_write_stream_cnt.attr,
 	NULL
 };
 
-- 
2.46.0.421.g159f2d50e7

