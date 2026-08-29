Received: from canpmsgout04.his.huawei.com (canpmsgout04.his.huawei.com [113.46.200.219])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 133D7279907;
	Sat, 29 Aug 2026 03:29:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=113.46.200.219
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787974151; cv=none; b=sd6kjtdf3t1+w0v/IWH7f5rX1i1hJwDI96Shnmams+h8M2Kg7wyMqL/DcZMgFY8GrRLxblCevLm83nQP3Sw51L+w/dQ00ONlsn6I0QQlHrZxEM38Qlj8oR8fye3QIyWSw5TPoB32/lxHokIMaXdoxu6usX3cx0L+Hn+C5/v77ts=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787974151; c=relaxed/simple;
	bh=Kl4RMYqPxKLfNzlXyz2/w0whYyYP/6sieypoK6mmKAg=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=t+9RHevasos5QNtWw9W5wRcZhJJi6ZPtnPlaDq85u58Z0OosxcSfJark20ILyw+CpJubRN+ocsisK9bd0bA1+OzZ1iGVvFCMn4Q3zJrJAtUGjVAi+nnEPTWCC1KBhZunU068sSlsy9HeJQSWltPdjIKOFNVCubf7TZJA6U+m/tI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=h-partners.com; dkim=pass (1024-bit key) header.d=h-partners.com header.i=@h-partners.com header.b=BZUqmShd; arc=none smtp.client-ip=113.46.200.219
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=h-partners.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=h-partners.com header.i=@h-partners.com header.b="BZUqmShd"
dkim-signature: v=1; a=rsa-sha256; d=h-partners.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=pwjYKHkgPOmx9AT4534QkaAi2hLvqbUxJbHrvStqynM=;
	b=BZUqmShdL+UrMdcdkRPBJY787XUAcfvax78XaiProRj9vmrpRMQXJMSvb9ZfJx7PsC79KpHkY
	WVPRjbSFPoTVJsQSVlp76Te6nYLEYIDlaoTiZQlfw2zTmLcXbyvDyvuATPLX9XBl/EyMTIAN6WS
	wdexGX0ejzZ2MC/jxxqsC/4=
Received: from mail.maildlp.com (unknown [172.19.162.144])
	by canpmsgout04.his.huawei.com (SkyGuard) with ESMTPS id 4hX0nZ5LBrz1prKd;
	Sat, 29 Aug 2026 11:18:10 +0800 (CST)
Received: from kwepemp100006.china.huawei.com (unknown [7.202.195.87])
	by mail.maildlp.com (Postfix) with ESMTPS id E710A40538;
	Sat, 29 Aug 2026 11:28:59 +0800 (CST)
Received: from kwepemp500015.china.huawei.com (7.202.195.9) by
 kwepemp100006.china.huawei.com (7.202.195.87) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.45; Sat, 29 Aug 2026 11:28:59 +0800
Received: from localhost.localdomain (10.50.163.32) by
 kwepemp500015.china.huawei.com (7.202.195.9) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.45; Sat, 29 Aug 2026 11:28:59 +0800
From: Xingui Yang <yangxingui@huawei.com>
To: <jejb@linux.ibm.com>, <martin.petersen@oracle.com>,
	<john.g.garry@oracle.com>, <yanaijie@huawei.com>
CC: <linux-scsi@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<linuxarm@huawei.com>, <yangxingui@huawei.com>, <liuyonglong@huawei.com>,
	<kangfenglong@huawei.com>
Subject: [PATCH 1/3] scsi: hisi_sas: Fix incorrect delay values from magic-number cleanup
Date: Sat, 29 Aug 2026 11:28:56 +0800
Message-ID: <20260829032858.1661019-2-yangxingui@huawei.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260829032858.1661019-1-yangxingui@huawei.com>
References: <20260829032858.1661019-1-yangxingui@huawei.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: kwepems100001.china.huawei.com (7.221.188.238) To
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
index 213d5b5dea94..dcb1c65113de 100644
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

