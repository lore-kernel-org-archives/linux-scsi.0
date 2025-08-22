Received: from szxga06-in.huawei.com (szxga06-in.huawei.com [45.249.212.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29EFA2E8E17;
	Fri, 22 Aug 2025 07:59:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755849598; cv=none; b=CJIy6g2W9U2yob8DjZaJb+c9fbCPB6B8LGQRcTl8GVZ2HMU49x7XqJvs/afTprD0A5/XPkH6rdO6bTP0SLtnURVDfBYlYmagEQ8iW7/dL9O1So00Zx2vRj+ziy+BhsW0JuCM7uXJGh15oa3Vq34Dze0rGgKTI0fcM3TotHmOWgU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755849598; c=relaxed/simple;
	bh=2mNK/G+UdmLd/wUnzViK9h4iThwB6qlPneYAKY4e6CY=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=UwJ/O7UsF6ZHGxXyqMxf0Ox6/JrJovNRchdNY3bOw5KzA3HgBoMgwYmV0vi8wf3LgKfxSo78J8g95Smu2XqUpi6p14wB0VD2cxr55uPMissUzqf6O2ZSYzZsQJIEJ76N1K/JyGNlrZk5RzaGuo8Eb4nU7ZM1MMycXqD7uYnosWI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=h-partners.com; spf=pass smtp.mailfrom=h-partners.com; arc=none smtp.client-ip=45.249.212.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=h-partners.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=h-partners.com
Received: from mail.maildlp.com (unknown [172.19.163.17])
	by szxga06-in.huawei.com (SkyGuard) with ESMTP id 4c7Xgb2KRvz27jGV;
	Fri, 22 Aug 2025 16:00:59 +0800 (CST)
Received: from kwepemh200005.china.huawei.com (unknown [7.202.181.112])
	by mail.maildlp.com (Postfix) with ESMTPS id 9657F1A0188;
	Fri, 22 Aug 2025 15:59:53 +0800 (CST)
Received: from localhost.localdomain (10.50.165.33) by
 kwepemh200005.china.huawei.com (7.202.181.112) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Fri, 22 Aug 2025 15:59:53 +0800
From: Yihang Li <liyihang9@h-partners.com>
To: <martin.petersen@oracle.com>, <James.Bottomley@HansenPartnership.com>
CC: <linux-scsi@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<linuxarm@huawei.com>, <liyihang9@huawei.com>, <liuyonglong@huawei.com>,
	<prime.zeng@hisilicon.com>
Subject: [PATCH 3/4] scsi: hisi_sas: Remove cond_resched() in bottom half of interrupt
Date: Fri, 22 Aug 2025 15:59:50 +0800
Message-ID: <20250822075951.2051639-4-liyihang9@h-partners.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20250822075951.2051639-1-liyihang9@h-partners.com>
References: <20250822075951.2051639-1-liyihang9@h-partners.com>
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

After changing threaded irq to tasklet, the tasklet function executes in
the soft interrupt context, and soft interrupt handlers cannot sleep or
be scheduled. Therefore, remove cond_resched() in complete_v3_hw().

Signed-off-by: Yihang Li <liyihang9@h-partners.com>
---
 drivers/scsi/hisi_sas/hisi_sas_v3_hw.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c b/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
index 967cf5181fed..58bdff8b3665 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
@@ -2553,7 +2553,6 @@ static int complete_v3_hw(struct hisi_sas_cq *cq)
 	/* update rd_point */
 	cq->rd_point = rd_point;
 	hisi_sas_write32(hisi_hba, COMPL_Q_0_RD_PTR + (0x14 * queue), rd_point);
-	cond_resched();
 
 	return completed;
 }
-- 
2.33.0

