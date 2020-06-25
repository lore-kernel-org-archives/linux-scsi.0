Return-Path: <SRS0=uw5d=AG=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.0 required=3.0
	tests=HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0130BC433E0
	for <linux-scsi@archiver.kernel.org>; Thu, 25 Jun 2020 14:01:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D13FF206B7
	for <linux-scsi@archiver.kernel.org>; Thu, 25 Jun 2020 14:01:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405319AbgFYOBz (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 25 Jun 2020 10:01:55 -0400
Received: from mx2.suse.de ([195.135.220.15]:41292 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2405300AbgFYOBu (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 25 Jun 2020 10:01:50 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id EF510AF5B;
        Thu, 25 Jun 2020 14:01:45 +0000 (UTC)
From:   Hannes Reinecke <hare@suse.de>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        John Garry <john.garry@huawei.com>,
        Don Brace <don.brace@microchip.de>,
        Bart van Assche <bvanassche@acm.org>,
        linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>
Subject: [PATCH 15/22] hpsa: move hpsa_hba_inquiry after scsi_add_host()
Date:   Thu, 25 Jun 2020 16:01:17 +0200
Message-Id: <20200625140124.17201-16-hare@suse.de>
X-Mailer: git-send-email 2.16.4
In-Reply-To: <20200625140124.17201-1-hare@suse.de>
References: <20200625140124.17201-1-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Move hpsa_hba_inquiry to after scsi_add_host() so that the host
is fully initialized.

Signed-off-by: Hannes Reinecke <hare@suse.de>
Tested-by: Don Brace <don.brace@microchip.com>
---
 drivers/scsi/hpsa.c | 37 +++++++++++++++++++------------------
 1 file changed, 19 insertions(+), 18 deletions(-)

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index 81d0414e2117..db0142a16a72 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -5839,6 +5839,22 @@ static int hpsa_scsi_host_alloc(struct ctlr_info *h)
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
@@ -5848,6 +5864,9 @@ static int hpsa_scsi_add_host(struct ctlr_info *h)
 		dev_err(&h->pdev->dev, "scsi_add_host failed\n");
 		return rv;
 	}
+
+	hpsa_hba_inquiry(h);
+
 	scsi_scan_host(h->scsi_host);
 	return 0;
 }
@@ -7901,22 +7920,6 @@ static int hpsa_pci_init(struct ctlr_info *h)
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
@@ -8825,8 +8828,6 @@ static int hpsa_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 	/* Turn the interrupts on so we can service requests */
 	h->access.set_intr_mask(h, HPSA_INTR_ON);
 
-	hpsa_hba_inquiry(h);
-
 	h->lastlogicals = kzalloc(sizeof(*(h->lastlogicals)), GFP_KERNEL);
 	if (!h->lastlogicals)
 		dev_info(&h->pdev->dev,
-- 
2.16.4

