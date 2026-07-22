Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8FB85438033
	for <linux-scsi@vger.kernel.org>; Wed, 22 Jul 2026 20:23:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=68.232.154.123
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784751822; cv=none; b=YeuMRWDbKo5qDkNRQPWP4HNdFryhx5Zb+/5L3snALKbQFtdNjBZlIwwWqFuq1gS7LAIV/yrBw3YX7cG0+QV1jFVA/uXOIUvX7raWiHpaNTHCFd5xoZhquRjEIhOeudZH2rWXpLIpUbhBuPL/OfoYxr48xVdmp3a5VWHCgRcDR1k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784751822; c=relaxed/simple;
	bh=6FBzIc1FVcbv5b3Y+Vsx38EgHa3xfyWzqwuiqH4WvNs=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=qIsM6zbZEtdQOWAZEe5+xc0LE0i4TYzwtL0M3Dxn/7gGH4V9M2ACThbnolB00msMGzkxmy0rvbFS6cwO9zkgoO6tfRM4D69+gnsJnvH1Wy22qOYoEH5Vke3Gf+3lLV4pq+988Cw3zxa04lXlS82CGfV6TxP6VH1kNCiPt6n5l94=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=microchip.com; spf=pass smtp.mailfrom=microchip.com; dkim=pass (2048-bit key) header.d=microchip.com header.i=@microchip.com header.b=D4FMd9G0; arc=none smtp.client-ip=68.232.154.123
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=microchip.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=microchip.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=microchip.com header.i=@microchip.com header.b="D4FMd9G0"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1784751820; x=1816287820;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=6FBzIc1FVcbv5b3Y+Vsx38EgHa3xfyWzqwuiqH4WvNs=;
  b=D4FMd9G0SJlq9uaWY4roMsbrvvPJRPNuMYvpyvRl/6LBcfDo4hiGq6Vq
   XUVwyz6d+eB6n7BDv9hAqotvmYEP3oVqb8QSfdnjoz0vcKRLnGztfivpK
   JEHVdPQO2ddLKdMxwU0u7u9c6Aa9l6cv4xttmLfThv4S1nJkuae8TmlXm
   RMe4/2UFAc1qq+AgzgM7HO1X+fAJC2EIzopDr3dElla7KIWtMW5kW5BGF
   vfhLyvE1eZCmhTZPbB7tjEf6E+g4zb5FiKKRN86XCmJdgtUclceBYVfT2
   zz9nmJ6lCAolVDzbsdBUTq+zbHhEs1ZOfp7V5KaVMlX47amauk/uzcU7m
   w==;
X-CSE-ConnectionGUID: bceh3xWkSOaMSyonqO5K2Q==
X-CSE-MsgGUID: jUM0qGX8QrauvzxN0J0DQQ==
X-IronPort-AV: E=Sophos;i="6.25,179,1779174000"; 
   d="scan'208";a="60160551"
X-Amp-Result: SKIPPED(no attachment in message)
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa4.microchip.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 22 Jul 2026 13:23:38 -0700
Received: from dks-rocky10u1-dev.pdev.net (10.10.85.11) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.58; Wed, 22 Jul 2026 13:23:38 -0700
From: David Strahan <david.strahan@microchip.com>
To: <david.strahan@microchip.com>, <linux-scsi@vger.kernel.org>
CC: <don.brace@microchip.com>
Subject: [PATCH] scsi: smartpqi: add support for CCISS_BIG_PASSTHRU ioctl
Date: Wed, 22 Jul 2026 15:23:25 -0500
Message-ID: <20260722202327.5242-2-david.strahan@microchip.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260722202327.5242-1-david.strahan@microchip.com>
References: <20260722202327.5242-1-david.strahan@microchip.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: chn-vm-ex01.mchp-main.com (10.10.85.143) To
 chn-vm-ex01.mchp-main.com (10.10.85.143)

From: David Strahan <David.Strahan@microchip.com>

Add pqi_big_passthru_ioctl() to handle CCISS_BIG_PASSTHRU ioctl
requests. The existing passthru ioctl uses a 16-bit integer for
the I/O buffer size, limiting transfers to 64KB. The big passthru
ioctl uses BIG_IOCTL_Command_struct which stores the buffer size as
a 32-bit integer, allowing larger transfers required by some
management utilities.

Add CCISS_BIG_PASSTHRU_SUPPORTED to uapi/linux/cciss_ioctl.h and
return 0 from pqi_ioctl() to advertise driver support.
Userspace tools can send this ioctl to probe whether the driver
supports CCISS_BIG_PASSTHRU before issuing it.

Co-developed-by: Mike McGowen <mike.mcgowen@microchip.com>
Signed-off-by: Mike McGowen <mike.mcgowen@microchip.com>
Signed-off-by: David Strahan <david.strahan@microchip.com>
Acked-by: Don Brace <don.brace@microchip.com>
---
 drivers/scsi/smartpqi/smartpqi_init.c | 144 ++++++++++++++++++++++++++
 include/uapi/linux/cciss_ioctl.h      |   1 +
 2 files changed, 145 insertions(+)

diff --git a/drivers/scsi/smartpqi/smartpqi_init.c b/drivers/scsi/smartpqi/smartpqi_init.c
index 3a75b9f..473f1c9 100644
--- a/drivers/scsi/smartpqi/smartpqi_init.c
+++ b/drivers/scsi/smartpqi/smartpqi_init.c
@@ -6935,6 +6935,144 @@ out:
 	return rc;
 }
 
+static int pqi_big_passthru_ioctl(struct pqi_ctrl_info *ctrl_info, void __user *arg)
+{
+	int rc;
+	char *kernel_buffer = NULL;
+	u16 iu_length;
+	size_t sense_data_length;
+	BIG_IOCTL_Command_struct iocommand;
+	struct pqi_raid_path_request request;
+	struct pqi_raid_error_info pqi_error_info;
+	struct ciss_error_info ciss_error_info;
+
+	if (pqi_ctrl_offline(ctrl_info))
+		return -ENXIO;
+	if (pqi_ofa_in_progress(ctrl_info) && pqi_ctrl_blocked(ctrl_info))
+		return -EBUSY;
+	if (!arg)
+		return -EINVAL;
+	if (!capable(CAP_SYS_RAWIO))
+		return -EPERM;
+	if (copy_from_user(&iocommand, arg, sizeof(iocommand)))
+		return -EFAULT;
+	if (iocommand.buf_size < 1 &&
+		iocommand.Request.Type.Direction != XFER_NONE)
+		return -EINVAL;
+	if (iocommand.Request.CDBLen > sizeof(request.cdb))
+		return -EINVAL;
+	if (iocommand.Request.Type.Type != TYPE_CMD)
+		return -EINVAL;
+
+	switch (iocommand.Request.Type.Direction) {
+	case XFER_NONE:
+	case XFER_WRITE:
+	case XFER_READ:
+	case XFER_READ | XFER_WRITE:
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	if (iocommand.buf_size > 0) {
+		kernel_buffer = kmalloc(iocommand.buf_size, GFP_KERNEL);
+		if (!kernel_buffer)
+			return -ENOMEM;
+		if (iocommand.Request.Type.Direction & XFER_WRITE) {
+			if (copy_from_user(kernel_buffer, iocommand.buf,
+				iocommand.buf_size)) {
+				rc = -EFAULT;
+				goto out;
+			}
+		} else {
+			memset(kernel_buffer, 0, iocommand.buf_size);
+		}
+	}
+
+	memset(&request, 0, sizeof(request));
+
+	request.header.iu_type = PQI_REQUEST_IU_RAID_PATH_IO;
+	iu_length = offsetof(struct pqi_raid_path_request, sg_descriptors) -
+		PQI_REQUEST_HEADER_LENGTH;
+	memcpy(request.lun_number, iocommand.LUN_info.LunAddrBytes, sizeof(request.lun_number));
+	memcpy(request.cdb, iocommand.Request.CDB, iocommand.Request.CDBLen);
+	request.additional_cdb_bytes_usage = SOP_ADDITIONAL_CDB_BYTES_0;
+
+	switch (iocommand.Request.Type.Direction) {
+	case XFER_NONE:
+		request.data_direction = SOP_NO_DIRECTION_FLAG;
+		break;
+	case XFER_WRITE:
+		request.data_direction = SOP_WRITE_FLAG;
+		break;
+	case XFER_READ:
+		request.data_direction = SOP_READ_FLAG;
+		break;
+	case XFER_READ | XFER_WRITE:
+		request.data_direction = SOP_BIDIRECTIONAL;
+		break;
+	}
+
+	request.task_attribute = SOP_TASK_ATTRIBUTE_SIMPLE;
+
+	if (iocommand.buf_size > 0) {
+		put_unaligned_le32(iocommand.buf_size, &request.buffer_length);
+
+		rc = pqi_map_single(ctrl_info->pci_dev,
+			&request.sg_descriptors[0], kernel_buffer,
+			iocommand.buf_size, DMA_BIDIRECTIONAL);
+		if (rc)
+			goto out;
+
+		iu_length += sizeof(request.sg_descriptors[0]);
+	}
+
+	put_unaligned_le16(iu_length, &request.header.iu_length);
+
+	if (ctrl_info->raid_iu_timeout_supported)
+		put_unaligned_le32(iocommand.Request.Timeout, &request.timeout);
+
+	rc = pqi_submit_raid_request_synchronous(ctrl_info, &request.header,
+		PQI_SYNC_FLAGS_INTERRUPTABLE, &pqi_error_info);
+
+	if (iocommand.buf_size > 0)
+		pqi_pci_unmap(ctrl_info->pci_dev, request.sg_descriptors, 1, DMA_BIDIRECTIONAL);
+
+	memset(&iocommand.error_info, 0, sizeof(iocommand.error_info));
+
+	if (rc == 0) {
+		pqi_error_info_to_ciss(&pqi_error_info, &ciss_error_info);
+		iocommand.error_info.ScsiStatus = ciss_error_info.scsi_status;
+		iocommand.error_info.CommandStatus = ciss_error_info.command_status;
+		sense_data_length = ciss_error_info.sense_data_length;
+		if (sense_data_length) {
+			if (sense_data_length > sizeof(iocommand.error_info.SenseInfo))
+				sense_data_length = sizeof(iocommand.error_info.SenseInfo);
+			memcpy(iocommand.error_info.SenseInfo,
+				pqi_error_info.data, sense_data_length);
+			iocommand.error_info.SenseLen = sense_data_length;
+		}
+	}
+
+	if (copy_to_user(arg, &iocommand, sizeof(iocommand))) {
+		rc = -EFAULT;
+		goto out;
+	}
+
+	if (rc == 0 && iocommand.buf_size > 0 &&
+		(iocommand.Request.Type.Direction & XFER_READ)) {
+		if (copy_to_user(iocommand.buf, kernel_buffer,
+			iocommand.buf_size)) {
+			rc = -EFAULT;
+		}
+	}
+
+out:
+	kfree(kernel_buffer);
+
+	return rc;
+}
+
 static int pqi_ioctl(struct scsi_device *sdev, unsigned int cmd,
 		     void __user *arg)
 {
@@ -6958,6 +7096,12 @@ static int pqi_ioctl(struct scsi_device *sdev, unsigned int cmd,
 	case CCISS_PASSTHRU:
 		rc = pqi_passthru_ioctl(ctrl_info, arg);
 		break;
+	case CCISS_BIG_PASSTHRU:
+		rc = pqi_big_passthru_ioctl(ctrl_info, arg);
+		break;
+	case CCISS_BIG_PASSTHRU_SUPPORTED:
+		rc = 0;
+		break;
 	default:
 		rc = -EINVAL;
 		break;
diff --git a/include/uapi/linux/cciss_ioctl.h b/include/uapi/linux/cciss_ioctl.h
index 5622301..8295f1b 100644
--- a/include/uapi/linux/cciss_ioctl.h
+++ b/include/uapi/linux/cciss_ioctl.h
@@ -85,5 +85,6 @@ typedef struct _LogvolInfo_struct{
 #define CCISS_RESCANDISK   _IO(CCISS_IOC_MAGIC, 16)
 #define CCISS_GETLUNINFO   _IOR(CCISS_IOC_MAGIC, 17, LogvolInfo_struct)
 #define CCISS_BIG_PASSTHRU _IOWR(CCISS_IOC_MAGIC, 18, BIG_IOCTL_Command_struct)
+#define CCISS_BIG_PASSTHRU_SUPPORTED _IO(CCISS_IOC_MAGIC, 19)
 
 #endif /* _UAPICCISS_IOCTLH */
-- 
2.47.3

