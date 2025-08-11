Received: from 003.mia.mailroute.net (003.mia.mailroute.net [199.89.3.6])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4ADC5311C16
	for <linux-scsi@vger.kernel.org>; Mon, 11 Aug 2025 17:38:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.6
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754933922; cv=none; b=rQO2R0dFIqsxUlOkAZci019Up11o2Jjxvs2YeFBvCge7mTCSleEZ8jC8XwbT0lMKYA2xgPoGm+YIkshUu3oFD2caWxB3GJqmUCO3wBq4Acwd0CwYCpkO+MlW+VlZVS8iYSILSGislPBEV99jsbx4nFyAeZQ1rnIZUPW/lSlQrX4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754933922; c=relaxed/simple;
	bh=L9HjE4pCM62mijfU/5SdsA/cL2ybfQcnD9TZIdgzEdk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JGHDC1w4tFAIq9NVJCrg8RhrSuTh9z/ipsOapxum8M/I3KkjIlzdcBwUSdmdygjeR0po27G8dytDrbF0wQyhaHnpgh2OcwhWONZxad3NeVzFxut1+8dOnhwVx2ir8dy36yFTfSOeotuFA1eHhKiYwh8Ns6a50IF714L2uCTTOo4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=yg9LFdSx; arc=none smtp.client-ip=199.89.3.6
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="yg9LFdSx"
Received: from localhost (localhost [127.0.0.1])
	by 003.mia.mailroute.net (Postfix) with ESMTP id 4c121D31t1zlgqV3;
	Mon, 11 Aug 2025 17:38:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1754933918; x=1757525919; bh=xMFPG
	aAfOXgQg5Ftju9PT2cL5avm4J/fZno0DDmlgEA=; b=yg9LFdSxnljWIWRQ+VCIv
	HZphzX7glEihXmNhGdC7FS15j4FMuSKR/9Iy56c4GZCKDBfslLAgqnX8//jUF+Zs
	tMQlagKrHNohEC9RnSyW02LKbq8cjgtbe/io5iLGQ8U5Xl/N8PFClHZmpsIwgjQT
	YZMMAgxxJQsWKMXYLN5WGGPyjZOzwP11/1sj4GnlQhNLpXkvJnIDwMlnAEKgcvSh
	bNqqebqEl5vOSkqU0c90zj6AGZsqYqZ3JFIs4QAtkfB8lXGLOxEbr0+ihhLQFb7U
	AqmgQwER+AzhrOj49/7qzQJAeMSbNDuGiKvSJg9rnBylX/pmuqUaVGHbWiuqJLFl
	g==
X-Virus-Scanned: by MailRoute
Received: from 003.mia.mailroute.net ([127.0.0.1])
 by localhost (003.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id 4NqXLiko1Fdu; Mon, 11 Aug 2025 17:38:38 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 003.mia.mailroute.net (Postfix) with ESMTPSA id 4c1213758fzlsxFX;
	Mon, 11 Aug 2025 17:38:31 +0000 (UTC)
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
Subject: [PATCH v2 10/30] ufs: core: Change the type of one ufshcd_add_command_trace() argument
Date: Mon, 11 Aug 2025 10:34:22 -0700
Message-ID: <20250811173634.514041-11-bvanassche@acm.org>
X-Mailer: git-send-email 2.51.0.rc0.155.g4a0f42376b-goog
In-Reply-To: <20250811173634.514041-1-bvanassche@acm.org>
References: <20250811173634.514041-1-bvanassche@acm.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable

Change the 'tag' argument into a SCSI command pointer. This patch prepare=
s
for the removal of the hba->lrb[] array.

Reviewed-by: Avri Altman <avri.altman@sandisk.com>
Reviewed-by: Peter Wang <peter.wang@mediatek.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/ufs/core/ufshcd.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index 2ee735872e4d..ba9367f748a5 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -475,7 +475,7 @@ static void ufshcd_add_uic_command_trace(struct ufs_h=
ba *hba,
 				 ufshcd_readl(hba, REG_UIC_COMMAND_ARG_3));
 }
=20
-static void ufshcd_add_command_trace(struct ufs_hba *hba, unsigned int t=
ag,
+static void ufshcd_add_command_trace(struct ufs_hba *hba, struct scsi_cm=
nd *cmd,
 				     enum ufs_trace_str_t str_t)
 {
 	u64 lba =3D 0;
@@ -483,9 +483,9 @@ static void ufshcd_add_command_trace(struct ufs_hba *=
hba, unsigned int tag,
 	u32 doorbell =3D 0;
 	u32 intr;
 	u32 hwq_id =3D 0;
-	struct ufshcd_lrb *lrbp =3D &hba->lrb[tag];
-	struct scsi_cmnd *cmd =3D lrbp->cmd;
 	struct request *rq =3D scsi_cmd_to_rq(cmd);
+	unsigned int tag =3D rq->tag;
+	struct ufshcd_lrb *lrbp =3D &hba->lrb[tag];
 	int transfer_len =3D -1;
=20
 	/* trace UPIU also */
@@ -503,7 +503,7 @@ static void ufshcd_add_command_trace(struct ufs_hba *=
hba, unsigned int tag,
 		       be32_to_cpu(lrbp->ucd_req_ptr->sc.exp_data_transfer_len);
 		lba =3D scsi_get_lba(cmd);
 		if (opcode =3D=3D WRITE_10)
-			group_id =3D lrbp->cmd->cmnd[6];
+			group_id =3D cmd->cmnd[6];
 	} else if (opcode =3D=3D UNMAP) {
 		/*
 		 * The number of Bytes to be unmapped beginning with the lba.
@@ -2357,7 +2357,7 @@ void ufshcd_send_command(struct ufs_hba *hba, unsig=
ned int task_tag,
 	lrbp->compl_time_stamp =3D ktime_set(0, 0);
 	lrbp->compl_time_stamp_local_clock =3D 0;
 	if (lrbp->cmd) {
-		ufshcd_add_command_trace(hba, task_tag, UFS_CMD_SEND);
+		ufshcd_add_command_trace(hba, lrbp->cmd, UFS_CMD_SEND);
 		ufshcd_clk_scaling_start_busy(hba);
 	}
 	if (unlikely(ufshcd_should_inform_monitor(hba, lrbp)))
@@ -5627,7 +5627,7 @@ void ufshcd_compl_one_cqe(struct ufs_hba *hba, int =
task_tag,
 	if (cmd) {
 		if (unlikely(ufshcd_should_inform_monitor(hba, lrbp)))
 			ufshcd_update_monitor(hba, lrbp);
-		ufshcd_add_command_trace(hba, task_tag, UFS_CMD_COMP);
+		ufshcd_add_command_trace(hba, cmd, UFS_CMD_COMP);
 		cmd->result =3D ufshcd_transfer_rsp_status(hba, lrbp, cqe);
 		ufshcd_release_scsi_cmd(hba, lrbp);
 		/* Do not touch lrbp after scsi done */
