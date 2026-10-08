Received: from canpmsgout01.his.huawei.com (canpmsgout01.his.huawei.com [113.46.200.216])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19DE02135B8;
	Thu,  8 Oct 2026 03:26:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=113.46.200.216
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791429980; cv=none; b=A7M9XDXhw1rxtIuh2FBsJ+8HfUBNI2SQAVNF7xJXR+WvmiJtI6XaiJqOrMz0+7P7ovRKd+qkRufPFwSgNjD87mg0JN1VE+h23HAEyeqcbv0tP77WZLafsaNzDi6axu5viIIvYskJYCs53JJ/J8s2fPTjdjgerji8NgFel+8wP3Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791429980; c=relaxed/simple;
	bh=ar6LCuGMlJyeug6Mz0Uo8jBG93Z4sWFJv2H98essfy4=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=WFsfGqkjG18CnquxsUr/TGrC6FU9CDq5MSrmKDHNolEmZ3/GBoUGepzsU/lsJSFhagI8JvHJvfqwG1LhV4ZXZpooByatDRNlK0ZDsr3LsD25ZQzFYcPLSp/fCgqwc1WWg3TRiy0pg5yEXIRDGIWQwfYWiNwTNMbjeydSQWR7+TY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=h-partners.com; dkim=pass (1024-bit key) header.d=h-partners.com header.i=@h-partners.com header.b=XGB/lry0; arc=none smtp.client-ip=113.46.200.216
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=h-partners.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=h-partners.com header.i=@h-partners.com header.b="XGB/lry0"
dkim-signature: v=1; a=rsa-sha256; d=h-partners.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=acxlm9lMiji4kTwJQg5tQSY03/227aOYVrKZVmKZqjk=;
	b=XGB/lry0Xdvswtl4E4SEJZNjYj+dU0FctBjTC4/eQFUG9HUqakPAilCQD1t7PS1d6Faa9uVPc
	Deg/ReD651uLjBHF1RpY4erylLKxH/eDdL0RlSa/3jThoavCuKaqXIy2qu7i+TldOuY9h84c1T3
	MQ64Ea8PlUu7E/My6LmbC10=
Received: from mail.maildlp.com (unknown [172.19.162.223])
	by canpmsgout01.his.huawei.com (SkyGuard) with ESMTPS id 4j0ZpD1RPTz1T4Fq;
	Thu,  8 Oct 2026 11:13:56 +0800 (CST)
Received: from kwepemp200006.china.huawei.com (unknown [7.202.195.217])
	by mail.maildlp.com (Postfix) with ESMTPS id AA8A940561;
	Thu,  8 Oct 2026 11:26:08 +0800 (CST)
Received: from kwepemp500015.china.huawei.com (7.202.195.9) by
 kwepemp200006.china.huawei.com (7.202.195.217) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.45; Thu, 8 Oct 2026 11:26:08 +0800
Received: from localhost.localdomain (10.50.163.32) by
 kwepemp500015.china.huawei.com (7.202.195.9) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.45; Thu, 8 Oct 2026 11:26:07 +0800
From: Xingui Yang <yangxingui@huawei.com>
To: <mkp@kernel.org>, <jejb@linux.ibm.com>, <john.garry@linux.dev>,
	<yanaijie@huawei.com>
CC: <linux-scsi@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<linuxarm@huawei.com>, <liuyonglong@huawei.com>, <kangfenglong@huawei.com>
Subject: [PATCH v2 2/4] scsi: hisi_sas: Fix incorrect delay values from magic-number cleanup
Date: Thu, 8 Oct 2026 11:26:03 +0800
Message-ID: <20261008032605.2853026-3-yangxingui@huawei.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261008032605.2853026-1-yangxingui@huawei.com>
References: <20261008032605.2853026-1-yangxingui@huawei.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: kwepems500001.china.huawei.com (7.221.188.70) To
 kwepemp500015.china.huawei.com (7.202.195.9)

Commit 4ca7fe99fc84 ("scsi: hisi_sas: Use macro instead of magic
number") replaced several delay constants with a single macro of
value 100. However, three sites originally used different values:

  - reset_hw_v3_hw:     udelay(50) -> udelay(100) [doubled]
  - disable_phy_v3_hw:  mdelay(50) -> mdelay(100) [doubled]
  - disable_host_v3_hw: mdelay(10) -> mdelay(100) [10x longer]

The overly long delays on the PHY disable and host shutdown paths
increase boot and shutdown time for all local PHYs.

Add separate macros for each delay to restore the original values
while still avoiding magic numbers.

Fixes: 4ca7fe99fc84 ("scsi: hisi_sas: Use macro instead of magic number")
Signed-off-by: Xingui Yang <yangxingui@huawei.com>
---
 drivers/scsi/hisi_sas/hisi_sas_v3_hw.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c b/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
index 8a2500993e19..9c363e237353 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
@@ -547,6 +547,9 @@ struct hisi_sas_err_record_v3 {
 #define IRQ_AXI_INDEX 11
 
 #define DELAY_FOR_RESET_HW 100
+#define STOP_PHY_DELAY_US 50
+#define DISABLE_PHY_DELAY_MS 50
+#define DISABLE_HOST_PHY_DELAY_MS 10
 #define HDR_SG_MOD 0x2
 #define LUN_SIZE 8
 #define ATTR_PRIO_REGION 9
@@ -983,7 +986,7 @@ static int reset_hw_v3_hw(struct hisi_hba *hisi_hba)
 
 	/* Disable all of the PHYs */
 	hisi_sas_stop_phys(hisi_hba);
-	udelay(HISI_SAS_DELAY_FOR_PHY_DISABLE);
+	udelay(STOP_PHY_DELAY_US);
 
 	/* Ensure axi bus idle */
 	ret = hisi_sas_read32_poll_timeout(AXI_CFG, val, !val,
@@ -1072,7 +1075,7 @@ static void disable_phy_v3_hw(struct hisi_hba *hisi_hba, int phy_no)
 	cfg &= ~PHY_CFG_ENA_MSK;
 	hisi_sas_phy_write32(hisi_hba, phy_no, PHY_CFG, cfg);
 
-	mdelay(HISI_SAS_DELAY_FOR_PHY_DISABLE);
+	mdelay(DISABLE_PHY_DELAY_MS);
 
 	state = hisi_sas_read32(hisi_hba, PHY_STATE);
 	if (state & BIT(phy_no)) {
@@ -2755,7 +2758,7 @@ static int disable_host_v3_hw(struct hisi_hba *hisi_hba)
 
 	hisi_sas_stop_phys(hisi_hba);
 
-	mdelay(HISI_SAS_DELAY_FOR_PHY_DISABLE);
+	mdelay(DISABLE_HOST_PHY_DELAY_MS);
 
 	reg_val = hisi_sas_read32(hisi_hba, AXI_MASTER_CFG_BASE +
 				  AM_CTRL_GLOBAL);
-- 
2.43.0

