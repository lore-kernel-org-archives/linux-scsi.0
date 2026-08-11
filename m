Received: from canpmsgout12.his.huawei.com (canpmsgout12.his.huawei.com [113.46.200.227])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78ED71A6830;
	Tue, 11 Aug 2026 04:03:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=113.46.200.227
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786421028; cv=none; b=gqOUNmeXojY5r1Jjgn2RjX+nbGa9TGD/qGiMol9ARk52bdQ3cXKBW3MXnSZi9eCGYlvrpzOvq+AM4lW3wXQdtPCth0EoJuYHTk53UMa6O6Sjp/fYpMj6AaCcDjLIaBU6tWBuersd5ho4RBJrweR7KYAynlea3iXITJycZQbz/vI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786421028; c=relaxed/simple;
	bh=Jxg4XBwbZEnUa/eUMmus2koZ451j/BrYYnOrdim2I+I=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Dmrh3ZGWNnvMEDu00FeT887AfTA72yhX8ggaL0xm34JRcy3etODr0BQgaMSR7ko680fsdT1IQWTTgtjTHbgjGvmZvT3Yn76ZuwI/u1z1bXq7IOvlCxgezpoT0+NtkGoDuym0t+gzDMB44p0N3v3er295VQolc0yKn1ETUIbW+pA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=h-partners.com; dkim=pass (1024-bit key) header.d=h-partners.com header.i=@h-partners.com header.b=jPPErVPK; arc=none smtp.client-ip=113.46.200.227
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=h-partners.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=h-partners.com header.i=@h-partners.com header.b="jPPErVPK"
dkim-signature: v=1; a=rsa-sha256; d=h-partners.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=Wrlal8m5Pic7Ct45yV3qVRVX54yjjTgu9lXVfjjxdiQ=;
	b=jPPErVPKqSS9RKSqhuF4uvctZG1EmKK6fNv3XRevoBkQX/IabkEmy/8ByrdOvBwbtRLP7xz1t
	NjPywW3h9eg0K+QTrhgGZXOBM0m9XRS5Ixwb1P12I2v6IMijxbShqUB+C0NLVo1Umeiy5Cz+fMq
	y8dp81DZUAcStG4i1x/6LiI=
Received: from mail.maildlp.com (unknown [172.19.163.15])
	by canpmsgout12.his.huawei.com (SkyGuard) with ESMTPS id 4hJyQK1bM6znTbJ;
	Tue, 11 Aug 2026 11:53:13 +0800 (CST)
Received: from kwepemp200008.china.huawei.com (unknown [7.202.195.107])
	by mail.maildlp.com (Postfix) with ESMTPS id 649C340586;
	Tue, 11 Aug 2026 12:03:36 +0800 (CST)
Received: from kwepemp500015.china.huawei.com (7.202.195.9) by
 kwepemp200008.china.huawei.com (7.202.195.107) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.45; Tue, 11 Aug 2026 12:03:36 +0800
Received: from localhost.localdomain (10.50.163.32) by
 kwepemp500015.china.huawei.com (7.202.195.9) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.45; Tue, 11 Aug 2026 12:03:35 +0800
From: Xingui Yang <yangxingui@huawei.com>
To: <john.g.garry@oracle.com>, <yanaijie@huawei.com>, <jejb@linux.ibm.com>,
	<martin.petersen@oracle.com>
CC: <linux-scsi@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<linuxarm@huawei.com>, <yangxingui@huawei.com>, <liuyonglong@huawei.com>,
	<kangfenglong@huawei.com>
Subject: [PATCH v10 1/2] scsi: libsas: Add sas_ex_phy_to_dev() helper
Date: Tue, 11 Aug 2026 12:03:33 +0800
Message-ID: <20260811040334.4184911-2-yangxingui@huawei.com>
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

Add sas_ex_phy_to_dev() to return any device type attached to an
expander phy, and refactor sas_ex_to_ata() to use it.

No functional changes intended.

Signed-off-by: Xingui Yang <yangxingui@huawei.com>
---
 drivers/scsi/libsas/sas_expander.c | 13 +++++++++----
 drivers/scsi/libsas/sas_internal.h |  1 +
 2 files changed, 10 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/libsas/sas_expander.c b/drivers/scsi/libsas/sas_expander.c
index f471ab464a78..a5c5327cd0dd 100644
--- a/drivers/scsi/libsas/sas_expander.c
+++ b/drivers/scsi/libsas/sas_expander.c
@@ -345,11 +345,10 @@ static void sas_set_ex_phy(struct domain_device *dev, int phy_id,
 		 SAS_ADDR(phy->attached_sas_addr), type);
 }
 
-/* check if we have an existing attached ata device on this expander phy */
-struct domain_device *sas_ex_to_ata(struct domain_device *ex_dev, int phy_id)
+/* Return the domain device attached to an expander phy */
+struct domain_device *sas_ex_phy_to_dev(struct domain_device *ex_dev, int phy_id)
 {
 	struct ex_phy *ex_phy = &ex_dev->ex_dev.ex_phy[phy_id];
-	struct domain_device *dev;
 	struct sas_rphy *rphy;
 
 	if (!ex_phy->port)
@@ -359,7 +358,13 @@ struct domain_device *sas_ex_to_ata(struct domain_device *ex_dev, int phy_id)
 	if (!rphy)
 		return NULL;
 
-	dev = sas_find_dev_by_rphy(rphy);
+	return sas_find_dev_by_rphy(rphy);
+}
+
+/* Check if we have an existing attached ata device on this expander phy */
+struct domain_device *sas_ex_to_ata(struct domain_device *ex_dev, int phy_id)
+{
+	struct domain_device *dev = sas_ex_phy_to_dev(ex_dev, phy_id);
 
 	if (dev && dev_is_sata(dev))
 		return dev;
diff --git a/drivers/scsi/libsas/sas_internal.h b/drivers/scsi/libsas/sas_internal.h
index 7dce0f587149..f5c75ab10dc4 100644
--- a/drivers/scsi/libsas/sas_internal.h
+++ b/drivers/scsi/libsas/sas_internal.h
@@ -91,6 +91,7 @@ int sas_smp_get_phy_events(struct sas_phy *phy);
 
 void sas_device_set_phy(struct domain_device *dev, struct sas_port *port);
 struct domain_device *sas_find_dev_by_rphy(struct sas_rphy *rphy);
+struct domain_device *sas_ex_phy_to_dev(struct domain_device *ex_dev, int phy_id);
 struct domain_device *sas_ex_to_ata(struct domain_device *ex_dev, int phy_id);
 int sas_ex_phy_discover(struct domain_device *dev, int single);
 int sas_get_report_phy_sata(struct domain_device *dev, int phy_id,
-- 
2.43.0

