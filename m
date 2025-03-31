Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E99A1E1A05;
	Mon, 31 Mar 2025 12:33:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.187
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743424436; cv=none; b=LFsuirM0j6r6STb822oZwt3ZMvQGKQW08tLX/gH7uq7+cq0UrZmYxCA42sXC3z0blE6AVMhlAzZX97vm/3kBB7QZAx5tqPluAygf73kZarIgQTyrS0OCGM1JlYm35X3ksCI9pljDEDV+07gDRqm06KSwOnmewkh2O87aVSSjbfo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743424436; c=relaxed/simple;
	bh=TzFDk89sh3Ab5/ZS5nBqoqnZsPTHScRKBGCqXbZqCSs=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=OA9BqGAHpsBCYvpv7ScS7L6wjNqWUnUZh8sMMvGYkkLNtiBEacCj9gm56BTixtqKgVLdAzfzI205tt/5E0tAfY/9u5hdHkePPLSXNidxA7abzg0vyeBikxXCkSATO04fiMHy7Eq+om/LZvsAD8ekky7DMZft2VumdpGCteSDXog=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.187
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.163.252])
	by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4ZR9XK3qpmz13LBY;
	Mon, 31 Mar 2025 20:33:21 +0800 (CST)
Received: from dggpemf100013.china.huawei.com (unknown [7.185.36.179])
	by mail.maildlp.com (Postfix) with ESMTPS id E213E1800E2;
	Mon, 31 Mar 2025 20:33:50 +0800 (CST)
Received: from localhost.huawei.com (10.50.165.33) by
 dggpemf100013.china.huawei.com (7.185.36.179) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Mon, 31 Mar 2025 20:33:50 +0800
From: Yihang Li <liyihang9@huawei.com>
To: <martin.petersen@oracle.com>, <James.Bottomley@HansenPartnership.com>
CC: <linux-scsi@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<linuxarm@huawei.com>, <liyihang9@huawei.com>, <liuyonglong@huawei.com>,
	<prime.zeng@hisilicon.com>
Subject: [PATCH v2 0/4] hisi_sas: Misc patches and cleanups
Date: Mon, 31 Mar 2025 20:33:45 +0800
Message-ID: <20250331123349.99591-1-liyihang9@huawei.com>
X-Mailer: git-send-email 2.33.0
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

This series contains some minor bugfix and general tidying:
- Ignore the soft reset result by calling I_T_nexus after the SATA disk
  is soft reset
- General minor tidying

Thanks!

Changes since v1:
- Remove patch 1 and come up with a better solution to fix the issue:
  https://lore.kernel.org/linux-block/eef1e927-c9b2-c61d-7f48-92e65d8b0418@huawei.com/
  maybe in libsas or libata.

Yihang Li (4):
  scsi: hisi_sas: Use macro instead of magic number
  scsi: hisi_sas: Code style cleanup
  scsi: hisi_sas: Call I_T_nexus after soft reset for SATA disk
  scsi: hisi_sas: Wait until eh is recovered

 drivers/scsi/hisi_sas/hisi_sas.h       |  50 +++--
 drivers/scsi/hisi_sas/hisi_sas_main.c  |  81 ++++----
 drivers/scsi/hisi_sas/hisi_sas_v1_hw.c |   2 +-
 drivers/scsi/hisi_sas/hisi_sas_v2_hw.c |   6 +-
 drivers/scsi/hisi_sas/hisi_sas_v3_hw.c | 253 +++++++++++++++----------
 5 files changed, 229 insertions(+), 163 deletions(-)

-- 
2.33.0

