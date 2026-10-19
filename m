Received: from mail-m12771.qiye.163.com (mail-m12771.qiye.163.com [115.236.127.71])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5587B47F3C1
	for <linux-scsi@vger.kernel.org>; Mon, 19 Oct 2026 05:10:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.236.127.71
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792386650; cv=none; b=uXPQn4eq+3p+idkR+kvLhEWBrCN3tpM9sjZQVcDRAdfzE8B/iBCvRXL91YJb6RKSQswJXQpFz3aj+yfzypKQVzlA0EUSaveXW3HQbGi3Djh7tDrFefxEzp+GucZ/Sz6i9Nn1UBi+KYND+kk2bnI8kYbIWFLYQoE+fYJD2CFVpmY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792386650; c=relaxed/simple;
	bh=J+5GPTv8w35AGvo9/AUvrzN63L9qcXt1N+QsFiR43Ys=;
	h=From:To:Cc:Subject:Date:Message-Id; b=TBbe/DyEZBvtpPFe4n8EFV1Bqp2k0kjTOcBA3/eERSoc6NzTRpt4cD4t2MOuDI9hsLcGQn3HYFoEJyps92Y9k2obHuSsk0KaSVTcJdE7hT8+0ftew81vys8PDWh+vPCSaycEA7Kl/UKxXhhAnMg5HvN7mLtqGoE9MWCsVHJ7X0o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=rock-chips.com; spf=pass smtp.mailfrom=rock-chips.com; dkim=pass (1024-bit key) header.d=rock-chips.com header.i=@rock-chips.com header.b=PM+F/RVk; arc=none smtp.client-ip=115.236.127.71
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=rock-chips.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rock-chips.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=rock-chips.com header.i=@rock-chips.com header.b="PM+F/RVk"
Received: from localhost.localdomain (unknown [58.22.7.114])
	by smtp.qiye.163.com (Hmail) with ESMTP id 517656c25;
	Mon, 19 Oct 2026 08:34:36 +0800 (GMT+08:00)
From: Shawn Lin <shawn.lin@rock-chips.com>
To: "James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K . Petersen" <martin.petersen@oracle.com>
Cc: Bart Van Assche <bvanassche@acm.org>,
	linux-scsi@vger.kernel.org,
	Bean Huo <beanhuo@micron.com>,
	Shawn Lin <shawn.lin@rock-chips.com>
Subject: [PATCH v3] scsi: ufs: core: Fix stale comment in ufshcd_mcq_config_nr_queues()
Date: Mon, 19 Oct 2026 08:34:22 +0800
Message-Id: <1792370062-23050-1-git-send-email-shawn.lin@rock-chips.com>
X-Mailer: git-send-email 2.7.4
X-HM-Tid: 0aa15194e92c03a4kunme6592d26600a88
X-HM-MType: 1
X-HM-Spam-Status: e1kfGhgUHx5ZQUpXWQgPGg8OCBgUHx5ZQUlOS1dZFg8aDwILHllBWSg2Ly
	tZV1koWUFDSUNOT01LS0k3V1kYFggdWUFKV1ktWUFJV1kPCRoVCBIfWUFZGRhPSVZMGB1NH04ZTk
	5KGk1WFRQJFhoXVRMBExYaEhckFA4PWVdZGBILWUFZTkNVSUlVTFVKSk9ZV1kWGg8SFR0UWUFZT0
	tIVUpLSU9PT0hVSktLVUpCS0tZBg++
DKIM-Signature: a=rsa-sha256;
	b=PM+F/RVkhSZBhVWiklrV71Z+tmQF0EtutcP/zEpyqYaDbPG7Xx3zdQaT30AvZFq1dCA8n6pgriKs/9pEJ3tqDiFmumyuqmxJ7XdvR/XDEeyHpUMtVRsqA1VSo1QKV0oPK/01jBkZuLmmA//62GGEWLcnMTTHdO5BPYjR3G0weRw=; c=relaxed/relaxed; s=default; d=rock-chips.com; v=1;
	bh=TyOzjxbbY7JyZH2FXiIeKAf2yjP76tT3088Ve2uPSlc=;
	h=date:mime-version:subject:message-id:from;
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

The comment refers to "hba->dev_cmd_queue", but struct ufs_hba no longer
has such a member (it was removed when the dedicated hwq for device
commands was dropped). Reword it to describe the actual requirement:
the queue is a host controller capability and it serves both non-polled
SCSI commands and UFS device management commands.

Signed-off-by: Shawn Lin <shawn.lin@rock-chips.com>
Reviewed-by: Bean Huo <beanhuo@micron.com>
---

Changes in v3:
- improve commit message (Bean)
- collect tag from Bean

Changes in v2:
- address Bart's review comments

 drivers/ufs/core/ufs-mcq.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/ufs/core/ufs-mcq.c b/drivers/ufs/core/ufs-mcq.c
index df293b6..25e392f 100644
--- a/drivers/ufs/core/ufs-mcq.c
+++ b/drivers/ufs/core/ufs-mcq.c
@@ -183,8 +183,8 @@ static int ufshcd_mcq_config_nr_queues(struct ufs_hba *hba)
 	}
 
 	/*
-	 * Device should support at least one I/O queue to handle device
-	 * commands via hba->dev_cmd_queue.
+	 * At least one non-poll (HCTX_TYPE_DEFAULT) queue is required for
+	 * non-polled SCSI commands and UFS device management commands.
 	 */
 	if (hba_maxq == poll_queues) {
 		dev_err(hba->dev, "At least one non-poll queue required\n");
-- 
2.7.4

