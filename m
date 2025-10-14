Received: from 004.mia.mailroute.net (004.mia.mailroute.net [199.89.3.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8BCAC2BE02A
	for <linux-scsi@vger.kernel.org>; Tue, 14 Oct 2025 20:20:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760473227; cv=none; b=Ad+/UQfG25HtWzTjkiZ2cWj+nPit2DZf2GIFS3w0WctGWpvpGfVfm48HPzzgPB7Z+3lybhvXt5fFXh6DvofAwwqQ2UHGGLRbaVK79SMQgqoxmpXVeNJ2bjoVINWGIkHtOLVfrTT9fbRTwTMrjkglyvwmNSriRZ/6m4+jsfOP+0E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760473227; c=relaxed/simple;
	bh=BXAx16R4pTw/U3Hqz0t3P+W8Zf83MAnQaB4vsQ57s8c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bVeieG/yHrL/9CC3n6Co5xRkXJnYF2LpBkQUzk+ATKeJthE0R1TGCV2U3+6PWTHOsiT8obXa72Ql2Y6H+vAZRHvjGDUeeMFHL2e5jrFPbm5V0N1fPyHl3yK/Ypl9SvfLPimO9KqttcqjcBU6M039oS2Jb4aU4TFv3Mryboxsa+E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=jUzz2wez; arc=none smtp.client-ip=199.89.3.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="jUzz2wez"
Received: from localhost (localhost [127.0.0.1])
	by 004.mia.mailroute.net (Postfix) with ESMTP id 4cmQZJ6M63zm0yVW;
	Tue, 14 Oct 2025 20:20:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1760473223; x=1763065224; bh=gucst
	6WqnDt9lQpe4WdsDj9dkjouJSRN9gkuaok4RoM=; b=jUzz2wezqYsmZi4ffWAOD
	A5WGeoOlpZYXPXsCsC8yfXpnPoeK64Min0T1t+Y08yCsF9G5Yx1i61U5/DiIemsW
	gqhgUtU2gouoHf5GBaJDY4cQzWu8MFrudwNtqZMruW3QhTXcKe71KhtqjEvQSBec
	bYt/BNa9Cqo7VqhqTD6KfRHocHsGeE8sJOfDtXoNwPoGtAQgCjvg02TqMNmE2vZd
	G1Q8qDG3ITQDeRktglYFJRf45orbm+CyBLfWT0xxwjMJcw+mrmVjL1SD+uy54ONM
	Y2nE2OtUcV/GoQJ5GSrYUaqhcSmrB1i4kcyusHX/vdyRAfAyUt35foFaVr+uonqG
	g==
X-Virus-Scanned: by MailRoute
Received: from 004.mia.mailroute.net ([127.0.0.1])
 by localhost (004.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id 9WGptNhsK8hI; Tue, 14 Oct 2025 20:20:23 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.180.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 004.mia.mailroute.net (Postfix) with ESMTPSA id 4cmQZB1D93zm0yVS;
	Tue, 14 Oct 2025 20:20:17 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	Peter Wang <peter.wang@mediatek.com>,
	Avri Altman <avri.altman@sandisk.com>,
	Bean Huo <beanhuo@micron.com>
Subject: [PATCH v6 19/28] ufs: core: Call ufshcd_init_lrb() later
Date: Tue, 14 Oct 2025 13:16:01 -0700
Message-ID: <20251014201707.3396650-20-bvanassche@acm.org>
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

Call ufshcd_init_lrb() from inside ufshcd_setup_dev_cmd() instead of
ufshcd_host_memory_configure(). This patch prepares for calling
ufshcd_host_memory_configure() before the information is available
that is required to call ufshcd_setup_dev_cmd().

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/ufs/core/ufshcd.c | 53 ++++++++++++++++++++-------------------
 1 file changed, 27 insertions(+), 26 deletions(-)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index a7e4aee959df..bd87a7953551 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -2903,8 +2903,32 @@ static void ufshcd_comp_scsi_upiu(struct ufs_hba *=
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
@@ -2916,7 +2940,7 @@ static void __ufshcd_setup_cmd(struct ufshcd_lrb *l=
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
@@ -2971,27 +2995,6 @@ static void ufshcd_map_queues(struct Scsi_Host *sh=
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
@@ -3084,7 +3087,7 @@ static int ufshcd_queuecommand(struct Scsi_Host *ho=
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
@@ -4047,8 +4050,6 @@ static void ufshcd_host_memory_configure(struct ufs=
_hba *hba)
 			utrdlp[i].response_upiu_length =3D
 				cpu_to_le16(ALIGNED_UPIU_SIZE >> 2);
 		}
-
-		ufshcd_init_lrb(hba, &hba->lrb[i], i);
 	}
 }
=20
