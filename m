Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8355715D5C4;
	Fri, 14 Mar 2025 01:10:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.187
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741914626; cv=none; b=Fw96Y4bP/PhnohVb+QcvvEjuXVW1Zc8KGj/ByCmWAM8b/fVbz5TRsi902x+rw+x9w6uUYEwMX5witx+KNczueGumptAcavszTnZ7KSHd11fjJFkwnZcF+3vHTPFeXKC0j9EYRKTGSLrh71joDBpSoHJbze9xWUiaFZ9NQjUl1Fs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741914626; c=relaxed/simple;
	bh=WlDROKFimy2M3ERNPkejUxJFEzrcYWTkIFsDT4inJcA=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=eBb8FBbW+HxQLSIKebmWiF78eUcDBfRH10H3HVrMcJTMLbZ8u3kwhxcMdVv7tCmt6dCYvPJdPozQF+Il3DmpI2hpA0shX8621myODuONONoLGXt6aX0Dp/lDapVt1dGGdX/T7dlhhhgcw2Et85kgPm/gFUADaPo4hTbwM5+MYXw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.187
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.162.254])
	by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4ZDR5Y2tFJzvWqN;
	Fri, 14 Mar 2025 09:06:25 +0800 (CST)
Received: from dggpemf500016.china.huawei.com (unknown [7.185.36.197])
	by mail.maildlp.com (Postfix) with ESMTPS id B4828180102;
	Fri, 14 Mar 2025 09:10:16 +0800 (CST)
Received: from localhost.localdomain (10.175.101.6) by
 dggpemf500016.china.huawei.com (7.185.36.197) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Fri, 14 Mar 2025 09:10:16 +0800
From: JiangJianJun <jiangjianjun3@huawei.com>
To: <jejb@linux.ibm.com>, <martin.petersen@oracle.com>,
	<linux-scsi@vger.kernel.org>
CC: <hare@suse.de>, <linux-kernel@vger.kernel.org>, <lixiaokeng@huawei.com>,
	<jiangjianjun3@huawei.com>, <hewenliang4@huawei.com>,
	<yangkunlin7@huawei.com>
Subject: [RFC PATCH v3 09/19] scsi: core: increase/decrease target_busy without check can_queue
Date: Fri, 14 Mar 2025 09:29:17 +0800
Message-ID: <20250314012927.150860-10-jiangjianjun3@huawei.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20250314012927.150860-1-jiangjianjun3@huawei.com>
References: <20250314012927.150860-1-jiangjianjun3@huawei.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
 dggpemf500016.china.huawei.com (7.185.36.197)

From: Wenchao Hao <haowenchao2@huawei.com>

This is preparation for a genernal target based error handle strategy
to check if to wake up actual error handler.

Signed-off-by: Wenchao Hao <haowenchao2@huawei.com>
---
 drivers/scsi/scsi_lib.c | 11 ++++-------
 1 file changed, 4 insertions(+), 7 deletions(-)

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 8cdab7ac5980..e477c5d3c393 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -394,8 +394,7 @@ void scsi_device_unbusy(struct scsi_device *sdev, struct scsi_cmnd *cmd)
 
 	scsi_dec_host_busy(shost, cmd);
 
-	if (starget->can_queue > 0)
-		atomic_dec(&starget->target_busy);
+	atomic_dec(&starget->target_busy);
 
 	sbitmap_put(&sdev->budget_map, cmd->budget_token);
 	cmd->budget_token = -1;
@@ -1413,10 +1412,10 @@ static inline int scsi_target_queue_ready(struct Scsi_Host *shost,
 		spin_unlock_irq(shost->host_lock);
 	}
 
+	busy = atomic_inc_return(&starget->target_busy) - 1;
 	if (starget->can_queue <= 0)
 		return 1;
 
-	busy = atomic_inc_return(&starget->target_busy) - 1;
 	if (atomic_read(&starget->target_blocked) > 0) {
 		if (busy)
 			goto starved;
@@ -1441,8 +1440,7 @@ static inline int scsi_target_queue_ready(struct Scsi_Host *shost,
 	list_move_tail(&sdev->starved_entry, &shost->starved_list);
 	spin_unlock_irq(shost->host_lock);
 out_dec:
-	if (starget->can_queue > 0)
-		atomic_dec(&starget->target_busy);
+	atomic_dec(&starget->target_busy);
 	return 0;
 }
 
@@ -1886,8 +1884,7 @@ static blk_status_t scsi_queue_rq(struct blk_mq_hw_ctx *hctx,
 out_dec_host_busy:
 	scsi_dec_host_busy(shost, cmd);
 out_dec_target_busy:
-	if (scsi_target(sdev)->can_queue > 0)
-		atomic_dec(&scsi_target(sdev)->target_busy);
+	atomic_dec(&scsi_target(sdev)->target_busy);
 out_put_budget:
 	scsi_mq_put_budget(q, cmd->budget_token);
 	cmd->budget_token = -1;
-- 
2.33.0

