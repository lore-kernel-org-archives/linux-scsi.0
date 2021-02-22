Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EF293C433DB
	for <linux-scsi@archiver.kernel.org>; Mon, 22 Feb 2021 13:30:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AC17B64E27
	for <linux-scsi@archiver.kernel.org>; Mon, 22 Feb 2021 13:30:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231887AbhBVN36 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 22 Feb 2021 08:29:58 -0500
Received: from mx2.suse.de ([195.135.220.15]:47786 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231185AbhBVN2Q (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 22 Feb 2021 08:28:16 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 13CBBB000;
        Mon, 22 Feb 2021 13:24:16 +0000 (UTC)
From:   Hannes Reinecke <hare@suse.de>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     James Bottomley <james.bottomley@hansenpartnership.com>,
        Christoph Hellwig <hch@lst.de>,
        John Garry <john.garry@huawei.com>, linux-scsi@vger.kernel.org,
        Hannes Reinecke <hare@suse.de>, Hannes Reinecke <hare@suse.com>
Subject: [PATCH 17/31] aacraid: move scsi_add_host()
Date:   Mon, 22 Feb 2021 14:23:51 +0100
Message-Id: <20210222132405.91369-18-hare@suse.de>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210222132405.91369-1-hare@suse.de>
References: <20210222132405.91369-1-hare@suse.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Move the call to scsi_add_host() so that the Scsi_Host structure
is initialized before any I/O is sent.

Signed-off-by: Hannes Reinecke <hare@suse.com>
---
 drivers/scsi/aacraid/linit.c | 31 +++++++++++++++----------------
 1 file changed, 15 insertions(+), 16 deletions(-)

diff --git a/drivers/scsi/aacraid/linit.c b/drivers/scsi/aacraid/linit.c
index 3168915adaa7..e5d89b309c3a 100644
--- a/drivers/scsi/aacraid/linit.c
+++ b/drivers/scsi/aacraid/linit.c
@@ -1639,6 +1639,9 @@ static int aac_probe_one(struct pci_dev *pdev, const struct pci_device_id *id)
 	shost->irq = pdev->irq;
 	shost->unique_id = unique_id;
 	shost->max_cmd_len = 16;
+	shost->max_id = MAXIMUM_NUM_CONTAINERS;
+	shost->max_lun = AAC_MAX_LUN;
+	shost->sg_tablesize = HBA_MAX_SG_SEPARATE;
 
 	if (aac_cfg_major == AAC_CHARDEV_NEEDS_REINIT)
 		aac_init_char();
@@ -1677,7 +1680,7 @@ static int aac_probe_one(struct pci_dev *pdev, const struct pci_device_id *id)
 	aac->base_size = AAC_MIN_FOOTPRINT_SIZE;
 	if ((*aac_drivers[index].init)(aac)) {
 		error = -ENODEV;
-		goto out_unmap;
+		goto out_free_fibs;
 	}
 
 	if (aac->sync_mode) {
@@ -1703,9 +1706,15 @@ static int aac_probe_one(struct pci_dev *pdev, const struct pci_device_id *id)
 		printk(KERN_ERR "aacraid: Unable to create command thread.\n");
 		error = PTR_ERR(aac->thread);
 		aac->thread = NULL;
-		goto out_deinit;
+		goto out_unmap;
 	}
 
+	pci_set_drvdata(pdev, shost);
+
+	error = scsi_add_host(shost, &pdev->dev);
+	if (error)
+		goto out_deinit;
+
 	aac->maximum_num_channels = aac_drivers[index].channels;
 	error = aac_get_adapter_info(aac);
 	if (error < 0)
@@ -1764,18 +1773,6 @@ static int aac_probe_one(struct pci_dev *pdev, const struct pci_device_id *id)
 	if (!aac->sa_firmware && aac_drivers[index].quirks & AAC_QUIRK_SRC)
 		aac_intr_normal(aac, 0, 2, 0, NULL);
 
-	/*
-	 * dmb - we may need to move the setting of these parms somewhere else once
-	 * we get a fib that can report the actual numbers
-	 */
-	shost->max_lun = AAC_MAX_LUN;
-
-	pci_set_drvdata(pdev, shost);
-
-	error = scsi_add_host(shost, &pdev->dev);
-	if (error)
-		goto out_deinit;
-
 	aac_scan_host(aac);
 
 	pci_enable_pcie_error_reporting(pdev);
@@ -1792,10 +1789,12 @@ static int aac_probe_one(struct pci_dev *pdev, const struct pci_device_id *id)
 				  aac->comm_addr, aac->comm_phys);
 	kfree(aac->queues);
 	aac_adapter_ioremap(aac, 0);
-	kfree(aac->fibs);
 	kfree(aac->fsa_dev);
+ out_free_fibs:
+	kfree(aac->fibs);
  out_free_host:
 	scsi_host_put(shost);
+	pci_set_drvdata(pdev, NULL);
  out_disable_pdev:
 	pci_disable_device(pdev);
  out:
@@ -1903,9 +1902,9 @@ static void aac_remove_one(struct pci_dev *pdev)
 	struct aac_dev *aac = (struct aac_dev *)shost->hostdata;
 
 	aac_cancel_rescan_worker(aac);
-	scsi_remove_host(shost);
 
 	__aac_shutdown(aac);
+	scsi_remove_host(shost);
 	aac_fib_map_free(aac);
 	dma_free_coherent(&aac->pdev->dev, aac->comm_size, aac->comm_addr,
 			  aac->comm_phys);
-- 
2.29.2

