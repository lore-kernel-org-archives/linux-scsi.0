Received: from 004.mia.mailroute.net (004.mia.mailroute.net [199.89.3.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE9D21A5B9D
	for <linux-scsi@vger.kernel.org>; Thu,  3 Apr 2025 21:20:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743715259; cv=none; b=Hm66VhxFzIzFBG+um7+sI6q3p/LZGeQz2IuaMmqCGcOMaVCjzDVwWtgy3/uMum5TzTKQiV3QbRrXJh6PYMnxlt/DsGPcuWLCcxSKIxZ5aRQ6P4BwvzwBdCNGcumQtfEML4ZWDPNWNHH90S/WBMi7rj9QgnqIGCWojgLEkaW7NTQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743715259; c=relaxed/simple;
	bh=ZfTVCKNnSI2ZxYj0aQOY5jbnFaipyxJcAKMQfZoSDT8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WHGYTL5vYvRYkGDpfVchg6CyRdJ6ZgMBTftmcMTOcTbPcBsYOyfCv9dvx5n7qKyQ0xJ1VWE0k4lstKf+QMx9vtJ/RWZLaCDdKtjU5q7LLAVn/azpWM1d9cxtrNJaQOOhCBCkBHIxo9QqH5xSPh2OZCjFwzlgTn44OFePPTbV3ZQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=TD9MGtuL; arc=none smtp.client-ip=199.89.3.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="TD9MGtuL"
Received: from localhost (localhost [127.0.0.1])
	by 004.mia.mailroute.net (Postfix) with ESMTP id 4ZTF5h6K3Xzm2bhF;
	Thu,  3 Apr 2025 21:20:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1743715255; x=1746307256; bh=nmZim
	V+MUgeBGJkCLra/6DkBWtm8nL3e7obXmRzOfCo=; b=TD9MGtuLdSG7mEIVgXuuX
	rFFIVtB+DMVyJacYaJ6QcSUZdjn5kllZlQajiEd5Sw/NNqMOXcDa2AZExRNgzd6M
	9+yJWwqQ4fuKZ+PodJqLHtnQ9HL7crjVdAjOPCh+7Hp6CTlatSJLwcnkdgJkkd8x
	tESL8xmEr8f4cGvP8KM8Q4sxkm2SNeIPBAyp0sWc7lFRdIrRhChBvM4OGb39QaQN
	u9Aq7hg5ypvVioZUMLofu8C+DB2Ny7saqddX/Sq1xfoI2vwW0/BvszSV99EIyTmh
	zmCSRzz4mJ6hcCQkj3tMy4/bFu3B1iZdZ09b4ec79L3WPSVvz7kbtmiXmC/aP3B2
	A==
X-Virus-Scanned: by MailRoute
Received: from 004.mia.mailroute.net ([127.0.0.1])
 by localhost (004.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id FDvojVFzEsot; Thu,  3 Apr 2025 21:20:55 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 004.mia.mailroute.net (Postfix) with ESMTPSA id 4ZTF5X5fqgzm0yV3;
	Thu,  3 Apr 2025 21:20:48 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	Peter Wang <peter.wang@mediatek.com>,
	Avri Altman <avri.altman@wdc.com>,
	Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
	"Bao D. Nguyen" <quic_nguyenb@quicinc.com>
Subject: [PATCH 08/24] scsi: ufs: core: Change the type of one ufshcd_add_command_trace() argument
Date: Thu,  3 Apr 2025 14:17:52 -0700
Message-ID: <20250403211937.2225615-9-bvanassche@acm.org>
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

Change the 'tag' argument into a SCSI command pointer. This patch prepare=
s
for the removal of the hba->lrb[] array.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/ufs/core/ufshcd.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index 94cf864ac62b..f87526443d8d 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -425,7 +425,7 @@ static void ufshcd_add_uic_command_trace(struct ufs_h=
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
@@ -433,9 +433,9 @@ static void ufshcd_add_command_trace(struct ufs_hba *=
hba, unsigned int tag,
 	u32 doorbell =3D 0;
 	u32 intr;
 	int hwq_id =3D -1;
-	struct ufshcd_lrb *lrbp =3D &hba->lrb[tag];
-	struct scsi_cmnd *cmd =3D lrbp->cmd;
 	struct request *rq =3D scsi_cmd_to_rq(cmd);
+	unsigned int tag =3D rq->tag;
+	struct ufshcd_lrb *lrbp =3D &hba->lrb[tag];
 	int transfer_len =3D -1;
=20
 	/* trace UPIU also */
@@ -453,7 +453,7 @@ static void ufshcd_add_command_trace(struct ufs_hba *=
hba, unsigned int tag,
 		       be32_to_cpu(lrbp->ucd_req_ptr->sc.exp_data_transfer_len);
 		lba =3D scsi_get_lba(cmd);
 		if (opcode =3D=3D WRITE_10)
-			group_id =3D lrbp->cmd->cmnd[6];
+			group_id =3D cmd->cmnd[6];
 	} else if (opcode =3D=3D UNMAP) {
 		/*
 		 * The number of Bytes to be unmapped beginning with the lba.
@@ -2307,7 +2307,7 @@ void ufshcd_send_command(struct ufs_hba *hba, unsig=
ned int task_tag,
 	lrbp->compl_time_stamp =3D ktime_set(0, 0);
 	lrbp->compl_time_stamp_local_clock =3D 0;
 	if (lrbp->cmd) {
-		ufshcd_add_command_trace(hba, task_tag, UFS_CMD_SEND);
+		ufshcd_add_command_trace(hba, lrbp->cmd, UFS_CMD_SEND);
 		ufshcd_clk_scaling_start_busy(hba);
 	}
 	if (unlikely(ufshcd_should_inform_monitor(hba, lrbp)))
@@ -5564,7 +5564,7 @@ void ufshcd_compl_one_cqe(struct ufs_hba *hba, int =
task_tag,
 	if (cmd) {
 		if (unlikely(ufshcd_should_inform_monitor(hba, lrbp)))
 			ufshcd_update_monitor(hba, lrbp);
-		ufshcd_add_command_trace(hba, task_tag, UFS_CMD_COMP);
+		ufshcd_add_command_trace(hba, cmd, UFS_CMD_COMP);
 		cmd->result =3D ufshcd_transfer_rsp_status(hba, lrbp, cqe);
 		ufshcd_release_scsi_cmd(hba, lrbp);
 		/* Do not touch lrbp after scsi done */
