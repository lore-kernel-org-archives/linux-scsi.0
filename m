Received: from mail-m155101.qiye.163.com (mail-m155101.qiye.163.com [101.71.155.101])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E160F2749C9;
	Wed, 31 Dec 2025 15:11:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=101.71.155.101
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767193891; cv=none; b=iYW4dy+ULhTJZKbPxjqHccFk/0iuBipTPlISEjHGz6fCJwMhnmllZeQtQvrdLyM+lVPW7U7VOuO3JG6dDMGpNMSrkXX4bN4zDDNjr6WeajvH6GOninsoSQmiLoNsv8OnhdE4br0Z+rNwkXbNXDgLXgx1SajH+qJvvOKVsY+sgD4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767193891; c=relaxed/simple;
	bh=F1Zd7PK5qv/Q3FCmkouzGY2//UDeMu1s9JuoGaeqCTM=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Jmb1SOavLsdsTOIrwT3tU3WjTctz1ULW8eKuAoHW+364PM9h/RIndb1DMtQZwQRSkmtV6vQbFcEQiwTMFtqA6cK23UZLjFWDMFi5RckizlWJkQHf/bHyz1j44dkTGKRcq/2JvKdAU6KtMzBLUrGtAUQ4bBOoMi1Uy9oyCoQKKWw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=seu.edu.cn; spf=pass smtp.mailfrom=seu.edu.cn; dkim=pass (1024-bit key) header.d=seu.edu.cn header.i=@seu.edu.cn header.b=hwg6t9jo; arc=none smtp.client-ip=101.71.155.101
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=seu.edu.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=seu.edu.cn
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=seu.edu.cn header.i=@seu.edu.cn header.b="hwg6t9jo"
Received: from LAPTOP-N070L597.localdomain (unknown [222.191.246.242])
	by smtp.qiye.163.com (Hmail) with ESMTP id 2f2b2ecc9;
	Wed, 31 Dec 2025 23:11:24 +0800 (GMT+08:00)
From: Zilin Guan <zilin@seu.edu.cn>
To: justin.tee@broadcom.com
Cc: paul.ely@broadcom.com,
	James.Bottomley@HansenPartnership.com,
	martin.petersen@oracle.com,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Markus.Elfring@web.de,
	Zilin Guan <zilin@seu.edu.cn>,
	Jianhao Xu <jianhao.xu@seu.edu.cn>
Subject: [PATCH v3 3/3] scsi: lpfc: Fix memory leak in lpfc_cmpl_plogi_plogi_issue()
Date: Wed, 31 Dec 2025 15:11:09 +0000
Message-Id: <20251231151109.362373-4-zilin@seu.edu.cn>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20251231151109.362373-1-zilin@seu.edu.cn>
References: <20251231151109.362373-1-zilin@seu.edu.cn>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-HM-Tid: 0a9b74f6b77b03a1kunmad4383ff1aba72
X-HM-MType: 10
X-HM-Spam-Status: e1kfGhgUHx5ZQUpXWQgPGg8OCBgUHx5ZQUlOS1dZFg8aDwILHllBWSg2Ly
	tZV1koWUFITzdXWS1ZQUlXWQ8JGhUIEh9ZQVlCQ0oeVhoaSEtJTkxJThlMGlYeHw5VEwETFhoSFy
	QUDg9ZV1kYEgtZQVlJSUlVSkJKVUlPTVVJT0lZV1kWGg8SFR0UWUFZT0tIVUpLSUhOQ0NVSktLVU
	tZBg++
DKIM-Signature: a=rsa-sha256;
	b=hwg6t9joU93dNLO6kfOKH27W6kJDVBFFgfOHb2JKlOaV/pSbWac92dTtwpp1zHu6eUitmjhmi3zd1yX6JhLVmjSy9lS3B4u0VEYwdv1VaXwIG09ZaSNmimllr2oFG/dBeb7926+1uipznDx8BoMWL2Cu5X2fryvNIvyq/jS22zI=; s=default; c=relaxed/relaxed; d=seu.edu.cn; v=1;
	bh=sDdO+nwO8UMsubRHt9hljG4K4gbAZAqcwzGsSX6eUh4=;
	h=date:mime-version:subject:message-id:from;

In lpfc_cmpl_plogi_plogi_issue(), mbox is allocated via
mempool_alloc() and initialized. However, if lpfc_nlp_get() fails,
the mbox and its resources are not freed.

Fix this by using lpfc_mbox_rsrc_cleanup() to free the mailbox and
its associated resources.

Fixes: 4430f7fd09ec ("scsi: lpfc: Rework locations of ndlp reference taking")
Co-developed-by: Jianhao Xu <jianhao.xu@seu.edu.cn>
Signed-off-by: Jianhao Xu <jianhao.xu@seu.edu.cn>
Signed-off-by: Zilin Guan <zilin@seu.edu.cn>
---
 drivers/scsi/lpfc/lpfc_nportdisc.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/lpfc/lpfc_nportdisc.c b/drivers/scsi/lpfc/lpfc_nportdisc.c
index 8240d59f4120..e81640223276 100644
--- a/drivers/scsi/lpfc/lpfc_nportdisc.c
+++ b/drivers/scsi/lpfc/lpfc_nportdisc.c
@@ -1505,8 +1505,10 @@ lpfc_cmpl_plogi_plogi_issue(struct lpfc_vport *vport,
 		}
 
 		mbox->ctx_ndlp = lpfc_nlp_get(ndlp);
-		if (!mbox->ctx_ndlp)
+		if (!mbox->ctx_ndlp) {
+			lpfc_mbox_rsrc_cleanup(phba, mbox, MBOX_THD_UNLOCKED);
 			goto out;
+		}
 
 		mbox->vport = vport;
 		if (lpfc_sli_issue_mbox(phba, mbox, MBX_NOWAIT)
-- 
2.34.1

