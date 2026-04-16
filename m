Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55EC63002BD;
	Thu, 16 Apr 2026 15:58:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=68.232.153.233
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776355137; cv=none; b=lBcyw1RbE/dqKvuA8SkkI3Kgd/eCOz40Qj/LjE+NLVVmy37UzLQOlEVcTOZPtKzRwQrYH8OtmtWLVN1PhijCSb6XeX7+8j/xMzmqVArgJqBlW39x830ui4Bqa5LNbVNzPxGx3yK6t+xgaQZrpkyXx8+AVZvQNtVvabOVzhWkSZQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776355137; c=relaxed/simple;
	bh=VoFu6zdcNIlWYXin68CivHXkudYOc1cZgUUunz/fBOw=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=lI8d+NNK3PaiZVZZ2O+aoM0Mi7vOXfcZ1JWagGWgega5P3d+8CJNNq2Qh40UFGVj4C0UxPsR0LBk+g0nSDUftWZCPGtsaBz3X9t1x0KnS9hdcCQ0SaQerIWR0O3/wYbnsXThAICwM93z7gSnKLx9b9q/Fo3L2Z3+z5cVLqEbapI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=microchip.com; spf=pass smtp.mailfrom=microchip.com; dkim=pass (2048-bit key) header.d=microchip.com header.i=@microchip.com header.b=CWf+UVR4; arc=none smtp.client-ip=68.232.153.233
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=microchip.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=microchip.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=microchip.com header.i=@microchip.com header.b="CWf+UVR4"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1776355136; x=1807891136;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=VoFu6zdcNIlWYXin68CivHXkudYOc1cZgUUunz/fBOw=;
  b=CWf+UVR4cdS9CJRsWQy87CUG8UbG3YpuqdfQmEaMydX9n4PvntzsXXbg
   fOv9g/bTIncsz24UfTbiYY1d4s8z2Vh2mTfwZvUjo2YCZ3IUfipm6Mi2I
   Nwy3ZGNgAwXLkQmhN/H5nCqUeCxi+rND7CI+gjDEJUWQPnW83qVyB/n5F
   8CvRuR4BZtMFNDJHkDJQRx9rVHlZrqqZ+TGaIVQMoeVU/qeB0Vd0s18s2
   CmzGxZv3Xw0mtuvcJ0k8+bYnRLyABpnYELeHAwugaRvOxqCrnt+p1uDsJ
   1A0LJhalVkGzkDnprpIZSTwzaykL1nzf7hJ7gag0RYyM251O5/36eIMSz
   w==;
X-CSE-ConnectionGUID: ctb6DzhaSxmBsytyUH3wNg==
X-CSE-MsgGUID: P0kO7RE1S/S9Mv1i67UF7g==
X-IronPort-AV: E=Sophos;i="6.23,181,1770620400"; 
   d="scan'208";a="56218451"
X-Amp-Result: SKIPPED(no attachment in message)
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa3.microchip.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 16 Apr 2026 08:58:50 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.58; Thu, 16 Apr 2026 08:58:37 -0700
Received: from c34249-workdesk.microsemi.net (10.10.85.11) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server id
 15.1.2507.58 via Frontend Transport; Thu, 16 Apr 2026 08:58:37 -0700
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
Subject: [PATCH] scsi: pm8001: reject firmware update in fatal error state
Date: Thu, 16 Apr 2026 15:37:57 +0000
Message-ID: <20260416153757.414896-1-sagar.biradar@microchip.com>
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

pm8001_store_update_fw() allows a firmware update request even
when the controller has already entered a fatal error state.

Firmware update is not valid once the controller is in that state,
and attempting it can lead to a call trace. Reject the request
early by checking controller_fatal_error, set the firmware
status to FAIL_PARAMETERS, and return -EINVAL.

Signed-off-by: Kumar Meiyappan <kumar.meiyappan@microchip.com>
Signed-off-by: Sagar Biradar <sagar.biradar@microchip.com>
---
 drivers/scsi/pm8001/pm8001_ctl.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/scsi/pm8001/pm8001_ctl.c b/drivers/scsi/pm8001/pm8001_ctl.c
index cbfda8c04e95..bb38b2d63acb 100644
--- a/drivers/scsi/pm8001/pm8001_ctl.c
+++ b/drivers/scsi/pm8001/pm8001_ctl.c
@@ -826,6 +826,14 @@ static ssize_t pm8001_store_update_fw(struct device *cdev,
 		goto out;
 	}
 
+	if (pm8001_ha->controller_fatal_error) {
+		pm8001_dbg(pm8001_ha, FAIL,
+			   "controller in fatal error state, firmware update rejected\n");
+		pm8001_ha->fw_status = FAIL_PARAMETERS;
+		ret = -EINVAL;
+		goto out;
+	}
+
 	for (i = 0; flash_command_table[i].code != FLASH_CMD_NONE; i++) {
 		if (!memcmp(flash_command_table[i].command,
 				 cmd_ptr, strlen(cmd_ptr))) {
-- 
2.43.0

