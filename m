Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC03938AF2B;
	Mon,  5 May 2025 23:12:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746486776; cv=none; b=G/ikgeXx24sLK1AUDqeT2jYGRtLQkh+OhTavBJgls0vjFvFsIVu62G4jX0pvC78DDVmZZr0LkUp93CYSdHFX3Lal84QoZHIULZHQo4zKXXbjcCSY8YRhqze2/+ws4qdAk741jPfDOLcwO3chUPScOaaTnINBZzkrVLFCPbiHrcs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746486776; c=relaxed/simple;
	bh=gE3emMFQQOhRKQH4aWjQBd6PT7SYaFX/CFhjgkCBKSo=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Tfl9Kz5nrv4byMy79i1cILsF1gb8O/x+9FYF8W0eEO9UmEReIAc2zmwNfYBGDM7khYFZVsJQMo1iFgGwOj4fPGW6amTldf4xsrYyCbGhbJw5ru3CiA/cO2BY3uekGCnH174pgzzSrQVYuV5ngJFV5vCJjBtFWHYLB0D2TYVFdyw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=nUfcU6OM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="nUfcU6OM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 934FFC4CEEF;
	Mon,  5 May 2025 23:12:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1746486776;
	bh=gE3emMFQQOhRKQH4aWjQBd6PT7SYaFX/CFhjgkCBKSo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nUfcU6OM+yeoRQM7Lt9fv6P0hdBahfW18IanQP/NmWGm7jU9NHRV+O7VZLMsDBuB5
	 m1EdMCTRcL8vs2EqEWKv4wQ5ayofZWK+4Ky2u9lt0Pg9hwPouMnh0dP/GmdqYnBHrz
	 4wSE8bD9dcpJqgcwmSdGXGzxhhHk8ybhhUai3e5WVmceqK10xatmxc2jRXYMvTFTeH
	 aEbqLFEX/Yg4V5KNK4eFPr5tEi8Gznbblxda/p14oSzJvcP+kRtU6SwEGgZEoWnKji
	 1TzzkpHvhfjeuogJGsO/TIlJTigM7NZizkY6cBWBZZ04Jxbnu4q9EwWTBWg0m3vTpn
	 zVdhz1uN4F6Xg==
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
Subject: [PATCH AUTOSEL 6.1 197/212] scsi: lpfc: Free phba irq in lpfc_sli4_enable_msi() when pci_irq_vector() fails
Date: Mon,  5 May 2025 19:06:09 -0400
Message-Id: <20250505230624.2692522-197-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250505230624.2692522-1-sashal@kernel.org>
References: <20250505230624.2692522-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.1.136
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
index 1a0bafde34d86..97f3c5240d572 100644
--- a/drivers/scsi/lpfc/lpfc_init.c
+++ b/drivers/scsi/lpfc/lpfc_init.c
@@ -13204,6 +13204,7 @@ lpfc_sli4_enable_msi(struct lpfc_hba *phba)
 	eqhdl = lpfc_get_eq_hdl(0);
 	rc = pci_irq_vector(phba->pcidev, 0);
 	if (rc < 0) {
+		free_irq(phba->pcidev->irq, phba);
 		pci_free_irq_vectors(phba->pcidev);
 		lpfc_printf_log(phba, KERN_WARNING, LOG_INIT,
 				"0496 MSI pci_irq_vec failed (%d)\n", rc);
@@ -13284,6 +13285,7 @@ lpfc_sli4_enable_intr(struct lpfc_hba *phba, uint32_t cfg_mode)
 			eqhdl = lpfc_get_eq_hdl(0);
 			retval = pci_irq_vector(phba->pcidev, 0);
 			if (retval < 0) {
+				free_irq(phba->pcidev->irq, phba);
 				lpfc_printf_log(phba, KERN_WARNING, LOG_INIT,
 					"0502 INTR pci_irq_vec failed (%d)\n",
 					 retval);
-- 
2.39.5

