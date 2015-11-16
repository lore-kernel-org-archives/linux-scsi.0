From: John Garry <john.garry@huawei.com>
Subject: [PATCH v4 11/32] scsi: hisi_sas: add phy SAS ADDR initialization
Date: Mon, 16 Nov 2015 21:05:57 +0800
Message-ID: <1447679178-220222-12-git-send-email-john.garry@huawei.com>
References: <1447679178-220222-1-git-send-email-john.garry@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1447679178-220222-1-git-send-email-john.garry@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
To: JBottomley@odin.com, robh+dt@kernel.org, pawel.moll@arm.com, mark.rutland@arm.com, ijc+devicetree@hellion.org.uk, galak@codeaurora.org, arnd@arndb.de
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, devicetree@vger.kernel.org, linuxarm@huawei.com, john.garry2@mail.dcu.ie, hare@suse.de, xuwei5@hisilicon.com, zhangfei.gao@linaro.org, john.garry@huawei.com
List-Id: linux-scsi@vger.kernel.org

The SAS address for the HBA comes from the device tree.

Signed-off-by: John Garry <john.garry@huawei.com>
---
 drivers/scsi/hisi_sas/hisi_sas.h      |  1 +
 drivers/scsi/hisi_sas/hisi_sas_main.c | 12 ++++++++++++
 2 files changed, 13 insertions(+)

diff --git a/drivers/scsi/hisi_sas/hisi_sas.h b/drivers/scsi/hisi_sas/hisi_sas.h
index 315fe46..c50384f 100644
--- a/drivers/scsi/hisi_sas/hisi_sas.h
+++ b/drivers/scsi/hisi_sas/hisi_sas.h
@@ -39,6 +39,7 @@
 
 struct hisi_sas_phy {
 	struct asd_sas_phy	sas_phy;
+	u64		dev_sas_addr;
 };
 
 struct hisi_sas_port {
diff --git a/drivers/scsi/hisi_sas/hisi_sas_main.c b/drivers/scsi/hisi_sas/hisi_sas_main.c
index d10bf24..8cd1b55 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_main.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_main.c
@@ -281,6 +281,16 @@ err_out:
 	return NULL;
 }
 
+static void hisi_sas_init_add(struct hisi_hba *hisi_hba)
+{
+	int i;
+
+	for (i = 0; i < hisi_hba->n_phy; i++)
+		memcpy(&hisi_hba->phy[i].dev_sas_addr,
+		       hisi_hba->sas_addr,
+		       SAS_ADDR_SIZE);
+}
+
 int hisi_sas_probe(struct platform_device *pdev,
 			 const struct hisi_sas_hw *hw)
 {
@@ -334,6 +344,8 @@ int hisi_sas_probe(struct platform_device *pdev,
 		sha->sas_port[i] = &hisi_hba->port[i].sas_port;
 	}
 
+	hisi_sas_init_add(hisi_hba);
+
 	rc = scsi_add_host(shost, &pdev->dev);
 	if (rc)
 		goto err_out_ha;
-- 
1.9.1
