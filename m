Received: from mail-m49198.qiye.163.com (mail-m49198.qiye.163.com [45.254.49.198])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B07C43254BD;
	Tue, 30 Dec 2025 14:59:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.254.49.198
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767106754; cv=none; b=hIRmn04Mq4+7L/JZV04QVIEaJBpDuFTnBCGkPKMO6iF3VSySiViYI8IhpaWdkk0Ed04gpsaI/IQ29m6jpjMGnMBZlaxlq8psUy6adHxyVe47V9RZXcodhvfjCiABOpt3J58IKINtv9r9IidfJ8o3H8BMfMOJvjS2xhZRb1NvrLw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767106754; c=relaxed/simple;
	bh=ZIvQDxZDetnQ0xfwwElweUFce4vC+1SpEyM58qQ/cB0=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=kRlQD5B905C5Hy0eGdFSWz128byP7zm6XGRZaAjve+aSmySUriorw9Fa9ejm9luN02XQbNbRBZYyxHx3JyOe+qQkvvNfN5ghnTgc7b9omdxINonMded7E/MuW3pplye5r7WS9Y5Y56Bge2zgOCmndE7hpU0AQ+0wQrzDR7eSQCo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=seu.edu.cn; spf=pass smtp.mailfrom=seu.edu.cn; dkim=pass (1024-bit key) header.d=seu.edu.cn header.i=@seu.edu.cn header.b=nG1Ki6N+; arc=none smtp.client-ip=45.254.49.198
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=seu.edu.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=seu.edu.cn
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=seu.edu.cn header.i=@seu.edu.cn header.b="nG1Ki6N+"
Received: from LAPTOP-N070L597.localdomain (unknown [223.112.146.162])
	by smtp.qiye.163.com (Hmail) with ESMTP id 2f0b66557;
	Tue, 30 Dec 2025 22:59:06 +0800 (GMT+08:00)
From: Zilin Guan <zilin@seu.edu.cn>
To: justin.tee@broadcom.com
Cc: paul.ely@broadcom.com,
	James.Bottomley@HansenPartnership.com,
	martin.petersen@oracle.com,
	Markus.Elfring@web.de,
	jianhao.xu@seu.edu.cn,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Zilin Guan <zilin@seu.edu.cn>
Subject: [PATCH v2 1/3] scsi: lpfc: Fix memory leak in lpfc_config_port_post()
Date: Tue, 30 Dec 2025 14:58:56 +0000
Message-Id: <20251230145858.1356864-2-zilin@seu.edu.cn>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20251230145858.1356864-1-zilin@seu.edu.cn>
References: <20251230145858.1356864-1-zilin@seu.edu.cn>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-HM-Tid: 0a9b6fc5185e03a1kunmc44e99e11660b8
X-HM-MType: 10
X-HM-Spam-Status: e1kfGhgUHx5ZQUpXWQgPGg8OCBgUHx5ZQUlOS1dZFg8aDwILHllBWSg2Ly
	tZV1koWUFITzdXWS1ZQUlXWQ8JGhUIEh9ZQVkZTkNIVhgaGk4ZSBgfSkIYH1YeHw5VEwETFhoSFy
	QUDg9ZV1kYEgtZQVlJSUhVSkpJVUpPTVVKTUlZV1kWGg8SFR0UWUFZT0tIVUpLSUJDQ0xVSktLVU
	tZBg++
DKIM-Signature: a=rsa-sha256;
	b=nG1Ki6N+7NLN1idebOGNRsE9TU0PdjrziNOCNQT4wNpOoKHxV7g2bPlg52/ppneFdGSpKNZ5cSagReJlN3WO8Nd8bPk1w3hkKLpiZnJAPqo56eDYV8CU+N5MMEKu1E3m/oJSRwX/hmEGp5pYuWsYFZUjBF4HGY2NLozSUJ7iaKU=; s=default; c=relaxed/relaxed; d=seu.edu.cn; v=1;
	bh=1yQ2WTZI2O8HROjoaf/lEGkd9+VlSDWeeazkE0xc8GM=;
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
v2:
- Refactor error handling to use a goto label for cleanup.

 drivers/scsi/lpfc/lpfc_init.c | 19 +++++++++----------
 1 file changed, 9 insertions(+), 10 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
index b1460b16dd91..1390d2b5095d 100644
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
@@ -550,8 +549,7 @@ lpfc_config_port_post(struct lpfc_hba *phba)
 	if (phba->intr_type == MSIX) {
 		rc = lpfc_config_msi(phba, pmb);
 		if (rc) {
-			mempool_free(pmb, phba->mbox_mem_pool);
-			return -EIO;
+			goto out_free;
 		}
 		rc = lpfc_sli_issue_mbox(phba, pmb, MBX_POLL);
 		if (rc != MBX_SUCCESS) {
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

