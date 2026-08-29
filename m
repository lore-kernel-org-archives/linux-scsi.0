Received: from canpmsgout03.his.huawei.com (canpmsgout03.his.huawei.com [113.46.200.218])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65D2C32B113;
	Sat, 29 Aug 2026 03:29:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=113.46.200.218
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787974152; cv=none; b=GLVj3NMvT5pfhvJM+VHL/HFME023KVGXexKKRQjUjt7N8C5/tOnesB4iAHzMfkavAQA79JVJFkKHAMWpaLAEDgx1ioWYVc3aMDvRWYuXVdKh+6LJPkEABKZM3y2LXOZ9G7L4BExkVCnfP9SlJ1aep/HkWJVnNhi+FKFwtguYV0k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787974152; c=relaxed/simple;
	bh=E7DYMq+KrbU9EaVGyX1RiWPn2dEO8qB5JuMjtAMn/6I=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Dz5ig2UbIG1QBkRgiroR7RWrGJihaW1XCeHhuFavIBCMMTC2OpihQw9snmXSLwiUIyswUA3g+XdKQflf4T2W6d+ezC2/xN2IGDcAtpKUfTTRAByYHDZx4eJosJQkUzdgHjlv6A+J0wutl6F5DGDcynxwqkhM7rn4tU6NU0d7CvA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=h-partners.com; dkim=pass (1024-bit key) header.d=h-partners.com header.i=@h-partners.com header.b=DvzRW6oh; arc=none smtp.client-ip=113.46.200.218
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=h-partners.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=h-partners.com header.i=@h-partners.com header.b="DvzRW6oh"
dkim-signature: v=1; a=rsa-sha256; d=h-partners.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=2Rppzi6/BcH+ztmHChwLZOG3AMX55Mgn3gS30zddtKY=;
	b=DvzRW6ohxY7ntNCFgnKzOvlen6KekoUwWkHQTFPHkIoCWUREgXJvqPFrJTMVgw17+D7qgQKiw
	KL6qvpW2xjPc0UfD9/CqYjmerowgBUgTtfGLHUkDfrrZkEg4RP5Xa5dF3mtA4tfMXnfxUkke1dy
	mIQY9CP7FE0lT7VeZfnVypg=
Received: from mail.maildlp.com (unknown [172.19.163.104])
	by canpmsgout03.his.huawei.com (SkyGuard) with ESMTPS id 4hX0n742rVzpT1J;
	Sat, 29 Aug 2026 11:17:47 +0800 (CST)
Received: from kwepemp500012.china.huawei.com (unknown [7.202.195.81])
	by mail.maildlp.com (Postfix) with ESMTPS id CA2E94058C;
	Sat, 29 Aug 2026 11:29:00 +0800 (CST)
Received: from kwepemp500015.china.huawei.com (7.202.195.9) by
 kwepemp500012.china.huawei.com (7.202.195.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.45; Sat, 29 Aug 2026 11:29:00 +0800
Received: from localhost.localdomain (10.50.163.32) by
 kwepemp500015.china.huawei.com (7.202.195.9) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.45; Sat, 29 Aug 2026 11:29:00 +0800
From: Xingui Yang <yangxingui@huawei.com>
To: <jejb@linux.ibm.com>, <martin.petersen@oracle.com>,
	<john.g.garry@oracle.com>, <yanaijie@huawei.com>
CC: <linux-scsi@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<linuxarm@huawei.com>, <yangxingui@huawei.com>, <liuyonglong@huawei.com>,
	<kangfenglong@huawei.com>
Subject: [PATCH 3/3] scsi: hisi_sas: Fix spinup failure for SAS SSP devices in Active_Wait state
Date: Sat, 29 Aug 2026 11:28:58 +0800
Message-ID: <20260829032858.1661019-4-yangxingui@huawei.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260829032858.1661019-1-yangxingui@huawei.com>
References: <20260829032858.1661019-1-yangxingui@huawei.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: kwepems100001.china.huawei.com (7.221.188.238) To
 kwepemp500015.china.huawei.com (7.202.195.9)

SAS HDDs powered up with RNOT=1 enter Active_Wait/Idle_Wait state and
return NOT_READY with ASC/ASCQ=0x04/0x11, causing indefinite mid-layer
retries and disk spinup failure.

Parse sense data in the driver's slot completion path using
scsi_normalize_sense(). When the spinup-notify sense is detected on a
directly-attached SSP device, queue HISI_PHYE_SPINUP_NOTIFY work to the
ordered workqueue, which defers sl_notify_ssp() (containing msleep) to
process context and serializes SL_CONTROL register access.

Fixes: 60b4a5ee9034 ("scsi: hisi_sas: add v3 cq interrupt handler")
Signed-off-by: Xingui Yang <yangxingui@huawei.com>
---
 drivers/scsi/hisi_sas/hisi_sas.h       |  3 ++
 drivers/scsi/hisi_sas/hisi_sas_main.c  | 38 ++++++++++++++++++++++++++
 drivers/scsi/hisi_sas/hisi_sas_v1_hw.c |  3 ++
 drivers/scsi/hisi_sas/hisi_sas_v2_hw.c |  3 ++
 drivers/scsi/hisi_sas/hisi_sas_v3_hw.c |  3 ++
 5 files changed, 50 insertions(+)

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
index 944ce19ae2fc..1cb578e6ae59 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_main.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_main.c
@@ -996,10 +996,22 @@ static void hisi_sas_phyup_pm_work(struct work_struct *work)
 	pm_runtime_put_sync(dev);
 }
 
+static void hisi_sas_spinup_notify_work(struct work_struct *work)
+{
+	struct hisi_sas_phy *phy =
+		container_of(work, typeof(*phy), works[HISI_PHYE_SPINUP_NOTIFY]);
+	struct hisi_hba *hisi_hba = phy->hisi_hba;
+	int phy_no = phy->sas_phy.id;
+
+	hisi_hba->hw->sl_notify_ssp(hisi_hba, phy_no);
+	dev_info(hisi_hba->dev, "spinup notify primitive on phy%d\n", phy_no);
+}
+
 static const work_func_t hisi_sas_phye_fns[HISI_PHYES_NUM] = {
 	[HISI_PHYE_PHY_UP] = hisi_sas_phyup_work,
 	[HISI_PHYE_LINK_RESET] = hisi_sas_linkreset_work,
 	[HISI_PHYE_PHY_UP_PM] = hisi_sas_phyup_pm_work,
+	[HISI_PHYE_SPINUP_NOTIFY] = hisi_sas_spinup_notify_work,
 };
 
 bool hisi_sas_notify_phy_event(struct hisi_sas_phy *phy,
@@ -1639,6 +1651,32 @@ void hisi_sas_controller_reset_done(struct hisi_hba *hisi_hba)
 }
 EXPORT_SYMBOL_GPL(hisi_sas_controller_reset_done);
 
+#define ASC_LUN_NOT_READY		0x04
+#define ASCQ_NOTIFY_SPINUP_REQUIRED	0x11
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
+	    sshdr.asc != ASC_LUN_NOT_READY ||
+	    sshdr.ascq != ASCQ_NOTIFY_SPINUP_REQUIRED)
+		return;
+
+	local_phy = sas_get_local_phy(dev);
+	phy = &hisi_hba->phy[local_phy->number];
+	hisi_sas_notify_phy_event(phy, HISI_PHYE_SPINUP_NOTIFY);
+	sas_put_local_phy(local_phy);
+}
+EXPORT_SYMBOL_GPL(hisi_sas_spinup_notify);
+
 static int hisi_sas_controller_prereset(struct hisi_hba *hisi_hba)
 {
 	if (!hisi_hba->hw->soft_reset)
diff --git a/drivers/scsi/hisi_sas/hisi_sas_v1_hw.c b/drivers/scsi/hisi_sas/hisi_sas_v1_hw.c
index fa94d7110714..9d89db6e8716 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_v1_hw.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_v1_hw.c
@@ -1272,6 +1272,9 @@ static void slot_complete_v1_hw(struct hisi_hba *hisi_hba,
 				&status_buffer->iu[0];
 
 		sas_ssp_task_response(dev, task, iu);
+		if (ts->stat == SAS_SAM_STAT_CHECK_CONDITION &&
+		    !dev_parent_is_expander(device))
+			hisi_sas_spinup_notify(hisi_hba, task);
 		break;
 	}
 	case SAS_PROTOCOL_SMP:
diff --git a/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c b/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c
index f3516a0611dd..dd48626db196 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c
@@ -2427,6 +2427,9 @@ static void slot_complete_v2_hw(struct hisi_hba *hisi_hba,
 				&status_buffer->iu[0];
 
 		sas_ssp_task_response(dev, task, iu);
+		if (ts->stat == SAS_SAM_STAT_CHECK_CONDITION &&
+		    !dev_parent_is_expander(device))
+			hisi_sas_spinup_notify(hisi_hba, task);
 		break;
 	}
 	case SAS_PROTOCOL_SMP:
diff --git a/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c b/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
index 0cdf72f3dde9..97d848885575 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
@@ -2449,6 +2449,9 @@ static void slot_complete_v3_hw(struct hisi_hba *hisi_hba,
 			sizeof(struct hisi_sas_err_record);
 
 		sas_ssp_task_response(dev, task, iu);
+		if (ts->stat == SAS_SAM_STAT_CHECK_CONDITION &&
+		    !dev_parent_is_expander(device))
+			hisi_sas_spinup_notify(hisi_hba, task);
 		break;
 	}
 	case SAS_PROTOCOL_SMP: {
-- 
2.43.0

