Received: from 004.mia.mailroute.net (004.mia.mailroute.net [199.89.3.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 144502E62DA
	for <linux-scsi@vger.kernel.org>; Thu,  3 Apr 2025 21:21:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743715269; cv=none; b=f09vcxqUeQlNCjRlf8EPzymQ4yRxBUrjVODBF/ks/r0NOWsSAHO3TUAVZ1NMxagaHA1D9XL+LcJQ0bz3YPcbPk+T0pM6WKNsjzVvP6H8DJJWnckmViks/JlxB/v3g7pXIsovb8wTenCjtoMxUxnp4F1ToVQMjmVQ/toJ2Ac9iNE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743715269; c=relaxed/simple;
	bh=1CQF/Yr2LiS210mPVuJd9YF8MZ0/9HdXQ3I0AbFmnCg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=p/rDm8ijMFglxFXTsEloDSHIThHZIu3P3CnpZQZv0thqtUSZQsw1Ja1TTCAlYUVr4oj0o/K8qMMza7+wD/wyR3ibaW0omO3XVjLM8M9GWmTG/4Ajt8il2nLCZbLOqw/qNN+4KVq5GuHuahvZnEl+LTQx0x0WOs4hYjLPMOSNCTw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=WHobIDOH; arc=none smtp.client-ip=199.89.3.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="WHobIDOH"
Received: from localhost (localhost [127.0.0.1])
	by 004.mia.mailroute.net (Postfix) with ESMTP id 4ZTF5v0N4czm0pKW;
	Thu,  3 Apr 2025 21:21:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1743715265; x=1746307266; bh=PIbA4
	uHKBEt4P5SmGhUS3s16eIDf/h/Ll1WmdcSigS4=; b=WHobIDOHJdLF0+gT05b3v
	IHWDQemEE0hoDW9iT8qckz/cKRfGNg9yo9y/udPMC71BaKB1US4XxEzw80P6qNos
	CpBu1kO/PJWPm32d2G4DyYszSQgDCX1sDrPThphrsP9iMsqVwas2zShwVq1+khN5
	1LIE6HTThbXXkSwhfcMLaCV51Dz0uQ/JpCAf21p5WN4E8zhzyOL/1tgkg9ocezsd
	1d3aWKgATeGvfJJvoBptHq3SbB1EVXqZCPOAxI7Ik02y16Ku9bdVRkAcxuZIhTdv
	k0g2+TYECqFutrXIVvJv3P+302hSUKJMAW+VdXTZvBn+USw9fRfd4mTg6Vm/g+J0
	w==
X-Virus-Scanned: by MailRoute
Received: from 004.mia.mailroute.net ([127.0.0.1])
 by localhost (004.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id fwSc-KznIfrp; Thu,  3 Apr 2025 21:21:05 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 004.mia.mailroute.net (Postfix) with ESMTPSA id 4ZTF5l3dzmzm0yVW;
	Thu,  3 Apr 2025 21:20:58 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	Peter Wang <peter.wang@mediatek.com>,
	Avri Altman <avri.altman@wdc.com>,
	Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
	"Bao D. Nguyen" <quic_nguyenb@quicinc.com>
Subject: [PATCH 09/24] scsi: ufs: core: Change the type of one ufshcd_send_command() argument
Date: Thu,  3 Apr 2025 14:17:53 -0700
Message-ID: <20250403211937.2225615-10-bvanassche@acm.org>
X-Mailer: git-send-email 2.49.0.504.g3bcea36a83-goog
In-Reply-To: <20250403211937.2225615-1-bvanassche@acm.org>
References: <20250403211937.2225615-1-bvanassche@acm.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable

Change the 'task_tag' argument into an LRB pointer. This patch prepares
for the removal of the hba->lrb[] array.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/ufs/core/ufshcd.c | 13 ++++++-------
 1 file changed, 6 insertions(+), 7 deletions(-)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index f87526443d8d..883551274330 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -2292,14 +2292,13 @@ static void ufshcd_update_monitor(struct ufs_hba =
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
 	lrbp->issue_time_stamp =3D ktime_get();
@@ -3029,7 +3028,7 @@ static int ufshcd_queuecommand(struct Scsi_Host *ho=
st, struct scsi_cmnd *cmd)
 	if (hba->mcq_enabled)
 		hwq =3D ufshcd_mcq_req_to_hwq(hba, scsi_cmd_to_rq(cmd));
=20
-	ufshcd_send_command(hba, tag, hwq);
+	ufshcd_send_command(hba, lrbp, hwq);
=20
 out:
 	if (ufs_trigger_eh(hba)) {
@@ -3263,7 +3262,7 @@ static int ufshcd_issue_dev_cmd(struct ufs_hba *hba=
, struct ufshcd_lrb *lrbp,
 	int err;
=20
 	ufshcd_add_query_upiu_trace(hba, UFS_QUERY_SEND, lrbp->ucd_req_ptr);
-	ufshcd_send_command(hba, tag, hba->dev_cmd_queue);
+	ufshcd_send_command(hba, lrbp, hba->dev_cmd_queue);
 	err =3D ufshcd_wait_for_dev_cmd(hba, lrbp, timeout);
=20
 	ufshcd_add_query_upiu_trace(hba, err ? UFS_QUERY_ERR : UFS_QUERY_COMP,
