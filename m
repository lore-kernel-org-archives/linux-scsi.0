Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2D1A23C361
	for <linux-scsi@vger.kernel.org>; Wed, 12 Mar 2025 09:51:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.187
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741773108; cv=none; b=twc+4ChJPP8+k02nAN5X9PkKTNE7/WgjR00Hp3AbqysWMiU61MpK78aujtQN3amkz7SR0xRdLbJiVZKf02IW8UtgOnusgEXnBTUCCnJAMj4bmPk2mxrew3FRhrHyqY73VxySNmzB47Toy9SnBFjR2Umhm+X1tdh5+1sZwf3Y4ko=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741773108; c=relaxed/simple;
	bh=2lEHRuqrsa82Nq1byjRcR0oQVGykGOGFwi0EkqW3gao=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=hBmdZXCpqXgJNL7Edl/mSIyBV/4nvhfR/K/ZsdJ75kUpdNBYI+fJCD9dFHrD2ZJCwga87bpg1D7ILyh7sCqEsIZtHqnWj8EV+xySEAfSd+wrl8V7pOuFhDdrEa6uI+S6p2lnjKnN10zoXFuZSM0m5BX3+fSjG+NWL9R8/V3m9C4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.187
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.162.254])
	by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4ZCQrQ4ydczyRtG;
	Wed, 12 Mar 2025 17:51:34 +0800 (CST)
Received: from kwepemg100017.china.huawei.com (unknown [7.202.181.58])
	by mail.maildlp.com (Postfix) with ESMTPS id 450F9180102;
	Wed, 12 Mar 2025 17:51:39 +0800 (CST)
Received: from localhost.huawei.com (10.90.30.45) by
 kwepemg100017.china.huawei.com (7.202.181.58) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Wed, 12 Mar 2025 17:51:38 +0800
From: Xingui Yang <yangxingui@huawei.com>
To: <john.g.garry@oracle.com>, <yanaijie@huawei.com>
CC: <jejb@linux.ibm.com>, <martin.petersen@oracle.com>,
	<linux-scsi@vger.kernel.org>, <linuxarm@huawei.com>, <prime.zeng@huawei.com>,
	<yangxingui@huawei.com>, <liuyonglong@huawei.com>, <kangfenglong@huawei.com>,
	<liyangyang20@huawei.com>, <f.fangjian@huawei.com>,
	<xiabing14@h-partners.com>, <zhonghaoquan@hisilicon.com>
Subject: [PATCH v4 2/2] scsi: hisi_sas: Fix IO errors caused by hardware port ID changes
Date: Wed, 12 Mar 2025 17:51:35 +0800
Message-ID: <20250312095135.3048379-3-yangxingui@huawei.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20250312095135.3048379-1-yangxingui@huawei.com>
References: <20250312095135.3048379-1-yangxingui@huawei.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: dggems705-chm.china.huawei.com (10.3.19.182) To
 kwepemg100017.china.huawei.com (7.202.181.58)

The hw port id of phy may change when inserting disks in batches, causing
the port id in hisi_sas_port and itct to be inconsistent with the hardware,
resulting in IO errors. The solution is to set the device state to gone to
intercept IO sent to the device, and then execute linkreset to discard and
find the disk to re-update its information.

Signed-off-by: Xingui Yang <yangxingui@huawei.com>
---
 drivers/scsi/hisi_sas/hisi_sas_main.c | 20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

diff --git a/drivers/scsi/hisi_sas/hisi_sas_main.c b/drivers/scsi/hisi_sas/hisi_sas_main.c
index da4a2ed8ee86..edb1efc241db 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_main.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_main.c
@@ -911,8 +911,28 @@ static void hisi_sas_phyup_work_common(struct work_struct *work,
 		container_of(work, typeof(*phy), works[event]);
 	struct hisi_hba *hisi_hba = phy->hisi_hba;
 	struct asd_sas_phy *sas_phy = &phy->sas_phy;
+	struct asd_sas_port *sas_port = sas_phy->port;
+	struct hisi_sas_port *port = phy->port;
+	struct device *dev = hisi_hba->dev;
+	struct domain_device *port_dev;
 	int phy_no = sas_phy->id;
 
+	if (!test_bit(HISI_SAS_RESETTING_BIT, &hisi_hba->flags) &&
+	    sas_port && port && (port->id != phy->port_id)) {
+		dev_info(dev, "phy%d's hw port id changed from %d to %llu\n",
+				phy_no, port->id, phy->port_id);
+		port_dev = sas_port->port_dev;
+		if (port_dev && !dev_is_expander(port_dev->dev_type)) {
+			/*
+			 * Set the device state to gone to block
+			 * sending IO to the device.
+			 */
+			set_bit(SAS_DEV_GONE, &port_dev->state);
+			hisi_sas_notify_phy_event(phy, HISI_PHYE_LINK_RESET);
+			return;
+		}
+	}
+
 	phy->wait_phyup_cnt = 0;
 	if (phy->identify.target_port_protocols == SAS_PROTOCOL_SSP)
 		hisi_hba->hw->sl_notify_ssp(hisi_hba, phy_no);
-- 
2.33.0

