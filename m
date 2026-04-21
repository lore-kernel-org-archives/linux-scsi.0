Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B365E39A818;
	Tue, 21 Apr 2026 21:22:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=68.232.153.233
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776806548; cv=none; b=d3ZwsX+UghEbXeq+8K1ybfF2tyVBdS8795DsSnyRCSy9lYxpwXhqtZYu+7LyEDRRUTKnd/qnP3tonesEQqpiY0HIfyiGPKJPx/g3UysMahrhGJwLZUhLWSuJLV/6wJlp3Iuj4nwm49qCYm/z1soJMEwXkj5/TMZVNL1oEOUiaOk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776806548; c=relaxed/simple;
	bh=DLGklc2X1yiN6C0ilLsX9B4bf963Cmi8SjQQft8XWIo=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=jvH2z3EwlwU6rVjrqiiVGTXm4hXjC0Q/wqbdqe61ZdM0Is5til/LAgIa85EP1Hd+aQwz4cv4iyxQT6w5/cdEepMRx3z1fD+WRCy3sq+tfBIeamZ3QkX6Z811ctSYYpc2NkQBD9KP1Hf55RRjRev+8Th72Yr4Twvv2Wo3JWWfPU4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=microchip.com; spf=pass smtp.mailfrom=microchip.com; dkim=pass (2048-bit key) header.d=microchip.com header.i=@microchip.com header.b=oZwRsWXt; arc=none smtp.client-ip=68.232.153.233
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=microchip.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=microchip.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=microchip.com header.i=@microchip.com header.b="oZwRsWXt"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1776806547; x=1808342547;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=DLGklc2X1yiN6C0ilLsX9B4bf963Cmi8SjQQft8XWIo=;
  b=oZwRsWXt/HYRpJ3orm/plz8Gxg1hyiJuv8lfieqUJ3qcPG32eU/MW2TO
   upDolCBhJI1MoxEg/JylKKcqVEV7/L+Ueffm6srfrmivcQD+ZvJeuUO++
   4G4jpOXwhqSpwJd8XyeUd0BmGME621pIFHM7MkD7YAO2SRmGN78nkm+7x
   39m3hZIpqK0zB83v6Wlm51H+IXWHBMsTtmEYXbV5jw6RCydjk62JhzGod
   xbUNbXjrqe0YSFuKrCbIRWGYfhtE2ATKLlR7wqO4oiNF/PVobM/ug9gSS
   kBTKJ/tbHdb1JRmxkTWkfqITbHMolhxQuohGSS26362epLfg6BHj5A3YZ
   g==;
X-CSE-ConnectionGUID: RgioWcFfQBCNWVkBHz2Wkw==
X-CSE-MsgGUID: 0wmiNehdQdeyGmWTRtBiUA==
X-IronPort-AV: E=Sophos;i="6.23,192,1770620400"; 
   d="scan'208";a="287808264"
X-Amp-Result: SKIPPED(no attachment in message)
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa5.microchip.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 21 Apr 2026 14:22:26 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.87.72) by
 chn-vm-ex02.mchp-main.com (10.10.87.72) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.58; Tue, 21 Apr 2026 14:22:25 -0700
Received: from c34249-workdesk.microsemi.net (10.10.85.11) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server id
 15.1.2507.58 via Frontend Transport; Tue, 21 Apr 2026 14:22:24 -0700
From: Sagar Biradar <sagar.biradar@microchip.com>
To: "Martin K. Petersen" <martin.petersen@oracle.com>, James Bottomley
	<James.Bottomley@HansenPartnership.com>, Jack Wang
	<jinpu.wang@cloud.ionos.com>
CC: linux-scsi <linux-scsi@vger.kernel.org>, <stable@vger.kernel.org>, "Don
 Brace" <don.brace@microchip.com>, Raja VS <raja.vs@microchip.com>, "Kumar
 Meiyappan" <kumar.meiyappan@microchip.com>, Abhinav Kuchibhotla
	<abhinav.kuchibhotla@microchip.com>, Uday kumar Bagam
	<udaykumar.bagam@microchip.com>, Advait Churi <advait.churi@microchip.com>,
	Sagar Biradar <sagar.biradar@microchip.com>
Subject: [PATCH] scsi: pm8001: add MODULE_AUTHOR entries for new contributors
Date: Tue, 21 Apr 2026 14:22:18 -0700
Message-ID: <20260421212218.433963-1-sagar.biradar@microchip.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain

Add MODULE_AUTHOR declarations for the developers who have
been actively working on the pm8001/pm80xx driver in recent years.

This helps properly credit the people involved in the ongoing
maintenance and the current upstreaming effort.

Signed-off-by: Sagar Biradar <sagar.biradar@microchip.com>
---
 drivers/scsi/pm8001/pm8001_init.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/scsi/pm8001/pm8001_init.c b/drivers/scsi/pm8001/pm8001_init.c
index e93ea76b565e..487f9bc237ef 100644
--- a/drivers/scsi/pm8001/pm8001_init.c
+++ b/drivers/scsi/pm8001/pm8001_init.c
@@ -1569,6 +1569,9 @@ MODULE_AUTHOR("Jack Wang <jack_wang@usish.com>");
 MODULE_AUTHOR("Anand Kumar Santhanam <AnandKumar.Santhanam@pmcs.com>");
 MODULE_AUTHOR("Sangeetha Gnanasekaran <Sangeetha.Gnanasekaran@pmcs.com>");
 MODULE_AUTHOR("Nikith Ganigarakoppal <Nikith.Ganigarakoppal@pmcs.com>");
+MODULE_AUTHOR("Abhinav Kuchibhotla <Abhinav.Kuchibhotla@microchip.com>");
+MODULE_AUTHOR("Kumar Meiyappan <Kumar.Meiyappan@microchip.com>");
+MODULE_AUTHOR("Sagar Biradar <Sagar.Biradar@microchip.com>");
 MODULE_DESCRIPTION(
 		"PMC-Sierra PM8001/8006/8081/8088/8089/8074/8076/8077/8070/8072 "
 		"SAS/SATA controller driver");
-- 
2.43.0

