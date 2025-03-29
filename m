Received: from szxga04-in.huawei.com (szxga04-in.huawei.com [45.249.212.190])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0DBFE183CCA;
	Sat, 29 Mar 2025 07:32:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.190
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743233565; cv=none; b=csWgPd7Yi5xSpf4jmttq9nN6kJymR0C0N3/lrBreOVFWMMT3KNcOi2BhCNq1xUd3xXRTNYLUI9wAGMm8Re+ApgnYhw+smIz73OSjhOe9s/NGlZ/4td8UDo2GZ+G5WSb4OdKUGovFWpdHbmOk/rAO8oWjo4MApdwxQve0m7LeCC4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743233565; c=relaxed/simple;
	bh=SYhyciRCD6HcPvOs+YyIrEknhUE8pAVUbbxH0T6fJcg=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=bWwmiousiRyPix32E+UFjXI1avX1OxwyiefkosuEkahd3fRPNs0NaBTvFNlVEXiJMZwTSp0F4+P5cZNh0FVl/ibtyZeNojfuIertG+FTmJG3RhR2xaHJj1t1dkbc4MRA/BotQ/TvaAqujFCXC/v0sFjkKarV6Jz2pK/2etaCa6g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.190
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.163.44])
	by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4ZPptV0YPkz2CdRQ;
	Sat, 29 Mar 2025 15:29:22 +0800 (CST)
Received: from dggpemf100013.china.huawei.com (unknown [7.185.36.179])
	by mail.maildlp.com (Postfix) with ESMTPS id 5A4A214010D;
	Sat, 29 Mar 2025 15:32:40 +0800 (CST)
Received: from localhost.huawei.com (10.50.165.33) by
 dggpemf100013.china.huawei.com (7.185.36.179) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Sat, 29 Mar 2025 15:32:40 +0800
From: Yihang Li <liyihang9@huawei.com>
To: <martin.petersen@oracle.com>, <James.Bottomley@HansenPartnership.com>
CC: <linux-scsi@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<linuxarm@huawei.com>, <liyihang9@huawei.com>, <liuyonglong@huawei.com>,
	<prime.zeng@hisilicon.com>
Subject: [PATCH 5/5] scsi: hisi_sas: Wait until eh is recovered
Date: Sat, 29 Mar 2025 15:32:36 +0800
Message-ID: <20250329073236.2300582-6-liyihang9@huawei.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20250329073236.2300582-1-liyihang9@huawei.com>
References: <20250329073236.2300582-1-liyihang9@huawei.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
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
index c3cbeb556440..97ff48e7fe5d 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
@@ -5130,9 +5130,11 @@ static void hisi_sas_reset_prepare_v3_hw(struct pci_dev *pdev)
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

