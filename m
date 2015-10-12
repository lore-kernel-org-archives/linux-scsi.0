From: John Garry <john.garry@huawei.com>
Subject: [PATCH 21/25] scsi: hisi_sas: add scan finished and start
Date: Mon, 12 Oct 2015 23:20:33 +0800
Message-ID: <1444663237-238302-22-git-send-email-john.garry@huawei.com>
References: <1444663237-238302-1-git-send-email-john.garry@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from szxga02-in.huawei.com ([119.145.14.65]:12575 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751986AbbJLPIb (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 12 Oct 2015 11:08:31 -0400
In-Reply-To: <1444663237-238302-1-git-send-email-john.garry@huawei.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: linux-kernel@vger.kernel.com, devicetree@vger.kernel.org, arnd@arndb.de, linuxarm@huawei.com, zhangfei.gao@linaro.org, linux-scsi@vger.kernel.org, xuwei5@hisilicon.com, john.garry2@mail.dcu.ie, hare@suse.de, John Garry <john.garry@huawei.com>

Add functions for scsi host template scan_finished
and scan_start methods.

Signed-off-by: John Garry <john.garry@huawei.com>
---
 drivers/scsi/hisi_sas/hisi_sas.h      |  4 ++++
 drivers/scsi/hisi_sas/hisi_sas_init.c |  2 ++
 drivers/scsi/hisi_sas/hisi_sas_main.c | 24 ++++++++++++++++++++++++
 3 files changed, 30 insertions(+)

diff --git a/drivers/scsi/hisi_sas/hisi_sas.h b/drivers/scsi/hisi_sas/hisi_sas.h
index be2cdf5..9565a2a 100644
--- a/drivers/scsi/hisi_sas/hisi_sas.h
+++ b/drivers/scsi/hisi_sas/hisi_sas.h
@@ -165,6 +165,7 @@ struct hisi_hba {
 
 	int	n_phy;
 
+	int scan_finished;
 
 	struct timer_list timer;
 	struct workqueue_struct *wq;
@@ -351,6 +352,9 @@ union hisi_sas_command_table {
 	struct hisi_sas_command_table_stp stp;
 };
 
+int hisi_sas_scan_finished(struct Scsi_Host *shost, unsigned long time);
+void hisi_sas_scan_start(struct Scsi_Host *shost);
+
 void hisi_sas_slot_index_init(struct hisi_hba *hisi_hba);
 void hisi_sas_phy_init(struct hisi_hba *hisi_hba, int i);
 int hisi_sas_dev_found(struct domain_device *dev);
diff --git a/drivers/scsi/hisi_sas/hisi_sas_init.c b/drivers/scsi/hisi_sas/hisi_sas_init.c
index ba64562..caab645 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_init.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_init.c
@@ -18,6 +18,8 @@ static struct scsi_host_template hisi_sas_sht = {
 	.queuecommand		= sas_queuecommand,
 	.target_alloc		= sas_target_alloc,
 	.slave_configure	= sas_slave_configure,
+	.scan_finished		= hisi_sas_scan_finished,
+	.scan_start		= hisi_sas_scan_start,
 	.change_queue_depth	= sas_change_queue_depth,
 	.bios_param		= sas_bios_param,
 	.can_queue		= 1,
diff --git a/drivers/scsi/hisi_sas/hisi_sas_main.c b/drivers/scsi/hisi_sas/hisi_sas_main.c
index 91620b0..393d22a 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_main.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_main.c
@@ -435,6 +435,30 @@ found_out:
 	return res;
 }
 
+void hisi_sas_scan_start(struct Scsi_Host *shost)
+{
+	struct sas_ha_struct *sha = SHOST_TO_SAS_HA(shost);
+	struct hisi_hba *hisi_hba = sha->lldd_ha;
+	int i;
+
+	for (i = 0; i < hisi_hba->n_phy; ++i)
+		hisi_sas_bytes_dmaed(hisi_hba, i);
+
+	hisi_hba->scan_finished = 1;
+}
+
+int hisi_sas_scan_finished(struct Scsi_Host *shost, unsigned long time)
+{
+	struct sas_ha_struct *sha = SHOST_TO_SAS_HA(shost);
+	struct hisi_hba *hisi_hba = sha->lldd_ha;
+
+	if (hisi_hba->scan_finished == 0)
+		return 0;
+
+	sas_drain_work(sha);
+	return 1;
+}
+
 
 static void hisi_sas_phyup_work(struct hisi_hba *hisi_hba,
 				      int phy_no)
-- 
1.9.1

