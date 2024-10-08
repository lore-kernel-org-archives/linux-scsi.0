Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A24D1E519
	for <linux-scsi@vger.kernel.org>; Tue,  8 Oct 2024 02:18:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.188
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728353912; cv=none; b=nl6xAEz7n9gsD0AG1t4a2Kt8Zc3WZIlx8V09wrEF1WGtidfWXtExh9VhjpeM4NIyKPJu2B3j5D3ypTyYmwl+OGRdMuJv6eUQVcdE8C3OEvOCfySrCVRx9QgsH1zhuEoaPpSNhmULOC8BJAAbbhT0Dmq7BCWcch47u08sxBhRCr8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728353912; c=relaxed/simple;
	bh=ues5ROJraO97nl9cHWEQ4BkflE10D+0uKiugBEgLns0=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=uH9TnTmqDhmJYEvw1lT7FvpAYRM0gnY0VHLTXBviMzF5MQf/QNYMLFYffUMfAbTmPHe5S8Q+3UCh3p1lccbRUNH6iKhgIDttjuby60LhF2+ogQwrtbpKiIwaxKXFbn0VhnJKCEiuYD2jodbS2Q99RgAX+Srx+2ltdCzkjsee0Os=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.188
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.163.252])
	by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4XN04q6vZ7zpWcL;
	Tue,  8 Oct 2024 10:16:27 +0800 (CST)
Received: from dggpemf100013.china.huawei.com (unknown [7.185.36.179])
	by mail.maildlp.com (Postfix) with ESMTPS id 0CFF21800CF;
	Tue,  8 Oct 2024 10:18:28 +0800 (CST)
Received: from localhost.huawei.com (10.50.165.33) by
 dggpemf100013.china.huawei.com (7.185.36.179) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Tue, 8 Oct 2024 10:18:27 +0800
From: Yihang Li <liyihang9@huawei.com>
To: <James.Bottomley@HansenPartnership.com>, <martin.petersen@oracle.com>
CC: <linux-scsi@vger.kernel.org>, <linuxarm@huawei.com>,
	<liyihang9@huawei.com>
Subject: [PATCH v2 03/13] scsi: hisi_sas: Add firmware information check
Date: Tue, 8 Oct 2024 10:18:12 +0800
Message-ID: <20241008021822.2617339-4-liyihang9@huawei.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20241008021822.2617339-1-liyihang9@huawei.com>
References: <20241008021822.2617339-1-liyihang9@huawei.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
 dggpemf100013.china.huawei.com (7.185.36.179)

For security purposes, after information is obtained through the FW,
check information to ensure data correctness.

In v1 and v2 hw, the maximum number of PHYs is 9, while in v3 it is 8.
In v2 and v3 hw, the maximum number of hardware queues is 16, while in v1
it is 32.

Also add some debug logs for failure.

Signed-off-by: Yihang Li <liyihang9@huawei.com>
Reviewed-by: Xiang Chen <chenxiang66@hisilicon.com>
---
 drivers/scsi/hisi_sas/hisi_sas.h       |  1 +
 drivers/scsi/hisi_sas/hisi_sas_main.c  |  5 +++++
 drivers/scsi/hisi_sas/hisi_sas_v1_hw.c | 18 ++++++++++++++++++
 drivers/scsi/hisi_sas/hisi_sas_v2_hw.c | 18 ++++++++++++++++++
 drivers/scsi/hisi_sas/hisi_sas_v3_hw.c | 20 ++++++++++++++++++++
 5 files changed, 62 insertions(+)

diff --git a/drivers/scsi/hisi_sas/hisi_sas.h b/drivers/scsi/hisi_sas/hisi_sas.h
index d223f482488f..a44768bceb9a 100644
--- a/drivers/scsi/hisi_sas/hisi_sas.h
+++ b/drivers/scsi/hisi_sas/hisi_sas.h
@@ -307,6 +307,7 @@ enum {
 
 struct hisi_sas_hw {
 	int (*hw_init)(struct hisi_hba *hisi_hba);
+	int (*fw_info_check)(struct hisi_hba *hisi_hba);
 	int (*interrupt_preinit)(struct hisi_hba *hisi_hba);
 	void (*setup_itct)(struct hisi_hba *hisi_hba,
 			   struct hisi_sas_device *device);
diff --git a/drivers/scsi/hisi_sas/hisi_sas_main.c b/drivers/scsi/hisi_sas/hisi_sas_main.c
index d3dcc4918444..275d45a41b0b 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_main.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_main.c
@@ -2450,6 +2450,11 @@ static struct Scsi_Host *hisi_sas_shost_alloc(struct platform_device *pdev,
 	if (hisi_sas_get_fw_info(hisi_hba) < 0)
 		goto err_out;
 
+	if (hisi_hba->hw->fw_info_check) {
+		if (hisi_hba->hw->fw_info_check(hisi_hba))
+			goto err_out;
+	}
+
 	error = dma_set_mask_and_coherent(dev, DMA_BIT_MASK(64));
 	if (error) {
 		dev_err(dev, "No usable DMA addressing method\n");
diff --git a/drivers/scsi/hisi_sas/hisi_sas_v1_hw.c b/drivers/scsi/hisi_sas/hisi_sas_v1_hw.c
index 71b5008c3552..70bba55bc5d0 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_v1_hw.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_v1_hw.c
@@ -1734,6 +1734,23 @@ static struct attribute *host_v1_hw_attrs[] = {
 
 ATTRIBUTE_GROUPS(host_v1_hw);
 
+static int check_fw_info_v1_hw(struct hisi_hba *hisi_hba)
+{
+	struct device *dev = hisi_hba->dev;
+
+	if (hisi_hba->n_phy < 0 || hisi_hba->n_phy > 9) {
+		dev_err(dev, "invalid phy number from FW\n");
+		return -EINVAL;
+	}
+
+	if (hisi_hba->queue_count < 0 || hisi_hba->queue_count > 32) {
+		dev_err(dev, "invalid queue count from FW\n");
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
 static const struct scsi_host_template sht_v1_hw = {
 	LIBSAS_SHT_BASE_NO_SLAVE_INIT
 	.device_configure	= hisi_sas_device_configure,
@@ -1747,6 +1764,7 @@ static const struct scsi_host_template sht_v1_hw = {
 
 static const struct hisi_sas_hw hisi_sas_v1_hw = {
 	.hw_init = hisi_sas_v1_init,
+	.fw_info_check = check_fw_info_v1_hw,
 	.setup_itct = setup_itct_v1_hw,
 	.sl_notify_ssp = sl_notify_ssp_v1_hw,
 	.clear_itct = clear_itct_v1_hw,
diff --git a/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c b/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c
index 342d75f12051..ab6668dc5b77 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c
@@ -3566,6 +3566,23 @@ static void map_queues_v2_hw(struct Scsi_Host *shost)
 	}
 }
 
+static int check_fw_info_v2_hw(struct hisi_hba *hisi_hba)
+{
+	struct device *dev = hisi_hba->dev;
+
+	if (hisi_hba->n_phy < 0 || hisi_hba->n_phy > 9) {
+		dev_err(dev, "invalid phy number from FW\n");
+		return -EINVAL;
+	}
+
+	if (hisi_hba->queue_count < 0 || hisi_hba->queue_count > 16) {
+		dev_err(dev, "invalid queue count from FW\n");
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
 static const struct scsi_host_template sht_v2_hw = {
 	LIBSAS_SHT_BASE_NO_SLAVE_INIT
 	.device_configure	= hisi_sas_device_configure,
@@ -3582,6 +3599,7 @@ static const struct scsi_host_template sht_v2_hw = {
 
 static const struct hisi_sas_hw hisi_sas_v2_hw = {
 	.hw_init = hisi_sas_v2_init,
+	.fw_info_check = check_fw_info_v2_hw,
 	.interrupt_preinit = hisi_sas_v2_interrupt_preinit,
 	.setup_itct = setup_itct_v2_hw,
 	.slot_index_alloc = slot_index_alloc_quirk_v2_hw,
diff --git a/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c b/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
index 980f28d7b87f..d48777fc4bd9 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
@@ -3371,6 +3371,23 @@ static const struct hisi_sas_hw hisi_sas_v3_hw = {
 	.debugfs_snapshot_regs = debugfs_snapshot_regs_v3_hw,
 };
 
+static int check_fw_info_v3_hw(struct hisi_hba *hisi_hba)
+{
+	struct device *dev = hisi_hba->dev;
+
+	if (hisi_hba->n_phy < 0 || hisi_hba->n_phy > 8) {
+		dev_err(dev, "invalid phy number from FW\n");
+		return -EINVAL;
+	}
+
+	if (hisi_hba->queue_count < 0 || hisi_hba->queue_count > 16) {
+		dev_err(dev, "invalid queue count from FW\n");
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
 static struct Scsi_Host *
 hisi_sas_shost_alloc_pci(struct pci_dev *pdev)
 {
@@ -3401,6 +3418,9 @@ hisi_sas_shost_alloc_pci(struct pci_dev *pdev)
 	if (hisi_sas_get_fw_info(hisi_hba) < 0)
 		goto err_out;
 
+	if (check_fw_info_v3_hw(hisi_hba) < 0)
+		goto err_out;
+
 	if (experimental_iopoll_q_cnt < 0 ||
 		experimental_iopoll_q_cnt >= hisi_hba->queue_count)
 		dev_err(dev, "iopoll queue count %d cannot exceed or equal 16, using default 0\n",
-- 
2.33.0

