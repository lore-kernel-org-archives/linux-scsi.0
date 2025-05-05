Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8EDC2338C00;
	Mon,  5 May 2025 22:37:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746484621; cv=none; b=TKeqiQxNiOwsJhjjDlJqqCTB5P21uaD3iCQQNRx4oT1bwQflGubO5hRu3LxyIgIgIoCXDMIvDbl1MoWvsgj7G9oqMNZF951Kt+xniWkorxc3Oo4xzjGnuzer70Y1BwD0PPzyFfnlT5S/AeC84VtPEVJybYR/lLzeD19AWQSOR/o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746484621; c=relaxed/simple;
	bh=lGEycOmXJyNOB+08mJHp6s1ra/DNqRNW0K+XsVgthzk=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=DDXZnTTAfCrXSAk1oj5whdpF4SAjzqy95BEatqNOGNJuBxnIGB79y6y/ViXIS2OZTF+i7Z7C/v7g2S2lWQfosYMBWU6jnHxPJD2wZiLEXvp3NJVzkkUK7QVlkYbjTvD47e0p3vv4ax2eIFu9eArgh4p3Nf0QA2uTVQfpNb9HLoE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=qWzcyajk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="qWzcyajk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1095CC4CEED;
	Mon,  5 May 2025 22:36:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1746484621;
	bh=lGEycOmXJyNOB+08mJHp6s1ra/DNqRNW0K+XsVgthzk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qWzcyajk+qHnR91XAanppB+gNZmAEAyRGoebphvM40SIai260lXK2imhTnsW3xpwY
	 NCP3wiszFv29Ga4cAuDTMFipyr3D8qLi7AL5JhOJG3rp2OS4/aWc8CRe1+wRY2BORp
	 qILDyf1KEjaZaDkfo3FDfSE0z6MiPefiJ1fhRg9Yke2FMaoDxPGF3LKdAfXbwGbhTB
	 AUZAJoL8JuRXeOxyo19lVbWTBsfMfXCDbLO8zv/NL/y6jrmI4oj4mcemLO+QljsCgj
	 6HkVYrzmx2z2dD08fsnjggWs7/JHHUAe5KNZu1VyCh8HG3nAX5leALVDdUan3wlwe6
	 bmEkHEfYd4oAQ==
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
Subject: [PATCH AUTOSEL 6.14 566/642] scsi: lpfc: Free phba irq in lpfc_sli4_enable_msi() when pci_irq_vector() fails
Date: Mon,  5 May 2025 18:13:02 -0400
Message-Id: <20250505221419.2672473-566-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250505221419.2672473-1-sashal@kernel.org>
References: <20250505221419.2672473-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.14.5
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
index bcadf11414c8a..411a6b927c5b0 100644
--- a/drivers/scsi/lpfc/lpfc_init.c
+++ b/drivers/scsi/lpfc/lpfc_init.c
@@ -13170,6 +13170,7 @@ lpfc_sli4_enable_msi(struct lpfc_hba *phba)
 	eqhdl = lpfc_get_eq_hdl(0);
 	rc = pci_irq_vector(phba->pcidev, 0);
 	if (rc < 0) {
+		free_irq(phba->pcidev->irq, phba);
 		pci_free_irq_vectors(phba->pcidev);
 		lpfc_printf_log(phba, KERN_WARNING, LOG_INIT,
 				"0496 MSI pci_irq_vec failed (%d)\n", rc);
@@ -13250,6 +13251,7 @@ lpfc_sli4_enable_intr(struct lpfc_hba *phba, uint32_t cfg_mode)
 			eqhdl = lpfc_get_eq_hdl(0);
 			retval = pci_irq_vector(phba->pcidev, 0);
 			if (retval < 0) {
+				free_irq(phba->pcidev->irq, phba);
 				lpfc_printf_log(phba, KERN_WARNING, LOG_INIT,
 					"0502 INTR pci_irq_vec failed (%d)\n",
 					 retval);
-- 
2.39.5

