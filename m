Return-Path: <SRS0=OG9y=YO=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9B9C3CA9EB7
	for <linux-scsi@archiver.kernel.org>; Mon, 21 Oct 2019 16:25:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 711CC2084B
	for <linux-scsi@archiver.kernel.org>; Mon, 21 Oct 2019 16:25:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728897AbfJUQZ2 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 21 Oct 2019 12:25:28 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:33120 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728375AbfJUQZ2 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 21 Oct 2019 12:25:28 -0400
Received: from DGGEMS402-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id E182BFD05BB0DD40C6F4;
        Tue, 22 Oct 2019 00:25:24 +0800 (CST)
Received: from localhost.localdomain (10.69.192.58) by
 DGGEMS402-HUB.china.huawei.com (10.3.19.202) with Microsoft SMTP Server id
 14.3.439.0; Tue, 22 Oct 2019 00:25:17 +0800
From:   John Garry <john.garry@huawei.com>
To:     <jejb@linux.vnet.ibm.com>, <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>, <linuxarm@huawei.com>,
        <linux-kernel@vger.kernel.org>,
        Xiang Chen <chenxiang66@hisilicon.com>,
        "John Garry" <john.garry@huawei.com>
Subject: [PATCH 03/18] scsi: hisi_sas: use wait_for_completion_timeout() when clearing ITCT
Date:   Tue, 22 Oct 2019 00:22:00 +0800
Message-ID: <1571674935-108326-4-git-send-email-john.garry@huawei.com>
X-Mailer: git-send-email 2.8.1
In-Reply-To: <1571674935-108326-1-git-send-email-john.garry@huawei.com>
References: <1571674935-108326-1-git-send-email-john.garry@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.58]
X-CFilter-Loop: Reflected
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Xiang Chen <chenxiang66@hisilicon.com>

When injecting 2bit ecc errors, it will cause confusion inside SAS
controller which needs host reset to recover it. If a device is gone at
the same times inject 2bit ecc errors, we may not receive the ITCT
interrupt so it will wait for completion in clear_itct_v3_hw() all the
time. And host reset will also not occur because it can't require
hisi_hba->sem, so the system will be suspended.

To solve the issue, use wait_for_completion_timeout() instead of
wait_for_completion(), and also don't mark the gone device as
SAS_PHY_UNUSED when device gone.

Signed-off-by: Xiang Chen <chenxiang66@hisilicon.com>
Signed-off-by: John Garry <john.garry@huawei.com>
---
 drivers/scsi/hisi_sas/hisi_sas.h       |  5 +++--
 drivers/scsi/hisi_sas/hisi_sas_main.c  |  8 ++++++--
 drivers/scsi/hisi_sas/hisi_sas_v1_hw.c |  6 ++++--
 drivers/scsi/hisi_sas/hisi_sas_v2_hw.c | 13 ++++++++++---
 drivers/scsi/hisi_sas/hisi_sas_v3_hw.c | 13 ++++++++++---
 5 files changed, 33 insertions(+), 12 deletions(-)

diff --git a/drivers/scsi/hisi_sas/hisi_sas.h b/drivers/scsi/hisi_sas/hisi_sas.h
index 720c4d6be939..83232e8472fb 100644
--- a/drivers/scsi/hisi_sas/hisi_sas.h
+++ b/drivers/scsi/hisi_sas/hisi_sas.h
@@ -84,6 +84,7 @@
 #define HISI_SAS_PROT_MASK (HISI_SAS_DIF_PROT_MASK | HISI_SAS_DIX_PROT_MASK)
 
 #define HISI_SAS_WAIT_PHYUP_TIMEOUT 20
+#define CLEAR_ITCT_TIMEOUT	20
 
 struct hisi_hba;
 
@@ -296,8 +297,8 @@ struct hisi_sas_hw {
 	void (*phy_set_linkrate)(struct hisi_hba *hisi_hba, int phy_no,
 			struct sas_phy_linkrates *linkrates);
 	enum sas_linkrate (*phy_get_max_linkrate)(void);
-	void (*clear_itct)(struct hisi_hba *hisi_hba,
-			    struct hisi_sas_device *dev);
+	int (*clear_itct)(struct hisi_hba *hisi_hba,
+			  struct hisi_sas_device *dev);
 	void (*free_device)(struct hisi_sas_device *sas_dev);
 	int (*get_wideport_bitmap)(struct hisi_hba *hisi_hba, int port_id);
 	void (*dereg_device)(struct hisi_hba *hisi_hba,
diff --git a/drivers/scsi/hisi_sas/hisi_sas_main.c b/drivers/scsi/hisi_sas/hisi_sas_main.c
index ceba1016b77f..621eebbeacd6 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_main.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_main.c
@@ -1045,6 +1045,7 @@ static void hisi_sas_dev_gone(struct domain_device *device)
 	struct hisi_sas_device *sas_dev = device->lldd_dev;
 	struct hisi_hba *hisi_hba = dev_to_hisi_hba(device);
 	struct device *dev = hisi_hba->dev;
+	int ret = 0;
 
 	dev_info(dev, "dev[%d:%x] is gone\n",
 		 sas_dev->device_id, sas_dev->dev_type);
@@ -1056,13 +1057,16 @@ static void hisi_sas_dev_gone(struct domain_device *device)
 
 		hisi_sas_dereg_device(hisi_hba, device);
 
-		hisi_hba->hw->clear_itct(hisi_hba, sas_dev);
+		ret = hisi_hba->hw->clear_itct(hisi_hba, sas_dev);
 		device->lldd_dev = NULL;
 	}
 
 	if (hisi_hba->hw->free_device)
 		hisi_hba->hw->free_device(sas_dev);
-	sas_dev->dev_type = SAS_PHY_UNUSED;
+
+	/* Don't mark it as SAS_PHY_UNUSED if failed to clear ITCT */
+	if (!ret)
+		sas_dev->dev_type = SAS_PHY_UNUSED;
 	sas_dev->sas_device = NULL;
 	up(&hisi_hba->sem);
 }
diff --git a/drivers/scsi/hisi_sas/hisi_sas_v1_hw.c b/drivers/scsi/hisi_sas/hisi_sas_v1_hw.c
index b861a0f14c9d..3af53cc42bd6 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_v1_hw.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_v1_hw.c
@@ -531,8 +531,8 @@ static void setup_itct_v1_hw(struct hisi_hba *hisi_hba,
 				(0xff00ULL << ITCT_HDR_REJ_OPEN_TL_OFF));
 }
 
-static void clear_itct_v1_hw(struct hisi_hba *hisi_hba,
-			      struct hisi_sas_device *sas_dev)
+static int clear_itct_v1_hw(struct hisi_hba *hisi_hba,
+			    struct hisi_sas_device *sas_dev)
 {
 	u64 dev_id = sas_dev->device_id;
 	struct hisi_sas_itct *itct = &hisi_hba->itct[dev_id];
@@ -551,6 +551,8 @@ static void clear_itct_v1_hw(struct hisi_hba *hisi_hba,
 	qw0 = le64_to_cpu(itct->qw0);
 	qw0 &= ~ITCT_HDR_VALID_MSK;
 	itct->qw0 = cpu_to_le64(qw0);
+
+	return 0;
 }
 
 static int reset_hw_v1_hw(struct hisi_hba *hisi_hba)
diff --git a/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c b/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c
index 8e96a257e439..61b1e2693b08 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c
@@ -974,13 +974,14 @@ static void setup_itct_v2_hw(struct hisi_hba *hisi_hba,
 					(0x1ULL << ITCT_HDR_RTOLT_OFF));
 }
 
-static void clear_itct_v2_hw(struct hisi_hba *hisi_hba,
-			      struct hisi_sas_device *sas_dev)
+static int clear_itct_v2_hw(struct hisi_hba *hisi_hba,
+			    struct hisi_sas_device *sas_dev)
 {
 	DECLARE_COMPLETION_ONSTACK(completion);
 	u64 dev_id = sas_dev->device_id;
 	struct hisi_sas_itct *itct = &hisi_hba->itct[dev_id];
 	u32 reg_val = hisi_sas_read32(hisi_hba, ENT_INT_SRC3);
+	struct device *dev = hisi_hba->dev;
 	int i;
 
 	sas_dev->completion = &completion;
@@ -990,13 +991,19 @@ static void clear_itct_v2_hw(struct hisi_hba *hisi_hba,
 		hisi_sas_write32(hisi_hba, ENT_INT_SRC3,
 				 ENT_INT_SRC3_ITC_INT_MSK);
 
+	/* need to set register twice to clear ITCT for v2 hw */
 	for (i = 0; i < 2; i++) {
 		reg_val = ITCT_CLR_EN_MSK | (dev_id & ITCT_DEV_MSK);
 		hisi_sas_write32(hisi_hba, ITCT_CLR, reg_val);
-		wait_for_completion(sas_dev->completion);
+		if (!wait_for_completion_timeout(sas_dev->completion,
+						 CLEAR_ITCT_TIMEOUT * HZ)) {
+			dev_warn(dev, "failed to clear ITCT\n");
+			return -ETIMEDOUT;
+		}
 
 		memset(itct, 0, sizeof(struct hisi_sas_itct));
 	}
+	return 0;
 }
 
 static void free_device_v2_hw(struct hisi_sas_device *sas_dev)
diff --git a/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c b/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
index cc594937fa8d..19a8cfeb8f6e 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
@@ -795,13 +795,14 @@ static void setup_itct_v3_hw(struct hisi_hba *hisi_hba,
 					(0x1ULL << ITCT_HDR_RTOLT_OFF));
 }
 
-static void clear_itct_v3_hw(struct hisi_hba *hisi_hba,
-			      struct hisi_sas_device *sas_dev)
+static int clear_itct_v3_hw(struct hisi_hba *hisi_hba,
+			    struct hisi_sas_device *sas_dev)
 {
 	DECLARE_COMPLETION_ONSTACK(completion);
 	u64 dev_id = sas_dev->device_id;
 	struct hisi_sas_itct *itct = &hisi_hba->itct[dev_id];
 	u32 reg_val = hisi_sas_read32(hisi_hba, ENT_INT_SRC3);
+	struct device *dev = hisi_hba->dev;
 
 	sas_dev->completion = &completion;
 
@@ -814,8 +815,14 @@ static void clear_itct_v3_hw(struct hisi_hba *hisi_hba,
 	reg_val = ITCT_CLR_EN_MSK | (dev_id & ITCT_DEV_MSK);
 	hisi_sas_write32(hisi_hba, ITCT_CLR, reg_val);
 
-	wait_for_completion(sas_dev->completion);
+	if (!wait_for_completion_timeout(sas_dev->completion,
+					 CLEAR_ITCT_TIMEOUT * HZ)) {
+		dev_warn(dev, "failed to clear ITCT\n");
+		return -ETIMEDOUT;
+	}
+
 	memset(itct, 0, sizeof(struct hisi_sas_itct));
+	return 0;
 }
 
 static void dereg_device_v3_hw(struct hisi_hba *hisi_hba,
-- 
2.17.1

