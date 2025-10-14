Received: from 004.mia.mailroute.net (004.mia.mailroute.net [199.89.3.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DFE142BE02A
	for <linux-scsi@vger.kernel.org>; Tue, 14 Oct 2025 20:19:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760473158; cv=none; b=NsqxUfKAnGUcRt3PQ8gFo0mi9NRPZ2QL75oHT5wlD9HxosWWBlGv+N9iSx8cDNw7V+yttTwFKWI9t+nnqya2G6S+TtwJHI8+BEU4WYgPVJIIp9bS3ZPfOfgLDanGXACX3+NDRjSQ7HtOo6AvcxAPahz0JCPVlGALDm6NlPGJstk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760473158; c=relaxed/simple;
	bh=zAdb2YMIfM3cnzOisLZOzfH32fJUacS2CcBTfWvPyf8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=m6q+bD1KBR5iAceKoUT5vax5rxqyS4FicVgHTpj6lwA3Omh9BRU5rAIN8OpUmMPNsH6PGUDWfM6bM0bY0WIF4TTGDb8mDd+r9pr20n+rQVDkrJs/Rw2sII3vCaNkdNk4bnj6LsyrPf4dwLAjW/lwZfD4MW+8ZFQnMNDMq+3y+8w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=adHHwb9L; arc=none smtp.client-ip=199.89.3.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="adHHwb9L"
Received: from localhost (localhost [127.0.0.1])
	by 004.mia.mailroute.net (Postfix) with ESMTP id 4cmQY0030Bzm0yVJ;
	Tue, 14 Oct 2025 20:19:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1760473154; x=1763065155; bh=gXJfr
	O4uWgWWyTsGZCzv79VV9DMKHqHVr1Q4AY8x09c=; b=adHHwb9LjdUiKRaU8qeQR
	9frcqqXFiiESxU1DoMa7B9amby1/f8fdYQNh9saIQoBHX56JqBAbqdRRpXpmDNcd
	wXdYKH5L4SWsqOt5drwRpSVCuHJdxARfj1ClmV+rVds+RDe3jaseSnzTY4vWZSgA
	sXio4gb8tnV0cIJRDigi930UbxXXx/+u4c3mEAVKpK7ViZcvBCJcI/z2/Ob0Hk5s
	/5aEYR6Q6fT/McghteJPDScSuTrokgEt6hxR4PLafYvTAoPBZk4RJPUQSEEmGIVn
	hhEt/b5UOaXMy43BGN+SGuPoPBWRe9Ky3QcPNDS2HpM+ec3qoViOlqSEX9vzH2iz
	A==
X-Virus-Scanned: by MailRoute
Received: from 004.mia.mailroute.net ([127.0.0.1])
 by localhost (004.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id f3BWG8L9FNcR; Tue, 14 Oct 2025 20:19:14 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.180.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 004.mia.mailroute.net (Postfix) with ESMTPSA id 4cmQXq2hmVzm0yVM;
	Tue, 14 Oct 2025 20:19:06 +0000 (UTC)
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
Subject: [PATCH v6 11/28] ufs: core: Change the type of one ufshcd_add_command_trace() argument
Date: Tue, 14 Oct 2025 13:15:53 -0700
Message-ID: <20251014201707.3396650-12-bvanassche@acm.org>
X-Mailer: git-send-email 2.51.0.788.g6d19910ace-goog
In-Reply-To: <20251014201707.3396650-1-bvanassche@acm.org>
References: <20251014201707.3396650-1-bvanassche@acm.org>
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
index 0d57deb9b724..88c2625dcaae 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -473,7 +473,7 @@ static void ufshcd_add_uic_command_trace(struct ufs_h=
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
@@ -481,9 +481,9 @@ static void ufshcd_add_command_trace(struct ufs_hba *=
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
@@ -501,7 +501,7 @@ static void ufshcd_add_command_trace(struct ufs_hba *=
hba, unsigned int tag,
 		       be32_to_cpu(lrbp->ucd_req_ptr->sc.exp_data_transfer_len);
 		lba =3D scsi_get_lba(cmd);
 		if (opcode =3D=3D WRITE_10)
-			group_id =3D lrbp->cmd->cmnd[6];
+			group_id =3D cmd->cmnd[6];
 	} else if (opcode =3D=3D UNMAP) {
 		/*
 		 * The number of Bytes to be unmapped beginning with the lba.
@@ -2366,7 +2366,7 @@ void ufshcd_send_command(struct ufs_hba *hba, unsig=
ned int task_tag,
 		lrbp->compl_time_stamp_local_clock =3D 0;
 	}
 	if (lrbp->cmd) {
-		ufshcd_add_command_trace(hba, task_tag, UFS_CMD_SEND);
+		ufshcd_add_command_trace(hba, lrbp->cmd, UFS_CMD_SEND);
 		ufshcd_clk_scaling_start_busy(hba);
 	}
 	if (unlikely(ufshcd_should_inform_monitor(hba, lrbp)))
@@ -5638,7 +5638,7 @@ void ufshcd_compl_one_cqe(struct ufs_hba *hba, int =
task_tag,
 	if (cmd) {
 		if (unlikely(ufshcd_should_inform_monitor(hba, lrbp)))
 			ufshcd_update_monitor(hba, lrbp);
-		ufshcd_add_command_trace(hba, task_tag, UFS_CMD_COMP);
+		ufshcd_add_command_trace(hba, cmd, UFS_CMD_COMP);
 		cmd->result =3D ufshcd_transfer_rsp_status(hba, lrbp, cqe);
 		ufshcd_release_scsi_cmd(hba, lrbp);
 		/* Do not touch lrbp after scsi done */
