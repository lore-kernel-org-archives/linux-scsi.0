Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=199.89.1.14
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795135885;
	b=oJwaFCXLH3QjWc7wS7HYh93djlOiFl+zcEzcGBe7O/Z+no58WeYL+ExtvlXTKpDFrnVp
	 VlgbBiESMrkvyWgMgCl/BXKTTh80qbI8fH6Mu4YdCw8MaOfYAASj275DoXpCvRu8ZTkvU
	 rPujXWSWv8z8Q6zhcrZmHuX31etFeELbgdUE69yi6jJ++QTfWqPsziytXSzykfRNmtvUm
	 MwGAd0lkjPJG/lEnJNoxO6Rxx1wpY6F0NSexaYzBloJVppEWKMt+YYhqziYVkPUoYqs96
	 E9TaPsnxkGeJkj9Cyl5s7f0+jUnhatRISnZXiS1Ff/3X0XDWvQ41tNtQRw28jNXfDZQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795135885;
	h=DMARC-Filter:Received:DKIM-Signature:X-Virus-Scanned:Received:
	 Received:From:To:Cc:Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding;
	bh=PY1ry0LAzBd0E8g3D9jmxPSsScJdJK7RTXnOcndqrzM=;
	b=oQ3KoH0px1uSkZz+MOQAg0OuRinc5fMJLlg4zmpgaAFZR2dJiI83Dszx359+vgknJ6K7
	 zSfTaBqvO4HY1b/kFNWHlwLrgdIHlpyM3pYMecJnlH5YKs4bw31ja3bAbKCXuKwUIrjRx
	 7lhq2eg1sImGJHDNFAjVm23KxURCLKIjeKFUuuD4QdWlmVnduNwvlLmjkYl/aTabLVOiI
	 El2/XRgeX+4OD7LZy4mmJy1C1yIuhvZUVSDiD1TN+ZKfuQAR5Gj1qyqJZDX4hqJ2ASxVP
	 qZUICdY0sIuzF58Ta4DUZIr6mGUuWIdxt+sUggSsG0VhHTpW258dnTptseVTfaVLvfw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=acm.org;
	spf=pass smtp.mailfrom=acm.org;
	dkim=pass header.d=acm.org header.i=@acm.org header.a=rsa-sha256 header.s=mr01 header.b=S1bHp6dE;
	arc=none smtp.remote-ip=199.89.1.14
Received: from 011.lax.mailroute.net (011.lax.mailroute.net [199.89.1.14])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C9EF606A320
	for <linux-scsi@vger.kernel.org>; Fri, 20 Nov 2026 00:51:25 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 5C9EF606A320
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=acm.org header.i=@acm.org header.a=rsa-sha256 header.s=mr01 header.b=S1bHp6dE
Received: from localhost (localhost [127.0.0.1])
	by 011.lax.mailroute.net (Postfix) with ESMTP id 4jVxbw4dt3z1XM6J6;
	Fri, 20 Nov 2026 00:51:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:x-mailer:message-id:date
	:date:subject:subject:from:from:received:received; s=mr01; t=
	1795135875; x=1797727876; bh=PY1ry0LAzBd0E8g3D9jmxPSsScJdJK7RTXn
	OcndqrzM=; b=S1bHp6dEfGMNjkjsSa5hSJZ5oUBO+i+hyUVA4k/NHgDMfkn0uMk
	2VW0tTxl6rA8ElEnRtDFImwdsv+yotmu8aeCrgqj5FtTRg6qlpsBdSPON5JkGEtz
	ggAQZWZbUj42xazasCd6nvfbtWVYn5RHeSqB8AVu5g9+9/Pme47yfqwcKCqzK5kT
	pr6DDw6bh1WmCWtd79r+fm6Z9X5Cw/U26M0ln/G5Dz3lU4tFFRxOqWwYGrJPt/vA
	w7Ft9KkThozMF30Ab1mCohWVzSblay71F1Q94twMnQxoHWakax4N5lMditwnCQzY
	tirSp4PjUa0tvzMYIDpbxO9rvMXopXxtGzw==
X-Virus-Scanned: by MailRoute
Received: from 011.lax.mailroute.net ([127.0.0.1])
 by localhost (011.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id oFMQz0nKIq5D; Fri, 20 Nov 2026 00:51:15 +0000 (UTC)
Received: from bvanassche.c.googlers.com.com (57.237.82.34.bc.googleusercontent.com [34.82.237.57])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 011.lax.mailroute.net (Postfix) with ESMTPSA id 4jVxbk4jwSz1XM30h;
	Fri, 20 Nov 2026 00:51:14 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K. Petersen" <mkp@kernel.org>,
	Peter Wang <peter.wang@mediatek.com>,
	Bean Huo <beanhuo@micron.com>,
	Stanley Jhu <stanleyjhu@google.com>,
	Can Guo <can.guo@oss.qualcomm.com>,
	HOYOUNG SEO <hy50.seo@samsung.com>,
	John Garry <john.garry@linux.dev>,
	Hyeoncheol Jeong <hyenc.jeong@samsung.com>
Subject: [PATCH] ufs: core: Remove the DMA addresses from struct ufshcd_lrb
Date: Thu, 19 Nov 2026 16:50:57 -0800
Message-ID: <cc98d54dcd4a98fead25db50c5c6aec2dd65d595.1795135853.git.bvanassche@acm.org>
X-Mailer: git-send-email 2.56.1.750.gf70dc682cf-goog
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable

The offsets stored in struct utp_transfer_req_desc are in double words
on hosts without UFSHCD_QUIRK_PRDT_BYTE_GRAN. Using these offsets as
byte offsets to compute ucd_rsp_dma_addr and ucd_prdt_dma_addr results
in incorrect DMA addresses. These addresses are only used by
ufshcd_print_tr() for error logging.

Instead of fixing how these addresses are computed, remove the
utrd_dma_addr, ucd_req_dma_addr, ucd_rsp_dma_addr and ucd_prdt_dma_addr
members from struct ufshcd_lrb and do not report DMA addresses anymore
in ufshcd_print_tr(). The contents of the transfer request descriptor,
the request UPIU, the response UPIU and the PRDT are still dumped by
that function. Remove the local variable cmd_desc_element_addr from
ufshcd_init_lrb() since it is no longer used.

This patch changes the output of ufshcd_print_tr() as follows: the
"Transfer Request Descriptor phys@", "Request UPIU phys@" and "Response
UPIU phys@" lines are no longer logged and the "PRDT" line no longer
includes a physical address.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/ufs/core/ufshcd.c | 23 +----------------------
 include/ufs/ufshcd.h      |  9 ---------
 2 files changed, 1 insertion(+), 31 deletions(-)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index 56a77f4a2a6e..839d62aebe8a 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -614,18 +614,11 @@ static void ufshcd_print_tr(struct ufs_hba *hba, st=
ruct scsi_cmnd *cmd,
 		dev_err(hba->dev, "UPIU[%d] - complete time %lld us\n", tag,
 			div_u64(lrbp->compl_time_stamp_local_clock, 1000));
 	}
-	dev_err(hba->dev,
-		"UPIU[%d] - Transfer Request Descriptor phys@0x%llx\n",
-		tag, (u64)lrbp->utrd_dma_addr);
=20
 	ufshcd_hex_dump("UPIU TRD: ", lrbp->utr_descriptor_ptr,
 			sizeof(struct utp_transfer_req_desc));
-	dev_err(hba->dev, "UPIU[%d] - Request UPIU phys@0x%llx\n", tag,
-		(u64)lrbp->ucd_req_dma_addr);
 	ufshcd_hex_dump("UPIU REQ: ", lrbp->ucd_req_ptr,
 			sizeof(struct utp_upiu_req));
-	dev_err(hba->dev, "UPIU[%d] - Response UPIU phys@0x%llx\n", tag,
-		(u64)lrbp->ucd_rsp_dma_addr);
 	ufshcd_hex_dump("UPIU RSP: ", lrbp->ucd_rsp_ptr,
 			sizeof(struct utp_upiu_rsp));
=20
@@ -634,10 +627,7 @@ static void ufshcd_print_tr(struct ufs_hba *hba, str=
uct scsi_cmnd *cmd,
 	if (hba->quirks & UFSHCD_QUIRK_PRDT_BYTE_GRAN)
 		prdt_length /=3D ufshcd_sg_entry_size(hba);
=20
-	dev_err(hba->dev,
-		"UPIU[%d] - PRDT - %d entries  phys@0x%llx\n",
-		tag, prdt_length,
-		(u64)lrbp->ucd_prdt_dma_addr);
+	dev_err(hba->dev, "UPIU[%d] - PRDT - %d entries\n", tag, prdt_length);
=20
 	if (pr_prdt)
 		ufshcd_hex_dump("UPIU PRDT: ", lrbp->ucd_prdt_ptr,
@@ -2983,17 +2973,13 @@ static void ufshcd_init_lrb(struct ufs_hba *hba, =
struct scsi_cmnd *cmd)
 {
 	const int i =3D scsi_cmd_to_rq(cmd)->tag;
 	struct utp_transfer_req_desc *utrdlp =3D hba->utrdl_base_addr;
-	u16 response_offset =3D le16_to_cpu(utrdlp[i].response_upiu_offset);
-	u16 prdt_offset =3D le16_to_cpu(utrdlp[i].prd_table_offset);
 	struct ufshcd_lrb *lrb =3D scsi_cmd_priv(cmd);
 	u8 *command_upiu, *response_upiu, *prd_table;
-	dma_addr_t cmd_desc_element_addr;
=20
 	/* The reserved tag uses a dedicated UCD outside the pool. */
 	if (unlikely(blk_mq_is_reserved_rq(scsi_cmd_to_rq(cmd)))) {
 		struct utp_devman_cmd_desc *cmd_descp =3D hba->devman_ucd_base_addr;
=20
-		cmd_desc_element_addr =3D hba->devman_ucd_dma_addr;
 		command_upiu =3D cmd_descp->command_upiu;
 		response_upiu =3D cmd_descp->response_upiu;
 		prd_table =3D cmd_descp->prd_table;
@@ -3005,22 +2991,15 @@ static void ufshcd_init_lrb(struct ufs_hba *hba, =
struct scsi_cmnd *cmd)
 		WARN_ON_ONCE(slot < 0);
 		cmd_descp =3D (void *)hba->ucdl_base_addr + slot * ufshcd_get_ucd_size=
(hba);
=20
-		cmd_desc_element_addr =3D
-			hba->ucdl_dma_addr + slot * ufshcd_get_ucd_size(hba);
 		command_upiu =3D cmd_descp->command_upiu;
 		response_upiu =3D cmd_descp->response_upiu;
 		prd_table =3D cmd_descp->prd_table;
 	}
=20
 	lrb->utr_descriptor_ptr =3D utrdlp + i;
-	lrb->utrd_dma_addr =3D
-		hba->utrdl_dma_addr + i * sizeof(struct utp_transfer_req_desc);
 	lrb->ucd_req_ptr =3D (struct utp_upiu_req *)command_upiu;
-	lrb->ucd_req_dma_addr =3D cmd_desc_element_addr;
 	lrb->ucd_rsp_ptr =3D (struct utp_upiu_rsp *)response_upiu;
-	lrb->ucd_rsp_dma_addr =3D cmd_desc_element_addr + response_offset;
 	lrb->ucd_prdt_ptr =3D (struct ufshcd_sg_entry *)prd_table;
-	lrb->ucd_prdt_dma_addr =3D cmd_desc_element_addr + prdt_offset;
 }
=20
 static void __ufshcd_setup_cmd(struct ufs_hba *hba, struct scsi_cmnd *cm=
d,
diff --git a/include/ufs/ufshcd.h b/include/ufs/ufshcd.h
index be62165b785e..4465e06fd394 100644
--- a/include/ufs/ufshcd.h
+++ b/include/ufs/ufshcd.h
@@ -157,10 +157,6 @@ struct ufs_pm_lvl_states {
  * @ucd_req_ptr: UCD address of the command
  * @ucd_rsp_ptr: Response UPIU address for this command
  * @ucd_prdt_ptr: PRDT address of the command
- * @utrd_dma_addr: UTRD dma address for debug
- * @ucd_prdt_dma_addr: PRDT dma address for debug
- * @ucd_rsp_dma_addr: UPIU response dma address for debug
- * @ucd_req_dma_addr: UPIU request dma address for debug
  * @scsi_status: SCSI status of the command
  * @command_type: SCSI, UFS, Query.
  * @lun: LUN of the command
@@ -179,11 +175,6 @@ struct ufshcd_lrb {
 	struct utp_upiu_rsp *ucd_rsp_ptr;
 	struct ufshcd_sg_entry *ucd_prdt_ptr;
=20
-	dma_addr_t utrd_dma_addr;
-	dma_addr_t ucd_req_dma_addr;
-	dma_addr_t ucd_rsp_dma_addr;
-	dma_addr_t ucd_prdt_dma_addr;
-
 	int scsi_status;
=20
 	int command_type;
