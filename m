Received: from esa4.hgst.iphmx.com (esa4.hgst.iphmx.com [216.71.154.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6CD71741D5;
	Fri,  9 Aug 2024 07:25:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=216.71.154.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723188314; cv=none; b=lpBGrbDsM5pf6JlYWlciOq+J8d0yEtHQ3JDZftprUfRa23IjxVV+C8F20FTBzpXNc0qw8sPpdY/tdQkTdOz3lhpJNTya0GzSJXSYBemvQux89wM3d6XBmDLv3e+cJDQGAYxQ8atmUFyPSrX7+z785moBw/fgZ/qT07s52h5rcdU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723188314; c=relaxed/simple;
	bh=F2SIY0yY7nL6gth0U1vS5JWPpunOq3B0lcpPZCsF9u4=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=FVyUTXOjWPoGG4zCQrEz4zvpVoV5N7FnfyDsX+NMdyg8gpKWV90L/kUL+LIZNA+oKXVWxWn+QXnKwkhybOuLInTAH9lpntX0y1D1hcZUqrC210b9TBDTs9D3mdClVp8DrYl4X5lllacl4U4GZpO1ygI6pIRGPoFBc9HGqwyEMvI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=YYfo0WXM; arc=none smtp.client-ip=216.71.154.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="YYfo0WXM"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1723188313; x=1754724313;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=F2SIY0yY7nL6gth0U1vS5JWPpunOq3B0lcpPZCsF9u4=;
  b=YYfo0WXML7Goh6AESU1vtXh5D4hLEXc/PllE+01mpJWF+W7leayYb5Za
   ST1zoOML0r099zniZoO5KLiueSIiZp6A3dfk2+bfcI9CaYYHH4kUW/AuI
   wswOx1JEXZoJiRmzFDsfEoe4jJhFvs7mUvdxLU81Z3FGaKEA9ssSQbwrb
   CqM//ZF64ozlLwGa54oQUOwKV6VFFnGkzJ3X+UwOq2+kXeZLKYWI7F8/r
   dMlz5i1W6Hwoy0u/it9t+psd/MMbAK8dW9oDCIHh3d+ZO6i7RRo9TIf3l
   i1HR0Aj6ROsFiPhoQ9eTHu0EMSvbBeDKucH9izDcRvaBWKZ6NoWoVyWP3
   g==;
X-CSE-ConnectionGUID: 4XCbazcvTDKSJrPRnbPgYA==
X-CSE-MsgGUID: B/LdBNFUTBiBTiH52Mennw==
X-IronPort-AV: E=Sophos;i="6.09,275,1716220800"; 
   d="scan'208";a="23232724"
Received: from uls-op-cesaip01.wdc.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 09 Aug 2024 15:25:08 +0800
IronPort-SDR: 66b5b7ab_eaJ2ydmLx16pr0FzjtwNvewFrfwybGfpGmtIabZ+hJBroa6
 bESS7cWpS2cyISRh6O+TDWka9mLte0BKd/qUayg==
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 08 Aug 2024 23:31:08 -0700
WDCIronportException: Internal
Received: from avri-office.ad.shared (HELO avri-office.sdcorp.global.sandisk.com) ([10.45.31.142])
  by uls-op-cesaip01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 09 Aug 2024 00:25:06 -0700
From: Avri Altman <avri.altman@wdc.com>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>,
	Keoseong Park <keosung.park@samsung.com>,
	Avri Altman <avri.altman@wdc.com>
Subject: [PATCH v3 1/2] scsi: ufs: Prepare to add HCI capabilities sysfs
Date: Fri,  9 Aug 2024 10:23:30 +0300
Message-Id: <20240809072331.2483196-2-avri.altman@wdc.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20240809072331.2483196-1-avri.altman@wdc.com>
References: <20240809072331.2483196-1-avri.altman@wdc.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Prepare so we'll be able to read various other HCI registers.
While at it, fix the HCPID & HCMID register names to stand for what they
really are. Also replace the pm_runtime_{get/put}_sync() calls in
auto_hibern8_show to ufshcd_rpm_{get/put}_sync() as any host controller
register reads should.

Reviewed-by: Keoseong Park <keosung.park@samsung.com>
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
Signed-off-by: Avri Altman <avri.altman@wdc.com>
---
 drivers/ufs/core/ufs-sysfs.c | 38 +++++++++++++++++++++---------------
 include/ufs/ufshci.h         |  5 +++--
 2 files changed, 25 insertions(+), 18 deletions(-)

diff --git a/drivers/ufs/core/ufs-sysfs.c b/drivers/ufs/core/ufs-sysfs.c
index e80a32421a8c..dec7746c98e0 100644
--- a/drivers/ufs/core/ufs-sysfs.c
+++ b/drivers/ufs/core/ufs-sysfs.c
@@ -198,6 +198,24 @@ static u32 ufshcd_us_to_ahit(unsigned int timer)
 	       FIELD_PREP(UFSHCI_AHIBERN8_SCALE_MASK, scale);
 }
 
+static int ufshcd_read_hci_reg(struct ufs_hba *hba, u32 *val, unsigned int reg)
+{
+	down(&hba->host_sem);
+	if (!ufshcd_is_user_access_allowed(hba)) {
+		up(&hba->host_sem);
+		return -EBUSY;
+	}
+
+	ufshcd_rpm_get_sync(hba);
+	ufshcd_hold(hba);
+	*val = ufshcd_readl(hba, reg);
+	ufshcd_release(hba);
+	ufshcd_rpm_put_sync(hba);
+
+	up(&hba->host_sem);
+	return 0;
+}
+
 static ssize_t auto_hibern8_show(struct device *dev,
 				 struct device_attribute *attr, char *buf)
 {
@@ -208,23 +226,11 @@ static ssize_t auto_hibern8_show(struct device *dev,
 	if (!ufshcd_is_auto_hibern8_supported(hba))
 		return -EOPNOTSUPP;
 
-	down(&hba->host_sem);
-	if (!ufshcd_is_user_access_allowed(hba)) {
-		ret = -EBUSY;
-		goto out;
-	}
-
-	pm_runtime_get_sync(hba->dev);
-	ufshcd_hold(hba);
-	ahit = ufshcd_readl(hba, REG_AUTO_HIBERNATE_IDLE_TIMER);
-	ufshcd_release(hba);
-	pm_runtime_put_sync(hba->dev);
-
-	ret = sysfs_emit(buf, "%d\n", ufshcd_ahit_to_us(ahit));
+	ret = ufshcd_read_hci_reg(hba, &ahit, REG_AUTO_HIBERNATE_IDLE_TIMER);
+	if (ret)
+		return ret;
 
-out:
-	up(&hba->host_sem);
-	return ret;
+	return sysfs_emit(buf, "%d\n", ufshcd_ahit_to_us(ahit));
 }
 
 static ssize_t auto_hibern8_store(struct device *dev,
diff --git a/include/ufs/ufshci.h b/include/ufs/ufshci.h
index 38fe97971a65..194e3655902e 100644
--- a/include/ufs/ufshci.h
+++ b/include/ufs/ufshci.h
@@ -25,8 +25,9 @@ enum {
 	REG_CONTROLLER_CAPABILITIES		= 0x00,
 	REG_MCQCAP				= 0x04,
 	REG_UFS_VERSION				= 0x08,
-	REG_CONTROLLER_DEV_ID			= 0x10,
-	REG_CONTROLLER_PROD_ID			= 0x14,
+	REG_EXT_CONTROLLER_CAPABILITIES		= 0x0C,
+	REG_CONTROLLER_PID			= 0x10,
+	REG_CONTROLLER_MID			= 0x14,
 	REG_AUTO_HIBERNATE_IDLE_TIMER		= 0x18,
 	REG_INTERRUPT_STATUS			= 0x20,
 	REG_INTERRUPT_ENABLE			= 0x24,
-- 
2.25.1

