Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A20F1E517
	for <linux-scsi@vger.kernel.org>; Tue,  8 Oct 2024 02:18:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.188
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728353912; cv=none; b=JYlCzg/I4SQrifOnAiLwjevmq7VNTd+SS8YXJDc4mYg5RH/kMDz+ouTTDVLAmYC2EFqZvGIPzZ0OnScbbsh1Tfq4njL5Lwz/p3040aWNzSFB1UeAeWSCahIcDQTeZveTM9dntQnY1AiPzZsCLPtfJibgwuYUtiD0TrEjEaENB3U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728353912; c=relaxed/simple;
	bh=ChMKCfFpwEJHbqP0CdLZzWIf602qYAHo1MB7cMxKs1A=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=opVF50zQyWv0C6U0mPC/Z0kmTkQcDtxhKC1a5+P6ADBEhEzbKa+ZXFOFW+56Yki86UZcY3Hqy1URjUKUrIQzrXyk/XfqLZTTA7QiYS5spwF8tg5mwrYIgJr8HIqLYabjucNf3QVA++iVeAlamClGoIcxPxOsYEdsPGUtI5J/Oog=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.188
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.88.105])
	by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4XN04r0XtJzpWfc;
	Tue,  8 Oct 2024 10:16:28 +0800 (CST)
Received: from dggpemf100013.china.huawei.com (unknown [7.185.36.179])
	by mail.maildlp.com (Postfix) with ESMTPS id 2ADCA1403D5;
	Tue,  8 Oct 2024 10:18:28 +0800 (CST)
Received: from localhost.huawei.com (10.50.165.33) by
 dggpemf100013.china.huawei.com (7.185.36.179) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Tue, 8 Oct 2024 10:18:27 +0800
From: Yihang Li <liyihang9@huawei.com>
To: <James.Bottomley@HansenPartnership.com>, <martin.petersen@oracle.com>
CC: <linux-scsi@vger.kernel.org>, <linuxarm@huawei.com>,
	<liyihang9@huawei.com>
Subject: [PATCH v2 04/13] scsi: hisi_sas: Enable all PHYs that are not disabled by user during controller reset
Date: Tue, 8 Oct 2024 10:18:13 +0800
Message-ID: <20241008021822.2617339-5-liyihang9@huawei.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20241008021822.2617339-1-liyihang9@huawei.com>
References: <20241008021822.2617339-1-liyihang9@huawei.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
 dggpemf100013.china.huawei.com (7.185.36.179)

For the controller reset operation(such as FLR or clear nexus ha in SCSI
EH), we will disable all PHYs and then enable PHY based on the
hisi_hba->phy_state obtained in hisi_sas_controller_reset_prepare(). If
the device is removed before controller reset or the PHY is not attached
to any device in directly attached scenario, the corresponding bit of
phy_state is not set. After controller reset done, the PHY is disabled.
The device cannot be identified even if user reconnect the disk.

Therefore, for PHYs that are not disabled by user, hisi_sas_phy_enable()
needs to be executed even if the corresponding bit of phy_state is not set.

Fixes: 89954f024c3a ("scsi: hisi_sas: Ensure all enabled PHYs up during controller reset")
Signed-off-by: Yihang Li <liyihang9@huawei.com>
Reviewed-by: Xiang Chen <chenxiang66@hisilicon.com>
---
 drivers/scsi/hisi_sas/hisi_sas_main.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/hisi_sas/hisi_sas_main.c b/drivers/scsi/hisi_sas/hisi_sas_main.c
index 275d45a41b0b..f3b0042ab67c 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_main.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_main.c
@@ -1545,10 +1545,16 @@ void hisi_sas_controller_reset_done(struct hisi_hba *hisi_hba)
 	/* Init and wait for PHYs to come up and all libsas event finished. */
 	for (phy_no = 0; phy_no < hisi_hba->n_phy; phy_no++) {
 		struct hisi_sas_phy *phy = &hisi_hba->phy[phy_no];
+		struct asd_sas_phy *sas_phy = &phy->sas_phy;
 
-		if (!(hisi_hba->phy_state & BIT(phy_no)))
+		if (!sas_phy->phy->enabled)
 			continue;
 
+		if (!(hisi_hba->phy_state & BIT(phy_no))) {
+			hisi_sas_phy_enable(hisi_hba, phy_no, 1);
+			continue;
+		}
+
 		async_schedule_domain(hisi_sas_async_init_wait_phyup,
 				      phy, &async);
 	}
-- 
2.33.0

