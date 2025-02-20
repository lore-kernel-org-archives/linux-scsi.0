Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75AD31F7076;
	Thu, 20 Feb 2025 13:06:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.188
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740056781; cv=none; b=lCKb14zhbbYjIHGPmrqj8T7SawBy4327O/bgS/RhC5nZB0UOxGuMT2nSwwoLWp4362Tu1sHjFHxhpHn5WU2AnPN2Fwk5KEqmJRcGkSyswyQza02vAvqsrC2P8Gos3I7s4HgA22UOjr7IBsuSQg0bAKHXj2b2r16JYdyHFLxxn44=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740056781; c=relaxed/simple;
	bh=YlKsGiWBMwmia8TAqqEUMOD7B8myAjpdvDWgClaHJZc=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Vw9XzM2xOYrDh0Ei9tE2iXwFuCdS7TYXhL5g3+kfbP7hkDNIiHXpscyAI+kw8/NlQBGWbVStqKOOBGNFolXWFfRmzgu5OY7FIm7LVdXLA+aX9VxB4I2qqUqzZfBpfxdIaSw0BVg8FxnRcO1ErJZIEZseIAy/k385ob5TLKDyRYk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.188
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.163.48])
	by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4YzD3z1vFSzWn1x;
	Thu, 20 Feb 2025 21:04:15 +0800 (CST)
Received: from kwepemg100017.china.huawei.com (unknown [7.202.181.58])
	by mail.maildlp.com (Postfix) with ESMTPS id 713FA1802D0;
	Thu, 20 Feb 2025 21:05:48 +0800 (CST)
Received: from localhost.huawei.com (10.90.30.45) by
 kwepemg100017.china.huawei.com (7.202.181.58) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Thu, 20 Feb 2025 21:05:47 +0800
From: Xingui Yang <yangxingui@huawei.com>
To: <john.garry@huawei.com>, <liyihang9@huawei.com>, <yanaijie@huawei.com>
CC: <jejb@linux.ibm.com>, <martin.petersen@oracle.com>,
	<linux-scsi@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<linuxarm@huawei.com>, <prime.zeng@huawei.com>, <yangxingui@huawei.com>,
	<liuyonglong@huawei.com>, <kangfenglong@huawei.com>,
	<liyangyang20@huawei.com>, <f.fangjian@huawei.com>,
	<xiabing14@h-partners.com>
Subject: [PATCH v3 1/3] scsi: hisi_sas: Enable force phy when SATA disk directly connected
Date: Thu, 20 Feb 2025 21:05:44 +0800
Message-ID: <20250220130546.2289555-2-yangxingui@huawei.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20250220130546.2289555-1-yangxingui@huawei.com>
References: <20250220130546.2289555-1-yangxingui@huawei.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
 kwepemg100017.china.huawei.com (7.202.181.58)

the SAS controller determines the disk to which I/Os are delivered based
on the port id in the DQ entry when SATA disk directly connected.

When many phys were disconnected immediately and connected again during
I/O sending and port id of phys were changed and used by other link, I/O
may be sent to incorrect disk and data inconsistency on the SATA disk may
occur during I/O retry with the old port id. So enable force phy, then
force the command to be executed in a certain phy, and if the actual phy
id of the port does not match the phy configured in the command, the chip
will stop delivering the I/O to disk.

Fixes: ce60689e12dd ("scsi: hisi_sas: add v3 code to send ATA frame")
Signed-off-by: Xingui Yang <yangxingui@huawei.com>
Reviewed-by: Yihang Li <liyihang9@huawei.com>
---
 drivers/scsi/hisi_sas/hisi_sas_v2_hw.c |  9 +++++++--
 drivers/scsi/hisi_sas/hisi_sas_v3_hw.c | 14 ++++++++++++--
 2 files changed, 19 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c b/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c
index 6e7f99fcc824..3af991cad07e 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c
@@ -2501,6 +2501,7 @@ static void prep_ata_v2_hw(struct hisi_hba *hisi_hba,
 	struct hisi_sas_port *port = to_hisi_sas_port(sas_port);
 	struct sas_ata_task *ata_task = &task->ata_task;
 	struct sas_tmf_task *tmf = slot->tmf;
+	int phy_id;
 	u8 *buf_cmd;
 	int has_data = 0, hdr_tag = 0;
 	u32 dw0, dw1 = 0, dw2 = 0;
@@ -2508,10 +2509,14 @@ static void prep_ata_v2_hw(struct hisi_hba *hisi_hba,
 	/* create header */
 	/* dw0 */
 	dw0 = port->id << CMD_HDR_PORT_OFF;
-	if (parent_dev && dev_is_expander(parent_dev->dev_type))
+	if (parent_dev && dev_is_expander(parent_dev->dev_type)) {
 		dw0 |= 3 << CMD_HDR_CMD_OFF;
-	else
+	} else {
+		phy_id = device->phy->identify.phy_identifier;
+		dw0 |= (1U << phy_id) << CMD_HDR_PHY_ID_OFF;
+		dw0 |= CMD_HDR_FORCE_PHY_MSK;
 		dw0 |= 4 << CMD_HDR_CMD_OFF;
+	}
 
 	if (tmf && ata_task->force_phy) {
 		dw0 |= CMD_HDR_FORCE_PHY_MSK;
diff --git a/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c b/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
index 095bbf80c34e..6a0656f3b596 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
@@ -359,6 +359,10 @@
 #define CMD_HDR_RESP_REPORT_MSK		(0x1 << CMD_HDR_RESP_REPORT_OFF)
 #define CMD_HDR_TLR_CTRL_OFF		6
 #define CMD_HDR_TLR_CTRL_MSK		(0x3 << CMD_HDR_TLR_CTRL_OFF)
+#define CMD_HDR_PHY_ID_OFF		8
+#define CMD_HDR_PHY_ID_MSK		(0x1ff << CMD_HDR_PHY_ID_OFF)
+#define CMD_HDR_FORCE_PHY_OFF		17
+#define CMD_HDR_FORCE_PHY_MSK		(0x1U << CMD_HDR_FORCE_PHY_OFF)
 #define CMD_HDR_PORT_OFF		18
 #define CMD_HDR_PORT_MSK		(0xf << CMD_HDR_PORT_OFF)
 #define CMD_HDR_PRIORITY_OFF		27
@@ -1429,15 +1433,21 @@ static void prep_ata_v3_hw(struct hisi_hba *hisi_hba,
 	struct hisi_sas_cmd_hdr *hdr = slot->cmd_hdr;
 	struct asd_sas_port *sas_port = device->port;
 	struct hisi_sas_port *port = to_hisi_sas_port(sas_port);
+	int phy_id;
 	u8 *buf_cmd;
 	int has_data = 0, hdr_tag = 0;
 	u32 dw1 = 0, dw2 = 0;
 
 	hdr->dw0 = cpu_to_le32(port->id << CMD_HDR_PORT_OFF);
-	if (parent_dev && dev_is_expander(parent_dev->dev_type))
+	if (parent_dev && dev_is_expander(parent_dev->dev_type)) {
 		hdr->dw0 |= cpu_to_le32(3 << CMD_HDR_CMD_OFF);
-	else
+	} else {
+		phy_id = device->phy->identify.phy_identifier;
+		hdr->dw0 |= cpu_to_le32((1U << phy_id)
+				<< CMD_HDR_PHY_ID_OFF);
+		hdr->dw0 |= CMD_HDR_FORCE_PHY_MSK;
 		hdr->dw0 |= cpu_to_le32(4U << CMD_HDR_CMD_OFF);
+	}
 
 	switch (task->data_dir) {
 	case DMA_TO_DEVICE:
-- 
2.33.0

