Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7BDAD334C25
	for <linux-scsi@vger.kernel.org>; Thu,  6 Nov 2025 16:39:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=68.232.153.233
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762447160; cv=none; b=MAaBwVD7SfR9xU62/67aNKT4Pyjz+wdgYkHqcgg2XdE78VmJmR3OoH8UJpc3KPTloHJzjhJCB17GruaORNUi2jfU9aIMv0jP72PxumfXr/waGeu2iObSDpMq9TtF5FvZaRNzxXhvH3JWcaO4b+vKu9l2Kgv1tM1xHG++5qDTIjs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762447160; c=relaxed/simple;
	bh=/6mNw+eR/QtYt+TkutR45DcRtbHRq3aA0PSiBlS6vZA=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=TvmLiABjWa11zAv6bhWjJQcamjOzRV1OzOxlw+0VQub1NIRNjk0cf/Hj1wVk3HUm2IxBar8kKuoz35c4SjUuicDKTuye2Xdf2G8XpV5VS5pzenjnP/RQxFR+aSU90rZLHlwoRZxzfY8c0Jju5pIHoaBlNBqHrrh+Sv5sW0DutK4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=microchip.com; spf=pass smtp.mailfrom=microchip.com; dkim=pass (2048-bit key) header.d=microchip.com header.i=@microchip.com header.b=gELUcr1g; arc=none smtp.client-ip=68.232.153.233
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=microchip.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=microchip.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=microchip.com header.i=@microchip.com header.b="gELUcr1g"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1762447155; x=1793983155;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=/6mNw+eR/QtYt+TkutR45DcRtbHRq3aA0PSiBlS6vZA=;
  b=gELUcr1gmyHSJTXv845GosmAOtjKSeZwUhwrvepzUCGgg6AsSM3j5MGt
   bIuPhpttxHjEXnSvIQhpmv7X+6mLkL6nQuDjtjr31scweX+lGHTIQXnnX
   5tsQ+j8EG/Q/tDhJQzuIpkgEmGrO1JZJ2xPk7jkn8ascuk689xSDw7pzW
   L1LLXIl+Ow5ZobRQt6BMQd2o2kDlXwB7rQnzW2LWbQ/uGp3L+GzPrt8ib
   exuBb2lJWcdBO5SWNG22D5QMIeFtfauf//lQ1RS3Y/nkuOTOUSKxiJHxj
   eKFwIeDxx+X72lmhiBD3blyHOw7Tw/1ydYS+I9eVV2qJs2mEJAvz0xJC8
   g==;
X-CSE-ConnectionGUID: p1tMouI0Q3+X2WA6PzuktQ==
X-CSE-MsgGUID: /Y3op/jSSsKeB7Ar01CbUg==
X-IronPort-AV: E=Sophos;i="6.19,284,1754982000"; 
   d="scan'208";a="280159947"
X-Amp-Result: SKIPPED(no attachment in message)
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa5.microchip.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 06 Nov 2025 09:39:06 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.58; Thu, 6 Nov 2025 09:38:29 -0700
Received: from brunhilda.pdev.net (10.10.85.11) by chn-vm-ex03.mchp-main.com
 (10.10.85.151) with Microsoft SMTP Server id 15.1.2507.58 via Frontend
 Transport; Thu, 6 Nov 2025 09:38:28 -0700
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
Subject: [PATCH 4/4] smartpqi: update version to 2.1.36-026
Date: Thu, 6 Nov 2025 10:38:22 -0600
Message-ID: <20251106163823.786828-5-don.brace@microchip.com>
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

Update driver version to 2.1.36-026

Reviewed-by: Scott Benesh <scott.benesh@microchip.com>
Reviewed-by: Scott Teel <scott.teel@microchip.com>
Reviewed-by: Gerry Morong <gerry.morong@microchip.com>
Signed-off-by: Don Brace <don.brace@microchip.com>
---
 drivers/scsi/smartpqi/smartpqi_init.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/smartpqi/smartpqi_init.c b/drivers/scsi/smartpqi/smartpqi_init.c
index 3886559a5eaa..fe549e2b7c94 100644
--- a/drivers/scsi/smartpqi/smartpqi_init.c
+++ b/drivers/scsi/smartpqi/smartpqi_init.c
@@ -34,11 +34,11 @@
 #define BUILD_TIMESTAMP
 #endif
 
-#define DRIVER_VERSION		"2.1.34-035"
+#define DRIVER_VERSION		"2.1.36-026"
 #define DRIVER_MAJOR		2
 #define DRIVER_MINOR		1
-#define DRIVER_RELEASE		34
-#define DRIVER_REVISION		35
+#define DRIVER_RELEASE		36
+#define DRIVER_REVISION		26
 
 #define DRIVER_NAME		"Microchip SmartPQI Driver (v" \
 				DRIVER_VERSION BUILD_TIMESTAMP ")"
-- 
2.52.0.rc0.28.g4cf919bd7b

