Return-Path: <SRS0=uVXb=YR=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3BCE8CA9EAF
	for <linux-scsi@archiver.kernel.org>; Thu, 24 Oct 2019 14:25:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 11A5121A4A
	for <linux-scsi@archiver.kernel.org>; Thu, 24 Oct 2019 14:25:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2409407AbfJXOYx (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 24 Oct 2019 10:24:53 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:52470 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2409387AbfJXOYx (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 24 Oct 2019 10:24:53 -0400
Received: from DGGEMS414-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id 6567F4D347CCF59F7DB4;
        Thu, 24 Oct 2019 22:24:50 +0800 (CST)
Received: from localhost.localdomain (10.69.192.58) by
 DGGEMS414-HUB.china.huawei.com (10.3.19.214) with Microsoft SMTP Server id
 14.3.439.0; Thu, 24 Oct 2019 22:24:41 +0800
From:   John Garry <john.garry@huawei.com>
To:     <jejb@linux.vnet.ibm.com>, <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>, <linuxarm@huawei.com>,
        <linux-kernel@vger.kernel.org>, <hare@suse.com>,
        <ming.lei@redhat.com>, "John Garry" <john.garry@huawei.com>
Subject: [PATCH 5/6] scsi: hisi_sas: Split interrupt_init_v3_hw()
Date:   Thu, 24 Oct 2019 22:21:20 +0800
Message-ID: <1571926881-75524-6-git-send-email-john.garry@huawei.com>
X-Mailer: git-send-email 2.8.1
In-Reply-To: <1571926881-75524-1-git-send-email-john.garry@huawei.com>
References: <1571926881-75524-1-git-send-email-john.garry@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.58]
X-CFilter-Loop: Reflected
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

To expose multiple queues to the upper layer we will need to do some
interrupt initialisation earlier - that being to calculate the vectors -
so split interrupt_init_v3_hw().

Signed-off-by: John Garry <john.garry@huawei.com>
---
 drivers/scsi/hisi_sas/hisi_sas_v3_hw.c | 16 +++++++++++++---
 1 file changed, 13 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c b/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
index 497bbf6964f6..29119d0b27a7 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
@@ -2409,11 +2409,10 @@ static void setup_reply_map_v3_hw(struct hisi_hba *hisi_hba, int nvecs)
 	/* Don't clean all CQ masks */
 }
 
-static int interrupt_init_v3_hw(struct hisi_hba *hisi_hba)
+static int interrupt_preinit_v3_hw(struct hisi_hba *hisi_hba)
 {
 	struct device *dev = hisi_hba->dev;
-	struct pci_dev *pdev = hisi_hba->pci_dev;
-	int vectors, rc, i;
+	int vectors;
 	int max_msi = HISI_SAS_MSI_COUNT_V3_HW, min_msi;
 
 	if (auto_affine_msi_experimental) {
@@ -2445,6 +2444,14 @@ static int interrupt_init_v3_hw(struct hisi_hba *hisi_hba)
 	}
 
 	hisi_hba->cq_nvecs = vectors - BASE_VECTORS_V3_HW;
+	return 0;
+}
+
+static int interrupt_init_v3_hw(struct hisi_hba *hisi_hba)
+{
+	struct device *dev = hisi_hba->dev;
+	struct pci_dev *pdev = hisi_hba->pci_dev;
+	int rc, i;
 
 	rc = devm_request_irq(dev, pci_irq_vector(pdev, 1),
 			      int_phy_up_down_bcast_v3_hw, 0,
@@ -3284,6 +3291,9 @@ hisi_sas_v3_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	if (hisi_sas_debugfs_enable)
 		hisi_sas_debugfs_init(hisi_hba);
 
+	rc = interrupt_preinit_v3_hw(hisi_hba);
+	if (rc)
+		goto err_out_ha;
 	rc = scsi_add_host(shost, dev);
 	if (rc)
 		goto err_out_ha;
-- 
2.17.1

