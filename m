From: John Garry <john.garry@huawei.com>
Subject: [PATCH 07/25] scsi: hisi_sas: add ioremap for device HW
Date: Mon, 12 Oct 2015 23:20:19 +0800
Message-ID: <1444663237-238302-8-git-send-email-john.garry@huawei.com>
References: <1444663237-238302-1-git-send-email-john.garry@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from szxga02-in.huawei.com ([119.145.14.65]:13616 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751073AbbJLPLt (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 12 Oct 2015 11:11:49 -0400
In-Reply-To: <1444663237-238302-1-git-send-email-john.garry@huawei.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: linux-kernel@vger.kernel.com, devicetree@vger.kernel.org, arnd@arndb.de, linuxarm@huawei.com, zhangfei.gao@linaro.org, linux-scsi@vger.kernel.org, xuwei5@hisilicon.com, john.garry2@mail.dcu.ie, hare@suse.de, John Garry <john.garry@huawei.com>

This includes registers for core SAS controllers
and also SAS control registers.

Signed-off-by: John Garry <john.garry@huawei.com>
---
 drivers/scsi/hisi_sas/hisi_sas.h      |  2 ++
 drivers/scsi/hisi_sas/hisi_sas_init.c | 25 +++++++++++++++++++++++++
 2 files changed, 27 insertions(+)

diff --git a/drivers/scsi/hisi_sas/hisi_sas.h b/drivers/scsi/hisi_sas/hisi_sas.h
index 929c513..5f72d98 100644
--- a/drivers/scsi/hisi_sas/hisi_sas.h
+++ b/drivers/scsi/hisi_sas/hisi_sas.h
@@ -69,6 +69,8 @@ struct hisi_hba {
 
 	struct platform_device *pdev;
 
+	void __iomem *regs;
+	void __iomem *ctrl_regs;
 
 	u8 sas_addr[SAS_ADDR_SIZE];
 
diff --git a/drivers/scsi/hisi_sas/hisi_sas_init.c b/drivers/scsi/hisi_sas/hisi_sas_init.c
index 38b9ed2..8f1e856 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_init.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_init.c
@@ -195,6 +195,28 @@ static void hisi_sas_free(struct hisi_hba *hisi_hba)
 				  hisi_hba->sata_breakpoint_dma);
 }
 
+int hisi_sas_ioremap(struct hisi_hba *hisi_hba)
+{
+	struct platform_device *pdev = hisi_hba->pdev;
+	struct device *dev = &pdev->dev;
+	struct resource *res;
+
+	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	hisi_hba->regs = devm_ioremap(dev,
+				      res->start,
+				      resource_size(res));
+	if (!hisi_hba->regs)
+		return -ENOMEM;
+
+	res = platform_get_resource(pdev, IORESOURCE_MEM, 1);
+	hisi_hba->ctrl_regs = devm_ioremap(dev,
+					   res->start,
+					   resource_size(res));
+	if (!hisi_hba->ctrl_regs)
+		return -ENOMEM;
+
+	return 0;
+}
 
 static const struct of_device_id sas_of_match[] = {
 	{ .compatible = "hisilicon,sas-controller-v1",},
@@ -241,6 +263,9 @@ static struct hisi_hba *hisi_sas_hba_alloc(
 
 	hisi_hba->shost = shost;
 
+	if (hisi_sas_ioremap(hisi_hba))
+		goto err_out;
+
 	if (hisi_sas_alloc(hisi_hba, shost)) {
 		hisi_sas_free(hisi_hba);
 		goto err_out;
-- 
1.9.1

