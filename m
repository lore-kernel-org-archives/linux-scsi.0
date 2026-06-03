Received: from canpmsgout10.his.huawei.com (canpmsgout10.his.huawei.com [113.46.200.225])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27110392C32;
	Wed,  3 Jun 2026 09:23:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=113.46.200.225
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780478595; cv=none; b=miiduAnHgoWZ0/o705re/dsOPfV8w9BRsPyOMU72zAyMPhvpiEutZp4C/R9FadRvJfXYNd7hihmcDKXqYyoHL0qCqGg8cujOt8ttPjvO5+S33CZdtrB6mnA533+477um1xaIFq5ZTFPvzXaRZnkBVt6jmNKETbKpHdAsgmt2r4s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780478595; c=relaxed/simple;
	bh=1xVW2E+hdRjtCngjFuTLIK1CACkUj1G5ICWRGaoaxDI=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Tnc2OLmZBOTGYq0FSV5XhhZBXmjCG2ugK9kD8vHSpii/5P9XhT0RceGLfn5iBxMYUXCA+9lWqvc4UVxReUsKP9DDyQO6r0laJhYzVKwP8zvmbQr4gBgMI4CoYfPTh3tm8NR6ufI+QJVHAWytFsqMLndnQQD7UsVTQxDVAZ/eJIo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=h-partners.com; dkim=pass (1024-bit key) header.d=h-partners.com header.i=@h-partners.com header.b=rZHnUsvK; arc=none smtp.client-ip=113.46.200.225
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=h-partners.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=h-partners.com header.i=@h-partners.com header.b="rZHnUsvK"
dkim-signature: v=1; a=rsa-sha256; d=h-partners.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=xSn+qz83wZny5kbe30x8qft/hhkTszJke/vaJ927OWg=;
	b=rZHnUsvKsZvbcLCl/BGKPS0gb735E+jEcTaOlc8HBz+0pBpDRadyCSuN+gtglNHnQh4e3yK1l
	TPrF2srD1thhzUap5VYdS0TalC/L1BVAVrPDLEwJEmVuvB5j608NRTN+YoXybd26pwrsi/ORFYo
	eNdMJ+kP1zFLNhFeK4Uownk=
Received: from mail.maildlp.com (unknown [172.19.163.127])
	by canpmsgout10.his.huawei.com (SkyGuard) with ESMTPS id 4gVhqr4W9rz1K97N;
	Wed,  3 Jun 2026 17:15:20 +0800 (CST)
Received: from kwepemj100018.china.huawei.com (unknown [7.202.194.12])
	by mail.maildlp.com (Postfix) with ESMTPS id 3E92540572;
	Wed,  3 Jun 2026 17:23:09 +0800 (CST)
Received: from localhost.localdomain (10.50.163.32) by
 kwepemj100018.china.huawei.com (7.202.194.12) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.36; Wed, 3 Jun 2026 17:23:08 +0800
From: Xingui Yang <yangxingui@huawei.com>
To: <john.g.garry@oracle.com>, <yanaijie@huawei.com>, <jejb@linux.ibm.com>,
	<martin.petersen@oracle.com>
CC: <linux-scsi@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<linuxarm@huawei.com>, <liyihang9@h-partners.com>, <yangxingui@huawei.com>,
	<liuyonglong@huawei.com>, <kangfenglong@huawei.com>
Subject: [PATCH v6 2/2] scsi: libsas: Add linkrate and sas_addr change detection in rediscover
Date: Wed, 3 Jun 2026 17:21:24 +0800
Message-ID: <20260603092124.2221524-3-yangxingui@huawei.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260603092124.2221524-1-yangxingui@huawei.com>
References: <20260603092124.2221524-1-yangxingui@huawei.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: kwepems200002.china.huawei.com (7.221.188.68) To
 kwepemj100018.china.huawei.com (7.202.194.12)

In sas_rediscover_dev(), when detecting a "flutter" condition (same SAS
address and compatible device type), the code assumes the device remains
unchanged and only handles SATA pending state recovery. However, this
approach misses two important scenarios:

First, the flutter detection only compares SAS address and device type,
ignoring potential linkrate changes that may have already occurred.

Second, after sas_ex_phy_discover() re-queries the expander phy, both
linkrate and attached SAS address may be updated. The current code does
not validate these changes against the existing child device.

Additionally, the replace code path (different SAS address detected)
has a sysfs duplication issue: sas_unregister_devs_sas_addr() only marks
the device as gone, but the actual sysfs cleanup happens later in
sas_destruct_devices(). Calling sas_discover_new() immediately after
unregister causes sysfs_warn_dup() errors.

Introduce sas_dev_is_flutter() to check whether it is a true flutter with
validation for linkrate and sas_addr changes. It returns true for normal
flutter and false when changes are detected requiring rediscovery.

When sas_addr change is detected, restore phy->attached_sas_addr to
child_dev->sas_addr so that sas_unregister_devs_sas_addr() can properly
match and unregister the device via sas_phy_match_dev_addr().

Introduce sas_rediscover_ex_phy() to handle async rediscovery for both
flutter and replace cases. When invoked:
- Set phy_change_count and ex_change_count to -1 to force revalidation
- Unregister the device via sas_unregister_devs_sas_addr()
- Queue DISCE_REVALIDATE_DOMAIN event

The old device sysfs is cleaned up by sas_destruct_devices() at the end
of current revalidation work. The new event triggers discovery via
sas_discover_new() since attached_sas_addr is cleared, avoiding the
sysfs duplication issue.

Signed-off-by: Xingui Yang <yangxingui@huawei.com>
Suggested-by: John Garry <john.g.garry@oracle.com>
---
 drivers/scsi/libsas/sas_expander.c | 72 ++++++++++++++++++++++++------
 1 file changed, 58 insertions(+), 14 deletions(-)

diff --git a/drivers/scsi/libsas/sas_expander.c b/drivers/scsi/libsas/sas_expander.c
index f55ae9a979cd..3153a2e22342 100644
--- a/drivers/scsi/libsas/sas_expander.c
+++ b/drivers/scsi/libsas/sas_expander.c
@@ -1962,6 +1962,61 @@ static bool dev_type_flutter(enum sas_device_type new, enum sas_device_type old)
 	return false;
 }
 
+static void sas_rediscover_ex_phy(struct domain_device *dev, int phy_id,
+				  bool last)
+{
+	struct expander_device *ex = &dev->ex_dev;
+	struct ex_phy *phy = &ex->ex_phy[phy_id];
+
+	phy->phy_change_count = -1;
+	ex->ex_change_count = -1;
+	sas_unregister_devs_sas_addr(dev, phy_id, last);
+	sas_discover_event(dev->port, DISCE_REVALIDATE_DOMAIN);
+}
+
+static bool sas_dev_is_flutter(struct domain_device *dev, int phy_id,
+			       u8 *sas_addr, enum sas_device_type type)
+{
+	struct expander_device *ex = &dev->ex_dev;
+	struct ex_phy *phy = &ex->ex_phy[phy_id];
+	struct domain_device *child_dev;
+	char *action = "";
+	int res;
+
+	if (SAS_ADDR(sas_addr) != SAS_ADDR(phy->attached_sas_addr) ||
+	    !dev_type_flutter(type, phy->attached_dev_type))
+		return false;
+
+	child_dev = sas_ex_to_dev(dev, phy_id);
+	if (!child_dev)
+		goto out;
+
+	res = sas_ex_phy_discover(dev, phy_id);
+	if (res)
+		return false;
+
+	if (dev_is_sata(child_dev) &&
+	    phy->attached_dev_type == SAS_SATA_PENDING) {
+		action = ", needs recovery";
+	} else if (child_dev->linkrate != phy->linkrate) {
+		pr_info("ex %016llx phy%02d linkrate changed from %d to %d\n",
+			SAS_ADDR(dev->sas_addr), phy_id,
+			child_dev->linkrate, phy->linkrate);
+		return false;
+	} else if (SAS_ADDR(child_dev->sas_addr) != SAS_ADDR(phy->attached_sas_addr)) {
+		pr_info("ex %016llx phy%02d sas_addr changed from %016llx to %016llx\n",
+			SAS_ADDR(dev->sas_addr), phy_id,
+			SAS_ADDR(child_dev->sas_addr),
+			SAS_ADDR(phy->attached_sas_addr));
+		memcpy(phy->attached_sas_addr, child_dev->sas_addr, SAS_ADDR_SIZE);
+		return false;
+	}
+out:
+	pr_debug("ex %016llx phy%02d broadcast flutter%s\n",
+		 SAS_ADDR(dev->sas_addr), phy_id, action);
+	return true;
+}
+
 static int sas_rediscover_dev(struct domain_device *dev, int phy_id,
 			      bool last, int sibling)
 {
@@ -2015,27 +2070,16 @@ static int sas_rediscover_dev(struct domain_device *dev, int phy_id,
 		if (res == 0)
 			sas_set_ex_phy(dev, phy_id, disc_resp);
 		goto out_free_resp;
-	} else if (SAS_ADDR(sas_addr) == SAS_ADDR(phy->attached_sas_addr) &&
-		   dev_type_flutter(type, phy->attached_dev_type)) {
-		struct domain_device *ata_dev = sas_ex_to_ata(dev, phy_id);
-		char *action = "";
-
-		sas_ex_phy_discover(dev, phy_id);
+	}
 
-		if (ata_dev && phy->attached_dev_type == SAS_SATA_PENDING)
-			action = ", needs recovery";
-		pr_debug("ex %016llx phy%02d broadcast flutter%s\n",
-			 SAS_ADDR(dev->sas_addr), phy_id, action);
+	if (sas_dev_is_flutter(dev, phy_id, sas_addr, type))
 		goto out_free_resp;
-	}
 
 	/* we always have to delete the old device when we went here */
 	pr_info("ex %016llx phy%02d replace %016llx\n",
 		SAS_ADDR(dev->sas_addr), phy_id,
 		SAS_ADDR(phy->attached_sas_addr));
-	sas_unregister_devs_sas_addr(dev, phy_id, last);
-
-	res = sas_discover_new(dev, phy_id);
+	sas_rediscover_ex_phy(dev, phy_id, last);
 out_free_resp:
 	kfree(disc_resp);
 	return res;
-- 
2.43.0

