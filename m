Return-Path: <SRS0=2Pbo=54=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5AABBC2BB86
	for <linux-scsi@archiver.kernel.org>; Sun, 12 Apr 2020 09:40:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3EA8720708
	for <linux-scsi@archiver.kernel.org>; Sun, 12 Apr 2020 09:40:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726924AbgDLJko (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 12 Apr 2020 05:40:44 -0400
Received: from smtp02.smtpout.orange.fr ([80.12.242.124]:48804 "EHLO
        smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726043AbgDLJko (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 12 Apr 2020 05:40:44 -0400
Received: from localhost.localdomain ([90.126.162.40])
        by mwinf5d55 with ME
        id Rlgg2200K0scBcy03lghJr; Sun, 12 Apr 2020 11:40:42 +0200
X-ME-Helo: localhost.localdomain
X-ME-Auth: Y2hyaXN0b3BoZS5qYWlsbGV0QHdhbmFkb28uZnI=
X-ME-Date: Sun, 12 Apr 2020 11:40:42 +0200
X-ME-IP: 90.126.162.40
From:   Christophe JAILLET <christophe.jaillet@wanadoo.fr>
To:     aacraid@microsemi.com, jejb@linux.ibm.com,
        martin.petersen@oracle.com
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Subject: [PATCH] scsi: aacraid: Fix some error handling paths in 'aac_probe_one()'
Date:   Sun, 12 Apr 2020 11:40:39 +0200
Message-Id: <20200412094039.8822-1-christophe.jaillet@wanadoo.fr>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

If 'scsi_host_alloc()' or 'kcalloc()' fail, 'error' is known to be 0. Set
it explicitly to -ENOMEM instead before branching to the error handling
path.

While at it, axe 2 useless assignments to 'error'. These values are
overwridden a few lines later.

Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
---
 drivers/scsi/aacraid/linit.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/aacraid/linit.c b/drivers/scsi/aacraid/linit.c
index 83a60b0a8cd8..a0a2b3abc512 100644
--- a/drivers/scsi/aacraid/linit.c
+++ b/drivers/scsi/aacraid/linit.c
@@ -1632,7 +1632,7 @@ static int aac_probe_one(struct pci_dev *pdev, const struct pci_device_id *id)
 	struct Scsi_Host *shost;
 	struct aac_dev *aac;
 	struct list_head *insert = &aac_devices;
-	int error = -ENODEV;
+	int error;
 	int unique_id = 0;
 	u64 dmamask;
 	int mask_bits = 0;
@@ -1657,7 +1657,6 @@ static int aac_probe_one(struct pci_dev *pdev, const struct pci_device_id *id)
 	error = pci_enable_device(pdev);
 	if (error)
 		goto out;
-	error = -ENODEV;
 
 	if (!(aac_drivers[index].quirks & AAC_QUIRK_SRC)) {
 		error = pci_set_dma_mask(pdev, DMA_BIT_MASK(32));
@@ -1689,8 +1688,10 @@ static int aac_probe_one(struct pci_dev *pdev, const struct pci_device_id *id)
 	pci_set_master(pdev);
 
 	shost = scsi_host_alloc(&aac_driver_template, sizeof(struct aac_dev));
-	if (!shost)
+	if (!shost) {
+		error = -ENOMEM;
 		goto out_disable_pdev;
+	}
 
 	shost->irq = pdev->irq;
 	shost->unique_id = unique_id;
@@ -1714,8 +1715,11 @@ static int aac_probe_one(struct pci_dev *pdev, const struct pci_device_id *id)
 	aac->fibs = kcalloc(shost->can_queue + AAC_NUM_MGT_FIB,
 			    sizeof(struct fib),
 			    GFP_KERNEL);
-	if (!aac->fibs)
+	if (!aac->fibs) {
+		error = -ENOMEM;
 		goto out_free_host;
+	}
+
 	spin_lock_init(&aac->fib_lock);
 
 	mutex_init(&aac->ioctl_mutex);
-- 
2.20.1

