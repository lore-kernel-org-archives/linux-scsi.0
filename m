Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1AC819E825
	for <linux-scsi@vger.kernel.org>; Thu, 11 Jul 2024 19:47:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=68.232.154.123
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720727258; cv=none; b=XFnG43+TxJp/GxAhhbMUvJ1qCtww9b+451NsoHvLrQHL2vJEYVMJYm6PSemzesA0iTnxvJNomvgLq4KVlFbarP0c5vGhyNIzaQ9POaE3G8lFWDPqHVwrfxBrNPcC9iH2qwNiCohigO+QT9EwRghDlRm+CjfEO4UVu1Foqg5Ejdg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720727258; c=relaxed/simple;
	bh=oO9Tw88Vkqve2FQkvrtllfQzvVcTZz4MwbuIcCou+Yc=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=SLFxOBlrI8hC/ZK0gYGLdR5cff0r+RzqhZCX1qWgU/TwMiMU6T6fr7/KPLQCIxFqi9pmnnjb9ovHioybjd9IAlhe/u1i6YwGzVW32C1mnKd94YFIBXs/UiNgVo44NQUysmEn/dTr7bW2TLeC66AWvPwcmWeXHxFLWFI2h2MWUzI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=microchip.com; spf=pass smtp.mailfrom=microchip.com; dkim=pass (2048-bit key) header.d=microchip.com header.i=@microchip.com header.b=G/yLc19n; arc=none smtp.client-ip=68.232.154.123
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=microchip.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=microchip.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=microchip.com header.i=@microchip.com header.b="G/yLc19n"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1720727256; x=1752263256;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=oO9Tw88Vkqve2FQkvrtllfQzvVcTZz4MwbuIcCou+Yc=;
  b=G/yLc19nyq/rFkj5q5XHMjvhXYKNwhyswTQL+dxNS9+HdkprtiTfL7jj
   K3Tp1vzTbZuWOGhQjUyYRfb2639UYRWyuApO4eVNWxblYswq80vG4B4lo
   Hei6UhxjPuws6QdZQuO2OoO971O7vslQe6LTZxtSPYpYo4YyBClepVQlN
   JptcMNewBlRgG+lk3pnngE7u1hV+UGqDRiU25M1HV1G8OTjqvf1962UMJ
   j411ObMD2DnQokJyRpCllaQELrowS/9xWJnoBfVNcS8iTmF5iiHrwMe9f
   4bNi1VtvxmDpPtLmmFODz1lAqtoH3w5cLBk2CzoqT7P4GdJnvAPcxdYiT
   A==;
X-CSE-ConnectionGUID: lpLBJxwkSjifens90ReNAw==
X-CSE-MsgGUID: ScTUQmqgQm+3EGHis7Izwg==
X-IronPort-AV: E=Sophos;i="6.09,201,1716274800"; 
   d="scan'208";a="29106957"
X-Amp-Result: SKIPPED(no attachment in message)
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa4.microchip.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 11 Jul 2024 12:47:30 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.85.144) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Thu, 11 Jul 2024 12:47:08 -0700
Received: from brunhilda.pdev.net (10.10.85.11) by chn-vm-ex02.mchp-main.com
 (10.10.85.144) with Microsoft SMTP Server id 15.1.2507.35 via Frontend
 Transport; Thu, 11 Jul 2024 12:47:08 -0700
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
Subject: [PATCH 4/5] smartpqi: fix improve handling of multipath failover
Date: Thu, 11 Jul 2024 14:47:03 -0500
Message-ID: <20240711194704.982400-5-don.brace@microchip.com>
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

Improve multipath fail-overs by mapping firmware errors into
I/O errors.

In some rare instances, firmware does not return the proper error code
for I/O errors caused by a multipath path failure.

Map I/O errors returned by firmware into errors that help the multipath
layer to detect the failure of a path.

Reviewed-by: Gerry Morong <gerry.morong@microchip.com>
Reviewed-by: Scott Benesh <scott.benesh@microchip.com>
Reviewed-by: Scott Teel <scott.teel@microchip.com>
Reviewed-by: Mike McGowen <mike.mcgowen@microchip.com>
Signed-off-by: Kevin Barnett <kevin.barnett@microchip.com>
Signed-off-by: Don Brace <don.brace@microchip.com>
---
 drivers/scsi/smartpqi/smartpqi_init.c | 16 +++++++++++++++-
 1 file changed, 15 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/smartpqi/smartpqi_init.c b/drivers/scsi/smartpqi/smartpqi_init.c
index d8df7440bbe1..0dd901445dcc 100644
--- a/drivers/scsi/smartpqi/smartpqi_init.c
+++ b/drivers/scsi/smartpqi/smartpqi_init.c
@@ -3247,6 +3247,20 @@ static void pqi_process_raid_io_error(struct pqi_io_request *io_request)
 			sense_data_length);
 	}
 
+	if (pqi_cmd_priv(scmd)->this_residual &&
+		!pqi_is_logical_device(scmd->device->hostdata) &&
+		scsi_status == SAM_STAT_CHECK_CONDITION &&
+		host_byte == DID_OK &&
+		sense_data_length &&
+		scsi_normalize_sense(error_info->data, sense_data_length, &sshdr) &&
+		sshdr.sense_key == ILLEGAL_REQUEST &&
+		sshdr.asc == 0x26 &&
+		sshdr.ascq == 0x0) {
+			host_byte = DID_NO_CONNECT;
+			pqi_take_device_offline(scmd->device, "AIO");
+			scsi_build_sense_buffer(0, scmd->sense_buffer, HARDWARE_ERROR, 0x3e, 0x1);
+	}
+
 	scmd->result = scsi_status;
 	set_host_byte(scmd, host_byte);
 }
@@ -6021,7 +6035,7 @@ static int pqi_scsi_queue_command(struct Scsi_Host *shost, struct scsi_cmnd *scm
 
 	ctrl_info = shost_to_hba(shost);
 
-	if (pqi_ctrl_offline(ctrl_info) || pqi_device_in_remove(device)) {
+	if (pqi_ctrl_offline(ctrl_info) || pqi_device_offline(device) || pqi_device_in_remove(device)) {
 		set_host_byte(scmd, DID_NO_CONNECT);
 		pqi_scsi_done(scmd);
 		return 0;
-- 
2.45.2.827.g557ae147e6

