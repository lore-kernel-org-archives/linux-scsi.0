Received: from canpmsgout03.his.huawei.com (canpmsgout03.his.huawei.com [113.46.200.218])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 602522FFDD8;
	Tue,  2 Dec 2025 06:56:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=113.46.200.218
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764658594; cv=none; b=TrWMyzcVIJ6kwNihx4WtLMH6N+gWN4Xf8th7FZQpnW3CMrkCWVs8U0CsBLMvE+DpuYwBtppZh/DOio2zn76b6XY0ZJNi/c9oXrUhmNdg9U9voje178LUS8h5qcslhgMzhtv6aU92PZgbkeFfXQxOD82ZtTOY//LaxKu6P4Q4ZYI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764658594; c=relaxed/simple;
	bh=m1Te0q+4H3v4ZG0a3YAAAFAgCP4oBn6XzwNvR6bXp0U=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=LkkR50OJyBqjVo88U1GLc/wi3/7ztLlbStbzBZMXXOHuaNebFWUDh0lOdhrpVKkOYE9AWIZ65R4PqB5iDfkDFlg4lc3wt/j/IzWrTz27wMTdqVLwm/lQ1oK//jYrAyotLWzZmnKRk+BedTIl8Tq6oIbxlL5GBySbBKI4/XObS34=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=h-partners.com; dkim=pass (1024-bit key) header.d=h-partners.com header.i=@h-partners.com header.b=MDLCs1OT; arc=none smtp.client-ip=113.46.200.218
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=h-partners.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=h-partners.com header.i=@h-partners.com header.b="MDLCs1OT"
dkim-signature: v=1; a=rsa-sha256; d=h-partners.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=gqJyVj140xSUbQzLDN9i0O9WFSrezFv6O1fAd38S6dg=;
	b=MDLCs1OTVNrtyr95x4Gwk81UZ5LLML6x6/FpVuKdYPJo7wFvPb9VqykSyW2dJH9SGEtsmK/Jk
	7wBUB9I8Xo5OexihgJa2PSfGCqYKRPE7VmR6tRvRVAyCxopEQUwhIY4+6XaaItTYFkB7f9oKcJl
	7gxYUhKhx/URT7T7s1J2h54=
Received: from mail.maildlp.com (unknown [172.19.162.254])
	by canpmsgout03.his.huawei.com (SkyGuard) with ESMTPS id 4dLBMR3BD4zpSy3;
	Tue,  2 Dec 2025 14:54:11 +0800 (CST)
Received: from kwepemj100018.china.huawei.com (unknown [7.202.194.12])
	by mail.maildlp.com (Postfix) with ESMTPS id E447A1804F7;
	Tue,  2 Dec 2025 14:56:28 +0800 (CST)
Received: from localhost.huawei.com (10.90.31.46) by
 kwepemj100018.china.huawei.com (7.202.194.12) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Tue, 2 Dec 2025 14:56:28 +0800
From: Xingui Yang <yangxingui@huawei.com>
To: <john.g.garry@oracle.com>, <yanaijie@huawei.com>, <jejb@linux.ibm.com>,
	<martin.petersen@oracle.com>
CC: <linux-scsi@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<linuxarm@huawei.com>, <liyihang9@h-partners.com>, <yangxingui@huawei.com>,
	<liuyonglong@huawei.com>, <kangfenglong@huawei.com>
Subject: [PATCH v2] Revert "scsi: libsas: Fix exp-attached device scan after probe failure scanned in again after probe failed"
Date: Tue, 2 Dec 2025 14:56:27 +0800
Message-ID: <20251202065627.140361-1-yangxingui@huawei.com>
X-Mailer: git-send-email 2.33.0
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

This reverts commit ab2068a6fb84751836a84c26ca72b3beb349619d.

When probing the exp-attached sata device, libsas/libata will issue a hard
reset in sas_probe_sata() -> ata_sas_async_probe(), then a broadcast event
will be received after the disk probe fails, and this commit causes the
probe will be re-executed on the disk, and a faulty disk may get into an
indefinite loop of probe.

Therefore, revert this commit, although it can fix some temporary issues
with disk probe failure.

Signed-off-by: Xingui Yang <yangxingui@huawei.com>
Reviewed-by: Jason Yan <yanaijie@huawei.com>
---
Changs to v1:
- Update commit message
---
 drivers/scsi/libsas/sas_internal.h | 14 --------------
 1 file changed, 14 deletions(-)

diff --git a/drivers/scsi/libsas/sas_internal.h b/drivers/scsi/libsas/sas_internal.h
index 6706f2be8d27..da5408c701cd 100644
--- a/drivers/scsi/libsas/sas_internal.h
+++ b/drivers/scsi/libsas/sas_internal.h
@@ -145,20 +145,6 @@ static inline void sas_fail_probe(struct domain_device *dev, const char *func, i
 		func, dev->parent ? "exp-attached" :
 		"direct-attached",
 		SAS_ADDR(dev->sas_addr), err);
-
-	/*
-	 * If the device probe failed, the expander phy attached address
-	 * needs to be reset so that the phy will not be treated as flutter
-	 * in the next revalidation
-	 */
-	if (dev->parent && !dev_is_expander(dev->dev_type)) {
-		struct sas_phy *phy = dev->phy;
-		struct domain_device *parent = dev->parent;
-		struct ex_phy *ex_phy = &parent->ex_dev.ex_phy[phy->number];
-
-		memset(ex_phy->attached_sas_addr, 0, SAS_ADDR_SIZE);
-	}
-
 	sas_unregister_dev(dev->port, dev);
 }
 
-- 
2.33.0

