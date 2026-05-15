Received: from canpmsgout01.his.huawei.com (canpmsgout01.his.huawei.com [113.46.200.216])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4E61402B9D;
	Fri, 15 May 2026 08:46:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=113.46.200.216
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778834814; cv=none; b=Hdxlnp5OznXU1Jzi1cdbRWGwhgRSnVcL/Zb1feMFM1ASifB94KFHS3DRf66c4fykJqV+R+EKCHGTMh0I6uTj66GjqKJgwfz6vV9PfC00WEsltrCpdXquNg4OwOZtY6MDKAMWJW44xnK5ahvf5IMa82vwM1zf32+p1aBaIEcoRCU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778834814; c=relaxed/simple;
	bh=44bMr9vMwLBH5sexDb/BcNfLJA1lU8kjZ7FJCctfKY0=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=PS38W+5ta5UdJJ/PInlkPZDAaskgeqk0t2pv/r1kuCWVjNigxnl+miNAJotz0qTo6E2EoAfd/wX5foZ8jMfjVFtMn/gz9/BzDhQXe6tu/9TbzaED5AQqGrxzJI0E3eHiGE32/kEd5tcakiA2oM3NTPKI4pKIRZFIu0awWWJwT0I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=h-partners.com; dkim=pass (1024-bit key) header.d=h-partners.com header.i=@h-partners.com header.b=CQheUaBb; arc=none smtp.client-ip=113.46.200.216
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=h-partners.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=h-partners.com header.i=@h-partners.com header.b="CQheUaBb"
dkim-signature: v=1; a=rsa-sha256; d=h-partners.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=zV32QZJOSJYAu2D1qI9F4LgllhyokyX48eMdek8/kDU=;
	b=CQheUaBbozWoho1lmjqIg+zPwfXw2wlFie02osXzy5Sk5+kk8L54szC426eXSgPFNY/QgiOpO
	UY5hqi3NTcbwpTaz8RAwTfrGjCWnErjegS8KjPOek3DVrhammYsIYaKRV9zUl0+rcMCZ5bxl9v2
	kxt5TlxfPRSLwZ4M/HFZ3zs=
Received: from mail.maildlp.com (unknown [172.19.162.140])
	by canpmsgout01.his.huawei.com (SkyGuard) with ESMTPS id 4gH0wh0snmz1T4MM;
	Fri, 15 May 2026 16:39:00 +0800 (CST)
Received: from kwepemj100018.china.huawei.com (unknown [7.202.194.12])
	by mail.maildlp.com (Postfix) with ESMTPS id 4507E202E6;
	Fri, 15 May 2026 16:46:44 +0800 (CST)
Received: from localhost.localdomain (10.50.163.32) by
 kwepemj100018.china.huawei.com (7.202.194.12) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.36; Fri, 15 May 2026 16:46:43 +0800
From: Xingui Yang <yangxingui@huawei.com>
To: <john.g.garry@oracle.com>, <yanaijie@huawei.com>, <jejb@linux.ibm.com>,
	<martin.petersen@oracle.com>
CC: <linux-scsi@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<linuxarm@huawei.com>, <liyihang9@h-partners.com>, <yangxingui@huawei.com>,
	<liuyonglong@huawei.com>, <kangfenglong@huawei.com>
Subject: [PATCH v3 2/2] scsi: libsas: Add linkrate and sas_addr change detection in rediscover
Date: Fri, 15 May 2026 16:45:31 +0800
Message-ID: <20260515084531.866259-3-yangxingui@huawei.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260515084531.866259-1-yangxingui@huawei.com>
References: <20260515084531.866259-1-yangxingui@huawei.com>
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

Add validation checks after sas_ex_phy_discover() to detect linkrate and
sas_addr changes. When changes are detected, mark the device as gone and
schedule rediscovery via libsas's async discovery pattern:
- Set phy_change_count and ex_change_count to -1 to force revalidation
- Unregister the device and schedule DISCE_REVALIDATE_DOMAIN event
- The old device is destroyed by sas_destruct_devices()
- New event triggers discovery via sas_discover_new() since
  attached_sas_addr is cleared

Suggested-by: John Garry <john.g.garry@oracle.com>
Signed-off-by: Xingui Yang <yangxingui@huawei.com>
---
 drivers/scsi/libsas/sas_expander.c | 32 ++++++++++++++++++++++++++----
 1 file changed, 28 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/libsas/sas_expander.c b/drivers/scsi/libsas/sas_expander.c
index f55ae9a979cd..720db4128727 100644
--- a/drivers/scsi/libsas/sas_expander.c
+++ b/drivers/scsi/libsas/sas_expander.c
@@ -2017,15 +2017,39 @@ static int sas_rediscover_dev(struct domain_device *dev, int phy_id,
 		goto out_free_resp;
 	} else if (SAS_ADDR(sas_addr) == SAS_ADDR(phy->attached_sas_addr) &&
 		   dev_type_flutter(type, phy->attached_dev_type)) {
-		struct domain_device *ata_dev = sas_ex_to_ata(dev, phy_id);
+		struct domain_device *child_dev = sas_ex_to_dev(dev, phy_id);
+		bool need_rediscover = false;
 		char *action = "";
 
 		sas_ex_phy_discover(dev, phy_id);
 
-		if (ata_dev && phy->attached_dev_type == SAS_SATA_PENDING)
+		if (child_dev && dev_is_sata(child_dev) &&
+		    phy->attached_dev_type == SAS_SATA_PENDING) {
 			action = ", needs recovery";
-		pr_debug("ex %016llx phy%02d broadcast flutter%s\n",
-			 SAS_ADDR(dev->sas_addr), phy_id, action);
+		} else if (child_dev && phy->linkrate != child_dev->linkrate) {
+			pr_info("ex %016llx phy%02d linkrate changed from %d to %d\n",
+				SAS_ADDR(dev->sas_addr), phy_id,
+				child_dev->linkrate, phy->linkrate);
+			need_rediscover = true;
+		} else if (child_dev &&
+			   SAS_ADDR(child_dev->sas_addr) != SAS_ADDR(phy->attached_sas_addr)) {
+			pr_info("ex %016llx phy%02d sas_addr changed from %016llx to %016llx\n",
+				SAS_ADDR(dev->sas_addr), phy_id,
+				SAS_ADDR(child_dev->sas_addr),
+				SAS_ADDR(phy->attached_sas_addr));
+			need_rediscover = true;
+		}
+
+		if (need_rediscover) {
+			set_bit(SAS_DEV_GONE, &child_dev->state);
+			phy->phy_change_count = -1;
+			ex->ex_change_count = -1;
+			sas_unregister_devs_sas_addr(dev, phy_id, true);
+			sas_discover_event(dev->port, DISCE_REVALIDATE_DOMAIN);
+		} else {
+			pr_debug("ex %016llx phy%02d broadcast flutter%s\n",
+				 SAS_ADDR(dev->sas_addr), phy_id, action);
+		}
 		goto out_free_resp;
 	}
 
-- 
2.43.0

