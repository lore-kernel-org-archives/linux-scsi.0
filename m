Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7CF319E819
	for <linux-scsi@vger.kernel.org>; Thu, 11 Jul 2024 19:47:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=68.232.154.123
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720727258; cv=none; b=jYoSjenxM92m8Y0Ssb9d0H1mIJOO0439olvIgNddkTrMDuHyjzGOe6wAYt8IclV1g/Ot16Zgf9KI/2NiYu/8PsUvSjfnWHPCArYI3Yy33LQFQxNCQ4TuJj6O0wTT3trvxTAWeJbFkVjw5yq9XVHTucHnQ/dXZeCWrbuMx8Xj8x0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720727258; c=relaxed/simple;
	bh=T/GzQbh0X4TKvXQbjdOYEp62TV3ZEQxPb0M8pfhIlpQ=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=hf+0RW+g+/IcwGekxdfY8ylZcaZXJkyX8Omwurah3ps4QVbkMUySTvMizPDxk8aX6K+xgiosP6gryYfGRpXgpxJvcEtmEuEyoFYkDIzEQFFjtZSATG0cI99wmYJiTmycQkGA3LTjDGcR3akDq31g4UvGovKtbHheH9et8EGczSE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=microchip.com; spf=pass smtp.mailfrom=microchip.com; dkim=pass (2048-bit key) header.d=microchip.com header.i=@microchip.com header.b=JlQRYg2S; arc=none smtp.client-ip=68.232.154.123
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=microchip.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=microchip.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=microchip.com header.i=@microchip.com header.b="JlQRYg2S"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1720727256; x=1752263256;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=T/GzQbh0X4TKvXQbjdOYEp62TV3ZEQxPb0M8pfhIlpQ=;
  b=JlQRYg2S+pWVDqtRxLVSEV9lvGVTmLqgVWm5xgKbqxXWcEWpLyrZE/MA
   jBo2k0dUMhjN4K+m9DpdOoBGS/laTxZlHSjzBNjERey5hBmlEK1mUfJg8
   eXS9GECy72YJg4DfeD3kbFCITi/x+P/qOXUp/1TAjlaRzUuJqtGQbUFrh
   2dqimNSN0MZPMaAxV/Jovm8i7AVtHQ/tuoo3nGv9Vl/TXsPy8mWuY3tCj
   CPznPuldyZSfE0Lur90TjC4xQtnVCynfbCce8WWEYRWsifcMkRMdt/njp
   j0dIH/Kmrcif+sYG9j5PhlZC/GEGNbb0bmxEuigTRnpOoYW7Mhw0tURGt
   w==;
X-CSE-ConnectionGUID: lpLBJxwkSjifens90ReNAw==
X-CSE-MsgGUID: VOATk1O5S1uPUuA7yuwiIQ==
X-IronPort-AV: E=Sophos;i="6.09,201,1716274800"; 
   d="scan'208";a="29106958"
X-Amp-Result: SKIPPED(no attachment in message)
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa4.microchip.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 11 Jul 2024 12:47:30 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.85.144) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Thu, 11 Jul 2024 12:47:09 -0700
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
Subject: [PATCH 5/5] smartpqi: update driver version to 2.1.28-025
Date: Thu, 11 Jul 2024 14:47:04 -0500
Message-ID: <20240711194704.982400-6-don.brace@microchip.com>
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

Update driver version to 2.1.28-025

Reviewed-by: Mike Tran <mike.tran@microchip.com>
Reviewed-by: Gerry Morong <gerry.morong@microchip.com>
Reviewed-by: Scott Benesh <scott.benesh@microchip.com>
Reviewed-by: Scott Teel <scott.teel@microchip.com>
Signed-off-by: Don Brace <don.brace@microchip.com>
---
 drivers/scsi/smartpqi/smartpqi_init.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/smartpqi/smartpqi_init.c b/drivers/scsi/smartpqi/smartpqi_init.c
index 0dd901445dcc..823cc97a9788 100644
--- a/drivers/scsi/smartpqi/smartpqi_init.c
+++ b/drivers/scsi/smartpqi/smartpqi_init.c
@@ -33,11 +33,11 @@
 #define BUILD_TIMESTAMP
 #endif
 
-#define DRIVER_VERSION		"2.1.26-030"
+#define DRIVER_VERSION		"2.1.28-025"
 #define DRIVER_MAJOR		2
 #define DRIVER_MINOR		1
-#define DRIVER_RELEASE		26
-#define DRIVER_REVISION		30
+#define DRIVER_RELEASE		28
+#define DRIVER_REVISION		25
 
 #define DRIVER_NAME		"Microchip SmartPQI Driver (v" \
 				DRIVER_VERSION BUILD_TIMESTAMP ")"
-- 
2.45.2.827.g557ae147e6

