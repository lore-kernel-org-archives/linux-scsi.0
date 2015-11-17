From: John Garry <john.garry@huawei.com>
Subject: [PATCH v5 16/32] scsi: hisi_sas: add timer and spinlock init
Date: Wed, 18 Nov 2015 00:50:43 +0800
Message-ID: <1447779059-136143-17-git-send-email-john.garry@huawei.com>
References: <1447779059-136143-1-git-send-email-john.garry@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1447779059-136143-1-git-send-email-john.garry@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
To: JBottomley@odin.com, robh+dt@kernel.org, pawel.moll@arm.com, mark.rutland@arm.com, ijc+devicetree@hellion.org.uk, galak@codeaurora.org, arnd@arndb.de
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, devicetree@vger.kernel.org, linuxarm@huawei.com, john.garry2@mail.dcu.ie, hare@suse.de, xuwei5@hisilicon.com, zhangfei.gao@linaro.org, john.garry@huawei.com
List-Id: linux-scsi@vger.kernel.org

Signed-off-by: John Garry <john.garry@huawei.com>
---
 drivers/scsi/hisi_sas/hisi_sas.h      | 2 ++
 drivers/scsi/hisi_sas/hisi_sas_main.c | 3 +++
 2 files changed, 5 insertions(+)

diff --git a/drivers/scsi/hisi_sas/hisi_sas.h b/drivers/scsi/hisi_sas/hisi_sas.h
index 3a2400e..3749c46 100644
--- a/drivers/scsi/hisi_sas/hisi_sas.h
+++ b/drivers/scsi/hisi_sas/hisi_sas.h
@@ -97,7 +97,9 @@ struct hisi_hba {
 	u8 sas_addr[SAS_ADDR_SIZE];
 
 	int n_phy;
+	spinlock_t lock;
 
+	struct timer_list timer;
 	struct workqueue_struct *wq;
 
 	int slot_index_count;
diff --git a/drivers/scsi/hisi_sas/hisi_sas_main.c b/drivers/scsi/hisi_sas/hisi_sas_main.c
index bc41ce4..06b863c 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_main.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_main.c
@@ -81,6 +81,7 @@ static int hisi_sas_alloc(struct hisi_hba *hisi_hba, struct Scsi_Host *shost)
 	struct platform_device *pdev = hisi_hba->pdev;
 	struct device *dev = &pdev->dev;
 
+	spin_lock_init(&hisi_hba->lock);
 	for (i = 0; i < hisi_hba->n_phy; i++) {
 		hisi_sas_phy_init(hisi_hba, i);
 		hisi_hba->port[i].port_attached = 0;
@@ -275,6 +276,8 @@ static struct Scsi_Host *hisi_sas_shost_alloc(struct platform_device *pdev,
 	hisi_hba->shost = shost;
 	SHOST_TO_SAS_HA(shost) = &hisi_hba->sha;
 
+	init_timer(&hisi_hba->timer);
+
 	sas_addr_prop = of_find_property(np, "sas-addr", NULL);
 	if (!sas_addr_prop || (sas_addr_prop->length != SAS_ADDR_SIZE))
 		goto err_out;
-- 
1.9.1
