Received: from 003.mia.mailroute.net (003.mia.mailroute.net [199.89.3.6])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C37F3009D5
	for <linux-scsi@vger.kernel.org>; Fri, 12 Sep 2025 18:26:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.6
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757701565; cv=none; b=FFrrJ9dXwnFaYuYhQUUpMLaLRUKRmKdrAssqmoIJqfXtk800NlbtzQ72X5EMxsYsChb5wUGTDhIjr1jvN55f0tCK4UVs7+Xv4W31Y98BsYLfjRd/1Zo//d52X1dEGbunXHnJzu92XoUMebLVjvISOwKf8hg8siZv74Su1Oi2kls=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757701565; c=relaxed/simple;
	bh=3b3Ow4GPUAbpidXoGcAhDy2mIe7hMP2QhMUbYTt5PYE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=o4yUvc82O6b7mQ754fkHbSlJ7uwFi7mi0Ct0eOp0y39n6b0eRL1UrL3ei1WFPJQgR3/2tdJoxD46hrEBTDEg43GHra6m9Way5R+gkzEhaAxpioA6S28lTo29356LX9Udl5JBF9ZxvUi+dKF5cpJigdP691yj/720PPSvrZ6w5jQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=aHAOhzS9; arc=none smtp.client-ip=199.89.3.6
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="aHAOhzS9"
Received: from localhost (localhost [127.0.0.1])
	by 003.mia.mailroute.net (Postfix) with ESMTP id 4cNjY71HBTzlgqVx;
	Fri, 12 Sep 2025 18:26:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1757701561; x=1760293562; bh=il0MX
	PaGD2d20qr9qcbQctcAjJAaGAhTnIABBmTpaBk=; b=aHAOhzS9ktDIqtF7g4Mxe
	AgHALejqrEm67WaJEuPsgfhAdy7gRdFM8jLcmyY77mttPgoolnes0XYdnpakRGbL
	CTIfR0AfaWBOoa/bjyQVdwZPgxyMtrP2gserUx0F5mAvXRSMwsb6jUZ+bHWF/VQZ
	yh3VnuJ66LsGjKMgsPsaRiBlPxLKxRa163Gs2EedKp/pUbLfTbj530SM24EaqyX6
	Ex12EO1jT9z5mMgr/8NaI6fbqMbGoijS70yDZ+vmCBLllI3H0gwum6PKPsxH7Sv5
	y9T2VPewAAxl5vp66dJGnOX+YxKtojFiSs3iqsGQ+WDl0aIbLwyj2FDFlPJMYfM8
	A==
X-Virus-Scanned: by MailRoute
Received: from 003.mia.mailroute.net ([127.0.0.1])
 by localhost (003.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id Sq16B4Jt7VeZ; Fri, 12 Sep 2025 18:26:01 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 003.mia.mailroute.net (Postfix) with ESMTPSA id 4cNjXz6qSJzlgqVJ;
	Fri, 12 Sep 2025 18:25:55 +0000 (UTC)
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
Subject: [PATCH v4 11/29] ufs: core: Change the type of one ufshcd_add_command_trace() argument
Date: Fri, 12 Sep 2025 11:21:32 -0700
Message-ID: <20250912182340.3487688-12-bvanassche@acm.org>
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
index 2b14d1510d92..a87983dde5cd 100644
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
