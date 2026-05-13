Received: from canpmsgout05.his.huawei.com (canpmsgout05.his.huawei.com [113.46.200.220])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1ED234A3BC;
	Wed, 13 May 2026 02:17:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=113.46.200.220
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778638637; cv=none; b=MwPhzrrbTa2tV1Q9wtNRdYikWrwk7jz0S+iBKjN2wszBLpgt1TfKjGVyCKZzV/ZVDnJB85W5xSIsQFfGDHugX21wNBREDNb25QigIZH+cY54Z+3AJ1xr6Hdp0TSsbzr/vlVKpD2y2F4tI0Kfe3FWBvvzfybYVjLbMp3+PGjUlsc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778638637; c=relaxed/simple;
	bh=9m/ENIaZqWIQ6DDMOEhdapqwfQ/HaJOpbfhG9bTfjio=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=V7zWzYa9hIvG4lwaJBgDRFKgGaDMJK7Ww2kjNBpKf7nWGaC7l/8SExSXqOds3iFRr0kbWJs6RtBYdsojy5bVjO3+WibMvf7lsRHo+4LJ+hoMNjv3BA4kEEPwADWlv6CxbLy/lQE/ibaVSW/DVp7vdg1UgILEa5TslDr50DVAPAg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=h-partners.com; dkim=pass (1024-bit key) header.d=h-partners.com header.i=@h-partners.com header.b=UIPbf3gD; arc=none smtp.client-ip=113.46.200.220
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=h-partners.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=h-partners.com header.i=@h-partners.com header.b="UIPbf3gD"
dkim-signature: v=1; a=rsa-sha256; d=h-partners.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=w6panE/YjIew6+Ph9IC7ua2w+0qUcB9C76gBt9Re0S4=;
	b=UIPbf3gDvxNklvW8VFVz1rO9pUvj/daoBzQlcJ9FK7NmJhwknyANE5/fRGRJY7Ee6rCwia0Ic
	jZINvRjETXCt2NWcJNodBvQ3fdbATdye5GCRpHRvJHXM5Uo51bAEpzZRBACsairF0VPwdwWuWbc
	RDsUk7FoODdCICM9IDA7Vjs=
Received: from mail.maildlp.com (unknown [172.19.162.144])
	by canpmsgout05.his.huawei.com (SkyGuard) with ESMTPS id 4gFcNv0dS9z12Ln6;
	Wed, 13 May 2026 10:10:07 +0800 (CST)
Received: from kwepemj100018.china.huawei.com (unknown [7.202.194.12])
	by mail.maildlp.com (Postfix) with ESMTPS id 703834056D;
	Wed, 13 May 2026 10:17:12 +0800 (CST)
Received: from localhost.localdomain (10.50.163.32) by
 kwepemj100018.china.huawei.com (7.202.194.12) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.36; Wed, 13 May 2026 10:17:11 +0800
From: Xingui Yang <yangxingui@huawei.com>
To: <john.g.garry@oracle.com>, <yanaijie@huawei.com>, <jejb@linux.ibm.com>,
	<martin.petersen@oracle.com>
CC: <linux-scsi@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<linuxarm@huawei.com>, <liyihang9@h-partners.com>, <yangxingui@huawei.com>,
	<liuyonglong@huawei.com>, <kangfenglong@huawei.com>
Subject: [PATCH v2 1/3] scsi: libsas: refactor sas_ex_to_ata() using new helper sas_ex_to_dev()
Date: Wed, 13 May 2026 10:16:01 +0800
Message-ID: <20260513021603.3023329-2-yangxingui@huawei.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260513021603.3023329-1-yangxingui@huawei.com>
References: <20260513021603.3023329-1-yangxingui@huawei.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: kwepems100002.china.huawei.com (7.221.188.206) To
 kwepemj100018.china.huawei.com (7.202.194.12)

The sas_ex_to_ata() function checks for an attached ATA device on an
expander phy. Refactor it to use a new helper function sas_ex_to_dev()
which returns any device type attached to an expander phy, improving code
reuse and allowing other code paths to find attached devices regardless
of type.

No functional changes intended.

Signed-off-by: Xingui Yang <yangxingui@huawei.com>
---
 drivers/scsi/libsas/sas_expander.c | 12 ++++++++----
 drivers/scsi/libsas/sas_internal.h |  1 +
 2 files changed, 9 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/libsas/sas_expander.c b/drivers/scsi/libsas/sas_expander.c
index f471ab464a78..f55ae9a979cd 100644
--- a/drivers/scsi/libsas/sas_expander.c
+++ b/drivers/scsi/libsas/sas_expander.c
@@ -345,11 +345,9 @@ static void sas_set_ex_phy(struct domain_device *dev, int phy_id,
 		 SAS_ADDR(phy->attached_sas_addr), type);
 }
 
-/* check if we have an existing attached ata device on this expander phy */
-struct domain_device *sas_ex_to_ata(struct domain_device *ex_dev, int phy_id)
+struct domain_device *sas_ex_to_dev(struct domain_device *ex_dev, int phy_id)
 {
 	struct ex_phy *ex_phy = &ex_dev->ex_dev.ex_phy[phy_id];
-	struct domain_device *dev;
 	struct sas_rphy *rphy;
 
 	if (!ex_phy->port)
@@ -359,7 +357,13 @@ struct domain_device *sas_ex_to_ata(struct domain_device *ex_dev, int phy_id)
 	if (!rphy)
 		return NULL;
 
-	dev = sas_find_dev_by_rphy(rphy);
+	return sas_find_dev_by_rphy(rphy);
+}
+
+/* check if we have an existing attached ata device on this expander phy */
+struct domain_device *sas_ex_to_ata(struct domain_device *ex_dev, int phy_id)
+{
+	struct domain_device *dev = sas_ex_to_dev(ex_dev, phy_id);
 
 	if (dev && dev_is_sata(dev))
 		return dev;
diff --git a/drivers/scsi/libsas/sas_internal.h b/drivers/scsi/libsas/sas_internal.h
index 7dce0f587149..350a70484bde 100644
--- a/drivers/scsi/libsas/sas_internal.h
+++ b/drivers/scsi/libsas/sas_internal.h
@@ -91,6 +91,7 @@ int sas_smp_get_phy_events(struct sas_phy *phy);
 
 void sas_device_set_phy(struct domain_device *dev, struct sas_port *port);
 struct domain_device *sas_find_dev_by_rphy(struct sas_rphy *rphy);
+struct domain_device *sas_ex_to_dev(struct domain_device *ex_dev, int phy_id);
 struct domain_device *sas_ex_to_ata(struct domain_device *ex_dev, int phy_id);
 int sas_ex_phy_discover(struct domain_device *dev, int single);
 int sas_get_report_phy_sata(struct domain_device *dev, int phy_id,
-- 
2.43.0

