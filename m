Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF7072D7ADB;
	Mon,  5 May 2025 22:55:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746485723; cv=none; b=iwg4Vu5BnL3KGzQOcMZ6ydP11hTtrsJPL//3eP/4pg43Gzducbm7CmPnyxfxLmyiibef29lIPcepO/GtlNy6A4g5w3t8APY+A8I/dMM4H0I4Jmn6KLDXIvpx1wLuoQccRchgWhC0jE1/nsc0VNv1RByPtKSt2KF99VZT5jAt908=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746485723; c=relaxed/simple;
	bh=YTsXMGJYOcoTdqK//koWZvn0gA3KqcI4GeOMBd0XydE=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=DQ6Gl385hkfNtHnTZjo7iJkjc0DWQPVaklEIfceiBi99NOEhTL58ApG2X1J/9Zlnk4IJ9fUpHM3PONnEeDvd0DXHKZt8LJlt6CgzaCYjKg1N08EfLphElQNJyaDvKet7Q7cISezRH6w1Zgvq4U0d+YYar5KVPJpiWIX4UWnDGdI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=JrwRpXHa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JrwRpXHa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 58DB6C4CEED;
	Mon,  5 May 2025 22:55:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1746485721;
	bh=YTsXMGJYOcoTdqK//koWZvn0gA3KqcI4GeOMBd0XydE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JrwRpXHa+YCs+fa72MIisulzRvyfarvTj7Gxe6cmTE5DX2D18jG6yhiVwz+fuDjqq
	 IJ4NfnGXvai59k/qHWrKDYTCF3fjYnJ4sXRTD/2rMFArFruC6csl45q6xl4ceyyNTO
	 pNjNDD6rrIrKzH52mfemGPAPxRk5Rud34mNb6vXzJr0FfwB7l1SdmTotffiPuYho0X
	 kgLDfiG1wc6wbMNaJ08SsewQvmtGQs2pVPjh4sD30tN178Ou3UwAjjQhycPuU6bKNl
	 L+aaL1UMg7b62Ty2Ca/Fe1apxn5fkiuHsDI3RJVmERUckWqSy+jRJ4gtLpXTlLogfP
	 LvtsCOwwy8z2Q==
From: Sasha Levin <sashal@kernel.org>
To: linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Cc: Justin Tee <justin.tee@broadcom.com>,
	"Martin K . Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>,
	james.smart@broadcom.com,
	dick.kennedy@broadcom.com,
	James.Bottomley@HansenPartnership.com,
	linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 6.12 443/486] scsi: lpfc: Free phba irq in lpfc_sli4_enable_msi() when pci_irq_vector() fails
Date: Mon,  5 May 2025 18:38:39 -0400
Message-Id: <20250505223922.2682012-443-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250505223922.2682012-1-sashal@kernel.org>
References: <20250505223922.2682012-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.12.26
Content-Transfer-Encoding: 8bit

From: Justin Tee <justin.tee@broadcom.com>

[ Upstream commit f0842902b383982d1f72c490996aa8fc29a7aa0d ]

Fix smatch warning regarding missed calls to free_irq().  Free the phba IRQ
in the failed pci_irq_vector cases.

lpfc_init.c: lpfc_sli4_enable_msi() warn: 'phba->pcidev->irq' from
             request_irq() not released.

Signed-off-by: Justin Tee <justin.tee@broadcom.com>
Link: https://lore.kernel.org/r/20250131000524.163662-3-justintee8345@gmail.com
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/lpfc/lpfc_init.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
index a3658ef1141b2..50c761991191f 100644
--- a/drivers/scsi/lpfc/lpfc_init.c
+++ b/drivers/scsi/lpfc/lpfc_init.c
@@ -13190,6 +13190,7 @@ lpfc_sli4_enable_msi(struct lpfc_hba *phba)
 	eqhdl = lpfc_get_eq_hdl(0);
 	rc = pci_irq_vector(phba->pcidev, 0);
 	if (rc < 0) {
+		free_irq(phba->pcidev->irq, phba);
 		pci_free_irq_vectors(phba->pcidev);
 		lpfc_printf_log(phba, KERN_WARNING, LOG_INIT,
 				"0496 MSI pci_irq_vec failed (%d)\n", rc);
@@ -13270,6 +13271,7 @@ lpfc_sli4_enable_intr(struct lpfc_hba *phba, uint32_t cfg_mode)
 			eqhdl = lpfc_get_eq_hdl(0);
 			retval = pci_irq_vector(phba->pcidev, 0);
 			if (retval < 0) {
+				free_irq(phba->pcidev->irq, phba);
 				lpfc_printf_log(phba, KERN_WARNING, LOG_INIT,
 					"0502 INTR pci_irq_vec failed (%d)\n",
 					 retval);
-- 
2.39.5

