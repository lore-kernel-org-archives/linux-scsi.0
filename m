Received: from canpmsgout08.his.huawei.com (canpmsgout08.his.huawei.com [113.46.200.223])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C86842048;
	Sat, 25 Apr 2026 06:52:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=113.46.200.223
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777099951; cv=none; b=VlIQnMzhW/UiCKH3t8jJ5ho9Ou8m7RcWLY6AT8QgOxSu1CeSmI1/x29RPq+DxKqGMnQx7aIwLmkon4PB0qxXzztR3JsCzz9en3C/knIHJOCM+Yf9O3i+ZOqzQcQTRpBV9EUG5oWGt/oEw8evHdSNpLmAjtyTaUIjD/uTxAb+/Ko=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777099951; c=relaxed/simple;
	bh=Z0/R4si3m0KsGY8iqzq4WrXBhTH00RKirdAaWaJD1JY=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=ODmw4P8ztkWSwEcOITnh/y5K5HBKsn98+NgsQiY7sZBBVeqYNwMujjjVwA2Dm+z7dEueULuL1rzxly1Wh/IVmyF9ocFZHDIsrkobGMjtlJVh/hndgYzr+yIyFYSlV/zziAdA+q/Zp1Llu9YxeapUVvXCk7zRlU9/7R2szDz+6zI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=h-partners.com; dkim=pass (1024-bit key) header.d=h-partners.com header.i=@h-partners.com header.b=o+mTjfZj; arc=none smtp.client-ip=113.46.200.223
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=h-partners.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=h-partners.com header.i=@h-partners.com header.b="o+mTjfZj"
dkim-signature: v=1; a=rsa-sha256; d=h-partners.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=yl5b3+0xlS1xJi+qRBkprVJDn5eb/BZx2zd32w4xeSE=;
	b=o+mTjfZjuDKfggS0lTKQa5ptHKPIxOKr99Rue/XV+w5A+/ujB2m/nczufKEbA9MRuA9ZR+GYn
	wcCrRIoi7/NczkvU9BMDH9sJKlGgHAAwn/1WuTlZmayHwoG7St9YiYbpJ5Xh403cx6msN+p9F/y
	afnqezhiSLON6y4zdCfR9OU=
Received: from mail.maildlp.com (unknown [172.19.163.163])
	by canpmsgout08.his.huawei.com (SkyGuard) with ESMTPS id 4g2gMP2QgqzmV6X;
	Sat, 25 Apr 2026 14:45:53 +0800 (CST)
Received: from kwepemh200005.china.huawei.com (unknown [7.202.181.112])
	by mail.maildlp.com (Postfix) with ESMTPS id 339234056E;
	Sat, 25 Apr 2026 14:52:19 +0800 (CST)
Received: from localhost.localdomain (10.50.163.32) by
 kwepemh200005.china.huawei.com (7.202.181.112) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Sat, 25 Apr 2026 14:52:18 +0800
From: Yihang Li <liyihang9@huawei.com>
To: <martin.petersen@oracle.com>, <James.Bottomley@HansenPartnership.com>
CC: <linux-scsi@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<linuxarm@huawei.com>, <liyihang9@h-partners.com>, <liuyonglong@huawei.com>,
	<prime.zeng@hisilicon.com>
Subject: [PATCH] scsi: hisi_sas: Add slave_destroy interface for v3 hw
Date: Sat, 25 Apr 2026 14:52:18 +0800
Message-ID: <20260425065218.2655578-1-liyihang9@huawei.com>
X-Mailer: git-send-email 2.33.0
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: kwepems500002.china.huawei.com (7.221.188.17) To
 kwepemh200005.china.huawei.com (7.202.181.112)

WARNING is triggered when executing link reset of remote PHY
and rmmod SAS driver simultaneously. Following is the WARNING log:

WARNING: CPU: 61 PID: 21818 at drivers/base/core.c:1347 __device_links_no_driver+0xb4/0xc0
 Call trace:
  __device_links_no_driver+0xb4/0xc0
  device_links_driver_cleanup+0xb0/0xfc
  __device_release_driver+0x198/0x23c
  device_release_driver+0x38/0x50
  bus_remove_device+0x130/0x140
  device_del+0x184/0x434
  __scsi_remove_device+0x118/0x150
  scsi_remove_target+0x1bc/0x240
  sas_rphy_remove+0x90/0x94
  sas_rphy_delete+0x24/0x3c
  sas_destruct_devices+0x64/0xa0 [libsas]
  sas_revalidate_domain+0xe4/0x150 [libsas]
  process_one_work+0x1e0/0x46c
  worker_thread+0x15c/0x464
  kthread+0x160/0x170
  ret_from_fork+0x10/0x20
 ---[ end trace 71e059eb58f85d4a ]---

During SAS phy up, link->status is set to DL_STATE_AVAILABLE in
device_links_driver_bound, then this setting influences
__device_links_no_driver() before driver rmmod and caused WARNING.

So we add the slave_destroy interface, to make sure link is removed
after flush workque.

Fixes: 16fd4a7c59170 ("scsi: hisi_sas: Add device link between SCSI devices and hisi_hba")
Signed-off-by: Yihang Li <liyihang9@huawei.com>
---
 drivers/scsi/hisi_sas/hisi_sas_v3_hw.c | 12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c b/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
index fda07b193137..f04edcdec66c 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
@@ -2977,7 +2977,7 @@ static int sdev_configure_v3_hw(struct scsi_device *sdev,
 		return 0;
 
 	if (!device_link_add(&sdev->sdev_gendev, dev,
-			     DL_FLAG_PM_RUNTIME | DL_FLAG_RPM_ACTIVE)) {
+			     DL_FLAG_STATELESS | DL_FLAG_PM_RUNTIME | DL_FLAG_RPM_ACTIVE)) {
 		if (pm_runtime_enabled(dev)) {
 			dev_info(dev, "add device link failed, disable runtime PM for the host\n");
 			pm_runtime_disable(dev);
@@ -2987,6 +2987,15 @@ static int sdev_configure_v3_hw(struct scsi_device *sdev,
 	return 0;
 }
 
+static void slave_destroy_v3_hw(struct scsi_device *sdev)
+{
+	struct Scsi_Host *shost = dev_to_shost(&sdev->sdev_gendev);
+	struct hisi_hba *hisi_hba = shost_priv(shost);
+	struct device *dev = hisi_hba->dev;
+
+	device_link_remove(&sdev->sdev_gendev, dev);
+}
+
 static struct attribute *host_v3_hw_attrs[] = {
 	&dev_attr_phy_event_threshold.attr,
 	&dev_attr_intr_conv_v3_hw.attr,
@@ -3401,6 +3410,7 @@ static const struct scsi_host_template sht_v3_hw = {
 	.sg_tablesize		= HISI_SAS_SGE_PAGE_CNT,
 	.sg_prot_tablesize	= HISI_SAS_SGE_PAGE_CNT,
 	.sdev_init		= hisi_sas_sdev_init,
+	.slave_destroy		= slave_destroy_v3_hw,
 	.shost_groups		= host_v3_hw_groups,
 	.sdev_groups		= sdev_groups_v3_hw,
 	.tag_alloc_policy_rr	= true,
-- 
2.33.0

