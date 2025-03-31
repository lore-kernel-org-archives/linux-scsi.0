Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C7291DF973;
	Mon, 31 Mar 2025 12:33:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.188
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743424436; cv=none; b=FF85t49H8SpvB2PDjxcaz9VAYvD5E9vzWeos8r5W1xeqzV6QPLgz1uvBVqb3giTij3mchrvTcvlsdvZRqlS2cu/+N1XD+aDNme/dnsj8C9K/qmL3OkJPAib6UhAA143EGdkoKRlRYoLeMWC34RIyYPsLtFjdMtw+6JdOxy8LzTs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743424436; c=relaxed/simple;
	bh=SYhyciRCD6HcPvOs+YyIrEknhUE8pAVUbbxH0T6fJcg=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=MZNJ/vkXHeVK8PfZKwxipHAcp3ALaROjO60IBETM7hnhqEs5Jzv0lndE7lcjchpqWb/hq24RnBVkd8UiB2hrNKpsAZ+HZ4UE3y1IWzNc+mcWNsjHli4nFyyEUhIIKdmayvfHRjOmeZgk8RqQWStEue4nJnVcYATiH7N7n7b0nRc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.188
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.163.48])
	by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4ZR9Sf2YXMzWfp0;
	Mon, 31 Mar 2025 20:30:10 +0800 (CST)
Received: from dggpemf100013.china.huawei.com (unknown [7.185.36.179])
	by mail.maildlp.com (Postfix) with ESMTPS id 910761800B1;
	Mon, 31 Mar 2025 20:33:51 +0800 (CST)
Received: from localhost.huawei.com (10.50.165.33) by
 dggpemf100013.china.huawei.com (7.185.36.179) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Mon, 31 Mar 2025 20:33:51 +0800
From: Yihang Li <liyihang9@huawei.com>
To: <martin.petersen@oracle.com>, <James.Bottomley@HansenPartnership.com>
CC: <linux-scsi@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<linuxarm@huawei.com>, <liyihang9@huawei.com>, <liuyonglong@huawei.com>,
	<prime.zeng@hisilicon.com>
Subject: [PATCH v2 4/4] scsi: hisi_sas: Wait until eh is recovered
Date: Mon, 31 Mar 2025 20:33:49 +0800
Message-ID: <20250331123349.99591-5-liyihang9@huawei.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20250331123349.99591-1-liyihang9@huawei.com>
References: <20250331123349.99591-1-liyihang9@huawei.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
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

