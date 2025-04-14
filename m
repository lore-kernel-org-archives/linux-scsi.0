Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4B3F259C84;
	Mon, 14 Apr 2025 08:08:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.187
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744618133; cv=none; b=nllizoG+xR5UIuiasfuN6pqNFtVYsdIIljdHtbZOwVY1rxwy0JgmziuT9JWmki9+NeYu1Snqgi+I+P/cdeHwO+5tnCSWNJ7ebsmenWraXgcYMs2UlGisJNUjDfxxhL+56urvLffmsQ+Iu38MD2x8AyI01O4Uo8BxapaPL6ukUm0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744618133; c=relaxed/simple;
	bh=RXiIoJmwdgY+eS+X74ykYmE1AL9TNuJ+L3FNsdrHTmE=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Jjh4ljhdkHaCdME3zfYTfZ5eYD02x0CKh2+rv9dBPN3qDrfLgcZJVSDgDpSYI4B4sJJxJKANql1FADuGc/T1T32Lg6qqXyMF8aHtNqcEgtQYPwhe7Pp1AWjMYwyI8Byg0UVaFiG8NmH4YcjOzLx0kl475RXaKZfqTsCuWBJ9+BY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.187
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.163.48])
	by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4Zbfzg3KqPz13LPZ;
	Mon, 14 Apr 2025 16:07:59 +0800 (CST)
Received: from dggpemf100013.china.huawei.com (unknown [7.185.36.179])
	by mail.maildlp.com (Postfix) with ESMTPS id B5282180080;
	Mon, 14 Apr 2025 16:08:46 +0800 (CST)
Received: from localhost.localdomain (10.50.165.33) by
 dggpemf100013.china.huawei.com (7.185.36.179) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Mon, 14 Apr 2025 16:08:46 +0800
From: Yihang Li <liyihang9@huawei.com>
To: <martin.petersen@oracle.com>, <James.Bottomley@HansenPartnership.com>
CC: <linux-scsi@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<linuxarm@huawei.com>, <liyihang9@huawei.com>, <liuyonglong@huawei.com>,
	<prime.zeng@hisilicon.com>
Subject: [PATCH v3 4/4] scsi: hisi_sas: Wait until eh is recovered
Date: Mon, 14 Apr 2025 16:08:45 +0800
Message-ID: <20250414080845.1220997-5-liyihang9@huawei.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20250414080845.1220997-1-liyihang9@huawei.com>
References: <20250414080845.1220997-1-liyihang9@huawei.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: dggems705-chm.china.huawei.com (10.3.19.182) To
 dggpemf100013.china.huawei.com (7.185.36.179)

SATA devices are lost when FLR is performed while the controller and disks
are in suspended state.

This is because the libata layer is called to initialize the SATA device
during controller resuming. If FLR is executed at this time, the IDENTIFY
command fails. As a result, the revalidate fails, and the SATA device is
disabled by the libata layer.

So, wait until eh is recovered.

Signed-off-by: Yihang Li <liyihang9@huawei.com>
---
 drivers/scsi/hisi_sas/hisi_sas_v3_hw.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c b/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
index 15f1d5d783cb..d7a5522890a3 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
@@ -5100,9 +5100,11 @@ static void hisi_sas_reset_prepare_v3_hw(struct pci_dev *pdev)
 {
 	struct sas_ha_struct *sha = pci_get_drvdata(pdev);
 	struct hisi_hba *hisi_hba = sha->lldd_ha;
+	struct Scsi_Host *shost = hisi_hba->shost;
 	struct device *dev = hisi_hba->dev;
 	int rc;
 
+	wait_event(shost->host_wait, !scsi_host_in_recovery(shost));
 	dev_info(dev, "FLR prepare\n");
 	down(&hisi_hba->sem);
 	set_bit(HISI_SAS_RESETTING_BIT, &hisi_hba->flags);
-- 
2.33.0

