Received: from esa3.hgst.iphmx.com (esa3.hgst.iphmx.com [216.71.153.141])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4DD21B28A;
	Sun,  4 Aug 2024 07:22:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=216.71.153.141
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722756167; cv=none; b=kCZSDYHtFCeiCjWjvVoith4w8CxNw1uGIW0PnSFahvzehiKqwrRrmz0t+eFXoMArk7n07J5UFtJSYHDA/OkJ4LSma+gH/ZoOGVCOELaVpr53hR/Ex7B/E97uzyjHF9KCpPbdFE/DnAGnka6Kby+vMYHWF1U8e1WvCGWWWpkuM4w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722756167; c=relaxed/simple;
	bh=bSXxBNsipb8VPRVT3Rb7YrwMNkEw8hZ336MNNYdDdlk=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=RrCFASpuiHxTCu9T3h1bSxjQEraC91BAf1G2x9IwggVJ3PLLYuhPAVZYBpROnHz2uxlFXguhjqEioNuS1KhwiFq4MAT+OGpIuaxc/9IXMdRVi7XL6kvrlWnfAs1uIzRub3t6/CCCymGle4ImLOOs5SiLwMYcj4hnYH3D8llQJKU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=jxJL3vRm; arc=none smtp.client-ip=216.71.153.141
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="jxJL3vRm"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1722756166; x=1754292166;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=bSXxBNsipb8VPRVT3Rb7YrwMNkEw8hZ336MNNYdDdlk=;
  b=jxJL3vRmu/so6eOYPCVXvpfX68BdzoJ216PmKptfYJu8KbWxA5DKhlKh
   8XwidvXa/7J94rj04O/xUtZIrs4LpcdZ78YPewfl0UK+sbtT3wY1BLcSa
   JmD+6KcHSjCuAUGGUA9iklFetP7Le20dxgUFKW4PkGLyDVhnkeAcmWSN5
   aXWk2JTComNJC4SuAz5fgsOtkhYqsycLr3A3pTcYE3XL9BZP7FcAJLnxg
   3RMxT+vQs0F/iGbR2GwRSS80uxQ2xFfehMN0lHPCC6mGNqWWWne4G4iri
   15KQqej6MtSPJCgmon5idGXuvsm4QfgSNUalPff395DKDwBjmE1SljHPs
   g==;
X-CSE-ConnectionGUID: veZX/mqLRAODYPvT1XR2CQ==
X-CSE-MsgGUID: fxjQd6F1SlesuMzCkT65XA==
X-IronPort-AV: E=Sophos;i="6.09,262,1716220800"; 
   d="scan'208";a="23384661"
Received: from h199-255-45-14.hgst.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 04 Aug 2024 15:22:39 +0800
IronPort-SDR: 66af1f9c_+OashjvIYB+ZQyZXHB1+ZZgLPlvEcxvwP39teMf3q2UVGQj
 txog6dJLV7iYe6k2APCcmPbE0WzNj74DUa00U6g==
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 03 Aug 2024 23:28:45 -0700
WDCIronportException: Internal
Received: from avri-office.ad.shared (HELO avri-office.sdcorp.global.sandisk.com) ([10.45.31.142])
  by uls-op-cesaip02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 04 Aug 2024 00:22:37 -0700
From: Avri Altman <avri.altman@wdc.com>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>,
	Avri Altman <avri.altman@wdc.com>
Subject: [PATCH v2 1/2] scsi: ufs: Prepare to add HCI capabilities sysfs
Date: Sun,  4 Aug 2024 10:21:08 +0300
Message-Id: <20240804072109.2330880-2-avri.altman@wdc.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20240804072109.2330880-1-avri.altman@wdc.com>
References: <20240804072109.2330880-1-avri.altman@wdc.com>
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

