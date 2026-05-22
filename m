Received: from mail-m10188.netease.com (mail-m10188.netease.com [154.81.10.188])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17AAC4369A;
	Fri, 22 May 2026 03:05:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=154.81.10.188
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779419128; cv=none; b=OR29jNbKcx8pVfip3gV7SEycU9ARRZXu37Jd3JN38hNrxQujKAkN3dM8YfQfF6dUwIKQVnILBQJDofZ9UXZfRW1XvaIMu1346qctZg4k1WDdP0HjhZJj6NGstIsaUN1KOur03OXVrsyUcmEA3FUbEWPiD8zCXrFLq8tKo4crQPo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779419128; c=relaxed/simple;
	bh=Lqsy4HienDaWeboj22nwmyyE+vhyncL58Mye6wNTjGI=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=iwWBj6sdZpE0hAUMtA4WAHorLfWWLLaTbMx9hRPP0mhb8voqeGQe8Zv0gRKLjsEzUDnaODq3DlAUFhnuPvZh4T5WT8YNpvVMLuGmT2k+vzspmpzBfLpW867odv6gK7k1NDq6HiQ2LFfD9UnSxNnKHvqo7himvDdG1FlLvno0cSo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=seu.edu.cn; spf=pass smtp.mailfrom=seu.edu.cn; dkim=pass (1024-bit key) header.d=seu.edu.cn header.i=@seu.edu.cn header.b=n0FjetMn; arc=none smtp.client-ip=154.81.10.188
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=seu.edu.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=seu.edu.cn
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=seu.edu.cn header.i=@seu.edu.cn header.b="n0FjetMn"
Received: from DESKTOP-SUEFNF9.taila7e912.ts.net (unknown [223.112.146.162])
	by smtp.qiye.163.com (Hmail) with ESMTP id 3f63bb564;
	Fri, 22 May 2026 11:05:14 +0800 (GMT+08:00)
From: Dawei Feng <dawei.feng@seu.edu.cn>
To: sathya.prakash@broadcom.com
Cc: sreekanth.reddy@broadcom.com,
	suganath-prabu.subramani@broadcom.com,
	ranjan.kumar@broadcom.com,
	James.Bottomley@HansenPartnership.com,
	martin.petersen@oracle.com,
	MPT-FusionLinux.pdl@broadcom.com,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	jianhao.xu@seu.edu.cn,
	Dawei Feng <dawei.feng@seu.edu.cn>,
	stable@vger.kernel.org,
	Zilin Guan <zilin@seu.edu.cn>
Subject: [PATCH] scsi: mpt3sas: fix double free on attach failure
Date: Fri, 22 May 2026 11:05:12 +0800
Message-Id: <20260522030512.3593337-1-dawei.feng@seu.edu.cn>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-HM-Tid: 0a9e4da4ecea03a2kunmbeaf0ddc5fe61
X-HM-MType: 10
X-HM-Spam-Status: e1kfGhgUHx5ZQUpXWQgPGg8OCBgUHx5ZQUlOS1dZFg8aDwILHllBWSg2Ly
	tZV1koWUFITzdXWRgWCB1ZQUpXWS1ZQUlXWQ8JGhUIEh9ZQVkaT05NVh1LTxlMTxgZHkIeSlYeHw
	5VEwETFhoSFyQUDg9ZV1kYEgtZQVlJSUhVSkpJVUpPTVVKTUlZV1kWGg8SFR0UWUFZT0tIVUpLSU
	hOQ0NVSktLVUtZBg++
DKIM-Signature: a=rsa-sha256;
	b=n0FjetMnflSYuRnILIwM6OFHiYrbgQnN1H0RTbAbbkO+8/l7w1hJLDdy9z8MjZ/5SyMjUgb3EZUlZ8jlce2HKPJ0qkKTEqZclHqzFCtiqW1fZ1vymRDMbOEJqd5x0pJWTAqG8AutDT1zL4vRVzTrOx5mBK8Xk6yH/fDBj14d9n8=; s=default; c=relaxed/relaxed; d=seu.edu.cn; v=1;
	bh=5A71jDVZGOtR1kW6DpGCEYPpBI3TD0twhJ2npk6TIOI=;
	h=date:mime-version:subject:message-id:from;

mpt3sas_base_attach() tears memory pools down from its
out_free_resources path when _base_allocate_memory_pools() fails.
Some _base_allocate_memory_pools() retry and error paths already call
_base_release_memory_pools() before returning an error, so the attach
cleanup can run the same teardown twice.

Set reply_post, pcie_sgl_dma_pool, and config_page to NULL after
teardown so the attach failure path cannot release the same resources a
second time, avoiding a double free.

The bug was first flagged by an experimental analysis tool we are
developing for kernel memory-management bugs while analyzing
v6.13-rc1. The tool is still under development and is not yet publicly
available. Manual inspection confirms that the bug is still
present in v7.1-rc4.

Runtime validation was not attempted because this path depends on
mpt3sas controller initialization and suitable hardware or firmware.

Fixes: 8ff045c92708 ("mpt3sas: Free memory pools before retrying to allocate with different value.")
Cc: stable@vger.kernel.org
Signed-off-by: Zilin Guan <zilin@seu.edu.cn>
Signed-off-by: Dawei Feng <dawei.feng@seu.edu.cn>
---
 drivers/scsi/mpt3sas/mpt3sas_base.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.c b/drivers/scsi/mpt3sas/mpt3sas_base.c
index 79052f2accbd..18fe64d6f40a 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_base.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_base.c
@@ -5866,6 +5866,7 @@ _base_release_memory_pools(struct MPT3SAS_ADAPTER *ioc)
 		}
 		dma_pool_destroy(ioc->reply_post_free_array_dma_pool);
 		kfree(ioc->reply_post);
+		ioc->reply_post = NULL;
 	}
 
 	if (ioc->pcie_sgl_dma_pool) {
@@ -5876,6 +5877,7 @@ _base_release_memory_pools(struct MPT3SAS_ADAPTER *ioc)
 			ioc->pcie_sg_lookup[i].pcie_sgl = NULL;
 		}
 		dma_pool_destroy(ioc->pcie_sgl_dma_pool);
+		ioc->pcie_sgl_dma_pool = NULL;
 	}
 	kfree(ioc->pcie_sg_lookup);
 	ioc->pcie_sg_lookup = NULL;
@@ -5886,6 +5888,7 @@ _base_release_memory_pools(struct MPT3SAS_ADAPTER *ioc)
 				     ioc->config_page));
 		dma_free_coherent(&ioc->pdev->dev, ioc->config_page_sz,
 		    ioc->config_page, ioc->config_page_dma);
+		ioc->config_page = NULL;
 	}
 
 	kfree(ioc->hpr_lookup);
-- 
2.34.1

