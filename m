Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0B6E1CDFBC
	for <linux-scsi@vger.kernel.org>; Tue, 27 Aug 2024 18:55:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=68.232.154.123
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724784931; cv=none; b=QcQUiuZuwEP0Lrtx8mRDggbwvfASSnizqA5sG6a/8/GmeChuSVUP6dzgsZslW2hsUFrtS29rF10d2UZWSQXiT2ZmaZVlnDaCwRFlVAOZngbp41WQIuvum8x4RYLU8HuwKBpfYYseZsnQVcwaOI6tI4f38ebFLBnxXHaJKXAVqkc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724784931; c=relaxed/simple;
	bh=R46qk2BYMkVhF9ljRZtMv68fYf6KS5vYg98zqXGrGl8=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=n5zGgurbS9iPZ4o1yDTOj/SKkZYz6kdvq5A99pcBR8YJd3LgRIB8a+6is+/O01XjIX3EsiboQRxOMcCDkA3v16/R11SbzU9+Fdnh4sjngXnMTgkikyMjm2dSAQMsSQBIP99dx/s3P7YLn4KqhIm2mbe6PLZXeK1sar5L3jnCwqY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=microchip.com; spf=pass smtp.mailfrom=microchip.com; dkim=pass (2048-bit key) header.d=microchip.com header.i=@microchip.com header.b=0W/q6Ljk; arc=none smtp.client-ip=68.232.154.123
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=microchip.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=microchip.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=microchip.com header.i=@microchip.com header.b="0W/q6Ljk"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1724784929; x=1756320929;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=R46qk2BYMkVhF9ljRZtMv68fYf6KS5vYg98zqXGrGl8=;
  b=0W/q6Ljkwudns4TCAurGA2zvRCYGFSbIC1gJuP5Z2ugpbSazwpbEj/HF
   kHdSX4LrcfAXxa3xsAxRhM7WYjs8u1acxHFulBvjSNQ5jC11KIkvXicuB
   saBWWswCf/mvOCkGOvdl3KryVxnoNn1qFoQl8SlnOSGJ2c6O9xB6daO/5
   346I4701kUJJm0L03QYYvwjnmFNXKvqhJn6ROlYH7NS4740X8QwgzS2tB
   Y0fSwgIaXZyabosYKTs6WGOMgqb7+PaI5zlx86XnPQos5SbD99XofLUNa
   RFYajpsoyJzZSSVNmmyKYxViwEIU3SEQpMJ1xg0+lhnjDBn0dwc3AgYJ+
   g==;
X-CSE-ConnectionGUID: HXogS4E1Q5emAr2ic36fkw==
X-CSE-MsgGUID: m1q/b04RRUCdOVwJ6SwgEg==
X-IronPort-AV: E=Sophos;i="6.10,181,1719903600"; 
   d="scan'208";a="198399612"
X-Amp-Result: SKIPPED(no attachment in message)
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa6.microchip.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 27 Aug 2024 11:55:27 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Tue, 27 Aug 2024 11:54:57 -0700
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
Subject: [PATCH 2/7] smartpqi: correct stream detection
Date: Tue, 27 Aug 2024 13:54:56 -0500
Message-ID: <20240827185501.692804-3-don.brace@microchip.com>
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

Correct stream detection by initializing the structure
pqi_scsi_dev_raid_map_data to 0s.

When the OS issues SCSI READ commands, the driver erroneously
considers them as SCSI WRITES. If they are identified as sequential
IOs, the driver then submits those requests via the RAID path
instead of the AIO path.

The 'is_write' flag might be set for SCSI READ commands also.
The driver may interpret SCSI READ commands as SCSI WRITE
commands, resulting in IOs being submitted through the RAID path.

Note: This does not cause data corruption.

Reviewed-by: Scott Benesh <scott.benesh@microchip.com>
Reviewed-by: Scott Teel <scott.teel@microchip.com>
Reviewed-by: Mike McGowen <mike.mcgowen@microchip.com>
Signed-off-by: Mahesh Rajashekhara <mahesh.rajashekhara@microchip.com>
Signed-off-by: Don Brace <don.brace@microchip.com>
---
 drivers/scsi/smartpqi/smartpqi_init.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/smartpqi/smartpqi_init.c b/drivers/scsi/smartpqi/smartpqi_init.c
index 54f7fe843445..8e2e71ab49ae 100644
--- a/drivers/scsi/smartpqi/smartpqi_init.c
+++ b/drivers/scsi/smartpqi/smartpqi_init.c
@@ -5942,7 +5942,7 @@ static bool pqi_is_parity_write_stream(struct pqi_ctrl_info *ctrl_info,
 	int rc;
 	struct pqi_scsi_dev *device;
 	struct pqi_stream_data *pqi_stream_data;
-	struct pqi_scsi_dev_raid_map_data rmd;
+	struct pqi_scsi_dev_raid_map_data rmd = { 0 };
 
 	if (!ctrl_info->enable_stream_detection)
 		return false;
-- 
2.46.0.421.g159f2d50e7

