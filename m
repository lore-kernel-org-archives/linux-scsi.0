Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB1E55695
	for <linux-scsi@vger.kernel.org>; Mon, 22 Jan 2024 06:21:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.188
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705904491; cv=none; b=nTrXaUuBuUs0mM2ZOig5kor7AyfuLrkosgSUzwg0Jx/AzrZuiLLiTojLHV2ri7KE+ZF1S8WnuD4Y1gPYUS9ur1hhxS6ijpsj9YzpBvFD6wBv8teP3fcsjbXWe5f6TEHWA7nhrYSQR+bNJl6sDykWaJMi6A3ss0dBB9bEpOJDiJE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705904491; c=relaxed/simple;
	bh=prm8afriE3L7+Ezt+NN2IL+bQCqsRyoMjnIX95cj7Qc=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=jHW7UPqbNTNF6TXgCiodNFnGb7z7cpR5mG8Eanj/Vvo3KLV923b1R9dk7CxNmxFEKytozsaRxZTdA5CWFcT8ZpisHQm0jAtb71Eyd05ihQXl6Ggep9sN/ugR5Qy9UMs/2zajv2zX5LEO2NDOjy936cQMUMHnlk9plyt5aEilrhQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=hisilicon.com; spf=pass smtp.mailfrom=hisilicon.com; arc=none smtp.client-ip=45.249.212.188
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=hisilicon.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=hisilicon.com
Received: from mail.maildlp.com (unknown [172.19.162.254])
	by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4TJKp26mSYzXgZv;
	Mon, 22 Jan 2024 14:20:10 +0800 (CST)
Received: from kwepemi500025.china.huawei.com (unknown [7.221.188.170])
	by mail.maildlp.com (Postfix) with ESMTPS id F03C5180089;
	Mon, 22 Jan 2024 14:21:04 +0800 (CST)
Received: from localhost.localdomain (10.69.192.58) by
 kwepemi500025.china.huawei.com (7.221.188.170) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Mon, 22 Jan 2024 14:20:49 +0800
From: chenxiang <chenxiang66@hisilicon.com>
To: <jejb@linux.ibm.com>, <martin.petersen@oracle.com>
CC: <linux-scsi@vger.kernel.org>, <linuxarm@huawei.com>, Yihang Li
	<liyihang9@huawei.com>, Xiang Chen <chenxiang66@hisilicon.com>
Subject: [PATCH 2/4] scsi: hisi_sas: Remove redundant checks for automatic debugfs dump
Date: Mon, 22 Jan 2024 14:25:45 +0800
Message-ID: <1705904747-62186-3-git-send-email-chenxiang66@hisilicon.com>
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

From: Yihang Li <liyihang9@huawei.com>

In commit 63f0733d07ce ("scsi: hisi_sas: Allocate DFX memory during dump
trigger"), the memory allocation time of the DFX is changed from device
initialization to dump occurs, so .debugfs_itct is not a valid address and
do not need to check.

The parameter hisi_sas_debugfs_enable is enough to check whether automatic
debugfs dump is triggered, so remove redunant checks.

Fixes: 63f0733d07ce ("scsi: hisi_sas: Allocate DFX memory during dump trigger")
Signed-off-by: Yihang Li <liyihang9@huawei.com>
Signed-off-by: Xiang Chen <chenxiang66@hisilicon.com>
---
 drivers/scsi/hisi_sas/hisi_sas_main.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/hisi_sas/hisi_sas_main.c b/drivers/scsi/hisi_sas/hisi_sas_main.c
index 1abc62b..70c998d 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_main.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_main.c
@@ -1573,7 +1573,7 @@ static int hisi_sas_controller_prereset(struct hisi_hba *hisi_hba)
 		return -EPERM;
 	}
 
-	if (hisi_sas_debugfs_enable && hisi_hba->debugfs_itct[0].itct)
+	if (hisi_sas_debugfs_enable)
 		hisi_hba->hw->debugfs_snapshot_regs(hisi_hba);
 
 	return 0;
@@ -1961,7 +1961,7 @@ static bool hisi_sas_internal_abort_timeout(struct sas_task *task,
 	struct hisi_hba *hisi_hba = dev_to_hisi_hba(device);
 	struct hisi_sas_internal_abort_data *timeout = data;
 
-	if (hisi_sas_debugfs_enable && hisi_hba->debugfs_itct[0].itct) {
+	if (hisi_sas_debugfs_enable) {
 		/*
 		 * If timeout occurs in device gone scenario, to avoid
 		 * circular dependency like:
-- 
2.8.1

