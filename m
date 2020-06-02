Return-Path: <SRS0=e+HO=7P=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 41AC2C433DF
	for <linux-scsi@archiver.kernel.org>; Tue,  2 Jun 2020 09:21:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1164D206A4
	for <linux-scsi@archiver.kernel.org>; Tue,  2 Jun 2020 09:21:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728285AbgFBJVb (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 2 Jun 2020 05:21:31 -0400
Received: from mga03.intel.com ([134.134.136.65]:55922 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726485AbgFBJVb (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 2 Jun 2020 05:21:31 -0400
IronPort-SDR: /Q4VtJXGsIiU5kWrWVLmplyue0lVFlWoSOQfmDp5ldBHEBvB8kjgbsZj+VDf9eQOSywOdQIW2P
 Df1lqZnoNOoQ==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Jun 2020 02:21:31 -0700
IronPort-SDR: Zk4p6UqDmqIfERpDP4fvJX3Mqub+M0OjDj1bzssxGtQb4VtxnI/D/+3/6aPJz6AUcBLkkMI4xT
 nFKvkvO8qguw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,463,1583222400"; 
   d="scan'208";a="444621658"
Received: from gklab-125-110.igk.intel.com ([10.91.125.110])
  by orsmga005.jf.intel.com with ESMTP; 02 Jun 2020 02:21:29 -0700
From:   Piotr Stankiewicz <piotr.stankiewicz@intel.com>
To:     Brian King <brking@us.ibm.com>,
        "James E . J . Bottomley" <jejb@linux.ibm.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Jim Gill <jgill@vmware.com>,
        VMware PV-Drivers <pv-drivers@vmware.com>
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Piotr Stankiewicz <piotr.stankiewicz@intel.com>
Subject: [PATCH 15/15] scsi: use PCI_IRQ_MSI_TYPES and PCI_IRQ_ALL_TYPES where appropriate
Date:   Tue,  2 Jun 2020 11:21:26 +0200
Message-Id: <20200602092126.32327-1-piotr.stankiewicz@intel.com>
X-Mailer: git-send-email 2.17.2
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Seeing as there is shorthand available to use when asking for any type
of interrupt, or any type of message signalled interrupt, leverage it.

Signed-off-by: Piotr Stankiewicz <piotr.stankiewicz@intel.com>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@intel.com>
---
 drivers/scsi/ipr.c        | 2 +-
 drivers/scsi/vmw_pvscsi.c | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/ipr.c b/drivers/scsi/ipr.c
index d48a8fa997b9..666dcf196d07 100644
--- a/drivers/scsi/ipr.c
+++ b/drivers/scsi/ipr.c
@@ -10275,7 +10275,7 @@ static int ipr_probe_ioa(struct pci_dev *pdev,
 
 	irq_flag = PCI_IRQ_LEGACY;
 	if (ioa_cfg->ipr_chip->has_msi)
-		irq_flag |= PCI_IRQ_MSI | PCI_IRQ_MSIX;
+		irq_flag |= PCI_IRQ_MSI_TYPES;
 	rc = pci_alloc_irq_vectors(pdev, 1, ipr_number_of_msix, irq_flag);
 	if (rc < 0) {
 		ipr_wait_for_pci_err_recovery(ioa_cfg);
diff --git a/drivers/scsi/vmw_pvscsi.c b/drivers/scsi/vmw_pvscsi.c
index c3f010df641e..825b7db9c713 100644
--- a/drivers/scsi/vmw_pvscsi.c
+++ b/drivers/scsi/vmw_pvscsi.c
@@ -1347,7 +1347,7 @@ static u32 pvscsi_get_max_targets(struct pvscsi_adapter *adapter)
 
 static int pvscsi_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 {
-	unsigned int irq_flag = PCI_IRQ_MSIX | PCI_IRQ_MSI | PCI_IRQ_LEGACY;
+	unsigned int irq_flag = PCI_IRQ_ALL_TYPES;
 	struct pvscsi_adapter *adapter;
 	struct pvscsi_adapter adapter_temp;
 	struct Scsi_Host *host = NULL;
-- 
2.17.2

