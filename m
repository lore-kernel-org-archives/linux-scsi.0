Received: from outboundhk.mxmail.xiaomi.com (outboundhk.mxmail.xiaomi.com [207.226.244.123])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1999A288522
	for <linux-scsi@vger.kernel.org>; Tue, 24 Feb 2026 06:34:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=207.226.244.123
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771914865; cv=none; b=HKcekv8BkTz6cjxm9SxVLiAKraWQdvL2oKj1tltaFSj1S5q7Jhwn3O71GtYMOyf9k7hxLvYIlzOYPitxSprO1zkJn0FmLtdpo3YJIzeUO99KTUoZo2rP7fGr4gheDQ3EBm7aRv4X2r3RS/UurGft9TUnRN+hpI4cUuLV2O+69/s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771914865; c=relaxed/simple;
	bh=ANzeNLRmBeExZ10im+M5DZ9zEJ17NTjtu0772fuQshQ=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=E+lZmrjUhTZLNZf1s0gviZureJ2mEeCv9/oY1Hq6LOZdNbZi7c1ogvMkrYf5W0yfAv+QMY1FKN52EYMWqCUCKGjO1Q2pEnS9L+plazB153Hzb05NWILgDH85miGVLnltdmlqDzqaBhYq/HYtBWEoDL9yToqrmbJs8sw94u/8YuE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=xiaomi.com; spf=pass smtp.mailfrom=xiaomi.com; arc=none smtp.client-ip=207.226.244.123
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=xiaomi.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=xiaomi.com
X-CSE-ConnectionGUID: wEjM7qLWQyi1F4QooYJ92A==
X-CSE-MsgGUID: cc+EO3QnT6ONgUx+GUMVJg==
X-IronPort-AV: E=Sophos;i="6.21,308,1763395200"; 
   d="scan'208";a="167766251"
From: WangShuaiwei <wangshuaiwei1@xiaomi.com>
To: "Martin K . Petersen" <martin.petersen@oracle.com>, "James E . J .
 Bottomley" <James.Bottomley@HansenPartnership.com>
CC: Alim Akhtar <alim.akhtar@samsung.com>, Avri Altman <avri.altman@wdc.com>,
	Bart Van Assche <bvanassche@acm.org>, <linux-scsi@vger.kernel.org>,
	<wanghui33@xiaomi.com>, WangShuaiwei <wangshuaiwei1@xiaomi.com>
Subject: [PATCH] scsi: ufs: core: Fix shift out of bounds when MAXQ=32
Date: Tue, 24 Feb 2026 14:32:28 +0800
Message-ID: <20260224063228.50112-1-wangshuaiwei1@xiaomi.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BJ-MBX07.mioffice.cn (10.237.8.127) To bj-mbx11.mioffice.cn
 (10.237.8.131)

From: wangshuaiwei <wangshuaiwei1@xiaomi.com>

According to JESD223F, the maximum number of queues (MAXQ) is 32. When
MCQ is enabled and ESI is disabled, nr_hw_queues=32 causes a shift overflow
problem.

Fix this by using 64-bit intermediate values to handle the nr_hw_queues=32
case safely.

Signed-off-by: wangshuaiwei <wangshuaiwei1@xiaomi.com>
---
 drivers/ufs/core/ufshcd.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index 847b55789bb8..8e0d02a77a55 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -7097,7 +7097,7 @@ static irqreturn_t ufshcd_handle_mcq_cq_events(struct ufs_hba *hba)
 
 	ret = ufshcd_vops_get_outstanding_cqs(hba, &outstanding_cqs);
 	if (ret)
-		outstanding_cqs = (1U << hba->nr_hw_queues) - 1;
+		outstanding_cqs = (1ULL << hba->nr_hw_queues) - 1;
 
 	/* Exclude the poll queues */
 	nr_queues = hba->nr_hw_queues - hba->nr_queues[HCTX_TYPE_POLL];
-- 
2.43.0

