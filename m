Received: from 003.mia.mailroute.net (003.mia.mailroute.net [199.89.3.6])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 338802D3A71
	for <linux-scsi@vger.kernel.org>; Mon, 11 Aug 2025 17:40:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.6
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754934051; cv=none; b=Xg/VwIvqIsRYRQPxzcQ5wE85mdhauE13WgrkNoRQM32ZWwf8875szDj0cLXwzCRF//cYC1VXvRgBefg3xiE8diKO8zpHbqFF5f4Aj4vXCei6STiEK55zWSRaYo4QZUB+Bw3bzIOAcV3S1qexGQxwDLAEINO6pijiZgn/5czl3GE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754934051; c=relaxed/simple;
	bh=IIaNYK0vGTDixLO8CghdNXxX8Rr92LC0/jOrWo7QFFo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TKs2ArPKJleOMAO40lT+PXRejyF2iO7qDZHUC865QkZwoQ8YEvVITj6WEo+1Lb581bPdU+6j6zclj2e13CNRo0O6nuCAe2lnQQNE4HmOfLWhM26q+WOYb5trhH2jDr65P61ROXO2oxHEKtHWFJ5s4dtmDBbWoVmlZ+Y46YNo0N4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=KBcrNVh+; arc=none smtp.client-ip=199.89.3.6
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="KBcrNVh+"
Received: from localhost (localhost [127.0.0.1])
	by 003.mia.mailroute.net (Postfix) with ESMTP id 4c123j3hMyzlgqTr;
	Mon, 11 Aug 2025 17:40:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1754934047; x=1757526048; bh=Dg/Uo
	WKc5Z19JL9vqxAfqtXBxPm/XItQMdP6rscoQww=; b=KBcrNVh+HRiZ3QIRweHaN
	WwRnRI6UnTM6Mmxd2tH8lI8gfDsQSxbiR2orFskZgunzOvGLBighLRf2S4oBfBQM
	LzvfZZIz0tjB+UiCl0pWayGRpV9X37B2XFBglhrZKkN5ZzQzyFVLFNt2Gb7xJyJT
	agrkQVqd7hqR5ug5TbrEpyo5ucIUUcTutYr+eOTyAha2SBIMpnWVzmuHHY33MAaR
	Ubtj/WbrzqkD8r9IyethGpzQLpJrw8wf0xYxEdJfNdvpY8JntkI9klizE+ptRvWc
	sCxeopx3nEaz2IkNjqoiyq1XWLm01Jq43aFkkr6kr4ertJJl69VUDNQCW0Ud9Tkk
	g==
X-Virus-Scanned: by MailRoute
Received: from 003.mia.mailroute.net ([127.0.0.1])
 by localhost (003.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id Q40z1r4Qpohl; Mon, 11 Aug 2025 17:40:47 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 003.mia.mailroute.net (Postfix) with ESMTPSA id 4c123b4gRnzlgqTq;
	Mon, 11 Aug 2025 17:40:42 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	Peter Wang <peter.wang@mediatek.com>,
	Avri Altman <avri.altman@sandisk.com>,
	Bean Huo <beanhuo@micron.com>
Subject: [PATCH v2 22/30] ufs: core: Call ufshcd_init_lrb() later
Date: Mon, 11 Aug 2025 10:34:34 -0700
Message-ID: <20250811173634.514041-23-bvanassche@acm.org>
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

Call ufshcd_init_lrb() from inside ufshcd_setup_dev_cmd() instead of
ufshcd_host_memory_configure(). This patch prepares for calling
ufshcd_host_memory_configure() before the information is available
that is required to call ufshcd_setup_dev_cmd().

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/ufs/core/ufshcd.c | 53 ++++++++++++++++++++-------------------
 1 file changed, 27 insertions(+), 26 deletions(-)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index 27140432d737..a932f62c5c2c 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -2894,8 +2894,32 @@ static void ufshcd_comp_scsi_upiu(struct ufs_hba *=
hba, struct ufshcd_lrb *lrbp)
 	ufshcd_prepare_utp_scsi_cmd_upiu(lrbp, upiu_flags);
 }
=20
-static void __ufshcd_setup_cmd(struct ufshcd_lrb *lrbp, struct scsi_cmnd=
 *cmd, u8 lun, int tag)
+static void ufshcd_init_lrb(struct ufs_hba *hba, struct ufshcd_lrb *lrb,=
 int i)
+{
+	struct utp_transfer_cmd_desc *cmd_descp =3D
+		(void *)hba->ucdl_base_addr + i * ufshcd_get_ucd_size(hba);
+	struct utp_transfer_req_desc *utrdlp =3D hba->utrdl_base_addr;
+	dma_addr_t cmd_desc_element_addr =3D
+		hba->ucdl_dma_addr + i * ufshcd_get_ucd_size(hba);
+	u16 response_offset =3D le16_to_cpu(utrdlp[i].response_upiu_offset);
+	u16 prdt_offset =3D le16_to_cpu(utrdlp[i].prd_table_offset);
+
+	lrb->utr_descriptor_ptr =3D utrdlp + i;
+	lrb->utrd_dma_addr =3D
+		hba->utrdl_dma_addr + i * sizeof(struct utp_transfer_req_desc);
+	lrb->ucd_req_ptr =3D (struct utp_upiu_req *)cmd_descp->command_upiu;
+	lrb->ucd_req_dma_addr =3D cmd_desc_element_addr;
+	lrb->ucd_rsp_ptr =3D (struct utp_upiu_rsp *)cmd_descp->response_upiu;
+	lrb->ucd_rsp_dma_addr =3D cmd_desc_element_addr + response_offset;
+	lrb->ucd_prdt_ptr =3D (struct ufshcd_sg_entry *)cmd_descp->prd_table;
+	lrb->ucd_prdt_dma_addr =3D cmd_desc_element_addr + prdt_offset;
+}
+
+static void __ufshcd_setup_cmd(struct ufs_hba *hba, struct ufshcd_lrb *l=
rbp,
+			       struct scsi_cmnd *cmd, u8 lun, int tag)
 {
+	ufshcd_init_lrb(hba, lrbp, tag);
+
 	memset(lrbp->ucd_req_ptr, 0, sizeof(*lrbp->ucd_req_ptr));
=20
 	lrbp->cmd =3D cmd;
@@ -2907,7 +2931,7 @@ static void __ufshcd_setup_cmd(struct ufshcd_lrb *l=
rbp, struct scsi_cmnd *cmd, u
 static void ufshcd_setup_scsi_cmd(struct ufs_hba *hba, struct ufshcd_lrb=
 *lrbp,
 				  struct scsi_cmnd *cmd, u8 lun, int tag)
 {
-	__ufshcd_setup_cmd(lrbp, cmd, lun, tag);
+	__ufshcd_setup_cmd(hba, lrbp, cmd, lun, tag);
 	lrbp->intr_cmd =3D !ufshcd_is_intr_aggr_allowed(hba);
 	lrbp->req_abort_skip =3D false;
=20
@@ -2962,27 +2986,6 @@ static void ufshcd_map_queues(struct Scsi_Host *sh=
ost)
 	}
 }
=20
-static void ufshcd_init_lrb(struct ufs_hba *hba, struct ufshcd_lrb *lrb,=
 int i)
-{
-	struct utp_transfer_cmd_desc *cmd_descp =3D (void *)hba->ucdl_base_addr=
 +
-		i * ufshcd_get_ucd_size(hba);
-	struct utp_transfer_req_desc *utrdlp =3D hba->utrdl_base_addr;
-	dma_addr_t cmd_desc_element_addr =3D hba->ucdl_dma_addr +
-		i * ufshcd_get_ucd_size(hba);
-	u16 response_offset =3D le16_to_cpu(utrdlp[i].response_upiu_offset);
-	u16 prdt_offset =3D le16_to_cpu(utrdlp[i].prd_table_offset);
-
-	lrb->utr_descriptor_ptr =3D utrdlp + i;
-	lrb->utrd_dma_addr =3D hba->utrdl_dma_addr +
-		i * sizeof(struct utp_transfer_req_desc);
-	lrb->ucd_req_ptr =3D (struct utp_upiu_req *)cmd_descp->command_upiu;
-	lrb->ucd_req_dma_addr =3D cmd_desc_element_addr;
-	lrb->ucd_rsp_ptr =3D (struct utp_upiu_rsp *)cmd_descp->response_upiu;
-	lrb->ucd_rsp_dma_addr =3D cmd_desc_element_addr + response_offset;
-	lrb->ucd_prdt_ptr =3D (struct ufshcd_sg_entry *)cmd_descp->prd_table;
-	lrb->ucd_prdt_dma_addr =3D cmd_desc_element_addr + prdt_offset;
-}
-
 /**
  * ufshcd_queuecommand - main entry point for SCSI requests
  * @host: SCSI host pointer
@@ -3075,7 +3078,7 @@ static int ufshcd_queuecommand(struct Scsi_Host *ho=
st, struct scsi_cmnd *cmd)
 static void ufshcd_setup_dev_cmd(struct ufs_hba *hba, struct ufshcd_lrb =
*lrbp,
 			     enum dev_cmd_type cmd_type, u8 lun, int tag)
 {
-	__ufshcd_setup_cmd(lrbp, NULL, lun, tag);
+	__ufshcd_setup_cmd(hba, lrbp, NULL, lun, tag);
 	lrbp->intr_cmd =3D true; /* No interrupt aggregation */
 	hba->dev_cmd.type =3D cmd_type;
 }
@@ -4030,8 +4033,6 @@ static void ufshcd_host_memory_configure(struct ufs=
_hba *hba)
 			utrdlp[i].response_upiu_length =3D
 				cpu_to_le16(ALIGNED_UPIU_SIZE >> 2);
 		}
-
-		ufshcd_init_lrb(hba, &hba->lrb[i], i);
 	}
 }
=20
