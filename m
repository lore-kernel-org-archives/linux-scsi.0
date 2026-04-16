Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CDB3277818;
	Thu, 16 Apr 2026 16:07:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=68.232.153.233
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776355662; cv=none; b=Ciae8fDlq5D4eLAna/1NmgeXxx3KDrgXbNdj8vr9aQX59WvKUgR9ubPRCTNKxB6fZzRhlT6+TH11aWVFT030D++7ZQhkvkPsDRLWr9Kifkpt2bT+NcHMRzORUnleu/vIs6aTQTSjQC+sREyZAIRrtNEuzifmsJ5oe95lqYmfDZ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776355662; c=relaxed/simple;
	bh=qao/Q8ZaEWTm/ysOoWCK36ISeRwnGqtgwEfsoRZC9RA=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=pliXxQUKiagWYAU2VjuNO+TET48cygnykHnDH1r4Zt450WMehD/qDicLMpm1/hc+ZqST0JGmUCEUOsrXlWqoDCW9zhDs4xiTH5fyU8ZPfxga691ZaFvSJLLgiOIE3/deLM5fXhWVLS7FG1bxqnKylKQIPm2KD/ZhSK3HdwtNRZo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=microchip.com; spf=pass smtp.mailfrom=microchip.com; dkim=pass (2048-bit key) header.d=microchip.com header.i=@microchip.com header.b=ziEuOEVG; arc=none smtp.client-ip=68.232.153.233
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=microchip.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=microchip.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=microchip.com header.i=@microchip.com header.b="ziEuOEVG"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1776355661; x=1807891661;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=qao/Q8ZaEWTm/ysOoWCK36ISeRwnGqtgwEfsoRZC9RA=;
  b=ziEuOEVGqjUAEO8ii4kmQMdMkIWckyAa6jyKtLckzi3D4LpcyfKPLSD7
   H5P9KHcZbS9KzvoH0tAyNfWOkWnbfwe4SpTQXmvpKqUqRRQ4J8ckVIlP9
   K/cEkhtBb3Qp3y4/VYlHoRLq+a4PG40ztNjqbl5hp0gphEzyhQjKwI9Bf
   9h85hGobnWF5LZ+ZN/2jSBjtbk4jC+KiOfXxm0N7R1DumZSrpMESlBVd0
   I5NgNwHzVv8SZWE5u70WLrzWdZEWJgAzErm3KANlILw0LLGUQ+EiT1Vn9
   QmGqCV4bjdm/9GFVv2jYmT3EL49R6KpQafSQrS7b4pEDCHfuGpbuqV8b/
   Q==;
X-CSE-ConnectionGUID: DxYSXy9UTvellq4VxFal2A==
X-CSE-MsgGUID: f86AsaOuQOGT/aWHLL3Xvw==
X-IronPort-AV: E=Sophos;i="6.23,181,1770620400"; 
   d="scan'208";a="64196903"
X-Amp-Result: SKIPPED(no attachment in message)
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa1.microchip.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Apr 2026 09:07:40 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.87.152) by
 chn-vm-ex1.mchp-main.com (10.10.87.30) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.2.2562.35; Thu, 16 Apr 2026 09:07:20 -0700
Received: from c34249-workdesk.microsemi.net (10.10.85.11) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server id
 15.1.2507.58 via Frontend Transport; Thu, 16 Apr 2026 09:07:19 -0700
From: Sagar Biradar <sagar.biradar@microchip.com>
To: "Martin K . Petersen" <martin.petersen@oracle.com>, James Bottomley
	<James.Bottomley@HansenPartnership.com>, Jack Wang
	<jinpu.wang@cloud.ionos.com>
CC: linux-scsi <linux-scsi@vger.kernel.org>, <stable@vger.kernel.org>, "Brian
 King" <brking@linux.vnet.ibm.com>, Don Brace <don.brace@microchip.com>, "Raja
 VS" <raja.vs@microchip.com>, Kumar Meiyappan <kumar.meiyappan@microchip.com>,
	Abhinav Kuchibhotla <abhinav.kuchibhotla@microchip.com>, Uday kumar Bagam
	<udaykumar.bagam@microchip.com>, Advait Churi <advait.churi@microchip.com>,
	Sagar Biradar <sagar.biradar@microchip.com>
Subject: [PATCH] scsi: pm8001: reject non-fatal dump when controller is crashed
Date: Thu, 16 Apr 2026 15:46:50 +0000
Message-ID: <20260416154650.415624-1-sagar.biradar@microchip.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain

From: Kumar Meiyappan <kumar.meiyappan@microchip.com>

pm80xx_get_non_fatal_dump() can be called even after the controller
has entered a fatal error state. In that case the forensic memory
contents are not safe to access for a non-fatal dump request,
and attempting to do so can trigger a call trace.

Check controller_fatal_error before reading the non-fatal dump buffer
and return -EINVAL when the controller is already in a crashed state.

This prevents non-fatal dump collection from running in an invalid
controller state.

Signed-off-by: Kumar Meiyappan <kumar.meiyappan@microchip.com>
Signed-off-by: Sagar Biradar <sagar.biradar@microchip.com>
---
 drivers/scsi/pm8001/pm80xx_hwi.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/scsi/pm8001/pm80xx_hwi.c b/drivers/scsi/pm8001/pm80xx_hwi.c
index 954f307352e6..2c0fa7ab33d2 100644
--- a/drivers/scsi/pm8001/pm80xx_hwi.c
+++ b/drivers/scsi/pm8001/pm80xx_hwi.c
@@ -401,6 +401,13 @@ ssize_t pm80xx_get_non_fatal_dump(struct device *cdev,
 	char *buf_copy = buf;
 
 	temp = (u32 *)pm8001_ha->memoryMap.region[FORENSIC_MEM].virt_ptr;
+
+	if (pm8001_ha->controller_fatal_error) {
+		pm8001_dbg(pm8001_ha, FAIL,
+			   "non-fatal dump not available in fatal error state\n");
+		return -EINVAL;
+	}
+
 	if (++pm8001_ha->non_fatal_count == 1) {
 		if (pm8001_ha->chip_id == chip_8001) {
 			snprintf(pm8001_ha->forensic_info.data_buf.direct_data,
-- 
2.43.0

