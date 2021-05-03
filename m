Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9AEE9C433ED
	for <linux-scsi@archiver.kernel.org>; Mon,  3 May 2021 15:04:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 651086127A
	for <linux-scsi@archiver.kernel.org>; Mon,  3 May 2021 15:04:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230257AbhECPEy (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 3 May 2021 11:04:54 -0400
Received: from mx2.suse.de ([195.135.220.15]:40876 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230209AbhECPEn (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 3 May 2021 11:04:43 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id BC0D2B22B;
        Mon,  3 May 2021 15:03:44 +0000 (UTC)
From:   Hannes Reinecke <hare@suse.de>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        John Garry <john.garry@huawei.com>, linux-scsi@vger.kernel.org,
        Hannes Reinecke <hare@suse.de>,
        Don Brace <don.brace@microchip.com>
Subject: [PATCH 11/18] hpsa: move hpsa_hba_inquiry after scsi_add_host()
Date:   Mon,  3 May 2021 17:03:26 +0200
Message-Id: <20210503150333.130310-12-hare@suse.de>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210503150333.130310-1-hare@suse.de>
References: <20210503150333.130310-1-hare@suse.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Move hpsa_hba_inquiry to after scsi_add_host() so that the host
is fully initialized.

Signed-off-by: Hannes Reinecke <hare@suse.de>
Acked-by: Don Brace <don.brace@microchip.com>
Tested-by: Don Brace <don.brace@microchip.com>
---
 drivers/scsi/hpsa.c | 37 +++++++++++++++++++------------------
 1 file changed, 19 insertions(+), 18 deletions(-)

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index 38369766511c..c82f218cd1f6 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -5874,6 +5874,22 @@ static int hpsa_scsi_host_alloc(struct ctlr_info *h)
 	return 0;
 }
 
+static void hpsa_hba_inquiry(struct ctlr_info *h)
+{
+	int rc;
+
+#define HBA_INQUIRY_BYTE_COUNT 64
+	h->hba_inquiry_data = kmalloc(HBA_INQUIRY_BYTE_COUNT, GFP_KERNEL);
+	if (!h->hba_inquiry_data)
+		return;
+	rc = hpsa_scsi_do_inquiry(h, RAID_CTLR_LUNID, 0,
+		h->hba_inquiry_data, HBA_INQUIRY_BYTE_COUNT);
+	if (rc != 0) {
+		kfree(h->hba_inquiry_data);
+		h->hba_inquiry_data = NULL;
+	}
+}
+
 static int hpsa_scsi_add_host(struct ctlr_info *h)
 {
 	int rv;
@@ -5883,6 +5899,9 @@ static int hpsa_scsi_add_host(struct ctlr_info *h)
 		dev_err(&h->pdev->dev, "scsi_add_host failed\n");
 		return rv;
 	}
+
+	hpsa_hba_inquiry(h);
+
 	scsi_scan_host(h->scsi_host);
 	return 0;
 }
@@ -7949,22 +7968,6 @@ static int hpsa_pci_init(struct ctlr_info *h)
 	return err;
 }
 
-static void hpsa_hba_inquiry(struct ctlr_info *h)
-{
-	int rc;
-
-#define HBA_INQUIRY_BYTE_COUNT 64
-	h->hba_inquiry_data = kmalloc(HBA_INQUIRY_BYTE_COUNT, GFP_KERNEL);
-	if (!h->hba_inquiry_data)
-		return;
-	rc = hpsa_scsi_do_inquiry(h, RAID_CTLR_LUNID, 0,
-		h->hba_inquiry_data, HBA_INQUIRY_BYTE_COUNT);
-	if (rc != 0) {
-		kfree(h->hba_inquiry_data);
-		h->hba_inquiry_data = NULL;
-	}
-}
-
 static int hpsa_init_reset_devices(struct pci_dev *pdev, u32 board_id)
 {
 	int rc, i;
@@ -8869,8 +8872,6 @@ static int hpsa_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 	/* Turn the interrupts on so we can service requests */
 	h->access.set_intr_mask(h, HPSA_INTR_ON);
 
-	hpsa_hba_inquiry(h);
-
 	h->lastlogicals = kzalloc(sizeof(*(h->lastlogicals)), GFP_KERNEL);
 	if (!h->lastlogicals)
 		dev_info(&h->pdev->dev,
-- 
2.29.2

