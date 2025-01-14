Received: from esa5.hgst.iphmx.com (esa5.hgst.iphmx.com [216.71.153.144])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 993F424334E;
	Tue, 14 Jan 2025 09:38:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=216.71.153.144
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736847488; cv=none; b=goje5VkRiptKR5EVbaCHQSf2pKSxl7NV55CHe/QfSTBVIBm8ZTMQ1O0iZbA/JdVgBzoLbaOVTb/7uDucbleJnCSzMVC9gSQgCuzdCIk9YTC5IqtTqH3b92fFPOTEqYWTlt0XoBWr6+NI1oqA7uzQeQee3VsfAAVncM6hJlSYNAE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736847488; c=relaxed/simple;
	bh=xaY/0LrOW6WSLYSVlpxfs1XgOP9TPDdCciZPradmefE=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=ZRVxRMy3EcWCpbWxaWUKm/6+3YtcAqIuEJoYBYHTrMH/46P9P2Wt87KzwbA/hRRpYQy5zVaSebrKpUiyHWo5+1aNUlDE6G4514neTSgk5LmxoiBBLO9++FywobDOIGmSGAK+iJ0j1bjkYZOXHfGgA3/nyt5P4PG/SJjHkz6HTUY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=o66tNXfA; arc=none smtp.client-ip=216.71.153.144
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="o66tNXfA"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1736847486; x=1768383486;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=xaY/0LrOW6WSLYSVlpxfs1XgOP9TPDdCciZPradmefE=;
  b=o66tNXfAlCAkrqAORnhXY1Bve16Tk1hPLLgq8vDDGmL1RiNiVybybnWc
   6yy8voE7fWLMUAVXKFvgjw17MhpW0XfnQsxqtGrfr2rsEhx4E2ZumcCeC
   fS22by3bnpravrEpzcCM+JdKLX/1RBDvYy1aN4UOqk/xr8D6AD0UpZRCC
   qY4p9HBH/BaQIWnxEWFd0h2H4mRpp3y/vta+XpWT5tR+tTGptO4nhZPl2
   UFBOS7Gb+v0CiX1otaQt4Uym9GiywyU10mIVC+2jqH123zWZtENd/w22u
   UMt/hOBJ5d9z6C3kdPalWtH6N5Dylq7Ki1zS0sUnPxV6E6yauANxab0zx
   A==;
X-CSE-ConnectionGUID: 1SNwRW4zR8ONm/BVd0lpVA==
X-CSE-MsgGUID: ukPILo8QS0+jnmgzQxU2pA==
X-IronPort-AV: E=Sophos;i="6.12,313,1728921600"; 
   d="scan'208";a="36912840"
Received: from uls-op-cesaip01.wdc.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 14 Jan 2025 17:38:00 +0800
IronPort-SDR: 678622eb_/7r/CoKHi7gomHA7PCBCoUwMmq6uh9ChfJYceA2iTbYBqxG
 EJjATrjbu3+sK8zSBtK0eNREqR6KD1CGJw/UCNA==
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 14 Jan 2025 00:40:11 -0800
WDCIronportException: Internal
Received: from avri-office.ad.shared (HELO avri-office.sdcorp.global.sandisk.com) ([10.45.31.142])
  by uls-op-cesaip02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 14 Jan 2025 01:37:59 -0800
From: Avri Altman <avri.altman@wdc.com>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Guenter Roeck <linux@roeck-us.net>,
	Bart Van Assche <bvanassche@acm.org>,
	Avri Altman <avri.altman@wdc.com>
Subject: [PATCH 1/2] scsi: ufs: core: Simplify temperature exception event handling
Date: Tue, 14 Jan 2025 11:35:11 +0200
Message-Id: <20250114093512.151019-2-avri.altman@wdc.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20250114093512.151019-1-avri.altman@wdc.com>
References: <20250114093512.151019-1-avri.altman@wdc.com>
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

