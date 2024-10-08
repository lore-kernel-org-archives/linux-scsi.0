Received: from szxga04-in.huawei.com (szxga04-in.huawei.com [45.249.212.190])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E33B1E535
	for <linux-scsi@vger.kernel.org>; Tue,  8 Oct 2024 02:18:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.190
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728353913; cv=none; b=DSl0IADzww7H43O0LqkbERHOM9rOymrxY7KT5NqbnaLRPqzRfeLwNq1xVzqd9fTdjyb1/ObbJ74VQ6qNtdAPlphB3+N090/qxwV8NVAhUvx4mXiAiRGPFvUJvYQ2OdDdZsXfymdpuXRPTFmhO0xHBPWbxr49tyBAAvXpPKOGFNU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728353913; c=relaxed/simple;
	bh=+x28lV6zXLgjm1NVDr/xALVIX3TlEg5+jJhbV9CCNDE=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=tdi3lZtXJGC0IFGemJjbEX4qNEWr9vlqmtoz2kGUc86woZo9LcP0DT3alaDv5RZuk7xqTz02isWQ8PRJ+zYYSJ2p6jdDfPjuu0dvr0VH5E0ZLKEdE98Z4ZfTiGKrKntR0tsq2suAlZbo6oWcfCMdnGpQo2I7FTqSuqhsjpEAtes=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.190
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.163.44])
	by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4XN05w0NQPz2Dd6X;
	Tue,  8 Oct 2024 10:17:24 +0800 (CST)
Received: from dggpemf100013.china.huawei.com (unknown [7.185.36.179])
	by mail.maildlp.com (Postfix) with ESMTPS id 93ED91401F1;
	Tue,  8 Oct 2024 10:18:27 +0800 (CST)
Received: from localhost.huawei.com (10.50.165.33) by
 dggpemf100013.china.huawei.com (7.185.36.179) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Tue, 8 Oct 2024 10:18:27 +0800
From: Yihang Li <liyihang9@huawei.com>
To: <James.Bottomley@HansenPartnership.com>, <martin.petersen@oracle.com>
CC: <linux-scsi@vger.kernel.org>, <linuxarm@huawei.com>,
	<liyihang9@huawei.com>
Subject: [PATCH v2 00/13] scsi: hisi_sas: Some fixes for hisi_sas
Date: Tue, 8 Oct 2024 10:18:09 +0800
Message-ID: <20241008021822.2617339-1-liyihang9@huawei.com>
X-Mailer: git-send-email 2.33.0
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

This series contains some fixes including:
- Adjust priority of registering and exiting debugfs for security;
- Create trigger_dump at the end of the debugfs initialization;
- Add firmware information check;
- Enable all PHYs that are not disabled by user during controller reset;
- Reset PHY again if phyup timeout;
- Check usage count only when the runtime PM status is RPM_SUSPENDING;
- Add cond_resched() for no forced preemption model;
- Default enable interrupt coalescing;
- Update disk locked timeout to 7 seconds;
- Add time interval between two H2D FIS following soft reset spec;
- Update v3 hw STP_LINK_TIMER setting;
- Create all dump files during debugfs initialization;
- Add latest_dump for the debugfs dump;

Changes since v1:
- Use goto instead of return to fix the build error in patch 3.

Xingui Yang (3):
  scsi: hisi_sas: Update disk locked timeout to 7 seconds
  scsi: hisi_sas: Add time interval between two H2D FIS following soft
    reset spec
  scsi: hisi_sas: Update v3 hw STP_LINK_TIMER setting

Yihang Li (10):
  scsi: hisi_sas: Adjust priority of registering and exiting debugfs for
    security
  scsi: hisi_sas: Create trigger_dump at the end of the debugfs
    initialization
  scsi: hisi_sas: Add firmware information check
  scsi: hisi_sas: Enable all PHYs that are not disabled by user during
    controller reset
  scsi: hisi_sas: Reset PHY again if phyup timeout
  scsi: hisi_sas: Check usage count only when the runtime PM status is
    RPM_SUSPENDING
  scsi: hisi_sas: Add cond_resched() for no forced preemption model
  scsi: hisi_sas: Default enable interrupt coalescing
  scsi: hisi_sas: Create all dump files during debugfs initialization
  scsi: hisi_sas: Add latest_dump for the debugfs dump

 drivers/scsi/hisi_sas/hisi_sas.h       |   1 +
 drivers/scsi/hisi_sas/hisi_sas_main.c  |  31 +++-
 drivers/scsi/hisi_sas/hisi_sas_v1_hw.c |  18 +++
 drivers/scsi/hisi_sas/hisi_sas_v2_hw.c |  18 +++
 drivers/scsi/hisi_sas/hisi_sas_v3_hw.c | 187 ++++++++++++++++++-------
 5 files changed, 204 insertions(+), 51 deletions(-)

-- 
2.33.0

