Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E56A7C433F5
	for <linux-scsi@archiver.kernel.org>; Thu, 25 Nov 2021 15:13:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355975AbhKYPQT (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 25 Nov 2021 10:16:19 -0500
Received: from smtp-out1.suse.de ([195.135.220.28]:35628 "EHLO
        smtp-out1.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354002AbhKYPOO (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 25 Nov 2021 10:14:14 -0500
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out1.suse.de (Postfix) with ESMTP id 2322021B37;
        Thu, 25 Nov 2021 15:11:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1637853062; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=AixfXiIGH2bhLD5l9eshfBQ/VT0uzH9fb4WosDxbBno=;
        b=uNw8zuYBXHcoCDBcKpyYAnSAlKujsaqXJNdFY7+Vy/qRIiJfD9y7feH62Yq6Boz7vtzi5D
        lKPMWkjQbnDpWGooIxj1/bjG0d2oXRWsNT9OtUF62gqeVC3oJcHbEWhj+s4UyAKjRNaxjC
        Gbly8Ic0gxC05nYqXXlgSfEQ5EVpOCQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1637853062;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=AixfXiIGH2bhLD5l9eshfBQ/VT0uzH9fb4WosDxbBno=;
        b=Bc7Yx95wXnkdyOtxCUHpvvNKmcPF6wh9GfspHh1PkbE4EBugOVpnJBYWvS1nX/Ew7w+8+E
        Js2LpPT72ySCvdAg==
Received: from adalid.arch.suse.de (adalid.arch.suse.de [10.161.8.13])
        by relay2.suse.de (Postfix) with ESMTP id 174A4A3B92;
        Thu, 25 Nov 2021 15:11:02 +0000 (UTC)
Received: by adalid.arch.suse.de (Postfix, from userid 16045)
        id BC56B5191A00; Thu, 25 Nov 2021 16:11:01 +0100 (CET)
From:   Hannes Reinecke <hare@suse.de>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org, John Garry <john.garry@huawei.com>,
        Bart van Assche <bvanassche@acm.org>,
        Hannes Reinecke <hare@suse.de>, Hannes Reinecke <hare@suse.com>
Subject: [PATCH 10/15] aacraid: move scsi_add_host()
Date:   Thu, 25 Nov 2021 16:10:43 +0100
Message-Id: <20211125151048.103910-11-hare@suse.de>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20211125151048.103910-1-hare@suse.de>
References: <20211125151048.103910-1-hare@suse.de>
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
index a911252075a6..b92a6595358e 100644
--- a/drivers/scsi/aacraid/linit.c
+++ b/drivers/scsi/aacraid/linit.c
@@ -1643,6 +1643,9 @@ static int aac_probe_one(struct pci_dev *pdev, const struct pci_device_id *id)
 	shost->irq = pdev->irq;
 	shost->unique_id = unique_id;
 	shost->max_cmd_len = 16;
+	shost->max_id = MAXIMUM_NUM_CONTAINERS;
+	shost->max_lun = AAC_MAX_LUN;
+	shost->sg_tablesize = HBA_MAX_SG_SEPARATE;
 
 	if (aac_cfg_major == AAC_CHARDEV_NEEDS_REINIT)
 		aac_init_char();
@@ -1681,7 +1684,7 @@ static int aac_probe_one(struct pci_dev *pdev, const struct pci_device_id *id)
 	aac->base_size = AAC_MIN_FOOTPRINT_SIZE;
 	if ((*aac_drivers[index].init)(aac)) {
 		error = -ENODEV;
-		goto out_unmap;
+		goto out_free_fibs;
 	}
 
 	if (aac->sync_mode) {
@@ -1707,9 +1710,15 @@ static int aac_probe_one(struct pci_dev *pdev, const struct pci_device_id *id)
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
@@ -1768,18 +1777,6 @@ static int aac_probe_one(struct pci_dev *pdev, const struct pci_device_id *id)
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
@@ -1796,10 +1793,12 @@ static int aac_probe_one(struct pci_dev *pdev, const struct pci_device_id *id)
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
@@ -1907,9 +1906,9 @@ static void aac_remove_one(struct pci_dev *pdev)
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

