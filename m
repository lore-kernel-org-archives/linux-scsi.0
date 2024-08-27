Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 046DD1C4623
	for <linux-scsi@vger.kernel.org>; Tue, 27 Aug 2024 18:55:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=68.232.154.123
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724784932; cv=none; b=nJGfnQARo5Ti/B071eQXGiXc0WtUgE3QW8gk5klM6cLuywCl6I5DH7oKxefxvtZq2fy7nGTdn35dcXgwiP+eQyfZuVaMEsBi8hBDOEgPy/DzdHHgEF4Q98GHdXwI9RGE2RpIuXCjGCHf79rJTKGdMaPAsxxBSdF4JnB38yj6jqo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724784932; c=relaxed/simple;
	bh=pagNeiceoDAWafeXwgVxUCyS/kvJikAHf2ME0fuyuxA=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Ovmuye00OyZ6Zk/BlLuGF7sLZ6oDzulrAiahSKXr6AamJUsP6r5r5xC7scFZDkVhRNIyd/lPeKaKVo2e0GZFHKTFyG8YZULNAohqNWv79t1o43BJbOMfJRGMDAIwi7Memi/zjA3Y97HgejuV8LYjIvp5wyu2aSCYXZd/9NFQCQI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=microchip.com; spf=pass smtp.mailfrom=microchip.com; dkim=pass (2048-bit key) header.d=microchip.com header.i=@microchip.com header.b=D0laLwGQ; arc=none smtp.client-ip=68.232.154.123
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=microchip.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=microchip.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=microchip.com header.i=@microchip.com header.b="D0laLwGQ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1724784928; x=1756320928;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=pagNeiceoDAWafeXwgVxUCyS/kvJikAHf2ME0fuyuxA=;
  b=D0laLwGQfzxCKgG5ahVJGIcoEfFrnZqCd1FuddTGko35jyg1kow0OVHO
   GwkKuusmiDbVmQMeUefHaPDEGZHuCllu3Da3inJKcLcstAvz51CCKOavF
   aX1JnA73XIpJIigd4wg5++JG2GgmUrMPPzMpKOvWJxPmmBZGFEyyOGJBA
   7BWxjtYNxmv0zvwI9nArySoonXj/P3XtiEKCJRgMiosqAEMHQQcJJ3PiR
   v6pDdiFjQ3RPeqKuZbwZdKqAFlMft/hqpSy4WxXJsALetiBsqTbIyoYF0
   IwQIsmRta4SVALLLA5J6jCpr4LWirvrV/jsWGKOAOlD66His2u/9+zkP3
   Q==;
X-CSE-ConnectionGUID: HXogS4E1Q5emAr2ic36fkw==
X-CSE-MsgGUID: 4jFXQ4WxQBqffr2ngYD/4g==
X-IronPort-AV: E=Sophos;i="6.10,181,1719903600"; 
   d="scan'208";a="198399611"
X-Amp-Result: SKIPPED(no attachment in message)
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa6.microchip.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 27 Aug 2024 11:55:26 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Tue, 27 Aug 2024 11:54:56 -0700
Received: from brunhilda.pdev.net (10.10.85.11) by chn-vm-ex01.mchp-main.com
 (10.10.85.143) with Microsoft SMTP Server id 15.1.2507.35 via Frontend
 Transport; Tue, 27 Aug 2024 11:55:02 -0700
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
Subject: [PATCH 1/7] smartpqi: Add fw log to kdump
Date: Tue, 27 Aug 2024 13:54:55 -0500
Message-ID: <20240827185501.692804-2-don.brace@microchip.com>
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

From: Murthy Bhat <Murthy.Bhat@microchip.com>

Add controller logs to kdump.

Driver allocates DMA memory and communicates this address to FW.
In the event of system crash, host driver notifies the firmware about
the crash and firmware posts all the necessary logs in the
pre-allocated host buffer for firmware debugging.

Once firmware notifies the completion of the log uploading to the host
memory and host continues with the OS crash dump saving.

This is a "feature" driven capability and is backward compatible with
existing controller FW.

Rename some prefixes for OFA (Online-Firmware Activation ofa_*) buffers
to host_memory_*. So, not a lot of actual functional changes to
smartpqi_init.c, mainly determining the memory size allocation.

Added a function to notify the controller to copy debug data into host
memory before continuing kdump.

Most of the functional changes are in smartpqi_sis.c where the actual
handshaking is done.

Reviewed-by: Scott Benesh <scott.benesh@microchip.com>
Reviewed-by: Mike McGowen <mike.mcgowen@microchip.com>
Signed-off-by: Murthy Bhat <Murthy.Bhat@microchip.com>
Signed-off-by: Don Brace <don.brace@microchip.com>
---
 drivers/scsi/smartpqi/smartpqi.h      |  32 ++--
 drivers/scsi/smartpqi/smartpqi_init.c | 226 ++++++++++++++++----------
 drivers/scsi/smartpqi/smartpqi_sis.c  |  60 +++++++
 drivers/scsi/smartpqi/smartpqi_sis.h  |   3 +
 4 files changed, 221 insertions(+), 100 deletions(-)

diff --git a/drivers/scsi/smartpqi/smartpqi.h b/drivers/scsi/smartpqi/smartpqi.h
index 023fbce04e7a..f493006bee9d 100644
--- a/drivers/scsi/smartpqi/smartpqi.h
+++ b/drivers/scsi/smartpqi/smartpqi.h
@@ -505,7 +505,7 @@ struct pqi_vendor_general_request {
 			__le64	buffer_address;
 			__le32	buffer_length;
 			u8	reserved[40];
-		} ofa_memory_allocation;
+		} host_memory_allocation;
 	} data;
 };
 
@@ -517,21 +517,30 @@ struct pqi_vendor_general_response {
 	u8	reserved[2];
 };
 
-#define PQI_VENDOR_GENERAL_CONFIG_TABLE_UPDATE	0
-#define PQI_VENDOR_GENERAL_HOST_MEMORY_UPDATE	1
+#define PQI_VENDOR_GENERAL_CONFIG_TABLE_UPDATE		0
+#define PQI_VENDOR_GENERAL_OFA_MEMORY_UPDATE		1
+#define PQI_VENDOR_GENERAL_CTRL_LOG_MEMORY_UPDATE	2
 
 #define PQI_OFA_VERSION			1
 #define PQI_OFA_SIGNATURE		"OFA_QRM"
-#define PQI_OFA_MAX_SG_DESCRIPTORS	64
+#define PQI_CTRL_LOG_VERSION		1
+#define PQI_CTRL_LOG_SIGNATURE		"FW_DATA"
+#define PQI_HOST_MAX_SG_DESCRIPTORS	64
 
-struct pqi_ofa_memory {
-	__le64	signature;	/* "OFA_QRM" */
+struct pqi_host_memory {
+	__le64	signature;	/* "OFA_QRM", "FW_DATA", etc. */
 	__le16	version;	/* version of this struct (1 = 1st version) */
 	u8	reserved[62];
 	__le32	bytes_allocated;	/* total allocated memory in bytes */
 	__le16	num_memory_descriptors;
 	u8	reserved1[2];
-	struct pqi_sg_descriptor sg_descriptor[PQI_OFA_MAX_SG_DESCRIPTORS];
+	struct pqi_sg_descriptor sg_descriptor[PQI_HOST_MAX_SG_DESCRIPTORS];
+};
+
+struct pqi_host_memory_descriptor {
+	struct pqi_host_memory *host_memory;
+	dma_addr_t		host_memory_dma_handle;
+	void			**host_chunk_virt_address;
 };
 
 struct pqi_aio_error_info {
@@ -867,7 +876,8 @@ struct pqi_config_table_firmware_features {
 #define PQI_FIRMWARE_FEATURE_FW_TRIAGE				17
 #define PQI_FIRMWARE_FEATURE_RPL_EXTENDED_FORMAT_4_5		18
 #define PQI_FIRMWARE_FEATURE_MULTI_LUN_DEVICE_SUPPORT           21
-#define PQI_FIRMWARE_FEATURE_MAXIMUM                            21
+#define PQI_FIRMWARE_FEATURE_CTRL_LOGGING			22
+#define PQI_FIRMWARE_FEATURE_MAXIMUM				22
 
 struct pqi_config_table_debug {
 	struct pqi_config_table_section_header header;
@@ -1357,6 +1367,7 @@ struct pqi_ctrl_info {
 	u8		firmware_triage_supported : 1;
 	u8		rpl_extended_format_4_5_supported : 1;
 	u8		multi_lun_device_supported : 1;
+	u8		ctrl_logging_supported : 1;
 	u8		enable_r1_writes : 1;
 	u8		enable_r5_writes : 1;
 	u8		enable_r6_writes : 1;
@@ -1398,13 +1409,12 @@ struct pqi_ctrl_info {
 	wait_queue_head_t block_requests_wait;
 
 	struct mutex	ofa_mutex;
-	struct pqi_ofa_memory *pqi_ofa_mem_virt_addr;
-	dma_addr_t	pqi_ofa_mem_dma_handle;
-	void		**pqi_ofa_chunk_virt_addr;
 	struct work_struct ofa_memory_alloc_work;
 	struct work_struct ofa_quiesce_work;
 	u32		ofa_bytes_requested;
 	u16		ofa_cancel_reason;
+	struct pqi_host_memory_descriptor ofa_memory;
+	struct pqi_host_memory_descriptor ctrl_log_memory;
 	enum pqi_ctrl_removal_state ctrl_removal_state;
 };
 
diff --git a/drivers/scsi/smartpqi/smartpqi_init.c b/drivers/scsi/smartpqi/smartpqi_init.c
index b5396d722d52..54f7fe843445 100644
--- a/drivers/scsi/smartpqi/smartpqi_init.c
+++ b/drivers/scsi/smartpqi/smartpqi_init.c
@@ -92,9 +92,9 @@ static int pqi_aio_submit_r56_write_io(struct pqi_ctrl_info *ctrl_info,
 static void pqi_ofa_ctrl_quiesce(struct pqi_ctrl_info *ctrl_info);
 static void pqi_ofa_ctrl_unquiesce(struct pqi_ctrl_info *ctrl_info);
 static int pqi_ofa_ctrl_restart(struct pqi_ctrl_info *ctrl_info, unsigned int delay_secs);
-static void pqi_ofa_setup_host_buffer(struct pqi_ctrl_info *ctrl_info);
-static void pqi_ofa_free_host_buffer(struct pqi_ctrl_info *ctrl_info);
-static int pqi_ofa_host_memory_update(struct pqi_ctrl_info *ctrl_info);
+static void pqi_host_setup_buffer(struct pqi_ctrl_info *ctrl_info, struct pqi_host_memory_descriptor *host_memory_descriptor, u32 total_size, u32 min_size);
+static void pqi_host_free_buffer(struct pqi_ctrl_info *ctrl_info, struct pqi_host_memory_descriptor *host_memory_descriptor);
+static int pqi_host_memory_update(struct pqi_ctrl_info *ctrl_info, struct pqi_host_memory_descriptor *host_memory_descriptor, u16 function_code);
 static int pqi_device_wait_for_pending_io(struct pqi_ctrl_info *ctrl_info,
 	struct pqi_scsi_dev *device, u8 lun, unsigned long timeout_msecs);
 static void pqi_fail_all_outstanding_requests(struct pqi_ctrl_info *ctrl_info);
@@ -3634,7 +3634,7 @@ static void pqi_process_soft_reset(struct pqi_ctrl_info *ctrl_info)
 		ctrl_info->pqi_mode_enabled = false;
 		pqi_save_ctrl_mode(ctrl_info, SIS_MODE);
 		rc = pqi_ofa_ctrl_restart(ctrl_info, delay_secs);
-		pqi_ofa_free_host_buffer(ctrl_info);
+		pqi_host_free_buffer(ctrl_info, &ctrl_info->ofa_memory);
 		pqi_ctrl_ofa_done(ctrl_info);
 		dev_info(&ctrl_info->pci_dev->dev,
 				"Online Firmware Activation: %s\n",
@@ -3645,7 +3645,7 @@ static void pqi_process_soft_reset(struct pqi_ctrl_info *ctrl_info)
 				"Online Firmware Activation ABORTED\n");
 		if (ctrl_info->soft_reset_handshake_supported)
 			pqi_clear_soft_reset_status(ctrl_info);
-		pqi_ofa_free_host_buffer(ctrl_info);
+		pqi_host_free_buffer(ctrl_info, &ctrl_info->ofa_memory);
 		pqi_ctrl_ofa_done(ctrl_info);
 		pqi_ofa_ctrl_unquiesce(ctrl_info);
 		break;
@@ -3655,7 +3655,7 @@ static void pqi_process_soft_reset(struct pqi_ctrl_info *ctrl_info)
 		dev_err(&ctrl_info->pci_dev->dev,
 			"unexpected Online Firmware Activation reset status: 0x%x\n",
 			reset_status);
-		pqi_ofa_free_host_buffer(ctrl_info);
+		pqi_host_free_buffer(ctrl_info, &ctrl_info->ofa_memory);
 		pqi_ctrl_ofa_done(ctrl_info);
 		pqi_ofa_ctrl_unquiesce(ctrl_info);
 		pqi_take_ctrl_offline(ctrl_info, PQI_OFA_RESPONSE_TIMEOUT);
@@ -3670,8 +3670,8 @@ static void pqi_ofa_memory_alloc_worker(struct work_struct *work)
 	ctrl_info = container_of(work, struct pqi_ctrl_info, ofa_memory_alloc_work);
 
 	pqi_ctrl_ofa_start(ctrl_info);
-	pqi_ofa_setup_host_buffer(ctrl_info);
-	pqi_ofa_host_memory_update(ctrl_info);
+	pqi_host_setup_buffer(ctrl_info, &ctrl_info->ofa_memory, ctrl_info->ofa_bytes_requested, ctrl_info->ofa_bytes_requested);
+	pqi_host_memory_update(ctrl_info, &ctrl_info->ofa_memory, PQI_VENDOR_GENERAL_OFA_MEMORY_UPDATE);
 }
 
 static void pqi_ofa_quiesce_worker(struct work_struct *work)
@@ -3711,7 +3711,7 @@ static bool pqi_ofa_process_event(struct pqi_ctrl_info *ctrl_info,
 		dev_info(&ctrl_info->pci_dev->dev,
 			"received Online Firmware Activation cancel request: reason: %u\n",
 			ctrl_info->ofa_cancel_reason);
-		pqi_ofa_free_host_buffer(ctrl_info);
+		pqi_host_free_buffer(ctrl_info, &ctrl_info->ofa_memory);
 		pqi_ctrl_ofa_done(ctrl_info);
 		break;
 	default:
@@ -7883,6 +7883,9 @@ static void pqi_ctrl_update_feature_flags(struct pqi_ctrl_info *ctrl_info,
 	case PQI_FIRMWARE_FEATURE_MULTI_LUN_DEVICE_SUPPORT:
 		ctrl_info->multi_lun_device_supported = firmware_feature->enabled;
 		break;
+	case PQI_FIRMWARE_FEATURE_CTRL_LOGGING:
+		ctrl_info->ctrl_logging_supported = firmware_feature->enabled;
+		break;
 	}
 
 	pqi_firmware_feature_status(ctrl_info, firmware_feature);
@@ -7988,6 +7991,11 @@ static struct pqi_firmware_feature pqi_firmware_features[] = {
 		.feature_bit = PQI_FIRMWARE_FEATURE_MULTI_LUN_DEVICE_SUPPORT,
 		.feature_status = pqi_ctrl_update_feature_flags,
 	},
+	{
+		.feature_name = "Controller Data Logging",
+		.feature_bit = PQI_FIRMWARE_FEATURE_CTRL_LOGGING,
+		.feature_status = pqi_ctrl_update_feature_flags,
+	},
 };
 
 static void pqi_process_firmware_features(
@@ -8090,6 +8098,7 @@ static void pqi_ctrl_reset_config(struct pqi_ctrl_info *ctrl_info)
 	ctrl_info->firmware_triage_supported = false;
 	ctrl_info->rpl_extended_format_4_5_supported = false;
 	ctrl_info->multi_lun_device_supported = false;
+	ctrl_info->ctrl_logging_supported = false;
 }
 
 static int pqi_process_config_table(struct pqi_ctrl_info *ctrl_info)
@@ -8230,6 +8239,9 @@ static void pqi_perform_lockup_action(void)
 	}
 }
 
+#define PQI_CTRL_LOG_TOTAL_SIZE	(4 * 1024 * 1024)
+#define PQI_CTRL_LOG_MIN_SIZE	(PQI_CTRL_LOG_TOTAL_SIZE / PQI_HOST_MAX_SG_DESCRIPTORS)
+
 static int pqi_ctrl_init(struct pqi_ctrl_info *ctrl_info)
 {
 	int rc;
@@ -8241,6 +8253,12 @@ static int pqi_ctrl_init(struct pqi_ctrl_info *ctrl_info)
 			if (rc)
 				return rc;
 		}
+		if (sis_is_ctrl_logging_supported(ctrl_info)) {
+			sis_notify_kdump(ctrl_info);
+			rc = sis_wait_for_ctrl_logging_completion(ctrl_info);
+			if (rc)
+				return rc;
+		}
 		sis_soft_reset(ctrl_info);
 		ssleep(PQI_POST_RESET_DELAY_SECS);
 	} else {
@@ -8422,6 +8440,11 @@ static int pqi_ctrl_init(struct pqi_ctrl_info *ctrl_info)
 	if (rc)
 		return rc;
 
+	if (ctrl_info->ctrl_logging_supported && !reset_devices) {
+		pqi_host_setup_buffer(ctrl_info, &ctrl_info->ctrl_log_memory, PQI_CTRL_LOG_TOTAL_SIZE, PQI_CTRL_LOG_MIN_SIZE);
+		pqi_host_memory_update(ctrl_info, &ctrl_info->ctrl_log_memory, PQI_VENDOR_GENERAL_CTRL_LOG_MEMORY_UPDATE);
+	}
+
 	rc = pqi_get_ctrl_product_details(ctrl_info);
 	if (rc) {
 		dev_err(&ctrl_info->pci_dev->dev,
@@ -8606,8 +8629,22 @@ static int pqi_ctrl_init_resume(struct pqi_ctrl_info *ctrl_info)
 		return rc;
 	}
 
-	if (pqi_ofa_in_progress(ctrl_info))
+	if (pqi_ofa_in_progress(ctrl_info)) {
 		pqi_ctrl_unblock_scan(ctrl_info);
+		if (ctrl_info->ctrl_logging_supported) {
+			if (!ctrl_info->ctrl_log_memory.host_memory)
+				pqi_host_setup_buffer(ctrl_info,
+					&ctrl_info->ctrl_log_memory,
+					PQI_CTRL_LOG_TOTAL_SIZE,
+					PQI_CTRL_LOG_MIN_SIZE);
+			pqi_host_memory_update(ctrl_info,
+				&ctrl_info->ctrl_log_memory, PQI_VENDOR_GENERAL_CTRL_LOG_MEMORY_UPDATE);
+		} else {
+			if (ctrl_info->ctrl_log_memory.host_memory)
+				pqi_host_free_buffer(ctrl_info,
+					&ctrl_info->ctrl_log_memory);
+		}
+	}
 
 	pqi_scan_scsi_devices(ctrl_info);
 
@@ -8797,6 +8834,7 @@ static void pqi_remove_ctrl(struct pqi_ctrl_info *ctrl_info)
 		pqi_fail_all_outstanding_requests(ctrl_info);
 		ctrl_info->pqi_mode_enabled = false;
 	}
+	pqi_host_free_buffer(ctrl_info, &ctrl_info->ctrl_log_memory);
 	pqi_unregister_scsi(ctrl_info);
 	if (ctrl_info->pqi_mode_enabled)
 		pqi_revert_to_sis_mode(ctrl_info);
@@ -8822,177 +8860,187 @@ static void pqi_ofa_ctrl_unquiesce(struct pqi_ctrl_info *ctrl_info)
 	pqi_ctrl_unblock_scan(ctrl_info);
 }
 
-static int pqi_ofa_alloc_mem(struct pqi_ctrl_info *ctrl_info, u32 total_size, u32 chunk_size)
+static int pqi_ofa_ctrl_restart(struct pqi_ctrl_info *ctrl_info, unsigned int delay_secs)
+{
+	ssleep(delay_secs);
+
+	return pqi_ctrl_init_resume(ctrl_info);
+}
+
+static int pqi_host_alloc_mem(struct pqi_ctrl_info *ctrl_info,
+	struct pqi_host_memory_descriptor *host_memory_descriptor,
+	u32 total_size, u32 chunk_size)
 {
 	int i;
 	u32 sg_count;
 	struct device *dev;
-	struct pqi_ofa_memory *ofap;
+	struct pqi_host_memory *host_memory;
 	struct pqi_sg_descriptor *mem_descriptor;
 	dma_addr_t dma_handle;
 
-	ofap = ctrl_info->pqi_ofa_mem_virt_addr;
-
 	sg_count = DIV_ROUND_UP(total_size, chunk_size);
-	if (sg_count == 0 || sg_count > PQI_OFA_MAX_SG_DESCRIPTORS)
+	if (sg_count == 0 || sg_count > PQI_HOST_MAX_SG_DESCRIPTORS)
 		goto out;
 
-	ctrl_info->pqi_ofa_chunk_virt_addr = kmalloc_array(sg_count, sizeof(void *), GFP_KERNEL);
-	if (!ctrl_info->pqi_ofa_chunk_virt_addr)
+	host_memory_descriptor->host_chunk_virt_address = kmalloc(sg_count * sizeof(void *), GFP_KERNEL);
+	if (!host_memory_descriptor->host_chunk_virt_address)
 		goto out;
 
 	dev = &ctrl_info->pci_dev->dev;
+	host_memory = host_memory_descriptor->host_memory;
 
 	for (i = 0; i < sg_count; i++) {
-		ctrl_info->pqi_ofa_chunk_virt_addr[i] =
-			dma_alloc_coherent(dev, chunk_size, &dma_handle, GFP_KERNEL);
-		if (!ctrl_info->pqi_ofa_chunk_virt_addr[i])
+		host_memory_descriptor->host_chunk_virt_address[i] = dma_alloc_coherent(dev, chunk_size, &dma_handle, GFP_KERNEL);
+		if (!host_memory_descriptor->host_chunk_virt_address[i])
 			goto out_free_chunks;
-		mem_descriptor = &ofap->sg_descriptor[i];
+		mem_descriptor = &host_memory->sg_descriptor[i];
 		put_unaligned_le64((u64)dma_handle, &mem_descriptor->address);
 		put_unaligned_le32(chunk_size, &mem_descriptor->length);
 	}
 
 	put_unaligned_le32(CISS_SG_LAST, &mem_descriptor->flags);
-	put_unaligned_le16(sg_count, &ofap->num_memory_descriptors);
-	put_unaligned_le32(sg_count * chunk_size, &ofap->bytes_allocated);
+	put_unaligned_le16(sg_count, &host_memory->num_memory_descriptors);
+	put_unaligned_le32(sg_count * chunk_size, &host_memory->bytes_allocated);
 
 	return 0;
 
 out_free_chunks:
 	while (--i >= 0) {
-		mem_descriptor = &ofap->sg_descriptor[i];
+		mem_descriptor = &host_memory->sg_descriptor[i];
 		dma_free_coherent(dev, chunk_size,
-			ctrl_info->pqi_ofa_chunk_virt_addr[i],
+			host_memory_descriptor->host_chunk_virt_address[i],
 			get_unaligned_le64(&mem_descriptor->address));
 	}
-	kfree(ctrl_info->pqi_ofa_chunk_virt_addr);
-
+	kfree(host_memory_descriptor->host_chunk_virt_address);
 out:
 	return -ENOMEM;
 }
 
-static int pqi_ofa_alloc_host_buffer(struct pqi_ctrl_info *ctrl_info)
+static int pqi_host_alloc_buffer(struct pqi_ctrl_info *ctrl_info,
+	struct pqi_host_memory_descriptor *host_memory_descriptor,
+	u32 total_required_size, u32 min_required_size)
 {
-	u32 total_size;
 	u32 chunk_size;
 	u32 min_chunk_size;
 
-	if (ctrl_info->ofa_bytes_requested == 0)
+	if (total_required_size == 0 || min_required_size == 0)
 		return 0;
 
-	total_size = PAGE_ALIGN(ctrl_info->ofa_bytes_requested);
-	min_chunk_size = DIV_ROUND_UP(total_size, PQI_OFA_MAX_SG_DESCRIPTORS);
+	total_required_size = PAGE_ALIGN(total_required_size);
+	min_required_size = PAGE_ALIGN(min_required_size);
+	min_chunk_size = DIV_ROUND_UP(total_required_size, PQI_HOST_MAX_SG_DESCRIPTORS);
 	min_chunk_size = PAGE_ALIGN(min_chunk_size);
 
-	for (chunk_size = total_size; chunk_size >= min_chunk_size;) {
-		if (pqi_ofa_alloc_mem(ctrl_info, total_size, chunk_size) == 0)
-			return 0;
-		chunk_size /= 2;
-		chunk_size = PAGE_ALIGN(chunk_size);
+	while (total_required_size >= min_required_size) {
+		for (chunk_size = total_required_size; chunk_size >= min_chunk_size;) {
+			if (pqi_host_alloc_mem(ctrl_info,
+				host_memory_descriptor, total_required_size,
+				chunk_size) == 0)
+				return 0;
+			chunk_size /= 2;
+			chunk_size = PAGE_ALIGN(chunk_size);
+		}
+		total_required_size /= 2;
+		total_required_size = PAGE_ALIGN(total_required_size);
 	}
 
 	return -ENOMEM;
 }
 
-static void pqi_ofa_setup_host_buffer(struct pqi_ctrl_info *ctrl_info)
+static void pqi_host_setup_buffer(struct pqi_ctrl_info *ctrl_info,
+	struct pqi_host_memory_descriptor *host_memory_descriptor,
+	u32 total_size, u32 min_size)
 {
 	struct device *dev;
-	struct pqi_ofa_memory *ofap;
+	struct pqi_host_memory *host_memory;
 
 	dev = &ctrl_info->pci_dev->dev;
 
-	ofap = dma_alloc_coherent(dev, sizeof(*ofap),
-		&ctrl_info->pqi_ofa_mem_dma_handle, GFP_KERNEL);
-	if (!ofap)
+	host_memory = dma_alloc_coherent(dev, sizeof(*host_memory),
+		&host_memory_descriptor->host_memory_dma_handle, GFP_KERNEL);
+	if (!host_memory)
 		return;
 
-	ctrl_info->pqi_ofa_mem_virt_addr = ofap;
+	host_memory_descriptor->host_memory = host_memory;
 
-	if (pqi_ofa_alloc_host_buffer(ctrl_info) < 0) {
-		dev_err(dev,
-			"failed to allocate host buffer for Online Firmware Activation\n");
-		dma_free_coherent(dev, sizeof(*ofap), ofap, ctrl_info->pqi_ofa_mem_dma_handle);
-		ctrl_info->pqi_ofa_mem_virt_addr = NULL;
+	if (pqi_host_alloc_buffer(ctrl_info, host_memory_descriptor,
+		total_size, min_size) < 0) {
+		dev_err(dev, "failed to allocate firmware usable host buffer\n");
+		dma_free_coherent(dev, sizeof(*host_memory), host_memory,
+			host_memory_descriptor->host_memory_dma_handle);
+		host_memory_descriptor->host_memory = NULL;
 		return;
 	}
-
-	put_unaligned_le16(PQI_OFA_VERSION, &ofap->version);
-	memcpy(&ofap->signature, PQI_OFA_SIGNATURE, sizeof(ofap->signature));
 }
 
-static void pqi_ofa_free_host_buffer(struct pqi_ctrl_info *ctrl_info)
+static void pqi_host_free_buffer(struct pqi_ctrl_info *ctrl_info,
+	struct pqi_host_memory_descriptor *host_memory_descriptor)
 {
 	unsigned int i;
 	struct device *dev;
-	struct pqi_ofa_memory *ofap;
+	struct pqi_host_memory *host_memory;
 	struct pqi_sg_descriptor *mem_descriptor;
 	unsigned int num_memory_descriptors;
 
-	ofap = ctrl_info->pqi_ofa_mem_virt_addr;
-	if (!ofap)
+	host_memory = host_memory_descriptor->host_memory;
+	if (!host_memory)
 		return;
 
 	dev = &ctrl_info->pci_dev->dev;
 
-	if (get_unaligned_le32(&ofap->bytes_allocated) == 0)
+	if (get_unaligned_le32(&host_memory->bytes_allocated) == 0)
 		goto out;
 
-	mem_descriptor = ofap->sg_descriptor;
-	num_memory_descriptors =
-		get_unaligned_le16(&ofap->num_memory_descriptors);
+	mem_descriptor = host_memory->sg_descriptor;
+	num_memory_descriptors = get_unaligned_le16(&host_memory->num_memory_descriptors);
 
 	for (i = 0; i < num_memory_descriptors; i++) {
 		dma_free_coherent(dev,
 			get_unaligned_le32(&mem_descriptor[i].length),
-			ctrl_info->pqi_ofa_chunk_virt_addr[i],
+			host_memory_descriptor->host_chunk_virt_address[i],
 			get_unaligned_le64(&mem_descriptor[i].address));
 	}
-	kfree(ctrl_info->pqi_ofa_chunk_virt_addr);
+	kfree(host_memory_descriptor->host_chunk_virt_address);
 
 out:
-	dma_free_coherent(dev, sizeof(*ofap), ofap,
-		ctrl_info->pqi_ofa_mem_dma_handle);
-	ctrl_info->pqi_ofa_mem_virt_addr = NULL;
+	dma_free_coherent(dev, sizeof(*host_memory), host_memory,
+		host_memory_descriptor->host_memory_dma_handle);
+	host_memory_descriptor->host_memory = NULL;
 }
 
-static int pqi_ofa_host_memory_update(struct pqi_ctrl_info *ctrl_info)
+static int pqi_host_memory_update(struct pqi_ctrl_info *ctrl_info,
+	struct pqi_host_memory_descriptor *host_memory_descriptor,
+	u16 function_code)
 {
 	u32 buffer_length;
 	struct pqi_vendor_general_request request;
-	struct pqi_ofa_memory *ofap;
+	struct pqi_host_memory *host_memory;
 
 	memset(&request, 0, sizeof(request));
 
 	request.header.iu_type = PQI_REQUEST_IU_VENDOR_GENERAL;
-	put_unaligned_le16(sizeof(request) - PQI_REQUEST_HEADER_LENGTH,
-		&request.header.iu_length);
-	put_unaligned_le16(PQI_VENDOR_GENERAL_HOST_MEMORY_UPDATE,
-		&request.function_code);
-
-	ofap = ctrl_info->pqi_ofa_mem_virt_addr;
-
-	if (ofap) {
-		buffer_length = offsetof(struct pqi_ofa_memory, sg_descriptor) +
-			get_unaligned_le16(&ofap->num_memory_descriptors) *
-			sizeof(struct pqi_sg_descriptor);
-
-		put_unaligned_le64((u64)ctrl_info->pqi_ofa_mem_dma_handle,
-			&request.data.ofa_memory_allocation.buffer_address);
-		put_unaligned_le32(buffer_length,
-			&request.data.ofa_memory_allocation.buffer_length);
+	put_unaligned_le16(sizeof(request) - PQI_REQUEST_HEADER_LENGTH, &request.header.iu_length);
+	put_unaligned_le16(function_code, &request.function_code);
+
+	host_memory = host_memory_descriptor->host_memory;
+
+	if (host_memory) {
+		buffer_length = offsetof(struct pqi_host_memory, sg_descriptor) + get_unaligned_le16(&host_memory->num_memory_descriptors) * sizeof(struct pqi_sg_descriptor);
+		put_unaligned_le64((u64)host_memory_descriptor->host_memory_dma_handle, &request.data.host_memory_allocation.buffer_address);
+		put_unaligned_le32(buffer_length, &request.data.host_memory_allocation.buffer_length);
+
+		if (function_code == PQI_VENDOR_GENERAL_OFA_MEMORY_UPDATE) {
+			put_unaligned_le16(PQI_OFA_VERSION, &host_memory->version);
+			memcpy(&host_memory->signature, PQI_OFA_SIGNATURE, sizeof(host_memory->signature));
+		} else if (function_code == PQI_VENDOR_GENERAL_CTRL_LOG_MEMORY_UPDATE) {
+			put_unaligned_le16(PQI_CTRL_LOG_VERSION, &host_memory->version);
+			memcpy(&host_memory->signature, PQI_CTRL_LOG_SIGNATURE, sizeof(host_memory->signature));
+		}
 	}
 
 	return pqi_submit_raid_request_synchronous(ctrl_info, &request.header, 0, NULL);
 }
 
-static int pqi_ofa_ctrl_restart(struct pqi_ctrl_info *ctrl_info, unsigned int delay_secs)
-{
-	ssleep(delay_secs);
-
-	return pqi_ctrl_init_resume(ctrl_info);
-}
-
 static struct pqi_raid_error_info pqi_ctrl_offline_raid_error_info = {
 	.data_out_result = PQI_DATA_IN_OUT_HARDWARE_ERROR,
 	.status = SAM_STAT_CHECK_CONDITION,
diff --git a/drivers/scsi/smartpqi/smartpqi_sis.c b/drivers/scsi/smartpqi/smartpqi_sis.c
index 673437c7152b..ca1df36b83f7 100644
--- a/drivers/scsi/smartpqi/smartpqi_sis.c
+++ b/drivers/scsi/smartpqi/smartpqi_sis.c
@@ -29,6 +29,7 @@
 #define SIS_ENABLE_INTX				0x80
 #define SIS_SOFT_RESET				0x100
 #define SIS_CMD_READY				0x200
+#define SIS_NOTIFY_KDUMP			0x400
 #define SIS_TRIGGER_SHUTDOWN			0x800000
 #define SIS_PQI_RESET_QUIESCE			0x1000000
 
@@ -52,6 +53,8 @@
 #define SIS_BASE_STRUCT_ALIGNMENT		16
 
 #define SIS_CTRL_KERNEL_FW_TRIAGE		0x3
+#define SIS_CTRL_KERNEL_CTRL_LOGGING		0x4
+#define SIS_CTRL_KERNEL_CTRL_LOGGING_STATUS	0x18
 #define SIS_CTRL_KERNEL_UP			0x80
 #define SIS_CTRL_KERNEL_PANIC			0x100
 #define SIS_CTRL_READY_TIMEOUT_SECS		180
@@ -65,6 +68,13 @@ enum sis_fw_triage_status {
 	FW_TRIAGE_COMPLETED
 };
 
+enum sis_ctrl_logging_status {
+	CTRL_LOGGING_NOT_STARTED = 0,
+	CTRL_LOGGING_STARTED,
+	CTRL_LOGGING_COND_INVALID,
+	CTRL_LOGGING_COMPLETED
+};
+
 #pragma pack(1)
 
 /* for use with SIS_CMD_INIT_BASE_STRUCT_ADDRESS command */
@@ -442,6 +452,21 @@ static inline enum sis_fw_triage_status
 		SIS_CTRL_KERNEL_FW_TRIAGE));
 }
 
+bool sis_is_ctrl_logging_supported(struct pqi_ctrl_info *ctrl_info)
+{
+	return readl(&ctrl_info->registers->sis_firmware_status) & SIS_CTRL_KERNEL_CTRL_LOGGING;
+}
+
+void sis_notify_kdump(struct pqi_ctrl_info *ctrl_info)
+{
+	sis_set_doorbell_bit(ctrl_info, SIS_NOTIFY_KDUMP);
+}
+
+static inline enum sis_ctrl_logging_status sis_read_ctrl_logging_status(struct pqi_ctrl_info *ctrl_info)
+{
+	return ((enum sis_ctrl_logging_status)((readl(&ctrl_info->registers->sis_firmware_status) & SIS_CTRL_KERNEL_CTRL_LOGGING_STATUS) >> 3));
+}
+
 void sis_soft_reset(struct pqi_ctrl_info *ctrl_info)
 {
 	writel(SIS_SOFT_RESET,
@@ -484,6 +509,41 @@ int sis_wait_for_fw_triage_completion(struct pqi_ctrl_info *ctrl_info)
 	return rc;
 }
 
+#define SIS_CTRL_LOGGING_STATUS_TIMEOUT_SECS		180
+#define SIS_CTRL_LOGGING_STATUS_POLL_INTERVAL_SECS	1
+
+int sis_wait_for_ctrl_logging_completion(struct pqi_ctrl_info *ctrl_info)
+{
+	int rc;
+	enum sis_ctrl_logging_status status;
+	unsigned long timeout;
+
+	timeout = (SIS_CTRL_LOGGING_STATUS_TIMEOUT_SECS * HZ) + jiffies;
+	while (1) {
+		status = sis_read_ctrl_logging_status(ctrl_info);
+		if (status == CTRL_LOGGING_COND_INVALID) {
+			dev_err(&ctrl_info->pci_dev->dev,
+				"controller data logging condition invalid\n");
+			rc = -EINVAL;
+			break;
+		} else if (status == CTRL_LOGGING_COMPLETED) {
+			rc = 0;
+			break;
+		}
+
+		if (time_after(jiffies, timeout)) {
+			dev_err(&ctrl_info->pci_dev->dev,
+				"timed out waiting for controller data logging status\n");
+			rc = -ETIMEDOUT;
+			break;
+		}
+
+		ssleep(SIS_CTRL_LOGGING_STATUS_POLL_INTERVAL_SECS);
+	}
+
+	return rc;
+}
+
 void sis_verify_structures(void)
 {
 	BUILD_BUG_ON(offsetof(struct sis_base_struct,
diff --git a/drivers/scsi/smartpqi/smartpqi_sis.h b/drivers/scsi/smartpqi/smartpqi_sis.h
index 0c97626d87d4..7e0eac3d07de 100644
--- a/drivers/scsi/smartpqi/smartpqi_sis.h
+++ b/drivers/scsi/smartpqi/smartpqi_sis.h
@@ -31,6 +31,9 @@ u32 sis_read_driver_scratch(struct pqi_ctrl_info *ctrl_info);
 void sis_soft_reset(struct pqi_ctrl_info *ctrl_info);
 u32 sis_get_product_id(struct pqi_ctrl_info *ctrl_info);
 int sis_wait_for_fw_triage_completion(struct pqi_ctrl_info *ctrl_info);
+bool sis_is_ctrl_logging_supported(struct pqi_ctrl_info *ctrl_info);
+void sis_notify_kdump(struct pqi_ctrl_info *ctrl_info);
+int sis_wait_for_ctrl_logging_completion(struct pqi_ctrl_info *ctrl_info);
 
 extern unsigned int sis_ctrl_ready_timeout_secs;
 
-- 
2.46.0.421.g159f2d50e7

