Return-Path: <SRS0=qHBX=6I=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7F987C54FCB
	for <linux-scsi@archiver.kernel.org>; Fri, 24 Apr 2020 11:37:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5A9E320767
	for <linux-scsi@archiver.kernel.org>; Fri, 24 Apr 2020 11:37:38 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=synopsys.com header.i=@synopsys.com header.b="N4dYuxqU"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726920AbgDXLhY (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 24 Apr 2020 07:37:24 -0400
Received: from smtprelay-out1.synopsys.com ([149.117.87.133]:43908 "EHLO
        smtprelay-out1.synopsys.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726798AbgDXLhX (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 24 Apr 2020 07:37:23 -0400
Received: from mailhost.synopsys.com (mdc-mailhost1.synopsys.com [10.225.0.209])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id AB5FCC0339;
        Fri, 24 Apr 2020 11:37:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1587728243; bh=Kdkz2c2eoMxFLfQe031hFNSbGAX9E7zYNTPeDp82S8s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:In-Reply-To:
         References:From;
        b=N4dYuxqUA9OTOsx9Zy1mrvltv9gyN02r6VGkNONaTmS2VaF+Qj/sGe0feG0LtkUFf
         mnqlCDPlYZc8e6LYbwJXx5H68pnfMta4/iv19PvVWrd5yyrARGHhtaE0o28iaPW0+a
         HYH8Tl7SsCS/5NlpE47Q1MGv9UH464dn++8j5tGuYcU4uOz3pLEOmrwxlHVP04YGcM
         5wG75361T6Y412TrE+EecIGQAllbG5yfFUYzinFY+2i7mUN4Th1QattB3p2l54AteX
         DEi6KtLo4YOmeb/IAbJ+WaK6Zsjpu9qLtg8ABY253m8XfK/cTObtsvGc4Z9KdnpNU2
         gAZPUvMcc9Xew==
Received: from de02dwia024.internal.synopsys.com (de02dwia024.internal.synopsys.com [10.225.19.81])
        by mailhost.synopsys.com (Postfix) with ESMTP id 67740A006C;
        Fri, 24 Apr 2020 11:37:21 +0000 (UTC)
From:   Jose Abreu <Jose.Abreu@synopsys.com>
To:     linux-scsi@vger.kernel.org
Cc:     Joao Pinto <Joao.Pinto@synopsys.com>,
        Jose Abreu <Jose.Abreu@synopsys.com>,
        Joao Lima <Joao.Lima@synopsys.com>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 4/5] scsi: ufs: tc-dwc-pci: Allow for MSI interrupt type
Date:   Fri, 24 Apr 2020 13:36:59 +0200
Message-Id: <9b5c2d47997629c55ac14ce594771e9e8f254c74.1587727756.git.Jose.Abreu@synopsys.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <cover.1587727756.git.Jose.Abreu@synopsys.com>
References: <cover.1587727756.git.Jose.Abreu@synopsys.com>
In-Reply-To: <cover.1587727756.git.Jose.Abreu@synopsys.com>
References: <cover.1587727756.git.Jose.Abreu@synopsys.com>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Newer Test Chips boards have MSI support. It does no harm to try to
request it as the function will fallback to legacy interrupts if MSI is
not supported.

Signed-off-by: Jose Abreu <Jose.Abreu@synopsys.com>

---
Cc: Joao Lima <Joao.Lima@synopsys.com>
Cc: Jose Abreu <Jose.Abreu@synopsys.com>
Cc: Alim Akhtar <alim.akhtar@samsung.com>
Cc: Avri Altman <avri.altman@wdc.com>
Cc: "James E.J. Bottomley" <jejb@linux.ibm.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
---
 drivers/scsi/ufs/tc-dwc-pci.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/ufs/tc-dwc-pci.c b/drivers/scsi/ufs/tc-dwc-pci.c
index 74a2d80d32bd..e0a880cbbe68 100644
--- a/drivers/scsi/ufs/tc-dwc-pci.c
+++ b/drivers/scsi/ufs/tc-dwc-pci.c
@@ -136,9 +136,15 @@ tc_dwc_pci_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 		return -ENOENT;
 	}
 
+	err = pci_alloc_irq_vectors(pdev, 1, 1, PCI_IRQ_ALL_TYPES);
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
 		return err;
-- 
2.7.4

