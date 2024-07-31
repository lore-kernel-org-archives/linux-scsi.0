Received: from esa5.hgst.iphmx.com (esa5.hgst.iphmx.com [216.71.153.144])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2AE91AD9FF;
	Wed, 31 Jul 2024 12:22:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=216.71.153.144
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722428540; cv=none; b=qIRc9Y9Vv4VVWdK5dPSDwGaRPtMtoCZN/xYlrgzJDJIl9/9vhfq3MEQHX3j+ODnXfbFib+WO9QpTi7F0cZCfQsRoMpQfjSnFRxxWLXPopOFnwajgSEat2mSEtIzg/uuAHu0hx60S4DjqCjHy3100SVxlSRTRqS2V6Ak3uQpW7Uc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722428540; c=relaxed/simple;
	bh=VJVT/K2rFT2gV6I6mbycIEfIkRg62vzI6yc7jU/kF9M=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=h70p4g2nuiW15JiAkG9hIxEDhB68mUSSDlK50sFFG8gcfiE390SpIYja0j1467sp4hKoWuy7EIJ9Wir1cYJa69Z1XBhhQAluKOd7SGp7f4y1/zd04MAYXa0ylBp2N+jA8He1ZdD6uzGV1D7r+Nw4eFDgXPg0/fjuuk2bo0TAMaU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=oNGt8+OO; arc=none smtp.client-ip=216.71.153.144
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="oNGt8+OO"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1722428538; x=1753964538;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=VJVT/K2rFT2gV6I6mbycIEfIkRg62vzI6yc7jU/kF9M=;
  b=oNGt8+OO+RITVjXHquc/yGRWhdwp0T71qVHtZN11p/dYc5Pi1uBSY9os
   2SVWpKLsX0oRlaOnSEZ0NaxekfxFSkhPRmnk8JLpXd85OBBJfaovL4Ktj
   4UGD0Txo88c12sSsdWcBe2cy54R7+eGTFZo2WCZKmN+MJadawYr4vh9wG
   G5ai7WQV1MIm5c8WA66/2XOYRvgh4lT5ljfxAYGgoqxx/p6OSPg6oEu+K
   TE134j7/scUUnW4G/dfis4ccNFqtjJARTqtSYl7ZY7fTGBCy75hcVp5Jz
   TRbaA2ud/Dxu8SZ7dHlyiFcpDoSE97fYVVLAOidOEWo039IzRqpKarnQu
   g==;
X-CSE-ConnectionGUID: 4FphUws6SNSxk+8a7Mzvsw==
X-CSE-MsgGUID: p2dJmrwqTxG+lyG9JkB/gA==
X-IronPort-AV: E=Sophos;i="6.09,251,1716220800"; 
   d="scan'208";a="24150840"
Received: from uls-op-cesaip02.wdc.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 31 Jul 2024 20:22:14 +0800
IronPort-SDR: 66aa1e85_I/Te2pDSmPxVoIqxJo5fNYJHzDU+PhCW0ci0bLhfxb4gF1L
 yUkZV+ijHFVg5fbD9jNpLpfwpTwk03Q8Qa12ttQ==
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 31 Jul 2024 04:22:45 -0700
WDCIronportException: Internal
Received: from avri-office.ad.shared (HELO avri-office.sdcorp.global.sandisk.com) ([10.45.31.142])
  by uls-op-cesaip02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 31 Jul 2024 05:22:13 -0700
From: Avri Altman <avri.altman@wdc.com>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Avri Altman <avri.altman@wdc.com>
Subject: [PATCH 1/2] scsi: ufs: Prepare to add HCI capabilities sysfs
Date: Wed, 31 Jul 2024 15:20:50 +0300
Message-Id: <20240731122051.2058406-2-avri.altman@wdc.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20240731122051.2058406-1-avri.altman@wdc.com>
References: <20240731122051.2058406-1-avri.altman@wdc.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Prepare so we'll be able to read various other HCI registers.
While at it, fix the HCPID & HCMID register names to stand for what they
really are.

Signed-off-by: Avri Altman <avri.altman@wdc.com>
---
 drivers/ufs/core/ufs-sysfs.c | 38 +++++++++++++++++++++---------------
 include/ufs/ufshci.h         |  5 +++--
 2 files changed, 25 insertions(+), 18 deletions(-)

diff --git a/drivers/ufs/core/ufs-sysfs.c b/drivers/ufs/core/ufs-sysfs.c
index e80a32421a8c..7a264f8ef140 100644
--- a/drivers/ufs/core/ufs-sysfs.c
+++ b/drivers/ufs/core/ufs-sysfs.c
@@ -198,33 +198,39 @@ static u32 ufshcd_us_to_ahit(unsigned int timer)
 	       FIELD_PREP(UFSHCI_AHIBERN8_SCALE_MASK, scale);
 }
 
-static ssize_t auto_hibern8_show(struct device *dev,
-				 struct device_attribute *attr, char *buf)
+static int ufshcd_read_hci_reg(struct ufs_hba *hba, u32 *val, unsigned int reg)
 {
-	u32 ahit;
-	int ret;
-	struct ufs_hba *hba = dev_get_drvdata(dev);
-
-	if (!ufshcd_is_auto_hibern8_supported(hba))
-		return -EOPNOTSUPP;
-
 	down(&hba->host_sem);
 	if (!ufshcd_is_user_access_allowed(hba)) {
-		ret = -EBUSY;
-		goto out;
+		up(&hba->host_sem);
+		return -EBUSY;
 	}
 
 	pm_runtime_get_sync(hba->dev);
 	ufshcd_hold(hba);
-	ahit = ufshcd_readl(hba, REG_AUTO_HIBERNATE_IDLE_TIMER);
+	*val = ufshcd_readl(hba, reg);
 	ufshcd_release(hba);
 	pm_runtime_put_sync(hba->dev);
 
-	ret = sysfs_emit(buf, "%d\n", ufshcd_ahit_to_us(ahit));
-
-out:
 	up(&hba->host_sem);
-	return ret;
+	return 0;
+}
+
+static ssize_t auto_hibern8_show(struct device *dev,
+				 struct device_attribute *attr, char *buf)
+{
+	u32 ahit;
+	int ret;
+	struct ufs_hba *hba = dev_get_drvdata(dev);
+
+	if (!ufshcd_is_auto_hibern8_supported(hba))
+		return -EOPNOTSUPP;
+
+	ret = ufshcd_read_hci_reg(hba, &ahit, REG_AUTO_HIBERNATE_IDLE_TIMER);
+	if (ret)
+		return ret;
+
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

