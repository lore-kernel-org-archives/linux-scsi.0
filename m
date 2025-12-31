Received: from mail-m155101.qiye.163.com (mail-m155101.qiye.163.com [101.71.155.101])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8336528751D;
	Wed, 31 Dec 2025 15:11:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=101.71.155.101
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767193885; cv=none; b=BUEmESy25c259cg/aJD/bRZZvqMZ2bghMiGhHD47Osnwt60aMlytNxZlayM6P62ld6vQoIb0kW6hXk/Q1NFt4IaG4flbHsire5GBrr//Dpz42j3AI8SsP1I5gysaknzMsHgcfC8v3QlNsS2cyISjAgRZd3Zl1U/Rc7hAkpFIhec=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767193885; c=relaxed/simple;
	bh=aghNKRPtPssAjSH810kXRcNHGVU0R6vBLYHruq/GreA=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=DGb//wV0HeQW/8o/eerRbbhukp0nC721GFaKnUtVv1TPUbGLpct8DXj2ShgjqjNHueD504lQqmmPTz+d4fAUZqYbbEXSqwbd2DOHwvIpW22xSp1Fp7brmU7ybovoLcEwUSfs4+1v/aNIZJ3H2uk8Kd6w5FQPeA4+pdQYJkWxaF8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=seu.edu.cn; spf=pass smtp.mailfrom=seu.edu.cn; dkim=pass (1024-bit key) header.d=seu.edu.cn header.i=@seu.edu.cn header.b=ZURKb80a; arc=none smtp.client-ip=101.71.155.101
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=seu.edu.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=seu.edu.cn
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=seu.edu.cn header.i=@seu.edu.cn header.b="ZURKb80a"
Received: from LAPTOP-N070L597.localdomain (unknown [222.191.246.242])
	by smtp.qiye.163.com (Hmail) with ESMTP id 2f2b2ecc1;
	Wed, 31 Dec 2025 23:11:17 +0800 (GMT+08:00)
From: Zilin Guan <zilin@seu.edu.cn>
To: justin.tee@broadcom.com
Cc: paul.ely@broadcom.com,
	James.Bottomley@HansenPartnership.com,
	martin.petersen@oracle.com,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Markus.Elfring@web.de,
	Zilin Guan <zilin@seu.edu.cn>,
	Jianhao Xu <jianhao.xu@seu.edu.cn>
Subject: [PATCH v3 1/3] scsi: lpfc: Fix memory leak in lpfc_config_port_post()
Date: Wed, 31 Dec 2025 15:11:07 +0000
Message-Id: <20251231151109.362373-2-zilin@seu.edu.cn>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20251231151109.362373-1-zilin@seu.edu.cn>
References: <20251231151109.362373-1-zilin@seu.edu.cn>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-HM-Tid: 0a9b74f69c0d03a1kunmad4383ff1aba4d
X-HM-MType: 10
X-HM-Spam-Status: e1kfGhgUHx5ZQUpXWQgPGg8OCBgUHx5ZQUlOS1dZFg8aDwILHllBWSg2Ly
	tZV1koWUFITzdXWS1ZQUlXWQ8JGhUIEh9ZQVkZShkZVhgaSk8YHkkYQx4ZGFYeHw5VEwETFhoSFy
	QUDg9ZV1kYEgtZQVlJSUlVSkJKVUlPTVVJT0lZV1kWGg8SFR0UWUFZT0tIVUpLSUhOQ0NVSktLVU
	tZBg++
DKIM-Signature: a=rsa-sha256;
	b=ZURKb80aQsrtKK45a5kT4UK64e/7fozKDZniKTWDdoombkyYOv1nr5mbOq0bLZCDVDVX3ELOKwszmbV/XKdxPr/kipVvhESGY4GEGZzMUkC15qQdbEcCRTTt25vAAGMMOaD1smp409/GK0PJ3JCnll8rWaQa/bw7YjCHNjwKEYA=; s=default; c=relaxed/relaxed; d=seu.edu.cn; v=1;
	bh=EJrs4tcpP7nuSQtNRoXXPGnF5r8LYcf8SJaf41xG4jA=;
	h=date:mime-version:subject:message-id:from;

In lpfc_config_port_post(), pmb is allocated via mempool_alloc() but
is not freed when lpfc_readl() fails.

Instead of simply adding the missing free, refactor the error handling
to use a goto label. This unifies the cleanup logic and ensures pmb is
freed in all error paths.

Fixes: 9940b97bb30d ("[SCSI] lpfc 8.3.22: Add support for PCI Adapter Failure")
Suggested-by: Markus Elfring <Markus.Elfring@web.de>
Co-developed-by: Jianhao Xu <jianhao.xu@seu.edu.cn>
Signed-off-by: Jianhao Xu <jianhao.xu@seu.edu.cn>
Signed-off-by: Zilin Guan <zilin@seu.edu.cn>
---
Changes in v3:
- Remove unnecessary braces for single-line if statement.

Changes in v2:
- Refactor error handling to use a goto label for cleanup.

 drivers/scsi/lpfc/lpfc_init.c | 23 +++++++++++------------
 1 file changed, 11 insertions(+), 12 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
index b1460b16dd91..c520d314b131 100644
--- a/drivers/scsi/lpfc/lpfc_init.c
+++ b/drivers/scsi/lpfc/lpfc_init.c
@@ -511,8 +511,7 @@ lpfc_config_port_post(struct lpfc_hba *phba)
 				"READ_CONFIG, mbxStatus x%x\n",
 				mb->mbxCommand, mb->mbxStatus);
 		phba->link_state = LPFC_HBA_ERROR;
-		mempool_free( pmb, phba->mbox_mem_pool);
-		return -EIO;
+		goto out_free;
 	}
 
 	/* Check if the port is disabled */
@@ -549,10 +548,9 @@ lpfc_config_port_post(struct lpfc_hba *phba)
 	 */
 	if (phba->intr_type == MSIX) {
 		rc = lpfc_config_msi(phba, pmb);
-		if (rc) {
-			mempool_free(pmb, phba->mbox_mem_pool);
-			return -EIO;
-		}
+		if (rc)
+			goto out_free;
+
 		rc = lpfc_sli_issue_mbox(phba, pmb, MBX_POLL);
 		if (rc != MBX_SUCCESS) {
 			lpfc_printf_log(phba, KERN_ERR, LOG_TRACE_EVENT,
@@ -560,8 +558,7 @@ lpfc_config_port_post(struct lpfc_hba *phba)
 					"failed, mbxCmd x%x, mbxStatus x%x\n",
 					pmb->u.mb.mbxCommand,
 					pmb->u.mb.mbxStatus);
-			mempool_free(pmb, phba->mbox_mem_pool);
-			return -EIO;
+			goto out_free;
 		}
 	}
 
@@ -572,7 +569,7 @@ lpfc_config_port_post(struct lpfc_hba *phba)
 	/* Enable appropriate host interrupts */
 	if (lpfc_readl(phba->HCregaddr, &status)) {
 		spin_unlock_irq(&phba->hbalock);
-		return -EIO;
+		goto out_free;
 	}
 	status |= HC_MBINT_ENA | HC_ERINT_ENA | HC_LAINT_ENA;
 	if (psli->num_rings > 0)
@@ -616,9 +613,7 @@ lpfc_config_port_post(struct lpfc_hba *phba)
 			lpfc_printf_log(phba, KERN_ERR, LOG_TRACE_EVENT,
 					"2599 Adapter failed to issue DOWN_LINK"
 					" mbox command rc 0x%x\n", rc);
-
-			mempool_free(pmb, phba->mbox_mem_pool);
-			return -EIO;
+			goto out_free;
 		}
 	} else if (phba->cfg_suppress_link_up == LPFC_INITIALIZE_LINK) {
 		mempool_free(pmb, phba->mbox_mem_pool);
@@ -666,6 +661,10 @@ lpfc_config_port_post(struct lpfc_hba *phba)
 	}
 
 	return 0;
+
+out_free:
+	mempool_free(pmb, phba->mbox_mem_pool);
+	return -EIO;
 }
 
 /**
-- 
2.34.1

