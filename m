Received: from canpmsgout12.his.huawei.com (canpmsgout12.his.huawei.com [113.46.200.227])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC469360EF2;
	Thu, 11 Jun 2026 06:16:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=113.46.200.227
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781158565; cv=none; b=EDumzv6fJdoSZU7lMq4iekxHCpuaNhxEidNPz8/0S8v3nXXzsEqQ8k94H1hLBieW7rzKZ4jSLEkPfhQ/zzDeGk/OHi2ad1oq8W7WkO94A0BfYPL8matYQ+y37ozUWzU4sGBYnSC8Ef4mrEPe0usSqEg9ieZm6xvwD03vi+pydLk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781158565; c=relaxed/simple;
	bh=ORHqyx6iSr4Cwh98iRBYCcot5oCxsYFariuXpcSeIzs=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=WtVQW1BhCJC/wB+Hk474AS2RvbuuE+CjtdL57htseD6uhdoXySBh4RepxcCgHKPp10C8ph9HhaxE/QB1UiU5EalDT42OmGiLbbNAtGy4QKKmseWu4p2W6Mzmhc9jbrKbi5rEYXOf/FOC+dKwDnkrrLXVUW7yHUaR490Z2OVQQ+U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=h-partners.com; dkim=pass (1024-bit key) header.d=h-partners.com header.i=@h-partners.com header.b=Q/zHUm6O; arc=none smtp.client-ip=113.46.200.227
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=h-partners.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=h-partners.com header.i=@h-partners.com header.b="Q/zHUm6O"
dkim-signature: v=1; a=rsa-sha256; d=h-partners.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=KgloCteKBb7eVzozAMyZXMWje7TzIbG3M27y2CX7Qzw=;
	b=Q/zHUm6OAi25aRXi05yLPRFucKHBLiFRrDKsXqaMp/7EK1qcIlEqYSW0ET8jN/lDlsLyqb2Vy
	kONFq+tIAt8brNCXUV09iDijuVeMgTAqDAiDo/+t8ETfI6s84dxtG8fcviKtPgQbStTLlcw8fbZ
	Fq0Di1DIJubGIDjCzo561bc=
Received: from mail.maildlp.com (unknown [172.19.163.127])
	by canpmsgout12.his.huawei.com (SkyGuard) with ESMTPS id 4gbXJ46yyQznTV5;
	Thu, 11 Jun 2026 14:08:04 +0800 (CST)
Received: from kwepemj100018.china.huawei.com (unknown [7.202.194.12])
	by mail.maildlp.com (Postfix) with ESMTPS id 8FFC5402AB;
	Thu, 11 Jun 2026 14:15:53 +0800 (CST)
Received: from localhost.localdomain (10.50.163.32) by
 kwepemj100018.china.huawei.com (7.202.194.12) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.36; Thu, 11 Jun 2026 14:15:52 +0800
From: Xingui Yang <yangxingui@huawei.com>
To: <john.g.garry@oracle.com>, <yanaijie@huawei.com>, <jejb@linux.ibm.com>,
	<martin.petersen@oracle.com>
CC: <linux-scsi@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<linuxarm@huawei.com>, <liyihang9@h-partners.com>, <yangxingui@huawei.com>,
	<liuyonglong@huawei.com>, <kangfenglong@huawei.com>
Subject: [PATCH v7 2/2] scsi: libsas: Add linkrate and sas_addr change detection in rediscover
Date: Thu, 11 Jun 2026 14:15:51 +0800
Message-ID: <20260611061551.1171058-3-yangxingui@huawei.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260611061551.1171058-1-yangxingui@huawei.com>
References: <20260611061551.1171058-1-yangxingui@huawei.com>
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
 drivers/scsi/libsas/sas_expander.c | 82 +++++++++++++++++++++++++-----
 1 file changed, 68 insertions(+), 14 deletions(-)

diff --git a/drivers/scsi/libsas/sas_expander.c b/drivers/scsi/libsas/sas_expander.c
index f55ae9a979cd..4145938a0db5 100644
--- a/drivers/scsi/libsas/sas_expander.c
+++ b/drivers/scsi/libsas/sas_expander.c
@@ -1962,6 +1962,71 @@ static bool dev_type_flutter(enum sas_device_type new, enum sas_device_type old)
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
+		goto out;
+	}
+
+	if (child_dev->linkrate != phy->linkrate) {
+		pr_info("ex %016llx phy%02d linkrate changed from %d to %d\n",
+			SAS_ADDR(dev->sas_addr), phy_id,
+			child_dev->linkrate, phy->linkrate);
+		return false;
+	}
+
+	if (SAS_ADDR(child_dev->sas_addr) != SAS_ADDR(phy->attached_sas_addr)) {
+		pr_info("ex %016llx phy%02d sas_addr changed from %016llx to %016llx\n",
+			SAS_ADDR(dev->sas_addr), phy_id,
+			SAS_ADDR(child_dev->sas_addr),
+			SAS_ADDR(phy->attached_sas_addr));
+		/*
+		 * Device unregistering relies on address matching. Restore
+		 * attached_sas_addr back to the original address so that the old
+		 * device can be unregistered later
+		 */
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
@@ -2015,27 +2080,16 @@ static int sas_rediscover_dev(struct domain_device *dev, int phy_id,
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

