Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6FEAA238C1A;
	Fri, 22 Aug 2025 07:59:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.187
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755849598; cv=none; b=aPLHKM4dlrcwGRUJP6z6DuNsLGG4GilALArm8XqHrypCtcJZPt29m8wQcUV+0ZRDeKva3FRYeIJ40y6tXwlg3t42NBSLJF/YLyiUTAEMCL6g2Qlp6QaGqGmmKZZQXAL2rtD78mJfI0QvXtW1ynfeLekAzIYvIm1n6HkC5mfBLxE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755849598; c=relaxed/simple;
	bh=r40f9NvojQ0Gxr2Dzg9s3w+6lHh7GzvMlj1NRQs5Njs=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=bBBgV3afyu0uNrkq92DNwxBBpQpy2EYmRQW6SRcJ/w6ysuI7PfKDn8k5sYWUJ1ulknc1sPr+BrtKxvigeKtfiQ/BYrull/9bFf+LavMKQ5B6Mzwjg8lhNTVB0v9PgGhhaEAy58u4rNjVWxpv32qiS29snwV0RCIQMJw9KlOIX/Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=h-partners.com; spf=pass smtp.mailfrom=h-partners.com; arc=none smtp.client-ip=45.249.212.187
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=h-partners.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=h-partners.com
Received: from mail.maildlp.com (unknown [172.19.163.48])
	by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4c7XZ85MgKz13MlR;
	Fri, 22 Aug 2025 15:56:16 +0800 (CST)
Received: from kwepemh200005.china.huawei.com (unknown [7.202.181.112])
	by mail.maildlp.com (Postfix) with ESMTPS id 762811800B1;
	Fri, 22 Aug 2025 15:59:52 +0800 (CST)
Received: from localhost.localdomain (10.50.165.33) by
 kwepemh200005.china.huawei.com (7.202.181.112) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Fri, 22 Aug 2025 15:59:51 +0800
From: Yihang Li <liyihang9@h-partners.com>
To: <martin.petersen@oracle.com>, <James.Bottomley@HansenPartnership.com>
CC: <linux-scsi@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<linuxarm@huawei.com>, <liyihang9@huawei.com>, <liuyonglong@huawei.com>,
	<prime.zeng@hisilicon.com>
Subject: [PATCH 0/4] scsi: hisi_sas: Switch to use tasklet over threaded irq handling
Date: Fri, 22 Aug 2025 15:59:47 +0800
Message-ID: <20250822075951.2051639-1-liyihang9@h-partners.com>
X-Mailer: git-send-email 2.33.0
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: kwepems200001.china.huawei.com (7.221.188.67) To
 kwepemh200005.china.huawei.com (7.202.181.112)

We found that when the CPU handling the interrupt thread is occupied by
other high-priority processes, the interrupt thread will not be scheduled.
So there is a change to switch the driver to use tasklet over threaded
interrupt handling.

Yihang Li (4):
  scsi: hisi_sas: Use tasklet to process CQ interrupts
  scsi: hisi_sas: replace spin_lock/spin_unlock with
    spin_lock_irqsave/spin_unlock_restore
  scsi: hisi_sas: Remove cond_resched() in bottom half of interrupt
  scsi: hisi_sas: Remove unused hisi_sas_sync_poll_cqs()

 drivers/scsi/hisi_sas/hisi_sas.h       |  2 +-
 drivers/scsi/hisi_sas/hisi_sas_main.c  | 76 ++++++++++++--------------
 drivers/scsi/hisi_sas/hisi_sas_v2_hw.c | 48 ++++++++++------
 drivers/scsi/hisi_sas/hisi_sas_v3_hw.c | 43 ++++++++-------
 4 files changed, 89 insertions(+), 80 deletions(-)

-- 
2.33.0

