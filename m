Received: from 004.mia.mailroute.net (004.mia.mailroute.net [199.89.3.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 036F210E9
	for <linux-scsi@vger.kernel.org>; Thu,  3 Apr 2025 21:22:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743715327; cv=none; b=rybTVQEQ690bTNF3TR/HamIYYKuTFmlkP2pxZq9JuKPu4D0PhnZJwJ+OEo54We4HNCoh7cg/qEmbtf/4rRoy7pR338hV80IJBFATsh9as5ZEprVj2ds3S3E4/FcKT7JjKQQyPOR4EM5uukFFE2zs/5CZrQICCWC6eDK/MNeZBxM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743715327; c=relaxed/simple;
	bh=mhhMMlzxMc1P+BqYIS8WPbmCXrTpk3vzyH2U8EKTpBQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=k3+pxSPDo6sM+gHKe/Pj/xD7Vp7CwdZglJi82I+L4WKtyUFHoHhH2wuW3Cn9OTD8SBi3mUY0YFCnJ8naTeW76Qf+/4oyHSAtVp6OcEc2qzJt+3ur8UH9r7B/3Q0pLz2waSIw63J19APO8duUP40rJG4NugAvGC16Zx34xV9oJys=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=vKsYpms1; arc=none smtp.client-ip=199.89.3.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="vKsYpms1"
Received: from localhost (localhost [127.0.0.1])
	by 004.mia.mailroute.net (Postfix) with ESMTP id 4ZTF6z74HLzm0XBf;
	Thu,  3 Apr 2025 21:22:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1743715321; x=1746307322; bh=0ICoX
	c3VTPD8Y7idmfsK0tkHDmg9Vb6bCRMyzmVyS/Q=; b=vKsYpms1iEj3WlLDCDf0N
	SNujkbdPZo5LVz7g9p9vswnRE4bWeL/PsOKojBdjGf+zTV3yJKoZc3vcACuSNmlz
	UqTBSEbqF3QfSwGuLRI+u4vaskWwq194/zmd17Fc2o2z4IY4v3rV7WeFQD08p2Gs
	vbL7nokDRWRfmbB97rq3XhTeb3Qpn9GWzPJ4MnxsCNfvOMlPiHnoJYggzx6mGE+5
	fAsb4OrMHu602bq7/d5RsEv8GDEVxoE+BeO4hll0RUTMZwdGzKTgN4eRUTJmHfeq
	Upp/KBIf01nCZ5843hB6JJ5x70Sxg6+FkXmapIlIxLIKaNjPsc3/0WCKq9YJL2Uu
	A==
X-Virus-Scanned: by MailRoute
Received: from 004.mia.mailroute.net ([127.0.0.1])
 by localhost (004.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id ep2mHI6WrCay; Thu,  3 Apr 2025 21:22:01 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 004.mia.mailroute.net (Postfix) with ESMTPSA id 4ZTF6n1YdQzm0yVH;
	Thu,  3 Apr 2025 21:21:52 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	Peter Wang <peter.wang@mediatek.com>,
	Avri Altman <avri.altman@wdc.com>,
	Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
	"Bao D. Nguyen" <quic_nguyenb@quicinc.com>,
	Eric Biggers <ebiggers@google.com>,
	Can Guo <quic_cang@quicinc.com>,
	Minwoo Im <minwoo.im@samsung.com>
Subject: [PATCH 14/24] scsi: ufs: core: Cache the DMA buffer sizes
Date: Thu,  3 Apr 2025 14:17:58 -0700
Message-ID: <20250403211937.2225615-15-bvanassche@acm.org>
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

Prepare for supporting DMA buffer reallocation. Caching the DMA buffer
sizes is essential because a later patch will modify hba->nutrs between
the ufshcd_memory_alloc() and the ufshcd_memory_free() calls.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/ufs/core/ufshcd.c | 62 ++++++++++++++++++++-------------------
 include/ufs/ufshcd.h      |  5 ++++
 2 files changed, 37 insertions(+), 30 deletions(-)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index 4728cae130a7..26aa07712507 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -3857,14 +3857,10 @@ static int ufshcd_get_ref_clk_gating_wait(struct =
ufs_hba *hba)
  */
 static int ufshcd_memory_alloc(struct ufs_hba *hba)
 {
-	size_t utmrdl_size, utrdl_size, ucdl_size;
-
 	/* Allocate memory for UTP command descriptors */
-	ucdl_size =3D ufshcd_get_ucd_size(hba) * hba->nutrs;
-	hba->ucdl_base_addr =3D dmam_alloc_coherent(hba->dev,
-						  ucdl_size,
-						  &hba->ucdl_dma_addr,
-						  GFP_KERNEL);
+	hba->ucdl_size =3D ufshcd_get_ucd_size(hba) * hba->nutrs;
+	hba->ucdl_base_addr =3D dmam_alloc_coherent(
+		hba->dev, hba->ucdl_size, &hba->ucdl_dma_addr, GFP_KERNEL);
=20
 	/*
 	 * UFSHCI requires UTP command descriptor to be 128 byte aligned.
@@ -3880,11 +3876,9 @@ static int ufshcd_memory_alloc(struct ufs_hba *hba=
)
 	 * Allocate memory for UTP Transfer descriptors
 	 * UFSHCI requires 1KB alignment of UTRD
 	 */
-	utrdl_size =3D (sizeof(struct utp_transfer_req_desc) * hba->nutrs);
-	hba->utrdl_base_addr =3D dmam_alloc_coherent(hba->dev,
-						   utrdl_size,
-						   &hba->utrdl_dma_addr,
-						   GFP_KERNEL);
+	hba->utrdl_size =3D sizeof(struct utp_transfer_req_desc) * hba->nutrs;
+	hba->utrdl_base_addr =3D dmam_alloc_coherent(
+		hba->dev, hba->utrdl_size, &hba->utrdl_dma_addr, GFP_KERNEL);
 	if (!hba->utrdl_base_addr ||
 	    WARN_ON(hba->utrdl_dma_addr & (SZ_1K - 1))) {
 		dev_err(hba->dev,
@@ -3896,7 +3890,7 @@ static int ufshcd_memory_alloc(struct ufs_hba *hba)
 	 * Skip utmrdl allocation; it may have been
 	 * allocated during first pass and not released during
 	 * MCQ memory allocation.
-	 * See ufshcd_release_sdb_queue() and ufshcd_config_mcq()
+	 * See ufshcd_memory_free() and ufshcd_config_mcq()
 	 */
 	if (hba->utmrdl_base_addr)
 		goto skip_utmrdl;
@@ -3904,11 +3898,9 @@ static int ufshcd_memory_alloc(struct ufs_hba *hba=
)
 	 * Allocate memory for UTP Task Management descriptors
 	 * UFSHCI requires 1KB alignment of UTMRD
 	 */
-	utmrdl_size =3D sizeof(struct utp_task_req_desc) * hba->nutmrs;
-	hba->utmrdl_base_addr =3D dmam_alloc_coherent(hba->dev,
-						    utmrdl_size,
-						    &hba->utmrdl_dma_addr,
-						    GFP_KERNEL);
+	hba->utmrdl_size =3D sizeof(struct utp_task_req_desc) * hba->nutmrs;
+	hba->utmrdl_base_addr =3D dmam_alloc_coherent(
+		hba->dev, hba->utmrdl_size, &hba->utmrdl_dma_addr, GFP_KERNEL);
 	if (!hba->utmrdl_base_addr ||
 	    WARN_ON(hba->utmrdl_dma_addr & (SZ_1K - 1))) {
 		dev_err(hba->dev,
@@ -8705,20 +8697,30 @@ static int ufshcd_add_lus(struct ufs_hba *hba)
 	return ret;
 }
=20
-/* SDB - Single Doorbell */
-static void ufshcd_release_sdb_queue(struct ufs_hba *hba, int nutrs)
+/*
+ * Free the memory allocated by ufshcd_memory_alloc() except the utmrdl =
DMA
+ * memory.
+ */
+static void ufshcd_memory_free(struct ufs_hba *hba)
 {
-	size_t ucdl_size, utrdl_size;
-
-	ucdl_size =3D ufshcd_get_ucd_size(hba) * nutrs;
-	dmam_free_coherent(hba->dev, ucdl_size, hba->ucdl_base_addr,
-			   hba->ucdl_dma_addr);
+	if (hba->ucdl_base_addr) {
+		dmam_free_coherent(hba->dev, hba->ucdl_size,
+				   hba->ucdl_base_addr, hba->ucdl_dma_addr);
+		hba->ucdl_base_addr =3D NULL;
+		hba->ucdl_dma_addr =3D 0;
+	}
=20
-	utrdl_size =3D sizeof(struct utp_transfer_req_desc) * nutrs;
-	dmam_free_coherent(hba->dev, utrdl_size, hba->utrdl_base_addr,
-			   hba->utrdl_dma_addr);
+	if (hba->utrdl_base_addr) {
+		dmam_free_coherent(hba->dev, hba->utrdl_size,
+				   hba->utrdl_base_addr, hba->utrdl_dma_addr);
+		hba->utrdl_base_addr =3D NULL;
+		hba->utrdl_dma_addr =3D 0;
+	}
=20
-	devm_kfree(hba->dev, hba->lrb);
+	if (hba->lrb) {
+		devm_kfree(hba->dev, hba->lrb);
+		hba->lrb =3D NULL;
+	}
 }
=20
 static int ufshcd_alloc_mcq(struct ufs_hba *hba)
@@ -8740,7 +8742,7 @@ static int ufshcd_alloc_mcq(struct ufs_hba *hba)
 	 * Number of supported tags in MCQ mode may be larger than SDB mode.
 	 */
 	if (hba->nutrs !=3D old_nutrs) {
-		ufshcd_release_sdb_queue(hba, old_nutrs);
+		ufshcd_memory_free(hba);
 		ret =3D ufshcd_memory_alloc(hba);
 		if (ret)
 			goto err;
diff --git a/include/ufs/ufshcd.h b/include/ufs/ufshcd.h
index e928ed0265ff..656c9b668fcc 100644
--- a/include/ufs/ufshcd.h
+++ b/include/ufs/ufshcd.h
@@ -847,6 +847,9 @@ enum ufshcd_mcq_opr {
 /**
  * struct ufs_hba - per adapter private structure
  * @mmio_base: UFSHCI base register address
+ * @ucdl_size: Size of UFS Command Descriptor buffer
+ * @utrdl_size: Size of UTP Transfer Request Descriptor buffer
+ * @utmrdl_size: Size of UTP Task Management Descriptor buffer
  * @ucdl_base_addr: UFS Command Descriptor base address
  * @utrdl_base_addr: UTP Transfer Request Descriptor base address
  * @utmrdl_base_addr: UTP Task Management Descriptor base address
@@ -975,6 +978,8 @@ enum ufshcd_mcq_opr {
 struct ufs_hba {
 	void __iomem *mmio_base;
=20
+	u32 ucdl_size, utrdl_size, utmrdl_size;
+
 	/* Virtual memory reference */
 	struct utp_transfer_cmd_desc *ucdl_base_addr;
 	struct utp_transfer_req_desc *utrdl_base_addr;
