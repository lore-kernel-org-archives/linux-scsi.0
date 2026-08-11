Received: from canpmsgout04.his.huawei.com (canpmsgout04.his.huawei.com [113.46.200.219])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B44A1FF1DA;
	Tue, 11 Aug 2026 04:03:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=113.46.200.219
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786421028; cv=none; b=Ry4+ChUoQ7+/J39ICPRy7DMnR9FRuxsQktycFwLmlR8qb5DeWJSy7CuFBkRb7LFZksCZHXZIDUcg8keRPfRPMxq1BA19aAM3ULu7e0+LS36w5ubcS9d8M4R7WtlImp3ISQ/hGjtcv9i4tpDe3c3D5U7E9SC5O6JeVzGoQ/c1FPc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786421028; c=relaxed/simple;
	bh=DvHQObcs0hv0n1VAih9FuWiM3Lyat5LpF7ygcijfzPk=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=nqOSDaDsj0ZQcc4TDf67EznPgVZpiFFws4wq1TEk4x+BnszoWnuicxr3o5010/8ZVk+NL7ywVdB+JSy4nPEzJmqrs8+quIwEmEOQ3Glwwx4g6TnLSM6c/QNhR60Vp19Ysp09rdQ8LPyOjxt/fWtMemJRkEyG6qjZux312EVG2I4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=h-partners.com; dkim=pass (1024-bit key) header.d=h-partners.com header.i=@h-partners.com header.b=IhLoqcbY; arc=none smtp.client-ip=113.46.200.219
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=h-partners.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=h-partners.com header.i=@h-partners.com header.b="IhLoqcbY"
dkim-signature: v=1; a=rsa-sha256; d=h-partners.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=0HAVUN1s4FR94PgjafaL7yV/H4Fl7FZ19LvdVgBkk88=;
	b=IhLoqcbYvweTX5jXgG+GoyNuXs/XlkLOmHHOqXcJW9E0J4RHgF0ToeG2Er0LKwtkQAPqsstWS
	tfojv9yaYfa3hWR82FZxGTFGygD3tvc14l6BWuTEhbtOpouvMeorGgxiZSJCdt6EMpKsQOKC0Wf
	InJ3kR5xt2BO+Crbnpludto=
Received: from mail.maildlp.com (unknown [172.19.162.144])
	by canpmsgout04.his.huawei.com (SkyGuard) with ESMTPS id 4hJyQ23dmmz1prQt;
	Tue, 11 Aug 2026 11:52:58 +0800 (CST)
Received: from kwepemp200007.china.huawei.com (unknown [7.202.195.46])
	by mail.maildlp.com (Postfix) with ESMTPS id D54D24056D;
	Tue, 11 Aug 2026 12:03:36 +0800 (CST)
Received: from kwepemp500015.china.huawei.com (7.202.195.9) by
 kwepemp200007.china.huawei.com (7.202.195.46) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.45; Tue, 11 Aug 2026 12:03:36 +0800
Received: from localhost.localdomain (10.50.163.32) by
 kwepemp500015.china.huawei.com (7.202.195.9) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.45; Tue, 11 Aug 2026 12:03:36 +0800
From: Xingui Yang <yangxingui@huawei.com>
To: <john.g.garry@oracle.com>, <yanaijie@huawei.com>, <jejb@linux.ibm.com>,
	<martin.petersen@oracle.com>
CC: <linux-scsi@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<linuxarm@huawei.com>, <yangxingui@huawei.com>, <liuyonglong@huawei.com>,
	<kangfenglong@huawei.com>
Subject: [PATCH v10 2/2] scsi: libsas: Add linkrate and sas_addr change detection in rediscover
Date: Tue, 11 Aug 2026 12:03:34 +0800
Message-ID: <20260811040334.4184911-3-yangxingui@huawei.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260811040334.4184911-1-yangxingui@huawei.com>
References: <20260811040334.4184911-1-yangxingui@huawei.com>
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

Introduce sas_dev_is_flutter() and sas_rediscover_ex_phy() to improve
flutter and device replace detection during rediscovery.

sas_dev_is_flutter() calls sas_ex_phy_discover() before looking up the
child device via sas_ex_phy_to_dev(), ensuring the PHY state is always
updated and avoiding use-after-free since the child device pointer is
obtained after the sleeping SMP request completes.

It adds validation for linkrate and sas_addr changes. When the SAS
address changes, phy->attached_sas_addr is restored to the original
address before returning false, so sas_unregister_devs_sas_addr() can
properly match and unregister the old device. The sas_addr check is
ordered before the linkrate check to avoid skipping the restoration
when both change simultaneously.

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
index a5c5327cd0dd..811c9eb4fef1 100644
--- a/drivers/scsi/libsas/sas_expander.c
+++ b/drivers/scsi/libsas/sas_expander.c
@@ -1963,6 +1963,72 @@ static bool dev_type_flutter(enum sas_device_type new, enum sas_device_type old)
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
+	child_dev = sas_ex_phy_to_dev(dev, phy_id);
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
@@ -2016,27 +2082,16 @@ static int sas_rediscover_dev(struct domain_device *dev, int phy_id,
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

