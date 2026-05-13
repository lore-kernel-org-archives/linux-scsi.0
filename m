Received: from canpmsgout08.his.huawei.com (canpmsgout08.his.huawei.com [113.46.200.223])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 588B43EDE72;
	Wed, 13 May 2026 02:17:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=113.46.200.223
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778638638; cv=none; b=ttdue0XNonPpCnpeoRSJmYZtXvHWEjGDctXkmXyMkvtbeZAAZOkUdP6uwkLyZeA3PWDFP2X25e5Udup/9aPQX0Sui/jE5Zq78/u9kMp9IO1w731FTk1feNkHVCrYUw/8OmkXuaZK7x9VvacW+SQqcJlzocFoCwckSfALD6toeXs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778638638; c=relaxed/simple;
	bh=DNDzjMl8AcFAc3buZHjn9/7TT234oGTqAmS85EFup9w=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=m/uG6SSelX5KX22SnI09TOV1Xg6UTZdBfmdcLz7iyxzYAV1a8fs0+IhrTBrxsQG3HdrNT6WOgzrbrvsohibuoQzBA2JgSy8yC187YZpQbCrDvEqynj100OenQkgt/UEsKTgXQORD9xiF7pct8VCnqz9DlXTy5ZAyB18bKqN/nz0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=h-partners.com; dkim=pass (1024-bit key) header.d=h-partners.com header.i=@h-partners.com header.b=GGcohAte; arc=none smtp.client-ip=113.46.200.223
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=h-partners.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=h-partners.com header.i=@h-partners.com header.b="GGcohAte"
dkim-signature: v=1; a=rsa-sha256; d=h-partners.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=Vh0sJqCldgiBiQHfmOvdQJDZxxML5s029KT+v0vmHpA=;
	b=GGcohAteVGljupp1LTNm00FvJG4EiyF/3VgHZ6ii627NlmFqkoBPhge+zTZ+ZjUbBqJT/e6CC
	+bMkP2OuBurTwdtVtVJli+sRBrTeHD7oReR5jY1/kd/AEkQ3vgo5wuz0a2oh7/yE+eJN/xK7eVG
	Sm8CHrrOLdzcVpgpDzPWtC0=
Received: from mail.maildlp.com (unknown [172.19.163.163])
	by canpmsgout08.his.huawei.com (SkyGuard) with ESMTPS id 4gFcNG65kPzmV8q;
	Wed, 13 May 2026 10:09:34 +0800 (CST)
Received: from kwepemj100018.china.huawei.com (unknown [7.202.194.12])
	by mail.maildlp.com (Postfix) with ESMTPS id E58F34048B;
	Wed, 13 May 2026 10:17:12 +0800 (CST)
Received: from localhost.localdomain (10.50.163.32) by
 kwepemj100018.china.huawei.com (7.202.194.12) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.36; Wed, 13 May 2026 10:17:12 +0800
From: Xingui Yang <yangxingui@huawei.com>
To: <john.g.garry@oracle.com>, <yanaijie@huawei.com>, <jejb@linux.ibm.com>,
	<martin.petersen@oracle.com>
CC: <linux-scsi@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<linuxarm@huawei.com>, <liyihang9@h-partners.com>, <yangxingui@huawei.com>,
	<liuyonglong@huawei.com>, <kangfenglong@huawei.com>
Subject: [PATCH v2 2/3] scsi: libsas: add lldd_dev_info_update callback for device info changes
Date: Wed, 13 May 2026 10:16:02 +0800
Message-ID: <20260513021603.3023329-3-yangxingui@huawei.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260513021603.3023329-1-yangxingui@huawei.com>
References: <20260513021603.3023329-1-yangxingui@huawei.com>
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

When a device attached to an expander phy experiences a linkrate change
(e.g., due to cable reconnection or negotiation), the current code in
sas_rediscover_dev() treats it as "broadcast flutter" and takes no action
if the SAS address and device type remain unchanged.

However, for drivers like hisi_sas, the ITCT entry needs to be updated
to reflect the new linkrate. Without this update, the hardware continues
using stale linkrate information, which can cause performance issues or
protocol errors.

Introduce a new LLDD callback lldd_dev_info_update() to notify the
low-level driver when a device's information changes (such as linkrate),
allowing the driver to update its hardware structures accordingly. This
callback is designed to be extensible for future device information
updates.

Signed-off-by: Xingui Yang <yangxingui@huawei.com>
---
 drivers/scsi/libsas/sas_discover.c | 12 ++++++++++++
 drivers/scsi/libsas/sas_expander.c | 13 +++++++++++--
 drivers/scsi/libsas/sas_internal.h |  1 +
 include/scsi/libsas.h              |  1 +
 4 files changed, 25 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/libsas/sas_discover.c b/drivers/scsi/libsas/sas_discover.c
index b07062db50b2..60be59c45508 100644
--- a/drivers/scsi/libsas/sas_discover.c
+++ b/drivers/scsi/libsas/sas_discover.c
@@ -204,6 +204,18 @@ void sas_notify_lldd_dev_gone(struct domain_device *dev)
 	}
 }
 
+void sas_notify_lldd_dev_info_update(struct domain_device *dev)
+{
+	struct sas_ha_struct *sas_ha = dev->port->ha;
+	struct Scsi_Host *shost = sas_ha->shost;
+	struct sas_internal *i = to_sas_internal(shost->transportt);
+
+	if (!i->dft->lldd_dev_info_update)
+		return;
+
+	i->dft->lldd_dev_info_update(dev);
+}
+
 static void sas_probe_devices(struct asd_sas_port *port)
 {
 	struct domain_device *dev, *n;
diff --git a/drivers/scsi/libsas/sas_expander.c b/drivers/scsi/libsas/sas_expander.c
index f55ae9a979cd..11165ba585b2 100644
--- a/drivers/scsi/libsas/sas_expander.c
+++ b/drivers/scsi/libsas/sas_expander.c
@@ -2017,13 +2017,22 @@ static int sas_rediscover_dev(struct domain_device *dev, int phy_id,
 		goto out_free_resp;
 	} else if (SAS_ADDR(sas_addr) == SAS_ADDR(phy->attached_sas_addr) &&
 		   dev_type_flutter(type, phy->attached_dev_type)) {
-		struct domain_device *ata_dev = sas_ex_to_ata(dev, phy_id);
+		struct domain_device *child_dev = sas_ex_to_dev(dev, phy_id);
 		char *action = "";
 
 		sas_ex_phy_discover(dev, phy_id);
 
-		if (ata_dev && phy->attached_dev_type == SAS_SATA_PENDING)
+		if (child_dev && dev_is_sata(child_dev) &&
+		    phy->attached_dev_type == SAS_SATA_PENDING) {
 			action = ", needs recovery";
+		} else if (child_dev && child_dev->linkrate != phy->linkrate) {
+			pr_debug("ex %016llx phy%02d linkrate changed: %d -> %d\n",
+				 SAS_ADDR(dev->sas_addr), phy_id,
+				 child_dev->linkrate, phy->linkrate);
+			child_dev->linkrate = phy->linkrate;
+			sas_notify_lldd_dev_info_update(child_dev);
+		}
+
 		pr_debug("ex %016llx phy%02d broadcast flutter%s\n",
 			 SAS_ADDR(dev->sas_addr), phy_id, action);
 		goto out_free_resp;
diff --git a/drivers/scsi/libsas/sas_internal.h b/drivers/scsi/libsas/sas_internal.h
index 350a70484bde..9ee37b8abd78 100644
--- a/drivers/scsi/libsas/sas_internal.h
+++ b/drivers/scsi/libsas/sas_internal.h
@@ -82,6 +82,7 @@ bool sas_queue_work(struct sas_ha_struct *ha, struct sas_work *sw);
 
 int sas_notify_lldd_dev_found(struct domain_device *);
 void sas_notify_lldd_dev_gone(struct domain_device *);
+void sas_notify_lldd_dev_info_update(struct domain_device *dev);
 
 void sas_smp_handler(struct bsg_job *job, struct Scsi_Host *shost,
 		struct sas_rphy *rphy);
diff --git a/include/scsi/libsas.h b/include/scsi/libsas.h
index 163f23c92b41..973b4445b7e0 100644
--- a/include/scsi/libsas.h
+++ b/include/scsi/libsas.h
@@ -674,6 +674,7 @@ struct sas_domain_function_template {
 	/* GPIO support */
 	int (*lldd_write_gpio)(struct sas_ha_struct *, u8 reg_type,
 			       u8 reg_index, u8 reg_count, u8 *write_data);
+	void (*lldd_dev_info_update)(struct domain_device *dev);
 };
 
 extern int sas_register_ha(struct sas_ha_struct *);
-- 
2.43.0

