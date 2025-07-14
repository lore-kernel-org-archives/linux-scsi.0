Received: from mailout4.samsung.com (mailout4.samsung.com [203.254.224.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2161ECA6B
	for <linux-scsi@vger.kernel.org>; Mon, 14 Jul 2025 09:06:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752483996; cv=none; b=b1wGKfWtLAEazL3aA7I7OLWUPzWxpNbAai0G3Am44KcZUwXVtxUcPrhVYl+0lVYj+HF8v2fyHG5DT88vgzwAC1W0ACWoF9OQJV4wZPgFT+jEC3dCJgbuJPVzS1DlHmRkcbDiZxwR07T80Cug8Hg4zGPA8SM38RkXt5bG6OOfe48=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752483996; c=relaxed/simple;
	bh=X8RGDB9wzFS4Va1ii1k6z1+qNnla8YBtsxSHUDbd3CE=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type:
	 References; b=iDHn84c/sGnuIiRUUgPOfuWuoEG2PGTkNLNiCVyC0rUcngXIiGBYMlaPIwQXNeZm0ayD4Vzr+ZwFKS2yleSqi80y0iwj6IO7fxfUM6uZHcnjQXe6z0nTglN5gh/JCU+QoyS9NegOWUmsGsJ5AWeEHeJqwLtTY1e4/Pd6ElrQaVY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=n5PaU9ly; arc=none smtp.client-ip=203.254.224.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="n5PaU9ly"
Received: from epcas1p4.samsung.com (unknown [182.195.41.48])
	by mailout4.samsung.com (KnoxPortal) with ESMTP id 20250714090632epoutp04cfd3569cf44758cbfeac4b9fec6303e1~SEufhDcJC1361913619epoutp04O
	for <linux-scsi@vger.kernel.org>; Mon, 14 Jul 2025 09:06:32 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20250714090632epoutp04cfd3569cf44758cbfeac4b9fec6303e1~SEufhDcJC1361913619epoutp04O
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1752483992;
	bh=AH1RjOknKmwF3CWDe75qYP+1VnhwNlQ476gW0wSAocE=;
	h=From:To:Cc:Subject:Date:References:From;
	b=n5PaU9lyD+mJxlA4x018LdxIM9qGfemJsqClO8eKuLiRE3RpqsVBkoa73CmINZE06
	 +HzmkQoicBm3lo3ROcxA3e1wa+wqZ/hViyjC4SVvkLS+RdKsuq7hE4hpduIdq8FlK+
	 7iIF+MVR+ox4QMhIgKP0gLez2Et4L4jKie+QoiyE=
Received: from epsnrtp02.localdomain (unknown [182.195.42.154]) by
	epcas1p4.samsung.com (KnoxPortal) with ESMTPS id
	20250714090631epcas1p4a39189d3c69dad3c87cbe5534ae3a8d8~SEufEhhq11975419754epcas1p4L;
	Mon, 14 Jul 2025 09:06:31 +0000 (GMT)
Received: from epcas1p2.samsung.com (unknown [182.195.38.243]) by
	epsnrtp02.localdomain (Postfix) with ESMTP id 4bgbzC3yHSz2SSKb; Mon, 14 Jul
	2025 09:06:31 +0000 (GMT)
Received: from epsmtip2.samsung.com (unknown [182.195.34.31]) by
	epcas1p2.samsung.com (KnoxPortal) with ESMTPA id
	20250714090630epcas1p28ab8afec11bbab4d256dfe6649d3b00b~SEuear0Tc0285302853epcas1p2D;
	Mon, 14 Jul 2025 09:06:30 +0000 (GMT)
Received: from sh043lee-960XFH.. (unknown [10.253.98.183]) by
	epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
	20250714090630epsmtip2c03061fc01d2d6965a52da8e2b92d621~SEueXVtxj1185511855epsmtip25;
	Mon, 14 Jul 2025 09:06:30 +0000 (GMT)
From: Seunghui Lee <sh043.lee@samsung.com>
To: alim.akhtar@samsung.com, avri.altman@wdc.com, bvanassche@acm.org,
	James.Bottomley@HansenPartnership.com, martin.petersen@oracle.com,
	linux-scsi@vger.kernel.org, sdriver.sec@samsung.com
Cc: Seunghui Lee <sh043.lee@samsung.com>
Subject: [PATCH] ufs: core: Use link recovery when the h8 exit failure
 during runtime resume
Date: Mon, 14 Jul 2025 18:06:17 +0900
Message-ID: <20250714090617.9212-1-sh043.lee@samsung.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CMS-MailID: 20250714090630epcas1p28ab8afec11bbab4d256dfe6649d3b00b
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
CMS-TYPE: 101P
cpgsPolicy: CPGSC10-711,Y
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20250714090630epcas1p28ab8afec11bbab4d256dfe6649d3b00b
References: <CGME20250714090630epcas1p28ab8afec11bbab4d256dfe6649d3b00b@epcas1p2.samsung.com>

If the h8 exit fails during runtime resume process,
the runtime thread enters runtime suspend immediately
and the error handler operates at the same time.
It becomes stuck and cannot be recovered through the error handler.
To fix this, use link recovery instead of the error handler.

Signed-off-by: Seunghui Lee <sh043.lee@samsung.com>
---
 drivers/ufs/core/ufshcd.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index 50adfb8b335b..dc2845c32d72 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -4340,7 +4340,7 @@ static int ufshcd_uic_pwr_ctrl(struct ufs_hba *hba, struct uic_command *cmd)
 	hba->uic_async_done = NULL;
 	if (reenable_intr)
 		ufshcd_enable_intr(hba, UIC_COMMAND_COMPL);
-	if (ret) {
+	if (ret && !hba->pm_op_in_progress) {
 		ufshcd_set_link_broken(hba);
 		ufshcd_schedule_eh_work(hba);
 	}
@@ -4348,6 +4348,14 @@ static int ufshcd_uic_pwr_ctrl(struct ufs_hba *hba, struct uic_command *cmd)
 	spin_unlock_irqrestore(hba->host->host_lock, flags);
 	mutex_unlock(&hba->uic_cmd_mutex);
 
+	/*
+	 * If the h8 exit fails during the runtime resume process,
+	 * it becomes stuck and cannot be recovered through the error handler.
+	 * To fix this, use link recovery instead of the error handler.
+	 */
+	if (ret && hba->pm_op_in_progress)
+		ret = ufshcd_link_recovery(hba);
+
 	return ret;
 }
 
-- 
2.43.0

