Return-Path: <SRS0=qHBX=6I=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CA941C54FD0
	for <linux-scsi@archiver.kernel.org>; Fri, 24 Apr 2020 13:45:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AB7C220728
	for <linux-scsi@archiver.kernel.org>; Fri, 24 Apr 2020 13:45:14 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=synopsys.com header.i=@synopsys.com header.b="CcR/fbO+"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727801AbgDXNpF (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 24 Apr 2020 09:45:05 -0400
Received: from smtprelay-out1.synopsys.com ([149.117.73.133]:45434 "EHLO
        smtprelay-out1.synopsys.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726806AbgDXNpE (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 24 Apr 2020 09:45:04 -0400
Received: from mailhost.synopsys.com (mdc-mailhost1.synopsys.com [10.225.0.209])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id 16AFF404B8;
        Fri, 24 Apr 2020 13:45:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1587735904; bh=ydPoZRUelRe6CU9Hp1tIyZfCVvTrM8j0ovTLVduK/no=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:In-Reply-To:
         References:From;
        b=CcR/fbO+1ynLZ+XgLl9RKEwMBPx3k2p+IozSw0SuIipGu7/WSWhsSetuXK4B/J3Px
         6PMVkh0O6dlv+7IDAwcl0pw03IytWG4dvGybSv/8zvMuaEWtM1w+f/8sc+q/7Z6Vdf
         flJMUOqywAlxpBX2WThzcKVQS0Pfa7oRB86eI/6ocA8mj+u6Lr2NKw891yQS6JO6AI
         lqmItRU/XhIboGanh2n3/gowCnldmkn7UuUXm1LcIMLuZyZDvru2Ozhnt88a3DrfAD
         1VRN5yNJaK6ErApH4tQwgvxrIljPZexHJMJgJ3qNHVRP7y1XKEzc3PM5YrVA8B9HrJ
         Ha3ZtWrPrIf7w==
Received: from de02dwia024.internal.synopsys.com (de02dwia024.internal.synopsys.com [10.225.19.81])
        by mailhost.synopsys.com (Postfix) with ESMTP id D1994A006C;
        Fri, 24 Apr 2020 13:45:02 +0000 (UTC)
From:   Jose Abreu <Jose.Abreu@synopsys.com>
To:     linux-scsi@vger.kernel.org
Cc:     Joao Pinto <Joao.Pinto@synopsys.com>,
        Jose Abreu <Jose.Abreu@synopsys.com>,
        "Winkler, Tomas" <tomas.winkler@intel.com>,
        Joao Lima <Joao.Lima@synopsys.com>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 4/5] scsi: ufs: tc-dwc-pci: Allow for MSI interrupt type
Date:   Fri, 24 Apr 2020 15:44:48 +0200
Message-Id: <05ba98b7a98520e3ac3884037ee481da460d0dcc.1587735561.git.Jose.Abreu@synopsys.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <cover.1587735561.git.Jose.Abreu@synopsys.com>
References: <cover.1587735561.git.Jose.Abreu@synopsys.com>
In-Reply-To: <cover.1587735561.git.Jose.Abreu@synopsys.com>
References: <cover.1587735561.git.Jose.Abreu@synopsys.com>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Newer Test Chips boards have MSI support. It does no harm to try to
request it as the function will fallback to legacy interrupts if MSI is
not supported.

Signed-off-by: Jose Abreu <Jose.Abreu@synopsys.com>

---

Changes from v1:
- Do not try to request MSIX vectors (Tomas)
- Add missing call to pci_free_irq_vectors() (Tomas)

Cc: "Winkler, Tomas" <tomas.winkler@intel.com>
Cc: Joao Lima <Joao.Lima@synopsys.com>
Cc: Jose Abreu <Jose.Abreu@synopsys.com>
Cc: Alim Akhtar <alim.akhtar@samsung.com>
Cc: Avri Altman <avri.altman@wdc.com>
Cc: "James E.J. Bottomley" <jejb@linux.ibm.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
---
 drivers/scsi/ufs/tc-dwc-pci.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/ufs/tc-dwc-pci.c b/drivers/scsi/ufs/tc-dwc-pci.c
index 74a2d80d32bd..78dc6c484e84 100644
--- a/drivers/scsi/ufs/tc-dwc-pci.c
+++ b/drivers/scsi/ufs/tc-dwc-pci.c
@@ -88,6 +88,7 @@ static void tc_dwc_pci_remove(struct pci_dev *pdev)
 	pm_runtime_forbid(&pdev->dev);
 	pm_runtime_get_noresume(&pdev->dev);
 	ufshcd_remove(hba);
+	pci_free_irq_vectors(pdev);
 }
 
 /**
@@ -136,11 +137,18 @@ tc_dwc_pci_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 		return -ENOENT;
 	}
 
+	err = pci_alloc_irq_vectors(pdev, 1, 1, PCI_IRQ_LEGACY | PCI_IRQ_MSI);
+	if (err < 0) {
+		dev_err(&pdev->dev, "Allocation failed\n");
+		return err;
+	}
+
 	hba->vops = &data->ops;
 
-	err = ufshcd_init(hba, mmio_base, pdev->irq);
+	err = ufshcd_init(hba, mmio_base, pci_irq_vector(pdev, 0));
 	if (err) {
 		dev_err(&pdev->dev, "Initialization failed\n");
+		pci_free_irq_vectors(pdev);
 		return err;
 	}
 
-- 
2.7.4

