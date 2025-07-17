Received: from mailout1.samsung.com (mailout1.samsung.com [203.254.224.24])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38321279327
	for <linux-scsi@vger.kernel.org>; Thu, 17 Jul 2025 08:12:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.24
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752739947; cv=none; b=nUSyUZyUAScZU6tL30thGlxzvXIJMhPeciUDIeRgJbdL3aIRXxwEsvs40e60R85eF42J9x8D7+TNjPXE3nx28czMt6ZiTRzIjyNDLQXkRDtwm7wX73Xv1FhLtH9AiSmyjkf7nQk8p7FrSgPLLCSMixroyXrqTSYIFnH3tNUF83Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752739947; c=relaxed/simple;
	bh=wlWucFXbu0+Ln1t4583wNhsERYRXZ5JUYc8spd+sCj0=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type:
	 References; b=UNAK84Zy57Sl+h+yQ0o/Ibuz725ZU4S76cB4jITExEC22KZuXwNyaQJ+FBEoPM/TGiuqs5a4mBa5dGI5Vu8CbMZ+t07XuibX1TAElwn5W9eqjSO2eXmR9uPhr/yl7kYfxtwReWIUqGq1ys+7mDGBPn5lfzLH9ch+dyVI4HlMZUU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=I5G7u573; arc=none smtp.client-ip=203.254.224.24
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="I5G7u573"
Received: from epcas1p4.samsung.com (unknown [182.195.41.48])
	by mailout1.samsung.com (KnoxPortal) with ESMTP id 20250717081222epoutp0138a46882e020ba74bbdce8beb2f4d756~S_7DfTVUn1620716207epoutp01R
	for <linux-scsi@vger.kernel.org>; Thu, 17 Jul 2025 08:12:22 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20250717081222epoutp0138a46882e020ba74bbdce8beb2f4d756~S_7DfTVUn1620716207epoutp01R
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1752739942;
	bh=I6DmLKFHaX7ZFv9+ybkFoENu8O7C3F5K8tKghegzEPE=;
	h=From:To:Cc:Subject:Date:References:From;
	b=I5G7u573t1Vs1eAC+h5Y9OUCyIAznJLO+48I6OoZMAh4ZmfMF4lBnTf7sC2cSpRBu
	 F3FJaOtLa8pVYRM+EI0VhoooXgQS4hPv+2kgG+Oyha/jvHwIDQp6qw3QhlrcPEpgVK
	 66xjPPXFvDi2B+jTL/4NxszU8YNHAUDRXpzJMkns=
Received: from epsnrtp02.localdomain (unknown [182.195.42.154]) by
	epcas1p4.samsung.com (KnoxPortal) with ESMTPS id
	20250717081221epcas1p49ca52a04d3d9d32ae1e17e8b0b7725c4~S_7DAaufW2619926199epcas1p4G;
	Thu, 17 Jul 2025 08:12:21 +0000 (GMT)
Received: from epcas1p3.samsung.com (unknown [182.195.36.223]) by
	epsnrtp02.localdomain (Postfix) with ESMTP id 4bjQdK1YnNz2SSKX; Thu, 17 Jul
	2025 08:12:21 +0000 (GMT)
Received: from epsmtip1.samsung.com (unknown [182.195.34.30]) by
	epcas1p2.samsung.com (KnoxPortal) with ESMTPA id
	20250717081220epcas1p224952b344389e4967beb893297f1ae02~S_7CMUyfQ2346023460epcas1p25;
	Thu, 17 Jul 2025 08:12:20 +0000 (GMT)
Received: from sh043lee-960XFH.. (unknown [10.253.98.183]) by
	epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
	20250717081220epsmtip1f52df09778fe4c34b224d21c4dd455ae~S_7CJlsHU0463304633epsmtip1J;
	Thu, 17 Jul 2025 08:12:20 +0000 (GMT)
From: Seunghui Lee <sh043.lee@samsung.com>
To: alim.akhtar@samsung.com, avri.altman@wdc.com, bvanassche@acm.org,
	James.Bottomley@HansenPartnership.com, martin.petersen@oracle.com,
	linux-scsi@vger.kernel.org, sdriver.sec@samsung.com
Cc: Seunghui Lee <sh043.lee@samsung.com>
Subject: [PATCH v2] ufs: core: Use link recovery when the h8 exit failure
 during runtime resume
Date: Thu, 17 Jul 2025 17:12:13 +0900
Message-ID: <20250717081213.6811-1-sh043.lee@samsung.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CMS-MailID: 20250717081220epcas1p224952b344389e4967beb893297f1ae02
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
CMS-TYPE: 101P
cpgsPolicy: CPGSC10-711,Y
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20250717081220epcas1p224952b344389e4967beb893297f1ae02
References: <CGME20250717081220epcas1p224952b344389e4967beb893297f1ae02@epcas1p2.samsung.com>

If the h8 exit fails during runtime resume process,
the runtime thread enters runtime suspend immediately
and the error handler operates at the same time.
It becomes stuck and cannot be recovered through the error handler.
To fix this, use link recovery instead of the error handler.

Fixes: 4db7a2360597 ("scsi: ufs: Fix concurrency of error handler and other error recovery paths")
Signed-off-by: Seunghui Lee <sh043.lee@samsung.com>
---
Changes from v1:
 * Add the Fixes tag as Beanhuo's requested.
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

