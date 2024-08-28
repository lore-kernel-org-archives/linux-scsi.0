Received: from szxga05-in.huawei.com (szxga05-in.huawei.com [45.249.212.191])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED55886250;
	Wed, 28 Aug 2024 10:27:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.191
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724840835; cv=none; b=Ggpf2L2h0O7/QZVRwUgp9CnBDvWS8opo2K1PyID4WPPvuF+d0syKIrtkaHZoCLJcRfrskiVT3q0Ni0DwGYWZO9q/YWvo6QVbOhWGhG1QUP+uL4U/1lqjg4LlcM1I206nIMiSsJ9JXh/vNdO0P72kek5sn8hEUT2jx+eX9v48aPM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724840835; c=relaxed/simple;
	bh=RWr9+h0rvHq0GKm8IUgq023hhxbkVtf+MlTrlE28Ho4=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=tHSUylsMvrBcKMI8Pdrw+1IzMgmDoDLF6wszpc07GSKmnVdP+lTvT0n62qqPkrgdTp2N6sTho9SNSSP2QKoHV685RyhTN2WyNqUOO1ejD/IyVLHwDs9RkkWu56ErXLQW+oivYkJMO0ZqvxBndOheEXsdY9sL8VKg+MzG5bKacOQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.191
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.162.112])
	by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4Wv0r4297qz1HFth;
	Wed, 28 Aug 2024 18:23:48 +0800 (CST)
Received: from kwepemh500013.china.huawei.com (unknown [7.202.181.146])
	by mail.maildlp.com (Postfix) with ESMTPS id 0D1A214013B;
	Wed, 28 Aug 2024 18:27:08 +0800 (CST)
Received: from huawei.com (10.90.53.73) by kwepemh500013.china.huawei.com
 (7.202.181.146) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Wed, 28 Aug
 2024 18:27:07 +0800
From: Jinjie Ruan <ruanjinjie@huawei.com>
To: <kashyap.desai@broadcom.com>, <sumit.saxena@broadcom.com>,
	<shivasharan.srikanteshwara@broadcom.com>, <chandrakanth.patil@broadcom.com>,
	<James.Bottomley@HansenPartnership.com>, <martin.petersen@oracle.com>,
	<megaraidlinux.pdl@broadcom.com>, <linux-scsi@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>
CC: <ruanjinjie@huawei.com>
Subject: [PATCH] scsi: megaraid: Use PCI_DEVID() macro to simplify the code
Date: Wed, 28 Aug 2024 18:35:07 +0800
Message-ID: <20240828103507.3680658-1-ruanjinjie@huawei.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
 kwepemh500013.china.huawei.com (7.202.181.146)

The macro PCI_DEVID() can be used instead of compose it manually.

Signed-off-by: Jinjie Ruan <ruanjinjie@huawei.com>
---
 drivers/scsi/megaraid/megaraid_mbox.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/megaraid/megaraid_mbox.c b/drivers/scsi/megaraid/megaraid_mbox.c
index bc867da650b6..92107a125aa2 100644
--- a/drivers/scsi/megaraid/megaraid_mbox.c
+++ b/drivers/scsi/megaraid/megaraid_mbox.c
@@ -3730,7 +3730,7 @@ gather_hbainfo(adapter_t *adapter, mraid_hba_info_t *hinfo)
 	hinfo->irq		= adapter->host->irq;
 	hinfo->baseport		= ADAP2RAIDDEV(adapter)->baseport;
 
-	hinfo->unique_id	= (hinfo->pci_bus << 8) | adapter->pdev->devfn;
+	hinfo->unique_id	= PCI_DEVID(hinfo->pci_bus, adapter->pdev->devfn);
 	hinfo->host_no		= adapter->host->host_no;
 
 	return 0;
-- 
2.34.1

