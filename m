Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93DD21D175F
	for <linux-scsi@vger.kernel.org>; Tue, 27 Aug 2024 18:55:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=68.232.154.123
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724784939; cv=none; b=mqSgDi0ogsgcR/pDGTYF3K6dETIptV2SQZL+pw+C3ZuB1FruotO6f2j/NgIS/5sur/MscHEk55npjf3TAo0Zbaa/ryjaQpM6IXU7GMYg376VHmyz0xecai1sBZ+zeUvZJ+GXm0EBIfhUGHAo6iPyni2fnqXttpbYXdUG+RpprtA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724784939; c=relaxed/simple;
	bh=wBGQAH0YW2S6oJ2JF3kclw61Rr2nwq8HPDdXycjqjEk=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=mSnaRuWcSCE7/ZTOY4kTUQK57rNf5+z69HdwjeVsM2DzP/TZniaMuYRcq/qT3+N5z40miEdMm2w6cwx2HwcrFWQVBz3Q21HSUCFMnhRCyhoRP2dRltBCXT79IhPt9VSg1YOVg1VsPh2+ZdqYo4lcNNOdVRSBm3I0ZLXtxECxM8c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=microchip.com; spf=pass smtp.mailfrom=microchip.com; dkim=pass (2048-bit key) header.d=microchip.com header.i=@microchip.com header.b=myJHQazB; arc=none smtp.client-ip=68.232.154.123
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=microchip.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=microchip.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=microchip.com header.i=@microchip.com header.b="myJHQazB"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1724784937; x=1756320937;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=wBGQAH0YW2S6oJ2JF3kclw61Rr2nwq8HPDdXycjqjEk=;
  b=myJHQazB4cjTH+55f/rmRbw90Nr0GdbyYKeGzmu+YuNTlU48yNdKtyK1
   yJJ/FR3s2XZ07Nz6bVY3Nto3+w63TDYByocg+tB9RG6LkDUg6WoQNHW9V
   Kb/W+W/y/ynofjImkAeFJXjMzkwnMRgB0oWm8x/9uzDz7W+iDPgTiOigp
   67fIwiJlLR8RAlMb0m9Sk+H33IiVDOKscK+KN5jSTQOLVZqkYhlHujHMa
   m4AL/RBhp19ymQeeLSdnnk5AWtKRZshYjnTCh6tFPgSmymvY5oV6q/qf2
   OQfJUta1LvBjwWHkUVaH9Ce0rjOzNkwq6vX0osChqZzwrG8x8qqE+LIjD
   g==;
X-CSE-ConnectionGUID: pic9PO9ETNS/SjIHijWoOQ==
X-CSE-MsgGUID: REFkMKnQSIeePBX/n+MfPQ==
X-IronPort-AV: E=Sophos;i="6.10,181,1719903600"; 
   d="scan'208";a="31626339"
X-Amp-Result: SKIPPED(no attachment in message)
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa2.microchip.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 27 Aug 2024 11:55:37 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Tue, 27 Aug 2024 11:55:07 -0700
Received: from brunhilda.pdev.net (10.10.85.11) by chn-vm-ex01.mchp-main.com
 (10.10.85.143) with Microsoft SMTP Server id 15.1.2507.35 via Frontend
 Transport; Tue, 27 Aug 2024 11:55:07 -0700
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
Subject: [PATCH 7/7] smartpqi: update driver version to 2.1.30-031
Date: Tue, 27 Aug 2024 13:55:01 -0500
Message-ID: <20240827185501.692804-8-don.brace@microchip.com>
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

Update driver version to 2.1.30-031

Reviewed-by: David Strahan <david.strahan@microchip.com>
Reviewed-by: Scott Benesh <scott.benesh@microchip.com>
Reviewed-by: Scott Teel <scott.teel@microchip.com>
Reviewed-by: Mike McGowen <mike.mcgowen@microchip.com>
Reviewed-by: Gerry Morong <gerry.morong@microchip.com>
Signed-off-by: Don Brace <don.brace@microchip.com>
---
 drivers/scsi/smartpqi/smartpqi_init.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/smartpqi/smartpqi_init.c b/drivers/scsi/smartpqi/smartpqi_init.c
index 0dab30753f0a..7fd5a8c813dc 100644
--- a/drivers/scsi/smartpqi/smartpqi_init.c
+++ b/drivers/scsi/smartpqi/smartpqi_init.c
@@ -33,11 +33,11 @@
 #define BUILD_TIMESTAMP
 #endif
 
-#define DRIVER_VERSION		"2.1.28-025"
+#define DRIVER_VERSION		"2.1.30-031"
 #define DRIVER_MAJOR		2
 #define DRIVER_MINOR		1
-#define DRIVER_RELEASE		28
-#define DRIVER_REVISION		25
+#define DRIVER_RELEASE		30
+#define DRIVER_REVISION		31
 
 #define DRIVER_NAME		"Microchip SmartPQI Driver (v" \
 				DRIVER_VERSION BUILD_TIMESTAMP ")"
-- 
2.46.0.421.g159f2d50e7

