Received: from szxga08-in.huawei.com (szxga08-in.huawei.com [45.249.212.255])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1103B182C5
	for <linux-scsi@vger.kernel.org>; Tue,  8 Oct 2024 02:18:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.255
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728353917; cv=none; b=UXFRFQC4Ieb0WP/tHKBair5g/Vuaa6QvxSrI/fC4+OsT6IH+KPCe3sY7zXhFpguvPNrCb1mm0nOOCm/dbTqJ7jnkBY3PN5QaINaAX30p4x2vhuCb3vlZA0goM1rQhtXIHdDsaTAL0MRJirjjK5zT1UqbkPZISukfz2H/KHdztQg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728353917; c=relaxed/simple;
	bh=56gz1DnxyZSPJndfDIZ0eZ8Y+0fGkcxO+C93+ZxCaNs=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=lNF273KPMhxK8wXNwjKuVlf15lpATjH8k8FYKTUSaZPmvupMhxThMEv/LrOpVHuI3tW6jPtmcqnKbNU3TgzAwwYqxWOSIzJ5FqnX8+Sx0jh+IrsOcRXWlXhp2ASNbvGP88RLbr5xNDU+WP8QWYqamwLWsYrBsKuY8XseP2K5cH8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.255
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.162.254])
	by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4XN05B5VC0z1T8HN;
	Tue,  8 Oct 2024 10:16:46 +0800 (CST)
Received: from dggpemf100013.china.huawei.com (unknown [7.185.36.179])
	by mail.maildlp.com (Postfix) with ESMTPS id 54014180106;
	Tue,  8 Oct 2024 10:18:28 +0800 (CST)
Received: from localhost.huawei.com (10.50.165.33) by
 dggpemf100013.china.huawei.com (7.185.36.179) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Tue, 8 Oct 2024 10:18:28 +0800
From: Yihang Li <liyihang9@huawei.com>
To: <James.Bottomley@HansenPartnership.com>, <martin.petersen@oracle.com>
CC: <linux-scsi@vger.kernel.org>, <linuxarm@huawei.com>,
	<liyihang9@huawei.com>
Subject: [PATCH v2 05/13] scsi: hisi_sas: Reset PHY again if phyup timeout
Date: Tue, 8 Oct 2024 10:18:14 +0800
Message-ID: <20241008021822.2617339-6-liyihang9@huawei.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20241008021822.2617339-1-liyihang9@huawei.com>
References: <20241008021822.2617339-1-liyihang9@huawei.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
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
index f3b0042ab67c..93f9f13084fd 100644
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

