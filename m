Received: from szxga05-in.huawei.com (szxga05-in.huawei.com [45.249.212.191])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B44DE748E
	for <linux-scsi@vger.kernel.org>; Mon,  1 Apr 2024 05:53:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.191
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711950826; cv=none; b=V4mx22J2ccZp43NG/GGLIGDnSZrc83IdlquNzKjJnkFwZvlYu6JXsTQTvY7YKWLhtFMgvoyLs66dtEPoOqPE0rnXD8JJduqu6I3SxqBmOvmDom+u+H8qfxabAPtrXb5JugUI/jhEHck/nMoss1Bmbz0YE3j1z9+F/BcTzfTgxLA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711950826; c=relaxed/simple;
	bh=T8pf6gGuyqrmTnoMKvkn50jXsjChxY9j7mKVYCqq9tc=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=M/rjJbDuGwRKzMKr8xVDGSMU8smTyOfFSfoYw31DcwgmKm9b+m5HwcUhTvD8NrbgnwyoyQld4y0z30pncDjNuxTri+kVASjbEig/kSrpW8kjPhDq3mmyDdQebX1KdGPft25n2pRuBzJ9LJLFcimNHSCpUqjJ8qe3xVtv64zunQE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=hisilicon.com; spf=pass smtp.mailfrom=hisilicon.com; arc=none smtp.client-ip=45.249.212.191
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=hisilicon.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=hisilicon.com
Received: from mail.maildlp.com (unknown [172.19.163.17])
	by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4V7KtQ5VZSz1GFHS;
	Mon,  1 Apr 2024 13:53:02 +0800 (CST)
Received: from kwepemd200015.china.huawei.com (unknown [7.221.188.21])
	by mail.maildlp.com (Postfix) with ESMTPS id D25611A0172;
	Mon,  1 Apr 2024 13:53:38 +0800 (CST)
Received: from huawei.com (10.67.165.2) by kwepemd200015.china.huawei.com
 (7.221.188.21) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1258.28; Mon, 1 Apr
 2024 13:53:38 +0800
From: chenxiang <chenxiang66@hisilicon.com>
To: <jejb@linux.vnet.ibm.com>, <martin.petersen@oracle.com>
CC: <linuxarm@huawei.com>, <linux-scsi@vger.kernel.org>
Subject: [PATCH 0/2] Some small fixes for hisi_sas
Date: Mon, 1 Apr 2024 13:49:12 +0800
Message-ID: <20240401054914.721093-1-chenxiang66@hisilicon.com>
X-Mailer: git-send-email 2.30.0
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
 kwepemd200015.china.huawei.com (7.221.188.21)

From: Xiang Chen <chenxiang66@hisilicon.com>

This series contain two small fixes including:
- Handle the NCQ error returned by D2H frame;
- Correct the deadline value for ata_wait_after_reset() in
function hisi_sas_debug_I_T_nexus_reset;

Xingui Yang (1):
  scsi: hisi_sas: Handle the NCQ error returned by D2H frame

Yihang Li (1):
  scsi: hisi_sas: Modify the deadline for ata_wait_after_reset()

 drivers/scsi/hisi_sas/hisi_sas_main.c  | 4 +++-
 drivers/scsi/hisi_sas/hisi_sas_v3_hw.c | 9 ++++++++-
 2 files changed, 11 insertions(+), 2 deletions(-)

-- 
2.30.0

