Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75A771F584A;
	Thu, 20 Feb 2025 13:06:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.188
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740056781; cv=none; b=VyXH5uS8gzsCCB2AeJ3+PZ6wesly1/3i1xywibPeFNPkEsrD85WA7RSG8QlqXDSke9uW5Tpzbvv924OX+nYaD3tvbHviQddgblz9CxBB0ugff5RLsQrkKOCwYUiEnUec+6UCKy6irQCxnqszVix28z1Dm93oyZSaLu51Ubhnl0o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740056781; c=relaxed/simple;
	bh=cwrEDWn9gOz8N1o79meswT+NNyq8vNgg6/i34OwYYY0=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Y81XKwmhqwZymDTpLJquj2HUa763PffYSsu38YLBdHzFT1OhhDn4JQ4/V1tZa3ng+8KI8dS2xXdSCVxSmI/wrBcx1X4NEACnentQaOS5k/E4Qp4sF30E1mr7Gn1jRStwnQ+WYttfcIapKdHrB8hf6GGcODt5mDQcd6b1Eqkydes=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.188
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.162.254])
	by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4YzD402VqtzWn23;
	Thu, 20 Feb 2025 21:04:16 +0800 (CST)
Received: from kwepemg100017.china.huawei.com (unknown [7.202.181.58])
	by mail.maildlp.com (Postfix) with ESMTPS id 86298180113;
	Thu, 20 Feb 2025 21:05:49 +0800 (CST)
Received: from localhost.huawei.com (10.90.30.45) by
 kwepemg100017.china.huawei.com (7.202.181.58) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Thu, 20 Feb 2025 21:05:48 +0800
From: Xingui Yang <yangxingui@huawei.com>
To: <john.garry@huawei.com>, <liyihang9@huawei.com>, <yanaijie@huawei.com>
CC: <jejb@linux.ibm.com>, <martin.petersen@oracle.com>,
	<linux-scsi@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<linuxarm@huawei.com>, <prime.zeng@huawei.com>, <yangxingui@huawei.com>,
	<liuyonglong@huawei.com>, <kangfenglong@huawei.com>,
	<liyangyang20@huawei.com>, <f.fangjian@huawei.com>,
	<xiabing14@h-partners.com>
Subject: [PATCH v3 3/3] scsi: hisi_sas: Fixed IO error caused by port id not updated
Date: Thu, 20 Feb 2025 21:05:46 +0800
Message-ID: <20250220130546.2289555-4-yangxingui@huawei.com>
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

After phy up and its asd_sas_port is not null, the hisi_sas_port
information will not be updated although its hardware port id changes,
then the old port id will cause IO exception. Therefore, update the port
id and itct information when the phy's hw port id changes.

Signed-off-by: Xingui Yang <yangxingui@huawei.com>
---
 drivers/scsi/hisi_sas/hisi_sas_main.c | 51 +++++++++++++++++++++++++++
 1 file changed, 51 insertions(+)

diff --git a/drivers/scsi/hisi_sas/hisi_sas_main.c b/drivers/scsi/hisi_sas/hisi_sas_main.c
index 3596414d970b..26d60d21779f 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_main.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_main.c
@@ -176,6 +176,56 @@ void hisi_sas_stop_phys(struct hisi_hba *hisi_hba)
 }
 EXPORT_SYMBOL_GPL(hisi_sas_stop_phys);
 
+static void hisi_sas_update_itct(void *data, async_cookie_t cookie)
+{
+	struct domain_device *device = data;
+	struct hisi_sas_device *sas_dev = device->lldd_dev;
+	struct hisi_hba *hisi_hba = sas_dev->hisi_hba;
+
+	hisi_hba->hw->clear_itct(hisi_hba, sas_dev);
+	hisi_hba->hw->setup_itct(hisi_hba, sas_dev);
+	sas_put_device(device);
+}
+
+static void hisi_sas_update_port_id(struct hisi_hba *hisi_hba, int phy_no)
+{
+	struct hisi_sas_phy *phy = &hisi_hba->phy[phy_no];
+	struct asd_sas_phy *sas_phy = &phy->sas_phy;
+	struct device *dev = hisi_hba->dev;
+	struct asd_sas_port *sas_port;
+	struct domain_device *device;
+	struct hisi_sas_port *port;
+	ASYNC_DOMAIN_EXCLUSIVE(async);
+
+	if (test_bit(HISI_SAS_RESETTING_BIT, &hisi_hba->flags) ||
+	    !sas_phy->port)
+		return;
+
+	sas_port = sas_phy->port;
+	port = to_hisi_sas_port(sas_port);
+	if (phy->port_id == port->id)
+		return;
+
+	dev_info(dev, "phy%d's hw port id changed from %d to %llu\n",
+		 phy_no, port->id, phy->port_id);
+	port->id = phy->port_id;
+	spin_lock(&sas_port->dev_list_lock);
+	list_for_each_entry(device, &sas_port->dev_list, dev_list_node) {
+		if (!device->parent)
+			device->linkrate = phy->sas_phy.linkrate;
+
+		/*
+		 * Update itct may trigger scheduling, it cannot be within
+		 * an atomic context, so use asynchronous scheduling and
+		 * hold a reference to avoid racing with final remove.
+		 */
+		kref_get(&device->kref);
+		async_schedule_domain(hisi_sas_update_itct, device, &async);
+	}
+	spin_unlock(&sas_port->dev_list_lock);
+	async_synchronize_full_domain(&async);
+}
+
 static void hisi_sas_slot_index_clear(struct hisi_hba *hisi_hba, int slot_idx)
 {
 	void *bitmap = hisi_hba->slot_index_tags;
@@ -937,6 +987,7 @@ static void hisi_sas_phyup_work_common(struct work_struct *work,
 	struct asd_sas_phy *sas_phy = &phy->sas_phy;
 	int phy_no = sas_phy->id;
 
+	hisi_sas_update_port_id(hisi_hba, phy_no);
 	phy->wait_phyup_cnt = 0;
 	if (phy->identify.target_port_protocols == SAS_PROTOCOL_SSP)
 		hisi_hba->hw->sl_notify_ssp(hisi_hba, phy_no);
-- 
2.33.0

