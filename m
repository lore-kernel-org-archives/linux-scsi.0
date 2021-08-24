Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2EF9AC4320A
	for <linux-scsi@archiver.kernel.org>; Tue, 24 Aug 2021 10:06:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 14A1360FE8
	for <linux-scsi@archiver.kernel.org>; Tue, 24 Aug 2021 10:06:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236041AbhHXKGv (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 24 Aug 2021 06:06:51 -0400
Received: from frasgout.his.huawei.com ([185.176.79.56]:3684 "EHLO
        frasgout.his.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236033AbhHXKGj (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 24 Aug 2021 06:06:39 -0400
Received: from fraeml745-chm.china.huawei.com (unknown [172.18.147.201])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4Gv4Tf2NmMz67byN;
        Tue, 24 Aug 2021 18:04:38 +0800 (CST)
Received: from lhreml724-chm.china.huawei.com (10.201.108.75) by
 fraeml745-chm.china.huawei.com (10.206.15.226) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.8; Tue, 24 Aug 2021 12:05:53 +0200
Received: from localhost.localdomain (10.69.192.58) by
 lhreml724-chm.china.huawei.com (10.201.108.75) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.8; Tue, 24 Aug 2021 11:05:51 +0100
From:   John Garry <john.garry@huawei.com>
To:     <jejb@linux.ibm.com>, <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linuxarm@huawei.com>, Luo Jiaxing <luojiaxing@huawei.com>,
        John Garry <john.garry@huawei.com>
Subject: [PATCH 3/5] scsi: hisi_sas: Rename HISI_SAS_{RESET -> RESETTING}_BIT
Date:   Tue, 24 Aug 2021 18:00:58 +0800
Message-ID: <1629799260-120116-4-git-send-email-john.garry@huawei.com>
X-Mailer: git-send-email 2.8.1
In-Reply-To: <1629799260-120116-1-git-send-email-john.garry@huawei.com>
References: <1629799260-120116-1-git-send-email-john.garry@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.58]
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
 lhreml724-chm.china.huawei.com (10.201.108.75)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Luo Jiaxing <luojiaxing@huawei.com>

HISI_SAS_RESET_BIT means that the controller is being reset, and so the
name is a bit vague.

Rename it to HISI_SAS_RESETTING_BIT.

Signed-off-by: Luo Jiaxing <luojiaxing@huawei.com>
Signed-off-by: John Garry <john.garry@huawei.com>
---
 drivers/scsi/hisi_sas/hisi_sas.h       |  2 +-
 drivers/scsi/hisi_sas/hisi_sas_main.c  | 12 ++++++------
 drivers/scsi/hisi_sas/hisi_sas_v1_hw.c |  2 +-
 drivers/scsi/hisi_sas/hisi_sas_v2_hw.c |  2 +-
 drivers/scsi/hisi_sas/hisi_sas_v3_hw.c | 10 +++++-----
 5 files changed, 14 insertions(+), 14 deletions(-)

diff --git a/drivers/scsi/hisi_sas/hisi_sas.h b/drivers/scsi/hisi_sas/hisi_sas.h
index 436d174f2194..57be32ba0109 100644
--- a/drivers/scsi/hisi_sas/hisi_sas.h
+++ b/drivers/scsi/hisi_sas/hisi_sas.h
@@ -35,7 +35,7 @@
 #define HISI_SAS_QUEUE_SLOTS	4096
 #define HISI_SAS_MAX_ITCT_ENTRIES 1024
 #define HISI_SAS_MAX_DEVICES HISI_SAS_MAX_ITCT_ENTRIES
-#define HISI_SAS_RESET_BIT	0
+#define HISI_SAS_RESETTING_BIT	0
 #define HISI_SAS_REJECT_CMD_BIT	1
 #define HISI_SAS_PM_BIT		2
 #define HISI_SAS_HW_FAULT_BIT	3
diff --git a/drivers/scsi/hisi_sas/hisi_sas_main.c b/drivers/scsi/hisi_sas/hisi_sas_main.c
index 9515c45affa5..fec4db46c76c 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_main.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_main.c
@@ -724,7 +724,7 @@ static int hisi_sas_init_device(struct domain_device *device)
 		 */
 		local_phy = sas_get_local_phy(device);
 		if (!scsi_is_sas_phy_local(local_phy) &&
-		    !test_bit(HISI_SAS_RESET_BIT, &hisi_hba->flags)) {
+		    !test_bit(HISI_SAS_RESETTING_BIT, &hisi_hba->flags)) {
 			unsigned long deadline = ata_deadline(jiffies, 20000);
 			struct sata_device *sata_dev = &device->sata_dev;
 			struct ata_host *ata_host = sata_dev->ata_host;
@@ -1072,7 +1072,7 @@ static void hisi_sas_dev_gone(struct domain_device *device)
 		 sas_dev->device_id, sas_dev->dev_type);
 
 	down(&hisi_hba->sem);
-	if (!test_bit(HISI_SAS_RESET_BIT, &hisi_hba->flags)) {
+	if (!test_bit(HISI_SAS_RESETTING_BIT, &hisi_hba->flags)) {
 		hisi_sas_internal_task_abort(hisi_hba, device,
 					     HISI_SAS_INT_ABT_DEV, 0, true);
 
@@ -1576,7 +1576,7 @@ void hisi_sas_controller_reset_done(struct hisi_hba *hisi_hba)
 	hisi_sas_reset_init_all_devices(hisi_hba);
 	up(&hisi_hba->sem);
 	scsi_unblock_requests(shost);
-	clear_bit(HISI_SAS_RESET_BIT, &hisi_hba->flags);
+	clear_bit(HISI_SAS_RESETTING_BIT, &hisi_hba->flags);
 
 	hisi_sas_rescan_topology(hisi_hba, hisi_hba->phy_state);
 }
@@ -1587,7 +1587,7 @@ static int hisi_sas_controller_prereset(struct hisi_hba *hisi_hba)
 	if (!hisi_hba->hw->soft_reset)
 		return -1;
 
-	if (test_and_set_bit(HISI_SAS_RESET_BIT, &hisi_hba->flags))
+	if (test_and_set_bit(HISI_SAS_RESETTING_BIT, &hisi_hba->flags))
 		return -1;
 
 	if (hisi_sas_debugfs_enable && hisi_hba->debugfs_itct[0].itct)
@@ -1611,7 +1611,7 @@ static int hisi_sas_controller_reset(struct hisi_hba *hisi_hba)
 		clear_bit(HISI_SAS_REJECT_CMD_BIT, &hisi_hba->flags);
 		up(&hisi_hba->sem);
 		scsi_unblock_requests(shost);
-		clear_bit(HISI_SAS_RESET_BIT, &hisi_hba->flags);
+		clear_bit(HISI_SAS_RESETTING_BIT, &hisi_hba->flags);
 		return rc;
 	}
 
@@ -2251,7 +2251,7 @@ void hisi_sas_phy_down(struct hisi_hba *hisi_hba, int phy_no, int rdy,
 	} else {
 		struct hisi_sas_port *port  = phy->port;
 
-		if (test_bit(HISI_SAS_RESET_BIT, &hisi_hba->flags) ||
+		if (test_bit(HISI_SAS_RESETTING_BIT, &hisi_hba->flags) ||
 		    phy->in_reset) {
 			dev_info(dev, "ignore flutter phy%d down\n", phy_no);
 			return;
diff --git a/drivers/scsi/hisi_sas/hisi_sas_v1_hw.c b/drivers/scsi/hisi_sas/hisi_sas_v1_hw.c
index afe639994f3d..862f4e8b7eb5 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_v1_hw.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_v1_hw.c
@@ -1422,7 +1422,7 @@ static irqreturn_t int_bcast_v1_hw(int irq, void *p)
 		goto end;
 	}
 
-	if (!test_bit(HISI_SAS_RESET_BIT, &hisi_hba->flags))
+	if (!test_bit(HISI_SAS_RESETTING_BIT, &hisi_hba->flags))
 		sas_notify_port_event(sas_phy, PORTE_BROADCAST_RCVD,
 				      GFP_ATOMIC);
 
diff --git a/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c b/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c
index b0b2361e63fe..a5fc79b3f732 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c
@@ -2824,7 +2824,7 @@ static void phy_bcast_v2_hw(int phy_no, struct hisi_hba *hisi_hba)
 	hisi_sas_phy_write32(hisi_hba, phy_no, SL_RX_BCAST_CHK_MSK, 1);
 	bcast_status = hisi_sas_phy_read32(hisi_hba, phy_no, RX_PRIMS_STATUS);
 	if ((bcast_status & RX_BCAST_CHG_MSK) &&
-	    !test_bit(HISI_SAS_RESET_BIT, &hisi_hba->flags))
+	    !test_bit(HISI_SAS_RESETTING_BIT, &hisi_hba->flags))
 		sas_notify_port_event(sas_phy, PORTE_BROADCAST_RCVD,
 				      GFP_ATOMIC);
 	hisi_sas_phy_write32(hisi_hba, phy_no, CHL_INT0,
diff --git a/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c b/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
index f57d9f488a42..b137e5619da1 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
@@ -1617,7 +1617,7 @@ static irqreturn_t phy_bcast_v3_hw(int phy_no, struct hisi_hba *hisi_hba)
 	hisi_sas_phy_write32(hisi_hba, phy_no, SL_RX_BCAST_CHK_MSK, 1);
 	bcast_status = hisi_sas_phy_read32(hisi_hba, phy_no, RX_PRIMS_STATUS);
 	if ((bcast_status & RX_BCAST_CHG_MSK) &&
-	    !test_bit(HISI_SAS_RESET_BIT, &hisi_hba->flags))
+	    !test_bit(HISI_SAS_RESETTING_BIT, &hisi_hba->flags))
 		sas_notify_port_event(sas_phy, PORTE_BROADCAST_RCVD,
 				      GFP_ATOMIC);
 	hisi_sas_phy_write32(hisi_hba, phy_no, CHL_INT0,
@@ -4851,7 +4851,7 @@ static void hisi_sas_reset_prepare_v3_hw(struct pci_dev *pdev)
 	int rc;
 
 	dev_info(dev, "FLR prepare\n");
-	set_bit(HISI_SAS_RESET_BIT, &hisi_hba->flags);
+	set_bit(HISI_SAS_RESETTING_BIT, &hisi_hba->flags);
 	hisi_sas_controller_reset_prepare(hisi_hba);
 
 	rc = disable_host_v3_hw(hisi_hba);
@@ -4897,7 +4897,7 @@ static int _suspend_v3_hw(struct device *device)
 		return -ENODEV;
 	}
 
-	if (test_and_set_bit(HISI_SAS_RESET_BIT, &hisi_hba->flags))
+	if (test_and_set_bit(HISI_SAS_RESETTING_BIT, &hisi_hba->flags))
 		return -1;
 
 	scsi_block_requests(shost);
@@ -4908,7 +4908,7 @@ static int _suspend_v3_hw(struct device *device)
 	if (rc) {
 		dev_err(dev, "PM suspend: disable host failed rc=%d\n", rc);
 		clear_bit(HISI_SAS_REJECT_CMD_BIT, &hisi_hba->flags);
-		clear_bit(HISI_SAS_RESET_BIT, &hisi_hba->flags);
+		clear_bit(HISI_SAS_RESETTING_BIT, &hisi_hba->flags);
 		scsi_unblock_requests(shost);
 		return rc;
 	}
@@ -4947,7 +4947,7 @@ static int _resume_v3_hw(struct device *device)
 	}
 	phys_init_v3_hw(hisi_hba);
 	sas_resume_ha(sha);
-	clear_bit(HISI_SAS_RESET_BIT, &hisi_hba->flags);
+	clear_bit(HISI_SAS_RESETTING_BIT, &hisi_hba->flags);
 
 	return 0;
 }
-- 
2.26.2

