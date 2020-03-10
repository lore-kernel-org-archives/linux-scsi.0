Return-Path: <SRS0=Pfrg=43=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4CE7FC18E5B
	for <linux-scsi@archiver.kernel.org>; Tue, 10 Mar 2020 16:30:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2DD8720848
	for <linux-scsi@archiver.kernel.org>; Tue, 10 Mar 2020 16:30:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727030AbgCJQal (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 10 Mar 2020 12:30:41 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:35456 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726395AbgCJQak (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 10 Mar 2020 12:30:40 -0400
Received: from DGGEMS414-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id AAB0846DB4A5C061FC87;
        Wed, 11 Mar 2020 00:30:33 +0800 (CST)
Received: from localhost.localdomain (10.69.192.58) by
 DGGEMS414-HUB.china.huawei.com (10.3.19.214) with Microsoft SMTP Server id
 14.3.487.0; Wed, 11 Mar 2020 00:30:27 +0800
From:   John Garry <john.garry@huawei.com>
To:     <axboe@kernel.dk>, <jejb@linux.ibm.com>,
        <martin.petersen@oracle.com>, <hare@suse.de>,
        <ming.lei@redhat.com>, <bvanassche@acm.org>, <hch@infradead.org>
CC:     <linux-block@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-scsi@vger.kernel.org>,
        <virtualization@lists.linux-foundation.org>,
        <esc.storagedev@microsemi.com>, <chenxiang66@hisilicon.com>,
        Hannes Reinecke <hare@suse.com>
Subject: [PATCH RFC v2 11/24] hpsa: move hpsa_hba_inquiry after scsi_add_host()
Date:   Wed, 11 Mar 2020 00:25:37 +0800
Message-ID: <1583857550-12049-12-git-send-email-john.garry@huawei.com>
X-Mailer: git-send-email 2.8.1
In-Reply-To: <1583857550-12049-1-git-send-email-john.garry@huawei.com>
References: <1583857550-12049-1-git-send-email-john.garry@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.58]
X-CFilter-Loop: Reflected
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Hannes Reinecke <hare@suse.de>

Move hpsa_hba_inquiry to after scsi_add_host() so that the host
is fully initialized.

Signed-off-by: Hannes Reinecke <hare@suse.com>
---
 drivers/scsi/hpsa.c | 37 +++++++++++++++++++------------------
 1 file changed, 19 insertions(+), 18 deletions(-)

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index 1a4ddfacb458..703f824584fe 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -5814,6 +5814,22 @@ static int hpsa_scsi_host_alloc(struct ctlr_info *h)
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
@@ -5823,6 +5839,9 @@ static int hpsa_scsi_add_host(struct ctlr_info *h)
 		dev_err(&h->pdev->dev, "scsi_add_host failed\n");
 		return rv;
 	}
+
+	hpsa_hba_inquiry(h);
+
 	scsi_scan_host(h->scsi_host);
 	return 0;
 }
@@ -7899,22 +7918,6 @@ static int hpsa_pci_init(struct ctlr_info *h)
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
@@ -8810,8 +8813,6 @@ static int hpsa_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 	/* Turn the interrupts on so we can service requests */
 	h->access.set_intr_mask(h, HPSA_INTR_ON);
 
-	hpsa_hba_inquiry(h);
-
 	h->lastlogicals = kzalloc(sizeof(*(h->lastlogicals)), GFP_KERNEL);
 	if (!h->lastlogicals)
 		dev_info(&h->pdev->dev,
-- 
2.17.1

