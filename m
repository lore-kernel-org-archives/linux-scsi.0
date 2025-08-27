Received: from 004.mia.mailroute.net (004.mia.mailroute.net [199.89.3.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D38E93C0C
	for <linux-scsi@vger.kernel.org>; Wed, 27 Aug 2025 00:09:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756253398; cv=none; b=YGsuklfu0/htVEkReYegkwHMU+4nnz7tt4g7kWX+Od3to++eMNrHaAp3rVqyBekmh+f/CEBLNgB+0O8LAndT0uRkZGokvg6rDEMsIFQj0zvJ0FVL9W64e85TX2Mc3a0pFj+/gEzm78cciuSNgt7BKKsp9RpnpCJePbaBxMpmDg8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756253398; c=relaxed/simple;
	bh=NHkdUP0IcFtQsIg4yBgl1GRFi0/SNdcvnMFQCnQx6SE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UjjpHVT4JAdvdxl5+SXwXiNX2+9dpI5lCL+3brUYZlOZ2lWoCmVjVjwYyGpe7eQI97HHcEIhU+FBANaYe+g5zux9AU8Wq3AADpoxweLazntfUP5MMMTttNdvi3PtsOYvMpcmWsLsHfYeTfV126fAAegHeeTiJsAfQJb3v8fQ/+s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=hH9NS2Im; arc=none smtp.client-ip=199.89.3.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="hH9NS2Im"
Received: from localhost (localhost [127.0.0.1])
	by 004.mia.mailroute.net (Postfix) with ESMTP id 4cBPzm1WHrzm0yVM;
	Wed, 27 Aug 2025 00:09:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1756253394; x=1758845395; bh=QSKJL
	jSg7Ih9gqOOjTsutK4snDAgKJqO+nq8udFOGN0=; b=hH9NS2ImWuE27ksgh6cgF
	tCRmOQhwP5BMG8zfXs5lZqh3KLjGaXedoUyv1FBH2ZzVP9EmqMkkJ07hMMSStyQF
	+1E3LgKDtgrnVaGjikk5I+eFdImn0jCgwFAoP0i/H3xQs+sSkMmoxQkoQiVnXB7B
	Xo2ybwEYNA8eiLNtMTSzrb443NZsXisbGkLC7tPhPQjKkGPnN2FwyimzfB2y7RlP
	UKxjsqWEL91EaUXDlUajzUv/ffXjEFS/Zf/ZwEA/Pn4LyBs7VStau53TCsTU+kaS
	N5W+9JmXVJcDe81NHS35Y+NayztydWeobB+AxAn2IGyfeqhTUp/ydcpT7t3Z4jp4
	Q==
X-Virus-Scanned: by MailRoute
Received: from 004.mia.mailroute.net ([127.0.0.1])
 by localhost (004.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id 9hNtThK4Jvp6; Wed, 27 Aug 2025 00:09:54 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 004.mia.mailroute.net (Postfix) with ESMTPSA id 4cBPzc0x4Wzm0ysy;
	Wed, 27 Aug 2025 00:09:47 +0000 (UTC)
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
Subject: [PATCH v3 10/26] ufs: core: Change the type of one ufshcd_add_command_trace() argument
Date: Tue, 26 Aug 2025 17:06:14 -0700
Message-ID: <20250827000816.2370150-11-bvanassche@acm.org>
X-Mailer: git-send-email 2.51.0.261.g7ce5a0a67e-goog
In-Reply-To: <20250827000816.2370150-1-bvanassche@acm.org>
References: <20250827000816.2370150-1-bvanassche@acm.org>
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
index 3511e2d594c6..0ef3409d6230 100644
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
@@ -2363,7 +2363,7 @@ void ufshcd_send_command(struct ufs_hba *hba, unsig=
ned int task_tag,
 		lrbp->compl_time_stamp_local_clock =3D 0;
 	}
 	if (lrbp->cmd) {
-		ufshcd_add_command_trace(hba, task_tag, UFS_CMD_SEND);
+		ufshcd_add_command_trace(hba, lrbp->cmd, UFS_CMD_SEND);
 		ufshcd_clk_scaling_start_busy(hba);
 	}
 	if (unlikely(ufshcd_should_inform_monitor(hba, lrbp)))
@@ -5630,7 +5630,7 @@ void ufshcd_compl_one_cqe(struct ufs_hba *hba, int =
task_tag,
 	if (cmd) {
 		if (unlikely(ufshcd_should_inform_monitor(hba, lrbp)))
 			ufshcd_update_monitor(hba, lrbp);
-		ufshcd_add_command_trace(hba, task_tag, UFS_CMD_COMP);
+		ufshcd_add_command_trace(hba, cmd, UFS_CMD_COMP);
 		cmd->result =3D ufshcd_transfer_rsp_status(hba, lrbp, cqe);
 		ufshcd_release_scsi_cmd(hba, lrbp);
 		/* Do not touch lrbp after scsi done */
