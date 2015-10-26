From: John Garry <john.garry@huawei.com>
Subject: [PATCH v2 28/32] scsi: hisi_sas: add scan finished and start
Date: Mon, 26 Oct 2015 22:14:59 +0800
Message-ID: <1445868903-183817-29-git-send-email-john.garry@huawei.com>
References: <1445868903-183817-1-git-send-email-john.garry@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1445868903-183817-1-git-send-email-john.garry@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
To: JBottomley@odin.com, robh+dt@kernel.org, pawel.moll@arm.com, mark.rutland@arm.com, ijc+devicetree@hellion.org.uk, galak@codeaurora.org, arnd@arndb.de
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, devicetree@vger.kernel.org, linuxarm@huawei.com, john.garry2@mail.dcu.ie, hare@suse.de, xuwei5@hisilicon.com, zhangfei.gao@linaro.org, John Garry <john.garry@huawei.com>
List-Id: linux-scsi@vger.kernel.org

Add functions for scsi host template scan_finished
and scan_start methods

Signed-off-by: John Garry <john.garry@huawei.com>
---
 drivers/scsi/hisi_sas/hisi_sas.h      |  1 +
 drivers/scsi/hisi_sas/hisi_sas_main.c | 25 +++++++++++++++++++++++++
 2 files changed, 26 insertions(+)

diff --git a/drivers/scsi/hisi_sas/hisi_sas.h b/drivers/scsi/hisi_sas/hisi_sas.h
index 1dc71ee..fae73cd 100644
--- a/drivers/scsi/hisi_sas/hisi_sas.h
+++ b/drivers/scsi/hisi_sas/hisi_sas.h
@@ -158,6 +158,7 @@ struct hisi_hba {
 
 
 	int n_phy;
+	int scan_finished;
 	spinlock_t lock;
 
 	struct timer_list timer;
diff --git a/drivers/scsi/hisi_sas/hisi_sas_main.c b/drivers/scsi/hisi_sas/hisi_sas_main.c
index a1bfb47..13e34cb 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_main.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_main.c
@@ -425,6 +425,29 @@ found_out:
 	return res;
 }
 
+static void hisi_sas_scan_start(struct Scsi_Host *shost)
+{
+	struct hisi_hba *hisi_hba = shost_priv(shost);
+	int i;
+
+	for (i = 0; i < hisi_hba->n_phy; ++i)
+		hisi_sas_bytes_dmaed(hisi_hba, i);
+
+	hisi_hba->scan_finished = 1;
+}
+
+static int hisi_sas_scan_finished(struct Scsi_Host *shost, unsigned long time)
+{
+	struct hisi_hba *hisi_hba = shost_priv(shost);
+	struct sas_ha_struct *sha = &hisi_hba->sha;
+
+	if (hisi_hba->scan_finished == 0)
+		return 0;
+
+	sas_drain_work(sha);
+	return 1;
+}
+
 static void hisi_sas_phyup_work(struct work_struct *work)
 {
 	struct hisi_sas_phy *phy =
@@ -638,6 +661,8 @@ static struct scsi_host_template hisi_sas_sht = {
 	.queuecommand		= sas_queuecommand,
 	.target_alloc		= sas_target_alloc,
 	.slave_configure	= sas_slave_configure,
+	.scan_finished		= hisi_sas_scan_finished,
+	.scan_start		= hisi_sas_scan_start,
 	.change_queue_depth	= sas_change_queue_depth,
 	.bios_param		= sas_bios_param,
 	.can_queue		= 1,
-- 
1.9.1
