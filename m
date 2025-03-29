Received: from szxga08-in.huawei.com (szxga08-in.huawei.com [45.249.212.255])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2F87208D0;
	Sat, 29 Mar 2025 07:32:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.255
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743233562; cv=none; b=YyoUawvSLleDwujaTdMcua8LbtIN31IeDXbIFlyWGNtNO5g4iW6aaKkJS2EzIVvmGGDUqXQmNHwaiRB9Bh+jXGi8qp02kFJzTSMcZ6sVEu5MHifU91IqrDHJAIZ5ZTeElDfeEgPdCYeYmXC5tZrFGJDuFR2I3c/IRWaIIoZUKeA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743233562; c=relaxed/simple;
	bh=zl50PSAP+Yh901QF+MwN7P4o1BCnhPRvAAdmTF4TlG0=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=Ae3LFrcfnr6zLw0ukSYMC+LILDOy2slp5M1J9lUiEfP+Szt7bPW90URWsKMncPbkd25+/7yHHAxUqlBqwMux8TebpKPS7EuEAPTYILYkcPQrnx8GEc/ABcNdQKulVpQtNsagouAwILPKQxhSYz7bqa8oWkcijVstdhr/ikYjE/U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.255
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.162.254])
	by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4ZPpxk2XYQz1d0tV;
	Sat, 29 Mar 2025 15:32:10 +0800 (CST)
Received: from dggpemf100013.china.huawei.com (unknown [7.185.36.179])
	by mail.maildlp.com (Postfix) with ESMTPS id B359E18010B;
	Sat, 29 Mar 2025 15:32:36 +0800 (CST)
Received: from localhost.huawei.com (10.50.165.33) by
 dggpemf100013.china.huawei.com (7.185.36.179) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Sat, 29 Mar 2025 15:32:36 +0800
From: Yihang Li <liyihang9@huawei.com>
To: <martin.petersen@oracle.com>, <James.Bottomley@HansenPartnership.com>
CC: <linux-scsi@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<linuxarm@huawei.com>, <liyihang9@huawei.com>, <liuyonglong@huawei.com>,
	<prime.zeng@hisilicon.com>
Subject: [PATCH 0/5] hisi_sas: Misc patches and cleanups
Date: Sat, 29 Mar 2025 15:32:31 +0800
Message-ID: <20250329073236.2300582-1-liyihang9@huawei.com>
X-Mailer: git-send-email 2.33.0
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

This series contains some minor bugfix and general tidying:
- Add host_tagset_enable module param for v3 hw to show only one queue
  capability to the kernel
- Ignore the soft reset result by calling I_T_nexus after the SATA disk
  is soft reset
- General minor tidying

Thanks!

Xingui Yang (1):
  scsi: hisi_sas: Add host_tagset_enable module param for v3 hw

Yihang Li (4):
  scsi: hisi_sas: Use macro instead of magic number
  scsi: hisi_sas: Code style cleanup
  scsi: hisi_sas: Call I_T_nexus after soft reset for SATA disk
  scsi: hisi_sas: Wait until eh is recovered

 drivers/scsi/hisi_sas/hisi_sas.h       |  51 +++--
 drivers/scsi/hisi_sas/hisi_sas_main.c  |  91 ++++----
 drivers/scsi/hisi_sas/hisi_sas_v1_hw.c |   2 +-
 drivers/scsi/hisi_sas/hisi_sas_v2_hw.c |   6 +-
 drivers/scsi/hisi_sas/hisi_sas_v3_hw.c | 283 ++++++++++++++++---------
 5 files changed, 264 insertions(+), 169 deletions(-)

-- 
2.33.0

