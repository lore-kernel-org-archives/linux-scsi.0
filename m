Received: from 004.mia.mailroute.net (004.mia.mailroute.net [199.89.3.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3FB6CA6F
	for <linux-scsi@vger.kernel.org>; Fri, 31 Oct 2025 20:43:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761943402; cv=none; b=WeAqXgcP+pQyIbzDPeHejrwG7AohQQ2sBbtRsU1/FiYi286SWo+0xwbPtBRlHv5tOyrIDZVMcAIsRj4y4XCOH//GnA6DGhO3DgBan4jxgyBwWPkhxfG0ggOrsQbYLfOOBZhbs+h2ITX9vluHXoHa1UiDnyUr4rk/DjmcryY3Q/4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761943402; c=relaxed/simple;
	bh=jj9Zwg5k9uJ5a7IjbPPsy992azsav0ZaykjfpISVhLI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nflj8cnyOjul6beWMhlSSwphGlN9pTGr++hcEVKFUzoI6iUYo01rtPTrlbRArTJEqAXtlI9cK0bKpq4ITPpsdU10g45wP7mr7canpNSYQe7zlNUqi4Rjlko2dE3/alCbPCLyjt4890QUPzZTOT8LxkyPV2GOfb8lfRvm2cgIzHM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=JafveGHR; arc=none smtp.client-ip=199.89.3.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="JafveGHR"
Received: from localhost (localhost [127.0.0.1])
	by 004.mia.mailroute.net (Postfix) with ESMTP id 4cytGw0Fhjzm0pKT;
	Fri, 31 Oct 2025 20:43:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1761943398; x=1764535399; bh=v7dFW
	LMl20bXD3lZy/kc3iHLpTtzT39MA38TirbeOAU=; b=JafveGHRF9hkGCqpmM32M
	ufZj8aSK0c8WTymh0jF+NmarsmAObsUaVonSL7+y2yuI+NG872O2ojFAwoBy08jV
	2RWBs70GaTYILOMrpyaNUmLWPp8hZXJb3aeVRNlBlwFVtKY/cSq9io4jG08Lt1sU
	x1lqcSkb/pmpa8cRPLB/I2MK1zPMB0Mt5RZSClugnrcoIrnVXaxio6iHqxFcFZ9H
	iQv5AiIYeyOPLgcUcjan06/ziXQpsQAe+u27KNuDRCqjTDFrbJm3ywJLV/SX1TqO
	QUQxJEL7iDZMviPmqoIVdwn5KoLqB9tq7YjHOOO9X6TVotgGKhdq4oeGUXLPTolS
	w==
X-Virus-Scanned: by MailRoute
Received: from 004.mia.mailroute.net ([127.0.0.1])
 by localhost (004.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id AGCrx8ybSjQF; Fri, 31 Oct 2025 20:43:18 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.180.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 004.mia.mailroute.net (Postfix) with ESMTPSA id 4cytGm3FdHzm0pKy;
	Fri, 31 Oct 2025 20:43:11 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>,
	Avri Altman <avri.altman@sandisk.com>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	Peter Wang <peter.wang@mediatek.com>,
	Bean Huo <beanhuo@micron.com>,
	"Bao D. Nguyen" <quic_nguyenb@quicinc.com>,
	Adrian Hunter <adrian.hunter@intel.com>
Subject: [PATCH v8 19/28] ufs: core: Call ufshcd_init_lrb() later
Date: Fri, 31 Oct 2025 13:39:27 -0700
Message-ID: <20251031204029.2883185-20-bvanassche@acm.org>
X-Mailer: git-send-email 2.51.1.930.gacf6e81ea2-goog
In-Reply-To: <20251031204029.2883185-1-bvanassche@acm.org>
References: <20251031204029.2883185-1-bvanassche@acm.org>
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

Reviewed-by: Avri Altman <avri.altman@sandisk.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/ufs/core/ufshcd.c | 53 ++++++++++++++++++++-------------------
 1 file changed, 27 insertions(+), 26 deletions(-)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index 7935aad4ca13..f6eecc03282a 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -2904,8 +2904,32 @@ static void ufshcd_comp_scsi_upiu(struct ufs_hba *=
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
@@ -2917,7 +2941,7 @@ static void __ufshcd_setup_cmd(struct ufshcd_lrb *l=
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
@@ -2972,27 +2996,6 @@ static void ufshcd_map_queues(struct Scsi_Host *sh=
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
@@ -3085,7 +3088,7 @@ static int ufshcd_queuecommand(struct Scsi_Host *ho=
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
@@ -4048,8 +4051,6 @@ static void ufshcd_host_memory_configure(struct ufs=
_hba *hba)
 			utrdlp[i].response_upiu_length =3D
 				cpu_to_le16(ALIGNED_UPIU_SIZE >> 2);
 		}
-
-		ufshcd_init_lrb(hba, &hba->lrb[i], i);
 	}
 }
=20
