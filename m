Received: from 003.mia.mailroute.net (003.mia.mailroute.net [199.89.3.6])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 595CA3009D5
	for <linux-scsi@vger.kernel.org>; Fri, 12 Sep 2025 18:26:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.6
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757701579; cv=none; b=I4v7uRnuRYI5BZKu4uIDNw/gpHPfwBCyKJCPJNOuA7PKi4uZ+UCFuMwnAoJbBhW0LqtMBam3FfI4j/Q7sTgw36wtyoxxEXJWggWgiy8zs8XFEbASEKstSpakObhCZ2Kkp7R3Zf5an5S0x6J09DV3PwdcULngZsDAIlknlLSvR58=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757701579; c=relaxed/simple;
	bh=0znlOhB13ndKfCRZxayLFSoLLX60icCnlhq8f4nw7jo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jfY3zo4obYA20cUp+D1ZaXi4URVoda/+b55GFs9+Tf1Y6fTcyQt6MnGK9JKjZiUzt/RLXC/cIdIgMt4L2yT2s9+Y5tlI8cTSFzDkMCc3P1fgVqcY5IJNFTFc+Ktfk51XA+S0hm/qH5mBiby5zMoZg9qmCDGGxiBCNtDFS6G2LM0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=3Jd5WKTf; arc=none smtp.client-ip=199.89.3.6
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="3Jd5WKTf"
Received: from localhost (localhost [127.0.0.1])
	by 003.mia.mailroute.net (Postfix) with ESMTP id 4cNjYK4prpzlgqVx;
	Fri, 12 Sep 2025 18:26:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1757701571; x=1760293572; bh=r8zus
	MCbcpsPvTXC8YfzzAULUAO9l16S2NgtGxsdfFM=; b=3Jd5WKTfcMLAE2CDTJEwP
	ioROiXlgGuf2g44VUMrcXNWezB1qpRWv7hO0Fr+9S4kejeTph6xpSWg4PjhT6au5
	zjMAAc4zXgAqcJcM0JTWlzj1E4/X5jfqNsQwTsvjDvHDISFV4l1wTvoyrrs0r0dI
	yrFLcZHk8CmmmRM7MoyGYxNX6ZpSklsN/RsCBYCTht23KecLpTIoHjViXtmFAakU
	mApPuMWnVwErNrf20e9AjNKLUT0xV2ZNligCjRruMdC5SCWyyH8G1Lu8S29UyZhQ
	BelplmGwoTWHunpNUTBKRyGxocSZ7TLyIztysm7ps5d4kHx5r5+0fMgWQ/2SYu/B
	A==
X-Virus-Scanned: by MailRoute
Received: from 003.mia.mailroute.net ([127.0.0.1])
 by localhost (003.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id amNO52WLlG9D; Fri, 12 Sep 2025 18:26:11 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 003.mia.mailroute.net (Postfix) with ESMTPSA id 4cNjY95FF7zlgqVJ;
	Fri, 12 Sep 2025 18:26:04 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>,
	Avri Altman <avri.altman@sandisk.com>,
	Peter Wang <peter.wang@mediatek.com>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	Matthias Brugger <matthias.bgg@gmail.com>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Bean Huo <beanhuo@micron.com>
Subject: [PATCH v4 12/29] ufs: core: Change the type of one ufshcd_send_command() argument
Date: Fri, 12 Sep 2025 11:21:33 -0700
Message-ID: <20250912182340.3487688-13-bvanassche@acm.org>
X-Mailer: git-send-email 2.51.0.384.g4c02a37b29-goog
In-Reply-To: <20250912182340.3487688-1-bvanassche@acm.org>
References: <20250912182340.3487688-1-bvanassche@acm.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable

Change the 'task_tag' argument into an LRB pointer. This patch prepares
for the removal of the hba->lrb[] array.

Reviewed-by: Avri Altman <avri.altman@sandisk.com>
Reviewed-by: Peter Wang <peter.wang@mediatek.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/ufs/core/ufshcd.c | 13 ++++++-------
 1 file changed, 6 insertions(+), 7 deletions(-)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index a87983dde5cd..eb2c6fe5e7ea 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -2346,14 +2346,13 @@ static void ufshcd_update_monitor(struct ufs_hba =
*hba, const struct ufshcd_lrb *
 /**
  * ufshcd_send_command - Send SCSI or device management commands
  * @hba: per adapter instance
- * @task_tag: Task tag of the command
+ * @lrbp: Local reference block of SCSI command
  * @hwq: pointer to hardware queue instance
  */
-static inline
-void ufshcd_send_command(struct ufs_hba *hba, unsigned int task_tag,
-			 struct ufs_hw_queue *hwq)
+static inline void ufshcd_send_command(struct ufs_hba *hba,
+				       struct ufshcd_lrb *lrbp,
+				       struct ufs_hw_queue *hwq)
 {
-	struct ufshcd_lrb *lrbp =3D &hba->lrb[task_tag];
 	unsigned long flags;
=20
 	if (hba->monitor.enabled) {
@@ -3062,7 +3061,7 @@ static int ufshcd_queuecommand(struct Scsi_Host *ho=
st, struct scsi_cmnd *cmd)
 	if (hba->mcq_enabled)
 		hwq =3D ufshcd_mcq_req_to_hwq(hba, scsi_cmd_to_rq(cmd));
=20
-	ufshcd_send_command(hba, tag, hwq);
+	ufshcd_send_command(hba, lrbp, hwq);
=20
 out:
 	if (ufs_trigger_eh(hba)) {
@@ -3307,7 +3306,7 @@ static int ufshcd_issue_dev_cmd(struct ufs_hba *hba=
, struct ufshcd_lrb *lrbp,
 	int err;
=20
 	ufshcd_add_query_upiu_trace(hba, UFS_QUERY_SEND, lrbp->ucd_req_ptr);
-	ufshcd_send_command(hba, tag, hba->dev_cmd_queue);
+	ufshcd_send_command(hba, lrbp, hba->dev_cmd_queue);
 	err =3D ufshcd_wait_for_dev_cmd(hba, lrbp, timeout);
=20
 	ufshcd_add_query_upiu_trace(hba, err ? UFS_QUERY_ERR : UFS_QUERY_COMP,
