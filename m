Received: from 004.mia.mailroute.net (004.mia.mailroute.net [199.89.3.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9BA71A83FF
	for <linux-scsi@vger.kernel.org>; Thu,  3 Apr 2025 21:23:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743715393; cv=none; b=cb/e/HaOXxUuUS+F8jdUxH+y1hxN5k60xUAeXB7Ol2Hz1Zl+TDXfx12I5W/yAl07U2JL/fm3dB/UVLGLR+ypRmwTZF/7C1nBYrVCoW/onhl03EwypEaWjr+IQ0ObrjBN5UAvqsWcVsoXjrhRTq5pouh5+2GlJ7DtWVRegjijb2s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743715393; c=relaxed/simple;
	bh=UIURsZW3ch5WcrE7xfaWTMnatNO6eQE1Utc0ogc5a3Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=p2omkmsfn0O4cw/ZuPjs75i8vBG76EtR3CumLnWgo2eKZ+aYhBQNXjR7zke/+Fdwteze87DJOXLKe/Rd+IOIsFme0wMp9RFUSkoGPzrrpArW6m0z8xNiUowo3lAnf+wWKx7kHwWr45DFgnqUMm9HLVu5O7vzU0hSDvLCZhF30JA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=h6QnZnEh; arc=none smtp.client-ip=199.89.3.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="h6QnZnEh"
Received: from localhost (localhost [127.0.0.1])
	by 004.mia.mailroute.net (Postfix) with ESMTP id 4ZTF8G52pGzm0yVW;
	Thu,  3 Apr 2025 21:23:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1743715388; x=1746307389; bh=59c7p
	/IyoVQUGaXWI/BGRG0h1Lr+TMOa5Rx4ilLEyOA=; b=h6QnZnEhihZ824IXXb52V
	2UEmV8g+8D8pdipKtiwKoxXgnaSQxVIup1ktHq9vah3mAVnB0y1SyeoTXJJG9v2a
	K7SNacbYHTWKt5aGgZ9TekTzsBgRyFW7mYCjSgwkAa2J5OsIHdO2UnhW1zfWw9Ya
	eu0/9M+apVfgkP8Cu27JLfiscxd+q/X6lab5jG9F05W9AisZfmI6Em+BPHPT0ZQ5
	7H7EMUiO0adIaacOlEisXGOu+N276npIUtm2IR6zR6dVo86c/zLma5x+YrcY8cBW
	AenWJM8lcZ6GF9hjeZLSYGGw1iNyC12miSfVP1Sng9Jt976nUuDdNT9h6hhmubjW
	w==
X-Virus-Scanned: by MailRoute
Received: from 004.mia.mailroute.net ([127.0.0.1])
 by localhost (004.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id VzSMIfdrJd9k; Thu,  3 Apr 2025 21:23:08 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 004.mia.mailroute.net (Postfix) with ESMTPSA id 4ZTF866G0vzm0ySc;
	Thu,  3 Apr 2025 21:23:01 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	Peter Wang <peter.wang@mediatek.com>,
	Avri Altman <avri.altman@wdc.com>,
	Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
	"Bao D. Nguyen" <quic_nguyenb@quicinc.com>
Subject: [PATCH 19/24] scsi: ufs: core: Call ufshcd_init_lrb() later
Date: Thu,  3 Apr 2025 14:18:03 -0700
Message-ID: <20250403211937.2225615-20-bvanassche@acm.org>
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

Call ufshcd_init_lrb() from inside ufshcd_setup_dev_cmd() instead of
ufshcd_host_memory_configure(). This patch prepares for calling
ufshcd_host_memory_configure() before the information is available
that is required to call ufshcd_setup_dev_cmd().

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/ufs/core/ufshcd.c | 53 ++++++++++++++++++++-------------------
 1 file changed, 27 insertions(+), 26 deletions(-)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index 7cbc7a3cf2db..df90163939d0 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -2868,8 +2868,32 @@ static void ufshcd_comp_scsi_upiu(struct ufs_hba *=
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
@@ -2881,7 +2905,7 @@ static void __ufshcd_setup_cmd(struct ufshcd_lrb *l=
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
@@ -2936,27 +2960,6 @@ static void ufshcd_map_queues(struct Scsi_Host *sh=
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
@@ -3049,7 +3052,7 @@ static int ufshcd_queuecommand(struct Scsi_Host *ho=
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
@@ -3978,8 +3981,6 @@ static void ufshcd_host_memory_configure(struct ufs=
_hba *hba)
 			utrdlp[i].response_upiu_length =3D
 				cpu_to_le16(ALIGNED_UPIU_SIZE >> 2);
 		}
-
-		ufshcd_init_lrb(hba, &hba->lrb[i], i);
 	}
 }
=20
