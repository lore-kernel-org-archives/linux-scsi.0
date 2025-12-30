Received: from mail-m49197.qiye.163.com (mail-m49197.qiye.163.com [45.254.49.197])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63D6F325737;
	Tue, 30 Dec 2025 14:59:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.254.49.197
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767106757; cv=none; b=bbM70Io/SwrPksVFk61Q/UIO3iPFTVMMjO4ry5XLtbXQNxD31VzBTBvuVZAsNhqalBr3Hb53Ud/MfDp1qcuZTwZI5TAr7gC7RiuoRSyW+QyvfOn+lY2dJiJzF4s/oeb+QUc27t+llCwwO87MPPfaLzpjVy761XhrsMeYyasSTSM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767106757; c=relaxed/simple;
	bh=F1Zd7PK5qv/Q3FCmkouzGY2//UDeMu1s9JuoGaeqCTM=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=afgsCEbA9dvCcLTjFjEk6DYplJ9lM4eAj/u2mhJWqy4nCY/kbvDNY4OR25FPxnhu3Qh8m7SQK2VhKVQFxgCFY59yFEvwxpeBF7umDlp33t5s/k6jOLkOTmrrNDL5oTmljMEORwD8eZM47/SPUpf5ExQBgcl3gEJkEekh/OIQpOQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=seu.edu.cn; spf=pass smtp.mailfrom=seu.edu.cn; dkim=pass (1024-bit key) header.d=seu.edu.cn header.i=@seu.edu.cn header.b=gr1PBs1T; arc=none smtp.client-ip=45.254.49.197
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=seu.edu.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=seu.edu.cn
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=seu.edu.cn header.i=@seu.edu.cn header.b="gr1PBs1T"
Received: from LAPTOP-N070L597.localdomain (unknown [223.112.146.162])
	by smtp.qiye.163.com (Hmail) with ESMTP id 2f0b6655c;
	Tue, 30 Dec 2025 22:59:10 +0800 (GMT+08:00)
From: Zilin Guan <zilin@seu.edu.cn>
To: justin.tee@broadcom.com
Cc: paul.ely@broadcom.com,
	James.Bottomley@HansenPartnership.com,
	martin.petersen@oracle.com,
	Markus.Elfring@web.de,
	jianhao.xu@seu.edu.cn,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Zilin Guan <zilin@seu.edu.cn>
Subject: [PATCH v2 3/3] scsi: lpfc: Fix memory leak in lpfc_cmpl_plogi_plogi_issue()
Date: Tue, 30 Dec 2025 14:58:58 +0000
Message-Id: <20251230145858.1356864-4-zilin@seu.edu.cn>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20251230145858.1356864-1-zilin@seu.edu.cn>
References: <20251230145858.1356864-1-zilin@seu.edu.cn>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-HM-Tid: 0a9b6fc529cb03a1kunmc44e99e11660c0
X-HM-MType: 10
X-HM-Spam-Status: e1kfGhgUHx5ZQUpXWQgPGg8OCBgUHx5ZQUlOS1dZFg8aDwILHllBWSg2Ly
	tZV1koWUFITzdXWS1ZQUlXWQ8JGhUIEh9ZQVlDTEMZVkkYH00ZHxodHh8dGlYeHw5VEwETFhoSFy
	QUDg9ZV1kYEgtZQVlJSUhVSkpJVUpPTVVKTUlZV1kWGg8SFR0UWUFZT0tIVUpLSUJDQ0xVSktLVU
	tZBg++
DKIM-Signature: a=rsa-sha256;
	b=gr1PBs1TpK6EUikSViUrU6qiJJEYGEDa8QtIRiCPZF40//EkauNOubT8ZK+81oLoqAziEa/dEYAv0yO+/j/JRC/OA+PnapmB9FIdWFDQfRRgl0RUotmaMPC3LmdEc1ZiwYhz5+Z5XX0QvYuT2IdQy/PLjKqiVyVYAjR5+lWwHDI=; s=default; c=relaxed/relaxed; d=seu.edu.cn; v=1;
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

