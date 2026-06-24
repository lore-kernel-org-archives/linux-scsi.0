Received: from canpmsgout05.his.huawei.com (canpmsgout05.his.huawei.com [113.46.200.220])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3408388396;
	Wed, 24 Jun 2026 06:32:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=113.46.200.220
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782282757; cv=none; b=HdkpyAlmZyHWzoql9Zz6lsP7wvbVD9Gj9wngzvlV2rhbC0hXeNqhkLclW1kXkPK+zOxPl+kaAfebrxZt2E0FeHq4WPellfU+zKDeo7e8O4g5oUU3H0Esm/STFkqPbupsYTaem/9sPy+P+SEuFDK5Ww281rVFRYGMtA1oAFL794Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782282757; c=relaxed/simple;
	bh=wMJ0iU5E+VvNHeK3Lj6Z5A40DQQrEb5TKNhaTdwAtC4=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=J5FXRK6Ldiwg5161Nt2th8sTFYVBMhKMh/U2NPEq9NNMyBBcbH2bZmQ46ODTnM5bI6C4th4P6ysZDML9iPkINM62pJAFSknsnb7vZqxujinxZWsdWGph4hZtalf7L7B75pVQMC58vL/aZPEc6qrYv77D5t1o4PNI5/BQ36OkxLU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=h-partners.com; dkim=pass (1024-bit key) header.d=h-partners.com header.i=@h-partners.com header.b=RjiOw8FN; arc=none smtp.client-ip=113.46.200.220
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=h-partners.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=h-partners.com header.i=@h-partners.com header.b="RjiOw8FN"
dkim-signature: v=1; a=rsa-sha256; d=h-partners.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=HSNwBSCUEPOM/GPtmdX9ilibZ8hLS5SB8qdGuxxw1dQ=;
	b=RjiOw8FNdmITayc46STkkB3RzWMTsS5orMG7fW5d0IMArFyBQpPZsIlfPcnzDBbjWLZ9Qtv9k
	oRC+UWRjKNehvHtc820l2CqmSXVaw01zMHIrGYN7SEpOBS9ohzxMcW1c28rkqZla0hvvMcIhNX8
	t/WKPH2Gqh3jkmvEb/Y/r5k=
Received: from mail.maildlp.com (unknown [172.19.163.104])
	by canpmsgout05.his.huawei.com (SkyGuard) with ESMTPS id 4glX286ZGVz12LGK;
	Wed, 24 Jun 2026 14:23:44 +0800 (CST)
Received: from kwepemj100018.china.huawei.com (unknown [7.202.194.12])
	by mail.maildlp.com (Postfix) with ESMTPS id 1C86340363;
	Wed, 24 Jun 2026 14:32:32 +0800 (CST)
Received: from localhost.localdomain (10.50.163.32) by
 kwepemj100018.china.huawei.com (7.202.194.12) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.36; Wed, 24 Jun 2026 14:32:31 +0800
From: Xingui Yang <yangxingui@huawei.com>
To: <john.g.garry@oracle.com>, <yanaijie@huawei.com>, <jejb@linux.ibm.com>,
	<martin.petersen@oracle.com>
CC: <linux-scsi@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<linuxarm@huawei.com>, <liyihang9@h-partners.com>, <yangxingui@huawei.com>,
	<liuyonglong@huawei.com>, <kangfenglong@huawei.com>
Subject: [PATCH v9 2/2] scsi: libsas: Add linkrate and sas_addr change detection in rediscover
Date: Wed, 24 Jun 2026 14:32:30 +0800
Message-ID: <20260624063230.3264029-3-yangxingui@huawei.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260624063230.3264029-1-yangxingui@huawei.com>
References: <20260624063230.3264029-1-yangxingui@huawei.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: kwepems200001.china.huawei.com (7.221.188.67) To
 kwepemj100018.china.huawei.com (7.202.194.12)

Introduce sas_dev_is_flutter() and sas_rediscover_ex_phy() to improve
flutter and device replace detection during rediscovery.

sas_dev_is_flutter() calls sas_ex_phy_discover() before looking up the
child device, which ensures the PHY state is always updated and avoids
a use-after-free since the child device pointer is obtained after the
sleeping SMP request completes.

It adds validation for linkrate and sas_addr changes. When the SAS
address changes, it restores phy->attached_sas_addr back to the original
address before returning false, ensuring sas_unregister_devs_sas_addr()
can properly match and unregister the old device via
sas_phy_match_dev_addr(). The sas_addr check is ordered before the
linkrate check to ensure the address restoration is not skipped when
both change simultaneously.

sas_rediscover_ex_phy() uses the async discovery pattern
(sas_discover_event) instead of the synchronous sas_discover_new() to
ensure proper ordering between device unregistration and rediscovery,
avoiding sysfs_warn_dup() errors.

Signed-off-by: Xingui Yang <yangxingui@huawei.com>
Suggested-by: John Garry <john.g.garry@oracle.com>
---
 drivers/scsi/libsas/sas_expander.c | 83 +++++++++++++++++++++++++-----
 1 file changed, 69 insertions(+), 14 deletions(-)

diff --git a/drivers/scsi/libsas/sas_expander.c b/drivers/scsi/libsas/sas_expander.c
index fc6d8f3c9dca..e27953de2b4e 100644
--- a/drivers/scsi/libsas/sas_expander.c
+++ b/drivers/scsi/libsas/sas_expander.c
@@ -1967,6 +1967,72 @@ static bool dev_type_flutter(enum sas_device_type new, enum sas_device_type old)
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
+	res = sas_ex_phy_discover(dev, phy_id);
+	if (res)
+		return false;
+
+	child_dev = sas_ex_to_dev(dev, phy_id);
+	if (!child_dev)
+		goto out;
+
+	if (dev_is_sata(child_dev) &&
+	    phy->attached_dev_type == SAS_SATA_PENDING) {
+		action = ", needs recovery";
+		goto out;
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
+
+	if (child_dev->linkrate != phy->linkrate) {
+		pr_info("ex %016llx phy%02d linkrate changed from %d to %d\n",
+			SAS_ADDR(dev->sas_addr), phy_id,
+			child_dev->linkrate, phy->linkrate);
+		return false;
+	}
+
+out:
+	pr_debug("ex %016llx phy%02d broadcast flutter%s\n",
+		 SAS_ADDR(dev->sas_addr), phy_id, action);
+	return true;
+}
+
 static int sas_rediscover_dev(struct domain_device *dev, int phy_id,
 			      bool last, int sibling)
 {
@@ -2020,27 +2086,16 @@ static int sas_rediscover_dev(struct domain_device *dev, int phy_id,
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

