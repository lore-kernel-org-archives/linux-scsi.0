Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B16B11AF0D7
	for <linux-scsi@vger.kernel.org>; Thu, 20 Feb 2025 09:00:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.187
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740042017; cv=none; b=oplVx28ZOSDF6mdfbYCRa0aCFcoJS5T/Ra6LK+kJ502Iz94xZdXHuR21Xgyy0zKZar4A3GK9FIAu3ggZDqeefylnkaVM9n6UiZ7hHsGerX9QgasL0g9QM6NBqQWBlAgqEMYGaVnf/FQLr+C6Bzkm2txA4fEnVtrZw75ULKJ4wOU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740042017; c=relaxed/simple;
	bh=MNUAL1LnAOiaxcET0LM09qMU/KkYme39h0CeoPTay4s=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=WTBIbCvTcz5IEjb3EMnwoaBd/gguan71/4DtJm41R5Ucxzz9CF1khgRJYI6FnMfOb4hHuc+lxD29yapwVu1QMFicuVsjnA4QRQi83jXoXs2ttwAttDqrQhNPHr7A1psF0xeUXlseogZCzCwg/pA2wYlJzdOMQ564LVkXrn7V+bI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.187
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.163.48])
	by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4Yz6Z65SF5zkXTQ;
	Thu, 20 Feb 2025 16:56:30 +0800 (CST)
Received: from dggpemf100013.china.huawei.com (unknown [7.185.36.179])
	by mail.maildlp.com (Postfix) with ESMTPS id E44F518009E;
	Thu, 20 Feb 2025 17:00:11 +0800 (CST)
Received: from localhost.huawei.com (10.50.165.33) by
 dggpemf100013.china.huawei.com (7.185.36.179) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Thu, 20 Feb 2025 17:00:11 +0800
From: Yihang Li <liyihang9@huawei.com>
To: <James.Bottomley@HansenPartnership.com>, <martin.petersen@oracle.com>
CC: <linux-scsi@vger.kernel.org>, <linuxarm@huawei.com>,
	<liyihang9@huawei.com>, <liuyonglong@huawei.com>, <prime.zeng@hisilicon.com>
Subject: [PATCH] scsi: hisi_sas: Fixed failure to issue vendor specific commands
Date: Thu, 20 Feb 2025 17:00:11 +0800
Message-ID: <20250220090011.313848-1-liyihang9@huawei.com>
X-Mailer: git-send-email 2.33.0
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
 dggpemf100013.china.huawei.com (7.185.36.179)

From: Xingui Yang <yangxingui@huawei.com>

At present, we determine the protocol through the cmd type, but other
cmd types, such as vendor-specific commands, default to the pio protocol.
This strategy often causes the execution of different vendor-specific
commands to fail. In fact, for these commands, a better way is to use the
protocol configured by the command's tf to determine its protocol.

Fixes: 6f2ff1a1311e ("hisi_sas: add v2 path to send ATA command")
Signed-off-by: Xingui Yang <yangxingui@huawei.com>
Reviewed-by: Yihang Li <liyihang9@huawei.com>
---
 drivers/scsi/hisi_sas/hisi_sas.h       |  3 +--
 drivers/scsi/hisi_sas/hisi_sas_main.c  | 28 ++++++++++++++++++++++++--
 drivers/scsi/hisi_sas/hisi_sas_v2_hw.c |  4 +---
 drivers/scsi/hisi_sas/hisi_sas_v3_hw.c |  4 +---
 4 files changed, 29 insertions(+), 10 deletions(-)

diff --git a/drivers/scsi/hisi_sas/hisi_sas.h b/drivers/scsi/hisi_sas/hisi_sas.h
index 2d438d722d0b..e17f5d8226bf 100644
--- a/drivers/scsi/hisi_sas/hisi_sas.h
+++ b/drivers/scsi/hisi_sas/hisi_sas.h
@@ -633,8 +633,7 @@ extern struct dentry *hisi_sas_debugfs_dir;
 extern void hisi_sas_stop_phys(struct hisi_hba *hisi_hba);
 extern int hisi_sas_alloc(struct hisi_hba *hisi_hba);
 extern void hisi_sas_free(struct hisi_hba *hisi_hba);
-extern u8 hisi_sas_get_ata_protocol(struct host_to_dev_fis *fis,
-				int direction);
+extern u8 hisi_sas_get_ata_protocol(struct sas_task *task);
 extern struct hisi_sas_port *to_hisi_sas_port(struct asd_sas_port *sas_port);
 extern void hisi_sas_sata_done(struct sas_task *task,
 			    struct hisi_sas_slot *slot);
diff --git a/drivers/scsi/hisi_sas/hisi_sas_main.c b/drivers/scsi/hisi_sas/hisi_sas_main.c
index da4a2ed8ee86..3596414d970b 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_main.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_main.c
@@ -21,8 +21,32 @@ struct hisi_sas_internal_abort_data {
 	bool rst_ha_timeout; /* reset the HA for timeout */
 };
 
-u8 hisi_sas_get_ata_protocol(struct host_to_dev_fis *fis, int direction)
+static u8 hisi_sas_get_ata_protocol_from_tf(struct ata_queued_cmd *qc)
 {
+	if (!qc)
+		return HISI_SAS_SATA_PROTOCOL_PIO;
+
+	switch (qc->tf.protocol) {
+	case ATA_PROT_NODATA:
+		return HISI_SAS_SATA_PROTOCOL_NONDATA;
+	case ATA_PROT_PIO:
+		return HISI_SAS_SATA_PROTOCOL_PIO;
+	case ATA_PROT_DMA:
+		return HISI_SAS_SATA_PROTOCOL_DMA;
+	case ATA_PROT_NCQ_NODATA:
+	case ATA_PROT_NCQ:
+		return HISI_SAS_SATA_PROTOCOL_FPDMA;
+	default:
+		return HISI_SAS_SATA_PROTOCOL_PIO;
+	}
+}
+
+u8 hisi_sas_get_ata_protocol(struct sas_task *task)
+{
+	struct host_to_dev_fis *fis = &task->ata_task.fis;
+	struct ata_queued_cmd *qc = task->uldd_task;
+	int direction = task->data_dir;
+
 	switch (fis->command) {
 	case ATA_CMD_FPDMA_WRITE:
 	case ATA_CMD_FPDMA_READ:
@@ -93,7 +117,7 @@ u8 hisi_sas_get_ata_protocol(struct host_to_dev_fis *fis, int direction)
 	{
 		if (direction == DMA_NONE)
 			return HISI_SAS_SATA_PROTOCOL_NONDATA;
-		return HISI_SAS_SATA_PROTOCOL_PIO;
+		return hisi_sas_get_ata_protocol_from_tf(qc);
 	}
 	}
 }
diff --git a/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c b/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c
index 71cd5b4450c2..6e7f99fcc824 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c
@@ -2538,9 +2538,7 @@ static void prep_ata_v2_hw(struct hisi_hba *hisi_hba,
 			(task->ata_task.fis.control & ATA_SRST))
 		dw1 |= 1 << CMD_HDR_RESET_OFF;
 
-	dw1 |= (hisi_sas_get_ata_protocol(
-		&task->ata_task.fis, task->data_dir))
-		<< CMD_HDR_FRAME_TYPE_OFF;
+	dw1 |= (hisi_sas_get_ata_protocol(task)) << CMD_HDR_FRAME_TYPE_OFF;
 	dw1 |= sas_dev->device_id << CMD_HDR_DEV_ID_OFF;
 	hdr->dw1 = cpu_to_le32(dw1);
 
diff --git a/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c b/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
index 48b95d9a7927..095bbf80c34e 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
@@ -1456,9 +1456,7 @@ static void prep_ata_v3_hw(struct hisi_hba *hisi_hba,
 			(task->ata_task.fis.control & ATA_SRST))
 		dw1 |= 1 << CMD_HDR_RESET_OFF;
 
-	dw1 |= (hisi_sas_get_ata_protocol(
-		&task->ata_task.fis, task->data_dir))
-		<< CMD_HDR_FRAME_TYPE_OFF;
+	dw1 |= (hisi_sas_get_ata_protocol(task)) << CMD_HDR_FRAME_TYPE_OFF;
 	dw1 |= sas_dev->device_id << CMD_HDR_DEV_ID_OFF;
 
 	if (FIS_CMD_IS_UNCONSTRAINED(task->ata_task.fis))
-- 
2.33.0

