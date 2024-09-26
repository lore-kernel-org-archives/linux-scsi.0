Received: from szxga05-in.huawei.com (szxga05-in.huawei.com [45.249.212.191])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E0611714BE
	for <linux-scsi@vger.kernel.org>; Thu, 26 Sep 2024 01:43:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.191
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727315018; cv=none; b=nRUchm1whN4qqIuyf2s88VLS9hY/K34YvkJ5uJ5EuB+f+ydfwWdsNuolb5DcZ1v5LqAiiL614jVJNGNNhGTGnj61MMTqqjYtsNgqpozPC74bNsj15xhjRnJ30z2D2yj6Khn1dDyNT329qljdcZK/lzMyfz5ifB048tEw7LjJRTg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727315018; c=relaxed/simple;
	bh=6UbY7UAJrOSIY62FzegcwiYEE5Aolgs4PcRNS7Cym8M=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=sEZLY6vghB8cqvHOlAnCs6jdCwrIfphTdgzoelq1yfjsF7ATyU9YttvGZ4K6pJ81p+eX2I7Yy6UcfNOepZNh7msp3WGVPDZX745zh4/mTN/Qync3e3UbNA++CJ7aCajFP4gn88oSqczUnvWObn8meOMJ5h/UZFhViiKagPQRCow=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.191
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.88.163])
	by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4XDbqy4mKpz1HK0d;
	Thu, 26 Sep 2024 09:39:42 +0800 (CST)
Received: from dggpemf100013.china.huawei.com (unknown [7.185.36.179])
	by mail.maildlp.com (Postfix) with ESMTPS id D206418002B;
	Thu, 26 Sep 2024 09:43:33 +0800 (CST)
Received: from localhost.huawei.com (10.50.165.33) by
 dggpemf100013.china.huawei.com (7.185.36.179) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Thu, 26 Sep 2024 09:43:33 +0800
From: Yihang Li <liyihang9@huawei.com>
To: <James.Bottomley@HansenPartnership.com>, <martin.petersen@oracle.com>
CC: <linux-scsi@vger.kernel.org>, <linuxarm@huawei.com>,
	<liyihang9@huawei.com>
Subject: [PATCH 05/13] scsi: hisi_sas: Reset PHY again if phyup timeout
Date: Thu, 26 Sep 2024 09:43:24 +0800
Message-ID: <20240926014332.3905399-6-liyihang9@huawei.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20240926014332.3905399-1-liyihang9@huawei.com>
References: <20240926014332.3905399-1-liyihang9@huawei.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
 dggpemf100013.china.huawei.com (7.185.36.179)

In commit 89954f024c3a ("scsi: hisi_sas: Ensure all enabled PHYs up during
controller reset"), we enable PHYs in parallel through async operations
and wait for PHYs come up. However, for some directly attached SATA disks,
the PHY not come up after a timeout period and the hardware is not ready.
At this time, we should get the latest PHY hardware state, if the new PHY
state is not ready but the old PHY state is ready, call work
HISI_PHYE_LINK_RESET to give it another chance to phyup.

Signed-off-by: Yihang Li <liyihang9@huawei.com>
Reviewed-by: Xiang Chen <chenxiang66@hisilicon.com>
---
 drivers/scsi/hisi_sas/hisi_sas_main.c | 13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/hisi_sas/hisi_sas_main.c b/drivers/scsi/hisi_sas/hisi_sas_main.c
index 85374800251a..452baf9d5a26 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_main.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_main.c
@@ -1384,6 +1384,7 @@ static void hisi_sas_refresh_port_id(struct hisi_hba *hisi_hba)
 
 static void hisi_sas_rescan_topology(struct hisi_hba *hisi_hba, u32 state)
 {
+	u32 new_state = hisi_hba->hw->get_phys_state(hisi_hba);
 	struct asd_sas_port *_sas_port = NULL;
 	int phy_no;
 
@@ -1397,7 +1398,7 @@ static void hisi_sas_rescan_topology(struct hisi_hba *hisi_hba, u32 state)
 			continue;
 
 		/* Report PHY state change to libsas */
-		if (state & BIT(phy_no)) {
+		if (new_state & BIT(phy_no)) {
 			if (do_port_check && sas_port && sas_port->port_dev) {
 				struct domain_device *dev = sas_port->port_dev;
 
@@ -1410,6 +1411,16 @@ static void hisi_sas_rescan_topology(struct hisi_hba *hisi_hba, u32 state)
 			}
 		} else {
 			hisi_sas_phy_down(hisi_hba, phy_no, 0, GFP_KERNEL);
+
+			/*
+			 * The new_state is not ready but old_state is ready,
+			 * the two possible causes:
+			 * 1. The connected device is removed
+			 * 2. Device exists but phyup timed out
+			 */
+			if (state & BIT(phy_no))
+				hisi_sas_notify_phy_event(phy,
+							  HISI_PHYE_LINK_RESET);
 		}
 	}
 }
-- 
2.33.0

