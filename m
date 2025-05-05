Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6897A239E63;
	Mon,  5 May 2025 23:05:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746486342; cv=none; b=YU0w//mW3nW5gXibJlzw7YiP3lEbMasxwozh7BmDAR3JhWQMXkSaK+TAZ0fBMEmwlC2aecyC5i2ICmiSc3X6uQwQvw+MxP592t8H+KzgCaK+Prm1rQTgpj36vL2Vx8j/wQ64vQK0lNWzaxTRHX1h4Fe0fhPh5AbJ+1pS/AskIIQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746486342; c=relaxed/simple;
	bh=GlFkKQ9JLcEprQq/Og33CGUcqlPLFdfFiF314qAebzE=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=lr2O2UPi+jHJ4jzETtv7McBkpIJV3WuMQJyuSHChBRfZjpq1Zop79XnPIlrEHuT7QwIsRd3OjrEfS4ALMpvrR9uSdN02ObCoj23nTmdW1oA32ezHWp8RI+s6lo5zxq5ppbIVDEkrmaDV3SbuN7ByYldkcQWVWtf0xI7ux/3Bajg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=FTJb18wb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FTJb18wb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F788C4CEED;
	Mon,  5 May 2025 23:05:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1746486342;
	bh=GlFkKQ9JLcEprQq/Og33CGUcqlPLFdfFiF314qAebzE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FTJb18wbvSTUYOTBZL0yIj4fcdOMUfme9/J1tWAcV5Yd3SZtgd4xL/TgltFLy2yJG
	 Oy19SBrb0NDpFgI9R7Qlcl3GU91OJkQdVT2GKa7joh08LEIL64AX42oyYmb/fuH8II
	 oc94ktoqUNGGq4etFfVnoDGY0kQ+VZkLDLXWr/VWGpKwP8QXCAkez+3wlUSrkqopC0
	 +3Fj+b5eVl1Fo8gtGz3t4DITMQOilku6ofTKfIiAoeP2HDmvHMmChBPd57Q36A8t8c
	 1vIKjzlVQSglvB+l3sLSveZXxRlZvMVqp8Kj8PrvIXRS4dmS8L9LDHGqWes50tCgZt
	 xuZUFNB60Aglg==
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
Subject: [PATCH AUTOSEL 6.6 269/294] scsi: lpfc: Free phba irq in lpfc_sli4_enable_msi() when pci_irq_vector() fails
Date: Mon,  5 May 2025 18:56:09 -0400
Message-Id: <20250505225634.2688578-269-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250505225634.2688578-1-sashal@kernel.org>
References: <20250505225634.2688578-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.6.89
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
index 424b39a8155cb..7c8e0e1d36da9 100644
--- a/drivers/scsi/lpfc/lpfc_init.c
+++ b/drivers/scsi/lpfc/lpfc_init.c
@@ -13180,6 +13180,7 @@ lpfc_sli4_enable_msi(struct lpfc_hba *phba)
 	eqhdl = lpfc_get_eq_hdl(0);
 	rc = pci_irq_vector(phba->pcidev, 0);
 	if (rc < 0) {
+		free_irq(phba->pcidev->irq, phba);
 		pci_free_irq_vectors(phba->pcidev);
 		lpfc_printf_log(phba, KERN_WARNING, LOG_INIT,
 				"0496 MSI pci_irq_vec failed (%d)\n", rc);
@@ -13260,6 +13261,7 @@ lpfc_sli4_enable_intr(struct lpfc_hba *phba, uint32_t cfg_mode)
 			eqhdl = lpfc_get_eq_hdl(0);
 			retval = pci_irq_vector(phba->pcidev, 0);
 			if (retval < 0) {
+				free_irq(phba->pcidev->irq, phba);
 				lpfc_printf_log(phba, KERN_WARNING, LOG_INIT,
 					"0502 INTR pci_irq_vec failed (%d)\n",
 					 retval);
-- 
2.39.5

