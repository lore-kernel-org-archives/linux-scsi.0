Received: from szxga04-in.huawei.com (szxga04-in.huawei.com [45.249.212.190])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB9BC29D261;
	Sat, 16 Aug 2025 10:53:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.190
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755341598; cv=none; b=CxQI8chs4B6Lp7P9V8rBPCRAjQb0GMzYWJYhqjq7Nly+HRAVPSAwmSuy1Tfo8vfRwAVZOvhwYvM54/aNMYt066HFsejkqq1a0LQtrTPWuNk1br74KpcAHePSlCzEP/F/LlklEA8oNBZiCqYydIuveua7tPpLpjxLNhsTkB1B+Eo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755341598; c=relaxed/simple;
	bh=A8UN6nhnqb4wUk5VVG86mpla/61dO0D3CqACMOhUiaQ=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Q2b7kRuP121NPR1SNUtbiVxqFRZ7b/UyIroSfMXxuFRrezwu4PxgrciBOklR6aCUJqIBow/XN3xV1tbMVC+tA0FRnd6d4aoLbVV5fyD3JGqTRvk4Q1wgfc9OIIUrEionBOgDSb2EzWXN9LZYBJuJwYGsNnvqII/43V5oa4TtG4Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=h-partners.com; arc=none smtp.client-ip=45.249.212.190
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=h-partners.com
Received: from mail.maildlp.com (unknown [172.19.88.234])
	by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4c3wjx4tcVz2VRG4;
	Sat, 16 Aug 2025 18:50:29 +0800 (CST)
Received: from kwepemk500001.china.huawei.com (unknown [7.202.194.86])
	by mail.maildlp.com (Postfix) with ESMTPS id BA6B0140259;
	Sat, 16 Aug 2025 18:53:13 +0800 (CST)
Received: from localhost.localdomain (10.175.104.170) by
 kwepemk500001.china.huawei.com (7.202.194.86) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Sat, 16 Aug 2025 18:53:12 +0800
From: JiangJianJun <jiangjianjun3@huawei.com>
To: <James.Bottomley@HansenPartnership.com>, <martin.petersen@oracle.com>,
	<linux-scsi@vger.kernel.org>
CC: <linux-kernel@vger.kernel.org>, <hare@suse.de>, <bvanassche@acm.org>,
	<michael.christie@oracle.com>, <hch@infradead.org>, <haowenchao22@gmail.com>,
	<john.g.garry@oracle.com>, <hewenliang4@huawei.com>, <yangyun50@huawei.com>,
	<wuyifeng10@huawei.com>, <wubo40@huawei.com>, <yangxingui@h-partners.com>
Subject: [PATCH 09/14] scsi: core: increase/decrease target_busy if set error handler
Date: Sat, 16 Aug 2025 19:24:12 +0800
Message-ID: <20250816112417.3581253-10-jiangjianjun3@huawei.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20250816112417.3581253-1-jiangjianjun3@huawei.com>
References: <20250816112417.3581253-1-jiangjianjun3@huawei.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: kwepems100002.china.huawei.com (7.221.188.206) To
 kwepemk500001.china.huawei.com (7.202.194.86)

From: JiangJianJun <jiangjianjun3@h-partners.com>

This is preparation for a genernal target based error handle strategy
to check if to wake up actual error handler, we should enable counter
field scsi_target.target_busy in this case.

Signed-off-by: JiangJianJun <jiangjianjun3@h-partners.com>
---
 drivers/scsi/scsi_lib.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 63bd33af336b..5115ab5d0942 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -393,7 +393,7 @@ void scsi_device_unbusy(struct scsi_device *sdev, struct scsi_cmnd *cmd)
 
 	scsi_dec_host_busy(shost, cmd);
 
-	if (starget->can_queue > 0)
+	if (starget->can_queue > 0 || starget->eh)
 		atomic_dec(&starget->target_busy);
 
 	sbitmap_put(&sdev->budget_map, cmd->budget_token);
@@ -1412,8 +1412,11 @@ static inline int scsi_target_queue_ready(struct Scsi_Host *shost,
 		spin_unlock_irq(shost->host_lock);
 	}
 
-	if (starget->can_queue <= 0)
+	if (starget->can_queue <= 0) {
+		if (starget->eh)
+			atomic_inc(&starget->target_busy);
 		return 1;
+	}
 
 	busy = atomic_inc_return(&starget->target_busy) - 1;
 	if (atomic_read(&starget->target_blocked) > 0) {
@@ -1885,7 +1888,7 @@ static blk_status_t scsi_queue_rq(struct blk_mq_hw_ctx *hctx,
 out_dec_host_busy:
 	scsi_dec_host_busy(shost, cmd);
 out_dec_target_busy:
-	if (scsi_target(sdev)->can_queue > 0)
+	if (scsi_target(sdev)->can_queue > 0 || scsi_target(sdev)->eh)
 		atomic_dec(&scsi_target(sdev)->target_busy);
 out_put_budget:
 	scsi_mq_put_budget(q, cmd->budget_token);
-- 
2.33.0

