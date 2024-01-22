Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19A1ED262
	for <linux-scsi@vger.kernel.org>; Mon, 22 Jan 2024 06:21:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.188
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705904514; cv=none; b=V4t4A4VcfnWLBeOUUuWIUIe5FoAw2xPJHe51fGstlVMUY4UdBb2q5rsNSj7Ghb8CN/hJ31PjH07goZPOjrbWdzohcIJpS1xSIj1Rksk9tC7iqcQiO4psQPRqY/Iejj02FmHlMPuoZffQ6v2q3xwDXbucyInE8Qj0QoJAeRsSPYM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705904514; c=relaxed/simple;
	bh=cSASeODNTk7ju5aIbY6KUqa6knStYgnDHy6ZXHFCSvY=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=i2f3t94k0Z5mYoppqsVxZ4xxOKrpikWk57o3aTp/Y6y3ClXCtm89PttsxNIsMAwRgdClZflh4fZCoLpvNXKi9MR0Eo3JZGkhfBrexV9Qzk+FyqdzZ1gPbJXtEHXSSpHJ7pdcjjtxiuDhy2nCGKymPQw4uUlRNn2nWx+csGhprdI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=hisilicon.com; spf=pass smtp.mailfrom=hisilicon.com; arc=none smtp.client-ip=45.249.212.188
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=hisilicon.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=hisilicon.com
Received: from mail.maildlp.com (unknown [172.19.162.254])
	by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4TJKpd0SKwzXgbt;
	Mon, 22 Jan 2024 14:20:41 +0800 (CST)
Received: from kwepemi500025.china.huawei.com (unknown [7.221.188.170])
	by mail.maildlp.com (Postfix) with ESMTPS id 173EF180086;
	Mon, 22 Jan 2024 14:21:35 +0800 (CST)
Received: from localhost.localdomain (10.69.192.58) by
 kwepemi500025.china.huawei.com (7.221.188.170) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Mon, 22 Jan 2024 14:20:50 +0800
From: chenxiang <chenxiang66@hisilicon.com>
To: <jejb@linux.ibm.com>, <martin.petersen@oracle.com>
CC: <linux-scsi@vger.kernel.org>, <linuxarm@huawei.com>, Xiang Chen
	<chenxiang66@hisilicon.com>
Subject: [PATCH 4/4] scsi: hisi_sas: Remove hisi_hba->timer for v3 hw
Date: Mon, 22 Jan 2024 14:25:47 +0800
Message-ID: <1705904747-62186-5-git-send-email-chenxiang66@hisilicon.com>
X-Mailer: git-send-email 2.8.1
In-Reply-To: <1705904747-62186-1-git-send-email-chenxiang66@hisilicon.com>
References: <1705904747-62186-1-git-send-email-chenxiang66@hisilicon.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
 kwepemi500025.china.huawei.com (7.221.188.170)

From: Xiang Chen <chenxiang66@hisilicon.com>

Hisi_hba->timer is not used for v3 hw actually, but there are two places
that some operations related to hisi_hba->timer is calling by v3 hw:
- delete the timer in function hisi_sas_v3_hw() which is only for v3 hw;
- delete the timer in function hisi_sas_controller_reset_prepare() which
is common for v1/v2/v3 hw

We can remove it in the first place, but for the second place we need to
remove it only for v3 hw, so check hw->sht which is Null only for v3 hw
before deleting hisi_hba->timer.

Signed-off-by: Xiang Chen <chenxiang66@hisilicon.com>
---
 drivers/scsi/hisi_sas/hisi_sas_main.c  | 7 ++++++-
 drivers/scsi/hisi_sas/hisi_sas_v3_hw.c | 1 -
 2 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/hisi_sas/hisi_sas_main.c b/drivers/scsi/hisi_sas/hisi_sas_main.c
index 0b66c73..097dfe4 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_main.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_main.c
@@ -1507,7 +1507,12 @@ void hisi_sas_controller_reset_prepare(struct hisi_hba *hisi_hba)
 	scsi_block_requests(shost);
 	hisi_hba->hw->wait_cmds_complete_timeout(hisi_hba, 100, 5000);
 
-	del_timer_sync(&hisi_hba->timer);
+	/*
+	 * hisi_hba->timer is only used for v1/v2 hw, and check hw->sht
+	 * which is also only used for v1/v2 hw to skip it for v3 hw
+	 */
+	if (hisi_hba->hw->sht)
+		del_timer_sync(&hisi_hba->timer);
 
 	set_bit(HISI_SAS_REJECT_CMD_BIT, &hisi_hba->flags);
 }
diff --git a/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c b/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
index 033298d..7d2a335 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
@@ -4935,7 +4935,6 @@ static void hisi_sas_v3_remove(struct pci_dev *pdev)
 	struct Scsi_Host *shost = sha->shost;
 
 	pm_runtime_get_noresume(dev);
-	del_timer_sync(&hisi_hba->timer);
 
 	sas_unregister_ha(sha);
 	flush_workqueue(hisi_hba->wq);
-- 
2.8.1

