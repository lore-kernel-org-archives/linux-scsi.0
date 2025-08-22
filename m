Received: from szxga03-in.huawei.com (szxga03-in.huawei.com [45.249.212.189])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 871FD2EA48B;
	Fri, 22 Aug 2025 07:59:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.189
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755849599; cv=none; b=Yxgk8tnrkV+CJtvqahFi3eNbC14rKhq8xqXoil4kUt5DGhF/6yMKcmAqRS7ztqiNAR8h61rKScNy6OtM55I4/9prTpPtoytKaHiNdFV3tYWbkEmIBlO80c6zTcJMVrQhf8yPirnzAp9O1a6U/unpaEI5k5ZA69iBK6XLfylvZ2s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755849599; c=relaxed/simple;
	bh=nsZJ2eg5NO/9LP5H5mGlr9Mh6ZEFV6Uo7z/Dvs2ySYU=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ttNKCDaMlBLgAnom1gxz679plqLog14P8+cKYNpYY/zuBrNy/JfXj2XEzXfeGh6I6RhOLNTKaiOMgaOfmtg8P3T7Wlin+9shn3bg5m5XcUSHF9Y8m6FBckXcbP1c7A4wHPSNQBnhIUjaiV0YZu3AiV0y0VX4e3w7xXdqil/cbFo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=h-partners.com; spf=pass smtp.mailfrom=h-partners.com; arc=none smtp.client-ip=45.249.212.189
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=h-partners.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=h-partners.com
Received: from mail.maildlp.com (unknown [172.19.163.174])
	by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4c7XYG1BkWzdcKP;
	Fri, 22 Aug 2025 15:55:30 +0800 (CST)
Received: from kwepemh200005.china.huawei.com (unknown [7.202.181.112])
	by mail.maildlp.com (Postfix) with ESMTPS id 014F71400CD;
	Fri, 22 Aug 2025 15:59:54 +0800 (CST)
Received: from localhost.localdomain (10.50.165.33) by
 kwepemh200005.china.huawei.com (7.202.181.112) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Fri, 22 Aug 2025 15:59:53 +0800
From: Yihang Li <liyihang9@h-partners.com>
To: <martin.petersen@oracle.com>, <James.Bottomley@HansenPartnership.com>
CC: <linux-scsi@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<linuxarm@huawei.com>, <liyihang9@huawei.com>, <liuyonglong@huawei.com>,
	<prime.zeng@hisilicon.com>
Subject: [PATCH 4/4] scsi: hisi_sas: Remove unused hisi_sas_sync_poll_cqs()
Date: Fri, 22 Aug 2025 15:59:51 +0800
Message-ID: <20250822075951.2051639-5-liyihang9@h-partners.com>
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

hisi_sas_sync_poll_cqs() is no longer used anywhere, so remove it.

Signed-off-by: Yihang Li <liyihang9@h-partners.com>
---
 drivers/scsi/hisi_sas/hisi_sas_main.c | 13 -------------
 1 file changed, 13 deletions(-)

diff --git a/drivers/scsi/hisi_sas/hisi_sas_main.c b/drivers/scsi/hisi_sas/hisi_sas_main.c
index cd24b7d4ef0f..4296fa45da22 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_main.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_main.c
@@ -751,19 +751,6 @@ static void hisi_sas_sync_cq(struct hisi_sas_cq *cq)
 		tasklet_kill(&cq->tasklet);
 }
 
-void hisi_sas_sync_poll_cqs(struct hisi_hba *hisi_hba)
-{
-	int i;
-
-	for (i = 0; i < hisi_hba->queue_count; i++) {
-		struct hisi_sas_cq *cq = &hisi_hba->cq[i];
-
-		if (hisi_sas_queue_is_poll(cq))
-			hisi_sas_sync_poll_cq(cq);
-	}
-}
-EXPORT_SYMBOL_GPL(hisi_sas_sync_poll_cqs);
-
 void hisi_sas_sync_cqs(struct hisi_hba *hisi_hba)
 {
 	int i;
-- 
2.33.0

