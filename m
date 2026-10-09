Received: from canpmsgout02.his.huawei.com (canpmsgout02.his.huawei.com [113.46.200.217])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B0CA39A7F7;
	Fri,  9 Oct 2026 03:32:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=113.46.200.217
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791516778; cv=none; b=EeDTcfoAxDtvHA8Yn3/MKDan+fcYfGPJOQ+R4xomzPbezJlbZpLF8ETHFTj9DhAbY52QVmosvBwtvURZ2toBC2FgEmRWyWU8H9sAWIuTXqhfILlhAx9Y/6uIez19nCEtXdi+wIV30ggUJ2sIpSrfAnWG3xGiLzOjHsfJnQ6HaNM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791516778; c=relaxed/simple;
	bh=3iUbIu7wn2a/Ac0TTJaeRyRD92Zt761J66HfWKzs8aY=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=UWp8cUdrXuagyoZUV6gTn6sMXnmmlEA8epWcXlOwbv9VskiLv9VtW7iHGYBNX/HZT6VfIO9lJv4myAB0Wj68ZPMUI8M4/CJrnwizDml9q5+sje4cGshTg2VomWxE4YHZg4J5Z81uIqTCAV2kGhw0NeZb7ciBdrVzKjo5xMkQ+xk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=h-partners.com; dkim=pass (1024-bit key) header.d=h-partners.com header.i=@h-partners.com header.b=osBIa4wO; arc=none smtp.client-ip=113.46.200.217
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=h-partners.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=h-partners.com header.i=@h-partners.com header.b="osBIa4wO"
dkim-signature: v=1; a=rsa-sha256; d=h-partners.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=TMELnjkQQLTdwn/+hAAYGm2MTYs7s8aZUYcOrrmhdyY=;
	b=osBIa4wO4r7IOKAPcy7JCYgxJ60euDE1f2fQpb8zHmZDHfV01mYDx/lbnWQLU2NXzRHqDTYM+
	7i+DGp60+k8ym3tg+FsZS+MW2hNJezKI3id101xEK8VlCcRW63v2QL3ewFjU4UlYmWX9QeAniq9
	npJACW6AdGU7YtzEz7acJug=
Received: from mail.maildlp.com (unknown [172.19.162.144])
	by canpmsgout02.his.huawei.com (SkyGuard) with ESMTPS id 4j1Bvk5GBGzcb46;
	Fri,  9 Oct 2026 11:20:50 +0800 (CST)
Received: from kwepemp500005.china.huawei.com (unknown [7.202.195.153])
	by mail.maildlp.com (Postfix) with ESMTPS id C2D0E4056E;
	Fri,  9 Oct 2026 11:32:43 +0800 (CST)
Received: from kwepemp500015.china.huawei.com (7.202.195.9) by
 kwepemp500005.china.huawei.com (7.202.195.153) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.45; Fri, 9 Oct 2026 11:32:43 +0800
Received: from localhost.localdomain (10.50.163.32) by
 kwepemp500015.china.huawei.com (7.202.195.9) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.45; Fri, 9 Oct 2026 11:32:43 +0800
From: Xingui Yang <yangxingui@huawei.com>
To: <mkp@kernel.org>, <jejb@linux.ibm.com>, <john.garry@linux.dev>,
	<yanaijie@huawei.com>
CC: <linux-scsi@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<linuxarm@huawei.com>, <yangxingui@huawei.com>, <liuyonglong@huawei.com>,
	<kangfenglong@huawei.com>
Subject: [PATCH v3 4/4] scsi: hisi_sas: Fix spinup failure for SAS SSP devices in Active_Wait state
Date: Fri, 9 Oct 2026 11:32:38 +0800
Message-ID: <20261009033238.1076098-5-yangxingui@huawei.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261009033238.1076098-1-yangxingui@huawei.com>
References: <20261009033238.1076098-1-yangxingui@huawei.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: kwepems200001.china.huawei.com (7.221.188.67) To
 kwepemp500015.china.huawei.com (7.202.195.9)

SAS HDDs powered up with RNOT=1 wait in Active_Wait state for a
NOTIFY(ENABLE SPINUP) primitive and keep returning NOT_READY with
ASC/ASCQ 0x04/0x11, causing endless mid-layer retries and spinup
failure.

Parse the sense data in the slot completion path and, when
LU_NOT_READY_NOTIFY_REQUIRED is returned by a directly-attached SSP
device, queue work that sends the primitive from process context
(sl_notify_ssp() contains msleep()). The work takes a runtime PM
reference with pm_runtime_get_if_active(), pairing with
pm_runtime_put_sync() in the work, so the controller stays resumed
until the primitive is sent.

Fixes: 60b4a5ee9034 ("scsi: hisi_sas: add v3 cq interrupt handler")
Signed-off-by: Xingui Yang <yangxingui@huawei.com>
---
 drivers/scsi/hisi_sas/hisi_sas.h       |  3 ++
 drivers/scsi/hisi_sas/hisi_sas_main.c  | 43 ++++++++++++++++++++++++++
 drivers/scsi/hisi_sas/hisi_sas_v1_hw.c |  4 +++
 drivers/scsi/hisi_sas/hisi_sas_v2_hw.c |  4 +++
 drivers/scsi/hisi_sas/hisi_sas_v3_hw.c |  4 +++
 5 files changed, 58 insertions(+)

diff --git a/drivers/scsi/hisi_sas/hisi_sas.h b/drivers/scsi/hisi_sas/hisi_sas.h
index 1323ed8aa717..d48ba3747b81 100644
--- a/drivers/scsi/hisi_sas/hisi_sas.h
+++ b/drivers/scsi/hisi_sas/hisi_sas.h
@@ -163,6 +163,7 @@ enum hisi_sas_phy_event {
 	HISI_PHYE_PHY_UP   = 0U,
 	HISI_PHYE_LINK_RESET,
 	HISI_PHYE_PHY_UP_PM,
+	HISI_PHYE_SPINUP_NOTIFY,
 	HISI_PHYES_NUM,
 };
 
@@ -689,4 +690,6 @@ extern void hisi_sas_sync_cqs(struct hisi_hba *hisi_hba);
 extern void hisi_sas_sync_poll_cqs(struct hisi_hba *hisi_hba);
 extern void hisi_sas_controller_reset_prepare(struct hisi_hba *hisi_hba);
 extern void hisi_sas_controller_reset_done(struct hisi_hba *hisi_hba);
+extern void hisi_sas_spinup_notify(struct hisi_hba *hisi_hba,
+				   struct sas_task *task);
 #endif
diff --git a/drivers/scsi/hisi_sas/hisi_sas_main.c b/drivers/scsi/hisi_sas/hisi_sas_main.c
index 944ce19ae2fc..cf7aa0a699cd 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_main.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_main.c
@@ -996,10 +996,25 @@ static void hisi_sas_phyup_pm_work(struct work_struct *work)
 	pm_runtime_put_sync(dev);
 }
 
+static void hisi_sas_spinup_notify_work(struct work_struct *work)
+{
+	struct hisi_sas_phy *phy =
+		container_of(work, typeof(*phy), works[HISI_PHYE_SPINUP_NOTIFY]);
+	struct hisi_hba *hisi_hba = phy->hisi_hba;
+	struct device *dev = hisi_hba->dev;
+	int phy_no = phy->sas_phy.id;
+
+	hisi_hba->hw->sl_notify_ssp(hisi_hba, phy_no);
+	dev_info(dev, "spinup notify primitive on phy%d\n", phy_no);
+
+	pm_runtime_put_sync(dev);
+}
+
 static const work_func_t hisi_sas_phye_fns[HISI_PHYES_NUM] = {
 	[HISI_PHYE_PHY_UP] = hisi_sas_phyup_work,
 	[HISI_PHYE_LINK_RESET] = hisi_sas_linkreset_work,
 	[HISI_PHYE_PHY_UP_PM] = hisi_sas_phyup_pm_work,
+	[HISI_PHYE_SPINUP_NOTIFY] = hisi_sas_spinup_notify_work,
 };
 
 bool hisi_sas_notify_phy_event(struct hisi_sas_phy *phy,
@@ -1639,6 +1654,34 @@ void hisi_sas_controller_reset_done(struct hisi_hba *hisi_hba)
 }
 EXPORT_SYMBOL_GPL(hisi_sas_controller_reset_done);
 
+void hisi_sas_spinup_notify(struct hisi_hba *hisi_hba,
+			    struct sas_task *task)
+{
+	struct task_status_struct *ts = &task->task_status;
+	struct domain_device *dev = task->dev;
+	struct scsi_sense_hdr sshdr;
+	struct sas_phy *local_phy;
+	struct hisi_sas_phy *phy;
+
+	if (!scsi_normalize_sense(ts->buf, ts->buf_valid_size, &sshdr))
+		return;
+
+	if (sshdr.sense_key != NOT_READY ||
+	    sshdr.sense_code != LU_NOT_READY_NOTIFY_REQUIRED)
+		return;
+
+	if (!pm_runtime_get_if_active(hisi_hba->dev))
+		return;
+
+	local_phy = sas_get_local_phy(dev);
+	phy = &hisi_hba->phy[local_phy->number];
+	if (!hisi_sas_notify_phy_event(phy, HISI_PHYE_SPINUP_NOTIFY))
+		pm_runtime_put(hisi_hba->dev);
+
+	sas_put_local_phy(local_phy);
+}
+EXPORT_SYMBOL_GPL(hisi_sas_spinup_notify);
+
 static int hisi_sas_controller_prereset(struct hisi_hba *hisi_hba)
 {
 	if (!hisi_hba->hw->soft_reset)
diff --git a/drivers/scsi/hisi_sas/hisi_sas_v1_hw.c b/drivers/scsi/hisi_sas/hisi_sas_v1_hw.c
index fa94d7110714..5fcb8d5002f5 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_v1_hw.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_v1_hw.c
@@ -1272,6 +1272,10 @@ static void slot_complete_v1_hw(struct hisi_hba *hisi_hba,
 				&status_buffer->iu[0];
 
 		sas_ssp_task_response(dev, task, iu);
+		if (unlikely(ts->stat == SAS_SAM_STAT_CHECK_CONDITION &&
+			     !dev_parent_is_expander(device)))
+			hisi_sas_spinup_notify(hisi_hba, task);
+
 		break;
 	}
 	case SAS_PROTOCOL_SMP:
diff --git a/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c b/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c
index f3516a0611dd..f16896e962fd 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c
@@ -2427,6 +2427,10 @@ static void slot_complete_v2_hw(struct hisi_hba *hisi_hba,
 				&status_buffer->iu[0];
 
 		sas_ssp_task_response(dev, task, iu);
+		if (unlikely(ts->stat == SAS_SAM_STAT_CHECK_CONDITION &&
+			     !dev_parent_is_expander(device)))
+			hisi_sas_spinup_notify(hisi_hba, task);
+
 		break;
 	}
 	case SAS_PROTOCOL_SMP:
diff --git a/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c b/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
index 030f050731ba..9391d031f5df 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
@@ -2447,6 +2447,10 @@ static void slot_complete_v3_hw(struct hisi_hba *hisi_hba,
 			sizeof(struct hisi_sas_err_record);
 
 		sas_ssp_task_response(dev, task, iu);
+		if (unlikely(ts->stat == SAS_SAM_STAT_CHECK_CONDITION &&
+			     !dev_parent_is_expander(device)))
+			hisi_sas_spinup_notify(hisi_hba, task);
+
 		break;
 	}
 	case SAS_PROTOCOL_SMP: {
-- 
2.43.0

