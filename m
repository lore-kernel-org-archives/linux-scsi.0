Received: from esa5.hgst.iphmx.com (esa5.hgst.iphmx.com [216.71.153.144])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28A1C1FC7FC;
	Tue, 14 Jan 2025 18:14:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=216.71.153.144
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736878489; cv=none; b=aDL99hUPr7QufprqRACuUUle5BLnioq9R35CeC+eQAvVxe2SuqYF+fmuD9QP4vUa+S7bJTTYFexQeWLPAedAkd1f01ndwHNaUdVqUGcThHmmcHv0q1mLxZow/U84otIn3a8eFUMBVbm000k+FyPXOzp4Wo6Egli+9PKI76Z4qIk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736878489; c=relaxed/simple;
	bh=XYIkzQIR/91O4frnklbMe479e2/y1+7ehr6bFJRVnqc=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=VjJh+itTp54tB04EAb2V8pfVjOq+joxLTFGKAYSW3CP1XU72Q4O5d77RSDQnEv2kREfkDR/A0bhxFhTGrfKEYAlxSQPOjtFY77WadEpKyvFATj34tghPmGrWKZ2HapSuB2wqvgKVdxcLPktzFPJ4iKGlTb0uYKD/ZwHNGhH4TeA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=ELeXVV9m; arc=none smtp.client-ip=216.71.153.144
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="ELeXVV9m"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1736878487; x=1768414487;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=XYIkzQIR/91O4frnklbMe479e2/y1+7ehr6bFJRVnqc=;
  b=ELeXVV9moJNqZz+kh3qg/ZS68B55M7NqDv657827MlfeV9s5QCKEXgER
   wvgMySGxNw56QD79dRwnOOm8mmpkrZxkn5iaoK4zEkw1sXQ7BthUPOfpS
   o27YRw7yqZiLFNhj7h/yO/8VvR4EfAgSJOKzIhNRekhQ9MnZNdWliRGur
   GnWf668Q/YFmIiRXjLF1wx1mqlm7xv844/4JeO0ya+tfMT+08u6354gDc
   NZo7jmfQtMAqHp+ZB0KRcxMzCj2hU/5aN7N18EGoio9Ll6qyal9XGDOTn
   /uPVW5Rzsmp2drpBxf1Zba75NtI55v2GFY2gjxqVy3scXg9UCiRMG9ScN
   w==;
X-CSE-ConnectionGUID: HYbICricTAGn5kIGx4iH8Q==
X-CSE-MsgGUID: plNk6afQRaSwJp1PIlc0Wg==
X-IronPort-AV: E=Sophos;i="6.12,314,1728921600"; 
   d="scan'208";a="36947355"
Received: from h199-255-45-14.hgst.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 15 Jan 2025 02:14:45 +0800
IronPort-SDR: 67869c09_IWcl+s+dw0aMV4BVk5bqmRH4tFixQk1XVZuF26xcOlMIrpc
 T3pF1CHrjLBSO/0yoSoCRLNMFgOfFOaHsKBZmgQ==
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 14 Jan 2025 09:16:58 -0800
WDCIronportException: Internal
Received: from avri-office.ad.shared (HELO avri-office.sdcorp.global.sandisk.com) ([10.45.31.142])
  by uls-op-cesaip02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 14 Jan 2025 10:14:44 -0800
From: Avri Altman <avri.altman@wdc.com>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Guenter Roeck <linux@roeck-us.net>,
	Bart Van Assche <bvanassche@acm.org>,
	Avri Altman <avri.altman@wdc.com>
Subject: [PATCH v2] scsi: ufs: core: Simplify temperature exception event handling
Date: Tue, 14 Jan 2025 20:12:05 +0200
Message-Id: <20250114181205.153760-1-avri.altman@wdc.com>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This commit simplifies the temperature exception event handling by
removing the `ufshcd_temp_exception_event_handler` function and directly
calling `ufs_hwmon_notify_event` in the `ufshcd_exception_event_handler`
function.

The `ufshcd_temp_exception_event_handler` function contained a
placeholder comment for platform vendors to add additional steps if
required. However, since its introduction a few years ago, no vendor has
added any additional steps. Therefore, the placeholder function is
removed to streamline the code.

Signed-off-by: Avri Altman <avri.altman@wdc.com>

---
Changes compared to v1:
 - Remove patch #2 - Add missing ABI documentation (Guenter)
---
 drivers/ufs/core/ufshcd.c | 20 +-------------------
 1 file changed, 1 insertion(+), 19 deletions(-)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index 0920a443588c..f6c38cf10382 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -5976,24 +5976,6 @@ static void ufshcd_bkops_exception_event_handler(struct ufs_hba *hba)
 				__func__, err);
 }
 
-static void ufshcd_temp_exception_event_handler(struct ufs_hba *hba, u16 status)
-{
-	u32 value;
-
-	if (ufshcd_query_attr_retry(hba, UPIU_QUERY_OPCODE_READ_ATTR,
-				QUERY_ATTR_IDN_CASE_ROUGH_TEMP, 0, 0, &value))
-		return;
-
-	dev_info(hba->dev, "exception Tcase %d\n", value - 80);
-
-	ufs_hwmon_notify_event(hba, status & MASK_EE_URGENT_TEMP);
-
-	/*
-	 * A placeholder for the platform vendors to add whatever additional
-	 * steps required
-	 */
-}
-
 static int __ufshcd_wb_toggle(struct ufs_hba *hba, bool set, enum flag_idn idn)
 {
 	u8 index;
@@ -6214,7 +6196,7 @@ static void ufshcd_exception_event_handler(struct work_struct *work)
 		ufshcd_bkops_exception_event_handler(hba);
 
 	if (status & hba->ee_drv_mask & MASK_EE_URGENT_TEMP)
-		ufshcd_temp_exception_event_handler(hba, status);
+		ufs_hwmon_notify_event(hba, status & MASK_EE_URGENT_TEMP);
 
 	ufs_debugfs_exception_event(hba, status);
 }
-- 
2.25.1

