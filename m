Received: from 003.mia.mailroute.net (003.mia.mailroute.net [199.89.3.6])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 151D321771B
	for <linux-scsi@vger.kernel.org>; Mon, 11 Aug 2025 17:39:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.6
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754933985; cv=none; b=i3cg0V4shvhmffJi3GMk0cKxuojM6BFZFaR1SJNWeGby7SkUfYIppM/JmeA37pbcQcFb1ltfevBxYVLV7gGKocDqjcVVM0EJqnKCVIN6lUcKlINwZXg8swifyTdPBLfsk61uf46GXLu2lzjRMiT2VQNwPwgDT4JMjKYJ1QY3Abw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754933985; c=relaxed/simple;
	bh=pNUqFkrixHUfSbX4kbB2/uOAS0/8z3QiTCHwCo3eoJE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KNW/cOPKYcseHFHX2LvT0LK124Z88qceS3JOp7clO9bcEsVpsXgTnMLyQM3jEefQjJXfrHtN+V1HjVIdbbCutcQG6ZLkohnlzq0IRefd9G7G9kz05xDacxZSA4XIBMWkwRktraj2PthHkDLA/81GzPWOcoT/HO/ZvhaWf2eVl1k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=IoO5hSlz; arc=none smtp.client-ip=199.89.3.6
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="IoO5hSlz"
Received: from localhost (localhost [127.0.0.1])
	by 003.mia.mailroute.net (Postfix) with ESMTP id 4c122R0T0kzlgqV3;
	Mon, 11 Aug 2025 17:39:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1754933980; x=1757525981; bh=S7/s9
	m8EgMhy/G1A6DlrAIMQUmX0gLOgUK4L4UmJqWE=; b=IoO5hSlz+Y83u/hFOw0MH
	TFCk06qoORLXFFD8E3QYa/L1xswBrQkCQRchXu8Ks2csNAqgWn6BmMi6wxmf9NkE
	Eocwr/nD0ekrvbZDg3s/U//RjhoGlbzFhu8TQVrzb9jA7jZaO0JtOTKFEd7NUkCw
	C+pOUNhKfeENwSWUdc+HI4Bu1JKr2CHdrQCHZOkA/lukObg7dlzFuS3TabahrbLq
	jSrfifJt5otOpyMzXtJ4k1NfoQ4r+IPQHzrJgJXYXla2BPGQAq2iScWXlCSLpwIM
	1obj3qBXzdBhsKXalsAb1VP0PGI7CI/zHvw4pGXwr7CkqfJH4oLztIVl9DXyNint
	Q==
X-Virus-Scanned: by MailRoute
Received: from 003.mia.mailroute.net ([127.0.0.1])
 by localhost (003.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id AVIWA0K_HgrC; Mon, 11 Aug 2025 17:39:40 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 003.mia.mailroute.net (Postfix) with ESMTPSA id 4c122F23DbzlgqTq;
	Mon, 11 Aug 2025 17:39:32 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	Peter Wang <peter.wang@mediatek.com>,
	Avri Altman <avri.altman@sandisk.com>,
	Bean Huo <beanhuo@micron.com>,
	Manivannan Sadhasivam <mani@kernel.org>,
	Can Guo <quic_cang@quicinc.com>,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH v2 16/30] ufs: core: Cache the DMA buffer sizes
Date: Mon, 11 Aug 2025 10:34:28 -0700
Message-ID: <20250811173634.514041-17-bvanassche@acm.org>
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

Prepare for supporting DMA buffer reallocation. Caching the DMA buffer
sizes is essential because a later patch will modify hba->nutrs between
the ufshcd_memory_alloc() and the ufshcd_memory_free() calls.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/ufs/core/ufshcd.c | 62 ++++++++++++++++++++-------------------
 include/ufs/ufshcd.h      |  5 ++++
 2 files changed, 37 insertions(+), 30 deletions(-)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index ac4c54a34fd8..09727a94595c 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -3909,14 +3909,10 @@ static int ufshcd_get_ref_clk_gating_wait(struct =
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
@@ -3932,11 +3928,9 @@ static int ufshcd_memory_alloc(struct ufs_hba *hba=
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
@@ -3948,7 +3942,7 @@ static int ufshcd_memory_alloc(struct ufs_hba *hba)
 	 * Skip utmrdl allocation; it may have been
 	 * allocated during first pass and not released during
 	 * MCQ memory allocation.
-	 * See ufshcd_release_sdb_queue() and ufshcd_config_mcq()
+	 * See ufshcd_memory_free() and ufshcd_config_mcq()
 	 */
 	if (hba->utmrdl_base_addr)
 		goto skip_utmrdl;
@@ -3956,11 +3950,9 @@ static int ufshcd_memory_alloc(struct ufs_hba *hba=
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
@@ -8852,20 +8844,30 @@ static int ufshcd_add_lus(struct ufs_hba *hba)
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
@@ -8887,7 +8889,7 @@ static int ufshcd_alloc_mcq(struct ufs_hba *hba)
 	 * Number of supported tags in MCQ mode may be larger than SDB mode.
 	 */
 	if (hba->nutrs !=3D old_nutrs) {
-		ufshcd_release_sdb_queue(hba, old_nutrs);
+		ufshcd_memory_free(hba);
 		ret =3D ufshcd_memory_alloc(hba);
 		if (ret)
 			goto err;
diff --git a/include/ufs/ufshcd.h b/include/ufs/ufshcd.h
index 1d3943777584..3e71d691d731 100644
--- a/include/ufs/ufshcd.h
+++ b/include/ufs/ufshcd.h
@@ -842,6 +842,9 @@ enum ufshcd_mcq_opr {
 /**
  * struct ufs_hba - per adapter private structure
  * @mmio_base: UFSHCI base register address
+ * @ucdl_size: Size of UFS Command Descriptor buffer
+ * @utrdl_size: Size of UTP Transfer Request Descriptor buffer
+ * @utmrdl_size: Size of UTP Task Management Descriptor buffer
  * @ucdl_base_addr: UFS Command Descriptor base address
  * @utrdl_base_addr: UTP Transfer Request Descriptor base address
  * @utmrdl_base_addr: UTP Task Management Descriptor base address
@@ -971,6 +974,8 @@ enum ufshcd_mcq_opr {
 struct ufs_hba {
 	void __iomem *mmio_base;
=20
+	u32 ucdl_size, utrdl_size, utmrdl_size;
+
 	/* Virtual memory reference */
 	struct utp_transfer_cmd_desc *ucdl_base_addr;
 	struct utp_transfer_req_desc *utrdl_base_addr;
