Return-Path: <SRS0=wv9C=AK=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.0 required=3.0
	tests=HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D3783C433DF
	for <linux-scsi@archiver.kernel.org>; Mon, 29 Jun 2020 19:12:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C08AD20723
	for <linux-scsi@archiver.kernel.org>; Mon, 29 Jun 2020 19:12:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730251AbgF2TMB (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 29 Jun 2020 15:12:01 -0400
Received: from mx2.suse.de ([195.135.220.15]:53586 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731051AbgF2TLY (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 29 Jun 2020 15:11:24 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 88067B123;
        Mon, 29 Jun 2020 07:20:56 +0000 (UTC)
From:   Hannes Reinecke <hare@suse.de>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        Bart van Assche <bvanassche@acm.org>,
        Don Brace <don.brace@microchip.com>,
        John Garry <john.garry@huawei.com>, linux-scsi@vger.kernel.org,
        Hannes Reinecke <hare@suse.de>, Hannes Reinecke <hare@suse.com>
Subject: [PATCH 19/22] aacraid: move scsi_add_host()
Date:   Mon, 29 Jun 2020 09:20:18 +0200
Message-Id: <20200629072021.9864-20-hare@suse.de>
X-Mailer: git-send-email 2.16.4
In-Reply-To: <20200629072021.9864-1-hare@suse.de>
References: <20200629072021.9864-1-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
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
index a308e86a97f1..91cbe479cfa8 100644
--- a/drivers/scsi/aacraid/linit.c
+++ b/drivers/scsi/aacraid/linit.c
@@ -1696,6 +1696,9 @@ static int aac_probe_one(struct pci_dev *pdev, const struct pci_device_id *id)
 	shost->irq = pdev->irq;
 	shost->unique_id = unique_id;
 	shost->max_cmd_len = 16;
+	shost->max_id = MAXIMUM_NUM_CONTAINERS;
+	shost->max_lun = AAC_MAX_LUN;
+	shost->sg_tablesize = HBA_MAX_SG_SEPARATE;
 
 	if (aac_cfg_major == AAC_CHARDEV_NEEDS_REINIT)
 		aac_init_char();
@@ -1734,7 +1737,7 @@ static int aac_probe_one(struct pci_dev *pdev, const struct pci_device_id *id)
 	aac->base_size = AAC_MIN_FOOTPRINT_SIZE;
 	if ((*aac_drivers[index].init)(aac)) {
 		error = -ENODEV;
-		goto out_unmap;
+		goto out_free_fibs;
 	}
 
 	if (aac->sync_mode) {
@@ -1760,9 +1763,15 @@ static int aac_probe_one(struct pci_dev *pdev, const struct pci_device_id *id)
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
@@ -1821,18 +1830,6 @@ static int aac_probe_one(struct pci_dev *pdev, const struct pci_device_id *id)
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
@@ -1849,10 +1846,12 @@ static int aac_probe_one(struct pci_dev *pdev, const struct pci_device_id *id)
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
@@ -1979,9 +1978,9 @@ static void aac_remove_one(struct pci_dev *pdev)
 	struct aac_dev *aac = (struct aac_dev *)shost->hostdata;
 
 	aac_cancel_rescan_worker(aac);
-	scsi_remove_host(shost);
 
 	__aac_shutdown(aac);
+	scsi_remove_host(shost);
 	aac_fib_map_free(aac);
 	dma_free_coherent(&aac->pdev->dev, aac->comm_size, aac->comm_addr,
 			  aac->comm_phys);
-- 
2.16.4

