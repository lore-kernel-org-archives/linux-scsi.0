Received: from szxga05-in.huawei.com (szxga05-in.huawei.com [45.249.212.191])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E0D1173320
	for <linux-scsi@vger.kernel.org>; Thu, 26 Sep 2024 01:43:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.191
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727315018; cv=none; b=RNn1VstMeEl9ySVL59zuYZ85aVomvmFyt6Hv6t9RJYCGAlGGdmZFxGijXeb2N9GfCQLayzH1e+lKS+9c9h2ntk8ah4hxYVKXMQqKbZtObsm0Kq1lnm3gCpcxldTHBk+awJeLdgTNGolbbZ6+bUIbW8pmCeWCDtho/VljugoqWJE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727315018; c=relaxed/simple;
	bh=zslkVdI65BfNdZCGJ/oQ2+q+7u0AnER4uoluoLE+3hU=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=RRW47VI9JPM2/FYypz9QLLJYzwv0t7tisnf24TJzL/i5HoIRGV958Qq0oyelQktj8F7pDK4MTdVtnXcrxUPU2BMGH/EChvEos0WQS2bJ1RAHzb7XMJY4g2F+i+kPuL5Q+CdThaIbt4i9os/DuM8j9JNFa0+WuqAmPTVaS3zH5og=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.191
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.88.163])
	by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4XDbqz4CrZz1HKCx;
	Thu, 26 Sep 2024 09:39:43 +0800 (CST)
Received: from dggpemf100013.china.huawei.com (unknown [7.185.36.179])
	by mail.maildlp.com (Postfix) with ESMTPS id BF82518002B;
	Thu, 26 Sep 2024 09:43:34 +0800 (CST)
Received: from localhost.huawei.com (10.50.165.33) by
 dggpemf100013.china.huawei.com (7.185.36.179) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Thu, 26 Sep 2024 09:43:34 +0800
From: Yihang Li <liyihang9@huawei.com>
To: <James.Bottomley@HansenPartnership.com>, <martin.petersen@oracle.com>
CC: <linux-scsi@vger.kernel.org>, <linuxarm@huawei.com>,
	<liyihang9@huawei.com>
Subject: [PATCH 11/13] scsi: hisi_sas: Update v3 hw STP_LINK_TIMER setting
Date: Thu, 26 Sep 2024 09:43:30 +0800
Message-ID: <20240926014332.3905399-12-liyihang9@huawei.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20240926014332.3905399-1-liyihang9@huawei.com>
References: <20240926014332.3905399-1-liyihang9@huawei.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
 dggpemf100013.china.huawei.com (7.185.36.179)

From: Xingui Yang <yangxingui@huawei.com>

At present, it is found that some SATA HDD disks may continue to return the
HOLD primitive for more than 500ms when they are busy writing data, which
is more likely to trigger an STP link timeout exception. Now Modify STP
link timer from 500ms to the maximum value of 1.048575s.

Signed-off-by: Xingui Yang <yangxingui@huawei.com>
Reviewed-by: Yihang Li <liyihang9@huawei.com>
---
 drivers/scsi/hisi_sas/hisi_sas_v3_hw.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c b/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
index 5c97c4463032..bc5c96320f5a 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
@@ -686,7 +686,7 @@ static void init_reg_v3_hw(struct hisi_hba *hisi_hba)
 		hisi_sas_phy_write32(hisi_hba, i, PHY_CTRL_RDY_MSK, 0x0);
 		hisi_sas_phy_write32(hisi_hba, i, PHYCTRL_DWS_RESET_MSK, 0x0);
 		hisi_sas_phy_write32(hisi_hba, i, PHYCTRL_OOB_RESTART_MSK, 0x1);
-		hisi_sas_phy_write32(hisi_hba, i, STP_LINK_TIMER, 0x7f7a120);
+		hisi_sas_phy_write32(hisi_hba, i, STP_LINK_TIMER, 0x7ffffff);
 		hisi_sas_phy_write32(hisi_hba, i, CON_CFG_DRIVER, 0x2a0a01);
 		hisi_sas_phy_write32(hisi_hba, i, SAS_EC_INT_COAL_TIME,
 				     0x30f4240);
-- 
2.33.0

