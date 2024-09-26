Received: from szxga08-in.huawei.com (szxga08-in.huawei.com [45.249.212.255])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8BD017334E
	for <linux-scsi@vger.kernel.org>; Thu, 26 Sep 2024 01:43:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.255
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727315018; cv=none; b=GfoJEPjyOmy6UqAWj5LB5s5kpCuVlEoyzjti04lX8ufS1lYQXRU+GXGwe0GFsLwC138b1ARQgt4RUtH0WPoelv7HZa5bNan+CApYTdMT+8TFy5OJhvCAx6WBDz8qpyTcVwUJEadZHjtsg+X8pAu2RAf2ez72hAVT6TgwBZPAVbU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727315018; c=relaxed/simple;
	bh=mQDQwGEjnI6zhdlDT9Q/g8HZZGTCEn5ltEXJ1cv1JGs=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=L43Gi+sGi62cODhyTpel/GaqWuyxvo9NbAB4yVB56Wc17BzFFE+dkTLq9toO2ekkkk3TXViasEmyb8r5nZSLw4XyCkWpua+9RlXWYPr87dcqF6dPMHqJ+3D+Yx7nHgQToj1rRRLR05slyfgFwgjFms8Lsh+LT9Stdu4C8EgZmjQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.255
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.163.174])
	by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4XDbtl1pmQz1T7wp;
	Thu, 26 Sep 2024 09:42:07 +0800 (CST)
Received: from dggpemf100013.china.huawei.com (unknown [7.185.36.179])
	by mail.maildlp.com (Postfix) with ESMTPS id 10CD814037E;
	Thu, 26 Sep 2024 09:43:33 +0800 (CST)
Received: from localhost.huawei.com (10.50.165.33) by
 dggpemf100013.china.huawei.com (7.185.36.179) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Thu, 26 Sep 2024 09:43:32 +0800
From: Yihang Li <liyihang9@huawei.com>
To: <James.Bottomley@HansenPartnership.com>, <martin.petersen@oracle.com>
CC: <linux-scsi@vger.kernel.org>, <linuxarm@huawei.com>,
	<liyihang9@huawei.com>
Subject: [PATCH 00/13] scsi: hisi_sas: Some fixes for hisi_sas
Date: Thu, 26 Sep 2024 09:43:19 +0800
Message-ID: <20240926014332.3905399-1-liyihang9@huawei.com>
X-Mailer: git-send-email 2.33.0
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
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
 drivers/scsi/hisi_sas/hisi_sas_main.c  |  33 ++++-
 drivers/scsi/hisi_sas/hisi_sas_v1_hw.c |  18 +++
 drivers/scsi/hisi_sas/hisi_sas_v2_hw.c |  18 +++
 drivers/scsi/hisi_sas/hisi_sas_v3_hw.c | 187 ++++++++++++++++++-------
 5 files changed, 206 insertions(+), 51 deletions(-)

-- 
2.33.0

