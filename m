Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F21A79F5
	for <linux-scsi@vger.kernel.org>; Wed, 23 Apr 2025 18:33:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=68.232.153.233
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745433186; cv=none; b=dYJwNlLAtsupPqRVGnYOCuae2S13uuBM8OXuBQz6TYE/y+LO+7wb9ADl+8BYgMgD1RSLVMLUzkLHn3nWWKKTy1fUwqMHNWemQj/z113yRclATRNHKuswISmTPWWeJSNWGfckNzN5z7Y8l739z5nXtJKm/oI9+aR3/wULI+bi1gY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745433186; c=relaxed/simple;
	bh=JxNn2p4Y196/abv20N2vRvYq4I9ql3aqZqEPczfnVu8=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=KlWK7LZYrZrU07k05jKY2r7LjnlIm8vp4XJWqOln2oMjlE9iMC67pDuCjb125gHv/2nQOOunDbICXIouFuSOUpuDNVXg6Dl9ZROjyC8swGnKKS1Q9DaFR77Y4zvzmkB+Pqx0gIztjKc0QMncJTCGgyIcJZUTe8o27lJL1kQ0bO4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=microchip.com; spf=pass smtp.mailfrom=microchip.com; dkim=pass (2048-bit key) header.d=microchip.com header.i=@microchip.com header.b=ME8qDu4p; arc=none smtp.client-ip=68.232.153.233
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=microchip.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=microchip.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=microchip.com header.i=@microchip.com header.b="ME8qDu4p"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1745433186; x=1776969186;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=JxNn2p4Y196/abv20N2vRvYq4I9ql3aqZqEPczfnVu8=;
  b=ME8qDu4pCn4hZEmMibmQcvIvCzCMhH0GpYM0tZm/VQ2T3OEGsaIpCv0F
   K4BLHH7Bs/r/7T3RcYDEZ2307rPKKPI88a5jkt41PE5aHGJddJv/470es
   i6Phj97g/m2wvcVMvoDhzCXpPo7YO5Xvb8dLZt3UjB/LnKRRcMUe9u5mH
   n9wPh2/M3SthuPoITNJwwjpNyNwgdw0v81CN8yGiTtNHdU9TEqU6ggl8N
   9tyQ99tktuUFVExMvPH2jazBWTg5cnJItbb5wfw1GT2J0K4w9sbMSsEKD
   Z2CjyPVkLOJ4XzrkvbLEsxI3uvBr5nB5CPLxVF6kfYWjPKfwCBLR0H/DA
   A==;
X-CSE-ConnectionGUID: whCUM/FPRpqRy+T/Tuj6Xw==
X-CSE-MsgGUID: qb6elJGaRiKl0nl37ZJkaw==
X-IronPort-AV: E=Sophos;i="6.15,233,1739862000"; 
   d="scan'208";a="40821212"
X-Amp-Result: SKIPPED(no attachment in message)
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa3.microchip.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 23 Apr 2025 11:33:05 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.44; Wed, 23 Apr 2025 11:32:34 -0700
Received: from brunhilda.pdev.net (10.10.85.11) by chn-vm-ex04.mchp-main.com
 (10.10.85.152) with Microsoft SMTP Server id 15.1.2507.44 via Frontend
 Transport; Wed, 23 Apr 2025 11:32:33 -0700
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
Subject: [PATCH 3/5] Enhance WWID Logging Logic.
Date: Wed, 23 Apr 2025 13:32:27 -0500
Message-ID: <20250423183229.538572-4-don.brace@microchip.com>
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

From: Venkatesh Emparala <Venkatesh.Emparala@microchip.com>

Log the extended WWID for NVMe devices and for devices that have the
firmware feature bit "PQI_FIRMWARE_FEATURE_RPL_EXTENDED_FORMAT_4_5"
enabled.

Log 8-bytes otherwise.

Reviewed-by: Scott Teel <scott.teel@microchip.com>
Reviewed-by: Scott Benesh <scott.benesh@microchip.com>
Reviewed-by: Mike McGowen <mike.mcgowen@microchip.com>
Signed-off-by: Venkatesh Emparala <Venkatesh.Emparala@microchip.com>
Signed-off-by: Don Brace <don.brace@microchip.com>
---
 drivers/scsi/smartpqi/smartpqi_init.c | 23 ++++++++++++++++++-----
 1 file changed, 18 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/smartpqi/smartpqi_init.c b/drivers/scsi/smartpqi/smartpqi_init.c
index 3cb8619e9ce9..efc042071ec0 100644
--- a/drivers/scsi/smartpqi/smartpqi_init.c
+++ b/drivers/scsi/smartpqi/smartpqi_init.c
@@ -2011,18 +2011,31 @@ static void pqi_dev_info(struct pqi_ctrl_info *ctrl_info,
 			PQI_DEV_INFO_BUFFER_LENGTH - count,
 			"-:-");
 
-	if (pqi_is_logical_device(device))
+	if (pqi_is_logical_device(device)) {
 		count += scnprintf(buffer + count,
 			PQI_DEV_INFO_BUFFER_LENGTH - count,
 			" %08x%08x",
 			*((u32 *)&device->scsi3addr),
 			*((u32 *)&device->scsi3addr[4]));
-	else
+	} else if (ctrl_info->rpl_extended_format_4_5_supported) {
+		if (device->device_type == SA_DEVICE_TYPE_NVME)
+			count += scnprintf(buffer + count,
+					PQI_DEV_INFO_BUFFER_LENGTH - count,
+					" %016llx%016llx",
+					get_unaligned_be64(&device->wwid[0]),
+					get_unaligned_be64(&device->wwid[8]));
+		else
+			count += scnprintf(buffer + count,
+					PQI_DEV_INFO_BUFFER_LENGTH - count,
+					" %016llx",
+					get_unaligned_be64(&device->wwid[0]));
+	} else {
 		count += scnprintf(buffer + count,
 			PQI_DEV_INFO_BUFFER_LENGTH - count,
-			" %016llx%016llx",
-			get_unaligned_be64(&device->wwid[0]),
-			get_unaligned_be64(&device->wwid[8]));
+			" %016llx",
+			get_unaligned_be64(&device->wwid[0]));
+	}
+
 
 	count += scnprintf(buffer + count, PQI_DEV_INFO_BUFFER_LENGTH - count,
 		" %s %.8s %.16s ",
-- 
2.49.0.391.g4bbb303af6

