Return-Path: <SRS0=nml+=3C=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 12751C33CAD
	for <linux-scsi@archiver.kernel.org>; Mon, 13 Jan 2020 13:26:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D69CB2080D
	for <linux-scsi@archiver.kernel.org>; Mon, 13 Jan 2020 13:26:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726450AbgAMN0Q (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 13 Jan 2020 08:26:16 -0500
Received: from mx2.suse.de ([195.135.220.15]:32962 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726277AbgAMN0Q (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 13 Jan 2020 08:26:16 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id BA6DAAAC3;
        Mon, 13 Jan 2020 13:26:14 +0000 (UTC)
From:   Hannes Reinecke <hare@suse.de>
To:     Sumit Saxena <sumit.saxena@broadcom.com>
Cc:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>
Subject: [PATCH] megaraid_sas: fixup MSIx interrupt setup during resume
Date:   Mon, 13 Jan 2020 14:26:09 +0100
Message-Id: <20200113132609.69536-1-hare@suse.de>
X-Mailer: git-send-email 2.16.4
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Streamline resume workflow by using the same functions for enabling
MSIx interrupts as used during initialisation.
Without it the driver might crash during resume with:

WARNING: CPU: 2 PID: 4306 at ../drivers/pci/msi.c:1303 pci_irq_get_affinity+0x3b/0x90

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/scsi/megaraid/megaraid_sas_base.c | 20 +++++++++-----------
 1 file changed, 9 insertions(+), 11 deletions(-)

diff --git a/drivers/scsi/megaraid/megaraid_sas_base.c b/drivers/scsi/megaraid/megaraid_sas_base.c
index a4bc81479284..ec58244c680c 100644
--- a/drivers/scsi/megaraid/megaraid_sas_base.c
+++ b/drivers/scsi/megaraid/megaraid_sas_base.c
@@ -7592,7 +7592,6 @@ megasas_resume(struct pci_dev *pdev)
 	int rval;
 	struct Scsi_Host *host;
 	struct megasas_instance *instance;
-	int irq_flags = PCI_IRQ_LEGACY;
 
 	instance = pci_get_drvdata(pdev);
 
@@ -7634,16 +7633,15 @@ megasas_resume(struct pci_dev *pdev)
 	atomic_set(&instance->ldio_outstanding, 0);
 
 	/* Now re-enable MSI-X */
-	if (instance->msix_vectors) {
-		irq_flags = PCI_IRQ_MSIX;
-		if (instance->smp_affinity_enable)
-			irq_flags |= PCI_IRQ_AFFINITY;
-	}
-	rval = pci_alloc_irq_vectors(instance->pdev, 1,
-				     instance->msix_vectors ?
-				     instance->msix_vectors : 1, irq_flags);
-	if (rval < 0)
-		goto fail_reenable_msix;
+	if (instance->msix_vectors)
+		megasas_alloc_irq_vectors(instance);
+
+	if (!instance->msix_vectors) {
+		rval = pci_alloc_irq_vectors(instance->pdev, 1, 1,
+					     PCI_IRQ_LEGACY);
+		if (rval < 0)
+			goto fail_reenable_msix;
+	}
 
 	megasas_setup_reply_map(instance);
 
-- 
2.16.4

