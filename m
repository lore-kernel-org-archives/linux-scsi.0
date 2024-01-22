Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE5886AA1
	for <linux-scsi@vger.kernel.org>; Mon, 22 Jan 2024 06:20:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.187
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705904456; cv=none; b=bda/Fcz7K2Bvvs41JAuzjGzdYZ/fVDb+zo//5+exPMIxufUd3AF860/13CWiVTqnEfZOon/vJe8g/3Fnnzw4GXHi/wIqFof4GS8An33gZhFHsiIxIApKXx1mqadfZ780Ehr2E/Xf+NuB7YlOzUmiaDlza8rJ+wkcaid43PoKTdw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705904456; c=relaxed/simple;
	bh=e+0gWEk8dR5e73nsFAMg4bSczbFQfuQH2kMfZkhd0mY=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=fRgD/CqUQiPJWdBE8s42KtMNSGgdAhzdhs/DQkXGPv2MuZyKNnFqFrPGrTDmfc24Tlvmavd0mmrOcr1vOQbZQVCYGSIw6+7AagCZot7lE66BrjbwUU0t+jx7hFkJ990cf4POp6IMHRiubA9sT2QlblhPtHE4gdiuQROiBYJ73KY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=hisilicon.com; spf=pass smtp.mailfrom=hisilicon.com; arc=none smtp.client-ip=45.249.212.187
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=hisilicon.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=hisilicon.com
Received: from mail.maildlp.com (unknown [172.19.163.48])
	by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4TJKn34ghJzvVCy;
	Mon, 22 Jan 2024 14:19:19 +0800 (CST)
Received: from kwepemi500025.china.huawei.com (unknown [7.221.188.170])
	by mail.maildlp.com (Postfix) with ESMTPS id 83CF6180076;
	Mon, 22 Jan 2024 14:20:49 +0800 (CST)
Received: from localhost.localdomain (10.69.192.58) by
 kwepemi500025.china.huawei.com (7.221.188.170) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Mon, 22 Jan 2024 14:20:49 +0800
From: chenxiang <chenxiang66@hisilicon.com>
To: <jejb@linux.ibm.com>, <martin.petersen@oracle.com>
CC: <linux-scsi@vger.kernel.org>, <linuxarm@huawei.com>, Xiang Chen
	<chenxiang66@hisilicon.com>
Subject: [PATCH 0/4] scsi: hisi_sas: Minor fixes and cleanups
Date: Mon, 22 Jan 2024 14:25:43 +0800
Message-ID: <1705904747-62186-1-git-send-email-chenxiang66@hisilicon.com>
X-Mailer: git-send-email 2.8.1
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

This series contains some fixes and cleanups including:
- Fix a deadlock issue related to automatic debugfs;
- Remove redundant checks for automatic debugfs;
- Check whether debugfs is enabled before removing or releasing it;
- Remove hisi_hba->timer for v3 hw;

Xiang Chen (1):
  scsi: hisi_sas: Remove hisi_hba->timer for v3 hw

Yihang Li (3):
  scsi: hisi_sas: Fix a deadlock issue related to automatic dump
  scsi: hisi_sas: Remove redundant checks for automatic debugfs dump
  scsi: hisi_sas: Check whether debugfs is enabled before removing or
    releasing it

 drivers/scsi/hisi_sas/hisi_sas_main.c  | 26 ++++++++++++++++++++------
 drivers/scsi/hisi_sas/hisi_sas_v3_hw.c |  8 +++++---
 2 files changed, 25 insertions(+), 9 deletions(-)

-- 
2.8.1

