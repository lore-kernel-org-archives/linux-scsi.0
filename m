Received: from canpmsgout10.his.huawei.com (canpmsgout10.his.huawei.com [113.46.200.225])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E85227FD7D;
	Tue, 21 Oct 2025 07:34:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=113.46.200.225
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761032091; cv=none; b=C1xfr64Qg+sHCJxVSnuvgwbrXwomQDYM5ri1sEWZlXb+rwDOGFvMcH5Nwa5+zwASE1s0qRXGR9971g35gkQ6U3AnJXcbUm9Az8tdH/uxtMNlfV3KD2fvCsa8lSaAMCdzQ3T303V9swZXB1yeDuk/CPfh32OfxdHaOy1Zyr7j5Js=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761032091; c=relaxed/simple;
	bh=hC5tvKb13w9Pzr2Uh3ekORCYcLYXBgnL/lruhyAesrw=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=I6/gcu8eCgeywzOD17SQs3CXoHtJ84JiNlmW7DcqJdIMdC+L/r0nrFiV4p+IKidMX9vfh7MOkiiTc9jrsFTPTemZ1ty03vD+0fysbMxMSZK5Ir3jKoHjF+JIjLmoI3+CxDpOkK06xvgn9h/KLAhhDZeKlT5eNdvcp+zAgwYWl2Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=h-partners.com; dkim=pass (1024-bit key) header.d=h-partners.com header.i=@h-partners.com header.b=eNo5ym2N; arc=none smtp.client-ip=113.46.200.225
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=h-partners.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=h-partners.com header.i=@h-partners.com header.b="eNo5ym2N"
dkim-signature: v=1; a=rsa-sha256; d=h-partners.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=6esKAayHAT9WjDVN0yl0ek5qzPVL6tQl6OyfEkc/dgw=;
	b=eNo5ym2N2Ijmr8f3YXwIH7T5aqaFjTEHnzqYGxktYwSOFsgEOszwQfIhqFYzQ4vsQNeXuaVy0
	+qupDOAukPNwMmrXtsdbtkDHFcTca7WDz08G39a0rdiO5cES7ao0kZBNPC3ZcJY1AgKqRAwGf21
	TdSoYCqXEKHBYHENRTMnR+A=
Received: from mail.maildlp.com (unknown [172.19.88.214])
	by canpmsgout10.his.huawei.com (SkyGuard) with ESMTPS id 4crPF42sCrz1K96c;
	Tue, 21 Oct 2025 15:34:16 +0800 (CST)
Received: from kwepemj100018.china.huawei.com (unknown [7.202.194.12])
	by mail.maildlp.com (Postfix) with ESMTPS id 9A0C51A016C;
	Tue, 21 Oct 2025 15:34:39 +0800 (CST)
Received: from localhost.huawei.com (10.90.31.46) by
 kwepemj100018.china.huawei.com (7.202.194.12) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Tue, 21 Oct 2025 15:34:38 +0800
From: Xingui Yang <yangxingui@huawei.com>
To: <john.g.garry@oracle.com>, <yanaijie@huawei.com>, <jejb@linux.ibm.com>,
	<martin.petersen@oracle.com>
CC: <linux-scsi@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<linuxarm@huawei.com>, <liyihang9@h-partners.com>, <yangxingui@huawei.com>,
	<liuyonglong@huawei.com>, <kangfenglong@huawei.com>
Subject: [PATCH] Revert "scsi: libsas: Fix exp-attached device scan after probe failure scanned in again after probe failed"
Date: Tue, 21 Oct 2025 15:34:38 +0800
Message-ID: <20251021073438.3441934-1-yangxingui@huawei.com>
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

As the disk may fall into an abnormal loop of probe when it fails to probe
due to physical reasons and cannot be repaired.

Signed-off-by: Xingui Yang <yangxingui@huawei.com>
---
 drivers/scsi/libsas/sas_internal.h | 14 --------------
 1 file changed, 14 deletions(-)

diff --git a/drivers/scsi/libsas/sas_internal.h b/drivers/scsi/libsas/sas_internal.h
index 03d6ec1eb970..85948963fb97 100644
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

