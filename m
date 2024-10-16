Received: from esa2.hgst.iphmx.com (esa2.hgst.iphmx.com [68.232.143.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 579DB20695C;
	Wed, 16 Oct 2024 10:23:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=68.232.143.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729074230; cv=none; b=FgFdekQIE5RuCJ7ca4v99SiypkHkYHjFWCzA3qEQW/yKuOH9QT9fV2w5CUXYcWCpYWtT6rJmux7B+WFQrtSsMHysAwHx7OcI6ejKwy48M6qFehdLqSDOf1vlBCd5rkEqo/GCt+GBFl3deX9vcWFRSb/v0GTjP3X5uSzBKDRS9r0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729074230; c=relaxed/simple;
	bh=0aDmPs+anhfc37txHXDwfhfw7YbIofDuRGpzjKfcZG8=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=A0dzGr5CCeY65yMFtLmHiIi0eTZr8K3TLSiQN94OUpLgXACIgNTRmWU4LpZjSoABWl7C2qcEIMAgwYt3KSZ8iobcK4G3BKo1kIZ/tZ2auhc3gkO6B+uynTwcySVg9qBzRDe0me4pLYLxD3wcYmsFj8o1dIhgL0jxeihzvj9XUfA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=K7iyw+QR; arc=none smtp.client-ip=68.232.143.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="K7iyw+QR"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1729074228; x=1760610228;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=0aDmPs+anhfc37txHXDwfhfw7YbIofDuRGpzjKfcZG8=;
  b=K7iyw+QRly/WrCpcfIs3Lps7JZbdTu6j/F3DZuVKuJ+RXWHI/PkmhJwW
   witDdOG2wpL0BfqAFkzIqXAttOAJxHvz/OGqQoEil7x4vjqX7oCzUlf6q
   9QSDwYX14aW/KW9gy9g29hb5cjYjO1q98BaEkchm4Z/6bg6f4QnpB/ATK
   +qpxHYG418e2I4IlO1X64I76kSJ1I3TLVEo6DUE8cGwYTauwCsdUHMJMf
   As19dsQ6pJ/np+qxxnK1st6GSwxPndu1rsI5SteYobQ4jTmCWcBXSyOva
   ndC54zD1PrydraDFwec7MaSiTb0m/FUoU9XShH1W5GRB6+ewJENUe7D9z
   g==;
X-CSE-ConnectionGUID: 9sCI9hpdTQWNadyIbNomKg==
X-CSE-MsgGUID: eoleS7WdRziscVSoi3rftw==
X-IronPort-AV: E=Sophos;i="6.11,207,1725292800"; 
   d="scan'208";a="29536136"
Received: from uls-op-cesaip01.wdc.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 16 Oct 2024 18:23:47 +0800
IronPort-SDR: 670f8724_4EuPppubrDNw3KN3pw/MKWsiJNSBv4pcvtLIY3jA59vwfxp
 pAO/KmOhdMZ4fMosybJcDAjV30WRB4t75iDPSqg==
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 16 Oct 2024 02:28:05 -0700
WDCIronportException: Internal
Received: from avri-office.ad.shared (HELO avri-office.sdcorp.global.sandisk.com) ([10.45.31.142])
  by uls-op-cesaip02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 16 Oct 2024 03:23:47 -0700
From: Avri Altman <avri.altman@wdc.com>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>,
	Avri Altman <avri.altman@wdc.com>
Subject: [PATCH RESEND v2] scsi: ufs: Use wait-for-reg in HCE init
Date: Wed, 16 Oct 2024 13:21:41 +0300
Message-Id: <20241016102141.441382-1-avri.altman@wdc.com>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The current so called "inner loop" in ufshcd_hba_execute_hce() is open
coding ufshcd_wait_for_register. Replace it by ufshcd_wait_for_register.
This is a code simplification - no functional change.

Signed-off-by: Avri Altman <avri.altman@wdc.com>

---
Changes in v2:
 - Elaborate the commit log (Bart)
 - Change a while-loop into a for-loop (Bart)
---
 drivers/ufs/core/ufshcd.c | 67 ++++++++++++++++++---------------------
 1 file changed, 30 insertions(+), 37 deletions(-)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index 9e6d008f4ea4..146915f92a85 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -4818,51 +4818,44 @@ EXPORT_SYMBOL_GPL(ufshcd_hba_stop);
  */
 static int ufshcd_hba_execute_hce(struct ufs_hba *hba)
 {
-	int retry_outer = 3;
-	int retry_inner;
+	int retry;
 
-start:
-	if (ufshcd_is_hba_active(hba))
-		/* change controller state to "reset state" */
-		ufshcd_hba_stop(hba);
+	for (retry = 3; retry > 0; retry--) {
+		if (ufshcd_is_hba_active(hba))
+			/* change controller state to "reset state" */
+			ufshcd_hba_stop(hba);
 
-	/* UniPro link is disabled at this point */
-	ufshcd_set_link_off(hba);
+		/* UniPro link is disabled at this point */
+		ufshcd_set_link_off(hba);
 
-	ufshcd_vops_hce_enable_notify(hba, PRE_CHANGE);
+		ufshcd_vops_hce_enable_notify(hba, PRE_CHANGE);
 
-	/* start controller initialization sequence */
-	ufshcd_hba_start(hba);
+		/* start controller initialization sequence */
+		ufshcd_hba_start(hba);
 
-	/*
-	 * To initialize a UFS host controller HCE bit must be set to 1.
-	 * During initialization the HCE bit value changes from 1->0->1.
-	 * When the host controller completes initialization sequence
-	 * it sets the value of HCE bit to 1. The same HCE bit is read back
-	 * to check if the controller has completed initialization sequence.
-	 * So without this delay the value HCE = 1, set in the previous
-	 * instruction might be read back.
-	 * This delay can be changed based on the controller.
-	 */
-	ufshcd_delay_us(hba->vps->hba_enable_delay_us, 100);
+		/*
+		 * To initialize a UFS host controller HCE bit must be set to 1.
+		 * During initialization the HCE bit value changes from 1->0->1.
+		 * When the host controller completes initialization sequence
+		 * it sets the value of HCE bit to 1. The same HCE bit is read back
+		 * to check if the controller has completed initialization sequence.
+		 * So without this delay the value HCE = 1, set in the previous
+		 * instruction might be read back.
+		 * This delay can be changed based on the controller.
+		 */
+		ufshcd_delay_us(hba->vps->hba_enable_delay_us, 100);
 
-	/* wait for the host controller to complete initialization */
-	retry_inner = 50;
-	while (!ufshcd_is_hba_active(hba)) {
-		if (retry_inner) {
-			retry_inner--;
-		} else {
-			dev_err(hba->dev,
-				"Controller enable failed\n");
-			if (retry_outer) {
-				retry_outer--;
-				goto start;
-			}
-			return -EIO;
-		}
-		usleep_range(1000, 1100);
+		/* wait for the host controller to complete initialization */
+		if (!ufshcd_wait_for_register(hba, REG_CONTROLLER_ENABLE, CONTROLLER_ENABLE,
+					      CONTROLLER_ENABLE, 1000, 50))
+			break;
+
+		dev_err(hba->dev, "Enabling the controller failed\n");
 	}
 
+	if (!retry)
+		return -EIO;
+
 	/* enable UIC related interrupts */
 	ufshcd_enable_intr(hba, UFSHCD_UIC_MASK);
 
-- 
2.25.1

