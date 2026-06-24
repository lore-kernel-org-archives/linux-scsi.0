Received: from canpmsgout03.his.huawei.com (canpmsgout03.his.huawei.com [113.46.200.218])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47A7024113D;
	Wed, 24 Jun 2026 06:32:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=113.46.200.218
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782282758; cv=none; b=aumEOh81SbtYSo9yzImZctoPcuArOT2GtEeUBYP6+tsJ7owv1zXYCI2qTBHEqbp+hq4r+Ya5Cw75qb+E/c/D20Ny4vaWkBeqD3csphoNadtkDg0kUIY6V8+bHGyPNk8PT8v3xjhDeeTDji4XpBf91TbODuSJcMQet7C9xZYOFtA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782282758; c=relaxed/simple;
	bh=QuitcDszOAMeNm8T1DutrMTMsn2rlUIEBb4lgj4nTWY=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=J05N1/3U2j0xfdqbwff0rOjGV52b8KdEjl2VYF/2yDJvA9RbypqQB/gnYVsYaFZHDFWEeMIRpjDn7PdlSBiSuR2y9s5N+pVlGW8Y8DvRHhL7o0vNuD5yAq+HyqRuCd81aoFT2f5wxIsaWMTWOPeAoBq0kEJaMHJWehX3QLYpdb0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=h-partners.com; dkim=pass (1024-bit key) header.d=h-partners.com header.i=@h-partners.com header.b=PCNmWgAo; arc=none smtp.client-ip=113.46.200.218
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=h-partners.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=h-partners.com header.i=@h-partners.com header.b="PCNmWgAo"
dkim-signature: v=1; a=rsa-sha256; d=h-partners.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=VB1uYr9RM9bqeWDEhcpSTVw/qbylOy5SxDegX8AXifQ=;
	b=PCNmWgAoOwpoFnx3uKD/WogPosLofNXvu2v7lMTbTpBdVszGl+2qr+3kTJDarZfKDX7MryMju
	i0GvGx7B3amo16RWrnOdp5aLMFI3Pc8IgpzEKzvIw6tXc31nY6l9wYQ1k0UCUQYmY21OiN3UTAJ
	nAeCWfoZ4ck7GU/oop3c34s=
Received: from mail.maildlp.com (unknown [172.19.162.197])
	by canpmsgout03.his.huawei.com (SkyGuard) with ESMTPS id 4glX2m2z6pzpT0m;
	Wed, 24 Jun 2026 14:24:16 +0800 (CST)
Received: from kwepemj100018.china.huawei.com (unknown [7.202.194.12])
	by mail.maildlp.com (Postfix) with ESMTPS id A598940576;
	Wed, 24 Jun 2026 14:32:31 +0800 (CST)
Received: from localhost.localdomain (10.50.163.32) by
 kwepemj100018.china.huawei.com (7.202.194.12) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.36; Wed, 24 Jun 2026 14:32:30 +0800
From: Xingui Yang <yangxingui@huawei.com>
To: <john.g.garry@oracle.com>, <yanaijie@huawei.com>, <jejb@linux.ibm.com>,
	<martin.petersen@oracle.com>
CC: <linux-scsi@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<linuxarm@huawei.com>, <liyihang9@h-partners.com>, <yangxingui@huawei.com>,
	<liuyonglong@huawei.com>, <kangfenglong@huawei.com>
Subject: [PATCH v9 1/2] scsi: libsas: refactor sas_ex_to_ata() using new helper sas_ex_to_dev()
Date: Wed, 24 Jun 2026 14:32:29 +0800
Message-ID: <20260624063230.3264029-2-yangxingui@huawei.com>
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

Introduce sas_ex_to_dev() to return any device type attached to an
expander phy. The new helper is then used by sas_ex_to_ata() to reduce
code duplication.

Also add a defensive NULL check for ex_dev to guard against callers
passing a NULL device.

Signed-off-by: Xingui Yang <yangxingui@huawei.com>
---
 drivers/scsi/libsas/sas_expander.c | 19 ++++++++++++++-----
 drivers/scsi/libsas/sas_internal.h |  1 +
 2 files changed, 15 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/libsas/sas_expander.c b/drivers/scsi/libsas/sas_expander.c
index f471ab464a78..fc6d8f3c9dca 100644
--- a/drivers/scsi/libsas/sas_expander.c
+++ b/drivers/scsi/libsas/sas_expander.c
@@ -345,13 +345,16 @@ static void sas_set_ex_phy(struct domain_device *dev, int phy_id,
 		 SAS_ADDR(phy->attached_sas_addr), type);
 }
 
-/* check if we have an existing attached ata device on this expander phy */
-struct domain_device *sas_ex_to_ata(struct domain_device *ex_dev, int phy_id)
+/* return the domain device attached to an expander phy */
+struct domain_device *sas_ex_to_dev(struct domain_device *ex_dev, int phy_id)
 {
-	struct ex_phy *ex_phy = &ex_dev->ex_dev.ex_phy[phy_id];
-	struct domain_device *dev;
+	struct ex_phy *ex_phy;
 	struct sas_rphy *rphy;
 
+	if (!ex_dev)
+		return NULL;
+
+	ex_phy = &ex_dev->ex_dev.ex_phy[phy_id];
 	if (!ex_phy->port)
 		return NULL;
 
@@ -359,7 +362,13 @@ struct domain_device *sas_ex_to_ata(struct domain_device *ex_dev, int phy_id)
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

