Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD0ED1F76A8;
	Thu, 20 Feb 2025 13:05:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.187
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740056754; cv=none; b=YuMiOiDcBc+9jNgNs5Uv2BQuCy6dKsdj7laE/30XLVJaWnqzGOpdxvFJpgL5RywccIQ+PPliWNPnbupmo7/RYx7h6zJRw3FPiIHtL6DOZU56YTshbR1osydYJRDN8ntDiXHTOrYXw808d+7uDJujFRb1EAVZiTAHueiBTUrRSPE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740056754; c=relaxed/simple;
	bh=ce7JpSmh+cZ7Mm95zXhiso5i9tGqOvLl69DFZqF6HTo=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Z1YA15l+wMx71ZXMJELhmkbtdpy3fMPje7Caqjbeh8PeaLlUzNjsc26GadbmQ6dZV0w5h+iaclBLXVnRtDbJlVj4w10vsq8xZG85KpM+DOWPkaYhPdUTAHJPuqI164utLONcOFWrTQ1SWf0LGh/aFvHEgwaQQp0WtT+Tdnewcao=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.187
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.163.174])
	by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4YzD1W1H91zkXGv;
	Thu, 20 Feb 2025 21:02:07 +0800 (CST)
Received: from kwepemg100017.china.huawei.com (unknown [7.202.181.58])
	by mail.maildlp.com (Postfix) with ESMTPS id 002B31402E0;
	Thu, 20 Feb 2025 21:05:49 +0800 (CST)
Received: from localhost.huawei.com (10.90.30.45) by
 kwepemg100017.china.huawei.com (7.202.181.58) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Thu, 20 Feb 2025 21:05:48 +0800
From: Xingui Yang <yangxingui@huawei.com>
To: <john.garry@huawei.com>, <liyihang9@huawei.com>, <yanaijie@huawei.com>
CC: <jejb@linux.ibm.com>, <martin.petersen@oracle.com>,
	<linux-scsi@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<linuxarm@huawei.com>, <prime.zeng@huawei.com>, <yangxingui@huawei.com>,
	<liuyonglong@huawei.com>, <kangfenglong@huawei.com>,
	<liyangyang20@huawei.com>, <f.fangjian@huawei.com>,
	<xiabing14@h-partners.com>
Subject: [PATCH v3 2/3] scsi: libsas: Move sas_put_device() to libsas.h
Date: Thu, 20 Feb 2025 21:05:45 +0800
Message-ID: <20250220130546.2289555-3-yangxingui@huawei.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20250220130546.2289555-1-yangxingui@huawei.com>
References: <20250220130546.2289555-1-yangxingui@huawei.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
 kwepemg100017.china.huawei.com (7.202.181.58)

As sas_put_device() needs to be called in lldd, it is now moved to libsas.h

Signed-off-by: Xingui Yang <yangxingui@huawei.com>
---
 drivers/scsi/libsas/sas_discover.c | 1 +
 drivers/scsi/libsas/sas_internal.h | 6 ------
 include/scsi/libsas.h              | 6 ++++++
 3 files changed, 7 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/libsas/sas_discover.c b/drivers/scsi/libsas/sas_discover.c
index 951bdc554a10..43a65d0542ab 100644
--- a/drivers/scsi/libsas/sas_discover.c
+++ b/drivers/scsi/libsas/sas_discover.c
@@ -309,6 +309,7 @@ void sas_free_device(struct kref *kref)
 
 	kfree(dev);
 }
+EXPORT_SYMBOL_GPL(sas_free_device);
 
 static void sas_unregister_common_dev(struct asd_sas_port *port, struct domain_device *dev)
 {
diff --git a/drivers/scsi/libsas/sas_internal.h b/drivers/scsi/libsas/sas_internal.h
index 03d6ec1eb970..a1e364deb3ee 100644
--- a/drivers/scsi/libsas/sas_internal.h
+++ b/drivers/scsi/libsas/sas_internal.h
@@ -98,7 +98,6 @@ int sas_get_phy_attached_dev(struct domain_device *dev, int phy_id,
 			     u8 *sas_addr, enum sas_device_type *type);
 int sas_try_ata_reset(struct asd_sas_phy *phy);
 
-void sas_free_device(struct kref *kref);
 void sas_destruct_devices(struct asd_sas_port *port);
 
 extern const work_func_t sas_phy_event_fns[PHY_NUM_EVENTS];
@@ -217,9 +216,4 @@ static inline struct domain_device *sas_alloc_device(void)
 	return dev;
 }
 
-static inline void sas_put_device(struct domain_device *dev)
-{
-	kref_put(&dev->kref, sas_free_device);
-}
-
 #endif /* _SAS_INTERNAL_H_ */
diff --git a/include/scsi/libsas.h b/include/scsi/libsas.h
index ba460b6c0374..f67137f50980 100644
--- a/include/scsi/libsas.h
+++ b/include/scsi/libsas.h
@@ -425,6 +425,12 @@ static inline void sas_put_local_phy(struct sas_phy *phy)
 	put_device(&phy->dev);
 }
 
+void sas_free_device(struct kref *kref);
+static inline void sas_put_device(struct domain_device *dev)
+{
+	kref_put(&dev->kref, sas_free_device);
+}
+
 #ifdef CONFIG_SCSI_SAS_HOST_SMP
 int try_test_sas_gpio_gp_bit(unsigned int od, u8 *data, u8 index, u8 count);
 #else
-- 
2.33.0

