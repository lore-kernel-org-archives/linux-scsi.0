Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C157D29CB24;
	Tue, 21 Apr 2026 21:20:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=68.232.153.233
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776806409; cv=none; b=fVy2/yLKbwWVFdxdVbbmZIByrOowtlTZdB3MJtq2eDLZAeLJj1zPK/9wip8Th6FflisZx4EjFaJI+x4My/TmXCHPk/2abllCewW4tigOII/B1dfDLMUiGwa/ArahdmiScfKQGg4Fj3EoZfwwTry4n3lXjqinGGmc5TaE2tfdDzw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776806409; c=relaxed/simple;
	bh=qP++HqK5+HNctbGjwnjNhR+DOU3bV7dRtm3vuwsJ+oY=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=sgoQlwA3FfLejttjcUGfx9UkJawHdjZvPYbtBbEBVwpFW/ZmSfZi596Jha9dDSe72fbb1llqJRjjPAYgRLAAix+gRBxoogvGU17O63TUFUBFQQj0vdU+ASM/ZrJ5O5D8cC+6uW3DDn/hELTdymaq1F9ccfYOMI4IfGw1Pbpz7kg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=microchip.com; spf=pass smtp.mailfrom=microchip.com; dkim=pass (2048-bit key) header.d=microchip.com header.i=@microchip.com header.b=Z0Cwx8QB; arc=none smtp.client-ip=68.232.153.233
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=microchip.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=microchip.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=microchip.com header.i=@microchip.com header.b="Z0Cwx8QB"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1776806406; x=1808342406;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=qP++HqK5+HNctbGjwnjNhR+DOU3bV7dRtm3vuwsJ+oY=;
  b=Z0Cwx8QB5nvyS83WEkB9ViFs8LqAwLkLLjTSUB8UePahLGSe+LPEBXDk
   a0oOCeFf7XX8FA5H9oB/r5ApCo1jQtrUHod5sKSGehDkasq7BupJBXm7m
   Na1wbQlpkrZ6gi+EGeXF+GU4BZm6BYf752gw/pnvoA5QVjZ90UryCi9Mu
   jWXm9eLYQmSwtK9wp6F6w9eRiI41XyK2HbeiBMIEpLj56URqOOucVI+z8
   XDHUHRs1sx0RllhGesr2Y3rTkwat4JII2/u8SuHQjRhTvQWPYlnUYR2Mu
   flxRau95pjyXZ4dlDWPIECVaaXCgQk8JxgZS9WshjfTMmIOS/CY9po2V7
   w==;
X-CSE-ConnectionGUID: p6p45Q1BTtynQgbu01/Y0A==
X-CSE-MsgGUID: 6qLn3UWcQBKSodIBJae7uw==
X-IronPort-AV: E=Sophos;i="6.23,192,1770620400"; 
   d="scan'208";a="56435724"
X-Amp-Result: SKIPPED(no attachment in message)
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa3.microchip.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 21 Apr 2026 14:19:59 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.85.144) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.58; Tue, 21 Apr 2026 14:20:00 -0700
Received: from c34249-workdesk.microsemi.net (10.10.85.11) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server id
 15.1.2507.58 via Frontend Transport; Tue, 21 Apr 2026 14:19:59 -0700
From: Sagar Biradar <sagar.biradar@microchip.com>
To: "Martin K . Petersen" <martin.petersen@oracle.com>, James Bottomley
	<James.Bottomley@HansenPartnership.com>, Jack Wang
	<jinpu.wang@cloud.ionos.com>
CC: linux-scsi <linux-scsi@vger.kernel.org>, <stable@vger.kernel.org>, "Don
 Brace" <don.brace@microchip.com>, Raja VS <raja.vs@microchip.com>, "Kumar
 Meiyappan" <kumar.meiyappan@microchip.com>, Abhinav Kuchibhotla
	<abhinav.kuchibhotla@microchip.com>, Uday kumar Bagam
	<udaykumar.bagam@microchip.com>, Advait Churi <advait.churi@microchip.com>,
	Sagar Biradar <sagar.biradar@microchip.com>
Subject: [PATCH] scsi: pm8001: bump driver version to 1.50
Date: Tue, 21 Apr 2026 14:19:50 -0700
Message-ID: <20260421211950.433910-1-sagar.biradar@microchip.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain

The pm8001 driver has seen very little upstream activity for years,
with the version string remaining at 0.1.40.
In the meantime, significant internal development and clean-ups
have accumulated.

Bump the version to 1.50 to mark the start of renewed
upstreaming work. This provides a clean baseline for the upcoming
series that will bring pending patches and later enable new
hardware support.

This patch only updates the version string and introduces no
functional changes.

Signed-off-by: Sagar Biradar <sagar.biradar@microchip.com>
---
 drivers/scsi/pm8001/pm8001_sas.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/pm8001/pm8001_sas.h b/drivers/scsi/pm8001/pm8001_sas.h
index b63b6ffcaaf5..4e8c7c11f319 100644
--- a/drivers/scsi/pm8001/pm8001_sas.h
+++ b/drivers/scsi/pm8001/pm8001_sas.h
@@ -59,7 +59,7 @@
 #include "pm8001_defs.h"
 
 #define DRV_NAME		"pm80xx"
-#define DRV_VERSION		"0.1.40"
+#define DRV_VERSION		"0.1.50"
 #define PM8001_FAIL_LOGGING	0x01 /* Error message logging */
 #define PM8001_INIT_LOGGING	0x02 /* driver init logging */
 #define PM8001_DISC_LOGGING	0x04 /* discovery layer logging */
-- 
2.43.0

